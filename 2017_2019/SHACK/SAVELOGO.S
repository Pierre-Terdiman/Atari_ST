;26 59
;115

	bra		Jump
AnalyzeTop:
	lea		Picture1P+34,a2
	move.w	#200-1,d5
	moveq	#0,d0
.NextLine		
N	set	0
	moveq	#0,d1
	REPT	20
		add.w	N(a2),d1
N	set	N+8
	ENDR
	tst.w	d1
	bne.s	.NotEmpty
	lea		160(a2),a2
	addq	#1,d0
	dbf		d5,.NextLine
.NotEmpty
	nop

AnalyzeBottom:
	lea		Picture1P+34,a2
	add.l	#32000,a2
	
	move.w	#200-1,d5
	moveq	#0,d0
.NextLine		
	lea		-160(a2),a2
N	set	0
	moveq	#0,d1
	REPT	20
		add.w	N(a2),d1
N	set	N+8
	ENDR
	tst.w	d1
	bne.s	.NotEmpty
	addq	#1,d0
	dbf		d5,.NextLine
.NotEmpty
	nop

JJump:
	lea		Picture1P+34,a2
	lea		26*160(a2),a2
	lea		Picture1P2,a3
	move.w	#115-1,d5
.NextLine		
N	set	0
	REPT	20
		move.w	N(a2),(a3)+
N	set	N+8
	ENDR
	lea		160(a2),a2
	dbf		d5,.NextLine
	nop
Jump:
