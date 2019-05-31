NB_PTS=50
NB_SEG=NB_PTS/2
PAS=3
NB_POS=50
NB_POS2=360/PAS

NB_PTSB=54
NB_SEG2=NB_PTSB/2
PASB=2
NB_POSB=50
NB_POS2B=360/PASB

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

	LEA	DEB_BSS,A0
	LEA	END_BSS,A1
DO_IT	CLR.B	(A0)+
	CMP.L	A0,A1
	BNE.S	DO_IT

	MOVEQ	#1,D0
	JSR	ZIK

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	LEA	efecr,A0
	MOVE	#$2079,(A0)+
	MOVE.L	#SCREEN1,(a0)+
	move.l	#$41e87BC0,(a0)+
	move.l	#$70007200,(a0)+
	move.l	#$74007600,(a0)+
	move.l	#$78007a00,(a0)+
	move.l	#$7c007e00,(a0)+
	
	move.l	#$93c995ca,(a0)+
	move.l	#$97cb99cc,(a0)+
	move.l	#$9bcd9dce,(a0)+
	moveq	#0,d0
	move	#24,d0
	move	#197,d2
cod	moveq	#0,d1
	move.l	#$48e87eff,(a0)+
	move	d1,(a0)
	add	d0,(a0)+
	add	#14*4,d1
	move.l	#$48e81eff,(a0)+
	move	d1,(a0)
	add	d0,(a0)+
	sub	#160,d0
	dbf	d2,cod
	move	#$4e75,(a0)

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	LEA	DATA_X,A1
	move	#256,z_pt_fuite
	move.l	#NB_POS2-1,d7
ici	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTS-1,D6
OP1	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,OP1
	ADD	#2*PAS,x_angle
	dbf	d7,ici

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move	#256,z_pt_fuite
	move.l	#NB_POS-1,d7
ici2	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTS-1,D6
OP2	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,OP2
	ADD.L	#NB_PTS*2*2,PNT_GG
	dbf	d7,ici2

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move.l	#NB_PTS*4*NB_POS,PNT_GG
	move	#256,z_pt_fuite
	move.l	#NB_POS2-1,d7
ici3	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTS-1,D6
OP3	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,OP3
	ADD	#2*PAS,y_angle
	dbf	d7,ici3
**************

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	CLR.L	PNT_GG
	move	#256,z_pt_fuite
	move.l	#NB_POSB-1,d7
ici5	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTSB-1,D6
OP5	jsr	sp_to_pl2
	jsr	ROUTINE
	DBF	D6,OP5
	ADD.L	#NB_PTSB*2*2,PNT_GG
	dbf	d7,ici5

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move.l	#NB_PTSB*4*NB_POSB,PNT_GG
	move	#256,z_pt_fuite
	move.l	#NB_POS2B-1,d7
ici6	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTSB-1,D6
OP6	jsr	sp_to_pl2
	jsr	ROUTINE
	DBF	D6,OP6
	ADD	#2*PASB,x_angle
	ADD	#2*PASB,y_angle
	ADD	#2*PASB,z_angle
	dbf	d7,ici6

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move.l	#NB_PTSB*4*NB_POSB,PNT_GG
	move	#256,z_pt_fuite
	move.l	#NB_POSB-1,d7
ici7	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTSB-1,D6
OP7	jsr	sp_to_pl2
	jsr	ROUTINE
	DBF	D6,OP7
	SUB.L	#NB_PTSB*2*2,PNT_GG
	dbf	d7,ici7

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
	MOVE.L	#INTER_RTE,$120.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	CMPI.B	#0,FLAG_FLEXI
	BEQ.S	BOUCLE

	MOVE.L	SCREEN1,A1
	MOVE.L	SCREEN2,A2
	MOVE	#7999,D7
COA	CLR.L	(A1)+
	CLR.L	(A2)+
	DBF	D7,COA
	CLR.L	$FFFF8240.W
	CLR.L	$FFFF8244.W
	CLR.L	$FFFF8248.W
	CLR.L	$FFFF824C.W
	CLR.L	$FFFF8250.W
	CLR.L	$FFFF8254.W
	CLR.L	$FFFF8258.W
	CLR.L	$FFFF825C.W
	move.l	#2,PNTP2
	move.l	#6,PNTP
	move.l	SCREEN1,$44e.w
	CLR.B	COLOR
	CLR.B	FLAG1
	CLR.B	FLAG2
	CLR.B	FLAG3
	CLR.B	FLAG4
	
	LEA	KAT+34,A0
	LEA	BUF,A1
	MOVE	#155,D4
DO_A_LINE
	MOVE	#7,D7
DO_16_PIX
	MOVE	(A0),D0
	MOVE	2(A0),D1
	MOVE	4(A0),D2
	MOVE	6(A0),D3

	MOVE	#15,D5
	MOVE.B	#15,D6
DO_A_WORD
	LEA	KAT+2,A2
	BTST	D6,D0
	BEQ.S	VIDE1
	MOVE.B	#1,FLAG1
VIDE1	BTST	D6,D1
	BEQ.S	VIDE2
	MOVE.B	#1,FLAG2
VIDE2	BTST	D6,D2
	BEQ.S	VIDE3
	MOVE.B	#1,FLAG3
VIDE3	BTST	D6,D3
	BEQ.S	VIDE4
	MOVE.B	#1,FLAG4
VIDE4	JSR	TROUVE_COLOR
	MOVE	D4,-(SP)
	MOVEQ	#0,D4
	MOVE.B	COLOR,D4
	LSL	#1,D4
	ADDA.L	D4,A2
	MOVE	(SP)+,D4
	MOVE	(A2),(A1)+
	CLR.B	COLOR
	CLR.B	FLAG1
	CLR.B	FLAG2
	CLR.B	FLAG3
	CLR.B	FLAG4
	SUBQ.B	#1,D6
	DBF	D5,DO_A_WORD
	LEA	8(A0),A0
	DBF	D7,DO_16_PIX
	LEA	96(A0),A0
	DBF	D4,DO_A_LINE

	move.l SCREEN1,ad_ecran
	addq.l	#4,ad_ecran
	LEA	EMUL_LINEA,A0
	MOVE.L	A0,D0

	move.l a0,lineA_tab

	move.l #pattern,46(a0)
	move #0,50(a0)
	move #0,36(a0)
	move #-1,24(a0)
	move #0,26(a0)
	move #0,28(a0)
	move #0,30(a0)

	move #$2300,sr
	
	bsr text_convert
	
	lea text_buffer_end,a0
	lea text,a1
	lea font,a2
	moveq #0,d0
	move d0,d1
	move #30-1,d7
text_lp:
	move.b (a1)+,d0
	move.b 3(a2,d0.w),-(a0)
	move.b 2(a2,d0.w),-(a0)
	move.b 1(a2,d0.w),-(a0)
	move.b 0(a2,d0.w),-(a0)
	move.b d1,-(a0)
	dbra d7,text_lp
	move.l a1,text_pt

	move.l #data_ads,ad_data_pt
	lea compteurs,a3
	
	bsr construction
	
	lea ad_routines,a0
	move.l 16(a0),a2
	move #-4,(a3)
	move #-20,2(a3)

	
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt

	MOVE.L	#$04450445,$FFFF8244.W
	MOVE.L	#$04450445,$FFFF8248.W
	MOVE.L	#$04450445,$FFFF824C.W
	MOVE.L	#$04450445,$FFFF8250.W
	MOVE.L	#$04450445,$FFFF8254.W
	MOVE.L	#$04450445,$FFFF8258.W
	MOVE.L	#$04450445,$FFFF825C.W

	MOVE	#$223,$FFFF8242.W
	MOVE	#$667,$FFFF8244.W
	MOVE	#$667,$FFFF8248.W
	MOVE	#$333,$FFFF8250.W
	MOVEM.L	D0-A6,SAVEALL

	MOVE.L	#VBL_FLEXI2,$70.W
B	JMP	B

TROUVE_COLOR
	CMPI.B	#1,FLAG4
	BNE.S	FLAG4_OFF
	JSR	FLAG4_ON
FLAG4_OFF	CMPI.B	#1,FLAG3
	BNE.S	FLAG3_OFF
	JSR	FLAG3_ON
FLAG3_OFF	CMPI.B	#1,FLAG2
	BNE.S	FLAG2_OFF
	JSR	FLAG2_ON
FLAG2_OFF	CMPI.B	#1,FLAG1
	BNE.S	FLAG1_OFF
	JSR	FLAG1_ON
FLAG1_OFF	RTS
FLAG4_ON	ADDQ.B	#8,COLOR
	RTS
FLAG3_ON	ADDQ.B	#4,COLOR
	RTS
FLAG2_ON	ADDQ.B	#2,COLOR
	RTS
FLAG1_ON	ADDQ.B	#1,COLOR
	RTS



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
	
	MOVE.L	SAUVE,-(SP)
	MOVE.W 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	

	CLR.W 	-(SP)
	TRAP	#1
	
VBL_IR	
	CLR.B	$FFFFFA1B.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF
	ST	$FFFF8240.W
EF	
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE
	
	REPT	NB_SEG
	LEA	DATA_X,A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace
	ENDR

	LEA	COLORS,A0
	ADDA.L	TIME,A0
	CMPI.B	#-1,2(A0)
	BEQ.S	LETSGO
	CLR.L	PNT
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,TIME2
	CMPI.L	#5,TIME2
	BNE.S	LETSGO
	CLR.L	TIME2
	ADDQ.L	#2,TIME
	
LETSGO	
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#4*2*NB_SEG*(NB_POS+NB_POS2*2),PNT
	BNE.S	NO_P
	
	LEA	COLORS2,A0
	ADDA.L	TIME3,A0
	CMPI.B	#-1,2(A0)
	BEQ.S	LETSGO2
	MOVE.L	#4*2*NB_SEG*(NB_POS+NB_POS2*2-1),PNT
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,TIME4
	CMPI.L	#5,TIME4
	BNE.S	NO_P
	CLR.L	TIME4
	ADDQ.L	#2,TIME3
	BRA.S	NO_P
LETSGO2
	MOVE.L	#VBL_IR2,$70.W
	CLR.L	PNT
	CLR.L	TIME
	CLR.L	TIME2
	CLR.L	TIME3
	CLR.L	TIME4
NO_P	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
INTER_RTE	RTE

VBL_IR2
	CLR.B	$FFFFFA1B.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF2
	ST	$FFFF8240.W
EF2
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE

	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	
	REPT	NB_SEG2
	LEA	DATA_X,A0
	ADDA.L	#4*2*NB_SEG*(NB_POS+NB_POS2*2),A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace
	ENDR
	
	LEA	COLORS,A0
	ADDA.L	TIME,A0
	CMPI.B	#-1,2(A0)
	BEQ.S	LETSG
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,TIME2
	CMPI.L	#5,TIME2
	BNE.S	LETSG
	CLR.L	TIME2
	ADDQ.L	#2,TIME
LETSG

	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#4*2*NB_SEG2*(NB_POS2B+NB_POSB*2),PNT
	BNE.S	NO_P2

	MOVE.L	#4*2*((4*50)-1)),PNT
	MOVE.L	#VBL_INTERM,$70.W
	CLR.L	TIME
	CLR.L	TIME2
	CLR.L	TIME3
	CLR.L	TIME4
NO_P2	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE


VBL_INTERM
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF_CADRE0
	ST	$FFFF8240.W
EF_CADRE0	
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	REPT	4
	LEA	CADRE,A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	SUB.L	#4*2,PNT
	jsr	trace
	ENDR

	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#0,PNT
	BGE.S	CONTINUE0
	
	MOVE.L	#VBL_INTER,$70.W
	CLR.L	PNT
CONTINUE0	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$1,$FFFFFC02.W
	BEQ	FIN
	RTE


VBL_INTER	MOVE.L	#VBL_INTER2,$70.W
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE
VBL_INTER2	MOVE.L	#VBL_HC,$70.W
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE



VBL_HC
	CLR.B	$FFFFFA1B.W
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR

	MOVE.L	SCREEN2,A0
	LEA	2(A0),A0
	JSR	EFFACE
	
	MOVE.L	SCREEN2,A0
	LEA	82(A0),A0
	JSR	EFFACE

	MOVE.L	SCREEN2,A0
	LEA	160*100+2(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100(A0),A0
	LEA	80+2(A0),A0
	JSR	EFFACE

	REPT	6
	bsr	POLY_
	ENDR

	LEA	FAD_HC1,A0
	ADDA.L	PNT_FAD_HC,A0
	MOVE	(A0),$FFFF8244.W

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	JSR	ZIK+4
	SF	$FFFF8240.W
	
	CMPI.L	#6*2,PNT_FAD_HC
	BEQ.S	NO_FAD_HC
	ADDQ.L	#1,PNT_FAD_HC2
	CMPI.L	#4,PNT_FAD_HC2
	BNE.S	NO_FAD_HC
	CLR.L	PNT_FAD_HC2
	ADDQ.L	#2,PNT_FAD_HC
NO_FAD_HC

	CMPI.L	#50,TIME_PASSED
	BEQ.S	GO1
	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	OUTOFDIS
GO1	MOVE.L	#VBL_TRANSFO1,$70.W
	CLR.L	PNT
	CLR.L	TIME_PASSED
OUTOFDIS	RTE

VBL_TRANSFO1
	CLR.B	$FFFFFA1B.W
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR1
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR1

	MOVE.L	SCREEN2,A0
	LEA	2(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	82(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100+2(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100(A0),A0
	LEA	82(A0),A0
	JSR	EFFACE

	REPT	6
	bsr	POLY_1
	ENDR

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	JSR	ZIK+4
	SF	$FFFF8240.W

	CMPI.L	#50,TIME_PASSED
	BEQ.S	GO2
	CMPI.B	#$3B,$FFFFFC02.W
	BNE	POPO
GO2	MOVE.L	#VBL_TRANSFO2,$70.W
	CLR.L	PNT
	CLR.L	TIME_PASSED
POPO	RTE

VBL_TRANSFO2
	CLR.B	$FFFFFA1B.W
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR2
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR2
	move.l	SCREEN2,a0
	LEA	2(A0),A0
	JSR	EFFACE
	move.l	SCREEN2,a0
	LEA	160*100+2(A0),A0
	JSR	EFFACE

	REPT	3
	bsr	POLY_2
	ENDR

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	JSR	ZIK+4
	SF	$FFFF8240.W

	CMPI.L	#5,TIME_PASSED
	BEQ.S	GO3
	CMPI.B	#$3C,$FFFFFC02.W
	BNE	GNY
GO3	CLR.L	PNT
	CLR.L	TIME_PASSED
	MOVE.L	#VBL_TRANSFO3,$70.W
GNY	RTE


VBL_TRANSFO3
	CLR.B	$FFFFFA1B.W
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR3
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR3
	move.l	SCREEN2,a0
	LEA	82(A0),A0
	JSR	EFFACE
	move.l	SCREEN2,a0
	LEA	82(A0),A0
	LEA	160*100(A0),A0
	JSR	EFFACE

	REPT	3
	bsr	POLY_3
	ENDR


	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	JSR	ZIK+4
	SF	$FFFF8240.W

	CMPI.L	#50,TIME_PASSED
	BNE.S	OUTY
	CLR.L	PNT_FAD_HC
	CLR.L	PNT_FAD_HC2
	MOVE.L	#VBLFAD_HCED,$70.W
OUTY	CMPI.B	#$1,$FFFFFC02.W
	BEQ	FIN
	RTE

VBLFAD_HCED
	CLR.B	$FFFFFA1B.W
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F

	LEA	FAD_HC2,A0
	ADDA.L	PNT_FAD_HC,A0
	MOVE	(A0),$FFFF8244.W
	
	ADDQ.L	#1,PNT_FAD_HC2
	CMPI.L	#4,PNT_FAD_HC2
	BNE.S	NOFA
	CLR.L	PNT_FAD_HC2
	CMPI.L	#-2*7,PNT_FAD_HC
	BNE.S	NOFA2
	CLR.L	PNT
	MOVE.L	#VBL_INTERB,$70.W
	
NOFA2	SUBQ.L	#2,PNT_FAD_HC
NOFA	
	JSR	ZIK+4
	RTE
VBL_INTERB	MOVE.L	#VBL_INTERB2,$70.W
	CLR.L	PNT
	JSR	EFECR
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	MOVE.L	SCREEN1,A0
	LEA	2(A0),A0
	JSR	CADRE_F
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE
VBL_INTERB2	MOVE.L	#VBL_CUBE,$70.W
	move	#0,adag1
	move	#2,adag2
	move	#2,adag3
	CLR.L	TIME_CUBE
	MOVE	#2,DONNEE
	MOVE	#-2,DONNEE2
	MOVE	#55,DONNEE3
	MOVE	#-55,DONNEE4
	move.l	#$00000777,$ffff8240.w
	move.l	#$07770777,$ffff8244.w
	move.l	#$07770777,$ffff8248.w
	move.l	#$07770777,$ffff824c.w
	move.l	#$07770777,$ffff8250.w
	move.l	#$07770777,$ffff8254.w
	move.l	#$07770777,$ffff8258.w
	move.l	#$07770777,$ffff825c.w

	move	#$112,$ffff8242.w
	move	#$223,$ffff8244.w
	move	#$334,$ffff8248.w
	move	#$445,$ffff8250.w

	JSR	EFECR
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	MOVE.L	SCREEN1,A0
	LEA	2(A0),A0
	JSR	CADRE_F

	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	RTE

VBL_CUBE
	CMPI	#55,DONNEE
	BGE.S	NO_ZOOM
	ADDQ	#1,DONNEE
	SUBQ	#1,DONNEE2

	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE,D0
	SWAP	D0
	MOVE	DONNEE,D0
	MOVEQ	#0,D1
	MOVE	DONNEE2,D1
	SWAP	D1
	MOVE	DONNEE2,D1

	MOVE.L	D1,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	50,50,-50		3	

	MOVE	D0,(A0)+
	MOVE.L	D1,(A0)+
;	dc.w	50,-50,-50		4

	MOVE.L	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	-50,-50,50		5	

	MOVE	D1,(A0)+
	MOVE.L	D0,(A0)+
;	dc.w	-50,50,50		6	

	MOVE.L	D0,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,50,50		7

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,-50,50		8
	BRA	SUIT_CU
NO_ZOOM	
	ADDQ.L	#1,TIME_CUBE
	CMPI.L	#50*4,TIME_CUBE
	BLE	SUIT_CU
	CMPI.L	#50*12,TIME_CUBE
	BGE	NO_ZOOM2
	CMPI	#4,DONNEE3
	BEQ	NO_ZOOM2
	SUBQ	#1,DONNEE3
	ADDQ	#1,DONNEE4
	
	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE3,D0
	SWAP	D0
	MOVE	DONNEE3,D0
	MOVEQ	#0,D1
	MOVE	DONNEE4,D1
	SWAP	D1
	MOVE	DONNEE4,D1

	MOVE.L	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	50,50,-50		3

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	50,-50,-50		4
	bra	SUIT_CU
	
NO_ZOOM2	ADDQ.L	#1,TIME_CUBE
	CMPI.L	#50*12,TIME_CUBE
	BLE.S	SUIT_CU
	CMPI	#55,DONNEE3
	BEQ.S	SUIT_CU2
;	MOVE	#$070,$FFFF8240.W
	ADDQ	#1,DONNEE3
	SUBQ	#1,DONNEE4
	
	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE3,D0
	SWAP	D0
	MOVE	DONNEE3,D0
	MOVEQ	#0,D1
	MOVE	DONNEE4,D1
	SWAP	D1
	MOVE	DONNEE4,D1

	MOVE.L	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	50,50,-50		3

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	50,-50,-50		4
	BRA.S	SUIT_CU
SUIT_CU2	
;	ADDQ.L	#1,TIME_CUBE
	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	SUIT_CU
;	MOVE	#$070,$FFFF8240.W
	MOVE.L	#VBL_CUBE_FIN,$70.W
	CLR.L	TIME_CUBE
SUIT_CU	

	move.l	SCREEN1,d0
	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
	move.l	d0,SCREEN2
	move.l	d1,SCREEN1

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	PO
	ST	$FFFF8240.W
PO	jsr	ZIK+4
	jsr	efecr
	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	tobj
	bsr	calcrot
	SF	$FFFF8240.W
	*st	$ffff8240.w

	RTE
VBL_CUBE_FIN
	CMPI	#2,DONNEE
	BEQ.S	NO_ZOOM_F
	SUBQ	#1,DONNEE
	ADDQ	#1,DONNEE2

	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE,D0
	SWAP	D0
	MOVE	DONNEE,D0
	MOVEQ	#0,D1
	MOVE	DONNEE2,D1
	SWAP	D1
	MOVE	DONNEE2,D1

	MOVE.L	D1,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	50,50,-50		3	

	MOVE	D0,(A0)+
	MOVE.L	D1,(A0)+
;	dc.w	50,-50,-50		4

	MOVE.L	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	-50,-50,50		5	

	MOVE	D1,(A0)+
	MOVE.L	D0,(A0)+
;	dc.w	-50,50,50		6	

	MOVE.L	D0,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,50,50		7

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,-50,50		8
;	BRA	SUIT_CU
	BRA.S	DF
NO_ZOOM_F
	MOVE.L	#VBL_CUBE2,$70.W	
DF
	move.l	SCREEN1,d0
	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
	move.l	d0,SCREEN2
	move.l	d1,SCREEN1

	jsr	ZIK+4
	jsr	efecr
	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	tobj
	bsr	calcrot
	SF	$FFFF8240.W
	cmp.b	#$1,key
	beq	FIN
	rte

EFECR	
	movea.l	SCREEN1,a0
	
	moveq	#0,d0
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
efecr1	
N	SET	0
	REPT	200
	movem.l	d0-d7/a1-a6,N(a0)
	movem.l	d0-d7/A1-A6,N+4*14(a0)
	movem.l	d0-d7/A1-A4,N+4*14*2(a0)
N	SET	N+160
	ENDR
	RTS

VBL_CUBE2
	LEA	EFECT,A0
	LEA	EFECT2,A1
	ADDA.L	PNT_EFECT,A0
	ADDA.L	PNT_EFECT,A1
	LEA	EFECT,A2
	LEA	EFECT2,A3
	ADDA.L	PNT_EFECT,A2
	ADDA.L	PNT_EFECT,A3
	LEA	100(A2),A2
	LEA	100(A3),A3
	CMPI	#-1,200(A0)
	BNE.S	ROULE
	CLR.L	PNT_EFECT
	LEA	EFECT,A0
	LEA	EFECT2,A1
	LEA	EFECT,A2
	LEA	EFECT2,A3
	LEA	100(A2),A2
	LEA	100(A3),A3
ROULE	
	ADDQ.L	#2,PNT_EFECT
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5

	MOVE	(A0),D0
	SWAP	D0
	MOVE	(A0),D0
	
	MOVE	(A1),D1
	SWAP	D1
	MOVE	(A1),D1

	MOVE	(A2),D2
	SWAP	D2
	MOVE	(A2),D2
	MOVE	100(A2),D4
	SWAP	D4
	MOVE	100(A2),D4

	MOVE	(A3),D3
	SWAP	D3
	MOVE	(A3),D3
	MOVE	100(A3),D5
	SWAP	D5
	MOVE	100(A3),D5


	LEA	tpoitesp1,A0
	LEA	2(A0),A0

	MOVE	D5,(A0)+
	MOVE	D3,(A0)+
;	LEA	4(A0),A0
	MOVE	D1,(A0)+
;	dc.w	-50,-50,-50		1

	MOVE	D5,(A0)+
	MOVE	D2,(A0)+
;	LEA	4(A0),A0
	MOVE	D1,(A0)+
;	dc.w	-50,50,-50		2

	MOVE	D4,(A0)+
	MOVE	D2,(A0)+
;	LEA	4(A0),A0
	MOVE	D1,(A0)+
;	dc.w	50,50,-50		3	

	MOVE	D4,(A0)+
	MOVE	D3,(A0)+
;	LEA	4(A0),A0
	MOVE	D1,(A0)+
;	dc.w	50,-50,-50		4


	MOVE.L	D3,(A0)+
;	LEA	4(A0),A0
	MOVE	D0,(A0)+
;	dc.w	-50,-50,50		5	

	MOVE	D3,(A0)+
	MOVE	D2,(A0)+
;	LEA	4(A0),A0
	MOVE	D0,(A0)+
;	dc.w	-50,50,50		6	

	MOVE.L	D2,(A0)+
;	LEA	4(A0),A0
	MOVE	D0,(A0)+
;	dc.w	50,50,50		7

	MOVE	D2,(A0)+
	MOVE	D3,(A0)+
;	LEA	4(A0),A0
	MOVE	D0,(A0)+
;	dc.w	50,-50,50		8


	move.l	SCREEN1,d0
	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
	move.l	d0,SCREEN2
	move.l	d1,SCREEN1
	
	jsr	ZIK+4
	jsr	efecr
	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	tobj
	bsr	calcrot
	SF	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	YOGA
	MOVE.L	#VBL_INTERC,$70.W
YOGA	cmp.b	#$1,key
	beq	FIN
	rte

	
VBL_INTERC	MOVE.L	#VBL_INTERC2,$70.W
	CLR.L	PNT
	move	#$777,$ffff8242.w
	JSR	EFECR
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE
VBL_INTERC2	MOVE.L	#VBL_CADRE,$70.W
	JSR	EFECR
	MOVE.L	SCREEN1,A0
	JSR	CADRE_F
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	RTE
	
VBL_CADRE
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF_CADRE
	ST	$FFFF8240.W
EF_CADRE	
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	REPT	4
	LEA	CADRE,A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace
	ENDR

	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#4*2*4*51,PNT
	BNE.S	CONTINUE
	
	MOVE.L	#VBL_INTER3,$70.W
	
CONTINUE	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$1,$FFFFFC02.W
	BEQ	FIN
	RTE
VBL_INTER3	MOVE.L	#VBL_INTER4,$70.W
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE
VBL_INTER4	MOVE.L	#VBL_EXPLO,$70.W
	MOVE.L	SCREEN1,A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN1,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE
	JSR	ZIK+4
	CLR.L	PNT
	MOVE.L	#200*(80-3),PNT2
	MOVE.L	#$07770777,$FFFF8244.W
	MOVE.L	#$07770777,$FFFF8248.W
	MOVE.L	#$07770777,$FFFF824C.W
	MOVE.L	#$07770777,$FFFF8250.W
	MOVE.L	#$07770777,$FFFF8254.W
	MOVE.L	#$07770777,$FFFF8258.W
	MOVE.L	#$07770777,$FFFF825C.W

	MOVE	#$111,$FFFF8242.W
	MOVE	#$333,$FFFF8244.W
	MOVE	#$555,$FFFF8248.W
	MOVE	#$777,$FFFF8250.W

	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	RTE


VBL_EXPLO
	CLR.B	$FFFFFA1B.W

	CMPI.B	#$1,$FFFFFC02.W
	BEQ	NON

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	P
	ST	$FFFF8240.W
P
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	MOVEQ	#0,D2
	LEA	EXPLOY,A1
	ADDA.L	PNT2,A1
	ADDA.L	PNT2,A1
	MOVE.L	SCREEN1,A2
	
	MOVE	#200-1,D0
EFF_PT	MOVE	(A1)+,D1
	MOVE.B	D2,(A2,D1.W)
	MOVE.B	D2,2(A2,D1.W)
	MOVE.B	D2,4(A2,D1.W)
	MOVE.B	D2,6(A2,D1.W)
	DBF	D0,EFF_PT
	
	ADD.L	#200,PNT
	CMPI.L	#200*80,PNT
	BNE.S	OK
	CLR.L	PNT
	MOVE.L	#VBL_FLEXI,$70.W
OK

	ADD.L	#200,PNT2
	CMPI.L	#200*80,PNT2
	BNE.S	OK2
	CLR.L	PNT2
OK2

 	LEA	EXPLOX,A0
	ADDA.L	PNT,A0
	LEA	EXPLOY,A1
	ADDA.L	PNT,A1
	ADDA.L	PNT,A1
	
	MOVE.L	SCREEN1,A2
	ADDA.L	PNTP,A2

	MOVE	#200-1,D0
AFF_PT	MOVE	(A1)+,D1
	MOVE.B	(A0)+,D2
	OR.B	D2,(A2,D1.W)
	DBF	D0,AFF_PT

	MOVE	$FFFF8242.W,D0
	MOVE	$FFFF8244.W,D1
	MOVE	$FFFF8248.W,D2
	MOVE	$FFFF8250.W,D3

	MOVE	D0,$FFFF8244.W
	MOVE	D1,$FFFF8248.W
	MOVE	D2,$FFFF8250.W
	MOVE	D3,$FFFF8242.W
	
	ADDQ.L	#2,PNTP
	CMPI.L	#8,PNTP
	BNE.S	KJ
	CLR.L	PNTP
KJ	
NOTY	
NON	SF	$FFFF8240.W

	MOVE.L	SCREEN1,A0
	CLR.B	160(A0)
	CLR.B	162(A0)
	CLR.B	164(A0)
	CLR.B	166(A0)

	CLR.B	160+153(A0)
	CLR.B	160+155(A0)
	CLR.B	160+157(A0)
	CLR.B	160+159(A0)
	
	CLR.B	160*199(A0)
	CLR.B	160*199+2(A0)
	CLR.B	160*199+4(A0)
	CLR.B	160*199+6(A0)

	JSR	ZIK+4

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

VBL_FLEXI	MOVEM.L	D0-A6,-(SP)
	MOVE.B	#1,FLAG_FLEXI
	JSR	ZIK+4
	MOVEM.L	(SP)+,D0-A6
	MOVE.L	#2*50,PNT_SYNC2	
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
	
VBL_FLEXI2	CLR	$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	CMPI.B	#$50,$FFFFFC02.W
	BNE.S	PASF1
	CMPI.L	#128*2*137,PNT_SYNC
	BGE.S	PASF1
	ADD.L	#128*2,PNT_SYNC
PASF1
	CMPI.B	#$48,$FFFFFC02.W
	BNE.S	PASF2
	CMPI.L	#0,PNT_SYNC
	BLE.S	PASF2
	SUB.L	#128*2,PNT_SYNC
PASF2
	CMPI.B	#$4D,$FFFFFC02.W
	BNE.S	PASF3
	CMPI.L	#87*2,PNT_SYNC2
	BGE.S	PASF3
	ADD.L	#2,PNT_SYNC2
PASF3
	CMPI.B	#$4B,$FFFFFC02.W
	BNE.S	PASF4
	CMPI.L	#0,PNT_SYNC2
	BLE.S	PASF4
	SUB.L	#2,PNT_SYNC2
PASF4

	MOVE	$FFFF8242.W,D0
	MOVE	$FFFF8244.W,D1
	MOVE	$FFFF8248.W,D2
	MOVE	$FFFF8250.W,D3

	MOVE	D0,$FFFF8244.W
	MOVE	D1,$FFFF8248.W
	MOVE	D2,$FFFF8250.W
	MOVE	D3,$FFFF8242.W


	ADDQ.L	#2,PNTP
	CMPI.L	#8,PNTP
	BNE.S	KJVA
	CLR.L	PNTP
KJVA
	ADDQ.L	#2,PNTP2
	CMPI.L	#8,PNTP2
	BNE.S	KJ2
	CLR.L	PNTP2
KJ2;	BRA.S	PLPL
KJJ;	MOVE.L	#1,FLAG
PLPL

	MOVEM.L	SAVEALL,D0-A6
demo_lp:
	
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4
	move.l text_buff_pt,a5

	cmpi.b	#$F,$FFFFFC02.W
	BNE.S	NOTI
	ST	$FFFF8240.W
NOTI
	move.l (a0)+,a1
	move.l SCREEN1,a6
	ADDA.L	PNTP2,A6
	jsr (a1)

	move.l SCREEN1,a6
	ADDA.L	PNTP,A6
	jsr (a2)


	SF	$FFFF8240.W


	addQ #1,(a3)
	bne LAO

	move #-4,(a3)
	lea ad_routines,a0
	sub.l d1,text_buff_pt
	
	addQ #1,2(a3)
	bne LAO
	
	move #-20,2(a3)
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	movem.l 70(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,90(a5)
	movem.l 30(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,50(a5)
	movem.l -10(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,10(a5)
	movem.w -20(a5),d0-d4
	movem.w d0-d4,(a5)
	
	move.l text_pt,a1
	lea font,a6
	moveq #0,d0
	move d0,d1
	move #4-1,d7
text_lp2:
	move.b (a1)+,d0
	cmp #255,d0
	bne.s forme_change_pas
	
	
	addQ.l #4,ad_data_pt
	cmp.b #255,(a1)
	bne.s forme_suivante
	lea text,a1
	move.l #data_ads,ad_data_pt
forme_suivante:
	bsr construction
	move.b (a1)+,d0
	lea ad_routines,a0
	move.l 16(a0),a2
	
forme_change_pas:
	move.b 3(a6,d0.w),-(a5)
	move.b 2(a6,d0.w),-(a5)
	move.b 1(a6,d0.w),-(a5)
	move.b 0(a6,d0.w),-(a5)
	move.b d1,-(a5)
	dbra d7,text_lp2
	move.l a1,text_pt

LAO
	MOVEM.L	D0-A6,SAVEALL
	
	LEA	BUF,A0
	ADDA.L	PNT_SYNC,A0
	ADDA.L	PNT_SYNC2,A0
	LEA	$FFFF8240.W,A1

	MOVE.L	#$FFFF8209,A6
	MOVE.L	#$FFFF8260,A4
	MOVE.L	#$FFFF820A,A3
	MOVEQ	#0,D1
	MOVEQ	#$10,D6
	MOVE	#$2700,SR

	MOVE	#18,D0	20
	
SYNCHRO	MOVE.B	(A6),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6
	LSL.W	D6,D1

	DCB	97,$4E71
	
LINE	
	REPT	11
	DCB	26+15,$3298
	DCB	3,$4E71
	LEA	-41*2(A0),A0
	ENDR
	DCB	26+15,$3298
	LEA	87*2(A0),A0
	DBF	D0,LINE
	CLR	$FFFF8240.W
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	MOVE	#$2300,SR
	JSR	ZIK+4

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

CADRE_F	
N	SET	0
	REPT	20
	MOVE	#$FFFF,N(A0)
N	SET	N+8
	ENDR
N	SET	160
	REPT	198
	MOVE.B	#%10000000,N(A0)
	MOVE.B	#1,153+N(A0)
N	SET	N+160
	ENDR
N	SET	160*199
	REPT	20
	MOVE	#$FFFF,N(A0)
N	SET	N+8
	ENDR
	RTS

trigo	movem.l d0-d7/a4-a6,-(a7)

	lea cos_tab,a4
	lea sin_tab,a5

	lea x_angle,a6
	move.w (a6)+,d2
	move.w (a6)+,d1
	move.w (a6)+,d0
	
	move.w 0(a5,d2.w),d5
	move.w 0(a4,d2.w),d4
	move.w 0(a5,d1.w),d3
	move.w 0(a4,d1.w),d2
	move.w 0(a5,d0.w),d1
	move.w 0(a4,d0.w),d0

	lea var_3d,a6

	moveq #9,d7
	
sp_c	move.w d3,d6
	neg.w d6	
	move.w d6,(a6)+
	
sp_f	move.w d2,d6
	muls d5,d6	
	asr.l d7,d6	
	move.w d6,(a6)+
	
sp_i	move.w d2,d6	
	muls d4,d6	
	asr.l d7,d6	
	move.w d6,(a6)+

sp_a	move.w d0,d6	
	muls d2,d6	
	asr.l d7,d6	
	move.w d6,(a6)+

sp_d	move.w d1,d6	
	muls d4,d6	
	asr.l d7,d6	
	movea.w d6,a4	

	move.w d0,d6	
	muls d3,d6	
	asr.l d7,d6	
	muls d5,d6	

	asr.l d7,d6	
	sub.w a4,d6	

	move.w d6,(a6)+	

sp_g	move.w d1,d6	
	muls d5,d6	
	asr.l d7,d6	
	movea.w d6,a4	

	move.w d0,d6	
	muls d3,d6	
	asr.l d7,d6	
	muls d4,d6	

	asr.l d7,d6	
	add.w a4,d6	

	move.w d6,(a6)+	

sp_b	move.w d1,d6	
	muls d2,d6	
	asr.l d7,d6	
	move.w d6,(a6)+

sp_e	move.w d0,d6	
	muls d4,d6	
	asr.l d7,d6	
	movea.w d6,a4	
	
	move.w d1,d6	
	muls d3,d6	
	asr.l d7,d6	
	muls d5,d6	

	asr.l d7,d6	
	add.w a4,d6	

	move.w d6,(a6)+	
	
sp_h	move.w d0,d6	
	muls d5,d6	
	asr.l d7,d6	
	movea.w d6,a4	
	
	move.w d1,d6	
	muls d3,d6	
	asr.l d7,d6	
	muls d4,d6	

	asr.l d7,d6	
	sub.w a4,d6	

	move.w d6,(a6)+	
	
	movem.l (a7)+,d0-d7/a4-a6
	rts


sp_to_pl2 movem.l d0-d7/a1-a6,-(a7)
	
	lea points2,a6
	ADDA.L	PNT_GG,A6
	ADDA.L	POINTEUR,A6
	JMP	SUITE_SP
sp_to_pl movem.l d0-d7/a1-a6,-(a7)
	
	lea points,a6
	ADDA.L	PNT_GG,A6
	ADDA.L	POINTEUR,A6
SUITE_SP	MOVEQ	#0,D0
	MOVEQ	#0,D1
	move.w (a6)+,d0
	move.w (a6)+,d1
;	move.w (a6)+,d2
	MOVEQ	#0,D2
	SUB	#160,D0
	SUB	#100,D1
	ADD.L	#4,POINTEUR
	
;	lea depla,a3
;	move.w (a3)+,d3
;	move.w (a3)+,d4
;	move.w (a3)+,d5
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	ext.l d3
	ext.l d4
	ext.l d5
	moveq #9,d6
	asl.l d6,d3
	asl.l d6,d4
	asl.l d6,d5
	movea.l d3,a1	
	movea.l d4,a2
	movea.l d5,a3
	
	lea var_3d,a6

	move.w d0,d3
	move.w d1,d4
	move.w d2,d5

	muls (a6)+,d3
	muls (a6)+,d4
	muls (a6)+,d5
	add.l d4,d5
	add.l d3,d5
	add.l a3,d5
	move.l d5,a5
	divs z_pt_fuite,d5

	move.w #512,d7
	sub.w d5,d7
	
	move.w d0,d3
	move.w d1,d4
	move.w d2,d5

	muls (a6)+,d3
	muls (a6)+,d4
	muls (a6)+,d5
	add.l d4,d5
	add.l d3,d5
	add.l a1,d5
	move.l d5,a4
	divs d7,d5
	
	muls (a6)+,d0
	muls (a6)+,d1
	muls (a6)+,d2
	add.l d0,d1
	add.l d1,d2
	add.l a2,d2
	move.l d2,d6
	divs d7,d2
	
	lea xp,a6

	add.w #160,d5
	move.w d5,(a6)+
	
	add.w #100,d2
	move.w d2,(a6)+

	move.l a4,d5
	move.l a5,d7
	moveq #9,d0
	asr.l d0,d5
	asr.l d0,d6
	asr.l d0,d7

	move.w d5,(a6)+
	move.w d6,(a6)+
	move.w d7,(a6)+
	MOVE	D7,ZA	
	movem.l (a7)+,d0-d7/a1-a6
	rts

ROUTINE	MOVEQ	#0,D0
	MOVE	xp,D0
	CMPI	#0,D0
	BGT.S	CLIP1
	MOVE	#1,D0
CLIP1	CMPI	#320,D0
	BLT.S	CLIP2
	MOVE	#319,D0
CLIP2	MOVE	D0,(A1)+

	MOVE	yp,D0
	CMPI	#0,D0
	BGT.S	CLIP3
	MOVE	#1,D0
CLIP3	CMPI	#200,D0
	BLT.S	CLIP4
	MOVE	#199,D0
CLIP4	MOVE	D0,(A1)+
	RTS

* ROUTINES ZERIOUL (CUBE)
calcrot
	sub.w	#1,attvbl
	beq.s	calcrots	
	bra	finacal
calcrots
	move.w	#10,attvbl
	moveq	#0,d0
	move.b	key,d0
	
	cmp.w	#7,d0
	bgt.s	finacal
	beq.s	changobj
	subq	#1,d0
	
	lea.l	adag1,a0
	moveq.l	#1,d1
	and.w	d0,d1
	bne.s	suitadcal
	
	sub.w	d1,d0
	add.w	d0,a0
	sub.w	#2,(a0)
	bra.s	finacal
suitadcal
	sub.w	d1,d0
	add.w	d0,a0
	add.w	#2,(a0)
	bra.s	finacal
changobj	
	add.w	#8,numobj
	lea.l	paobj,a0
	add.w	numobj,a0
	move.l	(a0)+,d0	
	bgt.s	schangobj	
	move.w	#-8,numobj
	bra.s	changobj
schangobj	
	move.l	d0,ptchang2+2
	addq.l	#2,d0
	move.l	d0,ptchang1+2
	move.l	(a0),ptchang3+2	
	clr.l	adag1
	clr.w	adag3
	clr.w	ang1
	clr.w	ang2
	clr.w	ang3
finacal	
	move.w	ang1,d0
	add.w	adag1,d0
	and.w	#$1ff,d0
	move.w	d0,ang1
	
	move.w	ang2,d0
	add.w	adag2,d0
	and.w	#$1ff,d0
	move.w	d0,ang2
	
	move.w	ang3,d0
	add.w	adag3,d0
	and.w	#$1ff,d0
	move.w	d0,ang3

	rts


	******************
	*matrix 3axe(zyx)*
	******************
calcpoint	
	lea.l	tsin,a0
	lea.l	128(a0),a1
ang1	equ	*+2
	move.w	#0,d0
ang2	equ	*+2
	move.w	#0,d1
ang3	equ	*+2	
	move.w	#0,d2

	move.w	(a0,d1.w),d3
	neg	d3
	move.w	d3,modf3+2	

	move.w	d0,d3
	sub.w	d1,d3
	add.w	d0,d1

	move.w	(a1,d1.w),d4
	add.w	(a1,d3.w),d4
	asr	d4
	move.w	d4,modf1+2
	
	move.w	(a0,d1.w),d4
	add.w	(a0,d3.w),d4
	asr	d4
	neg	d4
	move.w	d4,modf2+2

	sub.w	d0,d1
	move.w	d1,d3
	sub.w	d2,d3	
	add.w	d1,d2	
	
	move.w	(a0,d2.w),d4	
	sub.w	(a0,d3.w),d4	
	asr	d4
	neg	d4
	move.w	d4,modf6+2
	
	move.w	(a1,d2.w),d4	
	add.w	(a1,d3.w),d4	
	asr	d4
	move.w	d4,modf9+2

	sub.w	d1,d2
	move.w	d0,d3
	sub.w	d2,d3
	add.w	d0,d2
	
	move.w	(a0,d2.w),d4
	add.w	(a0,d3.w),d4
	asr	d4
	move.w	d4,addmodf1
	
	move.w	(a1,d2.w),d4
	add.w	(a1,d3.w),d4
	asr	d4
	move.w	d4,addmodf2
	
	move.w	(a1,d3.w),d4
	sub.w	(a1,d2.w),d4
	asr	d4
	move.w	d4,addmodf3
	
	move.w	(a0,d2.w),d4
	sub.w	(a0,d3.w),d4
	asr	d4
	move.w	d4,addmodf4

	sub.w	d0,d2
	move.w	#14,d3

	move.w	(a1,d0.w),d4
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf1	equ	*+2
	add.w	#0,d4
	move.w	d4,modf4+2
	
	move.w	(a0,d0.w),d4
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
addmodf2	equ	*+2
	add.w	#0,d4
	move.w	d4,modf5+2
	
	move.w	(a1,d0.w),d4
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
addmodf3	equ	*+2
	add.w	#0,d4
	move.w	d4,modf7+2
	
	move.w	(a0,d0.w),d4
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf4	equ	*+2
	add.w	#0,d4
	move.w	d4,modf8+2
	
	lea.l	t_points,a0
ptchang3	lea.l	tpoitesp1,a1
	lea.l	tz+255*2,a2

	move.w	#155,d5
	move.w	#100,d6
	
	move.w	(a1)+,d7

bmatrix
	move.w	(a1)+,a3
	move.w	(a1)+,a4
	move.w	(a1)+,d4

	move.w	a3,d0
	move.w	a4,d1
	move.w	d4,d2

modf1	muls	#1<<7,d0
modf2	muls	#0,d1
modf3	muls	#0,d2
	add.l	d1,d0
	add.l	d2,d0
	
	move.w	a3,d1
	move.w	a4,d2
	move.w	d4,d3

modf4	muls	#0,d1
modf5	muls	#1<<7,d2
modf6	muls	#0,d3
	add.l	d2,d1
	add.l	d3,d1
	
	move.w	a3,d2
	move.w	a4,d3
	
modf7	muls	#0,d2
modf8	muls	#0,d3
modf9	muls	#1<<7,d4
	add.l	d3,d2
	add.l	d4,d2
	
	asr.w	#7,d2
	add.w	d2,d2
	
	add.w	#20,d2
	
	muls	(a2,d2.w),d0
	muls	(a2,d2.w),d1
	
	swap	d0
	swap	d1
	
	add.w	d5,d0
	add.w	d6,d1
	
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	
	dbra.w	d7,bmatrix
	rts

tobj
	
ptchang1	move.l	#tpoly1+2,chbobj
ptchang2	move.w	tpoly1,d0
bobj	
	move.w	d0,sauvd0
chbobj	equ	*+2
	move.l	tpoly1,d6
	add.l	#4,chbobj
	bsr	poly
	move.w	sauvd0,d0
	dbra.w	d0,bobj	
	
	rts

	************************
	**trace de poly 1 plan**	
	************************
poly:
  	move.l	d6,a5
  	move.w	(a5)+,plan
  	lea.l	t_points,a1
	move.w	2(a5),d0
	move.w	4(a5),d1
	move.w	6(a5),d2
	move.w	(a1,d0.w),d3
	sub.w	(a1,d1.w),d3
	move.w	2(a1,d0.w),d4
	sub.w	2(a1,d1.w),d4
	move.w	(a1,d2.w),d0
	sub.w	(a1,d1.w),d0
	move.w	2(a1,d2.w),d5
	sub.w	2(a1,d1.w),d5
	muls	d3,d5
	muls	d0,d4	
	sub.l	d4,d5
	bgt.s	ncaches	
	rts 
ncaches	
	move.w	(a5)+,d0
	
	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0
	
	move.w	(a5),d1
	move.w	2(a1,d1),d2
	lea.l	2(a5),a2
	move.w	(a2)+,d3
t_petit
	cmp.w	2(a1,d3.w),d2
	blt.s	st_ptit
	lea.l	-2(a2),a5
	move.w	2(a1,d3.w),d2
st_ptit
	move.w	(a2)+,d3
	dbra.w	d0,t_petit
	move.w	d2,codmpyin+2
	
	lea.l	calc(pc),a4
	add.w	d7,d7	
	addq.l	#4,d6
	add.l	d6,d7
	lea.l	tgauch,a3
	lea.l	(a5),a2
b_calct_g	
	move.w	(a2)+,d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g
	move.l	d6,a2
s_calct_g	
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g	
	bsr	calcord
	bra.b	b_calct_g	
s1_calct_g
	move.w	#0,(a3)
	lea.l	tdroit,a3
	move.l	d7,mcodtd+2
	move.l	d6,d7	
	lea.l	(a5),a2
b_calct_d
	move.w	(a2),d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_d
mcodtd	move.l	#t_points+2,a2
s_calct_d	
	move.w	-(a2),d4
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_d	
	bsr	calcord
	bra.b	b_calct_d	
s1_calct_d	
	move.w	#-4,(a3)
	move.l	SCREEN1,a0
	LEA	-29*160(A0),A0
codmpyin	move.w	#100,d0
	lea.l	p_t_ord(pc),a1
	add.w	d0,d0
	add.w	(a1,d0.w),a0
plan	dc.w	$4e71
	
	lea.l	tgauch,a1	
	lea.l	tdroit,a5
	lea.l	p_t_left(pc),a2	
	lea.l	p_t_right(pc),a3	
	lea.l	tdrempvd(pc),a6
	
	move.w	#$fffc,d3
	move.w	#$ffff,d7

pvalpoly	macro

 	moveq	#-4,d0
	and.w	(a1)+,d0
	move.l	(a2,d0.w),d0
	
	moveq	#-4,d1
	and.w	(a5)+,d1
	move.l	(a3,d1.w),d1

	move.l	a0,a4
	add.w	d0,a4

	sub.w	d0,d1

	jmp	(a6,d1.w)
	endm
	pvalpoly
	rts
	bra.w	pdaffpa1
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
	
	pvalpoly
	

pdaffpa2
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	
	pvalpoly
	

pdaffpa3
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	
	pvalpoly
	

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
	
	pvalpoly
	

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
	
	pvalpoly
	

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

	pvalpoly

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
	
	pvalpoly
	

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
	
	pvalpoly

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

	pvalpoly
	

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
	
	pvalpoly

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

	pvalpoly
	

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

	pvalpoly

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
	
	pvalpoly

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

	pvalpoly

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
	
	pvalpoly
	

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
	
	pvalpoly
	

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
	
	pvalpoly
	

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
	
	pvalpoly
	

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
	
	pvalpoly
 	

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
	
	pvalpoly
calcord	
	
	moveq.l	#0,d4
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ASL.W	#7,D4
	ext.l	d4
	DIVS.W	d3,D4
	move.w	#11,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4
	
	add.w	d0,d0	
	add.w	d0,d0
	sub.w	d1,d1
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts



text_convert:
	lea text,a0
	moveq #-1,d1
convert_lp:
	moveq #0,d0
	move.b (a0),d0
	cmp.b d1,d0
	bne.S convert_suite
	cmp.b #255,1(a0)
	beq.S convert_fin
	addq #1,a0
	bra.s convert_lp
convert_suite:
	cmp.b #$20,d0
	blo.s int2_conv
	cmp.b #$21,d0
	bhi.s int2_conv
	sub #$20,d0
	bra.S next_octet
int2_conv:
	cmp.b #$41,d0
	blo.s int3_conv
	cmp.b #$5a,d0
	bhi.s int3_conv
	sub #$3f,d0
	bra.S next_octet
int3_conv:
	cmp.b #$30,d0
	blo.s int4_conv
	cmp.b #$39,d0
	bhi.s int4_conv
	sub #$14,d0
	bra.S next_octet
int4_conv:
	cmp.b #$27,d0
	blo.s int5_conv
	cmp.b #$29,d0
	bhi.s int5_conv
	addQ #$2,d0
	bra.S next_octet
int5_conv:
	cmp.b #$2e,d0
	bne.s int6_conv
	subQ #$8,d0
	bra.S next_octet
int6_conv:
	cmp.b #$3a,d0
	bne.s int7_conv
	sub #$13,d0
	bra.S next_octet
int7_conv:
	cmp.b #$2c,d0
	bne.s int8_conv
	subQ #$4,d0
next_octet:
	lsl #2,d0
	move.b d0,(a0)+
	bra.S convert_lp
convert_fin:
	rts
int8_conv:
	jmp	FIN

sort_demo:
	addq #4,sp
	rts 

construction:
	movem.l a0-a6/d1/d7,-(sp)
	
	lea off_bolean,a6
	move #125-1,d7
	moveq #0,d6
off_bol_lp:
	move.l d6,(a6)+
	dbra d7,off_bol_lp

	move.l #ad_routines,routs_pt
	lea	PtsFill,a3
	move.l a3,usp
	move.l ad_data_pt,a4
	move.l (a4),a4
	move.l lineA_tab,a6
	lea EXPLOX,a5

	move #4-1,d7
pas_lp:
	move d7,-(sp)
	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #32-1,d7
col_lp:

	move #$1e1d,(a5)+
	move #5-1,d6
ligne_lp:

	move.b d6,d5
	add.b d5,d5
	addq.b #1,d5
	move.b d5,(a5)+
	move.b #7,(a5)+
	move.l a5,-(sp)
	move #$6700,(a5)+

	move.l (a4),(a3)+
	move.l 4(a4),(a3)+
	move.l 4+24(a4),(a3)+
	move.l 24(a4),(a3)+
	move.l (a4),(a3)
	move.l usp,a3
	addq #4,a4

	move #+30000,d4
	move #-30000,d5
	move 2(a3),d3
	cmp d3,d4
	ble.s pas_inf1
	move d3,d4
pas_inf1:
	cmp d3,d5
	bge.s pas_sup1
	move d3,d5
pas_sup1:
	move 6(a3),d3
	cmp d3,d4
	ble.s pas_inf2
	move d3,d4
pas_inf2:
	cmp d3,d5
	bge.s pas_sup2
	move d3,d5
pas_sup2: 
	move 10(a3),d3
	cmp d3,d4
	ble.s pas_inf3
	move d3,d4
pas_inf3:
	cmp d3,d5
	bge.s pas_sup3
	move d3,d5
pas_sup3:	
	move 14(a3),d3
	cmp d3,d4
	ble.s pas_inf4
	move d3,d4
pas_inf4:
	cmp d3,d5
	bge.s pas_sup4
	move d3,d5
pas_sup4:
	sub d4,d5	
	move d5,d3	

	move d4,40(a6)
aff_lp:	
	MOVEM.L	D0-D7/A0-A6,-(A7)
	jsr	FILL1
	MOVEM.L	(A7)+,D0-D7/A0-A6

	addQ #1,40(a6)
	dbra d5,aff_lp

	REPT 4	
	move.l (a3)+,38(a6)
	move.l (a3),42(a6)

            movem.l d0-d7/a0-a6,-(a7)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	MOVE	38(a6),D0
	MOVE	40(a6),D1
	
	MOVE	42(a6),D2
	MOVE	44(a6),D3

                bsr     DRAW_A_LINE


                movem.l (a7)+,d0-d7/a0-a6

	ENDR
	
	move.l usp,a3

	move #+30000,d0
	move #-30000,d1
	move (a3),d2
	cmp d2,d0
	ble.s xpas_inf1
	move d2,d0
xpas_inf1:
	cmp d2,d1
	bge.s xpas_sup1
	move d2,d1
xpas_sup1:
	move 4(a3),d2
	cmp d2,d0
	ble.s xpas_inf2
	move d2,d0
xpas_inf2:
	cmp d2,d1
	bge.s xpas_sup2
	move d2,d1
xpas_sup2: 
	move 8(a3),d2
	cmp d2,d0
	ble.s xpas_inf3
	move d2,d0
xpas_inf3:
	cmp d2,d1
	bge.s xpas_sup3
	move d2,d1
xpas_sup3:	
	move 12(a3),d2
	cmp d2,d0
	ble.s xpas_inf4
	move d2,d0
xpas_inf4:
	cmp d2,d1
	bge.s xpas_sup4
	move d2,d1
xpas_sup4:
	lsr #4,d0	
	lsr #4,d1
	sub d0,d1	
	lsl #3,d0	
	muls #160,d4	
	add d4,d0	

	move.l ad_ecran,a0

	move d6,-(sp)
	move d7,-(sp)
	move.l a6,-(sp)
	lea off_bolean,a6
scan_y:
	move d0,d4	
	move d1,d2
scan_x:
	move (a0,d4.w),d5
	beq.s or_nul
	clr (a0,d4.w)	
	move #$006e,(a5)+
	move d5,(a5)+
	move d4,(a5)+
	move d4,d6
	lsr #3,d6
	move d6,d7
	and #$0007,d6
	lsr #3,d7
	bset.b d6,(a6,d7.w)
or_nul:
	addq #8,d4
	dbra d2,scan_x

	add #160,d0
	dbra d3,scan_y

	move.l (sp)+,a6
	move (sp)+,d7
	move (sp)+,d6

	move.l a5,d0	
	move.l (sp)+,a1
	sub.l a1,d0
	subq #2,d0
	cmp #127,d0	
	blo.s offset_short
	move #$6700,(a1)+
	move.l a5,a0
	move d0,d1
	addq #2,d0
	lsr #1,d1
off_l_lp:
	move -(a0),2(a0)
	dbra d1,off_l_lp
	move d0,(a1)+
	addq #2,a5
	bra.s off_l_fin
offset_short:
	move.b d0,1(a1)
off_l_fin:

	cmp.l #EXPLOX+60000,a5
	blo.s mem_ok
	jmp	FIN
mem_ok:

	dbra d6,ligne_lp
	addq #4,a4

	dbra d7,col_lp
	add #24,a4

	move (sp)+,d7
	move #$4e75,(a5)+
	dbra d7,pas_lp



	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #$7e00,(a5)+
	lea off_bolean,a0
	moveq #0,d5
	move #500-1,d7
off_oct_lp:	
	move.b (a0)+,d5
	moveq #8-1,d6
off_bit_lp:
	btst d6,d5
	beq.s bit_nul_off
	move #$3d47,(a5)+
	move #499,d4
	sub d7,d4
	lsl #3,d4
	add d6,d4
	lsl #3,d4
	move d4,(a5)+
	
	cmp.l #EXPLOX+60000,a5
	blo.s mem_ok2
	jmp	FIN
mem_ok2:

bit_nul_off:
	dbra d6,off_bit_lp
	dbra d7,off_oct_lp
	
	move #$4e75,(a5)+

	movem.l (sp)+,a0-a6/d1/d7
	rts

FILL1	MOVEQ.L	#3,D0
	LEA	PtsFill,a0
	LEA	BUF16DA,A1
	
	CLR.W	PNT_261E
LFCA0F4	MOVE.W	6(A0),D1
	MOVE.W	2(A0),D2
	SUB.W	D2,D1
	BEQ.S	LFCA13E
	MOVE.W	EMUL_LINEA-$299A+$29C2,D3
	MOVE.W	D3,D4
	SUB.W	D2,D4
	SUB.W	6(A0),D3
	MOVE.W	D4,D2
	EOR.W	D3,D2
	BPL.S	LFCA13E
	MOVE.W	4(A0),D2
	SUB.W	(A0),D2
	ADD.W	D2,D2
	MULS.W	D2,D4
	DIVS.W	D1,D4
	BPL.S	LFCA12E
	NEG.W	D4
	ADDQ.W	#1,D4
	ASR.W	#1,D4
	NEG.W	D4
	BRA.S	LFCA132
LFCA12E	ADDQ.W	#1,D4
	ASR.W	#1,D4
LFCA132	ADD.W	(A0),D4
	MOVE.W	D4,(A1)+
	ADDQ.W	#1,PNT_261E
LFCA13E	LEA	4(A0),A0
	DBF	D0,LFCA0F4
	MOVE.W	PNT_261E,D0
	BNE.S	LFCA150
	RTS

LFCA150	LEA	BUF16DA,A0
	BSR.S	LFCA1DC
	MOVE.W	PNT_261E,D0
	ASR.W	#1,D0
	SUBQ.W	#1,D0

LFCA16C	MOVE.W	(A1)+,EMUL_LINEA+$26
	MOVE.W	(A1)+,EMUL_LINEA+$2A
	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR.S	FILL2
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
	DBF	D0,LFCA16C
	RTS
	
LFCA1DC	SUBQ.W	#2,D0
	BCS.S	LFCA1FC
	MOVE.W	D0,D1
	MOVEA.L	A0,A1
LFCA1E4	MOVE.W	D1,D0
	MOVEA.L	A1,A0
LFCA1E8	MOVE.W	(A0)+,D2
	CMP.W	(A0),D2
	BLE.S	LFCA1F4
	MOVE.W	(A0),-2(A0)
	MOVE.W	D2,(A0)
LFCA1F4	DBF	D0,LFCA1E8
	DBF	D1,LFCA1E4
LFCA1FC	RTS

VALEURS	DC.L	$FFFF7FFF
	DC.L	$3FFF1FFF
	DC.L	$0FFF07FF
	DC.L	$03FF01FF
	DC.L	$00FF007F
	DC.L	$003F001F
	DC.L	$000F0007
	DC.L	$00030001
	DC	$0000


FILL2	
	LEA	EMUL_LINEA-$299A+$299A,A4

	MOVE	$26(A4),D4
	MOVE	$28(A4),D5
	MOVE	$2A(A4),D6

	MOVE.W	D5,D0

	AND.W	50(A4),D0
	ADD.W	D0,D0
	
	MOVEA.L	46(A4),A0
	ADDA.W	D0,A0	
	
	TST.W	52(A4)
	SNE	D0
	AND.W	#$20,D0
	MOVE.W	D4,D1
	ASR.W	#4,D1
	MOVE.W	D6,D2
	ASR.W	#4,D2
	MOVEQ	#$F,D3
	AND.W	D3,D4
	ADD.W	D4,D4
	MOVE.W	VALEURS(PC,D4.W),D4
	AND.W	D3,D6
	ADD.W	D6,D6
	MOVE.W	VALEURS+2(PC,D6.W),D6
	NOT.W	D6
	SUB.W	D1,D2
	BNE.S	LFCA63C
	AND.W	D6,D4
LFCA63C	

	MOVEA.L	$44E.W,A1
	lea	4(a1),a1
	MULS.W	#160,D5
	ADDA.L	D5,A1

	MOVEA.W	D0,A2

	MOVE.W	#4,D7
	MOVE	#8,D0
	MULS.W	D0,D1	
	ADDA.L	D1,A1

	LEA	24(A4),A3

	NOT.W	D4
	NOT.W	D6
LFD1C56	MOVEA.L	A1,A4
	MOVE.W	D2,D5
	MOVE.W	(A0),D3
	ADDA.W	A2,A0
	TST.W	(A3)+
	BNE.S	LFD1C88
	MOVE.W	D4,D1
	AND.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1C7E
	SUBQ.W	#1,D5
	BCS.S	LFD1C78
	CLR.W	D1
LFD1C70	ADDA.W	D0,A4
	MOVE.W	D1,(A4)

	DBF	D5,LFD1C70

LFD1C78	MOVE.W	D6,D1
	ADDA.W	D0,A4
	AND.W	D1,(A4)
LFD1C7E	

	NOT.W	D4
	NOT.W	D6
	RTS

LFD1C88	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D4,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1CAE
	SUBQ.W	#1,D5
	BCS.S	LFD1CA2
LFD1C9A	ADDA.W	D0,A4
	MOVE.W	D3,(A4)
	DBF	D5,LFD1C9A
LFD1CA2	ADDA.W	D0,A4
	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D6,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A4)

LFD1CAE	DBF	D7,LFD1C56

	NOT.W	D4
	NOT.W	D6
	RTS


                
DRAW_A_LINE
                cmp.w   d1,d3
                beq     DRAW_HORIZONTAL
                cmp.w   d0,d2
                beq     DRAW_VERTICAL

                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l	$44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0
                move.w  d0,d5
                eor.w   #$0f,d5
                and.w   #$0f,d5
                clr.w   d6
                bset    d5,d6
                move.w  d6,d7          
                not.w   d6             

                sub.w   d0,d2
                sub.w   d1,d3

                move.l  #0,a1
                move.l  #0,a2
                move.l  #0,a3
                move.l  #0,a4
                
                tst.w   d2
                bpl.s   .dr_1
                beq.s   .dr_2
                move.w  #-1,a1
                neg.w   d2
                bra.s   .dr_2
.dr_1
	move.w  #1,a1
.dr_2
                tst.w   d3
                bpl.s   .dr_3
                beq.s   .dr_4
                move.w  #-1,a2 
                neg.w   d3     
                bra.s   .dr_4
.dr_3
                move.w  #1,a2  
.dr_4
                cmp.w   d2,d3
                blt.s   .dr_5
                move.w  a2,a4  
                exg     d2,d3
                bra.s   .dr_6
.dr_5
                move.w  a1,a3  
.dr_6 
                move.w  d2,d0
                lsr.w   #1,d0  
                move.w  d2,d1  

.dr_7

                or.w    d7,(a0)

                add.w   d3,d0
                cmp.w   d0,d2
                bgt.s   .dr_8
        
                sub.w   d2,d0
                
                cmp.w   #0,a1
                beq.s   .dr_A5
                bmi.s   .dr_A6
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A5
                addq.l  #8,a0
                bra.s   .dr_A5
.dr_A6
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A5
                subq.l  #8,a0
.dr_A5
                cmp.w   #0,a2
                beq.s   .dr_A3
                bmi.s   .dr_A8
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A8
                lea     -160(a0),a0
                bra.s   .dr_A3
.dr_8
                cmp.w   #0,a3
                beq.s   .dr_A1
                bmi.s   .dr_A2
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A3
                addq.l  #8,a0
                bra.s   .dr_A3
.dr_A2
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A3
                subq.l  #8,a0
                bra.s   .dr_A3
.dr_A1
                cmp.w   #0,a4
                bmi.s   .dr_A4
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A4
                lea     -160(a0),a0
.dr_A3
                dbf     d1,.dr_7        
                rts

DRAW_HORIZONTAL
                cmp.w   d0,d2
                bne.s   .dr_h_1
                rts
.dr_h_1
                bgt.s   .dr_h_2
                exg     d0,d2
.dr_h_2
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l  $44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                move.w  d2,d3
                move.w  d0,d6
                
                and.w   #$fff0,d6
                lsr.w   #4,d6
                and.w   #$fff0,d2
                lsr.w   #4,d2
                
                sub.w   d6,d2

                lea     PIXEL_TABLE_LEFT,a1
                and.w   #$000f,d0
                lsl.w   #1,d0
                move.w  (a1,d0),d0
                lea     PIXEL_TABLE_RIGHT,a1
                and.w   #$000f,d3
                lsl.w   #1,d3
                move.w  (a1,d3),d3

                tst     d2
                bne.s   .dr_h_7
                
                and.w   d0,d3
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_7
                subq.w  #1,d2
                bne.s   .dr_h_8
                
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr.S     .dr_h_m_1
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_8
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr.S     .dr_h_m_1

                subq.w  #1,d2
                move.w  #$ffff,d6
                clr.w   d7
.dr_h_9
                bsr.S     .dr_h_m_1
                dbf     d2,.dr_h_9
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7

.dr_h_m_1       
                or.w    d6,(a0)
	lea	8(a0),a0
                rts

DRAW_VERTICAL
                cmp.w   d1,d3
                bgt.s   .dr_v_1
                exg     d1,d3
.dr_v_1
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l  $44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                eor.w   #$0f,d0
                and.w   #$0f,d0
                clr.w   d6
                bset    d0,d6
                move.w  d6,d7  
                not.w   d7     

                sub.w   d1,d3
.dr_v_m_1
                or.w    d6,(a0)

                lea     160(a0),a0
                dbf     d3,.dr_v_m_1
                rts

trace:
	movea.l	SCREEN1,a0
	
	cmp.w	d0,d2
	bge.s 	suit1
	exg.l	d0,d2
	exg.l	d1,d3 
suit1
	move.w	d1,d7	

	cmp.w	d1,d3
	bge.s 	suit2
	
	exg.l	d1,d3	
	move.w	#-160,d5
	bra.s	suit2s
suit2
	move.w	#160,d5
suit2s
	move.w	d2,d4
	sub.w	d0,d2	
	sub.w	d1,d3
	
	add.w	d0,d0
	lea.l	posx(pc),a1
	move.w	(a1,d0.w),d1
	add.w	d7,d7
	lea.l	posy(pc),a1
	move.w 	(a1,d7.w),d7	
	add.w	d1,d7
	lea.l	(a0,d7.w),a0
	
	cmp.w	d2,d3
	bge.w	point2
	
	cmp.w	#17,d2
	ble	point11
	
	lea.l	fdpx(pc),a1
	add.w	d4,d4
	add.w	d4,d4
	move.l	(a1,d4.w),d4
	move.w	d4,saut+2
	swap	d4
	
	lea.l	ddpx(pc),a1
	add.w	d0,d0	
	move.l	(a1,d0.w),a1
	add.w	d4,a1
	
point1
	addq.l	#1,d2
	swap	d3
	divu	d2,d3	
	moveq.w	#0,d4

	move.w	d3,a2
	move.w	d5,a5
	move.w	#7,d0
	move.w	#6,d1
	move.w	#5,d2
	move.w	#4,d6
	move.w	#3,d7
	move.w	#2,d3
	move.w	#1,d5
	
	jmp	(a1)
lignt	macro

	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	point111\@1
	add.w	a5,a0
point111\@1	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	point112\@1
	add.w	a5,a0
point112\@1	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	point113\@1
	add.w	a5,a0
point113\@1	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	point114\@1
	add.w	a5,a0
point114\@1	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	point115\@1
	add.w	a5,a0
point115\@1	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	point116\@1
	add.w	a5,a0
point116\@1	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	point117\@1
	add.w	a5,a0
point117\@1	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	point118\@1
	add.w	a5,a0
point118\@1
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	point119\@1
	add.w	a5,a0
point119\@1	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	point1110\@1
	add.w	a5,a0
point1110\@1	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	point1111\@1
	add.w	a5,a0
point1111\@1
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	point1112\@1
	add.w	a5,a0
point1112\@1	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	point1113\@1
	add.w	a5,a0
point1113\@1	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	point1114\@1	8	
	add.w	a5,a0
point1114\@1	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	point1115\@1	8
	add.w	a5,a0
point1115\@1	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#7,a0
	bcc.s	point1115\@1+12
	add.w	a5,a0

	endm
trace11
n	set	0
	rept	20
	lignt	n
n	set	n+1	
	endr
	
saut	bra	ftrac1
ftrac1
	rts

ftrac2	
	bset.b	d0,(a0)
	rts

ftrac3	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf31
	add.w	a5,a0
pointf31	
	bset.b	d1,(a0)
	rts

ftrac4	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf41
	add.w	a5,a0
pointf41	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf42
	add.w	a5,a0
pointf42	
	bset.b	d2,(a0)
	rts

ftrac5	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf51
	add.w	a5,a0
pointf51	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf52
	add.w	a5,a0
pointf52	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf53
	add.w	a5,a0
pointf53	
	bset.b	d6,(a0)
	rts

ftrac6	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf61
	add.w	a5,a0
pointf61	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf62
	add.w	a5,a0
pointf62	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf63
	add.w	a5,a0
pointf63	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf64
	add.w	a5,a0
pointf64	
	bset.b	d7,(a0)
	rts

ftrac7	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf71
	add.w	a5,a0
pointf71	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf72
	add.w	a5,a0
pointf72	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf73
	add.w	a5,a0
pointf73	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf74
	add.w	a5,a0
pointf74	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf75
	add.w	a5,a0
pointf75	
	bset.b	d3,(a0)
	
	rts

ftrac8	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf81
	add.w	a5,a0
pointf81	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf82
	add.w	a5,a0
pointf82	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf83
	add.w	a5,a0
pointf83	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf84
	add.w	a5,a0
pointf84	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf85
	add.w	a5,a0
pointf85	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf86
	add.w	a5,a0
pointf86	
	bset.b	d5,(a0)
	
	rts

ftrac9	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf91
	add.w	a5,a0
pointf91	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf92
	add.w	a5,a0
pointf92	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf93
	add.w	a5,a0
pointf93	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf94
	add.w	a5,a0
pointf94	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf95
	add.w	a5,a0
pointf95	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf96
	add.w	a5,a0
pointf96	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf97
	add.w	a5,a0
pointf97	
	bset.b	#0,(a0)
	
	rts

ftrac10	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf101
	add.w	a5,a0
pointf101	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf102
	add.w	a5,a0
pointf102	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf103
	add.w	a5,a0
pointf103	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf104
	add.w	a5,a0
pointf104	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf105
	add.w	a5,a0
pointf105	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf106
	add.w	a5,a0
pointf106	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf107
	add.w	a5,a0
pointf107	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf108
	add.w	a5,a0
pointf108	
	bset.b	d0,(a0)
	rts

ftrac11	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf111
	add.w	a5,a0
pointf111	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf112
	add.w	a5,a0
pointf112	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf113
	add.w	a5,a0
pointf113	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf114
	add.w	a5,a0
pointf114	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf115
	add.w	a5,a0
pointf115	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf116
	add.w	a5,a0
pointf116	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf117
	add.w	a5,a0
pointf117	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf118
	add.w	a5,a0
pointf118	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf119
	add.w	a5,a0
pointf119
	bset.b	d1,(a0)
	rts
	
ftrac12
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf121
	add.w	a5,a0
pointf121	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf122
	add.w	a5,a0
pointf122	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf123
	add.w	a5,a0
pointf123	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf124
	add.w	a5,a0
pointf124	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf125
	add.w	a5,a0
pointf125	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf126
	add.w	a5,a0
pointf126	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf127
	add.w	a5,a0
pointf127	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf128
	add.w	a5,a0
pointf128	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf129
	add.w	a5,a0
pointf129
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1210
	add.w	a5,a0
pointf1210
	bset.b	d2,(a0)
	rts
	
ftrac13	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf131
	add.w	a5,a0
pointf131	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf132
	add.w	a5,a0
pointf132	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf133
	add.w	a5,a0
pointf133	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf134
	add.w	a5,a0
pointf134	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf135
	add.w	a5,a0
pointf135	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf136
	add.w	a5,a0
pointf136	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf137
	add.w	a5,a0
pointf137	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf138
	add.w	a5,a0
pointf138	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf139
	add.w	a5,a0
pointf139
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1310
	add.w	a5,a0
pointf1310
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1311
	add.w	a5,a0
pointf1311
	bset.b	d6,(a0)
	rts
	
ftrac14	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf141
	add.w	a5,a0
pointf141	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf142
	add.w	a5,a0
pointf142	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf143
	add.w	a5,a0
pointf143	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf144
	add.w	a5,a0
pointf144	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf145
	add.w	a5,a0
pointf145	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf146
	add.w	a5,a0
pointf146	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf147
	add.w	a5,a0
pointf147	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf148
	add.w	a5,a0
pointf148	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf149
	add.w	a5,a0
pointf149
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1410
	add.w	a5,a0
pointf1410
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1411
	add.w	a5,a0
pointf1411
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf1412
	add.w	a5,a0
pointf1412
	bset.b	d7,(a0)
	rts
	
ftrac15	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf151
	add.w	a5,a0
pointf151	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf152
	add.w	a5,a0
pointf152	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf153
	add.w	a5,a0
pointf153	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf154
	add.w	a5,a0
pointf154	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf155
	add.w	a5,a0
pointf155	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf156
	add.w	a5,a0
pointf156	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf157
	add.w	a5,a0
pointf157	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf158
	add.w	a5,a0
pointf158	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf159
	add.w	a5,a0
pointf159
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1510
	add.w	a5,a0
pointf1510
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1511
	add.w	a5,a0
pointf1511
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf1512
	add.w	a5,a0
pointf1512
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf1513
	add.w	a5,a0
pointf1513
	bset.b	d3,(a0)
	rts
	
ftrac16	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf161
	add.w	a5,a0
pointf161	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf162
	add.w	a5,a0
pointf162	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf163
	add.w	a5,a0
pointf163	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf164
	add.w	a5,a0
pointf164	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf165
	add.w	a5,a0
pointf165	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf166
	add.w	a5,a0
pointf166	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf167
	add.w	a5,a0
pointf167	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf168
	add.w	a5,a0
pointf168	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf169
	add.w	a5,a0
pointf169
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1610
	add.w	a5,a0
pointf1610
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1611
	add.w	a5,a0
pointf1611
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf1612
	add.w	a5,a0
pointf1612
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf1613
	add.w	a5,a0
pointf1613
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf1614
	add.w	a5,a0
pointf1614
	bset.b	d5,(a0)
	rts	
	
point11
	lea.l	ppxpet(pc),a1
	add.w	d0,d0
	add.w	d0,a1
	
	tst.w	d3
	beq	point12
	move.w	d3,d6
	
	subq.l	#1,d6
	move.w	d2,d4
	addq.l	#2,a1
	move.w	(a1)+,d0
bpoint11
	bset.b	d0,(a0)
	add.w	(a1)+,a0
	move.w	(a1)+,d0
	sub.w	d3,d4
	bge.s	bpoint11
	add.w	d5,a0
	add.w	d2,d4
spoint11
	dbra.w	d6,bpoint11
	rts
point12
	subq.l	#1,d2
	addq.l	#2,a1
	move.w	(a1)+,d0
bpoint12	
	bset	d0,(a0)
	add.w	(a1)+,a0
	move.w	(a1)+,d0
	dbra.w	d2,bpoint12
	rts
point2
	addq.l	#1,d3
	swap	d2
	divu	d3,d2	
	moveq.w	#0,d4
	lea.l	ppxpet(pc),a1
	add.w	d0,d0
	add.w	d0,a1
	addq.l	#2,a1
	move.w	(a1)+,d0
	muls.w	#12,d3
	neg	d3
	lea.l	linvt(pc),a2
	jmp	(a2,d3.w)


lign	macro
	bset.b	d0,(a0)
	add.w	d5,a0
	add.w	d2,d4
	bcc.s	ligv\@1	
	add.w	(a1)+,a0
	move.w	(a1)+,d0
ligv\@1
	endm

n	set	0
	rept	201
	lign	n
n	set	n+1	
	endr
linvt	
	
	rts


EFFACE
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVE.L	#0,A1
	MOVE.L	#0,A2
	MOVE.L	#0,A3
	MOVE.L	#0,A4
	MOVE.L	#0,A5
	MOVE.L	#0,A6
N	SET	0
	REPT	100
	MOVE	D0,N(A0)
	MOVE	D0,N+8(A0)
	MOVE	D0,N+16(A0)
	MOVE	D0,N+24(A0)
	MOVE	D0,N+32(A0)
	MOVE	D0,N+40(A0)
	MOVE	D0,N+48(A0)
	MOVE	D0,N+56(A0)
	MOVE	D0,N+64(A0)
	MOVE	D0,N+72(A0)
N	SET	N+160
	ENDR
	RTS

POLY_3:
	LEA	POINTS_3,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*3(A1)
	BNE.S	OKAYC
	SUB.L	#4*4*3,PNT
	ADDQ.L	#1,TIME_PASSED
	BRA.S	POLY_3

OKAYC	ADD.L	#4*4,PNT
	BRA	OKAY2
POLY_2:
	LEA	POINTS_2,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*3(A1)
	BNE.S	OKAYB
	SUB.L	#4*4*3,PNT
	ADDQ.L	#1,TIME_PASSED
	BRA.S	POLY_2

OKAYB	ADD.L	#4*4,PNT
	BRA	OKAY2
POLY_1:
	LEA	POINTS_1,A1
	ADDA.L	PNT,A1
	CMPI.L	#1,FLAG_T
	BNE.S	NO_FL
	SUB.L	#16,PNT
	LEA	POINTS_1,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,-4(A1)
	BNE.S	OOK
	ADD.L	#4*4*7,PNT
	ADDQ.L	#1,TIME_PASSED
	BRA.S	POLY_1
	
OOK	BRA.S	OKAY2
NO_FL	CMPI.B	#-1,4*4*6(A1)
	BNE.S	OKAYZ
	move.l	#1,FLAG_T
	SUB.L	#4*4*6,PNT
	BRA.S	POLY_1

OKAYZ	ADD.L	#4*4,PNT
	BRA.S	OKAY2

POLY_:
	LEA	POINTS_,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*6(A1)
	BNE.S	OKAY
	SUB.L	#4*4*6,PNT
	ADDQ.L	#1,TIME_PASSED
	BRA.S	POLY_
	
OKAY	ADD.L	#4*4,PNT
OKAY2	

	lea.l	tpoly(pc),a5
	move.w	(a5)+,d0
	
	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0
	




	move.w	(a5),d1
	move.w	2(a1,d1),d2
	lea.l	2(a5),a2
	move.w	(a2)+,d3
t_petit_
	cmp.w	2(a1,d3.w),d2
	blt.s	st_ptit_
	lea.l	-2(a2),a5
	move.w	2(a1,d3.w),d2
st_ptit_
	move.w	(a2)+,d3
	dbra.w	d0,t_petit_
	move.w	d2,codmpyin_+2
	
	lea.l	calc_(pc),a4
	add.w	d7,d7	
	add.l	#tpoly+2,d7
	lea.l	tgauch,a3
	lea.l	(a5),a2
b_calct_g_
	move.w	(a2)+,d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g_
	lea.l	tpoly+2(pc),a2
s_calct_g_
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g_
	bsr	calcord_
	bra.b	b_calct_g_
s1_calct_g_
	lea.l	tdroit,a3
	move.l	d7,mcodtd_+2
	move.l	#tpoly+2,d7	
	lea.l	(a5),a2
b_calct_d_
	move.w	(a2),d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_d_
mcodtd_	move.l	#t_POINTS_+2,a2
s_calct_d_
	move.w	-(a2),d4
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_d_
	bsr	calcord_
	bra.b	b_calct_d_
s1_calct_d_
	move.l	SCREEN2,a0
	LEA	2(A0),A0
	
	move.w	d1,d6

codmpyin_	move.w	#100,d0
	sub.w	d0,d6
	subq.l	#1,d6
	lea.l	P_T_ord_(pc),a1
	add.w	d0,d0
	add.w	(a1,d0.w),a0
	
	lea.l	tgauch,a1	
	lea.l	P_T_left(pc),a2	
	lea.l	P_T_right(pc),a3	
	
	move.w	#$ffff,d7
	
bouclaff_
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
	jmp	tdrempvd_(pc,d1.w)
tdrempvd_
	bra.w	pdaffpa1_
	dc.l	0
	bra.w	pdaffpa2_
	dc.l	0
	bra.w	pdaffpa3_
	dc.l	0
	bra.w	pdaffpa4_
	dc.l	0
	bra.w	pdaffpa5_
	dc.l	0
	bra.w	pdaffpa6_
	dc.l	0
	bra.w	pdaffpa7_
	dc.l	0
	bra.w	pdaffpa8_
	dc.l	0
	bra.w	pdaffpa9_
	dc.l	0
	bra.w	pdaffpa10_
	dc.l	0
	bra.w	pdaffpa11_
	dc.l	0
	bra.w	pdaffpa12_
	dc.l	0
	bra.w	pdaffpa13_
	dc.l	0
	bra.w	pdaffpa14_
	dc.l	0
	bra.w	pdaffpa15_
	dc.l	0
	bra.w	pdaffpa16_
	dc.l	0
	bra.w	pdaffpa17_
	dc.l	0
	bra.w	pdaffpa18_
	dc.l	0
	bra.w	pdaffpa19_
	dc.l	0
	bra.w	pdaffpa20_

pdaffpa1_
	swap	d0
	swap	d1
	and.w	d0,d1
	or.w	d1,(a4)	
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff_
	rts
pdaffpa2_
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff_
	rts
pdaffpa3_
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff_
	rts
pdaffpa4_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa5_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa6_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa7_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa8_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa9_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa10_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa11_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa12_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa13_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa14_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa15_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa16_

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
	dbra.w	d6,bouclaff_
	rts
pdaffpa17_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa18_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa19_
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
	dbra.w	d6,bouclaff_
	rts
pdaffpa20_
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
	dbra.w	d6,bouclaff_
	rts

calcord_
	
	moveq.l	#0,d4
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul_
	rts
scalcnul_
	move.w	d2,d4
	
	ASL.W	#6,D4
	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#10,d2
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
calc_
	rts


	DATA

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

	dc.w	-8,-6
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
n	set	30*160
	rept	200
	dc.w	n
n	set	n+160
	endr
	*------------variable------------*

ddpx	
n	set	0
	rept	20
	dc.l	trace11+n,trace11+n+8,trace11+n+16,trace11+n+24,trace11+n+32,trace11+n+40
	dc.l	trace11+n+48,trace11+n+56,trace11+n+68,trace11+n+76,trace11+n+84,trace11+n+92
	dc.l	trace11+n+100,trace11+n+108,trace11+n+116,trace11+n+124
n	set	n+136
	endr

fdpx
n	set	20*136
	rept	20
	dc.w 	n,ftrac2-saut-2,n,ftrac3-saut-2
	dc.w 	n,ftrac4-saut-2,n,ftrac5-saut-2
	dc.w 	n,ftrac6-saut-2,n,ftrac7-saut-2
	dc.w 	n,ftrac8-saut-2,n,ftrac9-saut-2
	dc.w 	n,ftrac10-saut-2,n,ftrac11-saut-2
	dc.w 	n,ftrac12-saut-2,n,ftrac13-saut-2
	dc.w 	n,ftrac14-saut-2,n,ftrac15-saut-2
	dc.w 	n,ftrac16-saut-2,n-136,ftrac1-saut-2
n	set	n-136
	endr

posx	
n	set	0
	rept	160/8
	dc.w	n,n,n,n
	dc.w	n,n,n,n
	dc.w	n+1,n+1,n+1,n+1
	dc.w	n+1,n+1,n+1,n+1
n	set	n+8
	endr  

posy:	
	
n	set 	-160*3
	rept	206	
	dc.w	n	
n	set n+160
	endr

ppxpet
	rept	(160/8)
	dc.w	7,7,0,6,0,5,0,4
	dc.w	0,3,0,2,0,1,0,0
	dc.w	1,7,0,6,0,5,0,4
	dc.w	0,3,0,2,0,1,0,0
	endr

buffl:
	dc.w	21216,21216,21184,21216,21216,21216,21216,21168
	dc.w	10688,10704,21216,21216,21152,21120,10656,21216	
	
n	set	15840
	rept	10
	dc.w	n
n	set	16+n
	endr

	dc.w	10672,21200,21216,21216,21216,21216,21216	

n	set	0
	rept	10
	dc.w	n
n	set	8*2+n
	endr
	
n	set	5280	
	rept	10
	dc.w	n
n	set	n+16
	endr	
	
n	set	10560	
	rept	6
	dc.w	n
n	set	n+16
	endr	


COLORS	DC	$0,$111,$222,$333,$444,$555,$666
	DCB	20,$777
	DC.L	-1
COLORS2	DC	$777,$666,$555,$444,$333,$222,$111
	DCB	10,$0
	DC.L	-1
*CUBE
adag1	dc.w	0
adag2	dc.w	0
adag3	dc.w	0
attvbl	dc.w	10
numobj	dc.w	0	
paobj	dc.l	tpoly1,tpoitesp1,tpoly2,tpoitesp2,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11,face12,face13,face14,face15,face16 	

face11	dc.w	$5488,4,0,4,8,12
face12	dc.w	$5888,4,16,0,12,28
face13	dc.w	$5c88,4,12,8,24,28
face14	dc.w	$5888,4,4,20,24,8
face15	dc.w	$5c88,4,16,20,4,0 
face16	dc.w	$4e71,4,28,24,20,16

tpoitesp1	
	dc.w	8-1
	dc.w	-42,-42,-42		1
	dc.w	-42,42,-42		2
	dc.w	42,42,-42		3	
	dc.w	42,-42,-42		4
	dc.w	-42,-42,42		5	
	dc.w	-42,42,42		6	
	dc.w	42,42,42		7
	dc.w	42,-42,42		8
*****************************************************
tpoly2	dc.w	7-1
	dc.l	face21,face22,face23,face24,face25,face26,face27 	

face21	dc.w	$5488,4,0,4,8,12	avd
face22	dc.w	$5888,4,0,12,32,36	dhaut
face23	dc.w	$5888,4,36,32,28,16	dhaut
face24	dc.w	$5c88,5,12,8,24,28,32	droit
face25	dc.w	$5888,4,4,20,24,8	bas
face26	dc.w	$5c88,5,16,20,4,0,36 	gauche	
face27	dc.w	$4e71,4,28,24,20,16	arrie

tpoitesp2	
	dc.w	10-1
	dc.w	-40,-15,-25		1=0
	dc.w	-40,32,-25		2=4
	dc.w	40,32,-25		3=8	
	dc.w	40,-15,-25		4=12
	dc.w	-40,-15,25		5=16	
	dc.w	-40,32,25		6=15	
	dc.w	40,32,25		7=24
	dc.w	40,-15,25		8=28
	dc.w	40,-32,0		9=32
	dc.w	-40,-32,0		10=36

CADRE

; NB PTS=8
; Forme de d‚part
; DC 1,199,319,199
; DC 319,199,319,1
; DC 319,1,1,1
; DC 1,1,1,199


 DC 7,193,312,193
 DC 312,193,312,3
 DC 312,3,7,3
 DC 7,3,7,193


; Transformation
; DC 4,196,315,196
; DC 315,196,315,2
; DC 315,2,4,2
; DC 4,2,4,196


 DC 7,193,312,193
 DC 312,193,312,3
 DC 312,3,7,3
 DC 7,3,7,19

 DC 7,193,312,193
 DC 312,193,312,3
 DC 312,3,7,3
 DC 7,3,7,193
 DC 10,190,309,190
 DC 309,190,309,4
 DC 309,4,10,4
 DC 10,4,10,190
 DC 13,187,306,187
 DC 306,187,306,5
 DC 306,5,13,5
 DC 13,5,13,187
 DC 16,185,303,185
 DC 303,185,303,6
 DC 303,6,16,6
 DC 16,6,16,185
 DC 20,182,299,182
 DC 299,182,299,8
 DC 299,8,20,8
 DC 20,8,20,182
 DC 23,179,296,179
 DC 296,179,296,9
 DC 296,9,23,9
 DC 23,9,23,179
 DC 26,176,293,176
 DC 293,176,293,10
 DC 293,10,26,10
 DC 26,10,26,176
 DC 29,173,290,173
 DC 290,173,290,11
 DC 290,11,29,11
 DC 29,11,29,173
 DC 32,171,287,171
 DC 287,171,287,12
 DC 287,12,32,12
 DC 32,12,32,171
 DC 35,168,284,168
 DC 284,168,284,13
 DC 284,13,35,13
 DC 35,13,35,168
 DC 39,165,280,165
 DC 280,165,280,15
 DC 280,15,39,15
 DC 39,15,39,165
 DC 42,162,277,162
 DC 277,162,277,16
 DC 277,16,42,16
 DC 42,16,42,162
 DC 45,160,274,160
 DC 274,160,274,17
 DC 274,17,45,17
 DC 45,17,45,160
 DC 48,157,271,157
 DC 271,157,271,18
 DC 271,18,48,18
 DC 48,18,48,157
 DC 51,154,268,154
 DC 268,154,268,19
 DC 268,19,51,19
 DC 51,19,51,154
 DC 55,151,264,151
 DC 264,151,264,21
 DC 264,21,55,21
 DC 55,21,55,151
 DC 58,148,261,148
 DC 261,148,261,22
 DC 261,22,58,22
 DC 58,22,58,148
 DC 61,146,258,146
 DC 258,146,258,23
 DC 258,23,61,23
 DC 61,23,61,146
 DC 64,143,255,143
 DC 255,143,255,24
 DC 255,24,64,24
 DC 64,24,64,143
 DC 67,140,252,140
 DC 252,140,252,25
 DC 252,25,67,25
 DC 67,25,67,140
 DC 70,137,249,137
 DC 249,137,249,26
 DC 249,26,70,26
 DC 70,26,70,137
 DC 74,135,245,135
 DC 245,135,245,28
 DC 245,28,74,28
 DC 74,28,74,135
 DC 77,132,242,132
 DC 242,132,242,29
 DC 242,29,77,29
 DC 77,29,77,132
 DC 80,129,239,129
 DC 239,129,239,30
 DC 239,30,80,30
 DC 80,30,80,129
 DC 83,126,236,126
 DC 236,126,236,31
 DC 236,31,83,31
 DC 83,31,83,126
 DC 86,123,233,123
 DC 233,123,233,32
 DC 233,32,86,32
 DC 86,32,86,123
 DC 90,121,229,121
 DC 229,121,229,34
 DC 229,34,90,34
 DC 90,34,90,121
 DC 93,118,226,118
 DC 226,118,226,35
 DC 226,35,93,35
 DC 93,35,93,118
 DC 96,115,223,115
 DC 223,115,223,36
 DC 223,36,96,36
 DC 96,36,96,115
 DC 99,112,220,112
 DC 220,112,220,37
 DC 220,37,99,37
 DC 99,37,99,112
 DC 102,110,217,110
 DC 217,110,217,38
 DC 217,38,102,38
 DC 102,38,102,110
 DC 105,107,214,107
 DC 214,107,214,39
 DC 214,39,105,39
 DC 105,39,105,107
 DC 109,104,210,104
 DC 210,104,210,41
 DC 210,41,109,41
 DC 109,41,109,104
 DC 112,101,207,101
 DC 207,101,207,42
 DC 207,42,112,42
 DC 112,42,112,101
 DC 115,98,204,98
 DC 204,98,204,43
 DC 204,43,115,43
 DC 115,43,115,98
 DC 118,96,201,96
 DC 201,96,201,44
 DC 201,44,118,44
 DC 118,44,118,96
 DC 121,93,198,93
 DC 198,93,198,45
 DC 198,45,121,45
 DC 121,45,121,93
 DC 125,90,194,90
 DC 194,90,194,47
 DC 194,47,125,47
 DC 125,47,125,90
 DC 128,87,191,87
 DC 191,87,191,48
 DC 191,48,128,48
 DC 128,48,128,87
 DC 131,85,188,85
 DC 188,85,188,49
 DC 188,49,131,49
 DC 131,49,131,85
 DC 134,82,185,82
 DC 185,82,185,50
 DC 185,50,134,50
 DC 134,50,134,82
 DC 137,79,182,79
 DC 182,79,182,51
 DC 182,51,137,51
 DC 137,51,137,79
 DC 140,76,179,76
 DC 179,76,179,52
 DC 179,52,140,52
 DC 140,52,140,76
 DC 144,73,175,73
 DC 175,73,175,54
 DC 175,54,144,54
 DC 144,54,144,73
 DC 147,71,172,71
 DC 172,71,172,55
 DC 172,55,147,55
 DC 147,55,147,71
 DC 150,68,169,68
 DC 169,68,169,56
 DC 169,56,150,56
 DC 150,56,150,68
 DC 153,65,166,65
 DC 166,65,166,57
 DC 166,57,153,57
 DC 153,57,153,65
 DC 156,62,163,62
 DC 163,62,163,58
 DC 163,58,156,58
 DC 156,58,156,62

 DC 159,60,160,60
 DC 160,60,160,59
 DC 160,59,159,59
 DC 159,59,159,60
; Forme d'arriv‚e
CADRE2 DC 160,60,160,60
 DC 160,60,160,60
 DC 160,60,160,60
 DC 160,60,160,60

*DATA FLEXI
SCREEN_Y_TABLE
                dc.w    0,160,320,480,640,800,960,1120,1280,1440,1600,1760,1920,2080,2240
                dc.w    2400,2560,2720,2880,3040,3200,3360,3520,3680,3840,4000,4160,4320,4480,4640
                dc.w    4800,4960,5120,5280,5440,5600,5760,5920,6080,6240,6400,6560,6720,6880,7040
                dc.w    7200,7360,7520,7680,7840,8000,8160,8320,8480,8640,8800,8960,9120,9280,9440
                dc.w    9600,9760,9920,10080,10240,10400,10560,10720,10880,11040,11200,11360,11520,11680,11840
                dc.w    12000,12160,12320,12480,12640,12800,12960,13120,13280,13440,13600,13760,13920,14080,14240
                dc.w    14400,14560,14720,14880,15040,15200,15360,15520,15680,15840,16000,16160,16320,16480,16640
                dc.w    16800,16960,17120,17280,17440,17600,17760,17920,18080,18240,18400,18560,18720,18880,19040
                dc.w    19200,19360,19520,19680,19840,20000,20160,20320,20480,20640,20800,20960,21120,21280,21440
                dc.w    21600,21760,21920,22080,22240,22400,22560,22720,22880,23040,23200,23360,23520,23680,23840
                dc.w    24000,24160,24320,24480,24640,24800,24960,25120,25280,25440,25600,25760,25920,26080,26240
                dc.w    26400,26560,26720,26880,27040,27200,27360,27520,27680,27840,28000,28160,28320,28480,28640
                dc.w    28800,28960,29120,29280,29440,29600,29760,29920,30080,30240,30400,30560,30720,30880,31040
                dc.w    31200,31360,31520,31680,31840
PIXEL_TABLE_LEFT
                dc.w    %1111111111111111
                dc.w    %0111111111111111
                dc.w    %0011111111111111
                dc.w    %0001111111111111
                dc.w    %0000111111111111
                dc.w    %0000011111111111
                dc.w    %0000001111111111
                dc.w    %0000000111111111
                dc.w    %0000000011111111
                dc.w    %0000000001111111
                dc.w    %0000000000111111
                dc.w    %0000000000011111
                dc.w    %0000000000001111
                dc.w    %0000000000000111
                dc.w    %0000000000000011
                dc.w    %0000000000000001
PIXEL_TABLE_RIGHT
                dc.w    %1000000000000000
                dc.w    %1100000000000000
                dc.w    %1110000000000000
                dc.w    %1111000000000000
                dc.w    %1111100000000000
                dc.w    %1111110000000000
                dc.w    %1111111000000000
                dc.w    %1111111100000000
                dc.w    %1111111110000000
                dc.w    %1111111111000000
                dc.w    %1111111111100000
                dc.w    %1111111111110000
                dc.w    %1111111111111000
                dc.w    %1111111111111100
                dc.w    %1111111111111110
                dc.w    %1111111111111111

MESS_X_COORD    dc.w    0
MESS_Y_COORD    dc.w    0
sauvd0	dc.w	0

pattern:	dc.w $ffff

data_ads:	dc.l	f01
;ARROWS
text:
	dc.b "                            "
	rept	20
	DC.B " AND WHILE WE'RE AT IT, HERE'S A SOLID VECTOR SCROLLER RUNING AT"
	DC.B " FULL FRAME RATE...      IT'S ACTUALLY AN ADVANCED VERSION OF DAN NATO'S"
	DC.B " FLEXI KILLER SCROLLER...   DON'T THINK I'M SHORT OF MACHINE TIME... "
	DC.B "   JUST PRESS THE ARROWS, POSER !  YEAH!  THIS IS VERY UGLY,"
	DC.B " BUT YOU KNOW WHAT THIS EFFECT MEANS...  "
	endr
	dc.b "                                "
	dc.b 255,255

	even
font:	
	dc.b %00000,%00000,%00000,%00000	;' '
	dc.b %00000,%11101,%11101,%00000	;!
	dc.b %01111,%10100,%10100,%01111	;a
	dc.b %01010,%10101,%10101,%11111	;b
	dc.b %10001,%10001,%10001,%11111	;c
	dc.b %01110,%10001,%10001,%11111	;d
	dc.b %10001,%10101,%10101,%11111	;e
	dc.b %10000,%10100,%10100,%11111	;f
	dc.b %10110,%10101,%10001,%01110	;g
	dc.b %11111,%00100,%00100,%11111	;h
	dc.b %00000,%10001,%11111,%10001	;i
	dc.b %00000,%10000,%11111,%10001	;j
	dc.b %11011,%00100,%00100,%11111	;k
	dc.b %00001,%00001,%00001,%11111	;l
	dc.b %11111,%01000,%01000,%11111	;m
	dc.b %01111,%10000,%10000,%11111	;n
	dc.b %11111,%10001,%10001,%11111	;o
	dc.b %01000,%10100,%10100,%11111	;p
	dc.b %11111,%10011,%10001,%11111	;q
	dc.b %11101,%10110,%10100,%11111	;r
	dc.b %10010,%10101,%10101,%01001	;s
	dc.b %00000,%10000,%11111,%10000	;t
	dc.b %11111,%00001,%00001,%11111	;u
	dc.b %11110,%00001,%00001,%11110	;v
	dc.b %11111,%00010,%00010,%11111	;w
	dc.b %11011,%00100,%00100,%11011	;x
	dc.b %00000,%11100,%00111,%11100	;y
	dc.b %10001,%11001,%10101,%10011	;z
	dc.b %01110,%10001,%10001,%01110	;0
	dc.b %00000,%00001,%11111,%01001	;1
	dc.b %01001,%10101,%10011,%00001	;2
	dc.b %01010,%10101,%10101,%10001	;3
	dc.b %00010,%11111,%01010,%00110	;4
	dc.b %10010,%10101,%10101,%11101	;5
	dc.b %00010,%10101,%10101,%01110	;6
	dc.b %11000,%10100,%10010,%10001	;7
	dc.b %01010,%10101,%10101,%01010	;8
	dc.b %01110,%10101,%10101,%01001	;9
	dc.b %00000,%00011,%00011,%00000	;.
	dc.b %00000,%01001,%00000,%00000	;:
	dc.b %00000,%00010,%00001,%00000	;,
	dc.b %00000,%00000,%11000,%00000	;'
	dc.b %00000,%10001,%01110,%00000	;(
	dc.b %00000,%01110,%10001,%00000	;)

*equivalence:
*	dc.b " !ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:,'()"

 	EVEN

tpoly	dc.w	4
	dc.w	0,4,8,12

t_POINTS_	
	dc.w	0,75
	dc.w	0,199
	dc.w	75,199
	dc.w	150,0
	
P_T_left
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

P_T_right
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
	
P_T_ord_
n	set	0
	rept	200
	dc.w	n
n	set	n+160
	endr	

POINTS_	
	INCBIN	POLYTRAN.DAT
	DC.L	-1
	DC.L	-1

POINTS_1
	INCBIN	TRANSHC.DAT
	DC.L	-1
	DC.L	-1
	
POINTS_2
	INCBIN	TRANSFOH.DAT
	DC.L	-1
	DC.L	-1

POINTS_3
	INCBIN	TRANSFOC.DAT
	DC.L	-1
	DC.L	-1
	
PART1	DC.W	%1111111111111111
	DC.W	%0111111111111111
	DC.W	%0011111111111111
	DC.W	%0001111111111111
	DC.W	%0000111111111111
	DC.W	%0000011111111111
	DC.W	%0000001111111111
	DC.W	%0000000111111111
	DC.W	%0000000011111111
	DC.W	%0000000001111111
	DC.W	%0000000000111111
	DC.W	%0000000000011111
	DC.W	%0000000000001111
	DC.W	%0000000000000111
	DC.W	%0000000000000011
	DC.W	%0000000000000001

PART2	DC.W	%1000000000000000
	DC.W	%1100000000000000
	DC.W	%1110000000000000
	DC.W	%1111000000000000
	DC.W	%1111100000000000
	DC.W	%1111110000000000
	DC.W	%1111111000000000
	DC.W	%1111111100000000
	DC.W	%1111111110000000
	DC.W	%1111111111000000
	DC.W	%1111111111100000
	DC.W	%1111111111110000
	DC.W	%1111111111111000
	DC.W	%1111111111111100
	DC.W	%1111111111111110
	DC.W	%1111111111111111

PNTS
N	SET	32768
	REPT	16
	DC.W	N
N	SET	N/2
	ENDR
	
FAD_HC0	DC	$000,$000
FAD_HC1	DC	$111,$222,$333,$444,$555,$666
FAD_HC2	DC	$777


EFECT
 DC 5
 DC 6
 DC 8
 DC 9
 DC 11
 DC 12
 DC 14
 DC 16
 DC 17
 DC 19
 DC 20
 DC 22
 DC 23
 DC 25
 DC 26
 DC 28
 DC 29
 DC 30
 DC 32
 DC 33
 DC 34
 DC 36
 DC 37
 DC 38
 DC 39
 DC 41
 DC 42
 DC 43
 DC 44
 DC 45
 DC 46
 DC 47
 DC 48
 DC 48
 DC 49
 DC 50
 DC 51
 DC 51
 DC 52
 DC 52
 DC 53
 DC 53
 DC 54
 DC 54
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 56
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 54
 DC 54
 DC 53
 DC 53
 DC 52
 DC 52
 DC 51
 DC 51
 DC 50
 DC 49
 DC 48
 DC 48
 DC 47
 DC 46
 DC 45
 DC 44
 DC 43
 DC 42
 DC 41
 DC 39
 DC 38
 DC 37
 DC 36
 DC 34
 DC 33
 DC 32
 DC 30
 DC 29
 DC 28
 DC 26
 DC 25
 DC 23
 DC 22
 DC 20
 DC 19
 DC 17
 DC 16
 DC 14
 DC 12
 DC 11
 DC 9
 DC 8
 DC 6

 DC 5
 DC 6
 DC 8
 DC 9
 DC 11
 DC 12
 DC 14
 DC 16
 DC 17
 DC 19
 DC 20
 DC 22
 DC 23
 DC 25
 DC 26
 DC 28
 DC 29
 DC 30
 DC 32
 DC 33
 DC 34
 DC 36
 DC 37
 DC 38
 DC 39
 DC 41
 DC 42
 DC 43
 DC 44
 DC 45
 DC 46
 DC 47
 DC 48
 DC 48
 DC 49
 DC 50
 DC 51
 DC 51
 DC 52
 DC 52
 DC 53
 DC 53
 DC 54
 DC 54
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 56
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 54
 DC 54
 DC 53
 DC 53
 DC 52
 DC 52
 DC 51
 DC 51
 DC 50
 DC 49
 DC 48
 DC 48
 DC 47
 DC 46
 DC 45
 DC 44
 DC 43
 DC 42
 DC 41
 DC 39
 DC 38
 DC 37
 DC 36
 DC 34
 DC 33
 DC 32
 DC 30
 DC 29
 DC 28
 DC 26
 DC 25
 DC 23
 DC 22
 DC 20
 DC 19
 DC 17
 DC 16
 DC 14
 DC 12
 DC 11
 DC 9
 DC 8
 DC 6


 DC 5
 DC 6
 DC 8
 DC 9
 DC 11
 DC 12
 DC 14
 DC 16
 DC 17
 DC 19
 DC 20
 DC 22
 DC 23
 DC 25
 DC 26
 DC 28
 DC 29
 DC 30
 DC 32
 DC 33
 DC 34
 DC 36
 DC 37
 DC 38
 DC 39
 DC 41
 DC 42
 DC 43
 DC 44
 DC 45
 DC 46
 DC 47
 DC 48
 DC 48
 DC 49
 DC 50
 DC 51
 DC 51
 DC 52
 DC 52
 DC 53
 DC 53
 DC 54
 DC 54
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 56
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 55
 DC 54
 DC 54
 DC 53
 DC 53
 DC 52
 DC 52
 DC 51
 DC 51
 DC 50
 DC 49
 DC 48
 DC 48
 DC 47
 DC 46
 DC 45
 DC 44
 DC 43
 DC 42
 DC 41
 DC 39
 DC 38
 DC 37
 DC 36
 DC 34
 DC 33
 DC 32
 DC 30
 DC 29
 DC 28
 DC 26
 DC 25
 DC 23
 DC 22
 DC 20
 DC 19
 DC 17
 DC 16
 DC 14
 DC 12
 DC 11
 DC 9
 DC 8
 DC 6

 DC.L -1
 
EFECT2
 DC -5
 DC -6
 DC -8
 DC -9
 DC -11
 DC -12
 DC -14
 DC -16
 DC -17
 DC -19
 DC -20
 DC -22
 DC -23
 DC -25
 DC -26
 DC -28
 DC -29
 DC -30
 DC -32
 DC -33
 DC -34
 DC -36
 DC -37
 DC -38
 DC -39
 DC -41
 DC -42
 DC -43
 DC -44
 DC -45
 DC -46
 DC -47
 DC -48
 DC -48
 DC -49
 DC -50
 DC -51
 DC -51
 DC -52
 DC -52
 DC -53
 DC -53
 DC -54
 DC -54
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -56
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -54
 DC -54
 DC -53
 DC -53
 DC -52
 DC -52
 DC -51
 DC -51
 DC -50
 DC -49
 DC -48
 DC -48
 DC -47
 DC -46
 DC -45
 DC -44
 DC -43
 DC -42
 DC -41
 DC -39
 DC -38
 DC -37
 DC -36
 DC -34
 DC -33
 DC -32
 DC -30
 DC -29
 DC -28
 DC -26
 DC -25
 DC -23
 DC -22
 DC -20
 DC -19
 DC -17
 DC -16
 DC -14
 DC -12
 DC -11
 DC -9
 DC -8
 DC -6

 DC -5
 DC -6
 DC -8
 DC -9
 DC -11
 DC -12
 DC -14
 DC -16
 DC -17
 DC -19
 DC -20
 DC -22
 DC -23
 DC -25
 DC -26
 DC -28
 DC -29
 DC -30
 DC -32
 DC -33
 DC -34
 DC -36
 DC -37
 DC -38
 DC -39
 DC -41
 DC -42
 DC -43
 DC -44
 DC -45
 DC -46
 DC -47
 DC -48
 DC -48
 DC -49
 DC -50
 DC -51
 DC -51
 DC -52
 DC -52
 DC -53
 DC -53
 DC -54
 DC -54
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -56
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -54
 DC -54
 DC -53
 DC -53
 DC -52
 DC -52
 DC -51
 DC -51
 DC -50
 DC -49
 DC -48
 DC -48
 DC -47
 DC -46
 DC -45
 DC -44
 DC -43
 DC -42
 DC -41
 DC -39
 DC -38
 DC -37
 DC -36
 DC -34
 DC -33
 DC -32
 DC -30
 DC -29
 DC -28
 DC -26
 DC -25
 DC -23
 DC -22
 DC -20
 DC -19
 DC -17
 DC -16
 DC -14
 DC -12
 DC -11
 DC -9
 DC -8
 DC -6

 DC -5
 DC -6
 DC -8
 DC -9
 DC -11
 DC -12
 DC -14
 DC -16
 DC -17
 DC -19
 DC -20
 DC -22
 DC -23
 DC -25
 DC -26
 DC -28
 DC -29
 DC -30
 DC -32
 DC -33
 DC -34
 DC -36
 DC -37
 DC -38
 DC -39
 DC -41
 DC -42
 DC -43
 DC -44
 DC -45
 DC -46
 DC -47
 DC -48
 DC -48
 DC -49
 DC -50
 DC -51
 DC -51
 DC -52
 DC -52
 DC -53
 DC -53
 DC -54
 DC -54
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -56
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -55
 DC -54
 DC -54
 DC -53
 DC -53
 DC -52
 DC -52
 DC -51
 DC -51
 DC -50
 DC -49
 DC -48
 DC -48
 DC -47
 DC -46
 DC -45
 DC -44
 DC -43
 DC -42
 DC -41
 DC -39
 DC -38
 DC -37
 DC -36
 DC -34
 DC -33
 DC -32
 DC -30
 DC -29
 DC -28
 DC -26
 DC -25
 DC -23
 DC -22
 DC -20
 DC -19
 DC -17
 DC -16
 DC -14
 DC -12
 DC -11
 DC -9
 DC -8
 DC -6

 DC.L -1




ZIK	INCBIN	KILLER.ALC
cos_tab	incbin 'COSIN.DAT'
sin_tab	equ cos_tab+720
points	INCBIN	POINTS1.DAT
points2	INCBIN	POINTS2.DAT
	incbin	tsin7.aid
tsin	incbin	tsin7.aid
	incbin	tsin7.aid
tz	incbin	tzoom.aid
EXPLOX	INCBIN	EXPLOX2
EXPLOY	INCBIN	EXPLOY2
KAT	INCBIN	DARRIAN.PI1
f01:	incbin	rounded4.dat	;57000 octets

 	BSS
*** BSS TRANSFO
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SAUVE	DS.L	1	
DEB_BSS
ANC_VBL	DS.L	1	
ANC_TB	DS.L	1	
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
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
xe	ds.w 1
ye	ds.w 1
ze	ds.w 1

xdep	ds.w 1
ydep	ds.w 1
zdep	ds.w 1

xp	ds.w 1
yp	ds.w 1

new_xe	ds.w 1
new_ye	ds.w 1
new_ze	ds.w 1

x_angle	ds.w 1
y_angle	ds.w 1
z_angle	ds.w 1	

z_pt_fuite	ds.w 1

var_3d	ds.w 9
POINTEUR	DS.L	1

DATA_X
	DS	NB_POS*NB_PTS*2
	DS	NB_POS2*NB_PTS*2
	DS	NB_POS2*NB_PTS*2

	DS	NB_POSB*NB_PTSB*2
	DS	NB_POS2B*NB_PTSB*2
	DS	NB_POSB*NB_PTSB*2

CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1
PNT	DS.L	1
PNT_GG	DS.L	1
TIME	DS.L	1
TIME2	DS.L	1
TIME3	DS.L	1
TIME4	DS.L	1
stimb	ds.l	1
*BSS EXPLO
PNTP	DS.L	1
PNT2	DS.L	1
*****BSS CUBE
FLAG_FLEXI	DS.B	1
	even
key	dS.b	1
	even 

t_points	ds.w	20	
;tdroit	ds.w	200
;tgauch	ds.w	200
* BSS FLEXI
PNT_SYNC	DS.L	1
PNT_SYNC2	DS.L	1
BUF	DS.B	128*156*2
COLOR	DS.B	1
FLAG1	DS.B	1
FLAG2	DS.B	1
FLAG3	DS.B	1
FLAG4	DS.B	1
FLAG_T	DS.L	1
PNT_FAD_HC	DS.L	1
PNT_FAD_HC2	DS.L	1
TIME_PASSED	DS.L	1
tdroit	ds.w	800
tgauch	ds.w	800

ad_ecran	ds.l	1
SAVEA0	DS.L	1
lineA_tab:	ds.l 1
routs_pt:	ds.l 1
text_pt:	ds.l 1
text_buff_pt:	ds.l 1
ad_data_pt:	ds.l 1
PNT_261E	DS	1
SAVEA2	DS.L	1
SAVE	DS.L	1
compteurs:	ds.w 2
ad_routines:	ds.l 5
text_buffer:	ds.b 150
text_buffer_deb	equ text_buffer+20
text_buffer_end:ds.l 1
PNT_FAD	DS.L	1
PNT_FAD2	DS.L	1
pntcolor	ds.l	1
PNTP2	DS.L	1
FLAG	DS.L	1
SAVEALL	DS.L	16
off_bolean:	ds.b 500
EMUL_LINEA	DS.B	60
SAVE_ALL	DS.L	16
BUF16DA	DS.B	512
PtsFill:	ds.b	512
DONNEE	DS	1
DONNEE2	DS	1
DONNEE3	DS	1
DONNEE4	DS	1
TIME_CUBE	DS.L	1
PNT_EFECT	DS.L	1
PNT_EFECT2	DS.L	1
efecr	DS.B	2416
END_BSS
