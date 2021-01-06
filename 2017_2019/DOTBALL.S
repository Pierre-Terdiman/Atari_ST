;Dotball
;Fastrot special case where all points are in the +++ octant (so there's no need to test signs or sort dots
;or generate code or anything)
;The remaining dots in other quadrants are all implicit and derived at plot time from the +++ data.
;We do compute the Z here to make a classical "culled" dotball.
;Doesn't cut the ball into slices etc so that would work fine for other symmetrical objects.
;Total number of dots on screen is only NB_BALL_PTS*4 (as opposed to the usual *8, half of them are hidden).
;It's ok but this one misses a lot of tricks and isn't super optimized (it still loops over vertices with a regular loop, etc)

;	opt	o+,a+
	opt	o+
;	opt	p+

SIN_TABLE_SIZE	=	1024

FRAME_SIZE		=		80
NB_INTERPOLATED	=		80

;NB_BALL_PTS		= 90
NB_BALL_PTS		= 128
;NB_BALL_PTS		= 100
;NB_BALL_PTS		= 64

FASTROT_DEBUG			= 0	;Include/compile code to render interpolated vectors
FASTROT_USE_HACK		= 0	;Make interpolation faster by skipping odd vectors
FASTROT_COMPUTE_Z		= 1	;Compute Z or not. Faster without but some effects require Z.
FASTROT_INTERNAL_SCALE	= 0	;See FASTROT_NOTE2
FASTROT_LOW_ACCURACY	= 0	;Accuracy vs speed.
FASTROT_INTERP_MULTABLE	= 0	;Only compatible with FASTROT_LOW_ACCURACY
FASTROT_ROTA_XY			= 1	;No Z in rotation matrix = skip some work in interpolation code

FASTROT_INIT_VERSION0	= 0
FASTROT_VERSION0		= 0

	IFNE	FASTROT_COMPUTE_Z
FASTROT_NB_COORDS		= 3
	ELSE
FASTROT_NB_COORDS		= 2
	ENDC

	IFNE	FASTROT_LOW_ACCURACY
FASTROT_ACCURACY		= 2
	ELSE
FASTROT_ACCURACY		= 4
	ENDC

	section text

	bra		Start
UTIL_CLEAR_SCREEN_1P		= 0
UTIL_CLEAR_SCREEN_4P		= 0
UTIL_ROTATE_POINTS			= 1
UTIL_600_SCREEN_ADDRESS		= 0
UTIL_CREATE_PIXEL_TABLE		= 0
UTIL_CREATE_PIXEL_TABLE2	= 0
UTIL_CREATE_MULS_TABLE		= 1

	INCLUDE		UTILS.S
	include	LIB/BSS.S
	include	LIB/ENV.S
	include	LIB/STPS.S
	include	LIB/SYS.S
	include	LIB/FROT.S

;		DC.L	1,2,3,4
;PIPO	DC.L	5,6,7,8

Start:
;	lea		PIPO,a1
;	move.l	#$12345678,d1
;	move.l	d1,-(a1)
;	move.b	(a1),d6
;	lsl.w	#$3,d6


	bsr		Lib_ClearBSS

	SwitchToSuper

	bsr		Lib_SaveEnv

	bsr		FastRot_PreprocessPts

	lea		MulsTable,a0
	bsr		CreateMulsTable

;	lea		PixelTable2,a0
;	bsr		CreateSinglePixelTable

		move.l	#PixelTable2b,d0
		move.l	d0,PixelTable2bAddy
		move.l	PixelTable2bAddy,a0
		bsr		CreateNewSinglePixelTable


	move.b	#0,$ffff8260.w	;Switch to low res

	move.w	#$2700,SR

	move.l	#ScreenBuffer,d0
	clr.b	d0
	move.l	d0,ScreenPtr1
	addi.l	#32000,d0
	move.l	d0,ScreenPtr2

	move.b	ScreenPtr1+1,$FFFF8201.w
	move.b	ScreenPtr1+2,$FFFF8203.w

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

	bsr		MainLoop

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

Vbl:
	addq.w	#1,VBL_Flag
	rte
	
VSync
	clr.w	VBL_Flag
.Wait	
	cmpi.w	#1,VBL_Flag
	bne.s	.Wait
	rts

;======================================

FlipBuffers:
	move.l	ScreenPtr1,d0
	move.l	ScreenPtr2,ScreenPtr1
	move.l	d0,ScreenPtr2

	move.b	ScreenPtr1+1,$FFFF8201.w
	move.b	ScreenPtr1+2,$FFFF8203.w
	RTS
	
;======================================

;Generate rotation matrix
GenerateRotMatrix:
	lea		SinTable,a0
	move.l	FrameCounter,d6		;'angle'
	move.l	d6,d4
;	add.w	d6,d6				;speed things up
	lsl.l	#8,d6
	divu	#67,d6
	lsl.l	#8,d4
	divu	#333,d4

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

	rts
;======================================

MainLoop:
	bsr		VSync

;	bra		.SkipThis

	move.w	#$0001,D0
	move.w	D0,$FFFF8240.W

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

	;Clear screen
Y_MARGIN	set		20
;Y_MARGIN	set		10
		moveq	#0,d0
		move.l	ScreenPtr2,a0
		adda.l	#160*Y_MARGIN,a0
;		bsr		ClearScreen_1Plane
	
		;Clears part of the screen only
		move.w	#200-Y_MARGIN*2-1,d7
.Clear
N	set		8*5
		REPT	10
		move.w	d0,N(a0)
;		move.w	d0,N+2(a0)
N	set		N+8
		ENDR
		lea		160(a0),a0
		dbf		d7,.Clear
	
	move.w	#$777,$FFFF8242.W
	move.w	#$444,$FFFF8244.W

;	move.l	ScreenPtr2,a0
;	bsr		ClearScreen_4Planes

	move.w	#$007,$FFFF8240.W
	
.SkipThis
	move.w	#$070,$FFFF8240.W
	move.w	#$030,$FFFF8240.W
	
	bsr		GenerateRotMatrix

	move.w	#$003,$FFFF8240.W

;=========================================

	bsr		FastRot_Interpolate_Version0

	move.w	#$123,$ffff8240.w

	move	#$2700,sr
	bsr		FastRot_Symmetry_Hidden_NoProj3
	move	#$2300,sr

;=========================================
	
;.SkipThis

EndFrame:
	move.w	#$700,$FFFF8240.W

;	bsr		RotationRuntime
	
	move.w	#$222,$FFFF8240.W


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

FastRot_PreprocessPts:

	;TODO: refactor this

	lea		Pts,a0
	lea		DotBallPts,a1
	move.w	#(NB_BALL_PTS*3)-1,d7
.GenBallPt2
	move.w	(a1)+,d1

	ext.l	d1		
;	divs	#32768/100,d1	;
	divs	#32768/80,d1	;
;	divs	#32768/64,d1	;
;	divs	#32768/90,d1	;
	
;	tst.w	d1
;	bge.s	.PosOrNull
;	neg.w	d1
;.PosOrNull		
	IFNE	FASTROT_USE_HACK
	and.w	#$fffe,d1	;HACK
	ENDC
	move.w	d1,(a0)+
	dbf		d7,.GenBallPt2

	lea		Pts,a0	
	lea		PtsPreca,a1
	move.w	#NB_BALL_PTS-1,d7
.PreShift
	move.w	(a0),d0
	move.w	2(a0),d1
	move.w	4(a0),d2
	mulu	#12,d0
	mulu	#12,d1
	mulu	#12,d2
;	lsl.w	#4,d0
;	lsl.w	#4,d1
;	lsl.w	#4,d2
	move.w	d0,(a0)
	move.w	d1,2(a0)
	move.w	d2,4(a0)

		lea		RotatedX,a2
		adda.w	d0,a2
		move.l	a2,(a1)+
		
		lea		RotatedY,a2
		adda.w	d1,a2
		move.l	a2,(a1)+
		
		lea		RotatedZ,a2
		adda.w	d2,a2
		move.l	a2,(a1)+

	lea		6(a0),a0
	dbf		d7,.PreShift
	rts

;======================================

;This version from previous saves, using OR.W
PlotDot43a	MACRO
	swap	d0				;x
	swap	d1				;y
	
	add.w	d0,d0			;x*2
	add.w	d0,d0			;x*4
	add.w	d1,d1			;y*2

	move.l	(a5,d0.w),d0	;a5 = pixel table
	move.w	(a4,d1.w),d1	;a4 = muls table
	
	add.w	d0,d1
	swap	d0
	or.w	d0,(a1,d1.w)
	ENDM

;This version using BSET.
;Muls table can be dropped with low accuracy interpolation.
;The rest can be optimized further using more memory/registers.
PlotDot43	MACRO
	swap	d1				;y
	add.w	d1,d1			;y*2
	move.w	(a4,d1.w),d1	;a4 = muls table
	
	swap	d0				;x
	move.b	(a5,d0.w),d7	;a5 = pixel table
	add.w	d7,d1
;	not		d0				;Not needed because of lines marked with "this line to get rid of the NOT in the plot macro"
	bset	d0,(a1,d1.w)
	ENDM

;======================================

	even
_SaveA7		ds.l	1

;======================================

;More optimized version
FastRot_Symmetry_Hidden_NoProj3:

	;This version does the symmetry, does compute Z and uses it to reject half the dots.
	move.l	a7,_SaveA7
	
_d0	equr	d0
_d1	equr	d1
_d2	equr	d2
_d3	equr	d3
_d4	equr	d4
_d5	equr	d5
_d6	equr	d6
_d7	equr	d7
_a0	equr	a0
_a1	equr	a1
_a2	equr	a2
_a3	equr	a3
_a4	equr	a4
_a5	equr	a5
_a6	equr	a6
_a7	equr	a7
	
	lea		PtsPreca,_a0
	move.l	ScreenPtr2,_a1
;	lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,_a5
	lea		MulsTable+MULS_TABLE_START_OFFSET,a4
	
		move.l	PixelTable2bAddy,_a5
		lea		160(_a5),_a5
	
	moveq	#0,d7
	move.w	#NB_BALL_PTS-1,_d7
.AffDot
	swap	d7

	movem.l	(_a0)+,_a3/_a6/_a7
	move.l	_a0,usp

	movem.l	(_a3),_d0/_a0/_a2	;d0 = 0(a3)
								;a0 = 4(a3)
								;a2 = 8(a3)

	;====
	movem.l	(_a6),_d3/_d5/_a6	;d3 = 0(a6)
								;d5 = 4(a6)
								;a6 = 8(a6)
							
	movem.l	(_a7),_d1/_d2/_d4		;d1 = 0(a7)
									;d2 = 4(a7)
									;d4 = 8(a7)
;		movem.l	(_a7),_d4/_d2/_d1
;		exg.l	_d4,_d1
		
	move.l	_d5,_d6
	add.l	_d2,_d5		;d5 = 4(a6) + 4(a7)
	sub.l	_d2,_d6		;d6 = 4(a6) - 4(a7)

	move.l	_a6,_a7
	add.l	_d4,_a6		;a6 = 8(a6) + 8(a7)
	sub.l	_d4,_a7		;a7 = 8(a6) - 8(a7)

	move.l	_d3,_d2
	add.l	_d1,_d3		;d3 = 0(a6) + 0(a7)
	sub.l	_d2,_d1		;d4 = 0(a7) - 0(a6)
	move.l	_d1,_d4	*** could remove by swapping d1 / d4 ?

		;create initial d0
		;add.l	_d3,_d0		;d0 = 0(a3) + 0(a6)
		;add.l	_d1,_d0		;d0 = 0(a3) + 0(a6) + 0(a7)
		;
		;add.l	_d3,_d3		;   d3 = 0(a6) * 2
		;add.l	_d1,_d1		;d1/d4 = 0(a7) * 2
		;move.l	_d1,_d4	*** could remove by swapping d1 / d4 ?

	;====
						;d0 = 0(a3)
	move.l	_d0,_a3		;a3 = 0(a3)	saved for restoring _d0 below (3 times). Only used for d0 / X.
	move.l	_a0,_d1		;d1 = 4(a3) saved for restoring _d1 below (3 times)
	
	add.l	_d3,_d0		;d0 = 0(a3) + 0(a6) + 0(a7)
	add.l	_d5,_d1		;d1 = 4(a3) + 4(a6) + 4(a7)

	move.l	_a2,_d2		;d2 = 8(a3)
	add.l	_a6,_d2		;d2 = 8(a3) + 8(a6) + 8(a7)
	blt.s	.New3b
	neg.l	_d0
	neg.l	_d1
.New3b
	PlotDot43

	;====

	move.l	_a3,_d0		;d0 = 0(a3)
;		swap	d0		;d0 = 0(a3) + 0(a6) + 0(a7)
	move.l	_a0,_d1		;d1 = 4(a3)
	
	add.l	_d4,_d0		;d0 = 0(a3) - 0(a6) + 0(a7)	
;		sub.l	_d3,_d0	;d0 = 0(a3) - 0(a6) + 0(a7)	
	sub.l	_d6,_d1		;d1 = 4(a3) - 4(a6) + 4(a7)

	cmp.l	_a7,_a2
	blt.s	.New2b
	neg.l	_d0
	neg.l	_d1
.New2b
	PlotDot43

;	bra.s	.skipall

	;====

	move.l	_a3,_d0		;d0 = 0(a3)
;		swap	d0		;d0 = 0(a3) - 0(a6) + 0(a7)	
	move.l	_a0,_d1		;d1 = 4(a3)
	
	sub.l	_d3,_d0		;d0 = 0(a3) - 0(a6) - 0(a7)
;		sub.l	_d4,_d0	;d0 = 0(a3) - 0(a6) - 0(a7)
	sub.l	_d5,_d1		;d1 = 4(a3) - 4(a6) - 4(a7)

	cmp.l	_a6,_a2
	blt.s	.New0b
	neg.l	_d0
	neg.l	_d1
.New0b
	PlotDot43

	;====

	move.l	_a3,_d0		;d0 = 0(a3)
;		swap	d0		;d0 = 0(a3) - 0(a6) - 0(a7)
	move.l	_a0,_d1		;d1 = 4(a3)
	
	sub.l	_d4,_d0		;d0 = 0(a3) + 0(a6) - 0(a7)
;		add.l	_d3,_d0	;d0 = 0(a3) + 0(a6) - 0(a7)	
	add.l	_d6,_d1		;d1 = 4(a3) + 4(a6) - 4(a7)
	
	move.l	_a2,_d2		;d2 = 8(a3)
	add.l	_a7,_d2		;d2 = 8(a3) + 8(a6) - 8(a7)
	blt.s	.New1b
	neg.l	_d0
	neg.l	_d1
.New1b
	PlotDot43

	;====
.skipall
	move.l	usp,_a0
	
	swap	d7
	dbf		_d7,.AffDot

	move.l	_SaveA7,a7
	rts

;======================================

CreateNewSinglePixelTable:
	moveq	#3,d3
	moveq	#4,d4
	moveq	#0,d1
	moveq	#0,d0			;x value
		move.w	#320,d0		;next pixel	**** this line to get rid of the NOT in the plot macro
	move.w	#320-1,d7		;table valid for 320 pixels
.CreateTable
		subq.w	#1,d0		;next pixel	**** this line to get rid of the NOT in the plot macro
	move.w	d0,d1
	lsr.w	d4,d1
	lsl.w	d3,d1

	move.w	d0,d2
	and.w	#15,d2
	cmp.w	#7,d2
	ble.s	.nu
	addq.w	#1,d1
.nu	

	move.b	d1,(a0)+		;screen offset
;		addq.w	#1,d0		;next pixel
	dbf		d7,.CreateTable
	rts

;======================================

	section data
	even

PixelTable2bAddy	ds.l	1
PixelTable2b	ds.b	320


RotatedFrame	dc.l	0,0,0,0,0,0,0,0,0
Frame			dc.w	FRAME_SIZE,0,0,0,FRAME_SIZE,0,0,0,FRAME_SIZE

SinTable	INCBIN	SIN.LUT		;TODO: generate

;DotBallPts	INCBIN	DOTBALL.PTS
;DotBallPts	INCBIN	DOTBALL2.PTS
;DotBallPts	INCBIN	DTBL100A.PTS
;DotBallPts	INCBIN	DTBL100D.PTS
DotBallPts	INCBIN	DTBL128A.PTS
;DotBallPts	INCBIN	DTBL100B.PTS
	
	section bss
	even

StartBSS:
Pts				ds.w	NB_BALL_PTS*3		;x y z
PtsPreca		ds.l	NB_BALL_PTS*3

RotatedX		ds.l	NB_INTERPOLATED*3
RotatedY		ds.l	NB_INTERPOLATED*3
RotatedZ		ds.l	NB_INTERPOLATED*3

MulsTable		ds.w	MULS_TABLE_SIZE

;PixelTable2		ds.w	SINGLE_PIXEL_TABLE_SIZE

				ds.l	2	;###TEST
Matrix			ds.w	9

				ds.b	256
ScreenBuffer	ds.b	32000*2
ScreenPtr1		ds.l	1
ScreenPtr2		ds.l	1

FrameCounter	ds.l	1

SavedEnv		ds.l	SAVED_ENV_DWORD_SIZE

VBL_Flag		ds.w	1

EndBSS:

