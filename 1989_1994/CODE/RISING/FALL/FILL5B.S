	LEA	CODE,A0
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
	BEQ.S	G�N�R�
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
	MOVE	#$0068,(A0)+
	MOVE	D0,(A0)+
	MOVE	D7,(A0)+
	ADDQ	#8,D7
	BRA.S	SUIT0
DEB_LINE	MOVE	#$0050,(A0)+
	MOVE	D0,(A0)+
	ADDQ	#8,D7

SUIT0	BRA.S	VIDE
	
G�N�R�	MOVE	#$4E75,(A0)+
	LEA	TABLO,A6
	ROXR	(A6)
	ROXR	2(A6)
	ROXR	4(A6)
	ROXR	6(A6)
	ROXR	8(A6)
	ROXR	10(A6)
	ROXR	12(A6)
	ROXR	14(A6)
	ROXR	16(A6)
	ROXR	18(A6)

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
	CMPI	#20,MODX
	BEQ.S	FINITO
	BRA	ANEW
	
FINITO	NOP
	
CNT	DC.L	0
TABLO	DCB	20,0
	DC	$9999
TABLO_COPIE	DCB	20,0
	BSS
CODE	DS.B	70000