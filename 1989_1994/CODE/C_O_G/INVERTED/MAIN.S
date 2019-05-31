f1614
	add.w	a5,a0
pointf1614
	bset.b	d5,(a0)
	rts	
	
point11
	lea.l	ppxpet(pc),a1
	add.w	d0,d0
	add.w	d0,a1
	
	tst.w	d3
	beq	point12
	move.w	d3,d6
	
	subq.l	#1,d6
	move.w	d2,d4
	addq.l	#2,a1
	move.w	(a1)+,d0
bpoint11
	bset.b	d0,(a0)
	add.w	(a1)+,a0
	move.w	(a1)+,d0
	sub.w	d3,d4
	bge.s	bpoint11
	add.w	d5,a0
	add.w	d2,d4
spoint11
	dbra.w	d6,bpoint11
	rts
point12
	subq.l	#1,d2
	addq.l	#2,a1
	move.w	(a1)+,d0
bpoint12	
	bset	d0,(a0)
	add.w	(a1)+,a0
	move.w	(a1)+,d0
	dbra.w	d2,bpoint12
	rts
point2
	addq.l	#1,d3
	swap	d2
	divu	d3,d2	
	moveq.w	#0,d4
	lea.l	ppxpet(pc),a1
	add.w	d0,d0
	add.w	d0,a1
	addq.l	#2,a1
	move.w	(a1)+,d0
	muls.w	#12,d3
	neg	d3
	lea.l	linvt(pc),a2
	jmp	(a2,d3.w)


lign	macro
	bset.b	d0,(a0)
	add.w	d5,a0
	add.w	d2,d4
	bcc.s	ligv\@1	
	add.w	(a1)+,a0
	move.w	(a1)+,d0
ligv\@1		
	endm

n	set	0
	rept	201
	lign	n
n	set	n+1	
	endr
linvt	
	
	rts

poly:
	JSR	LINE_A_INIT
	
	LEA	DATA_X,A5
	ADDA.L	PNT,A5
	CMPI	#$9999,(A5)
	BNE.S	OKAY
	CLR.L	PNT
	LEA	DATA_X,A5
	BRA.S	OKAY2
OKAY	ADD.L	#4*4,PNT
OKAY2	
	moveq	#0,d3

	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move	2(a5),d4
	move	6(a5),d5
	move	10(a5),d6
	move	14(a5),d7

	cmp	d4,d5
	bgt	d5_pg
	move	d4,d5
d5_pg	
	cmp	d6,d5
	bgt	d5_pg2
	move	d6,d5
d5_pg2	
	cmp	d7,d5
	bgt	d5_pg3
	move	d7,d5
d5_pg3	addq	#1,d5
	move	d5,ymax

	moveq	#0,d3

	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move	2(a5),d4
	move	6(a5),d5
	move	10(a5),d6
	move	14(a5),d7

	cmp	d4,d5
	blt	d5_pgh
	move	d4,d5
d5_pgh
	cmp	d6,d5
	blt	d5_pg2h
	move	d6,d5
d5_pg2h	
	cmp	d7,d5
	blt	d5_pg3h
	move	d7,d5
d5_pg3h	subq	#1,d5
	move	d5,ymin
	
;	LEA	TAB,A5
	LEA	_PTSIN,A6
	MOVE.L	(A5)+,(A6)+
	MOVE.L	(A5)+,(A6)+
	MOVE.L	(A5)+,(A6)+
	MOVE.L	(A5)+,(A6)+
	LEA	-4*4(A5),A5
	MOVE.L	(A5)+,(A6)+
	
	MOVE	ymin,D3
LOOP1	MOVE	D3,Y1(A0)
	MOVE.L	A0,-(SP)
;	DC	POLYGON
	cmp	#0,d3
	blt.s	sautX
	cmp	#100,d3
	bge.s	sautX
	JSR	LINE_A_POLYGON
sautX
	MOVE.L	(SP)+,A0
	ADDQ	#1,D3
	CMP	ymax,D3
	BNE	LOOP1

	RTS
ymin	ds	1
ymax	ds	1
LINE_A_INIT
	LEA	EMUL_LINEA,A0
;	LEA	$299A,A0
	MOVE.L	A0,D0
;	LEA	$FCA002,A1
;	LEA	$FC9FC2,A2
	RTS
FILL1
LINE_A_POLYGON
	MOVEM.L	D3-D7/A3-A5,-(SP)
	JSR	_FCA0D6
	MOVEM.L	(SP)+,D3-D7/A3-A5
	RTS

_FCA0D6	;MOVEA.L	$299E,A0
	;MOVE.W	2(A0),D0
	;SUBQ.W	#1,D0
	MOVEQ	#3,D0      NB DE POINTS-1
	
;	MOVEA.L	$29A6,A0
	LEA	_PTSIN,A0
	
;	LEA	$16DA,A1
	LEA	BUF16DA,A1
;	CLR.W	$261E
	CLR.W	PNT_261E
	
LFCA0F4	MOVE.W	6(A0),D1
	MOVE.W	2(A0),D2
	SUB.W	D2,D1
	BEQ.S	LFCA13E
	MOVE.W	EMUL_LINEA-$299A+$29C2,D3
;	MOVE.W	$29C2,D3
	MOVE.W	D3,D4
	SUB.W	D2,D4
	SUB.W	6(A0),D3
	MOVE.W	D4,D2
	EOR.W	D3,D2
	BPL.S	LFCA13E
	MOVE.W	4(A0),D2
	SUB.W	0(A0),D2
	ADD.W	D2,D2
	MULS.W	D2,D4
	DIVS.W	D1,D4
	BPL.S	LFCA12E
	NEG.W	D4
	ADDQ.W	#1,D4
	ASR.W	#1,D4
	NEG.W	D4
	BRA.S	LFCA132
LFCA12E	ADDQ.W	#1,D4
	ASR.W	#1,D4
LFCA132	ADD.W	0(A0),D4
	MOVE.W	D4,(A1)+
;	ADDQ.W	#1,$261E
	ADDQ.W	#1,PNT_261E
	
LFCA13E	LEA	4(A0),A0
	DBF	D0,LFCA0F4
;	MOVE.W	$261E,D0
	MOVE.W	PNT_261E,D0
	BNE.S	LFCA150
	RTS
LFCA150	
	;LEA	$16DA,A0
	LEA	BUF16DA,A0
	BSR	LFCA1DC
;	MOVE.W	$261E,D0
	MOVE.W	PNT_261E,D0
	ASR.W	#1,D0
	SUBQ.W	#1,D0
	TST.W	EMUL_LINEA+$29D0-$299A
	BNE.S	LFCA18A
LFCA16C	
	MOVE.W	(A1)+,EMUL_LINEA+$29C0-$299A
	MOVE.W	(A1)+,EMUL_LINEA+$29C4-$299A
;	MOVE.W	(A1)+,$29C0
;	MOVE.W	(A1)+,$29C4
	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR	_FCA5F6
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
	DBF	D0,LFCA16C
	RTS
LFCA18A	
	MOVE.W	(A1)+,EMUL_LINEA+$29C0-$299A
	MOVE.W	(A1)+,EMUL_LINEA+$29C4-$299A
;	MOVE.W	(A1)+,$29C0
;	MOVE.W	(A1)+,$29C4

	MOVE	EMUL_LINEA+$29D2-$299A,D1
	MOVE	EMUL_LINEA+$29C0-$299A,D2
	MOVE	EMUL_LINEA+$29C4-$299A,D3
;	MOVE.W	$29D2,D1
;	MOVE.W	$29C0,D2
;	MOVE.W	$29C4,D3
	CMP.W	D1,D2
	BGE.S	LFCA1B6
	CMP.W	D1,D3
	BLT.S	LFCA1D6
;	MOVE.W	D1,$29C0
	MOVE.W	D1,EMUL_LINEA+$29C0-$299A
LFCA1B6	
	MOVE.W	EMUL_LINEA+$29D6-$299A,D1
;	MOVE.W	$29D6,D1
	CMP.W	D1,D3
	BLE.S	LFCA1CA
	CMP.W	D1,D2
	BGT.S	LFCA1D6
;	MOVE.W	D1,$29C4
	MOVE.W	D1,EMUL_LINEA+$29C4-$299A
LFCA1CA	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR	_FCA5F6
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
LFCA1D6	DBF	D0,LFCA18A
	RTS
LFCA1DC	SUBQ.W	#2,D0
	BCS.S	LFCA1FC
	MOVE.W	D0,D1
	MOVEA.L	A0,A1
LFCA1E4	MOVE.W	D1,D0
	MOVEA.L	A1,A0
LFCA1E8	MOVE.W	(A0)+,D2
	CMP.W	(A0),D2
	BLE.S	LFCA1F4
	MOVE.W	(A0),-2(A0)
	MOVE.W	D2,(A0)
LFCA1F4	DBF	D0,LFCA1E8
	DBF	D1,LFCA1E4
LFCA1FC	RTS
	MOVEQ	#1,D1
	MOVE.W	6(A7),D0
	MULS.W	4(A7),D0
	BGE.S	LFCA20C
	NEG.W	D1
LFCA20C	MOVE.W	8(A7),D2
	DIVS.W	D2,D0
	TST.W	D2
	BGE.S	LFCA21A
	NEG.W	D1
	NEG.W	D2
LFCA21A	MOVE.L	D3,-(A7)
	MOVE.L	D0,D3
	BGE.S	LFCA222
	NEG.L	D3
LFCA222	SWAP	D3
	ADD.W	D3,D3
	CMP.W	D2,D3
	BLT.S	LFCA22C
	ADD.W	D1,D0
LFCA22C	MOVE.L	(A7)+,D3
	RTS
	MOVE.W	D2,-(A7)
	MOVE.W	D3,-(A7)
;	MULS.W	$2998,D1
	MULS.W	#160,D1

	MOVE.W	EMUL_LINEA,D3
	MOVE.B	_FCA259(PC,D3.W),D3
	MOVE.W	D0,D2
	EXT.L	D2
	AND.W	#$FFF0,D2
	ASR.W	D3,D2
	ADD.L	D2,D1
	AND.W	#$F,D0
	MOVE.W	(A7)+,D3
	MOVE.W	(A7)+,D2
	RTS
_FCA259	DC.L	$03020001
	DC.L	$00000000

_FCA5D4	DC	$FFFF
_FCA5D6	DC.L	$7FFF3FFF
	DC.L	$1FFF0FFF
	DC.L	$07FF03FF
	DC.L	$01FF00FF
	DC.L	$007F003F
	DC.L	$001F000F
	DC.L	$00070003
	DC.L	$00010000
_FCA5F6
	LEA	EMUL_LINEA,A4
	MOVEM.W	$26(A4),D4-D6
	MOVE.W	D5,D0
	AND.W	$32(A4),D0
	ADD.W	D0,D0
	MOVEA.L	$2E(A4),A0
	ADDA.W	D0,A0
	TST.W	$34(A4)
	SNE	D0
	AND.W	#$20,D0
	MOVE.W	D4,D1
	ASR.W	#4,D1
	MOVE.W	D6,D2
	ASR.W	#4,D2
	MOVEQ	#$F,D3
	AND.W	D3,D4
	ADD.W	D4,D4
	MOVE.W	_FCA5D4(PC,D4.W),D4
	AND.W	D3,D6
	ADD.W	D6,D6
	MOVE.W	_FCA5D6(PC,D6.W),D6
	NOT.W	D6
	SUB.W	D1,D2
	BNE.S	LFCA63C
	AND.W	D6,D4
LFCA63C	MOVEA.L	$9A(A4),A5
;TEST	JMP	(A5)
;	JMP	LFD1B58
	
LFD1B58
	MOVEA.L	SCREEN1,A1
;	MULS.W	-2(A4),D5
	MULS.W	#160,D5
	
	ADDA.L	D5,A1
	MOVEA.W	D0,A2
;	MOVE.W	0(A4),D7

	MOVE.W	#4,D7
	
	MOVE.W	D7,D0
	ADD.W	D0,D0
	MULS.W	D0,D1
	ADDA.L	D1,A1
	SUBQ.W	#1,D7
	LEA	$18(A4),A3
	MOVE.W	$24(A4),D1
	ADD.W	D1,D1
TST	LEA	_FD1B86(PC,D1.W),A5
	ADDA.W	(A5),A5
;	JMP	(A5)
	JMP	LFD1C52
	
_FD1B86	DC.L	$00CC0130
	DC.L	$009C014A
	DC.L	$4E56FFEC

LFD1C52

	NOT.W	D4
	NOT.W	D6
LFD1C56	MOVEA.L	A1,A4
	MOVE.W	D2,D5
	MOVE.W	(A0),D3
	ADDA.W	A2,A0
	TST.W	(A3)+
	BNE.S	LFD1C88
	MOVE.W	D4,D1
	AND.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1C7E
	SUBQ.W	#1,D5
	BCS.S	LFD1C78
	CLR.W	D1
LFD1C70	ADDA.W	D0,A4
	MOVE.W	D1,(A4)
	DBF	D5,LFD1C70
LFD1C78	MOVE.W	D6,D1
	ADDA.W	D0,A4
	AND.W	D1,(A4)
LFD1C7E	DBF	D7,LFD1C56
	NOT.W	D4
	NOT.W	D6
	RTS
LFD1C88	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D4,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1CAE
	SUBQ.W	#1,D5
	BCS.S	LFD1CA2
LFD1C9A	ADDA.W	D0,A4
	MOVE.W	D3,(A4)
	DBF	D5,LFD1C9A
LFD1CA2	ADDA.W	D0,A4
	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D6,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A4)
LFD1CAE	DBF	D7,LFD1C56
	NOT.W	D4
	NOT.W	D6
	RTS

	
DRAW_A_LINE
	cmp.w	d1,d3
	beq	DRAW_HORIZONTAL
	cmp.w	d0,d2
	beq	DRAW_VERTICAL

	move.w	d0,d5
	move.w	d1,d6
	ext.l	d5
	ext.l	d6
	lsl.w	#1,d6
	lea	SCREEN_Y_TABLE,a0
	move.l	#0,a1
	move.w	(a0,d6),a1
	movea.l	SCREEN1,a0
	add.l	a1,a0
	and.l	#$fffffff0,d5
	lsr.w	#1,d5
	add.l	d5,a0
	move.w	d0,d5
	eor.w	#$0f,d5
	and.w	#$0f,d5
	clr.w	d6
	bset	d5,d6
	move.w	d6,d7
	not.w	d6

	sub.w	d0,d2
	sub.w	d1,d3

	move.l	#0,a1
	move.l	#0,a2
	move.l	#0,a3
	move.l	#0,a4
	
	tst.w	d2
	bpl.s	.dr_1
	beq.s	.dr_2
	move.w	#-1,a1
	neg.w	d2
	bra.s	.dr_2
.dr_1
	move.w	#1,a1
.dr_2
	tst.w	d3
	bpl.s	.dr_3
	beq.s	.dr_4
	move.w	#-1,a2
	neg.w	d3
	bra.s	.dr_4
.dr_3
	move.w	#1,a2
.dr_4
	cmp.w	d2,d3
	blt.s	.dr_5
	move.w	a2,a4
	exg	d2,d3
	bra.s	.dr_6
.dr_5
	move.w	a1,a3
.dr_6 
	move.w	d2,d0
	lsr.w	#1,d0
	move.w	d2,d1
.dr_7
	or.w	d7,(a0)
	add.w	d3,d0
	cmp.w	d0,d2
	bgt.s	.dr_8
	sub.w	d2,d0
	cmp.w	#0,a1
	beq.s	.dr_A5
	bmi.s	.dr_A6
	ror.w	#1,d6
	ror.w	#1,d7
	bcc.s	.dr_A5
	addq.l	#8,a0
	bra.s	.dr_A5
.dr_A6
	rol.w	#1,d6
	rol.w	#1,d7
	bcc.s	.dr_A5
	subq.l	#8,a0
.dr_A5
	cmp.w	#0,a2
	beq.s	.dr_A3
	bmi.s	.dr_A8
	lea	160(a0),a0
	bra.s	.dr_A3
.dr_A8
	lea	-160(a0),a0
	bra.s	.dr_A3
.dr_8
	cmp.w	#0,a3
	beq.s	.dr_A1
	bmi.s	.dr_A2
	ror.w	#1,d6
	ror.w	#1,d7
	bcc.s	.dr_A3
	addq.l	#8,a0
	bra.s	.dr_A3
.dr_A2
	rol.w	#1,d6
	rol.w	#1,d7
	bcc.s	.dr_A3
	subq.l	#8,a0
	bra.s	.dr_A3
.dr_A1
	cmp.w	#0,a4
	bmi.s	.dr_A4
	lea	160(a0),a0
	bra.s	.dr_A3
.dr_A4
	lea	-160(a0),a0
.dr_A3
	dbf	d1,.dr_7
	rts

DRAW_HORIZONTAL
	cmp.w	d0,d2
	bne.s	.dr_h_1
	rts
.dr_h_1
	bgt.s