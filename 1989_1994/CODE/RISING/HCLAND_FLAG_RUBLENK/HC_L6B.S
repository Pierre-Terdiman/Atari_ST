;version precalc

X1	EQU	0
Y1	EQU	2
X2	EQU	4
Y2	EQU	6
X3	EQU	8
Y3	EQU	10
X4	EQU	12
Y4	EQU	14

Y_CLIP=199
MAX=130
nb_pts=64	;!obligatoire

main
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	lea.l	8,a0
	move.l	#fini,d0
	move.l	#fini,d1
	move.l	#fini,d2
	move.l	#fini,d3
	move.l	#fini,d4
	move.l	#fini,d5
	move.l	#fini,d6
	move.l	#fini,d7
	movem.l	d0-d7,(a0)

;	MOVEQ	#1,D0
;	JSR	ZIK

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	move.w	#$5,-(sp)
	trap	#14
	lea.l	12(sp),sp
	
	move.l	#BUFECR,d0	deff ecr
	CLR.B	D0
	move.l	d0,SCREEN1
	move.l	#BUFECR2,d0	deff ecr
	CLR.B	D0
	move.l	d0,SCREEN2

	LEA	PRECY,A5
	LEA	PRECX,A6
	MOVEM.L	A5-A6,SAVE

	MOVE	#$001,$FFFF8240.W

	CLR.B	COLOR
	CLR.B	FLAG1
	CLR.B	FLAG2
	CLR.B	FLAG3
	CLR.B	FLAG4
	
	LEA	IMG+34,A0
;	LEA	80-32+160*40(A0),A0
	LEA	DATAS_IMG,A1
	
	MOVE	#200-1,D4
DO_A_LINE
	MOVE	#20-1,D7	20*16=320 PIX
DO_16_PIX
	MOVE	(A0),D0
	MOVE	2(A0),D1
	MOVE	4(A0),D2
	MOVE	6(A0),D3

	MOVE	#15,D5
	MOVE.B	#15,D6
DO_A_WORD
;	LEA	KAT+2,A2
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

;	MOVE	D4,-(SP)
;	MOVEQ	#0,D4
;	MOVE.B	COLOR,D4
;	LSL	#1,D4
;	ADDA.L	D4,A2
;	MOVE	(SP)+,D4
;	MOVE	(A2),(A1)+

	MOVE.L	D0,-(SP)
	MOVEQ	#0,D0
	MOVE.B	COLOR,D0
	ADD	D0,D0
	ADD	D0,D0

	LEA	TABLE,A4
	MOVE.L	(A4,D0.W),(A1)+

;	MOVE.B	D0,(A1)+
;	MOVE.B	COLOR,(A1)+
	MOVE.L	(SP)+,D0

	CLR.B	COLOR
	CLR.B	FLAG1
	CLR.B	FLAG2
	CLR.B	FLAG3
	CLR.B	FLAG4
	SUBQ.B	#1,D6
	DBF	D5,DO_A_WORD
	LEA	8(A0),A0
	DBF	D7,DO_16_PIX
;	LEA	128(A0),A0
	DBF	D4,DO_A_LINE

	MOVE	#$002,$FFFF8240.W
	
;	move.b	#$12,$fffffc02.w	

**

;	move.l	#newvbl,$70.w	
	clr.b	$fffffa07.w	
	clr.b	$fffffa09.w	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	MOVE.L	#VBL_RTE,$70.W
	JSR	PRECALC

	MOVE.L	#VBL,$70.W
	MOVE.L	#TB0,$120.W
	jmp	newvbl

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

;PNT_SYNC	DS.L	1
COLOR	DS.B	1
FLAG1	DS.B	1
FLAG2	DS.B	1
FLAG3	DS.B	1
FLAG4	DS.B	1
	EVEN		

VBL	ADDQ.L	#1,VBL_FLAG
	CLR.B	$FFFFFA1B.W
;	MOVE.L	#TB0,$120.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	movem.l	d0-a6,-(sp)
	MOVEM.L	IMG+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
;	MOVE	#$246,$FFFF825E.W
;	MOVE	#$100,$FFFF8256.W
;	MOVE	#$111,$FFFF824E.W

	LEA	BUF_SCROL,A0
	ADDQ.L	#2,A0
	MOVE.L	SCREEN1,A1
	LEA	160*193(A1),A1
	MOVE	#7-1,D0
.F
N	SET	0
	REPT	20
	MOVE	N(A0),N(A1)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	LEA	160(A1),A1
	DBF	D0,.F

	CMPI.L	#8,NB_PART
	BNE.S	.SUITV0
	JSR	TEST_LET
	CLR.L	NB_PART
.SUITV0	JSR	SCROLL
	;BSR	SCROLL
;	JSR	ZIK+4

K	movem.l	(sp)+,d0-a6
VBL_RTE	RTE
VBL_FLAG	DC.L	0

TB0
	CLR.B	$FFFFFA1B.W
	MOVE	#$200,$FFFF8256.W
	MOVE	#$222,$FFFF824E.W

	MOVE.B	#3*2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB1
	CLR.B	$FFFFFA1B.W
	MOVE	#$300,$FFFF8256.W
	MOVE	#$333,$FFFF824E.W

	MOVE.B	#6*2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB2
	CLR.B	$FFFFFA1B.W
	MOVE	#$400,$FFFF8256.W
	MOVE	#$444,$FFFF824E.W

	MOVE.B	#9*2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3
	CLR.B	$FFFFFA1B.W
	MOVE	#$500,$FFFF8256.W
	MOVE	#$555,$FFFF824E.W

	MOVE.B	#14*2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB4,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB4
	CLR.B	$FFFFFA1B.W
	MOVE	#$600,$FFFF8256.W
	MOVE	#$666,$FFFF824E.W

	MOVE.B	#20*2,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB5,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB5
	CLR.B	$FFFFFA1B.W
	MOVE	#$700,$FFFF8256.W
	MOVE	#$777,$FFFF824E.W

;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE

fini	MOVE.L	4.W,A0
	JMP	(A0)

DONNEE	DC	$83
DONNEE2	DC	-$83
newvbl        
	SF	$FFFF8240.W
;	MOVEM.L	IMG+2,D0-D7
;	MOVEM.L	D0-D7,$FFFF8240.W

	LEA	REBOND,A0
MOD_REB	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	.FDREB
	CLR	MOD_REB
	LEA	REBOND,A0
.FDREB	MOVEQ	#0,D0
	MOVE	(A0),D0
	EXT.L	D0
	MOVE.L	D0,MOD_REB_
	ADDQ	#2,MOD_REB

	LEA	TABLE_C,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C1
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C2
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C3
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C4
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C5
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C6
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C7
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C8
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C9
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C10
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C11
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C12
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C13
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C14
	MOVE	(A0)+,D0
	MOVE	(A0)+,MOD_Y_C15

	CMPI.B	#$1,$FFFFFC02.W
	BNE.S	.NO_ESC
	TST	PNT_ROT
	BLE.S	.NO_ESC
	SUBQ	#1,PNT_ROT
.NO_ESC	CMPI.B	#$2,$FFFFFC02.W
	BNE.S	.NO_1
	CMPI	#2,PNT_ROT
	BGE.S	.NO_1
	ADDQ	#1,PNT_ROT
.NO_1
	TST	PNT_ROT
	BNE.S	.GO1
	ADD.L	#nb_pts*nb_pts,PNT_PREC
	ADD.L	#1*4*3,ROTATE
.GO1	CMPI	#2,PNT_ROT
	BNE.S	.GO2
	SUB.L	#nb_pts*nb_pts,PNT_PREC
	SUB.L	#1*4*3,ROTATE
.GO2

	TST	AUTOMODE
	BNE.S	.CTRL

;	ADD.L	#nb_pts*nb_pts,PNT_PREC
;	ADD.L	#1*4*3,ROTATE

	LEA	CRB_X,A0
MOD_CRB_X	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	.FD1
	CLR	MOD_CRB_X
	LEA	CRB_X,A0
.FD1	MOVEQ	#0,D0
	MOVE	(A0)+,D0
	ADD	D0,D0
	ADD	D0,D0
	MOVE	D0,MOD_IMG_X
	ADD	#(128+16)*4,MOD_IMG_X
	ADDQ	#2,MOD_CRB_X

	LEA	CRB_Y,A0
MOD_CRB_Y	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	.FD2
	CLR	MOD_CRB_Y
	LEA	CRB_Y,A0
.FD2	MOVE.L	#((75+10)*320)*4,MOD_IMG_Y
	MOVEQ	#0,D0
	MOVE	(A0)+,D0
	EXT.L	D0
	ADD.L	D0,D0
	ADD.L	D0,D0
	ADD.L	D0,MOD_IMG_Y
	ADDQ	#2,MOD_CRB_Y

.CTRL	CMPI.B	#$4D,$FFFFFC02.W
	BNE.S	NO_F3
	ADDQ	#2*4,MOD_IMG_X
	MOVE	#1,AUTOMODE
NO_F3
	CMPI.B	#$4B,$FFFFFC02.W
	BNE.S	NO_F4
	SUBQ	#2*4,MOD_IMG_X
	MOVE	#1,AUTOMODE
NO_F4
	CMPI.B	#$50,$FFFFFC02.W
	BNE.S	NO_F5
	ADD.L	#320*2*4,MOD_IMG_Y
	MOVE	#1,AUTOMODE
NO_F5
	CMPI.B	#$48,$FFFFFC02.W
	BNE.S	NO_F6
	SUB.L	#320*2*4,MOD_IMG_Y
	MOVE	#1,AUTOMODE
NO_F6

	TST	MOD_IMG_X
	BGE.S	.OK1
	CLR	MOD_IMG_X
.OK1	CMPI	#(319-nb_pts)*4,MOD_IMG_X
	BLE.S	.OK2
	MOVE	#(319-nb_pts)*4,MOD_IMG_X
.OK2	
	TST.L	MOD_IMG_Y
	BGE.S	.OK3
	CLR.L	MOD_IMG_Y
.OK3	CMPI.L	#((199-nb_pts)*320)*4,MOD_IMG_Y
	BLE.S	.OK4
	MOVE.L	#((199-nb_pts)*320)*4,MOD_IMG_Y
.OK4
	bsr	efecr

	CMPI.B	#$52,$FFFFFC02.W
	BNE.S	.K1
	ADD.L	#nb_pts*nb_pts,PNT_PREC
	ADD.L	#1*4*3,ROTATE
	MOVE	#1,AUTOMODE
.K1
	CMPI.B	#$47,$FFFFFC02.W
	BNE.S	.K2
	SUB.L	#nb_pts*nb_pts,PNT_PREC
	SUB.L	#1*4*3,ROTATE
	MOVE	#1,AUTOMODE
.K2

	TST.L	PNT_PREC
	BGE.S	.ROOL1
	MOVE.L	#nb_pts*nb_pts*31,PNT_PREC
.ROOL1	CMPI.L	#nb_pts*nb_pts*32,PNT_PREC
	BLT.S	.ROOL2
	CLR.L	PNT_PREC
.ROOL2

	TST.L	ROTATE
	BGE.S	.ROOL3
	MOVE.L	#32*4*4*3-4*3,ROTATE
.ROOL3	CMPI.L	#32*4*4*3,ROTATE
	BLT.S	.ROOL4
	CLR.L	ROTATE
.ROOL4

	lea	TABL_ROT,A0
	ADDA.L	ROTATE,A0
	MOVE.L	(A0)+,MOD_CADR2
	MOVE.L	(A0)+,MOD_CADR3
	MOVE.L	(A0)+,MOD_CADR1

	JSR	GERE_FACE
;*

STOP	move.l	SCREEN1,d0
	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
	move.l	d0,SCREEN2
	move.l	d1,SCREEN1

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIME
	ST	$FFFF8240.W
NO_TIME
	cmp.b	#$39,key
	beq	fini

POPO	TST.L	VBL_FLAG
	BEQ.S	POPO
	CLR.L	VBL_FLAG

	CMPI.B	#$10,$FFFFFC02.W
	BEQ.S	JUMPED
POPO2	TST.L	VBL_FLAG
	BEQ.S	POPO2
	CLR.L	VBL_FLAG
JUMPED
	jmp	newvbl
ROTATE	DC.L	0
PNT_ROT	DC	0
TABL_ROT
	REPT	32	ok
	DC.L	0,4,(320-nb_pts)*4
	ENDR
	REPT	32	ok
	dc.l	-4+(nb_pts)*4,320*4,-320*nb_pts*4-4
	ENDR
	REPT	32
	DC.L	(320*(nb_pts-1)*4)+(nb_pts-1)*4,-4,-(320-nb_pts)*4
	ENDR
	REPT	32
	DC.L	320*(nb_pts-1)*4,-320*4,320*nb_pts*4+4
	ENDR

PRECALC

	CLR	adag2
	CLR	adag3
	MOVE	#4,adag1
;	clr	ang1
	CLR	ang2
	move	#$82,ang3
;	bsr	efecr

	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	calcrot  

;	LEA	DATAS_FACES,A6
;	lea	t_points,a0
;	LEA	16(A0),A0
;	lea	face_en_cours,a1
;	move.l	-(a0),(a1)+
;	move.l	-(a0),(a1)+
;	move.l	-(a0),(a1)+
;	move.l	-(a0),(a1)+
;	MOVE.L	(A6)+,PNT_DATA
;	MOVE.L	A6,-(SP)
;	JSR	GERE_FACE2
;	MOVE.L	(SP)+,A6
	ADD	#1,$FFFF8240.W
	ADDQ	#1,CNTP
	CMPI	#32,CNTP
	BEQ.S	PRECALC_DONE
	JMP	PRECALC
PRECALC_DONE	RTS
CNTP	DC	0

GERE_FACE2
	CLR	CNT
;	st	$ffff8240.w
;1) Teste si la face est visible
  	lea.l	face_en_cours,a1
	move	(a1),d3
	sub	4(a1),d3
	move	2(a1),d4
	sub	6(a1),d4
	move	4*2(a1),d0
	sub	4(a1),d0
	move	10(a1),d5
	sub	6(a1),d5
	muls	d3,d5	(X1-X2)*(Y3-Y2)
	muls	d0,d4	(X3-X2)*(Y1-Y2)
	sub.l	d4,d5	produit vectoriel
;(X1-X2)*(Y3-Y2)-(X3-X2)*(Y1-Y2)
;=(X1Y3-X1Y2-X2Y3+X2Y2)-(X3Y1-X3Y2-X2Y1+X2Y2)
;=X1Y3 - X1Y2 - X2Y3 +X2Y1 - X3Y1 + X3Y2
	bgt.s	visible2
cachee2	rts
visible2
PART2B
;2) Efface les tableaux
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	SUBA.L	A1,A1
	SUBA.L	A2,A2
	SUBA.L	A3,A3
	SUBA.L	A4,A4
	SUBA.L	A5,A5
	SUBA.L	A6,A6
	LEA	TAB,A0
N	SET	0
	REPT	7
	MOVEM.L	D0-D7/A1-A6,N(A0)
N	SET	N+14*4
	ENDR
	MOVEM.L	D0-D1,N(A0)
	LEA	TAB2,A0
N	SET	0
	REPT	7
	MOVEM.L	D0-D7/A1-A6,N(A0)
N	SET	N+14*4
	ENDR
	MOVEM.L	D0-D1,N(A0)

;3) Cr�e les nouveaux tableaux
	MOVEM.L	SAVE,A5-A6
	LEA	ADR_RTS,A4

	LEA	face_en_cours,a0
	LEA	DATAS_X,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	(A0),D0	x1
	MOVE	4(A0),D2	x2
;	MOVE	2(A0),D1
	MOVE	#nb_pts,D3
;	MOVE	D1,D4
;	ADD	D4,D4
;	ADD	D4,A3
	JSR	CALCUL

	LEA	face_en_cours,a0
	LEA	DATAS_Y,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	2(A0),D0	Y1
	MOVE	4+2(A0),D2	Y2
;	MOVE	2(A0),D1
	MOVE	#nb_pts,D3
;	MOVE	D1,D4
;	ADD	D4,D4
;	ADD	D4,A3
	JSR	CALCUL

	LEA	face_en_cours,a0
	LEA	DATAS_X2,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	12(A0),D0	x3
	MOVE	8(A0),D2	x4
;	MOVE	2(A0),D1
	MOVE	#nb_pts,D3
;	MOVE	D1,D4
;	ADD	D4,D4
;	ADD	D4,A3
	JSR	CALCUL

	LEA	face_en_cours,a0
	LEA	DATAS_Y2,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	12+2(A0),D0	Y3
	MOVE	8+2(A0),D2	Y4
;	MOVE	2(A0),D1
	MOVE	#nb_pts,D3
;	MOVE	D1,D4
;	ADD	D4,D4
;	ADD	D4,A3
	JSR	CALCUL
*******************************************************
	MOVE	#nb_pts-1,D6
DO_A_SEG2
	LEA	DATAS_X,a0
	ADD	CNT,A0
	LEA	DATAS_X2,a1
	ADD	CNT,A1

	LEA	TRAVAIL_X,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	(A0)+,D0	x3
	MOVE	(A1)+,D2	x4
;	MOVE	2(A0),D1
	MOVE	#nb_pts,D3
;	MOVE	D1,D4
;	ADD	D4,D4
;	ADD	D4,A3
	JSR	CALCUL

	LEA	DATAS_Y,a0
	ADD	CNT,A0
	LEA	DATAS_Y2,a1
	ADD	CNT,A1
	LEA	TRAVAIL_Y,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	(A0)+,D0	x3
;	MULU	#160,D0
	MOVE	(A1)+,D2	x4
;	MULU	#160,D2
;	MOVE	2(A0),D1
	MOVE	#nb_pts,D3
;	MOVE	D1,D4
;	ADD	D4,D4
;	ADD	D4,A3
	JSR	CALCUL

	LEA	TRAVAIL_X,A0
	LEA	TRAVAIL_Y,A1
	MOVE	#nb_pts-1,D7
	moveq	#0,d3
;	MOVEM.L	SAVE,A5-A6
DO_A_DOT2
	REPT	nb_pts
	MOVE	(A0)+,D0
	MOVE	(A1)+,D1
	JSR	ROUTINE
	ENDR
;	MOVEM.L	A5-A6,SAVE
	ADDQ	#2,CNT
	DBF	D6,DO_A_SEG2

DONE2	MOVEM.L	A5-A6,SAVE
	RTS
SAVE	DS.L	2
ROUTINE	MOVEM.L	D0-D2/A0-A1/A5-A6,-(SP)
;	MOVE.L	SCREEN2,a1
	MOVEQ	#0,D2
	SWAP	D0
	SWAP	D1
	CLR	D0
	CLR	D1
	SWAP	D0
	SWAP	D1

;	MOVE	xp,D0
;	MOVE	yp,d1

	TST	D0
	BGE.S	TOK1
	MOVE	#-1,D1
	MOVEQ	#0,D0
TOK1	CMPI	#320,D0
	BLT.S	TOK2
	MOVE	#-1,D1
	MOVEQ	#0,D0
TOK2
	CMPI	#-1,D1
	BGE.S	TOK3
	MOVE	#-1,D1
	MOVEQ	#0,D0
TOK3	CMPI	#192,D1
	BLE.S	TOK4
	MOVEQ	#0,D1
	MOVE	#-1,D1
TOK4	MULU	#160,D1
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
	LSL	#3,D0
	JSR	(A0,D0.W)

;	OR.B	D0,(A1,D1.W)
	MOVEM.L	SAVE,A5-A6
	MOVE.B	D0,(A6)+
	MOVE	D1,(A5)+
	MOVEM.L	A5-A6,SAVE
	MOVEM.L	(SP)+,D0-D2/A0-A1/A5-A6
	RTS

KK	MOVE.B	#%10000000,D0
	NOP
	RTS
	MOVE.B	#%01000000,D0
	NOP
	RTS
	MOVE.B	#%00100000,D0
	NOP
	RTS	
	MOVE.B	#%00010000,D0
	NOP
	RTS	
	MOVE.B	#%00001000,D0
	NOP
	RTS	
	MOVE.B	#%00000100,D0
	NOP
	RTS
	MOVE.B	#%00000010,D0
	NOP
	RTS
	MOVE.B	#%00000001,D0
	NOP
	RTS

GERE_FACE
	CLR	CNT

	LEA	DATAS_IMG,A6
MOD_IMG_X	EQU	*+2
	LEA	0(A6),A6
MOD_IMG_Y	EQU	*+2
	ADDA.L	#0,A6
MOD_CADR2	EQU	*+2
	ADDA.L	#0,A6

	MOVE	#nb_pts-1,D6
	LEA	PRECX,A2
	ADDA.L	PNT_PREC,A2
	LEA	PRECY,A4
	ADDA.L	PNT_PREC,A4
	ADDA.L	PNT_PREC,A4
MOD_CADR3	EQU	*+2
	MOVE.L	#4,D3	

	MOVE.L	MOD_CADR1,D7
	LEA	SAVER,A1
	MOVE.L	A6,A5
	MOVE.L	D3,D2
	LSL.L	#6,D2	;D2*64
;	MULU	#nb_pts,D2
;	EXT.L	D2
;	ADD.L	D3,D2

	REPT	nb_pts
	ADDA.L	D2,A5
	MOVE.L	(A5),(A1)+
	MOVE.L	A5,(A1)+
	MOVE.L	#RETURN,(A5)
;	SUBA.L	D3,A5
	ADDA.L	D7,A5
	ENDR
*
	MOVEQ	#0,D2
	MOVE.L	SCREEN2,A5
DO_A_SEG
DO_A_DOT
	;REPT	nb_pts
ROUTY	MACRO
	MOVE.L	A5,A3
	MOVE.B	(A2)+,D2
	ADD	(A4)+,A3
	MOVE.L	(A6),A0
	ADD	D3,A6
	JMP	(A0)
	ENDM
	;ENDR
	ROUTY
RETURN
	SUBQ	#1,A2
	SUBQ	#2,A4
	SUB	D3,A6
MOD_CADR1	EQU	*+2
	ADDA.L	#(320-nb_pts)*4,A6
	DBF	D6,DO_A_SEG
DONE
	LEA	SAVER,A1
	REPT	nb_pts
	MOVE.L	(A1)+,A0
	MOVE.L	(A1)+,A2
	MOVE.L	A0,(A2)
	ENDR

	RTS

PNT_PREC	DC.L	0
CNT	DC	0
TABLE
	DC.L	COL0
	DC.L	COL1
	DC.L	COL2
	DC.L	COL3
	DC.L	COL4
	DC.L	COL5
	DC.L	COL6
	DC.L	COL7
	DC.L	COL8
	DC.L	COL9
	DC.L	COL10
	DC.L	COL11
	DC.L	COL12
	DC.L	COL13
	DC.L	COL14
	DC.L	COL15
TABLE_COLORS	;A LAISSER APRES TABLE!
	DC.L	0

TABLE_C	
;	DC.L	0	MER1 - $245
;	DC.L	0	MER2 - $134
;	DC.L	-160*12
;	DC.L	-160
;	DC.L	-160*16
;	DC.L	-160*8*6
;	DC.L	-160*20
;	DC.L	-160*6
;	DC.L	-160*7*6
;	DC.L	-160*6*5
;MOD_REB_
;	DC.L	-160*30
;	DC.L	-160*5*5
;	DC.L	-160*10*7
;	DC.L	-160*9*7
;	DC.L	-160*11*7

	DC.L	-160*9*7	9
	DC.L	-160*10*7	10
	DC.L	0	LIBRE
MOD_REB_
	DC.L	-160*30	12

	DC.L	-160*16	;VERT1
	DC.L	-160*6	2
	DC.L	-160*12	3
	DC.L	-160	4

	DC.L	-160*8*6	8
	DC.L	-160*7*6	7
	DC.L	-160*6*5	6
	DC.L	0	5
	DC.L	-160*5*5	;MER
	DC.L	0	;MER
	DC.L	-160*20

COL0
	RTS
COL1	
MOD_Y_C1	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,(A3)
;	NOT	D2
;	AND	D2,2(A3)
;	AND	D2,4(A3)
;	AND	D2,6(A3)
;	RTS
	ROUTY
COL2
MOD_Y_C2	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,4(A3)
;	AND	D2,6(A3)
	ROUTY
COL3	
MOD_Y_C3	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,4(A3)
;	AND	D2,6(A3)
	ROUTY
COL4	
MOD_Y_C4	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,4(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,2(A3)
;	AND	D2,6(A3)
	ROUTY
COL5	
MOD_Y_C5	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,4(A3)
	OR.B	D2,(A3)
;	NOT	D2
;	AND	D2,2(A3)
;	AND	D2,6(A3)
	ROUTY
COL6	
MOD_Y_C6	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,4(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,6(A3)
	ROUTY
COL7
MOD_Y_C7	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,(A3)
	OR.B	D2,2(A3)
	OR.B	D2,4(A3)
;	NOT	D2
;	AND	D2,6(A3)
	ROUTY
COL8
MOD_Y_C8	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,2(A3)
;	AND	D2,4(A3)
	ROUTY
COL9
MOD_Y_C9	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,(A3)
;	NOT	D2
;	AND	D2,2(A3)
;	AND	D2,4(A3)
	ROUTY
COL10
MOD_Y_C10	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,4(A3)
	ROUTY
COL11
MOD_Y_C11	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,2(A3)
	OR.B	D2,(A3)
;	NOT	D2
;	AND	D2,4(A3)
	ROUTY
COL12
MOD_Y_C12	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,2(A3)
	ROUTY
COL13
MOD_Y_C13	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
	OR.B	D2,(A3)
;	NOT	D2
;	AND	D2,2(A3)
	ROUTY
COL14
MOD_Y_C14	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
	ROUTY
COL15
MOD_Y_C15	EQU	*+2
	LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
	OR.B	D2,2(A3)
	OR.B	D2,(A3)
	ROUTY

	even
key	dc.b	0
	even 

;FLAG	DC	0
TRIE_MAX	CMP	D0,D1
	BGT.S	AD1_WIN_A
;	BLT.S	AD0_WIN_A
;	ADDQ	#1,FLAG1
AD0_WIN_A	CMP	D2,D0
	BGT.S	AD0_WIN_B
;	BLT.S	AD2_WIN_A
;	ADDQ	#1,FLAG2
AD2_WIN_A	CMP	D3,D2
	BGT.S	AD2_WIN_B
;	BLT.S	AD3_WIN_A
;	ADDQ	#1,FLAG3
AD3_WIN_A	MOVE	D3,D4
;	TST	FLAG3
;	BNE.S	OK0
;	TST	FLAG2
;	BNE.S	OK1
;	TST	FLAG1
;	BNE.S	OK2
;	;4 Y EGAUX=> PROB
;	MOVE	#$700,$FFFF8240.W
;	JMP	FIN
;OK2	;D3=D2=D1
;OK1	;D3=D2
;	MOVE	4*3(A0),D6
;	SUB	4*2(A0),D6
;	B
OK0	MOVE	4*3(A0),D5
	RTS
AD2_WIN_B	MOVE	D2,D4
	MOVE	4*2(A0),D5
	RTS
AD0_WIN_B	CMP	D3,D0
	BGT.S	AD0_WIN_C
AD3_WIN_B	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
AD0_WIN_C	MOVE	D0,D4
	MOVE	(A0),D5
	RTS
AD1_WIN_A	CMP	D2,D1
	BGT.S	AD1_WIN_B
AD2_WIN_C	CMP	D3,D2
	BGT.S	AD2_WIN_B
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
AD1_WIN_B	CMP	D3,D1
	BGT.S	AD1_WIN_C
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
AD1_WIN_C	MOVE	D1,D4
	MOVE	4(A0),D5
	RTS


TRIE_MIN	CMP	D0,D1
	BLT.S	D1_WIN_A
D0_WIN_A	CMP	D2,D0
	BLT.S	D0_WIN_B
D2_WIN_A	CMP	D3,D2
	BLT.S	D2_WIN_B
D3_WIN_A	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D2_WIN_B	MOVE	D2,D4
	MOVE	4*2(A0),D5
	RTS
D0_WIN_B	CMP	D3,D0
	BLT.S	D0_WIN_C
D3_WIN_B	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D0_WIN_C	MOVE	D0,D4
	MOVE	(A0),D5
	RTS
D1_WIN_A	CMP	D2,D1
	BLT.S	D1_WIN_B
D2_WIN_C	CMP	D3,D2
	BLT.S	D2_WIN_B
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D1_WIN_B	CMP	D3,D1
	BLT.S	D1_WIN_C
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D1_WIN_C	MOVE	D1,D4
	MOVE	4(A0),D5
	RTS

CALCUL	LEA	ADR_RTS,A4
	MOVEQ	#0,D4
	CMP	D0,D2
	BGT.S	D2_P_G
	EXG.L	D0,D2
	BRA	OTHER
D2_P_G	SUB.W	D0,D2	DELTA X
	SUB.W	D1,D3	DELTA Y
	BNE.S	NON_NUL
	RTS
NON_NUL
	MOVE	D2,D4

	ASL	#7,D4	*128
;	EXT.L	D4
	DIVS.W	D3,D4	*X(+1)=(DX/DY)+X
	MOVE	#9,D2
	EXT.L	d4
	ASL.L	D2,D4
	
	ADD	D3,D3
	ADD	D3,D3
	NEG	D3
	SWAP	D4
	
;	ADD	D0,D0
;	ADD	D0,D0
	SUB	D1,D1
	JMP	(A4,D3)

	REPT	401*2
	MOVE	D0,(A3)+
	ADDX.L	D4,D0
	ENDR
ADR_RTS
	RTS

OTHER	LEA	ADR_RTS2,A4
	SUB.W	D0,D2	DELTA X
	SUB.W	D1,D3	DELTA Y
	BNE.S	NON_NUL2
	RTS
NON_NUL2
	MOVE	D3,D5
	ADD	D5,D5
	ADD	D5,A3
	MOVE	D2,D4
	
	ASL	#7,D4	*128
;	EXT.L	D4
	DIVS.W	D3,D4	*X(+1)=(DX/DY)+X
	MOVE	#9,D2
	EXT.L	d4
	ASL.L	D2,D4
	
	ADD	D3,D3
	ADD	D3,D3
	NEG	D3
	SWAP	D4
	
;	ADD	D0,D0
;	ADD	D0,D0
	SUB	D1,D1
	JMP	(A4,D3)

	REPT	401*2
	MOVE	D0,-(A3)
	ADDX.L	D4,D0
	ENDR
ADR_RTS2
	RTS

MINI_TABLO	DS.L	8
	DS	200*2
TAB	DS	200
	DS	200*2
TAB2	DS	200
	DS	200*2
TABE	DC.L	$99999999,0,0,0

	*-----sous programe------*	
calcrot
;	sub.w	#1,attvbl
;	beq.s	calcrots	
;	bra	finacal
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
;	move.l	d0,ptchang2+2
	addq.l	#2,d0
;	move.l	d0,ptchang1+2
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
adag1	dc.w	0
adag2	dc.w	0
adag3	dc.w	0
attvbl	dc.w	10
numobj	dc.w	0
AUTOMODE	DC	0
efecr	
	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	SUBA.L	A1,A1
	SUBA.L	A2,A2
	SUBA.L	A3,A3
	SUBA.L	A4,A4
	SUBA.L	A5,A5
	SUBA.L	A6,A6
N	SET	0
	REPT	193
	MOVEM.L	D0-D7/A1-A6,N(A0)
	MOVEM.L	D0-D7/A1-A6,N+4*14(A0)
	MOVEM.L	D0-D7/A1-A4,N+4*14*2(A0)
N	SET	N+160
	ENDR
	RTS

;	MOVE	#199,D1
;JK
;N	SET	0
;	REPT	20
;	MOVE	D0,N(A0)
;N	SET	N+8
;	ENDR
;	LEA	160(A0),A0
;	DBF	D1,JK
;	RTS
	



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
	move.w	#$82,d2

	move.w	(a0,d1.w),d3	-sinb
	neg	d3
	move.w	d3,modf3+2	

	move.w	d0,d3		d3=a-b
	sub.w	d1,d3		
	add.w	d0,d1		d1=a+b

	move.w	(a1,d1.w),d4	1/2(cos(a+b)+cos(a-b))
	add.w	(a1,d3.w),d4	cosacosb
	asr	d4
	move.w	d4,modf1+2		
	
	move.w	(a0,d1.w),d4	-1:2(sin(a+b)+sin((a-b))
	add.w	(a0,d3.w),d4	-sinacosb
	asr	d4
	neg	d4
	move.w	d4,modf2+2		

	sub.w	d0,d1
	move.w	d1,d3		
	sub.w	d2,d3		d3=b-c
	add.w	d1,d2		d2=b+c
	
	move.w	(a0,d2.w),d4	-1:2(sin(b+c)-sin((b-c))
	sub.w	(a0,d3.w),d4	-sinccosb
	asr	d4
	neg	d4
	move.w	d4,modf6+2		
	
	move.w	(a1,d2.w),d4	1/2(cos(b+c)+cos(b-c))
	add.w	(a1,d3.w),d4	cosbcosc
	asr	d4
	move.w	d4,modf9+2		

	sub.w	d1,d2
	move.w	d0,d3
	sub.w	d2,d3		d3=a-c
	add.w	d0,d2		d2=a+c
	
	move.w	(a0,d2.w),d4	1:2(sin(a+c)+sin(a-c))
	add.w	(a0,d3.w),d4	sinacosc
	asr	d4
	move.w	d4,addmodf1
	
	move.w	(a1,d2.w),d4	1:2(cos(a+c)+cos(a-c))
	add.w	(a1,d3.w),d4	cosacosc
	asr	d4
	move.w	d4,addmodf2
	
	move.w	(a1,d3.w),d4	1:2(cos(a-c)-cos(a+c))
	sub.w	(a1,d2.w),d4	sinasinc
	asr	d4
	move.w	d4,addmodf3
	
	move.w	(a0,d2.w),d4	1:2(sin(a+c)-sin(a-c))
	sub.w	(a0,d3.w),d4	cosasinc
	asr	d4
	move.w	d4,addmodf4

	sub.w	d0,d2
	move.w	#14,d3

	move.w	(a1,d0.w),d4	-cosasinbsinc+sinacosc
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf1	equ	*+2
	add.w	#0,d4
	move.w	d4,modf4+2
	
	move.w	(a0,d0.w),d4	sinasinbsinc+cosacosc
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
addmodf2	equ	*+2
	add.w	#0,d4
	move.w	d4,modf5+2
	
	move.w	(a1,d0.w),d4	cosasinbcosc+sinasinc
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
addmodf3	equ	*+2
	add.w	#0,d4
	move.w	d4,modf7+2
	
	move.w	(a0,d0.w),d4	-sinasinbcosc+cosasinc
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

	move.w	#160,d5
ADDY	EQU	*+2
	move.w	#-60,d6
	
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
	
;	move.w	d0,(a0)+
;	move.w	d1,(a0)+
	JSR	ROUTINE
	dbra.w	d7,bmatrix
	rts

SCROLL	LEA	BUF_SCROL,A0
	;MOVE.L	$44E.W,A0
	LEA	BUF_LET,A1
	REPT	8
	ROXL	(A1)

	ROXL	154(A0)
	ROXL	146(A0)
	ROXL	138(A0)
	ROXL	130(A0)
	ROXL	122(A0)
	ROXL	114(A0)
	ROXL	106(A0)
	ROXL	98(A0)
	ROXL	90(A0)
	ROXL	82(A0)
	ROXL	74(A0)
	ROXL	66(A0)
	ROXL	58(A0)	
	ROXL	50(A0)
	ROXL	42(A0)
	ROXL	34(A0)
	ROXL	26(A0)
	ROXL	18(A0)
	ROXL	10(A0)
	ROXL	2(A0)
	LEA	160(A0),A0
	ADDQ.L	#2,A1
	ENDR
	ADDI.L	#1,NB_PART
	RTS

TEST_LET	MOVEQ	#0,D0
	LEA	TEXT1,A0	
	ADDA.L	POINT,A0
	LEA	FONT8_8,A1
	CMPI.B	#$FF,(A0)
	BNE.S	.SUIT
	CLR.L	POINT
	LEA	TEXT1,A0
.SUIT	MOVE.B	(A0),D0	
	SUBI.B	#32,D0	
	LSL.W	#3,D0	
	ADDA.L	D0,A1	
	LEA	BUF_LET,A2
	MOVE.B	(A1)+,(A2)
	MOVE.B	(A1)+,2(A2)
	MOVE.B	(A1)+,4(A2)
	MOVE.B	(A1)+,6(A2)
	MOVE.B	(A1)+,8(A2)
	MOVE.B	(A1)+,10(A2)
	MOVE.B	(A1)+,12(A2)
	MOVE.B	(A1)+,14(A2)
	ADDI.L	#1,POINT
	RTS
	
TEXT1
 DC.B "        PRESS SPACE TO QUIT. YOU CAN CONTROL THE FLY BY PRESSING:    "
 DC.B "ARROW KEYS: MOVE EAST, WEST, NORTH, SOUTH.    INSERT: ROTATE LEFT.     CLR-HOME: ROTATE RIGHT. "
 DC.B "  PRESS 'ESC' OR '1' TO HAVE A CONTINUOUS ROTATION.            YES... THIS IS A BIT SLOW.  BUT I REALLY DON'T KNOW HOW TO OPTIMIZE IT. "
 DC.B " IN FACT... I NEED HELP! IF YOU HAVE EVER CODED SUCH A LANDSCAPE, YOU CAN CONTACT ME ON RTEL TO HAVE A CHAT!      "
 DC.B " YOU REALLY MUST BE TWO METERS IN FRONT OF THE MONITOR IF YOU WANNA HAVE THE BEST VIEW.    "
 DC.B "  I DON'T HAVE A LOT OF DOTS: ONLY 4096.  I HAVE A SPECIAL VERSION WITH 16384 DOTS, AND IT LOOKS A -LOT- BETTER!! ...BUT IT IS ALSO A -LOT- SLOWER!     "
 DC.B " THERE IS ALSO A 1024 DOTS VERSION WHICH LOOKS INCREDIBLY FAST COMPARED TO THIS ONE, BUT THE SCREEN IS SOOOOOOO EMPTY! NOT GOOD ENOUGH!         "
 DC.B " ABSOLUTELY ALL IS IN REALTIME IN THIS VERSION.  I SHOULD HAVE PRECALCULATED ALL THIS SHIT SINCE MY NICKNAME IS 'MISTER PRECALC', BUT WHAT DO YOU WANT TO PUT IN MEMORY? "
 DC.B " IF YOU HAVE SOME IDEAS...        OK, LET'S WRAP... 'LOVE MADOKA!                              "
 DC.B "                                                   "
	DC.B $FF
	EVEN
FONT8_8	
;FONTS_1
	DC.B	0,0,0,0,0,0,0,0
	DC.B 24,24,48,48,0,96,96,0
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
	DC.B	60,102,102,12,0,24,24,0
	DC.B	0,0,0,0,0,0,0,0

	DC.B	124,230,230,254,230,230,230,0	;A
	DC.B	252,230,230,252,230,230,252,0	;B
	DC.B	124,230,224,224,224,230,124,0	;C
	DC.B	252,230,230,230,230,230,252,0	;D
	DC.B	254,224,224,248,224,224,254,0	;E
	DC.B	254,224,224,248,224,224,224,0	;F
	DC.B	124,230,224,224,238,230,124,0	;G
	DC.B	230,230,230,254,230,230,230,0	;H
	DC.B	124,56,56,56,56,56,124,0	;I
	DC.B	14,14,14,14,14,206,124,0	;J
	DC.B	230,238,252,248,252,238,230,0	;K
	DC.B	224,224,224,224,224,224,254,0	;L
	DC.B	198,238,246,230,230,230,230,0	;M
	DC.B	252,230,230,230,230,230,230,0	;N
	DC.B	124,230,230,230,230,230,124,0	;O
	DC.B	252,230,230,252,224,224,224,0	;P
	DC.B	121,230,230,230,238,252,118,0	;Q
	DC.B	252,230,230,252,236,230,230,0	;R
	DC.B	124,230,224,124,14,206,124,0	;S
	DC.B	254,56,56,56,56,56,56,0	;T
	DC.B	230,230,230,230,230,230,124,0	;U
	DC.B	230,230,230,230,230,124,56,0	;V
	DC.B	230,230,230,230,254,238,198,0	;W
	DC.B	198,238,124,56,124,238,198,0	;X
	DC.B	230,230,230,124,56,56,56,0	;Y
	DC.B	254,206,28,56,112,230,254,0	;Z

NB_PART	DC.L	8
	
	DATA
;ZIK	INCBIN	B:\TAO\BUGGIN6.MUS	
IMG	INCBIN	A:\LAND2.PI1
PNT_DATA	DC.L	0
DATAS_FACES
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	
	incbin	tsin7.aid
tsin	incbin	tsin7.aid
	incbin	tsin7.aid

tz	incbin	tzoom.aid

paobj	dc.l	tpoly1,tpoitesp1,-1

tpoly1	dc.w	6-1
	dc.l	face11+2,face12+2,face13+2,face14+2,face15+2,face16+2 	

face11	dc.w	0,$5488,4,0,4,8,12
face12	dc.w	0,$5888,4,16,0,12,28
face13	dc.w	0,$5c88,4,12,8,24,28
face14	dc.w	0,$5888,4,4,20,24,8
face15	dc.w	0,$5c88,4,16,20,4,0 
face16	dc.w	0,$4e71,4,28,24,20,16

tpoitesp1
	dc.w	4096-1
;	dc.w	-$83,-$83,-$83		1
;	dc.w	-$83,$83,-$83		2
;	dc.w	$83,$83,-$83		3	
;	dc.w	$83,-$83,-$83		4
y	set	-128
	rept	64
	dc	128,y,-$83
	dc	128-4,y,-$83
	dc	128-4*2,y,-$83
	dc	128-4*3,y,-$83
	dc	128-4*4,y,-$83
	dc	128-4*5,y,-$83
	dc	128-4*6,y,-$83
	dc	128-4*7,y,-$83
	dc	128-4*8,y,-$83
	dc	128-4*9,y,-$83
	dc	128-4*10,y,-$83
	dc	128-4*11,y,-$83
	dc	128-4*12,y,-$83
	dc	128-4*13,y,-$83
	dc	128-4*14,y,-$83
	dc	128-4*15,y,-$83
	dc	128-4*16,y,-$83
	dc	128-4*17,y,-$83
	dc	128-4*18,y,-$83
	dc	128-4*19,y,-$83
	dc	128-4*20,y,-$83
	dc	128-4*21,y,-$83
	dc	128-4*22,y,-$83
	dc	128-4*23,y,-$83
	dc	128-4*24,y,-$83
	dc	128-4*25,y,-$83
	dc	128-4*26,y,-$83
	dc	128-4*27,y,-$83
	dc	128-4*28,y,-$83
	dc	128-4*29,y,-$83
	dc	128-4*30,y,-$83
	dc	128-4*31,y,-$83
	dc	128-4*32,y,-$83
	dc	128-4*33,y,-$83
	dc	128-4*34,y,-$83
	dc	128-4*35,y,-$83
	dc	128-4*36,y,-$83
	dc	128-4*37,y,-$83
	dc	128-4*38,y,-$83
	dc	128-4*39,y,-$83
	dc	128-4*40,y,-$83
	dc	128-4*41,y,-$83
	dc	128-4*42,y,-$83
	dc	128-4*43,y,-$83
	dc	128-4*44,y,-$83
	dc	128-4*45,y,-$83
	dc	128-4*46,y,-$83
	dc	128-4*47,y,-$83
	dc	128-4*48,y,-$83
	dc	128-4*49,y,-$83
	dc	128-4*50,y,-$83
	dc	128-4*51,y,-$83
	dc	128-4*52,y,-$83
	dc	128-4*53,y,-$83
	dc	128-4*54,y,-$83
	dc	128-4*55,y,-$83
	dc	128-4*56,y,-$83
	dc	128-4*57,y,-$83
	dc	128-4*58,y,-$83
	dc	128-4*59,y,-$83
	dc	128-4*60,y,-$83
	dc	128-4*61,y,-$83
	dc	128-4*62,y,-$83
	dc	128-4*63,y,-$83
y	set	y+4
	endr
	


	DCB	400,-320
TABLO_Y
N	SET	0
	REPT	200-8
	DC	N*160
N	SET	N+1
	ENDR

	DCB	400+8,-320
	DCB	400,0
TABLO_X

N	SET	0
	REPT	20
	DC	%1000000000000000,N
	DC	%0100000000000000,N
	DC	%0010000000000000,N
	DC	%0001000000000000,N
	DC	%0000100000000000,N
	DC	%0000010000000000,N
	DC	%0000001000000000,N
	DC	%0000000100000000,N
	DC	%0000000010000000,N
	DC	%0000000001000000,N
	DC	%0000000000100000,N
	DC	%0000000000010000,N
	DC	%0000000000001000,N
	DC	%0000000000000100,N
	DC	%0000000000000010,N
	DC	%0000000000000001,N
N	SET	N+8
	ENDR
	DCB	400,0

TABLO_X2
N	SET	0
	REPT	20
	DC	%1100000000000000,N
	DC	%0110000000000000,N
	DC	%0011000000000000,N
	DC	%0001100000000000,N
	DC	%0000110000000000,N
	DC	%0000011000000000,N
	DC	%0000001100000000,N
	DC	%0000000110000000,N
	DC	%0000000011000000,N
	DC	%0000000001100000,N
	DC	%0000000000110000,N
	DC	%0000000000011000,N
	DC	%0000000000001100,N
	DC	%0000000000000110,N
	DC	%0000000000000011,N
	DC	%0000000000000001,N
N	SET	N+8
	ENDR
	DCB	400,0

CRB_X
	INCLUDE	INC_X.CRB
	DC	$9999
CRB_Y
	INCLUDE	INC_Y.CRB
	DC	$9999
REBOND
 DC -0*160
 DC -2*160
 DC -4*160
 DC -7*160
 DC -9*160
 DC -11*160
 DC -13*160
 DC -15*160
 DC -17*160
 DC -19*160
 DC -21*160
 DC -22*160
 DC -24*160
 DC -25*160
 DC -26*160
 DC -27*160
 DC -28*160
 DC -29*160
 DC -29*160
 DC -29*160
 DC -30*160
 DC -29*160
 DC -29*160
 DC -29*160
 DC -28*160
 DC -27*160
 DC -26*160
 DC -25*160
 DC -24*160
 DC -22*160
 DC -21*160
 DC -19*160
 DC -17*160
 DC -15*160
 DC -13*160
 DC -11*160
 DC -9*160
 DC -7*160
 DC -4*160
 DC -2*160
 DC -0*160
 DC $9999
	BSS
BUF_SCROL	DS.B	160*10
BUF_LET	DS.B	(1*8)*2
POINT	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
t_points	ds.w	4096*2
face_en_cours	ds.l	4
	DS.B	32000
BUFECR	DS.B	32000
	DS.B	32000
BUFECR2	DS.B	32000
	DS.B	32000
DATAS_IMG	DS.L	320*200

DATAS_X	DS	nb_pts
DATAS_Y	DS	nb_pts
DATAS_X2	DS	nb_pts
DATAS_Y2	DS	nb_pts
TRAVAIL_X	DS	nb_pts
TRAVAIL_Y	DS	nb_pts
SAVER	DS.L	2*nb_pts
PRECX	DS.B	nb_pts*nb_pts*32
PRECY	DS	nb_pts*nb_pts*32
