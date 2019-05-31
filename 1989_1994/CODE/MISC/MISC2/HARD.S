; 15/02/90
;  Hard-scroll d'aprŠs la routine de fullscreen de ST-CNX ds ST-Mag.
;  La routine est en timer D appel‚ par la VBL.
;  A noter que pour le premier ‚largissement
;  … droite la commutation est faite un nop plus tard.
;
	pea 0
	move #$20,-(sp)
	trap #1
	addq #6,sp
	move.l d0,uusp
	
	bsr demo_init
	bsr demo
	bsr demo_end
	
	move.l uusp,-(sp)
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
	add.l #75*160,d0
	move.l d0,ad_ecran
	
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
	
	move #50000,d0
res_lp:	nop
	dbra d0,res_lp
	
	move #$2700,sr
	move.l $70.w,vbl_save
	
	movem.l $ffff8240.w,d0-d7
	movem.l d0-d7,pal_save
	movem.l palette(pc),d0-d7
	movem.l d0-d7,$ffff8240.w
	
	lea $fffffa00.w,a0
	movep.w 7(a0),d0
	movep.w $13(a0),d1
	move.b $1d(a0),d2
	move.b $25(a0),d3
	lea mfp_save(pc),a1
	move d0,(a1)+
	move d1,(a1)+
	move.b d2,(a1)+
	move.b d3,(a1)+
	moveq #0,d0
	movep.l d0,7(a0)
	movep.l d0,$f(a0)
	rts
	
demo_end:		*******************
	move #$2700,sr
	movem.l pal_save,d0-d7
	movem.l d0-d7,$ffff8240.w
	move.l vbl_save,$70.w
	lea $fffffa00.w,a0
	lea mfp_save(pc),a1
	move (a1)+,d0
	move (a1)+,d1
	move.b (a1)+,d2
	move.b (a1)+,d3
	moveq #0,d4
	movep.w d0,7(a0)
	movep.l d4,$b(a0)
	movep.w d1,$13(a0)
	move.b d2,$1d(a0)
	move.b d3,$25(a0)
	move #$2300,sr
	
	move res_save,-(sp)
	move.l ecran_gem(pc),d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp
	
	rts
	
it_vbl:				*******************
	move.b #104,$fffffa25.w
	move.b #%00000100,$fffffa1d.w
	move #$222,$ffff8240.w
	move #$0,$ffff825e.w
	
	movem.l d0-d7/a0-a6,-(sp)
	lea zeros(pc),a0
	movem.l (a0)+,d0-d7
	movem.l d0-d7,$ffff8240.w

	movem.l (sp)+,d0-d7/a0-a6
	rte

c6050:	MACRO
	move.b d0,(a0)
	nop
	move.b d1,(a0)
	ENDM
c70501:	MACRO
	move.b d1,(a1)
	nop
	move.b d0,(a1)
	ENDM
c70502:	MACRO
	move.b d1,(a1)
	nop
	nop
	move.b d0,(a1)
	ENDM
np:	MACRO
	REPT \1
	nop
	ENDR
	ENDM



timer_d:
	movem.l a0/d0,-(sp)
	moveq #0,d0
	lea $ffff820a.w,a0
	move.b d0,(a0)
	move #$2700,sr
	clr.b $fffffa1d.w
	move #$700,$ffff8240.w
	movem.l a2/d1,-(sp)
	moveq #2,d1
	lea $ffff8209.w,a2
	moveq #24,d0

w_aff:	tst.b (a2)
	beq.s w_aff
	move.b d1,(a0)		;50 Hz
	sub.b $ffff8209.w,d0
	lsr.l d0,d0		;synchro.

*	move #$222,$ffff8240.w	;4 nop
	np 4
	
	movem.l a1/d4-d7,-(sp)		;12 nop
	move.l hscr_pt(pc),a1		;4 nop
	move (a1)+,d7
	move (a1)+,d6
	move (a1)+,d5
	move (a1)+,d4			;8 nop
	subq #1,d4
	subq #1,d5
	subq #1,d6
	subq #1,d7			;4 nop
	lea $ffff8260.w,a1		;2 nop
	
	cmp #13,d4		;2 nop
	bne.s h_cas_ok		;3(s)/2 nop
	move #$ff02,d1		;2 nop		
	bra.s h_cas_part_fin	;3 nop
h_cas_ok:
	np 4
h_cas_part_fin: 		;du cmp … ici:9 nop
	
	np 63-43
	c6050 		;5 nop
	tst d4			;1 nop
	bmi over_dr_		;3 nop
	np 11-4
	c70501		;5 nop
	np 11
	c70502		;6 nop
	subq #1,d4		;1 nop
	bmi.s over_droit	;3(saut),2 nop
over_tot_lp:
*	np 86
	divs d1,d0	;38 nop
	divs d1,d0	;38 nop
	tst d1			;1 nop
	bpl.s h_teste_pas	;3(s)/2 nop
	tst d4			;1 nop
	bne.s h_148_non		;3(s)/2 nop
	bra hscr_148		;3 nop
h_teste_pas:
	np 3
h_148_non:		;du tst d0 … ici:7 nop
	np 3
	
	c6050		;5 nop
	np 12
	c70501		;5 nop
	np 11
	c70502		;6 nop
	dbra d4,over_tot_lp	;3(4) nop

over_droit:
	cmp d0,d5		;1 nop
	blt over_g_lp		;3 nop
over_dr_lp:
	np 81
	c6050		;5 nop
	np 5
over_dr_:
	np 7
	c70501		;5 nop
	np 11+6
	cmp d0,d5		;1 nop
	beq over_gauche		;3 nop
	nop
	dbra d5,over_dr_lp	:3 nop (4)

over_gauche:
	cmp d0,d6		;1 nop
	blt over_n_lp		;3 nop
over_g_lp:
	np 81+5+12
	c70501		;5 nop
	np 11
	c70502		;6 nop
	cmp d0,d6		;1 nop
	beq over_non		;3 nop
	nop
	dbra d6,over_g_lp	:3 nop (4)

over_non:
	cmp d0,d7		;1 nop
	blt hscr_fin		;3 nop
over_n_lp:
	np 81
	np 5+12+5+11+6
	cmp d0,d7		;1 nop
	beq hscr_fin		;3 nop
	nop
	dbra d7,over_n_lp	:3 nop (4)

hscr_fin:

	np 76
	move #-1,td_sync
	move.l pal_pt,a0
	movem.l (a0),a1/a2/d0/d1/d4-d7
	movem.l a1/a2/d0/d1/d4-d7,$ffff8240.w
	
	movem.l (sp)+,a1/d4-d7
	movem.l (sp)+,a2/d1
	movem.l (sp)+,a0/d0
	bclr.b #4,$fffffa11.w
	rte
	
hscr_148:
	np 1
	c6050		;5 nop
	np 12
	c70501		;5 nop
	np 11
	c70502		;6 nop
	bra hscr_fin
	

vsync:
	move #1,vbl_sync
	rte



demo:			*******************
	clr.b $ffff8201.w
	clr.b $ffff8203.w

	lea ecr,a0
	move.l a0,d0
	clr.b d0
	move.l d0,a0
	move.l d0,a1
	lsr.l #8,d0
	lea $ffff8200.w,a0
	movep d0,1(a0)

	lea test(pc),a2
	REPT 51
	move.l (a2)+,(a1)+
	ENDR
*	addq #0,a1

	move #100,d7
tlp:
	lea test(pc),a2
long 	set 28
	REPT long
	move.l (a2)+,(a1)+
	move.l (a2)+,(a1)+
	ENDR
*	addq #6,a1
	dbra d7,tlp

	
	move.b #104,$fffffa25.w
	clr.b $fffffa1d.w
	bset.b #4,$fffffa09.w
	bset.b #4,$fffffa15.w
	move.b #0,$ffff820a.w
	move.b #2,$ffff8260.w
	
	move.l #palette,pal_pt
	
	move.l #vsync,$70.w
	move #0,vbl_sync
	move #$2300,sr
	
vbl_sync_w:
	tst vbl_sync
	beq.s vbl_sync_w
	
	move.l #it_vbl,$70.w
	move.l #timer_d,$110.w
	
	lea 2036.w,a6
	move #1,sens
	move.l #h_scroll,hscr_pt
	bra demo_start
	
demo_loop:
	tst sens
	bpl.s sens_pos
	sub #4*160,a6
	cmp.l #2000,a6
	bhs.s fixe_ecr_fin
	bra.s inverse_sens
sens_pos:
	add #160,a6
	cmp.l #1040000,a6
	bls.s fixe_ecr_fin
inverse_sens:
	neg sens
fixe_ecr_fin: 

	move #0,td_sync
td_lp:
	tst td_sync
	beq.s td_lp
	
demo_start:
	move.l a6,d0		;ad ‚cran
	moveq #0,d1
	move.b d0,d1
	subq #4,d1
	clr.b d0
	lsr.l #8,d0
	lea h_scroll(pc),a0
	add d1,a0
	move.l a0,hscr_pt
	lsr #2,d1
	lea h_offsets(pc),a0
	sub (a0,d1.w),d0
	lea $ffff8200.w,a0
	movep d0,1(a0)
	
	cmp.b #$39,$fffffc02.w
	bne demo_loop 
	
	move #$2700,sr
	
	rts
	
h_scroll:	
		dc.w 1,1,11,1,6,4,2,2,2,2,6,4,2,3,4,5
		dc.w 2,4,2,6,1,6,1,6,1,0,1,12,0,2,0,12
		dc.w 11,0,3,0,11,1,1,1,5,1,7,1,5,2,5,2
		dc.w 6,2,2,4,4,5,2,3,2,8,2,2,2,2,2,8
		dc.w 1,4,1,8,0,6,0,8,0,0,0,14,9,0,5,0
		dc.w 9,1,3,1,8,3,2,1,7,5,1,1,4,2,4,4
		dc.w 2,5,4,3,3,5,1,5,1,1,3,9,1,2,1,10
		dc.w 0,4,0,10,13,0,1,0,7,0,7,0,7,1,5,1
h_offsets:	
		dc.w 11,10,11,11,11,11,12,12
		dc.w 9,9,10,10,10,10,10,11
		dc.w 11,11,12,9,9,9,9,10
		dc.w 10,10,11,11,11,8,9,9
	
palette:
		dc.w $0,$7,$5,$3,$2,$10,$50,$30
		dc.w $20,$144,$133,$022,$414,$313,$202,$440
		
test:		dc.w -1,0,0,0
		dc.w 0,-1,0,0
		dc.w -1,-1,0,0
		
		
		
		
		
		
		bss
		
uusp:		ds.l 1
ad_ecran:	ds.l 1
ecran_gem:	ds.l 1
vbl_save:	ds.l 1
vbl_sync:	ds.w 1
pal_save:	ds.w 16
res_save:	ds.w 1
mfp_save:	ds.w 3
td_sync:	ds.w 1
	
ad_ecr:		ds.l 1
zeros:		ds.w 16
hscr_pt:	ds.l 1
sens:		ds.w 1
pal_pt:		ds.l 1
fill_start:	ds.b 800
ecr:		ds.b 96000
