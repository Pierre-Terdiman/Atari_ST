	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W


	CLR	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE	#5,-(SP)
	TRAP	#14
	ADDA.L	#12,SP

	
	
	MOVE.L	$70.W,SAVEVBL
	MOVE.L	#VBL,$70.W
	
LOOP	JMP	LOOP


VBL	

	MOVEM.L	DATA+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	PNT2,PNT	

	LEA	TUB,A2
	LEA	$F8000,A0
	MOVE	#99,D1
L	LEA	DATA+34,A1
	ADDA.L	PNT,A1
	ADD	(A2)+,A1
	MOVE.L	#39,D0
ICI	MOVE.L	(A1)+,(A0)+
	DBF	D0,ICI
	ADD.L	#160,PNT
	DBF	D1,L

	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	O
	ADD.L	#160,PNT2
O

	CLR	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	RTE
	
	
	
FIN	MOVE.L	SAVEVBL,$70.W
	move	#$777,$ffff8240.w
	clr	$ffff8242.w
	CLR.L	-(SP)
	TRAP	#1	


	SECTION	DATA

DATA	INCBIN	OVERSCA2.PI1
	
	
PALETTE	

	DC	$000,$100,$200,$300,$400,$500,$600,$700
	DC	$710,$720,$730,$740,$750,$760
	DC	$761,$762


	DCB	200,$763
TUB
 dc 800
 dc 800
 dc 800
 dc 800
 dc 800
 dc 800
 dc 800
 dc 640
 dc 640
 dc 640
 dc 640
 dc 640
 dc 640
 dc 640
 dc 480
 dc 480
 dc 480
 dc 480
 dc 480
 dc 480
 dc 480
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 0
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 160
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 320
 dc 480
 dc 480
 dc 480
 dc 480
 dc 480
 dc 480
 dc 480
 dc 640
 dc 640
 dc 640
 dc 640
 dc 640
 dc 640
 dc 640
 dc 800
 dc 800
 dc 800
 dc 800
 dc 800
 dc 800
	
	SECTION	BSS
SAVEVBL	DS.L	1
PNT	DS.L	1
PNT2	DS.L	1
