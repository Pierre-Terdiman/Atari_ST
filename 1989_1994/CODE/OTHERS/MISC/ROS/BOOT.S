	output	.ro
	text
	move.w 	#2,-(a7)
 	move.w 	#0,-(a7)
 	move.w 	#0,-(a7)
 	move.w 	#1,-(a7)
 	move.w 	#0,-(a7)
	clr.l	-(sp)
 	move.l	$4c6.w,-(sp)
 	move.w 	#8,-(a7)
 	trap 	#14
 	lea	20(a7),a7
	rts
	include	rostruct.s
