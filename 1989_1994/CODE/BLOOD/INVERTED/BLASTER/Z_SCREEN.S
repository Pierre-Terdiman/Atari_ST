	LEA	NEW_PILE,A7

	PEA	0.W
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2

	LEA	COD1,A0
	LEA	TABLE,A1
UN_DE_PLUS	CMPI.L	#$99999999,(A0)
	BEQ.S	FINITO
	MOVE.L	A0,(A1)+
CHERCHE	CMPI	#$4E75,(A0)+
	BEQ.S	UN_DE_PLUS
	BRA.S	CHERCHE
FINITO	
;	JMP	TST

	LEA	COD2,A0
	LEA	TABLE2,A1
UN_DE_PLUS_	CMPI.L	#$99999999,(A0)
	BEQ.S	FINITO_
	MOVE.L	A0,(A1)+
CHERCHE_	CMPI	#$4E75,(A0)+
	BEQ.S	UN_DE_PLUS_
	BRA.S	CHERCHE_
FINITO_
TST	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.B	#2,$FFFF820A.W
	MOVE.B	#$1E,$FFFFFA07.W
	MOVE.B	#$64,$FFFFFA09.W
	MOVE.B	#$00,$FFFFFA0F.W
	MOVE.B	#$1E,$FFFFFA13.W
	MOVE.B	#$00,$FFFFFA1B.W
	MOVE.B	#$47,$FFFFFA21.W
	MOVE.B	#$64,$FFFFFA15.W
	MOVE.B	#$48,$FFFFFA17.W
	MOVE.B	#$00,$FFFFFA19.W
	MOVE.B	#$FF,$FFFFFA1F.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.B	#$12,$FFFFFC02.W

	LEA	FIN,A0
	MOVE.L	A0,$008.W
	MOVE.L	A0,$00C.W
	MOVE.L	A0,$010.W
	MOVE.L	A0,$014.W
	MOVE.L	A0,$018.W
	MOVE.L	A0,$01C.W
	MOVE.L	A0,$020.W
	
	LEA	RTE,A0
	MOVE.L	A0,$68.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$70.W
	BRA.S	CONTINUE
RTE	RTE
CONTINUE
	MOVE	#$777,$FFFF8242.W
	MOVE	#$777,$FFFF8250.W
;	MOVE	#$001,$FFFF8244.W
;	MOVE	#$777,$FFFF8246.W
;	MOVE	#$777,$FFFF8256.W
;0000
;0001
;0010
;0011
;0100
;0101
;0110
;0111
;1000
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

;	MOVE.L	SCREEN1,A0
;	LEA	160(A0),A0
;	MOVE.L	A0,A1
;	MOVE	#100,D0
;O2	MOVE	#28,D1
;O	MOVE	#$FFFF,2(A1)
;	ADDQ.L	#8,A1
;	DBF	D1,O
;	LEA	230(A0),A0
;	MOVE.L	A0,A1
;	DBF	D0,O2


	MOVE.L	SCREEN1,A0
	LEA	160+230*100(A0),A0

	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	JSR	8*4(A1)

	LEA	TABLE+4,A1
	MOVE.L	A1,SAVEA1

	;JMP	TST2

	MOVE.L	SCREEN1,A0
	LEA	160+230*100+112(A0),A0

	LEA	TABLE2,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	JSR	8*4(A1)

	LEA	TABLE2+4,A1
	MOVE.L	A1,SAVEA1B
TST2
	MOVE.L	#INTER_RTE,$68.W
;	MOVE.L	#TIMER_B,$120.W

;	CLR.B	$FFFFFA07.W
;	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W
	MOVE.L	#VBL,$70.W
	MOVE	#$2300,SR

J	BRA.S	J
VBL
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W

	MOVE	#3,$FFFF8240.W

	MOVE.L	SCREEN1,A0
	LEA	160+230*100(A0),A0
	MOVE.L	SAVEA1,A1
	MOVE.L	(A1)+,A2
	TST.L	-4(A1)
	BNE	RT
	LEA	TABLE+4,A1
	MOVE.L	(A1)+,A2
RT
	MOVEM.L	(A2),D0-D7
	JSR	8*4(A2)
	MOVE.L	A1,SAVEA1
**
	;JMP	TST3
	MOVE.L	SCREEN1,A0
	LEA	160+230*100+112(A0),A0
	MOVE.L	SAVEA1B,A1
	MOVE.L	(A1)+,A2
	TST.L	-4(A1)
	BNE	RTB
	LEA	TABLE2+4,A1
	MOVE.L	(A1)+,A2
RTB
	MOVEM.L	(A2),D0-D7
	JSR	8*4(A2)
	CMPI.B	#$1,$FFFFFC02.W
	BEQ.S	TST3
	MOVE.L	A1,SAVEA1B
TST3
INTER_RTE	RTE
SAVEA1	DC.L	0
SAVEA1B	DC.L	0
INTER_TMA
	movem.l	d0-a6,-(sp)

	CLR.B	$FFFFFA07.W		; ARRET DU MFP POUR NE PAS
	CLR.B	$FFFFFA09.W		; ETRE GENE
	MOVE	#$2100,SR		; ON AUTORISE LA HBL

	MOVE.L	#$FFFF8209,A6
	MOVE.L	#$FFFF8260,A4
	MOVE.L	#$FFFF820A,A3

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100		; ATTENTE DE LA PROCHAINE HBL
				; (FIXE A 16 CYCLES PRES ENVIRONS)
	MOVE	#$2700,SR		; ON COUPE TOUTE LES ITs
	MOVE	#$2300,(SP)		; AU RETOUR LE VBL SERA AUTORISEE

	MOVEQ	#29,D2		; ON ATTEND LE BON MOMENT
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D0,(A3)		; ET HOP! PLUS DE BORDER HAUT
	REPT	6
	NOP
	ENDR
	MOVE.B	D1,(A3)
full	
	LEA	$FFFF8209.W,A3	
	LEA	$FFFF8260.W,A1	
	LEA	$FFFF820A.W,A0	
	MOVE	#227,D0		* NB DE LIGNES
	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6
	MOVE	#$2700,SR

SYNCHRO	MOVE.B	(A3),D7     * SYNCHRO
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	97-5-6-10-3
	NOP	
	ENDR

	MOVE.L	SCREEN1,A2	5
	MOVE.L	SCREEN1,A3	5
	LEA	160(A2),A2
	LEA	160+230*120(A3),A3
	LEA	230*130(A3),A3
	LEA	PALETTE,A4
FULLSCREEN	
	REPT	51
	JSR	LIGNE
	ENDR
	REPT	227-153
	JSR	ROUTY
	ENDR
	DCB	5,$4E71
;	JMP	ENDE

	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE.L	(A4)+,$FFFF8240.W
	MOVE	(A4)+,$FFFF8250.W
	DCB	88-10,$4E71
	MOVE.b	#0,(A0)
	MOVE	a1,(A0)
	DCB	13,$4E71
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	CLR.B	$FFFF820A.W
	DCB	12-4,$4E71

	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE	A1,(A0)
	MOVE.L	(A4)+,$FFFF8240.W
	MOVE	(A4)+,$FFFF8250.W
	DCB	88-2-10,$4E71
	MOVE.b	#0,(A0)
	MOVE	a1,(A0)
	DCB	13,$4E71
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	DCB	12-5,$4E71

	REPT	35-5-5-2
	JSR	ROUTY
	ENDR

ENDE	movem.l	(sp)+,d0-a6
	MOVE	#$2300,SR
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	RTE
FIN	MOVE.L	4.W,A0
	JMP	(A0)
LIGNE
N	SET	0
***	LIGNE	1
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5

	DCB	3,$4E71
	MOVE.b	#0,(A0)
	MOVE	a1,(A0)
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	DCB	3,$4E71
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE	N+8(A2),N+8(A3)	5
	MOVE.L	(A4)+,$FFFF8240.W
	DCB	7-6,$4E71
***	LIGNE	2
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE	(A4)+,$FFFF8250.W
	DCB	8-4,$4E71
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
*1 LIGNE ECRITE
N	SET	230
N2	SET	-230
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N	SET	N+16
N2	SET	N2+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
	MOVE.b	#0,(A0)
	MOVE	a1,(A0)
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
	DCB	3,$4E71
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
	DCB	2,$4E71
**	LIGNE	3
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE.L	(A4)+,$FFFF8240.W
	MOVE	(A4)+,$FFFF8250.W
	DCB	24-10,$4E71
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
N2	SET	N2+16
N	SET	N+16
	MOVE	N+6(A2),N2(A3)		5
	MOVE	N+8(A2),N2+8(A3)	5
	LEA	230*2(A2),A2
	LEA	-230*2(A3),A3
	MOVE.b	#0,(A0)
	MOVE	a1,(A0)
	DCB	13-6-4,$4E71
	MOVE.L	(A4)+,$FFFF8240.W
	MOVE	(A4)+,$FFFF8250.W
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	DCB	12-4-5,$4E71
	RTS
*2 LIGNES ECRITES

ROUTY
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	MOVE.L	(A4)+,$FFFF8240.W
	MOVE	(A4)+,$FFFF8250.W
	DCB	88-10,$4E71
	MOVE.b	#0,(A0)
	MOVE	a1,(A0)
	DCB	13,$4E71
	MOVE	a1,(A1)
	MOVE.B	#0,(A1)
	DCB	12-5-4,$4E71
	RTS

	DATA
COD1	incbin	damier1.cod
	DC.L	$99999999
	EVEN
COD2	incbin	damier2.cod
	DC.L	$99999999
	EVEN

PALETTE
	REPT	21
	DC	$777,$677,$677
	ENDR
	DC	$667,$566,$566
	DC	$777,$677,$677
	REPT	32
	DC	$667,$566,$566
	ENDR
	DC	$556,$455,$455
	DC	$667,$566,$566
	REPT	16
	DC	$556,$455,$455
	ENDR
	DC	$445,$344,$344
	DC	$556,$455,$455
	REPT	8
	DC	$445,$344,$344
	ENDR
	DC	$334,$233,$233
	DC	$445,$344,$344
	REPT	4
	DC	$334,$233,$233
	ENDR
	DC	$223,$122,$122
	DC	$334,$233,$233
	REPT	3
	DC	$223,$122,$122
	ENDR
	DC	$112,$101,$101
	DC	$223,$122,$122
	REPT	2
	DC	$112,$101,$101
	ENDR
	DC	$001,$0,0
	DC	$112,$001,$001
	DC	$001,$0,0

***
	;REPT	47-43
	;DC	$000,$777,$777
	;ENDR

	DC	$000,$777,$777
	DC	$000,$777,$777

	DC	$000,$777,$777
	DC	$100,$777,$777
	DC	$200,$777,$777
	DC	$300,$777,$777
	DC	$400,$777,$777
	DC	$500,$777,$777
	DC	$600,$777,$777
	DC	$700,$777,$777
	DC	$710,$777,$777
	DC	$720,$777,$777
	DC	$730,$777,$777
	DC	$740,$777,$777
	DC	$750,$777,$777
	DC	$760,$777,$777
	DC	$770,$777,$777
	DC	$771,$777,$777
	DC	$772,$777,$777
	DC	$773,$777,$777
	DC	$774,$777,$777
	DC	$775,$777,$777
	DC	$776,$777,$777
	DC	$777,$777,$777
	DC	$776,$777,$777
	DC	$775,$777,$777
	DC	$774,$777,$777
	DC	$773,$777,$777
	DC	$772,$777,$777
	DC	$771,$777,$777
	DC	$770,$777,$777
	DC	$760,$777,$777
	DC	$750,$777,$777
	DC	$740,$777,$777
	DC	$730,$777,$777
	DC	$720,$777,$777
	DC	$710,$777,$777
	DC	$700,$777,$777
	DC	$600,$777,$777
	DC	$500,$777,$777
	DC	$400,$777,$777
	DC	$300,$777,$777
	DC	$200,$777,$777
	DC	$100,$777,$777
	DC	$000,$777,$777

	DC	$000,$777,$777
	DC	$000,$777,$777
***
	DC	$001,0,0
	DC	$101,$122,$122
	DC	$001,0,0
	DC	$101,$122,$122
	DC	$101,$122,$122
	DC	$212,$233,$233
	DC	$101,$122,$122
	REPT	3
	DC	$212,$233,$233
	ENDR
	DC	$323,$344,$344
	DC	$212,$233,$233
	REPT	4
	DC	$323,$344,$344
	ENDR
	DC	$434,$455,$455
	DC	$323,$344,$344
	REPT	8
	DC	$434,$455,$455
	ENDR
	DC	$545,$566,$566
	DC	$434,$455,$455
	REPT	16
	DC	$545,$566,$566
	ENDR
	DC	$656,$677,$677
	DC	$545,$566,$566
	REPT	32
	DC	$656,$677,$677
	ENDR
	DC	$767,$777,$777
	DC	$656,$677,$677
	REPT	21+2
	DC	$767,$777,$777
	ENDR
	DC	$700,$777,$777
	DCB	3*20,0

	BSS
	DS.L	256
NEW_PILE	DS.L	1
TABLE	DS.L	95
TABLE2	DS.L	95
	DS.B	256
BUFFERSCR	DS.B	64000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
