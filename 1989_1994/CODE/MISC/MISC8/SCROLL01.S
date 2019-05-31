; 04/02/90  Scroll Paradox vu sur Amiga.
;
	pea 0
	move #$20,-(sp)
	trap #1
	addq #6,sp
	move.l d0,sssp

	bsr demo_init
	bsr demo
	bsr demo_end

	move.l sssp,-(sp)
	move #$20,-(sp)
	trap #1
	addq #6,sp

	clr -(sp)
	trap #1
	
demo_init:		*******************
	move #$2300,sr
	move #2,-(sp)
	trap #14
	addq #2,sp
	move.l d0,ecran_gem
*	add.l #75*160,d0
*	move.l d0,ad_ecran

	move #4,-(sp)
	trap #14
	addq #2,sp
	move d0,res_save

	move #0,-(sp)		; BASSE RESOLUTION
	moveq #-1,d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp

	move #40000,d0
res_lp:	nop
	nop
	dbra d0,res_lp

	move #$2700,sr
	move.l $70.w,vbl_save

	movem.l $ffff8240.w,d0-d7
	movem.l d0-d7,pal_save
	movem.l palette,d0-d7
	movem.l d0-d7,$ffff8240.w

	lea $fffffa07.w,a0
	movep.w (a0),d0
	move d0,mfp_save
	moveq #0,d0
*	movep.w d0,(a0)

	move.l usp,a6
	move.l a6,uusp

	rts

demo_end:		*******************
e:
	move #$2700,sr
	move.l uusp,a6
	move.l a6,usp
	movem.l pal_save,d0-d7
	movem.l d0-d7,$ffff8240.w
	move.l vbl_save,$70.w
	lea $fffffa07.w,a0
	move mfp_save,d0
	movep.w d0,(a0)
	move #$2300,sr

	move res_save,-(sp)
	move.l ecran_gem,d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp

	move.l sssp,-(sp)
	move #$20,-(sp)
	trap #1
	addq #6,sp

	clr -(sp)
	trap #1
	rts

it_vbl:			*******************
	move.l a0,-(sp)
	move #1,vbl_sync
	move.l palette_pt,a0
	move.l (a0)+,$ffff8240.w
	move.l (a0)+,$ffff8244.w
	move.l (a0)+,$ffff8248.w
	move.l (a0)+,$ffff824c.w
	move.l (a0)+,$ffff8250.w
	move.l (a0)+,$ffff8254.w
	move.l (a0)+,$ffff8258.w
	move.l (a0)+,$ffff825c.w
	move.l (sp)+,a0
	rte

demo:			*******************   --> sr=$2700
	move.l ecran_gem,ad_ecran

	dc.w $a000
	move.l a0,lineA_tab
	move #1,clip(a0)	;clipping activ‚ (inutile d'ailleurs)
	move #0,xmn_c(a0)
	move #319,xmx_c(a0)
	move #0,ymn_c(a0)
	move #199,ymx_c(a0)
	move.l #pattern,patt(a0)
	move #0,pmsk(a0)
	move #0,wrt_mod(a0)
	move #-1,bp1(a0)
	move #0,bp2(a0)
	move #0,bp3(a0)
	move #0,bp4(a0)
	move.l contrl(a0),a1
	move #4,2(a1)		;nb d'angles ds contrl(1)
	move.l ptsin(a0),PtsFill
	move #-1,ln_msk(a0)	;pour LINE
	move #-1,lstlin(a0)

	move.l #it_vbl,$70.w
	move #$2300,sr
	
	bsr text_convert
	
	lea text_buffer_end,a0
	lea text,a1
	lea font,a2
	moveq #0,d0
	move d0,d1
	move #30-1,d7		;30*5=150
text_lp:
	move.b (a1)+,d0
	move.b 3(a2,d0.w),-(a0)
	move.b 2(a2,d0.w),-(a0)
	move.b 1(a2,d0.w),-(a0)
	move.b 0(a2,d0.w),-(a0)
	move.b d1,-(a0)
	dbra d7,text_lp
	move.l a1,text_pt

	move.l #data_ads,ad_data_pt
	lea compteurs,a3
*	move #-3,4(a3)		;compteur des formes
	
	bsr decrunch
	bsr construction
	
	lea ad_routines,a0
	move.l 16(a0),a2		;routine d'effa‡age
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	move #-4,(a3)		;images
	move #-20,2(a3)		;compteur pour le scroll du buffer de texte 
demo_lp:
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4
	move.l text_buff_pt,a5
	move.l ad_ecran,a6
	btst #0,1(a3)
	beq.s pal2
	move.l #palette1,palette_pt
	bra.s pal_fin
pal2:
	move.l #palette2,palette_pt
	addq #2,a6
pal_fin:
*	move #$0,$ffff8240.w
	bsr vsync
*	move #$3,$ffff8240.w
	jsr (a2)
	move.l (a0)+,a1
	move #$4,$ffff8240.w
	jsr (a1)
	add #1,(a3)
	bne.s demo_lp
	move #-4,(a3)
	lea ad_routines,a0
	sub.l d1,text_buff_pt
	
	add #1,2(a3)
	bne.s demo_lp
	
	move #-20,2(a3)
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	movem.l 70(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,90(a5)
	movem.l 30(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,50(a5)
	movem.l -10(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,10(a5)
	movem.w -20(a5),d0-d4
	movem.w d0-d4,(a5)
	
	move.l text_pt,a1
	lea font,a6
	moveq #0,d0
	move d0,d1
	move #4-1,d7		;4*5=20
text_lp2:
	move.b (a1)+,d0
	cmp #255,d0
	bne.s forme_change_pas
	
	
	add.l #4,ad_data_pt
	cmp.b #255,(a1)
	bne.s forme_suivante
	lea text,a1
	move.l #data_ads,ad_data_pt
forme_suivante:
	bsr construction
	move.b (a1)+,d0
	lea ad_routines,a0
	move.l 16(a0),a2		;routine d'effa‡age
	
forme_change_pas:
	move.b 3(a6,d0.w),-(a5)
	move.b 2(a6,d0.w),-(a5)
	move.b 1(a6,d0.w),-(a5)
	move.b 0(a6,d0.w),-(a5)
	move.b d1,-(a5)
	dbra d7,text_lp2
	move.l a1,text_pt
	bra demo_lp
	
	rts
	
text_convert:
	lea text,a0
	moveq #-1,d1
convert_lp:
	moveq #0,d0
	move.b (a0),d0
	cmp.b d1,d0
	bne convert_suite
	cmp.b #255,1(a0)
	beq convert_fin
	addq #1,a0
	bra.s convert_lp
convert_suite:
	cmp.b #$20,d0
	blo.s int2_conv
	cmp.b #$21,d0
	bhi.s int2_conv
	sub #$20,d0
	bra next_octet
int2_conv:
	cmp.b #$41,d0
	blo.s int3_conv
	cmp.b #$5a,d0
	bhi.s int3_conv
	sub #$3f,d0
	bra next_octet
int3_conv:
	cmp.b #$30,d0
	blo.s int4_conv
	cmp.b #$39,d0
	bhi.s int4_conv
	sub #$14,d0
	bra next_octet
int4_conv:
	cmp.b #$27,d0
	blo.s int5_conv
	cmp.b #$29,d0
	bhi.s int5_conv
	add #$2,d0
	bra next_octet
int5_conv:
	cmp.b #$2e,d0
	bne.s int6_conv
	sub #$8,d0
	bra next_octet
int6_conv:
	cmp.b #$3a,d0
	bne.s int7_conv
	sub #$13,d0
	bra next_octet
int7_conv:
	cmp.b #$2c,d0
	bne.s int8_conv
	sub #$4,d0
next_octet:
	lsl #2,d0
	move.b d0,(a0)+
	bra convert_lp
convert_fin:
	rts
int8_conv:
	illegal

vsync:
	move #0,vbl_sync
sync_wait:
	tst vbl_sync
	beq.s sync_wait
*	move #0,vbl_sync
	cmp.b #$39,$fffffc02.w
	beq.s sort_demo
	rts
sort_demo:
	addq #4,sp
	rts 

scroll_init:
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4
	move.l ad_ecran,a6
	rts

construction:
	movem.l a0-a6/d1/d7,-(sp)
	
	lea off_bolean,a6		;effa‡age des bits
	move #125-1,d7			;500 octets
	moveq #0,d6
off_bol_lp:
	move.l d6,(a6)+
	dbra d7,off_bol_lp

	move.l #ad_routines,routs_pt
	move.l PtsFill,a3		;tableau ptsin
	move.l a3,usp
	move.l ad_data_pt,a4
	move.l (a4),a4			;coord des points
	move.l lineA_tab,a6
	lea routines,a5

	move #4-1,d7		;4 pas
pas_lp:
	move d7,-(sp)
	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #128-1,d7		;128 colonnes
col_lp:

	move #$1e1d,(a5)+		;move.b (a5)+,d7
	move #5-1,d6		;5 lignes
ligne_lp:

	move.b d6,d5		;pour obtenir code du btst
	add.b d5,d5
	addq.b #1,d5
	move.b d5,(a5)+
	move.b #7,(a5)+			;btst.l d4/3/2/1/0,d7
	move.l a5,-(sp)
	move #$6700,(a5)+		;beq.s (offset … d‚finir)

	move.l (a4),(a3)+	;l,c
	move.l 4(a4),(a3)+	;l+1,c
	move.l 4+24(a4),(a3)+	;l+1,c+1
	move.l 24(a4),(a3)+	;l,c+1
	move.l (a4),(a3)	;l,c
	move.l usp,a3
	addq #4,a4

	move #+30000,d4		;ymin
	move #-30000,d5		;ymax
	move 2(a3),d3		;recherche de ymin et ymax
	cmp d3,d4
	ble.s pas_inf1
	move d3,d4
pas_inf1:
	cmp d3,d5
	bge.s pas_sup1
	move d3,d5
pas_sup1:
	move 6(a3),d3
	cmp d3,d4
	ble.s pas_inf2
	move d3,d4
pas_inf2:
	cmp d3,d5
	bge.s pas_sup2
	move d3,d5
pas_sup2: 
	move 10(a3),d3
	cmp d3,d4
	ble.s pas_inf3
	move d3,d4
pas_inf3:
	cmp d3,d5
	bge.s pas_sup3
	move d3,d5
pas_sup3:	
	move 14(a3),d3
	cmp d3,d4
	ble.s pas_inf4
	move d3,d4
pas_inf4:
	cmp d3,d5
	bge.s pas_sup4
	move d3,d5
pas_sup4:
	sub d4,d5		;ymax-ymin
	move d5,d3		;sauve le compteur en y

	move d4,y1(a6)		;affichage du polygone avec $a006
aff_lp:	dc.w $a006
	add #1,y1(a6)
	dbra d5,aff_lp

	REPT 4			;affichage des 4 lignes afin d'obtenir
	move.l (a3)+,x1(a6)	; la meme forme qu'avec polyfill.
	move.l (a3),x2(a6)
	dc.w $a003
	ENDR
	move.l usp,a3

	move #+30000,d0		;xmin
	move #-30000,d1		;xmax
	move (a3),d2		;recherche de xmin et xmax
	cmp d2,d0
	ble.s xpas_inf1
	move d2,d0
xpas_inf1:
	cmp d2,d1
	bge.s xpas_sup1
	move d2,d1
xpas_sup1:
	move 4(a3),d2
	cmp d2,d0
	ble.s xpas_inf2
	move d2,d0
xpas_inf2:
	cmp d2,d1
	bge.s xpas_sup2
	move d2,d1
xpas_sup2: 
	move 8(a3),d2
	cmp d2,d0
	ble.s xpas_inf3
	move d2,d0
xpas_inf3:
	cmp d2,d1
	bge.s xpas_sup3
	move d2,d1
xpas_sup3:	
	move 12(a3),d2
	cmp d2,d0
	ble.s xpas_inf4
	move d2,d0
xpas_inf4:
	cmp d2,d1
	bge.s xpas_sup4
	move d2,d1
xpas_sup4:
	lsr #4,d0		;on obtient le num‚ro du groupe de 16 pixels
	lsr #4,d1
	sub d0,d1		;compteur
	lsl #3,d0		;*8 => offset en x
	muls #160,d4		;ymin*160 => offset en y
	add d4,d0		;offset / ad ‚cran en .w

	move.l ad_ecran,a0

	move d6,-(sp)
	move d7,-(sp)
	move.l a6,-(sp)
	lea off_bolean,a6
scan_y:				;rep‚rage du polygone
	move d0,d4		;sauvegarde des compteurs
	move d1,d2
scan_x:
	move (a0,d4.w),d5
	beq.s or_nul
	clr (a0,d4.w)		;effa‡age
	move #$006e,(a5)+		;or #$uuuu,vv(a6)
	move d5,(a5)+		;$uuuu
	move d4,(a5)+		;vv=d16
	move d4,d6		;note l'offset pour l'effa‡age (tjs >=0)
	lsr #3,d6
	move d6,d7
	and #$0007,d6
	lsr #3,d7
	bset.b d6,(a6,d7.w)
or_nul:
	addq #8,d4		;groupe suivant
	dbra d2,scan_x
	add #160,d0		;ligne suivante
	dbra d3,scan_y
	move.l (sp)+,a6
	move (sp)+,d7
	move (sp)+,d6

	move.l a5,d0		;on peut calculer l'offset pour beq.s
	move.l (sp)+,a1
	sub.l a1,d0
	subq #2,d0
	cmp #127,d0		;ok pour beq.S ?
	blo.s offset_short
	move #$6700,(a1)+		;beq.l
	move.l a5,a0
	move d0,d1
	addq #2,d0
	lsr #1,d1
off_l_lp:
	move -(a0),2(a0)
	dbra d1,off_l_lp
	move d0,(a1)+
	addq #2,a5
	bra.s off_l_fin
offset_short:
	move.b d0,1(a1)			;offset pour le beq.s
off_l_fin:

	cmp.l #routines+330000,a5
	blo.s mem_ok
	illegal
mem_ok:

	dbra d6,ligne_lp
	addq #4,a4

	dbra d7,col_lp
	add #24,a4

	move (sp)+,d7
	move #$4e75,(a5)+		;rts
	dbra d7,pas_lp

	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #$7e00,(a5)+		;moveq #0,d7
	lea off_bolean,a0	;routine d'effa‡age: les bits concernent
	moveq #0,d5		; les mots du premier plan,dans l'ordre;
	move #500-1,d7		; bit=1 effacer plan 1 de ce groupe de 16 
off_oct_lp:			; pixels, ne rien faire sinon.
	move.b (a0)+,d5
	moveq #8-1,d6
off_bit_lp:
	btst d6,d5
	beq.s bit_nul_off
	move #$3d47,(a5)+		;move d7,xx(a6)
	move #499,d4
	sub d7,d4
	lsl #3,d4
	add d6,d4
	lsl #3,d4
	move d4,(a5)+			;offset
	
	cmp.l #routines+330000,a5
	blo.s mem_ok2
	illegal
mem_ok2:

bit_nul_off:
	dbra d6,off_bit_lp
	dbra d7,off_oct_lp
	
	move #$4e75,(a5)+		;rts

	movem.l (sp)+,a0-a6/d1/d7
	rts

decrunch:
	rts

gg:	addq #2,sp
	rts
palette2:	dc.w $0,$600,$0,$600,$70,$70,$70,$70
		dc.w $70,$70,$70,$70,$70,$70,$70,$7
palette1:	dc.w $0,$0,$600,$600,$70,$70,$70,$70
		dc.w $70,$70,$70,$70,$70,$70,$70,$7
		
pattern:	dc.w $ffff

f01:		incbin \ps_pier1.dat
f02:		incbin \ps_pier2.dat
f03:		incbin \ps_pier2.dat
		
data_ads:	dc.l f01
		dc.l f02
		dc.l f03
				

text:		;
	dc.b "                           CA MARCHE !!!!!!!   APRES PAS MAL D'ESSAIS CE SUPER SCROLL  "
	dc.b "FONCTIONNE PARFAITEMENT ET EN PLUS IL PEUT CHANGER DE FORME.........                                 "
	dc.b 255,"                       C'EST DEJA PLUS COMPLEXE... ET CE N'EST PAS FINI...                         "
	dc.b 255,"                       DAN NATO (ME) HOPES THAT THIS SCREEN WILL BE BETTER THAN THE PARADOX ONE OR THE ONE MADE BY THE HAMBUGGERS. THAT SHOULDN'T BE TOO DIFFICULT ...                           "
	dc.b 255,255
	
	even
font:	
	dc.b %00000,%00000,%00000,%00000	;' '
	dc.b %00000,%11101,%11101,%00000	;!
	dc.b %01111,%10100,%10100,%01111	;a
	dc.b %01010,%10101,%10101,%11111	;b
	dc.b %10001,%10001,%10001,%11111	;c
	dc.b %01110,%10001,%10001,%11111	;d
	dc.b %10001,%10101,%10101,%11111	;e
	dc.b %10000,%10100,%10100,%11111	;f
	dc.b %10110,%10101,%10001,%01110	;g
	dc.b %11111,%00100,%00100,%11111	;h
	dc.b %00000,%10001,%11111,%10001	;i
	dc.b %00000,%10000,%11111,%10001	;j
	dc.b %11011,%00100,%00100,%11111	;k
	dc.b %00001,%00001,%00001,%11111	;l
	dc.b %11111,%01000,%01000,%11111	;m
	dc.b %01111,%10000,%10000,%11111	;n
	dc.b %11111,%10001,%10001,%11111	;o
	dc.b %01000,%10100,%10100,%11111	;p
	dc.b %11111,%10011,%10001,%11111	;q
	dc.b %11101,%10110,%10100,%11111	;r
	dc.b %10010,%10101,%10101,%01001	;s
	dc.b %00000,%10000,%11111,%10000	;t
	dc.b %11111,%00001,%00001,%11111	;u
	dc.b %11110,%00001,%00001,%11110	;v
	dc.b %11111,%00010,%00010,%11111	;w
	dc.b %11011,%00100,%00100,%11011	;x
	dc.b %00000,%11100,%00111,%11100	;y
	dc.b %10001,%11001,%10101,%10011	;z
	dc.b %01110,%10001,%10001,%01110	;0
	dc.b %00000,%00001,%11111,%01001	;1
	dc.b %01001,%10101,%10011,%00001	;2
	dc.b %01010,%10101,%10101,%10001	;3
	dc.b %00010,%11111,%01010,%00110	;4
	dc.b %10010,%10101,%10101,%11101	;5
	dc.b %00010,%10101,%10101,%01110	;6
	dc.b %11000,%10100,%10010,%10001	;7
	dc.b %01010,%10101,%10101,%01010	;8
	dc.b %01110,%10101,%10101,%01001	;9
	dc.b %00000,%00011,%00011,%00000	;.
	dc.b %00000,%01001,%00000,%00000	;:
	dc.b %00000,%00010,%00001,%00000	;,
	dc.b %00000,%00000,%11000,%00000	;'
	dc.b %00000,%10001,%01110,%00000	;(
	dc.b %00000,%01110,%10001,%00000	;)

*equivalence:
*	dc.b " !ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:,'()"

ptsin	equ 12		;.l
contrl	equ 4		;.l
x1	equ 38		;.w
y1	equ 40
x2	equ 42
y2	equ 44
bp1	equ 24		;.w
bp2	equ 26
bp3	equ 28
bp4	equ 30
wrt_mod	equ 36		;.w
patt	equ 46		;.l
pmsk	equ 50		;.w
clip	equ 54		;.w
xmn_c	equ 56		;.w
xmx_c	equ 60
ymn_c	equ 58
ymx_c	equ 62
ln_msk	equ 34		;.w
lstlin	equ 32		;.w


	bss
sssp:		ds.l 1
uusp:		ds.l 1
ad_ecran:	ds.l 1
ecran_gem:	ds.l 1
vbl_save:	ds.l 1
vbl_sync:	ds.w 1
pal_save:	ds.w 16
res_save:	ds.w 1
mfp_save:	ds.w 1

lineA_tab:	ds.l 1
PtsFill:	ds.l 1
routs_pt:	ds.l 1
text_pt:	ds.l 1
text_buff_pt:	ds.l 1
palette_pt:	ds.l 1
ad_data_pt:	ds.l 1

palette:	ds.w 16
compteurs:	ds.w 2
ad_routines:	ds.l 5
text_buffer:	ds.b 150
text_buffer_deb	equ text_buffer+20
text_buffer_end:ds.l 1
off_bolean:	ds.b 500
routines:	ds.b 335010



