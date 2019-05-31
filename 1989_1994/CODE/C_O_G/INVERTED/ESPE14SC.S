  	*OPT	O+,W-
	section text	

main
	clr.l	-(sp)	*superviseur
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	lea.l	8,a0	*detourn int
	move.l	#fini,d0
	move.l	#fini,d1
	move.l	#fini,d2
	move.l	#fini,d3
	move.l	#fini,d4
	move.l	#fini,d5
	move.l	#fini,d6
	move.l	#fini,d7
	movem.l	d0-d7,(a0)

	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,oldcol	*sauv coull

	move.w	#$0,-(sp)	chang reso
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#$5,-(sp)
	trap	#14
	lea.l	12(sp),sp
	
	move.l	#text,ptlet	init scroll
	bsr	cacsc
	move.l	posc2,posc1

	
	move.l	#ecranp,d0	deff ecr
	addi.l	#256,d0
	andi.l	#$ffffff00,d0
	move.l	d0,ecran1
	
	move.l	#ecranp+40000,d0
	addi.l	#256,d0
	andi.l	#$ffffff00,d0
	move.l	d0,ecran2
	
	move.b	#$12,$fffffc02.w	
	move.l	$70.w,oldvbl	sauv vbl
	move.l	$fffffa06.w,stimb		
	
	move.l	#newvbl,$70.w	
	clr.b	$fffffa07.w	
	clr.b	$fffffa09.w	
	
	movem.l	dess+2,d0-d7	nouv vbl
	movem.l	d0-d7,$ffff8240.w
	moveq	#1,d0
	jsr	mus
	

mainloop			 *boucl vide
	bra.s	mainloop
	
fin
	move.l	oldvbl,$70.w	restor
	move.l	stimb,$fffffa06.w
	
	move.l	#$8000000,$ffff8800.w	nmusic
	move.l	#$9000000,$ffff8800.w
	move.l	#$a000000,$ffff8800.w
	
	move.b	#$8,$fffffc02.w	
	movem.l	oldcol,d0-d7
	movem.l	d0-d7,$ffff8240.w
	
	move.b	$44e+1.w,$ffff8201.w
	move.b	$44e+2.w,$ffff8203.w 
	clr.w	-(sp)
	trap	#1
*_______________________________________
fini
	
	*move.w	#$ff,$ffff8240.w
	bra	fin
*_______________________________________
newvbl        
	move.w	#$070,$ffff8242.w
	sf	$ffff8240.w		
	
	move.l	ecran1,d0		flip ecran
	move.l	ecran2,d1
	move.b	ecran2+1,$ffff8201.w
	move.b	ecran2+2,$ffff8203.w
	move.l	d0,ecran2
	move.l	d1,ecran1
	
	jsr	mus+4	appell music
*	jsr	scrol	       scroll
	bsr	efecr	       effecr
	move.w	$fffffc02.w,key    lclavier
	bsr	calcpoint	       calc 3d	
	bsr	tobj               affch
	bsr	calcrot	       ger touch       
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	LMLM
	st	$ffff8240.w
LMLM
	cmp.b	#$39,key
	beq	fin
	
	rte
	
	even
key	dc.b	0
	even 

	*-----sous programe------*	
calcrot
	sub.w	#1,attvbl
	beq.s	calcrots	
	bra	finacal
calcrots
	move.w	#10,attvbl
	moveq	#0,d0
	move.b	key,d0
	
	cmp.w	#7,d0
	bgt.s	finacal
	beq.s	changobj
	subq	#1,d0
	
	lea.l	adag1,a0
	moveq.l	#1,d1
	and.w	d0,d1
	bne.s	suitadcal
	
	sub.w	d1,d0
	add.w	d0,a0
	sub.w	#2,(a0)
	bra.s	finacal
suitadcal
	sub.w	d1,d0
	add.w	d0,a0
	add.w	#2,(a0)
	bra.s	finacal
changobj	
	add.w	#8,numobj
	lea.l	paobj,a0
	add.w	numobj,a0
	move.l	(a0)+,d0	
	bgt.s	schangobj	
	move.w	#-8,numobj
	bra.s	changobj
schangobj	
	move.l	d0,ptchang2+2
	addq.l	#2,d0
	move.l	d0,ptchang1+2
	move.l	(a0),ptchang3+2	
	clr.l	adag1
	clr.w	adag3
	clr.w	ang1
	clr.w	ang2
	clr.w	ang3

finacal	
	move.w	ang1,d0
	add.w	adag1,d0
	and.w	#$1ff,d0
	move.w	d0,ang1
	
	move.w	ang2,d0
	add.w	adag2,d0
	and.w	#$1ff,d0
	move.w	d0,ang2
	
	move.w	ang3,d0
	add.w	adag3,d0
	and.w	#$1ff,d0
	move.w	d0,ang3

	rts
adag1	dc.w	0
adag2	dc.w	0
adag3	dc.w	0
attvbl	dc.w	10
numobj	dc.w	0	

efecr	
	move.l	a7,gardsp
	movea.l	ecran1,a7
	lea.l	32000(a7),a7	
	
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	sub.l	a0,a0
	sub.l	a1,a1
	sub.l	a2,a2
	sub.l	a3,a3
	sub.l	a4,a4
	sub.l	a5,a5
	sub.l	a6,a6
efecr1
	rept	400
	movem.l	d0-d7/a0-a6,-(a7)
	endr
	move.l	gardsp,a7
	rts
gardsp	dc.l	0
	****************************

	******************
	*matrix 3axe(zyx)*
	******************
calcpoint	
	lea.l	tsin(pc),a0
	lea.l	128(a0),a1
ang1	equ	*+2
	move.w	#0,d0
ang2	equ	*+2
	move.w	#0,d1
ang3	equ	*+2	
	move.w	#0,d2

	move.w	(a0,d1.w),d3	-sinb
	neg	d3
	move.w	d3,modf3+2	

	move.w	d0,d3		d3=a-b
	sub.w	d1,d3		
	add.w	d0,d1		d1=a+b

	move.w	(a1,d1.w),d4	1/2(cos(a+b)+cos(a-b))
	add.w	(a1,d3.w),d4	cosacosb
	asr	d4
	move.w	d4,modf1+2		
	
	move.w	(a0,d1.w),d4	-1:2(sin(a+b)+sin((a-b))
	add.w	(a0,d3.w),d4	-sinacosb
	asr	d4
	neg	d4
	move.w	d4,modf2+2		

	sub.w	d0,d1
	move.w	d1,d3		
	sub.w	d2,d3		d3=b-c
	add.w	d1,d2		d2=b+c
	
	move.w	(a0,d2.w),d4	-1:2(sin(b+c)-sin((b-c))
	sub.w	(a0,d3.w),d4	-sinccosb
	asr	d4
	neg	d4
	move.w	d4,modf6+2		
	
	move.w	(a1,d2.w),d4	1/2(cos(b+c)+cos(b-c))
	add.w	(a1,d3.w),d4	cosbcosc
	asr	d4
	move.w	d4,modf9+2		

	sub.w	d1,d2
	move.w	d0,d3
	sub.w	d2,d3		d3=a-c
	add.w	d0,d2		d2=a+c
	
	move.w	(a0,d2.w),d4	1:2(sin(a+c)+sin(a-c))
	add.w	(a0,d3.w),d4	sinacosc
	asr	d4
	move.w	d4,addmodf1
	
	move.w	(a1,d2.w),d4	1:2(cos(a+c)+cos(a-c))
	add.w	(a1,d3.w),d4	cosacosc
	asr	d4
	move.w	d4,addmodf2
	
	move.w	(a1,d3.w),d4	1:2(cos(a-c)-cos(a+c))
	sub.w	(a1,d2.w),d4	sinasinc
	asr	d4
	move.w	d4,addmodf3
	
	move.w	(a0,d2.w),d4	1:2(sin(a+c)-sin(a-c))
	sub.w	(a0,d3.w),d4	cosasinc
	asr	d4
	move.w	d4,addmodf4

	sub.w	d0,d2
	move.w	#14,d3

	move.w	(a1,d0.w),d4	-cosasinbsinc+sinacosc
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf1	equ	*+2
	add.w	#0,d4
	move.w	d4,modf4+2
	
	move.w	(a0,d0.w),d4	sinasinbsinc+cosacosc
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
addmodf2	equ	*+2
	add.w	#0,d4
	move.w	d4,modf5+2
	
	move.w	(a1,d0.w),d4	cosasinbcosc+sinasinc
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
addmodf3	equ	*+2
	add.w	#0,d4
	move.w	d4,modf7+2
	
	move.w	(a0,d0.w),d4	-sinasinbcosc+cosasinc
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf4	equ	*+2
	add.w	#0,d4
	move.w	d4,modf8+2
	
	lea.l	t_points,a0
ptchang3	lea.l	tpoitesp1,a1
	lea.l	tz+255*2,a2

	move.w	#160,d5
	move.w	#100,d6
	
	move.w	(a1)+,d7

bmatrix
	move.w	(a1)+,a3
	move.w	(a1)+,a4
	move.w	(a1)+,d4

	move.w	a3,d0
	move.w	a4,d1
	move.w	d4,d2

modf1	muls	#1<<7,d0
modf2	muls	#0,d1
modf3	muls	#0,d2
	add.l	d1,d0
	add.l	d2,d0
	
	move.w	a3,d1
	move.w	a4,d2
	move.w	d4,d3

modf4	muls	#0,d1
modf5	muls	#1<<7,d2
modf6	muls	#0,d3
	add.l	d2,d1
	add.l	d3,d1
	
	move.w	a3,d2
	move.w	a4,d3
	
modf7	muls	#0,d2
modf8	muls	#0,d3
modf9	muls	#1<<7,d4
	add.l	d3,d2
	add.l	d4,d2
	
	asr.w	#7,d2
	add.w	d2,d2
	
	add.w	#20,d2
	
	muls	(a2,d2.w),d0
	muls	(a2,d2.w),d1
	
	swap	d0
	swap	d1
	
	add.w	d5,d0
	add.w	d6,d1
	
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	
	dbra.w	d7,bmatrix
	rts
	
	
	incbin	tsin7.aid
tsin	incbin	tsin7.aid
	incbin	tsin7.aid

tz	incbin	tzoom.aid

*----------------------------------------------------
tobj
	
ptchang1	move.l	#tpoly1+2,chbobj
ptchang2	move.w	tpoly1,d0
bobj	
	move.w	d0,sauvd0
chbobj	equ	*+2
	move.l	tpoly1,d6
	add.l	#4,chbobj
	bsr	poly
	move.w	sauvd0,d0
	dbra.w	d0,bobj	
	rts

sauvd0	dc.w	0
*----------------------------------------------------	
	************************
	**trace de poly 1 plan**	
	************************
poly:
				*chercher +haut
  	move.l	d6,a5
  	move.w	(a5)+,plan
  	lea.l	t_points,a1		*point	Y1		
				****************
	move.w	2(a5),d0
	move.w	4(a5),d1
	move.w	6(a5),d2		test	face
	move.w	(a1,d0.w),d3	     cachee
	sub.w	(a1,d1.w),d3
	move.w	2(a1,d0.w),d4
	sub.w	2(a1,d1.w),d4
	move.w	(a1,d2.w),d0
	sub.w	(a1,d1.w),d0
	move.w	2(a1,d2.w),d5
	sub.w	2(a1,d1.w),d5
	muls	d3,d5
	muls	d0,d4	
	sub.l	d4,d5
	bgt.s	ncaches	
	
	CMPI	#4,sauvd0
	BLE.S	DF
	tst.w	-4(a5)
	bne.s	ncache1
DF
	rts 

tzt	dc.w	0
ncache1				****************
	move.w	#$700,$ffff8242.w
;	move.w	#$777,$ffff8240.w
	rts
ncaches	
	move.w	(a5)+,d0		*d0=ndpoints
	
	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0		*calc avec tpoint
	
	move.w	(a5),d1
	move.w	2(a1,d1),d2
	lea.l	2(a5),a2
	move.w	(a2)+,d3
t_petit
	cmp.w	2(a1,d3.w),d2
	blt.s	st_ptit
	lea.l	-2(a2),a5
	move.w	2(a1,d3.w),d2
st_ptit
	move.w	(a2)+,d3
	dbra.w	d0,t_petit				
********************************************************************	
	move.w	d2,codmpyin+2		*calc ligne
	
	lea.l	calc(pc),a4		*pas touch
				*point=a1			*pointpoint=a5
				*tdpoint=a5
	add.w	d7,d7	
	addq.l	#4,d6
	add.l	d6,d7		
				*d7=fin de table
				*calc tgauche
	lea.l	tgauch,a3
	lea.l	(a5),a2
b_calct_g	
	move.w	(a2)+,d4		*pointe suivant tabe
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g
	move.l	d6,a2
s_calct_g	
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g	
	bsr	calcord
	bra.b	b_calct_g	
s1_calct_g		
	move.w	#0,(a3)
				**droit
	lea.l	tdroit,a3
	move.l	d7,mcodtd+2
	move.l	d6,d7	
	lea.l	(a5),a2
b_calct_d		
	move.w	(a2),d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_d
mcodtd	move.l	#t_points+2,a2
s_calct_d	
	move.w	-(a2),d4
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_d	
	bsr	calcord
	bra.b	b_calct_d	
s1_calct_d	
	move.w	#-4,(a3)
******************************************************************
					*affiche poly			
				*peut toucher a4
	move.l	ecran1,a0

codmpyin	move.w	#100,d0
	lea.l	p_t_ord(pc),a1		
	add.w	d0,d0
	add.w	(a1,d0.w),a0 	*add ydeb	
plan	dc.w	$4e71
	
	lea.l	tgauch,a1	
	lea.l	tdroit,a5
	lea.l	p_t_left(pc),a2	
	lea.l	p_t_right(pc),a3	
	lea.l	tdrempvd(pc),a6
	
	move.w	#$fffc,d3
	move.w	#$ffff,d7

pvalpoly	macro
				;256+12
 	moveq	#-4,d0		;4
	and.w	(a1)+,d0		;8
	move.l	(a2,d0.w),d0	;20
	
	moveq	#-4,d1		;4
	and.w	(a5)+,d1		;8
	move.l	(a3,d1.w),d1	;20	

	move.l	a0,a4		;4	
	add.w	d0,a4		;8	

	sub.w	d0,d1		;4	

	jmp	(a6,d1.w)		;16	
	endm
	pvalpoly
*********************************************
	rts
	bra.w	pdaffpa0
	bra.w	pdaffpa0
tdrempvd				
	bra.w	pdaffpa1		;12	
	dc.l	0
	bra.w	pdaffpa2
	dc.l	0
	bra.w	pdaffpa3	
	dc.l	0
	bra.w	pdaffpa4
	dc.l	0
	bra.w	pdaffpa5
	dc.l	0
	bra.w	pdaffpa6
	dc.l	0
	bra.w	pdaffpa7
	dc.l	0
	bra.w	pdaffpa8
	dc.l	0
	bra.w	pdaffpa9
	dc.l	0
	bra.w	pdaffpa10
	dc.l	0
	bra.w	pdaffpa11
	dc.l	0
	bra.w	pdaffpa12
	dc.l	0
	bra.w	pdaffpa13
	dc.l	0
	bra.w	pdaffpa14
	dc.l	0
	bra.w	pdaffpa15
	dc.l	0
	bra.w	pdaffpa16
	dc.l	0
	bra.w	pdaffpa17
	dc.l	0
	bra.w	pdaffpa18
	dc.l	0
	bra.w	pdaffpa19
	dc.l	0
	bra.w	pdaffpa20

pdaffpa0
	pvalpoly

pdaffpa1
	swap	d0
	swap	d1
	and.w	d0,d1
	or.w	d1,(a4)	
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa2
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa3
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa4
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	2
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa5
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	3
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa6
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	4
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0

	pvalpoly 						
	

pdaffpa7
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	5
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 					
	

pdaffpa8
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	6
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa9
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	7
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0

	pvalpoly 				 	
	

pdaffpa10
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	8
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				 	
	

pdaffpa11
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	9
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0

	pvalpoly 				 	
	

pdaffpa12
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	10
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0

	pvalpoly 				
	

pdaffpa13
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	11
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				


pdaffpa14
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	12
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0

	pvalpoly 				 	
	

pdaffpa15
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	13
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa16

	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	14
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa17
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	15
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa18
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	16
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa19
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	17
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
 	

pdaffpa20
	swap	d0		;4
	or.w	d0,(a4)		;12
n	set	8
	rept	18
	move.w	d7,n(a4)		;12*18
n	set	n+8
	endr
	swap	d1		;4
	or.w	d1,n(a4)		;12
	lea.l	160(a0),a0		;8
	
	pvalpoly 				
	


*********************************************
calcord	
	
	moveq.l	#0,d4
	
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul1
	rts
scalcnul1
	move.w	d2,d4
	ASL.W	#7,D4
	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	moveq	#11,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4
	
	add.w	d0,d0	
	add.w	d0,d0
	sub.w	d1,d1
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts

		
	*_______variables________*
	dc.l	0
p_t_left
n	set	0
          	rept	20
            dc.w    %1111111111111111,n
            dc.w    %0111111111111111,n
            dc.w    %0011111111111111,n
            dc.w    %0001111111111111,n
            dc.w    %0000111111111111,n
            dc.w    %0000011111111111,n
            dc.w    %0000001111111111,n
            dc.w    %0000000111111111,n
            dc.w    %0000000011111111,n
            dc.w    %0000000001111111,n
            dc.w    %0000000000111111,n
            dc.w    %0000000000011111,n
            dc.w    %0000000000001111,n
            dc.w    %0000000000000111,n
            dc.w    %0000000000000011,n
            dc.w    %0000000000000001,n
n	set	n+8
	endr

	dc.w	0,-10
p_t_right
	dc.w	0,0
n	set	0
            rept	20
            dc.w    %1000000000000000,n
            dc.w    %1100000000000000,n
            dc.w    %1110000000000000,n
            dc.w    %1111000000000000,n
            dc.w    %1111100000000000,n
            dc.w    %1111110000000000,n
            dc.w    %1111111000000000,n
            dc.w    %1111111100000000,n
            dc.w    %1111111110000000,n
            dc.w    %1111111111000000,n
            dc.w    %1111111111100000,n
            dc.w    %1111111111110000,n
            dc.w    %1111111111111000,n
            dc.w    %1111111111111100,n
            dc.w    %1111111111111110,n
            dc.w    %1111111111111111,n
n	set	n+8
	endr
	
p_t_ord
n	set	30*160
	rept	200
	dc.w	n
n	set	n+160
	endr			
	*------------variable------------*

np	equ	4

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
	add.w	#2*np,ptdsc	
	lea.l	tdscr1,a0
	add.w	ptdsc,a0
	movea.l	posc1,a1
	
	lea.l	(a0),a2
	lea.l	(a1),a3
	move.w	#31,d1

bscrols
	move.l	(a3),d0
	move.l	d0,38*np(a2)
	move.l	d0,-2*np(a2)
	move.l	4(a3),d0
	move.l	d0,+38*np+4(a2)
	move.l	d0,-2*np+4(a2)

	lea.l	160(a3),a3
	lea.l	40*2*np(a2),a2
	
	dbra.w	d1,bscrols

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
	
	add.w	ptdsc,a0
	movea.l	posc1,a1
	movea.l	posc2,a2
	move.w	#4,d2	
	move.l	#$fff0fff0,d3	
	move.l	#$f000f,d4

n	set	0	
	rept	32
	move.l	n/(40*2*np)*160(a1),d0
	move.l	n/(40*2*np)*160(a2),d1
	lsl.l	d2,d0
	and.l	d3,d0
	rol.l	d2,d1
	and.l	d4,d1			
	swap	d1
	or.l	d1,d0
	move.l	d0,n+38*np(a0)
	move.l	d0,n-2*np(a0)
	move.l	n/(40*2*np)*160+4(a1),d0
	move.l	n/(40*2*np)*160+4(a2),d1
	lsl.l	d2,d0
	and.l	d3,d0
	rol.l	d2,d1
	and.l	d4,d1			
	swap	d1
	or.l	d1,d0
	move.l	d0,n+38*np+4(a0)
	move.l	d0,n-2*np+4(a0)
n	set	n+40*2*np
	endr	
	
	bsr	affsvt
	
	rts

scrols2
	lea.l	tdscr3,a0
	
	add.w	ptdsc,a0
	movea.l	posc1,a1
	movea.l	posc2,a2

	lea.l	(a0),a3
	lea.l	(a1),a4
	lea.l	(a2),a5
		
	move.w	#31,d2
bscrols2

	movep.l	1(a4),d0
	movep.l	(a5),d1
	movep.l	d0,38*np(a3)
	movep.l	d1,38*np+1(a3)
	movep.l	d0,-2*np(a3)
	movep.l	d1,-2*np+1(a3)
	
	lea.l	40*2*np(a3),a3
	lea.l	160(a4),a4
	lea.l	160(a5),a5
	
	dbra.w	d2,bscrols2

	bsr	affsvt
	
	rts

scrols3
	clr.w	indad
	
	lea.l	tdscr4,a0
	move.w	ptdsc,d6
	lea.l	(a0,d6.w),a0
	
	movea.l	posc1,a1
	movea.l	posc2,a2
	
	move.w	#12,d2
	move.w	#4,d3
	move.l	#$f000f000,d4
	move.w	#$fff,d5

n	set	0	
	rept	32
	move.l	n/(40*2*np)*160(a1),d0
	move.l	n/(40*2*np)*160(a2),d1
	lsl.l	d2,d0
	lsr.l	d3,d1	
	and.l	d4,d0
	and.w	d5,d1
	or.l	d1,d0
	move.l	d0,n+38*np(a0)
	move.l	d0,n-2*np(a0)
	
	move.l	n/(40*2*np)*160+4(a1),d0
	move.l	n/(40*2*np)*160+4(a2),d1
	lsl.l	d2,d0
	lsr.l	d3,d1	
	and.l	d4,d0
	and.w	d5,d1
	or.l	d1,d0
	move.l	d0,n+38*np+4(a0)
	move.l	d0,n-2*np+4(a0)

n	set	n+40*2*np
	endr	
	
	move.l	posc2,posc1
	cmp.w	#42*np,d6
	bne.b	tscrol3	
	move.w	#2*np,ptdsc
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
	movea.l	ecran1,a1
pi	equ	2*160
n	set	pi
	rept	32
	movem.l	(a0)+,d0-d7/a2-a5
	movem.l	d0-d7/a2-a5,n+160(a1)
	movem.l	(a0)+,d0-d7/a2-a5
	movem.l	d0-d7/a2-a5,n+48+160(a1)
	movem.l	(a0)+,d0-d7/a2-a5
	movem.l	d0-d7/a2-a5,n+96+160(a1)
	movem.l	(a0)+,d0-d3
	movem.l	d0-d3,n+144+160(a1)
	lea.l	40*np(a0),a0	
n	set	n+160	
	endr
	rts

	section	data
mus	incbin	*.alc	
dess	incbin	METALFN1.pi1
text	
	dc.b	" "
	dc.b	"HI IT'S ME AGAIN TO SERVE YOU.......FUCK TO SELIM THE MUSULMAN FORCE    "
	dc.b	-1
	EVEN

buffl:		
	dc.w	21216,21216,21184,21216,21216,21216,21216,21168
	dc.w	10688,10704,21216,21216,21152,21120,10656,21216	
	
n	set	15840
	rept	10
	dc.w	n
n	set	16+n
	endr

	dc.w	10672,21200,21216,21216,21216,21216,21216	

n	set	0
	rept	10
	dc.w	n
n	set	8*2+n
	endr
	
n	set	5280	
	rept	10
	dc.w	n
n	set	n+16
	endr	
	
n	set	10560	
	rept	6
	dc.w	n
n	set	n+16
	endr	

	section	data
posl	ds.l	1
ptlet	ds.l	1
posc1	ds.l	1
posc2	ds.l	1
indad	ds.w	1
ptdsc	ds.w	1
vsiff	ds.w	1
tdscr1	ds.w	32*21*2*4
tdscr2	ds.w	32*21*2*4
tdscr3	ds.w	32*21*2*4
tdscr4	ds.w	32*21*2*4
	section	text

	
	
	section data

paobj	dc.l	tpoly1,tpoitesp1,tpoly2,tpoitesp2,tpoly3,tpoitesp3,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11+2,face12+2,face13+2,face14+2,face15+2,face16+2 	

face11	dc.w	0,$5488,4,0,4,8,12
face12	dc.w	0,$5888,4,16,0,12,28
face13	dc.w	0,$5c88,4,12,8,24,28
face14	dc.w	0,$5888,4,4,20,24,8
face15	dc.w	0,$5c88,4,16,20,4,0 
face16	dc.w	0,$4e71,4,28,24,20,16

tpoitesp1	
	dc.w	8-1
	dc.w	-42,-42,-42		1
	dc.w	-42,42,-42		2
	dc.w	42,42,-42		3	
	dc.w	42,-42,-42		4
	dc.w	-42,-42,42		5	
	dc.w	-42,42,42		6	
	dc.w	42,42,42		7
	dc.w	42,-42,42		8
*****************************************************
tpoly2	dc.w	7-1
	dc.l	face21+2,face22+2,face23+2,face24+2,face25+2,face26+2,face27+2 	

face21	dc.w	0,$5488,4,0,4,8,12	avd
face22	dc.w	0,$5888,4,0,12,32,36	dhaut
face23	dc.w	0,$5888,4,36,32,28,16	dhaut
face24	dc.w	0,$5c88,5,12,8,24,28,32	droit
face25	dc.w	0,$5888,4,4,20,24,8	bas
face26	dc.w	0,$5c88,5,16,20,4,0,36 	gauche	
face27	dc.w	0,$4e71,4,28,24,20,16	arrie

tpoitesp2	
	dc.w	10-1
	dc.w	-40,-15,-25		1=0
	dc.w	-40,32,-25		2=4
	dc.w	40,32,-25		3=8	
	dc.w	40,-15,-25		4=12
	dc.w	-40,-15,25		5=16	
	dc.w	-40,32,25		6=15	
	dc.w	40,32,25		7=24
	dc.w	40,-15,25		8=28
	dc.w	40,-32,0		9=32
	dc.w	-40,-32,0		10=36

********************************************
tpoly3	dc.w	10-1
	dc.l	face31+2,face32+2,face33+2,face34+2,face35+2
	dc.l	face31B+2,face32B+2,face33B+2,face34B+2,face35B+2

face31	dc.w	1,$4E71,3,0,4,8
face32	dc.w	1,$4E71,3,12,16,20
face33	dc.w	1,$4E71,3,24,32,28
face34	dc.w	1,$4E71,3,36,28,44
face35	dc.w	1,$4E71,3,28,40,48
face31B	dc.w	1,$4E71,3,8,4,0
face32B	dc.w	1,$4E71,3,20,16,12
face33B	dc.w	1,$4E71,3,28,32,24
face34B	dc.w	1,$4E71,3,44,28,36
face35B	dc.w	1,$4E71,3,48,40,28

tpoitesp3	
	dc.w	13-1
	dc.w	-60,-40,0	0
	dc.w	-80,0,0	4
	dc.w	-60,40,0	8
	dc.w	-60,-10,0	12
	dc.w	-40,10,0	16
	dc.w	-20,-10,0	20
	dc.w	-20,-40,0	24
	dc.w	0,0,0	28
	dc.w	-20,40,0	32
	dc.w	0,-40,0	36
	dc.w	0,40,0	40
	dc.w	60,-40,0	44
	dc.w	60,40,0	48

****************************************************

	section	bss
ecran1	ds.l	1	
ecran2	ds.l	1
t_points	ds.w	20*2	
tdroit	ds.w	200
tgauch	ds.w	200
ancl	ds.w	1
oldvbl	ds.l	1
stimb	ds.l	1
oldcol	ds.l	8
ecranp	ds.w	40000