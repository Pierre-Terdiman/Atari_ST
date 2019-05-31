;SCROLL -juillet 1988-
;PRESENTATION POUR BIONIC COMMANDO

		section text
		
debut		movea.l	a7,a5
		movea.l	$04(a5),a5
		move.l	$0c(a5),d0
		add.l	$14(a5),d0
		add.l	$1c(a5),d0
		addi.l	#$100,d0
		move.l	d0,-(a7)
		move.l	a5,-(a7)
	 	clr.w	-(a7)
	 	move.w	#$04a,-(a7)	; M-SHRINK
	 	trap	#$01
	 	adda.l	#$0c,a7
	 	
	 	move.w	#$04,-(a7)
	 	trap	#$0e
	 	addq.l	#$2,a7
	 	cmpi.w	#2,d0
	 	bne.s	ok
	 	
	 	pea reso(pc)
	 	move.w	#$09,-(a7)
	 	trap	#$01
	 	addq.l	#6,a7
	 	clr.l	-(a7)
	 	trap	#$01
reso		dc.b	$1b,$45,7,"Color monitor only,sorry",0
	 	
ok		pea	image+2
		move.w	#$06,-(a7)
		trap	#$0e		;couleurs … 0:‚cran noir
		addq.l	#$6,a7
		
		move.w	#$02,-(a7)
		trap	#$0e		;adresse de l'‚cran
		addq.l	#2,a7
		move.l	d0,ecran 
		
		clr.l	-(a7)
		move.w	#$020,-(a7)
		trap	#$01
		addq.l	#$6,a7
		
		move.b	#$0,$484
		
		lea	image,a4
		adda.l	#34,a4		;pointe sur image
		lea	$60000,a0	;plan couleur 0
		lea	$1f40(a0),a1	;plan 1
		lea	$1f40(a1),a2	;plan 2
		lea	$1f40(a2),a3	;plan 3
		movem.l	a0-a3,-(a7)
		move.w	#199,d0		;200 lignes … decompresser
		
tes		move.l	a0,a5
		bsr	dec
		move.l	a5,a0
		move.l	a1,a5
		bsr	dec
		move.l	a5,a1
		move.l	a2,a5
		bsr	dec
		move.l	a5,a2
		move.l	a3,a5
		bsr	dec
		move.l	a5,a3
		dbf	d0,tes
		bra.s	aff
		
dec		move.b	#0,d1
dec10		cmpi.b	#40,d1
		beq	fi
		move.b	(a4)+,d2
		cmpi.b	#0,d2
		blt	cas
		addq.b	#1,d2
dec20		move.b	(a4)+,(a5)+
		addq.b	#1,d1
		subq.b	#1,d2
		cmpi.b	#0,d2
		bgt	dec20
		bra.s	dec10
cas		neg.b	d2
		addq.b	#1,d2
		move.b	(a4)+,d3
cas1		move.b	d3,(a5)+
		addq.b	#1,d1
		subq.b	#1,d2
		cmpi.b	#0,d2
		bgt	cas1
		bra.s	dec10
fi		rts		
aff		move.l	ecran,a4
		movem.l	(a7)+,a0-a3
		move.w	#7999,d0
aff2		move.w	(a0)+,(a4)+
		move.w	(a1)+,(a4)+
		move.w	(a2)+,(a4)+
		move.w	(a3)+,(a4)+
		dbf	d0,aff2
		
routine		lea	$fffa00,a0
		lea	sauve_mfp,a1
		move.b	$07(a0),(a1)+
		move.b	$13(a0),(a1)+
		move.b	$1b(a0),(a1)+
		move.b	$21(a0),(a1)+
		move.l	$0120,(a1)+
		clr.b	$01b(a0)
		bset	#$0,$07(a0)
		bset	#$0,$13(a0)
		move.l	#timer_b,$0120
		move.l	$0118,midi_orig+2
		move.l 	#midi,$0118
		move.l	$070,vbl_orig+2
		clr.l	d0
		bsr	musique
		move.l	#vbl,$070
		move.b	#$02,$ff820a	;mode synchro
		move.w	#$025,-(a7)	;vsync
		trap	#$0e
		addq.l	#2,a7
		
key		move.w	#$07,-(a7)
		trap	#$01
		addq.l	#2,a7
		sf	infinite
		cmp.b	#$20,d0
		bne.s	ok2
		st	infinite
		
ok2		move.b	infinite,$426
		lea	texte,a0
		move.l	#(fintexte-texte),d7
		moveq	#0,d0
check		add.b	(a0)+,d0
		subq.l	#1,d7
		bne.s	check
		cmpi.b	#sum,d0
		bne.s	key

sum		equ	$d7
				
		clr.l	d0
		bsr	musique+28

orig_value	move.w	#$2700,sr
		lea	$0fffa00,a0
		lea	sauve_mfp,a1
		move.b	(a1)+,$07(a0)
		move.b	(a1)+,$13(a0)
		move.b	(a1)+,$1b(a0)
		move.b	(a1)+,$21(a0)
		move.l	(a1)+,$0120
		move.l	midi_orig+2,$0118
		move.l	vbl_orig+2,$070
		move.w	#$2000,sr
		pea	palorig
		move.w	#$06,-(a7)
		trap	#$0e
		addq.l	#6,a7
		
		lea	$60000,a0
		lea	charge,a1
		move.w	#(fincharge-charge)/4,d7
deplace		move.l	(a1)+,(a0)+
		dbf	d7,deplace
		
		move.w	#$02,-(a7)
		pea	name
		move.w	#$3d,-(a7)
		trap	#$01
		addq.l	#8,a7
		move.w	d0,handle
		tst.w	d0
		bmi	erreur
		jmp	$60000
		
charge		move.l	#$0d000,-(a7)
		move.l	#$015000,-(a7)
		move.w	handle,-(a7)
		move.w	#$03f,-(a7)
		trap	#$01
		adda.l	#$0c,a7
		move.w	handle,-(a7)
		move.w	#$3e,-(a7)
		trap	#$01
		addq.l	#4,a7
		
		tst.b	$426
		beq.s	cont2
		move.w	#$6000,$1737c	;NO TIME OUT
		move.w	#$6000,$119c4	;INFINITE LIVE
		
cont2		jmp	$0d000
fincharge		
		
midi		move.w	#$2500,sr
midi_orig	jmp	$0	

vbl		jsr	musique+14
		jmp	vbl2


vbl2		movem.l	d0-d7/a0-a1,-(a7)
		clr.b	$0fffa1b
		addq.b	#1,compteur_vbl	
		cmpi.b	#$03,compteur_vbl
		bne.s	suite1
		clr.b	compteur_vbl
		lea	palette2+2,a0
		lea	palette2,a1
		move.w	#$041,d0
		move.w	palette2,d7
boucle1		move.w	-(a1),-(a0)
		dbf	d0,boucle1
		move.w	d7,palette
suite1		move.b	#$04,$0fffa21
		move.b	#$08,$0fffa1b
		clr.w	offset_pal_col3
		bsr	scrolling
		move.w	#$0,$ff8240
		movem.l	(a7)+,d0-d7/a0-a1
vbl_orig	jmp	$0		

timer_b		movem.l	d0/a0,-(a7)
		move.w	offset_pal_col3,d0
		addq.w	#$2,offset_pal_col3
		move.w	palette(pc,d0.w),$ff8246
		cmp.w	#$082,d0
		bne.s	suite2
		clr.w	offset_pal_col3
suite2		bclr	#$0,$fffa0f
		movem.l	(a7)+,d0/a0
		rte	
		even
		dc.l	0,0,0,0,0	
palette		dc.w	$022,$033,$044,$055,$066,$077,$066,$055
		dc.w	$044,$033,$022,$002,$003,$004,$005,$006
		dc.w	$007,$006,$005,$004,$003,$002,$202,$303
		dc.w	$404,$505,$606,$707,$606,$505,$404,$303
		dc.w	$202,$200,$300,$400,$500,$600,$700,$600
		dc.w	$500,$400,$300,$200,$220,$330,$440,$550
		dc.w	$660,$770,$660,$550,$440,$330,$220,$020
		dc.w	$030,$040,$050,$060,$070,$060,$050,$040
		dc.w	$030
palette2	dc.w	$020
		dc.w	$000
		
palorig		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

ecran		ds.l	1
handle		ds.w	1
name		dc.b	"BIONIC.DAT",0

				
scrolling	movem.l	d0-d7/a0-a6,-(a7)
		cmpi.w	#$010,taille
		bne	suite3
		clr.w	taille
		movea.l	ad_message,a0
avant1		clr.l	d0
		move.b	(a0),d0
		bne	suite_scroll
		lea	texte,a0
		move.l	a0,ad_message
		bra.s	avant1
suite_scroll	addq.l	#1,ad_message
		subi.b	#$020,d0
		mulu	#$080,d0
		lea	lettre,a0
		adda.l	d0,a0
		lea	tampon,a1
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,(a1)
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,$020(a1)
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,$040(a1)
		movem.l	(a0)+,d0-d7
		movem.l	d0-d7,$060(a1)
suite3		lea	tampon,a1
		movea.l	ecran,a0
		adda.l	#$7300,a0
		move.l	#$0f,d0
avant2		move.l	#$03,d1
avant3		roxl	(a1)
		roxl	$0098(a0)
		roxl	$0090(a0)
		roxl	$0088(a0)
		roxl	$0080(a0)
		roxl	$0078(a0)
		roxl	$0070(a0)
		roxl	$0068(a0)
		roxl	$0060(a0)
		roxl	$0058(a0)
		roxl	$0050(a0)
		roxl	$0048(a0)
		roxl	$0040(a0)
		roxl	$0038(a0)
		roxl	$0030(a0)
		roxl	$0028(a0)
		roxl	$0020(a0)
		roxl	$0018(a0)
		roxl	$0010(a0)
		roxl	$0008(a0)
		roxl	(a0)
		roxl	(a1)+
		roxl	$0098(a0)
		roxl	$0090(a0)
		roxl	$0088(a0)
		roxl	$0080(a0)
		roxl	$0078(a0)
		roxl	$0070(a0)
		roxl	$0068(a0)
		roxl	$0060(a0)
		roxl	$0058(a0)
		roxl	$0050(a0)
		roxl	$0048(a0)
		roxl	$0040(a0)
		roxl	$0038(a0)
		roxl	$0030(a0)
		roxl	$0028(a0)
		roxl	$0020(a0)
		roxl	$0018(a0)
		roxl	$0010(a0)
		roxl	$0008(a0)
		roxl	(a0)
		addq.l	#2,a0
		dbf	d1,avant3
		adda.l	#$098,a0
		dbf	d0,avant2
		addq.w	#2,taille
		movem.l	(a7)+,d0-d7/a0-a6
		rts
		
erreur		trap	#$09
		trap	#$09
				
		
		even
		
sauve_mfp	ds.l	5
tampon		ds.l	$a0

infinite	dc.b	0

x		equ	5
y		equ	6

		
compteur_vbl	dc.b	0,0
offset_pal_col3 dc.w	0
taille		dc.w	$010
ad_message	dc.l	texte
texte		dc.b	"THE HOBBITS' BROTHERS (MUNSHINE - BILBOT - MADROD - BLACKBOOTS - THOR) "
		dc.b	"PROUDLY PRESENT : BIONIC COMMANDO TRAINER "
		dc.b	"- CRACKED BY THOR JULY 88 - "
		dc.b	"HI TO : B.O.S.S ,A-TEAM ,STCS ,TSUNOO ,SHOGUN ,HOFA "
		dc.b	"........................             ",0
fintexte
 
		even		
lettre		incbin	lettre.bin
		even
musique		incbin  music.bin
		even
image		incbin	degas.pc1
fin_image				
		
	