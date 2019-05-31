X1	EQU	0
Y1	EQU	2
X2	EQU	4
Y2	EQU	6
X3	EQU	8
Y3	EQU	10
X4	EQU	12
Y4	EQU	14

Y_CLIP=199

main
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

	
;	move.b	#$12,$fffffc02.w	

**
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
	
VIDE	MOVE	(A6)+,D0
	BEQ.S	VIDE
	CMPI	#$9999,D0
	BEQ.S	GNR

	CMPI	#$FFFF,D0
	BNE.S	NON_PLEIN

	TST	D7
	BEQ.S	DEBUT_DE_LIGNE
	MOVE	#$3141,(A0)+
	MOVE	D7,(A0)+
	ADDQ	#8,D7
	BRA.S	SUIT0
DEBUT_DE_LIGNE	MOVE	#$3081,(A0)+
	ADDQ	#8,D7
	BRA.S	SUIT0

NON_PLEIN	TST	D7
	BEQ.S	DEB_LINE

	MOVE	#$317C,(A0)+
	MOVE	D0,(A0)+
	MOVE	D7,(A0)+
	ADDQ	#8,D7
	BRA.S	SUIT0
DEB_LINE	MOVE	#$30BC,(A0)+
	MOVE	D0,(A0)+
	ADDQ	#8,D7

SUIT0	BRA.S	VIDE
	
GNR	MOVE	#$4ED7,(A0)+
	MOVE.L	A0,(A1)+
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

	LEA	TABLE_,A1
	LEA	TABLE,A0
	MOVE.L	A0,A2
	MOVE	#16-1,D1
TA2	MOVE.L	A2,A0
	MOVE	#320-1,D0
TA	TST.L	(A0)
	BNE.S	DO_IT
	MOVE.L	#RETOUR,(A1)+
	BRA.S	JUMP
DO_IT	MOVE.L	(A0),(A1)+
JUMP	LEA	16*4(A0),A0
	DBF	D0,TA
	ADDQ	#4,A2
	DBF	D1,TA2

**
	MOVE.L	#RETOUR_ULTIME,ADR_RET

	move.l	#newvbl,$70.w	
	clr.b	$fffffa07.w	
	clr.b	$fffffa09.w	


;	jmp	newvbl
		
mainloop	
	bra.s	mainloop
	
fini	MOVE.L	4.W,A0
	JMP	(A0)
*_______________________________________
newvbl        
	SF	$FFFF8240.W
	ST	$FFFF8242.W	

	bsr	efecr
	MOVE	#$700,$FFFF8240.W
	MOVEQ	#0,D0
	LEA	TAB,A0
	REPT	200
	MOVE.L	D0,(A0)+
	ENDR
	MOVE	#$001,$FFFF8240.W
	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	calcrot  

;  	move.l	d6,a5
;  	move.w	(a5)+,plan
  	lea.l	t_points,a1	*point	Y1		
			****************
;	move.w	2(a5),d0	PT1	0
;	move.w	4(a5),d1	PT2	4
;	move.w	6(a5),d2	PT3	8test face

;	move.w	(a1,d0.w),d3	X1	cachee
	move	(a1),d3
	sub	4(a1),d3
;	sub.w	(a1,d1.w),d3   X1-X2

;	move.w	2(a1,d0.w),d4	Y1
;	sub.w	2(a1,d1.w),d4	Y1-Y2
	move	2(a1),d4
	sub	6(a1),d4

;	move.w	(a1,d2.w),d0	X3
;	sub.w	(a1,d1.w),d0	X3-X2
	move	4*2(a1),d0
	sub	4(a1),d0

;	move.w	2(a1,d2.w),d5	Y3
;	sub.w	2(a1,d1.w),d5	Y3-Y2
	move	10(a1),d5
	sub	6(a1),d5

	muls	d3,d5	(X1-X2)*(Y3-Y2)
	muls	d0,d4	(X3-X2)*(Y1-Y2)
	sub.l	d4,d5
;(X1-X2)*(Y3-Y2)-(X3-X2)*(Y1-Y2)
;=(X1Y3-X1Y2-X2Y3+X2Y2)-(X3Y1-X3Y2-X2Y1+X2Y2)
;=X1Y3 - X1Y2 - X2Y3 +X2Y1 - X3Y1 + X3Y2
;	bgt.s	visible
	ble	cachee
	move	#$070,$ffff8240.w

*valable pour face 1
;	LEA	MINI_TABLO,A6
;**

	LEA	ADR_RTS,A4
;	LEA	MINI_TABLO,A6
;	MOVE	2(A6),D0	Y_MIN
;	MOVE	D0,D1
;	MULU	#160,D0
;	MOVE	D0,MODY
;	MULU	#?;D1
;	MOVE	D1,MOD_Y_LECTURE_TAB

**********
	LEA	t_points,a0
	MOVE	2(A0),D6	Y1
	CMP	2+4(A0),D6
	BGT	D6_WIN
;Y2>Y1	CAS 1 ET 2

	LEA	TAB,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	(A0),D0
	MOVE	4(A0),D2
	MOVE	2(A0),D1
	MOVE	6(A0),D3
	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVE	Y2(A0),D6
	CMP	Y3(A0),D6
	BGT	D6_W
;Y3>Y2	CAS 1
	LEA	TAB,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3

	MOVE	Y3(A0),D3
	MOVE	X3(A0),D2
	MOVE	Y2(A0),D1
	MOVE	X2(A0),D0
	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3

	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y3(A0),D3
	CMP	Y4(A0),D3
	BGT.S	D3W

	LEA	TAB,A3
	MOVE	Y3(A0),D1
	MOVE	X3(A0),D0
	MOVE	Y4(A0),D3
	MOVE	X4(A0),D2
	BRA.S	CONT0
D3W	
	LEA	TAB2,A3
	MOVE	Y3(A0),D3
	MOVE	X3(A0),D2
	MOVE	Y4(A0),D1
	MOVE	X4(A0),D0
	
CONT0	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y4(A0),D3
	CMP	Y1(A0),D3
	BGT.S	D3Q
	LEA	TAB,A3
	MOVE	Y4(A0),D1
	MOVE	X4(A0),D0
	MOVE	Y1(A0),D3
	MOVE	X1(A0),D2
	BRA.S	CONT1
D3Q	
	LEA	TAB2,A3
	MOVE	Y4(A0),D3
	MOVE	X4(A0),D2
	MOVE	Y1(A0),D1
	MOVE	X1(A0),D0
CONT1	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL
	BRA	DONE

D6_W	;Y2>Y3 CAS 2
	LEA	TAB2,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
;	MOVE	Y2(A0),D3
;	CMP	Y3(A0),D3
;	BGT.S	D3E
;	MOVE	Y2(A0),D1
;	MOVE	X2(A0),D0
;	MOVE	Y3(A0),D3
;	MOVE	X3(A0),D2	
;	BRA.S	CONT5
D3E	MOVE	Y2(A0),D3
	MOVE	X2(A0),D2
	MOVE	Y3(A0),D1
	MOVE	X3(A0),D0
CONT5	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL
	
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y3(A0),D3
	CMP	Y4(A0),D3
	BGT.S	D3F
	LEA	TAB,A3
	MOVE	Y3(A0),D1
	MOVE	X3(A0),D0
	MOVE	Y4(A0),D3
	MOVE	X4(A0),D2
	BRA.S	CONT4
D3F	
	LEA	TAB2,A3
	MOVE	Y3(A0),D3
	MOVE	X3(A0),D2
	MOVE	Y4(A0),D1
	MOVE	X4(A0),D0
CONT4	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3

	MOVE	Y1(A0),D3
	CMP	Y4(A0),D3
	BGT.S	D3D
	LEA	TAB2,A3
	MOVE	Y1(A0),D1
	MOVE	X1(A0),D0
	MOVE	Y4(A0),D3
	MOVE	X4(A0),D2
	BRA.S	CONT2
D3D	
	LEA	TAB,A3
	MOVE	Y1(A0),D3
	MOVE	X1(A0),D2
	MOVE	Y4(A0),D1
	MOVE	X4(A0),D0
CONT2	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL
	BRA	DONE

D6_WIN	;Y1>Y2	CAS 3 ET 4
	LEA	TAB2,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	4(A0),D0
	MOVE	(A0),D2
	MOVE	2(A0),D3
	MOVE	6(A0),D1
	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVE	4+2(A0),D6	Y2
	CMP	8+2(A0),D6	Y3,Y2
	BGT	D6_WINB
;CAS 4	Y3>Y2
	LEA	TAB,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	4(A0),D0
	MOVE	6(A0),D1
	MOVE	8(A0),D2
	MOVE	10(A0),D3
	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y4(A0),D3
	CMP	Y3(A0),D3
	BGT.S	D3R
	LEA	TAB2,A3
	MOVE	X3(A0),D2
	MOVE	X4(A0),D0
	MOVE	Y3(A0),D3
	MOVE	Y4(A0),D1
	BRA.S	CONT6
D3R	
	LEA	TAB,A3
	MOVE	X3(A0),D0
	MOVE	X4(A0),D2
	MOVE	Y3(A0),D1
	MOVE	Y4(A0),D3
CONT6	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y4(A0),D3
	CMP	Y1(A0),D3
	BGT.S	D3P
	LEA	TAB,A3
	MOVE	X1(A0),D2
	MOVE	X4(A0),D0
	MOVE	Y4(A0),D1
	MOVE	Y1(A0),D3
	BRA.S	CONT7
D3P	
	LEA	TAB2,A3
	MOVE	Y4(A0),D3
	MOVE	X1(A0),D0
	MOVE	X4(A0),D2
	MOVE	Y1(A0),D1
CONT7	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL
	BRA	DONE

D6_WINB	;Y2>Y3	CAS 3
	LEA	TAB2,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	4(A0),D2
	MOVE	10(A0),D1
	MOVE	8(A0),D0
	MOVE	6(A0),D3
	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y4(A0),D3
	CMP	Y3(A0),D3
	BGT.S	D3Y
	LEA	TAB2,A3
	MOVE	Y4(A0),D1
	MOVE	Y3(A0),D3
	MOVE	X3(A0),D2
	MOVE	X4(A0),D0
	BRA.S	CONT8
D3Y	
	LEA	TAB,A3
	MOVE	Y4(A0),D3
	MOVE	X3(A0),D0
	MOVE	X4(A0),D2
	MOVE	Y3(A0),D1
CONT8	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE	Y1(A0),D3
	CMP	Y4(A0),D3
	BGT.S	D3Z
	LEA	TAB2,A3
	MOVE	X4(A0),D2
	MOVE	X1(A0),D0
	MOVE	Y1(A0),D1
	MOVE	Y4(A0),D3
	BRA.S	CONT9
D3Z	
	LEA	TAB,A3
	MOVE	Y1(A0),D3
	MOVE	X4(A0),D0
	MOVE	X1(A0),D2
	MOVE	Y4(A0),D1
CONT9	MOVE	D1,D4
	ADD	D4,D4
	ADD	D4,A3
	JSR	CALCUL

DONE
	LEA	t_points,a0
	MOVE	2(A0),D0	Y1
	MOVE	2+4(A0),D1	Y2
	MOVE	2+4*2(A0),D2	Y3
	MOVE	2+4*3(A0),D3	Y4
	JSR	TRIE_MIN
**
;tri … faire avant pour Jumper+tot en cas de clip, mais tab a modifier
;apres le calcul...
	CMP	#Y_CLIP,D4
	BLT.S	OK_OK
	BRA	cachee
OK_OK	TST	D4
	BGE.S	NO_CLIP
	MOVEQ	#0,D4
NO_CLIP	ADD	D4,D4
	MOVE	D4,MOD_DEP_TAB
	MULU	#80,D4
	MOVE	D4,MODY

	LEA	t_points,a0
	MOVE	2(A0),D0	Y1
	MOVE	2+4(A0),D1	Y2
	MOVE	2+4*2(A0),D2	Y3
	MOVE	2+4*3(A0),D3	Y4
	JSR	TRIE_MAX
	TST	D4
	BGE.S	OK_OK_OK
	BRA	cachee
OK_OK_OK	LEA	TAB,A3
	LEA	TAB2,A4
	CMPI	#Y_CLIP,D4
	BLE.S	NO_CLIP2
	MOVE	#Y_CLIP,D4
NO_CLIP2	ADD	D4,D4
	ADD	D4,A3
	ADD	D4,A4
	MOVE	#0,(A3)
	MOVE	#5120,(A4)
	MOVE	#$222,$FFFF8240.W

***
;	bra	cachee
T	;MOVE	#$001,$FFFF8240.W
	MOVE	#$555,$FFFF8240.W

	MOVE.L	SCREEN2,A6	6? 7?
MODY	EQU	*+2
	LEA	0(A6),A6
	LEA	-160(A6),A6	2
	MOVE.L	#$FFFFFFFF,D1	3?

	LEA	TABL,A3	3?
	LEA	TABL2,A2	3?
	LEA	TABLE_,A4	3?
	MOVE	#%1111111111111000,D5

	LEA	TAB,A5
MOD_DEP_TAB	EQU	*+2
	LEA	0(A5),A5
	MOVE.L	A7,SAUVEA7
	LEA	RETOUR,A7
	BRA	ICI

	DS.L	256
;	MOVE	#200-1,D3	2

ICI	
RETOUR
	LEA	160(A6),A6	2
	MOVE.L	A6,A0	1
;MOD2	EQU	*+2
	MOVE	(A5)+,D6	2
;MOD	EQU	*+2
	MOVE	800-2(A5),D7	2

	SUB	D6,D7	1
	BLT	OOPS
	ADD	D7,D7	1
	ADD	D7,D7	1

	ADD	D6,D6	1
	ADD	(A3,D6.W),D7	4

	ADDA	(A2,D6.W),A0	5

	MOVE.L	(A4,D7.W),A1	5
	JMP	(A1)	2+61
OOPS	MOVE	#$770,$FFFF8240.W
	BRA	ICI


;	MOVE.L	SCREEN2,A6
;	LEA	TABLE1,A2
;	LEA	TABLE2,A3
;	LEA	TAB,A5
;	MOVE.L	#$FFFFFFFF,D1
;	MOVE	#199,D3
;ICI	MOVE.L	A6,A0
;	LEA	TABLE,A4
;	MOVE	(A5),D6
;	MOVE	D6,D5
;	MOVE	400(A5),D7
;	MOVE	D7,D4
;	TST	D6
;	BNE.S	Q
;	BRA.S	Y
;Q	TST	D7
;	BEQ.S	Y
;	LSR	#4,D7
;	LSR	#4,D6
;	SUB	D6,D7	DELTA X
;;	LSR	#4,D7	D7=>DETERMINE ROUT A APPELER
;	LSL	#2,D7
;
;;	SUBQ	#1,D5
;	ADD	D5,D5	x3*4 ( x3<x1 )
;	ADD	D5,D5
;	MOVE	(A2,D5.W),D0	motif
;	ADD	2(A2,D5.W),A0
;	SUBQ	#1,D4
;	ADD	D4,D4	x1*4 ( ancien x )
;	ADD	D4,D4
;	MOVE	(A3,D4.W),D2	motif
;
;	MOVE.L	(A4,D7.W),A4
;	JSR	(A4)
;Y	LEA	160(A6),A6
;	ADDQ	#2,A5
;	DBF	D3,ICI
;	SF	$FFFF8240.W
;	RTE


SAUVEA7	DC.L	0
RETOUR_ULTIME
	MOVE.L	SAUVEA7,A7
cachee


	move.l	SCREEN1,d0		flip SCREEN
	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
	move.l	d0,SCREEN2
	move.l	d1,SCREEN1

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIME
	ST	$FFFF8240.W
NO_TIME
	cmp.b	#$39,key
	beq	fini
	;jmp	newvbl
	rte

	even
key	dc.b	0
	even 
;FLAG	DC	0
TRIE_MAX	CMP	D0,D1
	BGT.S	AD1_WIN_A
;	BLT.S	AD0_WIN_A
;	ADDQ	#1,FLAG1
AD0_WIN_A	CMP	D2,D0
	BGT.S	AD0_WIN_B
;	BLT.S	AD2_WIN_A
;	ADDQ	#1,FLAG2
AD2_WIN_A	CMP	D3,D2
	BGT.S	AD2_WIN_B
;	BLT.S	AD3_WIN_A
;	ADDQ	#1,FLAG3
AD3_WIN_A	MOVE	D3,D4
;	TST	FLAG3
;	BNE.S	OK0
;	TST	FLAG2
;	BNE.S	OK1
;	TST	FLAG1
;	BNE.S	OK2
;	;4 Y EGAUX=> PROB
;	MOVE	#$700,$FFFF8240.W
;	JMP	FIN
;OK2	;D3=D2=D1
;OK1	;D3=D2
;	MOVE	4*3(A0),D6
;	SUB	4*2(A0),D6
;	B
OK0	MOVE	4*3(A0),D5
	RTS
AD2_WIN_B	MOVE	D2,D4
	MOVE	4*2(A0),D5
	RTS
AD0_WIN_B	CMP	D3,D0
	BGT.S	AD0_WIN_C
AD3_WIN_B	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
AD0_WIN_C	MOVE	D0,D4
	MOVE	(A0),D5
	RTS
AD1_WIN_A	CMP	D2,D1
	BGT.S	AD1_WIN_B
AD2_WIN_C	CMP	D3,D2
	BGT.S	AD2_WIN_B
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
AD1_WIN_B	CMP	D3,D1
	BGT.S	AD1_WIN_C
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
AD1_WIN_C	MOVE	D1,D4
	MOVE	4(A0),D5
	RTS


TRIE_MIN	CMP	D0,D1
	BLT.S	D1_WIN_A
D0_WIN_A	CMP	D2,D0
	BLT.S	D0_WIN_B
D2_WIN_A	CMP	D3,D2
	BLT.S	D2_WIN_B
D3_WIN_A	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D2_WIN_B	MOVE	D2,D4
	MOVE	4*2(A0),D5
	RTS
D0_WIN_B	CMP	D3,D0
	BLT.S	D0_WIN_C
D3_WIN_B	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D0_WIN_C	MOVE	D0,D4
	MOVE	(A0),D5
	RTS
D1_WIN_A	CMP	D2,D1
	BLT.S	D1_WIN_B
D2_WIN_C	CMP	D3,D2
	BLT.S	D2_WIN_B
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D1_WIN_B	CMP	D3,D1
	BLT.S	D1_WIN_C
	MOVE	D3,D4
	MOVE	4*3(A0),D5
	RTS
D1_WIN_C	MOVE	D1,D4
	MOVE	4(A0),D5
	RTS

CALCUL	LEA	ADR_RTS,A4
	MOVEQ	#0,D4
	CMP	D0,D2
	BGT.S	D2_P_G
	EXG.L	D0,D2
	BRA	OTHER
D2_P_G	SUB.W	D0,D2	DELTA X
	SUB.W	D1,D3	DELTA Y
	BNE.S	NON_NUL
	RTS
NON_NUL
	MOVE	D2,D4

	ASL	#7,D4	*128
;	EXT.L	D4
	DIVS.W	D3,D4	*X(+1)=(DX/DY)+X
	MOVE	#9,D2
	EXT.L	d4
	ASL.L	D2,D4
	
	ADD	D3,D3
	ADD	D3,D3
	NEG	D3
	SWAP	D4
	
;	ADD	D0,D0
;	ADD	D0,D0
	SUB	D1,D1
	JMP	(A4,D3)

	REPT	401
	MOVE	D0,(A3)+
	ADDX.L	D4,D0
	ENDR
ADR_RTS
	RTS

OTHER	LEA	ADR_RTS2,A4
	SUB.W	D0,D2	DELTA X
	SUB.W	D1,D3	DELTA Y
	BNE.S	NON_NUL2
	RTS
NON_NUL2
	MOVE	D3,D5
	ADD	D5,D5
	ADD	D5,A3
	MOVE	D2,D4
	
	ASL	#7,D4	*128
;	EXT.L	D4
	DIVS.W	D3,D4	*X(+1)=(DX/DY)+X
	MOVE	#9,D2
	EXT.L	d4
	ASL.L	D2,D4
	
	ADD	D3,D3
	ADD	D3,D3
	NEG	D3
	SWAP	D4
	
;	ADD	D0,D0
;	ADD	D0,D0
	SUB	D1,D1
	JMP	(A4,D3)

	REPT	401
	MOVE	D0,-(A3)
	ADDX.L	D4,D0
	ENDR
ADR_RTS2
	RTS

MINI_TABLO	DS.L	8
	DS	200
TAB	DS	200
	DS	200
TAB2	DS	200
	DS	200
TABE	DC.L	$99999999,0,0,0


**
ROUTINE	MOVEM.L	D0-D2/A0-A1,-(SP)
	MOVE.L	SCREEN2,a1
	MOVEQ	#0,D2
	SWAP	D0
	SWAP	D1
	CLR	D0
	CLR	D1
	SWAP	D0
	SWAP	D1

;	MOVE	xp,D0
;	MOVE	yp,d1

	TST	D0
	BGE.S	TOK1
	MOVE	#-1,D1
	MOVEQ	#0,D0
TOK1	CMPI	#320,D0
	BLT.S	TOK2
	MOVE	#-1,D1
	MOVEQ	#0,D0
TOK2
	CMPI	#-1,D1
	BGE.S	TOK3
	MOVE	#-1,D1
	MOVEQ	#0,D0
TOK3	CMPI	#199,D1
	BLE.S	TOK4
	MOVEQ	#0,D1
	MOVE	#-1,D1
TOK4	MULU	#160,D1
	DIVS	#16,D0
	MOVE	D0,D2
	MULU	#8,D2
	ADD.L	D2,D1
	SWAP	D0
	CMPI	#$7,D0
	BGT.S	PLUS_UN
	BRA.S	PLUS_LOIN
PLUS_UN	ADD.L	#1,D1
	SUB.L	#8,D0
PLUS_LOIN
	LEA	KK,A0
	LSL	#3,D0
	JSR	(A0,D0.W)

;	CMPI	#0,ZA
;	BGT.S	PLD
;	BRA.S	NOPLD
;PLD	ADD	#2,D1
;NOPLD	;MOVE	D1,(A2)+

	OR.B	D0,(A1,D1.W)

	MOVEM.L	(SP)+,D0-D2/A0-A1
	RTS

KK	MOVE.B	#%10000000,D0
	NOP
	RTS
	MOVE.B	#%01000000,D0
	NOP
	RTS
	MOVE.B	#%00100000,D0
	NOP
	RTS	
	MOVE.B	#%00010000,D0
	NOP
	RTS	
	MOVE.B	#%00001000,D0
	NOP
	RTS	
	MOVE.B	#%00000100,D0
	NOP
	RTS
	MOVE.B	#%00000010,D0
	NOP
	RTS
	MOVE.B	#%00000001,D0
	NOP
	RTS

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

efecr	
	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	MOVE	#199,D1
JK
N	SET	0
	REPT	20
	MOVE	D0,N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D1,JK
	RTS
	



	******************
	*matrix 3axe(zyx)*
	******************
calcpoint	
	lea.l	tsin(pc),a0
	lea.l	128(a0),a1
ang1	equ	*+2
	move.w	#$1c4,d0
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
	JSR	ROUTINE
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
TABLE_	DS.L	20*16*16
ADR_RET	DS.L	1	*A LAISSER ICI!!! APRES TABLE_!!

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
	dc.w	-80,-80,-80		1
	dc.w	-80,80,-80		2
	dc.w	80,80,-80		3	
	dc.w	80,-80,-80		4
	dc.w	-80,-80,80		5	
	dc.w	-80,80,80		6	
	dc.w	80,80,80		7
	dc.w	80,-80,80		8


TABL	
	REPT	20
;	DC.B	4*14
;	DC	4*15*320	0
	DC	0	1
	DC	4*320	2
	DC	4*2*320	3
	DC	4*3*320	4
	DC	4*4*320
	DC	4*5*320
	DC	4*6*320
	DC	4*7*320
	DC	4*8*320
	DC	4*9*320
	DC	4*10*320
	DC	4*11*320
	DC	4*12*320
	DC	4*13*320
	DC	4*14*320
	DC	4*15*320
	ENDR


TABL2
	REPT	17-1
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

CNT	DC.L	0
TABLO	DCB	20,0
	DC	$9999
TABLO_COPIE	DCB	20,0


	BSS
CODE	DS.B	250000
TABLE	DS.L	20*16*16
	DS.B	256
BUFECR	DS.B	32000
	DS.B	256
BUFECR2	DS.B	32000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
t_points	ds.w	20*2	
