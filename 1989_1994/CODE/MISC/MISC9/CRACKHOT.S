	move	#2,-(sp)
	move	#0,-(sp)
	move	#$49,-(sp)
	move	#1,-(sp)
	move	#0,-(sp)
	clr.l	-(sp)
	move.l	#tam,-(sp)
	move	#8,-(sp)
	trap	#14
	adda.l	#20,sp
	
	section	bss
tam	ds.l	(2*512)/4