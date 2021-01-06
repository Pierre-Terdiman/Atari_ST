;Sommerhack 2019

;	opt	o+,a+
	opt	o+
;	opt	p+

;	org	$600
;	org	$2000

speed	EQU 42	; timer d (pre-div 4)
;speed	EQU 60	; timer d (pre-div 4)
;speed	EQU 50	; timer d (pre-div 4)
;speed	EQU 40	; timer d (pre-div 4)

FADE_SPEED	set	2
FADE_BITS	set	1

SCROLLER				= 1

ENABLE_REGULAR_VERSION	= 0	;4 colors
ENABLE_4BP_VERSION		= 0	;4 bitplanes version (real 16 colors)
ENABLE_2BP_VERSION		= 1	;Two bitplanes mode (virtually double the amount of screens)

KILL_INTERRUPTS			= 0
ROTATE_STARS			= 0
PREMUL_Z4				= 1	;Premultiplies stored Z values by 4
TEST_DEBUG				= 0

SCREEN_BYTE_WIDTH	= 160
SCREEN_HEIGHT		= 200
SCREEN_GUARDBAND	= 0
SCREEN_SIZE			= 32000
CLIP_X				= 160
CLIP_Y				= 100	-4

SIN_TABLE_SIZE	=	1024
;NB_SCREENS	= 15
NB_SCREENS	= 11	+1
;NB_SCREENS	= 30
X_RANGE		= 512
Y_RANGE		= 256
Z_RANGE		= 256
;Z_RANGE		= 512

;NB_STEPS_PER_FRAME	= 8
NB_STEPS_PER_FRAME	= 6
;NB_STEPS_PER_FRAME	= 4
;NB_STEPS_PER_FRAME	= 1
;NB_PREPLOT_STEPS	= 4096
;NB_PREPLOT_STEPS	= 10000
;NB_PREPLOT_STEPS	= 15000
NB_PREPLOT_STEPS	= 12000
;NB_PREPLOT_STEPS	= 20000
;NB_PREPLOT_STEPS	= 0

	IFNE	ROTATE_STARS
NB_STARS	= 100
	ELSE
;Must be at least 4
;NB_STARS	= 16/NB_STEPS_PER_FRAME
NB_STARS	= 30/NB_STEPS_PER_FRAME
;NB_STARS	= 24/NB_STEPS_PER_FRAME
;NB_STARS	= 18*6/NB_STEPS_PER_FRAME
;NB_STARS	= 28/NB_STEPS_PER_FRAME
;NB_STARS	= 32/NB_STEPS_PER_FRAME
;NB_STARS	= 44/NB_STEPS_PER_FRAME
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
;	include	LIB/ENV.S
;	include	LIB/SYS.S
;	include	LIB/PIXT.S
	include	LIB/MULY.S

	INCLUDE		BALLGFX.S

BasicDrawGfx:
	REPT	GFX_PIXEL_SIZE
		move.w	(a0)+,d2
		or.w	d2,(a1)
		move.w	(a0)+,d2
		or.w	d2,8(a1)
		lea		160(a1),a1
	ENDR
	rts

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
	rts

PrepareStars:
	moveq	#42,d6	;Initial random seed
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
;	move.l	#256*200,d3
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
;F_PILE	DS.L 	128	
;D_PILE	DS.L 	1

Start:

	PEA	0.W
	MOVE #$20,-(SP)	
	TRAP #1
	ADDQ.L #6,SP


	LEA		my_stack,SP
;	move.w	#$700,$ffff8240.w

;	MOVE.L	4(SP),A0	MSHRINK
;	MOVE.L	$C(A0),D0	
;	ADD.L	$14(A0),D0	
;	ADD.L	$1C(A0),D0	
;	ADD.L	#$100,D0
;	MOVE.L	D0,-(SP)
;	MOVE.L	A0,-(SP)
;	CLR.W	-(SP)
;	MOVE.W	#$4A,-(SP)
;	TRAP	#1
;	LEA	12(SP),SP

;	MOVE.L	4(A7),A0
;	MOVE.L	$C(A0),D0
;	ADD.L	$14(A0),D0
;	ADD.L	$1C(A0),D0
;	ADD.L	#$800,D0
;	ANDI.L	#-2,D0
;	LEA.L	0(A0,D0),A7
;	MOVE.L	D0,-(A7)
;	MOVE.L	A0,-(A7)
;	CLR.W	-(A7)
;	MOVE.W	#$4A,-(A7)  *code mshrink
;	TRAP 	#1
;	ADD.L 	#12,A7


;DEBUT:
;	MOVE.L  A7,A5
;	LEA.L 	D_PILE,A7
;	MOVE.L 	4(A5),A5
;	MOVE.L 	$C(A5),D0
;	ADD.L 	$14(A5),D0
;	ADD.L 	$1C(A5),D0
;	ADD.L 	#$100,D0	
;	MOVE.L 	D0,-(SP)	
;	MOVE.L 	A5,-(SP)
;	MOVE.W 	#0,-(SP)
;	MOVE.W 	#$4A,-(SP)
;	TRAP 	#1
;	LEA 	12(SP),SP

	bsr		Lib_ClearBSS
	
;	SwitchToSuper
	
;	move.w	#$070,$ffff8240.w
	
;	MOVEM.L $FFFF8240.W,D0-D7
;	MOVEM.L D0-D7,old_stuff
;	MOVEQ	#0,D0
;	MOVEQ	#0,D1
;	MOVEQ	#0,D2
;	MOVEQ	#0,D3
;	MOVEQ	#0,D4
;	MOVEQ	#0,D5
;	MOVEQ	#0,D6
;	MOVEQ	#0,D7
;	MOVEM.L	D0-D7,$FFFF8240.W

	move.b	#0,$ffff8260.w	;Switch to low res
	move.w	#$2700,SR
	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w

	MOVE.L	#InterRTE,$70.W
	MOVE.L	#InterRTE,$68.W
	MOVE.L	#InterRTE,$120.W

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

;	jmp	skipallthis


		;Copy packed 1p data to temporary place
;		lea		Picture1P,a0
;		lea		ScreenBuffer,a1
;		add.l	#64000,a1
;		
;		move.w	#2986/4,d7
;.CopyPak1p
;		move.l	(a0)+,(a1)+
;		dbf		d7,.CopyPak1p
;	
;		;Unpack packed 1p data
;		lea		ScreenBuffer,a0
;		add.l	#64000,a1
;		jsr		unpack


		;Copy packed data to temporary place
		lea		PicturePak,a0
		lea		ScreenBuffer,a1
		move.w	#8638/4,d7
.CopyPak
		move.l	(a0)+,(a1)+
		dbf		d7,.CopyPak
	
		;Unpack packed data
		lea		ScreenBuffer,a0
		jsr		unpack

		;Set palette
;		lea		Picture+2,a0
		lea		ScreenBuffer+2,a0
;		lea		$FFFF8240.w,a1
		movem.l	(a0),d0-d7
;		movem.l	d0-d7,(a1)
		MOVEM.L D0-D7,old_stuff
;		move.w	#$001,(a1)

		move.l	#ScreenBufferX,d0
		clr.b	d0
		move.l	d0,a1
;		lea		Picture+34,a2
		lea		ScreenBuffer+34,a2
		move.w	#200-1,d5
.NextLine2
		move.w	#(8000/200)-1,d6
.CopyPic2
		move.l	(a2)+,(a1)+
		dbf		d6,.CopyPic2
		dbf		d5,.NextLine2
	
		lsr.l	#8,d0
		move.w	#$8201,a0
		movep.w	d0,(a0)

		;Clear our mess
		lea		ScreenBuffer,a1
		moveq	#0,d0
		move.w	#32066/4,d7
.ClearPak
		move.l	d0,(a1)+
		dbf		d7,.ClearPak

		;Set palette
		MOVEM.L old_stuff(PC),D0-D7	; restore palette
		lea		$FFFF8240.w,a1
		MOVEM.L D0-D7,(a1)
		move.w	#$001,(a1)

		move.l	#VblIntro,$70.w
		move.w	#$2300,SR

;	move.w	#$007,$ffff8240.w

;	IFNE TEST_PICTURE
;		move.w	#NB_SCREENS-1,d7
;		lea		ScreenPtrs,a0
;.InitScr2
;		move.l	(a0)+,a1	
;;		lea		Picture1P+34,a2
;		lea		ScreenBuffer,a0
;		add.l	#64000+34,a1
;		move.w	#200-1,d5
;.NextLine		
;N	set	0
;		REPT	20
;			move.w	N(a2),N(a1)
;			move.w	N(a2),N+4(a1)
;			move.w	N(a2),N+2(a1)
;			move.w	N(a2),N+6(a1)
;N	set	N+8
;		ENDR		
;		lea		160(a2),a2
;		lea		160(a1),a1		
;		dbf		d5,.NextLine
;		dbf		d7,.InitScr2
;	ENDC



;	IFNE TEST_PICTURE
;		move.w	#NB_SCREENS-1,d7
;		lea		ScreenPtrs,a0
;.InitScr2
;		move.l	(a0)+,a1	
;		lea		Picture1P+34,a2
;		move.w	#200-1,d5
;.NextLine		
;N	set	0
;		REPT	20
;			move.w	N(a2),N(a1)
;			move.w	N(a2),N+4(a1)
;			move.w	N(a2),N+2(a1)
;			move.w	N(a2),N+6(a1)
;N	set	N+8
;		ENDR		
;		lea		160(a2),a2
;		lea		160(a1),a1		
;		dbf		d5,.NextLine
;		dbf		d7,.InitScr2
;	ENDC



	lea		MulsTable,a0
	bsr		CreateMulsTable

;	lea		PixelTable2,a0
;	bsr		CreateSinglePixelTable
	bsr		ShufflePixelTable

	bsr		PrepareStars



	IFNE	SCROLLER
		bsr		InitScroller
;		bra.s	gogo2
;SAVED	dc.w	0
;gogo
;		move.w	#314,d7
;.Pre
;		move.w	d7,SAVED
;		bsr		VBL_SCROLL
;		bsr		FlipBuffers
;		move.w	SAVED,d7
;		dbf		d7,.Pre
;gogo2		
	ENDC


	move.w	#1,DitherFlag
	lea		Gfx,a0
	bsr		InitGfx
	
;	move.w	#1,DitherFlag
;	lea		Gfx2,a0
;	bsr		InitGfx
	
	bra.s	SkipData
BallData
	dc.w	GFX_PIXEL_SIZE*4*1, 50*160
	dc.w	GFX_PIXEL_SIZE*4*8, 180*160+16*2
	dc.w	GFX_PIXEL_SIZE*4*13, 150*160
	dc.w	GFX_PIXEL_SIZE*4*15, 110*160
	dc.w	GFX_PIXEL_SIZE*4*1, 30*160+160-16*2
	dc.w	GFX_PIXEL_SIZE*4*8, 180*160+160-16*2
	dc.w	GFX_PIXEL_SIZE*4*12, 150*160+160-16
	dc.w	GFX_PIXEL_SIZE*4*15, 110*160+160-16*3
	
	dc.w	GFX_PIXEL_SIZE*4*3, 60*160
	dc.w	GFX_PIXEL_SIZE*4*7, 70*160+16*3
	dc.w	GFX_PIXEL_SIZE*4*13, 155*160+16
	dc.w	GFX_PIXEL_SIZE*4*14, 160*160
	dc.w	GFX_PIXEL_SIZE*4*6, 20*160+160-16
	dc.w	GFX_PIXEL_SIZE*4*10, 160*160+160-16*2
	dc.w	GFX_PIXEL_SIZE*4*11, 140*160+160-16*2
	dc.w	GFX_PIXEL_SIZE*4*9, 120*160+160-16*3
SkipData
	lea		BallData(PC),a2
	move.w	#16-1,d6
	moveq	#0,d4
	moveq	#0,d5
.NextOne
	move.w	(a2)+,d4
	move.w	(a2)+,d5

	move.l	#ScreenBuffer,d0
	clr.b	d0
	move.w	#NB_SCREENS-1,d7
.NextScr
	move.l	d0,d1
	add.l	d5,d1
;		addq.w	#2,d1
	move.l	d1,a1
	
	lea		Gfx,a0
;	btst	#1,d6
;	beq.s	.ff
;	lea		Gfx2,a0
;.ff	
	add.w	d4,a0
	move.l	a0,a3
	
;	lea		GFX_PIXEL_SIZE*4*8(a0),a0
	jsr		BasicDrawGfx
	move.l	d0,d1
	add.l	d5,d1
	addq.w	#4,d1
;		addq.w	#2,d1
	move.l	d1,a1
	
	move.l	a3,a0
	
;	lea		GFX_PIXEL_SIZE*4*8(a0),a0
	jsr		BasicDrawGfx
	
	add.l	#SCREEN_SIZE,d0
	dbf		d7,.NextScr
	dbf		d6,.NextOne


SavedD7	dc.w	$4e71
	move.w	#NB_PREPLOT_STEPS,d7
	beq.s	.SkipPreplot
;	bra.s	.SkipPreplot
	subq.w	#1,d7
.PrePlot
	move.w	d7,SavedD7
;		bsr		SetupPalette
		bsr		PlotStars
		bsr		FlipBuffers
;		lea		ScreenPtrs,a0
;		move.b	1(a0),$FFFF8201.w
;		move.b	2(a0),$FFFF8203.w
	move.w	SavedD7,d7
	dbf		d7,.PrePlot
.SkipPreplot





;	MOVE #0,-(SP)
;	PEA -1.W
;	PEA -1.W
;	MOVE #5,-(SP)
;	TRAP #14
;	LEA 12(SP),SP

;	MOVE.L	SCREEN1,D0
;	LEA	$FFFF8201.W,A0
;	LSR.L	#8,D0
;	MOVEP	D0,(A0)

	move.l	#$00010001,d0
	MOVE.l	d0,D1
	MOVE.l	d0,D2
	MOVE.l	d0,D3
	MOVE.l	d0,D4
	MOVE.l	d0,D5
	MOVE.l	d0,D6
	MOVE.l	d0,D7
	MOVEM.L	D0-D7,$FFFF8240.W
	move.w	#$2700,SR
	MOVE.L	#InterRTE,$70.W

	lea		ScreenPtrs,a0
	move.b	1(a0),$FFFF8201.w
	move.b	2(a0),$FFFF8203.w

	lea		Picture1P2,a0
	jsr		unpack
	
	lea		mt_data,a0
	jsr		unpack

	BSR		Init_Voltab

	LEA		mt_data,A0
	BSR		mt_init	; initialise mod data.

	BSR.s	init_ints	; and go!
	MOVE.L	$120.W,ANC_TB
	MOVE.L	#TB0_IR,$120.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	move.w	#$2300,SR

WAIT
	TST.w	FlagLogo
	BEQ.S	WAIT
	move.w	#0,FlagLogo
	bsr		CopyLogo
;	TST.L	VBL_FLAG
;	BEQ.S	WAIT
;	CLR.L	VBL_FLAG
	BRA.s	WAIT

;FIN
;	BSR restore_ints
;	MOVE.L	ANC_TB,$120.W
;
;exit	
;	MOVEM.L old_stuff(PC),D0-D7	; restore palette
;	MOVEM.L D0-D7,$FFFF8240.W
;	PEA	0.W
;	TRAP	#1
	
; Save mfp vectors and ints and install our own.(very 'clean' setup rout)

init_ints	MOVEQ #$13,D0	; pause keyboard
	BSR Writeikbd	; (stop from sending)
	MOVE #$2700,SR
	LEA old_stuff+32(PC),A0
	MOVE.B $FFFFFA07.W,(A0)+
	MOVE.B $FFFFFA09.W,(A0)+
	MOVE.B $FFFFFA13.W,(A0)+
	MOVE.B $FFFFFA15.W,(A0)+	; Save mfp registers 
	MOVE.B $FFFFFA1D.W,(A0)+
	MOVE.B $FFFFFA25.W,(A0)+
	MOVE.L $70.W,(A0)+
	MOVE.L $110.W,(A0)+	; save some vectors
	MOVE.L $118.W,(A0)+
	CLR.B $fffffa07.W
	MOVE.B #$50,$fffffa09.W
	CLR.B $fffffa13.W
	MOVE.B #$50,$fffffa15.W
	BCLR.B #3,$fffffa17.W	; software end of int.
	MOVE.B #0,$FFFFFA1D.W
	MOVE.B #speed,$FFFFFA25.W
	MOVE.B #1,$FFFFFA1D.W
	LEA my_vbl(PC),A0
	MOVE.L A0,$70.W	; set our vbl
	LEA key_rout(PC),A0
	MOVE.L A0,$118.W	; and our keyrout.
	MOVE #0,D0
	BSR Select_PlayRout
	CLR key	
	LEA sndbuff1(PC),A1
	MOVE #$2300,SR
	MOVEQ #$11,D0	; resume sending
	BSR.s Writeikbd
	MOVEQ #$12,D0	; kill mouse
	BSR.s Writeikbd
	BSR.s flush
	RTS

; Restore mfp vectors and ints.

;restore_ints	
;	MOVEQ #$13,D0	; pause keyboard
;	BSR Writeikbd	; (stop from sending)
;	MOVE #$2700,SR
;	LEA old_stuff+32(PC),A0
;	MOVE.B (A0)+,$FFFFFA07.W
;	MOVE.B (A0)+,$FFFFFA09.W
;	MOVE.B (A0)+,$FFFFFA13.W
;	MOVE.B (A0)+,$FFFFFA15.W	; restore mfp
;	MOVE.B (A0)+,$FFFFFA1D.W
;	MOVE.B (A0)+,$FFFFFA25.W
;	MOVE.L (A0)+,$70.W
;	MOVE.L (A0)+,$110.W
;	MOVE.L (A0)+,$118.W
;	BSET.B #3,$FFFFFA17.W
;	MOVE #$2300,SR
;	MOVEQ #$11,D0	; resume
;	BSR Writeikbd	
;	MOVEQ #$8,D0	; restore mouse.
;	BSR Writeikbd
;	BSR flush
;	RTS

old_stuff:	DS.L 20

; Flush IKBD

flush	BTST.B #0,$FFFFFC00.W	; any waiting?
	BEQ.S .flok	; exit if none waiting.
	MOVE.B $FFFFFC02.W,D0	; get next in queue
	BRA.S flush	; and continue
.flok	RTS

; Write d0 to IKBD

Writeikbd	BTST.B #1,$FFFFFC00.W
	BEQ.S Writeikbd	; wait for ready
	MOVE.B D0,$FFFFFC02.W	; and send...
	RTS

; Keyboard handler interrupt routine...

key_rout	MOVE #$2500,SR	; ipl 5 for 'cleanness' 
	MOVE D0,-(SP)
	MOVE.B $FFFFFC00.W,D0
	BTST #7,D0	; int req?
	BEQ.S .end	
	BTST #0,D0	; 
	BEQ.S .end
	MOVE.B $FFFFFC02.W,key	; store keypress
.end	MOVE (SP)+,D0
	RTE
key	DC.W 0

; Init screen - and clear it too.


; The vbl - calls sequencer and vbl filler.

TB0_IR
;	MOVE	#$001,$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
;TIME	DC.L	0
;VBL_FLAG	DC.L	0
my_vbl	
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#198,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	
Vbl:
	MOVEM.L D0-D6/A0/A2-A6,-(SP)
	
;	addq.w	#1,NB_VBL

;	MOVEM.L D0-D7/A0-A6,-(SP)
;	move.w	#$444,$FFFF8240.W
;	bsr		SetupPalette
;	move.w	#$000,$FFFF8240.W

;;	move.w	#$444,$FFFF8240.W
;	bsr		PlotStars
;;	move.w	#$000,$FFFF8240.W
;	MOVEM.L (SP)+,D0-D7/A0-A6
	
	
;	MOVEM.L D7/A1,-(SP)
		bsr		SetupPalette
		bsr		PlotStars

;		lea		Palette1,a0
;		lea		$FFFF8240.w,a1
;		movem.l	(a0),d0-d7
;		movem.l	d0-d7,(a1)

;	MOVEM.L (SP)+,D7/A1

	IFNE	SCROLLER
;		bsr		VBL_SCROLL
	ENDC

;	moveq	#0,d0
;	moveq	#0,d1
;	moveq	#0,d2
;	moveq	#0,d3
;	moveq	#0,d4
;	moveq	#0,d5
;	moveq	#0,d6
;	moveq	#0,d7
;	move.l	d0,a0
;	move.l	d0,a1
;	move.l	d0,a2
;	move.l	d0,a3
;	move.l	d0,a4
;	move.l	d0,a5
;	move.l	d0,a6
;	move.l	d0,a7
	
	
	MOVEM.L D0-D6/A0/A2-A6,-(SP)
		BSR		Vbl_play
		BSR		mt_music
	MOVEM.L (SP)+,D0-D6/A0/A2-A6
	
	
	bsr		FlipBuffers
	lea		ScreenPtrs,a0
	move.b	1(a0),$FFFF8201.w
	move.b	2(a0),$FFFF8203.w

	move.w	FrameIndex,d0
	addq.w	#1,d0
;	cmpi.w	#200*50,d0
	cmpi.w	#31*50,d0
	bne.s	.EndVBL
	move.w	#1,FlagLogo
.EndVBL:
	move.w	d0,FrameIndex


;	bra.s	.NoSpace
;	cmpi.b	#$39,$fffffc02.w
;	bne.s	.NoSpace
;
;	move.w	#7*FADE_SPEED,d0
;;	lea		CurrentB0,a0
;;	move.w	d0,(a0)+
;;	move.w	d0,(a0)+
;;	move.w	d0,(a0)+
;	
;	lea		CurrentC0,a0
;	move.w	d0,(a0)+
;	move.w	d0,(a0)+
;	move.w	d0,(a0)+
;
;	lea		CurrentC1,a0
;	move.w	d0,(a0)+
;	move.w	d0,(a0)+
;	move.w	d0,(a0)+
;	
;	lea		CurrentC2,a0
;	move.w	d0,(a0)+
;	move.w	d0,(a0)+
;	move.w	d0,(a0)+
;	
;.NoSpace:

	MOVEM.L (SP)+,D0-D6/A0/A2-A6

;	cmpi.b	#$f,$fffffc02.w
;	bne.s	.NoTab
;	move.w	#$444,$FFFF8240.W
;.NoTab

;	cmpi.b	#$39,$fffffc02.w
;	bne.s	.EndVBL
;;	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
;;	bsr		CopyLogo
;	move.w	#1,FlagLogo
;.EndVBL:
	
	
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	.NOPS
	ST	$FFFF8240.W
.NOPS
;	CMPI.B	#$39,$FFFFFC02.W
;	BEQ	FIN
;	MOVE.L	#1,VBL_FLAG
	rte
	
	IFNE	SCROLLER
	
;FadePal	dc.w	16	
	
VblIntro:
	MOVEM.L D0-D7/A0-A6,-(SP)
	
;		MOVEM.L old_stuff(PC),D0-D7	; restore palette
;		lea		$FFFF8240.w,a1
;		MOVEM.L D0-D7,(a1)
;		move.w	#$001,(a1)
	
	
	IFNE	SCROLLER
		bsr		VBL_SCROLL2
;		bsr		VBL_SCROLL2
	ENDC
	MOVEM.L (SP)+,D0-D7/A0-A6
	RTE	

CopyLogo:

	move.w	#26*160,d4
	moveq	#0,d3
;	move.w	#200-1,d5
	move.w	#115-1,d5
.NextLine


	move.l	#ScreenBuffer,d0
	clr.b	d0
	move.l	#SCREEN_SIZE,d1
	clr.b	d1

	move.w	#NB_SCREENS-1,d6
;	lea		ScreenPtrs,a0
.InitScr2
;	move.l	(a0)+,a3
	move.l	d0,a3
;	lea		Picture1P+34,a2
		lea		Picture1P2,a2

;	add.w	d4,a2
		add.w	d3,a2
	add.w	d4,a3
	
;	move.w	#200-1,d5
;.NextLine
N	set	0
	REPT	20
;		move.w	N(a2),d2
		move.w	(a2)+,d2
		or.w	d2,N(a3)
		or.w	d2,N+4(a3)
		or.w	d2,N+2(a3)
		or.w	d2,N+6(a3)
N	set	N+8
	ENDR
	
;	lea		160(a2),a2
;	lea		160(a3),a3
;	dbf		d5,.NextLine
	
;	move.l	d0,(a0)+
	add.l	d1,d0

	dbf		d6,.InitScr2

	add.w	#40,d3
	add.w	#160,d4
	dbf		d5,.NextLine

	rts

	
	even
NB_PART	DC.L	8

InitScroller
	move.l	#8,NB_PART
	move.l	#0,POINT
	lea		BUF_LET,a0
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	rts
	
TEST_LET	MOVEQ	#0,D0
	LEA		TEXT1,A0	
	ADDA.L	POINT,A0
	LEA		FONT8_8,A6
	CMPI.B	#$FF,(A0)
	BNE.s	SUITTST
	CLR.L	POINT
	LEA		TEXT1,A0
SUITTST		MOVE.B	(A0),D0	
	SUBI.B	#32,D0	
	LSL.W	#3,D0	
	ADDA.L	D0,A6
	LEA		BUF_LET,A2
	MOVE.B	(A6)+,(A2)
	MOVE.B	(A6)+,2(A2)
	MOVE.B	(A6)+,4(A2)
	MOVE.B	(A6)+,6(A2)
	MOVE.B	(A6)+,8(A2)
	MOVE.B	(A6)+,10(A2)
	MOVE.B	(A6)+,12(A2)
	MOVE.B	(A6)+,14(A2)
	ADDI.L	#1,POINT
	RTS
	
;VBL_SCROLL
;	CMPI.L	#8,NB_PART
;	BNE.s	.SUITV0
;	BSR.s	TEST_LET
;	CLR.L	NB_PART
;.SUITV0
;;	BSR.s	SCROLL
;;	RTS
;
;SCROLL
;;	MOVE.L	ScreenPtr2,A0
;
;	lea		SCROLL_SCREEN,a0
;
;;	LEA	(200-8)*160(A0),A0
;	LEA		-2(A0),A0
;	LEA		BUF_LET,A6
;;	LEA		160(A0),A0
;	REPT	8
;	ROXL	(A6)
;
;	ROXL	154(A0)
;	ROXL	146(A0)
;	ROXL	138(A0)
;	ROXL	130(A0)
;	ROXL	122(A0)
;	ROXL	114(A0)
;	ROXL	106(A0)
;	ROXL	98(A0)
;	ROXL	90(A0)
;	ROXL	82(A0)
;	ROXL	74(A0)
;	ROXL	66(A0)
;	ROXL	58(A0)	
;	ROXL	50(A0)
;	ROXL	42(A0)
;	ROXL	34(A0)
;	ROXL	26(A0)
;	ROXL	18(A0)
;	ROXL	10(A0)
;	ROXL	2(A0)
;	LEA		160(A0),A0
;	ADDQ.L	#2,A6
;	ENDR
;	ADDI.L	#1,NB_PART
;	
;		lea		ScreenPtrs,a0
;;		lea		(NB_SCREENS-1)*4(a0),a0
;		lea		4(a0),a0
;		move.l	(a0),a0
;;		add.w	#((SCREEN_HEIGHT/2)-4)*SCREEN_BYTE_WIDTH,a0
;		add.w	#(SCREEN_HEIGHT-8)*SCREEN_BYTE_WIDTH,a0
;		
;		tst.b	BitplaneFlag
;		bne.s	.Second	
;		lea		2(a0),a0
;		bra.s	.First
;.Second
;		lea		6(a0),a0
;.First
;		
;		lea		SCROLL_SCREEN,a6
;		
;		move.w	#8-1,d6
;.Copy
;N	set 0
;		REPT	20
;			move.w	N(a6),N(a0)
;N	set N+8
;		ENDR
;		LEA		160(a6),a6
;		LEA		160(a0),a0
;		dbf		d6,.Copy		
;	RTS


VBL_SCROLL2
	CMPI.L	#8,NB_PART
	BNE.s	.SUITV0
	BSR.s	TEST_LET
	CLR.L	NB_PART
.SUITV0

;	lea		SCROLL_SCREEN,a0
	move.l	#ScreenBufferX,d0
	clr.b	d0
	move.l	d0,a0

	LEA	(200-8)*160(A0),A0

;	LEA	(200-8)*160(A0),A0
;	LEA		-2(A0),A0
;	lea		2(A0),A0
	LEA		BUF_LET,A6
	REPT	8
	ROXL	(A6)

	ROXL	154(A0)
	ROXL	146(A0)
	ROXL	138(A0)
	ROXL	130(A0)
	ROXL	122(A0)
	ROXL	114(A0)
	ROXL	106(A0)
	ROXL	98(A0)
	ROXL	90(A0)
	ROXL	82(A0)
	ROXL	74(A0)
	ROXL	66(A0)
	ROXL	58(A0)	
	ROXL	50(A0)
	ROXL	42(A0)
	ROXL	34(A0)
	ROXL	26(A0)
	ROXL	18(A0)
	ROXL	10(A0)
	ROXL	2(A0)
	LEA		160(A0),A0
	ADDQ.L	#2,A6
	ENDR
	ADDI.L	#1,NB_PART
	RTS

	ENDC


; Vbl player - this is a kind of 'Paula' Emulator(!)

Vbl_play:	MOVEA.L	buff_ptr(PC),A4
	MOVE.L A1,D0	; current pos in buffer
	CMP.L #endbuff1,d0
	BNE.S .norm
	MOVE.L #sndbuff1,d0	; wooky case(at end of buf)
.norm	MOVE.L D0,buff_ptr
	SUB.L A4,D0
	BEQ skipit
	BHI.S higher
	ADDI.W #$800,D0	; abs
higher	LSR.W #1,D0
	MOVE.L #endbuff1,D1
	SUB.L A4,D1
	LSR.W #1,D1
	CLR.W fillx1	; assume no buf overlap
	CMP.W D1,D0	; check for overlap
	BCS.S higher1
	MOVE.W D1,fillx1	; ok so there was overlap!!
higher1	SUB.W fillx1(PC),D0	; subtract any overlap
	MOVE.W D0,fillx2	; and store main
; A4 points to place to fill
	LEA freqs(PC),A3	; int.w/frac.w freq tab

.voices_1_2	MOVE.L #sndbuff1,buffbase	
	LEA.L ch1s(PC),A5
	MOVE.W amove(pc),D0
	BSR.s add1	; move voice 1
	LEA.L ch2s(PC),A5
	MOVE.W aadd(pc),D0
	BSR.s add1	; add voice 2

	LEA $802(A4),A4
.voices_3_4	MOVE.L #sndbuff2,buffbase	
	LEA.L ch3s(PC),A5	
	MOVE.W amove(pc),D0
	BSR.s add1	; move voice 3	
	LEA.L ch4s(PC),A5	
	MOVE.W aadd(pc),D0
	BSR.s add1	; add voice 4		; add voice 4
	RTS

; Routine to add/move one voice to buffer. The real Paula emulation part!!

add1	PEA (A4)	; save buff pos
	LEA moda(PC),A2
	MOVE.W D0,(A2)
	MOVE.W D0,modb-moda(A2)	; self modifying
	MOVE.W D0,modc-moda(A2)	; add/move code(see below)
	MOVE.W D0,modd-moda(A2)	
	MOVE.W D0,mode-moda(A2)	
	MOVE.L (A5),A2	; current sample end address
	MOVEM.W 6(A5),D1/D2	; period/volume
	ADD.W D1,D1
	ADD.W D1,D1	; *4 for lookup
	MOVEM.W 0(A3,D1),D1/D4	; get int.w/frac.w
	MOVE.L voltab_ptr(PC),A6	; base of volume table
	LSL.W #8,D2
	ADD.W D2,A6	; ptr to volume table
	MOVEQ #0,d5
	MOVE.W 4(A5),d5	; sample length
	CMP.L #nulsamp+2,A2
	BNE.S .vcon
	MOVEQ.L	#0,D4	; channel is off.
	MOVEQ.L	#0,D1	; clear all if off.
	MOVE.L voltab_ptr(PC),A6	; zero vol(safety!!)
	CLR.W 16(A5)	; clear frac part
.vcon	NEG.L d5
	MOVE.L A6,D6	; vol ptr
	MOVEQ.L	#0,D2	; clr top byte for sample
; Setup Loop stuff
	MOVE.L 10(a5),A0	; loop addr
	MOVEQ #0,D3
	MOVE.W 14(a5),D3	; loop length
	NEG.L D3
	MOVEM.W D1/D4,loopfreq
	CMP.L #-2,D3
	BNE.S isloop
noloop	MOVE.L D2,loopfreq	; no loop-no frequency
	LEA nulsamp+2(PC),A0	 	; no loop-point to nul
isloop	MOVE.L D3,looplength
	MOVE.W 16(A5),D3	; clear fraction part
	MOVE.W fillx1(PC),D0
	BSR.S addit	; 
	MOVE.W fillx2(PC),D0
	TST.W fillx1
	BEQ.S nores
	MOVE.L buffbase(PC),A4	; buffer base
nores	BSR.S addit
	NEG.L d5	; +ve offset(as original!)
	MOVE.L A2,(A5)	; store voice address
	MOVE.W d5,4(A5)	; store offset for next time
	MOVE.W D3,16(A5)	; clear fraction part
skipit	MOVE.L (SP)+,A4
	RTS
	
; Add D0 sample bytes to buffer

addit	MOVE.W D0,donemain+2	; lets go!!
	LSR #2,D0	; /4 for speed
	SUBQ #1,D0	; -1 (dbf)
	BMI.S donemain	; none to do?
makelp	MOVE.B (A2,d5.L),D6	; fetch sample byte
	MOVE.L D6,A6
	MOVE.B (A6),D2	; lookup in vol tab
moda	ADD.W D2,(A4)+	; add/move to buffer(self modified)
	ADD.W D4,D3	; add frac part
	ADDX.W D1,d5	; add ints.(carried thru)
	BCS.S lpvoice1	; voice looped?
CONT1	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
modb	ADD.W D2,(A4)+
	ADD.W D4,D3	; 
	ADDX.W D1,d5
	BCS.S lpvoice2
CONT2	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
modc	ADD.W D2,(A4)+
	ADD.W D4,D3	;
	ADDX.W D1,d5
	BCS.s lpvoice3
CONT3	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
modd	ADD.W D2,(A4)+	;
	ADD.W D4,D3
	ADDX.W D1,d5
CONT4	DBCS  D0,makelp
	BCS.s lpvoice4
donemain	MOVE.W #0,D0
	AND #3,D0	; remaining bytes.
	SUBQ #1,D0
	BMI.S yeah
niblp	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
mode	ADD.W D2,(A4)+
	ADD.W D4,D3
	ADDX.W D1,d5
CONT5	DBCS D0,niblp
	BCS.s lpvoicelast
yeah	RTS

buffbase	DS.L 1
loopfreq:	DS.W 2
looplength:	DS.L 1
voltab_ptr	DS.L 1

lpvoice	MACRO
	MOVE.L A0,A2 
	EXT.L D5
	ADD.L looplength(PC),D5	; fetch loop constants
	MOVEM.W loopfreq(PC),D1/D4	; (channel independent)
	MOVEQ #0,D2
	MOVE D2,CCR	
 	BRA \1
	ENDM

lpvoice1:	lpvoice CONT1	;
lpvoice2:	lpvoice CONT2	; loop routs
lpvoice3:	lpvoice CONT3	; (since code is repeated)
lpvoice4:	lpvoice CONT4	;
lpvoicelast:	lpvoice CONT5	;

aadd	ADD.W D2,(A4)+
amove	MOVE.W D2,(A4)+

nulsamp	ds.l 2	; nul sample.
buff_ptr:	dc.l 0
sndbuff1:	ds.w $400	; buffer for voices 1+2
endbuff1:	dc.w -1
sndbuff2	ds.w $400	; buffer for voices 3+4
endbuff2	dc.w -1

fillx1:	DC.W 0
fillx2:	DC.W 0


temp:	dc.l	0
setsam_dat:	dc.w	%0000000011010100  	;mastervol
	dc.w	%0000010010000110  	;treble
	dc.w	%0000010001000110  	;bass
	dc.w	%0000000000000001  	;mixer

; Select The Playback Routine D0.W = 0 to 6

Select_PlayRout:MOVE.W SR,-(SP)
	MOVE #$2700,SR
	MOVE.L Output_Routs,$110.W
	JSR rout_tab
	MOVE.W (SP)+,SR
	RTS

rout_tab	BRA.W YM2149_Setup

Which_replay	DC.W 0	; 0 - 6 as below
Output_Routs	DC.L YM2149_Player

; YM2149 Setup rout - turns off ste dma(if machine is st) and clears YM.

YM2149_Setup:	
	BSR Initsoundchip	; init soundchip
	RTS

; Ste Stereo Setup rout - turns off YM 2149 and setsup dma.

; Setup rout for all other output routs - kills both dma and YM sound.

Internal_Off:	
	BSR Killsoundchip
 	RTS

; YM2149 Soundchip output.

YM2149_Player:
	move.w (a1)+,d7
	bmi.s	.loopit
.contsnd
	add.w	$800(a1),d7
	lsl		#3,d7
	move.l	a1,usp
	lea		$ffff8800.w,a1	; output
	move.l	sound_look+4(pc,d7.w),(a1)
	move.l	sound_look(pc,d7.w),d7	; using quartet table.
	movep.l	d7,(a1)
	move.l	usp,a1
	rte
.loopit	lea sndbuff1(pc),a1
	move.w (a1)+,d7
	bra.w .contsnd
sound_look:	incbin quarfast.tab


; ST specific initialisation routines - sets up shadow amiga registers.

STspecific:	LEA  nulsamp+2(PC),A2
	MOVEQ #0,D0
	LEA ch1s(pc),A0
	BSR.s initvoice
	LEA ch2s(pc),A0
	BSR.s initvoice	;init shadow regs
	LEA ch3s(pc),A0
	BSR.s initvoice
	LEA ch4s(pc),A0
	BSR.s initvoice
	LEA sndbuff1(PC),A0
	MOVE.L A0,buff_ptr
	LEA sndbuff2(PC),A1
	MOVEQ.L	#0,D1
	MOVEQ #$7F,D0
.setbuf1	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+	; clear 2 ring buffers
	MOVE.L	D1,(A1)+
	MOVE.L	D1,(A1)+
	MOVE.L	D1,(A1)+
	MOVE.L	D1,(A1)+
	DBF D0,.setbuf1
	RTS
initvoice:	MOVE.L A2,(A0)	; point voice to nul sample
	MOVE.W #2,4(A0)	
	MOVE.W D0,6(A0)	; period=0
	MOVE.W D0,8(A0)	; volume=0
	MOVE.L A2,10(A0)	; and loop point to nul sample
	MOVE.W #2,14(A0)
	MOVE.W D0,16(A0)	; clear fraction part.
	RTS

; Initialise Soundchip

Initsoundchip:	LEA $FFFF8800.W,A0
	MOVE.B #7,(A0)	; turn on sound
	MOVE.B #$c0,D0
	AND.B (a0),D0
	OR.B #$38,D0
	MOVE.B d0,2(a0)
	MOVE.W #$0500,d0	; clear out ym2149
.initslp	MOVEP.W	d0,(a0)
	SUB.W #$0100,d0
	BPL.S .initslp
	RTS

; Reset sound chip

Killsoundchip	MOVE.W D0,-(SP)
	MOVE.B #7,$ffff8800.W	
	MOVE.B #7,D0
	OR.B $ffff8800.W,D0
	MOVE.B D0,$ffff8802.W
	MOVE.W (SP)+,D0
	RTS

; Make sure Volume lookup table is on a 256 byte boundary.

Init_Voltab	LEA vols+256(PC),A0
	MOVE.L A0,D0
	CLR.B D0
	LEA voltab_ptr(PC),A1
	TST.L (A1)
	BNE.S .alreadyinited
	MOVE.L D0,(A1)
	MOVE.L D0,A1
	MOVE.W #(16640/16)-1,D0
.lp	MOVE.L (A0)+,(A1)+
	MOVE.L (A0)+,(A1)+
	MOVE.L (A0)+,(A1)+
	MOVE.L (A0)+,(A1)+
	DBF D0,.lp
.alreadyinited	RTS


; Shadow Amiga Registers.
	
ch1s	DS.W 9
ch2s	DS.W 9
ch3s	DS.W 9
ch4s	DS.W 9

;********************************************
;* ----- Protracker V1.1A Playroutine ----- *
;* Lars "Zap" Hamre/Amiga Freelancers 1990  *
;* Bekkeliveien 10, N-2010 STRØMMEN, Norway *
;********************************************

n_cmd	EQU	2  ; W
n_cmdlo	EQU	3  ; low B of n_cmd
n_start	EQU	4  ; L
n_length	EQU	8  ; W
n_loopstart	EQU	10 ; L
n_replen	EQU	14 ; W
n_period	EQU	16 ; W
n_finetune	EQU	18 ; B
n_volume	EQU	19 ; B
n_dmabit	EQU	20 ; W
n_toneportdirec	EQU	22 ; B
n_toneportspeed	EQU	23 ; B
n_wantedperiod	EQU	24 ; W
n_vibratocmd	EQU	26 ; B
n_vibratopos	EQU	27 ; B
n_tremolocmd	EQU	28 ; B
n_tremolopos	EQU	29 ; B
n_wavecontrol	EQU	30 ; B
n_glissfunk	EQU	31 ; B
n_sampleoffset	EQU	32 ; B
n_pattpos	EQU	33 ; B
n_loopcount	EQU	34 ; B
n_funkoffset	EQU	35 ; B
n_wavestart	EQU	36 ; L
n_reallength	EQU	40 ; W

; Initialise module

mt_init	MOVE.L	A0,mt_SongDataPtr
	LEA	mt_mulu(PC),A1
	MOVE.L	A0,D0
	ADD.L	#12,D0
	MOVEQ	#$1F,D1
	MOVEQ	#$1E,D3
mt_lop4	MOVE.L	D0,(A1)+
	ADD.L	D3,D0
	DBRA	D1,mt_lop4
	LEA	$3B8(A0),A1
	MOVEQ	#127,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
mt_lop2 MOVE.B	(A1)+,D1
	CMP.B	D2,D1
	BLE.S	mt_lop
	MOVE.L	D1,D2
mt_lop	DBRA	D0,mt_lop2
	ADDQ.W	#1,d2
	ASL.L	#8,D2
	ASL.L	#2,D2
	LEA	4(A1,D2.L),A2
	LEA	mt_SampleStarts(PC),A1
	ADD.W	#$2A,A0
	MOVEQ	#$1E,D0
mt_lop3 CLR.L	(A2)
	MOVE.L	A2,(A1)+
	MOVEQ	#0,D1
	MOVE.B	D1,2(A0)
	MOVE.W	(A0),D1
	ASL.L	#1,D1
	ADD.L	D1,A2
	ADD.L	D3,A0
	DBRA	D0,mt_lop3
	LEA	mt_speed(PC),A1
	MOVE.B	#6,(A1)
	MOVEQ	#0,D0
	MOVE.B	D0,mt_SongPos-mt_speed(A1)
	MOVE.B	D0,mt_counter-mt_speed(A1)
	MOVE.W	D0,mt_PattPos-mt_speed(A1)
	BRA STspecific

; Vbl Sequencer

mt_music
	ADDQ.B	#1,mt_counter
	MOVE.B	mt_counter(PC),D0
	CMP.B	mt_speed(PC),D0
	BLO.S	mt_NoNewNote
	CLR.B	mt_counter
	TST.B	mt_PattDelTime2
	BEQ.S	mt_GetNewNote
	BSR.S	mt_NoNewAllChannels
	BRA	mt_dskip

mt_NoNewNote
	BSR.S	mt_NoNewAllChannels
	BRA	mt_NoNewPosYet

mt_NoNewAllChannels
	LEA	ch1s(pc),A5
	LEA	mt_chan1temp(PC),A6
	BSR	mt_CheckEfx
	LEA	ch2s(pc),A5
	LEA	mt_chan2temp(PC),A6
	BSR	mt_CheckEfx
	LEA	ch3s(pc),A5
	LEA	mt_chan3temp(PC),A6
	BSR	mt_CheckEfx
	LEA	ch4s(pc),A5
	LEA	mt_chan4temp(PC),A6
	BRA	mt_CheckEfx

mt_GetNewNote
	MOVE.L	mt_SongDataPtr(PC),A0
	LEA	12(A0),A3
	LEA	952(A0),A2	;pattpo
	LEA	1084(A0),A0	;patterndata
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE.B	mt_SongPos(PC),D0
	MOVE.B	(A2,D0.W),D1
	ASL.L	#8,D1
	ASL.L	#2,D1
	ADD.W	mt_PattPos(PC),D1

	LEA	ch1s(pc),A5
	LEA	mt_chan1temp(PC),A6
	BSR.S	mt_PlayVoice
	LEA	ch2s(pc),A5
	LEA	mt_chan2temp(PC),A6
	BSR.S	mt_PlayVoice
	LEA	ch3s(pc),A5
	LEA	mt_chan3temp(PC),A6
	BSR.S	mt_PlayVoice
	LEA	ch4s(pc),A5
	LEA	mt_chan4temp(PC),A6
	BSR.S	mt_PlayVoice
	BRA	mt_SetDMA

mt_PlayVoice
	TST.L	(A6)
	BNE.S	mt_plvskip
	MOVE.W	n_period(A6),6(A5)
mt_plvskip
	MOVE.L	(A0,D1.L),(A6)
	ADDQ.L	#4,D1
	MOVEQ	#0,D2
	MOVE.B	n_cmd(A6),D2
	LSR.B	#4,D2
	MOVE.B	(A6),D0
	AND.B	#$F0,D0
	OR.B	D0,D2
	BEQ	mt_SetRegs
	MOVEQ	#0,D3
	MOVE	D2,D4
	SUBQ.L	#1,D2
	ASL.L	#2,D2
	MULU	#30,D4
	MOVE.L	mt_SampleStarts(PC,D2.L),n_start(A6)
	MOVE.W	(A3,D4.L),n_length(A6)
	MOVE.W	(A3,D4.L),n_reallength(A6)
	MOVE.B	2(A3,D4.L),n_finetune(A6)
	MOVE.B	3(A3,D4.L),n_volume(A6)
	MOVE.W	4(A3,D4.L),D3 ; Get repeat
	TST.W	D3
	BEQ	mt_NoLoop
	MOVE.L	n_start(A6),D2	; Get start
	ASL.W	#1,D3
	ADD.L	D3,D2	; Add repeat
	MOVE.L	D2,n_loopstart(A6)
	MOVE.L	D2,n_wavestart(A6)
	MOVE.W	4(A3,D4.L),D0	; Get repeat
	ADD.W	6(A3,D4.L),D0	; Add replen
	MOVE.W	D0,n_length(A6)
	MOVE.W	6(A3,D4.L),n_replen(A6)	; Save replen
	MOVEQ	#0,D0
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)	; Set volume
	BRA	mt_SetRegs
mt_SampleStarts	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

mt_NoLoop
	MOVE.L	n_start(A6),D2
	ADD.L	D3,D2
	MOVE.L	D2,n_loopstart(A6)
	MOVE.L	D2,n_wavestart(A6)
	MOVE.W	6(A3,D4.L),n_replen(A6)	; Save replen
	MOVEQ	#0,D0
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)	; Set volume
mt_SetRegs
	MOVE.W	(A6),D0
	AND.W	#$0FFF,D0
	BEQ	mt_CheckMoreEfx	; If no note
	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0E50,D0
	BEQ.S	mt_DoSetFineTune
	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	CMP.B	#3,D0	; TonePortamento
	BEQ.S	mt_ChkTonePorta
	CMP.B	#5,D0
	BEQ.S	mt_ChkTonePorta
	CMP.B	#9,D0	; Sample Offset
	BNE.S	mt_SetPeriod
	BSR	mt_CheckMoreEfx
	BRA.S	mt_SetPeriod

mt_DoSetFineTune
	BSR	mt_SetFineTune
	BRA.S	mt_SetPeriod

mt_ChkTonePorta
	BSR	mt_SetTonePorta
	BRA	mt_CheckMoreEfx

mt_SetPeriod
	MOVEM.L	D1-D2/A2,-(SP)
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1
	LEA	mt_PeriodTable(PC),A2
	MOVEQ	#36,D2
mt_ftuloop
	CMP.W	(A2)+,D1
	DBHS	D2,mt_ftuloop
	MOVEQ	#0,D1
	MOVE.B	n_finetune(A6),D1
	MULU	#36*2,D1
	MOVE.W	-2(A2,D1.L),n_period(A6)
	MOVEM.L	(SP)+,D1-D2/A2

	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0ED0,D0 	; Notedelay
	BEQ	mt_CheckMoreEfx

	BTST	#2,n_wavecontrol(A6)
	BNE.S	mt_vibnoc
	CLR.B	n_vibratopos(A6)
mt_vibnoc
	BTST	#6,n_wavecontrol(A6)
	BNE.S	mt_trenoc
	CLR.B	n_tremolopos(A6)
mt_trenoc
	MOVE.L	n_start(A6),(A5)	; Set start
	MOVEQ.l	 #0,D0
	MOVE.W	n_length(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,(A5)	; point to end of sample
	MOVE.W	D0,4(A5)	; Set length
	MOVE.W	n_period(A6),6(A5)	; Set period
	BRA	mt_CheckMoreEfx
 
mt_SetDMA
	MOVE.L	D0,-(SP)
	MOVEQ.L	#0,D0
	LEA	ch4s(PC),A5
	LEA	mt_chan4temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVEQ.L	#0,D0
	LEA	ch3s(PC),A5
	LEA	mt_chan3temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVEQ.L	#0,D0
	LEA	ch2s(PC),A5
	LEA	mt_chan2temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVEQ.L	#0,D0
	LEA	ch1s(PC),A5
	LEA	mt_chan1temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVE.L	(SP)+,D0

mt_dskip
	ADD.W	#16,mt_PattPos
	MOVE.B	mt_PattDelTime,D0
	BEQ.S	mt_dskc
	MOVE.B	D0,mt_PattDelTime2
	CLR.B	mt_PattDelTime
mt_dskc	TST.B	mt_PattDelTime2
	BEQ.S	mt_dska
	SUBQ.B	#1,mt_PattDelTime2
	BEQ.S	mt_dska
	SUB.W	#16,mt_PattPos
mt_dska	TST.B	mt_PBreakFlag
	BEQ.S	mt_nnpysk
	SF	mt_PBreakFlag
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	CLR.B	mt_PBreakPos
	LSL.W	#4,D0
	MOVE.W	D0,mt_PattPos
mt_nnpysk
	CMP.W	#1024,mt_PattPos
	BLO.S	mt_NoNewPosYet
mt_NextPosition	
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	LSL.W	#4,D0
	MOVE.W	D0,mt_PattPos
	CLR.B	mt_PBreakPos
	CLR.B	mt_PosJumpFlag
	ADDQ.B	#1,mt_SongPos
	AND.B	#$7F,mt_SongPos
	MOVE.B	mt_SongPos(PC),D1
	MOVE.L	mt_SongDataPtr(PC),A0
	CMP.B	950(A0),D1
	BLO.S	mt_NoNewPosYet
	CLR.B	mt_SongPos
mt_NoNewPosYet	
	TST.B	mt_PosJumpFlag
	BNE.S	mt_NextPosition
	RTS

mt_CheckEfx
	BSR	mt_UpdateFunk
	MOVE.W	n_cmd(A6),D0
	AND.W	#$0FFF,D0
	BEQ.S	mt_PerNop
	MOVE.B	n_cmd(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_Arpeggio
	CMP.B	#1,D0
	BEQ	mt_PortaUp
	CMP.B	#2,D0
	BEQ	mt_PortaDown
	CMP.B	#3,D0
	BEQ	mt_TonePortamento
	CMP.B	#4,D0
	BEQ	mt_Vibrato
	CMP.B	#5,D0
	BEQ	mt_TonePlusVolSlide
	CMP.B	#6,D0
	BEQ	mt_VibratoPlusVolSlide
	CMP.B	#$E,D0
	BEQ	mt_E_Commands
SetBack	MOVE.W	n_period(A6),6(A5)
	CMP.B	#7,D0
	BEQ	mt_Tremolo
	CMP.B	#$A,D0
	BEQ	mt_VolumeSlide
mt_Return2
	RTS

mt_PerNop
	MOVE.W	n_period(A6),6(A5)
	RTS

mt_Arpeggio
	MOVEQ	#0,D0
	MOVE.B	mt_counter(PC),D0
	DIVS	#3,D0
	SWAP	D0
	CMP.W	#0,D0
	BEQ.S	mt_Arpeggio2
	CMP.W	#2,D0
	BEQ.S	mt_Arpeggio1
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	LSR.B	#4,D0
	BRA.S	mt_Arpeggio3

mt_Arpeggio1
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#15,D0
	BRA.S	mt_Arpeggio3

mt_Arpeggio2
	MOVE.W	n_period(A6),D2
	BRA.S	mt_Arpeggio4

mt_Arpeggio3
	ASL.W	#1,D0
	MOVEQ	#0,D1
	MOVE.B	n_finetune(A6),D1
	MULU	#36*2,D1
	LEA	mt_PeriodTable(PC),A0
	ADD.L	D1,A0
	MOVEQ	#0,D1
	MOVE.W	n_period(A6),D1
	MOVE.L D3,-(SP)
	MOVEQ	#36,D3
mt_arploop
	MOVE.W	(A0,D0.W),D2
	CMP.W	(A0)+,D1
	BHS.S	.arp4
	DBF	D3,mt_arploop
	MOVE.L (SP)+,D3
	RTS
.arp4	MOVE.W	D2,6(A5)
	MOVE.L (SP)+,D3
	RTS

mt_Arpeggio4
	MOVE.W	D2,6(A5)
	RTS

mt_FinePortaUp
	TST.B	mt_counter
	BNE.s	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaUp
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	SUB.W	D0,n_period(A6)
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#113,D0
	BPL.S	mt_PortaUskip
	AND.W	#$F000,n_period(A6)
	OR.W	#113,n_period(A6)
mt_PortaUskip
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS	
 
mt_FinePortaDown
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaDown
	CLR.W	D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	ADD.W	D0,n_period(A6)
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#856,D0
	BMI.S	mt_PortaDskip
	AND.W	#$F000,n_period(A6)
	OR.W	#856,n_period(A6)
mt_PortaDskip
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS

mt_SetTonePorta
	MOVE.L	A0,-(SP)
	MOVE.W	(A6),D2
	AND.W	#$0FFF,D2
	MOVEQ	#0,D0
	MOVE.B	n_finetune(A6),D0
	MULU	#37*2,D0
	LEA	mt_PeriodTable(PC),A0
	ADD.L	D0,A0
	MOVEQ	#0,D0
mt_StpLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_StpFound
	ADDQ.W	#2,D0
	CMP.W	#37*2,D0
	BLO.S	mt_StpLoop
	MOVEQ	#35*2,D0
mt_StpFound
	MOVE.B	n_finetune(A6),D2
	AND.B	#8,D2
	BEQ.S	mt_StpGoss
	TST.W	D0
	BEQ.S	mt_StpGoss
	SUBQ.W	#2,D0
mt_StpGoss
	MOVE.W	(A0,D0.W),D2
	MOVE.L	(SP)+,A0
	MOVE.W	D2,n_wantedperiod(A6)
	MOVE.W	n_period(A6),D0
	CLR.B	n_toneportdirec(A6)
	CMP.W	D0,D2
	BEQ.S	mt_ClearTonePorta
	BGE	mt_Return2
	MOVE.B	#1,n_toneportdirec(A6)
	RTS

mt_ClearTonePorta
	CLR.W	n_wantedperiod(A6)
	RTS

mt_TonePortamento
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_TonePortNoChange
	MOVE.B	D0,n_toneportspeed(A6)
	CLR.B	n_cmdlo(A6)
mt_TonePortNoChange
	TST.W	n_wantedperiod(A6)
	BEQ	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_toneportspeed(A6),D0
	TST.B	n_toneportdirec(A6)
	BNE.S	mt_TonePortaUp
mt_TonePortaDown
	ADD.W	D0,n_period(A6)
	MOVE.W	n_wantedperiod(A6),D0
	CMP.W	n_period(A6),D0
	BGT.S	mt_TonePortaSetPer
	MOVE.W	n_wantedperiod(A6),n_period(A6)
	CLR.W	n_wantedperiod(A6)
	BRA.S	mt_TonePortaSetPer

mt_TonePortaUp
	SUB.W	D0,n_period(A6)
	MOVE.W	n_wantedperiod(A6),D0
	CMP.W	n_period(A6),D0
	BLT.S	mt_TonePortaSetPer
	MOVE.W	n_wantedperiod(A6),n_period(A6)
	CLR.W	n_wantedperiod(A6)

mt_TonePortaSetPer
	MOVE.W	n_period(A6),D2
	MOVE.B	n_glissfunk(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_GlissSkip
	MOVEQ	#0,D0
	MOVE.B	n_finetune(A6),D0
	MULU	#36*2,D0
	LEA	mt_PeriodTable(PC),A0
	ADD.L	D0,A0
	MOVEQ	#0,D0
mt_GlissLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_GlissFound
	ADDQ.W	#2,D0
	CMP.W	#36*2,D0
	BLO.S	mt_GlissLoop
	MOVEQ	#35*2,D0
mt_GlissFound
	MOVE.W	(A0,D0.W),D2
mt_GlissSkip
	MOVE.W	D2,6(A5) 	; Set period
	RTS

mt_Vibrato
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_Vibrato2
	MOVE.B	n_vibratocmd(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_vibskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_vibskip
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_vibskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_vibskip2
	MOVE.B	D2,n_vibratocmd(A6)
mt_Vibrato2
	MOVE.B	n_vibratopos(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVEQ	#0,D2
	MOVE.B	n_wavecontrol(A6),D2
	AND.B	#$03,D2
	BEQ.S	mt_vib_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_vib_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_vib_set
mt_vib_rampdown
	TST.B	n_vibratopos(A6)
	BPL.S	mt_vib_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_sine
	MOVE.B	0(A4,D0.W),D2
mt_vib_set
	MOVE.B	n_vibratocmd(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#7,D2
	MOVE.W	n_period(A6),D0
	TST.B	n_vibratopos(A6)
	BMI.S	mt_VibratoNeg
	ADD.W	D2,D0
	BRA.S	mt_Vibrato3
mt_VibratoNeg
	SUB.W	D2,D0
mt_Vibrato3
	MOVE.W	D0,6(A5)
	MOVE.B	n_vibratocmd(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,n_vibratopos(A6)
	RTS

mt_TonePlusVolSlide
	BSR	mt_TonePortNoChange
	BRA	mt_VolumeSlide

mt_VibratoPlusVolSlide
	BSR.S	mt_Vibrato2
	BRA	mt_VolumeSlide

mt_Tremolo
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_Tremolo2
	MOVE.B	n_tremolocmd(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_treskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_treskip
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_treskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_treskip2
	MOVE.B	D2,n_tremolocmd(A6)
mt_Tremolo2
	MOVE.B	n_tremolopos(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVEQ	#0,D2
	MOVE.B	n_wavecontrol(A6),D2
	LSR.B	#4,D2
	AND.B	#$03,D2
	BEQ.S	mt_tre_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_tre_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_tre_set
mt_tre_rampdown
	TST.B	n_vibratopos(A6)
	BPL.S	mt_tre_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_sine
	MOVE.B	0(A4,D0.W),D2
mt_tre_set
	MOVE.B	n_tremolocmd(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#6,D2
	MOVEQ	#0,D0
	MOVE.B	n_volume(A6),D0
	TST.B	n_tremolopos(A6)
	BMI.S	mt_TremoloNeg
	ADD.W	D2,D0
	BRA.S	mt_Tremolo3
mt_TremoloNeg
	SUB.W	D2,D0
mt_Tremolo3
	BPL.S	mt_TremoloSkip
	CLR.W	D0
mt_TremoloSkip
	CMP.W	#$40,D0
	BLS.S	mt_TremoloOk
	MOVE.W	#$40,D0
mt_TremoloOk
	MOVE.W	D0,8(A5)
	MOVE.B	n_tremolocmd(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,n_tremolopos(A6)
	RTS

mt_SampleOffset
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_sononew
	MOVE.B	D0,n_sampleoffset(A6)
mt_sononew
	MOVE.B	n_sampleoffset(A6),D0
	LSL.W	#7,D0
	CMP.W	n_length(A6),D0
	BGE.S	mt_sofskip
	SUB.W	D0,n_length(A6)
	LSL.W	#1,D0
	ADD.L	D0,n_start(A6)
	RTS
mt_sofskip
	MOVE.W	#$0001,n_length(A6)
	RTS

mt_VolumeSlide
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	LSR.B	#4,D0
	TST.B	D0
	BEQ.S	mt_VolSlideDown
mt_VolSlideUp
	ADD.B	D0,n_volume(A6)
	CMP.B	#$40,n_volume(A6)
	BMI.S	mt_vsuskip
	MOVE.B	#$40,n_volume(A6)
mt_vsuskip
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)
	RTS

mt_VolSlideDown
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
mt_VolSlideDown2
	SUB.B	D0,n_volume(A6)
	BPL.S	mt_vsdskip
	CLR.B	n_volume(A6)
mt_vsdskip
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)
	RTS

mt_PositionJump
	MOVE.B	n_cmdlo(A6),D0
	SUBQ.B	#1,D0
	MOVE.B	D0,mt_SongPos
mt_pj2	CLR.B	mt_PBreakPos
	ST 	mt_PosJumpFlag
	RTS

mt_VolumeChange
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	CMP.B	#$40,D0
	BLS.S	mt_VolumeOk
	MOVEQ	#$40,D0
mt_VolumeOk
	MOVE.B	D0,n_volume(A6)
	MOVE.W	D0,8(A5)
	RTS

mt_PatternBreak
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	MOVE.L	D0,D2
	LSR.B	#4,D0
	MULU	#10,D0
	AND.B	#$0F,D2
	ADD.B	D2,D0
	CMP.B	#63,D0
	BHI.S	mt_pj2
	MOVE.B	D0,mt_PBreakPos
	ST	mt_PosJumpFlag
	RTS

mt_SetSpeed
	MOVE.B	3(A6),D0
	BEQ	mt_Return2
	CLR.B	mt_counter
	MOVE.B	D0,mt_speed
	RTS

mt_CheckMoreEfx
	BSR	mt_UpdateFunk
	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	CMP.B	#$9,D0
	BEQ	mt_SampleOffset
	CMP.B	#$B,D0
	BEQ	mt_PositionJump
	CMP.B	#$D,D0
	BEQ.S	mt_PatternBreak
	CMP.B	#$E,D0
	BEQ.S	mt_E_Commands
	CMP.B	#$F,D0
	BEQ.S	mt_SetSpeed
	CMP.B	#$C,D0
	BEQ	mt_VolumeChange
	RTS	

mt_E_Commands
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F0,D0
	LSR.B	#4,D0
	BEQ.S	mt_FilterOnOff
	CMP.B	#1,D0
	BEQ	mt_FinePortaUp
	CMP.B	#2,D0
	BEQ	mt_FinePortaDown
	CMP.B	#3,D0
	BEQ.S	mt_SetGlissControl
	CMP.B	#4,D0
	BEQ.s	mt_SetVibratoControl
	CMP.B	#5,D0
	BEQ.s	mt_SetFineTune
	CMP.B	#6,D0
	BEQ.s	mt_JumpLoop
	CMP.B	#7,D0
	BEQ	mt_SetTremoloControl
	CMP.B	#9,D0
	BEQ	mt_RetrigNote
	CMP.B	#$A,D0
	BEQ	mt_VolumeFineUp
	CMP.B	#$B,D0
	BEQ	mt_VolumeFineDown
	CMP.B	#$C,D0
	BEQ	mt_NoteCut
	CMP.B	#$D,D0
	BEQ	mt_NoteDelay
	CMP.B	#$E,D0
	BEQ	mt_PatternDelay
	CMP.B	#$F,D0
	BEQ	mt_FunkIt
	RTS

mt_FilterOnOff
	RTS	

mt_SetGlissControl
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,n_glissfunk(A6)
	OR.B	D0,n_glissfunk(A6)
	RTS

mt_SetVibratoControl
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,n_wavecontrol(A6)
	OR.B	D0,n_wavecontrol(A6)
	RTS

mt_SetFineTune
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	MOVE.B	D0,n_finetune(A6)
	RTS

mt_JumpLoop
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_SetLoop
	TST.B	n_loopcount(A6)
	BEQ.S	mt_jumpcnt
	SUBQ.B	#1,n_loopcount(A6)
	BEQ	mt_Return2
mt_jmploop	MOVE.B	n_pattpos(A6),mt_PBreakPos
	ST	mt_PBreakFlag
	RTS

mt_jumpcnt
	MOVE.B	D0,n_loopcount(A6)
	BRA.S	mt_jmploop

mt_SetLoop
	MOVE.W	mt_PattPos(PC),D0
	LSR.W	#4,D0
	MOVE.B	D0,n_pattpos(A6)
	RTS

mt_SetTremoloControl
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,n_wavecontrol(A6)
	OR.B	D0,n_wavecontrol(A6)
	RTS

mt_RetrigNote
	MOVE.L	D1,-(SP)
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_rtnend
	MOVEQ	#0,D1
	MOVE.B	mt_counter(PC),D1
	BNE.S	mt_rtnskp
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1
	BNE.S	mt_rtnend
	MOVEQ	#0,D1
	MOVE.B	mt_counter(PC),D1
mt_rtnskp
	DIVU	D0,D1
	SWAP	D1
	TST.W	D1
	BNE.S	mt_rtnend
mt_DoRetrig
	MOVE.L D0,-(SP)
	MOVEQ #0,D0
	MOVE.L	n_start(A6),(A5)	; Set sampledata pointer
	MOVE.W	n_length(A6),D0
	ADD D0,D0
	ADD.L D0,(A5)
	MOVE.W D0,4(A5)	; Set length
	MOVEQ #0,D0
	MOVE.L	n_loopstart(A6),10(A5)	; loop sample ptr
	MOVE.L	n_replen(A6),D0
	ADD D0,D0
	ADD.L D0,10(A5)
	MOVE.W D0,14(A5)
	MOVE.L (SP)+,D0
mt_rtnend
	MOVE.L	(SP)+,D1
	RTS

mt_VolumeFineUp
	TST.B	mt_counter
	BNE	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F,D0
	BRA	mt_VolSlideUp

mt_VolumeFineDown
	TST.B	mt_counter
	BNE	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	BRA	mt_VolSlideDown2

mt_NoteCut
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	CMP.B	mt_counter(PC),D0
	BNE	mt_Return2
	CLR.B	n_volume(A6)
	MOVE.W	#0,8(A5)
	RTS

mt_NoteDelay
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	CMP.B	mt_counter,D0
	BNE	mt_Return2
	MOVE.W	(A6),D0
	BEQ	mt_Return2
	MOVE.L	D1,-(SP)
	BRA	mt_DoRetrig

mt_PatternDelay
	TST.B	mt_counter
	BNE	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	TST.B	mt_PattDelTime2
	BNE	mt_Return2
	ADDQ.B	#1,D0
	MOVE.B	D0,mt_PattDelTime
	RTS

mt_FunkIt
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,n_glissfunk(A6)
	OR.B	D0,n_glissfunk(A6)
	TST.B	D0
	BEQ	mt_Return2
mt_UpdateFunk
	MOVEM.L	A0/D1,-(SP)
	MOVEQ	#0,D0
	MOVE.B	n_glissfunk(A6),D0
	LSR.B	#4,D0
	BEQ.S	mt_funkend
	LEA	mt_FunkTable(PC),A0
	MOVE.B	(A0,D0.W),D0
	ADD.B	D0,n_funkoffset(A6)
	BTST	#7,n_funkoffset(A6)
	BEQ.S	mt_funkend
	CLR.B	n_funkoffset(A6)

	CLR.B	n_funkoffset(A6)
	MOVE.L	n_loopstart(A6),D0
	MOVEQ	#0,D1
	MOVE.W	n_replen(A6),D1
	ADD.L	D1,D0
	ADD.L	D1,D0
	MOVE.L	n_wavestart(A6),A0
	ADDQ.L	#1,A0
	CMP.L	D0,A0
	BLO.S	mt_funkok
	MOVE.L	n_loopstart(A6),A0
mt_funkok
	MOVE.L	A0,n_wavestart(A6)
	MOVEQ	#-1,D0
	SUB.B	(A0),D0
	MOVE.B	D0,(A0)
mt_funkend
	MOVEM.L	(SP)+,A0/D1
	RTS

;======================================

FlipBuffers:
	IFNE ENABLE_2BP_VERSION
		tst.b	BitplaneFlag
		bne.s	.FlipTime
		move.b	#1,BitplaneFlag
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
B0	=	$001
;B0	=	$000

;C2	=	$655
;C1	=	$334
;C0	=	$112

;C2	=	$777
;C1	=	$444
;C0	=	$222

C2	=	$766
;C1	=	$445
;C0	=	$223
C1	=	$334
C0	=	$112

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
	
UpdatePalette
	;d0 = c0
	;d1 = c1
	;d2 = c2
	;d3 = b0
	lea		Palette0,a0
	move.w	d3,(a0)+		dc.w	B0		0000
	move.w	d0,(a0)+		dc.w	C0		0001
	move.w	d1,(a0)+		dc.w	C1		0010
	move.w	d2,(a0)+		dc.w	C2		0011
	move.w	d3,(a0)+		dc.w	B0		0100
	move.w	d0,(a0)+		dc.w	C0		0101
	move.w	d1,(a0)+		dc.w	C1		0110
	move.w	d2,(a0)+		dc.w	C2		0111
	move.w	d3,(a0)+		dc.w	B0		1000
	move.w	d0,(a0)+		dc.w	C0		1001
	move.w	d1,(a0)+		dc.w	C1		1010
	move.w	d2,(a0)+		dc.w	C2		1011
	move.w	d3,(a0)+		dc.w	B0		1100
	move.w	d0,(a0)+		dc.w	C0		1101
	move.w	d1,(a0)+		dc.w	C1		1110
	move.w	d2,(a0)+		dc.w	C2		1111
	
	lea		Palette0b,a0
	move.w	d3,(a0)+		dc.w	B0		0000
	move.w	d3,(a0)+		dc.w	B0		0001
	move.w	d3,(a0)+		dc.w	B0		0010
	move.w	d3,(a0)+		dc.w	B0		0011
	move.w	d0,(a0)+		dc.w	C0		0100
	move.w	d0,(a0)+		dc.w	C0		0101
	move.w	d0,(a0)+		dc.w	C0		0110
	move.w	d0,(a0)+		dc.w	C0		0111
	move.w	d1,(a0)+		dc.w	C1		1000
	move.w	d1,(a0)+		dc.w	C1		1001
	move.w	d1,(a0)+		dc.w	C1		1010
	move.w	d1,(a0)+		dc.w	C1		1011
	move.w	d2,(a0)+		dc.w	C2		1100
	move.w	d2,(a0)+		dc.w	C2		1101
	move.w	d2,(a0)+		dc.w	C2		1110
	move.w	d2,(a0)+		dc.w	C2		1111	
	rts
	

UpdateColor:
;	lea		Current,a0
;	lea		Target,a2
	move.l	a0,a3
	move.w	#3-1,d2
.NextCompo
	move.w	(a0),d0
	move.w	(a2)+,d1

	cmp.w	d0,d1
	beq.s	.equal
	blt.s	.lower
	addq.w	#1,d0
	bra.s	.equal
.lower
	subq.w	#1,d0
.equal
	move.w	d0,(a0)+

	dbf		d2,.NextCompo

	moveq	#0,d0
	move.w	(a3)+,d1
	lsr.w	#FADE_BITS,d1
	or.w	d1,d0
	lsl.w	#4,d0
	
	move.w	(a3)+,d1
	lsr.w	#FADE_BITS,d1
	or.w	d1,d0
	lsl.w	#4,d0

	move.w	(a3)+,d1
	lsr.w	#FADE_BITS,d1
	or.w	d1,d0
	rts

CurrentB0	dc.w	0*FADE_SPEED,0*FADE_SPEED,1*FADE_SPEED
TargetB0	dc.w	0*FADE_SPEED,0*FADE_SPEED,1*FADE_SPEED
	
CurrentC0	dc.w	0*FADE_SPEED,0*FADE_SPEED,1*FADE_SPEED
TargetC0	dc.w	1*FADE_SPEED,1*FADE_SPEED,2*FADE_SPEED

CurrentC1	dc.w	0*FADE_SPEED,0*FADE_SPEED,1*FADE_SPEED
TargetC1	dc.w	3*FADE_SPEED,3*FADE_SPEED,4*FADE_SPEED

CurrentC2	dc.w	0*FADE_SPEED,0*FADE_SPEED,1*FADE_SPEED
TargetC2	dc.w	7*FADE_SPEED,6*FADE_SPEED,6*FADE_SPEED
	
SetupPalette:
	lea		CurrentB0,a0
	lea		TargetB0,a2
	bsr		UpdateColor
	move.w	d0,d3

	lea		CurrentC2,a0
	lea		TargetC2,a2
	bsr		UpdateColor
	move.w	d0,d6

	lea		CurrentC1,a0
	lea		TargetC1,a2
	bsr		UpdateColor
	move.w	d0,d5

	lea		CurrentC0,a0
	lea		TargetC0,a2
	bsr		UpdateColor

	move.w	d5,d1
	move.w	d6,d2
	bsr		UpdatePalette



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
		lea		$FFFF8240.w,a2
		movem.l	(a0),d0-d6/a3
		movem.l	d0-d6/a3,(a2)
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
		lea		$FFFF8240.w,a2
		movem.l	(a0),d0-d6/a3
		movem.l	d0-d6/a3,(a2)
	ENDC
	
	rts

PlotStars:
	moveq	#NB_STEPS_PER_FRAME-1,d0
.NextStep
	move.w	d0,SaveD0

	;/////// Setup registers for main loop

	IFEQ	ROTATE_STARS
		move.l	FrameCounter,d6
		IFNE	PREMUL_Z4
			add.w	d6,d6
			add.w	d6,d6
				add.w	d6,d6
;				add.w	d6,d6
		ENDC
	ELSE
		bsr		GenerateRotMatrix
	ENDC

	lea		Stars,a0
	lea		ScreenPtrs,a6
	lea		(NB_SCREENS-1)*4(a6),a6
	move.l	(a6),a6
		add.w	#(SCREEN_HEIGHT/2)*SCREEN_BYTE_WIDTH,a6
		
;		lea		-160*4(a6),a6

;	lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
;	lea		MulsTable+MULS_TABLE_START_OFFSET,a4
	lea		DepthData,a2
	
	move.l	d6,a3

	moveq	#4-1,d4
	bra.s	.NextQuadrant

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
		move.w	a3,d6
		add.w	d6,-2(a0)		;take framecounter's adjustment into account
	ENDC
	bra		.NextDot
	
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





	move.w	#(NB_STARS/4)-1,d5
.AffDot
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	IFNE	ROTATE_STARS
		move.w	(a0),d2			;This version changes the stored Z value
		subi.w	#SPEED,(a0)+	;using the SPEED param
	ELSE
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
	
	ble.s	.GenerateNewStar

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
	muls.w	d2,d0		;x*256*N/z
	asr.l	#8,d0		;x*N/z		TODO: replace with add/swap
;		add.l	d0,d0
;		add.l	d0,d0
;		swap	d0
		
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

	muls.w	d2,d1		;y*256*N/z
	asr.l	#8,d1		;y*N/z
;		add.l	d1,d1
;		add.l	d1,d1
;		swap	d1

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
		or.w	d0,(a6,d2.w)	;plot pixel
	ENDC

TestBit	MACRO
		and.w	d0,d1
		beq.s	.\1
		bset	#\2,d6
.\1
	ENDM

BlitToPlane	MACRO
		and.w	d6,\3
		btst	#\2,d2	;TODO: 16 different routines indexed by d2 could help here
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

	IFNE	ENABLE_2BP_VERSION
		move.l	(a5,d0.w),d0	;pixel mask|screen offsetx
		move.w	d0,d3			;offsetx
		swap	d0				;screen offset|pixel mask
		add.w	(a4,d1.w),d3	;add offsety to main screen offset

;		move.l	a6,FAKE_USP	;Save screen pointer
		move.l	a6,d4	;Save screen pointer
		add.w	d3,a6	;d3 is free after this, also avoids recomputing the address N times in "move.l (a6,d3.w)" calls

		;d2 = ... color index
		;We're going to reconstruct the color index from current bitplanes (i.e. use the framebuffer as a z-buffer with color index == z)		
		moveq	#0,d6	;rebuilt color index

		tst.b	BitplaneFlag
		bne.s	.SecondFrame

		;Deal with plane 1 & 2
		move.l	(a6),d1		;puts plane2 data in low word, same as "move.l (a6,d3.w),d1"
		move.l	d1,d3		;save data for second part, ands are destructive
		TestBit	P1x,1
		swap	d1
		TestBit	P0x,0

		;"Z Buffer"... skip pixel if current one is in front of us
		cmp.w	d2,d6
		bge.s	.CullDot

		;Now we plot each dot like a sprite
		move.w	d0,d6
		not.w	d6
		
		;Deal with plane 1 & 2
		;Work on saved data in d7, same as "move.l (a6,d3.w),d1"
		BlitToPlane	P1,1,d3
		swap		d3
		BlitToPlane	P0,0,d3
		swap		d3
		move.l		d3,(a6)	;Write back to screen, same as "move.l d1,(a1,d3.w)"
		
		bra.s	.CullDot
		
.SecondFrame

		;Tweak color index
		add.w	d2,d2
		add.w	d2,d2

		;Deal with plane 3 & 4
		move.l	4(a6),d1	;puts plane2 data in low word, same as "move.l 4(a1,d3.w),d1"
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

		;Deal with plane 3 & 4
		;Work on saved data in d3, same as "move.l 4(a1,d3.w),d1"
		BlitToPlane	P3,3,d3
		swap		d3
		BlitToPlane	P2,2,d3
		swap		d3
		move.l		d3,4(a6)	;Write back to screen, same as "move.l d1,4(a1,d3.w)"

.CullDot
;		move.l	FAKE_USP,a6		;Restore screen pointer		
		move.l	d4,a6		;Restore screen pointer		
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
	rts
	
InterRTE:
	rte
	
;	even
;FAKE_USP	dc.l	0

	include	UNPACK.S

	section	data

mt_FunkTable dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

mt_VibratoTable	
	dc.b   0, 24, 49, 74, 97,120,141,161
	dc.b 180,197,212,224,235,244,250,253
	dc.b 255,253,250,244,235,224,212,197
	dc.b 180,161,141,120, 97, 74, 49, 24

mt_PeriodTable
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

mt_chan1temp	dc.l	0,0,0,0,0,$00010000,0,  0,0,0,0
mt_chan2temp	dc.l	0,0,0,0,0,$00020000,0,  0,0,0,0
mt_chan3temp	dc.l	0,0,0,0,0,$00040000,0,  0,0,0,0
mt_chan4temp	dc.l	0,0,0,0,0,$00080000,0,  0,0,0,0

mt_SongDataPtr	dc.l 0

mt_speed	dc.b 6
mt_counter	dc.b 0
mt_SongPos	dc.b 0
mt_PBreakPos	dc.b 0
mt_PosJumpFlag	dc.b 0
mt_PBreakFlag	dc.b 0
mt_LowMask	dc.b 0
mt_PattDelTime	dc.b 0
mt_PattDelTime2	dc.b 0
	dc.b 0

mt_PattPos	dc.w 0

mt_mulu	dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

freqs	ds.l 2
	incbin freq.bin	; frequency table. int.w/frac.w
	even

vols	ds.l 64
	incbin pt_volta.dat	; 65 ,256 byte lookups.
	even



		even
;mt_data	incbin	MOD.PAK
;		ds.b	22286-15482


;mt_data	incbin	KLISJE.MOD
;mt_data	incbin	NEBULUS.MOD
;mt_data	incbin	GDRAGON.MOD
;mt_data	incbin	SHADE
;mt_data	incbin	REACH.MOD
;mt_data	incbin	CHANT.MOD
;mt_data	incbin	VECTOR.MOD
;mt_data	incbin	ANIMOTIO.MOD
;mt_data	incbin	JESPER05.MOD
;mt_data	incbin	SPANKIT.MOD
;mt_data	incbin	PHENOMEN.MOD
;mt_data	incbin	IMPULSE.MOD
;mt_data	incbin	CHINESE.PAK
;mt_data	incbin	CHINESE.MOD
;mt_data	incbin	ANIMOTIO.PAK
;mt_data	incbin	KITCHEN.PAK

mt_data	incbin	LEMON.PAK		;Used in compo
mt_data_clear_start
			ds.b	256
ScreenBufferX
PicturePak	incbin	HOLOLOG.PAK		8638
;Picture1PP	incbin	HOLOLOG1.PAK	2986
;			ds.b	97010-60602-256-8638		;36408! Chinese
;			ds.b	130330-89110-256-8638		;Animotion
;			ds.b	126720-95556-256-8638		;Kitchen
			ds.b	110232-81278-256-8638		;Lemon
			ds.b	3400						-2986					;Lemon
mt_data_clear_end

;mt_data	incbin	JESPER03.MOD
;mt_data	incbin	JESPER01.MOD
;mt_data	incbin	MOD.LOA				*
;mt_data	incbin	SPICE.MOD
;mt_data	incbin	NOISE.MOD
;mt_data	incbin	LEMON.MOD
;mt_data	incbin	MOD.HOT
;mt_data	incbin	RNZOOL.MOD
;mt_data	incbin	CHUCK.MOD
;mt_data	incbin	FLETCH.MOD
;mt_data	incbin	MOD.SAV
;mt_data	incbin	MOD.ILL
;mt_data	incbin	MOD.STO
;mt_data	incbin	SHADE
;mt_data	incbin	UTOM.MOD
;mt_data	incbin	GDRAGON.MOD
;mt_data	incbin	BATTLE.MOD
;mt_data	incbin	KEFRENS.MOD
;mt_data	incbin	SAKSET.MOD
;mt_data	incbin	LEPARDIN.MOD
;mt_data	incbin	DEEP.MOD
;mt_data	incbin	ANIMOTIO.MOD
;mt_data	incbin	PBLANK.MOD
;mt_data	incbin	KITCHEN.MOD
;mt_data	incbin	SPANKIT.MOD
;mt_data	incbin	DJAMM.MOD
;mt_data	incbin	CHINESE.MOD

;Picture1P	incbin	HOLOLOG1.PI1
;Picture1P2	incbin	HOLOLOGO.1P
Picture1P2	incbin	HOLOLOGO.1PK
;			ds.b	4600-2178
	IFNE	SCROLLER
TEXT1
; dc.b "     Starfield compo?! I'm in!! Unlike the memory on a 520 ST, the amount of stars is infinite... "
 ;dc.b " I only had a couple of days to spend on this, sorry.  Zappy/HC writing a fucking scroller in 2019."
 
; dc.b "     Starfield compo?! I'm in!! Unlike the memory on a 520 ST, the amount of stars is infinite... "
; dc.b " Zappy/HC writing a fucking scroller in 2019.123456789123456789"

 dc.b "     Zappy/HC is back with a small effect for SommarHack 2019. Nobody expected it but the stars aligned!"
 dc.b " This runs on a plain 520 STf, but I'm out of memory."
 
 dc.b "                                                   ",$FF

	even
	include		FONT8_8.S
	ENDC
Here	ds.b	4600-(*-Picture1P2)


	section bss
	even

;Keep the stack outside of StartBSS/EndBSS
;			DS.L 399
;			DS.L 199
			DS.L 99
my_stack	DS.L 4

StartBSS:

;Picture1P2	ds.w	115*20

ANC_TB		DS.L	1

	IFNE	SCROLLER
	even

;SCROLL_SCREEN		ds.b	160*8	
	
POINT			DS.L	1
BUF_LET			DS.B	(1*8)*2
	ENDC

				ds.b	256
ScreenBuffer	ds.b	SCREEN_SIZE*NB_SCREENS
ScreenPtrs		ds.l	NB_SCREENS

FrameCounter	ds.l	1
Random			ds.l	1	;Current random value for creating new stars

PixelTable2		ds.l	SINGLE_PIXEL_TABLE_SIZE

MulsTable		ds.w	MULS_TABLE_SIZE

Stars			ds.w	NB_STARS*3	;x y z
DepthData		ds.l	Z_RANGE*2	;*2 because we want to spawn the initial batch very far away
	
SaveD0			ds.w	1
SaveD4			ds.w	1
FlagLogo		ds.w	1
FrameIndex		ds.w	1
;NB_VBL			ds.w	1
	IFNE ENABLE_2BP_VERSION
BitplaneFlag	ds.b	1	
	ENDC

EndBSS:
