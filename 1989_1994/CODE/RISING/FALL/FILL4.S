;	LIST
;	OR	D0,(A0)	8150
;N	SET	8
;	REPT	18
;	MOVE	D1,N(A0)	3141
;N	SET	N+8
;	ENDR
;	OR	D2,N(A0)	8568
;	RTS

	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
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
	
	LEA	CODE,A0
	LEA	TABLE,A1


	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEQ	#0,D3
	
	MOVE	#%1111111111111111,D6
	MOVE	#%1111111111111111,D2
	
	MOVE	#%1000000000000000,D3
	MOVE	#%0000000000000000,D7

D3_NON_NUL	OR	D3,D7
	AND	D2,D6
	MOVE.L	A0,(A1)+
	MOVE.L	#8,D0
;	MOVE	#$C440,(A0)+
;	MOVE	#$8550,(A0)+
	MOVE	#$0050,(A0)+
	MOVE	D6,D5
	AND	D7,D5
	MOVE	D5,(A0)+
	MOVE	#$4E75,(A0)+	1ERE ROUT - 1 OR UNIQUE

	MOVE.L	A0,(A1)+
	MOVE.L	#8,D0
;	MOVE	#$8150,(A0)+
;	MOVE	#$8568,(A0)+
	MOVE	#$0050,(A0)+
	MOVE	D6,(A0)+
	MOVE	#$0068,(A0)+
	MOVE	D7,(A0)+
	MOVE	D0,(A0)+
	MOVE	#$4E75,(A0)+	2EME ROUT - 2 ORS ONLY


	MOVE	#17,D5
	MOVE	#-1,D4
DOCODE	
	MOVE.L	A0,(A1)+

	MOVE.L	#8,D0
	ADDQ	#1,D4
	MOVE	D4,D1
	MOVE	#$0050,(A0)+
	MOVE	D6,(A0)+
DOMOVE	MOVE	#$3141,(A0)+
	MOVE	D0,(A0)+
	ADDQ	#8,D0
	DBF	D1,DOMOVE
	MOVE	#$0068,(A0)+
	MOVE	D7,(A0)+
	MOVE	D0,(A0)+
	MOVE	#$4E75,(A0)+
	DBF	D5,DOCODE	;GENERATION TERMINEE
			;POUR *UNE* VALEUR
			;DE D6/D7

	LSR	#1,D3
	BNE.S	D3_NON_NUL
	MOVE	#%1000000000000000,D3
	LSR	#1,D2
	BNE.S	D3_NON_NUL
	NOP

	MOVE.L	#VBL,$70.W
H	BRA.S	H
FIN	MOVE.L	4.W,A0
	JMP	(A0)
VBL	SF	$FFFF8240.W
	ST	$FFFF8242.W
	MOVE.L	$44E.W,A6
	moveq	#0,d0
	MOVE	#0,D1
EFF
N	SET	0
	REPT	20
	MOVE	D0,N(A6)
N	SET	N+8
	ENDR
	LEA	160(A6),A6
	DBF	D1,EFF
	MOVE.L	$44E.W,A0

	MOVE.L	#$FFFFFFFF,D1
	LEA	TABLE,A6
MD	EQU	*+2
	LEA	0(A6),A6
	TST.L	(A6)
	BNE.S	OK
	CLR	MD
	LEA	TABLE,A6
OK	MOVE.L	(A6),A1
	JSR	(A1)
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	J
	ADDQ	#4,MD
J	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	J2
	SUBQ	#4,MD
J2
	RTE

	LEA	TABLE1,A2
	LEA	TABLE2,A3
	MOVE.L	#$FFFFFFFF,D1
	MOVE	#199,D3
ICI	MOVE.L	A6,A0
	LEA	TABLE,A4
MOD2	EQU	*+2
	MOVE	#1,D6
;	MOVE	#1,D6
	MOVE	D6,D5
MOD	EQU	*+2
	MOVE	#16,D7
	MOVE	D7,D4
	
	LSR	#4,D7
	LSR	#4,D6
	SUB	D6,D7	DELTA X
;	LSR	#4,D7	D7=>DETERMINE ROUT A APPELER
	LSL	#2,D7

;	SUBQ	#1,D5
	ADD	D5,D5	x3*4 ( x3<x1 )
	ADD	D5,D5
	MOVE	(A2,D5.W),D0	motif
	ADD	2(A2,D5.W),A0
;	SUBQ	#1,D4
	ADD	D4,D4	x1*4 ( ancien x )
	ADD	D4,D4
	MOVE	(A3,D4.W),D2	motif

	MOVE.L	(A4,D7.W),A4
	JSR	(A4)
	LEA	160(A6),A6
	DBF	D3,ICI

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_T
	ST	$FFFF8240.W
NO_T	NOP
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO_T2
	ADDQ	#1,MOD
NO_T2	NOP
	CMPI.B	#$3c,$FFFFFC02.W
	BNE.S	NO_T2c
	ADDQ	#1,MOD2
NO_T2c	NOP
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


	BSS

	DS.L	1
TABLE	DS.L	20*16*16
	DS.L	1
CODE	DS.B	300000