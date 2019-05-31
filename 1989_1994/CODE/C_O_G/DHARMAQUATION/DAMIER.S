	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	LEA	COD,A0
	LEA	TABLE,A1
UN_DE_PLUS	MOVE.L	A0,(A1)+
CHERCHE	MOVE	(A0)+,D0
	CMPI	#$4E75,D0
	BNE.S	CHERCHE
	CMPI.L	#-1,(A1)
	BEQ.S	FINITO
	BRA.S	UN_DE_PLUS
FINITO

	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2


	LEA	BIG_DATA,A0
	MOVE.L	SCREEN2,A1
	JSR	decrunch
	MOVEM.L	2(A1),D0-D7
	LEA	PAL_LOGO,A0
	MOVEM.L	D0-D7,(A0)

	MOVE	#7,D0
EFFDEBUT	CLR.L	(A1)+
	DBF	D0,EFFDEBUT
	CLR	(A1)+
	MOVEA.L	SCREEN1,A1
	LEA	160*12(A1),A1
	MOVEA.L	SCREEN2,A2
	LEA	34(A2),A2
	MOVE	#(40*56)-1,D0
AFF_LOGO	MOVE.L	(A2),(A1)+
	CLR.L	(A2)+
	DBF	D0,AFF_LOGO

	MOVEA.L	SCREEN1,A1
	LEA	160*(12+57)(A1),A1
	MOVEA.L	SCREEN1,A2
	LEA	160*(12+56)(A2),A2
	MOVE	#27,D1
AFF_LOGO1	MOVE	#39,D0
AFF_LOGO2	MOVE.L	(A2)+,(A1)+
	DBF	D0,AFF_LOGO2
	LEA	-480(A2),A2
	DBF	D1,AFF_LOGO1
	MOVEA.L	SCREEN1,A0
	MOVEA.L	SCREEN2,A1
	MOVE	#7999,D0
COPY	MOVE.L	(A0)+,(A1)+
	DBF	D0,COPY


;	MOVE.L	SCREEN1,A0
;	LEA	160*(192-43)(A0),A0
;N	SET	0
;	REPT	20
;	MOVE	#$FFFF,N(A0)
;N	SET	N+8
;	ENDR

	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	LEA	160*(192-42)+2(A0),A0
	LEA	160*(192-42)+2(A1),A1
	MOVE	#(20*42)-1,D0
DO_LIGNE	MOVE	#$FFFF,(A0)
	MOVE	#$FFFF,(A1)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	DBF	D0,DO_LIGNE


AFF_CADRE	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A2
	LEA	192*160(A0),A1
	LEA	192*160(A2),A3
	MOVE	#7,D1
DO_Y	MOVE	#19,D0
DO_X	MOVE	#$FFFF,(A0)
	MOVE	#$FFFF,(A1)
	MOVE	#$FFFF,(A2)
	MOVE	#$FFFF,(A3)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	ADDQ.L	#8,A2
	ADDQ.L	#8,A3
	DBF	D0,DO_X
	DBF	D1,DO_Y

	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	MOVE	#(192-43)-1,D0
DO_PIX	MOVE.B	#$FF,(A0)
	MOVE.B	#$FF,(A1)
	MOVE.B	#$FF,153(A0)
	MOVE.B	#$FF,153(A1)
	LEA	160(A0),A0
	LEA	160(A1),A1
	DBF	D0,DO_PIX

	MOVE.L	SCREEN1,A0
	LEA	160*149(A0),A0
	MOVE.L	SCREEN2,A1
	LEA	160*149(A1),A1
	MOVE	#50,D0
DO_PIXU	MOVE.B	#$FF,4(A0)
	MOVE.B	#$FF,4(A1)
	MOVE.B	#$FF,153+4(A0)
	MOVE.B	#$FF,153+4(A1)
	LEA	160(A0),A0
	LEA	160(A1),A1
	DBF	D0,DO_PIXU
	
	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	MOVE.L	SCREEN1,A0
	LEA	160*50(A0),A0
	JSR	8*4(A1)
	MOVE.L	SCREEN2,A0
	LEA	160*50(A0),A0
	JSR	8*4(A1)
	
	LEA	TABLE+4,A1
	MOVE.L	A1,MOD_A1

		
	MOVE.L	#INTER_RTE,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	
	MOVE.L	#VBL_IR,$70.W
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

JUMP	BRA.S	JUMP
;0000
;0001
;0010
;0011
;0100
;0101
;0110
;0111
;1000
;1001
;1010
;1011
;1100
;1101
;1110
;1111
VBL_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#192-43,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	LEA	PAL_LOGO,A0
	MOVEM.L	(A0),D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

MOD_A1	EQU	*+2
	LEA	MOD_A1,A1
	MOVE.L	(A1)+,A2
	CMPI.L	#-1,-4(A1)
	BNE.S	ROUL
	LEA	TABLE+4,A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	MOVE.L	SCREEN1,A0
	LEA	160*50(A0),A0
	JSR	8*4(A2)
	MOVE.L	SCREEN2,A0
	LEA	160*50(A0),A0
	JSR	8*4(A2)
	MOVE.L	A1,MOD_A1

	
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
INTER_RTE	RTE

;INTER_TMA:	CLR.B	$FFFFFA07.W	; ARRET DU MFP POUR NE PAS
;	CLR.B	$FFFFFA09.W	; ETRE GENE
;	MOVE	#$2100,SR	; ON AUTORISE LA HBL

;	MOVE.L	A6,USP
	
;full
;	MOVE.L	#$FFFF8209,A6
;	MOVE.L	#$FFFF8260,A4
;	MOVE.L	#$FFFF820A,A3

;	MOVEQ	#0,D0
;	MOVEQ	#2,D1

;	STOP	#$2100	; ATTENTE DE LA PROCHAINE HBL
		; (FIXE A 16 CYCLES PRES ENVIRONS)
;	MOVE	#$2700,SR	; ON COUPE TOUTE LES ITs
;	MOVE	#$2300,(SP)	; AU RETOUR LE VBL SERA AUTORISEE

;	MOVEQ	#29,D2	; ON ATTEND LE BON MOMENT
;SYNCHROA:	DBF	D2,SYNCHROA
;	NOP

;	MOVE.B	D0,(A3)	; ET HOP! PLUS DE BORDER HAUT
;	REPT	6
;	NOP
;	ENDR
;	MOVE.B	D1,(A3)

;	RTE
	
TB0_IR	
	CLR.B	$FFFFFA1B.W
	MOVE	#$111,$FFFF8246.W
	MOVE	#$111,$FFFF8254.W
	MOVE	#$001,$FFFF8244.W
	MOVE	#$002,$FFFF8248.W
	MOVE	#$002,$FFFF824A.W
	MOVE	#$002,$FFFF824C.W
	MOVE	#$002,$FFFF824E.W
	MOVE.B	#3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB1
	CLR.B	$FFFFFA1B.W
	MOVE	#$222,$FFFF8246.W
	MOVE	#$222,$FFFF8254.W
	MOVE	#$002,$FFFF8244.W
	MOVE.B	#3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB2
	CLR.B	$FFFFFA1B.W
	MOVE	#$333,$FFFF8246.W
	MOVE	#$333,$FFFF8254.W
	MOVE	#$003,$FFFF8244.W
	MOVE.B	#4,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3
	CLR.B	$FFFFFA1B.W
	MOVE	#$444,$FFFF8246.W
	MOVE	#$444,$FFFF8254.W
	MOVE	#$004,$FFFF8244.W
	MOVE.B	#5,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB4,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB4
	CLR.B	$FFFFFA1B.W
	MOVE	#$555,$FFFF8246.W
	MOVE	#$555,$FFFF8254.W
	MOVE	#$005,$FFFF8244.W
	MOVE.B	#6,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB5,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB5
	CLR.B	$FFFFFA1B.W
	MOVE	#$666,$FFFF8246.W
	MOVE	#$666,$FFFF8254.W
	MOVE	#$006,$FFFF8244.W
	MOVE.B	#7,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB6,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB6
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8246.W
	MOVE	#$777,$FFFF8254.W
	MOVE	#$007,$FFFF8244.W
	MOVE.B	#8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB7,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB7
	CLR.B	$FFFFFA1B.W
;	MOVE	#$777,$FFFF8246.W
;	MOVE	#$777,$FFFF8254.W
	MOVE	#$017,$FFFF8244.W
;	MOVE.B	#4,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB0_IR,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

FIN	MOVE.L	4.W,A0
	JMP	(A0)

; a0: Pointer on packed Data
; a1: Pointer on destination of unpacked data
decrunch:	movem.l d0-a6,-(sp)
	cmpi.l	#'Ice!',(a0)+
	bne.s	ice_03
	move.l	(a0)+,d0
	lea	-8(a0,d0.l),a5
	move.l	(a0)+,(sp)
	movea.l a1,a4
	movea.l a1,a6
	adda.l	(sp),a6
	movea.l a6,a3
	bsr.s	ice_08
	bsr.s	ice_04
	bsr	ice_0c
	bcc.s	ice_03
	move.w	#$0f9f,d7
ice_00:	moveq	#3,d6
ice_01:	move.w	-(a3),d4
	moveq	#3,d5
ice_02:	add.w	d4,d4
	addx.w	d0,d0
	add.w	d4,d4
	addx.w	d1,d1
	add.w	d4,d4
	addx.w	d2,d2
	add.w	d4,d4
	addx.w	d3,d3
	dbra	d5,ice_02
	dbra	d6,ice_01
	movem.w d0-d3,(a3)
	dbra	d7,ice_00
ice_03:	movem.l (sp)+,d0-a6
	rts
ice_04:	bsr.s	ice_0c
	bcc.s	ice_07
	moveq	#0,d1
	bsr.s	ice_0c
	bcc.s	ice_06
	lea	ice_1a(pc),a1
	moveq	#4,d3
ice_05:	move.l	-(a1),d0
	bsr.s	ice_0f
	swap	d0
	cmp.w	d0,d1
	dbne	d3,ice_05
	add.l	20(a1),d1
ice_06:	move.b	-(a5),-(a6)
	dbra	d1,ice_06
ice_07:	cmpa.l	a4,a6
	bgt.s	ice_12
	rts
ice_08:	moveq	#3,d0
ice_09:	move.b	-(a5),d7
	ror.l	#8,d7
	dbra	d0,ice_09
	rts
ice_0a:	move.w	a5,d7
	btst	#0,d7
	bne.s	ice_0b
	move.l	-(a5),d7
	addx.l	d7,d7
	bra.s	ice_11
ice_0b:	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	bra.s	ice_11
ice_0c:	add.l	d7,d7
	beq.s	ice_0d
	rts
ice_0d:	move.w	a5,d7
	btst	#0,d7
	bne.s	ice_0e
	move.l	-(a5),d7
	addx.l	d7,d7
	rts
ice_0e:	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	rts
ice_0f:	moveq	#0,d1
ice_10:	add.l	d7,d7
	beq.s	ice_0a
ice_11:	addx.w	d1,d1
	dbra	d0,ice_10
	rts
ice_12:	lea	ice_1b(pc),a1
	moveq	#3,d2
ice_13:	bsr.s	ice_0c
	dbcc	d2,ice_13
	moveq	#0,d4
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bmi.s	ice_14
	bsr.s	ice_0f
ice_14:	move.b	6(a1,d2.w),d4
	add.w	d1,d4
	beq.s	ice_16
	lea	ice_1c(pc),a1
	moveq	#1,d2
ice_15:	bsr.s	ice_0c
	dbcc	d2,ice_15
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bsr.s	ice_0f
	add.w	d2,d2
	add.w	6(a1,d2.w),d1
	bra.s	ice_18
ice_16:	moveq	#0,d1
	moveq	#5,d0
	moveq	#0,d2
	bsr.s	ice_0c
	bcc.s	ice_17
	moveq	#8,d0
	moveq	#$40,d2
ice_17:	bsr.s	ice_0f
	add.w	d2,d1
ice_18:	lea	2(a6,d4.w),a1
	adda.w	d1,a1
	move.b	-(a1),-(a6)
ice_19:	move.b	-(a1),-(a6)
	dbra	d4,ice_19
	bra	ice_04
	DC.B $7f,$ff,$00,$0e,$00,$ff,$00,$07
	DC.B $00,$07,$00,$02,$00,$03,$00,$01
	DC.B $00,$03,$00,$01
ice_1a:	DC.B $00,$00,$01,$0d,$00,$00,$00,$0e
	DC.B $00,$00,$00,$07,$00,$00,$00,$04
	DC.B $00,$00,$00,$01
ice_1b:	DC.B $09,$01,$00,$ff,$ff,$08,$04,$02
	DC.B $01,$00
ice_1c:	DC.B $0b,$04,$07,$00,$01,$20,$00,$00
	DC.B $00,$20
;***************************************************************************

	DATA
PAL_LOGO	DS.L	8
BIG_DATA	INCBIN	LOGO.PAK
	EVEN
COD	INCBIN	DAMIER.COD
TABLE	DS.L	65
	DC.L	-1
	BSS
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	32000*2
