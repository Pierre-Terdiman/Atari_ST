	pea	0
	move	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	
	move	#$0000,d2
	lea	$ffff8000.w,a0
	move	(a0),d1
	move	d2,(a0)
	move	d1,(a0)
	reset
	pea	0
	trap	#1