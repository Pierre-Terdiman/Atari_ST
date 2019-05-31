X1	EQU	0
Y1	EQU	2
X2	EQU	4
Y2	EQU	6
X3	EQU	8
Y3	EQU	10
X4	EQU	12
Y4	EQU	14
X5	EQU	16
Y5	EQU	18
X6	EQU	20
Y6	EQU	22
X7	EQU	24
Y7	EQU	26
X8	EQU	28
Y8	EQU	30
X9	EQU	32
Y9	EQU	34
X10	EQU	36
Y10	EQU	38
X11	EQU	40
Y11	EQU	42
X12	EQU	44
Y12	EQU	46
X13	EQU	48
Y13	EQU	50
X14	EQU	52
Y14	EQU	54
X15	EQU	56
Y15	EQU	58
X16	EQU	60
Y16	EQU	62

Y_CLIP=199
MAX=130

Main:
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	lea.l	8,a0
	move.l	#fini,d0
	move.l	#fini,d1
	move.l	#fini,d2
	move.l	#fini,d3
	move.l	#fini,d4
	move.l	#fini,d5
	move.l	#fini,d6
	move.l	#fini,d7
	movem.l	d0-d7,(a0)

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	move.w	#$5,-(sp)
	trap	#14
	lea.l	12(sp),sp

	move.l	#BUFECR,d0	deff ecr
	CLR.B	D0
	move.l	d0,SCREEN1
	move.l	#BUFECR2,d0	deff ecr
	CLR.B	D0
	move.l	d0,SCREEN2

	MOVEM.L	DATA+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	LEA	DATA+34,A0
	MOVE.L	SCREEN1,A1
	MOVE.L	SCREEN2,A2
	MOVE	#7999,D0
C	MOVE.L	(A0),(A1)+
	MOVE.L	(A0)+,(A2)+
	DBF	D0,C

	JSR	POLY+8

	clr.b	$fffffa07.w
	clr.b	$fffffa09.w

	MOVE.L	#VBL,$70.W
	jmp	newvbl

mainloop
	bra.s	mainloop
VBL	ADDQ	#1,VBL_FLAG
	RTE
VBL_FLAG	DC	0
VBL_FLAG2	DC	0

fini	MOVE.L	4.W,A0
	JMP	(A0)
DONNEE	DC	0
DONNEE2	DC	0

newvbl
.WAIT	TST	VBL_FLAG
	BEQ.S	.WAIT

GO_GO	CLR	VBL_FLAG
	CLR	DONNEE
	CLR	DONNEE2

	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO_F1
	CMPI	#MAX,DONNEE
	BGT.S	NO_F1
	ADDQ	#1,DONNEE
	SUBQ	#1,DONNEE2
	ADDQ	#2,MODZ
NO_F1	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	NO_F2
	CMPI	#MAX,DONNEE2
	BGT.S	NO_F2
	SUBQ	#1,DONNEE
	ADDQ	#1,DONNEE2
	SUBQ	#2,MODZ
NO_F2	BRA	SUIT
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

	LEA	tpoitesp1,A0
	ADDQ	#6,A0
	REPT	16
	ADD	D0,(A0)
	ADDQ	#6,A0
	ENDR
SUIT

	bsr	efecr_sp‚cial

	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	calcrot  
	MOVE.L	SCREEN2,A0
	ADDQ	#4,A0
	JSR	POLY

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X3(a0),(a1)+
	move.l	X2(a0),(a1)+
	move.l	X6(a0),(a1)+
	move.l	X6(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X4(a0),(a1)+
	move.l	X1(a0),(a1)+
	move.l	X5(a0),(a1)+
	move.l	X5(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X8(a0),(a1)+
	move.l	X1(a0),(a1)+
	move.l	X7(a0),(a1)+
	move.l	X7(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X2(a0),(a1)+
	move.l	X3(a0),(a1)+
	move.l	X6(a0),(a1)+
	move.l	X6(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X1(a0),(a1)+
	move.l	X4(a0),(a1)+
	move.l	X5(a0),(a1)+
	move.l	X5(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	lea	t_points,a0
	lea	face_en_cours,a1
	move.l	X1(a0),(a1)+
	move.l	X8(a0),(a1)+
	move.l	X7(a0),(a1)+
	move.l	X7(a0),(a1)+
	lea	face_en_cours,a0
	JSR	POLY+4

	LEA	STUPID,A0
MOD_STU	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	.ROOL
	LEA	STUPID,A0
	CLR	MOD_STU
.ROOL	MOVE	(A0),MODY
	ADDQ	#2,MOD_STU

	SUBQ	#1,TEMPS
	BGE.S	S
ZE	MOVE	#0,adag2
	CMPI	#20,ZE+2
	BEQ.S	S
	ADDQ	#2,ZE+2
S
	
		

STOP	;move.l	SCREEN1,d0		flip SCREEN
	;move.l	SCREEN2,d1
	;move.b	SCREEN2+1,$ffff8201.w
	;move.b	SCREEN2+2,$ffff8203.w
	;move.l	d0,SCREEN2
	;move.l	d1,SCREEN1

	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w

	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2

	LEA	$FFFBE,A0
;	MOVE	ang1,(a0)+
	MOVE	ang2,(a0)+
;	MOVE	ang3,(a0)+
;	move	adag1,(a0)+
;	move	adag2,(a0)+
;	move	adag3,(a0)+
	MOVE	MODZ,(A0)+

;	CMPI.B	#$F,$FFFFFC02.W
;	BNE.S	NO_TIME
;	ST	$FFFF8240.W
;NO_TIME

	jmp	newvbl
TEMPS	DC	10
	even
key	dc.b	0
	even 

calcrot
	sub.w	#1,attvbl
	beq.s	calcrots	
	bra	finacal
calcrots
	move.w	#5,attvbl
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

efecr_sp‚cial
	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	;MOVE.L	#$0000FFFF,D0
	MOVE	#199,D1
JK
N	SET	0
	REPT	11
	MOVE	D0,N+4(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D1,JK
	RTS

calcpoint
	lea.l	tsin(pc),a0
	lea.l	128(a0),a1
ang1	equ	*+2
	move.w	#0,d0
ang2	equ	*+2
	move.w	#$1E2,d1
ang3	equ	*+2	
	move.w	#$10C,d2

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
MODZ	EQU	*+2
	LEA	-410(A2),A2	-310
	move.w	#80,d5
MODX	EQU	*+2
	ADD	#0,D5
	move.w	#99,d6
MODY	EQU	*+2
	SUB	#0,D6

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
;	JSR	ROUTINE
	dbra.w	d7,bmatrix
	rts

;	CLR.L	-(SP)
;	MOVE	#$20,-(SP)
;	TRAP	#1
;	ADDQ.L	#6,SP
;
;	MOVE.L	#VBK,$70.W
;
;J	BRA.S	J
;
;VBK
;	MOVE	#5000,D0
;F	DBF	D0,F
;	MOVEQ	#0,D0
;
;	ST	$FFFF8240.W
;	LEA	ADR_RTS,A4
;	lea	TAB,A3
;	MOVE	#-200,D0	X_DEP
;	MOVE	#200,D2	X_FIN
;
;	MOVE	#0,D1	Y_DEP
;	MOVE	#200,D3	Y_FIN=>(D3-D1) MOTS INSCRITS
;
;	JSR	CALCUL
;
;	nop
;
;	SF	$FFFF8240.W
;	RTE
;
;CALCUL
;	MOVEQ	#0,D4
;	SUB.W	D0,D2	DELTA X
;	SUB.W	D1,D3	DELTA Y
;	BNE.S	NON_NUL
;	RTS
;NON_NUL
;	MOVE	D2,D4
;
;	ASL	#7,D4	*128
;;	EXT.L	D4
;	DIVS.W	D3,D4	*X(+1)=(DX/DY)+X
;	MOVE	#9,D2
;	EXT.L	d4
;	ASL.L	D2,D4
;
;	ADD	D3,D3
;	ADD	D3,D3
;	NEG	D3
;	SWAP	D4
;
;;	ADD	D0,D0
;;	ADD	D0,D0
;	SUB	D1,D1
;	JMP	(A4,D3)
;
;	REPT	201
;	MOVE	D0,(A3)+
;	ADDX.L	D4,D0
;	ENDR
;ADR_RTS
;	RTS

;TAB	DS	200
;TABE	DC.L	$99999999,0,0,0

	DATA

	incbin	tsin7.aid
tsin	incbin	tsin7.aid
	incbin	tsin7.aid

tz	incbin	tzoom.aid
;TABLE_	DS.L	20*16*16

*----------------------------------------------------

paobj	dc.l	tpoly1,tpoitesp1,-1

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
	DC	0,0,0
	DC	5,5,3
	DC	0,-5,-3
	DC	20,8,2
	DC	20,-5,-1
	DC	-5,5,3
	DC	-20,8,2
	DC	-20,-5,-1

DATA	INCBIN	SCREEN.PI1
STUPID	INCBIN	STUPID
	DC	$9999
POLY	INCBIN	RT_POLY3.BIN

	BSS
	DS.B	411000

SCREEN1	DS.L	1
SCREEN2	DS.L	1
t_points	ds.w	20*2	
face_en_cours	ds.l	4
	DS.B	256
BUFECR	DS.B	32000
	DS.B	256
BUFECR2	DS.B	32000
