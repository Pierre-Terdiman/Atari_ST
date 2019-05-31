	lea	img+34,a0
	lea	buf,a1
	move	#3999,d0
cop	move	(a0),(a1)+
	addq	#8,a0
	dbf	d0,cop
fini	nop
img	incbin	msg.pi1
	bss
buf	ds.b	8000