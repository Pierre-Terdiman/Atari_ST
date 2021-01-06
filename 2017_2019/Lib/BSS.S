
Lib_ClearBSS:
;	move.l	#$12345678,Sentinel0
;	move.l	#$12345678,Sentinel1
	;a0 = start of BSS
	;a1 = end of BSS
	lea		StartBSS,a0
	lea		EndBSS,a1
	moveq	#0,d1
;	move.l	#$42424242,d1
	move.l	a1,d0
	sub.l	a0,d0
	lsr.l	#2+2,d0	;for 4 bytes & 4 move.l
	beq.s	.SmallBSS
	subq.l	#1,d0
.ClearBSS4
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	dbf		d0,.ClearBSS4
.SmallBSS	
	cmp.l	a1,a0
	beq.s	.EndClearBSS
.ClearBSS
	move.b	d1,(a0)+
	cmp.l	a1,a0
	blt.s	.ClearBSS
.EndClearBSS
	rts
