;
; Example Of Module Replay
; Used Registers: d7/a5/a6
;

	opt	o+,w+

	section	text

	clr.l	-(sp)	;supervisor
	move.w	#$20,-(sp)
	trap	#1
	addq.w	#6,sp
	lea	user+2(pc),a0
	move.l	d0,(a0)


	move.w	#$2700,sr
	clr.b	$ffff8260.w	;low rez & 50hz
	move.b	#$2,$ffff820a.w

	bsr.s	sauve_int	;save all its

	lea	module,a0
	moveq	#0,d0	;0->ym2149 / 1->st replay
	moveq	#30,d1	;timer D data register value
	bsr	player	;init module
	lea	inter_vbl(pc),a0
	move.l	a0,$70.w

	move.w	#$2300,sr

test_key:	move.b	$fffffc02.w,d0
	cmpi.b	#$3b,d0	;f1->monitor
	beq.s	f1
	cmpi.b	#$3c,d0	;f2->st replay
	beq.s	f2
	cmpi.b	#$39,d0 ;space?
	bne.s	test_key	;no!
	
	bsr	player+8

	bsr.s	rstr_int	;restore saved its

exit:
user:	pea	$12345678	;user mode
	move.w	#$20,-(sp)
	trap	#1
	addq.w	#6,sp

	clr.w	-(sp)
	trap	#1

f1:	moveq	#0,d0
	moveq	#30,d1
	bsr	player+12
	bra.s	test_key

f2:	moveq	#1,d0
	moveq	#30,d1
	bsr	player+12
	bra.s	test_key

sauve_int:	move.w	sr,-(sp)	;save its
	move.w	#$2700,sr
	lea	sauve_mfp(pc),a0
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$fffffa1d.w,(a0)+
	move.b	$fffffa25.w,(a0)+
	move.l	$70.w,sauve_vbl
	move.l	$134.w,sauve_tma
	move.l	$120.w,sauve_tmb
	clr.b	$fffffa07.w
	clr.b	$fffffa09.w
	clr.b	$fffffa13.w
	clr.b	$fffffa15.w
	rte

rstr_int:	move.w	sr,-(sp)	;restore its
	move.w	#$2700,sr
	lea	sauve_mfp(pc),a0
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$fffffa1d.w
	move.b	(a0)+,$fffffa25.w
	move.l	sauve_vbl(pc),$70.w
	move.l	sauve_tma(pc),$134.w
	move.l	sauve_tmb(pc),$120.w
	rte

sauve_vbl:	ds.w	2
sauve_tma:	ds.w	2
sauve_tmb:	ds.w	2
sauve_mfp:	ds.w	4

inter_vbl:	bsr.s	player+4
	rte

;player:	incbin	a:\noisetrk\player.bin
	include	a:\noisetrk\player.s

module:	incbin	a:\modules\3.mod

	section	bss

	ds.b	640*31	; indispensable!
	even

	end