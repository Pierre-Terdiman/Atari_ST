	MOVE.W	#1,-(SP)
	MOVE.W	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	PEA	PR_BOOT
	MOVE.W	#18,-(SP)
	TRAP	#14
	LEA	14(SP),SP

	MOVE.W	#1,-(SP)
	MOVE.W	#0,-(SP)
	MOVE.W	#0,-(SP)
	MOVE.W	#1,-(SP)
	MOVE.W	#0,-(SP)
	CLR.L	-(SP)
	PEA	PR_BOOT
	MOVE.W	#9,-(SP)
	TRAP	#14
	LEA	20(SP),SP

	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

PR_BOOT	BRA	DEBUT
	DC.B	$90,'HOLOCOST',$BF,$94
	DC.B	$9B,$00,$02,$02,$01,$00,$02,'p'
	DC.B	$00,$A0,$05,$F9,$03,$00,$09,$00
	DC.B	$02,$00,$00
DEBUT	
	move.w	#$751,$ffff825e.w
	pea	pr
	move.w	#9,-(sp)
	trap	#1
	lea	6(sp),sp

	move.b	$fffffa07.w,mfp
	move.b	$fffffa09.w,mfp+1
	move.b	$fffffa0f.w,mfp+2
	move.b	$fffffa13.w,mfp+3
	move.b	$fffffa1b.w,mfp+4
	move.b	$fffffa21.w,mfp+5

	clr.b	$fffffa07.w
	clr.b	$fffffa09.w
	move.l	$70.w,anc_vbl
	move.l	#vblr,$70.w
	move.l	$120.w,anc_tim
	move.l	#timer,$120.w
	clr.b	$fffffa1b.w
	bset	#0,$fffffa07.w
	bset	#0,$fffffa13.w

boucle	jmp	boucle	

fin	move.l	anc_vbl,$70.w
	move.l	anc_tim,$120.w
	move.b	mfp,$fffffa07.w
	move.b	mfp+1,$fffffa09.w
	move.b	mfp+2,$fffffa0f.w
	move.b	mfp+3,$fffffa13.w
	move.b	mfp+4,$fffffa1b.w
	move.b	mfp+5,$fffffa21.w
	move.w	#$777,$ffff8240.w
	;clr.w	-(sp)
	;trap	#1
	;lea	2(sp),sp
	;rts
	**************** V B L  &  P R O C E D U R E S ****************
vblr	lea	color,a0
	clr.b	$fffffa1b.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	cmpi.b	#$39,$fffffc02.w
	beq	fin
	rte

timer	move.w	(a0)+,$ffff8240.w
	clr.b	$fffffa1b.w
	move.b	#8,$fffffa21.w
	move.b	#8,$fffffa1b.w
	move.l	#timer,$120.w
	bclr	#0,$fffffa0f.w 
	rte
	
	section	data
color	dc.w	$111,$222,$333,$444,$555,$666,$777,$777,$666,$555,$444,$333	
	dc.w	$222,$333,$444,$555,$666,$777,$777,$666,$555,$444,$333,$222,$000	
pr	dc.b	"First Boot By H.O!",27,"Y",39,43,"Sorry But No Muzaxx",27,"Y",50,32,"Hi to Zappy,Xerioull,Danato,Satiry",0
	section	bss
mfp	ds.b	6
	even
anc_vbl	ds.l	1
anc_tim	ds.l	1
