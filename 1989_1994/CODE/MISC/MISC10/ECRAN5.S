
NB_PTS=104
PAS=2
NB_POS=360/PAS


 	SECTION TEXT
DEBUT:	MOVE.L  A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L 	$14(A5),D0
	ADD.L 	$1C(A5),D0
	ADD.L 	#$100,D0		
	MOVE.L 	D0,-(SP)		
        MOVE.L 	A5,-(SP)
	MOVE.W 	#0,-(SP)
	MOVE.W 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP




	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
	LEA	DATA_X,A1
	
;	MOVE	#16*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	
	move	#256,z_pt_fuite

	move.l	#NB_POS-1,d7
ici	CLR.L	POINTEUR
	jsr	trigo
	ADD.L	#2,POINTEUR2
	rept	NB_PTS
	jsr	sp_to_pl
	jsr	ROUTINE
	endr
	ADD	#2*PAS,x_angle
	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	dbf	d7,ici







	
	CLR.L 	-(SP)
	MOVE.W 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	MOVE.L 	D0,SAUVE
	
	MOVEQ	#1,D0
	JSR	ZIK


	LEA	IMAGE,A0
	JSR	decrunch


	CLR.L	POINT
	MOVE.L	#PALETTE2,POINTA6
	MOVE.L	#PALETTE2,POINTA4


	LEA	FADING,A0
	MOVE.L	A0,SAVEA0

        
	;MOVE.L #MES_F3,MES_PNT3


	MOVE.L	#$0,X_VALUE
	MOVE.L	#160,Y_VALUE



	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
			
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	
	CLR.B	$FFFFFA07.W	* A VIRER POUR LA ZIK D'HOTLINE
	CLR.B	$FFFFFA09.W	* 
	
	JSR	SET_SCR



	MOVE.L	SCREEN1,A2
	ADDA.L	#320+(230*40),A2
	MOVE.L	SCREEN2,A1
	ADDA.L	#320+(230*40),A1

	LEA	DATA+34,A0
	ADDA.L	#(160*40),A0
	MOVE.L	#1199,D0
M	MOVE.L	(A0),(A1)+
	MOVE.L	(A0)+,(A2)+
	DBF	D0,M


;	MOVE.L	SCREEN1,A2
;	ADDA.L	#160+(230*40)+160+(160*30)+(230*33)+160+(160*62)+(160*15),A2
;	MOVE.L	SCREEN2,A1
;	ADDA.L	#160+(230*40)+160+(160*30)+(230*33)+160+(160*62)+(160*15),A1

;	LEA	MANGA+34,A0
;	MOVE.L	#2759,D0	*2989
;M3	MOVE.L	(A0),(A1)+
;	MOVE.L	(A0)+,(A2)+
;	DBF	D0,M3


;	MOVE.L	SCREEN1,A2
;	ADDA.L	#160+(230*40)+160+(160*30)+(230*33)+160+(160*15),A2
;	MOVE.L	SCREEN2,A1
;	ADDA.L	#160+(230*40)+160+(160*30)+(230*33)+160+(160*15),A1


;	LEA	DATA+34,A0
;	ADDA.L	#160*(40+30+32),A0
;	MOVE.L	#(40*62)-1,D0
;M2	MOVE.L	(A0),(A1)+
;	MOVE.L	(A0)+,(A2)+
;	DBF	D0,M2

	CLR.L	PLUS
	MOVE.L	#39,LIGNES

	MOVE.L	#15,D3

O       MOVEA.L #DATA+34,A4
        JSR PREDECALE

        MOVEA.L #DATA+34,A0
	LEA	BUFFER1,A1
	ADDA.L	PLUS,A1

	MOVE.L	#39,D1
P	MOVE.L	#23,D0
L	MOVE.L	(A0)+,(A1)+
	DBF	D0,L
	LEA	64(A0),A0	* 64=160-96
	DBF	D1,P
		
	MOVE.L	PLUS,D4
	ADD.L	#3840,D4
	MOVE.L	D4,PLUS

	DBF	D3,O


	



;	MOVE.L	#BUFFERL,D0
;	ANDI.L	#$FFFFFF00,D0
;	ADD.L	#512,D0
;	MOVE.L	D0,ADRLOGO
	
	MOVE.W	#4,-(SP)
	TRAP 	#14
	ADDQ.L	#2,SP
	MOVE.W	D0,RES
	
	MOVE.W	#2,-(SP)
	TRAP 	#14
	ADDQ.L 	#2,SP
	MOVE.L	D0,ANC_ECR
	
	MOVE.W 	#0,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP

	LEA.L	$FFFF8240.W,A0
	MOVEM.L	(A0),D0-D7
	LEA.L	ANC_PAL,A0
	MOVEM.L	D0-D7,(A0)
	


	lea	TEXTE,a0	
	move.l	a0,MEM_LET	
	move.w	#0,PART_AFF	
        
;        move.l ADRFONT,a3
;        lea  FONT+34,a5
;        JSR  decomp
	
	MOVE.L #MES_F,MES_PNT

;        MOVE.W  #120,POIROT1
;	MOVE.W  #0,POIROT2

 ;	MOVEQ	#1,D0
;	JSR	MUSIC
;	MOVE.W  #1,MUS


	CLR.L	CNT
	MOVE.L	#NB_POS-2,CNT2
		
	LEA	DATA_X,A0
	LEA	DATA_Y,A1
	LEA	DATA_Y+(NB_PTS*(NB_POS-2)*2),A3
	MOVEA.L	SCREEN,A2
	
	MOVEM.L	A0-A3,SAVERD


	
	MOVE.L	$70,ANC_VBL
	MOVE.L	#VBL_IR,$70
	MOVE.L	$120,ANC_TB
	MOVE.L	#TB0_IR,$120
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W


BOUCLE	JMP BOUCLE


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
	ADD	#30,D2
	ADD.L	#6,POINTEUR
	
	lea depla,a3
	adda.l	POINTEUR2,A3
	move.w (a3)+,d5	;zdep
	move.w #0,d3	;xdep
	move.w #0,d4	;ydep
	LEA	DEPLA2,A3
	ADDA.L	POINTEUR2,A3
	MOVE	(A3)+,D3
	MOVE	#-180,D5

		
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

	add.w #230,d5	;d5=xp+160
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
	CLR.L	D0
	CLR.L	D1
	CLR.L	D2
	MOVE	xp,D0
	MOVE	yp,d1

	CMPI	#200,D1
	BGT.S	CLIPPING
	BRA.S	NO_CLIP
CLIPPING	
	CLR	D1
	CLR	D0
NO_CLIP	CMPI	#0,D1
	BLE.S	OUT
	BRA.S	TOUTOK
OUT	CLR	D1
	CLR	D0	
TOUTOK	
	CMPI	#459,D0
	BGT.S	GRR
	BRA.S	PASGRR
GRR	CLR	D0
	CLR	D1	
PASGRR	CMPI	#0,D0
	BLE.S	HJK
	BRA.S	ENFIN
HJK	CLR	D0
	CLR	D1
ENFIN	MULU	#230,D1
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

	CMPI	#110,ZA
	BGT.S	PLD
	BRA.S	NOPLD
PLD	ADD	#2,D1
NOPLD	
	SUB.L	#23000,D1
	MOVE	D1,(A2)+
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
	
	



VBL_IR
	CLR.B	$FFFFFA1B.W
	
	MOVEM.L	DATA+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

        CMPI.B  #$3B,$FFFFFC02.W
        BEQ.S LM
        BRA.S LK
LM	MOVE.W  #$777,$FFFF8240.W

LK	
	CMPI.B	#$3C,$FFFFFC02.W
	BEQ	POPO
	MOVEQ	#0,D0
        MOVEQ   #0,D1
	MOVEA.L	MES_PNT,A2
	CMPI.B	#-1,320(A2)             * 320=40*8
	BEQ.S	 AGAIN
        MOVEA.L	MES_PNT,A2
        MOVE.L  (A2)+,D0
        MOVE.L  (A2)+,D0
        MOVE.L	A2,MES_PNT
        BRA.S   LA_SUITE
AGAIN	MOVE.L	#MES_F,MES_PNT
	MOVEQ	#0,D0
        MOVEQ   #0,D1
	MOVEA.L	MES_PNT,A2
        MOVE.L	A2,MES_PNT		


LA_SUITE
INC     SET	0
INC2	SET	0

        REPT 40
        MOVEA.L   SCREEN2,A1 
	LEA	160(A1),A1
        MOVE.L  (A2)+,A0
        MOVE.L  (A2)+,D0
        ADDA.L  D0,A1
                
	MOVEM.L	INC(A0),D0-D7/A3-A6
	MOVEM.L	D0-D7/A3-A6,INC2(A1)
	
	MOVEM.L	INC+48(A0),D0-D7/A3-A6
	MOVEM.L	D0-D7/A3-A6,INC2+48(A1)

INC     SET	INC+96 	               ; 160
INC2	SET	INC2+230
        ENDR


POPO              
	MOVE.L	SAVEA0,A0
	MOVE	(A0)+,COUL1
	MOVE	(A0)+,COUL2
	MOVE	(A0)+,COUL3
	CMPI.W	#$999,(A0)
	BNE.S	SUITE

	LEA	FADING,A0
SUITE	MOVE.L	A0,SAVEA0

	JSR	AFF_FNT
	JSR	SCROLL
	LEA	PALETTE,A4

	CLR	$FFFF8240.W
	
full	
	MOVE.L	#$FFFF8209,A3	
	MOVE.L	#$FFFF8260,A1	
	MOVE.L	#$FFFF820A,A0	
;	MOVE	#39,D0		* NB DE LIGNES
;	MOVE	#32,D2		* NB DE LIGNES
	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6
	MOVE	#$2700,SR


;	MOVE	#$777,$FFFF8240.W

SYNCHRO	MOVE.B	(A3),D7     * SYNCHRO
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		


	REPT	19
	move.l	(a6)+,(a5)+
	ENDR
	REPT	2
	NOP	
	ENDR
	

	
	REPT	40

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	MOVE	(a4)+,$ffff825C.W		
;	MOVE	(a6),$ffff8242.W
;	MOVE	(a6)+,$ffff8244.W	* MOVE.W=4 NOPS

	* 85 NOPS

	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+




	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)

	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+

	NOP
	NOP
	NOP	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+

	NOP
	NOP
	ENDR






;	LEA.L	$FFFF8242.W,A6		= 8 CYCLES  ( 2 NOPS )
;	MOVE	(a6)+,$ffff8244.W	= 16 CYCLES ( 4 NOPS )
;	MOVE.B	D3,(A1)            	= 8 CYCLES  ( 2 NOPS )
;					( 12 AVEC OFFSET )
;	1 LIGNE = 128 NOPS

	*90 NOPS	(128-3-32-3)
	
	REPT	18
	move.l	(a6)+,(a5)+
	ENDR


	MOVE	COUL1,$FFFF8242.W
	MOVE	COUL2,$FFFF8244.W
	MOVE	COUL3,$FFFF8246.W



;	(128*30)-(3*6)	NOPS DE DISPO
;
;	MOVE	#$777,$FFFF8240.W
	REPT	2+(128*5)+(292*5)-34-3-4-6-2-6-5-4-6-2-6-35-1908
	NOP
	ENDR
	*2102-3-4-6-2-4-5-4-6-2-4-35-34=1993
;	MOVE	#$000,$FFFF8240.W


	REPT	34+3+4+6+2+6+5+4+6+2+6
	NOP
	ENDR


;	MOVEM.L	D0-D7/A0-A6,SAVER	*34
		
;	MOVEA.L	#DATA+34,A1		*	3 NOPS
;	ADDA.L	#(160*(40+30+32-15)),A1		*4
;        ADDA.L   Y_VALUE,A1			*6
;	LEA.L	-160(A1),A1  			*2
;	ADDa.L	X_VALUE,A1			*6
;        MOVEA.L SCREEN1,A0			*5
;	ADDA.L	#320+(230*40)+(160*30)+(230*33)+160,A0	*4
;        ADDA.L   Y_VALUE,A0			*6
;	LEA.L	-160(A0),A0  *-488		*2
;	ADDa.L	X_VALUE,A0			*6
;;INC	SET	0
;	REPT	18
;	MOVEM.L	INC(A1),D0-D7/A2-A6	*30
;	MOVEM.L	D0-D7/A2-A6,INC(A0)	*29

;	MOVEM.L	INC+48(A1),D0-D7/A2-A3	*24
;	MOVEM.L	D0-D7/A2-A3,INC+48(A0)	*23

;INC	SET	INC+160
;	ENDR

;	MOVEM.L	SAVER,D0-D7/A0-A6	*35
	REPT	35+18*(30+29+24+23)
	NOP
	ENDR


;	IL RESTE (33*58)-(40*17)-(33*17)-19-18 SOIT 636 MOVE.L (A6)+,(A5)+
;	A EFFECTUER  ( ANCIENNE SOUS-ROUTINE 'SCROLL2' )
;	ON A LA PLACE POUR 764 DE CES INSTRUCTIONS.
;	IL RESTE DONC 128 INSTRUCTIONS SOIT 128*5 NOPS

	REPT	636-292
	MOVE.L	(A6)+,(A5)+
	ENDR


	MOVE.L  #IMAGE+2,A2                  * = 12 CYCLES  ( 3 NOPS )

     
     	MOVE	(A2)+,$FFFF8242.W     * = 8*4 NOPS
       	MOVE	(A2)+,$FFFF8242.W
       	MOVE	(A2)+,$FFFF8244.W
       	MOVE	(A2)+,$FFFF8246.W
       	MOVE	(A2)+,$FFFF8248.W
       	MOVE	(A2)+,$FFFF824A.W
       	MOVE	(A2)+,$FFFF824C.W
       	MOVE	(A2)+,$FFFF824E.W


	LEA	PALETTE2,A2		* 12 CYCLES = 3 NOPS


	REPT	33

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)



	MOVE	(a2)+,$ffff8242.W		
;	MOVE	(a6),$ffff8242.W
;	MOVE	(a6)+,$ffff8244.W	* MOVE.W=4 NOPS

	* 85 NOPS

	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+


	* 85 NOPS


	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+

	NOP
	NOP
	NOP	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	move.l	(a6)+,(a5)+
	move.l	(a6)+,(a5)+

	NOP
	NOP
	ENDR



	REPT	93+1

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP



	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	ENDR



;;     REPT 116			* 116
;;	NOP	
;;     ENDR
;;	CLR.B	$FFFF820A.W 
;;    REPT 5
;;     	NOP			
;;     ENDR
;;	MOVE.B	#$2,$FFFF820A.W


	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP



	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	NOP	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	;	ICI=116	NOPS


	CLR.B	$FFFF820A.W 
    REPT 5+3
     	NOP			
     ENDR
;	MOVE.B	#$2,$FFFF820A.W





	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	MOVE.B	#$2,$FFFF820A.W
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP



	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	REPT	23+7

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP



	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	ENDR





;	MOVEM.L	PAL_SNORK,D0-D7
;	MOVEM.L	D0-D7,$FFFF8240.W


;	MOVE.L	MES_PNT2,A1
;	CMPI.B	#-1,(A1)
;	BEQ.S	NOT_OK
	
;	MOVE.L	(A1)+,A0
;	MOVE.L	(A1)+,D0
;	MOVE.L	A1,MES_PNT2

;	REPT	10
;	NOP
;	ENDR

;	BRA.S	LETSGO

;NOT_OK	MOVE.L	#MES_F2,MES_PNT2
;	MOVE.L	MES_PNT2,A1
;	MOVE.L	(A1)+,A0
;	MOVE.L	(A1)+,D0
;	MOVE.L	A1,MES_PNT2



;LETSGO	MOVEA.L	SCREEN2,A1
;	ADDA.L	#320+(230*40)+(230*33)+(160*40),A1
;	ADDA.L	D0,A1


;INC     SET	0
;INC2	SET	0

;        REPT 32
                
;	MOVEM.L	INC(A0),D0-D7/A2-A6
;	MOVEM.L	D0-D7/A2-A6,INC2(A1)
	
;	MOVEM.L	INC+48(A0),D0-D7/A2-A3
;	MOVEM.L	D0-D7/A2-A3,INC2+48(A1)

;INC     SET	INC+88 	               ; 160
;INC2	SET	INC2+160
;        ENDR

;	MOVE	#$700,$FFFF8240.W
;	CLR	$FFFF8240.W

	CMPI.B	#$3D,$FFFFFC02.W
	BEQ	GOGOP

	
	MOVEM.L	SAVERD,A0-A3

	MOVEA.L	SCREEND,A2
	ADDQ.L	#1,CNT2
	
	CMPI.L	#NB_POS,CNT		* ESSAYER 63 !!
	BNE.S	LTY

	LEA	DATA_X,A0
	LEA	DATA_Y,A1
	clr.l	CNT
LTY
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

	MOVEA.L	SCREEN,A2

	REPT	NB_PTS
	MOVE.B	(A0)+,D0
	MOVE	(A1)+,D1
	OR.B	D0,0(A2,D1.W)
	ENDR
	
	MOVEM.L	A0-A3,SAVERD

GOGOP
	JSR	SWAP_SCR
	jsr	ZIK+8
	

	CMPI.B	#$B9,$FFFFFC02.W
	BEQ	FIN
        CLR	$FFFF8240.W
	RTE


FIN:	
        MOVE.B  #2,$FFFF820A.W
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	
	MOVE.L	ANC_VBL,$70
	MOVE.L	ANC_TB,$120


	MOVEQ	#0,D0
	JSR	ZIK

	
	LEA.L	ANC_PAL,A0
	MOVEM.L	(A0),D0-D7
	LEA.L	$FFFF8240.W,A0
	MOVEM.L	D0-D7,(A0)
	
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
	

TB0_IR	
	RTE
;     REPT 127
;	NOP				* BOUCLE D'ATTENTE...
;     ENDR
;	MOVE.B	#0,$FFFF820A.W		* PASSAGE EN 60 HZ
;     REPT 8
;     	NOP				* BOUCLE D'ATTENTE
;     ENDR
;	MOVE.B	#2,$FFFF820A.W		* RETOUR EN 50 HZ
;	CLR.B	$FFFFFA1B.W			* ARRET DU TIMER B
;	MOVE.L	#TB0_IR,$120		* NOUVELLE ROUTINE TIMER B
;	BCLR	#0,$FFFFFA0F.W			* INTERUPTION TRAITEE
;	RTE				* RETOUR
	

PREDECALE:
          MOVE.L    LIGNES,D5
DECAL
          roxl.w    152(a4)  * 1ER PLAN
          roxl.w    144(a4)
          roxl.w    136(a4)       
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
   
          roxl.w    154(a4)  * 2EME PLAN
          roxl.w    146(a4)
          roxl.w    138(a4)       
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
          roxl.w    18(a4)
          roxl.w    10(a4)
          roxl.w    2(a4)

          roxl.w    156(a4)  * 3EME PLAN
          roxl.w    148(a4)
          roxl.w    140(a4)       
          roxl.w    132(a4)
          roxl.w    124(a4)
          roxl.w    116(a4)
          roxl.w    108(a4)
          roxl.w    100(a4)
          roxl.w    92(a4)
          roxl.w    84(a4)
          roxl.w    76(a4)
          roxl.w    68(a4)
          roxl.w    60(a4)
          roxl.w    52(a4)
          roxl.w    44(a4)
          roxl.w    36(a4)
          roxl.w    28(a4)
          roxl.w    20(a4)
          roxl.w    12(a4)
          roxl.w    4(a4)

          roxl.w    158(a4)  * 4EME PLAN
          roxl.w    150(a4)
          roxl.w    142(a4)       
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
          roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          LEA.L   160(A4),A4
          DBF D5,DECAL
          RTS


SET_SCR:	move.l	#BUFFERSCR,d0	
	and.l	#$ffffff00,d0		
	move.l	d0,SCREEN1
	add.l	#64000,d0		
	move.l	d0,SCREEN2
	ADD.L	#-64000+23320+4800,D0
	MOVE.L	D0,SCREEN
	add.l	#64000,d0		
	move.l	d0,SCREEND
	rts				

SWAP_SCR:	


	move.l	SCREEN,d0	
	move.l	SCREEND,SCREEN		
	move.l	d0,SCREEND

	move.l	SCREEN1,d0	
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	rts
SCROLL:	
        move.l	SCREEN2,a5	
	move.l	SCREEN2,a6
	adda.l	#8+(160*2)+(230*40)+(160*30),a6
	LEA	25760+(230*15)(A6),A6
	adda.l	#(160*2)+(230*40)+(160*30),a5
	LEA	25760+(230*15)(A5),A5
	RTS	

	






AFF_FNT:	cmp.w	#1,PART_AFF
	blo	PART1
	beq	PART2
	cmp.w	#3,PART_AFF
	blo	PART3
	beq	PART4
	
PART1:	move.l	#IMAGE+34,a2	Pointe sur les fontes
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1	(8 pixels de large)
	adda.l	#216+(160*2)+(230*40)+(160*30),a1
	LEA	25760+(230*15)(A1),A1
INC	set	0
INC2	SET	0
	rept	33
	move.b	INC+9(a2),INC2(a1)
	move.b	INC+11(a2),INC2+2(a1)
	move.b	INC+13(a2),INC2+4(a1)
        move.b  INC+15(a2),INC2+6(a1)  * ok je pense
INC	set	INC+160
INC2	SET	INC2+230
	endr
	
	addq.l	#2,a0		On passe … une autre lettre
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	On sauvegarde le pointeur
	
	move.l	#IMAGE+34,a2
	adda.w	(a0),a2
INC	set 	0
INC2	set 	0
	rept 	33
	move.b	INC+0(a2),INC2+1(a1)
	move.b	INC+2(a2),INC2+3(a1)
	move.b	INC+4(a2),INC2+5(a1)  * ok
        move.b  INC+6(a2),INC2+7(a1)
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#1,PART_AFF
	bra	FIN_SCRO	
	
PART2:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+(160*2)+(230*40)+(160*30),a1
	LEA	25760+(230*15)(A1),A1
INC	set	0
INC2	set	0
	rept	33
	move.l	INC(a2),INC2(a1)
	move.w	INC+4(a2),INC2+4(a1)
        move.w  INC+6(a2),INC2+6(a1)      * ok
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#2,PART_AFF
	bra	FIN_SCRO

PART3:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+(160*2)+(230*40)+(160*30),a1
	LEA	25760+(230*15)(A1),A1
INC	set	0
INC2	set	0
	rept	33
	move.b	INC+1(a2),INC2(a1)	
	move.b	INC+3(a2),INC2+2(a1)	
	move.b	INC+5(a2),INC2+4(a1)
        move.b  INC+7(a2),INC2+6(a1)
	move.b	INC+8(a2),INC2+1(a1)	
	move.b	INC+10(a2),INC2+3(a1)	
	move.b	INC+12(a2),INC2+5(a1)	
        move.b  INC+14(a2),INC2+7(a1)      * ok ?
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#3,PART_AFF
	bra	FIN_SCRO

PART4:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+(160*2)+(230*40)+(160*30),a1
	LEA	25760+(230*15)(A1),A1
INC	set	0
INC2	set	0

	rept	33
	move.l	INC+8(a2),INC2(a1)
	move.w	INC+12(a2),INC2+4(a1)
        move.w  INC+14(a2),INC2+6(a1)  * ok?
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#0,PART_AFF
	bra	FIN_SCRO

FIN_SCRO	rts	
	

;***************************************************************************
; Unpacking source for Pack-Ice Version 2.1
; a0: Pointer on packed Data
decrunch:	movem.l d0-a6,-(sp)		; save registers
		cmpi.l	#'Ice!',(a0)+		; Data packed?
		bne.s	ice2_07			; no!
		move.l	(a0)+,d0
		lea	-8(a0,d0.l),a5
		move.l	(a0)+,(sp)
		lea	108(a0),a4
		movea.l a4,a6
		adda.l	(sp),a6
		movea.l a6,a3
		movea.l a6,a1			; save 120 bytes
		lea	ice2_21+120(pc),a2	; at the end of the
		moveq	#$77,d0			; unpacked data
ice2_00:	move.b	-(a1),-(a2)
		dbra	d0,ice2_00
		bsr	ice2_0c
		bsr.s	ice2_08
		bsr	ice2_10		;; Picture decrunch!
		bcc.s	ice2_04		;; These marked lines are only
		movea.l a3,a1		;; necessary, if you selected the
		move.w	#$0f9f,d7	;; additional picture packer
ice2_01:	moveq	#3,d6		;; in Pack-Ice.
ice2_02:	move.w	-(a1),d4	;;
		moveq	#3,d5		;; If you never use the picture
ice2_03:	add.w	d4,d4		;; pack option, you may delete
		addx.w	d0,d0		;; all the lines marked with ";;"
		add.w	d4,d4		;;
		addx.w	d1,d1		;;
		add.w	d4,d4		;;
		addx.w	d2,d2		;;
		add.w	d4,d4		;;
		addx.w	d3,d3		;;
		dbra	d5,ice2_03	;;
		dbra	d6,ice2_02	;;
		movem.w d0-d3,(a1)	;;
		dbra	d7,ice2_01	;;
ice2_04:	move.l	(sp),d0			; move all data to
		lea	-120(a4),a1		; 120 bytes lower
ice2_05:	move.b	(a4)+,(a1)+
		dbra	d0,ice2_05
		subi.l	#$010000,d0
		bpl.s	ice2_05
		moveq	#$77,d0			; restore saved data
		lea	ice2_21+120(pc),a2
ice2_06:	move.b	-(a2),-(a3)
		dbra	d0,ice2_06
ice2_07:	movem.l (sp)+,d0-a6		; restore registers
		rts
ice2_08:	bsr.s	ice2_10
		bcc.s	ice2_0b
		moveq	#0,d1
		bsr.s	ice2_10
		bcc.s	ice2_0a
		lea	ice2_1e(pc),a1
		moveq	#4,d3
ice2_09:	move.l	-(a1),d0
		bsr.s	ice2_13
		swap	d0
		cmp.w	d0,d1
		dbne	d3,ice2_09
		add.l	20(a1),d1
ice2_0a:	move.b	-(a5),-(a6)
		dbra	d1,ice2_0a
ice2_0b:	cmpa.l	a4,a6
		bgt.s	ice2_16
		rts
ice2_0c:	moveq	#3,d0
ice2_0d:	move.b	-(a5),d7
		ror.l	#8,d7
		dbra	d0,ice2_0d
		rts
ice2_0e:	move.w	a5,d7
		btst	#0,d7
		bne.s	ice2_0f
		move.l	-(a5),d7
		addx.l	d7,d7
		bra.s	ice2_15
ice2_0f:	move.l	-5(a5),d7
		lsl.l	#8,d7
		move.b	-(a5),d7
		subq.l	#3,a5
		add.l	d7,d7
		bset	#0,d7
		bra.s	ice2_15
ice2_10:	add.l	d7,d7
		beq.s	ice2_11
		rts
ice2_11:	move.w	a5,d7
		btst	#0,d7
		bne.s	ice2_12
		move.l	-(a5),d7
		addx.l	d7,d7
		rts
ice2_12:	move.l	-5(a5),d7
		lsl.l	#8,d7
		move.b	-(a5),d7
		subq.l	#3,a5
		add.l	d7,d7
		bset	#0,d7
		rts
ice2_13:	moveq	#0,d1
ice2_14:	add.l	d7,d7
		beq.s	ice2_0e
ice2_15:	addx.w	d1,d1
		dbra	d0,ice2_14
		rts
ice2_16:	lea	ice2_1f(pc),a1
		moveq	#3,d2
ice2_17:	bsr.s	ice2_10
		dbcc	d2,ice2_17
		moveq	#0,d4
		moveq	#0,d1
		move.b	1(a1,d2.w),d0
		ext.w	d0
		bmi.s	ice2_18
		bsr.s	ice2_13
ice2_18:	move.b	6(a1,d2.w),d4
		add.w	d1,d4
		beq.s	ice2_1a
		lea	ice2_20(pc),a1
		moveq	#1,d2
ice2_19:	bsr.s	ice2_10
		dbcc	d2,ice2_19
		moveq	#0,d1
		move.b	1(a1,d2.w),d0
		ext.w	d0
		bsr.s	ice2_13
		add.w	d2,d2
		add.w	6(a1,d2.w),d1
		bra.s	ice2_1c
ice2_1a:	moveq	#0,d1
		moveq	#5,d0
		moveq	#0,d2
		bsr.s	ice2_10
		bcc.s	ice2_1b
		moveq	#8,d0
		moveq	#$40,d2
ice2_1b:	bsr.s	ice2_13
		add.w	d2,d1
ice2_1c:	lea	2(a6,d4.w),a1
		adda.w	d1,a1
		move.b	-(a1),-(a6)
ice2_1d:	move.b	-(a1),-(a6)
		dbra	d4,ice2_1d
		bra	ice2_08
		dc.b $7f,$ff,$00,$0e,$00,$ff,$00,$07
		dc.b $00,$07,$00,$02,$00,$03,$00,$01
		dc.b $00,$03,$00,$01
ice2_1e:	dc.b $00,$00,$01,$0d,$00,$00,$00,$0e
		dc.b $00,$00,$00,$07,$00,$00,$00,$04
		dc.b $00,$00,$00,$01
ice2_1f:	dc.b $09,$01,$00,$ff,$ff,$08,$04,$02
		dc.b $01,$00
ice2_20:	dc.b $0b,$04,$07,$00,$01,$20,$00,$00
		dc.b $00,$20
ice2_21:	ds.w 60			; free space (can be put in BSS)



**** Variables ***

	section   data



cos_tab	incbin A:\COSIN.DAT	;tables sinus cosinus
sin_tab	equ cos_tab+720

points	
 DC  -5,45,45,5,45,45
 DC  -15,45,45,15,45,45
 DC  -25,45,45,25,45,45
 DC  -35,45,45,35,45,45
 DC  -45,45,45,45,45,45

 DC  -5,-45,45,5,-45,45
 DC  -15,-45,45,15,-45,45
 DC  -25,-45,45,25,-45,45
 DC  -35,-45,45,35,-45,45
 DC  -45,-45,45,45,-45,45

 DC  45,-5,45,45,5,45
 DC  45,-15,45,45,15,45
 DC  45,-25,45,45,25,45
 DC  45,-35,45,45,35,45

 DC  -45,-5,45,-45,5,45
 DC  -45,-15,45,-45,15,45
 DC  -45,-25,45,-45,25,45
 DC  -45,-35,45,-45,35,45


 DC  -5,45,-45,5,45,-45
 DC  -15,45,-45,15,45,-45
 DC  -25,45,-45,25,45,-45
 DC  -35,45,-45,35,45,-45
 DC  -45,45,-45,45,45,-45

 DC  -5,-45,-45,5,-45,-45
 DC  -15,-45,-45,15,-45,-45
 DC  -25,-45,-45,25,-45,-45
 DC  -35,-45,-45,35,-45,-45
 DC  -45,-45,-45,45,-45,-45

 DC  45,-5,-45,45,5,-45
 DC  45,-15,-45,45,15,-45
 DC  45,-25,-45,45,25,-45
 DC  45,-35,-45,45,35,-45

 DC  -45,-5,-45,-45,5,-45
 DC  -45,-15,-45,-45,15,-45
 DC  -45,-25,-45,-45,25,-45
 DC  -45,-35,-45,-45,35,-45




 DC  -45,-45,-5,-45,-45,5
 DC  -45,-45,-15,-45,-45,15
 DC  -45,-45,-25,-45,-45,25
 DC  -45,-45,-35,-45,-45,35

 DC  -45,45,-5,-45,45,5
 DC  -45,45,-15,-45,45,15
 DC  -45,45,-25,-45,45,25
 DC  -45,45,-35,-45,45,35

 DC  45,-45,-5,45,-45,5
 DC  45,-45,-15,45,-45,15
 DC  45,-45,-25,45,-45,25
 DC  45,-45,-35,45,-45,35

 DC  45,45,-5,45,45,5
 DC  45,45,-15,45,45,15
 DC  45,45,-25,45,45,25
 DC  45,45,-35,45,45,35

	
depla		
 dc 0
 dc 2
 dc 4
 dc 6
 dc 8
 dc 10
 dc 12
 dc 14
 dc 16
 dc 18
 dc 20
 dc 22
 dc 25
 dc 27
 dc 29
 dc 31
 dc 33
 dc 35
 dc 37
 dc 39
 dc 41
 dc 43
 dc 45
 dc 47
 dc 48
 dc 50
 dc 52
 dc 54
 dc 56
 dc 58
 dc 60
 dc 61
 dc 63
 dc 65
 dc 67
 dc 68
 dc 70
 dc 72
 dc 74
 dc 75
 dc 77
 dc 78
 dc 80
 dc 82
 dc 83
 dc 85
 dc 86
 dc 87
 dc 89
 dc 90
 dc 92
 dc 93
 dc 94
 dc 96
 dc 97
 dc 98
 dc 99
 dc 100
 dc 101
 dc 103
 dc 104
 dc 105
 dc 106
 dc 107
 dc 108
 dc 108
 dc 109
 dc 110
 dc 111
 dc 112
 dc 112
 dc 113
 dc 114
 dc 114
 dc 115
 dc 116
 dc 116
 dc 117
 dc 117
 dc 117
 dc 118
 dc 118
 dc 118
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 119
 dc 118
 dc 118
 dc 118
 dc 117
 dc 117
 dc 116
 dc 116
 dc 115
 dc 115
 dc 114
 dc 113
 dc 113
 dc 112
 dc 111
 dc 111
 dc 110
 dc 109
 dc 108
 dc 107
 dc 106
 dc 105
 dc 104
 dc 103
 dc 102
 dc 101
 dc 100
 dc 99
 dc 97
 dc 96
 dc 95
 dc 94
 dc 92
 dc 91
 dc 90
 dc 88
 dc 87
 dc 85
 dc 84
 dc 82
 dc 81
 dc 79
 dc 78
 dc 76
 dc 74
 dc 73
 dc 71
 dc 69
 dc 68
 dc 66
 dc 64
 dc 62
 dc 61
 dc 59
 dc 57
 dc 55
 dc 53
 dc 51
 dc 49
 dc 48
 dc 46
 dc 44
 dc 42
 dc 40
 dc 38
 dc 36
 dc 34
 dc 32
 dc 30
 dc 28
 dc 26
 dc 24
 dc 21
 dc 19
 dc 17
 dc 15
 dc 13
 dc 11
 dc 9
 dc 7
 dc 5
 dc 3
 dc 1

DEPLA2
 dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -93
 dc -94
 dc -96
 dc -97
 dc -98
 dc -98
 dc -99
 dc -100
 dc -100
 dc -100
 dc -100
 dc -100
 dc -100
 dc -100
 dc -100
 dc -100
 dc -99
 dc -98
 dc -98
 dc -97
 dc -96
 dc -94
 dc -93
 dc -92
 dc -90
 dc -89
 dc -87
 dc -85
 dc -83
 dc -81
 dc -79
 dc -77
 dc -75
 dc -72
 dc -70
 dc -67
 dc -65
 dc -62
 dc -59
 dc -56
 dc -53
 dc -50
 dc -47
 dc -44
 dc -41
 dc -38
 dc -35
 dc -31
 dc -28
 dc -25
 dc -21
 dc -18
 dc -14
 dc -11
 dc -7
 dc -4


TEXTE:	INCBIN	A:\FULL.TXT
IMAGE:	INCBIN	A:\FONTES2.PI1
	ds.b	17668+160+160+320	*tot=23908
;	ds.b	6240
BUFFER1 DS.L    960
BUFFER2 DS.L    960
BUFFER3 DS.L    960
BUFFER4 DS.L    960
BUFFER5 DS.L    960
BUFFER6 DS.L    960
BUFFER7 DS.L    960
BUFFER8 DS.L    960
BUFFER9 DS.L    960
BUFFER10 DS.L    960
BUFFER11 DS.L    960
BUFFER12 DS.L    960
BUFFER13 DS.L    960
BUFFER14 DS.L    960
BUFFER15 DS.L    960
BUFFER16 DS.L    960


;MANGA	INCBIN	A:\DATA.KID
ZIK	INCBIN	A:\FRODON1.MUS
DATA:	INCBIN	A:\DATA2.PI1


MES_F   
 DC.L BUFFER8,64
 DC.L BUFFER5,64
 DC.L BUFFER1,64
 DC.L BUFFER14,72
 DC.L BUFFER10,72
 DC.L BUFFER6,72
 DC.L BUFFER3,72
 DC.L BUFFER15,80
 DC.L BUFFER11,80
 DC.L BUFFER8,80
 DC.L BUFFER4,80
 DC.L BUFFER1,80
 DC.L BUFFER13,88
 DC.L BUFFER10,88
 DC.L BUFFER7,88
 DC.L BUFFER3,88
 DC.L BUFFER16,96
 DC.L BUFFER13,96
 DC.L BUFFER9,96
 DC.L BUFFER6,96
 DC.L BUFFER3,96
 DC.L BUFFER16,104
 DC.L BUFFER13,104
 DC.L BUFFER10,104
 DC.L BUFFER7,104
 DC.L BUFFER5,104
 DC.L BUFFER2,104
 DC.L BUFFER15,112
 DC.L BUFFER13,112
 DC.L BUFFER10,112
 DC.L BUFFER8,112
 DC.L BUFFER5,112
 DC.L BUFFER3,112
 DC.L BUFFER1,112
 DC.L BUFFER15,120
 DC.L BUFFER13,120
 DC.L BUFFER11,120
 DC.L BUFFER9,120
 DC.L BUFFER7,120
 DC.L BUFFER6,120
 DC.L BUFFER4,120
 DC.L BUFFER3,120
 DC.L BUFFER1,120
 DC.L BUFFER16,128
 DC.L BUFFER15,128
 DC.L BUFFER14,128
 DC.L BUFFER13,128
 DC.L BUFFER12,128
 DC.L BUFFER11,128
 DC.L BUFFER11,128
 DC.L BUFFER10,128
 DC.L BUFFER10,128
 DC.L BUFFER9,128
 DC.L BUFFER9,128
 DC.L BUFFER9,128
 DC.L BUFFER9,128
 DC.L BUFFER9,128
 DC.L BUFFER9,128
 DC.L BUFFER9,128
 DC.L BUFFER10,128
 DC.L BUFFER10,128
 DC.L BUFFER11,128
 DC.L BUFFER11,128
 DC.L BUFFER12,128
 DC.L BUFFER13,128
 DC.L BUFFER14,128
 DC.L BUFFER15,128
 DC.L BUFFER16,128
 DC.L BUFFER1,120
 DC.L BUFFER3,120
 DC.L BUFFER4,120
 DC.L BUFFER6,120
 DC.L BUFFER7,120
 DC.L BUFFER9,120
 DC.L BUFFER11,120
 DC.L BUFFER12,120
 DC.L BUFFER14,120
 DC.L BUFFER16,120
 DC.L BUFFER3,112
 DC.L BUFFER5,112
 DC.L BUFFER7,112
 DC.L BUFFER9,112
 DC.L BUFFER12,112
 DC.L BUFFER14,112
 DC.L BUFFER1,104
 DC.L BUFFER3,104
 DC.L BUFFER6,104
 DC.L BUFFER9,104
 DC.L BUFFER11,104
 DC.L BUFFER14,104
 DC.L BUFFER1,96
 DC.L BUFFER4,96
 DC.L BUFFER7,96
 DC.L BUFFER10,96
 DC.L BUFFER13,96
 DC.L BUFFER16,96
 DC.L BUFFER3,88
 DC.L BUFFER6,88
 DC.L BUFFER10,88
 DC.L BUFFER13,88
 DC.L BUFFER16,88
 DC.L BUFFER3,80
 DC.L BUFFER7,80
 DC.L BUFFER10,80
 DC.L BUFFER13,80
 DC.L BUFFER1,72
 DC.L BUFFER4,72
 DC.L BUFFER7,72
 DC.L BUFFER11,72
 DC.L BUFFER14,72
 DC.L BUFFER1,64
 DC.L BUFFER5,64
 DC.L BUFFER8,64
 DC.L BUFFER11,64
 DC.L BUFFER14,64
 DC.L BUFFER2,56
 DC.L BUFFER5,56
 DC.L BUFFER8,56
 DC.L BUFFER11,56
 DC.L BUFFER15,56
 DC.L BUFFER2,48
 DC.L BUFFER5,48
 DC.L BUFFER8,48
 DC.L BUFFER11,48
 DC.L BUFFER14,48
 DC.L BUFFER1,40
 DC.L BUFFER4,40
 DC.L BUFFER7,40
 DC.L BUFFER9,40
 DC.L BUFFER12,40
 DC.L BUFFER15,40
 DC.L BUFFER1,32
 DC.L BUFFER4,32
 DC.L BUFFER7,32
 DC.L BUFFER9,32
 DC.L BUFFER11,32
 DC.L BUFFER14,32
 DC.L BUFFER16,32
 DC.L BUFFER2,24
 DC.L BUFFER4,24
 DC.L BUFFER6,24
 DC.L BUFFER8,24
 DC.L BUFFER10,24
 DC.L BUFFER12,24
 DC.L BUFFER14,24
 DC.L BUFFER16,24
 DC.L BUFFER1,16
 DC.L BUFFER3,16
 DC.L BUFFER4,16
 DC.L BUFFER5,16
 DC.L BUFFER7,16
 DC.L BUFFER8,16
 DC.L BUFFER9,16
 DC.L BUFFER10,16
 DC.L BUFFER11,16
 DC.L BUFFER12,16
 DC.L BUFFER13,16
 DC.L BUFFER13,16
 DC.L BUFFER14,16
 DC.L BUFFER14,16
 DC.L BUFFER15,16
 DC.L BUFFER15,16
 DC.L BUFFER15,16
 DC.L BUFFER15,16
 DC.L BUFFER16,16
 DC.L BUFFER16,16
 DC.L BUFFER15,16
 DC.L BUFFER15,16
 DC.L BUFFER15,16
 DC.L BUFFER15,16
 DC.L BUFFER14,16
 DC.L BUFFER14,16
 DC.L BUFFER13,16
 DC.L BUFFER12,16
 DC.L BUFFER12,16
 DC.L BUFFER11,16
 DC.L BUFFER10,16
 DC.L BUFFER9,16
 DC.L BUFFER8,16
 DC.L BUFFER7,16
 DC.L BUFFER6,16
 DC.L BUFFER4,16
 DC.L BUFFER3,16
 DC.L BUFFER2,16
 DC.L BUFFER16,24
 DC.L BUFFER15,24
 DC.L BUFFER13,24
 DC.L BUFFER12,24
 DC.L BUFFER10,24
 DC.L BUFFER8,24
 DC.L BUFFER6,24
 DC.L BUFFER5,24
 DC.L BUFFER3,24
 DC.L BUFFER1,24
 DC.L BUFFER15,32
 DC.L BUFFER13,32
 DC.L BUFFER11,32
 DC.L BUFFER9,32
 DC.L BUFFER6,32
 DC.L BUFFER4,32
 DC.L BUFFER2,32
 DC.L BUFFER16,40
 DC.L BUFFER14,40
 DC.L BUFFER11,40
 DC.L BUFFER9,40
 DC.L BUFFER7,40
 DC.L BUFFER4,40
 DC.L BUFFER2,40
 DC.L BUFFER16,48
 DC.L BUFFER13,48
 DC.L BUFFER11,48
 DC.L BUFFER8,48
 DC.L BUFFER6,48
 DC.L BUFFER4,48
 DC.L BUFFER1,48
 DC.L BUFFER15,56
 DC.L BUFFER12,56
 DC.L BUFFER10,56
 DC.L BUFFER8,56
 DC.L BUFFER5,56
 DC.L BUFFER3,56
 DC.L BUFFER16,64
 DC.L BUFFER14,64
 DC.L BUFFER12,64
 DC.L BUFFER9,64
 DC.L BUFFER7,64
 DC.L BUFFER5,64
 DC.L BUFFER3,64
 DC.L BUFFER16,72
 DC.L BUFFER14,72
 DC.L BUFFER12,72
 DC.L BUFFER10,72
 DC.L BUFFER8,72
 DC.L BUFFER6,72
 DC.L BUFFER4,72
 DC.L BUFFER2,72
 DC.L BUFFER16,80
 DC.L BUFFER14,80
 DC.L BUFFER12,80
 DC.L BUFFER10,80
 DC.L BUFFER9,80
 DC.L BUFFER7,80
 DC.L BUFFER5,80
 DC.L BUFFER4,80
 DC.L BUFFER2,80
 DC.L BUFFER1,80
 DC.L BUFFER15,88
 DC.L BUFFER14,88
 DC.L BUFFER13,88
 DC.L BUFFER11,88
 DC.L BUFFER10,88
 DC.L BUFFER9,88
 DC.L BUFFER8,88
 DC.L BUFFER7,88
 DC.L BUFFER6,88
 DC.L BUFFER5,88
 DC.L BUFFER4,88
 DC.L BUFFER3,88
 DC.L BUFFER2,88
 DC.L BUFFER1,88
 DC.L BUFFER1,88
 DC.L BUFFER16,96
 DC.L BUFFER16,96
 DC.L BUFFER15,96
 DC.L BUFFER15,96
 DC.L BUFFER14,96
 DC.L BUFFER14,96
 DC.L BUFFER14,96
 DC.L BUFFER14,96
 DC.L BUFFER13,96
 DC.L BUFFER13,96
 DC.L BUFFER13,96
 DC.L BUFFER13,96
 DC.L BUFFER13,96
 DC.L BUFFER14,96
 DC.L BUFFER14,96
 DC.L BUFFER14,96
 DC.L BUFFER14,96
 DC.L BUFFER15,96
 DC.L BUFFER15,96
 DC.L BUFFER15,96
 DC.L BUFFER16,96
 DC.L BUFFER16,96
 DC.L BUFFER1,88
 DC.L BUFFER2,88
 DC.L BUFFER2,88
 DC.L BUFFER3,88
 DC.L BUFFER4,88
 DC.L BUFFER4,88
 DC.L BUFFER5,88
 DC.L BUFFER6,88
 DC.L BUFFER7,88
 DC.L BUFFER8,88
 DC.L BUFFER9,88
 DC.L BUFFER10,88
 DC.L BUFFER11,88
 DC.L BUFFER12,88
 DC.L BUFFER13,88
 DC.L BUFFER14,88
 DC.L BUFFER15,88
 DC.L BUFFER16,88
 DC.L BUFFER1,80
 DC.L BUFFER2,80
 DC.L BUFFER3,80
 DC.L BUFFER4,80
 DC.L BUFFER6,80
 DC.L BUFFER7,80
 DC.L BUFFER8,80
 DC.L BUFFER9,80
 DC.L BUFFER10,80
 DC.L BUFFER12,80
 DC.L BUFFER13,80
 DC.L BUFFER14,80
 DC.L BUFFER15,80
 DC.L BUFFER1,72
 DC.L BUFFER2,72
 DC.L BUFFER3,72
 DC.L BUFFER4,72
 DC.L BUFFER5,72
 DC.L BUFFER6,72
 DC.L BUFFER8,72
 DC.L BUFFER9,72
 DC.L BUFFER10,72
 DC.L BUFFER11,72
 DC.L BUFFER12,72
 DC.L BUFFER13,72
 DC.L BUFFER14,72
 DC.L BUFFER15,72
 DC.L BUFFER1,64
 DC.L BUFFER2,64
 DC.L BUFFER3,64
 DC.L BUFFER4,64
 DC.L BUFFER4,64
 DC.L BUFFER5,64
 DC.L BUFFER6,64
 DC.L BUFFER7,64
 DC.L BUFFER8,64
 DC.L BUFFER9,64
 DC.L BUFFER10,64
 DC.L BUFFER10,64
 DC.L BUFFER11,64
 DC.L BUFFER12,64
 DC.L BUFFER12,64
 DC.L BUFFER13,64
 DC.L BUFFER14,64
 DC.L BUFFER14,64
 DC.L BUFFER15,64
 DC.L BUFFER15,64
 DC.L BUFFER16,64
 DC.L BUFFER16,64
 DC.L BUFFER1,56
 DC.L BUFFER1,56
 DC.L BUFFER1,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER3,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER2,56
 DC.L BUFFER1,56
 DC.L BUFFER1,56
 DC.L BUFFER1,56
 DC.L BUFFER16,64
 DC.L BUFFER16,64
 DC.L BUFFER16,64
 DC.L BUFFER15,64
 DC.L BUFFER15,64
 DC.L BUFFER14,64
 DC.L BUFFER14,64
 DC.L BUFFER13,64
 DC.L BUFFER13,64
 DC.L BUFFER12,64
 DC.L BUFFER12,64
 DC.L BUFFER11,64
 DC.L BUFFER11,64
 DC.L BUFFER10,64
 DC.L BUFFER10,64
 DC.L BUFFER9,64
 DC.L BUFFER9,64
 DC.L BUFFER8,64
 DC.L BUFFER8,64
 DC.L BUFFER7,64
 DC.L BUFFER7,64
 DC.L BUFFER6,64
 DC.L BUFFER6,64
 DC.L BUFFER5,64
 DC.L BUFFER5,64
 DC.L BUFFER4,64
 DC.L BUFFER4,64
 DC.L BUFFER3,64
 DC.L BUFFER3,64
 DC.L BUFFER2,64
 DC.L BUFFER2,64
 DC.L BUFFER2,64
 DC.L BUFFER1,64
 DC.L BUFFER1,64
 DC.L BUFFER16,72
 DC.L BUFFER16,72
 DC.L BUFFER16,72
 DC.L BUFFER16,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER14,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER15,72
 DC.L BUFFER16,72
 DC.L BUFFER16,72
 DC.L BUFFER1,64
 DC.L BUFFER1,64
 DC.L BUFFER1,64
 DC.L BUFFER2,64
 DC.L BUFFER2,64
 DC.L BUFFER3,64
 DC.L BUFFER4,64
 DC.L BUFFER4,64
 DC.L BUFFER5,64
 DC.L BUFFER6,64
 DC.L BUFFER6,64
 DC.L BUFFER7,64
 DC.L BUFFER8,64
 DC.L BUFFER9,64
 DC.L BUFFER10,64
 DC.L BUFFER10,64
 DC.L BUFFER11,64
 DC.L BUFFER12,64
 DC.L BUFFER13,64
 DC.L BUFFER14,64
 DC.L BUFFER15,64
 DC.L BUFFER16,64
 DC.L BUFFER1,56
 DC.L BUFFER2,56
 DC.L BUFFER3,56
 DC.L BUFFER4,56
 DC.L BUFFER5,56
 DC.L BUFFER7,56
 DC.L BUFFER8,56
 DC.L BUFFER9,56
 DC.L BUFFER10,56
 DC.L BUFFER11,56
 DC.L BUFFER12,56
 DC.L BUFFER14,56
 DC.L BUFFER15,56
 DC.L BUFFER16,56
 DC.L BUFFER1,48
 DC.L BUFFER2,48
 DC.L BUFFER4,48
 DC.L BUFFER5,48
 DC.L BUFFER6,48
 DC.L BUFFER7,48
 DC.L BUFFER8,48
 DC.L BUFFER10,48
 DC.L BUFFER11,48
 DC.L BUFFER12,48
 DC.L BUFFER13,48
 DC.L BUFFER14,48
 DC.L BUFFER16,48
 DC.L BUFFER1,40
 DC.L BUFFER2,40
 DC.L BUFFER3,40
 DC.L BUFFER4,40
 DC.L BUFFER5,40
 DC.L BUFFER6,40
 DC.L BUFFER7,40
 DC.L BUFFER8,40
 DC.L BUFFER9,40
 DC.L BUFFER10,40
 DC.L BUFFER11,40
 DC.L BUFFER11,40
 DC.L BUFFER12,40
 DC.L BUFFER13,40
 DC.L BUFFER14,40
 DC.L BUFFER15,40
 DC.L BUFFER15,40
 DC.L BUFFER16,40
 DC.L BUFFER16,40
 DC.L BUFFER1,32
 DC.L BUFFER1,32
 DC.L BUFFER2,32
 DC.L BUFFER2,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER4,32
 DC.L BUFFER4,32
 DC.L BUFFER4,32
 DC.L BUFFER4,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER3,32
 DC.L BUFFER2,32
 DC.L BUFFER2,32
 DC.L BUFFER2,32
 DC.L BUFFER1,32
 DC.L BUFFER16,40
 DC.L BUFFER16,40
 DC.L BUFFER15,40
 DC.L BUFFER14,40
 DC.L BUFFER14,40
 DC.L BUFFER13,40
 DC.L BUFFER12,40
 DC.L BUFFER11,40
 DC.L BUFFER10,40
 DC.L BUFFER9,40
 DC.L BUFFER7,40
 DC.L BUFFER6,40
 DC.L BUFFER5,40
 DC.L BUFFER4,40
 DC.L BUFFER2,40
 DC.L BUFFER1,40
 DC.L BUFFER15,48
 DC.L BUFFER14,48
 DC.L BUFFER12,48
 DC.L BUFFER11,48
 DC.L BUFFER9,48
 DC.L BUFFER7,48
 DC.L BUFFER5,48
 DC.L BUFFER4,48
 DC.L BUFFER2,48
 DC.L BUFFER16,56
 DC.L BUFFER14,56
 DC.L BUFFER12,56
 DC.L BUFFER10,56
 DC.L BUFFER8,56
 DC.L BUFFER6,56
 DC.L BUFFER4,56
 DC.L BUFFER1,56
 DC.L BUFFER15,64
 DC.L BUFFER13,64
 DC.L BUFFER11,64
 DC.L BUFFER8,64
 DC.L BUFFER6,64
 DC.L BUFFER4,64
 DC.L BUFFER2,64
 DC.L BUFFER15,72
 DC.L BUFFER13,72
 DC.L BUFFER10,72
 DC.L BUFFER8,72
 DC.L BUFFER6,72
 DC.L BUFFER3,72
 DC.L BUFFER1,72
 DC.L BUFFER14,80
 DC.L BUFFER12,80
 DC.L BUFFER10,80
 DC.L BUFFER7,80
 DC.L BUFFER5,80
 DC.L BUFFER2,80
 DC.L BUFFER16,88
 DC.L BUFFER14,88
 DC.L BUFFER11,88
 DC.L BUFFER9,88
 DC.L BUFFER7,88
 DC.L BUFFER4,88
 DC.L BUFFER2,88
 DC.L BUFFER16,96
 DC.L BUFFER14,96
 DC.L BUFFER11,96
 DC.L BUFFER9,96
 DC.L BUFFER7,96
 DC.L BUFFER5,96
 DC.L BUFFER3,96
 DC.L BUFFER1,96
 DC.L BUFFER15,104
 DC.L BUFFER13,104
 DC.L BUFFER11,104
 DC.L BUFFER9,104
 DC.L BUFFER8,104
 DC.L BUFFER6,104
 DC.L BUFFER4,104
 DC.L BUFFER3,104
 DC.L BUFFER1,104
 DC.L BUFFER16,112
 DC.L BUFFER14,112
 DC.L BUFFER13,112
 DC.L BUFFER12,112
 DC.L BUFFER11,112
 DC.L BUFFER9,112
 DC.L BUFFER8,112
 DC.L BUFFER7,112
 DC.L BUFFER6,112
 DC.L BUFFER6,112
 DC.L BUFFER5,112
 DC.L BUFFER4,112
 DC.L BUFFER3,112
 DC.L BUFFER3,112
 DC.L BUFFER2,112
 DC.L BUFFER2,112
 DC.L BUFFER2,112
 DC.L BUFFER2,112
 DC.L BUFFER1,112
 DC.L BUFFER1,112
 DC.L BUFFER1,112
 DC.L BUFFER2,112
 DC.L BUFFER2,112
 DC.L BUFFER2,112
 DC.L BUFFER2,112
 DC.L BUFFER3,112
 DC.L BUFFER4,112
 DC.L BUFFER4,112
 DC.L BUFFER5,112
 DC.L BUFFER6,112
 DC.L BUFFER7,112
 DC.L BUFFER8,112
 DC.L BUFFER9,112
 DC.L BUFFER10,112
 DC.L BUFFER11,112
 DC.L BUFFER12,112
 DC.L BUFFER14,112
 DC.L BUFFER15,112
 DC.L BUFFER1,104
 DC.L BUFFER2,104
 DC.L BUFFER4,104
 DC.L BUFFER6,104
 DC.L BUFFER8,104
 DC.L BUFFER10,104
 DC.L BUFFER12,104
 DC.L BUFFER14,104
 DC.L BUFFER16,104
 DC.L BUFFER2,96
 DC.L BUFFER5,96
 DC.L BUFFER7,96
 DC.L BUFFER9,96
 DC.L BUFFER12,96
 DC.L BUFFER14,96
 DC.L BUFFER1,88
 DC.L BUFFER4,88
 DC.L BUFFER7,88
 DC.L BUFFER9,88
 DC.L BUFFER12,88
 DC.L BUFFER15,88
 DC.L BUFFER2,80
 DC.L BUFFER5,80
 DC.L BUFFER8,80
 DC.L BUFFER11,80
 DC.L BUFFER14,80
 DC.L BUFFER1,72
 DC.L BUFFER4,72
 DC.L BUFFER8,72
 DC.L BUFFER11,72
 DC.L BUFFER14,72
 DC.L BUFFER1,64
 DC.L BUFFER5,64
 DC.L BUFFER8,64
 DC.L BUFFER11,64
 DC.L BUFFER14,64
 DC.L BUFFER2,56
 DC.L BUFFER5,56
 DC.L BUFFER8,56
 DC.L BUFFER12,56
 DC.L BUFFER15,56
 DC.L BUFFER2,48
 DC.L BUFFER6,48
 DC.L BUFFER9,48
 DC.L BUFFER12,48
 DC.L BUFFER16,48
 DC.L BUFFER3,40
 DC.L BUFFER6,40
 DC.L BUFFER9,40
 DC.L BUFFER12,40
 DC.L BUFFER16,40
 DC.L BUFFER3,32
 DC.L BUFFER6,32
 DC.L BUFFER9,32
 DC.L BUFFER12,32
 DC.L BUFFER15,32
 DC.L BUFFER2,24
 DC.L BUFFER4,24
 DC.L BUFFER7,24
 DC.L BUFFER10,24
 DC.L BUFFER13,24
 DC.L BUFFER15,24
 DC.L BUFFER2,16
 DC.L BUFFER4,16
 DC.L BUFFER7,16
 DC.L BUFFER9,16
 DC.L BUFFER11,16
 DC.L BUFFER14,16
 DC.L BUFFER16,16
 DC.L BUFFER2,8
 DC.L BUFFER4,8
 DC.L BUFFER6,8
 DC.L BUFFER7,8
 DC.L BUFFER9,8
 DC.L BUFFER11,8
 DC.L BUFFER12,8
 DC.L BUFFER14,8
 DC.L BUFFER15,8
 DC.L BUFFER1,0
 DC.L BUFFER2,0
 DC.L BUFFER3,0
 DC.L BUFFER4,0
 DC.L BUFFER5,0
 DC.L BUFFER5,0
 DC.L BUFFER6,0
 DC.L BUFFER7,0
 DC.L BUFFER7,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER8,0
 DC.L BUFFER7,0
 DC.L BUFFER7,0
 DC.L BUFFER6,0
 DC.L BUFFER5,0
 DC.L BUFFER5,0
 DC.L BUFFER4,0
 DC.L BUFFER3,0
 DC.L BUFFER1,0
 DC.L BUFFER16,8
 DC.L BUFFER15,8
 DC.L BUFFER13,8
 DC.L BUFFER12,8
 DC.L BUFFER10,8
 DC.L BUFFER9,8
 DC.L BUFFER7,8
 DC.L BUFFER5,8
 DC.L BUFFER3,8
 DC.L BUFFER1,8
 DC.L BUFFER15,16
 DC.L BUFFER13,16
 DC.L BUFFER10,16
 DC.L BUFFER8,16
 DC.L BUFFER5,16
 DC.L BUFFER3,16
 DC.L BUFFER16,24
 DC.L BUFFER14,24
 DC.L BUFFER11,24
 DC.L BUFFER8,24
 DC.L BUFFER5,24
 DC.L BUFFER2,24
 DC.L BUFFER15,32
 DC.L BUFFER12,32
 DC.L BUFFER9,32
 DC.L BUFFER6,32
 DC.L BUFFER2,32
 DC.L BUFFER15,40
 DC.L BUFFER12,40
 DC.L BUFFER8,40
 DC.L BUFFER5,40
 DC.L BUFFER2,40
 DC.L BUFFER14,48
 DC.L BUFFER11,48
 DC.L BUFFER7,48
 DC.L BUFFER3,48
 DC.L BUFFER16,56
 DC.L BUFFER12,56
 DC.L BUFFER9,56
 DC.L BUFFER5,56
 DC.L BUFFER1,56
 DC.L BUFFER14,64
 DC.L BUFFER10,64

 DC.L BUFFER8,64
 DC.L BUFFER5,64
 DC.L BUFFER1,64
 DC.L BUFFER14,72
 DC.L BUFFER10,72
 DC.L BUFFER6,72
 DC.L BUFFER3,72
 DC.L BUFFER15,80
 DC.L BUFFER11,80
 DC.L BUFFER8,80
 DC.L BUFFER4,80
 DC.L BUFFER1,80
 DC.L BUFFER13,88
 DC.L BUFFER10,88
 DC.L BUFFER7,88
 DC.L BUFFER3,88
 DC.L BUFFER16,96
 DC.L BUFFER13,96
 DC.L BUFFER9,96
 DC.L BUFFER6,96
 DC.L BUFFER3,96
 DC.L BUFFER16,104
 DC.L BUFFER13,104
 DC.L BUFFER10,104
 DC.L BUFFER7,104
 DC.L BUFFER5,104
 DC.L BUFFER2,104
 DC.L BUFFER15,112
 DC.L BUFFER13,112
 DC.L BUFFER10,112
 DC.L BUFFER8,112
 DC.L BUFFER5,112
 DC.L BUFFER3,112
 DC.L BUFFER1,112
 DC.L BUFFER15,120
 DC.L BUFFER13,120
 DC.L BUFFER11,120
 DC.L BUFFER9,120
 DC.L BUFFER7,120
; DC.L BUFFER6,120

	DC.B  -1,-1
	EVEN






PALETTE
	REPT	4
	DC.W	$000
	ENDR
	
	DC.W	$100,$200,$300,$400,$500,$600,$700
	DC.W	$710,$720,$730,$740,$750,$760,$770
	DC.W	$771,$772,$773,$774,$775,$776,$777

	DC.W	$101,$201,$301,$401,$501,$601,$701
	DC.W	$702,$703,$704,$705,$706,$707
	DC.W	$717,$727,$737,$747,$757,$767,$777
	
	REPT	40
	DC.W	$000
	ENDR


PALETTE2
	rept	2
	dc.w	$000
	endr

	DC.W	$100,$210,$320,$430,$540,$650,$760
	DC.W	$761,$762,$763,$764,$765,$766,$767
	DC.W	$757,$747,$737,$727,$717,$707
	DC.W	$706,$705,$704,$703,$702,$701
	DC.W	$601,$501,$401
	DC.W	$007,$007




FADING

	REPT	50
	DC.W	$000,$777,$777
	ENDR

	REPT	3
	DC.W	$100,$777,$777
	ENDR
	REPT	3
	DC.W	$200,$776,$776	
	ENDR
	REPT	3
	DC.W	$300,$775,$775
	ENDR
	REPT	3
	DC.W	$400,$774,$774
	ENDR
	REPT	3
	DC.W	$500,$773,$773
	ENDR
	REPT	3
	DC.W	$600,$772,$772
	ENDR
	REPT	3
	DC.W	$700,$771,$771
	ENDR
	REPT	3
	DC.W	$710,$770,$770	
	ENDR
	REPT	3
	DC.W	$720,$760,$760
	ENDR
	REPT	3
	DC.W	$730,$750,$750
	ENDR
	REPT	3

	DC.W	$740,$740,$740
	ENDR
	REPT	3
	DC.W	$750,$730,$750
	ENDR
	REPT	3
	DC.W	$760,$720,$760
	ENDR
	REPT	3
	DC.W	$770,$710,$770
	ENDR
	REPT	3
	DC.W	$771,$700,$771	
	ENDR
	REPT	3
	DC.W	$772,$600,$772
	ENDR
	REPT	3
	DC.W	$773,$500,$773
	ENDR
	REPT	3
	DC.W	$774,$400,$774
	ENDR
	REPT	3
	DC.W	$775,$300,$775
	ENDR
	REPT	3
	DC.W	$776,$200,$776
	ENDR
	REPT	3
	DC.W	$777,$100,$777
	ENDR

	REPT	50
	DC.W	$777,$000,$777
	ENDR
	
	REPT	3
	DC.W	$677,$010,$677
	ENDR
	REPT	3
	DC.W	$577,$020,$577
	ENDR
	REPT	3
	DC.W	$477,$030,$477
	ENDR
	REPT	3
	DC.W	$377,$040,$377
	ENDR
	REPT	3
	DC.W	$277,$050,$277
	ENDR
	REPT	3
	DC.W	$177,$060,$177
	ENDR
	REPT	3
	DC.W	$077,$070,$077
	ENDR
	REPT	2
	DC.W	$076,$071,$076
	ENDR
	REPT	3
	DC.W	$075,$072,$075
	ENDR
	REPT	3
	DC.W	$074,$073,$074
	ENDR
	REPT	3


	DC.W	$073,$074,$073
	ENDR
	REPT	3
	DC.W	$072,$075,$075
	ENDR
	REPT	3
	DC.W	$071,$076,$076
	ENDR
	REPT	3
	DC.W	$070,$077,$077
	ENDR
	REPT	3
	DC.W	$060,$177,$177
	ENDR
	REPT	3
	DC.W	$050,$277,$277
	ENDR
	REPT	3
	DC.W	$040,$377,$377
	ENDR
	REPT	3
	DC.W	$030,$477,$477
	ENDR
	REPT	3
	DC.W	$020,$577,$577
	ENDR
	REPT	3
	DC.W	$010,$677,$677
	ENDR
	REPT	3
	DC.W	$000,$777,$777
	ENDR

	DC.W	$999




PAL_SNORK
	DC.W	$000,$210,$321,$432,$543,$654,$765,$776,$700
	DC.W	$000,$000,$000,$000,$000,$000,$000
	EVEN



 	SECTION BSS
 	EVEN

SAVERD	DS.L	8
POINT	DS.L	1
ADRLOGO DS.L    1
ADRFONT DS.L    1
MUS     DS.W    1
MES_PNT DS.L    1
MES_PNT2 DS.L    1
BIDON   DS.L    1
F_PILE	DS.L 	128
D_PILE	DS.L 	1
SAUVE	DS.L	1
ANC_VBL DS.L	1
ANC_TB	DS.L	1
ANC_ECR	DS.L	1
RES	DS.W	1
ANC_PAL	DS.W	16
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
VSYNC	DS.B	1
;	DS.B	10000

	ds.b	256
BUFFERSCR:ds.b	64000*2
	ds.b	256

;	DS.B	10000
SCREEN1:	ds.l	1
SCREEN2:	ds.l	1
MEM_LET:	ds.l	1
PART_AFF:	ds.l    1
SAVEA5A6	DS.L	2
POINTA4	DS.L	1
POINTA6	DS.L	1
SAVEA0	DS.L	1
COUL1	DS.W	1
COUL2	DS.W	1
COUL3	DS.W	1
PLUS	DS.L	1
LIGNES	DS.L	1

KLM		DS.L	1
KLM2		DS.L	1
Y_VALUE		DS.L	1
X_VALUE		DS.L	1
MES_PNT3	DS.L	1

;	CLR	$FFFF8240.W
;	MOVE	#$222,$FFFF8242.W
;	MOVE	#$666,$FFFF8244.W
	
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
POINTEUR2	DS.L	1
DATA_X
	DS.B	NB_POS*NB_PTS
DATA_Y
	DS	NB_POS*NB_PTS

SCREEN	DS.L	1
SCREEND	DS.L	1
CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1	
