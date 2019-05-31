;******************* HELL SCREEN (VERY LAME..)****************
NB_PTS=104		
PAS=3		
NB_POS=360/PAS
;****************** DEBUT DU PROG (PRECALCULS CUBE) *************		
	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	LEA	DATA_Y,A2
	LEA	DATA_X,A1
	move	#256,z_pt_fuite
	move.l	#NB_POS-1,d7
ici	CLR.L	POINTEUR
	jsr	trigo
	rept	NB_PTS
	jsr	sp_to_pl
	jsr	ROUTINE
	endr
	ADD	#2*PAS,x_angle		rotation de PAS degr‚s entre chaque pos, axe X
	ADD	#2*PAS,y_angle		idem, axe Y
	dbf	d7,ici

	CLR	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE	#5,-(SP)
	TRAP	#14
	ADDA.L	#12,SP
	
               CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP


	MOVE.L	#BUFFERSCR,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1

	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

               move           #$666,$ffff8240.w
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	ANDI.B	#%11111000,$484.W

	CLR.L	CNTE
	CLR.L	Y_VALUE
	CLR.L	X_VALUE2
	CLR.L	FLAG	
	MOVE.L	#1,X_VALUE
	MOVE.L         #COLORS,PNT_COLOR
	MOVE.L	#COLO,PNTCOL
	
	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
               MOVEM.L	FOND+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
               MOVE.W         #0,POIROT1
	MOVE.W         #0,POIROT2
	CLR.L	CNT
	MOVE.L	#NB_POS-2,CNT2
		
;	LEA	DATA_X,A0
	LEA	DATA_Y,A1
	LEA	DATA_Y+(NB_PTS*(NB_POS-2)*2),A3
	MOVE.L	SCREEN1,A2

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W
	MOVE.L	$120.W,ANC_TB
	MOVE.L	#TB0_IR,$120.W
	MOVEQ	#1,D0
	JSR	MUZAXX
	
;******************* DEGOULINE ECRAN (LOGO HELL) ***************
	MOVE	#$2700,SR
	
	LEA	FOND+34,A1
	MOVE	#199,D2
AFFF	
	MOVE.L	SCREEN1,A0
	LEA	199*160(A0),A0

	MOVE	#199,D1
	MOVE.L	PNT,D3
	SUB	D3,D1
AFF	
	MOVE	#39,D0
AFF_L	MOVE.L	(A1)+,(A0)+
	DBF	D0,AFF_L
	LEA	-320(A0),A0
	LEA	-160(A1),A1
	DBF	D1,AFF
	LEA	160(A1),A1
	ADDQ.L	#1,PNT
	DBF	D2,AFFF
	
	MOVE	#$2300,SR               
;*********************************************************               
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W
	MOVE.B	#$12,$FFFFFC02.W
	DC.W	$A00A
	bsr            PREP_GRF
	lea	TEXTE,a0	
	move.l	a0,MEM_LET
	CLR.L	FLAG_VBL
	CLR.L	BIDON

BOUCLE	CMPI.L	#0,FLAG_VBL
	BEQ.S	BOUCLE
	MOVE.L	#VBL2,$70.W
	;MOVE.L	#TB0_IR,$120.W

BOUCLE2	JMP	BOUCLE2

FIN	MOVE.L	ANC_VBL,$70.W
               MOVE.L	ANC_TB,$120.W

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W

	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W

	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

	
*	routines STMAG

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
	
	lea depla,a3
	move.w (a3)+,d3	;xdep
	move.w (a3)+,d4	;ydep
	move.w (a3)+,d5	;zdep
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

* routine perso
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
	MULU	#6,D0
	JSR	0(A0,D0.W)

	CMPI	#110,ZA
	BGT.S	PLD
	BRA.S	NOPLD
PLD	ADD	#2,D1
NOPLD	MOVE	D1,(A2)+
	RTS


KK	MOVE.B	#%10000000,(A1)+
	RTS
	MOVE.B	#%01000000,(A1)+
	RTS
	MOVE.B	#%00100000,(A1)+
	RTS	
	MOVE.B	#%00010000,(A1)+
	RTS	
	MOVE.B	#%00001000,(A1)+
	RTS	
	MOVE.B	#%00000100,(A1)+
	RTS
	MOVE.B	#%00000010,(A1)+
	RTS
	MOVE.B	#%00000001,(A1)+
	RTS
;*************************** TIMER B(ECRAN1)*************
	
TB0_IR	MOVE.W         #$530,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			
TB1_IR	MOVE.W         #$420,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB2_IR	MOVE.W         #$310,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3_IR	MOVE.W         #$210,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB4_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
TB4_IR	MOVE.W         #$530,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB5_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			
TB5_IR	MOVE.W         #$420,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB6_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB6_IR	MOVE.W 	#$310,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#7,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB7_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
		
TB7_IR	MOVE.W  	#$210,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB8_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
		
TB8_IR	MOVE.W  	#$500,$FFFF8240.W
               MOVE.W  	#$666,$FFFF8246.W	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB9_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
		
TB9_IR         CLR	$FFFF8240.W
	CLR.B          $FFFFFA1B.W
               MOVE.B         #151,$FFFFFA21.W
               MOVE.B         #8,$FFFFFA1B.W		
               LEA.L          $FFFF8240.W,A6
               MOVEA.L        #FOND1+2,A5
               REPT  8
               MOVE.L         (A5)+,(A6)+
               ENDR
               MOVE.W         #$666,$FFFF8242.W
               MOVE.W         #$310,$FFFF8244.W
               MOVE.W         #$000,$FFFF8248.W
              ; move.w	#$000,$FFFF824C.W
              ; MOVE.W	#$000,$ffff8256.w	
	MOVE.L         #TB10_IR,$120
	BCLR           #0,$FFFFFA0F.W
	MOVEM.L	D0-A6,-(SP)
	
	MOVE.L         PNT_COLOR,A3
	CMPI.W         #-1,(A3)
	BEQ.S          F
	BNE.S          AGAIN1
	
F	MOVE.L         #COLORS,PNT_COLOR
               BRA.S          BLA
	
AGAIN1         MOVE.L         (A3)+,$FFFF8244.W
               MOVE.L         A3,PNT_COLOR
               MOVE.W         #$666,$FFFF8242.W
               MOVE.W         #$333,$FFFF8246.W
               
              ; MOVEM.L	(SP)+,D0-A6
BLA            CLR            $FFFF8240.W
               MOVEM.L	(SP)+,D0-A6
                          	
	RTE
	
TB10_IR	MOVE.W         #$500,$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB11_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE		

TB11_IR         CLR	$FFFF8240.W
	 CLR.B         $FFFFFA1B.W
                MOVE.B        #52,$FFFFFA21.W
                MOVE.B        #8,$FFFFFA1B.W		
                LEA.L         $FFFF8240.W,A6
                MOVEA.L       #FOND1+2,A5
                REPT  8
                MOVE.L        (A5)+,(A6)+
                ENDR
                MOVEM.L	 D0-A6,-(SP)
                MOVE.L         PNTCOL,A3
	 CMPI.W         #-1,(A3)
	 BEQ.S          F1
	 BNE.S          AGAIN2
	
F1	 MOVE.L         #COLO,PNTCOL
                BRA.S          BLA1
	
AGAIN2         MOVE.L         (A3)+,$FFFF8250.W
               MOVE.L         A3,PNTCOL
               
              ; MOVEM.L	(SP)+,D0-A6
BLA1           CLR            $FFFF8240.W
               MOVEM.L	(SP)+,D0-A6
                move.l	#$210,$ffff8242.w
	 MOVE.L        #TBF_IR,$120
	 BCLR          #0,$FFFFFA0F.W
	 RTE	
TBF_IR
     REPT 127
     NOP				
     ENDR
     MOVE.B	#0,$FFFF820A.W
     REPT 8
     NOP				
     ENDR
     MOVE.B	#2,$FFFF820A.W
     CLR.B	$FFFFFA1B.W
     MOVE.L	#TB0_IR,$120.W		
     BCLR	#0,$FFFFFA0F.W
     RTE				

VBLR
               CLR            $FFFF8240.W
               CLR.B          $FFFFFA1B.W
	MOVEM.L	FOND+2,D1-D7/A0
	MOVEM.L	D1-D7/A0,$FFFF8240.W
               ADDQ.L	#1,BIDON
               ;CMPI.B	#$2,$FFFFFC02.W		*80
 	;BNE.S	PAS_FIN
               CMPI.L	#50*3,BIDON
               BNE.S	RIENDUTOUT
               JSR	CLS
               MOVE.L	#1,FLAG_VBL
RIENDUTOUT	RTE

VBL2
               CLR	$FFFF8240.W
               CLR.B          $FFFFFA1B.W
;******************** OVERSCAN HAUT *******************               
               MOVE.L         #$58C,D0
P              DBF            D0,P
               REPT           5*5
                NOP
               ENDR
               MOVE.B         #0,$FFFF820A.W
               REPT           18
               NOP
               ENDR
               MOVE.B         #2,$FFFF820A.W
               
;*************** EXECUTION ROUTINE TIMER B *************               
              ; CLR.B	$FFFFFA1B.W
	;MOVE.B	#1,$FFFFFA21.W
	;MOVE.B	#8,$FFFFFA1B.W
	;BCLR	#0,$FFFFFA0F.W
;*******************************************************
	CMPI.B         #$42,$FFFC02
	BEQ            BLANC
	BRA.S          SUIT              
BLANC          move           #$777,$ffff8240         ;CA C'EST POUR
	                                        ;IMAGE
SUIT	ADDQ.L         #1,BIDON
	CMPI.L         #50*3,BIDON
	BEQ            EFF1
	BNE            SUI
EFF1          
              ; BSR            CLS
	
SUI	CMPI.L         #50*4,BIDON
               BEQ            IMAGE
               BNE            SUI1
IMAGE          
               BSR            IM1
                              
SUI1	BLO            POPO
;***********************************************
               CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
;***********************************************
	MOVEM.L	D0-A6,-(SP)
	ADDQ.L	#1,CNTE              ;ROUTINE QUI ECRIT
	CMPI.L	#4,CNTE              ;LE TEXTE
	BNE	POPO2 
	BSR	TEST_LET            ; 
	CLR.L	CNTE
POPO2	
	MOVEM.L	(SP)+,D0-A6
;**************************************
               
              

	CMPI.L         #50*28,BIDON
               BLO            E
;**********************************************               
	MOVEA.L	SCREEN1,A2
	ADDQ.L	#1,CNT2

	CMPI.L	#NB_POS,CNT
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
	
	REPT	NB_PTS	effacage
	MOVE	(A3)+,D1
	MOVE.B	D0,0(A2,D1.W)
	ENDR

	REPT	NB_PTS	affichage
	MOVE.B	(A0)+,D0
	MOVE	(A1)+,D1
	OR.B	D0,0(A2,D1.W)
	ENDR
;*******************************************************		
E	CMPI.L         #50*30,BIDON
	BLO            POPO
	
	MOVEM.L	D0-A6,-(SP)
	BSR SCROLL
               BSR AFF_FNT
               MOVEM.L	(SP)+,D0-A6
               
POPO           

               
               CMPI.L         #50*31,BIDON
               BLO            JOJO
;*********               
               MOVEM.L	D0-A6,-(SP)
               JSR            MUZAXX+2
               ;bsr	EQUA
               MOVEM.L	(SP)+,D0-A6
;*********               
               
JOJO           

	move          #$000,$ffff8240
;**************  SORTIE VBL ************************               

	;CMPI.L	#77*50,BIDON
	CMPI.B	#$39,$FFFFFC02.W		*80
 	BNE.S	PAS_FIN
 	
 	MOVEM.L	D0-A6,-(SP)
               lea	TEXT2,a0	
	move.l	a0,MEM_LET1
	;BSR            PREP_GRF
	MOVEM.L	(SP)+,D0-A6
 	MOVE.L	#VBL3,$70.W
 	MOVE.L	#TB,$120.W
PAS_FIN	RTE

VBL3           CLR            $FFFF8240.W
               CLR.B          $FFFFFA1B.W
               MOVE.L         #$58C,D0
PZ1            DBF            D0,PZ1
               REPT           5*5
                NOP
               ENDR
               MOVE.B         #0,$FFFF820A.W
               REPT           18
               NOP
               ENDR
               MOVE.B         #2,$FFFF820A.W
               
               CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
               
               MOVEM.L	D0-A6,-(SP)
	MOVEM.L	FOND1+2,D1-D7/A0
	MOVEM.L	D1-D7/A0,$FFFF8240.W
	MOVEM.L	(SP)+,D0-A6
	
        	MOVE	#$666,$FFFF8242.W
        	MOVE	#$666,$FFFF8246.W
        	;MOVEM.L	D0-A6,-(SP)
               ;JSR     	MUZAXX+2
               ;MOVEM.L	(SP)+,D0-A6
;***********************************
	MOVEA.L	SCREEN1,A2
	ADDQ.L	#1,CNT2

	CMPI.L	#NB_POS,CNT
	BNE.S	L1

	LEA	DATA_X,A0
	LEA	DATA_Y,A1
	clr.l	CNT
L1
	CMPI.L	#NB_POS,CNT2
	BNE.S	L3

	LEA	DATA_Y,A3
	CLR.L	CNT2
L3
	ADDQ.L	#1,CNT

	MOVEQ	#0,D0
	
	REPT	NB_PTS	effacage
	MOVE	(A3)+,D1
	MOVE.B	D0,0(A2,D1.W)
	ENDR

	REPT	NB_PTS	affichage
	MOVE.B	(A0)+,D0
	MOVE	(A1)+,D1
	OR.B	D0,0(A2,D1.W)
	ENDR
	
	MOVEM.L	D0-A6,-(SP)        
	ADDQ.L	#1,CNTE              ;ROUTINE QUI ECRIT
	CMPI.L	#4,CNTE              ;LE TEXTE
	BNE	POP 
	BSR	TEST_LET            
	CLR.L	CNTE
	
POP            MOVEM.L	(SP)+,D0-A6
               MOVEM.L	D0-A6,-(SP)
	BSR 	SCROLL1
               JSR	 AFF1
               MOVEM.L	(SP)+,D0-A6
        	MOVE	#$666,$FFFF8242.W
END            
	 MOVEM.L	D0-A6,-(SP)
               JSR     	MUZAXX+2
               JSR	EQUA
               MOVEM.L	(SP)+,D0-A6
               CMPI.B	#$1,$FFFFFC02.W
	BEQ	FIN
	RTE
;********************** TIMER B (ECRAN 2) *************	
	
TB	MOVE.W         #$530,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			
TB1	MOVE.W         #$420,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB2	MOVE.W         #$310,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3	MOVE.W         #$210,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB4,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
TB4	MOVE.W         #$530,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB5,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			
TB5	MOVE.W         #$420,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB6,$120
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB6	MOVE.W 	#$310,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#7,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB7,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
		
TB7	MOVE.W  	#$210,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB8,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
		
TB8	MOVE.W  	#$500,$FFFF8240.W
               MOVE.W  	#$666,$FFFF8246.W	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB9,$120
	BCLR	#0,$FFFFFA0F.W
	RTE
		
TB9         	CLR	$FFFF8240.W
	CLR.B          $FFFFFA1B.W
               MOVE.B         #151,$FFFFFA21.W
               MOVE.B         #8,$FFFFFA1B.W		
               LEA.L          $FFFF8240.W,A6
               MOVEA.L        #FOND1+2,A5
               REPT  8
               MOVE.L         (A5)+,(A6)+
               ENDR
               MOVE.W         #$666,$FFFF8242.W
               MOVE.W         #$000,$FFFF8244.W
              ; MOVE.W	#$310,$FFFF8248.W
              ; MOVE.W	#$420,$FFFF8250.W
               MOVE.W         #$333,$FFFF8246.W	
	MOVE.L         #TB10,$120
	BCLR           #0,$FFFFFA0F.W
	RTE
	
TB10	MOVE.W         #$500,$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB11,$120
	BCLR	#0,$FFFFFA0F.W
	RTE		

TB11         CLR	$FFFF8240.W
	 CLR.B         $FFFFFA1B.W
                MOVE.B        #52,$FFFFFA21.W
                MOVE.B        #8,$FFFFFA1B.W		
                LEA.L         $FFFF8240.W,A6
                MOVEA.L       #FOND1+2,A5
                REPT  8
                MOVE.L        (A5)+,(A6)+
                ENDR
                MOVEM.L	 D0-A6,-(SP)
                MOVE.L         PNTCOL,A3
	 CMPI.W         #-1,(A3)
	 BEQ.S          F2
	 BNE.S          AGAIN3
	
F2	 MOVE.L         #COLO,PNTCOL
                BRA.S          BLA2
	
AGAIN3         MOVE.L         (A3)+,$FFFF8250.W
               MOVE.L         A3,PNTCOL
               
              ; MOVEM.L	(SP)+,D0-A6
BLA2           CLR            $FFFF8240.W
               MOVEM.L	(SP)+,D0-A6
                move.l	#$210,$ffff8242.w
	 MOVE.L        #TBF,$120
	 BCLR          #0,$FFFFFA0F.W
	 RTE	
;****************** EQUALISEUR******************	 

EQUA	CLR.L	D0
	CLR.L	D1
	CLR.L	D2
	MOVE.L	SCREEN1,A0
	addq.l	#4,a0
	MOVE.L	A0,A4
	LEA	BUFEQ,A1
	MOVE.L	A1,A2
	MOVE.L	A2,A3
	MOVE.B	#8,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D0
	MOVE.B	#9,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D1
	MOVE.B	#$A,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D2
	LSL.W	#6,D0
	LSL.W	#6,D1
	LSL.W	#6,D2
	ADDA.L	D0,A1
	ADDA.L	D1,A2
	ADDA.L	D2,A3
	LEA	(161*160)(A0),A0
	LEA	(37*160)(A4),A4

	REPT	14

    	MOVE.W	(A1),16(A0)
	MOVE.W	(A1),16(A4)
	MOVE.W	(A1),128(A0)
	MOVE.W	(A1),128(A4)

	MOVE.W	(A2),8(A0)
	MOVE.W	(A2),8(A4)
	MOVE.W	(A2),136(A0)
	MOVE.W	(A2),136(A4)

	MOVE.W	(A3),(A0)
	MOVE.W	(A3),(A4)
	MOVE.W	(A3),144(A0)
	MOVE.W	(A3),144(A4)

	LEA	160(A0),A0
	LEA	-160(A4),A4
	ADDQ.L	#2,A1
	ADDQ.L	#2,A2
	ADDQ.L	#2,A3

	ENDR
	RTS

PREP_GRF	LEA	LIGNE,A0	
	LEA	BUFEQ,A1	
	MOVE.L	#15,D0	
	MOVE.L	#31,D7	
	MOVE.L	#-1,D6
NEW_SPR	MOVE.L	D7,D1	
	MOVE.L	D6,D2	
	CMPI.L	#-1,D1
	BEQ	AFFO
EFF	CLR.W	(A1)+	
	DBRA	D1,EFF	
	CMPI.L	#-1,D2
	BEQ	RECOM
AFFO	MOVE.W	(A0),(A1)+
	DBRA	D2,AFFO	
RECOM	SUBI.L	#2,D7	
	ADDI.L	#2,D6	
	DBRA	D0,NEW_SPR
	MOVE.L	#31,D0
BCL	MOVE.W	(A0),(A1)+
	DBRA	D0,BCL	
	RTS
	 	
	
	
TBF
     	REPT 127
	NOP				
     	ENDR
	MOVE.B	#0,$FFFF820A.W
     	REPT 8
     	NOP				
     	ENDR
	MOVE.B	#2,$FFFF820A.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB,$120.W		
	BCLR	#0,$FFFFFA0F.W
	RTE				
	

TEST_LET	MOVEQ	#0,D0
	LEA	TEXT1,A0	
	ADDA.L	POINT,A0
	LEA	FONT8_8,A1
	CMPI.B	#$FF,(A0)
	BNE.S	SUITTST
	CLR.L	POINT
	LEA	TEXT1,A0
SUITTST	
	CMPI.B	#$D,(A0)
	BNE.S	SUITST2
	ADD.L	#160*8,Y_VALUE
	BRA	POIPOI
SUITST2
	CMPI.B	#$A,(A0)
	BNE.S	SUITST3
	CLR.L	X_VALUE2
	CLR.L	FLAG	
	MOVE.L	#1,X_VALUE
	BRA	POIPOI
	
SUITST3	
	CMPI.B	#$B,(A0)
	BNE.S	SUITST4
	MOVEA.L	SCREEN1,A2
	LEA	160*2(A2),A2           ;LA
	ADDA.L	Y_VALUE,A2
	MOVE.L	#6,D1
LIGNE1	MOVE.L	#27,D0
EFFL	CLR	(A2)
	LEA	8(A2),A2
	DBF	D0,EFFL
	LEA	6(A2),A2
	DBF	D1,LIGNE1
	BRA	POIPOI
	

SUITST4	
	CMPI.B	#$C,(A0)
	BNE.S	SUITST5
	SUB.L	#160*8,Y_VALUE
	BRA	POIPOI
	
SUITST5	MOVE.B	(A0),D0	
	SUBI.B	#32,D0	
	LSL.W	#3,D0	
	ADDA.L	D0,A1
	MOVEA.L	SCREEN1,A2
	LEA	160*2(A2),A2              ;LA AUSSI  
	ADDA.L	Y_VALUE,A2
	ADDA.L	X_VALUE,A2
	
	MOVE.B	(A1)+,(A2)
	MOVE.B	(A1)+,160(A2)
	MOVE.B	(A1)+,160*2(A2)
	MOVE.B	(A1)+,160*3(A2)
	MOVE.B	(A1)+,160*4(A2)
	MOVE.B	(A1)+,160*5(A2)
	MOVE.B	(A1)+,160*6(A2)
	MOVE.B	(A1)+,160*7(A2)
	
	CMPI.L	#1,FLAG
	BEQ.S	OTHER
	ADD.L	#7,X_VALUE
	MOVE.L	#1,FLAG
	BRA.S	GOGO
OTHER	ADD.L	#1,X_VALUE
	CLR.L	FLAG
GOGO	
	ADD.L	#8,X_VALUE2
	CMPI.L	#154*2,X_VALUE2
	BNE.S	POIPOI
	ADD.L	#8*160,Y_VALUE
	MOVE.L	#1,X_VALUE
	CLR.L	X_VALUE2
POIPOI	
	ADDI.L	#1,POINT
	RTS
	
IM             LEA	FOND+34,A0
               MOVEA.L	SCREEN1,A1
               adda.l         #160*36,a1	;36
               MOVE.L	#7999,D1
COPY           MOVE.L	(A0)+,(A1)+
               DBF	D1,COPY
	RTS
               
IM1           
               MOVEA.L       #FOND1+34,A0
               MOVEA.L       #FONT1+34,A2
              ; ADDA.L        #160*86,A2
               MOVEA.L       SCREEN1,A1
               MOVEA.L       SCREEN1,A3
               ADDA.L        #160*37,A3
               adda.l        #160*175,a1               ;176
               MOVE.L        #3400,D1
               MOVE.L        #5600,D2
COPY1          MOVE.L        (A0)+,(A1)+
               DBF           D1,COPY1
COPY2          MOVE.L        (A2)+,(A3)+
               DBF           D2,COPY2               
               RTS
               
CLS            MOVEA.L        SCREEN1,A1
	ADDA.L	#160,A1
               MOVE.L         #7999,D1
CL             CLR.L          (A1)+
               DBF            D1,CL
               RTS 
               
;********************** SCROLLING VERTICAL  *********************               
SCROLL:	

	MOVEA.L  SCREEN1,A1
	LEA.L    160*25(A1),A1
               MOVEA.L  SCREEN1,A0
               LEA.L    160*26(A0),A0  

	REPT           148      
	MOVE.w	2(A0),2(a1)
	MOVE.w	10(A0),10(a1)
	MOVE.w	18(A0),18(a1)
	MOVE.w	26(A0),26(a1)
	MOVE.w	34(A0),34(a1)
	MOVE.w	42(A0),42(a1)
	MOVE.w	50(A0),50(a1)
	MOVE.w	58(A0),58(a1)
	MOVE.w	66(A0),66(a1)
	MOVE.w	74(A0),74(a1)
	MOVE.w	82(A0),82(a1)
	MOVE.w	90(A0),90(a1)
	MOVE.W         98(A0),98(A1)
	MOVE.W         106(A0),106(A1)
	MOVE.W         114(A0),114(A1)
	MOVE.W         122(A0),122(A1)
	MOVE.W         130(A0),130(A1)
	MOVE.W         138(A0),138(A1)
	MOVE.W         146(A0),146(A1)
	MOVE.W         154(A0),154(A1)
	;MOVE.W         160(A0),160(A1)
	;MOVEM.L	D0-D3,(A1)
               LEA.L  160(A0),A0
               LEA.L  160(A1),A1
	ENDR
	rts
AFF_FNT:	
	
	moveA.l	#FONT+34,a2
	moveA.l	MEM_LET,a0
	adda.w	(a0),a2
	moveA.l	SCREEN1,a1
		
	LEA.L          11840(A1),A1
               LEA.L          11840(A1),A1    
	LEA.L          4000(A1),A1
	
        MOVE.W  POIROT1,D0
AJ      ADDA.L  #160,A2
        DBF  D0,AJ
        addq   #1,POIROT1
       ; MOVEM.L	(A2),D0-D7
        
       ; MOVEM.L	D0-D7,(A1)
               MOVE.w	2(A2),2(a1)
	MOVE.w	10(A2),10(a1)
	MOVE.w	18(A2),18(a1)
	MOVE.w	26(A2),26(a1)
	MOVE.w	34(A2),34(a1)
	MOVE.w	42(A2),42(a1)
	MOVE.w	50(A2),50(a1)
	MOVE.w	58(A2),58(a1)
	MOVE.w	66(A2),66(a1)
	MOVE.w	74(A2),74(a1)
	MOVE.w	82(A2),82(a1)
	MOVE.w	90(A2),90(a1)
	MOVE.W         98(A2),98(A1)
	MOVE.W         106(A2),106(A1)
	MOVE.W         114(A2),114(A1)
	MOVE.W         122(A2),122(A1)
	MOVE.W         130(A2),130(A1)
	MOVE.W         138(A2),138(A1)
	MOVE.W         146(A2),146(A1)
	MOVE.W         154(A2),154(A1)
	;MOVE.W         160(A2),160(A1)
               CMPI.W  #41,POIROT1
               BEQ     OTHER1
               BRA.S   FIN_SCR

OTHER1  	MOVE.W  #0,POIROT1
    	addq.l	#2,a0		
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	
FIN_SCR RTS
;********************************************************
SCROLL1:	

	MOVEA.L  SCREEN1,A1
	LEA.L    160*174(A1),A1
               MOVEA.L  SCREEN1,A0
               LEA.L    160*173(A0),A0  

	REPT           148      
	;MOVE.w	-4(A0),-4(a1)
	;MOVE.w	-12(A0),-12(a1)
	;MOVE.w	-20(A0),-20(a1)
	;MOVE.w	-28(A0),-28(a1)
	MOVE.w	-36(A0),-36(a1)
	MOVE.w	-44(A0),-44(a1)
	MOVE.w	-52(A0),-52(a1)
	MOVE.w	-60(A0),-60(a1)
	MOVE.w	-68(A0),-68(a1)
	MOVE.w	-76(A0),-76(a1)
	MOVE.w	-84(A0),-84(a1)
	MOVE.w	-92(A0),-92(a1)
	MOVE.W         -100(A0),-100(A1)
	MOVE.W         -108(A0),-108(A1)
	MOVE.W         -116(A0),-116(A1)
	MOVE.W         -124(A0),-124(A1)
	MOVE.W         -132(A0),-132(A1)
	;MOVE.W         -140(A0),-140(A1)
	;MOVE.W         -148(A0),-148(A1)
	;MOVE.W         -156(A0),-156(A1)
	
	;MOVE.W         160(A0),160(A1)
	;MOVEM.L	D0-D3,(A1)
               LEA.L  -160(A0),A0
               LEA.L  -160(A1),A1
	ENDR

	rts



AFF1:	
	
	moveA.l	#FONT2+34,a2
	moveA.l	MEM_LET1,A0
	adda.w	(A0),a2
	moveA.l	SCREEN1,a1
		
	LEA.L        4320(A1),A1
              ; LEA.L         11840(A1),A1    
	;LEA.L         4000(A1),A1
	
        MOVE.W  POIROT3,D0
AJ1      ADDA.L  #160,A2
        DBF  D0,AJ1
        addq   #1,POIROT3
       ; MOVEM.L	(A2),D0-D7
        
       ; MOVEM.L	D0-D7,(A1)
               MOVE.w	-4(A2),-4(a1)
	MOVE.w	-12(A2),-12(a1)
	MOVE.w	-20(A2),-20(a1)
	MOVE.w	-28(A2),-28(a1)
	MOVE.w	-36(A2),-36(a1)
	MOVE.w	-44(A2),-44(a1)
	MOVE.w	-52(A2),-52(a1)
	MOVE.w	-60(A2),-60(a1)
	MOVE.w	-68(A2),-68(a1)
	MOVE.w	-76(A2),-76(a1)
	MOVE.w	-84(A2),-84(a1)
	MOVE.w	-92(A2),-92(a1)
	MOVE.W         -100(A2),-100(A1)
	MOVE.W         -108(A2),-108(A1)
	MOVE.W         -116(A2),-116(A1)
	MOVE.W         -124(A2),-124(A1)
	MOVE.W         -132(A2),-132(A1)
	MOVE.W         -140(A2),-140(A1)
	MOVE.W         -148(A2),-148(A1)
	MOVE.W         -156(A2),-156(A1)
	;MOVE.W         160(A2),160(A1)
               CMPI.W  	#199,POIROT3
               BEQ     OTHER2
               BRA.S   FIN_SCR1

OTHER2  	MOVE.W  #0,POIROT3
    	addq.l	#2,A0		
	cmp.w	#$ffff,(A0)
	bne	GO_LET1
	lea	TEXT2,A0
GO_LET1:	move.l	A0,MEM_LET1	
FIN_SCR1	 RTS

	SECTION	DATA
MUZAXX	INCBIN	COUNT.MUS
FOND           INCBIN         GODD1.PI1
FOND1          INCBIN	dks3.PI1
TEXTE:	INCBIN	ESSAI1.TXT
TEXT2:	INCBIN	ESSAI2.TXT
FONT:	INCBIN	bulles.PI1
FONT1:	INCBIN         dd.PI1
FONT2:	INCBIN	ESSAI2.PI1
cos_tab	incbin 	COSIN.DAT	;tables sinus cosinus
sin_tab	equ cos_tab+720


TEXT1	;$D=DESCENDRE
	;$A=RETOUR DEBUT DE LIGNE
	;$C=EFFACER LIGNE
	;$B=REMONTER D'1 LIGNE
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A
	DC.B	"                                     ",$A

	DC.B	"\DKS/ PROUDLY PRESENTS HIS FIRST     ",$A,$D
	DC.B	"PRODUCTION (NO CHANCE FOR YOU,NO ???)",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"YOU WANTED A SCREEN,WELL ORGANIZED   ",$A,$D
                      
	DC.B	",MAYBE BRAINBLASTING,SURELY ORIGINAL.",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"YOU HAVEN'T CHANCE..............     ",$A,$D
	DC.B	"NO,NO,NO DON'T LEAVE NOW..           ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"THAT WAS JUST A UGLY JOKE..           ",$A,$D
                      
	DC.B	"( LIKE ZAPPY'S JOKE..AH,AH )          ",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"SO,\DKS/ (YES, IT'S ME..)IS VERY HAPPY",$A,$D
	DC.B	"TO SEE YOU IN THIS SCREEN CALLED..... ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"          \THE HELL SCREEN/           ",$A,$D
                      
	DC.B	"OK ,OK ,THAT'S A STUPID NAME..        ",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"BLAME ON ME,THAT'S RIGHT.             ",$A,$D
	DC.B	"AND THE SCREEN ISN'T VERY HOT..       ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"BUT,I HOPE YOU FIND IT GOOD...GREAT...",$A,$D
                      
	DC.B	"...BIG...MIGHTY..UNBELIEVABLE..",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"OR JUST NICE.....( NO,ZAPPY, NNIICCE  ",$A,$D
	DC.B	"NOT NAAAAZE ..........)",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"SO, BE CLEVER (PLEASE,BITTE,POR FAVOR)",$A,$D
                      
	DC.B	"WITH A SOLO CODER WITHOUT CREW....    ",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"YA..ICH BIN EIN EINZELGANGER..OH,SORRY",$A,$D
	DC.B	"BUT I FEEL ME ALREADY EUROPEAN..      ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"SO,CREDITS FOR THIS (VERY GOOD)SCREEN",$A,$D
                      
	DC.B	"CODE BY : \DKS/ OF..",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"EUH ??? OF \DKS/..      WHAT ???      ",$A,$D
	DC.B	"CODE BY \DKS/ OF \DKS/???     ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"STUPID NO??..                         ",$A,$D
                      
	DC.B	"BY THE WAY,I'VE NO PROBLEM WITH OTHERS",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"AND I'M VERY PROUD (EUH...MAYBE.... ) ",$A,$D
	DC.B	"GRAPHIXX BY :\DKS/ (IT'S ME AGAIN...) ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"BLOODDY MUZAXX BY : \COUNT ZERO/      ",$A,$D
                      
	DC.B	"(YES,THIS ONE OF ELECTRONICS IMAGE ). ",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"EUH?? WHAT CAN I SAY NOW....          ",$A,$D
	DC.B	"YES,I'M A LAME WRITER (LAME CODER??)  ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"AH,I'VE A GOOD IDEA..                 ",$A,$D
                      
	DC.B	"I BEGIN.",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"WHEN I WAS 2 YEARS OLD..EUH??.....NO  ",$A,$D
	DC.B	"THAT'S BORING.....                    ",$A,$C
               DC.B	"                                      ",$A,$D
               DC.B	"                                      ",$A,$C
               
               DC.B	"AH...YEAH!!! THE GREETINGS,OF COURSE  ",$A,$D
                      
	DC.B	"(NOT ORIGINAL,BUT GOOD ANYWAY ..)",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"SO I WANT TO GREET :    ",$A,$D
	DC.B	"\DKS/ (A VERY COOL GUY,GREAT CODER.. ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"..BIG PLAYBOY...AN ANGEL)   ",$A,$D
                      
	DC.B	"THE MEMBERS OF THE FAMOUS CREW...... ",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"     \HOLOCAUST/ (STRANGE NAME??)    ",$A,$D
	DC.B	"SPECIALLY \ZAPPY/ (YES,THIS ONE) AND ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"\ELRIC/ (FULL BEAR).....             ",$A,$D
                      
	DC.B	"THEY ARE VERY GOOD CODERS,COOL GUYS..",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"(CF \CHOICE OF GODS/ ,A BRAINBLASTING",$A,$D
	DC.B	"FRENCH DEMO )AND GOOD FRIENDS ... ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"HEY!!ZAPPY,HOW DO YOU FIND THIS??   ",$A,$D
                      
	DC.B	"LAME..NO???   ",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"I WANT TO GREET TOO:     ",$A,$D
	DC.B	"\JOKER/ AND \BOSS/ (EX-MEMBER ZUUL)  ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"\JOJO/,\XYLOPHENE/,\ZETTE/,\BEBERE/, ",$A,$D
                      
	DC.B	"AND THE OTHERS....",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"NOW,THE NORMAL AND SPECIAL GREETINGS: ",$A,$D
	DC.B	"\DKS/ (APPLAUSE),\OVERLANDERS/,\TCB/, ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"\NEXT/,\UNDEAD/,\ZUUL/,\MAD VISION/ ",$A,$D
                      
	DC.B	",\LEGACY/,\LOST BOYS/,\INNER CIRCLE/,",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	",\DKS/ (APPLAUSE),\TSB/,\MASTERS/, ",$A,$D
	DC.B	"YES,I GREET MYSELF AND SO????????.. ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"\DKS/(BIG APPLAUSE),\FIRE HAWKS/..  ",$A,$D
                      
	DC.B	"\FUZION/,\AUTOMATION/,\G FORCE/..",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"\REPLICANTS/,\ULM/,\FUTURE MINDS/..  ",$A,$D
	DC.B	"\DKS/ ( HYSTERIA.. ),\BLACK PANTHERS/",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"\CRUSADERS/,\PULSIONS/,\ST CONNEXION/",$A,$D
                      
	DC.B	",\BMT/,\THE ALLIANCE/,\ACF/..........",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"\DKS/ (..SUICIDE..),\BEVERLY/..     ",$A,$D
	DC.B	"\THALION/,\STYWOX/,\DUNE/,\PULSAR/, ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"\RAIDER BROTHERS/,\DMA/,\CHAOS/,\TPT/,",$A,$D
                      
	DC.B	"AND ALL I'VE FORGOTTEN..SORRY..       ",$A,$C
	DC.B	"                                      ",$A,$D
	DC.B	"                                      ",$A,$C
	DC.B	"NOW, I WANT TO GREET ALL HARD ROCK    ",$A,$D
	DC.B	"MUSICIANS ( REAL MUSICIANS I SAID ..  ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"YES,THRASH MUSICIANS (NOT FM-MUSICIANS)",$A,$D
                      
	DC.B	":\METALLICA/,\GUN'S'N'ROSES/,\PANTERA/",$A,$C
	DC.B	"                                        ",$A,$D
	DC.B	"                                        ",$A,$C
	DC.B	",\ATHEIST/ (DEATH METAL),\ANTHRAX/....  ",$A,$D
	DC.B	"\LOUDBLAST/,\TESTAMENT/,\EGOINE/..",$A,$C
               DC.B	"                                        ",$A,$D
               DC.B	"                                        ",$A,$C
               
               DC.B	"\ANNIHILATOR/,AND THE OTHERS...         ",$A,$D
                      
	DC.B	"                                      ",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"AND NOW THE BIG QUESTION:     ",$A,$D
	DC.B	"WHAT DO YOU THINK ABOUT POLLUTION?   ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"EUH??,THAT'S A HORRIBLE MISTAKE,I BEG",$A,$D
                      
	DC.B	"YOUR PARDON..",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"WHAT DO YOU THINK ABOUT THE  \FALCON/",$A,$D
	DC.B	"OF ATARI?? ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"VERY GOOD NO??   ",$A,$D
                      
	DC.B	"YOU THINK IT'S ALL,YOU'RE SO RIGHT...",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"BUT I HOPE THE NEXT SCREEN WILL BE   ",$A,$D
	DC.B	"BETTER THAN THAT (YES,THAT'S POOR..) ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	"IN FACT,I'VE A LOT OF PROCESSOR TIME ",$A,$D
                      
	DC.B	"LEFT BUT I HAVEN'T ANY IDEA..",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
	DC.B	"SO,I CAN NOW SAY:     ",$A,$D
	DC.B	"??                               ",$A,$C
               DC.B	"                                     ",$A,$D
               DC.B	"                                     ",$A,$C
               
               DC.B	" GGGGGGOOOOOOOODDDDDDBBBBBYYYYYEEE!!! ",$A,$D
                      
	DC.B	"YES,   GGGGOOOODDDDBBBBYYYYEEEE!!!!   ",$A,$C
	DC.B	"                                     ",$A,$D
	DC.B	"                                     ",$A,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$C
;	DC.B	$B,$B,$A

	DC.B	$FF
LIGNE	DC.W	%01111110
FONT8_8	
	DC.B	0,0,0,0,0,0,0,0
	DC.B           24,24,48,48,0,96,96,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B 24,24,48,0,0,0,0,0
	DC.B 24,56,48,48,48,56,24,0
	DC.B 48,56,24,24,24,56,48,0
	DC.B 18,84,56,254,56,84,144,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B 0,0,0,0,48,48,96,0
	DC.B 0,0,0,126,126,0,0,0
	DC.B 0,0,0,0,0,48,48,0
	DC.B 254,0,252,0,248,0,240,0
	DC.B 124,198,206,214,230,198,124,0
	DC.B 24,56,56,24,24,60,60,0
 DC.B 60,94,102,12,24,54,126,0
 DC.B 126,126,6,28,6,126,124,0
 DC.B 28,60,108,204,254,254,12,0
 DC.B 126,126,64,124,6,126,124,0
 DC.B 60,102,96,124,102,102,60,0
 DC.B 126,118,76,12,24,24,24,0
 DC.B 60,102,102,60,102,102,60,0
 DC.B 60,102,102,62,6,6,60,0
 DC.B 0,0,48,48,0,48,48,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
 DC.B 60,102,102,12,0,24,24,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	24,56,56,76,124,140,206,0	;A
	DC.B	236,102,102,108,102,102,236,0	;B
	DC.B	46,98,224,224,224,98,46,0	;C
	DC.B	236,102,102,102,102,102,236,0	;D
	DC.B	238,98,96,108,96,98,238,0	;E
	DC.B	238,96,96,104,96,96,224,0	;F
	DC.B	46,98,224,238,230,102,44,0	;G
	DC.B	230,102,102,110,102,102,230,0	;H
	DC.B	60,24,24,24,24,24,60,0	;I
	DC.B	30,12,12,12,12,76,104,0	;J
 	DC.B	230,100,104,124,110,102,230,0	;K
	DC.B	240,96,96,96,96,98,238,0	;L
	DC.B	198,110,190,150,134,134,206,0	;M
	DC.B	198,98,178,154,140,134,194,0	;N
	DC.B	108,198,198,198,198,198,108,0	;O
	DC.B	236,102,102,108,96,96,224,0	;P
	DC.B	108,198,198,198,198,198,106,0	;Q
	DC.B	236,102,102,108,104,100,230,0	;R
	DC.B	110,194,240,60,14,134,236,0	;S
	DC.B	126,90,24,24,24,24,60,0	;T
	DC.B	246,98,98,98,98,98,28,0	;U
	DC.B	230,98,100,52,52,24,24,0	;V
	DC.B	230,194,194,210,250,236,198,0	;W
	DC.B	198,98,52,60,88,140,198,0	;X
	DC.B	230,98,52,24,24,24,60,0	;Y
	DC.B	246,142,28,56,112,226,222,0	;Z
	
	
	
	DC.B	0,0,0,0,0,0,0,0
 DC.B 254,0,126,0,62,0,30,0
 
 points:	;104 points du cube
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

depla	dc	0,0,0

COLORS         REPT    75
               DC.W    $000
               ENDR
               REPT    20
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $100
               ENDR
               REPT    10
               DC.W    $200
               ENDR
               REPT    560
               DC.W    $300
               ENDR
               REPT    10
               DC.W    $200
               ENDR
               REPT    10
               DC.W    $100
               ENDR
               REPT    10
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $000
               ENDR
               REPT    524
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $100
               ENDR
               REPT    10
               DC.W    $200
               ENDR
               REPT    335
               DC.W    $300
               ENDR
               DC.W    -1
               EVEN

COLO           REPT    75
               DC.W    $000
               ENDR
               REPT    20
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $100
               ENDR
               REPT    10
               DC.W    $210
               ENDR
               REPT    560
               DC.W    $310
               ENDR
               REPT    10
               DC.W    $210
               ENDR
               REPT    10
               DC.W    $100
               ENDR
               REPT    10
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $000
               ENDR
               REPT    524
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $000
               ENDR
               REPT    10
               DC.W    $100
               ENDR
               REPT    10
               DC.W    $200
               ENDR
               REPT    335
               DC.W    $310
               ENDR
               DC.W    -1
               EVEN
               	

	SECTION	BSS
SCREEN1	DS.L	1
SCREEN2        DS.L           1
PNT	DS.L	1
BIDON          DS.L           1
CNTE	DS.L	1
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
POIROT1	DS.W	1			
POIROT2	DS.W	1
POIROT3	DS.W	1
MEM_LET1	DS.W	1	
MEM_LET:	ds.l	1
PART_AFF:	ds.l           1
ANC_PAL	DS.L	8
FLAG	DS.L	1
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
ANC_TB         DS.L           1
POINT	DS.L	1
X_VALUE	DS.L	1
X_VALUE2	DS.L	1
Y_VALUE	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	100400
	DS.B	256
xe	ds.w 0		;coordonnees spatiales
ye	ds.w 0
ze	ds.w 0

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
BUFEQ	DS.W	64*16			;du point de fuite

var_3d	ds.w 9                  ;tableau pour calculs
POINTEUR	DS.L	1

DATA_X
	DS.B	NB_POS*NB_PTS
DATA_Y
	DS	NB_POS*NB_PTS


CNT	DS.L	2
CNT2	DS.L	1
ZA	DS	1		
PNT_COLOR      DS.L           1
FLAG_VBL	DS.L	1
PNTCOL	DS.L	1

