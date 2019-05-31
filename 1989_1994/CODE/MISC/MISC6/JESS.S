	move.w	#$101,-(a7)
	trap	#14
	
	moveq	#6,d0
	jsr	zik
	
	move.l	#zik+8,$4da.w
	clr.l	$4da.w
	
	jsr	zik+4
	

zik	incbin	a:\jess\phaleon.mus
	dcb.b	$100,0
	even