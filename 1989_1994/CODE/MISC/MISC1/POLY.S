NB_PTS=4
PAS=3
NB_POS=360/PAS
	TEXT
DEBUT:	MOVEA.L  A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L 	$14(A5),D0
	ADD.L 	$1C(A5),D0
	ADD.L 	#$100,D0		
	MOVE.L 	D0,-(SP)		
	MOVE.L 	A5,-(SP)
	MOVE 	#0,-(SP)
	MOVE 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP
	
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	MOVE.L 	D0,SAUVE

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
	LEA	DATA_X,A1
	
;	MOVE	#45*2,x_angle
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
	ADD	#2*PAS,z_angle
	dbf	d7,ici

	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2
			
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	MOVE.B	$FFFFFA15.W,MFP7
	MOVE.B	$FFFFFA17.W,MFP8
	MOVE.B	$FFFFFA19.W,MFP9
	MOVE.B	$FFFFFA1F.W,MFP10


	MOVE.L	$68.W,SAUVE_HBL
	MOVE.L	$134.W,SAUVE_TMA
	MOVE.L	#INTER_RTE,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	
	MOVE	#4,-(SP)
	TRAP 	#14
	ADDQ.L	#2,SP
	MOVE	D0,RES
	
	MOVE	#2,-(SP)
	TRAP 	#14
	ADDQ.L 	#2,SP
	MOVE.L	D0,ANC_ECR
	
	CLR.W 	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
        
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBL_IR,$70.W
	MOVE.L	$120.W,ANC_TB
	MOVE.L	#TB0_IR,$120.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	JMP	BOUCLE

FIN:	
	MOVE	#$2700,SR
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	MOVE.B	MFP7,$FFFFFA15.W
	MOVE.B	MFP8,$FFFFFA17.W
	MOVE.B	MFP9,$FFFFFA19.W
	MOVE.B	MFP10,$FFFFFA1F.W
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	SAUVE_TMA,$134.W
	MOVE.L	SAUVE_HBL,$68.W

	MOVE	#$2300,SR


	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	#2,$FFFF820A.W
	
	MOVE.W 	RES,-(SP)
	MOVE.L	ANC_ECR,-(SP)
	MOVE.L	ANC_ECR,-(SP)
	MOVE.W 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP
	
	MOVE.L	SAUVE,-(SP)
	MOVE.W 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	

	CLR.W 	-(SP)
	TRAP	#1
	
VBL_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

;	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
;	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
;	MOVE.B	#4,$FFFFFA19.W
;	BCLR	#3,$FFFFFA17.W
;	MOVE.L	#INTER_TMA,$134.W
;	ORI.B	#$20,$FFFFFA13.W
;	ORI.B	#$20,$FFFFFA07.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	efecr
	ST	$FFFF8240.W
efecr	
	movea.l	SCREEN1,a0
	LEA	160*60(A0),A0
	
	moveq	#1,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	sub.l	a1,a1
	sub.l	a2,a2
	sub.l	a3,a3
	sub.l	a4,a4
	sub.l	a5,a5
	sub.l	a6,a6
	MOVE.L	#1,A6
efecr1	
N	SET	48
	REPT	70
	movem.l	d0-d7/a1-a6,N(a0)
N	SET	N+160
	ENDR


	JSR	poly

	SF	$FFFF8240.W
	
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
INTER_RTE	RTE

INTER_TMA:	CLR.B	$FFFFFA07.W		; ARRET DU MFP POUR NE PAS
	CLR.B	$FFFFFA09.W		; ETRE GENE
	MOVE	#$2100,SR		; ON AUTORISE LA HBL

	MOVE.L	A6,USP
	
full
	MOVE.L	#$FFFF8209,A6
	MOVE.L	#$FFFF8260,A4
	MOVE.L	#$FFFF820A,A3

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100		; ATTENTE DE LA PROCHAINE HBL
				; (FIXE A 16 CYCLES PRES ENVIRONS)
	MOVE	#$2700,SR		; ON COUPE TOUTE LES ITs
	MOVE	#$2300,(SP)		; AU RETOUR LE VBL SERA AUTORISEE

	MOVEQ	#29,D2		; ON ATTEND LE BON MOMENT
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D0,(A3)		; ET HOP! PLUS DE BORDER HAUT
	REPT	6
	NOP
	ENDR
	MOVE.B	D1,(A3)

	RTE
	
TB0_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB0_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE	

TB1_IR
     REPT 127
	NOP			
     ENDR
	MOVE.B	#0,$FFFF820A.W	
     REPT 8
     	NOP			
     ENDR
	MOVE.B	#2,$FFFF820A.W	
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB0_IR,$120	
	BCLR	#0,$FFFFFA0F.W	
	RTE			

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
	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
	move.w (a6)+,d2	;d2=ze
	ADD.L	#6,POINTEUR
	
;	lea depla,a3
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
;	LEA	DATA_Y,A2
;	LEA	DATA_X,A1
	MOVE	xp,(A1)+
	MOVE	yp,(A1)+
	RTS
	
	*-----sous programe------*	
*************************************
*poly	(c) zerioul		*	
*************************************
np	equ	4
poly:
	lea.l	DATA_X,a0
	lea.l	tposym(pc),a1
	lea.l	(a1),a2
	lea.l	(a2),a3
	move.w	(a2)+,d4
	move.w	2(a0,d4.w),d3
	
	move.w	#np-2,d0
tinfpl1
	move.w	d0,d1
tinfpl2
	move.w	(a2)+,d2
	cmp.w	2(a0,d2.w),d3
	ble.s	tinvrai
	move.w	d4,-2(a2)
	move.w	d2,(a3)
	move.w	2(a0,d2.w),d3
tinvrai	
	dbra.w	d1,tinfpl2
	addq.l	#2,a3
	move.w	(a3),d4
	move.w	2(a0,d4.w),d3
	lea.l	2(a3),a2
	dbra.w	d0,tinfpl1
	
	move.w	(a0),d7
	move.w	(a0),d6
	lea.l	2(a0),a2

	move.w	#np-2,d0
btextrem	
	cmp.w	(a2),d7
	ble.s	splusptn
	move.w	(a2),d7
splusptn
	cmp.w	(a2),d6
	bge.s	splugrn
	move.w	(a2),d6
splugrn
	addq.l	#4,a2
	dbra.w	d0,btextrem	
	
	add.w	d6,d7
	lsr.w	d7
	
	move.w	(a1),d5
	move.w	(a1)+,d6
	lea.l	tdroit,a5
	lea.l	tgauch,a2
	lea.l	calc(pc),a4		*pas touch a4

calcd	macro
	
	move.w	(a1)+,d4
	cmp.w	(a0,d4.w),d7
	bge.s	caldr\@1
	move.w	(a0,d5.w),d0
	move.w	2(a0,d5.w),d1
	move.w	(a0,d4.w),d2
	move.w	2(a0,d4.w),d3
	move.w	d4,d5
	lea.l	(a5),a3
	bsr	calcord	
	lea.l	(a3),a5
	bra.s	fincalc\@1
caldr\@1	
	move.w	(a0,d6.w),d0
	move.w	2(a0,d6.w),d1
	move.w	(a0,d4.w),d2
	move.w	2(a0,d4.w),d3
	move.w	d4,d6
	lea.l	(a2),a3
	bsr	calcord	
	lea.l	(a3),a2
fincalc\@1	
	endm


n	set	0
	rept	np-2
	calcd	n
n	set	n+1
	endr
	
	move.w	(a1)+,d4
	move.w	(a0,d5.w),d0
	move.w	2(a0,d5.w),d1
	move.w	(a0,d4.w),d2
	move.w	2(a0,d4.w),d3
	move.w	d4,d5
	lea.l	(a5),a3
	bsr	calcord	
	
	move.w	(a0,d6.w),d0
	move.w	2(a0,d6.w),d1
	move.w	(a0,d5.w),d2
	move.w	2(a0,d5.w),d3
	move.w	d4,d6
	lea.l	(a2),a3
	bsr	calcord	
	
				*peut touch	a4
**************************************
	
	move.l	SCREEN2,a0
	
codmpyin	
	lea.l	DATA_X,a3
	lea.l	tposym(pc),a2
	move.w	(a2),d1
	move.w	2(a3,d1.w),d1
	move.w	d1,d0
	lea.l	p_t_ord(pc),a1		
	add.w	d0,d0
	add.w	(a1,d0.w),a0 	*add ydeb	
	move.w	#np-1,d6
	add.w	d6,d6
	move.w	(a2,d6.w),d6
	move.w	2(a3,d6.w),d6
	sub.w	d1,d6
	subq.l	#1,d6
	
	lea.l	tgauch,a1	
	lea.l	p_t_left(pc),a2	
	lea.l	p_t_right(pc),a3	
	
	move.w	#$ffff,d7
	
	move.w	#$f0,$ffff8240.W

	
bouclaff 	
	move.w	(a1)+,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a2,d0.w),d0
	
	move.w	tdroit-tgauch-2(a1),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a3,d1.w),d1
	
	lea.l	(a0,d0.w),a4	*add xdeb
	sub.w	d0,d1
	jmp	tdrempvd(pc,d1.w)	
*********************************************
tdrempvd
	bra.w	pdaffpa1
	dc.l	0
	bra.w	pdaffpa2
	dc.l	0
	bra.w	pdaffpa3	
	dc.l	0
	bra.w	pdaffpa4
	dc.l	0
	bra.w	pdaffpa5
	dc.l	0
	bra.w	pdaffpa6
	dc.l	0
	bra.w	pdaffpa7
	dc.l	0
	bra.w	pdaffpa8
	dc.l	0
	bra.w	pdaffpa9
	dc.l	0
	bra.w	pdaffpa10
	dc.l	0
	bra.w	pdaffpa11
	dc.l	0
	bra.w	pdaffpa12
	dc.l	0
	bra.w	pdaffpa13
	dc.l	0
	bra.w	pdaffpa14
	dc.l	0
	bra.w	pdaffpa15
	dc.l	0
	bra.w	pdaffpa16
	dc.l	0
	bra.w	pdaffpa17
	dc.l	0
	bra.w	pdaffpa18
	dc.l	0
	bra.w	pdaffpa19
	dc.l	0
	bra.w	pdaffpa20

pdaffpa1
	swap	d0
	swap	d1
	and.w	d0,d1
	or.w	d1,(a4)	
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa2
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa3
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa4
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	2
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 
	rts
pdaffpa5
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	3
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 
	rts
pdaffpa6
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	4
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa7
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	5
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa8
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	6
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa9
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	7
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa10
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	8
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa11
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	9
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa12
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	10
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa13
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	11
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa14
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	12
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa15
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	13
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa16

	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	14
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa17
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	15
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa18
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	16
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa19
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	17
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa20
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	18
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts


*********************************************
calcord	
	
	moveq.l	#0,d4
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ext.l	d4
	ASL.W	#7,D4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#9,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4

	sub.w	#0,d4
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts
			
	DATA

t_points	
	dc.w	0,100 	*coord plan des points
	dc.w	160,0	*pas de sens trigo 
	dc.w	160,199
	dc.w	319,100
	
tposym	dc.w	0,4,8,12	*pos des points dans tab

p_t_left
n	set	0
          	rept	20
            dc.w    %1111111111111111,n
            dc.w    %0111111111111111,n
            dc.w    %0011111111111111,n
            dc.w    %0001111111111111,n
            dc.w    %0000111111111111,n
            dc.w    %0000011111111111,n
            dc.w    %0000001111111111,n
            dc.w    %0000000111111111,n
            dc.w    %0000000011111111,n
            dc.w    %0000000001111111,n
            dc.w    %0000000000111111,n
            dc.w    %0000000000011111,n
            dc.w    %0000000000001111,n
            dc.w    %0000000000000111,n
            dc.w    %0000000000000011,n
            dc.w    %0000000000000001,n
n	set	n+8
	endr

p_t_right
n	set	0
            rept	20
            dc.w    %1000000000000000,n
            dc.w    %1100000000000000,n
            dc.w    %1110000000000000,n
            dc.w    %1111000000000000,n
            dc.w    %1111100000000000,n
            dc.w    %1111110000000000,n
            dc.w    %1111111000000000,n
            dc.w    %1111111100000000,n
            dc.w    %1111111110000000,n
            dc.w    %1111111111000000,n
            dc.w    %1111111111100000,n
            dc.w    %1111111111110000,n
            dc.w    %1111111111111000,n
            dc.w    %1111111111111100,n
            dc.w    %1111111111111110,n
            dc.w    %1111111111111111,n
n	set	n+8
	endr
	
p_t_ord
n	set	0
	rept	200
	dc.w	n
n	set	n+160
	endr	


cos_tab	incbin 'COSIN.DAT'	;tables sinus cosinus
sin_tab	equ cos_tab+720

points	
	
COORD	
	dc.w	-40,40,0 	*coord plan des points
	dc.w	-40,-40,0	*pas de sens trigo 
	dc.w	40,40,0
	dc.w	40,-40,0
	
 	BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SAUVE	DS.L	1	
ANC_VBL	DS.L	1	
ANC_TB	DS.L	1	
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
ANC_ECR	DS.L	1	
SCREEN1	DS.L	1
SCREEN2	DS.L	1
RES	DS.W	1	
ANC_PAL	DS.W	16
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
MFP7	DS.B	1
MFP8	DS.B	1
MFP9	DS.B	1
MFP10	DS.B	1
	DS.B	256
BUFFER	DS.B	32000*2
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
	DS	NB_POS*NB_PTS
DATA_Y
	DS	NB_POS*NB_PTS


CNT	DS.L	1
CNT2	DS.L	1
tdroit	ds.w	800
tgauch	ds.w	800

ZA	DS	1
PNT	DS.L	1
stimb	ds.l	1
point	;ds.l	20
