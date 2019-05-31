	pea	0
	move.w	#$20,-(sp)
	trap	#1
	addq	#6,sp
	clr.w	-(sp)
	pea	-1.w
	pea	-1.w
	move.w	#$5,-(sp)
	trap	#14
	lea	12(sp),sp
	move.w	#20,-(sp)
	move.w	#1,-(sp)
	move.w	#21,-(sp)
	trap	#14
	addq	#6,sp      
	move.w	#$000,$ffff825e.w
	lea	text,a6
bcl:	*moveq	#20,d1
rep:	moveq	#0,d2
	move.b	(a6)+,d2
	cmp.b	#-1,d2
	bne.s	kkk
	lea	text,a6
	jmp	kl
kkk	move.w	d2,-(sp)
	move.w	#6,-(sp)
	trap	#1
	addq.l	#4,sp
	move.w	#$25,-(sp)
	trap	#14
	addq	#2,sp
*	dbra	d1,rep
kl	cmp.b	#$39,$fffffc02.w
	bne.s	BCL
	clr.w	-(sp)
	trap	#1
text	dc.b	9," HEMOROIDS ANTI-VIRUS",9
	rept	48
	dc.b	$1b,$44
	endr
	dc.b	9,"   CODED BY SKYRACE  ",9
	rept	48
	dc.b	$1b,$44
	endr

	dc.b	$ff
	
	