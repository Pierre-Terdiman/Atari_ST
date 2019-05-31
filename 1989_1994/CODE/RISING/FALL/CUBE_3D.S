	(A2,D6.W),A0	5

	MOVE.L	(A4,D7.W),A1	5
	JSR	(A1)	4
;	LEA	160(A6),A6	2
	DBF	D3,ICI

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_T
	MOVE	#$002,$FFFF8240.W
NO_T	NOP
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO_T2
	ADDQ	#1,MOD
NO_T2	NOP
	CMPI.B	#$3c,$FFFFFC02.W
	BNE.S	NO_T2c
	ADDQ	#1,MOD2
NO_T2c	NOP
	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2

	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)


	RTE

	DATA
TABLE1
N	SET	0
	REPT	20
	DC	%1111111111111111,N
	DC	%0111111111111111,N
	DC	%0011111111111111,N
	DC	%0001111111111111,N
	DC	%0000111111111111,N
	DC	%0000011111111111,N
	DC	%0000001111111111,N
	DC	%0000000111111111,N
	DC	%0000000011111111,N
	DC	%0000000001111111,N
	DC	%0000000000111111,N
	DC	%0000000000011111,N
	DC	%0000000000001111,N
	DC	%0000000000000111,N
	DC	%0000000000000011,N
	DC	%0000000000000001,N
N	SET	N+8
	ENDR

TABLE2
N	SET	0
	REPT	20
;	DC	%0000000000000000,N
	DC	%1000000000000000,N
	DC	%1100000000000000,N
	DC	%1110000000000000,N
	DC	%1111000000000000,N
	DC	%1111100000000000,N
	DC	%1111110000000000,N
	DC	%1111111000000000,N
	DC	%1111111100000000,N
	DC	%1111111110000000,N
	DC	%1111111111000000,N
	DC	%1111111111100000,N
	DC	%1111111111110000,N
	DC	%1111111111111000,N
	DC	%1111111111111100,N
	DC	%1111111111111110,N
	DC	%1111111111111111,N
N	SET	N+8
	ENDR

TABL	
	REPT	20
	DC.B	4*15
	DC.B	0
	DC.B	4
	DC.B	4*2
	DC.B	4*3
	DC.B	4*4
	DC.B	4*5
	DC.B	4*6
	DC.B	4*7
	DC.B	4*8
	DC.B	4*9
	DC.B	4*10
	DC.B	4*11
	DC.B	4*12
	DC.B	4*13
	DC.B	4*14
	ENDR


TABL2
	REPT	17
	DC	0
	ENDR

N	SET	8
	REPT	19
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
	DC	N
N	SET	N+8
	ENDR
COORD	
;MOD2	EQU	*+2
	DC	1
;MOD	EQU	*+2
	DC	31

CNT	DC.L	0
TABLO	DCB	20,0
	DC	$9999
TABLO_COPIE	DCB	20,0
	BSS
CODE	DS.B	250000
TABLE	DS.L	20*16*16
GOGO
SCREEN1	DS.L	1
SCREEN2	DS.L	1

	DS.B	256
BUFFER	DS.B	64000
NNEE
	BGE.S	NO_ZOOM
	ADDQ	#1,DONNEE
	SUBQ	#1,DONNEE2

	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE,D0
	SWAP	D0
	MOVE	DONNEE,D0
	MOVEQ	#0,D1
	MOVE	DONNEE2,D1
	SWAP	D1
	MOVE	DONNEE2,D1

	MOVE.L	D1,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	50,50,-50		3	

	MOVE	D0,(A0)+
	MOVE.L	D1,(A0)+
;	dc.w	50,-50,-50		4

	MOVE.L	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	-50,-50,50		5	

	MOVE	D1,(A0)+
	MOVE.L	D0,(A0)+
;	dc.w	-50,50,50		6	

	MOVE.L	D0,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,50,50		7

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,-50,50		8
	BRA	SUIT_CU
NO_ZOOM	
	ADDQ.L	#1,TIME_CUBE
	CMPI.L	#50*4,TIME_CUBE
	BLE	SUIT_CU
	CMPI.L	#50*12,TIME_CUBE
	BGE	NO_ZOOM2
	CMPI	#4,DONNEE3
	BEQ	NO_ZOOM2
	SUBQ	#1,DONNEE3
	ADDQ	#1,DONNEE4
	
	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE3,D0
	SWAP	D0
	MOVE	DONNEE3,D0
	MOVEQ	#0,D1
	MOVE	DONNEE4,D1
	SWAP	D1
	MOVE	DONNEE4,D1

	MOVE.L	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	50,50,-50		3

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	50,-50,-50		4
	bra	SUIT_CU
	
NO_ZOOM2	ADDQ.L	#1,TIME_CUBE
	CMPI.L	#50*12,TIME_CUBE
	BLE.S	SUIT_CU
	CMPI	#55,DONNEE3
	BEQ.S	SUIT_CU2
;	MOVE	#$070,$FFFF8240.W
	ADDQ	#1,DONNEE3
	SUBQ	#1,DONNEE4
	
	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE3,D0
	SWAP	D0
	MOVE	DONNEE3,D0
	MOVEQ	#0,D1
	MOVE	DONNEE4,D1
	SWAP	D1
	MOVE	DONNEE4,D1

	MOVE.L	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	LEA	2(A0),A0
;	dc.w	50,50,-50		3

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	LEA	2(A0),A0
;	dc.w	50,-50,-50		4
	BRA.S	SUIT_CU
SUIT_CU2	
;	ADDQ.L	#1,TIME_CUBE
	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	SUIT_CU
;	MOVE	#$070,$FFFF8240.W
	MOVE.L	#VBL_CUBE_FIN,$70.W
	CLR.L	TIME_CUBE
SUIT_CU	


	move.l	ecran1,d0
	move.l	ecran2,d1
	move.b	ecran2+1,$ffff8201.w
	move.b	ecran2+2,$ffff8203.w
	move.l	d0,ecran2
	move.l	d1,ecran1
	
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	PO
	ST	$FFFF8240.W
PO	jsr	mus+4
	jsr	efecr
	move.w	$fffffc02.w,key

	bsr	calcpoint
	bsr	tobj
	bsr	calcrot

	SF	$FFFF8240.W
	*st	$ffff8240.w

;	cmp.b	#$39,key
;	beq	fin

	rte


VBL_CUBE_FIN
	CMPI	#2,DONNEE
	BEQ.S	NO_ZOOM_F
	SUBQ	#1,DONNEE
	ADDQ	#1,DONNEE2

	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVEQ	#0,D0
	MOVE	DONNEE,D0
	SWAP	D0
	MOVE	DONNEE,D0
	MOVEQ	#0,D1
	MOVE	DONNEE2,D1
	SWAP	D1
	MOVE	DONNEE2,D1

	MOVE.L	D1,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,-50,-50		1

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	-50,50,-50		2

	MOVE.L	D0,(A0)+
	MOVE	D1,(A0)+
;	dc.w	50,50,-50		3	

	MOVE	D0,(A0)+
	MOVE.L	D1,(A0)+
;	dc.w	50,-50,-50		4

	MOVE.L	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	-50,-50,50		5	

	MOVE	D1,(A0)+
	MOVE.L	D0,(A0)+
;	dc.w	-50,50,50		6	

	MOVE.L	D0,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,50,50		7

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
;	dc.w	50,-50,50		8
;	BRA	SUIT_CU
NO_ZOOM_F

	move.l	ecran1,d0
	move.l	ecran2,d1
	move.b	ecran2+1,$ffff8201.w
	move.b	ecran2+2,$ffff8203.w
	move.l	d0,ecran2
	move.l	d1,ecran1
	
	jsr	mus+4
	jsr	efecr
	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	tobj
	bsr	calcrot
	SF	$FFFF8240.W
	cmp.b	#$1,key
	beq	fin
	rte

	even
key	dc.b	0
	even 

	*-----sous programe------*	
calcrot
	sub.w	#1,attvbl	PAUSE SINON LA GESTION DES
	beq.s	calcrots	TOUCHES EST TROP SENSIBLE
	bra	finacal
calcrots
	move.w	#10,attvbl	pour la pause
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

	move.w	#155,d5	x milieu
	move.w	#100,d6	y milieu
	
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
ptchang2	move.w	tpoly1,d0	nb faces
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
  	lea.l	t_points,a1	*point	Y1		
			****************
	move.w	2(a5),d0	PT1	0
	move.w	4(a5),d1	PT2	4
	move.w	6(a5),d2	PT3	8test face

	move.w	(a1,d0.w),d3	X1	cachee
	sub.w	(a1,d1.w),d3   X1-X2

	move.w	2(a1,d0.w),d4	Y1
	sub.w	2(a1,d1.w),d4	Y1-Y2

	move.w	(a1,d2.w),d0	X3
	sub.w	(a1,d1.w),d0	X3-X2

	move.w	2(a1,d2.w),d5	Y3
	sub.w	2(a1,d1.w),d5	Y3-Y2

	muls	d3,d5	(X1-X2)*(Y3-Y2)
	muls	d0,d4	(X3-X2)*(Y1-Y2)
	sub.l	d4,d5
;(X1-X2)*(Y3-Y2)-(X3-X2)*(Y1-Y2)
;=(X1Y3-X1Y2-X2Y3+X2Y2)-(X3Y1-X3Y2-X2Y1+X2Y2)
;=X1Y3 - X1Y2 - X2Y3 +X2Y1 - X3Y1 + X3Y2
	bgt.s	ncaches	
	rts 
				****************
ncaches	
	move.w	(a5)+,d0	*d0=ndpoints
	
	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0	*calc avec tpoint
	
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
	move.w	d2,codmpyin+2	*calc ligne
	
	lea.l	calc(pc),a4	*pas touch
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
	move.w	(a2)+,d4	*pointe suivant tabe
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
	
	LEA	-29*160(A0),A0
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
	bra.w	pdaffpa1
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
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ASL.W	#7,D4
	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#11,d2
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

	dc.w	-8,-6
p_t_right
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

	section	data
mus	incbin	*.alc	

paobj	dc.l	tpoly1,tpoitesp1,tpoly2,tpoitesp2,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11,face12,face13,face14,face15,face16 	

face11	dc.w	$5488,4,0,4,8,12
face12	dc.w	$5888,4,16,0,12,28
face13	dc.w	$5c88,4,12,8,24,28
face14	dc.w	$5888,4,4,20,24,8
face15	dc.w	$5c88,4,16,20,4,0 
face16	dc.w	$4e71,4,28,24,20,16

tpoitesp1	
	dc.w	8-1
	dc.w	-50,-50,-50		0
	dc.w	-50,50,-50		1*4
	dc.w	50,50,-50		3
	dc.w	50,-50,-50		4
	dc.w	-50,-50,50		5
	dc.w	-50,50,50		6
	dc.w	50,50,50		7
	dc.w	50,-50,50		8
*****************************************************
tpoly2	dc.w	7-1
	dc.l	face21,face22,face23,face24,face25,face26,face27 	

face21	dc.w	$5488,4,0,4,8,12	avd
face22	dc.w	$5888,4,0,12,32,36	dhaut
face23	dc.w	$5888,4,36,32,28,16	dhaut
face24	dc.w	$5c88,5,12,8,24,28,32	droit
face25	dc.w	$5888,4,4,20,24,8	bas
face26	dc.w	$5c88,5,16,20,4,0,36 	gauche	
face27	dc.w	$4e71,4,28,24,20,16	arrie

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

****************************************************

	section	bss
ecran1	ds.l	1	
ecran2	ds.l	1
t_points	ds.w	20	
tdroit	ds.w	200
tgauch	ds.w	200
ancl	ds.w	1
oldvbl	ds.l	1
oldcol	ds.l	8
ecranp	ds.w	40000
*
DONNEE	DS	1
DONNEE2	DS	1
DONNEE3	DS	1
DONNEE4	DS	1
TIME_CUBE	DS.L	1
efecr	DS.B	2416
