NB_PTS=121
NB_POS=50

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	CLR.L	PPNNTT
		
	LEA	DATA_Y,A2
	LEA	DATA_X,A1
	
;	MOVE	#16*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	
	move	#256,z_pt_fuite

	move.l	#NB_POS-1,d7
ici	CLR.L	POINTEUR
	jsr	trigo
	rept	NB_PTS
	jsr	sp_to_pl
	jsr	ROUTINE
	endr
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	ADD.L	#484,PPNNTT
	dbf	d7,ici



	CLR	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE	#5,-(SP)
	TRAP	#14
	ADDA.L	#12,SP


	JMP	PROG
	
	clr.l	-(sp)
	trap	#1


trigo	movem.l d0-d7/a4-a6,-(a7)

	lea cos_tab,a4	;a4 pointe table cos
	lea sin_tab,a5	;a5 pointe table sin

	lea x_angle,a6
	move.w (a6)+,d2	;d2=x_angle
	move.w (a6)+,d1	;d1=y_angle
	move.w (a6)+,d0	;d0=z_angle
	
	move.w 0(a5,d2.w),d5	;d5=sin_x
	move.w 0(a4,d2.w),d4	;d4=cos_x
	move.w 0(a5,d1.w),d3	;d3=sin_y
	move.w 0(a4,d1.w),d2	;d2=cos_y
	move.w 0(a5,d0.w),d1	;d1=sin_z
	move.w 0(a4,d0.w),d0	;d0=cos_z

	lea var_3d,a6	;a6 pointe la zone
			;qui contiendra les
			;calculs 
			;intermediaires

	moveq #9,d7		;d7 contient le nombre 
			;de decalages a faire	
			;pour diviser par 512
			
	;****** calcul de C *****
	
sp_c	move.w d3,d6	;sin_y*512
	neg.w d6		;inverse signe
	move.w d6,(a6)+	;-sin_y*512
	
	;****** calcul de F *****
	
sp_f	move.w d2,d6	;cos_y*512 
	muls d5,d6		;cos_y*512*sin_x*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_y*sin_x*512
	
	;****** calcul de I *****
	
sp_i	move.w d2,d6	;cos_y*512
	muls d4,d6		;cos_y*512*cos_x*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_y*cos_x*512

	;****** calcul de A *****	

sp_a	move.w d0,d6	;cos_z*512
	muls d2,d6		;cos_z*512*cos_y*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_z*cos_y*512

	;****** calcul de D *****

sp_d	move.w d1,d6	;sin_z*512
	muls d4,d6		;sin_z*512*cos_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke resultat
			;dans a4

	move.w d0,d6	;cos_z*512
	muls d3,d6		;cos_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d5,d6		;cos_z*sin_y*512
			;     *sin_x*512
	asr.l d7,d6		;divise par 512
	sub.w a4,d6		;soustrait resultat
			;stock‚ dans a4
	move.w d6,(a6)+	

	;****** calcul de G *****

sp_g	move.w d1,d6	;sin_z*512
	muls d5,d6		;sin_z*512*sin_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4

	move.w d0,d6	;cos_z*512
	muls d3,d6		;cos_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d4,d6		;cos_z*sin_y*512
			;     *cos_x*512
	asr.l d7,d6		;divise par 512
	add.w a4,d6		;ajoute resultat
			;stock‚ dans a4
	move.w d6,(a6)+	

	;****** calcul de B *****
	
sp_b	move.w d1,d6	;sin_z*512
	muls d2,d6		;sin_z*512*cos_y*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;sin_z*cos_y*512

	;****** calcul de E *****
	
sp_e	move.w d0,d6	;cos_z*512
	muls d4,d6		;cos_z*512*cos_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4
	
	move.w d1,d6	;sin_z*512
	muls d3,d6		;sin_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d5,d6		;sin_z*sin_y*512
			;     *sin_x*512
	asr.l d7,d6		;divise par 512
	add.w a4,d6		;ajoute resultat
			;stock‚ dans a4
	move.w d6,(a6)+	
	
	;****** calcul de H *****

sp_h	move.w d0,d6	;cos_z*512
	muls d5,d6		;cos_z*512*sin_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4
	
	move.w d1,d6	;sin_z*512
	muls d3,d6		;sin_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d4,d6		;sin_z*sin_y*512
			;     *cos_x*512
	asr.l d7,d6		;divise par 512
	sub.w a4,d6		;soustrait resultat
			;stock‚ dans a4
	move.w d6,(a6)+	
	
	movem.l (a7)+,d0-d7/a4-a6
	rts

;********************************************
; calcul des coordonnees planes             *
; en entree: xe,ye,ze                       *
;            x_angle,y_angle,z_angle        *
;            z_pt_fuite z du point de fuite *
; en sortie: xp,yp coordonn‚es planes       *
;            new_xe,new_ye,new_ze nouvelles *
;            coordonn‚es spatiales          *
;********************************************

sp_to_pl movem.l d0-d7/a1-a6,-(a7)
	
	lea points,a6		;a6 pointe coords
	ADDA.L	POINTEUR,A6
	ADDA.L	PPNNTT,A6
	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
	SUB	#160,D0
	SUB	#100,D1
;	move.w (a6)+,d2	;d2=ze
	MOVEQ	#0,D2
	ADD.L	#4,POINTEUR
	
	lea depla,a3
;	move.w (a3)+,d3	;xdep
;	move.w (a3)+,d4	;ydep
;	move.w (a3)+,d5	;zdep
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	ext.l d3
	ext.l d4
	ext.l d5
	moveq #9,d6
	asl.l d6,d3 	;xdep*512
	asl.l d6,d4		;ydep*512
	asl.l d6,d5		;zdep*512
	movea.l d3,a1	
	movea.l d4,a2
	movea.l d5,a3
	
	lea var_3d,a6	;pointe zone de
			;calcul 
			;intermediaire

	move.w d0,d3	;d3=xe
	move.w d1,d4	;d4=ye
	move.w d2,d5	;d5=ze

	muls (a6)+,d3	;d3=c*xe*512
	muls (a6)+,d4	;d4=f*ye*512
	muls (a6)+,d5	;d5=i*ze*512
	add.l d4,d5		; + f*ye*512
	add.l d3,d5		; + c*xe*512
	add.l a3,d5		; + zdep*512
	move.l d5,a5	;a5=new_ze*512
	divs z_pt_fuite,d5	;d5=new_ze/z_pt_fuite

	move.w #512,d7
	sub.w d5,d7		;d7=512*q
			;d7=512*
			;(1-new_ze/z_pt_fuite)
	
	move.w d0,d3	;d3=xe
	move.w d1,d4	;d4=ye	
	move.w d2,d5	;d5=ze
		
	muls (a6)+,d3	;d3=a*xe*512
	muls (a6)+,d4	;d4=d*ye*512
	muls (a6)+,d5	;d5=g*ze*512
	add.l d4,d5		;+ a*xe*512
	add.l d3,d5		;+ d*xe*512
	add.l a1,d5		;+ xdep*512
	move.l d5,a4	;a4=new_xe*512
	divs d7,d5		;d5.w=
			;(new_xe*512)/(q*512)
			;d5=new_xe/q
	
	muls (a6)+,d0	;d0=b*xe*512
	muls (a6)+,d1	;d1=e*ye*512
	muls (a6)+,d2	;d2=h*ze*512
	add.l d0,d1		; + b*xe*512
	add.l d1,d2		; + e*ye*512
	add.l a2,d2		; + ydep*512
	move.l d2,d6	;d6=new_ye*512
	divs d7,d2		;d2.w=new_ye/q
	
	lea xp,a6		;a6 pointe zone
			;sauvergarde coords
			;plane qu'on
			;centre … l'‚cran

	add.w #160,d5	;d5=xp+160
	move.w d5,(a6)+	;xp
	
	add.w #100,d2	;d2=yp+100
	move.w d2,(a6)+	;yp

	move.l a4,d5	;new_xe*512
	move.l a5,d7	;new_ze*512
	moveq #9,d0
	asr.l d0,d5		;new_xe
	asr.l d0,d6		;new_ye
	asr.l d0,d7		;new_ze
			
			;sauve nouvelles 
			;coords spatiales
	move.w d5,(a6)+	;new_xe
	move.w d6,(a6)+	;new_ye
	move.w d7,(a6)+	;new_ze
	MOVE	D7,ZA	
	movem.l (a7)+,d0-d7/a1-a6
	rts

ROUTINE
	CLR.L	D0
	CLR.L	D1
	CLR.L	D2
	MOVE	xp,D0
	MOVE	yp,d1
	MULU	#160,D1
	DIVS	#16,D0
	MOVE	D0,D2
	MULU	#8,D2
	ADD.L	D2,D1
	SWAP	D0
	CMPI	#$7,D0
	BGT.S	PLUS_UN
	BRA.S	PLUS_LOIN
PLUS_UN	ADD.L	#1,D1
	SUB.L	#8,D0
PLUS_LOIN
	LEA	KK,A0
	MULU	#8,D0
	JSR	0(A0,D0.W)

	CMPI	#0,ZA
	BGT.S	PLD
	BRA.S	NOPLD
PLD	ADD	#2,D1
NOPLD	MOVE	D1,(A2)+
	RTS


KK	MOVE.B	#%10000000,(A1)+
	NOP
	RTS
	MOVE.B	#%01000000,(A1)+
	NOP
	RTS
	MOVE.B	#%00100000,(A1)+
	NOP
	RTS	
	MOVE.B	#%00010000,(A1)+
	NOP
	RTS	
	MOVE.B	#%00001000,(A1)+
	NOP
	RTS	
	MOVE.B	#%00000100,(A1)+
	NOP
	RTS
	MOVE.B	#%00000010,(A1)+
	NOP
	RTS
	MOVE.B	#%00000001,(A1)+
	NOP
	RTS

PROG:

	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP



	CLR	$FFFF8240.W
	MOVE	#$444,$FFFF8242.W
	MOVE	#$666,$FFFF8244.W
	
	CLR.L	CNT
	MOVE.L	#NB_POS-2,CNT2
		
	LEA	DATA_X,A0
	LEA	DATA_Y,A1
	LEA	DATA_Y+(NB_PTS*(NB_POS-2)*2),A3
	LEA	$F8000,A2
	

	
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBL,$70.W
	
LOOP	JMP	LOOP

VBL	
	cmpi.b	#$3b,$fffffc02.w
		beq	poi

	LEA	$F8000,A2
	ADDQ.L	#1,CNT2
	
	CMPI.L	#NB_POS,CNT		* ESSAYER 63 !!
	BNE.S	L

	LEA	DATA_X,A0
	LEA	DATA_Y,A1
	clr.l	CNT
L
	CMPI.L	#NB_POS,CNT2
	BNE.S	L2

	LEA	DATA_Y,A3
	CLR.L	CNT2
L2
	ADDQ.L	#1,CNT

	MOVEQ	#0,D0
	
	REPT	NB_PTS
	MOVE	(A3)+,D1
	MOVE.B	D0,0(A2,D1.W)
	ENDR

	REPT	NB_PTS
	MOVE.B	(A0)+,D0
	MOVE	(A1)+,D1
	OR.B	D0,0(A2,D1.W)
	ENDR
poi


	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	RTE
	
FIN	MOVE.L	ANC_VBL,$70.W

	CLR	$FFFF8242.W
	MOVE	#$777,$FFFF8240.W


	CLR.L	-(SP)
	TRAP	#1
	
	section data

cos_tab	incbin COSIN.DAT
sin_tab	equ cos_tab+720

points	
	INCBIN	FLAG.DAT
	
depla	dc	0,0,0

	section bss

xe	ds.w 1		;coordonnees spatiales
ye	ds.w 1
ze	ds.w 1

xdep	ds.w 1		;d‚placements
ydep	ds.w 1
zdep	ds.w 1

xp	ds.w 1		;coordonnees planes
yp	ds.w 1

new_xe	ds.w 1		;nouvelles coords 
new_ye	ds.w 1		;aprŠs rotation
new_ze	ds.w 1

x_angle	ds.w 1		;angles de rotation
y_angle	ds.w 1
z_angle	ds.w 1	

z_pt_fuite	ds.w 1		;coordonn‚es z du 
			;du point de fuite

var_3d	ds.w 9                  ;tableau pour calculs
POINTEUR	DS.L	1

DATA_X
	DS.B	NB_POS*NB_PTS
DATA_Y
	DS	NB_POS*NB_PTS


ANC_VBL	DS.L	1

CNT	DS.L	1
CNT2	DS.L	1
PPNNTT	DS.L	1
ZA	DS	1