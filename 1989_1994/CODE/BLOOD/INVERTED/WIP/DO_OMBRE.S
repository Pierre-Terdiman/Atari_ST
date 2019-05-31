X1	EQU	0
Y1	EQU	2
X2	EQU	4
Y2	EQU	6
X3	EQU	8
Y3	EQU	10
X4	EQU	12
Y4	EQU	14
X5	EQU	16
Y5	EQU	18
X6	EQU	20
Y6	EQU	22
X7	EQU	24
Y7	EQU	26
X8	EQU	28
Y8	EQU	30
X9	EQU	32
Y9	EQU	34
X10	EQU	36
Y10	EQU	38
X11	EQU	40
Y11	EQU	42
X12	EQU	44
Y12	EQU	46
X13	EQU	48
Y13	EQU	50
X14	EQU	52
Y14	EQU	54
X15	EQU	56
Y15	EQU	58
X16	EQU	60
Y16	EQU	62

Y_CLIP=199
MAX=130

Main:
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

	JSR	POLY+8

	LEA	BUFCOD,A0
	MOVE.L	A0,SAVEA0
	LEA	TABLE,A4
	MOVE.L	A4,SAVEA4
	MOVEM.L	D0-A6,INIT

	clr.b	$fffffa07.w
	clr.b	$fffffa09.w

	;MOVE.L	#VBL,$70.W
	jmp	newvbl

mainloop
	bra.s	mainloop
VBL	ADDQ	#1,VBL_FLAG
	RTE
VBL_FLAG	DC	0
VBL_FLAG2	DC	0

fini	MOVE.L	4.W,A0
	JMP	(A0)
DONNEE	DC	0
DONNEE2	DC	0

newvbl
;	ADDQ	#1,VBL_FLAG2
;	CMPI	#4,VBL_FLAG2
;	BNE.S	.GO_GO
;.WAIT	TST	VBL_FLAG
;	BEQ.S	.WAIT
GO_GO	CLR	VBL_FLAG
	CLR	DONNEE
	CLR	DONNEE2
	SF	$FFFF8240.W
COL1	EQU	*+2
	MOVE	#$112,$FFFF8242.W
COL2	EQU	*+2
	MOVE	#$223,$FFFF8244.W
COL3	EQU	*+2
	MOVE	#$334,$FFFF8248.W
	MOVE	#$445,$FFFF8250.W

	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO_F1
	CMPI	#MAX,DONNEE
	BGT.S	NO_F1
	ADDQ	#1,DONNEE
	SUBQ	#1,DONNEE2
	ADDQ	#2,MODZ
NO_F1	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	NO_F2
	CMPI	#MAX,DONNEE2
	BGT.S	NO_F2
	SUBQ	#1,DONNEE
	ADDQ	#1,DONNEE2
	SUBQ	#2,MODZ
NO_F2	BRA	SUIT
	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE,D0
	SWAP	D0
	MOVE	DONNEE,D0
	MOVEQ	#0,D1
	MOVE	DONNEE2,D1
	SWAP	D1
	MOVE	DONNEE2,D1

	LEA	tpoitesp1,A0
	ADDQ	#6,A0
	REPT	16
	ADD	D0,(A0)
	ADDQ	#6,A0
	ENDR
SUIT
	bsr	efecr

	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	calcrot  

	MOVE.L	SCREEN2,A0
	JSR	POLY

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X4(a0),(a1)+
	move.l	X7(a0),(a1)+
	move.l	X6(a0),(a1)+
	move.l	X6(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4


	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X8(a0),(a1)+
	move.l	X3(a0),(a1)+
	move.l	X5(a0),(a1)+
	move.l	X5(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X1(a0),(a1)+
	move.l	X2(a0),(a1)+
	move.l	X5(a0),(a1)+
	move.l	X6(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X2(a0),(a1)+
	move.l	X3(a0),(a1)+
	move.l	X8(a0),(a1)+
	move.l	X8(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X1(a0),(a1)+
	move.l	X7(a0),(a1)+
	move.l	X4(a0),(a1)+
	move.l	X4(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X3(a0),(a1)+
	move.l	X4(a0),(a1)+
	move.l	X6(a0),(a1)+
	move.l	X5(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X4(a0),(a1)+
	move.l	X7(a0),(a1)+
	move.l	X6(a0),(a1)+
	move.l	X6(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4


	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X8(a0),(a1)+
	move.l	X3(a0),(a1)+
	move.l	X5(a0),(a1)+
	move.l	X5(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X1(a0),(a1)+
	move.l	X6(a0),(a1)+
	move.l	X7(a0),(a1)+
	move.l	X7(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X2(a0),(a1)+
	move.l	X8(a0),(a1)+
	move.l	X5(a0),(a1)+
	move.l	X5(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X2(a0),(a1)+
	move.l	X1(a0),(a1)+
	move.l	X4(a0),(a1)+
	move.l	X3(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4


STOP	;move.l	SCREEN1,d0		flip SCREEN
	;move.l	SCREEN2,d1
	;move.b	SCREEN2+1,$ffff8201.w
	;move.b	SCREEN2+2,$ffff8203.w
	;move.l	d0,SCREEN2
	;move.l	d1,SCREEN1

;	MOVE.L	SCREEN2,A0
;	LEA	160*100(A0),A0
;N	SET	4
;	LEA	8*N(A0),A0
;	MOVEQ	#-1,D0
;	MOVE	#39-1,D2
;FGHE2	MOVE	#20-N*2-1,D1
;FGHE	MOVE	D0,6(A0)
;	ADDQ	#8,A0
;	DBF	D1,FGHE
;	LEA	8*2*N(A0),A0
;	DBF	D2,FGHE2

	MOVEM.L	D0-A6,-(SP)
	JSR	GEN
	MOVEM.L	(SP)+,D0-A6
ZER	EQU	*+2
	MOVE	#0,D0
	ADDQ	#1,ZER
	CMPI	#128,D0
	BNE.S	ZA
	JMP	SUITE
ZA

	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w

;	MOVE.L	SCREEN1,D0
;	MOVE.L	SCREEN2,SCREEN1
;	MOVE.L	D0,SCREEN2

;	LEA	$FFFFC,A0
;	MOVE	ang1,(a0)+
;	MOVE	ang2,(a0)+
;	MOVE	ang3,(a0)+
;	move	adag1,(a0)+
;	move	adag2,(a0)+
;	move	adag3,(a0)+
;	MOVE	MODZ,(A0)+

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIME
	ST	$FFFF8240.W
NO_TIME
;.E	CMPI.B	#$39,$FFFFFC02.W
;	BNE.S	.E
;.F	CMPI.B	#$39,$FFFFFC02.W
;	BEQ.S	.F
	
	jmp	newvbl

GEN	MOVEM.L	INIT,D0-A6
;	MOVE.L	D0,SAVED0
;	JSR	EFF
;	MOVE	#SEG-1,D6
;II2	MOVE.L	D6,-(SP)
;	bsr	poly
;	MOVE.L	(SP)+,D6
;	DBF	D6,II2

	MOVE	#3999,D0
	MOVE.L	SCREEN2,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KL	MOVE	(A1),(A2)+
	MOVE	(A0),(A1)+
	LEA	8(A0),A0
	dbf	d0,KL

	JSR	GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D3
	LEA	DATAS,A0
	LEA	FINAL,A1
	LEA	-8(A0),A0
LOOPED	LEA	8(A0),A0
	MOVE.L	(A0),D2
	MOVE.L	4(A0),D1
	CMPI.L	#0,(A0)
	BEQ.S	OKVAZY
	CMP.L	D0,D1
	BLE.S	LOOPED
	MOVE.L	D1,D0
	MOVE.L	D2,D4
;	MOVE.L	#1,4(A0)
	BRA.S	LOOPED
	
OKVAZY	
	LEA	DATAS,A0	;
	LEA	-8(A0),A0	;
BOUI	LEA	8(A0),A0	;
	CMP.L	(A0),D4	;
	BNE.S	BOUI	;
	CLR.L	4(A0)	;

	MOVE.L	D4,(A1)+
	MOVE.L	D0,(A1)+
	CMPI.L	#7,D3
	BEQ.S	LP
	ADDQ.L	#1,D3
	MOVEQ	#0,D0
	LEA	DATAS,A0
	LEA	-8(A0),A0
	BRA.S	LOOPED
	
LP	LEA	DATAS,A0
	MOVE	#1999,D0
P	CLR.L	(A0)+
	DBF	D0,P
	JSR	GENERE2

;	MOVE.L	SAVED0,D0
;	DBF	D0,GEN
	MOVEM.L	D0-A6,INIT
	RTS
INIT	DS.L	16
SUITE	JSR	efecr

	MOVE.L	SCREEN2,A0
	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	JSR	8*4(A1)
	
	LEA	TABLE+4,A1

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

JE	BRA.S	JE
TB0_IR	RTE
VBL_IR
	CLR.B	$FFFFFA1B.W
	MOVE.L	SCREEN2,A0

	MOVE	#5000,D0
GTY	DBF	D0,GTY

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIM
	ST	$FFFF8240.W
NO_TIM	
 
	MOVE.L	(A1)+,A2
	CMPI.L	#0,-4(A1)
	BNE.S	ROUL
	LEA	TABLE+4,A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	JSR	8*4(A2)

	SF	$FFFF8240.W
	
KK
	RTE
SAVED0	DS.L	1
SAVEA0	DS.L	1
SAVEA4	DS.L	1
GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE.L	#-16+6,D7	OFFSET
	LEA	BUF1,A1
	LEA	BUF2,A2
	LEA	DATAS,A6
;	MOVE.L	SAVEA0,A0
;	MOVE.L	SAVEA4,A4
;	MOVE.L	A0,(A4)+
;	MOVE.L	A4,SAVEA4
	
LOOP	ADD.L	#16,D7
	CMPI	#32000,D7
	BGT	FINI
	MOVE	(A1)+,D0
	MOVE	(A1)+,D1
	MOVE	(A2)+,D2
	MOVE	(A2)+,D3

	CMP	D0,D2
	BEQ.S	SAME_MOT1
	CMP	D1,D3
	BEQ.S	SAME_MOT2
	CMPI	#0,D3
	BEQ.S	PLAN2_VIDE
MOVEL	;MOVE	#$217C,(A0)+
	;MOVE	D2,(A0)+
	;MOVE	D3,(A0)+


	MOVE	D2,D5
	SWAP	D5
	MOVE	D3,D5
	JSR	DO_IT
	
	;MOVE	D7,(A0)+
	BRA.S	LOOP
PLAN2_VIDE	CMPI	#0,D2
	BNE.S	MOVEL
	;MOVE	#$42A8,(A0)+
	;MOVE	D7,(A0)+
	BRA.S	LOOP

SAME_MOT2	CMPI	#0,D2
	BNE.S	MOVE_PLAN1
CLR_PLAN1	;MOVE	#$4268,(A0)+
	;MOVE	D7,(A0)+
	BRA.S	LOOP
MOVE_PLAN1	;MOVE	#$317C,(A0)+
	;MOVE	D2,(A0)+
	;MOVE	D7,(A0)+
	BRA.S	LOOP

SAME_MOT1	CMP	D1,D3
	BEQ.S	LOOP
	CMPI	#0,D3
	BNE.S	MOVE_PLAN2
CLR_PLAN2	;MOVE	#$4268,(A0)+
	;MOVE	D7,(A0)
	;ADDQ	#2,(A0)+
	BRA.S	LOOP
MOVE_PLAN2	;MOVE	#$317C,(A0)+
	;MOVE	D3,(A0)+
	;MOVE	D7,(A0)
	;ADDQ	#2,(A0)+
	BRA	LOOP
	
		
FINI	;MOVE	#$4E75,(A0)+
	;MOVE.L	A0,SAVEA0
	RTS

OF7	DC	0
OF2	DC	0
GENERE2
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D6
	MOVE.L	#-16+6,D7	OFFSET
	MOVE	#-16+6-230*100,OF7
	CLR	OF2
	LEA	BUF1,A1
	LEA	BUF2,A2
	LEA	FINAL,A6
	MOVE.L	SAVEA0,A0
	MOVE.L	SAVEA4,A4
	MOVE.L	A0,(A4)+
	MOVE.L	A4,SAVEA4
	REPT	8
	MOVE.L	(A6)+,(A0)+
	MOVE.L	(A6)+,D0
	ENDR
	MOVEQ	#0,D0
WLOOP	ADD.L	#16,D7
	ADD	#16,OF7
	ADDQ	#1,OF2
	CMPI	#10,OF2
	BNE.S	ROOLP
	CLR	OF2
	ADD	#70,OF7
ROOLP	CMPI	#32000,D7
	BGT	WFINI
	MOVE	(A1)+,D0
	MOVE	(A1)+,D1
	MOVE	(A2)+,D2
	MOVE	(A2)+,D3

	CMP	D0,D2
	BEQ	WSAME_MOT1
	CMP	D1,D3
	BEQ.S	WSAME_MOT2
	CMPI	#0,D3
	BEQ.S	WPLAN2_VIDE
WMOVEL	

	MOVE.B	#$40,D6
	LEA	FINAL,A6
	MOVE	D2,D5
	SWAP	D5
	MOVE	D3,D5
	LEA	-8(A6),A6
TROUVE	LEA	8(A6),A6
	CMP.L	(A6),D5
	BEQ.S	C_LE_MEME
	ADDQ.B	#1,D6
	CMPI.B	#$48,D6
	BEQ.S	PADFRQ
	BRA.S	TROUVE
C_LE_MEME	MOVE.B	#$21,(A0)+
	MOVE.B	D6,(A0)+
	MOVE	OF7,(A0)+
	BRA.S	WLOOP
PADFRQ	
	MOVE	#$217C,(A0)+
	MOVE	D2,(A0)+
	MOVE	D3,(A0)+
	MOVE	OF7,(A0)+
	BRA.S	WLOOP
WPLAN2_VIDE	CMPI	#0,D2
	BNE.S	WMOVEL
	MOVE	#$42A8,(A0)+
	MOVE	OF7,(A0)+
	BRA.S	WLOOP

WSAME_MOT2	CMPI	#0,D2
	BNE.S	WMOVE_PLAN1
WCLR_PLAN1	MOVE	#$4268,(A0)+
	MOVE	OF7,(A0)+
	BRA.S	WLOOP
WMOVE_PLAN1	
	MOVE.B	#$40,D6
	LEA	FINAL,A6
	MOVE	D2,D5
	LEA	-8(A6),A6
TROUVE2	LEA	8(A6),A6
	CMP	2(A6),D5
	BEQ.S	C_LE_MEME2
	ADDQ.B	#1,D6
	CMPI.B	#$48,D6
	BEQ.S	PADFRQ2
	BRA.S	TROUVE2
C_LE_MEME2	MOVE.B	#$31,(A0)+
	MOVE.B	D6,(A0)+
	MOVE	OF7,(A0)+
	BRA	WLOOP
PADFRQ2

	MOVE	#$317C,(A0)+
	MOVE	D2,(A0)+
	MOVE	OF7,(A0)+
	BRA	WLOOP

WSAME_MOT1	CMP	D1,D3
	BEQ	WLOOP
	CMPI	#0,D3
	BNE.S	WMOVE_PLAN2
WCLR_PLAN2	MOVE	#$4268,(A0)+
	MOVE	OF7,(A0)
	ADDQ	#2,(A0)+
	BRA	WLOOP
WMOVE_PLAN2	
	MOVE.B	#$40,D6
	LEA	FINAL,A6
	MOVE	D3,D5
	LEA	-8(A6),A6
TROUVE3	LEA	8(A6),A6
	CMP	2(A6),D5
	BEQ.S	C_LE_MEME3
	ADDQ.B	#1,D6
	CMPI.B	#$48,D6
	BEQ.S	PADFRQ3
	BRA.S	TROUVE3
C_LE_MEME3	MOVE.B	#$31,(A0)+
	MOVE.B	D6,(A0)+
	MOVE	OF7,(A0)
	ADDQ	#2,(A0)+
	BRA	WLOOP
PADFRQ3


	MOVE	#$317C,(A0)+
	MOVE	D3,(A0)+
	MOVE	OF7,(A0)
	ADDQ	#2,(A0)+
	BRA	WLOOP
	
		
WFINI	MOVE	#$4E75,(A0)+
	MOVE.L	A0,SAVEA0
	RTS

DO_IT	MOVEM.L	D0-A6,-(SP)
	LEA	DATAS,A0
HERE	CMPI.L	#0,(A0)
	BEQ.S	OKEY
	CMP.L	(A0),D5
	BEQ.S	IDEM
	LEA	8(A0),A0
	BRA.S	HERE
IDEM	LEA	4(A0),A0
	ADDQ.L	#1,(A0)+
	BRA.S	HER
	
OKEY	MOVE.L	D5,(A0)+
	MOVE.L	#1,(A0)+
HER	MOVEM.L	(SP)+,D0-A6
	RTS

	even
key	dc.b	0
	even 

calcrot
	sub.w	#1,attvbl
	beq.s	calcrots	
	bra	finacal
calcrots
	move.w	#5,attvbl
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
adag1	dc.w	2*2
adag2	dc.w	0
adag3	dc.w	0
attvbl	dc.w	10
numobj	dc.w	0	
efecr
EFF	MOVE.L	SCREEN2,A0
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
	REPT	200
	MOVEM.L	D0-D7/A1-A6,N(A0)
	MOVEM.L	D0-D7/A1-A6,N+4*14(A0)
	MOVEM.L	D0-D7/A1-A4,N+4*14*2(A0)
N	SET	N+160
	ENDR
	RTS
efecr2	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	MOVE	#199,D1
JK
N	SET	0
	REPT	20
	MOVE	D0,N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D1,JK
	RTS
efecrN	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	MOVE	#199,D1
JKE
N	SET	0
	REPT	20
	MOVE.L	D0,N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D1,JKE
	RTS

	******************
	*matrix 3axe(zyx)*
	******************
calcpoint
	lea.l	tsin(pc),a0
	lea.l	128(a0),a1
ang1	equ	*+2
	move.w	#0,d0
ang2	equ	*+2
	move.w	#0,d1
ang3	equ	*+2	
	move.w	#64*2,d2

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
MODZ	EQU	*+2
	LEA	-24(A2),A2	-310
	move.w	#160,d5
MODX	EQU	*+2
	ADD	#0,D5
	move.w	#100,d6
MODY	EQU	*+2
	ADD	#0,D6

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

	move.w	d0,(a0)+
	move.w	d1,(a0)+
;	JSR	ROUTINE
	dbra.w	d7,bmatrix
	rts

;	CLR.L	-(SP)
;	MOVE	#$20,-(SP)
;	TRAP	#1
;	ADDQ.L	#6,SP
;
;	MOVE.L	#VBK,$70.W
;
;J	BRA.S	J
;
;VBK
;	MOVE	#5000,D0
;F	DBF	D0,F
;	MOVEQ	#0,D0
;
;	ST	$FFFF8240.W
;	LEA	ADR_RTS,A4
;	lea	TAB,A3
;	MOVE	#-200,D0	X_DEP
;	MOVE	#200,D2	X_FIN
;
;	MOVE	#0,D1	Y_DEP
;	MOVE	#200,D3	Y_FIN=>(D3-D1) MOTS INSCRITS
;
;	JSR	CALCUL
;
;	nop
;
;	SF	$FFFF8240.W
;	RTE
;
;CALCUL
;	MOVEQ	#0,D4
;	SUB.W	D0,D2	DELTA X
;	SUB.W	D1,D3	DELTA Y
;	BNE.S	NON_NUL
;	RTS
;NON_NUL
;	MOVE	D2,D4
;
;	ASL	#7,D4	*128
;;	EXT.L	D4
;	DIVS.W	D3,D4	*X(+1)=(DX/DY)+X
;	MOVE	#9,D2
;	EXT.L	d4
;	ASL.L	D2,D4
;
;	ADD	D3,D3
;	ADD	D3,D3
;	NEG	D3
;	SWAP	D4
;
;;	ADD	D0,D0
;;	ADD	D0,D0
;	SUB	D1,D1
;	JMP	(A4,D3)
;
;	REPT	201
;	MOVE	D0,(A3)+
;	ADDX.L	D4,D0
;	ENDR
;ADR_RTS
;	RTS

;TAB	DS	200
;TABE	DC.L	$99999999,0,0,0

	DATA

	incbin	tsin7.aid
tsin	incbin	tsin7.aid
	incbin	tsin7.aid

tz	incbin	tzoom.aid
;TABLE_	DS.L	20*16*16

*----------------------------------------------------

paobj	dc.l	tpoly1,tpoitesp1,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11+2,face12+2,face13+2,face14+2,face15+2,face16+2 	

face11	dc.w	0,$5488,4,0,4,8,12
face12	dc.w	0,$5888,4,16,0,12,28
face13	dc.w	0,$5c88,4,12,8,24,28
face14	dc.w	0,$5888,4,4,20,24,8
face15	dc.w	0,$5c88,4,16,20,4,0 
face16	dc.w	0,$4e71,4,28,24,20,16

tpoitesp1
	dc.w	8-1

	DC	-30,80,-40
	DC	30,80,-40
	DC	30,-50,-40
	DC	-30,-50,-40
	DC	30,-50,-40
	DC	-30,-50,-40
	DC	-80,-40,-40
	DC	80,-40,-40

POLY	INCBIN	RT_POLY3.BIN

	BSS
	DS.B	411000

SCREEN1	DS.L	1
SCREEN2	DS.L	1
t_points	ds.w	20*2	
face_en_cours	ds.l	4
	DS.B	256
BUFECR	DS.B	32000
	DS.B	256
BUFECR2	DS.B	32000
CNT	DS.L	1
CNT2	DS.L	1
PNT_X	DS.L	1
PNT_Y	DS.L	1
PNT	DS.L	1
*LINE_A_EMUL
TABLE	DS.L	130*2
BUF1	DS.B	8000
BUF2	DS.B	8000
FINAL	DS.L	16
DATAS	DS.B	8000
BUFCOD	DS.B	100000
