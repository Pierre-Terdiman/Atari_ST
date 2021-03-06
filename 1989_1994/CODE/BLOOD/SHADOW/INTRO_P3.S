	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ	#6,SP
	
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

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#32000,D0
	MOVE.L	D0,SCREEN2
	
	MOVE.B	SCREEN2+1,$FFFF8201.W
	MOVE.B	SCREEN2+2,$FFFF8203.W

	MOVEM.L	ETAP2+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
LOOP
	MOVE.L	SCREEN2,A0
	LEA	ETAP2+34,A1
	MOVE	#7999,D7
COPIMG	MOVE.L	(A1)+,(A0)+
	DBF	D7,COPIMG
	
	MOVE.L	MODMOT,SAVE

	LEA	CRB,A4
	MOVE.L	SCREEN2,A1
	LEA	14*160+64(A1),A1
	MOVE.L	A1,A2
	MOVE	#146-1,D7
	MOVEQ	#0,D6
AFF_IMG
	LEA	MOTIFS,A6
MODMOT	EQU	*+2
	LEA	4*14(A6),A6
	LEA	TABLE_IMG,A5	13 PIX A ECRIRE/LIGNE
	REPT	13+3
	MOVE.L	(A5)+,A0
	MOVE	(A6)+,D0
	MOVE	(A6)+,D2	OFFSET
	ADD.L	D6,A0
	MOVE	(A0,D2.W),D1
	AND	D0,D1
	OR	D1,(A1,D2.W)
	MOVE	2(A0,D2.W),D1
	AND	D0,D1
	OR	D1,2(A1,D2.W)
	MOVE	4(A0,D2.W),D1
	AND	D0,D1
	OR	D1,4(A1,D2.W)
	MOVE	6(A0,D2.W),D1
	AND	D0,D1
	OR	D1,6(A1,D2.W)
	ADDQ	#8,A0
	ENDR
	ADD.L	#160,D6
	LEA	160(A2),A2
	MOVE.L	A2,A1
	MOVE	(A4)+,D0
	ADD	D0,MODMOT
	DBF	D7,AFF_IMG
	
SAVE	EQU	*+2
	MOVE.L	#0,MODMOT
	
	;MOVE	#7,-(SP)
	;TRAP	#1
	;ADDQ	#2,SP
	ADDQ	#4,MODMOT

	MOVE.L	SCREEN2,A1
	LEA	14*160+64(A1),A1
	LEA	BUF,A0
MOD_BUF	EQU	*+2
	ADDA.L	#0,A0
	MOVE	#146-1,D7
PREC	MOVEM.L	(A1),D0-D6/A2
	MOVEM.L	D0-D6/A2,(A0)
	LEA	160(A1),A1
	LEA	32(A0),A0
	DBF	D7,PREC
	ADD.L	#146*32,MOD_BUF
	CMPI.L	#146*32*79,MOD_BUF
	BEQ.S	SUITE
	JMP	LOOP
SUITE	
	MOVE.L	SCREEN2,A0
	MOVE.L	SCREEN1,A2
	LEA	ETAP2+34,A1
	MOVE	#7999,D7
COPIMGU	MOVE.L	(A1),(A0)+
	MOVE.L	(A1)+,(A2)+
	DBF	D7,COPIMGU

	MOVE.L	#VBL,$70.W
B	BRA.S	B
VBL
	MOVE.L	SCREEN2,A1
	LEA	14*160+64(A1),A1
	LEA	BUF,A0
MOD_BUF2	EQU	*+2
	ADDA.L	#0,A0
	MOVE	#146-1,D7
.PREC	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,(A1)
	LEA	160(A1),A1
	DBF	D7,.PREC
	ADD.L	#146*32,MOD_BUF2
	CMPI.L	#146*32*79,MOD_BUF2
	BNE.S	.ROOL
	CLR.L	MOD_BUF2
.ROOL	
	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN2+1,$FFFF8201.W
	MOVE.B	SCREEN2+2,$FFFF8203.W
	
	RTE

FIN	MOVE.L	4.W,A0
	JMP	(A0)

	DATA
ETAP2	INCBIN	ETAP2.PI1
PERSOS1	INCBIN	PERSO1.PI1
PERSOS2	INCBIN	PERSO2.PI1

TABLE_IMG	
	DC.L	PERSOS2+34+32
	DC.L	PERSOS2+34
	DC.L	PERSOS1+34+32*4
	DC.L	PERSOS1+34+32*3
	DC.L	PERSOS1+34+32*2
	DC.L	PERSOS1+34+32

	DC.L	PERSOS1+34
	DC.L	PERSOS1+34
	DC.L	PERSOS1+34
	DC.L	PERSOS1+34

	DC.L	PERSOS1+34+32
	DC.L	PERSOS1+34+32*2
	DC.L	PERSOS1+34+32*3
	DC.L	PERSOS1+34+32*4
	DC.L	PERSOS2+34
	DC.L	PERSOS2+34+32

MOTIFS	
N	SET	-3*8
	REPT	23
	DC	$8000,N
	DC	$4000,N
	DC	$2000,N
	DC	$1000,N

	DC	$800,N
	DC	$400,N
	DC	$200,N
	DC	$100,N

	DC	$80,N
	DC	$40,N
	DC	$20,N
	DC	$10,N

	DC	$8,N
	DC	$4,N
	DC	$2,N
	DC	$1,N
N	SET	N+8
	ENDR

CRB	
	REPT	37
	DC	0
	DC	0
	DC	0
	DC	4
	ENDR

	BSS
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	64000
BUF	DS.B	80*32*146