	LEA	NEW_PILE,A7

	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	
	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	add.l	#32000,d0
	MOVE.L	D0,SCREEN2

	MOVE.L	SCREEN1,D0
	LSR.L	#8,D0
	LEA	$FFFF8201.W,A0
	MOVEP	D0,(A0)

	BSR	PREP_DRAPEAU

	SF	$FFFF8240.W
	MOVE.W	#$7,$FFFF8242.W
	MOVE.W	#$777,$FFFF8244.W
	MOVE.W	#$700,$FFFF8248.W
	MOVE.L	#$03330333,D0
	MOVE.L	D0,$FFFF8250.W
	MOVE.L	D0,$FFFF8254.W
	MOVE.L	D0,$FFFF8258.W
	MOVE.L	D0,$FFFF825C.W
	SF	$FFFF8250.W
	
	LEA	MODCOL,A0
	LEA	SCREEN1,A2
	LEA	VBL_END,A3
	LEA	RETOUR,A4
	MOVE.L	A0,ADR_CHG
	MOVE.L	A0,ADR_CHG2
	MOVE.L	A2,SCR_CHG
	MOVE.L	A3,CHG_VBL
	MOVE.L	A4,RET

	MOVE.L	#VBL,$70.W
J	JMP	J
TIME2	DC	0
*************************************************************
	OPT	O-

VBL_TXT
LOOP_AFF_MES
MOD_ADR	EQU	*+2
	LEA	MESSAGE,A0
	CMPI.B	#-1,(A0)
	BEQ	TERMINê
	MOVE	#(20*5)-1,D6
ICI	MOVEQ	#0,D0
SCR_CHG	EQU	*+2
	MOVE.L	SCREEN1,A5
	MOVE.L	SCREEN2,A6
	LEA	160*60+6(A5),A5
	LEA	160*60+6(A6),A6
	LEA	CORRES,A2
MOD	EQU	*+2
	LEA	0(A5),A5
MOD2	EQU	*+2
	LEA	0(A5),A5
	ADD	MOD,A6
	ADD	MOD2,A6
	MOVE.B	(A0)+,D0
	SUBI.B	#32,D0
;	TST.B	D0
;	BEQ.S	GO
;	SUBQ.B	#1,D0
GO	LSL.L	#2,D0
	ADDA.L	D0,A2
	MOVE.L	(A2),A2
	MOVEQ	#15,D0
AFF_A_LETTER	MOVE	(A2),(A5)
	MOVE	(A2),(A6)
	LEA	160(A2),A2
	LEA	160(A5),A5
	LEA	160(A6),A6
	DBF	D0,AFF_A_LETTER
	ADDQ	#8,MOD
	CMPI	#160,MOD
	BNE.S	OKAY_MAN
	CLR	MOD
	ADD	#160*16,MOD2
OKAY_MAN	DBF	D6,ICI
	MOVE.L	A0,MOD_ADR
	CLR	MOD
	CLR	MOD2
	CLR	PNT_FAD
	CLR	PNT_FADB
FAD1	LEA	FAD_IN,A0
PNT_FAD	EQU	*+2
	LEA	0(A0),A0
	MOVE	(A0),D0
	CMPI	#-1,D0
	BEQ.S	ENDED
ADR_CHG	EQU	*+2
	MOVE	D0,MODCOL
	MOVE.L	#WAIT_A_BIT,MODMOD
	RTE
WAIT_A_BIT	;TST.L	$140.W
	;BEQ.S	WAIT_A_BIT
	;CLR.L	$140.W
	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#2,PNT_FAD2
	BNE.S	EXI
	ADDQ	#2,PNT_FAD
	CLR.L	PNT_FAD2
EXI	MOVE.L	#FAD1,MODMOD
	RTE
PNT_FAD2	DC.L	0
TIME	DC.L	0
ENDED	ADDQ.L	#1,TIME
	MOVE.L	#WAIT2,MODMOD
	RTE
WAIT2	;TST.L	$140.W
	;BEQ.S	WAIT2
	;CLR.L	$140.W
	CMPI.L	#50,TIME
	BNE.S	ENDED
	CLR.L	TIME
	CLR.L	PNT_FAD2
FAD2	LEA	FAD_OUT,A0
PNT_FADB	EQU	*+2
	LEA	0(A0),A0
	MOVE	(A0),D0
	CMPI	#-1,D0
	BEQ.S	ENDEDB
ADR_CHG2	EQU	*+2
	MOVE	D0,MODCOL
WAITB	MOVE.L	#WAITB__,MODMOD
	RTE
WAITB__	;TST.L	$140.W
	;BEQ.S	WAITB
	;CLR.L	$140.W
	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#2,PNT_FAD2
	BNE.S	EXIB
	ADDQ	#2,PNT_FADB
	CLR.L	PNT_FAD2
EXIB	MOVE.L	#FAD2,MODMOD
	RTE
;	BRA.S	FAD2
ENDEDB	CLR.L	TIME
	CLR.L	PNT_FAD2
	MOVE.L	#LOOP_AFF_MES,MODMOD
	RTE
	
TERMINê	
CHG_VBL	EQU	*+2
	MOVE.L	#TERMINê,$70.W
	RTE
RET	EQU	*+2
	JMP	RETOUR
	*	'                    '
MESSAGE
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'   YES! TOO EASY!   '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'    ENJOY FRENCH    '
	DC.B	'      QUALITY!      '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'   THIS DEMO DOES   '
	DC.B	'                    '
	DC.B	'        -NOT-       '
	DC.B	'                    '
	DC.B	'       CONTAIN:     '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'  1) LAME PLASMAS   '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'  2) VERY LAME      '
	DC.B	'     SHADEBOBS...   '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'  3) INCREDIBLY     '
	DC.B	'  LAME KEFTALES!!!  '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'      KEFTALES      '
	DC.B	'        ARE         '
	DC.B	'        FOR         '
	DC.B	'      LAMERS !      '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'      KEFTALES      '
	DC.B	'        ARE         '
	DC.B	'       UGLY!        '
	DC.B	'                    '

	DC.B	'      KEFLAMES      '
	DC.B	'        ARE         '
	DC.B	'        FOR         '
	DC.B	'     GFA-CODERS!    '
	DC.B	'                    '

	DC.B	'        W E         '
	DC.B	'                    '
	DC.B	'      H A T E       '
	DC.B	'                    '
	DC.B	'  K E F T A L E S ! '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'      DAMN IT!      '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'      THIS IS       '
	DC.B	'    BEGINNING TO    '
	DC.B	'                    '
	DC.B	'  -PISS ME OFF!!!-  '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'DOES THIS DEMO HAVE '
	DC.B	'                    '
	DC.B	'A NEVERENDING SUPPLY'
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'...OF LAME STUFF !? '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'    I WANNA CODE    '
	DC.B	'                    '
	DC.B	"   SOMETHIN' HARD!  "
	DC.B	'                    '

	DC.B	' YOU KNOW...        '
	DC.B	'                    '
	DC.B	'THOSE STRANGE       '
	DC.B	'     COMBINATIONS...'
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'       SUCH AS:     '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B       $22,'4-BITPLANES-SOURCE-'
	DC.B	'   LIGHTED-MAPPED   '
	DC.B	'   RUBBER-CUBE',$22,' !!!!'
	DC.B	'                    '

	DC.B	' HMMMPF...          '
	DC.B	' DIS ONE MAY BE A   '
	DC.B	' BIT HARD TO CODE!! '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'         ...        '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'     I SAID HARD?   '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	-1,-1,-1,-1
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	EVEN
CORRES
N	SET	0
	REPT	20
	DC.L	FONTES+N
N	SET	N+8
	ENDR

N	SET	0
	REPT	20
	DC.L	FONTES+N+(160*15)
N	SET	N+8
	ENDR

N	SET	0
	REPT	20
	DC.L	FONTES+N+(160*30)
N	SET	N+8
	ENDR
FONTES	INCBIN	FNT.PI1
	DS.B	160
	EVEN
FAD_IN
	DC	$000,$111,$222,$333,$444,$555,$666,$777
	DC	-1
FAD_OUT
	DC	$777,$666,$555,$444,$333,$222,$111,$000
	DC	-1
**************************
VBL	MOVE.L	#1,$140.W
MODCOL	EQU	*+2
	MOVE	#000,$FFFF8250.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	BSR	AFF_DRAPEAU
	ADDQ	#1,TIME2
	CMPI	#50*3,TIME2
	BLE.S	VBL_END
	
MODMOD	EQU	*+2
	JMP	VBL_TXT

VBL_END	MOVE.L	#1,$140.W
;	MOVE	#$700,$FFFF8240.W
	RTE
FIN	MOVE.L	4.W,A0
	JMP	(A0)
RETOUR	MOVE	#$070,$FFFF8240.W
JU	JMP	JU


AFF_DRAPEAU	BSR	EFF_PTS
	MOVE.L	PT_INC_X,A0
	MOVE.L	PT_INC_Y,A1
	LEA	CORES_X,A2
	LEA	CORES_Y,A3
	MOVE.L	SCREEN2,A4
	MOVE.L	ADR_EFF,A6
	LEA	BUF_COD_DRAPEAU,A5
	JSR	(A5)
	MOVE.L	PT_INC_X,A0
	ADDQ.W	#2,A0
	CMPA.L	#FIN_INC_X,A0
	BNE.S	.FUCK_1
	LEA	INC_X,A0
.FUCK_1	MOVE.L	A0,PT_INC_X
	MOVE.L	PT_INC_Y,A0
	ADDQ.W	#2,A0
	CMPA.L	#FIN_INC_Y,A0
	BNE.S	.FUCK_2
	LEA	INC_Y,A0
.FUCK_2	MOVE.L	A0,PT_INC_Y

	LEA	ADR_EFF,A0
	MOVE.L	(A0)+,D0
	MOVE.L	(A0),-(A0)
	MOVE.L	D0,4(A0)
	BSR	SWAPEC
	RTS

EFF_PTS	MOVE.L	ADR_EFF,A0
	MOVE.L	SCREEN2,A1
	MOVEQ	#0,D0
	MOVE.W	NB_PTS,D7
.REPEAT	MOVE.W	(A0)+,D1
	MOVE.W	D0,(A1,D1.W)
	DBRA	D7,.REPEAT
	RTS

PREP_DRAPEAU	LEA	INC_X(PC),A0
	LEA	FIN_INC_X(PC),A1
	BSR	RECOPY
	LEA	INC_Y(PC),A0
	LEA	FIN_INC_Y(PC),A1
	BSR	RECOPY

	LEA	COOR_POINT(PC),A0
	LEA	BUF_COD_DRAPEAU,A1
	MOVEQ	#0,D3	;NB DE POINTS GENERAL
.NEXT_DIAG	CMPI.L	#"CACA",(A0)
	BEQ.S	.FINI_COD
	MOVE.W	(A0)+,D7	;NB DE POINTS-1 PAR DIAGONALE
	MOVE.L	#$34183619,(A1)+
.NEXT_POINT	MOVE.W	(A0)+,D0	;X
	MOVE.W	(A0)+,D1	;Y
	MOVE.W	(A0)+,CHG_1
	ADDQ.W	#1,D3
	CMPI.W	#127,D0
	BGT.S	.PAS_MOVEQ_X
	MOVE.W	#$7000,D2	;CODE DU MOVEQ #0,D0
	OR.W	D0,D2	;ON OR LA DONNêE <127
	MOVE.W	D2,(A1)+
	BRA.S	.X_DONE
.PAS_MOVEQ_X	MOVE.W	#$303C,(A1)+
	MOVE.W	D0,(A1)+
.X_DONE	CMPI.W	#127,D1
	BGT.S	.PAS_MOVEQ_Y
	MOVE.W	#$7200,D2	;CODE DU MOVEQ #0,D1
	OR.W	D1,D2	;ON OR LA DONNêE <127
	MOVE.W	D2,(A1)+
	BRA.S	.Y_DONE
.PAS_MOVEQ_Y	MOVE.W	#$323C,(A1)+
	MOVE.W	D1,(A1)+
.Y_DONE
CHG_1 = *+2
	MOVE.W	#$1234,D5
	CMPI.W	#1,D5
	BEQ.S	.GO_1
	CMPI.W	#2,D5
	BEQ.S	.GO_2
.GO_3	LEA	SEQUENC3COD(PC),A2
	MOVE.W	#LONG3COD-1,D5
	BRA.S	.REPRISE
.GO_2	LEA	SEQUENC2COD(PC),A2
	MOVE.W	#LONG2COD-1,D5
	BRA.S	.REPRISE
.GO_1	LEA	SEQUENC_COD(PC),A2
	MOVE.W	#LONG_COD-1,D5
.REPRISE	MOVE.B	(A2)+,(A1)+
	DBRA	D5,.REPRISE
	DBRA	D7,.NEXT_POINT
	BRA.S	.NEXT_DIAG

.FINI_COD	MOVE.W	#$4E75,(A1)
	SUBQ.W	#1,D3
	MOVE.W	D3,NB_PTS
	MOVE.L	#INC_X,PT_INC_X
	MOVE.L	#INC_Y,PT_INC_Y

	LEA	BUF_EFF,A0
	LEA	ADR_EFF,A1
	MOVE.L	A0,(A1)+
	LEA	2000(A0),A0
	MOVE.L	A0,(A1)+
	RTS

RECOPY	MOVE.L	A1,A2
.CONT	CMPA.L	A0,A2
	BEQ.S	.SORT
	MOVE.W	(A0)+,(A1)+
	BRA.S	.CONT
.SORT	RTS

SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

SEQUENC_COD	ADD.W	D2,D0
	ADD.W	D3,D1
	ADD.W	D0,D0	;X*4
	ADD.W	D0,D0
	ADD.W	D1,D1	;Y*2
	MOVE.W	(A3,D1.W),D1	;Y*160
	ADD.W	2(A2,D0.W),D1
	MOVE.W	(A2,D0.W),D0
	OR.W	D0,(A4,D1.W)
	MOVE.W	D1,(A6)+
FIN_CODE
LONG_COD = *-SEQUENC_COD

SEQUENC2COD	ADD.W	D2,D0
	ADD.W	D3,D1
	ADD.W	D0,D0	;X*4
	ADD.W	D0,D0
	ADD.W	D1,D1	;Y*2
	MOVE.W	(A3,D1.W),D1	;Y*160
	ADD.W	2(A2,D0.W),D1
	MOVE.W	(A2,D0.W),D0
	ADDQ.W	#2,D1
	OR.W	D0,(A4,D1.W)
	MOVE.W	D1,(A6)+
FIN2CODE
LONG2COD = *-SEQUENC2COD

SEQUENC3COD	ADD.W	D2,D0
	ADD.W	D3,D1
	ADD.W	D0,D0	;X*4
	ADD.W	D0,D0
	ADD.W	D1,D1	;Y*2
	MOVE.W	(A3,D1.W),D1	;Y*160
	ADD.W	2(A2,D0.W),D1
	MOVE.W	(A2,D0.W),D0
	ADDQ.W	#4,D1
	OR.W	D0,(A4,D1.W)
	MOVE.W	D1,(A6)+
FIN3CODE
LONG3COD = *-SEQUENC3COD

	DCB.W	1000,0
N	SET	0
CORES_X	REPT	20
	DC.W	32768,N,16384,N,8192,N,4096,N,2048,N,1024,N,512,N,256,N,128,N,64,N,32,N,16,N,8,N,4,N,2,N,1,N
N	SET	N+8
	ENDR
	DCB.W	1000,0

	DCB.W	300,0
N	SET	0
CORES_Y	REPT	200
	DC.W	N*160
N	SET	N+1
	ENDR
	DCB.W	300,0

COOR_POINT	INCBIN	DRAPEAU.COR
	DC.L	"CACA"

INC_X	INCBIN	INC_X.DRA
FIN_INC_X	DS.B	FIN_INC_X-INC_X
	DC.W	$1234

INC_Y	INCBIN	INC_Y.DRA
FIN_INC_Y	DS.B	FIN_INC_Y-INC_Y
	DC.W	$1234

	BSS
	DS.L	256
NEW_PILE	DS.L	1
	DS.B	256
BUFFER	DS.B	32000*2
SCREEN1	DS.L	1
SCREEN2	DS.L	1
***
NB_PTS	DS.W	1
PT_INC_X	DS.L	1
PT_INC_Y	DS.L	1
ADR_EFF	DS.L	2
BUF_EFF	DS.W	1000*2
BUF_COD_DRAPEAU	DS.B	30000
