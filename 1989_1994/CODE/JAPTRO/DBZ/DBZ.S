DEBUT:	
	LEA.L 	D_PILE,A7
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	
	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	CLR.W 	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP

	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1		
	add.l	#64000,d0		
	move.l	d0,SCREEN2

	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	JSR	PRO
******
	LEA	PART1+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160(A1),A1
	MOVE	#127,D7
AFF_Y	MOVE	#(112/4)-1,D6
AFF_X	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y
******
	LEA	PART2+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160+112(A1),A1
	MOVE	#127,D7
AFF_Y2	MOVE	#(112/4)-1,D6
AFF_X2	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X2
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y2
******
	LEA	PART3+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160(A1),A1
	LEA	230*100(A1),A1
	LEA	230*28(A1),A1
	MOVE	#127,D7
AFF_Y3	MOVE	#(112/4)-1,D6
AFF_X3	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X3
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y3
******
	LEA	PART4+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160+112(A1),A1
	LEA	230*100(A1),A1
	LEA	230*28(A1),A1
	MOVE	#127,D7
AFF_Y4	MOVE	#(112/4)-1,D6
AFF_X4	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X4
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y4
******
	MOVE.L	#VBLR_IR,$70.W
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	BRA.S	BOUCLE
VBLR_IR
	CLR.B	$FFFFFA1B.W
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVEM.L	PART1+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W
	LEA	DEGRADE,A0
INTER_RTE	RTE

INTER_TMA:	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR
full
	LEA	$FFFF8209.W,A3
	LEA	$FFFF8260.W,A6
	LEA	$FFFF820A.W,A5

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100

	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D2
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D0,(A5)
	REPT	6
	NOP
	ENDR
	MOVE.B	D1,(A5)

*******
	LEA	$FFFF8209.W,A6
	LEA	$FFFF8260.W,A4
	LEA	$FFFF820A.W,A3
	MOVEQ	#0,D1		
	MOVEQ	#$10,D6
	MOVE.L	#(226/2)-1,D0

SYNCHRO	MOVE.B	(A6),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		
	DCB	97-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-1-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	
FULLSCREEN	NOP
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
*
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4-4,$4E71
	MOVE	(A0)+,$FFFF8252.W

	DBF	D0,FULLSCREEN

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	;	ICI=116	NOPS

	CLR.B	$FFFF820A.W 
	DCB	8-4,$4E71
	MOVE	(A0)+,$FFFF8252.W

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	MOVE	A4,(A3)
	DCB	88-2,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	
	REPT	42
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	ENDR
SUITE
;OKAY	move.l	SCREEN1,d0
;	move.l	SCREEN2,SCREEN1		
;	move.l	d0,SCREEN2

	move.l	SCREEN1,d0
	ADD.L	D1,D0
	lsr.l	#8,d0
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
	JSR	PRO
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
Y_VALUE	DC.L	0

TB0_IR	RTE

FIN:	MOVE.L	4.W,A0
	JMP	(A0)

PRO	MOVEM.L	D0/A0-A1,-(SP)
	LEA	BUF,A0
	LEA	BUF2,A1
PT_Y	EQU	*+2
	LEA	0(A1),A1
	MOVE	#(84+14)-1,D0
COPC	MOVE	(A1)+,(A0)+
	DBF	D0,COPC
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO3B
	ADDQ	#2,PT_Y
NO3B	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	NO3C
	SUBQ	#2,PT_Y
NO3C	MOVEM.L	(SP)+,D0/A0-A1
	RTS

	DATA
PART1	INCBIN	COL1.PI1
PART2	INCBIN	COL2b.PI1
PART3	INCBIN	COL3.PI1
PART4	INCBIN	COL4.PI1

DEGRADE	
;;DC $010,$010,$020,$020,$030,$030,$040,$040,$050,$050,$060,$060,$070,$070
; DC $001,$002,$101,$101,$101,$202,$202,$202,$303,$303,$303,$404,$404,$404,$505,$505,$505,$606,$606,$606
 
;;DC $071,$071,$072,$072,$073,$073,$074,$074,$075,$075,$076,$076,$077,$077
; DC $707,$707,$707,$717,$717,$717,$727,$727,$727,$737,$737,$737,$747,$747,$747,$757,$757,$757,$767,$767,$767,$767

;;DC $177,$177,$277,$277,$377,$377,$477,$477,$577,$577,$677,$677,$777,$777
BUF	DS	84+14
	DCB	2,$101
	DC	$101,$101,$202,$202,$202,$202,$303,$303,$303,$303,$404,$404,$404,$404
	DCB	4*2,$403
	DC	$303,$303,$203,$203,$103,$103,$102,$102,$101,$101,$001,$001
	DC	$101,$101,$102,$102,$103,$103,$203,$203,$303,$303
	DCB	30*2,$403
	DC	$404,$404,$405,$405,$406,$406,$407,$407,$406,$406,$405,$405,$404,$404
	DCB	256,$403

BUF2

 DCB	2,$100
 DC	$200
 DC	$100

 DCB	2,$200
 DC	$300
 DC	$200

 DCB	2,$300
 DC	$400
 DC	$300

 DCB	2,$400
 DC	$500
 DC	$400

 DCB	2,$500
 DC	$600
 DC	$500

 DCB	2,$600
 DC	$700
 DC	$600

 DCB	2,$700
 DC	$710
 DC	$700

 DCB	2,$710
 DC	$720
 DC	$710

 DCB	2,$720
 DC	$730
 DC	$720

 DCB	2,$730
 DC	$740
 DC	$730

 DCB	2,$740
 DC	$750
 DC	$740

 DCB	2,$750
 DC	$760
 DC	$750

 DCB	2,$760
 DC	$770
 DC	$760

 DCB	2,$770
 DC	$771
 DC	$770

 DCB	2,$771
 DC	$772
 DC	$771

 DCB	2,$772
 DC	$773
 DC	$772

 DCB	2,$773
 DC	$774
 DC	$773

 DCB	2,$774
 DC	$775
 DC	$774

 DCB	2,$775
 DC	$776
 DC	$775

 DCB	2,$776
 DC	$777
 DC	$776

 DCB	2,$777
 DC	$767
 DC	$777

 DCB	2,$767
 DC	$757
 DC	$767

 DCB	2,$757
 DC	$747
 DC	$757

 DCB	2,$747
 DC	$737
 DC	$747

 DCB	2,$737
 DC	$727
 DC	$737
 DCB	2,$727
 DC	$717
 DC	$727
 DCB	2,$717
 DC	$707
 DC	$717
 DCB	2,$707
 DC	$706
 DC	$707
 DCB	2,$706
 DC	$705
 DC	$706
 DCB	2,$705
 DC	$704
 DC	$705
 DCB	2,$704
 DC	$703
 DC	$704
 DCB	2,$703
 DC	$702
 DC	$703
 DCB	2,$702
 DC	$701
 DC	$702
 DCB	2,$701
 DC	$700
 DC	$701
 DCB	2,$700
 DC	$600
 DC	$700
 DCB	2,$600
 DC	$500
 DC	$600
 DCB	2,$500
 DC	$400
 DC	$500
 DCB	2,$400
 DC	$300
 DC	$400
 DCB	2,$300
	DCB	7*2,$777
	

 	SECTION BSS

F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	64000*2
			