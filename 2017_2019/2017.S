
;	opt	o+,a+
	opt	o+
;	opt	p+

	section text

NO_PRECA		set	0
USE_PRECA0		set	0
USE_PRECA1		set	0
USE_PRECA2		set	1
USE_MUSIC		set	0
USE_PRECA_MUSIC	set	0
USE_DOTS		set	1
USE_OPTIM		set	0
COPY_DOTS		set	0
FLIP_COPY		set	0
DOT_SHADOW		set	0

;NB_PTS	=	7*1200
;NB_PTS	=	7*950
;NB_PTS	=	7*930
NB_PTS	=	7*900	*
;NB_PTS	=	7*875
;NB_PTS	=	7*856	(5992)
;NB_PTS	=	7*800
;NB_PTS	=	7*500
;NB_PTS	=	7*456
;NB_PTS	=	7*400
;NB_PTS	=	7*300
;NB_PTS	=	7*200
;NB_PTS	=	7*100

;X_STEP		= 800
X_STEP		= 555

;Y_DIVIDER	= 585
Y_DIVIDER	= 490
;Y_DIVIDER	= 350

;Y_MARGIN	= 8
Y_MARGIN	= 0
Y_DEP		= 160*Y_MARGIN
;Y_SIZE		= 141
Y_SIZE		= 200
DATA_SIZE	= 16000
CURVE_INC	= 4
CURVE_SHIFT	= 2
NB_FRAMES	= DATA_SIZE/CURVE_INC
;Time to wrap = 16000/4 = 4000 frames = 80 seconds

	bra		Start
	include	LIB/BSS.S
	include	LIB/ENV.S
	include	LIB/STPS.S
	include	LIB/600.S
	include	LIB/SYS.S

Start:
;	OR.B D0,$1234(A0)
;	ADD.B D0,$1234(A0)
;	MOVE.B D0,$1234(A0)
;	MOVE.L	D0,$1234(A0)
;	move.w	$1111(a0),$2222(a0)	$316811112222

;	lea	Data,a0
;	movem.w	(a0)+,a1-a2		;this extends the sign and writes FFFF in high bits when offset is negative
;	OR.B D0,32767(A0)		;max positive offset
;	OR.B D0,-32768(A0)		;max negative offset
;Data	dc.w	$7fff,$8000	

;	move	#$8000,a0
;	lea		$8000(a1),a0

;	movem.w	(sp)+,a0-a7

	bsr		Lib_ClearBSS

	SwitchToSuper

	IFNE	USE_PRECA2
		lea		CurrentColumnData2,a3
		moveq	#0,d4	;Frame counter
		move.l	#NB_FRAMES*2,d5	;shuffled format
		move	#NB_FRAMES-1-2,d0
.InitData:
		lea		PRECA,a1
		move.l	FrameCounter,d0		;the data has been pre-shifted so no need to adjust this
		adda.l	d4,a1				;shuffled format

		moveq	#10-1,d7
.ProcessColumn1
		moveq	#0,d1
		moveq	#0,d2
			move.b	(a1),d1				;min (shuffled format)
			move.b	NB_FRAMES(a1),d2	;max (shuffled format)
			add.l	d5,a1				;shuffled format

			add.b	(a3),d1		;min (shuffled format + delta)
			move.b	d1,(a3)+	;shuffled format + delta
			add.b	(a3),d2		;min (shuffled format + delta)
			move.b	d2,(a3)+	;shuffled format + delta
		dbf		d7,.ProcessColumn1
		dbf		d0,.InitData
	ENDC

;	bsr		GenerateCode

;	move.l	#Y_SIZE,d0
;	lea		ClearCode0,a0
;	jsr		GenerateClearCodePlanes1_4
;	lea		BUF_COD,a1

;	move.l	#Y_SIZE,d0
;	lea		CopyCode0,a0
;	jsr		GenerateCopyCodePlanes1_4
;	lea		BUF_COD,a1

	bsr		Lib_SaveEnv

	move.b	#0,$ffff8260.w	;Switch to low res

	move.w	#$2700,SR

	IFEQ	USE_DOTS
	move.l	#ScreenBuffer,d0
	clr.b	d0
	move.l	d0,ScreenPtr1
	addi.l	#32000,d0
	move.l	d0,ScreenPtr2

	move.b	ScreenPtr1+1,$FFFF8201.w
	move.b	ScreenPtr1+2,$FFFF8203.w

;		move.l	ScreenPtr1,a0
;		move.l	#32000/4,d0
;		move.l	#$12341234,d1
;	.ClearScreen:	
;		move.l	d1,(a0)+
;		dbra	d0,.ClearScreen
	ENDC

	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w

;Redirect exception vectors to quit
	move.l	#Quit,$008.w
	move.l	#Quit,$00C.w
	move.l	#Quit,$010.w
	move.l	#Quit,$014.w
	move.l	#Quit,$018.w
	move.l	#Quit,$01c.w
	move.l	#Quit,$020.w
	move.l	#Quit,$024.w

	MOVE.L	#$00010001,D0
	MOVE.L	D0,$FFFF8240.W
	MOVE.L	D0,$FFFF8244.W
	MOVE.L	D0,$FFFF8248.W
	MOVE.L	D0,$FFFF824C.W
	MOVE.L	D0,$FFFF8250.W
	MOVE.L	D0,$FFFF8254.W
	MOVE.L	D0,$FFFF8258.W
	MOVE.L	D0,$FFFF825C.W

		lea		$FFFF8240.W,a0
		moveq	#16-1,d0
	.AllWhite:
		move.w	#$ffff,(a0)+
		dbf		d0,.AllWhite
		MOVE.w	#$0001,$FFFF8240.W

	MOVE.L	#InterRTE,$70.W
	
	lea		SavedRAM,a0
	bsr		Init600
	
	IFNE	USE_MUSIC
		moveq	#1,d0
		bsr		Music
	ENDC

	IFNE	USE_PRECA_MUSIC
		lea		YM,a0
		move.l	(a0)+,d0		;File ID "YM6!"
		move.l	(a0)+,d0		;String
		move.l	(a0)+,d0		;String
		move.l	(a0)+,NbFrames	;#frames
		move.l	(a0)+,d0		;Song attribs
		move.w	(a0)+,d0		;#digidrums
		move.l	(a0)+,d0		;YM master clock in Hz
		move.w	(a0)+,d0		;50Hz
		move.l	(a0)+,d0		;Loop frame
		move.w	(a0)+,d0		;Size in bytes of extra data
		
		;<digidrums skipped>
		
		bsr		SkipString	;Song name
		bsr		SkipString	;Author name
		bsr		SkipString	;Song comment

		move.l	a0,SongDataPtr
		move.l	#0,CurrentFrame
	ENDC
	
	IFNE	USE_DOTS
		jsr		InitDots
		jsr		Dots
	ENDC

	IFEQ	USE_DOTS
		move.l	#VBL,$70.w
	ENDC

	move.w	#$2300,SR

Loop:
	bra.s	Loop

;======================================
Quit:
	move.w	#$2700,SR
	
	IFNE	USE_MUSIC	
	moveq	#0,d0
	bsr		Music
	ENDC

	move.l	#InterRTE,$008.w
	move.l	#InterRTE,$00C.w
	move.l	#InterRTE,$010.w
	move.l	#InterRTE,$014.w
	move.l	#InterRTE,$018.w
	move.l	#InterRTE,$01c.w
	move.l	#InterRTE,$020.w
	move.l	#InterRTE,$024.w
	move.l	#InterRTE,$68.w
	move.l	#InterRTE,$70.w
	move.l	#InterRTE,$114.w
	move.l	#InterRTE,$118.w
	move.l	#InterRTE,$120.w
	move.l	#InterRTE,$134.w

	bsr		Lib_StopSound

	lea		SavedRAM,a1
	bsr		Restore600

	bsr		Lib_RestoreEnv

	BackToUser
;Quit
	clr.w	-(sp)
	trap	#1

;======================================

	IFNE	USE_PRECA_MUSIC
SkipString:
	move.b	(a0)+,d0
	bne.s	SkipString
	rts
	ENDC
	
;======================================

	IFEQ	USE_DOTS
FlipBuffers:
	move.l	ScreenPtr1,d0
	move.l	ScreenPtr2,ScreenPtr1
	move.l	d0,ScreenPtr2

	move.b	ScreenPtr1+1,$FFFF8201.w
	move.b	ScreenPtr1+2,$FFFF8203.w
	RTS
	ENDC
	
;======================================
	IFEQ	USE_DOTS
VBL:
	move.w	#$0001,D0
	MOVE.w	D0,$FFFF8240.W

	lea		$FFFF8240.W,a0
	
	move.l	#$000f000f,d1
	move.l	#$00f000f0,d2
	move.l	#$0f000f00,d3
	move.l	#$00ff00ff,d4
	move.l	#$0f0f0f0f,d5
	move.l	#$0ff00ff0,d6
	moveq	#$0,d7

	move.w	#$000f,a1
	move.w	#$00f0,a2
	move.w	#$0f00,a3
	move.w	#$00ff,a4
	move.w	#$0f0f,a5
	move.w	#$0ff0,a6
	move.w	#$0,d7

  MOVE.B  #$18,D0 
  MOVE    #$2700,SR 
L0004:TST.B   $FFFF8209.W
  BEQ.s     L0004 
  SUB.B   $FFFF8209.W,D0 
  LSR.L   D0,D0 
;  JSR     ROUTINE

;	jmp		VBLDone
;	INCLUDE	COLORTST.s

;	MOVE    #$2300,SR



;	move.l	ScreenPtr1,a0
;	move.l	#32000/4,d0
;	move.l	#8000/4,d0
;.ClearScreen:	
;	clr.l	(a0)+
;	dbf		d0,.ClearScreen
	
VBLDone:	

	jmp		SkipStuff
	move.l	ScreenPtr1,a0
	moveq	#100-1,d0
.TestScreen:	
;	move.w	#$1111,(a0)
;	move.w	#$ffff,(a0)
;	move.w	#$ffff,8(a0)
	move.l	#$ffffffff,6(a0)
	lea		160(a0),a0
	dbf		d0,.TestScreen
SkipStuff:


;	move.w	#$000f,D0
;	MOVE.w	D0,$FFFF8240.W
	IFNE	USE_MUSIC	
	bsr		Music+4
;	bsr		Music+8
	ENDC

;	move.w	#$00f0,D0
;	MOVE.w	D0,$FFFF8240.W
	bsr	FlipBuffers

;	move.w	#$ffff,D0
;	MOVE.w	D0,$FFFF8240.W

	cmpi.b	#$39,$fffffc02.w
 	bne.s	.EndVBL
 	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
.EndVBL:
	ENDC
	
InterRTE:
	rte
;======================================

	IFNE	USE_DOTS
InitDots:

	lea		MulsTable,a0
	move	#-200*160,d1
	move	#400-1,d0
.InitMulsTable
	move	d1,(a0)+
	add		#160,d1
	dbf		d0,.InitMulsTable

	lea		$600.w,a0
	move	a0,SCREEN1
;	lea		(200-Y_MARGIN)*160(a0),a0
	lea		200*160(a0),a0
	move	a0,SCREEN2

	;Try to draw some pattern on plane 3 to change teh
;		move.l	SCREEN1,a0
;		move.l	SCREEN2,a1
;		move.l	#100*20-1,d0
;		move.l	#$ffff,d1
;.SetPlane3:
;;		move.w	d1,4(a0)
;;		move.w	d2,4(a1)
;		lea		8(a0),a0
;;		lea		8(a1),a1
;		dbra	d0,.SetPlane3



		MOVE	SCREEN1,D0
		SWAP	D0
		CLR		D0
		SWAP	D0
		MOVE.L	D0,A0
		
		MOVE	SCREEN2,D0
		SWAP	D0
		CLR		D0
		SWAP	D0
		MOVE.L	D0,A1
		
;		move.l	#$ffff,d0
		move.l	#$aaaa,d0
		move.l	#$5555,d1
		move.l	#200-1,d7
.SetPlan3
N	set		0
;		REPT	10
		REPT	20
		move.w	d0,4+N(a0)
		move.w	d0,4+N(a1)
N	set		N+8
		ENDR
		exg.l	d0,d1
		lea		160(a0),a0
		lea		160(a1),a1
		dbf		d7,.SetPlan3







	move.l	#BIG_BUF1,ADR1
	move.l	#BIG_BUF2,ADR2
;	move.l	#BUF_COD,COD1
;	move.l	#BUF_COD2,COD2

	JSR		PREP_MOUNT
	bsr		GenerateCode

	move.l	#Y_SIZE,d0
	lea		ClearCode0,a0
	jsr		GenerateClearCodePlanes1_4
	
	move.l	#Y_SIZE,d0
	lea		CopyCode0,a0
	jsr		GenerateCopyCodePlanes1_4


	
;	JSR		SWAPEC

	
	
	rts

Dots:

	CLR.B	$FFFF8201.W
	MOVE.B	SCREEN1,$FFFF8203.W

	JMP	SKIP_TEXT
		MOVE	SCREEN1,D0
		SWAP	D0
		CLR	D0
		SWAP	D0
		MOVE.L	D0,A0
		LEA	160*60(A0),A0
		MOVE	SCREEN2,D0
		SWAP	D0
		CLR	D0
		SWAP	D0
		MOVE.L	D0,A1
		LEA	160*60(A1),A1
		LEA	TXT,A2
		MOVE	#24-1,D7
.AF_TXT
N	SET	0
		REPT	20
		MOVE	(A2),N+4(A0)
		MOVE	(A2)+,N+4(A1)
N	SET	N+8
		ENDR
		LEA	160(A0),A0
		LEA	160(A1),A1
		DBF	D7,.AF_TXT
		MOVE	#$666,$FFFF8244.W
SKIP_TEXT:

;	JSR	PREP_MOUNT
;	bsr	GenerateCode

	MOVE.L	#InterRTE,$120.W
	MOVE.L	#InterRTE,$134.W

	;Setup colors
	
;		lea		$FFFF8240.W,a0
;		moveq	#16-1,d0
;	.AllRed:
;		move.w	#$700,(a0)+
;		dbf		d0,.AllRed

	IFEQ	DOT_SHADOW
;	MOVE	#$001,$FFFF8240.W
	MOVE	#$222,$FFFF8240.W
	ENDC

	IFNE	DOT_SHADOW
	MOVE	#$222,$FFFF8240.W
	ENDC

;	MOVE	#$444,$FFFF8242.W
;	MOVE	#$444,$FFFF8246.W
;	MOVE	#$444,$FFFF8250.W
;	MOVE	#$444,$FFFF8256.W

	;$FFFF8240.W	;0	0000
	;$FFFF8242.W	;1	0001	plan 1	second part of the curve
	;$FFFF8244.W	;2	0010	plan 2	text
	;$FFFF8246.W	;3	0011			curve overlapping with text
	;$FFFF8248.W	;4	0100	plan 3
	;$FFFF824a.W	;5	0101
	;$FFFF824c.W	;6	0110
	;$FFFF824e.W	;7	0111
	;$FFFF8250.W	;8	1000	plan 4	first part of the curve
	;$FFFF8252.W	;9	1001
	;$FFFF8254.W	;10	1010			curve overlapping with text
	;$FFFF8256.W	;11	1011
	;$FFFF8258.W	;12	1100
	;$FFFF825a.W	;13	1101
	;$FFFF825c.W	;14	1110
	;$FFFF825e.W	;15	1111

;	MOVE	#$444,$FFFF8242.W
;	MOVE	#$444,$FFFF8250.W
;	MOVE	#$777,$FFFF8246.W
;	MOVE	#$777,$FFFF8254.W

	MOVE	#$334,$FFFF8242.W
	MOVE	#$334,$FFFF8250.W
	MOVE	#$445,$FFFF8244.W
;	MOVE	#$544,$FFFF8244.W
	MOVE	#$777,$FFFF8246.W
	MOVE	#$777,$FFFF8254.W

;	MOVE	#$556,$FFFF8248.W
;	MOVE	#$777,$FFFF824a.W
;	MOVE	#$777,$FFFF824c.W
;	MOVE	#$777,$FFFF824e.W
;	MOVE	#$777,$FFFF8258.W
;	MOVE	#$777,$FFFF825a.W
;	MOVE	#$777,$FFFF825c.W
;	MOVE	#$777,$FFFF825e.W

	move	#$433,d0			;Color for plane1/4 dot on background
	move	#$544,d1			;Color for plane2 dot on background
;	move	#$730,d0			;Color for plane1/4 dot on background
;	move	#$640,d1			;Color for plane2 dot on background

	MOVE	#$222,$FFFF8248.W
	MOVE	#$223,$FFFF8248.W	;background (plan 3)
	MOVE	d0,$FFFF824a.W		;plan4 dot on plan3 background
	MOVE	d1,$FFFF824c.W		;plan2 dot on plan3 background (i.e. copy dot)
	MOVE	#$777,$FFFF824e.W
	MOVE	d0,$FFFF8258.W		;plan1 dot on plan3 background
	MOVE	#$070,$FFFF825a.W
	MOVE	#$777,$FFFF825c.W
	MOVE	#$070,$FFFF825e.W

	IFNE	DOT_SHADOW
	MOVE	#$111,$FFFF8244.W
	ENDC

	MOVE.L	#VBL_DOTS,$70.W

	rts

VBL_DOTS
	move.w	#$2700,SR
	
	MOVE	#$222,$FFFF8240.W

;		MOVE	SCREEN1,D0
;		SWAP	D0
;		CLR		D0
;		SWAP	D0
;		MOVE.L	A7,USP
;		MOVE.L	D0,A7
;		lea		160*200(a7),a7
;
;		MOVE	#$222,$FFFF8240.W
;		moveq	#0,d0
;		moveq	#0,d1
;		moveq	#0,d2
;		moveq	#0,d3
;		moveq	#0,d4
;		moveq	#0,d5
;		moveq	#0,d6
;		moveq	#0,d7
;		move.l	#0,a0
;		move.l	#0,a1
;		move.l	#0,a2
;		move.l	#0,a3
;		move.l	#0,a4
;		move.l	#0,a5
;		move.l	#0,a6
;	;	move.l	#0,a7
;		REPT	533
;		movem.l	D0-a6,-(a7)
;		ENDR
;		MOVE.L	USP,A7
;		MOVE	#$070,$FFFF8240.W
;		rte

;	movem.l	revp(pc),d0-7
;	movem.l	d0-7,$ffff8240.w
;	jmp		JumpOver
;revp	dc.w	$009,$009,$009,$009
;	dc.w	$009,$009,$009,$009
;	dc.w	$901,$a81,$b11,$c29
;	dc.w	$532,$6c3,$edb,$ffd
;JumpOver:

	bsr		ClearScreen

	move.l	ADR1,a0				;Either BIG_BUF1 or BIG_BUF2
	move.l	FrameCounter,d0
	lsl.w	#CURVE_SHIFT,d0		;**********
	adda.l	d0,a0

	lea		PixelMask,a1
	movem.w	(a1),d0-d7

	;with 2 codegen buffers
;	MOVE.L	COD1,A2
;	JSR		(A2)
	;with 1 codegen buffer
	jsr		BUF_COD

	cmpi.b	#$f,$fffffc02.w
 	bne.s	.NoTAB
	MOVE	#$0f0,$FFFF8240.W
.NoTAB:

	;========================
	cmpi.b	#59,$fffffc02.w
 	bne.s	.NoF1
	tst.b	PauseFlag
	bne.s	.NoF1b
	eor.b	#1,Pause
	move.b	#1,PauseFlag
	bra.s	.NoF1b
.NoF1:
	clr.b	PauseFlag
.NoF1b:
	;========================
;	cmpi.b	#60,$fffffc02.w
; 	bne.s	.NoF2
;	tst.b	PauseFlag
;	bne.s	.NoF1b
;	eor.b	#1,Pause
;	move.b	#1,PauseFlag
;	bra.s	.NoF1b
;.NoF2:
;	clr.b	PauseFlag
;.NoF2b:
	;========================

	cmp.b	#1,Pause
	beq.s	.WeArePaused

	move.l	FrameCounter,d0
	addq.w	#1,d0
	cmpi.w	#NB_FRAMES,d0
	bne.s	.KeepGoing
	moveq	#0,d0
.KeepGoing
	move.l	d0,FrameCounter
	
	JSR		SWAPEC
	
.WeArePaused

	IFNE	USE_MUSIC	
	bsr		Music+4
;	bsr		Music+8
	ENDC
	
	IFNE	USE_PRECA_MUSIC
;	MOVE	#$0f0,$FFFF8240.W
	move.l	SongDataPtr,a0
	move.l	CurrentFrame,d0
								lsr.l	#8,d0
	add.l	d0,a0
	lea		$ffff8800.w,a1
	move.l	NbFrames,d0

	moveq	#0,d1
	REPT	16
	move.b	d1,(a1)
	move.b	(a0),2(a1)
	addq	#1,d1
	add.l	d0,a0
	ENDR
	
	move.l	CurrentFrame,d0
	move.l	NbFrames,d1
								lsl.l	#8,d1
;	addq.l	#1,d0
								add.l	#256,d0
;								add.l	#200,d0
	cmp.l	d1,d0
	ble.s	.GoOn
	moveq	#0,d0
.GoOn
	move.l	d0,CurrentFrame
;	MOVE	#$000,$FFFF8240.W
	ENDC

	cmpi.b	#$39,$fffffc02.w
 	bne.s	.EndVBL
 	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
	move.w	#$2700,SR
	RTE
.EndVBL:
	move.w	#$2300,SR
	RTE

PixelMask2
	DC	%11000000
	DC	%1100000
	DC	%110000
	DC	%11000
	DC	%1100
	DC	%110
	DC	%11
	DC	%1

PixelMask:
	DC	%10000000
	DC	%1000000
	DC	%100000
	DC	%10000
	DC	%1000
	DC	%100
	DC	%10
	DC	%1

SWAPEC
	MOVE	SCREEN1,D0
	MOVE	SCREEN2,SCREEN1
	MOVE	D0,SCREEN2

	MOVE.L	ADR1,D0
	MOVE.L	ADR2,ADR1
	MOVE.L	D0,ADR2

;	MOVE.L	COD1,D0
;	MOVE.L	COD2,COD1
;	MOVE.L	D0,COD2

	;MOVE.B	SCREEN1+1,$FFFF8201.W
	;MOVE.B	SCREEN1+2,$FFFF8203.W

	CLR.B	$FFFF8201.W
	MOVE.B	SCREEN2,$FFFF8203.W
	RTS

;Generate clearing code for planes 1&4
;D0 = #lines
;A0 = dest buffer. Needed size = 2+#lines*4*10
GenerateClearCodePlanes1_4:
	subq	#1,d0
	moveq	#0,d1
.GenClearCode:
	;TODO: very first (null) offset could be dropped
	REPT	10
		move.w	#$2140,(a0)+	;$2140xxxx	= "MOVE.L D0,xxxx(A0)"
		move.w	d1,(a0)+
		add.w	#16,d1
	ENDR
	dbf		D0,.GenClearCode
	move.w	#$4e75,(a0)+	;rts
	rts

;Generate code that copies planes 1&4 to another plane
;D0 = #lines
;A0 = dest buffer. Needed size = 2+#lines*12*10
GenerateCopyCodePlanes1_4:
	;Curve is on planes 4 and 1, starting with 4:
	;16p4 16p1 16p4 16p1 ...
	;We want to copy that to plane 2 or 3:
	; d0 = (a0)	;16p4 16p1
	; (a0) = plane 4
	; -2(a0) = plane 3
	; -4(a0) = plane 2
	; low 16 bits copied to -4(a0)
	; high 16 bits copied to -4+8(a0)
	subq	#1,d0
	moveq	#0,d1
	move.w	#0,d2
.GenCopyCode:
	;TODO: very first (null) offset could be dropped
	REPT	10
		move.w	#$3168,(a0)+	;$316811112222	= "move.w $1111(a0),$2222(a0)"
		move.w	d1,(a0)
		addq.w	#2,(a0)+
		move.w	d1,(a0)
		add.w	d2,(a0)
		addq.w	#4,(a0)+

		move.w	#$3168,(a0)+	;$316811112222	= "move.w $1111(a0),$2222(a0)"
		move.w	d1,(a0)+
		move.w	d1,(a0)
		add.w	d2,(a0)
		subq.w	#4,(a0)+
	
		add.w	#16,d1
	ENDR
	dbf		D0,.GenCopyCode
	move.w	#$4e75,(a0)+	;rts
	rts

GetClearScreenAddress:
	MOVE	SCREEN1,D0
	SWAP	D0
	CLR		D0
	SWAP	D0
	MOVE.L	D0,A0
	ADDA	#Y_DEP,A0
;	LEA		6+160*30(A0),A0
	LEA		6(A0),A0
	rts


ClearScreen:
;	rts
	
	cmp.b	#1,Pause
	bne.s	.NotPaused
	rts
.NotPaused

	IFNE	COPY_DOTS
	jsr		GetClearScreenAddress
	jsr		CopyCode0
	ENDC
	
	jmp		.SkipClearPlane3
	;Clear plan 3
	MOVE	SCREEN1,D0
	SWAP	D0
	CLR		D0
	SWAP	D0
	MOVE.L	D0,A0
	adda.l	#160*(100-68),a0
	moveq	#0,d0
	move.l	#150-1,d7
.ClearPlan3
N	set		0
	REPT	20
	move.w	d0,4+N(a0)
N	set		N+8
	ENDR
	lea		160(a0),a0
	dbf		d7,.ClearPlan3
.SkipClearPlane3:	
	
	IFNE	NO_PRECA
	jsr		GetClearScreenAddress
	moveq	#0,d0
	jsr		ClearCode0
	RTS
	ENDC





	IFNE	USE_PRECA2
	
;	jmp		SkipAll
	
	move	SCREEN1,d0
	swap	d0
	clr		d0
	swap	d0
	move.l	d0,a6
	

;This part does the copy
;	IFEQ	COPY_DOTS
	jmp		SkipCopy
;	ENDC

;		bra.s	SkipLocalData
;FirstFrame	dc.w	1
;SkipLocalData;
;		cmp.w	#1,FirstFrame
;		bne.s	.AlreadyDone
;		move.w	#0,FirstFrame
;		
;		lea		CurrentColumnData2,a3
;		lea		PRECA,a1
;		move.l	#NB_FRAMES*2,d5	;shuffled format
;		move	#NB_FRAMES-1-2,d0
;.InitData:
;
;		moveq	#10-1,d7
;.ProcessColumn1
;		moveq	#0,d1
;		moveq	#0,d2
;			move.b	(a1),d1				;min (shuffled format)
;			move.b	NB_FRAMES(a1),d2	;max (shuffled format)
;			add.l	d5,a1				;shuffled format
;
;			add.b	(a3),d1		;min (shuffled format + delta)
;			move.b	d1,(a3)+	;shuffled format + delta
;			add.b	(a3),d2		;min (shuffled format + delta)
;			move.b	d2,(a3)+	;shuffled format + delta
;		dbf		d7,.ProcessColumn1
;		dbf		d0,.InitData
;	
;.AlreadyDone

		lea		CurrentColumnData2,a3
	lea		PRECA,a1
	move.l	FrameCounter,d0
	;We need to copy the data from 2 frames ago
	cmp		#2,d0
	bge.s	.AtLeastTwo
	add.l	#NB_FRAMES,d0
.AtLeastTwo	
	subq	#2,d0
		bne.s	.NotZero2
;		moveq	#0,d0
		move.l	d0,(a3)
		move.l	d0,4(a3)
		move.l	d0,8(a3)
		move.l	d0,12(a3)
		move.l	d0,16(a3)
.NotZero2:
	
;		muls	#20,d0				;sizeof(FrameDataSize) = 2 bytes * 10 columns
;		adda.l	d0,a1
		adda.l	d0,a1			;shuffled format
		move.l	#NB_FRAMES*2,d5	;shuffled format
;		lea		CurrentColumnData2,a3	;shuffled format + delta

	moveq	#0,d4
	moveq	#10-1,d7
ProcessColumn0
	moveq	#0,d1
	moveq	#0,d2
	;	move.b	(a1)+,d1	;min
	;	move.b	(a1)+,d2	;max
		move.b	(a1),d1				;min (shuffled format)
		move.b	NB_FRAMES(a1),d2	;max (shuffled format)
		add.l	d5,a1				;shuffled format

		add.b	(a3),d1		;min (shuffled format + delta)
		move.b	d1,(a3)+	;shuffled format + delta
		add.b	(a3),d2		;min (shuffled format + delta)
		move.b	d2,(a3)+	;shuffled format + delta

	add		#Y_MARGIN,d1
	add		#Y_MARGIN,d2

	move	d2,d3
	sub		d1,d3
	addq	#1,d3

	muls	#160,D1
;	muls	#160,D2

	move.l	a6,a0
	add		d1,a0
	add		d4,a0
;	addq	#6,a0

	move	#Y_SIZE,d1
	sub		d3,d1
	move	d1,d0
	muls	#160,d0
	sub		d0,a0
	muls	#12,d1		;sizeof(copy-to-plane2 code)
	moveq	#0,d0
	lea		ColumnCopy,a2
	adda.l	d1,a2
	jmp		(a2)
ColumnCopy:
N2	set	0
N	set	6					;Starts at 6 for plane4
	REPT	Y_SIZE
	move.w	N+2(a0),-4+8+N+N2(a0)	;Copy to plane 2
	move.w	N(a0),-4+N+N2(a0)		;Copy to plane 2
N	set		N+160	
	ENDR
	add		#16,d4
	dbf		d7,ProcessColumn0
SkipCopy:




	
	
		lea		CurrentColumnData,a3
	lea		PRECA,a1
	move.l	FrameCounter,d0		;the data has been pre-shifted so no need to adjust this
		bne.s	.NotZero
;		moveq	#0,d0
		move.l	d0,(a3)
		move.l	d0,4(a3)
		move.l	d0,8(a3)
		move.l	d0,12(a3)
		move.l	d0,16(a3)
	
.NotZero:		
;		muls	#20,d0				;sizeof(FrameDataSize) = 2 bytes * 10 columns
;		adda.l	d0,a1
		adda.l	d0,a1			;shuffled format
		move.l	#NB_FRAMES*2,d5	;shuffled format
;		lea		CurrentColumnData,a3	;shuffled format + delta

	moveq	#0,d4
	moveq	#10-1,d7
ProcessColumn
	moveq	#0,d1
	moveq	#0,d2
;		move.b	(a1)+,d1		;min
;		move.b	(a1)+,d2		;max
		move.b	(a1),d1				;min (shuffled format)
		move.b	NB_FRAMES(a1),d2	;max (shuffled format)
		add.l	d5,a1				;shuffled format
		
		add.b	(a3),d1		;min (shuffled format + delta)
		move.b	d1,(a3)+	;shuffled format + delta
		add.b	(a3),d2		;min (shuffled format + delta)
		move.b	d2,(a3)+	;shuffled format + delta
		
;	add		#Y_MARGIN,d1
;	add		#Y_MARGIN,d2

	move	d2,d3
	sub		d1,d3
	addq	#1,d3		;max-min+1 = #lines to clear

;	jmp		.SkipRed
;	muls	#160,D1				****
;	muls	#160,D2				****
;		move.l	a6,a0
;		add		d1,a0
;		add		d4,a0
;N	set	4
;		REPT	2
;		move	#$ffff,N(a0)
;N	set	N+8
;		ENDR
;		
;		move.l	a6,a0
;		add		d2,a0
;		add		d4,a0
;N	set	4
;		REPT	2
;		move	#$ffff,N(a0)
;N	set	N+8
;		ENDR
;.SkipRed:

	move.l	a6,a0
	add		d4,a0
;	addq	#6,a0

;Old:
;		muls	#160,D1
;		add		d1,a0
;		move	#Y_SIZE,d1
;		sub		d3,d1
;		move	d1,d0
;		muls	#160,d0
;		sub		d0,a0
;
;		lsl		#2,d1		;sizeof(move.l	d0,N(a0))
;;		lsl		#4,d1		;sizeof(clear + copy-to-plane2 code)
;;		muls	#4+12+12,d1
;		moveq	#0,d0
;		lea		ColumnClear,a2
;		adda.l	d1,a2

;New:
;		muls	#160,d1
;		add		d1,a0
		move	#Y_SIZE,d2
		sub		d3,d2
;		move	d2,d0
;		muls	#160,d0
;		sub		d0,a0
		sub		d2,d1
;		mulu	#160,d1
;		add		d1,a0
			add		d1,d1
			lea		MulsTable+200*2,a2
			add.w	(a2,d1.w),a0
		

;		lsl		#2,d2		;sizeof(move.l	d0,N(a0))
			add	d2,d2
			add	d2,d2
;		lsl		#4,d2		;sizeof(clear + copy-to-plane2 code)
;		muls	#4+12+12,d2
		moveq	#0,d0
		lea		ColumnClear,a2
;		adda.l	d2,a2
	
;	cmp		#9,d7
;	beq		Shortcut
;	cmp		#0,d7
;	beq		Shortcut
	
	jmp		(a2,d2.w)
ColumnClear:
N	set	6					;Starts at 6 for plane4
	REPT	Y_SIZE
	
;	move.w	-4+8+N(a0),-2+8+N(a0)	;Copy to plane 3
;	move.w	-4+N(a0),-2+N(a0)		;Copy to plane 3
	
;	move.w	N+2(a0),-4+8+N(a0)	;Copy to plane 2
;	move.w	N(a0),-4+N(a0)		;Copy to plane 2
	
	move.l	d0,N(a0)		;Clears planes 1&4
N	set		N+160
	ENDR

Shortcut:
	add		#16,d4
	
	dbf		d7,ProcessColumn
SkipAll:

;	jsr		GetClearScreenAddress
;	moveq	#0,d0
;	jsr		ClearCode0

	rts

	ENDC











	IFNE	USE_PRECA1
	
	move	#-68,d1
	move	#69,d2
	cmp.l	#1,FrameCounter
	ble.s	.SkipFirstFrame
	lea		PRECA,a1
	move.l	FrameCounter,d0
	subq	#2,d0
	lsl		#2,d0
	add		d0,a1
	move	(a1),d1		;min
	move	2(a1),d2	;max
.SkipFirstFrame;
;	add.l	#1,FrameCounter
;	-68 to 69
	add		#100+8,d1
	add		#100+8,d2
;	0 to 137

	move	d2,d3
	sub		d1,d3
	addq	#1,d3

	muls	#160,D1
	muls	#160,D2

	jmp		.SkipRed
		MOVE	SCREEN1,D0
		SWAP	D0
		CLR		D0
		SWAP	D0
		MOVE.L	D0,A0
		add		d1,a0
N	set	4
		REPT	20
		move	#$ffff,N(a0)
N	set	N+8
		ENDR
		MOVE.L	D0,A0
		add		d2,a0
N	set	4
		REPT	20
		move	#$ffff,N(a0)
N	set	N+8
		ENDR
.SkipRed:

	MOVE	SCREEN1,D0
	SWAP	D0
	CLR		D0
	SWAP	D0
	MOVE.L	D0,A0
	add		d1,a0
	addq	#6,a0

	move	#Y_SIZE,d1
	sub		d3,d1
	move	d1,d0
	muls	#160,d0
	sub		d0,a0
	muls	#40,D1
	moveq	#0,d0
	lea		ClearCode0,a2
	adda.l	d1,a2
	jsr		(a2)
	rts

	ENDC




	
	IFNE	USE_PRECA0
	jsr		GetClearScreenAddress

	move	#-68,d1
	move	#69,d2
	cmp.l	#0,FrameCounter
	beq.s	.SkipFirstFrame
	lea		PRECA,a1
	move.l	FrameCounter,d0
	subq	#1,d0
	lsl		#2,d0
	add		d0,a1
	move	(a1),d1		;min
	move	2(a1),d2	;max
.SkipFirstFrame;
;	add.l	#1,FrameCounter
;	-68 to 69
	add		#68,d1
	add		#68,d2
;	0 to 137
	sub		d1,d2	:delta = #lines to draw
	muls	#160,D1
;	add		d1,a0


		MOVE	SCREEN1,D0
		SWAP	D0
		CLR		D0
		SWAP	D0
		MOVE.L	D0,A0
		add		d1,a0
		REPT	20
		move	#$ffff,4(a1)
		adda.l	#8,a1
		ENDR

;		lea		-2(a0),a1
;		add		d1,a1
;		REPT	20
;		move	#$ffff,(a1)
;		adda.l	#8,a1
;		ENDR

	move	#Y_SIZE,d1
	sub		d2,d1
	muls	#40,D1
	jsr		GetClearScreenAddress
	moveq	#0,d0
	lea		ClearCode0,a2
;	adda.l	d1,a2
	jsr		(a2)
	ENDC
	
	RTS



	jsr		GetClearScreenAddress

	;Curve is on planes 4 and 1, starting with 4:
	;16p4 16p1 16p4 16p1 ...
	;We want to copy that to plane 2 or 3:
	; d0 = (a0)	;16p4 16p1
	; (a0) = plane 4
	; -2(a0) = plane 3
	; -4(a0) = plane 2
	; low 16 bits copied to -4(a0)
	; high 16 bits copied to -4+8(a0)

	IFEQ	USE_OPTIM
N2	SET	0
	ENDC
	IFNE	USE_OPTIM
N2	SET	160
	ENDC

	MOVEQ	#0,D0
	IFEQ	USE_OPTIM
	MOVE	#Y_SIZE-1,D7
	ENDC
	IFNE	USE_OPTIM
	MOVE	#(Y_SIZE/2)-1,D7
	ENDC
	
	IFNE	FLIP_COPY
	LEA		(Y_SIZE)*160-40*160(A0),A1
	LEA		-4(A1),A1
;	LEA		-160(A0),A1
	ENDC
	
.EFF

	IFEQ	FLIP_COPY
;	move.w	-4+8+N2(a0),-2+8+N2(a0)	*
;	move.w	-4+N2(a0),-2+N2(a0)		*
	move.w	2(a0),-4+8+N2(a0)
	move.w	(a0),-4+N2(a0)
	ENDC
	IFNE	FLIP_COPY
	move.w	2(a0),8+N2(a1)
	move.w	(a0),N2(a1)
	ENDC

	MOVE.L	D0,(A0)
N	SET	16
	REPT	9
	
	IFEQ	FLIP_COPY
;	move.w	-4+8+N+N2(a0),-2+8+N+N2(a0)	*
;	move.w	-4+N+N2(a0),-2+N+N2(a0)		*
	move.w	N+2(a0),-4+8+N+N2(a0)
	move.w	N(a0),-4+N+N2(a0)
	ENDC
	IFNE	FLIP_COPY
	move.w	N+2(a0),8+N+N2(a1)
	move.w	N(a0),N+N2(a1)
	ENDC
		
	MOVE.L	D0,N(A0)
N	SET	N+16
	ENDR

	IFNE	FLIP_COPY
	LEA	-160(A1),A1
;	LEA	160(A1),A1
	ENDC

	IFEQ	USE_OPTIM
	LEA	160(A0),A0
	ENDC
	IFNE	USE_OPTIM
	LEA	160*2(A0),A0
	ENDC
	DBF	D7,.EFF
	
	RTS


;MOVE.L A7,USP		(2)
;MOVEM.W (A0)+,A1-7	(4)		|
;OR.B D0,$1234(A1)	(4)	*7	|*(NB_PTS/7)
;MOVE.L USP,A7		(2)
;RTS				(2)
SEQUENCE_SIZE	= 4*7+4
CODGENSIZE		= 2+(NB_PTS/7)*SEQUENCE_SIZE+2+2
;CODGENSIZE		= 40000

GenerateCode:
	lea		CORES_X2,a2
;	lea		CORES_X3,a2
	lea		BUF_COD,a3
;	lea		BUF_COD2,a4
	move.w	#$4E67,(a3)+	;MOVE.L A7,USP
;	move.w	#$4E67,(a4)+	;MOVE.L A7,USP
	lea		TABL_PLANS,a5
	lea		XS2,a6
	moveq	#0,d4

	move.w	#(NB_PTS/7)-1,d7
.NextSequence
	move.l	#$4C98FE00,(a3)+	;MOVEM.W (A0)+,A1-7		9
;	move.l	#$4C98FE00,(a4)+	;MOVEM.W (A0)+,A1-7
	
	move	#$29,d5			;The $29 in this opcode: OR.B D0,$1234(A1)	$81291234 => encodes (A1)
;	move	#$41,d5

	moveq	#7-1,d6			;Generate code for 7 dots
.NextDot

;	move.w	#$3258,(a3)+		;MOVE.W (A0)+,A1


;	MOVE	(A6)+,D0

	MOVE	(A6),D0
;	ADD.L	#2*256,D4	;This one to get a classic "Blood" curve
;	ADD.L	#555,D4		*
	ADD.L	#X_STEP,D4		*
;	ADD.L	#520,D4
;	ADD.L	#200,D4
;	ADD.L	#400,D4
;	ADD.L	#600,D4
	MOVE.L	D4,D3
	LSR.L	#8,D3
	AND.W	#$fffe,D3
	LEA		XS2,A6
	ADD.L	D3,A6
	


	ADD		#160,D0			;x

	TST		D0
	BGE.S	.OK
	CLR		D0
.OK	CMPI	#320,D0
	BLT.S	.OK2
	MOVE	#319,D0
.OK2

																move	d0,d3

;	MOVE	#100*160,D2		;$3e80
;	MOVE	#0,D2			;See ;**** later
	MOVE	#200*160,D2		;$7d00
;	MOVE	#200*160,D1		;$7d00

;	Buf1 = SCREEN1 + Y_DEP + y*160
;	Buf2 = SCREEN2 + Y_DEP + y*160 - 100*160
;	Buf1 + D2 = SCREEN1 + Y_DEP + y*160 + 100*160
;	Buf2 + D1 = SCREEN2 + Y_DEP + y*160 + 100*160

	lsl.w	#2,d0			;x*4
;	ADD.W	2(A2,D0.W),D1	;Offset from CORES_X2 table
	ADD.W	2(A2,D0.W),D2	;Offset from CORES_X2 table
	
;	ADD		(A5,D0.W),D1	;from TABL_PLANS table
	ADD		(A5,D0.W),D2	;from TABL_PLANS table
	
	MOVE.W	(A2,D0.W),D0	;Opcode from CORES_X2 table

	;Sequence = 1 movem + 7 or.b = 9 + 7*4 = "37" nops for 7 dots, i.e. 5.28 nops/dot

	;OR.B Dx, N(A1)		4 nops
	;OR.B Dx, N(A2)
	;OR.B Dx, N(A3)
	;OR.B Dx, N(A4)
	;OR.B Dx, N(A5)
	;OR.B Dx, N(A6)
	;OR.B Dx, N(A7)
	;OR.B D0,$1234(A1)	81291234
	;OR.B D1,$1234(A2)	832a1234
	;OR.B D2,$1234(A3)	852b1234
	;OR.B D3,$1234(A4)	872c1234
	;OR.B D4,$1234(A5)	892d1234
	;OR.B D5,$1234(A6)	8b2e1234
	;OR.B D6,$1234(A7)	8d2f1234

;																cmp		#32*4,d3
;																blt.s	.KeepDatDot
;																cmp		#32*4+32,d3
;																bge.s	.KeepDatDot
;																bra.s	.SkipDatDot
.KeepDatDot

	move.w	d5,(a3)			;Part of opcode (dest address register)
	MOVE.B	D0,(A3)			;Part of opcode (src data register)
	MOVE	D2,2(A3)		;Part of opcode (address offset)
	ADDQ	#4,A3

;	move.w	d5,(a4)			;Part of opcode (dest address register)
;	MOVE.B	D0,(A4)			;Part of opcode (src data register)
;	MOVE	D1,2(A4)		;Part of opcode (address offset)
;	ADDQ	#4,A4

.SkipDatDot

	addq	#1,d5			;Next opcode = next dest address register
	dbf		d6,.NextDot
	dbf		d7,.NextSequence
	
	move.w	#$4E6F,(a3)+	;MOVE.L USP,A7
;	move.w	#$4E6F,(a4)+	;MOVE.L USP,A7
	move.w	#$4E75,(a3)		;RTS
;	move.w	#$4E75,(a4)		;RTS
	rts



PREP_MOUNT

	;Copy data
	lea		XS,a0
	lea		DATA_SIZE(a0),a1
	move	#(DATA_SIZE/4)-1,d7
.COPXS
	move.l	(a0)+,(a1)+
	dbf		d7,.COPXS

	LEA		XS,A0
	LEA		BIG_BUF1,A1
	LEA		BIG_BUF2,A2
	MOVE	SCREEN1,D0
	MOVE	SCREEN2,D1
	ADD		#Y_DEP,D0
	ADD		#Y_DEP,D1

	;Original data = DATA_SIZE bytes = DATA_SIZE/2 words
	;We replicated the data, i.e. we now have DATA_SIZE words to process.
	MOVE	#DATA_SIZE-1,D7
.DO_TRANSFO:
	MOVEQ	#0,D6
	MOVE	(A0)+,D6		;y (between -N and +M)
	EXT.L	D6
	LSL.L	#8,D6
	DIVS	#Y_DIVIDER,D6	;y_screen = y*256/Y_DIVIDER
	IFNE	USE_OPTIM
	AND		#$fffe,d6
	ENDC
	MULS	#160,D6			;y_screen * 160 = screen offset
	
	MOVE	D0,(A1)			;SCREEN1
;	ADD		#100*160,(A1)	;****
	SUB		#100*160,(A1)	;****
	ADD		D6,(A1)+		;SCREEN1 + Y_DEP + y*160
	
	MOVE	D1,(A2)			;SCREEN2
;	ADD		#100*160,(A2)	;****
	SUB		#100*160,D6
;	SUB		#80*160,D6		;ok
;	SUB		#70*160,D6		;ok
;	SUB		#60*160,D6		;crash	=> depends on Y_DIVIDER
;	SUB		#50*160,D6		;crash
;	SUB		#10*160,D6
	ADD		D6,(A2)+		;SCREEN2 + Y_DEP + y*160 - 100*160
	
	DBF		D7,.DO_TRANSFO
	
	RTS
	ENDC




	section data
	even

	IFNE	USE_PRECA_MUSIC
YM	incbin	iss.bin
	ENDC

	IFNE	USE_MUSIC
Music	incbin	buggin10.mus
;Music	incbin	zik.zik
	ENDC

	IFNE	USE_DOTS
;	DCB.W	500,0
N	SET	0
CORES_X2	REPT	20
	DC	$81,N
	DC	$83,N
	DC	$85,N
	DC	$87,N
	DC	$89,N
	DC	$8B,N
	DC	$8D,N
	DC	$8F,N
	DC	$81,N+1
	DC	$83,N+1
	DC	$85,N+1
	DC	$87,N+1
	DC	$89,N+1
	DC	$8B,N+1
	DC	$8D,N+1
	DC	$8F,N+1
N	SET	N+8
	ENDR
;	DCB.W	500,0


;	DCB.W	500,0
N	SET	0
CORES_X3	REPT	20
	DC	$D1,N
	DC	$D3,N
	DC	$D5,N
	DC	$D7,N
	DC	$D9,N
	DC	$Db,N
	DC	$Dd,N
	DC	$Df,N
	DC	$D1,N+1
	DC	$D3,N+1
	DC	$D5,N+1
	DC	$D7,N+1
	DC	$D9,N+1
	DC	$Db,N+1
	DC	$Dd,N+1
	DC	$Df,N+1
N	SET	N+8
	ENDR
;	DCB.W	500,0



;	DCB.W	500,0
N	SET	0
CORES_X4	REPT	20
	DC	$11,N
	DC	$13,N
	DC	$15,N
	DC	$17,N
	DC	$19,N
	DC	$1b,N
	DC	$1d,N
	DC	$1f,N
	DC	$11,N+1
	DC	$13,N+1
	DC	$15,N+1
	DC	$17,N+1
	DC	$19,N+1
	DC	$1b,N+1
	DC	$1d,N+1
	DC	$1f,N+1
N	SET	N+8
	ENDR
;	DCB.W	500,0


TABL_PLANS
	REPT	10
	DCB	32,6
	DCB	32,0
	ENDR

TXT	INCBIN	LEO.TXT
	ENDC

XS2:
;XS	INCBIN	XS.DAT
;XS	INCBIN	XS4.DAT
;XS	INCBIN	XS5.DAT
;XS	INCBIN	XS6.DAT
;XS	INCBIN	XS7.DAT
XS	INCBIN	XS7_900.DAT
;XS	INCBIN	XS8b.DAT
XS_END	DS.B	DATA_SIZE
;XS2	INCBIN	XS.DAT

	IFNE	USE_PRECA1
PRECA	INCBIN	PRCTST.DAT
	ENDC
	IFNE	USE_PRECA2
;PRECA	INCBIN	PRCTST2.DAT			;initial format
;PRECA	INCBIN	PRCTST2b.DAT		;shuffled
;PRECA	INCBIN	XS6P930.DAT		;shuffled
;PRECA	INCBIN	XS4P900.DAT
;PRECA	INCBIN	XS5P900.DAT
;PRECA	INCBIN	XS7PRECA.DAT
PRECA	INCBIN	XS7P900.DAT
;PRECA	INCBIN	XS8PRECB.DAT
	ENDC

	section bss
	even

StartBSS:
;	IFNE	USE_DOTS
SavedRAM		ds.b	64000
;	ENDC

	IFNE	USE_DOTS
SCREEN1			DS.W	1
SCREEN2			DS.W	1
ADR1			DS.L	1
ADR2			DS.L	1
;COD1			DS.L	1
;COD2			DS.L	1
FrameCounter	ds.l	1
Pause			ds.b	1
PauseFlag		ds.b	1
OneFrame		ds.b	1
OneFrameFlag	ds.b	1

MulsTable	ds.w	400
ClearCode0	ds.b	2+Y_SIZE*4*10
CopyCode0	ds.b	2+Y_SIZE*12*10

BUF_COD		DS.B	CODGENSIZE
;BUF_COD2	DS.B	CODGENSIZE
BIG_BUF1	DS.B	DATA_SIZE*2
BIG_BUF2	DS.B	DATA_SIZE*2
	ENDC
	
	IFNE	USE_PRECA2
CurrentColumnData	ds.b	10*2
CurrentColumnData2	ds.b	10*2
	ENDC

	IFNE	USE_PRECA_MUSIC
SongDataPtr		ds.l	1
NbFrames		ds.l	1
CurrentFrame	ds.l	1
	ENDC
	
	IFEQ	USE_DOTS
				ds.b	256
ScreenBuffer	ds.b	32000*2
ScreenPtr1		ds.l	1
ScreenPtr2		ds.l	1
	ENDC

SavedEnv		ds.l	SAVED_ENV_DWORD_SIZE

EndBSS:
