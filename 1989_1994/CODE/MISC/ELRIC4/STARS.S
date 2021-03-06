NB_STARS = 160
LIM_1 = 75

	RSRESET
X_ANGLE	RS.W	1
INC_X	RS.W	1
Y_ANGLE	RS.W	1
INC_Y	RS.W	1
Z_ANGLE	RS.W	1
INC_Z	RS.W	1
VIT_X	RS.W	1
VIT_Y	RS.W	1
VIT_Z	RS.W	1
RANG_SIN_COS	RS.W	2*3
ADR_EFF	RS.L	2
LONG_BSS_STARS	RS.B	1

LINK = 0	;1 POUR LINKER
DEBUG = 0	;1 POUR DEBUGGER SANS SE FAIRE CHIER, 0 POUR EXECUTER

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
	  MOVE.W	#8,A1
	  MOVE.L	A0,(A1)+
	  MOVE.L	A0,(A1)+
	  MOVE.L	A0,(A1)+
	  MOVE.L	A0,(A1)+
	  MOVE.L	A0,(A1)+
	  MOVE.L	A0,(A1)+
	  MOVE.L	A0,(A1)+
	 ENDC
	ENDC

	BSR	PREP_ECR
	BSR	PREPARE_STARS

	IFNE	DEBUG
	 BRA	IT_VBL
	ENDC

	CLR.B	DATA_JOY
	CLR.B	DATA2JOY

	IFEQ	LINK
	 ANDI.B	#%11111000,$484.W
	ENDC

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
	MOVE.W	#$666,$FFFF8242.W
	MOVE.W	#$333,$FFFF8244.W
	MOVE.W	#$666,$FFFF8246.W

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
	MOVE.L	$120.W,ANC_TIM
	MOVE.L	$118.W,ANC_CLAV
	MOVE.L	#VBLR,$70.W
	MOVE.L	#TB0,$120.W
	MOVE.L	#IT_CLAV,$118.W
	JSR	MUZAXX
	BSET	#0,$FFFFFA07.W		TB AUTORIS�
;	BSET	#6,$FFFFFA09.W		IT CLAVIER OK
	MOVE.B	$FFFFFA07.W,$FFFFFA13.W
	MOVE.B	$FFFFFA09.W,$FFFFFA15.W
	MOVE.B	#$40,$FFFFFA17.W
	MOVE.W	#$2300,SR

	CLR.W	NB_VBL
	JMP	IT_VBL

MUZAXX	INCBIN	LEVEL5.MUS
	EVEN
	DS.B	5000

FIN	MOVE.W	#$2700,SR
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	ANC_TIM,$120.W
	MOVE.L	ANC_CLAV,$118.W
	
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
	MOVE.B	#$B0,$23(A0)
	MOVE.B	TDDR,$25(A0)
	MOVE.W	#$2300,SR

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
VBLR	ADDQ.W	#1,NB_VBL
	MOVEM.L	D0-A6,-(SP)
	JSR	MUZAXX+8
	MOVEM.L	(SP)+,D0-A6
	RTE
	
TB0	RTE

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

IT_VBL	BSR	VSYNC
	CPU	$700
	BSR	ROTATING_STARS

	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
N	SET	0
	REPT	20
	MOVE.L	D0,N(A0)
N	SET	N+8
	ENDR
	BSR	SWAPEC
	COUL	0,0

	JMP	IT_VBL

VSYNC	CMPI.W	#1,NB_VBL
	BLT.S	VSYNC
	CLR.W	NB_VBL
	RTS

ROTATING_STARS	LEA	BSS_DEMO,A6
	MOVE.L	ADR_EFF(A6),A1
	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	JSR	(A1)
	LEA	TABLE_SIN_COS(PC),A0 ;A0=TABLE SINUS
	LEA	TABLE_SIN_COS+512(PC),A1 ;A1=TABLE COSINUS
	LEA	RANG_SIN_COS(A6),A2
	MOVE.W	X_ANGLE(A6),D0
	ADD.W	INC_X(A6),D0
	ANDI.W	#511,D0
	MOVE.W	D0,X_ANGLE(A6)
	MOVE.W	Y_ANGLE(A6),D1
	ADD.W	INC_Y(A6),D1
	ANDI.W	#511,D1
	MOVE.W	D1,Y_ANGLE(A6)
	MOVE.W	Z_ANGLE(A6),D2
	ADD.W	INC_Z(A6),D2
	ANDI.W	#511,D2
	MOVE.W	D2,Z_ANGLE(A6)
	MOVE.W	(A0,D0.W),(A2)+
	MOVE.W	(A1,D0.W),(A2)+
	MOVE.W	(A0,D1.W),(A2)+
	MOVE.W	(A1,D1.W),(A2)+
	MOVE.W	(A0,D2.W),(A2)+
	MOVE.W	(A1,D2.W),(A2)+
	;ON A DEPOSE LES 3 SINUS ET LES 3 COSINUS A <RANG_SIN_COS>.
	LEA	COOR_ETOILES(PC),A0
	LEA	COEFF_3D,A2
	LEA	CORES_X(PC),A3
	LEA	TABLE_160(PC),A4
	MOVE.L	SCREEN2,A5
	MOVE.L	ADR_EFF(A6),A6
	ADDQ.W	#2,A6
	MOVE.W	#NB_STARS-1,D7
REPEAT_STARS	LEA	RANG_SIN_COS+BSS_DEMO,A1
	MOVEM.W	(A0),D0-D2	;X,Y,Z.
	ADD.W	VIT_X+BSS_DEMO,D0
	ADD.W	VIT_Y+BSS_DEMO,D1
	ADD.W	VIT_Z+BSS_DEMO,D2
	ANDI.W	#255,D0
	ANDI.W	#255,D1
	ANDI.W	#255,D2
	MOVE.W	D0,(A0)+
	MOVE.W	D1,(A0)+
	MOVE.W	D2,(A0)+
	SUBI.W	#128,D0	;ON RECENTRE X.
	SUBI.W	#128,D1	;ON RECENTRE Y.
	SUBI.W	#128,D2	;ON RECENTRE Z.
	;ROTATION X
;	MOVEQ	#0,D5
;	MOVEQ	#0,D6
;	MOVE.W	(A1)+,D3	;SIN T1
;	MOVE.W	(A1)+,D4	;COS T1
;	MOVE.W	D1,D5	;Y
;	MOVE.W	D2,D6	;Z
;	MULS.W	D4,D1	;YCOS T1
;	MULS.W	D3,D6	;ZSIN T1
;	MULS.W	D3,D5	;YSIN T1
;	MULS.W	D4,D2	;ZCOS T1
;	ADD.L	D5,D2	;YSIN T1+ZCOS T1
;	BLT.S	.PAS_AFF
;	SUB.L	D6,D1	;YSIN T1-ZCOS T1
	;ROTATION Y
	ADDQ.W	#4,A1
;	ASR.L	#8,D2
;	ASR.L	#8,D1
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVE.W	(A1)+,D3	;SIN T2
	MOVE.W	(A1)+,D4	;COS T2
	MOVE.L	D0,D5	;D5=X
	MOVE.L	D2,D6	;D6=Z
	MULS.W	D4,D2	;ZCOS T2
	MULS.W	D3,D5	;XSIN T2
	MULS.W	D4,D0	;XCOS T2
	MULS.W	D3,D6	;ZSIN T2
	ADD.L	D6,D0	;ZSIN T2+XCOS T2
	SUB.L	D5,D2	;ZCOS T2-XSIN T2
	BLT	.PAS_AFF
	ASR.L	#8,D0
	ASR.L	#8,D2
	;ROTATION Z
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVE.W	(A1)+,D3	;SIN T3
	MOVE.W	(A1)+,D4	;COS T3
	MOVE.W	D0,D5	;D5=X
	MOVE.W	D1,D6	;D6=Y
	MULS.W	D4,D0	;XCOS T3
	MULS.W	D3,D6	;YSIN T3
	MULS.W	D3,D5	;XSIN T3
	MULS.W	D4,D1	;YCOS T3
	ADD.L	D5,D1	;XSIN T3+YCOS T3
	SUB.L	D6,D0	;XCOS T3-YSIN T3
	ASR.L	#8,D0
	ASR.L	#8,D1

	;X,Y ET Z SONT ROTAT�S !
	ADD.W	D0,D0
	ADD.W	D1,D1
	ADD.W	D2,D2
	ADD.W	D2,D2
	MOVE.W	2(A2,D2.W),D6
	MOVE.W	(A2,D2.W),D2
	MULS.W	D2,D0
	MULS.W	D2,D1
	SWAP	D0
	SWAP	D1
	ADD.W	D0,D0
	ADD.W	D0,D0
	ADD.W	D1,D1
	MOVE.W	(A3,D0.W),D2
	MOVE.W	(A4,D1.W),D1
	ADD.W	2(A3,D0.W),D1
	ADD.W	D6,D1
	OR.W	D2,(A5,D1.W)
	MOVE.W	D1,(A6)+
	ADDQ.W	#2,A6
.PAS_AFF	DBRA	D7,REPEAT_STARS
	LEA	BSS_DEMO+ADR_EFF,A6
	MOVE.L	(A6)+,D0
	MOVE.L	(A6),-(A6)
	MOVE.L	D0,4(A6)
	RTS

EFFAC_1	REPT	NB_STARS
	MOVE.W	D0,$1234(A0)
	ENDR
	RTS

EFFAC_2	REPT	NB_STARS
	MOVE.W	D0,$1234(A0)
	ENDR
	RTS

SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
	
PREP_ECR	MOVE.B	$FFFF8201.W,SAUVEC
	MOVE.B	$FFFF8203.W,SAUVEC+1
	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREPARE_STARS	LEA	BSS_DEMO,A6
	CLR.W	X_ANGLE(A6)
	CLR.W	Y_ANGLE(A6)
	CLR.W	Z_ANGLE(A6)
	MOVE.W	#0,INC_X(A6)
	MOVE.W	#2,INC_Y(A6)
	MOVE.W	#4,INC_Z(A6)
	MOVE.W	#-2,VIT_X(A6)
	MOVE.W	#5,VIT_Y(A6)
	MOVE.W	#-3,VIT_Z(A6)
	LEA	EFFAC_1(PC),A0
	LEA	EFFAC_2(PC),A1
	LEA	ADR_EFF(A6),A2
	MOVE.L	A0,(A2)+
	MOVE.L	A1,(A2)+

	LEA	COEFF_3D+2(PC),A0
	MOVEQ	#0,D0
	MOVE.W	#LIM_1-1,D7
.AJ	MOVE.W	D0,(A0)+
	ADDQ.W	#2,A0
	DBRA	D7,.AJ
	MOVEQ	#2,D0
	MOVE.W	#256-LIM_1-1,D7
.BJ	MOVE.W	D0,(A0)+
	ADDQ.W	#2,A0
	DBRA	D7,.BJ
	RTS

TABLE_SIN_COS	INCBIN	SIN_COS.TAB

COOR_ETOILES	INCBIN	COORSTR2.DAT

	DCB.W	600,$7FFF
COEFF_3D	INCBIN	COEFF164.DAT

	DCB.W	800,0
N	SET	0
	REPT	10
	DC.W	32768,N,16384,N,8192,N,4096,N,2048,N,1024,N,512,N,256,N,128,N,64,N,32,N,16,N,8,N,4,N,2,N,1,N
N	SET	N+8
	ENDR
CORES_X	REPT	10
	DC.W	32768,N,16384,N,8192,N,4096,N,2048,N,1024,N,512,N,256,N,128,N,64,N,32,N,16,N,8,N,4,N,2,N,1,N
N	SET	N+8
	ENDR
	DCB.W	1000,0

N	SET	0
	REPT	100
	DC.W	N*160
N	SET	N+1
	ENDR
TABLE_160	REPT	100
	DC.W	N*160
N	SET	N+1
	ENDR
	DCB.W	600,0

	SECTION	BSS
ANC_PAL	DS.L	8
ANC_VBL	DS.L	1
ANC_TIM	DS.L	1
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
	DS.B	256+640
BUFFER	DS.L	16000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
DATA_JOY	DS.B	1
DATA2JOY	DS.B	1
NB_VBL	DS.W	1
;
BSS_DEMO	DS.B	LONG_BSS_STARS