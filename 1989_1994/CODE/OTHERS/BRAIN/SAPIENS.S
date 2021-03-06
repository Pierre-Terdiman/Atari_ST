**************************************
* ROUTINE BOOTSECTEUR DU JEU SAPIENS *
**************************************

START:
	MOVEA.W	#$FA00,A5	; ADRESSE CARTOUCHE ?!?
	
	MOVE.B	#0,7(A5)
	MOVE.B	#0,9(A5)
	MOVE.B	#0,$13(A5)
	MOVE.B	#0,$15(A5)
	BCHG	#3,$17(A5)
	
	LEA	NEW_120(PC),A4
	MOVE.L	A4,$120.W		; NOUVELLE ROUTINE TIMER B
	
	LEA	NEW_134(PC),A4
	MOVE.L	A4,$134.W		; NOUVELLE ROUTINE TIMER C
	
	MOVE.B	#1,$21(A5)
	MOVE.B	#$14,$1F(A5)
	MOVE.B	#$21,7(A5)
	MOVE.B	#$21,$13(A5)
	
	LEA	$A100,A3
	
	LEA	8.W,A4
	MOVE.L	A4,D0
	
	MOVE.B	#1,$19(A5)
	MOVE.B	#8,$1B(A5)
	
	MOVEA.W	#$8600,A6	; DMAMODE DANS A6
	
	PEA	$200.W	; BUFFER
	
	MOVEQ	#0,D5	; EFFACER LE REGISTRE D5
LOOP:	TST.W	D5	; D5 NUL ? (INCREMENTATION EN TIMER C)
	BEQ	LOOP	; ALORS ON BOUCLE...
	
	BSR.S	SET_DMA	; POSITIONNER LE BUFFER
	
	MOVE.W	#$84,6(A6)	; FDC SECTOR REGISTER
	MOVE.W	#2,D7	; SECTEUR NUMERO 2
	BSR.S	WD_WRITE	; EXECUTER LA COMMANDE
	
	MOVE.W	#$90,D7	; FDC SECTOR COUNT REGISTER 
	BSR.S	READ_SEC	; LIRE SECTEUR(S)
	RTS

WAIT:	MOVE.W	#$20,D6	; PAUSE
WAIT1:	DBF	D6,WAIT1
	RTS

WD_WRITE:	BSR.S	WAIT	; PAUSE
	MOVE.W	D7,4(A6)	; D7 DANS $FF8604
	BRA.S	WAIT	; PAUSE
	BSR.S	WAIT	; PAUSE
	MOVE.W	4(A6),D7	; $FF8604 DANS D7 (TEST ERREUR)
	BRA.S	WAIT	; PAUSE

READ_SEC:	MOVE.W	#$80,6(A6)	; FDC COMMAND REGISTER
	BSR.S	WD_WRITE	; EXECUTER LA COMMANDE
	BSR.S	DATA_MARK	; TESTER DATA MARK
	RTS

SET_DMA:	MOVE.B	D0,$D(A6)	; D0 DANS $FF860D
	LSR.L	#8,D0
	MOVE.B	D0,$B(A6)	; D0 DANS $FF860B
	LSR.L	#8,D0
	MOVE.B	D0,9(A6)	; D0 DANS $FF8609

DMA_IN:	MOVE.W	#$90,6(A6)	; DMA R/W TOGGEL (FLIP/FLOP)
	MOVE.W	#$190,6(A6)
	MOVE.W	#$90,6(A6)	; SELECTION DMA SECTOR COUNT
	MOVE.W	#$A,D7	; 10 SECTEURS A LIRE
	BSR.S	WD_WRITE	; EXECUTER LA COMMANDE
	RTS

DATA_MARK:	BTST	#5,1(A5)	; DATA ADRESS MARK EFFACEE ?
	BNE.S	DATA_MARK	; NON, ON BOUCLE...
	RTS

NEW_120:	ADDQ.L	#1,$6032	; INCREMENTATION ADRESSE ???
	RTE

NEW_134:	MOVE.L	(A4)+,(A3)+
	CMPA.W	#$1008,A4
	BCS.S	END_134
	ADDQ.W	#1,D5
	MOVE.B	#8,$19(A5)		; MOVE.B	#8,25(A5)
END_134:	RTE
