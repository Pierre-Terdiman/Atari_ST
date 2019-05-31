*
* For Zappy & Elric
*
*  Voici le petit programme qui se charge d'afficher une image,
*  pack‚e … l'Ice (2.34) et sauv‚e avec le viewer (32Ko x2 pour l'image et
*  19Ko x2 pour la palette).
*  Ca ne tourne que sur STE, pour STF faudra que vous fassiez qqs modifs
*  (c'est-…-dire mettre les ‚crans sur une limite de page et virer les
*  deux ou trois lignes en trop dans la synchro (que j'ai rajout‚ … cause
*  du bit de poids faible de l'adresse ‚cran (qui n'est pas n‚cessairement
*  ‚gal … z‚ro sur STE (de toute facon, je suis sur que vous vous en
*  balancez complŠtement puisque vous allez tout refaire pour remettre dans
*  vos ‚crans (je commence … bien vous connaitre, hein?))))).
*
*  Au fait, les changements de palette sont g‚n‚r‚s, moi j'ai pas que ‡a
*  … faire, attendre que Devpac assemble 199 REPT...
*
*  PS important: J'ai laiss‚ … la fin les diverses routines dont je me
*                sers sous TOS pour les initialisations, etc, et qui sont
*                normalement dans un autre fichier que je trimballe
*                partout (c'est plus pratique...).
*                Vous y trouverez (si vous ne l'avez pas dŠj…) le petit
*                bout de code qui d‚sactive le cache du Mega STE. Pensez-y,
*                pendant le boot de la d‚mo!
*

	OPT	O-,W+

***************************************************************************
* Initialisations *********************************************************
***************************************************************************
	
	clr.l	-(a7)
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	move.l	d0,Save_USP
	move.l	a7,Save_SSP
	move.l	#NewStack,a7
	
	move.w	#$2700,sr
	jsr	Test_Cache_STE

	move.b	$44c.w,Save_Rez
	move.l	$44e.w,Save_Scr
	move.l	$70.w,Save_Inter
	move.l	$68.w,Save_Inter+4
	move.b	$ffff820a.w,Save_Sync

	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,Save_Pal

	move.b	#$12,$fffffc02.w
	move.b	#$15,$fffffc02.w

	movem.l	ZeroBuffer,d0-d7
	movem.l	d0-d7,$ffff8240.w

	move.b	Screen+1,$ffff8201.w
	move.b	Screen+2,$ffff8203.w
	move.b	Screen+3,$ffff820d.w	<= STE

	moveq	#0,d3
	moveq	#2,d4
	jsr	ShifterReset
	jsr	SaveMfp
	jsr	SaveVectors
	jsr	GenereColorBlk

	move.l	#MainVBL,$70.w

	lea	Pic1(pc),a0
	lea	ScreenBuffer,a1
	jsr	IceDecrunch
	move.l	#ScreenBuffer,Screen
	move.l	#ScreenBuffer+32000,Screen+4
	move.l	#PalBuffer+32,PCSPal
	move.l	#PalBuffer+19136+32,PCSPal+4
	move.w	#$2300,sr

WaitKbd	cmp.b	#$39+$80,$fffffc02.w
	bne.s	WaitKbd

***************************************************************************
* Restitution *************************************************************
***************************************************************************

Restitution
	move.w	#$2700,sr		Regardez bien, voici une
	clr.b	$ffff820f.w	 routine de restitution.
	clr.b	$ffff8265.w
	sf	$fffffa07.w	(...)
	sf	$fffffa09.w

	movem.l	ZeroBuffer,d0-7
	movem.l	d0-7,$ffff8240.w
	clr.b	$ffff8901.w

	jsr	RestoreMfp

	lea	Save_Scr,a0
	move.b	1(a0),$ffff8201.w	
	move.b	2(a0),$ffff8203.w
	move.b	3(a0),$ffff820d.w
	clr.b	$ffff820f.w
	clr.b	$ffff8265.w

	movem.l	Save_Pal,d0-d7
	movem.l	d0-d7,$ffff8240.w

	move.l	Save_Inter,$70.w
	move.l	Save_Inter+4,$68.w

	bsr	Reset_Acia
	move.b	#$08,d0
	bsr	Att_Acia
	move.b	#$1a,d0
	bsr	Att_Acia
	bsr	Flush_Key
	move.w	#$12,$fffffc02.w
	move.w	#$08,$fffffc02.w

	move.b	Save_Rez,d3
	move.b	Save_Sync,d4
	jsr	ShifterReset
	jsr	Restaure_Cache_STE
	
	move.l	Save_SSP,a7
	move.w	#$2300,sr
	move.l	Save_USP,-(a7)
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	
	clr.w	-(a7)
	trap	#1

***************************************************************************

MainVBL	move.b	Screen+1,$fffff8201.w
	move.b	Screen+2,$ffff8203.w
	move.b	Screen+3,$ffff820d.w		<= STE
	
	movem.l	d0-a6,-(a7)

	move.l	PCSPal+4(pc),a0
	lea	-30(a0),a0
	lea	$ffff8242.w,a1
	move.w	(a0)+,(a1)+
	REPT	7
	move.l	(a0)+,(a1)+
	ENDR

	bsr	SynchroPCS

	lea	Screen(pc),a0
	move.l	4(a0),d0
	move.l	(a0),4(a0)
	move.l	d0,(a0)
	lea	PCSPal(pc),a0
	move.l	4(a0),d0
	move.l	(a0),4(a0)
	move.l	d0,(a0)

	movem.l	(a7)+,d0-a6

	st	VBLFlag
	cmp.b	#$2a,$fffffc02.w
	bne.s	.NoCol
	move.w	#$4,$ffff8240.w
.NoCol	
RTE	rte

VBLFlag	dc.b	0,0
Screen	dc.l	ScreenBuffer,ScreenBuffer+200*160
PCSPal	dc.l	PalBuffer,PalBuffer+19136


***************************************************************************

SynchroPCS	move.w	#$2700,sr
	move.l	a7,SaveA7
	move.l	PCSPal(pc),a7
	lea	$ffff8209.w,a6
	clr.w	d0
	move.b	(a6),d0
	move.b	d0,d1		<= STE
.Sync	cmp.b	(a6),d0
	beq.s	.Sync
	move.b	(a6),d0
	sub.b	d1,d0		<= STE
	neg.w	d0
	lsl.w	d0,d0
	moveq	#17,d0
	dbf	d0,*
	nop
	jmp	DisplayColors
	move.l	#0,A7
SaveA7	EQU	*-4
	move.w	#$2300,sr
	rts

GenereColorBlk
	lea	DisplayColors,a0
	lea	BegColorBlk(pc),a1
	move.l	#EndColorBlk,d0
	sub.l	#BegColorBlk,d0
	lsr.w	#1,d0
	subq.w	#1,d0
	move.w	#198,d1
.NextBlk	move.l	a1,a2
	move.l	d0,d2
.NextWord	move.w	(a2)+,(a0)+
	dbf	d2,.NextWord
	dbf	d1,.NextBlk
	lea	-10(a0),a0
	move.w	#$4ef9,(a0)+
	move.l	#SaveA7-2,(a0)
	rts

BegColorBlk
	MOVEM.L	(A7)+,A0-A6/D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVEM.L	A0-A6,$FFFF8240.W
	MOVE.L	(A7)+,$FFFF825C.W
	LEA	$FFFF8240.W,A0
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.W	#0,$FFFF8240.W
	MOVE.L	(A7)+,(A0)+
	MOVE.W	#0,D0
	DBF	D0,*
	NOP
EndColorBlk

***************************************************************************
* Ice depacking (2.34) ****************************************************
***************************************************************************

IceDecrunch
	movem.l d0-a6,-(sp)
	bsr.s	.Ice05
	cmpi.l	#'ICE!',d0
	bne.s	.Ice04
	bsr.s	.Ice05
	lea	-8(a0,d0.l),a5
	bsr.s	.Ice05
	move.l	d0,(sp)
	movea.l a1,a4
	movea.l a1,a6
	adda.l	d0,a6
	movea.l a6,a3
	move.b	-(a5),d7
	bsr.s	.Ice07
	bsr.s	.Ice0B
	bcc.s	.Ice04
	move.w	#$0f9f,d1
	bsr.s	.Ice0B
	bcc.s	.Ice00
	moveq	#$0f,d0
	bsr.s	.Ice0D
.Ice00	move.w	d1,d7
.Ice01	moveq	#3,d6
.Ice02	move.w	-(a3),d4
	moveq	#3,d5
.Ice03	add.w	d4,d4
	addx.w	d0,d0
	add.w	d4,d4
	addx.w	d1,d1
	add.w	d4,d4
	addx.w	d2,d2
	add.w	d4,d4
	addx.w	d3,d3
	dbra	d5,.Ice03
	dbra	d6,.Ice02
	movem.w d0-d3,(a3)
	dbra	d7,.Ice01
.Ice04	movem.l (sp)+,d0-a6
	rts
.Ice05	moveq	#3,d1
.Ice06	lsl.l	#8,d0
	move.b	(a0)+,d0
	dbra	d1,.Ice06
	rts
.Ice07	bsr.s	.Ice0B
	bcc.s	.Ice0A
	moveq	#0,d1
	bsr.s	.Ice0B
	bcc.s	.Ice09
	lea	.Ice18(pc),a1
	moveq	#4,d3
.Ice08	move.l	-(a1),d0
	bsr.s	.Ice0D
	swap	d0
	cmp.w	d0,d1
	dbne	d3,.Ice08
	add.l	20(a1),d1
.Ice09	move.b	-(a5),-(a6)
	dbra	d1,.Ice09
.Ice0A	cmpa.l	a4,a6
	bgt.s	.Ice10
	rts
.Ice0B	add.b	d7,d7
	bne.s	.Ice0C
	move.b	-(a5),d7
	addx.b	d7,d7
.Ice0C	rts
.Ice0D	moveq	#0,d1
.Ice0E	add.b	d7,d7
	bne.s	.Ice0F
	move.b	-(a5),d7
	addx.b	d7,d7
.Ice0F	addx.w	d1,d1
	dbra	d0,.Ice0E
	rts
.Ice10	lea	.Ice19(pc),a1
	moveq	#3,d2
.Ice11	bsr.s	.Ice0B
	dbcc	d2,.Ice11
	moveq	#0,d4
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bmi.s	.Ice12
	bsr.s	.Ice0D
.Ice12	move.b	6(a1,d2.w),d4
	add.w	d1,d4
	beq.s	.Ice14
	lea	.Ice1A(pc),a1
	moveq	#1,d2
.Ice13	bsr.s	.Ice0B
	dbcc	d2,.Ice13
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bsr.s	.Ice0D
	add.w	d2,d2
	add.w	6(a1,d2.w),d1
	bpl.s	.Ice16
	sub.w	d4,d1
	bra.s	.Ice16
.Ice14	moveq	#0,d1
	moveq	#5,d0
	moveq	#-1,d2
	bsr.s	.Ice0B
	bcc.s	.Ice15
	moveq	#8,d0
	moveq	#$3f,d2
.Ice15	bsr.s	.Ice0D
	add.w	d2,d1
.Ice16	lea	2(a6,d4.w),a1
	adda.w	d1,a1
	move.b	-(a1),-(a6)
.Ice17	move.b	-(a1),-(a6)
	dbra	d4,.Ice17
	bra	.Ice07
	DC.B $7f,$ff,$00,$0e,$00,$ff,$00,$07
	DC.B $00,$07,$00,$02,$00,$03,$00,$01
	DC.B $00,$03,$00,$01
.Ice18	DC.B $00,$00,$01,$0d,$00,$00,$00,$0e
	DC.B $00,$00,$00,$07,$00,$00,$00,$04
	DC.B $00,$00,$00,$01
.Ice19	DC.B $09,$01,$00,$ff,$ff,$08,$04,$02
	DC.B $01,$00
.Ice1A	DC.B $0b,$04,$07,$00,$01,$1f,$ff,$ff
	DC.B $00,$1f
	even

***************************************************************************
* Flush clavier ***********************************************************
***************************************************************************

Flush_Key	move.w	#$22,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,a0
	clr.b	109(a0)
	clr.b	79(a0)
	rts

Reset_Acia	move.b	#3,$fffffc00.w	
	move.b	#$96,$fffffc00.w
	move.b	#$80,d0
	bsr.s	Att_Acia
	move.b	#$01,d0
	bsr.s	Att_Acia
	
	rts
	
Att_Acia	lea	$fffffc00.w,a0
.Att	move.b	(a0),d1
	btst	#1,d1
	beq.s	.Att
	move.b	d0,2(a0)
	rts

***************************************************************************
* Sauvegarde MFP **********************************************************
***************************************************************************

SaveMfp	
	Lea	$FFFFFA00.w,A0
	Lea	Save_Mfp,A1
	Movep.l	$3(A0),D0
	Move.l	D0,(A1)+
	Movep.w	$13(A0),D0
	Move.w	D0,(A1)+
	Move.b	$19(A0),D0
	Move.b	$1B(A0),D1
	Move.b	$1D(A0),D2
	Moveq	#$1,D3
	Moveq	#$0,D4
	Lea	$1F(A0),A3
	Lea	$19(A0),A2
	Bsr.s	ReadDataRegister
	Lea	$1B(A0),A2
	Bsr.s	ReadDataRegister
	Moveq	#$10,D3
	Lea	$1D(A0),A2
	Bsr.s	ReadDataRegister
	Moveq	#$1,D3
	Bsr.s	ReadDataRegister
	Move.b	D0,$19(A0)
	Move.b	D1,$1B(A0)
	Move.b	D2,$1D(A0)
	Move.b	D0,(A1)+
	Move.b	D1,(A1)+
	Move.b	D2,(A1)+
	Move.b	$29(A0),(A1)+
	Move.b	$17(A0),(A1)+
	Rts
	
ReadDataRegister
	Move.b	D3,(A2)
	Move.b	D4,(A2)
	Cmp.b	#$1,(A3)
	Bne.s	ReadDataRegister
ReadOffsetData
	Move.b	D3,(A2)
	Move.b	D4,(A2)
	Cmp.b	#$1,(A3)
	Beq.s	ReadOffsetData
	Move.b	(A3),(A1)+
	Addq.l	#$2,A3
	Rts

SaveVectors
	move.b	$fffffa17.w,d0
	and.l	#$f0,d0
	lsl.w	#2,d0
	move.l	d0,a1
	lea	Save_Vec,a0
	move.l	a1,(a0)+
	move.w	#15,d0
.0	move.l	(a1)+,(a0)+
	dbf	d0,.0
	
	lea	$fffffa00.w,a0
	moveq	#0,d0
	movep.l	d0,$7(a0)
	movep.l	d0,$f(a0)
	movep.l	d0,$17(a0)
	movep.l	d0,$1f(a0)
	move.b	#$40,$17(a0)
	rts

***************************************************************************
* Restauration MFP ********************************************************
***************************************************************************

RestoreMfp
	Lea	Save_Mfp,A0
	Lea	$FFFFFA00.w,A1
	Move.l	(A0)+,D0
	Movep.l	D0,$3(A1)
	Move.w	(A0)+,D0
	Movep.w	D0,$13(A1)
	Clr.b	$19(A1)
	Clr.b	$1B(A1)
	Clr.b	$1D(A1)
	Move.l	(A0)+,D0
	Movep.l	D0,$1F(A1)
	Move.b	(A0)+,$19(A1)
	Move.b	(A0)+,$1B(A1)
	Move.b	(A0)+,$1D(A1)
	Move.b	(A0)+,$29(A1)
	Move.b	(A0)+,$17(A1)
	
	lea	Save_Vec,a0
	move.l	(a0)+,a1
	move.w	#15,d0
.0	move.l	(a0)+,(a1)+
	dbf	d0,.0
	rts

***************************************************************************
* Gestion cache Mega STE **************************************************
***************************************************************************

Test_Cache_STE
	MOVEM.L	D0/A0-2,-(A7)
	SUBA.L	A0,A0
	MOVE.L	A7,A2			
	MOVE.L	8(A0),A1		
	MOVE.L	#.ERRBUS1,8(A0)		
	MOVE.B	$FFFF8E21.W,D0
	MOVE.B	D0,OLD_CACHE_VAL
	AND.B	#$FC,D0
	MOVE.B	D0,$FFFF8E21.W
.ERRBUS1	MOVE.L	A1,8(A0)		
	MOVE.L	A2,A7
	MOVEM.L	(A7)+,D0/A0-2
	RTS
OLD_CACHE_VAL
	DC.B	0,0
	
Restaure_Cache_STE
	MOVE.B	OLD_CACHE_VAL,D0
	TST.B	D0
	BEQ.S	.Y_AVAIT_PAS_DE_CACHE_DE_MIS_SUR_LE_MEGA_STE
	MOVE.B	D0,$FFFF8E21.W
.Y_AVAIT_PAS_DE_CACHE_DE_MIS_SUR_LE_MEGA_STE
	RTS

***************************************************************************
* Reset shifter ***********************************************************
***************************************************************************

ShifterReset
	movem.l	d0-2/a0-3,-(a7)
	move.l	$120.w,a3
	move.l	#RTE,$120.w
	lea	$ffff8000.w,a0
	lea	$fffffa21.w,a1
	lea	$fffffa1b.w,a2
	move.b	#$10,(a2)
	moveq	#1,d2
	move.b	#0,(a2)
	move.b	#10,(a1)
	move.b	#8,(a2)
.Sync1	move.b	(a1),d0
	cmp.b	d2,d0
	bne.s	.Sync1
.Sync2	move.b	(a1),d2
	move.w	#$267,d1
.Sync3	cmp.b	(a1),d2
	bne.s	.Sync2
	dbf	d1,.Sync3
	move.b	#$10,(a2)
	move.b	d3,$260(a0)
	move.b	d4,$20a(a0)
	move.l	a3,$120.w
	movem.l	(a7)+,d0-2/a0-3
	rts

***************************************************************************
***************************************************************************
***************************************************************************

	SECTION	DATA

	even
Pic1	incbin	m:\ranma3.bin
	even

	SECTION	BSS
	
Save_SSP	ds.l	1
Save_USP	ds.l	1
Save_Mfp	ds.l	16
Save_Vec	ds.l	17
Save_Pal	ds.l	8
Save_Scr	ds.l	1
Save_Rez	ds.w	1
Save_Inter	ds.l	2
Save_Sync	ds.w	1
ZeroBuffer	ds.b	160
	ds.l	50
NewStack	ds.l	20
	ds.b	$100
ScreenBuffer
	ds.b	200*160*2
PalBuffer	ds.b	19136*2
DisplayColors
	ds.b	11200
