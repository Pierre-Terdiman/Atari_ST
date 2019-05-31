FACE_INIT	=	1
PIST_INIT	=	1
BLOC_INIT	=	79
adresse = $3000
	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ	#6,SP

	OPT	O+,P+,A+
	MOVE	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	LEA	RTE,A0
	MOVE.L	A0,$70.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$68.W
	
	LEA	$500.W,A0
	LEA	PRG,A1
	MOVE	#250,D0
H	MOVE.L	(A1)+,(A0)+
	DBF	D0,H
	JMP	$500.W
PRG
	OPT	O+,P+,A+
	LEA	NEWPILE,A7
	OPT	O-,P-,A-
	LEA	adresse,A0
	LEA	$FFFFF,A1
	OPT	O+,P+,A+
.EF	CLR.L	(A0)+
	CMP.L	A1,A0
	BLT.S	.EF
	MOVE	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	LEA	RTE,A0
	MOVE.L	A0,$70.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$68.W
	cmpi.b	#4,$484.w
	BNE.S	KO
	PEA	MSG
	MOVE	#$9,-(SP)
	TRAP	#1
POPO	BRA.S	POPO
KO	
	MOVE	#$001,$FFFF8240.W
	JSR	CHARGEZ
	MOVE	#$2300,SR
	BSR.S	RELOC
	OPT	O-,P-,A-
	JMP	adresse
RELOC
	LEA	adresse,A0
	OPT	O+,P+,A+
	MOVE.L	A0,A1
	ADD.L	2(A0),A1
	ADD.L	6(A0),A1
	LEA	31(A1),A1
	MOVEQ	#0,D0
	
	OPT	O-,P-,A-
	LEA	adresse,A0
	OPT	O+,P+,A+
	LEA	28(A0),A0
	MOVE.L	A0,D1
	
RELOCATION	MOVE.B	(A1)+,D0
	BEQ.S	RELOC_END
	CMP.W	#1,D0
	BNE.S	RELOC1
	ADD.W	#254,A0
	BRA.S	RELOCATION
RELOC1	ADD.W	D0,A0
	ADD.L	D1,(A0)
	BRA.S	RELOCATION
RELOC_END	RTS

CHARGEZ
	LEA	DATA_FILES(PC),A0
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
;	LEA	OFF7_DEP,A1
;	MOVE	(A0)+,(A1)
;	LEA	TAILLE,A1
;	MOVE	(A0)+,(A1)
	JSR	TRACK_LOADING
	RTS

TRACK_LOADING	
	LEA	FACE(PC),A0
	MOVE	D0,(A0)
	LEA	PISTE(PC),A1
	LEA	PISTE2(PC),A2
	MOVE	D1,(A1)
	MOVE	D1,(A2)
	LEA	NB_SECT(PC),A0
	CMPI.L	#10,D2
	BLE.S	PAS_PLUS_DE_10
	MOVE.L	D2,D3
	DIVS	#10,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVE	D3,D4	NB * 10 SECT A LIRE
	SWAP	D3
	MOVE	D3,D5	ET RESTE
	SUBQ.L	#1,D4
AGAIN	
	MOVEM.L	D4/A0-A2,-(SP)
	MOVE	#10,(A0)
	JSR	LOADING
	LEA	AJOUT(PC),A3
	ADD.L	#512*10,(A3)
	MOVEM.L	(SP)+,D4/A0-A2
	ADDQ	#1,(A1)
	ADDQ	#1,(A2)
;r	cmpi.b	#$39,$fffffc02.w
;	bne.s	r
;e	cmpi.b	#$39,$fffffc02.w
;	beq.s	e
	DBF	D4,AGAIN
	TST.L	D3
	BEQ.S	FINIz
	TST	D5
	BEQ.S	FINIz
	MOVE	D5,(A0)
	JSR	LOADING
	BRA.S	FINIz
PAS_PLUS_DE_10	MOVE	D2,(A0)
	JSR	LOADING
FINIz	RTS
RTE	RTE
LOADING
	OPT	O-,A-,P-
	LEA	adresse,A0
	OPT	O+,P+,A+
AJOUT	EQU	*+2
	ADDA.L	#0,A0
	movea.l	a0,a1
	lea	$FFFF8604.W,a6
	st	$43E.W
	moveq	#0,d0
FACE	EQU	*+2
	move	#0,D1
	bsr	Set_drive
Tracks:	move.w	#$86,d2
PISTE	EQU	*+2
	move.w	#0,d3
	bsr.S	WD_write
	move.w	#$80,d2
	moveq	#%00010001,d3
	bsr.s	WD_write
Wait_Tracks:	bsr.S	Wait_done
	moveq	#0,d0
CHARGE:	move.l	a0,d1
	move.b	d1,$FFFF860D.W
	lsr.l	#8,d1
	move.b	d1,$FFFF860B.W
	lsr.l	#8,d1
	move.b	d1,$FFFF8609.W
DMA_in:	move.w	#$90,2(a6)
	move.w	#$190,2(a6)
	move.w	#$90,d2
	moveq	#1,d3
	bsr.s	WD_write
	move.w	#$82,d2
PISTE2	EQU	*+2
	move.w	#0,d3
	bsr.s	WD_write
	addq.w	#1,d0
	move.w	#$84,d2
	move.w	d0,d3
	bsr.s	WD_write
	move.w	#$80,d2
	move.w	#%10000000,d3
	bsr.s	WD_write
	bsr.s	Wait_done
	adda.l	#512,a0
NB_SECT	EQU	*+2
	cmpi.w	#0,d0
	bne.s	CHARGE
	move.b	#7,d0
	bsr.s	Select
	sf	$43E.W
	movea.l	a1,a0
	RTS
;	jmp	(a0)
WD_write:	move.w	d2,2(a6)
	move.w	d3,(a6)
Attend:	moveq	#40,d1
Attend1:dbf	d1,Attend1
	rts
Wait_done:	bsr.s	Attend
Wait:	btst	#5,$FFFFFa01.W
	bne.s	Wait
	rts
;Set_drive:	moveq	#5,d0
;Select:	move.w	sr,-(a7)
;	ori.w	#$700,sr
;	move.b	#$e,$ffFF8800.W
;	move.b	$ffFF8800.W,d1
;	andi.b	#$f8,d1
;	or.b	d0,d1
;	move.b	d1,$ffFF8802.W
;	move.w	(a7)+,sr
;	rts
Set_drive:
	move.w	d0,d4
	cmpi.w	#1,d0
	bgt.s	End_set
	addq.b	#1,d4
	lsl.b	#1,d4
	or.w	d1,d4
	eori.b	#7,d4
	andi.b	#7,d4
	MOVE.L	D4,D0
;	moveq	#5,d0		Selectionner le drive A	
Select:	move.w	sr,-(a7)
	ori.w	#$700,sr
	move.b	#$e,$fFFf8800.W
	move.b	$fFFf8800.W,d1
	andi.b	#$f8,d1
	or.b	d0,d1
	move.b	d1,$fFFf8802.W
	move.w	(a7)+,sr
End_set	rts

DATA_FILES
*STARS INTRO
	DC	FACE_INIT	FACE
	DC	PIST_INIT
	DC	180
MSG	dc.b 'RISING FORCE by Holocaust',$a,$d
	dc.b 'ONE MEGABYTE required...',$a,$d
	dc.b 'Buy X-TRA RAM !!',0
	BSS
	DS.L	128
NEWPILE	DS.L	1
	