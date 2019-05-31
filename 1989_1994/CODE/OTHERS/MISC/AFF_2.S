 	pea	0
 	move.w	#$20,-(sp)
 	trap	#1
 	addq	#6,sp
 	
 	moveq	#2,d0
 	jsr	musik+4
 	jsr	musik+8
 	
 	dc.w	$a00a
 	*clr.b	$ff8260
 	
 	
	
 	*pea	pic+2
 	*move.w	#6,-(sp)
 	*trap	#14
 	*addq	#6,sp
	*move.b	#6,$484.w
 	
 	clr.w	-(sp)
 	pea	-1.w
 	pea	-1.w
 	move.w	#5,-(sp)
 	trap	#14
 	lea	12(sp),sp
	*jsr	init
	move.l	#vbl,$4d2.w
bcl:	
	*lea	palette,a0
 	*lea	$ffff8240,a1
 	*moveq	#7,d4
*color	move.l	(a0)+,(a1)+
*	dbf	d4,color

	move.w	#$000,$ffff8240.w
	move.w	#$512,$ffff8242.w
	jsr	affp
	cmp.b	#$4b,$fffffc02.w	*test fleche gauche
	bne.s	add_pla
	lea	-8(a3),a3

add_pla
	cmp.b	#$4d,$fffffc02.w	*test fleche droit
	bne.s	add_pla2
	lea	8(a3),a3
add_pla2
	cmp.b	#$48,$fffffc02.w	*test fleche haut
	bne.s	add_pla3
	lea	-160(a3),a3
add_pla3
	cmp.b	#$50,$fffffc02.w	*test fleche bas
	bne.s	add_pla4
	lea	160(a3),a3
add_pla4
	clr.w	$ffff8240.w
	jsr	vs
	cmp.b	#$39,$fffffc02.w
	bne.s	bcl
	moveq	#0,d0
	jsr	musik+12
	clr.l	$4d2.w	
	move.l	#$8080000,$ffff8800.w
	move.l	#$9090000,$ffff8800.w
	move.l	#$a0a0000,$ffff8800.w
 	move.w	#$777,$ffff8240.w
 	move.w	#$000,$ffff8246.w
 	clr.w	-(sp)
 	trap	#1


affp: 	move.l	$44e.w,a1
	add.l	a3,a1
 	move.l	#pic+34,a2
x	set	0
	rept	1000	*taille se l'ecran a scroller
	move.w	x(a2),x(a1)
x	set	x+8
	endr
	rts
vs:	move.w	#$25,-(sp)
	trap	#14
	addq	#2,sp
	rts

vbl	jsr	musik
	MOVEM.L	A0/D0,-(SP)		*
flash	MOVE.B	#7,$FFFF8800.W		*
btst	BTST	#4,$FFFF8800.W		*VOIX 3,4 OU 5
	BNE.S	low			*
	MOVE.B	#14,$FFFF8800.W		*
	MOVE.B	#$40,$FFFF8802.W 	*
	BRA.S	cont			*
low	MOVE.B	#14,$FFFF8800.W		*  routine voyant
	MOVE.B	#2,$FFFF8802.W		*
cont	MOVE.L	#$70000+160*120,A0	*
	CLR.L	D0			*
	MOVE.B	#8,$FFFF8800.W		*
	MOVE.B	$FFFF8800.W,D0		*
	TST.B	D0			*
	MOVEM.L	(SP)+,A0/D0
	
	MOVE.B	#$8,$FFFF8800.W	*debut aff equaliseurs
	MOVE.B	$FFFF8800.W,V1
	MOVE.B	#$9,$FFFF8800.W
	MOVE.B	$FFFF8800.W,V2
	MOVE.B	#$A,$FFFF8800.W
	MOVE.B	$FFFF8800.W,V3
	MOVE.L	$44E.W,A0
	MOVEQ	#0,D0
	MOVE.B	V1,D0
	BSR	AFF_V
	MOVE.B	V2,D0
	BSR	AFF_V
	MOVE.B	V3,D0
	BSR	AFF_V
	
	rts	


AFF_V	AND	#15,D0
	MOVE	#20,D1
	SUB	D0,D1
	TST	D1
	BEQ.S	V15
	LSL	#1,D1
	SUBQ	#1,D1
	MOVEQ	#0,D7
BV0	MOVE	D7,0(A0)
	MOVE	D7,8(A0)
	
	LEA	160(A0),A0
	DBRA	D1,BV0
V15
	TST	D0
	BEQ.S	V0
	LSL	#1,D0
	SUBQ	#1,D0
	MOVEQ	#-1,D7
BV1	MOVE	D7,(A0)
	
	LEA	160(A0),A0
	DBRA	D0,BV1
V0	LEA	-160*2*20+8(A0),A0
	RTS



pic:	incbin	femme.pi1
musik	incbin	wings.snd 
palette	dc.w    	$000,$512,$100,$110,$210,$310,$420,$531
	dc.w	$642,$753,$764,$776,$554,$443,$332,$221

V1	DC.B 	0
V2	DC.B	0
V3	DC.B	0	