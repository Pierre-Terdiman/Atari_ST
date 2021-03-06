LARG_FONTE = 32
HAUT_FONTE = 32

	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.L	#TEXT,PT_TEXT
	CLR	PART_FONTE
	MOVE.W	#152,PT_BUF
	MOVE.L	#FONTS+34+(160*96)+96,SOV_ADR
	MOVE.W	#4,NO_DEC
	CLR	PT_AFF


	
	LEA	COD,A0
	LEA	TABLE,A1
UN_DE_PLUS	MOVE.L	A0,(A1)+
CHERCHE	MOVE	(A0)+,D0
	CMPI	#$4E75,D0
	BNE.S	CHERCHE
	CMPI.L	#-1,(A1)
	BEQ.S	FINITO
	BRA.S	UN_DE_PLUS
FINITO

	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2


	LEA	BIG_DATA,A0
	MOVE.L	SCREEN2,A1
	JSR	decrunch
	MOVEM.L	2(A1),D0-D7
	LEA	PAL_LOGO,A0
	MOVEM.L	D0-D7,(A0)

	MOVE	#7,D0
EFFDEBUT	CLR.L	(A1)+
	DBF	D0,EFFDEBUT
	CLR	(A1)+
	MOVEA.L	SCREEN1,A1
	LEA	160*12(A1),A1
	MOVEA.L	SCREEN2,A2
	LEA	34(A2),A2
	MOVE	#(40*56)-1,D0
AFF_LOGO	MOVE.L	(A2),(A1)+
	CLR.L	(A2)+
	DBF	D0,AFF_LOGO

	MOVEA.L	SCREEN1,A1
	LEA	160*(12+57)(A1),A1
	MOVEA.L	SCREEN1,A2
	LEA	160*(12+56)(A2),A2
	MOVE	#27,D1
AFF_LOGO1	MOVE	#39,D0
AFF_LOGO2	MOVE.L	(A2)+,(A1)+
	DBF	D0,AFF_LOGO2
	LEA	-480(A2),A2
	DBF	D1,AFF_LOGO1
	MOVEA.L	SCREEN1,A0
	MOVEA.L	SCREEN2,A1
	MOVE	#7999,D0
COPY	MOVE.L	(A0)+,(A1)+
	DBF	D0,COPY


;	MOVE.L	SCREEN1,A0
;	LEA	160*(192-43)(A0),A0
;N	SET	0
;	REPT	20
;	MOVE	#$FFFF,N(A0)
;N	SET	N+8
;	ENDR

	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	LEA	160*(192-42)+2(A0),A0
	LEA	160*(192-42)+2(A1),A1
	MOVE	#(20*42)-1,D0
DO_LIGNE	MOVE	#$FFFF,(A0)
	MOVE	#$FFFF,(A1)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	DBF	D0,DO_LIGNE


AFF_CADRE	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A2
	LEA	192*160(A0),A1
	LEA	192*160(A2),A3
	MOVE	#7,D1
DO_Y	MOVE	#19,D0
DO_X	MOVE	#$FFFF,(A0)
	MOVE	#$FFFF,(A1)
	MOVE	#$FFFF,(A2)
	MOVE	#$FFFF,(A3)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	ADDQ.L	#8,A2
	ADDQ.L	#8,A3
	DBF	D0,DO_X
	DBF	D1,DO_Y

	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	MOVE	#(192-43)-1,D0
DO_PIX	MOVE.B	#$FF,(A0)
	MOVE.B	#$FF,(A1)
	MOVE.B	#$FF,153(A0)
	MOVE.B	#$FF,153(A1)
	LEA	160(A0),A0
	LEA	160(A1),A1
	DBF	D0,DO_PIX

	MOVE.L	SCREEN1,A0
	LEA	160*149(A0),A0
	MOVE.L	SCREEN2,A1
	LEA	160*149(A1),A1
	MOVE	#50,D0
DO_PIXU	MOVE.B	#$FF,4(A0)
	MOVE.B	#$FF,4(A1)
	MOVE.B	#$FF,153+4(A0)
	MOVE.B	#$FF,153+4(A1)
	LEA	160(A0),A0
	LEA	160(A1),A1
	DBF	D0,DO_PIXU
	
	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	MOVE.L	SCREEN1,A0
	LEA	160*50(A0),A0
	JSR	8*4(A1)
	MOVE.L	SCREEN2,A0
	LEA	160*50(A0),A0
	JSR	8*4(A1)
	
	LEA	TABLE+4,A1
	MOVE.L	A1,MOD_A1

		
	MOVE.L	#INTER_RTE,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	
	MOVE.L	#VBL_IR,$70.W
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

JUMP	BRA.S	JUMP
;0000
;0001
;0010
;0011
;0100
;0101
;0110
;0111
;1000
;1001
;1010
;1011
;1100
;1101
;1110
;1111
VBL_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#192-43-37,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	LEA	PAL_LOGO,A0
	MOVEM.L	(A0),D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

MOD_A1	EQU	*+2
	LEA	MOD_A1,A1
	MOVE.L	(A1)+,A2
	CMPI.L	#-1,-4(A1)
	BNE.S	ROUL
	LEA	TABLE+4,A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	MOVE.L	SCREEN1,A0
	LEA	160*50(A0),A0
	JSR	8*4(A2)
	MOVE.L	SCREEN2,A0
	LEA	160*50(A0),A0
	JSR	8*4(A2)
	MOVE.L	A1,MOD_A1
	JSR	GEST_SCROLL
	MOVE.L	SCREEN2,A1
	LEA	160*112(A1),A1
	MOVE.L	#$000000FF,D0
N	SET	0
	REPT	32
	MOVEP.L	D0,N(A1)
	MOVEP.L	D0,N+153(A1)
N	SET	N+160
	ENDR
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
INTER_RTE	RTE
	
GEST_SCROLL	MOVE.W	NO_DEC,D0
	JMP	ROUTS_DEC(PC,D0.W)
ROUTS_DEC	BRA	DEC_0
	BRA	DEC_1
	BRA	DEC_2
	BRA	DEC_3

GEST_AFFICH	
	MOVE.L	SCREEN2,A1
	LEA	160*112(A1),A1
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
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
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
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
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
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
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
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
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


;INTER_TMA:	CLR.B	$FFFFFA07.W	; ARRET DU MFP POUR NE PAS
;	CLR.B	$FFFFFA09.W	; ETRE GENE
;	MOVE	#$2100,SR	; ON AUTORISE LA HBL

;	MOVE.L	A6,USP
	
;full
;	MOVE.L	#$FFFF8209,A6
;	MOVE.L	#$FFFF8260,A4
;	MOVE.L	#$FFFF820A,A3

;	MOVEQ	#0,D0
;	MOVEQ	#2,D1

;	STOP	#$2100	; ATTENTE DE LA PROCHAINE HBL
		; (FIXE A 16 CYCLES PRES ENVIRONS)
;	MOVE	#$2700,SR	; ON COUPE TOUTE LES ITs
;	MOVE	#$2300,(SP)	; AU RETOUR LE VBL SERA AUTORISEE

;	MOVEQ	#29,D2	; ON ATTEND LE BON MOMENT
;SYNCHROA:	DBF	D2,SYNCHROA
;	NOP

;	MOVE.B	D0,(A3)	; ET HOP! PLUS DE BORDER HAUT
;	REPT	6
;	NOP
;	ENDR
;	MOVE.B	D1,(A3)

;	RTE
	

TB0_IR
	CLR.B	$FFFFFA1B.W
	MOVE	#$002,$FFFF8250.W
	MOVE.L	A1,USP
	LEA	FONTS+2,A1
	MOVE.L	(A1)+,$FFFF8240.W
	MOVE.L	(A1)+,$FFFF8244.W
	MOVE.L	(A1)+,$FFFF8248.W
	MOVE.L	(A1)+,$FFFF824C.W
	MOVE.L	USP,A1
	MOVE.B	#32,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB0,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB0
	CLR.B	$FFFFFA1B.W
	MOVE	#$111,$FFFF8246.W
	MOVE	#$111,$FFFF8254.W
	MOVE	#$001,$FFFF8244.W
	MOVE	#$002,$FFFF8242.W
	MOVE	#$002,$FFFF8248.W
	MOVE	#$002,$FFFF824A.W
	MOVE	#$002,$FFFF824C.W
	MOVE	#$002,$FFFF824E.W
	MOVE.B	#3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB1
	CLR.B	$FFFFFA1B.W
	MOVE	#$222,$FFFF8246.W
	MOVE	#$222,$FFFF8254.W
	MOVE	#$002,$FFFF8244.W
	MOVE.B	#3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB2
	CLR.B	$FFFFFA1B.W
	MOVE	#$333,$FFFF8246.W
	MOVE	#$333,$FFFF8254.W
	MOVE	#$003,$FFFF8244.W
	MOVE.B	#4,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3
	CLR.B	$FFFFFA1B.W
	MOVE	#$444,$FFFF8246.W
	MOVE	#$444,$FFFF8254.W
	MOVE	#$004,$FFFF8244.W
	MOVE.B	#5,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB4,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB4
	CLR.B	$FFFFFA1B.W
	MOVE	#$555,$FFFF8246.W
	MOVE	#$555,$FFFF8254.W
	MOVE	#$005,$FFFF8244.W
	MOVE.B	#6,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB5,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB5
	CLR.B	$FFFFFA1B.W
	MOVE	#$666,$FFFF8246.W
	MOVE	#$666,$FFFF8254.W
	MOVE	#$006,$FFFF8244.W
	MOVE.B	#7,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB6,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB6
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8246.W
	MOVE	#$777,$FFFF8254.W
	MOVE	#$007,$FFFF8244.W
	MOVE.B	#8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB7,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB7
	CLR.B	$FFFFFA1B.W
;	MOVE	#$777,$FFFF8246.W
;	MOVE	#$777,$FFFF8254.W
	MOVE	#$017,$FFFF8244.W
;	MOVE.B	#4,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB0_IR,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

FIN	MOVE.L	4.W,A0
	JMP	(A0)

; a0: Pointer on packed Data
; a1: Pointer on destination of unpacked data
decrunch:	movem.l d0-a6,-(sp)
	cmpi.l	#'Ice!',(a0)+
	bne.s	ice_03
	move.l	(a0)+,d0
	lea	-8(a0,d0.l),a5
	move.l	(a0)+,(sp)
	movea.l a1,a4
	movea.l a1,a6
	adda.l	(sp),a6
	movea.l a6,a3
	bsr.s	ice_08
	bsr.s	ice_04
	bsr	ice_0c
	bcc.s	ice_03
	move.w	#$0f9f,d7
ice_00:	moveq	#3,d6
ice_01:	move.w	-(a3),d4
	moveq	#3,d5
ice_02:	add.w	d4,d4
	addx.w	d0,d0
	add.w	d4,d4
	addx.w	d1,d1
	add.w	d4,d4
	addx.w	d2,d2
	add.w	d4,d4
	addx.w	d3,d3
	dbra	d5,ice_02
	dbra	d6,ice_01
	movem.w d0-d3,(a3)
	dbra	d7,ice_00
ice_03:	movem.l (sp)+,d0-a6
	rts
ice_04:	bsr.s	ice_0c
	bcc.s	ice_07
	moveq	#0,d1
	bsr.s	ice_0c
	bcc.s	ice_06
	lea	ice_1a(pc),a1
	moveq	#4,d3
ice_05:	move.l	-(a1),d0
	bsr.s	ice_0f
	swap	d0
	cmp.w	d0,d1
	dbne	d3,ice_05
	add.l	20(a1),d1
ice_06:	move.b	-(a5),-(a6)
	dbra	d1,ice_06
ice_07:	cmpa.l	a4,a6
	bgt.s	ice_12
	rts
ice_08:	moveq	#3,d0
ice_09:	move.b	-(a5),d7
	ror.l	#8,d7
	dbra	d0,ice_09
	rts
ice_0a:	move.w	a5,d7
	btst	#0,d7
	bne.s	ice_0b
	move.l	-(a5),d7
	addx.l	d7,d7
	bra.s	ice_11
ice_0b:	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	bra.s	ice_11
ice_0c:	add.l	d7,d7
	beq.s	ice_0d
	rts
ice_0d:	move.w	a5,d7
	btst	#0,d7
	bne.s	ice_0e
	move.l	-(a5),d7
	addx.l	d7,d7
	rts
ice_0e:	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	rts
ice_0f:	moveq	#0,d1
ice_10:	add.l	d7,d7
	beq.s	ice_0a
ice_11:	addx.w	d1,d1
	dbra	d0,ice_10
	rts
ice_12:	lea	ice_1b(pc),a1
	moveq	#3,d2
ice_13:	bsr.s	ice_0c
	dbcc	d2,ice_13
	moveq	#0,d4
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bmi.s	ice_14
	bsr.s	ice_0f
ice_14:	move.b	6(a1,d2.w),d4
	add.w	d1,d4
	beq.s	ice_16
	lea	ice_1c(pc),a1
	moveq	#1,d2
ice_15:	bsr.s	ice_0c
	dbcc	d2,ice_15
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bsr.s	ice_0f
	add.w	d2,d2
	add.w	6(a1,d2.w),d1
	bra.s	ice_18
ice_16:	moveq	#0,d1
	moveq	#5,d0
	moveq	#0,d2
	bsr.s	ice_0c
	bcc.s	ice_17
	moveq	#8,d0
	moveq	#$40,d2
ice_17:	bsr.s	ice_0f
	add.w	d2,d1
ice_18:	lea	2(a6,d4.w),a1
	adda.w	d1,a1
	move.b	-(a1),-(a6)
ice_19:	move.b	-(a1),-(a6)
	dbra	d4,ice_19
	bra	ice_04
	DC.B $7f,$ff,$00,$0e,$00,$ff,$00,$07
	DC.B $00,$07,$00,$02,$00,$03,$00,$01
	DC.B $00,$03,$00,$01
ice_1a:	DC.B $00,$00,$01,$0d,$00,$00,$00,$0e
	DC.B $00,$00,$00,$07,$00,$00,$00,$04
	DC.B $00,$00,$00,$01
ice_1b:	DC.B $09,$01,$00,$ff,$ff,$08,$04,$02
	DC.B $01,$00
ice_1c:	DC.B $0b,$04,$07,$00,$01,$20,$00,$00
	DC.B $00,$20
;***************************************************************************

	DATA
PAL_LOGO	DS.L	8
BIG_DATA	INCBIN	LOGO.PAK
	EVEN
COD	INCBIN	DAMIER.COD
TABLE	DS.L	65
	DC.L	-1
FONTS	INCBIN	METALFNT.PI1
CORES_FONTS	
N	SET	0
N2	SET	160*(HAUT_FONTE+1)
N3	SET	160*(HAUT_FONTE+1)*2
N4	SET	160*(HAUT_FONTE+1)*3
N5	SET	160*(HAUT_FONTE+1)*4
	DC	N5+6*16	ESP
	DC	N5+6*16	!
	DC	N5+4*16	"
	DC	N5+6*16	#
	DC	N5+6*16	$
	DC	N5+6*16	%
	DC	N5+6*16	&
	DC	N5+3*16	'
	DC	N3+160-32	(
	DC	N3+160-16	)
	DC	N5+6*16	*
	DC	N5+6*16	+
	DC	N5+2*16	,
	DC	N5	-
	DC	N3+160-16*4	.
	DC	N5+6*16	/
NN	SET	0
	REPT	10
	DC	N4+NN
NN	SET	NN+16
	ENDR
	DC	N3+160-16*3	:
	DC	N5+160*5	;
	DC	N5+6*16	<
	DC	N5+6*16	=
	DC	N5+6*16	>
	DC	N5+6*16	?
	DC	N5+6*16	

	DC.W	N,N+16,N+32,N+48,N+64,N+80,N+96,N+112,N+128,N+144
	DC.W	N2,N2+16,N2+32,N2+48,N2+64,N2+80,N2+96,N2+112,N2+128,N2+144
	DC.W	N3,N3+16,N3+32,N3+48,N3+64,N3+80

TEXT	
 DC.B "                        "
 DC.B "ON A DARKLING PLAIN, AMONG THE FIELDS OF DREAM, WE WILL RULE FOREVER... "
 DC.B "   CHAOS IS OUR KINGDOM, CHAOTIC DEMOS OUR WAY OF TALKING.        "
	DC.B	"                    ",-1
	EVEN

	BSS
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	32000*2
BUFFER_SCROLL	DS.L	40*HAUT_FONTE*4
PT_TEXT	DS.L	1
PT_BUF	DS.W	1
SOV_ADR	DS.L	1
NO_DEC	DS.W	1
PT_AFF	DS.W	1
PART_FONTE	DS.W	1
