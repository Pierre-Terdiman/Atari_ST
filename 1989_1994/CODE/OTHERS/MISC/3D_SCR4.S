;	output	demo.prg
******************************
* Distor-Scroll              *
* Skyrace from HMD           *
* Hemoroids creativity @1990 *
******************************
* Registre utilisable
* a1,a2
cpu	macro
	cmp.b	#$0f,$fffffc02.w
	bne.s	.\@
	move.w	#\1,$ffff8240.w
.\@
	endm
fuck	equ	35
	opt	o+
	clr.l	-(sp)
	move.w	#$20,-(a7)
	trap	#1
	addq	#6,a7
	clr.w	-(sp)
	pea	-1.w
	pea	-1.w
	move.w	#$5,-(a7)
	trap	#14
	lea	12(a7),a7
	pea	palim
	move.w	#6,-(a7)
	trap	#14	
	addq	#2,a7
	move.b	#$12,$fffffc02.w
	lea	pal+$300,a1
	moveq	#1,d3
sal	move.w	#30500,d6
ahi	clr.l	(a1)+
	dbra	d6,ahi
	dbra	d3,sal
*	clr.b	$fffffa09.w
*	clr.b	$fffffa07.w
	move.l	#pal+$300,color1
	move.l	#pal+$4300+$500,color2
	move.l	#pal+$8100,color3
	move.l	#pal+$c000+$1000,color4
	bclr	#5,$fffffa09.w
	moveq	#1,d0
	jsr	medusa
	move.l	#medusa+$8,$4d6.w
	movem.l	d0-d7/a0-a6,-(sp)
	lea	but,a3
	lea	pal+$300,a4
	move.w	#190,d3
as	move.b	(a3)+,(a4)+
	dbra	d3,as
	lea	but,a3
	lea	pal+$4300+$500,a4
	move.w	#190,d3
as2	move.b	(a3)+,(a4)+
	dbra	d3,as2
	lea	but,a3
	lea	pal+$8100,a4
	move.w	#190,d3
as3	move.b	(a3)+,(a4)+
	dbra	d3,as3
	lea	but,a3
	lea	pal+$c000+$1000,a4
	move.w	#190,d3
as4	move.b	(a3)+,(a4)+
	dbra	d3,as4
	lea	pal+$300+190-14,a4
	lea	pal+$4300+$500+190-14,a2
	lea	pal+$8100+190-14,a5
	lea	pal+$c000+$1000+190-14,a6
	lea	text,a1
	move.w	#25,d6
coolno	clr.w	d3
	move.b	(a1)+,d3
	cmp.w	#"A",d3
	beq	a
	cmp.w	#"B",d3
	beq	b
	cmp.w	#"C",d3
	beq	c
	cmp.w	#"D",d3
	beq	d
	cmp.w	#"E",d3
	beq	e
	cmp.w	#"F",d3
	beq	f
	cmp.w	#"G",d3
	beq	g
	cmp.w	#"H",d3
	beq	h
	cmp.w	#"I",d3
	beq	i
	cmp.w	#"J",d3
	beq	j
	cmp.w	#"K",d3
	beq	k
	cmp.w	#"L",d3
	beq	l
	cmp.w	#"M",d3
	beq	m
	cmp.w	#"N",d3
	beq	n
	cmp.w	#"O",d3
	beq	o
	cmp.w	#"P",d3
	beq	p
	cmp.w	#"Q",d3
	beq	q
	cmp.w	#"R",d3
	beq	r
	cmp.w	#"S",d3
	beq	s
	cmp.w	#"T",d3
	beq	t
	cmp.w	#"U",d3
	beq	u
	cmp.w	#"V",d3
	beq	v
	cmp.w	#"W",d3
	beq	w
	cmp.w	#"X",d3
	beq	x
	cmp.w	#"Y",d3
	beq	y
	cmp.w	#"Z",d3
	beq	z
	cmp.w	#" ",d3
	beq	spacor
	cmp.w	#"—",d3
	beq	DR
	dbra	d6,coolno
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	$44e.w,a2
	move.w	#7999,d0
effpic	clr.l	(a2)+
	dbra	d0,effpic
	bsr	save
	move.l	#vbl,$4d2.w
	move.l	#led,$4d2+$8.w
	bsr	set	
	move.l	#image,a1
	move.l	$44e.w,a2
	lea	160*17(a2),a2
	move.l	#(23360/4)-4,d0
affpic	move.l	(a1)+,(a2)+
	dbra	d0,affpic
        lea 	textor,a6
	lea	texman,a4
	lea	table,a0

go:  	
	move.w	#300-20,d5
stef
	bsr	scroll2
	bsr	let
	CPU	$700
	bsr	afr
	bsr	scroll
	bsr	lettre
	bsr	afr2
	bsr	vs

	bsr	scroll2
	bsr	let2
	CPU	$700
	bsr	afr
	bsr	scroll
	bsr	lettre2
	bsr	afr2
	bsr	vs

	bsr	scroll2
	bsr	let
	CPU	$700
	bsr	afr
	bsr	scroll
	bsr	lettre3
	bsr	afr2
	bsr	vs

	bsr	scroll2
	bsr	let2
	CPU	$700
	bsr	afr
	bsr	scroll
	bsr	lettre4
	bsr	afr2
	bsr	vs
	
	cmp.b	#$3b,$fffffc02.w
	bne.s	jam	
	bsr	mus1
jam
	cmp.b	#$3c,$fffffc02.w
	bne.s	jam2
	bsr	mus2
jam2
	cmp.b	#$3d,$fffffc02.w
	bne.s	jam3
	bsr	mus3
jam3
	cmp.b	#$3e,$fffffc02.w
	bne.s	jam4
	bsr	mus4
jam4
	cmp.b	#$3f,$fffffc02.w
	bne.s	jam5
	bsr	mus5
jam5
	cmp.b	#$40,$fffffc02.w
	bne.s	jam6
	bsr	mus6
jam6
	cmp.b	#$41,$fffffc02.w
	bne.s	jam7
	bsr	mus7
jam7
	cmp.b	#$42,$fffffc02.w
	bne.s	jam8
	bsr	mus8
jam8
	cmp.b	#$43,$fffffc02.w
	bne.s	jam9
	bsr	mus9
jam9
	cmp.b	#$44,$fffffc02.w
	bne.s	jam10
	bsr	mus10
jam10
	cmp.b	#$02,$fffffc02.w
	bne.s	jam11
	bsr	mus11
jam11
	cmp.b	#$03,$fffffc02.w
	bne.s	jam12
	bsr	mus12
jam12
	cmp.b	#$04,$fffffc02.w
	bne.s	jam13
	bsr	mus13
jam13
	cmp.b	#$05,$fffffc02.w
	bne.s	jam14
	bsr	mus14
jam14

	cmp.b	#$39,$fffffc02.w
	beq	end
	dbra	d5,stef
	move.l	#pal+$300,color1
	move.l	#pal+$4300+$500,color2
	move.l	#pal+$8100,color3
	move.l	#pal+$c000+$1000,color4

	bra 	go
afr	moveq	#0,d2
	move.b	(a0)+,d2
	cmp.b	#$ff,d2
	bne.s	lum
	lea	table,a0
	moveq	#0,d2
	jmp	yu2
lum
	move.l	$44e.w,a1
	mulu	#160,d2
	add.l	d2,a1
	move.l	#bufm,a2
	moveq	#24,d2
dort	rept	6
	move.l	(a2)+,(a1)+
	endr
	lea	136(a1),a1
	dbra	d2,dort
yu2	rts
afr2	moveq	#0,d2
	move.b	(a0)+,d2
	cmp.b	#$ff,d2
	bne.s	lum2
	lea	table,a0
	moveq	#0,d2
	jmp	yu
lum2
	move.l	$44e.w,a1
	lea	144(a1),a1
	mulu	#160,d2
	add.l	d2,a1
	move.l	#bufm2,a2
	moveq	#21,d2
do2	rept	4
	move.l	(a2)+,(a1)+
	endr
	lea	144(a1),a1
	dbra	d2,do2
yu	rts
vs
	CPU	$222
	movem.l	a0,sova0
	move.w	#$25,-(sp)
	trap	#14
	addq	#2,sp
	movem.l	sova0,a0
	clr	$ffff8240.w
	rts
sova0	dc.l	0
let
	moveq	#0,d2
 	move.b 	(a4)+,d2
	moveq	#0,d2
 	move.b 	(a4),d2
	cmp.b	#$ff,d2
	bne.s	oufp
	lea	texman,a4
	moveq	#0,d2
	moveq	#0,d1
	jmp	mal
oufp
	sub.w 	#32,d2
 	lsl	#8,d2
 	lea 	rest,a3
 	add.l 	d2,a3
 	move.l 	$44e.w,a5
 	lea 	153(a5),a5
xx	set	0
yy	set	0
	rept	15
	movep.l	xx(a3),d0
	movep.l	d0,yy(a5)
xx	set	xx+16
yy	set	yy+160
	endr
mal 	rts
let2
	moveq	#0,d2
 	move.b 	(a4),d2
	cmp.b	#$ff,d2
	bne.s	oufp2
	moveq	#0,d2
	lea	texman,a4
	jmp	mal2
oufp2
	sub.w 	#32,d2
 	lsl	#8,d2
 	lea 	rest,a3
 	lea	1(a3),a3
	add.l 	d2,a3
 	move.l 	$44e.w,a5
 	lea 	153(a5),a5
xx	set	0
yy	set	0
	rept	15
	movep.l	xx(a3),d0
	movep.l	d0,yy(a5)
xx	set	xx+16
yy	set	yy+160
	endr
mal2 	rts

scroll2:
	move.l 	$44e.w,a2
 	moveq	#15,d6
who2
	move.b 	1(a2),(a2)
 	move.b 	8(a2),1(a2)
 	move.b 	9(a2),8(a2)
 	move.b 	16(a2),9(a2)
 	move.b 	17(a2),16(a2)
 	move.b 	24(a2),17(a2)
 	move.b 	25(a2),24(a2)
 	move.b 	32(a2),25(a2)
 	move.b 	33(a2),32(a2)
 	move.b 	40(a2),33(a2)
 	move.b 	41(a2),40(a2)
 	move.b 	48(a2),41(a2)
 	move.b 	49(a2),48(a2)
	move.b 	56(a2),49(a2)
 	move.b 	57(a2),56(a2)
 	move.b 	64(a2),57(a2)
 	move.b 	65(a2),64(a2)
 	move.b 	72(a2),65(a2)
 	move.b 	73(a2),72(a2)
 	move.b 	80(a2),73(a2)
 	move.b 	81(a2),80(a2)
 	move.b 	88(a2),81(a2)
 	move.b 	89(a2),88(a2)
 	move.b 	96(a2),89(a2)
 	move.b 	97(a2),96(a2)
 	move.b 	104(a2),97(a2)
 	move.b 	105(a2),104(a2)
 	move.b 	112(a2),105(a2)
 	move.b 	113(a2),112(a2)
 	move.b 	120(a2),113(a2)
 	move.b 	121(a2),120(a2)
 	move.b 	128(a2),121(a2)
 	move.b 	129(a2),128(a2)
 	move.b 	136(a2),129(a2)
 	move.b 	137(a2),136(a2)
 	move.b 	144(a2),137(a2)
	move.b 	145(a2),144(a2)
	move.b 	152(a2),145(a2)
 	move.b 	153(a2),152(a2)
 	lea 	160(a2),a2
 	dbra 	d6,who2
 	rts
  


scroll:
	move.l 	$44e.w,a2
 	lea 	164*160(a2),a2
 	move.w	#fuck,d6
who
	movep.l	1(a2),d0
	movep.l	d0,0(a2)
	movep.l	8(a2),d0
	movep.l	d0,1(a2)
	movep.l	9(a2),d0
	movep.l	d0,8(a2)
	movep.l	16(a2),d0
	movep.l	d0,9(a2)
	movep.l	17(a2),d0
	movep.l	d0,16(a2)
	movep.l	24(a2),d0
	movep.l	d0,17(a2)
	movep.l	25(a2),d0
	movep.l	d0,24(a2)
	movep.l	32(a2),d0
	movep.l	d0,25(a2)
	movep.l	33(a2),d0
	movep.l	d0,32(a2)
	movep.l	40(a2),d0
	movep.l	d0,33(a2)
	movep.l	41(a2),d0
	movep.l	d0,40(a2)
	movep.l	48(a2),d0
	movep.l	d0,41(a2)
	movep.l	49(a2),d0
	movep.l	d0,48(a2)
	movep.l	56(a2),d0
	movep.l	d0,49(a2)
	movep.l	57(a2),d0
	movep.l	d0,56(a2)
	movep.l	64(a2),d0
	movep.l	d0,57(a2)
	movep.l	65(a2),d0
	movep.l	d0,64(a2)
	movep.l	72(a2),d0
	movep.l	d0,65(a2)
	movep.l	73(a2),d0
	movep.l	d0,72(a2)
 	movep.l	80(a2),d0
	movep.l	d0,73(a2)
 	movep.l	81(a2),d0
	movep.l	d0,80(a2)
 	movep.l	88(a2),d0
	movep.l	d0,81(a2)
 	movep.l	89(a2),d0
	movep.l	d0,88(a2)
 	movep.l	96(a2),d0
	movep.l	d0,89(a2)
 	movep.l	97(a2),d0
	movep.l	d0,96(a2)
 	movep.l	104(a2),d0
	movep.l	d0,97(a2)
 	movep.l	105(a2),d0
	movep.l	d0,104(a2)
 	movep.l	112(a2),d0
	movep.l	d0,105(a2)
 	movep.l	113(a2),d0
	movep.l	d0,112(a2)
 	movep.l	120(a2),d0
	movep.l	d0,113(a2)
 	movep.l	121(a2),d0
	movep.l	d0,120(a2)
 	movep.l	128(a2),d0
	movep.l	d0,121(a2)
 	movep.l	129(a2),d0
	movep.l	d0,128(a2)
 	movep.l	136(a2),d0
	movep.l	d0,129(a2)
 	movep.l	137(a2),d0
	movep.l	d0,136(a2)
 	movep.l	144(a2),d0
	movep.l	d0,137(a2)
	movep.l	145(a2),d0
	movep.l	d0,144(a2)
	movep.l	152(a2),d0
	movep.l	d0,145(a2)
 	movep.l	153(a2),d0
	movep.l	d0,152(a2)
*	movep.l	160(a2),d0
*	movep.l	d0,153(a2)
 	lea 	160(a2),a2
 	dbra 	d6,who
 	rts
  
lettre
 	moveq	#0,d2
 	move.b	(a6)+,d2
 	moveq	#0,d2
 	move.b (a6),d2
 	cmp.b	#$ff,d2
 	bne.s	nul
 	moveq	#0,d2
 	lea	textor,a6
	jmp	mal3
nul
 	cmp.b  	#" ",d2
 	bne.s 	fantom
 	moveq 	#"@",d2
fantom
 	cmp.b	#".",d2
 	bne.s	dav
 	moveq	#"[",d2
dav
 cmp.b	#":",d2
 bne.s	prof
 moveq	#"\",d2
prof
 cmp.b	#"'",d2
 bne.s	hate
 moveq	#"]",d2
hate
 cmp.b	#"!",d2
 bne.s	joy
 moveq	#"^",d2
joy
 cmp.b	#")",d2
 bne.s	chan
 moveq	#"`",d2
chan
 cmp.b	#"(",d2
 bne.s	div
 moveq	#"_",d2
div
 cmp.b	#"?",d2
 bne.s	pen2
 moveq	#"a",d2
pen2
 cmp.b	#",",d2
 bne.s	penis2
 moveq	#"b",d2
penis2

 	sub.w 	#64,d2
 	mulu 	#36*16,d2
 	lea 	res,a3
 	add.l 	d2,a3
 	move.l 	$44e.w,a5
 	lea 	160*164+153(a5),a5
 	rept 	fuck
 	move.b 	(a3),(a5)
 	move.b 	2(a3),2(a5)
 	move.b 	4(a3),4(a5)
 	move.b 	6(a3),6(a5)
 	lea 	16(a3),a3
 	lea 	160(a5),a5
 	endr
mal3 	rts
lettre2
 moveq	#0,d2
 move.b (a6),d2
 cmp.b	#$ff,d2
 bne.s	nul2
 lea	textor,a6
 moveq	#0,d2
 jmp mal4
nul2
 cmp.b  #" ",d2
 bne.s fantom2
 moveq #"@",d2
fantom2
 cmp.b	#".",d2
 bne.s	dav2
 moveq	#"[",d2
dav2
 cmp.b	#":",d2
 bne.s	prof2
 moveq	#"\",d2
prof2
 cmp.b	#"'",d2
 bne.s	hate2
 moveq	#"]",d2
hate2
 cmp.b	#"!",d2
 bne.s	joy2
 moveq	#"^",d2
joy2
 cmp.b	#")",d2
 bne.s	chan2
 moveq	#"`",d2
chan2
 cmp.b	#"(",d2
 bne.s	div2
 moveq	#"_",d2
div2
 cmp.b	#"?",d2
 bne.s	pen3
 moveq	#"a",d2
pen3
 cmp.b	#",",d2
 bne.s	penis3
 moveq	#"b",d2
penis3

 sub.w #64,d2
 mulu #36*16,d2
 lea res,a3
 add.l d2,a3
 lea	1(a3),a3
 move.l $44e.w,a5
 lea 160*164+153(a5),a5
 rept fuck
 move.b (a3),(a5)
 move.b 2(a3),2(a5)
 move.b 4(a3),4(a5)
 move.b 6(a3),6(a5)
 lea 16(a3),a3
 lea 160(a5),a5
 endr
mal4 rts
lettre3
 moveq	#0,d2
 move.b (a6),d2
 cmp.b	#$ff,d2
 bne.s	nul3
 lea	textor,a6
 moveq	#0,d2
 jmp	mal5
nul3
 cmp.b  #" ",d2
 bne.s fantom3
 moveq #"@",d2
fantom3
 cmp.b	#".",d2
 bne.s	dav3
 moveq	#"[",d2
dav3
 cmp.b	#":",d2
 bne.s	prof3
 moveq	#"\",d2
prof3
 cmp.b	#"'",d2
 bne.s	hate3
 moveq	#"]",d2
hate3
 cmp.b	#"!",d2
 bne.s	joy3
 moveq	#"^",d2
joy3
 cmp.b	#")",d2
 bne.s	chan3
 moveq	#"`",d2
chan3
 cmp.b	#"(",d2
 bne.s	div3
 moveq	#"_",d2
div3
 cmp.b	#"?",d2
 bne.s	pen4
 moveq	#"a",d2
pen4
 cmp.b	#",",d2
 bne.s	penis4
 moveq	#"b",d2
penis4

 sub.w #64,d2
 mulu #36*16,d2
 lea res,a3
 add.l d2,a3
 lea	8(a3),a3
 move.l $44e.w,a5
 lea 160*164+153(a5),a5
 rept fuck
 move.b (a3),(a5)
 move.b 2(a3),2(a5)
 move.b 4(a3),4(a5)
 move.b 6(a3),6(a5)
 lea 16(a3),a3
 lea 160(a5),a5
 endr
mal5 rts
lettre4
 moveq	#0,d2
 move.b (a6),d2
 cmp.b	#$ff,d2
 bne.s	nul4
 lea	textor,a6
 moveq	#0,d2
	jmp	mal6
nul4
 cmp.b  #" ",d2
 bne.s fantom4
 moveq #"@",d2
fantom4
 cmp.b	#".",d2
 bne.s	dav4
 moveq	#"[",d2
dav4
 cmp.b	#":",d2
 bne.s	prof4
 moveq	#"\",d2
prof4
 cmp.b	#"'",d2
 bne.s	hate4
 moveq	#"]",d2
hate4
 cmp.b	#"!",d2
 bne.s	joy4
 moveq	#"^",d2
joy4
 cmp.b	#")",d2
 bne.s	chan4
 moveq	#"`",d2
chan4
 cmp.b	#"(",d2
 bne.s	div4
 moveq	#"_",d2
div4
 cmp.b	#"?",d2
 bne.s	pen5
 moveq	#"a",d2
pen5
 cmp.b	#",",d2
 bne.s	penis5
 moveq	#"b",d2
penis5

 sub.w #64,d2
 mulu #36*16,d2
 lea res,a3
 add.l d2,a3
 lea	9(a3),a3
 move.l $44e.w,a5
 lea 160*164+153(a5),a5
 rept fuck
 move.b (a3),(a5)
 move.b 2(a3),2(a5)
 move.b 4(a3),4(a5)
 move.b 6(a3),6(a5)
 	lea 	16(a3),a3
 	lea 	160(a5),a5
 	endr
mal6	rts




mus1
	clr.l	$4d6.w
	moveq	#1,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus2
	clr.l	$4d6.w
	moveq	#2,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus3
	clr.l	$4d6.w
	moveq	#3,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus4
	clr.l	$4d6.w
	moveq	#4,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus5
	clr.l	$4d6.w
	moveq	#5,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus6
	clr.l	$4d6.w
	moveq	#6,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus7
	clr.l	$4d6.w
	moveq	#7,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus8
	clr.l	$4d6.w
	moveq	#8,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus9
	clr.l	$4d6.w
	moveq	#9,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus10
	clr.l	$4d6.w
	moveq	#10,d0
	jsr	musd
	move.l	#musd+$8,$4d6.w
	rts
mus11
	clr.l	$4d6.w
	moveq	#1,d0
	jsr	atomix
	move.l	#atomix+$8,$4d6.w
	rts
mus12
	clr.l	$4d6.w
	moveq	#1,d0
	jsr	chamber
	move.l	#chamber+$8,$4d6.w
	rts
mus13
	clr.l	$4d6.w
	moveq	#1,d0
	jsr	medusa
	move.l	#medusa+$8,$4d6.w
	rts
mus14
	clr.l	$4d6.w
	moveq	#1,d0
	jsr	medusa2
	move.l	#medusa2+$8,$4d6.w
	rts







asma	move.l	#pal+$300,color1
	move.l	#pal+$4300+$500,color2
	move.l	#pal+$8100,color3
	move.l	#pal+$c000+$1000,color4
	move.l	#vbl,$4d2
	bra	go
leD	movem.l	d0-d7/a0-a6,-(sp)
	move.b	#8,$ffff8800.w
	move.b	$ffff8800.w,$ffff8258.w
	move.b	#9,$ffff8800.w
	move.b	$ffff8800.w,$ffff825a.w
	move.b	#10,$ffff8800.w
	move.b	$ffff8800.w,$ffff825c.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

end	pea	cls	
	move.w	#9,-(sp)
	trap	#1
	addq	#6,sp
	move.w	#$777,$ffff8240.w
	move.w	#000,$ffff825e.w
	clr.l	$4d2+$8.w
	clr.l	$4d2.w
	clr.l	$4d6.w
	pea	stopm_d
	move.w	#$20,-(sp)
	trap	#14
	addq	#6,sp

	bset	#5,$fffffa09.w
	move.b	#$8,$fffffc02.w

	bsr	old

	dc.w	$a00a

	clr	-(a7)
	trap	#1
add	lea	1(a4),a4
	lea	1(a2),a2
	lea	1(a5),a5
	lea	1(a6),a6
	rts
A	lea	lettre_a,a3
	move.w	#$14,d3
asmar	move.b	(a3)+,(a4)+
	dbra	d3,asmar
	lea	lettre_a_2,a3
	move.w	#$14,d3
asmar2	move.b	(a3)+,(a2)+
	dbra	d3,asmar2
	lea	lettre_a_3,a3
	move.w	#$14,d3
asmar3	move.b	(a3)+,(a5)+
	dbra	d3,asmar3
	lea	lettre_a_4,a3
	move.w	#$14,d3
asmar4	move.b	(a3)+,(a6)+
	dbra	d3,asmar4
	bsr.s	add
	bra coolno			
B	lea	lettre_B,a3
	move.w	#$14,d3
asmarD	move.b	(a3)+,(a4)+
	dbra	d3,asmarD
	lea	lettre_B_2,a3
	move.w	#$14,d3
asmar2D	move.b	(a3)+,(a2)+
	dbra	d3,asmar2D
	lea	lettre_B_3,a3
	move.w	#$14,d3
asmar3D	move.b	(a3)+,(a5)+
	dbra	d3,asmar3D
	lea	lettre_B_4,a3
	move.w	#$14,d3
asmar4D	move.b	(a3)+,(a6)+
	dbra	d3,asmar4D
	bsr	add
	bra coolno			
C	lea	lettre_C,a3
	move.w	#$14,d3
asmarC	move.b	(a3)+,(a4)+
	dbra	d3,asmarC
	lea	lettre_c_2,a3
	move.w	#$14,d3
asmar2C	move.b	(a3)+,(a2)+
	dbra	d3,asmar2C
	lea	lettre_c_3,a3
	move.w	#$14,d3
asmar3C	move.b	(a3)+,(a5)+
	dbra	d3,asmar3C
	lea	lettre_c_4,a3
	move.w	#$14,d3
asmar4C	move.b	(a3)+,(a6)+
	dbra	d3,asmar4C
	bsr	add
	bra coolno			
d	lea	lettre_d,a3
	move.w	#$14,d3
asmad	move.b	(a3)+,(a4)+
	dbra	d3,asmad
	lea	lettre_d_2,a3
	move.w	#$14,d3
asmarcd move.b	(a3)+,(a2)+
	dbra	d3,asmarcd
	lea	lettre_d_3,a3
	move.w	#$14,d3
asmardd	move.b	(a3)+,(a5)+
	dbra	d3,asmardd
	lea	lettre_d_4,a3
	move.w	#$14,d3
asmared	move.b	(a3)+,(a6)+
	dbra	d3,asmared
	bsr	add
	bra coolno			
e	lea	lettre_e,a3
	move.w	#$14,d3
asmare	move.b	(a3)+,(a4)+
	dbra	d3,asmare
	lea	lettre_e_2,a3
	move.w	#$14,d3
asmare2 move.b	(a3)+,(a2)+
	dbra	d3,asmare2
	lea	lettre_e_3,a3
	move.w	#$14,d3
asmare3	move.b	(a3)+,(a5)+
	dbra	d3,asmare3
	lea	lettre_e_4,a3
	move.w	#$14,d3
asmare4	move.b	(a3)+,(a6)+
	dbra	d3,asmare4
	bsr	add
	bra coolno			
f	lea	lettre_f,a3
	move.w	#$14,d3
asmarf	move.b	(a3)+,(a4)+
	dbra	d3,asmarf
	lea	lettre_f_2,a3
	move.w	#$14,d3
asmarf2 move.b	(a3)+,(a2)+
	dbra	d3,asmarf2
	lea	lettre_f_3,a3
	move.w	#$14,d3
asmarf3	move.b	(a3)+,(a5)+
	dbra	d3,asmarf3
	lea	lettre_f_4,a3
	move.w	#$14,d3
asmarf4	move.b	(a3)+,(a6)+
	dbra	d3,asmarf4
	bsr	add
	bra coolno			
g	lea	lettre_g,a3
	move.w	#$14,d3
asmarg	move.b	(a3)+,(a4)+
	dbra	d3,asmarg
	lea	lettre_g_2,a3
	move.w	#$14,d3
asmarg2 move.b	(a3)+,(a2)+
	dbra	d3,asmarg2
	lea	lettre_g_3,a3
	move.w	#$14,d3
asmarg3	move.b	(a3)+,(a5)+
	dbra	d3,asmarg3
	lea	lettre_g_4,a3
	move.w	#$14,d3
asmarg4	move.b	(a3)+,(a6)+
	dbra	d3,asmarg4
	bsr	add
	bra coolno			
h	lea	lettre_h,a3
	move.w	#$14,d3
asmarh	move.b	(a3)+,(a4)+
	dbra	d3,asmarh
	lea	lettre_h_2,a3
	move.w	#$14,d3
asmarh2 move.b	(a3)+,(a2)+
	dbra	d3,asmarh2
	lea	lettre_h_3,a3
	move.w	#$14,d3
asmarh3	move.b	(a3)+,(a5)+
	dbra	d3,asmarh3
	lea	lettre_h_4,a3
	move.w	#$14,d3
asmarh4	move.b	(a3)+,(a6)+
	dbra	d3,asmarh4
	bsr	add
	bra coolno			
i	lea	lettre_i,a3
	move.w	#$14,d3
asmari	move.b	(a3)+,(a4)+
	dbra	d3,asmari
	lea	lettre_i_2,a3
	move.w	#$14,d3
asmari2 move.b	(a3)+,(a2)+
	dbra	d3,asmari2
	lea	lettre_i_3,a3
	move.w	#$14,d3
asmari3	move.b	(a3)+,(a5)+
	dbra	d3,asmari3
	lea	lettre_i_4,a3
	move.w	#$14,d3
asmari4	move.b	(a3)+,(a6)+
	dbra	d3,asmari4
	bsr	add
	bra coolno			
j	lea	lettre_j,a3
	move.w	#$14,d3
asmarj	move.b	(a3)+,(a4)+
	dbra	d3,asmarj
	lea	lettre_j_2,a3
	move.w	#$14,d3
asmarj2 move.b	(a3)+,(a2)+
	dbra	d3,asmarj2
	lea	lettre_j_3,a3
	move.w	#$14,d3
asmarj3	move.b	(a3)+,(a5)+
	dbra	d3,asmarj3
	lea	lettre_j_4,a3
	move.w	#$14,d3
asmarj4	move.b	(a3)+,(a6)+
	dbra	d3,asmarj4
	bsr	add
	bra coolno			
k	lea	lettre_k,a3
	move.w	#$14,d3
asmark	move.b	(a3)+,(a4)+
	dbra	d3,asmark
	lea	lettre_k_2,a3
	move.w	#$14,d3
asmark2 move.b	(a3)+,(a2)+
	dbra	d3,asmark2
	lea	lettre_k_3,a3
	move.w	#$14,d3
asmark3	move.b	(a3)+,(a5)+
	dbra	d3,asmark3
	lea	lettre_k_4,a3
	move.w	#$14,d3
asmark4	move.b	(a3)+,(a6)+
	dbra	d3,asmark4
	bsr	add
	bra coolno			
l	lea	lettre_l,a3
	move.w	#$14,d3
asmarl	move.b	(a3)+,(a4)+
	dbra	d3,asmarl
	lea	lettre_l_2,a3
	move.w	#$14,d3
asmarl2 move.b	(a3)+,(a2)+
	dbra	d3,asmarl2
	lea	lettre_l_3,a3
	move.w	#$14,d3
asmarl3	move.b	(a3)+,(a5)+
	dbra	d3,asmarl3
	lea	lettre_l_4,a3
	move.w	#$14,d3
asmarl4	move.b	(a3)+,(a6)+
	dbra	d3,asmarl4
	bsr	add
	bra coolno			
m	lea	lettre_m,a3
	move.w	#$14,d3
asmarm	move.b	(a3)+,(a4)+
	dbra	d3,asmarm
	lea	lettre_m_2,a3
	move.w	#$14,d3
asmarm2 move.b	(a3)+,(a2)+
	dbra	d3,asmarm2
	lea	lettre_m_3,a3
	move.w	#$14,d3
asmarm3	move.b	(a3)+,(a5)+
	dbra	d3,asmarm3
	lea	lettre_m_4,a3
	move.w	#$14,d3
asmarm4	move.b	(a3)+,(a6)+
	dbra	d3,asmarm4
	bsr	add
	bra coolno			
n	lea	lettre_n,a3
	move.w	#$14,d3
asmarn	move.b	(a3)+,(a4)+
	dbra	d3,asmarn
	lea	lettre_n_2,a3
	move.w	#$14,d3
asmarn2 move.b	(a3)+,(a2)+
	dbra	d3,asmarn2
	lea	lettre_n_3,a3
	move.w	#$14,d3
asmarn3	move.b	(a3)+,(a5)+
	dbra	d3,asmarn3
	lea	lettre_n_4,a3
	move.w	#$14,d3
asmarn4	move.b	(a3)+,(a6)+
	dbra	d3,asmarn4
	bsr	add
	bra coolno			
o	lea	lettre_o,a3
	move.w	#$14,d3
asmaro	move.b	(a3)+,(a4)+
	dbra	d3,asmaro
	lea	lettre_o_2,a3
	move.w	#$14,d3
asmaro2 move.b	(a3)+,(a2)+
	dbra	d3,asmaro2
	lea	lettre_o_3,a3
	move.w	#$14,d3
asmaro3	move.b	(a3)+,(a5)+
	dbra	d3,asmaro3
	lea	lettre_o_4,a3
	move.w	#$14,d3
asmaro4	move.b	(a3)+,(a6)+
	dbra	d3,asmaro4
	bsr	add
	bra coolno			
p	lea	lettre_p,a3
	move.w	#$14,d3
asmarp	move.b	(a3)+,(a4)+
	dbra	d3,asmarp
	lea	lettre_p_2,a3
	move.w	#$14,d3
asmarp2 move.b	(a3)+,(a2)+
	dbra	d3,asmarp2
	lea	lettre_p_3,a3
	move.w	#$14,d3
asmarp3	move.b	(a3)+,(a5)+
	dbra	d3,asmarp3
	lea	lettre_p_4,a3
	move.w	#$14,d3
asmarp4	move.b	(a3)+,(a6)+
	dbra	d3,asmarp4
	bsr	add
	bra coolno			
q	lea	lettre_q,a3
	move.w	#$14,d3
asmarq	move.b	(a3)+,(a4)+
	dbra	d3,asmarq
	lea	lettre_q_2,a3
	move.w	#$14,d3
asmarq2 move.b	(a3)+,(a2)+
	dbra	d3,asmarq2
	lea	lettre_q_3,a3
	move.w	#$14,d3
asmarq3	move.b	(a3)+,(a5)+
	dbra	d3,asmarq3
	lea	lettre_q_4,a3
	move.w	#$14,d3
asmarq4	move.b	(a3)+,(a6)+
	dbra	d3,asmarq4
	bsr	add
	bra coolno			
r	lea	lettre_r,a3
	move.w	#$14,d3
asmarr	move.b	(a3)+,(a4)+
	dbra	d3,asmarr
	lea	lettre_r_2,a3
	move.w	#$14,d3
asmarr2 move.b	(a3)+,(a2)+
	dbra	d3,asmarr2
	lea	lettre_r_3,a3
	move.w	#$14,d3
asmarr3	move.b	(a3)+,(a5)+
	dbra	d3,asmarr3
	lea	lettre_r_4,a3
	move.w	#$14,d3
asmarr4	move.b	(a3)+,(a6)+
	dbra	d3,asmarr4
	bsr	add
	bra coolno			
s	lea	lettre_s,a3
	move.w	#$14,d3
asmars	move.b	(a3)+,(a4)+
	dbra	d3,asmars
	lea	lettre_s_2,a3
	move.w	#$14,d3
asmars2 move.b	(a3)+,(a2)+
	dbra	d3,asmars2
	lea	lettre_s_3,a3
	move.w	#$14,d3
asmars3	move.b	(a3)+,(a5)+
	dbra	d3,asmars3
	lea	lettre_s_4,a3
	move.w	#$14,d3
asmars4	move.b	(a3)+,(a6)+
	dbra	d3,asmars4
	bsr	add
	bra coolno			
t	lea	lettre_t,a3
	move.w	#$14,d3
asmart	move.b	(a3)+,(a4)+
	dbra	d3,asmart
	lea	lettre_t_2,a3
	move.w	#$14,d3
asmart2 move.b	(a3)+,(a2)+
	dbra	d3,asmart2
	lea	lettre_t_3,a3
	move.w	#$14,d3
asmart3	move.b	(a3)+,(a5)+
	dbra	d3,asmart3
	lea	lettre_t_4,a3
	move.w	#$14,d3
asmart4	move.b	(a3)+,(a6)+
	dbra	d3,asmart4
	bsr	add
	bra coolno			
u	lea	lettre_u,a3
	move.w	#$14,d3
asmaru	move.b	(a3)+,(a4)+
	dbra	d3,asmaru
	lea	lettre_u_2,a3
	move.w	#$14,d3
asmaru2 move.b	(a3)+,(a2)+
	dbra	d3,asmaru2
	lea	lettre_u_3,a3
	move.w	#$14,d3
asmaru3	move.b	(a3)+,(a5)+
	dbra	d3,asmaru3
	lea	lettre_u_4,a3
	move.w	#$14,d3
asmaru4	move.b	(a3)+,(a6)+
	dbra	d3,asmaru4
	bsr	add
	bra coolno			
v	lea	lettre_v,a3
	move.w	#$14,d3
asmarv	move.b	(a3)+,(a4)+
	dbra	d3,asmarv
	lea	lettre_v_2,a3
	move.w	#$14,d3
asmarv2 move.b	(a3)+,(a2)+
	dbra	d3,asmarv2
	lea	lettre_v_3,a3
	move.w	#$14,d3
asmarv3	move.b	(a3)+,(a5)+
	dbra	d3,asmarv3
	lea	lettre_v_4,a3
	move.w	#$14,d3
asmarv4	move.b	(a3)+,(a6)+
	dbra	d3,asmarv4
	bsr	add
	bra coolno			
w	lea	lettre_w,a3
	move.w	#$14,d3
asmarw	move.b	(a3)+,(a4)+
	dbra	d3,asmarw
	lea	lettre_w_2,a3
	move.w	#$14,d3
asmarw2 move.b	(a3)+,(a2)+
	dbra	d3,asmarw2
	lea	lettre_w_3,a3
	move.w	#$14,d3
asmarw3	move.b	(a3)+,(a5)+
	dbra	d3,asmarw3
	lea	lettre_w_4,a3
	move.w	#$14,d3
asmarw4	move.b	(a3)+,(a6)+
	dbra	d3,asmarw4
	bsr	add
	bra coolno			
x	lea	lettre_x,a3
	move.w	#$14,d3
asmarx	move.b	(a3)+,(a4)+
	dbra	d3,asmarx
	lea	lettre_x_2,a3
	move.w	#$14,d3
asmarx2 move.b	(a3)+,(a2)+
	dbra	d3,asmarx2
	lea	lettre_x_3,a3
	move.w	#$14,d3
asmarx3	move.b	(a3)+,(a5)+
	dbra	d3,asmarx3
	lea	lettre_x_4,a3
	move.w	#$14,d3
asmarx4	move.b	(a3)+,(a6)+
	dbra	d3,asmarx4
	bsr	add
	bra coolno			
y	lea	lettre_y,a3
	move.w	#$14,d3
asmary	move.b	(a3)+,(a4)+
	dbra	d3,asmary
	lea	lettre_y_2,a3
	move.w	#$14,d3
asmary2 move.b	(a3)+,(a2)+
	dbra	d3,asmary2
	lea	lettre_y_3,a3
	move.w	#$14,d3
asmary3	move.b	(a3)+,(a5)+
	dbra	d3,asmary3
	lea	lettre_y_4,a3
	move.w	#$14,d3
asmary4	move.b	(a3)+,(a6)+
	dbra	d3,asmary4
	bsr	add
	bra coolno			
z	lea	lettre_z,a3
	move.w	#$14,d3
asmarz	move.b	(a3)+,(a4)+
	dbra	d3,asmarz
	lea	lettre_z_2,a3
	move.w	#$14,d3
asmarz2 move.b	(a3)+,(a2)+
	dbra	d3,asmarz2
	lea	lettre_z_3,a3
	move.w	#$14,d3
asmarz3	move.b	(a3)+,(a5)+
	dbra	d3,asmarz3
	lea	lettre_z_4,a3
	move.w	#$14,d3
asmarz4	move.b	(a3)+,(a6)+
	dbra	d3,asmarz4
	bsr	add
	bra coolno			
spacor	lea	space,a3
	move.w	#$14,d3
asmaza	move.b	(a3)+,(a4)+
	dbra	d3,asmaza
	lea	space_2,a3
	move.w	#$14,d3
asmaza2 move.b	(a3)+,(a2)+
	dbra	d3,asmaza2
	lea	space_3,a3
	move.w	#$14,d3
asmaza3	move.b	(a3)+,(a5)+
	dbra	d3,asmaza3
	lea	space_4,a3
	move.w	#$14,d3
asmaza4	move.b	(a3)+,(a6)+
	dbra	d3,asmaza4
	bsr	add
	bra coolno			
DR	lea	—,a3
	move.w	#$14,d3
—P	move.b	(a3)+,(a4)+
	dbra	d3,—P
	lea	—_2,a3
	move.w	#$14,d3
—P1 	move.b	(a3)+,(a2)+
	dbra	d3,—P1
	lea	—_3,a3
	move.w	#$14,d3
—P2	move.b	(a3)+,(a5)+
	dbra	d3,—P2
	lea	—_4,a3
	move.w	#$14,d3
—P3	move.b	(a3)+,(a6)+
	dbra	d3,—P3
	bsr	add
	bra coolno			


vbl	addq.w	#2,color1+2
	addq.w	#2,color2+2
	addq.w	#2,color3+2
	addq.w	#2,color4+2
crad	move.l	color1,newtb+2
	move.l	color2,tb2+2
	move.l	color3,newtb2+2
	move.l	color4,tb22+2
	rts



save	move.l $118,oldkey
	move.l $120,oldtb
	move.l $110,oldz
	move.l $114,oldta
	move.l #$fffa00,a0
	move.b 7(a0),mfp+7
	move.b 9(a0),mfp+9
	move.b 11(a0),mfp+11
	move.b 13(a0),mfp+13
	move.b 15(a0),mfp+15
	move.b 17(a0),mfp+17
	move.b 19(a0),mfp+19
	move.b 21(a0),mfp+21
	move.b 27(a0),mfp+27
	move.b 33(a0),mfp+33
	rts	
old
	and.b	#$fe,$fffa07
	and.b	#$df,$fffa09  
	move.l	oldkey,$118
	move.l 	oldta,$114
	move.l	oldtb,$120
	move.l  oldz,$110
	move.l	#$fffa00,a0
	move.b	mfp+7,7(a0)
	move.b	mfp+9,9(a0)
	move.b	mfp+11,11(a0)
	move.b	mfp+13,13(a0)
	move.b	mfp+15,15(a0)
	move.b	mfp+17,17(a0)
	move.b	mfp+19,19(a0)
	move.b	mfp+21,21(a0)
	move.b	mfp+27,27(a0)
	move.b	mfp+33,33(a0)
	or.b	#$01,$fffffa07.w
	or.b	#$01,$fffffa13.w
	bset	#5,$fffffa09.w
	bset	#4,$fffffa09.w
	bset	#3,$fffffa17.w		;SEI
	rts
		
set	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	and.b	#$df,$fffffa09.w
	move.l 	newta,$114.w
	move.b 	#8,$fffffa1b.w
	move.b 	#5,$fffffa21.w
	move.l	#newtb,$120.w
	move.l	#newkey,$118.w
	
	or.b	#$01,$fffffa07.w
	or.b	#$01,$fffffa13.w
	
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w		;AEI
	rts

newtb   move.w 	color1,$ffff8250.w
	addq.w 	#2,newtb+4
tb2	move.w	color2,$ffff8252.w
	addq.w	#2,tb2+4
newtb2  move.w 	color3,$ffff8254.w
	addq.w 	#2,newtb2+4
tb22	move.w	color4,$ffff8256.w
	addq.w	#2,tb22+4
	bclr 	#0,$fffffa0f.w
	rte

newta
*	bclr 	#5,$fffffa11.w
	rte
newkey  move.w 	#$2300,sr
	move.l 	oldkey,-(sp)
	rts


oldz	ds.l	1
	even
comp	ds.l	1

color1	ds.l	1
color2	ds.l	1
color3	ds.l	1
color4	ds.l	1
color5	ds.l	1
color6	ds.l	1
color21	ds.l	1
color22	ds.l	1
	






lettre_A
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_A_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_A_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_A_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_B
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_B_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_B_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_B_4
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_C
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_C_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_C_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_C_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_d
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_d_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_d_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_d_4
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
lettre_e
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_e_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_e_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_e_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_f
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_f_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_f_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_f_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_g
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_g_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_g_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_g_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_h
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_h_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_h_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_h_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_i
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_i_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_i_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_i_4
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000

lettre_j
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_j_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_j_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_j_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_k
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_k_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_k_3
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
lettre_k_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_l
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_l_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_l_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_l_4
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_m
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_m_2
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_m_3
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_m_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_n
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_n_2
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_n_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
lettre_n_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_o
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_o_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_o_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_o_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_p
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_p_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_p_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_p_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_q
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
lettre_q_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
lettre_q_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_q_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_r
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_r_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_r_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_r_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_s
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_s_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_s_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_s_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_t
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_t_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_t_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_t_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_u
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_u_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_u_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_u_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_v
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_v_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_v_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_v_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_w
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_w_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_w_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_w_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_x
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_x_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_x_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_x_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_y
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_y_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_y_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_y_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
lettre_z
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_z_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_z_3
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
lettre_z_4
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$000
space
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
space_2
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
space_3
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
space_4
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
	dc.w	$000
—
	dc.w	$000
	dc.w	$007
	dc.w	$007
	dc.w	$007
	dc.w	$007
	dc.w	$007
	dc.w	$007
	dc.w	$007
	dc.w	$007
	dc.w	$007
—_2
	dc.w	$000
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
—_3
	dc.w	$000
	dc.w	$777
	dc.w	$777

	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
	dc.w	$777
—_4
	dc.w	$000
	dc.w	$700
	dc.w	$700
	dc.w	$700
	dc.w	$700
	dc.w	$700
	dc.w	$700
	dc.w	$700
	dc.w	$700
	dc.w	$700

but	rept	200
	dc.w	$000
	endr
mfp	ds.l 	18
pile	ds.l 	1
oldtb	ds.l 	1
oldvbl  ds.l	1
oldkey  ds.l 	1
state   ds.l 	1
ratur	ds.l	1
pointeur	ds.l 	1
mod		ds.l 	1
oldta		ds.l 	1
        	even
cls	dc.b	$1b,$45,0
image	incbin	raster.bin
musd	incbin	jambala.s
chamber	incbin	chamber.mus
atomix	incbin	atomix.mus
medusa	incbin	medusa.mus
medusa2	incbin	ring.mus
palim		dc.w	$0000,$0765,$0654,$0321,$0532,$0543,$0211,$0777
		dc.w	$0000,$0000,$0000,$0000,$0540,$0340,$0040,$0700
stopm_d	dc.b	7,$FF,6,0,8,0,9,0,$A,0
	even	
text	DC.B	"              STRANGLERS IS AN ALLI"  * = 100 dans d5
	DC.B	"ANCE BETWEEN — HEMOROIDS — AND — FU"
	DC.B	"ZION  — — —                        "
	DC.B	"                                   "
	DC.B	"                                   "
textor 
	dc.b	"  HI !   THE STRANGLERS PRESENT :        COMBO RACER          THIS GAME WAS CRACKED BY DARKLIGHT FROM FUZION, THE INTRO WAS CODED BY SKYRACE FROM HEMOROIDS !!!!!    "
	DC.B	"     IT'S THE DRAGON ON THE KEYBOARD !!!     THIS IS OUR GARDEN COPY PARTY WITH:THE DRAGON, FULCRUM AND ORION FROM FUZION, SKYRACE FROM HEMOROIDS, AND SKYRACE'S FRIEND : ERENDIL          "
	DC.B	"     HERE ARE MY PERSONNAL GREETS :  EXOSLARVE , BLACK EAGLE, MORODER, RDQ, MDK ( HEU.... WHAT ABOUT THE SOUNDTRACKS ?? ), LAP ( THANX FOR YOUR MUSAX !! ), BABAR ( VERY NICE GRAPHIX )....        "
	DC.B	"    SKYRACE ON THE KEYBOARD : HELLO TO: MCODER, ARIOCH, YODA, MAD VISION, ZUUL ( HI TO FRODON AND BOSS ), RICK, ZARATHUSTRA, TEC AND FUCK TO JERRY AND SMUGGLER ( HEY LAMERS WE KNOW YOUR"
	DC.B  	" NEW PSEUDO ... WARNING !!!   LET'S GGGLOOOOUPPP  ... BYE .... "
	dc.b	$ff
	DC.B	0
palor	dc.w	$000,$765,$654,$321
	dc.w	$532,$543,$211,$777
	dc.w	$046,$672,$230,$075
	dc.w	$540,$340,$040,$070
texman	
	DC.B    " THE STRANGLERS :     -  FUZION  -     -  HEMOROIDS  -            "
	DC.B	"      THE MEMBERS OF HEMOROIDS ARE :    CKAOS ( CODER )      SKYRACE ( CODER )     GLUEV ( SWAPPER )     PARANOIDS ( SWAPPER )     SINK ( SWAPPER )     SKYHAWK ( SWAPPER )     WOODY ( ZOBER )   SAMOS ( GFA CODER )    "
	DC.B	"       THE MEMBERS OF FUZION ARE :       DARKLIGHT ( CRACKER )       THE DRAGON ( SWAPPER AND CD )       ORION ( CODER )    FULCRUM ( SWAPPER AND CD TOO !! )    SPEEDER ( CODER )  "
	DC.B    "   DOCNO ( ORIGINALS AND SWAPPER )      SQUAT ( GRAPHIX )    "
	DC.B	"      "
	DC.B	"      TRY THE KEY   F1-F10    1-4 .        "
	dc.b	"    OK, HERE IS THE GREETINGS LIST IN ALPHABETICAL ORDER : ACKERLIGHT, AENIGMATICA, ALONE, ALPHA FLIGHT, AUTOMATION, BEN DAGLISH, BERURIER NOIR, BLACK EAGLE, BUBBLE ONE, CAROLE, CELTIK, CST ( HI TO ANDROMEDA ), DAVID WHITTAKER, DELI"
	DC.B	"GHT, DMA ( JINKS ), EQUINOX ( LAP, MINUTE MAN, STEPRATE ), FALLEN ANGELS ( STARFIX, DECKARD, SPEED DEMON ), FASHION ( TIGER ), FOF, FOFT, FUTUR MINDS ( MACDOS, SKYLINE , SUNNY, BOULDOG ), IMPACT ( AXIOM, DAD ST )," "
	DC.B	"  LASERACO, LE SERGENT, LIGEA, MAD VISION, MCA, MDK ( THANX FOR THE MUSAX, METAL 68 ! ), MGG ( THOMAS CROWN, STILL WAITING FOR YOUR INTROS ), NAOS ( NICE DEMO... ), OVERLANDERS ( ALL MEMBERS !! ), "
	DC.B	"PENDRAGONS ( SILVER ), POMPEY PIRATES, PULSION, QUARTEX, SOFT TRACK'S TEAM, SPEEDER, STARFIRES, ST CONNEXION ( VANTAGE ), STRIDER, ST WAIKIKI, SYNC, TAC ( HUM..HUM.. STRIX ? ), TDK, THE BLACK CATS, THE CAREBEARS, "
	DC.B	"THE EXCEPTIONS ( WE LOVE YOUR MUSAX MAX !! ), THE LOST BOYS, THE MEDWAY BOYS, THE REPLICANTS, TRB, TSB, TSW, VICKERS, V-8 ( BLUE MAX, TEC )  ............           "
	DC.B	"    WITHOUT FORGET A MEGA SLURKKKSSMMAACKKMOUTCH TO ANNAO.... ( FROM GLUEV )     "
	DC.B	"     PERSONNAL HELLO FROM HEMOROIDS : MCODER , ZARATHUSTRA, RICK, JUJUST, SCOOTER, MR QUARANTE, ELDAR, "
	DC.B	"ATOMIX (LE MYTHOMANE D'RTEL QUI CROIT QUE TOUT CE QUE FONT LES AUTRES EST INSPIRE DE CE QU'IL FAIT MAIS N'OSE MONTRER A PERSONNE, SVP "
	DC.B    "ENVOYEZ LUI TOUS DIX CENTIMES...) AND TO FINISH MORGANEE, SUBWAY, SIX'LAB, XRAY, BLOODY , GEGE, THE CURE, AMIGA NINETY FIVE "
 	DC.B    "  LET'S WARP NOW...... BYYYYYYEE......             "
 	DC.B	$FF



rest	incbin	e.bin
	even
res 	incbin 	a.bin
	even
table	dc.b	98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124
	dc.b	123,122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98
	dc.b	$ff
bufm	incbin	sky.bin
	even
bufm2	incbin	wood.bin
	even	
pal