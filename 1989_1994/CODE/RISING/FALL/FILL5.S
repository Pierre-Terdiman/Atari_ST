	LEA	CODE,A0
	BRA	FINI
********************************************************************
	MOVE	#%1000000000000000,D2
	MOVE	#%1000000000000000,D1	D1=MOTIF

	MOVE	D1,D3
DECALE	
	CMPI	#$FFFF,D1
	BNE.S	_OR
	MOVE	#$3081,(A0)+
	BRA.S	SUIT0
_OR	MOVE	#$0050,(A0)+	OR #X,(A0)
	MOVE	D1,(A0)+
SUIT0	MOVE	#$4E75,(A0)+
	ROR	#1,D1
	BGT.S	DECALE
	LSR	#1,D2
	BEQ.S	FINI
	OR	D2,D3
	MOVE	D3,D1
	BRA.S	DECALE
********************************************************************
FINI	NOP	DELTAX =< 16 G�N�R�S...

	MOVE	#$FFFF,D1
	MOVE	#%1000000000000000,D2
	MOVE	#%1000000000000000,D3
	MOVE	#$0008,D7

DECALE2	CMPI	#$FFFF,D1
	BNE.S	_OR1
	MOVE	#$3081,(A0)+
	BRA.S	SUIT1
_OR1	MOVE	#$0050,(A0)+	OR #X,(A0)
	MOVE	D1,(A0)+
SUIT1	
	CMPI	#$FFFF,D2
	BNE.S	_OR1B
	MOVE	#$3141,(A0)+
	MOVE	D7,(A0)+
	BRA.S	SUIT1B
_OR1B	MOVE	#$0068,(A0)+
	MOVE	D2,(A0)+
	MOVE	D7,(A0)+
SUIT1B	MOVE	#$4E75,(A0)+
	LSR	#1,D1
	BEQ.S	FINI2
	LSR	#1,D2
	OR	D3,D2
	BRA.S	DECALE2
FINI2	NOP
	BSS
CODE	DS.B	300000