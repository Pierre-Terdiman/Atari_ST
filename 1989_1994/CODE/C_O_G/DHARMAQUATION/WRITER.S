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
	
	MOVE.L	SCREEN1,D0
	LSR.L	#8,D0
	LEA	$FFFF8201.W,A0
	MOVEP	D0,(A0)

	SF	$FFFF8240.W
	SF	$FFFF8242.W

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
	LEA	160*60(A5),A5
	LEA	CORRES,A2
MOD	EQU	*+2
	LEA	0(A5),A5
MOD2	EQU	*+2
	LEA	0(A5),A5
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
	LEA	160(A2),A2
	LEA	160(A5),A5
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
	DC.B	'      !WELCOME!     '
	DC.B	'                    '
	DC.B	'                    '

;	DC.B	'                    '
;	DC.B	'                    '
;	DC.B	'                    '
;	DC.B	'                    '
;	DC.B	'                    '

	DC.B	'                    '
	DC.B	'     -HOLOCAUST-    '
	DC.B	'       PRESENT      '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'     A BRAND NEW    '
	DC.B	'     PRODUCTION!    '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'      -CHOICE-      '
	DC.B	'                    '
	DC.B	'        -OF-        '
	DC.B	'                    '
	DC.B	'       -GODS-       '
	
	DC.B	'                    '
	DC.B	'       FINALLY      '
	DC.B	'   RELEASED IN THE  '
	DC.B	'    YEAR OF 1992!   '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'  CODED THANKS TO   '
	DC.B	' THE EFFORTS OF ALL '
	DC.B	'MEMBERS OF HOLOCAUST'
	DC.B	'                    '
	
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'      WHO ARE...    '
	DC.B	'                    '
	DC.B	'                    '
	
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'       <ZAPPY>      '
	DC.B	'   ( CODER, GFXS )  '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'       <ELRIC>      '
	DC.B	'      ( CODER )     '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'     <DAN NATO>     '
	DC.B	'      ( CODER )     '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'      <ZERIOUL>     '
	DC.B	'      ( CODER )     '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'       <NONE>       '
	DC.B	' ( CODER ON AMIGA   '
	DC.B	' PREVIOUSLY CALLED  '
	DC.B	'   MR. MISTER... )  '

	DC.B	'                    '
	DC.B	'      <SLEDGE>      '
	DC.B	'( GRAPHIST ON AMIGA '
	DC.B	' PREVIOUSLY CALLED  '
	DC.B	'     NEWTEK... )    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'      <BLYZARD>     '
	DC.B	'(GRAPHIST ON AMIGA) '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'  COPY THIS DEMO:   '
	DC.B	' 2 SIDES, 79 TRACKS '
	DC.B	'   OF 10 SECTORS.   '
	DC.B	'                    '

	DC.B	' THE SOUNDTRACK WAS '
	DC.B	'  RIPPED BY <NONE>  '
	DC.B	 'FROM THE ',$22,'TURMOIL',$22,' '
	DC.B	'     BY -SANITY-.   '
	DC.B	'                    '
	
	DC.B	'                    '
	DC.B	'  IT IS COMPOSED BY '
	DC.B	'     -BIT ARTS-     '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'    PRESS  SPACE    '
	DC.B	'    TO CONTINUE...  '
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
	MOVE	#000,$FFFF8242.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
MODMOD	EQU	*+2
	JMP	VBL_TXT
VBL_END	MOVE.L	#1,$140.W
;	MOVE	#$700,$FFFF8240.W
	RTE
FIN	MOVE.L	4.W,A0
	JMP	(A0)
RETOUR	MOVE	#$070,$FFFF8240.W
JU	JMP	JU
	BSS
	DS.L	256
NEW_PILE	DS.L	1
	DS.B	256
BUFFER	DS.B	32000
SCREEN1	DS.L	1
