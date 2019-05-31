	lea	img+34,a0
	lea	buf,a1
	move	#30-1,d7
nb
n	set	0
	rept	20
	move	n(a0),(a1)+
n	set	n+8
	endr
	lea	160(a0),a0
	dbf	d7,nb
	nop
img	incbin	holotest.pi1

	bss
buf	ds	20*29