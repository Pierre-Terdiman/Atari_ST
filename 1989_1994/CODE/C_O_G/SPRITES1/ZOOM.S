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
	
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	LEA	IMG,A0
	LEA	BUF_ZOOM_DAT,A1
	JSR	decrunch
	LEA	IMG2,A0
	LEA	BUF_ZOOM_DAT2,A1
	JSR	decrunch

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#64000,D0
	MOVE.L	D0,SCREEN2

	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	MOVE.B	$FFFFFA15.W,MFP7
	MOVE.B	$FFFFFA17.W,MFP8
	MOVE.B	$FFFFFA19.W,MFP9
	MOVE.B	$FFFFFA1F.W,MFP10

	MOVE.L	$68.W,SAUVE_HBL
	MOVE.L	$134.W,SAUVE_TMA

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W


	MOVE.L	$44E.W,A0
	MOVE.L	#7999,D0
EFF_SCR	CLR.L	(A0)+
	DBRA	D0,EFF_SCR

	ANDI.B	#%11111000,$484.W

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W
	MOVE.L	#INTER_RTE,$68.W

BOUCLE	JMP	BOUCLE

FIN	
	MOVE	#$2700,SR
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	MOVE.B	MFP7,$FFFFFA15.W
	MOVE.B	MFP8,$FFFFFA17.W
	MOVE.B	MFP9,$FFFFFA19.W
	MOVE.B	MFP10,$FFFFFA1F.W
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	SAUVE_TMA,$134.W
	MOVE.L	SAUVE_HBL,$68.W

	MOVE	#$2300,SR


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
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

VBLR	
	CLR.B	$FFFFFA1B.W

	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W


	MOVEQ	#0,D0
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

	LEA	BUF_ZOOM_DAT,A1
	ADDA.L	LIGNE,A1
	
	REPT	7
	MOVE	(A1),(A0)+
	LEA	8(A1),A1
	MOVE	(A1),(A0)+
	LEA	8(A1),A1
	endr

	LEA	BUF_ZOOM_DAT2,A1
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
	MOVE.L	#256/2,D5
	LEA	BUFFER_,A6
	LEA	BUFFER_,A1
	LEA	128*2(A6),A6
	LEA	128*2(A1),A1
	LEA	BUFFER2,A5
	LEA	BUFFER2,A2
	LEA	128*2(A5),A5
	LEA	128*2(A2),A2
	
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
INTER_RTE	RTE

INTER_TMA:	CLR.B	$FFFFFA07.W		; ARRET DU MFP POUR NE PAS
	CLR.B	$FFFFFA09.W		; ETRE GENE
	MOVE	#$2100,SR		; ON AUTORISE LA HBL

	MOVE.L	A6,USP
	
full
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


	CLR.L	D7
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
	rept	198+29
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

;***************************************************************************
; Unpacking source for Pack-Ice Version 2.1
; a0: Pointer on packed Data
; a1: Pointer on destination of unpacked data
decrunch:	movem.l d0-a6,-(sp)
		cmpi.l	#'Ice!',(a0)+	; Is data packed?
		bne.s	ice_03		; no!
		move.l	(a0)+,d0	; read packed data
		lea	-8(a0,d0.l),a5
		move.l	(a0)+,(sp)
		movea.l a1,a4
		movea.l a1,a6
		adda.l	(sp),a6
		movea.l a6,a3
		bsr.s	ice_08
		bsr.s	ice_04
		bsr	ice_0c		;; Picture decrunch!
		bcc.s	ice_03		;; These marked lines may be
		move.w	#$0f9f,d7	;; removed in your own sources
ice_00:		moveq	#3,d6		;; if you do not use the
ice_01:		move.w	-(a3),d4	;; additional algorithm.
		moveq	#3,d5		;;
ice_02:		add.w	d4,d4		;;
		addx.w	d0,d0		;;
		add.w	d4,d4		;;
		addx.w	d1,d1		;;
		add.w	d4,d4		;;
		addx.w	d2,d2		;;
		add.w	d4,d4		;;
		addx.w	d3,d3		;;
		dbra	d5,ice_02	;;
		dbra	d6,ice_01	;;
		movem.w d0-d3,(a3)	;;
		dbra	d7,ice_00	;;
ice_03:		movem.l (sp)+,d0-a6
		rts
ice_04:		bsr.s	ice_0c
		bcc.s	ice_07
		moveq	#0,d1
		bsr.s	ice_0c
		bcc.s	ice_06
		lea	ice_1a(pc),a1
		moveq	#4,d3
ice_05:		move.l	-(a1),d0
		bsr.s	ice_0f
		swap	d0
		cmp.w	d0,d1
		dbne	d3,ice_05
		add.l	20(a1),d1
ice_06:		move.b	-(a5),-(a6)
		dbra	d1,ice_06
ice_07:		cmpa.l	a4,a6
		bgt.s	ice_12
		rts
ice_08:		moveq	#3,d0
ice_09:		move.b	-(a5),d7
		ror.l	#8,d7
		dbra	d0,ice_09
		rts
ice_0a:		move.w	a5,d7
		btst	#0,d7
		bne.s	ice_0b
		move.l	-(a5),d7
		addx.l	d7,d7
		bra.s	ice_11
ice_0b:		move.l	-5(a5),d7
		lsl.l	#8,d7
		move.b	-(a5),d7
		subq.l	#3,a5
		add.l	d7,d7
		bset	#0,d7
		bra.s	ice_11
ice_0c:		add.l	d7,d7
		beq.s	ice_0d
		rts
ice_0d:		move.w	a5,d7
		btst	#0,d7
		bne.s	ice_0e
		move.l	-(a5),d7
		addx.l	d7,d7
		rts
ice_0e:		move.l	-5(a5),d7
		lsl.l	#8,d7
		move.b	-(a5),d7
		subq.l	#3,a5
		add.l	d7,d7
		bset	#0,d7
		rts
ice_0f:		moveq	#0,d1
ice_10:		add.l	d7,d7
		beq.s	ice_0a
ice_11:		addx.w	d1,d1
		dbra	d0,ice_10
		rts
ice_12:		lea	ice_1b(pc),a1
		moveq	#3,d2
ice_13:		bsr.s	ice_0c
		dbcc	d2,ice_13
		moveq	#0,d4
		moveq	#0,d1
		move.b	1(a1,d2.w),d0
		ext.w	d0
		bmi.s	ice_14
		bsr.s	ice_0f
ice_14:		move.b	6(a1,d2.w),d4
		add.w	d1,d4
		beq.s	ice_16
		lea	ice_1c(pc),a1
		moveq	#1,d2
ice_15:		bsr.s	ice_0c
		dbcc	d2,ice_15
		moveq	#0,d1
		move.b	1(a1,d2.w),d0
		ext.w	d0
		bsr.s	ice_0f
		add.w	d2,d2
		add.w	6(a1,d2.w),d1
		bra.s	ice_18
ice_16:		moveq	#0,d1
		moveq	#5,d0
		moveq	#0,d2
		bsr.s	ice_0c
		bcc.s	ice_17
		moveq	#8,d0
		moveq	#$40,d2
ice_17:		bsr.s	ice_0f
		add.w	d2,d1
ice_18:		lea	2(a6,d4.w),a1
		adda.w	d1,a1
		move.b	-(a1),-(a6)
ice_19:		move.b	-(a1),-(a6)
		dbra	d4,ice_19
		bra	ice_04
		DC.B $7f,$ff,$00,$0e,$00,$ff,$00,$07
		DC.B $00,$07,$00,$02,$00,$03,$00,$01
		DC.B $00,$03,$00,$01
ice_1a:		DC.B $00,$00,$01,$0d,$00,$00,$00,$0e
		DC.B $00,$00,$00,$07,$00,$00,$00,$04
		DC.B $00,$00,$00,$01
ice_1b:		DC.B $09,$01,$00,$ff,$ff,$08,$04,$02
		DC.B $01,$00
ice_1c:		DC.B $0b,$04,$07,$00,$01,$20,$00,$00
		DC.B $00,$20
;***************************************************************************

	DATA
IMG	INCBIN	ZOOM_.DAT
IMG2	INCBIN	ZOOM2_.DAT

PALETTE2
	REPT	2
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
 	
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
MFP7	DS.B	1
MFP8	DS.B	1
MFP9	DS.B	1
MFP10	DS.B	1
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1

LIGNE	DS.L	1
LIGNE2	DS.L	1
CNT	DS.L	1
CNT2	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	64000*2
POINT2	DS.L	1
BUF_ZOOM_DAT	DS.B	32000
BUF_ZOOM_DAT2	DS.B	32000
BUFFER_	DS	256
BUFFER2	DS	256
z	ds.l	7*2
