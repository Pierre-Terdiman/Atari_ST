
SwitchToSuper	MACRO
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,SavedSP
	ENDM

BackToUser	MACRO
SavedSP = *+2
	move.l	#0,-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	ENDM

ShowCpuTime	MACRO
	cmpi.b	#$f,$fffffc02.w
 	bne.s	.\1
	move.w	#\2,$FFFF8240.W
.\1
	ENDM
