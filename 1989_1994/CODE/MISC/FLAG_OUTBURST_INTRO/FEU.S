LINK = 0	;1 POUR LINKER
DEBUG = 0	;1 POUR DEBUGGER SANS SE FAIRE CHIER, 0 POUR EXECUTER

;ROUTINE DE SCROLL 4/4
;SANS DOUBLE-BUFFERING
;LES FONTES FONT 32/32 ET LE BUFFER CYCLIQUE ME PREND 20480 OCTETS

LARG_FONTE = 32	(EN PIXELS !! )
HAUT_FONTE = 32	(EN PIXELS !! )

WAIT	MACRO
	MOVE.W	#\1,D7
\@BCL	DBRA	D7,\@BCL
	ENDM

CPU	MACRO
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	\@PAS_TOUCHE
	MOVE.W	#\1,$FFFF8240.W
\@PAS_TOUCHE	
	ENDM

COUL	MACRO
	MOVE.W	#\2,$FFFF8240+(\1*2).W
	ENDM

	IFEQ	LINK
	 CLR.L	-(SP)
	 MOVE.W	#$20,-(SP)
	 TRAP	#1
	 ADDQ.L	#6,SP
	 MOVE.L	D0,SAUV_SP

	 IFEQ	DEBUG
	  CLR.W	-(SP)
	  MOVE.L	#-1,-(SP)
	  MOVE.L	#-1,-(SP)
	  MOVE.W	#5,-(SP)
	  TRAP	#14
	  LEA	12(SP),SP

	  LEA	FIN,A0
	  MOVE.L	A0,$008.W
	  MOVE.L	A0,$00C.W
	  MOVE.L	A0,$010.W
	  MOVE.L	A0,$014.W
	  MOVE.L	A0,$018.W
	  MOVE.L	A0,$01C.W
	  MOVE.L	A0,$020.W
	 ENDC
	ENDC

	MOVE.B	$FFFF8201.W,SAUVEC
	MOVE.B	$FFFF8203.W,SAUVEC+1
	BSR	PREP_ECR

	MOVE.L	#TEXT,PT_TEXT
	MOVE.W	#0,PART_FONTE
	MOVE.W	#152,PT_BUF
	MOVE.L	#FONTS+34+160*33*4+6*16,SOV_ADR
	MOVE.W	#4,NO_DEC
	MOVE.W	#0,PT_AFF

	IFNE	DEBUG
	 BRA	IT_VBL
	ENDC

	CLR.W	VBL_FLAG
	CLR.B	DATA_JOY
	CLR.B	DATA2JOY

	IFEQ	LINK
	 ANDI.B	#%11111000,$484.W
	ENDC

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
	MOVEM.L	FONTS+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.B	#$80,$FFFFFC02.W
	MOVE.B	#1,$FFFFFC02.W
	MOVE.B	#$14,$FFFFFC02.W

	MOVE.W 	#$FA00,A0
	MOVE.B	7(A0),IERA
	MOVE.B	9(A0),IERB
	MOVE.B	$F(A0),ISRA
	MOVE.B	$11(A0),ISRB
	MOVE.B	$13(A0),IMRA
	MOVE.B	$15(A0),IMRB
	MOVE.B	$17(A0),VR
	MOVE.B	$19(A0),TACR
	MOVE.B	$1B(A0),TBCR
	MOVE.B	$1D(A0),TCDCR
	MOVE.B	$1F(A0),TADR
	MOVE.B	$21(A0),TBDR
	MOVE.B	$23(A0),TCDR
	MOVE.B	$25(A0),TDDR
	
	MOVE.W	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	$118.W,ANC_CLAV
	MOVE.L	$120.W,ANC_TIM
	MOVE.L	$134.W,ANC_TIMA
	MOVE.L	#VBLR,$70.W
	MOVE.L	#IT_CLAV,$118.W
	MOVE.L	#TB0,$120.W
	MOVE.L	#TA0,$134.W
	BSET	#0,$FFFFFA07.W		TB AUTORIS�
	BSET	#5,$FFFFFA07.W		TA AUTORIS�
	BSET	#6,$FFFFFA09.W		IT CLAVIER OK
	MOVE.B	$FFFFFA07.W,$FFFFFA13.W
	MOVE.B	$FFFFFA09.W,$FFFFFA15.W
	MOVE.B	#$40,$FFFFFA17.W
	MOVE.W	#$2300,SR

	JMP	IT_VBL

FIN	ADDQ.W	#6,SP
	MOVE.W	#$2700,SR
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	ANC_CLAV,$118.W
	MOVE.L	ANC_TIM,$120.W
	MOVE.L	ANC_TIMA,$134.W

	MOVE.W	#$FA00,A0
	MOVE.B	IERA,7(A0)
	MOVE.B	IERB,9(A0)
	MOVE.B	ISRA,$F(A0)
	MOVE.B	ISRB,$11(A0)
	MOVE.B	IMRA,$13(A0)
	MOVE.B	IMRB,$15(A0)
	MOVE.B	VR,$17(A0)
	MOVE.B	TACR,$19(A0)
	MOVE.B	TBCR,$1B(A0)
	MOVE.B	TCDCR,$1D(A0)
	MOVE.B	TADR,$1F(A0)
	MOVE.B	TBDR,$21(A0)
	MOVE.B	#$C0,$23(A0)
	MOVE.B	TDDR,$25(A0)
	MOVE.W	#$2300,SR

	MOVE.B	#$80,$FFFFFC02.W
	MOVE.B	#1,$FFFFFC02.W

	MOVE.B	SAUVEC,$FFFF8201.W
	MOVE.B	SAUVEC+1,$FFFF8203.W

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W
	
	IFEQ	LINK
	 ORI.B	#%00000111,$484.W

	 MOVE.L	SAUV_SP,-(SP)
	 MOVE.W	#$20,-(SP)
	 TRAP	#1
	 ADDQ.L	#6,SP
	
	 CLR.W	-(SP)
	 TRAP	#1
	 ADDQ.L	#2,SP
	ELSE
	 ILLEGAL
	ENDC

	*******	V B L  &  P R O C E D U R E S    *******
VBLR	ADDQ.W	#1,VBL_FLAG
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

RTE	RTE

TB0	RTE

TA0	RTE

IT_CLAV	MOVE.L	D0,-(SP)
	MOVEQ	#0,D0
	MOVE.B	$FFFFFC02.W,D0
	CMPI.B	#$FF,D0
	BNE.S	JOY_2
	MOVE.L	#CLAV_1,$118.W
	MOVE.L	(SP)+,D0
	RTE
JOY_2	CMPI.B	#$FE,D0
	BNE.S	PAS_JOY
	MOVE.L	#CLAV_2,$118.W
	MOVE.L	(SP)+,D0
	RTE
PAS_JOY	MOVE.L	(SP)+,D0
	RTE

CLAV_1	MOVE.B	$FFFFFC02.W,DATA_JOY
	MOVE.L	#IT_CLAV,$118.W
	RTE

CLAV_2	MOVE.B	$FFFFFC02.W,DATA2JOY
	MOVE.L	#IT_CLAV,$118.W
	RTE

IT_VBL	CMPI.W	#1,VBL_FLAG
	BLT.S	IT_VBL

	CPU	$700
	BSR	GEST_SCROLL
	MOVEM.L	FEU+2,D0-D7
	MOVEM.L	D4-D7,$FFFF8250.W
	MOVE.L	SCREEN2,A0
	MOVE.L	SCREEN2,A6
	LEA	(23+23+32+1)*160(A6),A6
	LEA	TABLE,A1
MOD	EQU	*+2
	LEA	0(A1),A1
	CMPI.L	#-1,(A1)
	BNE.S	OK
	CLR	MOD
	LEA	TABLE,A1
OK	MOVE.L	(A1),A1
	MOVE	#22,D7
AFF
	MOVEM.L	(A1),D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A0)
	MOVEM.L	D0-D6/A2-A5,(A6)

	MOVEM.L	11*4(A1),D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,11*4(A0)
	MOVEM.L	D0-D6/A2-A5,11*4(A6)

	MOVEM.L	11*4*2(A1),D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,11*4*2(A0)
	MOVEM.L	D0-D6/A2-A5,11*4*2(A6)

	MOVEM.L	11*4*3(A1),D0-D6
	MOVEM.L	D0-D6,11*4*3(A0)
	MOVEM.L	D0-D6,11*4*3(A6)
	LEA	160(A1),A1
	LEA	160(A0),A0
	LEA	-160(A6),A6
	DBF	D7,AFF
	ADDQ.L	#1,TIME
	CMPI.L	#5,TIME
	BLE.S	INTER_RTE
	CLR.L	TIME
	ADDQ	#4,MOD
INTER_RTE
	BSR	SWAPEC
	COUL	0,0

	CLR.W	VBL_FLAG
	BRA	IT_VBL
TIME	DC.L	0

GEST_SCROLL	MOVE.W	NO_DEC,D0
	JMP	ROUTS_DEC(PC,D0.W)
ROUTS_DEC	BRA	DEC_0
	BRA	DEC_1
	BRA	DEC_2
	BRA	DEC_3

GEST_AFFICH	CPU	$70
	MOVE.L	SCREEN2,A1
	LEA	24*160(A1),A1
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


SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
	
PREP_ECR	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

FONTS	INCBIN	FNT.PI1

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

TEXT	DC.B	"  -HOLOCAUST- PRESENTS A NEW MULTIPART CALLED...  'SUICIDAL LEVEL'...   "
	DC.B	" PREPARE TO BE HARDBOILED! "
	DC.B	"                    ",-1
	EVEN

FEU	INCBIN	FEU2.PI1
TABLE	DC.L	FEU+34
	DC.L	FEU+34+23*160
	DC.L	FEU+34+23*160*2
	DC.L	FEU+34+23*160*3
	DC.L	FEU+34+23*160*2
	DC.L	FEU+34+23*160
	DC.L	-1

	SECTION	BSS
ANC_PAL	DS.L	8
ANC_VBL	DS.L	1
ANC_TIM	DS.L	1
ANC_TIMA	DS.L	1
ANC_CLAV	DS.L	1
SAUV_SP	DS.L	1
SAUVEC	DS.W	1
IERA	DS.B	1
IERB	DS.B	1
ISRA	DS.B	1
ISRB	DS.B	1
IMRA	DS.B	1
IMRB	DS.B	1
VR	DS.B	1
TACR	DS.B	1
TBCR	DS.B	1
TCDCR	DS.B	1
TADR	DS.B	1
TBDR	DS.B	1
TCDR	DS.B	1
TDDR	DS.B	1
	DS.B	256
BUFFER	DS.L	16000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
DATA_JOY	DS.B	1
DATA2JOY	DS.B	1
VBL_FLAG	DS.W	1
BUFFER_SCROLL	DS.L	40*HAUT_FONTE*4
PT_TEXT	DS.L	1
PT_BUF	DS.W	1
SOV_ADR	DS.L	1
NO_DEC	DS.W	1
PT_AFF	DS.W	1
PART_FONTE	DS.W	1