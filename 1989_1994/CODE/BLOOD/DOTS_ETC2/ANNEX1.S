	lea	img+34,a0
	lea	buf,a1
	move	#199,d7
popo	
	move	152-16(a0),(a1)+
	move	152-8(a0),(a1)+
	move	152(a0),(a1)+
	lea	160(a0),a0
	dbf	d7,popo

	lea	img+34,a0
	move	#79,d7
popo2
	move	(a0),(a1)+
	move	8(a0),(a1)+
	move	16(a0),(a1)+
	lea	160(a0),a0
	dbf	d7,popo2
	
img	incbin	try.pi1

	bss
buf	ds.w	3*(280)
end_buf	ds.l	5000
