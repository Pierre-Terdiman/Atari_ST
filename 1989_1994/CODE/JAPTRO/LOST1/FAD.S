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

	MOVE.L	$44E.W,A0
	MOVE	#7999,D0
OUTY2	CLR.L	(A0)+
	DBF	D0,OUTY2

	LEA	MSG,A0
	MOVE.L	$44E.W,A1
	MOVE	#200-1,D0
AFY2	MOVE	#20-1,D1
AFX2	MOVE	(A0)+,(A1)
	ADDQ	#8,A1
	DBF	D1,AFX2
	DBF	D0,AFY2

	MOVE.L	#VBL,$70.W
B	BRA.S	B

fini	move.l	4.w,a0
	jmp	(a0)

VBL

	LEA	FAD_END,A6
MODFDEND	EQU	*+2
	LEA	0(A6),A6
	CMPI	#-1,(A6)
	BEQ.S	.OUT
	SUBQ	#1,BAZOUNGA
	BNE.S	.OUT
	MOVE	#5,BAZOUNGA
	ADDQ	#2,MODFDEND
	MOVE	(A6),$FFFF8242.W
.OUT	RTE

BAZOUNGA	DC	5
FAD_END	DC	$777,$667,$556,$445,$334,$223,$112,$000,-1

MSG	INCBIN	MSG1.DAT