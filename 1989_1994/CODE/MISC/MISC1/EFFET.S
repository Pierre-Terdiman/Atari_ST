	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE	#5,-(SP)
	TRAP	#14
	ADDA.L	#12,SP
	CLR.L	VALUE_X
	CLR.L	VALUE_Y
	
	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,SAVE_PAL

	MOVEM.L	CAMEO+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.L	$70.W,VBS
	
	MOVEA.L	$44E.W,A1
	LEA	CAMEO+34,A0
	MOVE.L	#7999,D0
COPY	MOVE.L	(A0)+,(A1)+
	DBF	D0,COPY
	MOVE.L	#0,D6
	MOVE	#0,D5
	LEA	GFX,A1
	MOVEM.L	D0-A6,SAVE
	MOVE.L	VALUE_X,SAV_X
	MOVE.L	VALUE_Y,SAV_Y
	MOVE.L	#VBL,$70.W

J	JMP	J



FIN	MOVE.L	VBS,$70.W
	MOVEM.L	SAVE_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	CLR.L	-(SP)
	TRAP	#1

VBL	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	BB
	ST	$FFFF8240.W
BB	MOVEM.L	SAVE,D0-A6
	CLR.L	VALUE_X2
	CLR.L	VALUE_Y2
	MOVE.L	SAV_X,VALUE_X
	MOVE.L	SAV_Y,VALUE_Y
	REPT	2
	JSR	ROUTINE
	JSR	GERE_X2
	ENDR
	
	SF	$FFFF8240.W
	MOVEM.L	D0-A6,SAVE
	MOVE.L	VALUE_X,SAV_X
	MOVE.L	VALUE_Y,SAV_Y

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
GERE_X2
	ADD.L	#8,VALUE_X2
	CMPI.L	#8*20,VALUE_X2
	BNE.S	RET
	CLR.L	VALUE_X2
	ADD.L	#16*160,VALUE_Y2
RET	RTS
ROUTINE
	MOVE	(A1)+,D0
	MOVE	D5,D7
	MOVEA.L	$44E.W,A0
	LEA	160*10(A0),A0
	ADDA.L	VALUE_X,A0
	ADDA.L	VALUE_X2,A0
	ADDA.L	VALUE_Y,A0
	ADDA.L	VALUE_Y2,A0
	MOVE	D5,D4
	MULU	#80,D4
	SUB.L	D4,A0
	
LIGNE	AND	D0,(A0)
	AND	D0,2(A0)
	AND	D0,4(A0)
	AND	D0,6(A0)
	LEA	160(A0),A0
	DBF	D7,LIGNE
	ADDQ.L	#2,D5
;	DBF	D6,BB
	ADDQ.L	#1,D6
	CMPI.L	#9,D6
	BNE.S	LP
	ADD.L	#8,VALUE_X
	CMP.L	#8*20,VALUE_X
	BNE.S	OK
	ADD.L	#160*16,VALUE_Y
	CLR.L	VALUE_X
OK	CLR.L	D6
	MOVE	#0,D5
	LEA	GFX,A1
	
LP	RTS

GFX	DC	%1111111111111111
	DC	%1111111001111111
	DC	%1111110000111111
	DC	%1111100000011111
	DC	%1111000000001111
	DC	%1110000000000111
	DC	%1100000000000011
	DC	%1000000000000001
	DC	%0000000000000000

		
CAMEO	INCBIN	OVERSCA2.PI1

	
	BSS
SAVE_PAL	DS.L	8
VBS	DS.L	1
VALUE_X	DS.L	1
VALUE_X2	DS.L	1
VALUE_Y	DS.L	1
VALUE_Y2	DS.L	1
SAVE	DS.L	16
SAV_X	DS.L	1
SAV_Y	DS.L	1
