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
connard	 	move.w	#$04,-(a7)
	 	trap	#$0e
	 	addq.l	#$2,a7
	 	cmpi.w	#2,d0
	 	bne.s	ok
	 	DC.W $A00A
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
		dc.w $a00a
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
		MOVE.W #7,-(A7)
		TRAP #1
		ADDQ.L #2,A7
		
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
		JSR MUSRUN
ecran		ds.l 1
		EVEN 
image		incbin	TRASH.pc1
fin_image				
	EVEN	
MUSRUN
 lea exut,a0
 lea argh,a1
 move.l #$60000,a2
 jsr memcopy
 move.l #shit,$8
 move.l #shit,$10
 move.l #shit,$20
 move.l #shit,$c	
 move.l $4ce,mus_int
 lea proc0,a0
 lea fin0,a1
 move.l #$6e53c,a2
 jsr memcopy
 lea proc1,a0
 lea fin1,a1
 move.l #$714d6,a2
 jsr memcopy
 lea proc2,a0
 lea fin2,a1
 move.l #$6d240,a2
 jsr memcopy
 lea music,a0
 lea finmus,a1
 move.l #$6d296,a2
 jsr memcopy
 lea findat,a0
 lea fin,a1
 move.l #$72544,a2
 jsr memcopy
 move.l #$484,a0
 and.b #$fc,(a0)
 move.l #$4ce,a0
 move.w #7,d1
 jsr $6e53c 
 move.w #0,musicon
 jsr $714d6
 jsr $6d240
 bsr routine
wait move.w #7,-(a7)
 trap #1
 addq.l #6,a7
 cmp #"1",d0
 beq stop1
 cmp #"2",d0
 beq stop2
 cmp #" ",d0
 beq exit
 bsr wait
stop1	cmp.w #0,musicon
	beq wait
	jsr stophyper
	rts
stop2	cmp #1,musicon
	beq wait
	jsr stopninja
	rts	
exit MOVE.B #0,$6D326
 move.b #0,$6d9cc
 MOVE.B #7,$484
 move.l mus_int,a0
 PEA CLEAR
 MOVE.W #9,-(A7)
 TRAP #1
 ADDQ.L #6,A7
 move.w #$2700,sr
 move.l a0,$4ce
 
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
 jsr $60000
exut 
 move.w #$20,-(a7)
 trap #1
 addq.l #6,a7
 pea rien(pc)
 pea rien(pc)
 pea fic(pc)
 clr.w -(a7)
 move.w #$4b,-(a7)
 trap #1
 add.l #14,a7
 clr -(a7)
 trap #1
 even
fic	dc.b 'tile3.iff',0
argh
memcopy	move.l (a0)+,(a2)+
	cmp.l a0,a1
	bge memcopy
	rts 
 even
stopninja move.w #1,musicon 
 MOVE.B #0,$6D326
 move.b #0,$6d9cc
 MOVE.B #7,$484
 move.l $4ce,ninja_int
 move.l mus_int,a0
 move.l a0,$4ce
 PEA clear2
 MOVE.W #9,-(A7)
 TRAP #1
 lea fic5,a0
 lea fin5,a1
 move.l #$41118,a2
copy	move.l (a0)+,(a2)+
	cmp.l a0,a1
	bge copy
	clr.l $45cea
	move.b #8,$484
	clr.b $45c84
	move.l $45ad4,$45adc
	move.b #7,d4
	move.b #$3f,d1
	andi.w #$3f,d1
	or.b $41cdb,d1
	move.b d4,$ff8800
	move.b d1,$ff8802
	add.b #1,d4
	clr.b $41ccf
	clr.b $41ccd
	move.l #$41118,-(a7)
	move.w #$f4,-(a7)
	move.w #7,-(a7)
	move.w #0,-(a7)
	move.w #$1f,-(a7)
	trap #14
	add.l #14,a7
	move.b #1,$4114a
	jsr wait
	even
fic5	incbin music.bin
fin5
 	even
stophyper clr.b $41ccf
	clr.b $41ccd
        pea clear2
 	move.w #9,-(a7)
	trap #1
	addq.l #6,a7
	jsr muson1
	rts
muson1   move.w #0,musicon
	move.l ninja_int,a0
	move.l a0,$4ce
 	jsr $714d6
 	jsr $6d240
 	jsr wait	  
CLEAR	DC.B $1B,$45,7,0
clear2	DC.B 7,0 
mus_int ds.l 1
	EVEN
rien	DS.L 0
proc0	incbin proc0.bin
fin0
 even
proc1	incbin proc1.bin
fin1
 even
proc2	incbin proc2.bin
fin2
 even
music	incbin mus.bin
finmus
 even
findat	incbin fin.bin
fin
tex	dc.b $1b,$45,'NINJA MISSION MUSIC',10,13
	DC.B 'HACKED BY HYDRA FROM CONSTELLATION',0
	even
		
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
		move.l $120,oldb
		move.l	#timer_b,$0120
		move.l $118,oldkey
		move.l	$0118,midi_orig+2
		move.l 	#midi,$0118
		move.l $70,howdy
		move.l	$070,vbl_orig+2
		clr.l	d0

		move.l	#vbl,$070
		move.b	#$02,$ff820a	;mode synchro
		move.w	#$025,-(a7)	;vsync
		trap	#$0e
		addq.l	#2,a7
		rts
midi		move.w	#$2500,sr
midi_orig	jmp	$0	

vbl		
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
suite1		move.b	#$00,$0fffa21
		move.b	#$08,$0fffa1b
		clr.w	offset_pal_col3
		bsr	scrolling
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
palette		dc.w	$022,$022,$022,$022,$033,$033,$033,$022
		dc.w	$022,$022,$022,$002,$002,$002,$002,$003
		dc.w	$003,$004,$005,$004,$003,$003,$202,$303
		dc.w	$404,$505,$606,$707,$606,$505,$404,$303
		dc.w	$202,$000,$000,$400,$700,$600,$700,$700
		dc.w	$200,$200,$200,$200,$220,$000,$000,$000
		dc.w	$000,$770,$440,$440,$440,$330,$330,$330
		dc.w	$330,$330,$330,$700,$070,$060,$050,$040
		dc.w	$030
palette2	dc.w	$020
		dc.w	$000
		
palorig		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


				
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
texte		dc.b	"        THE TRASH SECTION VERY PROUDLY PRESENTS: TECHNO CUP CRACKED BY SLAYER AND KID-CREW,THIS SHORT INTRO WAS CODED BY SLAYER.THE TRASH SECTION IS COMPOSED"
		dc.b	" BY 3 CRACKERS : SLAYER (HEY THAT'S ME!),A J CYBORG,TRAUN,3 PROGRAMMERS: --- ME --- ,--- A J C ---,--- JABBA ---,THREE SWAPPERS: --- ME --- KID CREW --- TRAUN,AND VARIOUS OCCUPATIONS (AS PUBLICITY) CREW:"
		dc.b	" HATEMAN,MOZART,MINOS,RAMSES,JABBA,KISS. OK SEE YOU SOON.THE PROTECTION WAS A VERY GOOD JOKE"
                DC.B 	" HI TO: VLAD,SPEEDY,FAB 81,THE GROUP,CONSTELLATIONS,INDIANA SOFT,D.DEX,SPECTRE (GREAT SWAPPING CREW!) ,STAR CREW,THE HOBBITS BROTHERS (DO YOU REMEMBER ME IN THE 29-10-88 COPY PARTY???),------------------ HAPPY CHRISTMAS."
                DC.B "WE'RE  NOW ON THE 27-12-88... BYE -------------------",0	
fintexte
pile		ds.l 1 
		even		
lettre		incbin	lettre.bin
		even
badres		dc.b $1B,$45,7,'SORRY BUT MY SCROLLER ONLY WORK IN LOW RES',10,13
		DC.B 10,13
		DC.B $1B,$70,'SEE YOU NEXT TIME',10,13
		DC.B $1B,$70,'		SLAYER',0
FUCK		PEA FTEX
		MOVE.W #9,-(A7)
		TRAP #1
		ADDQ.L #6,A7
		MOVE.W #7,-(A7)
		TRAP #1
		MOVE.L #$0,$FF8240
GLANDE		BRA GLANDE
FTEX		DC.B $1B,$45,'WHY CHANGING THE SCROLL TEXT?',10,13
		DC.B 'YOU SHOULD TAKE YOUR ASSEMBLER ',10,13
		DC.B 'AND MAKE YOUR OWN',10,13
		DC.B 'PROGRAMM          ***BYE***',0
howdy	ds.l 1
oldb	ds.l 1
oldkey	ds.l 1
	even
musicon	ds.w 1

ninja_int	ds.l 1
		even
shit		clr -(a7)
		trap #1
		rts
									 			