SPEED = 4
TEMPO_INTER_LET = 7
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
*********
	LEA	NEWPILE,A7
	MOVE.L	#TEXT1,PT_TXT
	MOVE	#$2300,SR
	CLR.L	$FFFF8240.W
	CLR.L	$FFFF8244.W
	CLR.L	$FFFF8248.W
	CLR.L	$FFFF824C.W
	CLR.L	$FFFF8250.W
	CLR.L	$FFFF8254.W
	CLR.L	$FFFF8258.W
	CLR.L	$FFFF825C.W

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN1B
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2B
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
**
	LEA	TEXT1,A0
	JSR	PREP_TEXT

	MOVE.L	#VBL_DEBUT,$70.W
	MOVE.L	#TB0,$120.W

JUMP	TST.L	MODIF
	BEQ.S	JUMP
	CLR.L	MODIF
	MOVE.L	PT_TXT,A0
	LEA	202(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	OI
	LEA	TEXT1,A0
OI	MOVE.L	A0,PT_TXT
	JSR	PREP_TEXT
	LEA	FAD,A0
KKK	TST.L	VBL_FLAG
	BEQ.S	KKK
	CLR.L	VBL_FLAG
	ADDQ.L	#1,CNT_FAD
	CMPI.L	#3,CNT_FAD
	BNE.S	KKK
	CMPI	#$9999,(A0)
	BEQ.S	OK_GO
	MOVE	(A0)+,$FFFF8244.W
	CLR.L	CNT_FAD
	BRA.S	KKK
OK_GO	JSR	EFFACE_PLAN3
	MOVE.L	#VBL_PART1,$70.W
	CLR.L	CNT_FAD
	CLR.L	VBL_FLAG
	BRA	JUMP
CNT_FAD	DC.L	0
FAD	DC	$444,$333,$222,$111,$000,$9999
EFFACE_PLAN3	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	MOVE	#7999,D0
.EFF	CLR.L	(A0)
	CLR.L	(A1)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	DBF	D0,.EFF
	RTS
CHG_RETURN	EQU	*+2
FIN	
	JMP	FIN
PT_TXT	DC.L	0
MODIF	DC.L	0
TIME	DC.L	0
VBL_FLAG	DC.L	0
VBL_DEBUT	
VBL_PART1	MOVEM.L	D0-A6,-(SP)
NO_MUS2	CLR.B	$FFFFFA1B.W
MOD_ZIK	EQU	*+2
;	JSR	$12345678
	SF	$FFFF8240.W
	MOVE.L	#TB0,$120.W
;	CMPI.B	#1,$FFFFFC02.W
;	BEQ.S	SAUT
	JSR	AFF_ROUTY
SAUT	JSR	SWAPEC
	ADDQ.L	#1,TIME
	CMPI.L	#50*20,TIME
	BNE.S	NO_TIME
	MOVE.L	#VBL_TRANSIT,$70.W
	ADDQ.L	#1,MODIF
NO_TIME	MOVEM.L	(SP)+,D0-A6
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	IOIO
	ST	$FFFF8240.W
IOIO	

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W

	LEA	$FFFF8209.W,A6
	LEA	$FFFF8260.W,A4
	LEA	$FFFF820A.W,A3
	MOVEQ	#0,D7	
	MOVEQ	#0,D1		
	MOVEQ	#$10,D6
	MOVE.L	#200-1-1,D0
;	MOVE	#$2700,SR

SYNCHRO	MOVE.B	(A6),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		
	DCB	97-1,$4E71
FULL	NOP
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71
	DBF	D0,FULL

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
VBL_TRANSIT	MOVEM.L	D0-A6,-(SP)
	CLR.B	$FFFFFA1B.W
;MOD_ZIK2	EQU	*+2
;	JSR	$12345678
	ADDQ.L	#1,VBL_FLAG
	JSR	SWAPEC
	CLR.L	TIME
	MOVEM.L	(SP)+,D0-A6
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

;TIME	DC.L	0
RTE	RTE

TB0	
	CLR.B	$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TA0	RTE

SWAPEC	

	MOVE.L	SCREEN1B,D0
	MOVE.L	SCREEN2B,SCREEN1B
	MOVE.L	D0,SCREEN2B

	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
**
AFF_ROUTY
	MOVE.W	#$222,$FFFF8242.W
	MOVE.W	#$444,$FFFF8244.W
	MOVE.W	#$444,$FFFF8246.W
	MOVE.L	#$07770777,$FFFF8250.W
	MOVE.L	#$07770777,$FFFF8254.W
	MOVE.L	#$07770777,$FFFF8258.W
	MOVE.L	#$07770777,$FFFF825C.W
	BSR	AFF_TEXT
	RTS
AFF_TEXT	TST.B	FLAG_FIN_PRISE
	BNE	.AFF_RIEN

	SUBQ.W	#1,TEMPO_LET
	BGT	.PAS_ENCORE
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVE.W	#TEMPO_INTER_LET,TEMPO_LET
	MOVE.L	PT_SRC,A0
	MOVE.W	(A0)+,D3	;X_DEP
	MOVE.W	(A0)+,D4	;Y_DEP
	CMPI.W	#$1234,(A0)
	BNE.S	.PAS_LOOP_SRC
	;MOVE.L	#VBL_ENDING,$70.W	
	LEA	CRB_SRC,A0
.PAS_LOOP_SRC	MOVE.L	A0,PT_SRC
	MOVE.L	PT_LET,A0
	MOVE.W	(A0)+,D5	;X_ARR
	MOVE.W	(A0)+,D6	;Y_ARR
	MOVE.W	(A0)+,D7	;No DU SPRITE ( Z=0 )
	CMPI.W	#$1234,(A0)
	BNE.S	.PAS_LOOP_LET
	ST	FLAG_FIN_PRISE
.PAS_LOOP_LET	MOVE.L	A0,PT_LET
	MOVE.W	D5,-(SP)
	MOVE.W	D6,-(SP)
	SUB.W	D3,D5	;DX
	SUB.W	D4,D6	;DY
	EXT.L	D5
	EXT.L	D6
	ASL.L	#8,D5
	ASL.L	#8,D6
	DIVS.W	#(150/SPEED),D5 ;PAS_X
	DIVS.W	#(150/SPEED),D6 ;PAS_Y
	EXT.L	D3
	EXT.L	D4
	ASL.L	#8,D3
	ASL.L	#8,D4
	LEA	BUF_TIRS,A0
.CONT_S	TST.W	14(A0)
	BGE.S	.PAS_BON
	MOVE.L	D3,(A0)+	;X_DEP
	MOVE.L	D4,(A0)+	;Y_DEP
	MOVE.W	#150,(A0)+	;Z_DEP
	MOVE.W	D5,(A0)+	;PAS_X
	MOVE.W	D6,(A0)+	;PAS_Y
	CLR.W	(A0)+	;FLAG=0-->TIR EN COURS !!!
	MOVE.W	D7,(A0)+	;No DE LA LETTRE ( Z=0 )
	MOVE.W	(SP)+,D6
	MOVE.W	(SP)+,D5
	MOVE.W	D5,(A0)+
	MOVE.W	D6,(A0)

	BRA.S	.FIN_S
.PAS_BON	LEA	22(A0),A0
	BRA.S	.CONT_S
.FIN_S
.PAS_ENCORE
.AFF_RIEN
	MOVE.L	BUF_ADR_CARR�,A0
.CONT_RECOP	CMPI.W	#$1234,(A0)
	BEQ.S	.STOP_RECOP
	MOVE.L	SCREEN2,A1
	LEA	160-30*230(A1),A1
	ADDA.W	(A0)+,A1	;A1=ADRESSE ECRAN
	MOVE.W	(A0)+,D7
	MOVEQ	#0,D3
.RECOP_SCREEN	ADDQ.W	#4,A0
	MOVE.W	D3,(A1)
	MOVE.W	D3,8(A1)
	LEA	230(A1),A1
	DBRA	D7,.RECOP_SCREEN
	BRA.S	.CONT_RECOP

.STOP_RECOP	MOVE.L	BUF_ADR_CARR�,A5
	LEA	BUF_TIRS,A0
.RECOM_AFF	CMPA.L	#FIN_BUF_TIRS,A0
	BGE	.FIN_AFF
	TST.W	14(A0)
	BLT	.PAS_AFF
	SF	FLAG
	MOVE.L	(A0),D3	;X
	MOVE.L	4(A0),D4	;Y
	MOVE.W	8(A0),D5	;Z
	BGT.S	.Z_DIFF_0
	ST	FLAG
.Z_DIFF_0	ADD.W	D5,D5
	MOVE.W	D5,D6
	LEA	BUF_COEFF,A1
	MOVE.W	(A1,D5.W),D5	;COEFF 3D
	LEA	CORES_ZOOM,A1
	MOVE.W	(A1,D6.W),D6	;No DU ZOOM
	ASR.L	#8,D3	;X*2
	ASR.L	#8,D4	;Y*2
	ASL.L	#1,D3
	ASL.L	#1,D4
	MULS.W	D5,D3	;X PROJET�
	MULS.W	D5,D4	;Y PROJET�
	SWAP	D3
	SWAP	D4
	ADDI.W	#230,D3
	ADDI.W	#100,D4
	MOVE.W	16(A0),D7	;No DE LA LETTRE
	MULU.W	#39,D6
	ADD.W	D7,D6	;D6=No DU SPRITE DANS LA BANQUE
	LEA	FONTES_I(PC),A1
	MULU.W	#6,D6
	ADDA.W	D6,A1
	LEA	FONTES_S(PC),A2
	ADDA.W	(A1)+,A2	;A2=ADRESSE DE LA FONTE
	MOVE.W	2(A1),D7	;D7=HAUTEUR
	MOVE.W	D3,D5
	ANDI.W	#15,D3	;D3=DECALAGE
	ANDI.W	#$FFF0,D5
	LSR	#1,D5
	MOVE.L	SCREEN2,A3
	LEA	160-230*30(A3),A3
;	SUB	#100,D4
	MULU.W	#230,D4
	ADD.W	D5,D4
	ADDA.W	D4,A3	;A3=ADRESSE DESTINATION ECRAN
	
	TST.B	FLAG
	BEQ.S	.OK_Z
	ADDQ.W	#2,A3
	BRA.S	.AFF_DEC

.OK_Z	MOVE.L	A3,A4
	MOVE.W	D4,(A5)+
	MOVE.W	D7,(A5)+
	MOVE.W	D7,-(SP)
.RECOP_BUF	MOVE.W	(A4),(A5)+	;ON SAUVE LE CARR�
	MOVE.W	8(A4),(A5)+
	LEA	230(A4),A4
	DBRA	D7,.RECOP_BUF
	MOVE.W	(SP)+,D7

.AFF_DEC	MOVEQ	#0,D4
	MOVE.W	(A2)+,D4
	ROR.L	D3,D4
	OR.W	D4,(A3)
	SWAP	D4
	OR.W	D4,8(A3)
	LEA	230(A3),A3
	DBRA	D7,.AFF_DEC
.PAS_AFF	LEA	22(A0),A0
	BRA	.RECOM_AFF

.FIN_AFF	MOVE.W	#$1234,(A5)

	MOVEQ	#0,D6
	MOVEQ	#0,D7
	LEA	BUF_TIRS,A0
.RECOM_INC	CMPA.L	#FIN_BUF_TIRS,A0
	BGE.S	.FIN_INC

	TST.W	14(A0)
	BLT.S	.PAS_INC
	BEQ.S	.ON_INC
	ADDQ.B	#1,14(A0)	;L'OCTET DE POIDS FORT DU FLAG EST LE NB DE VBL DURANT LESQUELLES LA LETTRES VA ETRE FIXE
	CMPI.B	#3,14(A0)
	BLT.S	.PAS_INC
	MOVE.W	#-1,14(A0)
	BRA.S	.PAS_INC
.ON_INC	MOVE.L	(A0),D3	;X
	MOVE.L	4(A0),D4	;Y
	MOVE.W	8(A0),D5	;Z
	MOVE.W	10(A0),D6	;PAS_X
	MOVE.W	12(A0),D7	;PAS_Y
	SUBQ.W	#SPEED,D5	;NEW Z
	BGT.S	.OK
	;LA LETTRE EST ARRIV�� !!
	MOVE.W	#1,14(A0)	;FLAG=1
	MOVEQ	#0,D5
	MOVEQ	#0,D6	;PAS_X=0
	MOVEQ	#0,D7	;PAS_Y=0
	MOVEQ	#0,D3
	MOVE.W	18(A0),D3
	ASL.L	#8,D3
	MOVEQ	#0,D4
	MOVE.W	20(A0),D4
	ASL.L	#8,D4
.OK	EXT.L	D6
	EXT.L	D7
	ADD.L	D6,D3	;NEW X
	ADD.L	D7,D4	;NEW Y
	MOVE.L	D3,(A0)
	MOVE.L	D4,4(A0)
	MOVE.W	D5,8(A0)
.PAS_INC	LEA	22(A0),A0
	BRA.S	.RECOM_INC
.FIN_INC
	LEA	BUF_ADR_CARR�,A0
	MOVE.L	(A0)+,D3
	MOVE.L	(A0),-(A0)
	MOVE.L	D3,4(A0)
	RTS
PREP_TEXT	;LEA	TEXT(PC),A0
	LEA	CORES_LET(PC),A1
	LEA	BUF_LET,A2
	MOVE.W	#-60,D1	;D1=Y
	MOVEQ	#9,D6
.A2	MOVE.W	#-160,D2	;D2=X
	MOVEQ	#19,D7	28-1
.A	MOVEQ	#0,D0
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVE.B	(A0)+,D0
	SUBI.B	#32,D0
	BEQ.S	.PASSE
	CMPI.B	#"I"-32,D0
	BNE.S	.L1
	MOVEQ	#5,D4
.L1	CMPI.B	#"!"-32,D0
	BNE.S	.L2
	MOVEQ	#5,D4
.L2	CMPI.B	#"-"-32,D0
	BNE.S	.L3
	MOVEQ	#6,D5
.L3	ADD.W	D0,D0
	MOVE.W	(A1,D0.W),D0	;D0=No DU SPRITE DANS LA BANQUE
	MOVE.W	D2,(A2)
	ADD.W	D4,(A2)+
	MOVE.W	D1,(A2)
	ADD.W	D5,(A2)+
	MOVE.W	D0,(A2)+
.PASSE	ADDI.W	#16,D2
	DBRA	D7,.A
	ADDI.W	#16,D1
	DBRA	D6,.A2
	MOVE.W	#1,TEMPO_LET
	MOVE.L	#CRB_SRC,PT_SRC
	MOVE.L	#BUF_LET,PT_LET
	MOVE.W	#$1234,(A2)
	LEA	BUF_TIRS,A0
	MOVEQ	#29,D7
.A3	MOVE.W	#-1,14(A0)
	LEA	22(A0),A0
	DBRA	D7,.A3
	SF	FLAG
	SF	FLAG_FIN_PRISE
	MOVE.L	#BUF_CARR�,BUF_ADR_CARR�
	MOVE.L	#BUF_CARR�+(68*30),BUF_ADR_CARR�+4
	MOVE.W	#$1234,BUF_CARR�
	MOVE.W	#$1234,BUF_CARR�+(68*30)
	RTS


	DATA	

	;DC.B	"                    "
TEXT1	DC.B	"--------------------"	1
	DC.B	"                    "	2
	DC.B	" THE CIRCLE SCROLLER"	3
	DC.B	"   WAS REALLY TOO   "	4
	DC.B	"   SLOW AND SMALL   "	5
	DC.B	"                    "	6
	DC.B	" HERE COMES ANOTHER "	7
	DC.B	" ONE A LOT COOLER ! "	8
	DC.B	"                    "	9
	DC.B	"--------------------"	10
	DC.W	$1234

TEXT2	DC.B	"  WOW! LET US SEND  "
	DC.B	"    GREETINGS TO    "
	DC.B	"                    "
	DC.B	"OVERLANDERS - LEGACY"
	DC.B	"ST CONNEXION - NAOS "
	DC.B	"UNDEAD - VEGETABLES "
	DC.B	"  ULM - SECTOR ONE  "
	DC.B	"PULSION - NPG - ACF "
	DC.B	"MYSTICS - FIREHAWKS "
	DC.B	"LOST BOYS - EQUINOX "
	DC.W	$1234
TEXT3	DC.B	"    -- AND TO --    "
	DC.B	"                    "
	DC.B	"THE CAREBEARS - NEXT"
	DC.B	"CHAOS - ZUUL - ACCS "
	DC.B	" THE ALLIANCE - TEX "
	DC.B	" AND TO -ALL- ATARI "
	DC.B	"  USERS AROUND THE  "
	DC.B	"        WORLD!      "
	DC.B	"                    "
	DC.B	"                    "
	DC.W	$1234
TEXT4	DC.B	"DID YOU GET OUR MEGA"
	DC.B	" DEMO CALLED CHOICE "
	DC.B	"OF GODS ? IF NOT YOU"
	DC.B	"SHOULD HURRY!  IT IS"
	DC.B	"BRILLIANT! MORE THAN"
	DC.B	"      PERFECT!      "
	DC.B	"                    "
	DC.B	" WELL MAYBE NOT BUT "
	DC.B	"     WE LOVE IT!    "
	DC.B	"                    "
	DC.W	$1234
TEXT5	
	DC.B	"                    "
	DC.B	"         AND        "
	DC.B	"                    "
	DC.B	"       WE LOVE      "
	DC.B	"                    "
	DC.B	"     M A D O K A    "
	DC.B	"                    "
	DC.B	"         TOO!       "
	DC.B	"                    "
	DC.B	"                    "
	DC.W	$1234
TEXT6	DC.B	"--------------------"
	DC.B	"--------------------"
	DC.B	"--                --"
	DC.B	"--   HAVE  NICE   --"
	DC.B	"--                --"
	DC.B	"--     DREAMS!    --"
	DC.B	"--                --"
	DC.B	"--                --"
	DC.B	"--------------------"
	DC.B	"--------------------"
	DC.W	$1234

	DC	$9999
CORES_ZOOM	INCBIN	CORE2ZOM.3D
BUF_COEFF	INCBIN	COEFF.3D

CORES_LET	DC.W	0,11,0,0,0,0,0,0,0,0,0,0,0
	DC.W	12,0,0,0,1,2,3,4,5,6,7,8,9
	DC.W	0,0,0,0,0,10,0
	DC.W	13,14,15,16,17,18,19,20,21,22
	DC.W	23,24,25,26,27,28,29,30,31,32
	DC.W	33,34,35,36,37,38,39

FONTES_I	INCBIN	BANK_FNT.INF
FONTES_S	INCBIN	BANK_FNT.SPR

CRB_SRC	
	DC	0,90
	;DC.W	-80,-25
	;DC.W	80,-25
	;DC.W	80,50
	;DC.W	-80,50
;	INCBIN	SRC_TIRS.SRC
	DC.W	$1234

	SECTION	BSS
	DS.L	256
NEWPILE	DS.L	1
	DS.B	256
BUFFER	DS.B	64000*2+64000
SCREEN1	DS.L	1
SCREEN1B	DS.L	1
SCREEN2	DS.L	1
SCREEN2B	DS.L	1
ici_
;PT_TEXT	DS.L	1
;PT_BUF	DS.W	1
;SOV_ADR	DS.L	1
;NO_DEC	DS.W	1
;PT_AFF	DS.W	1
;PART_FONTE	DS.W	1
TEMPO_LET	DS.W	1
PT_SRC	DS.L	1
PT_LET	DS.L	1
FLAG	DS.B	1
FLAG_FIN_PRISE	DS.B	1
;FLAG_TRANSFORM	DS.B	1
FLAG_FINI	DS.B	1
PASSE	DS.W	1
BUF_ADR_CARR�	DS.L	2
BUF_CARR�	DS.W	((1+1)+(2*16))*30*2
	;X(.L),Y(.L),Z(.W),PAS_X(.W),PAS_Y(.W),FLAG(.W),No(.W),X_DEF(.W),Y_DEF(.W)
BUF_TIRS	DS.W	(2+2+1+1+1+1+1+1+1)*30
FIN_BUF_TIRS
BUF_LET	DS.W	(3*200)+1
	;X(.L),Y(.L),0(.W),PAS_X(.W),0(.W),PAS_Y(.W),X_DEF(.W),Y_DEF(.W),OFFSET(.W),INC(.W)
