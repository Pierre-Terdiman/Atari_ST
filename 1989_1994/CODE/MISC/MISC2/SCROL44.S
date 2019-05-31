main
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	
	lea.l	8,a0
	move.l	#fin,d0
	move.l	#fin,d1
	move.l	#fin,d2
	move.l	#fin,d3
	move.l	#fin,d4
	move.l	#fin,d5
	move.l	#fin,d6
	move.l	#fin,d7
	
	clr.w	(ptdsc)
	
	movem.l	d0-d7,(a0)
	
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,colv
	
	move.l	#ecranp,d0
	addi.l	#256,d0
	andi.l	#$ffffff00,d0
	move.l	d0,ecran1
	
	move.l	#ecranp+40000,d0
	addi.l	#256,d0
	andi.l	#$ffffff00,d0
	move.l	d0,ecran2

	move.w	#0,-(sp)
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea.l	12(sp),sp

	movem.l	dess+2,d0-d7
	movem.l	d0-d7,$ffff8240.w	

	move.l	#text,ptlet
	bsr	cacsc
	move.l	posc2,posc1

	move.l	$70.w,old_vbl
	move.l	#newvbl1,$70.w

	moveq.l	#1,d0

mainloop
	cmp.b	#$39,key
	bne	mainloop	
fin
	move.w	#$0,$ffff8240.w
	move.l	old_vbl,$70.w	

	movem.l	colv,d0-d7
	movem.l	d0-d7,$ffff8240.w

	clr.w	-(sp)
	trap	#1	

*------------------------------------*

scrol:
	move.w	indad,d0
	addq.w	#1,indad
	
	cmp.w	#1,d0	
	beq.w	scrols1
	
	cmp.w	#3,d0	
	beq.w	scrols3	
	
	cmp.w	#0,d0	
	beq.b	scrols
	
	cmp.w	#2,d0	
	beq.w	scrols2	

scrols
	add.w	#32*2,ptdsc	
	lea.l	tdscr1,a0
	move.w	ptdsc,d0
	lea.l	(a0,d0.w),a0
	movea.l	posc1,a1

n	set	0	
	rept	32
	move.w	n*80(a1),n+19*32*2(a0)
	move.w	n*80(a1),n-32*2(a0)
n	set	n+2
	endr	
	
	bsr	affsvt
	
	rts
scrols1
	tst.w	vsiff
	beq.b	scrolp1
	bsr	cacsc
	clr.w	vsiff
	bra.b	scrol1
scrolp1
	move.l	posc1,posc2
	add.l	#8,posc2
	add.w	#1,vsiff
scrol1	
	lea.l	tdscr2,a0
	
	move.w	ptdsc,d0
	lea.l	(a0,d0.w),a0
	movea.l	posc1,a1
	movea.l	posc2,a2
	move.w	#12,d3	

n	set	0	
	rept	32
	move.w	n*80(a1),d0
	move.w	n*80(a2),d1
	lsr.w	d3,d1
	lsl.w	#4,d0
	or.w	d1,d0	
	move.w	d0,n+19*32*2(a0)
	move.w	d0,n-32*2(a0)
n	set	n+2
	endr	
	
	bsr	affsvt
	
	rts

scrols2
	lea.l	tdscr3,a0
	
	move.w	ptdsc,d0
	lea.l	(a0,d0.w),a0
	
	movea.l	posc1,a1
	movea.l	posc2,a2

n	set	0	
	rept	32
	move.b	n*80+1(a1),n+19*32*2(a0)
	move.b	n*80(a2),n+19*32*2+1(a0)
	move.b	n*80+1(a1),n-32*2(a0)
	move.b	n*80(a2),n-32*2+1(a0)
n	set	n+2
	endr	
	
	bsr	affsvt
	
	rts

scrols3
	clr.w	indad
	
	lea.l	tdscr4,a0
	move.w	ptdsc,d4
	lea.l	(a0,d4.w),a0
	
	movea.l	posc1,a1
	movea.l	posc2,a2
	
	move.w	#12,d3
n	set	0	
	rept	32
	move.w	n*80(a1),d0
	move.w	n*80(a2),d1
	lsr.w	#4,d1
	lsl.w	d3,d0
	or.w	d1,d0	
	move.w	d0,n+19*32*2(a0)
	move.w	d0,n-32*2(a0)
n	set	n+2
	endr	
	
	
	
	move.l	posc2,posc1
	
	cmp.w	#32*20*2,d4
	bne.b	tscrol3	
	clr.w	ptdsc
tscrol3
	bsr	affsvt
	rts


cacsc
	moveq.l	#0,d0
	move.l	(ptlet),a0
	move.b	(a0),d0
	sub.w	#32,d0
	add.w	d0,d0
	movea.l	#buffl,a0
	move.w	(a0,d0.w),d0
	
	move.l	#dess+34,d1		
	add.l	d0,d1
	move.l	d1,posc2

	addq.L	#1,(ptlet)
	movea.l	(ptlet),a0
	cmp.b	#-1,(a0)
	bne 	fcacsc
	move.l	#text,ptlet
fcacsc
	rts

affsvt

	movea.l	ecran2,a1
n	set	0
	rept	19
	movem.w	(a0)+,d0-d7
	move.w	d0,n(a1)
	move.w	d1,n+160(a1)
	move.w	d2,n+160*2(a1)
	move.w	d3,n+160*3(a1)
	move.w	d4,n+160*4(a1)
	move.w	d5,n+160*5(a1)
	move.w	d6,n+160*6(a1)
	move.w	d7,n+160*7(a1)
	movem.w	(a0)+,d0-d7
	move.w	d0,n+160*8(a1)
	move.w	d1,n+160*9(a1)
	move.w	d2,n+160*10(a1)
	move.w	d3,n+160*11(a1)
	move.w	d4,n+160*12(a1)
	move.w	d5,n+160*13(a1)
	move.w	d6,n+160*14(a1)
	move.w	d7,n+160*15(a1)
	movem.w	(a0)+,d0-d7
	move.w	d0,n+160*16(a1)
	move.w	d1,n+160*17(a1)
	move.w	d2,n+160*18(a1)
	move.w	d3,n+160*19(a1)
	move.w	d4,n+160*20(a1)
	move.w	d5,n+160*21(a1)
	move.w	d6,n+160*22(a1)
	move.w	d7,n+160*23(a1)
	movem.w	(a0)+,d0-d7
	move.w	d0,n+160*24(a1)
	move.w	d1,n+160*25(a1)
	move.w	d2,n+160*26(a1)
	move.w	d3,n+160*27(a1)
	move.w	d4,n+160*28(a1)
	move.w	d5,n+160*29(a1)
	move.w	d6,n+160*30(a1)
	move.w	d7,n+160*31(a1)

n	set	n+8
	endr
	rts

swapec
	move.l	ecran1,d0
	move.l	ecran2,d1
	move.l	d1,$44e.w
	move.b	ecran2+1,$ffff8201.w
	move.b	ecran2+2,$ffff8203.w
	move.l	d0,ecran2
	move.l	d1,ecran1
	
	rts
		
*-------------------------------------

newvbl1
	move.w	$fffffc02.w,key
	bsr	swapec
	move.w	#3000,d0
att1p
	move.l	a0,a0
	move.l	a0,a0
	move.l	a0,a0
	dbra.w	d0,att1p
	move.w	#$77,$ffff8240.w
	bsr	scrol
	move.w	#$0,$ffff8240.w
	rte

	*--------variable-------*
	section data

dess	incbin	fboislo1.pi1

text	dc.b	" ZERIOUL IS HAPPY TO PRESENT HIS FIRST SCROLL 4.4    "
	dc.b	-1

	even
buffl		
	dc.w	(33*160*2)+9*16
	dcb.w	6,0
	dc.w	(33*160*2)+8*16
	dcb.w	6,0
	dc.w	6*16+33*160*2
	dcb.w	16,0
	dc.w	7*16+33*160*2
	dc.W	8*16+33*160*2
	
n	set	0
	rept	160/(8*2)
	dc.w	n
n	set	n+16
	endr

n	set	0
	rept	160/(8*2)
	dc.w	n+33*160
n	set	n+16
	endr

n	set	0
	rept	6
	dc.w	n+33*160*2
n	set	n+16
	endr

	section bss

colv	ds.l	8
old_res	ds.w	1
old_vbl	ds.l	1
key	ds.w	1

posl	ds.l	1
ptlet	ds.l	1
posc1	ds.l	1
posc2	ds.l	1
indad	ds.w	1
ptdsc	ds.w	1
vsiff	ds.w	1
tdscr1	ds.w	32*21*2
tdscr2	ds.w	32*21*2
tdscr3	ds.w	32*21*2
tdscr4	ds.w	32*21*2

ecran1:	ds.l	1
ecran2:	ds.l	1
ecranp	ds.w	40000






