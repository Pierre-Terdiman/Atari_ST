;Dotball
;Same as dotball.s but no Z computation here, and many more tricks.
;Uses slices to share similar Y values for each slice, etc. Only works with a ball like this.

;	opt	o+,a+
	opt	o+
;	opt	p+

SIN_TABLE_SIZE			= 1024
;FRAME_SIZE				= 50
FRAME_SIZE				= 48
;FRAME_SIZE				= 38
NB_INTERPOLATED			= 80
;NB_PTS					= 453
;NB_PTS					= 257
;NB_PTS					= 768
;NB_PTS					= 900
;NB_PTS					= 1024
;NB_PTS					= 256
;NB_PTS					= 288
;NB_PTS					= 16
;NB_PTS					= 320
;NB_PTS					= 352
;NB_PTS					= 384
;NB_PTS					= 448

;NB_PTS					= 416
;NB_SLICES				= 32
;NB_IN_ARC				= 13

;NB_PTS					= 432
;NB_SLICES				= 27
;NB_IN_ARC				= 16

;NB_PTS					= 448
;NB_SLICES				= 28
;NB_IN_ARC				= 16

NB_PTS					= 459
NB_SLICES				= 27
NB_IN_ARC				= 17

;NB_PTS					= 468
;NB_SLICES				= 26
;NB_IN_ARC				= 18

;NB_PTS					= 480
;NB_SLICES				= 24
;NB_IN_ARC				= 20

FASTROT_CLEAR_SAVED_POS	= 0
FASTROT_CODGEN2			= 1
FASTROT_TEST			= 1
FASTROT_TEST2			= 1
FASTROT_TEST3			= 1
FASTROT_TEST4			= 0	;Generate code for interpolation, not needed with FASTROT_TEST5
FASTROT_TEST5			= 1	;Precomputed interpolated vectors (uses more memory but "free" interpolation)
FASTROT_TEST6			= 0	;This one only works with FASTROT_TEST5
FASTROT_TEST7			= 0	;Generate clear code
FASTROT_HACK			= 0

FASTROT_NB_COORDS		= 2

ZIK						= 0
SCROLLER				= 0

SYM_TABLE				= 0

REMOVED			set	1

	IFNE	FASTROT_TEST5
FASTROT_TABLE_SIZE		= FRAME_SIZE
EXTRA_SIZE				= 8
EXTRA_BITS				= 3
	ENDC

	section text

	bra		Start
UTIL_CLEAR_SCREEN_1P		= 0
UTIL_CLEAR_SCREEN_4P		= 0
UTIL_ROTATE_POINTS			= 0
UTIL_600_SCREEN_ADDRESS		= 0
UTIL_CREATE_PIXEL_TABLE		= 0
UTIL_CREATE_PIXEL_TABLE2	= 0
UTIL_CREATE_MULS_TABLE		= 1

	INCLUDE		UTILS.S
	include	LIB/BSS.S
	include	LIB/ENV.S
	include	LIB/STPS.S
	include	LIB/SYS.S
ROTA_SPECIAL	=	1
	include	LIB/ROTA.S

Start:

;	move.w	#160+13,d0
;	move.w	#160-13,d1
;	
;	move.w	d0,d2
;	and.w	#7,d2
;	
;	move.w	d1,d3
;	and.w	#7,d3
;	
;	not.b	d2
;	addq.w	#1,d2
;	and.w	#7,d2
;;	not.b	d3
;;	and.w	#7,d3

	bsr		Lib_ClearBSS

	SwitchToSuper

	bsr		Lib_SaveEnv


	IFNE	FASTROT_TEST3
		move.l	#ScreenBuffer,d0
		clr.w	d0
		move.l	d0,ScreenPtr1
		addi.l	#256*256,d0
		move.l	d0,ScreenPtr2
	ELSE
		move.l	#ScreenBuffer,d0
		clr.b	d0
		move.l	d0,ScreenPtr1
		addi.l	#32000,d0
		move.l	d0,ScreenPtr2
	ENDC
	
	
	IFNE	SYM_TABLE
	bsr		CreateSymTable
	ENDC
		
	bsr		InitPts3

	lea		MulsTable,a0
	bsr	CreateMulsTable

;	lea		PixelTable2,a0
;	bsr		CreateSinglePixelTable
	
		move.l	#PixelTable2b,d0
	IFNE	FASTROT_TEST2
		clr.w	d0
	ENDC
		move.l	d0,PixelTable2bAddy
;		lea		PixelTable2b,a0
		move.l	PixelTable2bAddy,a0
		bsr		CreateNewSinglePixelTable

	IFNE	FASTROT_TEST6
		move.l	#2,PixelTablePlanOffset
		move.l	#PixelTablePlan2,d0
		clr.w	d0
		move.l	d0,PixelTablePlan2Addy
		move.l	d0,a0
		bsr		CreateNewSinglePixelTable
		
		move.l	#4,PixelTablePlanOffset
		move.l	#PixelTablePlan3,d0
		clr.w	d0
		move.l	d0,PixelTablePlan3Addy
		move.l	d0,a0
		bsr		CreateNewSinglePixelTable

		move.l	#6,PixelTablePlanOffset
		move.l	#PixelTablePlan4,d0
		clr.w	d0
		move.l	d0,PixelTablePlan4Addy
		move.l	d0,a0
		bsr		CreateNewSinglePixelTable	
	ENDC

	IFNE	FASTROT_CLEAR_SAVED_POS
		move.l	#PtsClrOffsets,d0
		move.l	d0,ClrOffsetsPtr1
		addi.l	#NB_PTS*2,d0
		move.l	d0,ClrOffsetsPtr2
	ENDC

	IFNE	FASTROT_CODGEN2
;			move.l	#42,FrameCounter
;			bsr		GenerateRotMatrix
;			lea		Frame,a0
;			lea		RotatedFrame,a1
;			lea		Matrix,a2
;			move.w	#3-1,d7
;			bsr		RotatePoints
;			lea		Frame,a0
;			lea		RotatedFrame,a1
;			lea		Matrix,a2
;			move.w	#3-1,d7
;			bsr		RotatePointsSpecial
;			bsr		FastRot_Interpolate
	
		lea		FastrotCodgen2,a0
		bsr		GenerateFastrotCode2
	ENDC

;		move.l	#$7fff,d0
;		move.l	#$7fff,d1
;		mulu	d0,d1
;		move.l	#42,FrameCounter
;		bsr		GenerateRotMatrix
;		lea		Frame,a0
;		lea		RotatedFrame,a1
;		lea		Matrix,a2
;		move.w	#3-1,d7
;		bsr		RotatePoints
;		lea		Frame,a0
;		lea		RotatedFrame,a1
;		lea		Matrix,a2
;		move.w	#3-1,d7
;		bsr		RotatePointsSpecial
;		bsr		FastRot_Interpolate

	move.b	#0,$ffff8260.w	;Switch to low res

	move.w	#$2700,SR

	IFEQ	FASTROT_TEST6
;	bra		.SkipPlan3
		move.l	ScreenPtr1,a0
		move.l	ScreenPtr2,a1
		move.w	#$aaaa,d0
		move.l	#200-1,d7
.SetPlan3
N	set		0
;		REPT	10
		REPT	20
		move.w	d0,4+N(a0)
		move.w	d0,4+N(a1)
N	set		N+8
		ENDR
		not.w	d0
		lea		160(a0),a0
		lea		160(a1),a1
		dbf		d7,.SetPlan3
.SkipPlan3
	ENDC

	move.l	ScreenPtr1,a0
	bsr		GenerateBallGfx
	move.l	ScreenPtr2,a0
	bsr		GenerateBallGfx

	move.l	ScreenPtr1,a0
	bsr		GenerateCorners
	move.l	ScreenPtr2,a0
	bsr		GenerateCorners

	IFNE	FASTROT_TEST7
	bsr		GenerateClearCode
	ENDC
	
	IFNE	SCROLLER
		bsr		FlipBuffers
		bsr		InitScroller
		move.w	#314,d7
		move.w	d7,d6
.Pre
		bsr		VBL_SCROLL
		dbf		d7,.Pre
		bsr		FlipBuffers
		bsr		InitScroller
.Pre2
		bsr		VBL_SCROLL
		dbf		d6,.Pre2
	ENDC
	
	move.b	ScreenPtr1+1,$FFFF8201.w
	move.b	ScreenPtr1+2,$FFFF8203.w

	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w
	
;	clr.b	$FFFFFC02.w


;Redirect exception vectors to quit
	move.l	#Quit,$008.w
	move.l	#Quit,$00C.w
	move.l	#Quit,$010.w
	move.l	#Quit,$014.w
	move.l	#Quit,$018.w
	move.l	#Quit,$01c.w
	move.l	#Quit,$020.w
	move.l	#Quit,$024.w


	move.l	#$00010001,D0
	move.l	D0,$FFFF8240.W
	move.l	D0,$FFFF8244.W
	move.l	D0,$FFFF8248.W
	move.l	D0,$FFFF824C.W
	move.l	D0,$FFFF8250.W
	move.l	D0,$FFFF8254.W
	move.l	D0,$FFFF8258.W
	move.l	D0,$FFFF825C.W

		lea		$FFFF8240.W,a0
		moveq	#16-1,d0
	.AllWhite:
		move.w	#$ffff,(a0)+
		dbf		d0,.AllWhite
		move.w	#$0001,$FFFF8240.W

;	move.l	#InterRTE,$70.W
;	move.l	#VBL,$70.w

	move.l	#Vbl,$70.w

	move.w	#$2300,SR

	IFNE	ZIK
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
	bra.s	JumpOverCode	
SkipString:
	move.b	(a0)+,d0
	bne.s	SkipString
	rts
JumpOverCode:	
	bsr.s	SkipString	;Song name
	bsr.s	SkipString	;Author name
	bsr.s	SkipString	;Song comment

	move.l	a0,SongDataPtr
	ENDC

	IFNE	FASTROT_TEST6
		bra		MainLoopForClear4P
	ELSE
		bsr		MainLoop
	ENDC
	
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

	bsr		Lib_StopSound
	bsr		Lib_RestoreEnv

	BackToUser
;Quit
	clr.w	-(sp)
	trap	#1

;======================================

CORNER_PIXEL_SIZE	set 64

BallBackground	ds.w	16*CORNER_PIXEL_SIZE*(1+(CORNER_PIXEL_SIZE/16))

GenerateCorners:
	move.l	a0,a2

	;===

	lea		BallBackground,a0
	moveq	#CORNER_PIXEL_SIZE,d5
	lsr		#1,d5			;radius
	move.l	d5,a1
	mulu	d5,d5
	add.l	#32,d5			;make gfx a bit fatter
	
	moveq	#CORNER_PIXEL_SIZE-1,d7
	moveq	#0,d1			;y
.GenerateBallGfxY
	moveq	#CORNER_PIXEL_SIZE-1,d6
	move.w	#$8000,d4		;pixel-mask
	moveq	#0,d0			;x
.GenerateBallGfxX
	;Must generate pixel (x,y)
	
	move	d0,d2
	sub		a1,d2
	muls	d2,d2

	move	d1,d3
	sub		a1,d3
	muls	d3,d3
	
	add		d3,d2
	
	cmp		d2,d5
	blt.s	.SkipPixel
	
	or.w	d4,(a0)
.SkipPixel

	lsr.w	#1,d4
	bne.s	.SomeMore
	move.w	#$8000,d4
	adda.l	#2,a0
.SomeMore
	addq	#1,d0
	dbf		d6,.GenerateBallGfxX
	addq	#2,a0
	addq	#1,d1
	dbf		d7,.GenerateBallGfxY
	
	;===
DrawCorners:

;	lea		BallBackground,a0
;	moveq	#CORNER_PIXEL_SIZE-1,d7
;.GenerateBallGfxY
;	move.l	a2,a1
;	moveq	#(CORNER_PIXEL_SIZE/16)-1,d6
;.GenerateBallGfxX
;	move.w	(a0)+,(a1)
;	lea		8(a1),a1
;	dbf		d6,.GenerateBallGfxX
;	lea		2(a0),a0
;	lea		160(a2),a2
;	dbf		d7,.GenerateBallGfxY


	lea		BallBackground,a0
	moveq	#2-1,d5
.GenerateBallGfxY2
	
	moveq	#(CORNER_PIXEL_SIZE/2)-1,d7
.GenerateBallGfxY
	move.l	a2,a1
NB_TO_GO	set		(CORNER_PIXEL_SIZE/16)
	moveq	#(NB_TO_GO/2)-1,d6
.GenerateBallGfxX
	move.w	(a0)+,d0
	and.w	d0,(a1)+
	and.w	d0,(a1)+
	and.w	d0,(a1)+
	and.w	d0,(a1)+
;	move.w	(a0)+,(a1)
;	lea		8(a1),a1
	dbf		d6,.GenerateBallGfxX
	;
;	lea		(NB_TO_GO/2)*2(a0),a0
	lea		160-NB_TO_GO*8(a1),a1
	moveq	#(NB_TO_GO/2)-1,d6
.GenerateBallGfxX2
;	move.w	(a0)+,(a1)
;	lea		8(a1),a1
	move.w	(a0)+,d0
	and.w	d0,(a1)+
	and.w	d0,(a1)+
	and.w	d0,(a1)+
	and.w	d0,(a1)+
	dbf		d6,.GenerateBallGfxX2

	;
	lea		2(a0),a0
	lea		160(a2),a2
	dbf		d7,.GenerateBallGfxY

	lea		160*(200-CORNER_PIXEL_SIZE)(a2),a2
	
	dbf		d5,.GenerateBallGfxY2


	
	rts
	
;======================================


;	IFNE	REMOVED
BALL_PIXEL_SIZE	set 192

GenerateBallGfx:
;	lea		BallBackground,a0

	lea		-160*4(a0),a0
	lea		(100-(BALL_PIXEL_SIZE/2))*160(a0),a0
	lea		(80-8*(BALL_PIXEL_SIZE/32))(a0),a0
	lea		2(a0),a0

	lea		8(a0),a0
	lea		160*5(a0),a0

	move.l	#BALL_PIXEL_SIZE,d5
	lsr		#1,d5			;radius
	move.l	d5,a1
	mulu	d5,d5
;	add.l	#32,d5			;make gfx a bit fatter
	sub.l	#1024,d5
	sub.l	#1024,d5
	sub.l	#1024,d5
	
	move.l	#BALL_PIXEL_SIZE-1,d7
	moveq	#0,d1			;y
.GenerateBallGfxY
	move.l	#BALL_PIXEL_SIZE-1,d6
	move.w	#$8000,d4		;pixel-mask
	moveq	#0,d0			;x
.GenerateBallGfxX
	;Must generate pixel (x,y)
	
	move	d0,d2
	sub		a1,d2
	muls	d2,d2

	move	d1,d3
	sub		a1,d3
	muls	d3,d3
	
	add		d3,d2
	
	cmp		d2,d5
	blt.s	.SkipPixel
	
	or.w	d4,(a0)
.SkipPixel

	lsr.w	#1,d4
	bne.s	.SomeMore
	move.w	#$8000,d4
;	adda.l	#2,a0
	lea		8(a0),a0
.SomeMore
	addq	#1,d0
	dbf		d6,.GenerateBallGfxX
;	addq	#2,a0
	lea		160-8*(BALL_PIXEL_SIZE/16)(a0),a0
	addq	#1,d1
	dbf		d7,.GenerateBallGfxY
	rts
;	ENDC
	
;======================================

Vbl:
	addq.w	#1,VBL_Flag
	IFNE	FASTROT_TEST6
	
	IFNE	ZIK
	movem.l	d0-a6,-(sp)
	bsr		PlayMusic
	movem.l	(sp)+,d0-a6
	ENDC
	
	move.l	d0,-(sp)
	move.w	VisiblePlan,d0
	cmp.w	#0,d0
	beq		.Plan1
	cmp.w	#1,d0
	beq		.Plan2
	cmp.w	#2,d0
	beq		.Plan3
	
	;$FFFF8240.W	;0	0000
	;$FFFF8242.W	;1	0001	plan 1
	;$FFFF8244.W	;2	0010	plan 2
	;$FFFF8246.W	;3	0011
	;$FFFF8248.W	;4	0100	plan 3
	;$FFFF824a.W	;5	0101
	;$FFFF824c.W	;6	0110
	;$FFFF824e.W	;7	0111
	;$FFFF8250.W	;8	1000	plan 4
	;$FFFF8252.W	;9	1001
	;$FFFF8254.W	;10	1010
	;$FFFF8256.W	;11	1011
	;$FFFF8258.W	;12	1100
	;$FFFF825a.W	;13	1101
	;$FFFF825c.W	;14	1110
	;$FFFF825e.W	;15	1111	
	
.Plan4	
	move.w	#$000,$ffff8242.w
	move.w	#$000,$ffff8244.w
	move.w	#$000,$ffff8246.w
	move.w	#$000,$ffff8248.w
	move.w	#$000,$ffff824a.w
	move.w	#$000,$ffff824c.w
	move.w	#$000,$ffff824e.w
	move.w	#$777,$ffff8250.w
	move.w	#$777,$ffff8252.w
	move.w	#$777,$ffff8254.w
	move.w	#$777,$ffff8256.w
	move.w	#$777,$ffff8258.w
	move.w	#$777,$ffff825a.w
	move.w	#$777,$ffff825c.w
	move.w	#$777,$ffff825e.w
	move.l	(sp)+,d0
	rte	
.Plan1
	move.w	#$777,$ffff8242.w
	move.w	#$000,$ffff8244.w
	move.w	#$777,$ffff8246.w
	move.w	#$000,$ffff8248.w
	move.w	#$777,$ffff824a.w
	move.w	#$000,$ffff824c.w
	move.w	#$777,$ffff824c.w
	move.w	#$000,$ffff8250.w
	move.w	#$777,$ffff8252.w
	move.w	#$000,$ffff8254.w
	move.w	#$777,$ffff8256.w
	move.w	#$000,$ffff8258.w
	move.w	#$777,$ffff825a.w
	move.w	#$000,$ffff825c.w
	move.w	#$777,$ffff825e.w
	move.l	(sp)+,d0
	rte	
.Plan2
	move.w	#$000,$ffff8242.w
	move.w	#$777,$ffff8244.w
	move.w	#$777,$ffff8246.w
	move.w	#$000,$ffff8248.w
	move.w	#$000,$ffff824a.w
	move.w	#$777,$ffff824c.w
	move.w	#$777,$ffff824e.w
	move.w	#$000,$ffff8250.w
	move.w	#$000,$ffff8252.w
	move.w	#$777,$ffff8254.w
	move.w	#$777,$ffff8256.w
	move.w	#$000,$ffff8258.w
	move.w	#$000,$ffff825a.w
	move.w	#$777,$ffff825c.w
	move.w	#$777,$ffff825e.w
	move.l	(sp)+,d0
	rte	
.Plan3
	move.w	#$000,$ffff8242.w
	move.w	#$000,$ffff8244.w
	move.w	#$000,$ffff8246.w
	move.w	#$777,$ffff8248.w
	move.w	#$777,$ffff824a.w
	move.w	#$777,$ffff824c.w
	move.w	#$777,$ffff824e.w
	move.w	#$000,$ffff8250.w
	move.w	#$000,$ffff8252.w
	move.w	#$000,$ffff8254.w
	move.w	#$000,$ffff8256.w
	move.w	#$777,$ffff8258.w
	move.w	#$777,$ffff825a.w
	move.w	#$777,$ffff825c.w
	move.w	#$777,$ffff825e.w
	move.l	(sp)+,d0
	rte
	ENDC
	rte
	
VSync
	clr.w	VBL_Flag
.Wait	
	cmpi.w	#1,VBL_Flag
	bne.s	.Wait
	rts

;======================================

FlipBuffers:
	IFNE	FASTROT_CLEAR_SAVED_POS
	move.l	ClrOffsetsPtr1,d0
	move.l	ClrOffsetsPtr2,ClrOffsetsPtr1
	move.l	d0,ClrOffsetsPtr2
	ENDC

	move.l	ScreenPtr1,d0
	move.l	ScreenPtr2,ScreenPtr1
	move.l	d0,ScreenPtr2

;	move.b	ScreenPtr1+1,$FFFF8201.w
;	move.b	ScreenPtr1+2,$FFFF8203.w

	move.l	ScreenPtr1,d0
	lsr.l	#8,d0
;	move.l	#$ffff8201,a0
	move.w	#$8201,a0
	movep.w	d0,(a0)

	RTS
	
;======================================

;_AngleInc	dc.w	67
;_AngleInc2	dc.w	333

;Initial version
_AngleInc	dc.w	57
_AngleInc2	dc.w	177

;_AngleInc	dc.w	256
;_AngleInc2	dc.w	256

;_AngleInc	dc.w	77
;_AngleInc2	dc.w	133

;Generate rotation matrix
GenerateRotMatrix:
;	move.b	$fffffc02.w,d0
;	cmp.b	#59,d0
;	bne.s	.NoF1
;	addq.w	#1,_AngleInc
;.NoF1
;	cmp.b	#60,d0
;	bne.s	.NoF2
;	subq.w	#1,_AngleInc
;.NoF2
;	cmp.b	#61,d0
;	bne.s	.NoF3
;	addq.w	#1,_AngleInc2
;.NoF3
;	cmp.b	#62,d0
;	bne.s	.NoF4
;	subq.w	#1,_AngleInc2
;.NoF4

	lea		SinTable,a0
	move.l	FrameCounter,d6		;'angle'
	move.l	d6,d4
;		add.w	d6,d6				;speed things up

;	move.w	#$700,$ffff8240.w
	lsl.l	#8,d6
	divu	_AngleInc,d6

;	move.w	#100,d4

	lsl.l	#8,d4
	divu	_AngleInc2,d4
;	move.w	#$222,$ffff8240.w

;	muls	_AngleInc,d6
;	asr.l	#8,d6

;	muls	_AngleInc2,d4
;	asr.l	#8,d4

;		moveq	#0,d4
;		moveq	#0,d6

	GetSinCos	a0,d6,d7
	GetSinCos	a0,d4,d5

	lea		Matrix,a0
	ComputeRotMatrixXY_TwoAngles	a0,d6,d7,d4,d5

;	lea		Matrix,a0
;	ComputeRotMatrixXY_OneAngle	a0,d6,d7

;	lea		Matrix,a0
;	ComputeRotMatrixX	a0,d6,d7

;	lea		Matrix,a0
;	ComputeRotMatrixY	a0,d6,d7

;	lea		Matrix,a0
;	ComputeRotMatrixZ	a0,d6,d7

;	addq.w	#1,_AngleInc
;	addq.w	#1,_AngleInc2

	rts
;======================================

	IFNE	FASTROT_TEST6
;a0 = screen address
ClearScreen_4Planes2:
	;TODO: generate this code to speedup compile time
	move.w	#$2700,sr
	move.l	a7,usp
	move.l	a0,a7
;	move.l	#$80808080,d0
	moveq	#0,d0
	move.l	d0,d1
	move.l	d0,d2
	move.l	d0,d3
	move.l	d0,d4
	move.l	d0,d5
	move.l	d0,d6
	move.l	d0,d7
	move.l	d1,a0
	move.l	d1,a1
	move.l	d1,a2
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6
N	set		32
	REPT	200
	movem.l	d0-a6,N(a7)
	movem.l	d0-a0,N+15*4(a7)
N	set		N+160
	ENDR
	move.l	usp,a7
	move.w	#$2300,sr
	rts
	ENDC

;======================================

	IFNE	ZIK
PlayMusic:
	move.l	SongDataPtr,a0
	move.l	CurrentFrame,d0
	add.l	d0,a0
	lea		$ffff8800.w,a1
	move.l	NbFrames,d0

	moveq	#0,d1
	REPT	16
		move.b	d1,(a1)
		move.b	(a0),2(a1)
;		move.b	(a0),d2
;		add.b	d2,d2
;		move.b	d2,2(a1)

		addq	#1,d1
		add.l	d0,a0
	ENDR
	
	move.l	CurrentFrame,d0
	move.l	NbFrames,d1
	addq.l	#1,d0
	cmp.l	d1,d0
	ble.s	.GoOn
	moveq	#0,d0
.GoOn
	move.l	d0,CurrentFrame
	rts
	ENDC
	
;======================================

	IFEQ	FASTROT_TEST7
ClearPartialScreenPlane1_4:
;Y_MARGIN	set		20
;Y_MARGIN	set		10
	IFNE	FASTROT_TEST5
Y_MARGIN	set		4
	ELSE
Y_MARGIN	set		0
	ENDC

		;Clears part of the screen only
;		move.l	#$80808080,d0
		lea		160*Y_MARGIN(a0),a0
;		move.w	#200-Y_MARGIN*2-1,d7
;.Clear
N		set		6

;TODO: generate this... rough & suboptimal here

M		set		25
		REPT	M
;			move.l	d0,N+8*4(a0)
			move.l	d0,N+8*6(a0)
			move.l	d0,N+8*8(a0)
			move.l	d0,N+8*10(a0)
			move.l	d0,N+8*12(a0)
;			move.l	d0,N+8*14(a0)
N		set		N+160
		ENDR



	IFNE	FASTROT_TEST5
NB		set		200-Y_MARGIN*2-7-M*2
	ELSE
NB		set		200-Y_MARGIN*2-M*2
	ENDC
		REPT	NB
			move.l	d0,N+8*4(a0)
;			move.l	d0,N+8*5(a0)
			move.l	d0,N+8*6(a0)
;			move.l	d0,N+8*7(a0)
			move.l	d0,N+8*8(a0)
;			move.l	d0,N+8*9(a0)
			move.l	d0,N+8*10(a0)
;			move.l	d0,N+8*11(a0)
			move.l	d0,N+8*12(a0)
;			move.l	d0,N+8*13(a0)
			move.l	d0,N+8*14(a0)
N		set		N+160
		ENDR
		
		
		REPT	M
;			move.l	d0,N+8*4(a0)
			move.l	d0,N+8*6(a0)
			move.l	d0,N+8*8(a0)
			move.l	d0,N+8*10(a0)
			move.l	d0,N+8*12(a0)
;			move.l	d0,N+8*14(a0)
N		set		N+160
		ENDR
		
		
;		lea		160(a0),a0
;		dbf		d7,.Clear
	rts
	ENDC
	
;======================================
;ZoomDelay	dc.w	2	;keep same zoom level N frames
MainLoop:
	bsr		VSync

	lea		Frame,a0
	cmp.w	#FRAME_SIZE,(a0)
	beq.s	.FullyZoomed

	;Removed, not smooth	
;	subq.w	#1,ZoomDelay
;	bne.s	.FullyZoomed
;	move.w	#4,ZoomDelay
	
	moveq	#1,d0
	add.w	d0,(a0)
	add.w	d0,8(a0)
	add.w	d0,16(a0)
;	move.l	FrameCounter,d0
;	asr.w	#1,d0
;	cmp.w	#FRAME_SIZE,d0
;	ble.s	.BelowLimit
;	move.w	#FRAME_SIZE,d0
;.BelowLimit	
;	move.w	d0,(a0)
;	move.w	d0,8(a0)
;	move.w	d0,16(a0)
.FullyZoomed

	IFNE	ZIK
	bsr		PlayMusic
	ENDC
	
	move.w	#1,DEBUG_Flag
	cmpi.b	#$f,$fffffc02.w
	beq.s	.DebugMode
;	bne.s	.DebugMode
	move.w	#0,DEBUG_Flag
	lea		_Palette2,a0
	bra.s	.SetupPalette
.DebugMode
	lea		_Palette1,a0
.SetupPalette
	movem.l	(a0),d0-d7
	movem.l	d0-d7,$ffff8240.w

;	move.l	ScreenPtr2,a0
;	bsr		ClearScreen_4Planes2
;	bra		SkipThatShit

	IFEQ	FASTROT_CLEAR_SAVED_POS
		moveq	#0,d0
		move.l	ScreenPtr2,a0
;		bsr		ClearScreen_1Plane
	
		IFNE	FASTROT_TEST7
			jsr		ClearCodgen
		ELSE
			bsr		ClearPartialScreenPlane1_4
		ENDC
	ELSE
		move.w	#$2700,sr
		move.l	a7,usp
		move.l	ScreenPtr2,a0
		IFEQ	FASTROT_TEST3
			lea		160*100(a0),a0
		ENDC
		move.l	ClrOffsetsPtr2,a1
		moveq	#0,d7
N		set		NB_PTS/13	
		REPT	N
			movem.w	(a1)+,d0-d6/a2-a7
;			move.w	d7,(a0,d0.w)
;			move.w	d7,(a0,d1.w)
;			move.w	d7,(a0,d2.w)
;			move.w	d7,(a0,d3.w)
;			move.w	d7,(a0,d4.w)
;			move.w	d7,(a0,d5.w)
;			move.w	d7,(a0,d6.w)
;			move.w	d7,(a0,a2.w)
;			move.w	d7,(a0,a3.w)
;			move.w	d7,(a0,a4.w)
;			move.w	d7,(a0,a5.w)
;			move.w	d7,(a0,a6.w)
;			move.w	d7,(a0,a7.w)
			move.b	d7,(a0,d0.w)
			move.b	d7,(a0,d1.w)
			move.b	d7,(a0,d2.w)
			move.b	d7,(a0,d3.w)
			move.b	d7,(a0,d4.w)
			move.b	d7,(a0,d5.w)
			move.b	d7,(a0,d6.w)
			move.b	d7,(a0,a2.w)
			move.b	d7,(a0,a3.w)
			move.b	d7,(a0,a4.w)
			move.b	d7,(a0,a5.w)
			move.b	d7,(a0,a6.w)
			move.b	d7,(a0,a7.w)
		ENDR
		REPT	NB_PTS-(N*13)
			move.w	(a1)+,d0
;			move.w	d7,(a0,d0.w)
			move.b	d7,(a0,d0.w)
		ENDR
		move.l	usp,a7
		move.w	#$2300,sr
	ENDC

SkipThatShit:


	cmp.w	#1,DEBUG_Flag
	bne.s	.SkipCol0
	move.w	#$030,$FFFF8240.W
.SkipCol0
	bsr		GenerateRotMatrix
	cmp.w	#1,DEBUG_Flag
	bne.s	.SkipCol1
	move.w	#$003,$FFFF8240.W
.SkipCol1

;=========================================

	bsr		FastRot_Interpolate

	cmp.w	#1,DEBUG_Flag
	bne.s	.SkipCol2
	move.w	#$123,$ffff8240.w
.SkipCol2

	move.w	#$2700,sr
	bsr		FastRot2
	move.w	#$2300,sr


	IFNE	SYM_TABLE
	bsr		CopyAndFlipScreen
	ENDC
	
;		move.l	ScreenPtr2,a0
;		lea		32000-160(a0),a1
;		move.w	#200-1,d7
;.TST
;N		set		0
;		REPT	10
;		move.l	6+16*N(a0),d0
;		move.w	d0,2+8+16*N(a1)
;		swap	d0
;		move.w	d0,2+16*N(a1)
;		
;N		set		N+1
;		ENDR
;		
;		lea		160(a0),a0
;		lea		-160(a1),a1
;		dbf		d7,.TST
	
;=========================================
.SkipAll
;	cmp.w	#1,DEBUG_Flag
;	bne.s	.SkipCol3
;	move.w	#$700,$FFFF8240.W
;.SkipCol3
	IFNE	SCROLLER
		bsr		VBL_SCROLL
	ENDC
	
	cmp.w	#1,DEBUG_Flag
	bne.s	.SkipCol4
	move.w	#$222,$FFFF8240.W
.SkipCol4


	addq.l	#1,FrameCounter
	bsr		FlipBuffers

	cmpi.b	#$39,$fffffc02.w
 	bne.s	.EndVBL
; 	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
	rts
.EndVBL:
	bra		MainLoop

InterRTE:
	rte

;======================================

	IFNE	FASTROT_TEST7	
GenerateClearCode:
	;Draw the sphere for some frames on the same screen (no flipping)
	move.w	#200-1,d7
.DrawFirstFrames
	move.w	d7,-(sp)
	bsr		GenerateRotMatrix
	bsr		FastRot_Interpolate
	move.w	#$2700,sr
	bsr		FastRot2
	move.w	#$2300,sr
	addq.l	#1,FrameCounter
	move.w	(sp)+,d7
	dbf		d7,.DrawFirstFrames
	
	;Then read back the screen and generate clear code whenever it's needed
	move.l	ScreenPtr2,a0
	lea		ClearCodgen,a1
	moveq	#6,d0
	move.w	#(200*10)-1,d7
.AnalyzeScreen	
	tst.l	(a0,d0.w)
	beq.s	.NotNeeded
	move.w	#$2140,(a1)+
	move.w	d0,(a1)+
.NotNeeded
	add.w	#16,d0
	dbf		d7,.AnalyzeScreen
	move.w	#$4e75,(a1)
	rts
	ENDC
	
;======================================

	IFNE	FASTROT_TEST6
VisiblePlan				ds.w	2
_PixelTableSavedAddy	ds.l	1

FlipBuffers2:
	move.l	ScreenPtr1,d0
	move.l	ScreenPtr2,ScreenPtr1
	move.l	d0,ScreenPtr2

	move.l	ScreenPtr2,d0
	lsr.l	#8,d0
	move.w	#$8201,a0
	movep.w	d0,(a0)
	RTS

MainLoopForClear4P:

	;===
	bsr		FlipBuffers2

	move.l	PixelTable2bAddy,_PixelTableSavedAddy

	;Write on screen0/plane1
	bsr		GenerateRotMatrix
	bsr		FastRot_Interpolate
	bsr		FastRot2
	addq.l	#1,FrameCounter
	move.w	#0,VisiblePlan

;	bsr		FlipBuffers2

	;===

	move.l	PixelTablePlan2Addy,PixelTable2bAddy

	;Write on screen0/plane2
	bsr		GenerateRotMatrix
	bsr		FastRot_Interpolate
	bsr		FastRot2
	addq.l	#1,FrameCounter
	move.w	#1,VisiblePlan

	;===

	move.l	PixelTablePlan3Addy,PixelTable2bAddy

	;Write on screen0/plane3
	bsr		GenerateRotMatrix
	bsr		FastRot_Interpolate
	bsr		FastRot2
	addq.l	#1,FrameCounter
	move.w	#2,VisiblePlan

	;===

	move.l	PixelTablePlan4Addy,PixelTable2bAddy

	;Write on screen0/plane4
	bsr		GenerateRotMatrix
	bsr		FastRot_Interpolate
	bsr		FastRot2
	addq.l	#1,FrameCounter
	move.w	#3,VisiblePlan

	;===

	move.l	_PixelTableSavedAddy,PixelTable2bAddy

	move.l	ScreenPtr1,a0
	bsr		ClearScreen_4Planes2
	
;	bsr		FlipBuffers2
	bsr		VSync
	

	bra		MainLoopForClear4P
	ENDC
	
;======================================

	IFNE	SYM_TABLE
Flip4	dc.w	%0000
		dc.w	%1000
		dc.w	%0100
		dc.w	%1100
		dc.w	%0010
		dc.w	%1010
		dc.w	%0110
		dc.w	%1110
		dc.w	%0001
		dc.w	%1001
		dc.w	%0101
		dc.w	%1101
		dc.w	%0011
		dc.w	%1011
		dc.w	%0111
		dc.w	%1111
	
CreateSymTable:
	lea		SymTable,a0
	lea		Flip4,a4
	moveq	#0,d0
	move.w	#256-1,d7
.loop0
	move.w	#256-1,d6
.loop1
	moveq	#0,d1
;	moveq	#16-1,d2
;.nextbit
;	lsr.w	#1,d1
;	btst	d2,d0
;	beq.s	.n
;	bset	#15,d1	
;.n
;	dbf		d2,.nextbit

	move.w	d0,d3

	move.w	d3,d2
	lsr.w	#4,d3
	and.w	#15,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d2
	or.w	d2,d1
	lsl.w	#4,d1

	move.w	d3,d2
	lsr.w	#4,d3
	and.w	#15,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d2
	or.w	d2,d1
	lsl.w	#4,d1
	
	move.w	d3,d2
	lsr.w	#4,d3
	and.w	#15,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d2
	or.w	d2,d1
	lsl.w	#4,d1

	move.w	d3,d2
;	lsr.w	#4,d3
	and.w	#15,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d2
	or.w	d2,d1




	move.w	d1,(a0)+
	addq.w	#1,d0
	dbf		d6,.loop1
	dbf		d7,.loop0
	rts
	ENDC

Copy16	MACRO
	move.w	\1(a0),d0
	add.w	d0,d0
	move.w	(a2,d0.w),d0
	move.w	d0,\2(a1)
	ENDM
	
	IFNE	SYM_TABLE
Y_SIZE	set	200
CopyAndFlipScreen:
	move.l	ScreenPtr2,a0
	lea		6(a0),a0
	lea		(Y_SIZE)*160(a0),a1
	lea		-4(a1),a1
	lea		SymTable,a2

	move.w	#$ffff,d1

N2	set	0
	move.w	#Y_SIZE-1,d7
	
.EFF
;N	set	0
;	REPT	10
;	Copy16	N+2,8+N+N2
;	Copy16	N,N+N2
;N	set	N+16
;	ENDR

;	Copy16	0+2,8+0+N2
;	Copy16	0,0+N2
;	Copy16	16+2,8+16+N2
;	Copy16	16,16+N2
;	Copy16	16*2+2,8+16*2+N2
;	Copy16	16*2,16*2+N2
;	Copy16	16*3+2,8+16*3+N2
;	Copy16	16*3,16*3+N2
;	Copy16	16*4+2,8+16*4+N2
;	Copy16	16*4,16*4+N2
;	Copy16	16*5+2,8+16*5+N2
;	Copy16	16*5,16*5+N2
;	Copy16	16*6+2,8+16*6+N2
;	Copy16	16*6,16*6+N2
;	Copy16	16*7+2,8+16*7+N2
;	Copy16	16*7,16*7+N2
;	Copy16	16*8+2,8+16*8+N2
;	Copy16	16*8,16*8+N2
;	Copy16	16*9+2,8+16*9+N2
;	Copy16	16*9,16*9+N2

;	Copy16	0,0+N2
;	Copy16	0+2,8+0+N2
;
;	Copy16	16,16+N2
;	Copy16	16+2,8+16+N2

	Copy16	16*2,8+16*7+N2
	Copy16	16*2+2,16*7+N2

	Copy16	16*3,8+16*6+N2
	Copy16	16*3+2,16*6+N2

	Copy16	16*4,8+16*5+N2
	Copy16	16*4+2,16*5+N2

	Copy16	16*5,8+16*4+N2
	Copy16	16*5+2,16*4+N2

	Copy16	16*6,8+16*3+N2
	Copy16	16*6+2,16*3+N2

	Copy16	16*7,8+16*2+N2
	Copy16	16*7+2,16*2+N2

;	Copy16	16*8,16*8+N2
;	Copy16	16*8+2,8+16*8+N2
;	
;	Copy16	16*9,16*9+N2
;	Copy16	16*9+2,8+16*9+N2
	
	

	lea		-160(a1),a1
	lea		160(a0),a0
	dbf		d7,.EFF
	rts
	ENDC


	IFEQ	REMOVED
CopyAndFlipScreen:

	move.l	ScreenPtr2,a0
	lea		6(a0),a0

	;Curve is on planes 4 and 1, starting with 4:
	;16p4 16p1 16p4 16p1 ...
	;We want to copy that to plane 2 or 3:
	; d0 = (a0)	;16p4 16p1
	; (a0) = plane 4
	; -2(a0) = plane 3
	; -4(a0) = plane 2
	; low 16 bits copied to -4(a0)
	; high 16 bits copied to -4+8(a0)

Y_SIZE	set	200

N2	set	0
	moveq	#0,d0
	move.w	#Y_SIZE-1,d7
	
;	IFNE	FLIP_COPY
		lea		(Y_SIZE)*160(a0),a1
		lea		-4(a1),a1
;	ENDC
	
.EFF
;	IFEQ	FLIP_COPY
;		move.w	2(a0),-4+8+N2(a0)
;		move.w	(a0),-4+N2(a0)
;	ENDC
;	IFNE	FLIP_COPY
		move.w	2(a0),8+N2(a1)
		move.w	(a0),N2(a1)
;	ENDC

;	move.l	d0,(a0)
N	set	16
	REPT	9
;	IFEQ	FLIP_COPY
;		move.w	N+2(a0),-4+8+N+N2(a0)
;		move.w	N(a0),-4+N+N2(a0)
;	ENDC
;	IFNE	FLIP_COPY
		move.w	N+2(a0),8+N+N2(a1)
		move.w	N(a0),N+N2(a1)
;	ENDC
		
;	move.l	d0,N(a0)
N	set	N+16
	ENDR

;	IFNE	FLIP_COPY
	lea		-160(a1),a1
;	ENDC

	lea		160(a0),a0
	dbf		d7,.EFF
	rts
	ENDC

;======================================

	IFNE	FASTROT_HACK
NB_ENTRIES	set	NB_INTERPOLATED/2
	ELSE
NB_ENTRIES	set	NB_INTERPOLATED
	ENDC

Interp_Divide	MACRO
;	clr.w	\1
;	and.w	#$ffff8000,\1
;	and.w	#$ffffc000,\1
;	and.w	#$fffff000,\1
	divs	#\2,\1
	ext.l	\1
	add.l	\1,\1	*** to remove "add" in plot code
	add.l	\1,\1	*** to scale the object
	IFNE	FASTROT_HACK
		add.l	\1,\1	;HACK
	ENDC
	ENDM

	IFEQ	FASTROT_TEST4
_FastRot_InterpolateAxis
	movem.l	(a1)+,d3-d5
	
	Interp_Divide	d3,NB_INTERPOLATED
	Interp_Divide	d4,NB_INTERPOLATED

	moveq	#0,d0
	moveq	#0,d1
	
	REPT	NB_ENTRIES
		move.l	d0,d6
			swap	d6
				move.w	d6,(a2)+
		add.l	d3,d0
		
		move.l	d1,d6
			swap	d6
		IFNE	FASTROT_TEST
				add.w	d6,d6
				move.w	(a4,d6.w),d6
		ENDC
				move.w	d6,(a2)+
		add.l	d4,d1
	ENDR
	rts

;Skips the axis we know will be all zero
_FastRot_InterpolateAxis_Special
	movem.l	(a1)+,d3-d5
	
	Interp_Divide	d3,NB_INTERPOLATED

	moveq	#0,d0

	REPT	NB_ENTRIES
		move.l	d0,d6
			swap	d6
				move.w	d6,(a2)+
		add.l	d3,d0

		lea		2(a2),a2
	ENDR
	rts
	ENDC

	IFNE	FASTROT_TEST5
FastRot_PreInterpolate:
	lea		PreRotatedXPos,a2
	lea		PreRotatedXNeg,a3
	lea		PreRotatedYPos,a4
	lea		PreRotatedYNeg,a5

	move.w	#FASTROT_TABLE_SIZE-1,d7
.NextValue

	move.w	#EXTRA_SIZE-1,d2
.NextDecimal

	moveq	#0,d3
	
		moveq	#FASTROT_TABLE_SIZE,d4
		sub.w	d7,d4
		subq.w	#1,d4	;desired amplitude
;		lsr.w	#2,d4

		move.l	d4,d3
		swap	d3
		
		move.w	#EXTRA_SIZE,d3
		sub.w	d2,d3
		subq.w	#1,d3
		lsl.w	#8,d3
		lsl.w	#8-EXTRA_BITS,d3

;		move.w	#$1f,d3
;		move.w	#$1a,d3
;		swap	d3

;		move.l	#FASTROT_TABLE_SIZE,d4
;		sub.w	d7,d4
;		subq.w	#1,d4	;desired amplitude
;		mulu	#$1a,d4
;		divs	#FASTROT_TABLE_SIZE,d4
;		ext.l	d4
;		swap	d4

	
;	Interp_Divide	d3,NB_INTERPOLATED

		divs	#NB_INTERPOLATED,d3
		ext.l	d3
		add.l	d3,d3	*** to remove "add" in plot code
		add.l	d3,d3	*** to scale the object

	moveq	#0,d0
	move.w	#NB_ENTRIES-1,d5
.NextEntry	
		move.l	d0,d6
			swap	d6

			;d6 up to 1f*64k
;			lsr.l	#5,d6	;d6 up to 64k
;			mulu	d4,d6	;d6 up to 64k*d4
;			swap	d6		;d6 up to d4
			
				move.w	d6,(a2)+
				neg.w	d6
				move.w	d6,(a3)+
				muls.w	#160,d6
				move.w	d6,(a5)+
				neg.w	d6
				move.w	d6,(a4)+
		add.l	d3,d0
	dbf		d5,.NextEntry

	dbf		d2,.NextDecimal

	dbf		d7,.NextValue
	
;	lea		PreRotatedMulsT,a0
;	moveq	#0,d0
;	move.w	#FASTROT_TABLE_SIZE-1,d7
;.InitMulsT
;	move.l	d0,d3
;	lsr.l	#8,d3
;	lsr.l	#8-EXTRA_BITS,d3
;	muls	#NB_INTERPOLATED,d3
;	add.w	d3,d3
;	adda.w	d3,a0
;	addq.w	#1,d0
;	dbf		d7,.InitMulsT
	rts
	ENDC

FastRot_Interpolate:

	;Rotate the frame (3 pts) with regular rotation code
	lea		Frame,a0
	lea		RotatedFrame,a1
	lea		Matrix,a2
	move.w	#3-1,d7
;	move.w	#$777,$ffff8240.w
	bsr		RotatePointsSpecial
;	move.w	#$222,$ffff8240.w

	IFEQ	FASTROT_TEST5
		;Interpolate NB_INTERPOLATED vectors along the frame axes
	
		lea		RotatedFrame,a1
;		lea		MulsTable+MULS_TABLE_START_OFFSET,a4
		lea		MulsTable+200*2,a4
	
		lea		RotatedX,a2
		IFNE	FASTROT_TEST4
			jsr		InterpolateCodgenX
		ELSE
			bsr		_FastRot_InterpolateAxis_Special	**2DROT
;			bsr		_FastRot_InterpolateAxis
		ENDC

		lea		RotatedY,a2
		IFNE	FASTROT_TEST4
			jsr		InterpolateCodgenY
		ELSE
			bsr		_FastRot_InterpolateAxis
		ENDC

		lea		RotatedZ,a2
		IFNE	FASTROT_TEST4
			jsr		InterpolateCodgenZ
		ELSE
			bsr		_FastRot_InterpolateAxis
		ENDC
	ELSE
ConvertToIndex	MACRO
;	add.l	#$7fff,\1
;	lsr.l	#8,\1
;	lsr.l	#8-EXTRA_BITS,\1
	lsl.l	#EXTRA_BITS,\1
	swap	\1
	muls	#NB_INTERPOLATED,\1
	add.w	\1,\1
	adda.w	\1,\2
	ENDM	
	
PrecomputedVersion:
;	move.w	#$700,$ffff8240.w
		lea		PreRotatedXPos,a0
		lea		RotatedFrame,a2
		move.l	(a2),d3
		bge.s	.PosX
		neg.l	d3
		lea		PreRotatedXNeg,a0
.PosX
		ConvertToIndex	d3,a0

		move.l	a0,RotatedXxPtr
;		lea		RotatedX,a2
;		REPT	NB_INTERPOLATED/2
;			move.l	(a0)+,(a2)+
;		ENDR
		
		;===
		
		lea		RotatedFrame+3*4,a2
		
		lea		PreRotatedXPos,a0
		move.l	(a2)+,d3
		bge.s	.PosY0
		neg.l	d3
		lea		PreRotatedXNeg,a0
.PosY0
		ConvertToIndex	d3,a0

		lea		PreRotatedYPos,a1
		move.l	(a2)+,d4
		bge.s	.PosY1
		neg.l	d4
		lea		PreRotatedYNeg,a1
.PosY1
		ConvertToIndex	d4,a1
		
		move.l	a0,RotatedYxPtr
		move.l	a1,RotatedYyPtr
;		lea		RotatedY,a2
;		REPT	NB_INTERPOLATED
;			move.w	(a0)+,(a2)+
;			move.w	(a1)+,(a2)+
;		ENDR
		
		;===
		lea		RotatedFrame+3*4*2,a2
		
		lea		PreRotatedXPos,a0
		move.l	(a2)+,d3
		bge.s	.PosZ0
		neg.l	d3
		lea		PreRotatedXNeg,a0
.PosZ0
		ConvertToIndex	d3,a0

;		lea		PreRotatedYPos,a1
		lea		PreRotatedYNeg,a1	*** switched because we want to do "sub d5" first in main loop
		move.l	(a2)+,d4
		bge.s	.PosZ1
		neg.l	d4
;		lea		PreRotatedYNeg,a1
		lea		PreRotatedYPos,a1	*** switched because we want to do "sub d5" first in main loop
.PosZ1
		ConvertToIndex	d4,a1
		
		move.l	a0,RotatedZxPtr
		move.l	a1,RotatedZyPtr
;		lea		RotatedZ,a2
;		REPT	NB_INTERPOLATED
;			move.w	(a0)+,(a2)+
;			move.w	(a1)+,(a2)+
;		ENDR
	ENDC
;	move.w	#$222,$ffff8240.w
	rts
	
;======================================

CopyBlock:
.Loop
	cmp.l	a1,a2
	beq.s	.Done
	move.b	(a1)+,(a0)+
	bra.s	.Loop
.Done	
	rts

;======================================
	
	IFNE	FASTROT_CODGEN2

;We can now use a1 instead of a5 to access the LUT, because a1 is overwritten just afterwards.
;This only works with the FASTROT_TEST3 trick!
	IFNE	FASTROT_TEST3
_a5	equr	a1
	ELSE
_a5	equr	a5
	ENDC


; d0 + d4 + d6
; d0 - d4 + d6
; d0 + d4 - d6
; d0 - d4 - d6
;With one constant:
;If d6 is a constant y we can add it to the screen offsets. We only need d0 + d4 / d0 - d4 then.
;If it's a constant x, not sure what to do. We can offset the table (a5) but 'd0' is used directly for the bset index so that doesn't help?
;With one null (because 2d rots):
;The Y are easier to handle so maybe having a null X is a better idea.

PlotSequence	MACRO
	move.l	d0,_a5
	move.b	(_a5),d2
	add.w	d2,d1

;	bset	d0,(a1,d1.w)
		move.l	d1,a1
		bset	d0,(a1)
	eor.w	d3,d1
	not.b	d0
	bset	d0,(a4,d1.w)
	ENDM
	
_d7	equr	a2
_a2	equr	d7
	
PPP2_wip	MACRO
;	move.w	$1234(a3),d0	3
;	move.w	$1234(a3),d1	3
;	add.w	$1234(a3),d0	3
;	add.w	$1234(a3),d1	3
;	add.w	$1234(a3),d0	3
;	add.w	$1234(a3),d1	3

;	move.w	$1234(a3),a0	3
;;	move.w	$1234(a3),a2	3		**2DROT
;	move.w	$1234(a3),d4	3
;	move.w	$1234(a3),d5	3
;	move.w	$1234(a3),d6	3
;	move.w	$1234(a3),d7	3

	move.w	$1234(a3),d6	3
;	move.w	$1234(a3),_d7	3		**2DROT2
	move.w	$1234(a3),a0	3
	move.w	$1234(a3),_a2	3
	move.w	$1234(a3),d4	3
	move.w	$1234(a3),d5	3

;	PlotDotNoProj8Codgen3

;- swap x and z so that the constant values are a0/a2, that way we don't need to change the signs. That saves the 2 loads already.
;- then d7 for example is only used as add/sub to d1, i.e. the screen offset. So we could pre-add/pre-sub this to the screen addresses
;in a1/a4. However it means the bset d0,(a1) stuff won't work I think. Should still be worth it.
;- a2 is always null for some reason. That saves one load. => that's because of the 2 angles rotation...
;====> also means the corresponding interpolation could be skipped
;- we can maybe sort the dots to take advantage of similar offsets or something
;- Z interp could be optimized too
;- could we replace the initial moves with lea/move (a3)+ when consecutive offsets are used?

	;===
	move.w	d4,d0
	add.w	d6,d4	;d4 = d4+d6
	sub.w	d0,d6	;d6 = d6-d4
	
;	move.w	d5,d1
;	add.w	d7,d5	;d5 = d5+d7
;	sub.w	d1,d7	;d7 = d7-d5

	move.w	d5,d1
	add.w	_a2,d5	;d5 = d5+_a2
	sub.w	d1,_a2	;_a2 = _a2-d5
	;===

;	move.w	a0,d0
;	add.w	d4,d0
;	add.w	d6,d0
		move.w	a0,d0
		add.w	d4,d0

;	move.w	a2,d1
;	add.w	d5,d1
;	add.w	d7,d1
;		move.w	d5,d1	**2DROT
;		add.w	d7,d1	**2DROT
;			move.w	_a2,d1	**2DROT2
;			add.w	d5,d1	**2DROT2
				move.w	d5,d1	**2DROT2

	PlotSequence

	;===
;	move.w	a0,d0
;	add.w	d4,d0
;	sub.w	d6,d0
		move.w	a0,d0
		sub.w	d6,d0
	
;	move.w	a2,d1
;	add.w	d5,d1
;	sub.w	d7,d1
;		move.w	d5,d1	**2DROT
;		sub.w	d7,d1	**2DROT
;			move.w	_a2,d1	**2DROT2
;			add.w	d5,d1	**2DROT2
				move.w	d5,d1	**2DROT2

	PlotSequence

	;===
;	move.w	a0,d0
;	sub.w	d4,d0
;	add.w	d6,d0
		move.w	a0,d0
		add.w	d6,d0
	
;	move.w	a2,d1
;	sub.w	d5,d1
;	add.w	d7,d1
;		move.w	d7,d1	**2DROT
;		sub.w	d5,d1	**2DROT
;			move.w	_a2,d1	**2DROT2
;			sub.w	d5,d1	**2DROT2
				move.w	_a2,d1	**2DROT2

	PlotSequence

	;===
;	move.w	a0,d0
;	sub.w	d4,d0
;	sub.w	d6,d0
		move.w	a0,d0
		sub.w	d4,d0
	
;	move.w	a2,d1
;	sub.w	d5,d1
;	sub.w	d7,d1
;		move.w	d5,d1	**2DROT
;		add.w	d7,d1	**2DROT
;		neg.w	d1		**2DROT
;			move.w	_a2,d1	**2DROT2
;			sub.w	d5,d1	**2DROT2
				move.w	_a2,d1	**2DROT2

	PlotSequence

;	IFNE	FASTROT_CLEAR_SAVED_POS
;		move.w	d1,(a2)+
;	ENDC
	ENDM	

PPP2_testx	MACRO
	move.w	$1234(a3),a0	3
	move.w	$1234(a3),a2	3		**2DROT
	move.w	$1234(a3),d4	3
	move.w	$1234(a3),d5	3
	move.w	$1234(a3),d6	3
	move.w	$1234(a3),d7	3

	;===

	move.w	a0,d0
	add.w	d4,d0
	add.w	d6,d0
	
	move.w	a2,d1
	add.w	d5,d1
	add.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1
;		bset	d0,(a1,d1.w)
		
		eor.w	d3,d1
		not.b	d0
;		bset	d0,(a4,d1.w)

	;===
	move.w	a2,d1
	add.w	d5,d1
	sub.w	d7,d1
						move.w	d0,d5
						addq.w	#1,d5
	move.w	a0,d0
	add.w	d4,d0
	sub.w	d6,d0
;						addq.w	#1,d0
	

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1
;		bset	d0,(a1,d1.w)
		bset	d5,(a1,d1.w)
		
			and.w	#7,d0
			and.w	#7,d5
			cmp.w	d0,d5
			beq.s	*+4
			illegal
		
;		eor.w	d3,d1
;		not.b	d0
;		bset	d0,(a4,d1.w)


		
	ENDM

PPP2_testy	MACRO
	move.w	$1234(a3),a0	3
	move.w	$1234(a3),a2	3		**2DROT
	move.w	$1234(a3),d4	3
	move.w	$1234(a3),d5	3
	move.w	$1234(a3),d6	3
	move.w	$1234(a3),d7	3

	;===

	move.w	a0,d0
	add.w	d4,d0
	add.w	d6,d0
	
	move.w	a2,d1
	add.w	d5,d1
	add.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1
		bset	d0,(a1,d1.w)
		
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

			add.w	d2,d1

;			add.w	#160+32,d0
			add.w	#321,d0

;	move.w	a0,d0
;	add.w	d4,d0
;	sub.w	d6,d0

;	move.w	a2,d1
;	add.w	d5,d1
;	sub.w	d7,d1
		
			move.l	d0,a5
			move.b	(a5),d2
;			add.w	d2,d1
			sub.w	d2,d1
;			not.b	d0
;			bset	d0,(a1,d1.w)
			bset	d0,(a4,d1.w)
	ENDM


PlotSequence2	MACRO
	move.l	d0,_a5
	move.b	(_a5),d2
	add.w	d2,\1

	IFNE	FASTROT_TEST3
		move.l	\1,a1
		bset	d0,(a1)
	ELSE
		bset	d0,(a1,\1.w)
;		bset	d0,(a6,\1.w)
	ENDC
	IFNE	FASTROT_TEST6
		eor.w	#$fff9,\1
	ELSE
		not.w	\1
	ENDC
;	not.b	d0
	not.w	d0
	IFNE	FASTROT_TEST3
		bset	d0,(a4,\1.w)
	ELSE
		bset	d0,(a1,\1.w)
;		bset	d0,(a6,\1.w)
	ENDC
	ENDM

NoPlotSequence	MACRO
	move.l	d0,_a5
	move.b	(_a5),d2
	add.w	d2,\1

	IFNE	FASTROT_TEST3
		move.l	\1,a1
;		bset	d0,(a1)
	ELSE
		bset	d0,(a1,\1.w)
;		bset	d0,(a6,\1.w)
	ENDC
	not.w	\1
;	eor.w	d3,\1
;	not.b	d0
	not.w	d0
	IFNE	FASTROT_TEST3
;		bset	d0,(a4,\1.w)
	ELSE
		bset	d0,(a1,\1.w)
;		bset	d0,(a6,\1.w)
	ENDC
	ENDM

;a0 = constant y.x for slice
;a1 = screen address
;a2 = constant y.y for slice
;a3 = base buffer for interpolated vectors
;a4 = screen address
;a5 = used in plot macro but we could use a1 instead in the FASTROT_TEST3 codepath!
;a6 = free
;a7 = free
;d0 = "x"
;d1 = "y"
;d2 = "screen offset"
;d3 = constant a0*2 for slice
;d4 = work register for vector recomposition
;d5 = work register for vector recomposition
;d6 = work register for vector recomposition
;d7 = "free", used to save d1 in main block
;usp = free
;we can use esp to free a2 for a slice, i.e:
;	move.l	a3,usp
;	move.w	$1234(a3),a3
;	...use a3 in main block
;	move.l	usp,a3 in new slice
;Thus the available registers for vectors are a2,a3,a5,a6,a7 => bingo


	IFEQ	REMOVED
NewSliceBlock
;	sub.w	d3,a1
;	sub.w	a2,a1

;	sub.w	a2,a4
;	sub.w	a2,d2
	
OFFSET_A0	= *+2
	move.w	$1234(a3),a0	3
OFFSET_A2	= *+2
	move.w	$1234(a3),a2	3
	
;	add		#160*25,a2
	
;		move.w	$1234(a3),d0
;		lea		(a1,d0.w),a6
;		suba.l	a2,a2
	
;	move.w	(a6)+,a0
;	move.w	(a6)+,a2

;	suba.l	a0,a0
;	suba.l	a2,a2
	
;	add.w	a2,a4
;	add.w	a2,d2

;	move.w	#1600,d3
;	add.w	#1600,a1
;	add.w	#1600,a2

;	move.w	a2,d3
;	add.w	d3,a1
;	sub.w	a2,a2
	
;	move.w	a0,d7
;	add.w	d7,d7
	move.w	a0,d3
	add.w	d3,d3
NewSliceBlockEnd
	ENDC


	IFEQ	REMOVED
MainBlock
OFFSET_D6	= *+2
	move.w	$1234(a3),d6	3
OFFSET_D7	= *+2
;	move.w	$1234(a3),d7	3		**2DROT2
OFFSET_A0_	= *+2
;	move.w	$1234(a3),a0	3
OFFSET_A2_	= *+2
;	move.w	$1234(a3),a2	3
OFFSET_D4	= *+2
	move.w	$1234(a3),d4	3
OFFSET_D5	= *+2
	move.w	$1234(a3),d5	3

	;===
	move.w	d4,d0
	add.w	d6,d4	;d4 = d4+d6
	sub.w	d0,d6	;d6 = d6-d4
	;===
	move.w	a0,d0
	add.w	d4,d0		;d0 + d4 + d6
		move.w	a2,d1
		add.w	d5,d1
		move.w	d1,d7
	PlotSequence2	d1
	;===
	move.w	a0,d0
	sub.w	d6,d0		;d0 + d4 - d6
	PlotSequence2	d7
	;===
	move.w	a0,d0
	add.w	d6,d0		;d0 - d4 + d6
		move.w	a2,d1
		sub.w	d5,d1
		move.w	d1,d7
	PlotSequence2	d1
	;===
	move.w	a0,d0
	sub.w	d4,d0		;d0 - d4 - d6
	PlotSequence2	d7
MainBlockEnd
	ENDC

;======================================

	IFNE	FASTROT_TEST5
_a3	equr	a3
	ELSE
_a3	equr	a2	;Need to preserve a3 in this codepath since it's used in main block
	ENDC

	IFNE	FASTROT_TEST6
_SavedA2	dc.l	1	
_a7	equr	a2
	ELSE
_a7	equr	a7
	ENDC

;======================================

NewSliceBlock
	move.l	usp,a3
	IFNE	FASTROT_TEST6
		move.l	_SavedA2,a2
	ENDC	
OFFSET_A0	= *+2
	IFNE	FASTROT_TEST5
		move.w	$1234(a2),_a7	3
	ELSE
		move.w	$1234(a3),a7	3
	ENDC
OFFSET_A2	= *+2
	move.w	$1234(a3),_a3	3
	
	;swap xp
;		move.w	_a3,d3
;		swap	d3
;		move.w	_a3,d3
;		move.l	d3,_a3

	move.w	_a7,d3
	add.w	d3,d3
NewSliceBlockEnd

;======================================

;	IFEQ	REMOVED
;LoadBlockD6
;OFFSET_D6	= *+2
;	IFNE	FASTROT_TEST5
;		move.w	$1234(a5),d6	3
;	ELSE
;		move.w	$1234(a3),d6	3
;	ENDC
;LoadBlockD6End

;d6 is now free!!!
LoadBlockD6
	move.w	_a7,d0
OFFSET_D6	= *+2
	IFNE	FASTROT_TEST5
		add.w	$1234(a5),d0	3
	ELSE
		add.w	$1234(a3),d0	3
	ENDC
LoadBlockD6End

LoadBlockD4
OFFSET_D4	= *+2
	IFNE	FASTROT_TEST5
		move.w	$1234(a6),d4	3
	ELSE
		move.w	$1234(a3),d4	3
	ENDC
LoadBlockD4End
	
LoadBlockD5
OFFSET_D5	= *+2
	IFNE	FASTROT_TEST5
		move.w	$1234(a0),d5	3
	ELSE
		move.w	$1234(a3),d5	3
	ENDC	
LoadBlockD5End

;======================================

	IFEQ	REMOVED
MainBlockOld
	;d0 + d4 + d6
;d6 is now free!!!
;	move.w	_a7,d0
;	add.w	d6,d0
	add.w	d4,d0
		move.w	_a3,d1
		add.w	d5,d1
		move.w	d1,d7
	PlotSequence2	d1
	;- d0 - d4 - d6

	;d0 + d4 - d6
	add.w	d3,d0
	add.w	d4,d4
	add.w	d4,d0
;		add.w	d6,d6
;		add.w	d6,d0
;		not.w	d0
	PlotSequence2	d7
;	PlotSequence3	d7
	;- d0 - d4 + d6
	
	;d0 - d4 + d6
	add.w	d3,d0
		move.w	_a3,d1
		sub.w	d5,d1
		move.w	d1,d7
	PlotSequence2	d1
	;- d0 + d4 - d6
	
	;d0 - d4 - d6
	add.w	d3,d0
	sub.w	d4,d0
;		add.w	d6,d0
;		not.w	d0
	PlotSequence2	d7
;	PlotSequence3	d7
	;- d0 + d4 + d6
	
MainBlockOldEnd
	ENDC

	IFEQ	REMOVED
;This new version uses the now free d6 register to reorganize the blocks and save one instruction
MainBlock_tmpremoved
	;d0 + d4 + d6
	add.w	d4,d0
		move.w	_a3,d1
;		add.w	d5,d1		;TODO: try to do this one last to add _a3 to d5 and save one move (or just negate d5 in precomputed buffers)
		sub.w	d5,d1		;"sub" first because we flipped the positive/negative buffers for d5
		move.w	d1,d7
	PlotSequence2	d1
	;- d0 - d4 - d6

	;d0 - d4 - d6
	add.w	d3,d0
;		move.w	_a3,d1
;;		sub.w	d5,d1
;		add.w	d5,d1
;		move.w	d1,d6		;TODO: use d5 here, free d6 again? but beware, we don't always reload d5!
;	PlotSequence2	d1
			add.w	_a3,d5
			move.w	d5,d6		;TODO: use d5 here, free d6 again? but beware, we don't always reload d5!
			PlotSequence2	d5
	;- d0 + d4 + d6

	;d0 - d4 + d6
	add.w	d3,d0
;	add.w	d4,d4
;	sub.w	d4,d0
		sub.w	d4,d0
		sub.w	d4,d0
	PlotSequence2	d6
	;- d0 + d4 - d6

	;d0 + d4 - d6
	add.w	d3,d0
	PlotSequence2	d7
	;- d0 - d4 + d6
MainBlockEnd_tmpremoved
	ENDC

PlotSequence2b	MACRO
	move.l	d6,_a5
	move.b	(_a5),d2
	add.w	d2,\1

	IFNE	FASTROT_TEST3
		move.l	\1,a1
		bset	d6,(a1)
	ELSE
		bset	d6,(a1,\1.w)
;		bset	d6,(a6,\1.w)
	ENDC
	IFNE	FASTROT_TEST6
		eor.w	#$fff9,\1
	ELSE
		not.w	\1
	ENDC
;	not.b	d6
	not.w	d6
	IFNE	FASTROT_TEST3
		bset	d6,(a4,\1.w)
	ELSE
		bset	d6,(a1,\1.w)
;		bset	d6,(a6,\1.w)
	ENDC
	ENDM


;This one frees d6 again by reusing d1 for y in plot sequence 3. Then it saves "d0+d6" to d6
;and subtracts d4 from d6 in plot3, saving one nop in total. This only works with a plot sequence
;that can use d6 instead of d0 for x. Is that all clear? :)
MainBlock_wip
					move.w	d0,d6
	;d0 + d4 + d6
	add.w	d4,d0
		move.w	_a3,d1
		sub.w	d5,d1		;"sub" first because we flipped the positive/negative buffers for d5
		move.w	d1,d7
	PlotSequence2	d1
;	NoPlotSequence	d1
	;- d0 - d4 - d6

	;d0 - d4 - d6
	add.w	d3,d0
			add.w	_a3,d5
			move.w	d5,d1
			PlotSequence2	d5
;			NoPlotSequence	d5
	;- d0 + d4 + d6

	;TODO: d0 is now unused from this point, could we use this?

	;d0 - d4 + d6
;	add.w	d3,d0
;		sub.w	d4,d0
;		sub.w	d4,d0
			sub.w	d4,d6
	PlotSequence2b	d1
	;- d0 + d4 - d6

	;d0 + d4 - d6
;	add.w	d3,d0
			add.w	d3,d6
	PlotSequence2b	d7
;	NoPlotSequence	d7
	;- d0 - d4 + d6
MainBlockEnd_wip

;we have _a3 - d5, we then need _a3 + d5
;we do: _a3 - d5 + d2
;and then: not(_a3 - d5 + d2) = ~ - _a3 + d5 - d2
;so if we add d2 again we actually get d5 - _a3
;_a3 is constant so we could have _a3*2 in a register, and one extra add would give _a3 + d5
;so we need 2 instructions to get the new screen offset, that's 8 instructions in total for the 4 plot sequences
;so it's actually worse than the current 5 instructions





PlotSequence2c	MACRO
	move.l	\2,_a5
	move.b	(_a5),d2
	add.w	d2,\1

	IFNE	FASTROT_TEST3
		move.l	\1,a1
		bset	\2,(a1)
	ELSE
		bset	\2,(a1,\1.w)
	ENDC
	IFNE	FASTROT_TEST6
		eor.w	#$fff9,\1
	ELSE
		not.w	\1
	ENDC
	not.w	\2	;not.b doesn't work
	IFNE	FASTROT_TEST3
		bset	\2,(a4,\1.w)
	ELSE
		bset	\2,(a1,\1.w)
	ENDC
	ENDM

; Current version = same as above but with dead code removed & unified plot macro
MainBlock
	move.w	d0,d6
	;d0 + d4 + d6
	add.w	d4,d0
	move.w	_a3,d1
	sub.w	d5,d1		;"sub" first because we flipped the positive/negative buffers for d5
	move.w	d1,d7
		PlotSequence2c	d1,d0
;		NoPlotSequence	d1
	;- d0 - d4 - d6

	;d0 - d4 - d6
	add.w	d3,d0
	add.w	_a3,d5
	move.w	d5,d1
		PlotSequence2c	d5,d0
;		NoPlotSequence	d5
	;- d0 + d4 + d6

	;TODO: d0 is now unused from this point, could we use this?

	;d0 - d4 + d6
	sub.w	d4,d6
		PlotSequence2c	d1,d6
	;- d0 + d4 - d6

	;d0 + d4 - d6
	add.w	d3,d6
		PlotSequence2c	d7,d6
;		NoPlotSequence	d7
	;- d0 - d4 + d6
MainBlockEnd





;	add.w	d3,d0
;	add.w	_a3,d5
;	move.w	d5,d6		;TODO: use d5 here, free d6 again? but beware, we don't always reload d5!
;		move.l	d0,_a5
;		move.b	(_a5),d2
;		add.w	d2,d5
;		move.l	d5,a1
;		bset	d0,(a1)
;		not.w	d5
;		not.w	d0
;		bset	d0,(a4,d5.w)
;	;- d0 + d4 + d6
;
;	;d0 - d4 + d6
;	add.w	d3,d0
;	sub.w	d4,d0
;	sub.w	d4,d0
;		move.l	d0,_a5
;		move.b	(_a5),d2
;		add.w	d2,d6
;		move.l	d6,a1
;		bset	d0,(a1)
;		not.w	d6
;		not.w	d0
;		bset	d0,(a4,d6.w)
;
;	;- d0 + d4 - d6





;TODO: investigate why the following is failing. Set d2 to zero, does it make a difference?
_SaveA4	ds.l	1
MainBlock___
	;d0 + d4 + d6
	add.w	d4,d0
						move.l	a4,_SaveA4
						adda.l	_a3,a4
;		move.w	_a3,d1
;		add.w	d5,d1
						move.w	d5,d1
		move.w	d1,d7
	PlotSequence2	d1
	;- d0 - d4 - d6
						move.l	_SaveA4,a4

;	;d0 - d4 - d6
;	add.w	d3,d0
;		move.w	_a3,d1
;		sub.w	d5,d1
;		move.w	d1,d6		;TODO: use d5 here, free d6 again? but beware, we don't always reload d5!
;	PlotSequence2	d1
;	;- d0 + d4 + d6
;
;	;d0 - d4 + d6
;	add.w	d3,d0
;;	add.w	d4,d4
;;	sub.w	d4,d0
;		sub.w	d4,d0
;		sub.w	d4,d0
;	PlotSequence2	d6
;	;- d0 + d4 - d6
;
;	;d0 + d4 - d6
;	add.w	d3,d0
;	PlotSequence2	d7
;	;- d0 - d4 + d6
MainBlockEnd___


;======================================

;We need a sequence for which the input d0 is NOTed
PlotSequence3	MACRO
	;In input, d0 has been NOTed i.e. it is correct for the second pixel
	
	move.l	d0,ax
	move.b	(ax),d2		;somehow fetch d2-from-NOTed-d0 = same d2 as if d0 wouldn't be NOTed
	add.w	d2,\1

;	;At this point we cannot plot the first pixel (d0 is incorrect)
;
;	IFNE	FASTROT_TEST3
;		move.l	\1,a1
;		bset	d0,(a1)
;	ELSE
;		bset	d0,(a1,\1.w)
;	ENDC
;	not.w	\1
;	not.w	d0
;	IFNE	FASTROT_TEST3
;		bset	d0,(a4,\1.w)
;	ELSE
;		bset	d0,(a1,\1.w)
;	ENDC
	ENDM

;======================================


	IFEQ	REMOVED

MainBlock
OFFSET_D6	= *+2
	move.w	$1234(a3),d6	3
OFFSET_D7	= *+2
;	move.w	$1234(a3),d7	3		**2DROT2
OFFSET_A0_	= *+2
;	move.w	$1234(a3),a0	3
OFFSET_A2_	= *+2
;	move.w	$1234(a3),a2	3
OFFSET_D4	= *+2
	move.w	$1234(a3),d4	3
OFFSET_D5	= *+2
	move.w	$1234(a3),d5	3

	;===

	;d0 + d4 + d6
	move.w	a0,d0
	add.w	d6,d0
	add.w	d4,d0
		move.w	a2,d1
		add.w	d5,d1
		move.w	d1,d7
;	PlotSequence2	d1
	NoPlotSequence	d1
	;- d0 - d4 - d6
	
	;d0 + d4 - d6
	add.w	d3,d0
	add.w	d4,d4
	add.w	d4,d0
;	move.w	d7,d1
;	PlotSequence2	d1

;	move.w	d7,d1

	add.w	d2,d1
		move.l	d0,_a5
		move.b	(_a5),d2
	sub.w	d2,d1
;		add.w	d2,d1

		IFNE	FASTROT_TEST3
			move.l	d1,a1
			bset	d0,(a1)
		ELSE
			bset	d0,(a1,d1.w)
		ENDC
		not.w	d1
		not.w	d0
		IFNE	FASTROT_TEST3
;			bset	d0,(a4,d1.w)
		ELSE
			bset	d0,(a1,d1.w)
		ENDC







	;- d0 - d4 + d6
	
		;- d0 - d4 + d6
;		add.w	d6,d0
;		add.w	d6,d0
;		;here d0 = not d0 for next dot
;		;d1 has been d2_added then NOTed. We need the NOT but we need a different screen offset
;			not.w	d0
;			PlotSequence2	d7

;			int offset = i + 32;
;			int noffset = ~offset;
;			int offset2 = -(noffset + 32 + 1);

;			add.w	d2,d1
;			addq.w	#1,d1
			


;		sub.w	d2,d1	;undo the previous add
;			move.l	d0,a5
;			move.b	(a5),d2
;			add.w	d2,d1
;
;			IFNE	FASTROT_TEST3
;				move.l	\1,a1
;				bset	d0,(a1)
;			ELSE
;				bset	d0,(a1,\1.w)
;			ENDC
;			not.w	\1
;			not.w	d0
;			IFNE	FASTROT_TEST3
;				bset	d0,(a4,d1.w)
;			ELSE
;				bset	d0,(a1,d1.w)
;			ENDC	
	
	
	

;	;d0 - d4 + d6
;	add.w	d3,d0
;		move.w	a2,d1
;		sub.w	d5,d1
;		move.w	d1,d7
;	PlotSequence2	d1
;	;- d0 + d4 - d6
;	
;	;d0 - d4 - d6
;	add.w	d3,d0
;	sub.w	d4,d0
;	PlotSequence2	d7
	
MainBlockEnd
	ENDC

Prologue:
	IFNE	FASTROT_TEST6
		move.l	a2,_SavedA2
	ENDC	
	move.l	a7,_SaveA7
	move.l	a3,usp
PrologueEnd

Epilogue:
	move.l	_SaveA7,a7
	rts
EpilogueEnd

;======================================

NbBsets				dc.w	0
NbCalls				dc.w	0
NbSame				dc.w	0
NbSameD6			dc.w	0
NbSameD4D5			dc.w	0
NbContiguousD6		dc.w	0
NbContiguousD4D5	dc.w	0

;a0 = dest buffer
GenerateFastrotCode2:
	move.w	#NB_PTS,d7
	lea		TmpBufferPts,a4
	lea		TmpBufferXZ,a1
	lea		TmpBufferY,a2
	move.w	d7,d6
	subq.w	#1,d6
;		moveq	#0,d2
;		moveq	#0,d3
;		moveq	#0,d4
;		moveq	#0,d5
.ChangeData
	move.w	(a4)+,d0	;a3 at runtime = RotatedX + d0
	asr.w	#1,d0	;because we skipped the lea 2(a2),a2 in the interpolate codgenx (the y is always null)
	move.w	d0,(a1)+

	move.w	(a4)+,d0	;a6 at runtime = RotatedY + d1
	IFNE	FASTROT_TEST5
		asr.w	#1,d0	;because we splitted x & y vectors to separate buffers
	ELSE
		add.w	#RotatedY-RotatedX,d0		;Base addy is RotatedX, offsets jumps to RotatedY
	ENDC
	move.w	d0,(a2)+
	
	move.w	(a4)+,d0	;a7 at runtime = RotatedZ + d2
	IFNE	FASTROT_TEST5
		asr.w	#1,d0	;because we splitted x & y vectors to separate buffers
	ELSE
		add.w	#RotatedZ-RotatedX,d0		;Base addy is RotatedX, offsets jumps to RotatedY
	ENDC
	move.w	d0,(a1)+

;		cmp.l	-4(a4),d5
;		bne.s	.Diff
;		cmp.l	-8(a4),d4
;		bne.s	.Diff
;		cmp.l	-12(a4),d3
;		bne.s	.Diff
;		addq.w	#1,d2
;.Diff
;		move.l	-12(a4),d3
;		move.l	-8(a4),d4
;		move.l	-4(a4),d5
		
;		addq.w	#4,d1
;		cmp.w	d0,d1
;		bne.s	.DifferentOffsetZ
;		addq.w	#1,d2
;.DifferentOffsetZ		
;		move.w	d0,d1	;previous Z offset
	
	dbf		d6,.ChangeData
	
;======================================

	lea		Prologue,a1
	lea		PrologueEnd,a2
	bsr		CopyBlock

	lea		TmpBufferXZ,a4
	lea		TmpBufferY,a5

	moveq	#NB_IN_ARC-1,d7
.NextSlice

		move.w	(a5),d0
		lea		OFFSET_A0,a1
		move.w	d0,(a1)
	IFNE	FASTROT_TEST5
		;It's the same offset now, just from separate base addresses
	ELSE
		addq.w	#2,d0
	ENDC
		lea		OFFSET_A2,a1
		move.w	d0,(a1)

	lea		NewSliceBlock,a1
	lea		NewSliceBlockEnd,a2
	bsr		CopyBlock

		moveq	#0,d3		;Previous d6 offset
		moveq	#0,d4		;Previous d4 offset
		not.w	d3			;Make sure initial previous offset is different
		not.w	d4			;Make sure initial previous offset is different

	moveq	#NB_SLICES-1,d6
.NextDotWithSimilarY	

	addq.w	#1,NbCalls
			moveq	#0,d2	;Flag for "same dot" (0=same, 1=different)

		move.w	(a4)+,d0
			cmp.w	d0,d3
			beq.s	.SameX
				addq.w	#2,d3
				cmp.w	d0,d3
				bne.s	.DiscontinuousX
				addq.w	#1,NbContiguousD6
.DiscontinuousX
;			moveq	#1,d2
			ori.w	#1,d2	;bit 0 = same d6 or not
			move.w	d0,d3
.SameX
		lea		OFFSET_D6,a1
		move.w	d0,(a1)
;		addq.w	#2,d0
;		lea		OFFSET_D7,a1
;		move.w	d0,(a1)
	;=====
		lea		2(a5),a5
;		move.w	(a5)+,d0
;		lea		OFFSET_A0_,a1
;		move.w	d0,(a1)
;		addq.w	#2,d0
;		lea		OFFSET_A2_,a1
;		move.w	d0,(a1)
	;=====
		move.w	(a4)+,d0
			cmp.w	d0,d4
			beq.s	.SameZ
				addq.w	#2,d4
				cmp.w	d0,d4
				bne.s	.DiscontinuousZ
				addq.w	#1,NbContiguousD4D5
.DiscontinuousZ
			
;			moveq	#1,d2
			ori.w	#2,d2	;bit 1 = same d4 or not
			move.w	d0,d4
.SameZ
		lea		OFFSET_D4,a1
		move.w	d0,(a1)
	IFNE	FASTROT_TEST5
		;It's the same offset now, just from separate base addresses
	ELSE
		addq.w	#2,d0
	ENDC
		lea		OFFSET_D5,a1
		move.w	d0,(a1)
			tst.b	d2
			bne.s	.DifferentDot
			addq.w	#1,NbSame
			bra		.SameDot	;exact same dot?! skip it
.DifferentDot
;		IFEQ	REMOVED
				cmp.b	#3,d2
				beq		.CopyFullBlock	;all different
				cmp.b	#2,d2
				beq.s	.SameD6DifferentD4D5
				cmp.b	#1,d2
				beq.s	.SameD4D5DifferentD6
				illegal
.SameD4D5DifferentD6
				addq.w	#1,NbSameD4D5

				lea		LoadBlockD6,a1
				lea		LoadBlockD6End,a2
				bsr		CopyBlock

				;D4 got doubled during main block   ===> not anymore
;				move.w	#$e244,(a0)+	;asr.w	#1,d4

;					lea		LoadBlockD4D5,a1
;					lea		LoadBlockD4D5End,a2
;					bsr		CopyBlock

;				lea		LoadBlockD4,a1
;				lea		LoadBlockD4End,a2
;				bsr		CopyBlock

				;we now need to reload d5 because it's modified in main loop
				lea		LoadBlockD5,a1
				lea		LoadBlockD5End,a2
				bsr		CopyBlock


				lea		MainBlock,a1
				lea		MainBlockEnd,a2
				bsr		CopyBlock
				addq.w	#8,NbBsets

				bra		.SameDot
.SameD6DifferentD4D5
				addq.w	#1,NbSameD6
				
				;this is now back because "d6" is directly added to d0
					lea		LoadBlockD6,a1
					lea		LoadBlockD6End,a2
					bsr		CopyBlock
				
				lea		LoadBlockD4,a1
				lea		LoadBlockD4End,a2
				bsr		CopyBlock

				lea		LoadBlockD5,a1
				lea		LoadBlockD5End,a2
				bsr		CopyBlock

				lea		MainBlock,a1
				lea		MainBlockEnd,a2
				bsr		CopyBlock
				addq.w	#8,NbBsets

				bra.s	.SameDot
.CopyFullBlock
;		ENDC
		
	lea		LoadBlockD6,a1
	lea		LoadBlockD6End,a2
	bsr		CopyBlock

	lea		LoadBlockD4,a1
	lea		LoadBlockD4End,a2
	bsr		CopyBlock

	lea		LoadBlockD5,a1
	lea		LoadBlockD5End,a2
	bsr		CopyBlock

	lea		MainBlock,a1
	lea		MainBlockEnd,a2
	bsr		CopyBlock
	addq.w	#8,NbBsets
.SameDot

	dbf		d6,.NextDotWithSimilarY

	dbf		d7,.NextSlice
	
	lea		Epilogue,a1
	lea		EpilogueEnd,a2
	bsr		CopyBlock

;	jsr		PrepareRegisters
;	jsr		FastrotCodgen2

	;===
	rts
	ENDC

;======================================

PrepareRegisters:
	move.l	ScreenPtr2,a1
	IFNE	FASTROT_TEST3
;		lea		160*25(a1),a1
		move.l	a1,d5
		move.l	a1,d7
;		move.l	a1,d6
		move.l	a1,d1
		move.l	a1,d3
	ELSE
		lea		160*100(a1),a1
	ENDC
;		lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
;		lea		PixelTable2b+160*1,a5
		move.l	PixelTable2bAddy,a5
	IFNE	FASTROT_TEST2
		move.l	a5,d0
		move.l	a5,d6
;		move.l	a5,d3
	ELSE
		lea		160(a5),a5
	ENDC
		moveq	#0,d2
;		lea		MulsTable+MULS_TABLE_START_OFFSET,a4
		lea		MulsTable+200*2,a4
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.l	ClrOffsetsPtr2,a2
	ENDC	

;	move.w	#$fff9,d3
;	move.w	#$ffff,d3
;	moveq	#0,d3
	
	IFNE	FASTROT_TEST3
	lea		1280*12*2+160(a1),a4	;+160 otherwise there's one line shift for the second part, use rotations around Y only to clearly see it
	move.w	#1280*12,d2
	ENDC
;	lea		160*25(a4),a4

	IFNE	FASTROT_TEST5
		move.l	RotatedXxPtr,a5
		move.l	RotatedZxPtr,a6
		move.l	RotatedZyPtr,a0
		move.l	RotatedYxPtr,a2
		move.l	RotatedYyPtr,a3
	ELSE
		lea		RotatedX,a3
;		suba.l	a0,a0
;		suba.l	a2,a2
;		suba.l	a5,a5
;		suba.l	a6,a6
	ENDC
	rts

FastRot2:
	jsr		PrepareRegisters
	jsr		FastrotCodgen2

;	move.l	#$12345678,d1
;	move.l	a1,a3
;	moveq	#0,d0
;	move.w	#63,d7
;.TEST
;	move.w	d0,d1
;	lsr.w	#4,d1
;	lsl.w	#3,d1
;	
;	move.w	d0,d2
;	and.w	#15,d2
;	cmp.w	#7,d2
;	ble.s	.nu
;	addq.w	#1,d1
;.nu	
;	move.w	d0,d2
;	not.w	d2
;	bset	d2,(a3,d1.w)
;
;	addq.w	#1,d0
;	lea		160(a3),a3
;	dbf		d7,.TEST
	
;N	set		0
;M	set		0
;	REPT	64
;	move.w	#M,d0
;	moveq	#0,d1
;;	tst.b	d0
;;	sgt		d1
;	not.w	d0
;	
;	add.w	#N+(M/16)*8,d1
;	
;	bset	d0,N+(M/16)*8(a1)
;	bset	d0,N+1+(M/16)*8(a1)
;;	bset	d0,(a1,d1.w)
;;	bset	d0,N+1(a1)
;N	set		N+160
;M	set		M+1
;	ENDR
	
	rts
	
;======================================

	IFNE	FASTROT_TEST4
PreludeBlockStart:
	movem.l	(a1)+,d3-d5
	Interp_Divide	d3,NB_INTERPOLATED
	Interp_Divide	d4,NB_INTERPOLATED
	moveq	#0,d0
	moveq	#0,d1
PreludeBlockEnd

PreludeBlockStartX:
	movem.l	(a1)+,d3-d5
	Interp_Divide	d3,NB_INTERPOLATED
	moveq	#0,d0
PreludeBlockEndX

UsedBlockStartX:
	move.l	d0,d6
		swap	d6
			move.w	d6,(a2)+
	add.l	d3,d0
;	lea		2(a2),a2
UsedBlockEndX

NotUsedBlockStartX:
	add.l	d3,d0
;	lea		2(a2),a2
NotUsedBlockEndX

UsedBlockStart:
	move.l	d0,d6
		swap	d6
			move.w	d6,(a2)+
	add.l	d3,d0
	
	move.l	d1,d6
		swap	d6
	IFNE	FASTROT_TEST
			add.w	d6,d6
			move.w	(a4,d6.w),d6
	ENDC
			move.w	d6,(a2)+
;					lea	(a4,d6.w),a5
;					move.w	(a5),(a2)+
	add.l	d4,d1
UsedBlockEnd

NotUsedBlockStart:
	add.l	d3,d0
	add.l	d4,d1
;	lea		4(a2),a2
NotUsedBlockEnd

CreateIntCodgen:
	move.l	d0,a1
	move.l	d1,a2
	bsr		CopyBlock
	moveq	#0,d6
	move.w	#NB_ENTRIES-1,d7
.IntGen
	tst.b	(a3)+
	beq.s	.NotUsed
	move.w	d6,d6
	beq.s	.Nothing
	add.w	d6,d6
	add.w	d6,d6
	move.w	#$45ea,(a0)+	;lea $1234(a2),a2
	move.w	d6,(a0)+
	moveq	#0,d6
.Nothing	
	move.l	d2,a1
	move.l	d3,a2
	bra.s	.Copy
.NotUsed
	move.l	d4,a1
	move.l	d5,a2
	addq.w	#1,d6
.Copy	
	bsr		CopyBlock
	dbf		d7,.IntGen
	move.w	#$4e75,(a0)
	rts

CreateIntCodgenYZ:
	move.l	#PreludeBlockStart,d0
	move.l	#PreludeBlockEnd,d1
	move.l	#UsedBlockStart,d2
	move.l	#UsedBlockEnd,d3
	move.l	#NotUsedBlockStart,d4
	move.l	#NotUsedBlockEnd,d5
	bra		CreateIntCodgen
	
CreateIntCodgenX:
	move.l	#PreludeBlockStartX,d0
	move.l	#PreludeBlockEndX,d1
	move.l	#UsedBlockStartX,d2
	move.l	#UsedBlockEndX,d3
	move.l	#NotUsedBlockStartX,d4
	move.l	#NotUsedBlockEndX,d5
	bra		CreateIntCodgen
	ENDC
	
InitPts3:
	lea		SrcPts,a1
	lea		TmpBufferPts,a2
	IFNE	FASTROT_TEST4
		lea		UsedX,a4
		lea		UsedY,a5
		lea		UsedZ,a6
	ENDC

	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	
	move.w	#NB_PTS-1,d7
.InitPts
	move.w	(a1)+,d0	;x
	move.w	(a1)+,d1	;y
	move.w	(a1)+,d2	;z

	;Rescaling
	asr.w	#3,d0
	asr.w	#3,d1
	asr.w	#3,d2
;	divs.w	#620/(NB_INTERPOLATED),d0
;	divs.w	#620/(NB_INTERPOLATED),d1
;	divs.w	#620/(NB_INTERPOLATED),d2
	
	move.w	d0,d0
	bge.s	.PosOrNullX
	illegal
.PosOrNullX
	move.w	d1,d1
	bge.s	.PosOrNullY
	illegal
.PosOrNullY
	move.w	d2,d2
	bge.s	.PosOrNullZ
	illegal
.PosOrNullZ

	IFNE	FASTROT_HACK
		asr.w	#1,d0		;HACK
		asr.w	#1,d1		;HACK
		asr.w	#1,d2		;HACK
	ENDC
	
	IFNE	FASTROT_TEST4
		move.b	#1,(a4,d0.w)
		move.b	#1,(a5,d1.w)
		move.b	#1,(a6,d2.w)
	ENDC
		
	mulu	#FASTROT_NB_COORDS*2,d0
	mulu	#FASTROT_NB_COORDS*2,d1
	mulu	#FASTROT_NB_COORDS*2,d2
	
	move.w	d0,(a2)+
	move.w	d1,(a2)+
	move.w	d2,(a2)+
	dbf		d7,.InitPts
	
	IFNE	FASTROT_TEST4
		lea		InterpolateCodgenX,a0
		lea		UsedX,a3
		bsr		CreateIntCodgenX
		
		lea		InterpolateCodgenY,a0
		lea		UsedY,a3
		bsr		CreateIntCodgenYZ

		lea		InterpolateCodgenZ,a0
		lea		UsedZ,a3
		bsr		CreateIntCodgenYZ
	ENDC
	
	IFNE	FASTROT_TEST5
		bsr	FastRot_PreInterpolate
	ENDC
	
	rts

;======================================

CreateNewSinglePixelTable:
		lea		TABL_PLANS,a5
		moveq	#0,d5
	moveq	#3,d3
	moveq	#4,d4
	moveq	#0,d1
	moveq	#0,d0			;x value
	IFNE	FASTROT_TEST2
		move.w	#160,d0
		move.l	a0,a1
	ENDC
	move.w	#320-1,d7		;table valid for 320 pixels
.CreateTable
	subq.w	#1,d0			;next pixel	**** this line to get rid of the NOT in the plot macro
	move.w	d0,d1
	lsr.w	d4,d1
	lsl.w	d3,d1

	move.w	d0,d2
	and.w	#15,d2
	cmp.w	#7,d2
	ble.s	.nu
	addq.w	#1,d1
.nu	

;	move.w	d5,d2
;	and.w	#63,d2
;	cmp.w	#31,d2
;	ble.s	.nu2
;	addq.b	#6,d1
;.nu2

	IFNE	FASTROT_TEST6
		add.l	PixelTablePlanOffset,d1
	ELSE
		move.w	d5,d2
		lsl.w	#2,d2
		ADD.w	(A5,D2.W),D1	;from TABL_PLANS table
	ENDC
	
;	move.w	d5,d2
;	lsr.w	#4,d2
;	and.w	#3,d2
;	add.w	d2,d2
;	add.w	d2,d1
	
;	move.w	d1,(a0)+		;screen offset
	move.b	d1,(a0)+		;screen offset
	
;	addq.w	#1,d0			;next pixel
		addq.w	#1,d5
	dbf		d7,.CreateTable
	
	IFNE	FASTROT_TEST2
	move.l	a1,a0
	move.l	a1,a2
	adda.l	#256*256-160,a1
	move.w	#160-1,d7
.Copy
;	move.b	(a0)+,-(a1)
	move.b	(a0)+,(a1)
;	sub.b	#80,(a1)+
	add.b	#80,(a1)+		**** this line to get rid of the NOT in the plot macro
	dbf		d7,.Copy
	
;	move.l	a2,a0
;	lea		320*2(a2),a1
;	move.w	#320-1,d7
;.Copy2
;	move.b	(a0)+,-(a1)
;	dbf		d7,.Copy2
	
	ENDC
	
	rts

;======================================

	IFNE	SCROLLER
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
	
VBL_SCROLL
	CMPI.L	#8,NB_PART
	BNE.s	SUITV0
	BSR		TEST_LET
	CLR.L	NB_PART
SUITV0
	BSR.s	SCROLL
;	BSR	SCROLL
	RTS

SCROLL	MOVE.L	ScreenPtr2,A0
	LEA	(200-8)*160(A0),A0
	LEA	BUF_LET,A1
	REPT	8
	ROXL	(A1)

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
	LEA	160(A0),A0
	ADDQ.L	#2,A1
	ENDR
	ADDI.L	#1,NB_PART
	RTS

TEST_LET	MOVEQ	#0,D0
	LEA	TEXT1,A0	
	ADDA.L	POINT,A0
	LEA	FONT8_8,A1
	CMPI.B	#$FF,(A0)
	BNE.s	SUITTST
	CLR.L	POINT
	LEA	TEXT1,A0
SUITTST	MOVE.B	(A0),D0	
	SUBI.B	#32,D0	
	LSL.W	#3,D0	
	ADDA.L	D0,A1	
	LEA	BUF_LET,A2
	MOVE.B	(A1)+,(A2)
	MOVE.B	(A1)+,2(A2)
	MOVE.B	(A1)+,4(A2)
	MOVE.B	(A1)+,6(A2)
	MOVE.B	(A1)+,8(A2)
	MOVE.B	(A1)+,10(A2)
	MOVE.B	(A1)+,12(A2)
	MOVE.B	(A1)+,14(A2)
	ADDI.L	#1,POINT
	RTS
	
	SECTION	DATA


TEXT1
 dc.b "3672 dots (27*17*8) by Zappy/HC in 2017"
 dc.b "                It's 2017 and I'm writing a fucking scroller... Against all odds, Zappy of Holocaust is back on the ST with a new screen."
 dc.b " "
 DC.B "               ",$FF

	even

	include		FONT8_8.S

	SECTION	BSS
POINT	DS.L	1
BUF_LET	DS.B	(1*8)*2
	ENDC
	
;======================================

	section data
	even

	IFNE	ZIK
YM	incbin	iss.bin
	ENDC
	
	;$FFFF8240.W	;0	0000
	;$FFFF8242.W	;1	0001	plan 1
	;$FFFF8244.W	;2	0010	plan 2
	;$FFFF8246.W	;3	0011
	;$FFFF8248.W	;4	0100	plan 3
	;$FFFF824a.W	;5	0101
	;$FFFF824c.W	;6	0110
	;$FFFF824e.W	;7	0111
	;$FFFF8250.W	;8	1000	plan 4
	;$FFFF8252.W	;9	1001
	;$FFFF8254.W	;10	1010
	;$FFFF8256.W	;11	1011
	;$FFFF8258.W	;12	1100
	;$FFFF825a.W	;13	1101
	;$FFFF825c.W	;14	1110
	;$FFFF825e.W	;15	1111
	
;Initial colors
COLOR0b	equ		$666
COLOR1b	equ		$544
COLOR2b	equ		$777
COLOR3b	equ		$655
COLOR4b	equ		$223
COLOR5b	equ		$222

;COLOR0b	equ		$555
;COLOR1b	equ		$433
;COLOR2b	equ		$777
;COLOR3b	equ		$655
;COLOR4b	equ		$223
;COLOR5b	equ		$222


_Palette2
	dc.w	COLOR5b	;$FFFF8240.W
	dc.w	COLOR0b	;$FFFF8242.W	;plane 1
	dc.w	COLOR5b	;$FFFF8244.W	;plane 2
	dc.w	COLOR2b	;$FFFF8246.W	;plane 1/2
	dc.w	COLOR4b	;$FFFF8248.W	;plane 3
	dc.w	COLOR1b	;$FFFF824a.W	;plane 1/3
	dc.w	COLOR4b	;$FFFF824c.W	;plane 2/3
	dc.w	COLOR3b	;$FFFF824e.W	;plane 1/2/3
	dc.w	COLOR0b	;$FFFF8250.W	;plane 4
	dc.w	$700	;$FFFF8252.W	;plane 1/4
	dc.w	COLOR2b	;$FFFF8254.W	;plane 2/4
	dc.w	$700	;$FFFF8256.W	;plane 1/2/4
	dc.w	COLOR1b	;$FFFF8258.W	;plane 3/4
	dc.w	$700	;$FFFF825a.W	;plane 1/3/4
	dc.w	COLOR3b	;$FFFF825c.W	;plane 2/3/4
	dc.w	$700	;$FFFF825e.W	;plane 1/2/3/4

_Palette2b
	dc.w	$222	;$FFFF8240.W
	dc.w	$777	;$FFFF8242.W
	dc.w	$777	;$FFFF8244.W
	dc.w	$777	;$FFFF8246.W
	dc.w	$223	;$FFFF8248.W	;background (plan 3)
	dc.w	$655	;$FFFF824a.W	;plan4 dot on plan3 background
	dc.w	$655	;$FFFF824c.W	;plan2 dot on plan3 background (i.e. copy dot)
	dc.w	$777	;$FFFF824e.W
	dc.w	$777	;$FFFF8250.W
	dc.w	$777	;$FFFF8252.W
	dc.w	$777	;$FFFF8254.W
	dc.w	$777	;$FFFF8256.W
	dc.w	$655	;$FFFF8258.W	;plan1 dot on plan3 background
	dc.w	$777	;$FFFF825a.W
	dc.w	$777	;$FFFF825c.W
	dc.w	$777	;$FFFF825e.W

_Palette1b
	dc.w	$123	;$FFFF8240.W
	dc.w	$777	;$FFFF8242.W
	dc.w	$777	;$FFFF8244.W
	dc.w	$777	;$FFFF8246.W
	dc.w	$123	;$FFFF8248.W	;background (plan 3)
	dc.w	$777	;$FFFF824a.W	;plan4 dot on plan3 background
	dc.w	$700	;$FFFF824c.W	;plan2 dot on plan3 background (i.e. copy dot)
	dc.w	$777	;$FFFF824e.W
	dc.w	$777	;$FFFF8250.W
	dc.w	$777	;$FFFF8252.W
	dc.w	$777	;$FFFF8254.W
	dc.w	$777	;$FFFF8256.W
	dc.w	$777	;$FFFF8258.W	;plan1 dot on plan3 background
	dc.w	$777	;$FFFF825a.W
	dc.w	$777	;$FFFF825c.W
	dc.w	$777	;$FFFF825e.W

_Palette1c
	dc.w	$123	;$FFFF8240.W
	dc.w	$555	;$FFFF8242.W	;plane 1
	dc.w	$123	;$FFFF8244.W	;plane 2
	dc.w	$777	;$FFFF8246.W	;plane 1/2
	dc.w	$123	;$FFFF8248.W	;plane 3
	dc.w	$555	;$FFFF824a.W	;plane 1/3
	dc.w	$123	;$FFFF824c.W	;plane 2/3
	dc.w	$777	;$FFFF824e.W	;plane 1/2/3
	dc.w	$555	;$FFFF8250.W	;plane 4
	dc.w	$555	;$FFFF8252.W	;plane 1/4
	dc.w	$777	;$FFFF8254.W	;plane 2/4
	dc.w	$777	;$FFFF8256.W	;plane 1/2/4
	dc.w	$555	;$FFFF8258.W	;plane 3/4
	dc.w	$555	;$FFFF825a.W	;plane 1/3/4
	dc.w	$777	;$FFFF825c.W	;plane 2/3/4
	dc.w	$777	;$FFFF825e.W	;plane 1/2/3/4

;COLOR0	equ		$666
;COLOR1	equ		$445
;COLOR2	equ		$777
;COLOR3	equ		$556
;COLOR4	equ		$223
;COLOR5	equ		$123

COLOR0	equ		$666
COLOR1	equ		$444
COLOR2	equ		$777
COLOR3	equ		$555
COLOR4	equ		$222
COLOR5	equ		$123

_Palette1
	dc.w	COLOR5	;$FFFF8240.W
	dc.w	COLOR0	;$FFFF8242.W	;plane 1
	dc.w	COLOR5	;$FFFF8244.W	;plane 2
	dc.w	COLOR2	;$FFFF8246.W	;plane 1/2
	dc.w	COLOR4	;$FFFF8248.W	;plane 3
	dc.w	COLOR1	;$FFFF824a.W	;plane 1/3
	dc.w	COLOR4	;$FFFF824c.W	;plane 2/3
	dc.w	COLOR3	;$FFFF824e.W	;plane 1/2/3
	dc.w	COLOR0	;$FFFF8250.W	;plane 4
	dc.w	$700	;$FFFF8252.W	;plane 1/4
	dc.w	COLOR2	;$FFFF8254.W	;plane 2/4
	dc.w	$700	;$FFFF8256.W	;plane 1/2/4
	dc.w	COLOR1	;$FFFF8258.W	;plane 3/4
	dc.w	$700	;$FFFF825a.W	;plane 1/3/4
	dc.w	COLOR3	;$FFFF825c.W	;plane 2/3/4
	dc.w	$700	;$FFFF825e.W	;plane 1/2/3/4

TABL_PLANS
	REPT	10
	DCB	32,0
	DCB	32,6
;	DCB	32,0
	ENDR

SrcPts:
;	INCLUDE	BUNNY.S
;	INCLUDE	DOLPHIN.S
;	INCBIN	CRV256.PTS
;	INCBIN	CRV512b.PTS
;	INCBIN	CRV512.PTS
;	INCBIN	CRV768.PTS
;	INCBIN	CRV900.PTS
;	INCBIN	CRV1024.PTS
;	INCBIN	OCT256.PTS
;	INCBIN	OCT256B.PTS
;	INCBIN	OCT288.PTS
;	INCBIN	OCT288B.PTS
;	INCBIN	OCT320.PTS
;	INCBIN	OCT352.PTS
;	INCBIN	OCT384.PTS
;	INCBIN	OCT384B.PTS
;	INCBIN	OCT416.PTS
;	INCBIN	OCT416B.PTS
;	INCBIN	OCT432.PTS
;	INCBIN	OCT448.PTS
	INCBIN	OCT459.PTS
;	INCBIN	OCT459B.PTS
;	INCBIN	OCT468.PTS
;	INCBIN	OCT480.PTS

RotatedFrame	dc.l	0,0,0,0,0,0,0,0,0
Frame			dc.w	0,0,0,0,0,0,0,0,0

SinTable	INCBIN	SIN.LUT		;TODO: generate

	section bss
	even

StartBSS:

	IFNE	FASTROT_CLEAR_SAVED_POS
PtsClrOffsets	ds.w	NB_PTS*2
ClrOffsetsPtr1	ds.l	1
ClrOffsetsPtr2	ds.l	1
	ENDC

	IFNE	FASTROT_TEST7	
ClearCodgen		ds.b	5000
	ENDC
	
_SaveA7			ds.l	1

	IFNE	FASTROT_TEST4
UsedX			ds.b	NB_PTS
UsedY			ds.b	NB_PTS
UsedZ			ds.b	NB_PTS
InterpolateCodgenX	ds.b	2000
InterpolateCodgenY	ds.b	2000
InterpolateCodgenZ	ds.b	2000
	ENDC

TmpBufferXZ		ds.w	NB_PTS*2
TmpBufferY		ds.w	NB_PTS
TmpBufferPts	ds.w	NB_PTS*3

RotatedX		ds.w	NB_INTERPOLATED*FASTROT_NB_COORDS
RotatedY		ds.w	NB_INTERPOLATED*FASTROT_NB_COORDS
RotatedZ		ds.w	NB_INTERPOLATED*FASTROT_NB_COORDS

	IFNE	FASTROT_TEST5
RotatedXxPtr	ds.l	1	
RotatedYxPtr	ds.l	1	
RotatedYyPtr	ds.l	1	
RotatedZxPtr	ds.l	1	
RotatedZyPtr	ds.l	1	
PreRotatedXPos	ds.w	NB_INTERPOLATED*FASTROT_TABLE_SIZE*EXTRA_SIZE
PreRotatedXNeg	ds.w	NB_INTERPOLATED*FASTROT_TABLE_SIZE*EXTRA_SIZE
PreRotatedYPos	ds.w	NB_INTERPOLATED*FASTROT_TABLE_SIZE*EXTRA_SIZE
PreRotatedYNeg	ds.w	NB_INTERPOLATED*FASTROT_TABLE_SIZE*EXTRA_SIZE
;PreRotatedMulsT	ds.w	FASTROT_TABLE_SIZE
	ENDC

MulsTable		ds.w	MULS_TABLE_SIZE

;PixelTable2		ds.w	SINGLE_PIXEL_TABLE_SIZE

PixelTable2bAddy	ds.l	1
	IFNE	FASTROT_TEST2
				ds.b	256*256
	ENDC
PixelTable2b	ds.b	320
	IFNE	FASTROT_TEST2
				ds.b	256*256
	ENDC

	IFNE	FASTROT_TEST6
PixelTablePlanOffset	ds.l	1	
PixelTablePlan2Addy	ds.l	1
				ds.b	256*256
PixelTablePlan2	ds.b	320
				ds.b	256*256
				
PixelTablePlan3Addy	ds.l	1
				ds.b	256*256
PixelTablePlan3	ds.b	320
				ds.b	256*256

PixelTablePlan4Addy	ds.l	1
				ds.b	256*256
PixelTablePlan4	ds.b	320
				ds.b	256*256	
	ENDC


Matrix			ds.w	9

	IFNE	FASTROT_TEST3
				ds.b	256*256
ScreenBuffer	ds.b	256*256*2
ScreenPtr1		ds.l	1
ScreenPtr2		ds.l	1
	ELSE
				ds.b	256
ScreenBuffer	ds.b	32000*2
ScreenPtr1		ds.l	1
ScreenPtr2		ds.l	1
	ENDC
	
FrameCounter	ds.l	1

	IFNE	FASTROT_CODGEN2
;FastrotCodgen2	ds.b	46000
FastrotCodgen2	ds.b	80000
	ENDC
	
SavedEnv		ds.l	SAVED_ENV_DWORD_SIZE

	IFNE	ZIK
SongDataPtr		ds.l	1
NbFrames		ds.l	1
CurrentFrame	ds.l	1
	ENDC

	IFNE	SYM_TABLE
SymTable	ds.w	65536
	ENDC

VBL_Flag		ds.w	1
DEBUG_Flag		ds.w	1

EndBSS:

