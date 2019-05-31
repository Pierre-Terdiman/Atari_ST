LARG_FONTE = 32
HAUT_FONTE = 29

	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVEQ	#2,D0
	JSR	ZIK

	LEA	FIN,A0
	MOVE.L	A0,$008.W
	MOVE.L	A0,$00C.W
	MOVE.L	A0,$010.W
	MOVE.L	A0,$014.W
	MOVE.L	A0,$018.W
	MOVE.L	A0,$01C.W
	MOVE.L	A0,$020.W

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	move.l	SCREEN1,$44e.w

	MOVE.L	#TEXT,PT_TEXT
	MOVE.W	#0,PART_FONTE
	MOVE.W	#152,PT_BUF
	MOVE.L	#FONTS+34+(160*29*5),SOV_ADR
	MOVE.W	#4,NO_DEC
	MOVE.W	#0,PT_AFF

	CLR.W	VBL_FLAG
INIT_FLEXI
	MOVE.L	#text,TEXT_EC
	move.l	#COURB1,COURB_EC
	MOVE	#128-1,COLONNE

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
	bsr text_convert
	lea text_buffer_end,a0
	MOVEA.L	TEXT_EC,a1
	lea font,a2
	moveq #0,d0
	move d0,d1
	move #30-1,d7	;30*5=150
text_lp:
	move.b (a1)+,d0
	move.b 3(a2,d0.w),-(a0)
	move.b 2(a2,d0.w),-(a0)
	move.b 1(a2,d0.w),-(a0)
	move.b 0(a2,d0.w),-(a0)
	move.b d1,-(a0)
	dbra d7,text_lp
	move.l a1,text_pt

	lea compteurs,a3
	
	bsr construction
	
	lea ad_routines,a0
	move.l 16(a0),a2	;routine d'effa‡age
	move #-4,(a3)	;images
	move #-20,2(a3)	;compteur pour le scroll du buffer de texte 
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	MOVEM.L	D0-A6,SAVE_ALL
*******
	MOVEM.L	FONTS+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.W	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	MOVE.L	#VBL_DEBUT,$70.W
	MOVE.L	#TB0,$120.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

;	BSET	#0,$FFFFFA07.W
;	BSET	#5,$FFFFFA07.W
;	BSET	#6,$FFFFFA09.W
;	MOVE.B	$FFFFFA07.W,$FFFFFA13.W
;	MOVE.B	$FFFFFA09.W,$FFFFFA15.W
;	MOVE.B	#$40,$FFFFFA17.W
	MOVE.W	#$2300,SR

JUMP	BRA.S	JUMP

FIN	MOVE.L	4.W,A0
	JMP	(A0)
TIME	DC.L	0
VBL_DEBUT	ADDQ.L	#1,TIME
	CLR.B	$FFFFFA1B.W
	ADDQ.B	#2,CHG
CHG_2	EQU	*+3
	MOVE.B	#99,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	CMPI.B	#2,CHG_2
	BNE.S	SUITE_1
	MOVE.L	#VBL_PART1,$70.W
SUITE_1	SUBQ.B	#1,CHG_2
	JSR	ZIK+8
	RTE

VBL_PART1	CMPI.L	#700,TIME
	BGE.S	NO_MUS2
	CMPI.L	#648,TIME
	BNE.S	NO_MUS
	MOVEQ	#1,D0
	JSR	ZIK
	MOVE.L	#700,TIME
NO_MUS	
	ADDQ.L	#1,TIME
NO_MUS2	CLR.B	$FFFFFA1B.W
	MOVE.L	#TIMER0,$120.W
	MOVE	#$777,$FFFF8242.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	JSR	SCROL_ROUTY
	JSR	FLEXI_ROUTY
	JSR	ZIK+8
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

RTE	RTE

TB0
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8240.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB1
	CLR.B	$FFFFFA1B.W
	MOVE	#$001,$FFFF8240.W
CHG	EQU	*+3
	MOVE.B	#0,$FFFFFA21.W	;197
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB2
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8240.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3
	CLR.B	$FFFFFA1B.W
	CLR	$FFFF8240.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB0,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TIMER0
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8240.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TIMER1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TIMER1
	CLR.B	$FFFFFA1B.W
	MOVE	#$001,$FFFF8240.W
	MOVE.B	#20,$FFFFFA21.W	197-35
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TCOL1
	CLR.B	$FFFFFA1B.W
	MOVE	#$112,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TCOL2
	CLR.B	$FFFFFA1B.W
	MOVE	#$223,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL3
	CLR.B	$FFFFFA1B.W
	MOVE	#$334,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL4,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL4
	CLR.B	$FFFFFA1B.W
	MOVE	#$445,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL5,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL5
	CLR.B	$FFFFFA1B.W
	MOVE	#$556,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL6,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TCOL6
	CLR.B	$FFFFFA1B.W
	MOVE	#$667,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL7,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL7
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL8,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL8
	CLR.B	$FFFFFA1B.W
	MOVE	#$667,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL9,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL9
	CLR.B	$FFFFFA1B.W
	MOVE	#$556,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL10,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TCOL10
	CLR.B	$FFFFFA1B.W
	MOVE	#$445,$FFFF8242.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TCOL11,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TCOL11
	CLR.B	$FFFFFA1B.W
	MOVE	#$334,$FFFF8242.W
	MOVE.B	#42,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TIMER2B,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TIMER2B
	CLR.B	$FFFFFA1B.W
	MOVEM.L	D0-D7,-(SP)
	MOVEM.L	FONTS+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVEM.L	(SP)+,D0-D7
	MOVE.B	#35,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TIMER2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TIMER2
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8240.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TIMER3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TIMER3
	CLR.B	$FFFFFA1B.W
	CLR	$FFFF8240.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TIMER0,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TA0	RTE

SCROL_ROUTY	;CMPI.W	#1,VBL_FLAG
	;BLT.S	IT_VBL

	BSR	GEST_SCROLL
	BSR	SWAPEC
	RTS
	;CLR.W	VBL_FLAG
	;BRA	IT_VBL

GEST_SCROLL	MOVE.W	NO_DEC,D0
	JMP	ROUTS_DEC(PC,D0.W)
ROUTS_DEC	BRA	DEC_0
	BRA	DEC_1
	BRA	DEC_2
	BRA	DEC_3

GEST_AFFICH	
	MOVE.L	SCREEN2,A1
	LEA	160*(200-32)(A1),A1
	MOVE.W	PT_AFF,D0
	JMP	ROUTS_AFF(PC,D0.W)
ROUTS_AFF	BRA	AFF_20_00
	BRA	AFF_19_01
	BRA	AFF_18_02
	BRA	AFF_17_03
	BRA	AFF_16_04
	BRA	AFF_15_05
	BRA	AFF_14_06
	BRA	AFF_13_07
	BRA	AFF_12_08
	BRA	AFF_11_09
	BRA	AFF_10_10
	BRA	AFF_09_11
	BRA	AFF_08_12
	BRA	AFF_07_13
	BRA	AFF_06_14
	BRA	AFF_05_15
	BRA	AFF_04_16
	BRA	AFF_03_17
	BRA	AFF_02_18
	BRA	AFF_01_19

DEC_0	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL,A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVE.L	(A2)+,(A3)+
	MOVE.L	(A2)+,(A3)+
	LEA	152(A2),A2
	LEA	152(A3),A3
	DBRA	D7,.RECOP_FONTE
	MOVE.W	#4,NO_DEC
	LEA	BUFFER_SCROLL,A0
	BSR	GEST_AFFICH
	MOVE.W	PT_BUF,D0
	ADDQ.W	#8,D0
	CMPI.W	#160,D0
	BLT.S	.C_EST_BON_1
	MOVEQ	#0,D0
.C_EST_BON_1	MOVE.W	D0,PT_BUF
	MOVE.W	PT_AFF,D0
	ADDQ.W	#4,D0
	CMPI.W	#80,D0
	BLT.S	.C_EST_BON_2
	MOVEQ	#0,D0
.C_EST_BON_2	MOVE.W	D0,PT_AFF
	MOVE.L	PT_TEXT,A0
	MOVE.W	PART_FONTE,D0
	ADDQ.W	#8,D0
	CMPI.W	#LARG_FONTE/2,D0
	BLT.S	.C_EST_BON_3
	MOVEQ	#0,D0
	ADDQ.W	#1,A0
	CMPI.B	#-1,10(A0)
	BNE.S	.C_EST_BON_3
	LEA	TEXT,A0
.C_EST_BON_3	MOVE.W	D0,PART_FONTE
	MOVE.L	A0,PT_TEXT
	RTS

DEC_1	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE),A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVE.L	SOV_ADR,A4
	MOVE.L	#$F000F,D5
	MOVE.L	#$FFF0FFF0,D6
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVE.L	(A4)+,D0	PLAN 1&2
	MOVE.L	(A4)+,D1	PLAN 3&4
	MOVE.L	(A2)+,D2	PLAN 1&2
	MOVE.L	(A2)+,D3	PLAN 3&4
	LSL.L	#4,D0
	LSL.L	#4,D1
	AND.L	D6,D0
	AND.L	D6,D1
	ROL.L	#4,D2
	ROL.L	#4,D3
	AND.L	D5,D2
	AND.L	D5,D3
	SWAP	D2
	SWAP	D3
	OR.L	D0,D2
	OR.L	D1,D3
	MOVE.L	D2,(A3)+
	MOVE.L	D3,(A3)+
	LEA	152(A2),A2
	LEA	152(A3),A3
	LEA	152(A4),A4
	DBRA	D7,.RECOP_FONTE
	MOVE.W	#8,NO_DEC
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE),A0
	BSR	GEST_AFFICH
	RTS

DEC_2	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*2),A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVE.L	SOV_ADR,A4
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVEP.L	1(A4),D0
	MOVEP.L	(A2),D1
	MOVEP.L	D0,(A3)
	MOVEP.L	D1,1(A3)
	LEA	160(A2),A2
	LEA	160(A3),A3
	LEA	160(A4),A4
	DBRA	D7,.RECOP_FONTE
	MOVE.W	#12,NO_DEC
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*2),A0
	BSR	GEST_AFFICH
	RTS

DEC_3	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*3),A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVE.L	SOV_ADR,A4

	MOVE.L	A2,SOV_ADR	;TRES IMPORTANT

	MOVE.L	#$0FFF,D5
	MOVE.L	#$F000F000,D6
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVE.L	(A4)+,D0	PLAN 1&2
	MOVE.L	(A4)+,D1	PLAN 3&4
	MOVE.L	(A2)+,D2	PLAN 1&2
	MOVE.L	(A2)+,D3	PLAN 3&4
	ROR.L	#4,D0
	ROR.L	#4,D1
	AND.L	D6,D0
	AND.L	D6,D1
	SWAP	D0
	SWAP	D1
	LSR.L	#4,D2
	LSR.L	#4,D3
	AND.W	D5,D2
	AND.W	D5,D3
	OR.L	D0,D2
	OR.L	D1,D3
	MOVE.L	D2,(A3)+
	MOVE.L	D3,(A3)+
	LEA	152(A2),A2
	LEA	152(A3),A3
	LEA	152(A4),A4
	DBRA	D7,.RECOP_FONTE
	CLR.W	NO_DEC
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*3),A0
	BSR	GEST_AFFICH
	RTS

AFF_20_00	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D6
	MOVEM.L	D0-D6,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_20_00+2
	RTS

AFF_19_01	MOVEQ	#HAUT_FONTE-1,D7
	MOVE.L	(A0)+,152(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_19_01+2
	RTS

AFF_18_02	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,144(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_18_02+2
	RTS

AFF_17_03	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,136(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVE.L	(A0)+,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_17_03+2
	RTS

AFF_16_04	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,128(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_16_04+2
	RTS

AFF_15_05	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,120(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_15_05+2
	RTS

AFF_14_06	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,112(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_14_06+2
	RTS

AFF_13_07	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,104(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,148(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_13_07+2
	RTS

AFF_12_08	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,96(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,140(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVE.L	(A0)+,88(A1)
	MOVE.L	(A0)+,92(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_12_08+2
	RTS

AFF_11_09	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D6
	MOVEM.L	D0-D6,132(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_11_09+2
	RTS

AFF_10_10	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,80(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A3
	MOVEM.L	D0-D6/A2-A3,124(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A3
	MOVEM.L	D0-D6/A2-A3,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_10_10+2
	RTS

AFF_09_11	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,72(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,116(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6
	MOVEM.L	D0-D6,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_09_11+2
	RTS

AFF_08_12	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,64(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,108(A1)
	MOVE.L	(A0)+,152(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_08_12+2
	RTS

AFF_07_13	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,56(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,100(A1)
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,144(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_07_13+2
	RTS

AFF_06_14	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,48(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,92(A1)
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,136(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVE.L	(A0)+,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_06_14+2
	RTS

AFF_05_15	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,40(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,84(A1)
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,128(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_05_15+2
	RTS

AFF_04_16	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,32(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,76(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,120(A1)
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_04_16+2
	RTS

AFF_03_17	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,24(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,68(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,112(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_03_17+2
	RTS

AFF_02_18	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,16(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,60(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,104(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,148(A1)
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_02_18+2
	RTS

AFF_01_19	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,8(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,52(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,96(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,140(A1)
	MOVE.L	(A0)+,(A1)
	MOVE.L	(A0)+,4(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_01_19+2
	RTS


SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
**
FLEXI_ROUTY
	MOVEM.L	SAVE_ALL,D0-A6
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4

	move.l	#$ffffffff,d6
	move.l text_buff_pt,a5
	move.l SCREEN1,a6
	lea	-50*160(a6),a6

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICA
	move #$200,$ffff8240.w
HICA

	jsr (a2)
	move.l (a0)+,a1
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HIC
	move #$100,$ffff8240.w
HIC
	jsr (a1)

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICq
	move #$007,$ffff8240.w
HICq

;	clr	$ffff8240.w
	
	addQ #1,(a3)
	bne END_ROUTY

	move #-4,(a3)
	lea ad_routines,a0
	sub.l d1,text_buff_pt
	
	addQ #1,2(a3)
	bne END_ROUTY
	
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
	move #4-1,d7	;4*5=20
text_lp2:
	move.b (a1)+,d0
	cmpi.b	#255,d0
	bne.s	pas_la_fin
	MOVEA.L	TEXT_EC,A1
	move.l a1,text_pt
	move.b (a1)+,d0
pas_la_fin
	move.b 3(a6,d0.w),-(a5)
	move.b 2(a6,d0.w),-(a5)
	move.b 1(a6,d0.w),-(a5)
	move.b 0(a6,d0.w),-(a5)
	move.b d1,-(a5)
	dbra d7,text_lp2
	move.l a1,text_pt
END_ROUTY	
	MOVEM.L	D0-A6,SAVE_ALL
	RTS
	
text_convert:
	MOVEA.L	TEXT_EC,A0
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

construction:
	movem.l a0-a6/d1/d7,-(sp)
	
	lea off_bolean,a6	;effa‡age des bits
	move #125-1,d7	;500 octets
	moveq #0,d6
off_bol_lp:
	move.l d6,(a6)+
	dbra d7,off_bol_lp

	move.l #ad_routines,routs_pt
	lea	PtsFill,a3	;tableau ptsin
	move.l a3,usp
	move.l	COURB_EC,a4
	
	move.l lineA_tab,a6
	lea routines,a5

	move #4-1,d7	;4 pas
pas_lp:
	move d7,-(sp)
	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move COLONNE,d7	;128 colonnes
col_lp:

	move #$1e1d,(a5)+	;move.b (a5)+,d7
	move #5-1,d6		;5 lignes
ligne_lp:

	CLR	D5
	move.b d6,d5		;pour obtenir code du btst
	
	MOVE	#$0807,(A5)+
	move	d5,(a5)+

	move.l a5,-(sp)
	move #$6700,(a5)+	;beq.s (offset … d‚finir)

	move.l (a4),(a3)+	;l,c
	move.l 4(a4),(a3)+	;l+1,c
	move.l 4+24(a4),(a3)+	;l+1,c+1
	move.l 24(a4),(a3)+	;l,c+1
	move.l (a4),(a3)	;l,c
	move.l usp,a3
	addq #4,a4

	move #+30000,d4	;ymin
	move #-30000,d5	;ymax
	move 2(a3),d3	;recherche de ymin et ymax
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
	sub d4,d5	;ymax-ymin
	move d5,d3	;sauve le compteur en y

	move d4,40(a6)	;affichage du polygone avec $a006
aff_lp:	
	MOVEM.L	D0-D7/A0-A6,-(A7)
	jsr	FILL1
	MOVEM.L	(A7)+,D0-D7/A0-A6

	addQ #1,40(a6)
	dbra d5,aff_lp

	REPT 4	;affichage des 4 lignes afin d'obtenir
	move.l (a3)+,38(a6)	; la meme forme qu'avec polyfill.
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

	bsr	DRAW_A_LINE


	movem.l (a7)+,d0-d7/a0-a6

	ENDR
	
	move.l usp,a3

	move #+30000,d0	;xmin
	move #-30000,d1	;xmax
	move (a3),d2	;recherche de xmin et xmax
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
	lsr #4,d0	;on obtient le num‚ro du groupe de 16 pixels
	lsr #4,d1
	sub d0,d1	;compteur
	lsl #3,d0	;*8 => offset en x
	muls #160,d4	;ymin*160 => offset en y
	add d4,d0	;offset / ad ‚cran en .w

	move.l SCREEN1,a0

	move d6,-(sp)
	move d7,-(sp)
	move.l a6,-(sp)
	lea off_bolean,a6
scan_y:		;rep‚rage du polygone
	move d0,d4	;sauvegarde des compteurs
	move d1,d2
scan_x:
	move (a0,d4.w),d5
	beq.s or_nul
	clr (a0,d4.w)	;effa‡age

	cmp	#$ffff,d5
	beq.s	move1
	move #$006e,(a5)+	;or #$uuuu,vv(a6)
	move d5,(a5)+	;$uuuu
	move d4,(a5)+	;vv=d16
	bra.s	okay
move1	move #$3d46,(a5)+	;move d6,vv(a6)
	move d4,(a5)+	;vv=d16
okay	move d4,d6	;note l'offset pour l'effa‡age (tjs >=0)
	lsr #3,d6
	move d6,d7
	and #$0007,d6
	lsr #3,d7
	bset.b d6,(a6,d7.w)
or_nul:
	addq #8,d4	;groupe suivant
	dbra d2,scan_x

	add #160,d0	;ligne suivante
	dbra d3,scan_y

	move.l (sp)+,a6
	move (sp)+,d7
	move (sp)+,d6

	move.l a5,d0	;on peut calculer l'offset pour beq.s
	move.l (sp)+,a1
	sub.l a1,d0
	subq #2,d0
	cmp #127,d0	;ok pour beq.S ?
	blo.s offset_short
	move #$6700,(a1)+	;beq.l
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
	move.b d0,1(a1)		;offset pour le beq.s
off_l_fin:

	cmp.l #routines+330000,a5
	blo.s mem_ok
	jmp	FIN
mem_ok:

	dbra d6,ligne_lp
	addq #4,a4

	dbra d7,col_lp
	add #24,a4

	move (sp)+,d7
	move #$4e75,(a5)+	;rts
	dbra d7,pas_lp



	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #$7e00,(a5)+	;moveq #0,d7
	lea off_bolean,a0	;routine d'effa‡age: les bits concernent
	moveq #0,d5	; les mots du premier plan,dans l'ordre;
	move #500-1,d7	; bit=1 effacer plan 1 de ce groupe de 16 
off_oct_lp:		; pixels, ne rien faire sinon.
	move.b (a0)+,d5
	moveq #8-1,d6
off_bit_lp:
	btst d6,d5
	beq.s bit_nul_off
	move #$3d47,(a5)+	;move d7,xx(a6)
	move #499,d4
	sub d7,d4
	lsl #3,d4
	add d6,d4
	lsl #3,d4
	move d4,(a5)+		;offset
	
	cmp.l #routines+330000,a5
	blo.s mem_ok2
	jmp	FIN
mem_ok2:

bit_nul_off:
	dbra d6,off_bit_lp
	dbra d7,off_oct_lp
	
	move #$4e75,(a5)+	;rts

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

	AND.W	50(A4),D0	MASK DU SAMPLE REMPLISSAGE
	ADD.W	D0,D0
	
	MOVEA.L	46(A4),A0	PNTEUR SUR SAMPLE REMPLISSAGE
	ADDA.W	D0,A0	
	
	TST.W	52(A4)	1 OU POLYPLANS
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
	MULS.W	#160,D5
	ADDA.L	D5,A1

	MOVEA.W	D0,A2

	MOVE.W	#4,D7	NB PLANS
	MOVE	#8,D0
	MULS.W	D0,D1	
	ADDA.L	D1,A1	A1=SCREEN

	LEA	24(A4),A3	VALEUR DE LA COLOR DU PLAN 0

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
	cmp.w	d1,d3
	beq	DRAW_HORIZONTAL
	cmp.w	d0,d2
	beq	DRAW_VERTICAL

	move.w	d0,d5
	move.w	d1,d6
	ext.l	d5
	ext.l	d6
	lsl.w	#1,d6
	lea	SCREEN_Y_TABLE,a0
	move.l	#0,a1
	move.w	(a0,d6),a1
	movea.l	$44e.w,a0
	add.l	a1,a0
	and.l	#$fffffff0,d5
	lsr.w	#1,d5
	add.l	d5,a0
	move.w	d0,d5
	eor.w	#$0f,d5
	and.w	#$0f,d5
	clr.w	d6
	bset	d5,d6
	move.w	d6,d7
	not.w	d6

	sub.w	d0,d2
	sub.w	d1,d3

	move.l	#0,a1
	move.l	#0,a2
	move.l	#0,a3
	move.l	#0,a4
	
	tst.w	d2
	bpl.s	.dr_1
	beq.s	.dr_2
	move.w	#-1,a1
	neg.w	d2
	bra.s	.dr_2
.dr_1
	move.w	#1,a1
.dr_2
	tst.w	d3
	bpl.s	.dr_3
	beq.s	.dr_4
	move.w	#-1,a2
	neg.w	d3
	bra.s	.dr_4
.dr_3
	move.w	#1,a2
.dr_4
	cmp.w	d2,d3
	blt.s	.dr_5
	move.w	a2,a4
	exg	d2,d3
	bra.s	.dr_6
.dr_5
	move.w	a1,a3
.dr_6 
	move.w	d2,d0
	lsr.w	#1,d0
	move.w	d2,d1
.dr_7
	or.w	d7,(a0)
	add.w	d3,d0
	cmp.w	d0,d2
	bgt.s	.dr_8
	sub.w	d2,d0
	cmp.w	#0,a1
	beq.s	.dr_A5
	bmi.s	.dr_A6
	ror.w	#1,d6
	ror.w	#1,d7
	bcc.s	.dr_A5
	addq.l	#8,a0
	bra.s	.dr_A5
.dr_A6
	rol.w	#1,d6
	rol.w	#1,d7
	bcc.s	.dr_A5
	subq.l	#8,a0
.dr_A5
	cmp.w	#0,a2
	beq.s	.dr_A3
	bmi.s	.dr_A8
	lea	160(a0),a0
	bra.s	.dr_A3
.dr_A8
	lea	-160(a0),a0
	bra.s	.dr_A3
.dr_8
	cmp.w	#0,a3
	beq.s	.dr_A1
	bmi.s	.dr_A2
	ror.w	#1,d6
	ror.w	#1,d7
	bcc.s	.dr_A3
	addq.l	#8,a0
	bra.s	.dr_A3
.dr_A2
	rol.w	#1,d6
	rol.w	#1,d7
	bcc.s	.dr_A3
	subq.l	#8,a0
	bra.s	.dr_A3
.dr_A1
	cmp.w	#0,a4
	bmi.s	.dr_A4
	lea	160(a0),a0
	bra.s	.dr_A3
.dr_A4
	lea	-160(a0),a0
.dr_A3
	dbf	d1,.dr_7
	rts

DRAW_HORIZONTAL
	cmp.w	d0,d2
	bne.s	.dr_h_1
	rts
.dr_h_1
	bgt.s	.dr_h_2
	exg	d0,d2
.dr_h_2
	move.w	d0,d5
	move.w	d1,d6
	ext.l	d5
	ext.l	d6
	lsl.w	#1,d6
	lea	SCREEN_Y_TABLE,a0
	move.l	#0,a1
	move.w	(a0,d6),a1
	movea.l	$44e.w,a0
	add.l	a1,a0
	and.l	#$fffffff0,d5
	lsr.w	#1,d5
	add.l	d5,a0

	move.w	d2,d3
	move.w	d0,d6
	
	and.w	#$fff0,d6
	lsr.w	#4,d6
	and.w	#$fff0,d2
	lsr.w	#4,d2
	
	sub.w	d6,d2

	lea	PIXEL_TABLE_LEFT,a1
	and.w	#$000f,d0
	lsl.w	#1,d0
	move.w	(a1,d0),d0
	lea	PIXEL_TABLE_RIGHT,a1
	and.w	#$000f,d3
	lsl.w	#1,d3
	move.w	(a1,d3),d3

	tst	d2
	bne.s	.dr_h_7
	
	and.w	d0,d3
	move.w	d3,d6
	move.w	d3,d7
	not.w	d7
	bra.s	.dr_h_m_1
.dr_h_7
	subq.w	#1,d2
	bne.s	.dr_h_8
	
	move.w	d0,d6
	move.w	d0,d7
	not.w	d7
	bsr.S	.dr_h_m_1
	
	move.w	d3,d6
	move.w	d3,d7
	not.w	d7
	bra.s	.dr_h_m_1
.dr_h_8
	move.w	d0,d6
	move.w	d0,d7
	not.w	d7
	bsr.S	.dr_h_m_1

	subq.w	#1,d2
	move.w	#$ffff,d6
	clr.w	d7
.dr_h_9
	bsr.S	.dr_h_m_1
	dbf	d2,.dr_h_9
	
	move.w	d3,d6
	move.w	d3,d7
	not.w	d7

.dr_h_m_1
	or.w	d6,(a0)
	lea	8(a0),a0
	rts

DRAW_VERTICAL
	cmp.w	d1,d3
	bgt.s	.dr_v_1
	exg	d1,d3
.dr_v_1
	move.w	d0,d5
	move.w	d1,d6
	ext.l	d5
	ext.l	d6
	lsl.w	#1,d6
	lea	SCREEN_Y_TABLE,a0
	move.l	#0,a1
	move.w	(a0,d6),a1
	movea.l	$44e.w,a0
	add.l	a1,a0
	and.l	#$fffffff0,d5
	lsr.w	#1,d5
	add.l	d5,a0

	eor.w	#$0f,d0
	and.w	#$0f,d0
	clr.w	d6
	bset	d0,d6
	move.w	d6,d7
	not.w	d7

	sub.w	d1,d3
.dr_v_m_1
	or.w	d6,(a0)

	lea	160(a0),a0
	dbf	d3,.dr_v_m_1
	rts

	DATA	
ZIK	INCBIN	ULM.MUS
	EVEN
FONTS	INCBIN	NPG.DAT
	DS.B	160*29
CORES_FONTS	
N	SET	0
N2	SET	160*(HAUT_FONTE)
N3	SET	160*(HAUT_FONTE)*2
N4	SET	160*(HAUT_FONTE)*3
N5	SET	160*(HAUT_FONTE)*4
N6	SET	160*(HAUT_FONTE)*5
	DC	N6	ESP
	DC	N4+1*16	!
	DC	N3+8*16	"
	DC	N6	#
	DC	N6	$
	DC	N6	%
	DC	N6	&
	DC	N4+16*5	'
	DC	N4+16*3	(
	DC	N4+16*4	)
	DC	N6	*
	DC	N4	+
	DC	N3+16*7	,
	DC	N3+16*9	-
	DC	N3+16*6	.
	DC	N6	/
	DC	N4+16*8	0
	DC	N4+16*9	1
NN	SET	0
	REPT	8
	DC	N5+NN
NN	SET	NN+16
	ENDR
	DC	N4+16*6	:
	DC	N4+16*7	;
	DC	N5+160-16*2	<
	DC	N6	=
	DC	N5+160-16	>
	DC	N4+16*2	?
	DC	N6

	DC.W	N,N+16,N+32,N+48,N+64,N+80,N+96,N+112,N+128,N+144
	DC.W	N2,N2+16,N2+32,N2+48,N2+64,N2+80,N2+96,N2+112,N2+128,N2+144
	DC.W	N3,N3+16,N3+32,N3+48,N3+64,N3+80

TEXT	DC.B	"  -HOLOCAUST- PRESENTS A NEW MULTIPART CALLED...  'SUICIDAL LEVEL'...   "
	DC.B	" PREPARE TO BE HARDBOILED! "
	DC.B	"                    ",-1
	EVEN
** DATAS FLEXI
SCREEN_Y_TABLE
	dc.w	0,160,320,480,640,800,960,1120,1280,1440,1600,1760,1920,2080,2240
	dc.w	2400,2560,2720,2880,3040,3200,3360,3520,3680,3840,4000,4160,4320,4480,4640
	dc.w	4800,4960,5120,5280,5440,5600,5760,5920,6080,6240,6400,6560,6720,6880,7040
	dc.w	7200,7360,7520,7680,7840,8000,8160,8320,8480,8640,8800,8960,9120,9280,9440
	dc.w	9600,9760,9920,10080,10240,10400,10560,10720,10880,11040,11200,11360,11520,11680,11840
	dc.w	12000,12160,12320,12480,12640,12800,12960,13120,13280,13440,13600,13760,13920,14080,14240
	dc.w	14400,14560,14720,14880,15040,15200,15360,15520,15680,15840,16000,16160,16320,16480,16640
	dc.w	16800,16960,17120,17280,17440,17600,17760,17920,18080,18240,18400,18560,18720,18880,19040
	dc.w	19200,19360,19520,19680,19840,20000,20160,20320,20480,20640,20800,20960,21120,21280,21440
	dc.w	21600,21760,21920,22080,22240,22400,22560,22720,22880,23040,23200,23360,23520,23680,23840
	dc.w	24000,24160,24320,24480,24640,24800,24960,25120,25280,25440,25600,25760,25920,26080,26240
	dc.w	26400,26560,26720,26880,27040,27200,27360,27520,27680,27840,28000,28160,28320,28480,28640
	dc.w	28800,28960,29120,29280,29440,29600,29760,29920,30080,30240,30400,30560,30720,30880,31040
	dc.w	31200,31360,31520,31680,31840
PIXEL_TABLE_LEFT
	dc.w	%1111111111111111
	dc.w	%0111111111111111
	dc.w	%0011111111111111
	dc.w	%0001111111111111
	dc.w	%0000111111111111
	dc.w	%0000011111111111
	dc.w	%0000001111111111
	dc.w	%0000000111111111
	dc.w	%0000000011111111
	dc.w	%0000000001111111
	dc.w	%0000000000111111
	dc.w	%0000000000011111
	dc.w	%0000000000001111
	dc.w	%0000000000000111
	dc.w	%0000000000000011
	dc.w	%0000000000000001
PIXEL_TABLE_RIGHT
	dc.w	%1000000000000000
	dc.w	%1100000000000000
	dc.w	%1110000000000000
	dc.w	%1111000000000000
	dc.w	%1111100000000000
	dc.w	%1111110000000000
	dc.w	%1111111000000000
	dc.w	%1111111100000000
	dc.w	%1111111110000000
	dc.w	%1111111111000000
	dc.w	%1111111111100000
	dc.w	%1111111111110000
	dc.w	%1111111111111000
	dc.w	%1111111111111100
	dc.w	%1111111111111110
	dc.w	%1111111111111111

MESS_X_COORD	dc.w	0
MESS_Y_COORD	dc.w	0

pattern:	dc.w $ffff

COURB1	incbin	flexi.dat
	
text:
 dc.b "                                                   "
 DC.B "HOLOCAUST IS BACK TO WIN!   FLEXIBLE... THIS IS A FLEXISCROLLER!  "
 DC.B "     A LOT BETTER THAN GRIFF'S ONE, OF COURSE!       "
 dc.b "                  "
	dc.b 255,255	 *2!

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
*****FIN DATAS FLEXI
	SECTION	BSS
	DS.B	256
BUFFER	DS.L	16000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
VBL_FLAG	DS.W	1
BUFFER_SCROLL	DS.L	40*HAUT_FONTE*4
PT_TEXT	DS.L	1
PT_BUF	DS.W	1
SOV_ADR	DS.L	1
NO_DEC	DS.W	1
PT_AFF	DS.W	1
PART_FONTE	DS.W	1
*BSS FLEXI
lineA_tab:	ds.l 1
routs_pt:	ds.l 1
text_pt:	ds.l 1
text_buff_pt:	ds.l 1
PNT_261E	DS	1
compteurs:	ds.w 2
ad_routines:	ds.l 5
text_buffer:	ds.b 150
text_buffer_deb	equ text_buffer+20
text_buffer_end:ds.l 1
off_bolean:	ds.b 500
EMUL_LINEA	DS.B	60
SAVE_ALL	DS.L	16
BUF16DA	DS.B	512
PtsFill:	ds.b	512
*****
COURB_EC	DS.L	1
TEXT_EC	DS.L	1
COLONNE	DS	1
routines	DS.B	170000
