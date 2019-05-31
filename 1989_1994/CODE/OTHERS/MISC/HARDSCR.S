	pea	0
	move.w	#$20,-(sp)		*passe en superviseur
	trap	#1
	addq	#6,sp
	
	move.w	#0,-(sp)
	move.l	#$70000,-(sp)
	move.l	#$70000,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	pea	pic+2
	move.w	#6,-(sp)
	trap	#14
	addq	#6,sp
	move.l	#$70000,a1
	
	move.l	#pic+34,a2
	move.w	#7999,d2		*affiche ecran pi1
aff:	move.l	(a2)+,(a1)+
	dbra	d2,aff
	sub.l	#160*10,a1
	move.w	#7999,d2
eff:	clr.l	(a1)+
	dbra	d2,eff
	lea	table,a2
bcl:	move.w	#3999,d2
ert	dbra	d2,ert
	move.w	#$777,$ffff8240.w
	moveq	#0,d2
	move.b	(a2)+,d2
	cmp.b	#$ff,d2
	bne.s	rt
	lea	table,a2
	moveq	#0,d2
	move.b	(a2)+,d2
rt	lsl	#8,d2
	mulu	#5,d2
	add.l	#$70000-$500*8,d2	
	move.w	#-1,-(sp)
	move.l	d2,-(sp)
	move.l	d2,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	clr.w	$ffff8240.w
go:	move.w	#$25,-(sp)
	trap	#14
	addq	#2,sp
	cmp.b	#$39,$fffffc02.w
	bne.s	bcl  
	move.w	#$777,$ffff8240.w
	move.w	#$000,$ffff8246.w
	clr.w	-(sp)
	trap	#1
pic	incbin	femme.pi1
table:	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40
	dc.b	39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,$ff