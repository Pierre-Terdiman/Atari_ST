	PEA	0
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP

	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	CLR.L	LIGNE
	
	MOVE.L	#32,LIGNE2
	
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#64000,D0
	MOVE.L	D0,SCREEN2
	
	MOVE.B	#$12,$FFFFFC02.W
	DC.W	$A00A

	MOVE.L	$44E.W,A0
	MOVE.L	#7999,D0
EFF_SCR	CLR.L	(A0)+
	DBRA	D0,EFF_SCR

	ANDI.B	#%11111000,$484.W

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W

BOUCLE	JMP	BOUCLE

FIN	MOVE.L	ANC_VBL,$70.W

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W

	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	
	
VBLR	MOVEQ	#0,D0
	LEA	Z_DAT,A0
	ADDA.L	CNT2,A0
	CMPI.L	#-1,(A0)
	BNE.S	NO_PB
	CLR.L	CNT2
	LEA	Z_DAT,A0
NO_PB	MOVE	(A0),D0
	MOVE.L	D0,LIGNE

	MOVE	(A0),D0
	DIVU	#160,D0
	MOVE.L	D0,LIGNE2
	
	CMPI.B	#$3B,$FFFFFC02.W
	BEQ.S	K
	ADDQ.L	#2,CNT2
K	
	lea	z,a0

	LEA	IMG,A1
	ADDA.L	LIGNE,A1
	
	REPT	7
	MOVE	(A1),(A0)+
	LEA	8(A1),A1
	MOVE	(A1),(A0)+
	LEA	8(A1),A1
	endr

	LEA	IMG2,A1
	ADDA.L	LIGNE,A1
	
	REPT	7
	MOVE	(A1),(A0)+
	LEA	8(A1),A1
	MOVE	(A1),(A0)+
	LEA	8(A1),A1
	endr
	
NO_ZOOM2
	MOVE	#$000,$FFFF8242.W
	MOVE	#$200,$FFFF8244.W
	MOVE	#$400,$FFFF8248.W
	MOVE	#$000,$FFFF8250.W
	
	
	
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	MOVEQ.L	#0,D7
	MOVEQ	#0,D4
	MOVE.L	#230/2,D5
	LEA	BUFFER_,A6
	LEA	BUFFER_,A1
	LEA	115*2(A6),A6
	LEA	115*2(A1),A1
	LEA	BUFFER2,A5
	LEA	BUFFER2,A2
	LEA	115*2(A5),A5
	LEA	115*2(A2),A2
	
	LEA	PALETTE2,A0
	MOVE.L	LIGNE2,D6
	SUBQ.L	#1,D6
OP	MOVE.L	D6,D0
	MOVE.L	D6,D1
REMPLIT_BUF	MOVE	(A0),(A6)+
	MOVE	D4,-(A1)
	MOVE	D4,(A5)+
	MOVE	(A0),-(A2)
	ADDQ.L	#1,D7
	CMP.L	D5,D7
	BEQ.S	OK
	DBF	D0,REMPLIT_BUF
	
	LEA	2(A0),A0
	EXG.L	A6,A5
	EXG.L	A1,A2
	BRA.S	OP
OK	

	LEA	BUFFER_,A6
	LEA	BUFFER2,A5

CA_ROULE	MOVE.L	A6,USP
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	full
	ST	$FFFF8240.W
	
full	
	MOVE.L	#$FFFF8209,A6
	MOVE.L	#$FFFF8260,A4
	MOVE.L	#$FFFF820A,A3
	MOVEQ	#0,D1		
	MOVEQ	#$10,D6
	MOVE	#$2700,SR

SYNCHRO	MOVE.B	(A6),D7     * SYNCHRO
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	DCB	97-5-2-1,$4E71
	move.l	SCREEN2,a0	5
	LEA	160(A0),A0	2
	MOVE.L	USP,A6
FULLSCREEN
	rept	198
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	MOVE	(a6),$ffff8250.W
	MOVE	(a6)+,$ffff8242.W		
	MOVE	(a5)+,$FFFF8240.W		

	lea	z,a1	3

n	set	6
	
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16	
	move.l	(a1)+,n(a0)	6
n	set	n+16		
	DCB	88-3-6*12-12,$4E71
	
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)


	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16


	DCB	13-12,$4E71
	
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)

	DCB	12-2,$4E71
	LEA	230(A0),A0
	ENDR

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	MOVE	(a6),$ffff8250.W
	MOVE	(a6)+,$ffff8242.W		
	MOVE	(a5)+,$FFFF8240.W		

	lea	z,a1	3

n	set	6
	rept	12
	move.l	(a1)+,n(a0)	6
n	set	n+16
	endr
		
	DCB	88-3-6*12-12,$4E71
	
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)

	rept	2
	move.l	(a1)+,n(a0)	6
n	set	n+16
	endr

	DCB	13-12,$4E71
	
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)

	CLR.B	$FFFF820A.W 
	DCB	12-2-4,$4E71
	LEA	230(A0),A0

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	MOVE	(a6),$ffff8250.W
	MOVE.B	#2,$FFFF820A.W
	MOVE	(a6)+,$ffff8242.W		
	MOVE	(a5)+,$FFFF8240.W		

	lea	z,a1	3

n	set	6
	rept	11
	move.l	(a1)+,n(a0)	6
n	set	n+16
	endr
		
	DCB	88-3-6*11-12-4,$4E71
	
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)

	rept	2
	move.l	(a1)+,n(a0)	6
n	set	n+16
	endr

	DCB	13-12,$4E71
	
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	move.l	(a1)+,n(a0)	6
n	set	n+16

	DCB	12-2-6,$4E71
	LEA	230(A0),A0


	rept	30
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	MOVE	(a6),$ffff8250.W
	MOVE	(a6)+,$ffff8242.W		
	MOVE	(a5)+,$FFFF8240.W		

	lea	z,a1	3

n	set	6

	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

	move.l	(a1)+,n(a0)	6
n	set	n+16

		
	DCB	88-3-6*12-12,$4E71
	
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)


	move.l	(a1)+,n(a0)	6
n	set	n+16
	move.l	(a1)+,n(a0)	6
n	set	n+16


	DCB	13-12,$4E71
	
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)

	DCB	12-2,$4E71
	LEA	230(A0),A0
	ENDR


	
	SF	$FFFF8240.W




	CMPI.B	#$39,$FFFFFC02.W
 	BEQ	FIN
	RTE

	DATA
IMG	INCBIN	ZOOM.DAT
IMG2	INCBIN	ZOOM2.DAT

PALETTE2
	REPT	8
	DC.W	$100,$200,$300,$400,$500,$600,$700
	DC.W	$710,$720,$730,$740,$750,$760,$770
	DC.W	$771,$772,$773,$774,$775,$776,$777
	DC.W	$677,$577,$477,$377,$277,$177,$077
	DC.W	$066,$055,$044,$033,$022,$011,$001,$001
	ENDR
Z_DAT
n	set	145
	rept	140
	dc	n*160
n	set	n-1
	endr
	
	rept	140
	dc	n*160
n	set	n+1
	endr
	DC.L	-1
		
	SECTION	BSS
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
LIGNE	DS.L	1
LIGNE2	DS.L	1
CNT	DS.L	1
CNT2	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	64000*2
POINT2	DS.L	1
BUFFER_	DS	230
BUFFER2	DS	230
z	ds.l	7*2
