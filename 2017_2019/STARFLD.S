
;	opt	o+,a+
	opt	o+
;	opt	p+

ENABLE_REGULAR_VERSION		= 0	;4 colors
ENABLE_4BP_VERSION			= 0	;4 bitplanes version (real 16 colors)
ENABLE_2BP_VERSION			= 1	;Two bitplanes mode (virtually double the amount of screens)
ENABLE_2BP_VERSION_BACKUP	= 0
ENABLE_FULLSCREEN			= 1

KILL_INTERRUPTS			= 0
ROTATE_STARS			= 0
PREMUL_Z4				= 1	;Premultiplies stored Z values by 4
PRESHIFT_XY				= 1	;Preshifts stored XY values - only ok with N<128 in projection code
TEST_PICTURE			= 0	;TODO: extract this palette
TEST_DEBUG				= 0

	IFNE	ENABLE_FULLSCREEN
SCREEN_BYTE_WIDTH	= 230
SCREEN_HEIGHT		= 260	;274
SCREEN_GUARDBAND	= 0
SCREEN_SIZE			= (SCREEN_BYTE_WIDTH*SCREEN_HEIGHT)+256		;64000
CLIP_X				= 210
CLIP_Y				= SCREEN_HEIGHT/2
	ELSE
SCREEN_BYTE_WIDTH	= 160
SCREEN_HEIGHT		= 200
SCREEN_GUARDBAND	= 0
SCREEN_SIZE			= 32000
CLIP_X				= 160
CLIP_Y				= 100
	ENDC

SIN_TABLE_SIZE	=	1024
NB_SCREENS	= 15
X_RANGE		= 512
Y_RANGE		= 256
Z_RANGE		= 256
;Z_RANGE		= 512

NB_STEPS_PER_FRAME	= 4
;NB_PREPLOT_STEPS	= 4096
NB_PREPLOT_STEPS	= 10000
;NB_PREPLOT_STEPS	= 0

	IFNE	ROTATE_STARS
NB_STARS	= 100
	ELSE
;Must be at least 4
NB_STARS	= 28/NB_STEPS_PER_FRAME
;NB_STARS	= 4/NB_STEPS_PER_FRAME
;NB_STARS	= 256/NB_STEPS_PER_FRAME
;NB_STARS	= 2560/NB_STEPS_PER_FRAME
;NB_STARS	= 200/NB_STEPS_PER_FRAME
;NB_STARS	= 400
;NB_STARS	= 128
;NB_STARS	= 100
	ENDC

;SPEED		= 6
;SPEED		= 2
SPEED		= 1

	section text

	bra		Start
UTIL_CLEAR_SCREEN_1P		= 0
UTIL_CLEAR_SCREEN_4P		= 0
UTIL_ROTATE_POINTS			= ROTATE_STARS
UTIL_600_SCREEN_ADDRESS		= 0
UTIL_CREATE_PIXEL_TABLE		= 0
UTIL_CREATE_PIXEL_TABLE2	= 0
UTIL_CREATE_MULS_TABLE		= 0

	INCLUDE		UTILS.S
	include	LIB/BSS.S
	include	LIB/ENV.S
	include	LIB/SYS.S
;	include	LIB/PIXT.S
	include	LIB/MULY.S
	
;======================================

	IFNE TEST_DEBUG
FakePlanes	dc.w	1,2,3,4
PlaneTest:
	;d2 = 0-15 color index
	moveq	#16-1,d2
	lea		FakePlanes,a1
	moveq	#1,d0	;fake bit pattern
.Loop

;	move.w	(a1),d1
;	move.w	2(a1),d6
;
;	move.l	(a1),d1
;	swap	d1

	move.w	#0,(a1)
	move.w	#0,2(a1)
	move.w	#0,4(a1)
	move.w	#0,6(a1)

	;Write pixel

		;This works but slower
;		btst	#0,d2
;		sne.b	d6
;		ext.w	d6
;		and.w	d0,d6
;		or.w	d6,(a1)

	btst	#0,d2
	beq.s	.P0
	or.w	d0,(a1)
.P0
	btst	#1,d2
	beq.s	.P1
	or.w	d0,2(a1)
.P1
	btst	#2,d2
	beq.s	.P2
	or.w	d0,4(a1)
.P2
	btst	#3,d2
	beq.s	.P3
	or.w	d0,6(a1)
.P3

	;Read pixel

	moveq	#0,d6
	move.w	(a1),d1
	and.w	d0,d1
	beq.s	.P0x
	bset	#0,d6
.P0x
	move.w	2(a1),d1
	and.w	d0,d1
	beq.s	.P1x
	bset	#1,d6
.P1x
	move.w	4(a1),d1
	and.w	d0,d1
	beq.s	.P2x
	bset	#2,d6
.P2x
	move.w	6(a1),d1
	and.w	d0,d1
	beq.s	.P3x
	bset	#3,d6
.P3x
	dbf	d2,.Loop	
	rts
	ENDC

;======================================
;Copy of the code in PIXT.S

SINGLE_PIXEL_TABLE_SIZE	= CLIP_X*2

ShufflePixelTable:
	moveq	#3,d3
	moveq	#4,d4
	moveq	#0,d0			;x value
	move.w	#$8000,d2		;mask
	lea		PixelTable2,a0

	move.w	#(CLIP_X*2)-1,d7
.CreateTable
	move.w	d2,(a0)+		;pixel mask
	
	lsr.w	#1,d2
	bne.s	.NotZero
	move.w	#$8000,d2
.NotZero

	move.w	d0,d1
	lsr.w	d4,d1
	lsl.w	d3,d1
	move.w	d1,(a0)+		;screen offset

	addq.w	#1,d0			;next pixel
	dbf		d7,.CreateTable

	lea		PixelTable2,a0
	lea		(CLIP_X*4)(a0),a0
	lea		PixelTable2,a1
	move.w	#(CLIP_X/2)-1,d7
.ShuffleTable
	lea		-4(a0),a0
	move.l	(a1),d1
	move.l	(a0),d2
	move.l	d2,(a1)
	move.l	d1,(a0)
	lea		4(a1),a1	
	dbf		d7,.ShuffleTable
	

	;While we're at it....
	
	lea		MulsTable,a0
	lea		(MULS_TABLE_SIZE)(a0),a0
	lea		MulsTable,a1
	move.w	#(MULS_TABLE_SIZE/4)-1,d7
.ShuffleTableY
	lea		-2(a0),a0
	move.w	(a1),d1
	move.w	(a0),d2
	move.w	d2,(a1)
	move.w	d1,(a0)
	lea		2(a1),a1	
	dbf		d7,.ShuffleTableY
		
	rts
	
;======================================

;RandomStarCoord	MACRO
;	;Randomize
;	mulu	#1325,d6
;	add.l	#715136305,d6
;	move.l	d6,\2
;	swap	\2
;	;Clip to desired range
;	andi.w	#\1-1,\2		;[0;N(
;	subi.w	#\1/2,\2		;[-N/2;N/2(
;	ENDM

RandomStarCoordQ	MACRO
	;Randomize
	mulu	#1325,d6
	add.l	#715136305,d6
	move.l	d6,\2
	swap	\2	
	;Clip to desired range
	andi.w	#\1-1,\2
	ENDM

;======================================

GenerateStarXY:
;	RandomStarCoord	X_RANGE,d0
;	RandomStarCoord	Y_RANGE,d1
	
		RandomStarCoordQ	(X_RANGE/2),d0	;[0;N/2(
;		btst	#0,d4
;		beq.s	.PosQuadrantX
;		subi.w	#X_RANGE/2,d0				;[-N/2;0(
;.PosQuadrantX
;		asl.w	#6,d0

		RandomStarCoordQ	(Y_RANGE/2),d1
;		btst	#1,d4
;;		bgt.s	.PosQuadrantY
;		beq.s	.PosQuadrantY
;		subi.w	#Y_RANGE/2,d1
;.PosQuadrantY
;		asl.w	#6,d1

	IFNE	PRESHIFT_XY
		asl.w	#8,d0
		asl.w	#8,d1
	ENDC

	rts

PrepareStars:
;	moveq	#42,d6	;Initial random seed
	moveq	#0,d6	;Initial random seed
	lea		Stars,a0
	moveq	#4-1,d4	;Quadrant
.NextQuadrant
	move.w	#(NB_STARS/4)-1,d7
.NextStar

	bsr.s	GenerateStarXY
	move.w	d0,(a0)+
	move.w	d1,(a0)+
		
	;RandomStarCoord	Z_RANGE,d0
	;add.w	#Z_RANGE,d0
		;Using random Z means multiple stars could end up on the same Z, etc.
		;Instead we spread stars over Z uniformly over the available range.
		move.w	d7,d0
		andi.w	#Z_RANGE-1,d0
		subi.w	#Z_RANGE/2,d0
		addi.w	#Z_RANGE,d0		;move initial stars beyond the regular range to make them come from far away
		IFNE	PREMUL_Z4
			add.w	d0,d0
			add.w	d0,d0
		ENDC
	move.w	d0,(a0)+

	dbf		d7,.NextStar
	dbf		d4,.NextQuadrant
	move.l	d6,Random
	
	;Prepare depth data: color/plane offset = f(z), and also precomputed 256*N/z values
	lea		DepthData,a0
	move.w	#(Z_RANGE*2)-1,d7
	moveq	#0,d2	;z
.SetupDepthData

	IFNE	ENABLE_REGULAR_VERSION
		moveq	#0,d3	;Color/plane offset
		cmpi.w	#(Z_RANGE/4),d2
		ble.s	.NextPa
		addq.w	#2,d3
.NextPa
		cmpi.w	#(Z_RANGE/4)*2,d2
		ble.s	.NextPb
		addq.w	#2,d3
.NextPb
		cmpi.w	#(Z_RANGE/4)*3,d2
		ble.s	.NextPc
		addq.w	#2,d3
.NextPc
		move.w	d3,(a0)+
	ENDC
	
	IFNE	ENABLE_4BP_VERSION
		moveq	#15,d3	;Color index
		cmpi.w	#(Z_RANGE/4),d2
		ble.s	.NextPa
		moveq	#14,d3	;Color index
.NextPa
		cmpi.w	#(Z_RANGE/4)*2,d2
		ble.s	.NextPb
		moveq	#13,d3	;Color index
.NextPb
		cmpi.w	#(Z_RANGE/4)*3,d2
		ble.s	.NextPc
		moveq	#12,d3	;Color index
.NextPc

			cmpi.w	#Z_RANGE-16,d2
			bge.s	.OutOfRange

			cmpi.w	#Z_RANGE/10,d2
			bge.s	.Continue
			
			moveq	#15,d3
			bra.s	.InRange
.Continue
			move.w	d2,d1
			subi.w	#Z_RANGE/10,d1
			
			move.w	#(15-1)*256/(Z_RANGE-16-(Z_RANGE/10)),d3
			mulu.w	d1,d3
			asr.l	#8,d3
			neg.w	d3
			add.w	#15,d3

			bra.s	.InRange
.OutOfRange
			moveq	#1,d3
.InRange
		move.w	d3,(a0)+
	ENDC
	
	IFNE	ENABLE_2BP_VERSION
MAX_INDEX	=	3
MIN_INDEX	=	1
Z0			=	Z_RANGE/4
Z1			=	Z_RANGE-64
		cmpi.w	#Z1,d2
		bge.s	.OutOfRange

		cmpi.w	#Z0,d2
		bge.s	.Continue
		
		moveq	#MAX_INDEX,d3
		bra.s	.InRange
.Continue
;		move.w	d2,d1
;		subi.w	#Z0,d1
;		
;		move.w	#(MAX_INDEX-MIN_INDEX)*256/((Z1)-(Z0)),d3
;		mulu.w	d1,d3
;		asr.l	#8,d3
;		neg.w	d3
;		add.w	#MAX_INDEX,d3

		moveq	#2,d3

		bra.s	.InRange
.OutOfRange
		moveq	#MIN_INDEX,d3
.InRange
		move.w	d3,(a0)+
	ENDC
	
	tst.w	d2
	beq.s	.ZIsNull
;	move.l	#256*50,d3
	move.l	#256*100,d3
;	move.l	#256*150,d3		*****
	;move.l	#256*200,d3
	divu.w	d2,d3		;256*N/z
	move.w	d3,(a0)+
	bra.s	.ZIsNotNull
.ZIsNull
	move.w	#0,(a0)+
.ZIsNotNull
	addq	#1,d2
	
	dbf		d7,.SetupDepthData
	rts

;======================================

;	;Alternative version, trying to make colors flicker
;	lea		ColorTable,a0
;	move.w	#(Z_RANGE*2)-1,d7
;	moveq	#0,d2
;.SetupColorTable2
;	moveq	#0,d3
;	
;Z_RANGE2	= Z_RANGE/8
;	
;	cmpi.w	#(Z_RANGE2),d2
;	ble.s	.NextPa
;	addq.w	#1,d3
;.NextPa
;
;	cmpi.w	#(Z_RANGE2)*2,d2
;	ble.s	.NextPb
;	addq.w	#1,d3
;.NextPb
;
;	cmpi.w	#(Z_RANGE2)*3,d2
;	ble.s	.NextPc
;	addq.w	#1,d3
;.NextPc
;
;	cmpi.w	#(Z_RANGE2)*4,d2
;	ble.s	.NextPd
;	addq.w	#1,d3
;.NextPd
;
;	cmpi.w	#(Z_RANGE2)*5,d2
;	ble.s	.NextPe
;	addq.w	#1,d3
;.NextPe
;
;	cmpi.w	#(Z_RANGE2)*6,d2
;	ble.s	.NextPf
;	addq.w	#1,d3
;.NextPf
;
;	btst	#0,d3
;	beq.s	.Bit0Null
;	
;	btst	#0,d7
;	beq.s	.Bit0Null2
;	addq.w	#1,d3
;	bra.s	.Bit0Null
;.Bit0Null2
;	subq.w	#1,d3
;	
;.Bit0Null
;
;	move.w	d3,(a0)+
;	addq	#1,d2
;	dbf		d7,.SetupColorTable2
;	rts

;======================================

Start:
	IFNE TEST_DEBUG
		bsr		PlaneTest
	ENDC

	bsr		Lib_ClearBSS


	;test
	;"256*N/z" is max for z=1
	;N = 100 by default so max = 256*100 = 25600
	;with a muls the max is 32767 i.e. N = 127?

	;Regular muls version
	move.l	#X_RANGE/2,d0	;max is X_RANGE/2 = 256
	move.w	#256*100,d2
	muls.w	d2,d0
	asr.l	#8,d0
	
	;Test with asl#6 - works
	move.l	#X_RANGE/2,d0	;max is 256
		asl.w	#6,d0		;preshifted
	move.w	#256*100,d2
	muls.w	d2,d0
	;asr.l	#8,d0
		;emulate asr#8 with this sequence
		add.l	d0,d0
		add.l	d0,d0
		swap	d0

	;test theoretical max value for N - works
	move.l	#X_RANGE/2,d0	;max is 256
	move.w	#256*127,d2
	muls.w	d2,d0
	asr.l	#8,d0

	;test with N>127 - becomes negative but asr moves it back I guess?
	move.l	#X_RANGE/2,d0	;max is 256
	move.w	#256*150,d2
	muls.w	d2,d0
	asr.l	#8,d0

	;test with N>127 - fails
	move.l	#X_RANGE/2,d0	;max is 256
		asl.w	#7,d0		;we want this to save one nop below
	move.w	#256*150,d2
	muls.w	d2,d0
	;asr.l	#8,d0
		;emulate asr#8 with this sequence
		add.l	d0,d0
		swap	d0

	;test with a mulu - remains positive
	move.l	#X_RANGE/2,d0	;max is 256
	move.w	#256*150,d2
	mulu.w	d2,d0
	asr.l	#8,d0

	;test with N>127 and mulu - works. We saved one bit of accuracy with mulu.
	move.l	#X_RANGE/2,d0	;max is 256
		asl.w	#7,d0		;we want this to save one nop below
	move.w	#256*150,d2
	mulu.w	d2,d0
	;asr.l	#8,d0
		;emulate asr#8 with this sequence
		add.l	d0,d0
		swap	d0

	;now test with N=100, mulu, and a single final swap. Kind of works!
	move.l	#(X_RANGE/2)-1,d0	;max is 256 but we need to limit to 0xff
		asl.w	#8,d0		;we want this to save two nops below
	move.w	#256*100,d2
	mulu.w	d2,d0
	;asr.l	#8,d0
		;emulate asr#8 with this sequence
		swap	d0


	SwitchToSuper

	IFNE ENABLE_2BP_VERSION
;	move.b	#1,BitplaneFlag
	ENDC

	bsr		Lib_SaveEnv

	lea		MulsTable,a0
	bsr		CreateMulsTable

;	lea		PixelTable2,a0
;	bsr		CreateSinglePixelTable
	bsr		ShufflePixelTable

	bsr		PrepareStars

	move.l	#ScreenBuffer,d0
	clr.b	d0
	move.w	#NB_SCREENS-1,d7
	lea		ScreenPtrs,a0
	move.l	#SCREEN_SIZE,d1
	clr.b	d1
.InitScr
	move.l	d0,(a0)+
	add.l	d1,d0
	dbf		d7,.InitScr
	
	IFNE TEST_PICTURE
		move.w	#NB_SCREENS-1,d7
		lea		ScreenPtrs,a0
.InitScr2
		move.l	(a0)+,a1
	
		lea		Picture+34,a2
		move.w	#200-1,d5
.NextLine		
		move.w	#(8000/200)-1,d6
.CopyPic
;		move.l	(a2)+,(a1)+
		dbf		d6,.CopyPic
;		lea		(230-160)(a1),a1
		dbf		d5,.NextLine
	
		dbf		d7,.InitScr2
	ENDC



;	move.w	#$2700,SR		?? this line here makes the full fail
;	MOVE.L	#InterRTE,$70.W
	;before: 692 vbls?!?
	;=> probably because NB_STARS is very small so the outer loops overhead becomes more important!! (28/4 vs 10000 iters)
	;515 vbls if we skip the whole last part drawing the stars!
	;781 vbls => 15.62s
	;776 vbls with mulus :) => 15.52s
	;736 vbls with PRESHIFT_XY => 14.72s
	;727 vbls with bitplane flag optim => 14.54s
	;709 vbls with register init moved to external loop => 14.18s
	;706 vbls moving gen new star out of loop/saving one jump => 14.12s
	;(703 vbls dropping the mulu in rnd gen)
	;(486 vbls if we skip the whole last part drawing the stars)
	;682 vbls with automodif code => 13.64s
	;678 vbls by saving a1 in a6 instead of usp => 13.56s
	move.l	#VblCount,$70.w

SavedD7	dc.w	$4e71
	move.w	#NB_PREPLOT_STEPS,d7
	beq		.SkipPreplot
;	bra.s	.SkipPreplot
	subq.w	#1,d7
.PrePlot
	move.w	d7,SavedD7
		bsr		PlotStars
		bsr		FlipBuffers
	move.w	SavedD7,d7
	dbf		d7,.PrePlot
.SkipPreplot






	move.b	#0,$ffff8260.w	;Switch to low res

	IFEQ	KILL_INTERRUPTS
	move.w	#$2700,SR
	ENDC
	
	lea		ScreenPtrs,a0
	move.b	1(a0),$FFFF8201.w
	move.b	2(a0),$FFFF8203.w

	IFEQ	KILL_INTERRUPTS
	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w

	IFNE	ENABLE_FULLSCREEN
		clr.b	$FFFFFA13.W
		clr.b	$FFFFFA15.W
	ENDC

;Redirect exception vectors to quit
	move.l	#Quit,$008.w
	move.l	#Quit,$00C.w
	move.l	#Quit,$010.w
	move.l	#Quit,$014.w
	move.l	#Quit,$018.w
	move.l	#Quit,$01c.w
	move.l	#Quit,$020.w
	move.l	#Quit,$024.w
	ENDC

	moveq	#0,d1
	lea		$FFFF8240.W,a0
	moveq	#16-1,d0
.AllBlack:
	move.w	d1,(a0)+
	dbf		d0,.AllBlack




	MOVE.L	#InterRTE,$70.W
		MOVE.L	#InterRTE,$68.W
		MOVE.L	#InterRTE,$120.W


	move.l	#Vbl,$70.w

	IFNE	ENABLE_FULLSCREEN
		clr.b	$FFFFFA1B.W
		bset	#0,$FFFFFA07.W
		bset	#0,$FFFFFA13.W
	ENDC



	move.w	#$2300,SR

;	bsr		MainLoop

Loop:
	bra.s	Loop

;======================================

Quit:
	move.w	#$2700,SR

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

	bsr		Lib_RestoreEnv

	BackToUser
;Quit
	clr.w	-(sp)
	trap	#1

;======================================

Vbl:
;	addq.w	#1,NB_VBL
	
	IFNE	ENABLE_FULLSCREEN
		CLR.B	$FFFFFA1B.W
		MOVE.B	#0,$FFFFFA19.W
		MOVE.B	#99,$FFFFFA1F.W
		MOVE.B	#4,$FFFFFA19.W
		BCLR	#3,$FFFFFA17.W
		MOVE.L	#INTER_TMA,$134.W
		ORI.B	#$20,$FFFFFA13.W
		ORI.B	#$20,$FFFFFA07.W
	ENDC
	
;	move.w	#$444,$FFFF8240.W
	bsr		SetupPalette
;	move.w	#$000,$FFFF8240.W

;	move.w	#$444,$FFFF8240.W
	bsr		PlotStars
;	move.w	#$000,$FFFF8240.W
	
	bsr		FlipBuffers
	lea		ScreenPtrs,a0
	move.b	1(a0),$FFFF8201.w
	move.b	2(a0),$FFFF8203.w

	cmpi.b	#$f,$fffffc02.w
	bne.s	.NoTab
	move.w	#$444,$FFFF8240.W
.NoTab

	cmpi.b	#$39,$fffffc02.w
	bne.s	.EndVBL
	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
.EndVBL:
	rte
VblCount:
	addq.w	#1,NBVBL
	rte
	
;VSync
;	clr.w	NB_VBL
;.Wait	
;	cmpi.w	#1,NB_VBL
;	bne.s	.Wait
;	rts

;======================================

FlipBuffers:
	IFNE ENABLE_2BP_VERSION
		tst.b	BitplaneFlag
		bne.s	.FlipTime
		move.b	#2,BitplaneFlag
		rts
.FlipTime
		clr.b	BitplaneFlag
	ENDC

	lea		ScreenPtrs,a0
	move.l	(a0),d0
	REPT	NB_SCREENS-1
		move.l	4(a0),(a0)
		lea		4(a0),a0
	ENDR
	move.l	d0,(a0)

;	lea		ScreenPtrs,a0
;	move.b	1(a0),$FFFF8201.w
;	move.b	2(a0),$FFFF8203.w
	rts

;======================================

	IFNE	ENABLE_FULLSCREEN

INTER_TMA:
	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w
	move.w	#$2100,SR

	lea		$FFFF820A.w,a5
	lea		NEW_PALETTE,a0
;	lea		$FFFF8244.w,a1

;	move.w	#$700,$ffff8244.w
;	move.w	#$700,$ffff824c.w
;	move.w	#$700,$ffff8254.w
;	move.w	#$700,$ffff825c.w
	
	moveq	#0,d0
	moveq	#2,d1

	stop	#$2100
	move.w	#$2700,SR
	move.w	#$2300,(SP)

	moveq	#29,d2
.SYNCHROA
	dbf		d2,.SYNCHROA
	nop
	move.b	d0,(a5)
	REPT	6
		nop
	ENDR
	move.b	d1,(a5)

	LEA		$FFFF8209.W,A6
	LEA		$FFFF8260.W,A4
	LEA		$FFFF820A.W,A3
	MOVEQ	#0,D7
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#$10,D6
	
	MOVE.L	#228-12+2-1-1-1+9,D0

.SYNCHRO
	MOVE.B	(A6),D7
	BEQ.S	.SYNCHRO
	SUB.W	D7,D6
	LSL.W	D6,D1

	DCB		97,$4E71

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB		88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB		13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB		12-1,$4E71
	MOVEQ	#42-1,D1

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB		88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB		13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB		12-1,$4E71

.FULLSCREEN
	NOP
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)		;slower version but saves one register, there could be a nop before
;	DCB		88,$4E71	;slower version but saves one register
;	MOVE.b	#0,(A3)		;slower version but saves one register
;		move.w	(a0),$ffff8244.w	4
;		move.w	(a0),$ffff824c.w	4
;		move.w	(a0),$ffff8254.w	4
;		move.w	(a0),$ffff825c.w	4
;		lea		2(a0),a0			2
;		DCB		89-18,$4E71
		
;		move.l	(a0)+,(a1)
;		DCB		89-5,$4E71

		DCB		89,$4E71
		MOVE.b	d2,(A3)
;			MOVE.b	d2,-56(A4)
	MOVE	a4,(A3)
	DCB		13,$4E71
	MOVE	a4,(A4)
;	MOVE.B	#0,(A4)		;slower version but saves one register
		nop
		MOVE.B	d2,(A4)
	DCB		12-4,$4E71
	DBF		D0,.FULLSCREEN

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB		88,$4E71
;		move.w	(a0),$ffff8244.w	4
;		move.w	(a0),$ffff824c.w	4
;		move.w	(a0),$ffff8254.w	4
;		move.w	(a0),$ffff825c.w	4
;		lea		2(a0),a0			2
;		DCB		88-18,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB		13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	CLR.B	$FFFF820A.W 
;		nop
;		CLR.B	(a3)
	DCB		8,$4E71

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	MOVE	A4,(A3)
	DCB		88-2,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB		13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB		12-1,$4E71
	
.F	NOP
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
;		move.w	(a0),$ffff8244.w	4
;		move.w	(a0),$ffff824c.w	4
;		move.w	(a0),$ffff8254.w	4
;		move.w	(a0),$ffff825c.w	4
;		lea		2(a0),a0			2
;		DCB		88-18,$4E71

	DCB		88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB		13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB		12-4,$4E71
	DBF		D1,.F


;	CMPI.B	#$50,$FFFFFC02.W
;	BNE.S	PAS_HAUT
;	ADD.L	#230,Y_VALUE
;PAS_HAUT	CMPI.B	#$48,$FFFFFC02.W
;	BNE.S	PAS_BAS
;	SUB.L	#230,Y_VALUE
;PAS_BAS
;	CMPI.B	#$4B,$FFFFFC02.W
;	BNE.S	PAS_GA
;	ADDQ.L	#8,Y_VALUE
;PAS_GA	CMPI.B	#$4D,$FFFFFC02.W
;	BNE.S	PAS_DR
;	SUBQ.L	#8,Y_VALUE
;PAS_DR
;
;	MOVEQ	#0,D0	
;	MOVEQ	#0,D1
;	MOVE.L	Y_VALUE,D0
;	
;	LSR.L	#8,D0
;	MOVE.L	D0,D1
;	LSL.L	#8,D1
;	
;	MOVE.L	Y_VALUE,D0
;	SUB.L	D1,D0
;
;	IFNE	USE_HARDSCROLL
;	LEA	DATA_HS,A0
;
;	TST.L	D0
;	BNE.S	DEJ
;	LEA	RIEN,A0
;	MOVE.L	A0,PT_HARD
;	BRA.S	OKAY
;DEJ	SUBQ.L	#2,D0
;	MULU	#18,D0
;	ADDA.L	D0,A0
;	MOVE.L	A0,PT_HARD
;	ENDC
;
;OKAY
;	MOVE.L	SCREEN1,D0
;	ADD.L	D1,D0
;	LSR.L	#8,D0
;	LEA		$FFFF8201.W,A0
;	MOVEP	D0,(A0)

	cmpi.b	#$f,$fffffc02.w
	bne.s	.NoTab
	move.w	#$444,$FFFF8240.W
.NoTab


	RTE

;Y_VALUE	DC.L	0
	
	ENDC

;======================================

	IFNE	ROTATE_STARS
		even
Matrix			ds.w	9
SinTable	INCBIN	SIN.LUT		;TODO: generate

GenerateRotMatrix:
	lea		SinTable,a0
	move.l	FrameCounter,d6
	add.w	d6,d6
	add.w	d6,d6

	GetSinCos	a0,d6,d7

	lea		Matrix,a0
	ComputeRotMatrixZ	a0,d6,d7

	rts
	ENDC

;======================================
	IFNE	ROTATE_STARS
Tmp	ds.w	3		
	ENDC

	IFNE	ENABLE_REGULAR_VERSION
;B0	=	$001
;C0	=	$655
;C1	=	$334
;C2	=	$334
;C3	=	$112
B0	=	$000
C0	=	$766
C1	=	$334
C2	=	$112
C3	=	$002
Palette1	dc.w	B0, C0, C1, C0, C2, C0, C1, C0, C3, C0, C1, C0, C2, C0, C1, C0
	ENDC

	IFNE	ENABLE_4BP_VERSION
Palette0	dc.w	$000, $002, $111, $112, $222, $223, $333, $334
			dc.w	$444, $445, $555, $556, $666, $667, $766, $777
	ENDC

	IFNE	ENABLE_2BP_VERSION
B0	=	$000
;C2	=	$655
;C1	=	$334
;C0	=	$112
C2	=	$777
C1	=	$444
C0	=	$222
Palette0	dc.w	B0		0000
			dc.w	C0		0001
			dc.w	C1		0010
			dc.w	C2		0011
			dc.w	B0		0100
			dc.w	C0		0101
			dc.w	C1		0110
			dc.w	C2		0111
			dc.w	B0		1000
			dc.w	C0		1001
			dc.w	C1		1010
			dc.w	C2		1011
			dc.w	B0		1100
			dc.w	C0		1101
			dc.w	C1		1110
			dc.w	C2		1111
			
Palette0b	dc.w	B0		0000
			dc.w	B0		0001
			dc.w	B0		0010
			dc.w	B0		0011
			dc.w	C0		0100
			dc.w	C0		0101
			dc.w	C0		0110
			dc.w	C0		0111
			dc.w	C1		1000
			dc.w	C1		1001
			dc.w	C1		1010
			dc.w	C1		1011
			dc.w	C2		1100
			dc.w	C2		1101
			dc.w	C2		1110
			dc.w	C2		1111
	ENDC
	
SetupPalette:
	;$FFFF8240.W	;0	0000
	;$FFFF8242.W	;1	0001
	;$FFFF8244.W	;2	0010
	;$FFFF8246.W	;3	0011
	;$FFFF8248.W	;4	0100
	;$FFFF824a.W	;5	0101
	;$FFFF824c.W	;6	0110
	;$FFFF824e.W	;7	0111
	;$FFFF8250.W	;8	1000
	;$FFFF8252.W	;9	1001
	;$FFFF8254.W	;10	1010
	;$FFFF8256.W	;11	1011
	;$FFFF8258.W	;12	1100
	;$FFFF825a.W	;13	1101
	;$FFFF825c.W	;14	1110
	;$FFFF825e.W	;15	1111

	IFNE	ENABLE_REGULAR_VERSION
		;Regular version writing each star to one bitplane. This gives us 4 main colors + the background color.
		lea		Palette1,a0
		lea		$FFFF8240.w,a1
		movem.l	(a0),d0-d7
		movem.l	d0-d7,(a1)
	ENDC
	
	IFNE	ENABLE_4BP_VERSION
		move.w	#$000,$FFFF8240.W
		move.w	#$766,d0
		move.w	#$334,d1
		move.w	#$112,d2
		move.w	#$001,d3
			move.w	#$002,d3	
	
;		move.w	d0,$FFFF8242.w
;		move.w	d1,$FFFF8244.w
;		move.w	d2,$FFFF8246.w
;		move.w	d3,$FFFF8248.w

		move.w	d3,$FFFF8258.w
		move.w	d2,$FFFF825a.w
		move.w	d1,$FFFF825c.w
		move.w	d0,$FFFF825e.w
		
		lea		Palette0,a0
		lea		$FFFF8240.w,a1
		movem.l	(a0),d0-d7
		movem.l	d0-d7,(a1)
	ENDC
	
	IFNE	ENABLE_2BP_VERSION
		tst.b	BitplaneFlag
		bne.s	.Second	
		lea		Palette0,a0
		bra.s	.First
.Second
		lea		Palette0b,a0
.First
		lea		$FFFF8240.w,a1
		movem.l	(a0),d0-d7
		movem.l	d0-d7,(a1)
	ENDC
	
	IFNE TEST_PICTURE
		lea		Picture+2,a0
		lea		$FFFF8240.w,a1
		movem.l	(a0),d0-d7
		movem.l	d0-d7,(a1)
	ENDC
	rts

;MainLoop:
;	bsr		VSync
;	bsr		SetupPalette
;
;	bsr		PlotStars
;;	bsr		FlipBuffers
;;	lea		ScreenPtrs,a0
;;	move.b	1(a0),$FFFF8201.w
;;	move.b	2(a0),$FFFF8203.w
;
;	cmpi.b	#$f,$fffffc02.w
;	bne.s	.NoTab
;	move.w	#$444,$FFFF8240.W
;.NoTab
;
;	cmpi.b	#$39,$fffffc02.w
 ;	bne.s	.EndVBL
; ;	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
;	rts
;.EndVBL:
;	bra		MainLoop

PlotStars:
	lea		ScreenPtrs,a1
	lea		(NB_SCREENS-1)*4(a1),a1
	move.l	(a1),a1
		add.w	#(SCREEN_HEIGHT/2)*SCREEN_BYTE_WIDTH,a1
	IFNE	ENABLE_FULLSCREEN
		lea	160(a1),a1
	ENDC
	IFNE	ENABLE_2BP_VERSION
		tst.b	BitplaneFlag
		beq.s	.FirstBitplanes
		lea		4(a1),a1
		
			lea	.AutoModif,a2
			move.w	#$d442,(a2)+	;add.w d2,d2
			move.w	#$d442,(a2)
			bra.s	.SecondBitplanes
		
.FirstBitplanes
			lea	.AutoModif,a2
			move.w	#$4e71,(a2)+
			move.w	#$4e71,(a2)
.SecondBitplanes
		move.l	a1,a6
	ENDC

;	lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
;	lea		MulsTable+MULS_TABLE_START_OFFSET,a4
	lea		DepthData,a2



	moveq	#NB_STEPS_PER_FRAME-1,d0
.NextStep
	move.w	d0,SaveD0

	;/////// Setup registers for main loop

	IFEQ	ROTATE_STARS
		move.l	FrameCounter,d7
		IFNE	PREMUL_Z4
			add.w	d7,d7
			add.w	d7,d7
				add.w	d7,d7
;				add.w	d7,d7
		ENDC
	ELSE
		bsr		GenerateRotMatrix
	ENDC

	lea		Stars,a0
	
	move.l	d7,a3
	
	moveq	#4-1,d4

	;/////// Main loop starts here
	
.NextQuadrant
	move.w	d4,SaveD4

	btst	#0,d4
	beq.s	.PosQuadrantX
;	lea		PixelTableN,a5
	lea		PixelTable2,a5
	bra.s	.NegQuadrantX
.PosQuadrantX
;	lea		PixelTableP,a5
	lea		PixelTable2+CLIP_X*4,a5
.NegQuadrantX

	btst	#1,d4
	beq.s	.PosQuadrantY
	lea		MulsTable,a4
	bra.s	.NegQuadrantY
.PosQuadrantY
	lea		MulsTable+MULS_TABLE_START_OFFSET,a4
.NegQuadrantY


	IFNE	ENABLE_2BP_VERSION
;		tst.b	BitplaneFlag
;		bne.s	.SecondFrameD3D4
;		moveq	#0,d3
;		moveq	#1,d4	
;		bra.s	.FirstFrameD3D4
;.SecondFrameD3D4
;		moveq	#2,d3
;		moveq	#3,d4
;.FirstFrameD3D4

		moveq	#0,d3
		moveq	#1,d4
		move.b	BitplaneFlag,d5
		add.b	d5,d3
		add.b	d5,d4
	ENDC



	move.w	#(NB_STARS/4)-1,d5
.AffDot
	IFNE	ROTATE_STARS
		move.w	(a0)+,d0
		move.w	(a0)+,d1
		move.w	(a0),d2			;This version changes the stored Z value
		subi.w	#SPEED,(a0)+	;using the SPEED param
	ELSE
;		movem.w	(a0)+,d0-d2
		move.w	(a0)+,d0
		move.w	(a0)+,d1
		move.w	(a0)+,d2	;This version keeps stored values const
		sub.w	a3,d2		;and just uses the framecounter to adjust the Z.
	ENDC
		;xp trying per-star variable speeds
		;move.w	d5,d6
		;and.w	#1,d6
		;add.w	#1,d6
		;sub.w	d6,(a0)+

	IFNE	ROTATE_STARS
	;pretty bad stuff to rewrite
		MOVEM.L	D3-A6,-(SP)
			lea		-6(a0),a0
			lea		Tmp,a1
			lea		Matrix,a2
			move.w	#1-1,d7
			bsr		RotatePoints
			
			lea		Tmp,a1
			move.w	(a1)+,d0
			move.w	(a1)+,d1
			move.w	(a1),d2
		MOVEM.L	(SP)+,D3-A6
	ENDC

	IFNE	PREMUL_Z4
		add.w	#Z_RANGE*2,d2	;TODO: store this in a3
	ELSE
		add.w	#Z_RANGE/2,d2	;TODO: store this in a3
	ENDC
	
	ble	.GenerateNewStar

	;Skip pixels beyond far plane - we could keep them in theory but we would have to extend the palette size.
	;Keeping them creates a bad-looking initial batch of stars but saves the two following instructions...
;	cmpi.w	#Z_RANGE,d2
;	bge.s	.NextDot

	;Fetch precomputed data from Z using the depth table
;	subq	#1,d2
	IFEQ	PREMUL_Z4
		add.w	d2,d2
		add.w	d2,d2
	ENDC
	
;		cmp.w	#0,d2
;		bge.s	.ok0
;		illegal
;.ok0
;		cmp.w	#Z_RANGE*2*4,d2
;		blt.s	.ok1
;		illegal
;.ok1
	
	move.l	(a2,d2.w),d2	;This gives both the color/plane offset and the precomputed 1/z

	;Debug center pixel
;	move.w	#256,d2
;	move.w	#0,d0
;	move.w	#0,d1

	;TODO: would mulu be faster per quadrant?
	;Actually d0 is in the range X_RANGE so we could have a mul table here?
	;In fact we could have X_RANGE/2 "div" tables as well to precompute everything.
	;But we want to save memory for video screens here so...
;	muls.w	d2,d0		;x*256*N/z
		mulu.w	d2,d0		;x*256*N/z
		
	IFNE	PRESHIFT_XY
;		add.l	d0,d0
;		add.l	d0,d0
		swap	d0
	ELSE
		asr.l	#8,d0		;x*N/z		TODO: replace with add/swap
	ENDC		
		
	;TODO: consider storing the sign somewhere else and doing one clip only
	;=> or split stored stars in 4 quadrants
	;=> or take the abs value and do 1 cmp only
	;=> or just use larger tables that take this into account
	;	Tables could be quite large though. For X the max X is X_RANGE/2, which is then multiplied by "100"
	;	during projection, so that's a (X_RANGE/2)*100*sizeof(table entry), *2 for both positive/negative parts.
	;	That's (512/2)*100*4*2 = 204800 bytes just to avoid clipping on X ! Divide by 4 for Y (half range + half data size)
	;	Storing per quadrant could help as well here (we'd only need half of the size)
	;=> We could also do something intermediate like a table to remap X. That way we only need a word table (half the size again)
	;	and we just remap clipped Xs to the first column or something.
	;=> Recycle the star as soon as it's clipped!! Don't let it go all the way. That way the extra clip table should be a lot smaller....
	;	But we'd still need to *detect* clipping then, to trigger recycling... That's still a table access + test...
	
	;Clipping used to call ".NextDot" but generating a new star immediately avoids the widely fluctuating frame time
;	cmpi.w	#-CLIP_X,d0
;	blt	.GenerateNewStar
;	cmpi.w	#CLIP_X,d0
	cmpi.w	#CLIP_X-1,d0
	bge	.GenerateNewStar

;TODO: create two different X tables, select proper one according to d4 (outside of the loop), then keep only one clip etc
;		btst	#0,d4
;		beq.s	.PosQuadrantX
;		neg.w	d0
;.PosQuadrantX

;	muls.w	d2,d1		;y*256*N/z
		mulu.w	d2,d1		;y*256*N/z
	IFNE	PRESHIFT_XY
;		add.l	d1,d1
;		add.l	d1,d1
		swap	d1
	ELSE
		asr.l	#8,d1		;y*N/z
	ENDC		

;		andi.w	#$fffe,d0
;		andi.w	#$fffe,d1

;	cmpi.w	#-CLIP_Y,d1
;	blt	.GenerateNewStar
;	cmpi.w	#CLIP_Y,d1
	cmpi.w	#CLIP_Y-1,d1
	bge	.GenerateNewStar

	swap	d2	;Get back color offset in low word

;		andi.w	#~3,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d1

;		moveq	#0,d0
;		moveq	#0,d1
;		moveq	#6,d2

	IFNE	ENABLE_REGULAR_VERSION
		move.l	(a5,d0.w),d0	;pixel mask|screen offsetx
		add.w	d0,d2			;add offsetx to color/plane offset
		swap	d0				;screen offset|pixel mask
		add.w	(a4,d1.w),d2	;add offsety to main screen offset
		or.w	d0,(a1,d2.w)	;plot pixel
	ENDC

TestBit	MACRO
		and.w	d0,d1
		beq.s	.\1
		bset	#\2,d6
.\1
	ENDM

TestBit2	MACRO
		and.w	d0,d1
		beq.s	.\1
		bset	\2,d6
.\1
	ENDM

BlitToPlane	MACRO
		and.w	d6,\3
		btst	#\2,d2	;TODO: 16 different routines indexed by d2 could help here
		beq.s	.\1
		or.w	d0,\3
.\1
	ENDM

BlitToPlane2	MACRO
		and.w	d6,\3
		btst	\2,d2	;TODO: 16 different routines indexed by d2 could help here
		beq.s	.\1
		or.w	d0,\3
.\1
	ENDM

	IFNE	ENABLE_4BP_VERSION
		move.l	(a5,d0.w),d0	;pixel mask|screen offsetx
		move.w	d0,d3			;offsetx
		swap	d0				;screen offset|pixel mask
		add.w	(a4,d1.w),d3	;add offsety to main screen offset

		move.l	a1,USP	;Save screen pointer
		add.w	d3,a1	;d3 is free after this, also avoids recomputing the address N times in "move.l (a1,d3.w)" calls

		;d2 = 0-15 color index
		;We're going to reconstruct the color index from current bitplanes (i.e. use the framebuffer as a z-buffer with color index == z)		
		moveq	#0,d6	;rebuilt color index

		;Deal with plane 1 & 2
		move.l	(a1),d1		;puts plane2 data in low word, same as "move.l (a1,d3.w),d1"
		move.l	d1,d7		;save data for second part, ands are destructive
		TestBit	P1x,1
		swap	d1
		TestBit	P0x,0
		
		;Deal with plane 3 & 4
		move.l	4(a1),d1	;puts plane2 data in low word, same as "move.l 4(a1,d3.w),d1"
		move.l	d1,d3		;save data for second part, ands are destructive
		TestBit	P3x,3
		swap	d1
		TestBit	P2x,2

		;"Z Buffer"... skip pixel if current one is in front of us
		cmp.w	d2,d6
		bge.s	.CullDot

		;Now we plot each dot like a sprite
		move.w	d0,d6
		not.w	d6

		;Deal with plane 1 & 2
		;Work on saved data in d7, same as "move.l (a1,d3.w),d1"
		BlitToPlane	P1,1,d7
		swap		d7
		BlitToPlane	P0,0,d7
		swap		d7
		move.l		d7,(a1)	;Write back to screen, same as "move.l d1,(a1,d3.w)"

		;Deal with plane 3 & 4
		;Work on saved data in d3, same as "move.l 4(a1,d3.w),d1"
		BlitToPlane	P3,3,d3
		swap		d3
		BlitToPlane	P2,2,d3
		swap		d3
		move.l		d3,4(a1)	;Write back to screen, same as "move.l d1,4(a1,d3.w)"

.CullDot
		move.l	USP,a1		;Restore screen pointer	
	ENDC

	IFNE	ENABLE_2BP_VERSION_BACKUP
		;TODO: this may not be useful anymore since we don't access a1 as much as in the 4P version
		move.l	a1,USP	;Save screen pointer
	
		;TODO: bset-based plot
;		move.l	(a5,d0.w),d0	;pixel mask|screen offsetx
;		move.w	d0,d6			;offsetx
;		swap	d0				;screen offset|pixel mask
;		add.w	(a4,d1.w),d6	;add offsety to main screen offset
;		add.w	d6,a1	;d6 is free after this, also avoids recomputing the address N times in "move.l (a1,dx.w)" calls
			move.l	(a5,d0.w),d0	;pixel mask|screen offsetx
			add.w	(a4,d1.w),d0	;add offsety to main screen offset
			add.w	d0,a1	;d6 is free after this, also avoids recomputing the address N times in "move.l (a1,dx.w)" calls
			swap	d0				;screen offset|pixel mask

		;d2 = ... color index
		;We're going to reconstruct the color index from current bitplanes (i.e. use the framebuffer as a z-buffer with color index == z)		
		moveq	#0,d6	;rebuilt color index

		tst.b	BitplaneFlag
		bne.s	.SecondFrame

		;Deal with plane 1 & 2
		move.l	(a1),d1		;puts plane2 data in low word, same as "move.l (a1,d3.w),d1"
		move.l	d1,d7		;save data for second part, ands are destructive
;		TestBit	P1x,1
		TestBit2	P1x,d4
		swap	d1
;		TestBit	P0x,0
		TestBit2	P0x,d3

		;"Z Buffer"... skip pixel if current one is in front of us
		cmp.w	d2,d6
		bge.s	.CullDot

		;Now we plot each dot like a sprite
		move.w	d0,d6
		not.w	d6
		
		;Deal with plane 1 & 2
		;Work on saved data in d7, same as "move.l (a1,d3.w),d1"
;		BlitToPlane	P1,1,d7
		BlitToPlane2	P1,d4,d7
		swap		d7
;		BlitToPlane	P0,0,d7
		BlitToPlane2	P0,d3,d7
		swap		d7
		move.l		d7,(a1)	;Write back to screen, same as "move.l d1,(a1,d3.w)"
		
		bra.s	.CullDot
		
.SecondFrame

		;Tweak color index
		add.w	d2,d2
		add.w	d2,d2

		;Deal with plane 3 & 4
;		move.l	4(a1),d1	;puts plane2 data in low word, same as "move.l 4(a1,d3.w),d1"
		move.l	(a1),d1		;puts plane2 data in low word, same as "move.l 4(a1,d3.w),d1"
		move.l	d1,d7		;save data for second part, ands are destructive
;		TestBit	P3x,3
		TestBit2	P3x,d4
		swap	d1
;		TestBit	P2x,2
		TestBit2	P2x,d3

		;"Z Buffer"... skip pixel if current one is in front of us
		cmp.w	d2,d6
		bge.s	.CullDot

		;Now we plot each dot like a sprite
		move.w	d0,d6
		not.w	d6

		;Deal with plane 3 & 4
		;Work on saved data in d7, same as "move.l 4(a1,d7.w),d1"
;		BlitToPlane	P3,3,d7
		BlitToPlane2	P3,d4,d7
		swap		d7
;		BlitToPlane	P2,2,d7
		BlitToPlane2	P2,d3,d7
		swap		d7
;		move.l		d7,4(a1)	;Write back to screen, same as "move.l d1,4(a1,d7.w)"
		move.l		d7,(a1)		;Write back to screen, same as "move.l d1,4(a1,d7.w)"

.CullDot
		move.l	USP,a1		;Restore screen pointer		
	ENDC





	IFNE	ENABLE_2BP_VERSION
		;TODO: this may not be useful anymore since we don't access a1 as much as in the 4P version
		move.l	a6,a1		;Restore screen pointer		
	
		;TODO: bset-based plot
			move.l	(a5,d0.w),d0	;pixel mask|screen offsetx
			add.w	(a4,d1.w),d0	;add offsety to main screen offset
			add.w	d0,a1	;d6 is free after this, also avoids recomputing the address N times in "move.l (a1,dx.w)" calls
			swap	d0				;screen offset|pixel mask

		;d2 = ... color index
		;We're going to reconstruct the color index from current bitplanes (i.e. use the framebuffer as a z-buffer with color index == z)		
		moveq	#0,d6	;rebuilt color index

.AutoModif
		nop
		nop

		;Deal with plane 1 & 2
		move.l	(a1),d1		;puts plane2 data in low word, same as "move.l (a1,d3.w),d1"
		move.l	d1,d7		;save data for second part, ands are destructive
		TestBit2	P1x,d4
		swap	d1
		TestBit2	P0x,d3

		;"Z Buffer"... skip pixel if current one is in front of us
		cmp.w	d2,d6
		bge.s	.CullDot

		;Now we plot each dot like a sprite
		move.w	d0,d6
		not.w	d6
		
		;Deal with plane 1 & 2
		;Work on saved data in d7, same as "move.l (a1,d3.w),d1"
		BlitToPlane2	P1,d4,d7
		swap		d7
		BlitToPlane2	P0,d3,d7
		swap		d7
		move.l		d7,(a1)	;Write back to screen, same as "move.l d1,(a1,d3.w)"
.CullDot
	ENDC





.NextDot

	dbf		d5,.AffDot
	move.w	SaveD4,d4
	dbf		d4,.NextQuadrant

	;/////// Main loop ends here

	addq.l	#1,FrameCounter

	move.w	SaveD0,d0
	dbf		d0,.NextStep

	subi.l	#NB_STEPS_PER_FRAME-1,FrameCounter


;	bra.s	.NextDot3
;.NextDot2
;	cmp.w	MAX_D0,d0
;	blt.s	.NextDot
;	move.w	d0,MAX_D0
;	bra.s	.NextDot
;.NextDot3

;	bsr		FlipBuffers
	
	rts

;/////// Generate new star when out of range
.GenerateNewStar

	cmp.w	#NB_STEPS_PER_FRAME-1,SaveD0
	bne		.NextDot
;	bra		.NextDot

	move.l	Random,d6
	bsr		GenerateStarXY
	move.w	d0,-6(a0)
	move.w	d1,-4(a0)
	move.l	d6,Random
			
	IFNE	PREMUL_Z4
		move.w	#Z_RANGE*2,-2(a0)
	ELSE
		move.w	#Z_RANGE/2,-2(a0)
	ENDC
	IFEQ	ROTATE_STARS
		move.w	a3,d7
		add.w	d7,-2(a0)		;take framecounter's adjustment into account
	ENDC
	bra		.NextDot



;MAX_D0	dc.w	0	
	
InterRTE:
	rte

	section data
	even

	IFNE TEST_PICTURE
Picture	incbin	nebula.pi1
	ENDC
	
	
;Copied from BLOOD
PALETTE
	REPT	21
	DC	$001,$011
	ENDR
	DC	$112,$122
	DC	$001,$011
	REPT	32
	DC	$112,$122
	ENDR
	DC	$223,$233
	DC	$112,$122
	REPT	16
	DC	$223,$233
	ENDR
	DC	$334,$344
	DC	$223,$233
	REPT	8
	DC	$334,$344
	ENDR
	DC	$445,$455
	DC	$334,$344
	REPT	4
	DC	$445,$445
	ENDR
	DC	$556,$566
	DC	$445,$455
	REPT	3
	DC	$556,$556
	ENDR
	DC	$667,$677
	DC	$556,$566
	REPT	2
	DC	$667,$677
	ENDR
	DC	$777,$777
	DC	$667,$677
	DC	$777,$777

***

	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777
	DC	$777,$777

***
	DC	$767,$777
	DC	$656,$677
	DC	$767,$777
	DC	$656,$677
	DC	$656,$677
	DC	$545,$566
	DC	$656,$677
	REPT	3
	DC	$545,$566
	ENDR
	DC	$434,$455
	DC	$545,$566
	REPT	4
	DC	$434,$455
	ENDR
	DC	$323,$344
	DC	$434,$455
	REPT	8
	DC	$323,$344
	ENDR
	DC	$212,$233
	DC	$323,$344
	REPT	16
	DC	$212,$233
	ENDR
	DC	$101,$122
	DC	$212,$233
	REPT	32
	DC	$101,$122
	ENDR
	DC	$001,$011
	DC	$101,$122
	REPT	21+2+20
	DC	$001,$011
	ENDR
	DC	0,0	
	
;C2	=	$777
;C1	=	$444
;C0	=	$222
	
NEW_PALETTE
	REPT	28
		DC	$777
	ENDR
	REPT	24
		DC	$666
	ENDR
	REPT	20
		DC	$555
	ENDR
	REPT	16
		DC	$444
	ENDR
	REPT	12
		DC	$333
	ENDR
	REPT	8
		DC	$222
	ENDR
	REPT	4
		DC	$111
	ENDR
***
	REPT	14
		DC	$111
	ENDR
		DC	$111
	REPT	14
		DC	$111
	ENDR
***
	REPT	4
		DC	$111
	ENDR
	REPT	8
		DC	$222
	ENDR
	REPT	12
		DC	$333
	ENDR
	REPT	16
		DC	$444
	ENDR
	REPT	20
		DC	$555
	ENDR
	REPT	24
		DC	$666
	ENDR
	REPT	28
		DC	$777
	ENDR




	
	
	
	section bss
	even

StartBSS:
				ds.b	256
ScreenBuffer	ds.b	SCREEN_SIZE*NB_SCREENS
ScreenPtrs		ds.l	NB_SCREENS

SavedEnv		ds.l	SAVED_ENV_DWORD_SIZE
FrameCounter	ds.l	1
Random			ds.l	1	;Current random value for creating new stars

PixelTable2		ds.l	SINGLE_PIXEL_TABLE_SIZE

MulsTable		ds.w	MULS_TABLE_SIZE

Stars			ds.w	NB_STARS*3	;x y z
DepthData		ds.l	Z_RANGE*2	;*2 because we want to spawn the initial batch very far away
	
SaveD0			ds.w	1
SaveD4			ds.w	1
NBVBL			ds.w	1
	IFNE ENABLE_2BP_VERSION
BitplaneFlag	ds.b	1	
	ENDC
EndBSS:
