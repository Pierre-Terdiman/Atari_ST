PLAY_B	MACRO
	MOVEQ	#0,D0	;1
	MOVE.B	(A0)+,D0	;2
	LSL.W	#3,D0	;3
	MOVE.L	0(A2,D0.W),D1	;5
	MOVE.W	4(A2,D0.W),D2	;4
	MOVEP.L	D1,(A1)	;6
	MOVEP.W	D2,(A1)	;4     ;=25 NOPS
	ENDM

DEBUT:	
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP

	LEA	D_PILE,A7

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	LEA	DATA_HS,A0
	MOVE.L	A0,POIT
		
;	CLR.W 	-(SP)
;	PEA	-1.W
;	PEA	-1.W
;	MOVE 	#5,-(SP)
;	TRAP 	#14
;	LEA.L 	12(SP),SP

	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1		
;	add.l	#64000,d0		
;	move.l	d0,SCREEN2

	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

******
	JSR	INIT_SAMPLE

	MOVE.L	#VBLR_IR,$70.W
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	BRA.S	BOUCLE

VBLR_IR
	CLR.B	$FFFFFA1B.W
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVE.L	D3,A3
	MOVE.L	D3,A4
	MOVE.L	D3,A5
	MOVEM.L	D3-D7/A3-A5,$FFFF8240.W
	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W
***
	CMPA.L	#TEST_FIN1,A0
	BLE.S	.NO
	MOVE.L	BEAT1,A0
.NO	
	MOVE.W	#$8800,A1
	LEA	CODE,A2
***
	LEA	FAD,A6
MODFAD	EQU	*+2
	LEA	0(A6),A6
	CMPI	#-1,(A6)
	BNE.S	.O
	LEA	-32(A6),A6
	BRA.S	.NON
.O	SUBQ	#1,PNTFAD
	BNE.S	.NON
	MOVE	#5,PNTFAD
	ADD	#32,MODFAD
.NON
	MOVE.L	A6,SAVEA6
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71
	PLAY_B
	DCB	128+128-27,$4E71

INTER_RTE	RTE
PNTFAD	DC	5
SAVEA6	DC.L	0
INTER_TMA:	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR
full
	LEA	$FFFF8209,A3
	LEA	$FFFF8260,A6
	LEA	$FFFF820A,A5

	MOVEQ	#2,D6

	STOP	#$2100
	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D5
SYNCHROA:	DBF	D5,SYNCHROA
	MOVEQ	#0,D5

	MOVE.B	D5,(A5)
	REPT	6
	NOP
	ENDR
	MOVE.B	D6,(A5)

*******

	MOVEA.L	POIT,A6

	LEA	$FFFF8209.W,A4
	LEA	$FFFF820A.W,A3

	MOVEQ	#0,D7
	MOVEQ	#0,D5
	MOVEQ	#$10,D6
	MOVE.L	#(216/2)-1,D4

SYNCHRO	MOVE.B	(A4),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6
	LSL.W	D6,D5
	LEA	$FFFF8260.W,A4
	DCB	97-3-4-2-27,$4E71
	PLAY_B

	REPT	9
	MOVE.L	(A6)+,A5	*3
	JSR	(A5)	*4
	ENDR

	DCB	7-1-5,$4E71
	MOVEQ	#(48/2)-1,D5
	MOVE.L	SAVEA6,A6

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	;PLAY_B
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13-12,$4E71
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-6,$4E71
	MOVE.L	(A6)+,$FFFF8248.W	6

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88-5*6-2-27,$4E71
	PLAY_B
	MOVE.L	(A6)+,$FFFF824C.W
	MOVE.L	(A6)+,$FFFF8250.W
	MOVE.L	(A6)+,$FFFF8254.W
	MOVE.L	(A6)+,$FFFF8258.W
	MOVE.L	(A6)+,$FFFF825C.W
	LEA	-32(A6),A6
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-1,$4E71

FULLSCREEN	NOP
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	PLAY_B
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE.L	(A6)+,$FFFF8248.W	6
	MOVE.L	(A6)+,$FFFF824C.W	6
	MOVE.L	(A6)+,$FFFF8250.W	6
	MOVE.L	(A6)+,$FFFF8254.W	6
	MOVE.L	(A6)+,$FFFF8258.W	6
	MOVE.L	(A6)+,$FFFF825C.W	6
	LEA	-32(A6),A6
	DCB	88-6*8-2-27,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12,$4E71

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE.L	(A6)+,$FFFF8248.W	6
	MOVE.L	(A6)+,$FFFF824C.W	6
	MOVE.L	(A6)+,$FFFF8250.W	6
	MOVE.L	(A6)+,$FFFF8254.W	6
	MOVE.L	(A6)+,$FFFF8258.W	6
	MOVE.L	(A6)+,$FFFF825C.W	6
	LEA	-32(A6),A6
	DCB	88-6*8-2,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71

	DBF	D4,FULLSCREEN

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	PLAY_B
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE.L	(A6)+,$FFFF8248.W	6
	MOVE.L	(A6)+,$FFFF824C.W	6
	MOVE.L	(A6)+,$FFFF8250.W	6
	MOVE.L	(A6)+,$FFFF8254.W	6
	MOVE.L	(A6)+,$FFFF8258.W	6
	MOVE.L	(A6)+,$FFFF825C.W	6
	LEA	-32(A6),A6
	DCB	88-48-2-27,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	;	ICI=116	NOPS

	CLR.B	$FFFF820A.W 
	DCB	8,$4E71

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	MOVE	A4,(A3)
	;PLAY_B
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE.L	(A6)+,$FFFF8248.W	6
	MOVE.L	(A6)+,$FFFF824C.W	6
	MOVE.L	(A6)+,$FFFF8250.W	6
	MOVE.L	(A6)+,$FFFF8254.W	6
	MOVE.L	(A6)+,$FFFF8258.W	6
	MOVE.L	(A6)+,$FFFF825C.W	6
	LEA	-32(A6),A6
	DCB	88-2-48-2,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-1,$4E71
	
.F	NOP
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	PLAY_B
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE.L	(A6)+,$FFFF8248.W	6
	MOVE.L	(A6)+,$FFFF824C.W	6
	MOVE.L	(A6)+,$FFFF8250.W	6
	MOVE.L	(A6)+,$FFFF8254.W	6
	MOVE.L	(A6)+,$FFFF8258.W	6
	MOVE.L	(A6)+,$FFFF825C.W	6
	LEA	-32(A6),A6
	DCB	88-48-2-27,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12,$4E71

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	;PLAY_B
	MOVE.L	(A6)+,$FFFF8240.W	6
	MOVE.L	(A6)+,$FFFF8244.W	6
	MOVE.L	(A6)+,$FFFF8248.W	6
	MOVE.L	(A6)+,$FFFF824C.W	6
	MOVE.L	(A6)+,$FFFF8250.W	6
	MOVE.L	(A6)+,$FFFF8254.W	6
	MOVE.L	(A6)+,$FFFF8258.W	6
	MOVE.L	(A6)+,$FFFF825C.W	6
	LEA	-32(A6),A6
	DCB	88-48-2,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71

	DBF	D5,.F
SUITE

;	CMPI.B	#$50,$FFFFFC02.W
;	BNE.S	PAS_HAUT
;	CMPI.L	#230*400,Y_VALUE
;	BEQ.S	PAS_HAUT
;	ADD.L	#230,Y_VALUE
;	;ADD	#32,MOD_PAL
;PAS_HAUT	CMPI.B	#$48,$FFFFFC02.W
;	BNE.S	PAS_BAS
;	TST.L	Y_VALUE
;	BEQ.S	PAS_BAS
;	SUB.L	#230,Y_VALUE
;	;SUB	#32,MOD_PAL
;PAS_BAS
;	CMPI.B	#$4B,$FFFFFC02.W
;	BNE.S	PAS_GA
;	ADDQ.L	#8,Y_VALUE
;PAS_GA	CMPI.B	#$4D,$FFFFFC02.W
;	BNE.S	PAS_DR
;	SUBQ.L	#8,Y_VALUE
;PAS_DR
*
	TST.L	Y_VALUE
	BEQ.S	.S
	SUB.L	#230,Y_VALUE
.S
*
	MOVEQ	#0,D7	
	MOVEQ	#0,D6
	MOVE.L	Y_VALUE,D7
	
	LSR.L	#8,D7
	MOVE.L	D7,D6
	LSL.L	#8,D6
	
	MOVE.L	Y_VALUE,D7
	SUB.L	D6,D7

	LEA	DATA_HS,A6

	TST.L	D7
	BNE.S	DEJ
	LEA	RIEN,A6
	MOVE.L	A6,POIT
	BRA.S	OKAY
DEJ	SUBQ.L	#2,D7
	MULU	#18,D7
	ADDA.L	D7,A6
	MOVE.L	A6,POIT
		
OKAY	
;	move.l	SCREEN1,d0
;	move.l	SCREEN2,SCREEN1		
;	move.l	d0,SCREEN2

	move.l	SCREEN1,D7
	ADD.L	D6,D7
	lsr.l	#8,D7
	LEA	$FFFF8201.W,A6
	movep	D7,(a6)

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
Y_VALUE	DC.L	58190

TB0_IR	RTE


FIN:	MOVE.L	4.W,A0
	JMP	(A0)

INIT_SAMPLE
	MOVE.L	#SAMPLE1,BEAT1

	LEA	SAMPLE1,A0
	MOVE.L	#TEST_FIN1,D7
	MOVE.L	#SAMPLE1,D6
	SUB.L	D6,D7
	LSR.L	#2,D7
	;MOVE.W	#((TEST_FIN-BEAT)/2)-1,D7
.CONT	MOVE.B	(A0),D0
	ADDI.B	#$80,D0
	MOVE.B	D0,(A0)+
	MOVE.B	(A0),D0
	ADDI.B	#$80,D0
	MOVE.B	D0,(A0)+
	MOVE.B	(A0),D0
	ADDI.B	#$80,D0
	MOVE.B	D0,(A0)+
	MOVE.B	(A0),D0
	ADDI.B	#$80,D0
	MOVE.B	D0,(A0)+
	DBRA	D7,.CONT
	LEA	SAMPLE1,A0
	LEA	TEST_FIN1,A1
	MOVE.W	#255,D7
.A	MOVE.B	(A0)+,(A1)+
	DBRA	D7,.A
GO	
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE.W	#$8800,A6
	MOVEQ	#$A,D0
SET_YM1	MOVE.B	D1,(A6)	;ON REMET LES 10 REGISTRES SONORES A ZERO
	CLR.B	2(A6)
	ADDQ.W	#1,D1
	DBRA	D0,SET_YM1

	MOVE.B	#7,(A6)
	MOVE.B	#$FF,2(A6)
	MOVE.L	BEAT1,A0

	RTS
;PLAY_B	MOVEQ	#0,D0	;1
;	MOVE.B	(A0)+,D0	;2
;	LSL.W	#3,D0	;3
;	MOVE.L	0(A2,D0.W),D1	;5
;	MOVE.W	4(A2,D0.W),D2	;4
;	MOVEP.L	D1,(A1)	;6
;	MOVEP.W	D2,(A1)	;4     ;=25 NOPS
;
;	RTS	;4    ;=29 NOPS

BEAT1	DS.L	1


CODE	INCBIN	TABLEREP.BIN

SAMPLE1	INCBIN	BGC_02.SPL
	EVEN
TEST_FIN1	DCB.B	256,0

H0	PLAY_B
	DCB	128-4-3-4-27,$4E71
	RTS

H70
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	PLAY_B
	DCB	3+17*5-27,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	NOP
	RTS	=4 NOPS
H44
	PLAY_B
	DCB	3+18*5-27,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	NOP
	RTS	=4 NOPS
H24
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	PLAY_B
	DCB	1+17*5-27,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	REPT	3
	NOP
	ENDR
	RTS	=4 NOPS
H2
	NOP
	PLAY_B
	DCB	18*5-27,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	REPT	3
	NOP
	ENDR
	RTS	=4 NOPS
H80
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	7*5,$4E71
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	PLAY_B
	DCB	3+9*5-27,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	NOP
	RTS
	 
	DATA

DATA_HS
 DC.L H44,H44,H2,H2,H2,H80,H0,H0,H0
 DC.L H44,H44,H2,H2,H80,H0,H0,H0,H0
 DC.L H44,H44,H2,H80,H0,H0,H0,H0,H0
 DC.L H44,H44,H80,H0,H0,H0,H0,H0,H0
 DC.L H44,H24,H24,H2,H80,H0,H0,H0,H0
 DC.L H44,H24,H24,H80,H0,H0,H0,H0,H0
 DC.L H24,H2,H2,H2,H2,H2,H0,H0,H0
 DC.L H24,H2,H2,H2,H2,H0,H0,H0,H0
 DC.L H24,H2,H2,H2,H0,H0,H0,H0,H0
 DC.L H24,H2,H2,H0,H0,H0,H0,H0,H0
 DC.L H24,H2,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H0,H0,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H24,H24,H80,H80,H0,H0
 DC.L H70,H44,H2,H2,H2,H80,H0,H0,H0
 DC.L H70,H44,H2,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H2,H80,H0,H0,H0,H0,H0
 DC.L H44,H2,H2,H2,H2,H2,H0,H0,H0
 DC.L H44,H2,H2,H2,H2,H0,H0,H0,H0
 DC.L H44,H2,H2,H2,H0,H0,H0,H0,H0
 DC.L H44,H2,H2,H0,H0,H0,H0,H0,H0
 DC.L H44,H2,H0,H0,H0,H0,H0,H0,H0
 DC.L H44,H0,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H2,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H0,H0,H0,H0,H0,H0,H0
 DC.L H44,H44,H44,H2,H80,H0,H0,H0,H0
 DC.L H44,H44,H44,H80,H0,H0,H0,H0,H0
 DC.L H70,H70,H2,H2,H2,H80,H0,H0,H0
 DC.L H70,H70,H2,H2,H80,H0,H0,H0,H0
 DC.L H70,H70,H2,H80,H0,H0,H0,H0,H0
 DC.L H44,H24,H2,H2,H2,H2,H0,H0,H0
 DC.L H44,H24,H2,H2,H2,H0,H0,H0,H0
 DC.L H44,H24,H2,H2,H0,H0,H0,H0,H0
 DC.L H44,H24,H2,H0,H0,H0,H0,H0,H0
 DC.L H44,H24,H0,H0,H0,H0,H0,H0,H0
 DC.L H70,H0,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H44,H2,H2,H80,H0,H0,H0
 DC.L H70,H44,H44,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H44,H80,H0,H0,H0,H0,H0
 DC.L H44,H24,H24,H2,H80,H70,H0,H0,H0
 DC.L H70,H44,H24,H24,H80,H0,H0,H0,H0
 DC.L H44,H44,H2,H2,H0,H0,H0,H0,H0
 DC.L H44,H44,H2,H0,H0,H0,H0,H0,H0
 DC.L H44,H44,H0,H0,H0,H0,H0,H0,H0
 DC.L H70,H24,H2,H2,H0,H0,H0,H0,H0
 DC.L H70,H24,H2,H0,H0,H0,H0,H0,H0
 DC.L H70,H24,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H2,H2,H2,H80,H0,H0
 DC.L H70,H70,H44,H2,H2,H80,H0,H0,H0
 DC.L H70,H70,H44,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H2,H2,H2,H2,H2,H0,H0
 DC.L H70,H44,H2,H2,H2,H2,H0,H0,H0
 DC.L H70,H44,H2,H2,H2,H0,H0,H0,H0
 DC.L H70,H44,H2,H2,H0,H0,H0,H0,H0
 DC.L H70,H44,H2,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H24,H2,H2,H0,H0
 DC.L H24,H24,H24,H24,H24,H2,H0,H0,H0
 DC.L H24,H24,H24,H24,H24,H0,H0,H0,H0
 DC.L H70,H44,H44,H44,H80,H0,H0,H0,H0
 DC.L H70,H70,H70,H2,H2,H2,H80,H0,H0
 DC.L H70,H70,H70,H2,H2,H80,H0,H0,H0
 DC.L H70,H70,H70,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H24,H2,H2,H2,H2,H0,H0
 DC.L H44,H44,H44,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H2,H2,H0,H0,H0,H0
 DC.L H70,H44,H24,H2,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H0,H0,H0,H0,H0,H0
 DC.L H70,H70,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H70,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H2,H2,H80,H0,H0
 DC.L H70,H70,H44,H44,H2,H80,H0,H0,H0
 DC.L H70,H70,H44,H44,H80,H0,H0,H0,H0
 DC.L H70,H70,H44,H24,H24,H2,H80,H0,H0
 DC.L H70,H44,H44,H2,H2,H2,H0,H0,H0
 DC.L H70,H44,H44,H2,H2,H0,H0,H0,H0
 DC.L H70,H44,H44,H2,H0,H0,H0,H0,H0
 DC.L H70,H44,H44,H0,H0,H0,H0,H0,H0
 DC.L H70,H70,H24,H2,H2,H0,H0,H0,H0
 DC.L H70,H70,H24,H2,H0,H0,H0,H0,H0
 DC.L H70,H70,H24,H0,H0,H0,H0,H0,H0
 DC.L H70,H24,H24,H24,H24,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H24,H24,H24,H0,H0
 DC.L H70,H70,H70,H44,H2,H2,H80,H0,H0
 DC.L H44,H44,H44,H44,H2,H2,H0,H0,H0
 DC.L H44,H44,H44,H44,H2,H0,H0,H0,H0
 DC.L H44,H44,H44,H44,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H2,H2,H2,H0,H0,H0
 DC.L H70,H70,H44,H2,H2,H0,H0,H0,H0
 DC.L H70,H70,H44,H2,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H24,H24,H0,H0,H0,H0
 DC.L H70,H70,H24,H24,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H44,H80,H2,H0,H0
 DC.L H70,H70,H44,H44,H44,H80,H0,H0,H0
 DC.L H70,H70,H70,H44,H24,H2,H2,H80,H0
 DC.L H44,H44,H44,H44,H24,H2,H2,H0,H0
 DC.L H44,H44,H44,H44,H24,H2,H0,H0,H0
 DC.L H44,H44,H44,H44,H24,H0,H0,H0,H0
 DC.L H70,H44,H44,H44,H0,H0,H0,H0,H0
 DC.L H70,H70,H70,H2,H2,H2,H0,H0,H0
 DC.L H70,H70,H70,H2,H2,H0,H0,H0,H0
 DC.L H70,H70,H70,H2,H0,H0,H0,H0,H0
 DC.L H70,H70,H70,H0,H0,H0,H0,H0,H0
 DC.L H24,H70,H70,H24,H24,H0,H0,H0,H0
 DC.L H70,H24,H24,H24,H24,H24,H24,H0,H0
 DC.L H44,H44,H44,H44,H44,H2,H2,H0,H0
 DC.L H44,H44,H44,H44,H44,H2,H0,H0,H0
 DC.L H44,H44,H44,H44,H44,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H2,H2,H2,H0,H0
 DC.L H70,H70,H44,H44,H2,H2,H0,H0,H0
 DC.L H70,H70,H44,H44,H2,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H0,H0,H0,H0,H0
 DC.L H70,H44,H44,H24,H24,H24,H0,H0,H0
 DC.L H70,H70,H70,H24,H2,H0,H0,H0,H0
 DC.L H70,H70,H70,H24,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H70,H70,H0,H0,H0
 DC.L H44,H44,H44,H44,H44,H24,H2,H2,H2
 DC.L H44,H44,H44,H44,H44,H24,H2,H2,H0
 DC.L H70,H44,H44,H44,H44,H2,H2,H0,H0
 DC.L H70,H44,H44,H44,H44,H2,H0,H0,H0
 DC.L H70,H44,H44,H44,H44,H0,H0,H0,H0
 DC.L H70,H44,H44,H44,H24,H24,H2,H0,H0
 DC.L H70,H70,H70,H44,H2,H2,H0,H0,H0
 DC.L H70,H70,H70,H44,H2,H0,H0,H0,H0
 DC.L H70,H70,H70,H44,H0,H0,H0,H0,H0
POINT	DC.L	0
BUF_LET	DCB.B	16,0

RIEN	REPT	9
	DC.L	H0
	ENDR

PART1	;INCBIN	j1b.PI1
PART2	;INCBIN	j2b.PI1
PART3	;INCBIN	j3b.PI1
PART4	;INCBIN	j4b.PI1
PART5	;INCBIN	j5b.PI1
PART6	;INCBIN	j6b.PI1
	DC	$1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
FAD
	DCB	16,0
	DC	$000,$000,$111,$000,$000,$100,$100,$000
	DC	$001,$000,$000,$000,$100,$100,$000,$000
	DC	$000,$001,$222,$000,$000,$200,$200,$100
	DC	$112,$000,$000,$100,$200,$210,$000,$001
	DC	$000,$012,$333,$000,$000,$300,$300,$200
	DC	$223,$000,$100,$200,$310,$321,$000,$002
	DC	$000,$023,$444,$000,$000,$411,$400,$300
	DC	$334,$100,$200,$310,$421,$432,$001,$003
	DC	$000,$134,$555,$000,$100,$522,$501,$400
	DC	$445,$200,$310,$421,$532,$543,$002,$004
	DC	$000,$245,$666,$001,$210,$633,$612,$501
	DC	$556,$310,$421,$532,$643,$654,$003,$015
	DC	$000,$356,$777,$002,$321,$744,$723,$612
	DC	$667,$421,$532,$643,$754,$765,$004,$126
	
	DC	-1
	

DATAS_PALETTES
	DC	600
hop	DC	$777
	DCB	15,0

 	SECTION BSS

F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
POIT	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFERSCR	
