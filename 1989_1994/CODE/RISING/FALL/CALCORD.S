	LEA	calc,a4
	lea	TAB,A3
	MOVE	#1,D0
	MOVE	#319,D2

	MOVE	#0,D1
	MOVE	#201,D3

	JSR	calcord
	
	nop

calcord	
	
	moveq	#0,d4
	SUB.W	D0,D2	DELTA X
	SUB.W	D1,D3
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ASL.W	#7,D4	*128
;	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#11,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4
	
	add.w	d0,d0
	add.w	d0,d0
	sub.w	d1,d1
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts

	BSS
TAB	DS	200
TABE