*
* Replay ziks soundchip au format Tao
* 
* Seule BUGGIN1.MUS contient deux morceaux.
*

	and.b	#$E,$484.w		Coupe bip clavier
	moveq	#1,d0		Num‚ro morceau (normalement 1)
	jsr	Zik		Init musique

	move.l	#Zik+4,$4da.w	Appel en VBL
	clr.l	$4da.w

	lea	$ffff8800.w,a0
	move.l	#$8080000,(a0)
	move.l	#$9090000,(a0)
	move.l	#$A0A0000,(a0)


Zik	incbin	A:\TAO\BUGGIN10.MUS
