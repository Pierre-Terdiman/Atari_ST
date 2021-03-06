X1	EQU	0
X2	EQU	4
X3	EQU	8
X4	EQU	12
X5	EQU	16
X6	EQU	20
X7	EQU	24
X8	EQU	28

MAIN	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.W	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	MOVE.L	#FIN,$018.W
	MOVE.L	#FIN,$01C.W
	MOVE.L	#FIN,$020.W

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W

	MOVE	#1,CHOICE
	JSR	INIT_ROUT_POLY
	MOVE.L	#RT_COOL,TABLE_ADR_COD+40

	MOVE.W	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.L	#VBLR,$70.W
	CLR.W	NB_VBL
	MOVE.W	#$2300,SR

IT_VBL	BSR	VSYNC
	SF	$FFFF8240.W

	BSR	EFFAC

	BSR	AFFICH

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	.NO_TIME
	ST	$FFFF8240.W
.NO_TIME

	LEA	BUF,A0
MODBUF	EQU	*+2
	ADDA.L	#0,A0
	MOVE.L	SCREEN2,A1
	MOVE	#(20*200)-1,D7
.COP	MOVE	(A1),(A0)+
	ADDQ	#8,A1
	DBF	D7,.COP
	ADD.L	#8000,MODBUF
	CMPI.L	#8000*30,MODBUF
	BNE.S	.PREC
	BRA.S	SUITE
.PREC	BSR	SWAPEC
	ADDQ	#1,TIME
	MOVE	TIME,$FFFFC
	BRA	IT_VBL
SUITE	
	MOVE	#1,MOD_SYNC
IT_VBL2	BSR	VSYNC
	SF	$FFFF8240.W

	LEA	BUF,A0
MODBUF2	EQU	*+2
	ADDA.L	#0,A0
	MOVE.L	SCREEN2,A1

	MOVE	#200-1,D7
.COP	
N	SET	0
	REPT	20
	MOVE	(A0)+,N(A1)
N	SET	N+8
	ENDR
	LEA	160(A1),A1
	DBF	D7,.COP

	ADD.L	#8000,MODBUF2
	CMPI.L	#8000*30,MODBUF2
	BNE.S	.AFF_P
	CLR.L	MODBUF2
.AFF_P	BSR	SWAPEC

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	.NO_TIME
	ST	$FFFF8240.W
.NO_TIME	

	BRA	IT_VBL2

TIME	DC	0
DONNEE	DC	256
MOD_SYNC	EQU	*+2
VSYNC	CMPI.W	#2,NB_VBL
	BLT.S	VSYNC
	CLR.W	NB_VBL
	RTS

VBLR	ADDQ.W	#1,NB_VBL
	RTE
FIN	MOVE.L	4.W,A0
	JMP	(A0)
SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

EFFAC
	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	MOVE.W	#200-1,D7
.ALL
N	SET	0
	REPT	20
	MOVE.W	D0,N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBRA	D7,.ALL
	RTS

AFFICH
	MOVE	#$4E71,MOD_PLAN

	lea	XPLO,a0
	LEA	VECTEURS,A2
	MOVEQ	#18-1,D6
AFF_A_POLY	MOVE	DONNEE,D1
	lea	face_en_cours+2,a1

	REPT	4
	MOVE	(A0),D0
	SUB	#160,D0
	MULS	D1,D0
	LSR.L	#8,D0
	ADD	#160,D0
	ADD	(A2),D0
	MOVE	D0,(A0)+
	MOVE	D0,(A1)+

	MOVE	(A0),D0
	SUB	#100,D0
	MULS	D1,D0
	LSR.L	#8,D0
	ADD	#100,D0
	ADD	2(A2),D0
	MOVE	D0,(A0)+
	MOVE	D0,(A1)+
	ENDR
	ADDQ	#4,A2
	MOVEM.L	D6/A0/A2,-(SP)
	lea	face_en_cours,a0
	JSR	RT_POLY
	MOVEM.L	(SP)+,D6/A0/A2

	DBF	D6,AFF_A_POLY
	ADD	#1,DONNEE
	RTS
face_en_cours	dC.w	4
	ds.l	4


*** Partie affichage
CHOICE	DC	0	;0=MOVE
			;1=OR
INIT_ROUT_POLY	LEA	BUF_COD_GEN,A0
	LEA	TABLE_ADR_COD,A1

	MOVE.L	#RETOUR_POLY,(A1)+
	MOVEQ	#9-1,D3
.GO	MOVE.L	#RT_COOL,(A1)+
	DBRA	D3,.GO

	MOVE.W	#$FFFF,D0	;1ER MOTIF
	MOVE.W	#$8000,D1	;DERNIER MOTIF
	MOVEQ	#0,D3	;DECALAGE

	MOVEQ	#16-1,D6
.DECAL	
	MOVEQ	#16+1,D5
	ADD.W	#18*16,D5	;D5=LONGUEUR DE LA LIGNE
	ADD.W	D3,D5

	MOVE.W	#-144,D4
	MOVEQ	#18-1,D7
.COPY_MOVED7	BSR	POZ_ADRESSE
	MOVE.W	#$3B47,(A0)+	;MOVE.W D7,d16(A5)
	MOVE.W	D4,(A0)+
	ADDQ.W	#8,D4
	SUBI.W	#16,D5
	DBRA	D7,.COPY_MOVED7

	MOVE.W	#16+1,D5
	ADD.W	D3,D5
	BSR	POZ_ADRESSE
	CMPI.W	#-1,D0
	BNE.S	.PAS_D7_1
	MOVE.W	#$3887,(A0)+	;MOVE.W D7,(A4)
	BRA.S	.RETOUR_1
.PAS_D7_1
	TST	CHOICE
	BNE.S	.OR1
	MOVE.W	#$38BC,(A0)+	;MOVE.W #$Imm,(A4)
	BRA.S	.MOV1
.OR1	MOVE	#$0054,(A0)+	OR.W #$Imm,(A4)
.MOV1	MOVE.W	D0,(A0)+
.RETOUR_1	MOVE.W	#1,D5
	ADD.W	D3,D5
	BSR	POZ_ADRESSE
	CMPI.W	#-1,D1
	BNE.S	.PAS_D7_2
	MOVE.W	#$3A87,(A0)+	;MOVE.W D7,(A5)
	BRA.S	.RETOUR_2
.PAS_D7_2
	TST	CHOICE
	BNE.S	.OR2
	MOVE.W	#$3ABC,(A0)+	;MOVE.W #$Imm,(A5)
	BRA.S	.MOV2
.OR2	MOVE	#$0055,(A0)+	OR "             "
.MOV2	MOVE.W	D1,(A0)+
.RETOUR_2
	BSR	COPY_RT_COOL

	ASR.W	#1,D1
	ADDQ.W	#1,D3	;LONGUEUR SUIVANT
	DBRA	D6,.DECAL

	LEA	TABLE_ADR_COD+1320,A1

	MOVE.W	#$7FFF,D3	;1ER MOTIF
	MOVEQ	#14,D5

	MOVEQ	#14,D2
ALL_RT	
	MOVE.L	#RETOUR_POLY,(A1)+
	MOVEQ	#9-1,D0
.GO	MOVE.L	#RT_COOL,(A1)+
	DBRA	D0,.GO

	MOVE.W	#1,A3

	MOVEQ	#0,D0
	MOVE.W	D5,D6
LITTLE	BSR	POZ_ADRESSE2
	BSET	D6,D0
	CMPI.W	#-1,D0
	BNE.S	.PAS_D7_LITTLE
	MOVE.W	#$3887,(A0)+
	BRA.S	.RETOUR_LITTLE
.PAS_D7_LITTLE
	TST	CHOICE
	BNE.S	.OR3
	MOVE.W	#$38BC,(A0)+	;MOVE.W #$Imm,(A4)
	BRA.S	.MOV3
.OR3	MOVE	#$0054,(A0)+
.MOV3	MOVE.W	D0,(A0)+

.RETOUR_LITTLE
	BSR	COPY_RT_COOL

	ADDQ.W	#1,A3
	DBRA	D6,LITTLE

	MOVE.W	D3,D0
	MOVE.W	#$8000,D1	;DERNIER MOTIF

	MOVEQ	#16-1,D6
DECAL
	MOVE.W	#18*16,A3
	ADD.W	D5,A3
	ADDQ.W	#1,A3
	MOVEQ	#16,D4
	SUB.W	D6,D4
	ADDA.W	D4,A3

	MOVE.W	#-144,D4
	MOVEQ	#18-1,D7
COPY_MOVED7	BSR	POZ_ADRESSE2
	MOVE.W	#$3B47,(A0)+	;MOVE.W D7,d16(A5)
	MOVE.W	D4,(A0)+
	ADDQ.W	#8,D4
	LEA	-16(A3),A3
	DBRA	D7,COPY_MOVED7

	MOVE.W	D5,A3
	ADDQ.W	#1,A3
	MOVEQ	#16,D4
	SUB.W	D6,D4
	ADDA.W	D4,A3
	BSR	POZ_ADRESSE2
	CMPI.W	#-1,D0
	BNE.S	.PAS_D7_3
	MOVE.W	#$3887,(A0)+	;MOVE.W D7,(A4)
	BRA.S	.RETOUR_3
.PAS_D7_3
	TST	CHOICE
	BNE.S	.OR4
	MOVE.W	#$38BC,(A0)+	;MOVE.W #$Imm,(A4)
	BRA.S	.MOV4
.OR4	MOVE	#$0054,(A0)+
.MOV4	MOVE.W	D0,(A0)+
.RETOUR_3	CMPI.W	#-1,D1
	BNE.S	.PAS_D7_4
	MOVE.W	#$3A87,(A0)+	;MOVE.W D7,(A5)
	BRA.S	.RETOUR_4
.PAS_D7_4
	TST	CHOICE
	BNE.S	.OR5
	MOVE.W	#$3ABC,(A0)+	;MOVE.W #$Imm,(A5)
	BRA.S	.MOV5
.OR5	MOVE	#$0055,(A0)+
.MOV5	MOVE.W	D1,(A0)+
.RETOUR_4
	BSR	COPY_RT_COOL

	ASR.W	#1,D1
	DBRA	D6,DECAL

	SUBQ.W	#1,D5
	LSR.W	#1,D3
	LEA	1280(A1),A1
	DBRA	D2,ALL_RT

*******
TBL4:	LEA	TABLE_A4,A0
	MOVE	#639,D7
.DEBT	CLR.L	(A0)+
	DBF	D7,.DEBT

	LEA	MINI_TABLE,A1
	MOVEQ	#0,D6	D6=X
	MOVEQ	#20-1,D7
.F	MOVEQ	#16-1,D0
.SXTEEN	MOVE	D6,(A0)+
	MOVE	(A1),(A0)+
	ADDQ	#4,D6
	DBF	D0,.SXTEEN
	ADDQ	#2,A1
	DBF	D7,.F

	MOVE	#639,D7
.FINT	MOVE	#319*4,(A0)+
	MOVE	#152,(A0)+
	;CLR	(A0)+
	DBF	D7,.FINT
TBL2:
	LEA	TABLE_A2,A0
	MOVE	#639,D7
.DEBT	CLR.L	(A0)+
	DBF	D7,.DEBT

	LEA	MINI_TABLE,A1
	MOVEQ	#0,D6	D6=X
	MOVEQ	#20-1,D7
.F	MOVEQ	#16-1,D0
.SXTEEN	MOVE	(A1),(A0)+
	MOVE	D6,(A0)
	MOVE	D6,D5
	LSR	#2,D5
	AND	#15,D5
	MULU	#1320,D5
	SUB	D5,(A0)+
	ADDQ	#4,D6
	DBF	D0,.SXTEEN
	ADDQ	#2,A1
	DBF	D7,.F

	MOVE	#639,D7
.FINT	;CLR	(A0)+
	MOVE	#152,(A0)+
	MOVE	#319*4,(A0)+
	DBF	D7,.FINT

	RTS

MINI_TABLE
N	SET	0
	REPT	20
	DC	N
N	SET	N+8
	ENDR


POZ_ADRESSE2	MOVEM.L	D5/A0,-(SP)
	MOVE.W	A3,D5
	SUBQ.W	#1,D5
	ADD.W	D5,D5
	ADD.W	D5,D5
;	SUBA.L	#BUF_COD_GEN,A0
	MOVE.L	A0,(A1,D5.W)
	MOVEM.L	(SP)+,D5/A0
	RTS
	

POZ_ADRESSE	MOVEM.L	D5/A0,-(SP)
	SUBQ.W	#1,D5
	ADD.W	D5,D5
	ADD.W	D5,D5
;	SUBA.L	#BUF_COD_GEN,A0
	MOVE.L	A0,(A1,D5.W)
	MOVEM.L	(SP)+,D5/A0
	RTS
	
COPY_RT_COOL	LEA	RT_COOL,A6
	MOVE.W	#LONG_RT_COOL,D7
.COPY	MOVE.W	(A6)+,(A0)+
	DBRA	D7,.COPY
	RTS

RT_COOL	ADD.L	D5,D6	1  PROCHAINE LIGNE:+160
	MOVE.L	D6,A4	1  A3=ADR ECRAN EN .W, WARNING!
	MOVE.L	A4,A5	1  A6=ECRAN TOO (LE A5 DE FULBERT)
	MOVE.L	D4,A2	1  D4=A2=TABLE_A2

	MOVE.W	(A1)+,D1	2  X2
	ADD.W	D1,D1	1  
	ADD.W	D1,D1	1

	MOVE.L	(A3,D1.W),D3	5
	ADD	D3,A5	2
	SWAP	D3	1

	MOVE.W	(A0)+,D1	2  X1
	ADD	D1,D1	1
	ADD	D1,D1	1
	ADD	D1,A2	2  A2=TABLE_A2+X1*4
	ADD	(A2)+,A4	3  OFFSET. A3=>1ER MOT
	SUB	(A2),D3	2  (A2)=X1*2-LE D�CALAGE... RUS�, HEIN?
	   ;D'OU D3=X2*2-(X1*2-D�CALAGE)=(X2-X1)*2+D�CALAGE, ZOU.
	MOVE.L	(A6,D3.W),A2	;5
	JMP	(A2)	;2

;TOTAL:31 NOPS. +58=89 NOPS.
LONG_RT_COOL = ((*-RT_COOL)/2)-1


RT_POLY	MOVE.L	A0,ADR_DEPART

	LEA	2(A0),A1	;A1 POINTE SUR LES POINTS
	MOVE.W	(A1),D3
	SUB.W	4(A1),D3
	MOVE.W	2(A1),D4
	SUB.W	6(A1),D4
	MOVE.W	8(A1),D6
	SUB.W	4(A1),D6
	MOVE.W	$A(A1),D5
	SUB.W	6(A1),D5
	MULS.W	D3,D5
	MULS.W	D6,D4
	SUB.L	D4,D5
	BGT.S	.VISIBLE
	RTS
.VISIBLE
;	LEA	REMP_GAUCHE,A1
;	MOVE	#(500/2)-1,D6
;.EFF_TBX	CLR.L	(A1)+
;	DBF	D6,.EFF_TBX

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7

	MOVE.W	(A0)+,D0	;NB DE POINTS COMPOSANT LA SURFACE
	LEA	BUF_EXAM,A1
	MOVE.L	A0,A2
	SUBQ.W	#1,D0
	MOVE.W	D0,NB_PTS
.COPYING	MOVE.L	(A0)+,(A1)+
	DBRA	D0,.COPYING
	MOVE.L	(A2),(A1)+

	LEA	BUF_EXAM,A0
	LEA	BUF_GAUCHE,A2
	LEA	BUF_DROIT,A3
	ADDQ.W	#4,A0
	MOVE.W	-2(A0),D3	;Y DE REFERENCE
NB_PTS = *+2
	MOVE.W	#$1234,D0
	MOVEQ	#-1,D6
	MOVEQ	#-1,D7
ALL_PTS	MOVE.W	(A0),D1	;X
	MOVE.W	2(A0),D2	;Y
	CMP.W	D2,D3
	BGE.S	ON_MONTE
ON_DESCEND	MOVE.L	-4(A0),(A2)+
	MOVE.L	(A0)+,(A2)+
	MOVE.W	D2,D3
	ADDQ.W	#1,D6
	DBRA	D0,ALL_PTS
	BRA.S	FINITO
ON_MONTE	MOVE.L	-4(A0),(A3)+
	MOVE.L	(A0)+,(A3)+
	MOVE.W	D2,D3
	ADDQ.W	#1,D7
	DBRA	D0,ALL_PTS
FINITO	;ICI LES TABLEAU BUF_GAUCHE ET BUF_DROIT SONT CONSTITU�S
	;D6=NB DE PTS-1 DANS BUF_GAUCHE
	;D7=NB DE PTS-1 DANS BUF_DROIT
	LEA	BUF_GAUCHE,A0
MAKE_REMP_GAUCHE
	LEA	REMP_GAUCHE,A1
	MOVE.W	(A0)+,D0	;X1
	MOVE.W	(A0)+,D1	;Y1
	MOVE.W	(A0)+,D2	;X2
	MOVE.W	(A0)+,D3	;Y2
	BSR	CLIPPING_Y
	TST.W	D5
	BLT.S	.NEXT
	SUB.W	D1,D3	;HAUTEUR-1 DU SEGMENT
	BEQ.S	.NEXT

	ADD.W	D1,D1
	ADDA.W	D1,A1

	ADDQ.W	#1,D3
	SUB.W	D0,D2
	BNE.S	.PAS_VERTICALE
.VERTICALE	SUBQ.W	#2,D3
	MOVE.W	D0,(A1)+
.PUT	MOVE.W	D0,(A1)+
	DBRA	D3,.PUT
	BRA.S	.NEXT
.PAS_VERTICALE	EXT.L	D2
	MOVEQ	#8,D4
	ASL.L	D4,D2
	DIVS.W	D3,D2
	EXT.L	D2
	SWAP	D2
	ROL.L	#8,D2
	SUBQ.W	#2,D3
	MOVE.W	D0,(A1)+
.MK_X	ADDX.L	D2,D0
	MOVE.W	D0,(A1)+
	DBRA	D3,.MK_X
.NEXT	DBRA	D6,MAKE_REMP_GAUCHE

	LEA	BUF_DROIT,A0
MAKE_REMP_DROIT	LEA	REMP_DROIT,A1
	MOVE.W	(A0)+,D0	;X1
	MOVE.W	(A0)+,D1	;Y1
	MOVE.W	(A0)+,D2	;X2
	MOVE.W	(A0)+,D3	;Y2
	BSR	CLIPPING_Y
	TST.W	D5
	BLT.S	.NEXT
	MOVE.W	D1,D4
	SUB.W	D3,D1	;HAUTEUR-1 DU SEGMENT
	BEQ.S	.NEXT

	ADD.W	D4,D4
	ADDA.W	D4,A1

	ADDQ.W	#1,D1
	SUB.W	D0,D2
	BNE.S	.PAS_VERTICALE
.VERTICALE	SUBQ.W	#2,D1
	MOVE.W	D0,(A1)
.PUT	MOVE.W	D0,-(A1)
	DBRA	D1,.PUT
	BRA.S	.NEXT
.PAS_VERTICALE	EXT.L	D2
	MOVEQ	#8,D4
	ASL.L	D4,D2
	DIVS.W	D1,D2
	EXT.L	D2
	SWAP	D2
	ROL.L	#8,D2
	SUBQ.W	#2,D1
	MOVE.W	D0,(A1)
.MK_X	ADDX.L	D2,D0
	MOVE.W	D0,-(A1)
	DBRA	D1,.MK_X
.NEXT	DBRA	D7,MAKE_REMP_DROIT

ADR_DEPART= *+2
	LEA	$12345678,A0
	MOVE.W	(A0)+,D7
	SUBQ.W	#1,D7
	MOVE.W	#-1000,D0	;MAXIMUM
	MOVE.W	#20000,D1	;MINIMUM
.TEST_MAX	CMP.W	2(A0),D0
	BGE.S	.FUCK
	MOVE.W	2(A0),D0
.FUCK	CMP.W	2(A0),D1
	BLE.S	.FUCK_2
	MOVE.W	2(A0),D1
.FUCK_2	ADDQ.W	#4,A0
	DBRA	D7,.TEST_MAX
	;D0 = Y MAXIMUM
	;D1 = Y MINIMUM
	CMPI.W	#200,D0
	BLT.S	.OK_Y_MAX
	MOVE.W	#199,D0
.OK_Y_MAX	TST.W	D1
	BGE.S	.OK_Y_MIN
	MOVEQ	#0,D1
.OK_Y_MIN

INIT	LEA	REMP_GAUCHE,A0
	LEA	REMP_DROIT,A1
	ADDQ.W	#1,D0
	ADD.W	D0,D0
	MOVE.W	#15,(A1,D0.W)
	MOVE.W	#25,(A0,D0.W)
	ADD.W	D1,D1
	ADDA.W	D1,A0
	ADDA.W	D1,A1
	MULU.W	#80,D1       ;D1=Y_MIN*160 (POUR ADD ECRAN)

	LEA	TABLE_ADR_COD+40,A6
	MOVE	#-1,D7
	MOVE.L	SCREEN2,D6
MOD_PLAN	NOP
	ADD.W	D1,D6	;...+Y_MIN*160
	SUBI.L	#160,D6
	MOVE.L	#TABLE_A2+640*4,D4
	MOVE.L	#160,D5
	LEA	TABLE_A4+640*4,A3
	MOVEQ	#0,D2

	ADD.L	D5,D6	1  PROCHAINE LIGNE:+160
	MOVE.L	D6,A4	1  A3=ADR ECRAN EN .W, WARNING!
	MOVE.L	A4,A5	1  A6=ECRAN TOO (LE A5 DE FULBERT)
	MOVE.L	D4,A2	1  D4=A2=TABLE_A2
	MOVE.W	(A1)+,D1	2  X2
	ADD.W	D1,D1	1  
	ADD.W	D1,D1	1
	MOVE.L	(A3,D1.W),D3	5
	ADD	D3,A5	2
	SWAP	D3	1
	MOVE.W	(A0)+,D1	2  X1
	ADD	D1,D1	1
	ADD	D1,D1	1
	ADD	D1,A2	2  A2=TABLE_A2+X1*4
	ADD	(A2)+,A4	3  OFFSET. A3=>1ER MOT
	SUB	(A2),D3	2  (A2)=X1*2-LE D�CALAGE*1320... RUS�, HEIN?   ;D'OU D3=X2*2-(X1*2-D�CALAGE)=(X2-X1)*2+D�CALAGE*1320, ZOU.
	MOVE.L	(A6,D3.W),A2
	JMP	(A2)

RETOUR_POLY	RTS

CLIPPING_Y	MOVEM.L	D4/D6/A6,-(SP)
	MOVEQ	#0,D5
	LEA	TABLE_Y,A6
	ADD.W	D1,D1
	ADD.W	D3,D3
	MOVEQ	#0,D4
	ADD.W	(A6,D1.W),D4
	ADD.W	(A6,D3.W),D4
	ASR.W	#1,D1
	ASR.W	#1,D3
	TST.W	D4
	BEQ	FIN_NORMALE
	CMPI.W	#-2,D4
	BEQ	RIEN_DU_TOUT
	CMPI.W	#4,D4
	BEQ	RIEN_DU_TOUT
	CMPI.W	#-1,D4
	BEQ	CLIP_HAUT
	CMPI.W	#2,D4
	BEQ	CLIP_BAS

CLIP_HAUT_BAS	MOVE.W	D3,D4
	SUB.W	D1,D4	;D4=Y2-Y1
	MOVE.W	D2,D5
	MULS.W	D1,D5	;D5=Y1*X2
	MOVE.W	D3,D6
	MULS.W	D0,D6	;D6=X1*Y2
	SUB.L	D5,D6	;D6=X1*Y2-Y1*X2
	MOVE.W	D2,D5
	SUB.W	D0,D5	;D5=X2-X1
	MULS.W	#200,D5	;D5=200*(X2-X1)
	DIVS.W	D4,D5
	DIVS.W	D4,D6
	ADD.W	D5,D6	;D6=X2 CLIPP�
	CMPI.W	#200,D1
	BGE.S	.C_EST_Y1
.C_EST_Y2	MOVE.W	D6,D2
	MOVE.W	#199,D3
	BRA.S	SUIT
.C_EST_Y1	MOVE.W	D6,D0
	MOVE.W	#199,D1

SUIT	MOVE.W	D3,D4
	SUB.W	D1,D4	;D4=Y2-Y1
	MOVE.W	D2,D5
	MULS.W	D1,D5	;D5=Y1*X2
	MOVE.W	D3,D6
	MULS.W	D0,D6	;D6=X1*Y2
	SUB.L	D5,D6	;D6=X1*Y2-Y1*X2
	DIVS.W	D4,D6
	;D6=X CLIPP�
	TST.W	D1
	BGE.S	.C_EST_Y2
.C_EST_Y1	MOVE.W	D6,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D5
	BRA.S	FIN_NORMALE
.C_EST_Y2	MOVE.W	D6,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D5
	BRA.S	FIN_NORMALE

CLIP_BAS	MOVE.W	D3,D4
	SUB.W	D1,D4	;D4=Y2-Y1
	MOVE.W	D2,D5
	MULS.W	D1,D5	;D5=Y1*X2
	MOVE.W	D3,D6
	MULS.W	D0,D6	;D6=X1*Y2
	SUB.L	D5,D6	;D6=X1*Y2-Y1*X2
	MOVE.W	D2,D5
	SUB.W	D0,D5	;D5=X2-X1
	MULS.W	#200,D5	;D5=200*(X2-X1)
	DIVS.W	D4,D5
	DIVS.W	D4,D6
	ADD.W	D5,D6	;D6=X2 CLIPP�
	CMPI.W	#200,D1
	BGE.S	.C_EST_Y1
.C_EST_Y2	MOVE.W	D6,D2
	MOVE.W	#199,D3
	MOVEQ	#0,D5
	BRA.S	FIN_NORMALE
.C_EST_Y1	MOVE.W	D6,D0
	MOVE.W	#199,D1
	MOVEQ	#0,D5
	BRA.S	FIN_NORMALE

CLIP_HAUT	MOVE.W	D3,D4
	SUB.W	D1,D4	;D4=Y2-Y1
	MOVE.W	D2,D5
	MULS.W	D1,D5	;D5=Y1*X2
	MOVE.W	D3,D6
	MULS.W	D0,D6	;D6=X1*Y2
	SUB.L	D5,D6	;D6=X1*Y2-Y1*X2
	DIVS.W	D4,D6
	;D6=X CLIPP�
	TST.W	D1
	BGE.S	.C_EST_Y2
.C_EST_Y1	MOVE.W	D6,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D5
	BRA.S	FIN_NORMALE
.C_EST_Y2	MOVE.W	D6,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D5
	BRA.S	FIN_NORMALE

RIEN_DU_TOUT	MOVE.W	#-1,D5
FIN_NORMALE	MOVEM.L	(SP)+,D4/D6/A6
	RTS

	DCB.W	2*640,-1
TABLE_Y	DCB.W	200,0
	DCB.W	2*640,2

XPLO	INCBIN	XPLO.DAT
VECTEURS	

	DC	1,2
	DC	3,-1
	DC	3,2
	DC	2,1
	DC	2,2
	DC	1,-1
	DC	-2,2
	DC	2,2
	DC	1,1
	DC	-1,-2
	DC	-3,-1
	DC	-3,-2
	DC	-2,-1
	DC	-2,-2
	DC	-1,-4
	DC	-3,-2
	DC	-2,-1
	DC	-1,-1
	SECTION	BSS
;BSS g�n�rale
	DS.B	256
BUFFER	DS.B	32000*2
	DS.B	100
SCREEN1	DS.L	1
SCREEN2	DS.L	1
NB_VBL	DS.W	1
;Routine d'affichage
TABLE_A4	DS.L	2*320*3
TABLE_A2	DS.L	2*320*3
BUF_EXAM	DS.W	2*50
BUF_GAUCHE	DS.W	4*50
BUF_DROIT	DS.W	4*50
REMP_GAUCHE	DS.W	250
REMP_DROIT	DS.W	250
TABLE_ADR_COD	DS.B	(1280+40)*16
BUF_COD_GEN	DS.B	39000
BUF	DS.B	30*8000


