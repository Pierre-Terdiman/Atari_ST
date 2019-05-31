;FILL - Version 7: MOVEs/une routine par Dx et par d‚calage.
;Version 7D=MOVEs+Effacage d‚j… g‚n‚r‚

;92 nops/ligne pleine. 89 sans le DBF. ( sans augmenter la m‚moire
;pour autant!!! )
;450 lignes sans le DBF. ( je le laisse pour tester, c'est + simple )

	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	LEA	NEWPILE,A7

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP	

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1		
	add.l	#32000,d0		
	move.l	d0,SCREEN2
	
	CLR.L	FLAG
	LEA	CODE,A0
	LEA	TABLE,A1
	MOVE.L	A0,(A1)+
	LEA	TABLO,A6
	MOVE	#%1000000000000000,(A6)
	MOVE	#%0100000000000000,D6

ANEW	LEA	TABLO,A6
	LEA	TABLO_COPIE,A5
	REPT	10
	MOVE.L	(A6)+,(A5)+
	ENDR

AGAIN	LEA	TABLO,A6
	MOVEQ	#0,D7
	
VIDE	;MOVE	D0,D4
	MOVE	(A6)+,D0
	BEQ.S	VIDE
	CMPI	#$9999,D0
	BEQ.S	GNR

;	TST.L	FLAG
;	BNE.S	SUIT1
;
;	TST	D7
;	BNE.S	PAS_LE_PREMIER_MOT
;	MOVE	#$3082,(A0)+
;	BRA.S	SUIT1
;PAS_LE_PREMIER_MOT
;	MOVE	#$3142,(A0)+
;	MOVE	D7,(A0)+
;	ADDQ	#8,D7
SUIT1
	CMPI	#$FFFF,D0
	BNE.S	NON_PLEIN

	TST	D7
	BEQ.S	DEBUT_DE_LIGNE
	MOVE	#$3141,(A0)+
	MOVE	D7,(A0)+
	ADDQ	#8,D7
	ADDQ.L	#1,FLAG
	BRA.S	SUIT0
DEBUT_DE_LIGNE	MOVE	#$3081,(A0)+
	ADDQ	#8,D7
	ADDQ.L	#1,FLAG
	BRA.S	SUIT0

NON_PLEIN	TST	D7
	BEQ.S	DEB_LINE

*
	MOVE	#$317C,(A0)+
	MOVE	D0,(A0)+
	MOVE	D7,(A0)+
	ADDQ	#8,D7
	ADDQ.L	#1,FLAG
	BRA.S	SUIT0

DEB_LINE	MOVE	#$30BC,(A0)+
	MOVE	D0,(A0)+
	ADDQ	#8,D7
	ADDQ.L	#1,FLAG

SUIT0	BRA.S	VIDE
FLAG	DC.L	0
GNR	
	CMPI	#160,D7
	BEQ.S	STOP_IT
	MOVE	#$3142,(A0)+
	MOVE	D7,(A0)+
STOP_IT	MOVE	#$4ED7,(A0)+

	MOVE.L	A0,(A1)+
	CLR.L	FLAG
	LEA	TABLO,A6
N	SET	0
	REPT	20
	ROXR	N(A6)
N	SET	N+2
	ENDR

	ADDQ.L	#1,CNT
	CMPI.L	#16,CNT
	BNE	AGAIN
	CLR.L	CNT
	LEA	TABLO,A5
	LEA	TABLO_COPIE,A6
	REPT	10
	MOVE.L	(A6)+,(A5)+
	ENDR
	LEA	TABLO,A6
MODX	EQU	*+2
	LEA	0(A6),A6
	OR	D6,(A6)
	LSR	#1,D6
	BNE	ANEW
	MOVE	#%1000000000000000,D6
	ADDQ	#2,MODX
	CMPI	#40,MODX
	BEQ.S	FINITO
	BRA	ANEW
	
FINITO	NOP
	MOVE	#$4EF9,(A0)+
	MOVE.L	#RETOUR_ULTIME,(A0)

	MOVE.L	#VBL,$70.W
H	BRA.S	H
FIN	MOVE.L	4.W,A0
	JMP	(A0)

LOAD	
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	lea	t_points,a0
	move	(a0)+,d4
	move	(a0)+,d0
	move	(a0)+,d5
	move	(a0)+,d1
	move	(a0)+,d6
	move	(a0)+,d2
	move	(a0)+,d7
	move	(a0)+,d3
	RTS
DONNEE	DC	20
DONNEE2	DC	-20
VBL	
	SF	$FFFF8240.W
;	ADDQ	#1,DONNEE
;	SUBQ	#1,DONNEE2

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


	BRA	T
	MOVE.L	SCREEN2,A6
	moveq	#0,d0
	MOVE	#199,D1
EFF
N	SET	0
	REPT	20
	MOVE	D0,N(A6)
N	SET	N+8
	ENDR
	LEA	160(A6),A6
	DBF	D1,EFF
T

	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	calcrot  

	JSR	LOAD

;D0=Y1	D4=X1
;D1=Y2	D5=X2
;D2=Y3	D6=X3
;D3=Y4	D7=X4

	CMP	D0,D3	Y1,Y4
	BGT	Y4_SUP
	BLT	Y1_SUP
***
;	Y1=Y4 => Y2=Y3
	CMP	D2,D3	Y3,Y4
	BGT.S	Y4_SUPB
	BLT.S	Y3_SUPB
	MOVE	#$700,$FFFF8240.W
PB1	JMP	FIN
Y4_SUPB	
	MOVE	D0,D7
	MULU	#160,D7
	MOVE	D7,MODY

	MOVE	D0,D3	Y1,D3
	MOVE	D1,D2	Y2,D2
	MOVE	D4,D0	X1 DS D0
	MOVE	D4,D1	X1 DS D1
	SUB	D3,D2
	LEA	TAB,A0	DEP
	JSR	DO_TRANS
	MOVE	#4,(A0)
	;DE Y1 A Y2 => XDEP=X1=X2
	JSR	LOAD

	MOVE	D6,D0
	MOVE	D6,D1
;	MOVE	D2,D2
;	MOVE	D3
;	EXG.L	D2,D3
	SUB	D3,D2
	LEA	TAB,A0
	ADDQ	#2,A0
	JSR	DO_TRANS
	MOVE	#4*320,(A0)
	;DE Y4 A Y3 => XEND=X4=X3
	JSR	POLY
	BRA.S	DONE
Y3_SUPB	
	MOVE	D3,D7
	MULU	#160,D7
	MOVE	D7,MODY

;	EXG.L	D2,D3
	SUB	D3,D2
	MOVE	D6,D0
	MOVE	D6,D1
	LEA	TAB,A0
	ADDQ	#2,A0
	JSR	DO_TRANS
	MOVE	#4*320,(A0)
	;DE Y3 A Y4 => XDEP=X3=X4
	JSR	LOAD

	MOVE	D1,D2	Y2
	MOVE	D0,D3
	SUB	D3,D2
	MOVE	D4,D0
	MOVE	D4,D1
	LEA	TAB,A0
;	ADDQ	#2,A0
	JSR	DO_TRANS
	MOVE	#4,(A0)
	;DE Y2 A Y1 => XEND=X2=X1
	JSR	POLY
	BRA.S	DONE
***
;	MOVE	#300,D0
;	MOVE	#319,D1
;
;	MOVE	#201,D2
;	MOVE	#1,D3
;	SUB	D3,D2
;	LEA	TAB,A0
;	ADDQ.L	#2,A0
;	JSR	DO_TRANS


Y4_SUP	;DE Y4 A Y1=>XDEP
	;CMP	Y1,Y2
	BGT.S	Y2_SUPB
	BLT.S	Y1_SUPB
	;Y1=Y2
	;DE Y3 A Y2=>XEND=X3=X2
Y2_SUPB	;DE Y3 A Y4=>XDEP
	;DE Y3 A Y2=>XEND
	;DE Y2 A Y1=>XEND
Y1_SUPB	;DE Y1 A Y2=>XDEP
	;DE Y4 A Y3=>XEND
	;DE Y3 A Y2=>XEND
***
Y1_SUP	;DE Y1 A Y4=>XEND
	;CMP	Y3,Y4
	BGT.S	Y4_SUPC
	BLT.S	Y3_SUPC
	;Y3=Y4=>Y1=Y2
	;DE Y2 A Y3=>XDEP
	;DE Y1 A Y4=>XEND
Y4_SUPC	;DE Y1 A Y2=>XDEP
	;DE Y2 A Y3=>XDEP
	;DE Y1 A Y4=>XEND
	;DE Y4 A Y3=>XEND
Y3_SUPC	;DE Y2 A Y3=>XDEP
	;DE Y3 A Y4=>XDEP
	;DE Y2 A Y1=>XEND
	;DE Y1 A Y4=>XEND

DONE
	JMP	FIN_VBL
POLY	MOVE	#$001,$FFFF8240.W
	TST	MODY
	BGE.S	NO_PB
	CLR	MODY
NO_PB	MOVE.L	SCREEN2,A6	6? 7?
MODY	EQU	*+2
	LEA	0(A6),A6
	MOVE.L	#$FFFFFFFF,D1	3?
	MOVEQ	#0,D2

	LEA	TABL,A3	3?
	LEA	TABL2,A2	3?
	LEA	TABLE,A4	3?
	LEA	-160(A6),A6	2

	LEA	TAB,A5
	MOVE.L	A7,SAUVEA7
	LEA	RETOUR,A7
	MOVE	#18,D4
	BRA	ICI
;	MOVE	#200-1,D3	2
	DS.L	256
ICI
RETOUR
	LEA	160(A6),A6	2
	MOVE.L	A6,A0	1
;MOD2	EQU	*+2
;	MOVE	#1*4,D6	2
	MOVE	(A5)+,D6
;MOD	EQU	*+2
;	MOVE	#320*4,D7	2
	MOVE	(A5)+,D7

	SUB	D6,D7	1
	LSL	#4,D7	5-1

	ADD	(A3,D6.W),D7	4

	ADDA	(A2,D6.W),A0	5
*
;	CMP	D4,D6
;	BLE.S	OP
	MOVE	D2,-8(A0)
;OP

;	MOVE.L	(A2,D6.W),D4	5
;	SWAP	D4
;	ADD	D4,A0	2
;	SWAP	D4	1
;	MOVE	D2,(A0,D4.W)	4
*
;	MOVE	D2,-8(A0)	3

	MOVE.L	(A4,D7.W),A1	5
	JMP	(A1)	2+61
;RETOUR
;	DBF	D3,ICI	3

SAUVEA7	DC.L	0
	even
key	dc.b	0
	even 


RETOUR_ULTIME
	MOVE.L	SAUVEA7,A7
	RTS

FIN_VBL
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_T
	MOVE	#$002,$FFFF8240.W
NO_T	NOP

	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO_T2
	ADDQ	#1,DONNEE
	SUBQ	#1,DONNEE2
NO_T2	NOP
	CMPI.B	#$3c,$FFFFFC02.W
	BNE.S	NO_T2c
	SUBQ	#1,DONNEE
	ADDQ	#1,DONNEE2
NO_T2c	NOP
	CMPI.B	#$3D,$FFFFFC02.W
	BNE.S	NO_T2D
	ADDQ	#1,MOD2
NO_T2D	NOP
	CMPI.B	#$3E,$FFFFFC02.W
	BNE.S	NO_T2E
	SUBQ	#1,MOD2
NO_T2E	NOP

	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2

	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE

DO_TRANS
;	MOVE.L	#NB_PASSES,D2	EN 'D2' PASSES
	MOVE.L	D2,D6
	MOVE	D2,MODIF
	MOVE	D2,MODIF_

	LSL.L	#8,D0
	LSL.L	#8,D1
	CMP.L	D0,D1
	BGT.S	ROUTY1
ROUTY2	;D1 PLUS PETIT
	MOVE.L	D0,D2
	SUB.L	D1,D0	D1=AMPLITUDE
	DIVU	D6,D0
	SWAP	D0
	CLR	D0
	SWAP	D0
MODIF_	EQU	*+2
	MOVE	#0,D7
	SUBQ	#1,D7
DO_IT_AGAIN_	SUB.L	D0,D2
	MOVE.L	D2,D3
	LSR.L	#8,D3	CA EN FAIT UN
	ADD	D3,D3
	ADD	D3,D3
	MOVE	D3,(A0)
	BGE.S	GOONN
	MOVE	#4,(A0)
GOONN	CMPI	#319*4,(A0)
	BLE.S	GOI
	MOVE	#319*4,(A0)
	
GOI	ADDQ.L	#4,A0
	DBF	D7,DO_IT_AGAIN_
FINI2	RTS
****
	
ROUTY1	;D0 PLUS PETIT
	MOVE.L	D0,D2
	SUB.L	D0,D1	D1=AMPLITUDE
	DIVU	D6,D1
	SWAP	D1
	CLR	D1
	SWAP	D1
MODIF	EQU	*+2
	MOVE	#0,D7
	SUBQ	#1,D7
DO_IT_AGAIN	ADD.L	D1,D2
	MOVE.L	D2,D3
	LSR.L	#8,D3	CA EN FAIT UN
	ADD	D3,D3
	ADD	D3,D3
	MOVE	D3,(A0)
	BGE.S	GOON
	MOVE	#4,(A0)
GOON	
	CMPI	#319*4,(A0)
	BLE.S	KK
	MOVE	#319*4,(A0)
KK	ADDQ.L	#4,A0
	DBF	D7,DO_IT_AGAIN
FINITED	RTS


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
	DC	4*15,0
	DC	0,0
	DC	4,0
	DC	4*2,0
	DC	4*3,0
	DC	4*4,0
	DC	4*5,0
	DC	4*6,0
	DC	4*7,0
	DC	4*8,0
	DC	4*9,0
	DC	4*10,0
	DC	4*11,0
	DC	4*12,0
	DC	4*13,0
	DC	4*14,0
	ENDR


TABL2
	REPT	17
	DC	0,0
	ENDR

N	SET	8
	REPT	19
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
	DC	N,-8
N	SET	N+8
	ENDR
	DS	5000
TAB	DS	200*2
	DC	4,320*4
	DS	5000

;TAB
;N	SET	2
;	REPT	199
;	DC	N*4
;N	SET	N+1
;	ENDR
;	DC	320*4

CNT	DC.L	0
	DS.L	256
NEWPILE	DS.L	1
TABLO	DCB	20,0
	DC	$9999
TABLO_COPIE	DCB	20,0
	TEXT

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
;	move.l	d0,ptchang2+2
	addq.l	#2,d0
;	move.l	d0,ptchang1+2
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

	section	data
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
	dc.w	343-1
points
Z	SET	-49
	REPT	7

Y	SET	-49
X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

X	SET	-49
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
	DC	X,Y,Z
X	SET	X+14
Y	SET	Y+14

Z	SET	Z+14
	ENDR

********************************************
tpoly3	dc.w	5-1
	dc.l	face31+2,face32+2,face33+2,face34+2,face35+2

face31	dc.w	1,$5888,3,0,4,8
face32	dc.w	1,$5888,3,12,16,20
face33	dc.w	1,$5888,3,24,32,28
face34	dc.w	1,$5888,3,36,28,44
face35	dc.w	1,$5888,3,28,40,48

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

	BSS
CODE	DS.B	263000
TABLE	DS.L	20*16*16
GOGO
SCREEN1	DS.L	1
SCREEN2	DS.L	1

	DS.B	256
BUFFER	DS.B	64000
t_points	ds.w	20*2	
