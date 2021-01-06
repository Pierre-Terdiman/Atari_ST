
Lib_StopSound:
	lea		$ffff8800.w,a1
	moveq	#0,d1
	moveq	#0,d2
	moveq	#16-1,d7
.Next
	move.b	d1,(a1)
	move.b	d2,2(a1)
	addq	#1,d1
	dbf		d7,.Next
	rts
