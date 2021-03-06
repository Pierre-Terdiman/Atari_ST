;version precalc
MODE:	EQU	0
PIC_ALGO:	EQU	1
DEC_SPACE:	EQU	$0000
RESTORE_SPACE:	EQU	0

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
;	clr.l	-(sp)
;	move.w	#$20,-(sp)
;	trap	#1
;	addq.l	#6,sp

;	lea.l	8,a0
;	move.l	#fini,d0
;	move.l	#fini,d1
;	move.l	#fini,d2
;	move.l	#fini,d3
;	move.l	#fini,d4
;	move.l	#fini,d5
;	move.l	#fini,d6
;	move.l	#fini,d7
;	movem.l	d0-d7,(a0)

;	MOVEQ	#1,D0
;	JSR	ZIK

;	CLR	-(SP)
;	PEA	-1.W
;	PEA	-1.W
;	move.w	#$5,-(sp)
;	trap	#14
;	lea.l	12(sp),sp

	MOVE.L	A0,MOD_ZIK
	MOVE.L	A0,MOD_ZIK2
	MOVE.L	A1,MOD_RET
	
	LEA	DEB_BSS,A0
	LEA	END_BSS,A1
EFD	CLR.L	(A0)+
	CMP.L	A1,A0
	BLE.S	EFD
	
	move.l	#BUFECR,d0	deff ecr
	CLR.B	D0
	move.l	d0,SCREEN1
	move.l	#BUFECR2,d0	deff ecr
	CLR.B	D0
	move.l	d0,SCREEN2

	MOVE.L	#VBL_DEB,$70.W

	JSR	GENERE
	MOVE.L	#$99999999,TABE

	LEA	IMG,A0
	LEA	PRECX,A1
	JSR	depack
	MOVEM.L	PRECX+2,D0-D7
	MOVEM.L	D0-D7,SAVEPAL

	LEA	PRECY,A5
	LEA	PRECX,A6
	MOVEM.L	A5-A6,SAVE

;	MOVE	#$001,$FFFF8240.W

	CLR.B	COLOR
	CLR.B	FLAG1
	CLR.B	FLAG2
	CLR.B	FLAG3
	CLR.B	FLAG4
	
	LEA	PRECX+34,A0
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

;	MOVE	#$002,$FFFF8240.W
	
;	move.b	#$12,$fffffc02.w	

**

	LEA	TABLE_C,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C1
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C2
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C3
	ADD	D0,MOD_Y_C3+4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C5
	ADD	D0,MOD_Y_C5+4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C6
	ADD	D0,MOD_Y_C6+4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C7
	ADD	D0,MOD_Y_C7+4
	ADD	D0,MOD_Y_C7+8
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C8
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C9
	ADD	D0,MOD_Y_C9+4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C10
	ADD	D0,MOD_Y_C10+4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C11
	ADD	D0,MOD_Y_C11+4
	ADD	D0,MOD_Y_C11+8
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C12
	ADD	D0,MOD_Y_C12+4
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C13
	ADD	D0,MOD_Y_C13+4
	ADD	D0,MOD_Y_C13+8
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C14
	ADD	D0,MOD_Y_C14+4
	ADD	D0,MOD_Y_C14+8
	MOVE	(A0)+,D0
	MOVE	(A0)+,D0
	ADD	D0,MOD_Y_C15
	ADD	D0,MOD_Y_C15+4
	ADD	D0,MOD_Y_C15+8
	ADD	D0,MOD_Y_C15+12

;	move.l	#newvbl,$70.w	
	clr.b	$fffffa07.w	
	clr.b	$fffffa09.w	

;	MOVE.L	#VBL_RTE,$70.W
	JSR	PRECALC

	MOVE.L	#VBL,$70.W
	MOVE.L	#TB0,$120.W
	MOVEM.L	SAVEPAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	jmp	newvbl
VBL_DEB	MOVEM.L	D0-A6,SAVE_ALL
MOD_ZIK	EQU	*+2
	JSR	MOD_ZIK
	MOVEM.L	SAVE_ALL,D0-A6
	RTE
SAVE_ALL	DS.L	16
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
	movem.l	d0-a6,-(sp)
	MOVE	#1,$FFFF8240.W
	MOVE	#$121,$FFFF825C.W
	MOVE	#$444,$FFFF8246.W
MOD_ZIK2	EQU	*+2
	JSR	MOD_ZIK2
NOSCROL
K	movem.l	(sp)+,d0-a6
TB0
VBL_RTE	RTE
VBL_FLAG	DC.L	0

fini	MOVE.L	4.W,A0
	JMP	(A0)

DONNEE	DC	$83
DONNEE2	DC	-$83
newvbl        
	;SF	$FFFF8240.W

	LEA	REBOND,A0
MOD_REB	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	.FDREB
	CLR	MOD_REB
	LEA	REBOND,A0
.FDREB	;MOVEQ	#0,D0
	MOVE	(A0),MOD_REB_
	ADDQ	#4,MOD_REB_
	;EXT.L	D0
	;MOVE.L	D0,MOD_REB_
	ADDQ	#2,MOD_REB


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
	;cmp.b	#$39,key
	;beq	fini

POPO	TST.L	VBL_FLAG
	BEQ.S	POPO
	CLR.L	VBL_FLAG

	CMPI.B	#$10,$FFFFFC02.W
	BEQ.S	JUMPED
POPO2	TST.L	VBL_FLAG
	BEQ.S	POPO2
	CLR.L	VBL_FLAG
JUMPED	CMPI.B	#$39,$FFFFFC02.W
	BNE	newvbl
MOD_RET	EQU	*+2
	JMP	MOD_RET
ROTATE	DC.L	0
PNT_ROT	DC	0

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
;	ADD	#1,$FFFF8240.W
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
TOK3	CMPI	#199,D1
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

	LEA	PRECX,A2
	ADDA.L	PNT_PREC,A2
	LEA	PRECY,A4
	ADDA.L	PNT_PREC,A4
	ADDA.L	PNT_PREC,A4
MOD_CADR3	EQU	*+2
	MOVE.L	#4,D3	
	MOVE.L	#RETURN,D6
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
	MOVE.L	A5,(A1)+
	MOVE.L	(A5),(A1)+
	MOVE.L	D6,(A5)
;	SUBA.L	D3,A5
	ADDA.L	D7,A5
	ENDR

*
	MOVEQ	#0,D2
	MOVE.L	SCREEN2,A5
	MOVE	#nb_pts-1,D6
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
	MOVE.L	(A1)+,(A0)
;	MOVE.L	A0,(A2)
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
	DC.L	-160*9*7
;MOD_REB_
	DC.L	0	12

	DC.L	-160*16	;VERT1
	DC.L	-160*6	2
	DC.L	-160*12	3
	DC.L	-160	4

	DC.L	-160*8*6	8
	DC.L	-160*7*6	7
	DC.L	-160*6*5	6
	DC.L	0	5
	DC.L	-160*5*5	;MER
	DC.L	-160
	DC.L	-160*20

COL0
	RTS
COL1	
MOD_Y_C1	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,0(A3)
;	NOT	D2
;	AND	D2,2(A3)
;	AND	D2,4(A3)
;	AND	D2,6(A3)
;	RTS
	ROUTY
COL2
MOD_Y_C2	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,4(A3)
;	AND	D2,6(A3)
	ROUTY
COL3	
MOD_Y_C3	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,0(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,4(A3)
;	AND	D2,6(A3)
	ROUTY
COL4	
MOD_REB_	EQU	*+2
MOD_Y_C4	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,4(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,2(A3)
;	AND	D2,6(A3)
	ROUTY
COL5	
MOD_Y_C5	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,4(A3)
	OR.B	D2,0(A3)
;	NOT	D2
;	AND	D2,2(A3)
;	AND	D2,6(A3)
	ROUTY
COL6	
MOD_Y_C6	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,4(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,6(A3)
	ROUTY
COL7
MOD_Y_C7	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,0(A3)
	OR.B	D2,2(A3)
	OR.B	D2,4(A3)
;	NOT	D2
;	AND	D2,6(A3)
	ROUTY
COL8
MOD_Y_C8	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,2(A3)
;	AND	D2,4(A3)
	ROUTY
COL9
MOD_Y_C9	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,0(A3)
;	NOT	D2
;	AND	D2,2(A3)
;	AND	D2,4(A3)
	ROUTY
COL10
MOD_Y_C10	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,4(A3)
	ROUTY
COL11
MOD_Y_C11	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,2(A3)
	OR.B	D2,0(A3)
;	NOT	D2
;	AND	D2,4(A3)
	ROUTY
COL12
MOD_Y_C12	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
;	NOT	D2
;	AND	D2,(A3)
;	AND	D2,2(A3)
	ROUTY
COL13
MOD_Y_C13	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
	OR.B	D2,0(A3)
;	NOT	D2
;	AND	D2,2(A3)
	ROUTY
COL14
MOD_Y_C14	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
	OR.B	D2,2(A3)
;	NOT	D2
;	AND	D2,(A3)
	ROUTY
COL15
MOD_Y_C15	EQU	*+2
	;LEA	0(A3),A3
	OR.B	D2,6(A3)
	OR.B	D2,4(A3)
	OR.B	D2,2(A3)
	OR.B	D2,0(A3)
	ROUTY

	even
key	dc.b	0
	even 

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

	REPT	65
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

	REPT	65
	MOVE	D0,-(A3)
	ADDX.L	D4,D0
	ENDR
ADR_RTS2
	RTS

	*-----sous programe------*	
calcrot
;	sub.w	#1,attvbl
;	beq.s	calcrots	
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
	JSR	G�N�R�3
	RTS

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

GENERE
	LEA	G�N�R�1,A0
	MOVE	#400-1,D0
G1	MOVE	#-320,(A0)+
	DBF	D0,G1
	MOVEQ	#0,D2
	MOVE	#200-8-1,D1
G2	ADDQ	#1,D2
	MOVE	D2,D0
	MULU	#160,D0
	MOVE	D0,(A0)+
	DBF	D1,G2
	MOVE	#408-1,D0
G3	MOVE	#-320,(A0)+
	DBF	D0,G3
	MOVE	#400-1,D0
G4	CLR	(A0)+
	DBF	D0,G4
	MOVEQ	#0,D1
	MOVE	#19,D2
G6	MOVE	#16-1,D3
	MOVE	#%1000000000000000,D0
G5	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	LSR	#1,D0
	DBF	D3,G5
	ADDQ	#8,D1
	DBF	D2,G6
	MOVE	#400-1,D0
G7	CLR	(A0)+
	DBF	D0,G7

	LEA	tpoitesp1,A0
	MOVE	#4095,(A0)+
	MOVEQ	#-128,D0
	MOVEQ	#64-1,D7
G9	MOVEQ	#64-1,D1
	MOVEQ	#0,D2
	
G8	MOVE	D2,D3
	ADD	D3,D3
	ADD	D3,D3
	MOVE	#128,(A0)
	SUB	D3,(A0)+
	ADDQ	#1,D2
	
	MOVE	D0,(A0)+
	MOVE	#-$83,(A0)+
	DBF	D1,G8
	ADDQ	#4,D0
	DBF	D7,G9

	LEA	SIN,A0
	lea	ZOB,A1
	LEA	1024(A1),A2
	LEA	1024(A2),A3
	MOVE	#(1024/4)-1,D0
DOSIN	MOVE.L	(A0),(A1)+
	MOVE.L	(A0),(A2)+
	MOVE.L	(A0)+,(A3)+
	DBF	D0,DOSIN

	LEA	G�N�R�3,A0
	MOVEQ	#0,D0
	MOVE	#199,D1
G10	MOVE.L	#$48E87EFF,(A0)+
	MOVE	D0,(A0)+
	MOVE.L	#$48E87EFF,(A0)+
	MOVE	D0,(A0)
	ADD	#4*14,(A0)+
	MOVE.L	#$48E81EFF,(A0)+
	MOVE	D0,(A0)
	ADD	#4*14*2,(A0)+
	ADD	#160,D0
	DBF	D1,G10
	MOVE	#$4E75,(A0)

	LEA	TABL_ROT,A0
	MOVEQ	#31,D0
G11	CLR.L	(A0)+
	MOVE.L	#4,(A0)+
	MOVE.L	#(320-64)*4,(A0)+
	DBF	D0,G11
	MOVEQ	#31,D0
G12	MOVE.L	#-4+64*4,(A0)+
	MOVE.L	#4*320,(A0)+
	MOVE.L	#-320*64*4-4,(A0)+
	DBF	D0,G12
	MOVEQ	#31,D0
G13	MOVE.L	#320*63*4+63*4,(A0)+
	MOVE.L	#-4,(A0)+
	MOVE.L	#-(320-64)*4,(A0)+
	DBF	D0,G13
	MOVEQ	#31,D0
G14	MOVE.L	#320*63*4,(A0)+
	MOVE.L	#-320*4,(A0)+
	MOVE.L	#320*64*4+4,(A0)+
	DBF	D0,G14

	RTS

depack:	movem.l	d0-a6,-(a7)
	cmp.l	#"ATM5",(a0)+
	bne	not_packed
	link	a2,#-28
	move.l	(a0)+,d0
	ifne	MODE
	lea	4(a0,d0.l),a5
	move.l	d0,-(a7)
	elseif
	move.l	a1,a5
	add.l	d0,a5
	endc
	move.l	a5,a4
	ifne	MODE
	ifne	DEC_SPACE
	lea	DEC_SPACE(a4),a5
	endc
	endc
	lea	-$c(a4),a4
	move.l	(a0)+,d0
	move.l	a0,a6
	add.l	d0,a6
	ifne	PIC_ALGO
	moveq	#0,d0
	move.b	-(a6),d0
	move	d0,-2(a2)
	ifne	RESTORE_SPACE
	lsl	#2,d0
	sub	d0,a4
	endc
	elseif
	ifne	RESTORE_SPACE
	clr	-2(a2)
	endc
	subq	#1,a6
	endc
	ifne	RESTORE_SPACE
	lea	buff_marg(pc),a3
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.save
.save_m:	move.b	(a4)+,(a3)+
	subq	#1,d0
.save:	bne.s	.save_m
	movem.l	a3-a4,-(a7)
	endc
	ifne	PIC_ALGO
	pea	(a5)
	endc
	move.b	-(a6),d7
	bra	take_type
decrunch:	move	d3,d5
take_lenght:	add.b	d7,d7
.cont_take:	dbcs	d5,take_lenght
	beq.s	.empty1
	bcc.s	.next_cod
	sub	d3,d5
	neg	d5
	bra.s	.do_copy1
.next_cod:	moveq	#3,d6
	bsr.s	get_bit2
	beq.s	.next_cod1
	bra.s	.do_copy
.next_cod1:	moveq	#7,d6
	bsr.s	get_bit2
	beq.s	.next_cod2
	add	#15,d5
	bra.s	.do_copy
.empty1:	move.b	-(a6),d7
	addx.b	d7,d7
	bra.s	.cont_take
.next_cod2:	moveq	#13,d6
	bsr.s	get_bit2
	add	#255+15,d5
.do_copy:	add	d3,d5
.do_copy1:	lea	decrun_table(pc),a4
	move	d5,d2
	bne.s	bigger
	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a6),d7
	addx.b	d7,d7
.not_empty:	bcs.s	.ho_kesako
	moveq	#1,d6
	bra.s	word
.ho_kesako:	moveq	#3,d6
	bsr.s	get_bit2
	tst.b	-28(a2)
	beq.s	.ho_kesako1
	move.b	10-28(a2,d5.w),-(a5)
	bra	tst_end
.ho_kesako1:	move.b	(a5),d0
	btst	#3,d5
	bne.s	.ho_kesako2
	bra.s	.ho_kesako3
.ho_kesako2:	add.b	#$f0,d5
.ho_kesako3:	sub.b	d5,d0
	move.b	d0,-(a5)
	bra	tst_end
get_bit2:	clr	d5
.get_bits:	add.b	d7,d7
	beq.s	.empty
.cont:	addx	d5,d5
	dbf	d6,.get_bits
	tst	d5
	rts
.empty:	move.b	-(a6),d7
	addx.b	d7,d7
	bra.s	.cont
bigger:	moveq	#2,d6
word:	bsr.s	get_bit2
contus:	move	d5,d4
	move.b	14(a4,d4.w),d6
	ext	d6
	tst.b	1-28(a2)
	bne.s	.spe_ofcod1
	addq	#4,d6
	bra.s	.nospe_ofcod1
.spe_ofcod1:	bsr.s	get_bit2
	move	d5,d1
	lsl	#4,d1
	moveq	#2,d6
	bsr.s	get_bit2
	cmp.b	#7,d5
	blt.s	.take_orof
	moveq	#0,d6
	bsr.s	get_bit2
	beq.s	.its_little
	moveq	#2,d6
	bsr.s	get_bit2
	add	d5,d5
	or	d1,d5
	bra.s	.spe_ofcod2
.its_little:	or.b	2-28(a2),d1
	bra.s	.spe_ofcod3
.take_orof:	or.b	3-28(a2,d5.w),d1
.spe_ofcod3:	move	d1,d5
	bra.s	.spe_ofcod2
.nospe_ofcod1:	bsr.s	get_bit2
.spe_ofcod2:	add	d4,d4
	beq.s	.first
	add	-2(a4,d4.w),d5
.first:	lea	1(a5,d5.w),a4
	move.b	-(a4),-(a5)
.copy_same:	move.b	-(a4),-(a5)
	dbf	d2,.copy_same
	bra.s	tst_end
make_jnk:	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a6),d7
	addx.b	d7,d7
.not_empty:	bcs.s	string
	move.b	-(a6),-(a5)
tst_end:	cmp.l	a5,a3
	bne.s	make_jnk
	cmp.l	a6,a0
	beq.s	work_done
take_type:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.nospe_ofcod
	move.b	-(a6),d0
	lea	2-28(a2),a1
	move.b	d0,(a1)+
	moveq	#1,d1
	moveq	#6,d2
.next:	cmp.b	d0,d1
	bne.s	.no_off_4b
	addq	#2,d1
.no_off_4b:	move.b	d1,(a1)+
	addq	#2,d1
	dbf	d2,.next
	st	1-28(a2)
	bra.s	.spe_ofcod
.nospe_ofcod:	sf	1-28(a2)
.spe_ofcod:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.relatif
	lea	10-28(a2),a1
	moveq	#15,d0
.next_f:	move.b	-(a6),(a1)+
	dbf	d0,.next_f
	st	-28(a2)
	bra.s	.freq
.relatif:	sf	-28(a2)
.freq:	clr	d3
	move.b	-(a6),d3
	move.b	-(a6),d0
	lsl	#8,d0
	move.b	-(a6),d0
	move.l	a5,a3
	sub	d0,a3
	bra.s	make_jnk
string:	bra	decrunch
work_done:
	ifne	PIC_ALGO
	move.l	(a7)+,a0
	pea	(a2)
	bsr.s	decod_picture
	move.l	(a7)+,a2
	endc
	ifne	RESTORE_SPACE
	movem.l	(a7)+,a3-a4
	endc
	ifne	MODE
	move.l	(a7)+,d0
	bsr	copy_decrun
	endc
	ifne	RESTORE_SPACE
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.restore
.restore_m:	move.b	-(a3),-(a4)
	subq	#1,d0
.restore:	bne.s	.restore_m
	endc
	unlk	a2
not_packed:	movem.l	(a7)+,d0-a6
 	rts
decrun_table:	dc.w	32,32+64,32+64+256,32+64+256+512,32+64+256+512+1024
	dc.w	32+64+256+512+1024+2048,32+64+256+512+1024+2048+4096
	dc.b	0,1,3,4,5,6,7,8
	ifne	PIC_ALGO
decod_picture:	move	-2(a2),d7
.next_picture:	dbf	d7,.decod_algo
	rts
.decod_algo:	move.l	-(a0),d0
	lea	0(a5,d0.l),a1
.no_odd:	lea	$7d00(a1),a2
.next_planes:	moveq	#3,d6
.next_word:	move	(a1)+,d0
	moveq	#3,d5
.next_bits:	add	d0,d0
	addx	d1,d1
	add	d0,d0
	addx	d2,d2
	add	d0,d0
	addx	d3,d3
	add	d0,d0
	addx	d4,d4
	dbf	d5,.next_bits
	dbf	d6,.next_word
	movem	d1-d4,-8(a1)
	cmp.l	a1,a2
	bne.s	.next_planes
	bra.s	.next_picture
	endc
	ifne	MODE
copy_decrun:	lsr.l	#4,d0
	lea	-12(a6),a6
.copy_decrun:	rept	4
	move.l	(a5)+,(a6)+
	endr
	dbf	d0,.copy_decrun
	rts
	endc
	ifne	RESTORE_SPACE
buff_marg:	dcb.b	$90+DEC_SPACE+$C
	endc

	DATA
;ZIK	INCBIN	B:\jess.zik
IMG	INCBIN	A:\LAND4.PAK
PNT_DATA	DC.L	0
DATAS_FACES
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG
	DC.L	DATAS_IMG

SIN	INCBIN	TSIN7.AID
;	incbin	tsin7.aid
;tsin	incbin	tsin7.aid
;	incbin	tsin7.aid

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
DEB_BSS
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
G�N�R�1	DS.B	4880
TABLO_Y	EQU	G�N�R�1+2*400
TABLO_X	EQU	G�N�R�1+2*400+192*2+808*2
tpoitesp1	ds.b	24578
*
ZOB	DS.B	1024
tsin	ds.b	1024*2
*
G�N�R�3	DS.B	3602

MINI_TABLO	DS.L	8
	DS	200*2
TAB	DS	200
	DS	200*2
TAB2	DS	200
	DS	200*2
TABE	DS.L	4
TABL_ROT	ds.b	1536
SAVEPAL	DS.B	32
END_BSS