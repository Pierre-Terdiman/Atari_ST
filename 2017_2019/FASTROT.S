;Fastrot - generic version (no symmetry or anything, really rotates and plots all the dots)
;But it uses generated code to speed things up.

;	opt	o+,a+
	opt	o+
;	opt	p+

SIN_TABLE_SIZE			= 1024
;FRAME_SIZE				= 50
FRAME_SIZE				= 38
NB_INTERPOLATED			= 80
;NB_PTS					= 453
;NB_PTS					= 257
;NB_PTS					= 768
;NB_PTS					= 900
NB_PTS					= 1024

FASTROT_DEBUG			= 0	;Include/compile code to render interpolated vectors
FASTROT_USE_HACK		= 0	;Make interpolation faster by skipping odd vectors - doesn't work well
FASTROT_COMPUTE_Z		= 0	;Compute Z or not. Faster without but some effects require Z.
FASTROT_INTERNAL_SCALE	= 1	;See FASTROT_NOTE2
FASTROT_LOW_ACCURACY	= 1	;Accuracy vs speed.
FASTROT_INTERP_MULTABLE	= 1	;Only compatible with FASTROT_LOW_ACCURACY		TODO: comment these better
FASTROT_ROTA_XY			= 1	;No Z in rotation matrix = skip some work in interpolation code

FASTROT_INIT_VERSION0	= 0
FASTROT_VERSION0		= 0

FASTROT_CLEAR_SAVED_POS	= 0
FASTROT_BIG_TABLE		= 0
FASTROT_CODGEN			= 1	;TODO: why is this needed?
FASTROT_CODGEN2			= 1
FASTROT_TEST			= 1
FASTROT_TEST2			= 1
FASTROT_TEST3			= 1

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
UTIL_ROTATE_POINTS			= 0
UTIL_600_SCREEN_ADDRESS		= 0
UTIL_CREATE_PIXEL_TABLE		= 1	;FASTROT_BIG_TABLE => we still need to include this for the plot macro
UTIL_CREATE_PIXEL_TABLE2	= 0
UTIL_CREATE_MULS_TABLE		= 1

	INCLUDE		UTILS.S
	include	LIB/BSS.S
	include	LIB/ENV.S
	include	LIB/STPS.S
	include	LIB/SYS.S
ROTA_SPECIAL	=	1
	include	LIB/ROTA.S
	include	LIB/FROT.S

Start:
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
	
	bsr		InitPts2

	lea		MulsTable,a0
	bsr	CreateMulsTable

	IFNE	FASTROT_BIG_TABLE
		lea		PixelTable2,a0
		bsr		CreateSinglePixelTable
	ENDC
	
		move.l	#PixelTable2b,d0
	IFNE	FASTROT_TEST2
		clr.w	d0
	ENDC
		move.l	d0,PixelTable2bAddy
;		lea		PixelTable2b,a0
		move.l	PixelTable2bAddy,a0
		bsr		CreateNewSinglePixelTable

	IFNE	FASTROT_CLEAR_SAVED_POS
		move.l	#PtsClrOffsets,d0
		move.l	d0,ClrOffsetsPtr1
		addi.l	#NB_PTS*2,d0
		move.l	d0,ClrOffsetsPtr2
	ENDC

	IFNE	FASTROT_BIG_TABLE
		bsr	CreateBigBruteForceTable
	ENDC

	IFNE	FASTROT_CODGEN
		lea		FastrotCodgen,a0
		bsr		GenerateFastrotCode
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
	IFNE	FASTROT_TEST3
;	subi.l	#1280*12,d0
;	subi.l	#1280*5,d0
	ENDC
	lsr.l	#8,d0
;	move.l	#$ffff8201,a0
	move.w	#$8201,a0
	movep.w	d0,(a0)

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

	move.w	#$0001,D0
	move.w	D0,$FFFF8240.W

	IFEQ	FASTROT_CLEAR_SAVED_POS

Y_MARGIN	set		20
;Y_MARGIN	set		10
		moveq	#0,d0
		move.l	ScreenPtr2,a0
;		bsr		ClearScreen_1Plane
	
		;Clears part of the screen only
;		adda.l	#160*Y_MARGIN,a0
;		move.w	#200-Y_MARGIN*2-1,d7
;.Clear
;N		set		8*5
;		REPT	10
;			move.w	d0,N(a0)
;;			move.w	d0,N+2(a0)
;N		set		N+8
;		ENDR
;		lea		160(a0),a0
;		dbf		d7,.Clear

		;Clears part of the screen only
;		move.w	#$8080,d0
		adda.l	#160*Y_MARGIN,a0
		move.w	#200-Y_MARGIN*2-1,d7
.Clear
N		set		8*5
		REPT	10
			move.w	d0,N(a0)
N		set		N+8
		ENDR
		lea		160(a0),a0
		dbf		d7,.Clear
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
			
	move.w	#$777,$FFFF8242.W
	move.w	#$444,$FFFF8244.W


;	move.l	ScreenPtr2,a0
;	bsr		ClearScreen_4Planes

	move.w	#$030,$FFFF8240.W
	bsr		GenerateRotMatrix
	move.w	#$003,$FFFF8240.W

;=========================================

	bsr		FastRot_Interpolate_Version0

	move.w	#$123,$ffff8240.w

	move.w	#$2700,sr
	bsr		FastRot2
	move.w	#$2300,sr
	
;=========================================
.SkipAll
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
PPP	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a3),d0-1
		move.w	(a3)+,d0	2
		move.w	(a3),d1		2
		add.w	(a6)+,d0	2
		add.w	(a6),d1		2
		add.w	(a7)+,d0	2
		add.w	(a7),d1		2
		IFNE	FASTROT_BIG_TABLE
		PlotDotNoProj8BT
		ELSE
		PlotDotNoProj8
		ENDC

;		move.l	(a3),d0		3
;		add.l	(a6),d0		4
;		add.l	(a7),d0		4
;		PlotDotNoProj8xy	+2
	ELSE
		move.l	(a3)+,d0
		move.l	(a3),d1
		
		add.l	(a6)+,d0
		add.l	(a6),d1
		
		add.l	(a7)+,d0
		add.l	(a7),d1
		
		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

PPN	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a3),d0-1
		move.w	(a3)+,d0
		move.w	(a3),d1
		add.w	(a6)+,d0
		add.w	(a6),d1
		sub.w	(a7)+,d0
		sub.w	(a7),d1
		PlotDotNoProj8

;		move.l	(a3),d0
;		add.l	(a6),d0
;		sub.l	(a7),d0
;		PlotDotNoProj8xy
	ELSE
		move.l	(a3)+,d0
		move.l	(a3),d1
		
		add.l	(a6)+,d0
		add.l	(a6),d1
		
		sub.l	(a7)+,d0
		sub.l	(a7),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

PNP	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a3),d0-1
		move.w	(a3)+,d0
		move.w	(a3),d1
		sub.w	(a6)+,d0
		sub.w	(a6),d1
		add.w	(a7)+,d0
		add.w	(a7),d1
		PlotDotNoProj8

;		move.l	(a3),d0
;		sub.l	(a6),d0
;		add.l	(a7),d0
;		PlotDotNoProj8xy
	ELSE
		move.l	(a3)+,d0
		move.l	(a3),d1
		
		sub.l	(a6)+,d0
		sub.l	(a6),d1
		
		add.l	(a7)+,d0
		add.l	(a7),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

PNN	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a3),d0-1
		move.w	(a3)+,d0
		move.w	(a3),d1
		sub.w	(a6)+,d0
		sub.w	(a6),d1
		sub.w	(a7)+,d0
		sub.w	(a7),d1
		PlotDotNoProj8

;		move.l	(a3),d0
;		sub.l	(a6),d0
;		sub.l	(a7),d0
;		PlotDotNoProj8xy
	ELSE
		move.l	(a3)+,d0
		move.l	(a3),d1
		
		sub.l	(a6)+,d0
		sub.l	(a6),d1
		
		sub.l	(a7)+,d0
		sub.l	(a7),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NPP	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a6),d0-1
		move.w	(a6)+,d0
		move.w	(a6),d1
		sub.w	(a3)+,d0
		sub.w	(a3),d1
		add.w	(a7)+,d0
		add.w	(a7),d1
		PlotDotNoProj8

;		move.l	(a6),d0
;		sub.l	(a3),d0
;		add.l	(a7),d0
;		PlotDotNoProj8xy
	ELSE
;		move.l	(a3)+,d0
;		move.l	(a3),d1
;		neg.l	d0
;		neg.l	d1
	
;		add.l	(a6)+,d0
;		add.l	(a6),d1

			move.l	(a6)+,d0
			move.l	(a6),d1
		
			sub.l	(a3)+,d0
			sub.l	(a3),d1
	
		add.l	(a7)+,d0
		add.l	(a7),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NPN	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a6),d0-1
		move.w	(a6)+,d0
		move.w	(a6),d1
		sub.w	(a3)+,d0
		sub.w	(a3),d1
		sub.w	(a7)+,d0
		sub.w	(a7),d1
		PlotDotNoProj8

;		move.l	(a6),d0
;		sub.l	(a3),d0
;		sub.l	(a7),d0
;		PlotDotNoProj8xy
	ELSE
;		move.l	(a3)+,d0
;		move.l	(a3),d1
;		neg.l	d0
;		neg.l	d1
;	
;		add.l	(a6)+,d0
;		add.l	(a6),d1

			move.l	(a6)+,d0
			move.l	(a6),d1

			sub.l	(a3)+,d0
			sub.l	(a3),d1
	
		sub.l	(a7)+,d0
		sub.l	(a7),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NNP	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a7),d0-1
		move.w	(a7)+,d0
		move.w	(a7),d1
		sub.w	(a6)+,d0
		sub.w	(a6),d1
		sub.w	(a3)+,d0
		sub.w	(a3),d1
		PlotDotNoProj8

;		move.l	(a7),d0
;		sub.l	(a6),d0
;		sub.l	(a3),d0
;		PlotDotNoProj8xy
	ELSE
;		move.l	(a3)+,d0
;		move.l	(a3),d1
;		neg.l	d0
;		neg.l	d1
	
;		sub.l	(a6)+,d0
;		sub.l	(a6),d1
	
;		add.l	(a7)+,d0
;		add.l	(a7),d1

			move.l	(a7)+,d0
			move.l	(a7),d1

			sub.l	(a6)+,d0
			sub.l	(a6),d1

			sub.l	(a3)+,d0
			sub.l	(a3),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NNN	MACRO
	movem.l	(a0)+,a3/a6/a7
	IFNE	FASTROT_LOW_ACCURACY
;		movem.w	(a3),d0-1
		move.w	(a3)+,d0
		move.w	(a3),d1
		neg.w	d0
		neg.w	d1
		sub.w	(a6)+,d0
		sub.w	(a6),d1
		sub.w	(a7)+,d0
		sub.w	(a7),d1
		PlotDotNoProj8

;		move.l	(a3),d0
;		neg.l	d0
;		sub.l	(a6),d0
;		sub.l	(a7),d0
;		PlotDotNoProj8xy
	ELSE
		move.l	(a3)+,d0
		move.l	(a3),d1
		neg.l	d0
		neg.l	d1
		
		sub.l	(a6)+,d0
		sub.l	(a6),d1
		
		sub.l	(a7)+,d0
		sub.l	(a7),d1

		PlotDotNoProj16
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

	IFNE	FASTROT_CODGEN
PPPBlock
	PPP
PPNBlock
	PPN
PNPBlock
	PNP
PNNBlock
	PNN
NPPBlock
	NPP
NPNBlock
	NPN
NNPBlock
	NNP
NNNBlock
	NNN
LastBlock

CopyBlock:
.Loop
	cmp.l	a1,a2
	beq.s	.Done
	move.b	(a1)+,(a0)+
	bra.s	.Loop
.Done	
	rts

BlockAddresses
	dc.l	PPPBlock
	dc.l	PPNBlock
	dc.l	PNPBlock
	dc.l	PNNBlock
	dc.l	NPPBlock
	dc.l	NPNBlock
	dc.l	NNPBlock
	dc.l	NNNBlock
	dc.l	LastBlock

;a0 = dest buffer
GenerateFastrotCode:
	lea		JumpTable,a4
	lea		_Counters,a3
	lea		BlockAddresses,a5
	moveq	#8-1,d6
.NextOctant
	move.l	a0,(a4)+
	move.w	(a3)+,d7
	beq.s	.OctantDone
	subq.w	#1,d7
	move.w	#$4e67,(a0)+	;move.l	a7,usp
.NextDot
	move.l	(a5),a1
	move.l	4(a5),a2
	bsr		CopyBlock
	dbf		d7,.NextDot
	move.w	#$4e6f,(a0)+	;move.l	usp,a7
.OctantDone
	move.w	#$4e75,(a0)+
	lea		4(a5),a5
	dbf		d6,.NextOctant
	rts
	ENDC

;======================================
	
	IFNE	FASTROT_CODGEN2
	
;HARDCODED for current defines, TEST	
PPP2	MACRO
;	movem.l	(a0)+,a3/a6/a7
;	move.w	(a3)+,d0
;	move.w	(a3),d1
;	add.w	(a6)+,d0
;	add.w	(a6),d1
;	add.w	(a7)+,d0
;	add.w	(a7),d1

	move.w	$1234(a3),d0	3
	move.w	$1234(a3),d1	3
;	add.w	$1234(a6),d0
;	add.w	$1234(a6),d1
	add.w	$1234(a3),d0	3
	add.w	$1234(a3),d1	3
;	add.w	$1234(a7),d0
;	add.w	$1234(a7),d1
	add.w	$1234(a3),d0	3
	add.w	$1234(a3),d1	3

	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM	
	
PPN2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	add.w	$1234(a3),d0
	add.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

PNP2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	add.w	$1234(a3),d0
	add.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

PNN2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NPP2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	add.w	$1234(a3),d0
	add.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NPN2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NNP2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM

NNN2	MACRO
	move.w	$1234(a3),d0
	move.w	$1234(a3),d1
	neg.w	d0
	neg.w	d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	sub.w	$1234(a3),d0
	sub.w	$1234(a3),d1
	PlotDotNoProj8Codgen2
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.w	d1,(a2)+
	ENDC
	ENDM
	
PPPBlock2
	PPP2
PPNBlock2
	PPN2
PNPBlock2
	PNP2
PNNBlock2
	PNN2
NPPBlock2
	NPP2
NPNBlock2
	NPN2
NNPBlock2
	NNP2
NNNBlock2
	NNN2
LastBlock2

BlockAddresses2
	dc.l	PPPBlock2
	dc.l	PPNBlock2
	dc.l	PNPBlock2
	dc.l	PNNBlock2
	dc.l	NPPBlock2
	dc.l	NPNBlock2
	dc.l	NNPBlock2
	dc.l	NNNBlock2
	dc.l	LastBlock2

Offsets
	dc.w	2,6,10,14,18,22				;PPP2
	dc.w	2,6,10,14,18,22				;PPN2
	dc.w	2,6,10,14,18,22				;PNP2
	dc.w	2,6,10,14,18,22				;PNN2
	dc.w	10,14,2,6,18,22				;NPP2 a6 a3 a7
	dc.w	10,14,2,6,18,22				;NPN2 a6 a3 a7
	dc.w	18,22,10,14,2,6				;NNP2 7 6 3
	dc.w	2,6,10+4,14+4,18+4,22+4		;NNN2 3 6 7 special
	
;a0 = dest buffer
GenerateFastrotCode2:
	lea		JumpTable2,a4
	move.l	a4,d1
	lea		PtsPreca,a4		;a0 at runtime
	lea		_Counters,a3
	lea		Offsets,a6

	lea		BlockAddresses2,a5
	moveq	#8-1,d6
.NextOctant

;	move.l	a0,(a4)+
	move.l	d1,a1
	move.l	a0,(a1)+
	move.l	a1,d1
	
	move.w	(a3)+,d7
	beq.s	.OctantDone
	subq.w	#1,d7
;	move.w	#$4e67,(a0)+	;move.l	a7,usp

.PPP

	move.l	a0,d0
	move.l	(a5),a1
	move.l	4(a5),a2
	bsr		CopyBlock

		move.l	d0,a1
		move.l	(a4)+,d0	;a3 at runtime = RotatedX + d0
		sub.l	#RotatedX,d0
;		move.w	d0,2(a1)
			move.w	(a6),d2
			move.w	d0,(a1,d2.w)
		addq.w	#2,d0
;		move.w	d0,6(a1)
			move.w	2(a6),d2
			move.w	d0,(a1,d2.w)
		
		move.l	(a4)+,d0	;a6 at runtime = RotatedY + d1
		sub.l	#RotatedY,d0
		add.l	#NB_INTERPOLATED*FASTROT_NB_COORDS*2,d0
;		move.w	d0,10(a1)
			move.w	4(a6),d2
			move.w	d0,(a1,d2.w)
		addq.w	#2,d0
;		move.w	d0,14(a1)
			move.w	6(a6),d2
			move.w	d0,(a1,d2.w)
		
		move.l	(a4)+,d0	;a7 at runtime = RotatedZ + d2
		sub.l	#RotatedZ,d0
		add.l	#NB_INTERPOLATED*FASTROT_NB_COORDS*2*2,d0
;		move.w	d0,18(a1)
			move.w	8(a6),d2
			move.w	d0,(a1,d2.w)
		addq.w	#2,d0
;		move.w	d0,22(a1)
			move.w	10(a6),d2
			move.w	d0,(a1,d2.w)

	dbf		d7,.PPP
;	move.w	#$4e6f,(a0)+	;move.l	usp,a7
.OctantDone
	move.w	#$4e75,(a0)+

	lea		4(a5),a5
	lea		2*6(a6),a6
	dbf		d6,.NextOctant


;		move.l	ScreenPtr2,a1
;		lea		160*100(a1),a1
;		lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
;;		lea		MulsTable+MULS_TABLE_START_OFFSET,a4
;		lea		MulsTable+200*2,a4
;		move.l	ClrOffsetsPtr2,a2
;		lea		RotatedX,a3
;		lea		JumpTable2+0,a6
;		move.l	(a6),a6
;		jsr		(a6)
;
;		lea		RotatedX,a3
;		lea		JumpTable2+4,a6
;		move.l	(a6),a6
;		jsr		(a6)


	;===
	rts
	ENDC

;======================================

FastRot2:
	IFNE	FASTROT_TEST
	move.w	#~3,d2
	ENDC
	
	move.l	a7,_SaveA7
	
	lea		PtsPreca,a0
	move.l	ScreenPtr2,a1
	IFNE	FASTROT_TEST3
		move.l	a1,d1
	ELSE
		lea		160*100(a1),a1
	ENDC
	IFNE	FASTROT_BIG_TABLE
		lea		BigBruteForceTable,a5
	ELSE
;		lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
;		lea		PixelTable2b+160*1,a5
		move.l	PixelTable2bAddy,a5
	IFNE	FASTROT_TEST2
		move.l	a5,d0
	ELSE
		lea		160(a5),a5
	ENDC
		moveq	#0,d2
	IFNE	FASTROT_TEST3
		move.w	#1280*12,d2
	ENDC
;		lea		MulsTable+MULS_TABLE_START_OFFSET,a4
		lea		MulsTable+200*2,a4
	ENDC
	IFNE	FASTROT_CLEAR_SAVED_POS
		move.l	ClrOffsetsPtr2,a2
	ENDC	

;		lea		RotatedX,a3
;		lea		RotatedY,a6
;		lea		RotatedZ,a7


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
	
	lea		_Counters+0,a3
	move.w	(a3),d7
	beq.s	.PPPDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+0,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+0,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.PPP
		PPP
		dbf		d7,.PPP
	ENDC
.PPPDone

;	bra		.NNNDone

	;===

	lea		_Counters+2,a3
	move.w	(a3),d7
	beq.s	.PPNDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.PPN
		PPN
		dbf		d7,.PPN
	ENDC
.PPNDone

;	bra		.NNNDone

	;===

	lea		_Counters+4,a3
	move.w	(a3),d7
	beq.s	.PNPDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4*2,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4*2,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.PNP
		PNP
		dbf		d7,.PNP
	ENDC
.PNPDone

;	bra		.NNNDone

	;===

	lea		_Counters+6,a3
	move.w	(a3),d7
	beq.s	.PNNDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4*3,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4*3,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.PNN
		PNN
		dbf		d7,.PNN
	ENDC
.PNNDone

;	bra		.NNNDone

	;===

	lea		_Counters+8,a3
	move.w	(a3),d7
	beq.s	.NPPDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4*4,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4*4,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.NPP
		NPP
		dbf		d7,.NPP
	ENDC
.NPPDone

	;===

	lea		_Counters+10,a3
	move.w	(a3),d7
	beq.s	.NPNDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4*5,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4*5,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.NPN
		NPN
		dbf		d7,.NPN
	ENDC
.NPNDone

	;===

	lea		_Counters+12,a3
	move.w	(a3),d7
	beq.s	.NNPDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4*6,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4*6,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.NNP
		NNP
		dbf		d7,.NNP
	ENDC
.NNPDone

	;===

	lea		_Counters+14,a3
	move.w	(a3),d7
	beq.s	.NNNDone
	IFNE	FASTROT_CODGEN
;		lea		JumpTable+4*7,a3
;		move.l	(a3),a3
;		jsr		(a3)

		lea		RotatedX,a3
		lea		JumpTable2+4*7,a6
		move.l	(a6),a6
		jsr		(a6)
;				mulu	#12,d7
;				add.w	d7,a0
	ELSE
		subq.w	#1,d7
.NNN
		NNN
		dbf		d7,.NNN
	ENDC
.NNNDone
	
	move.l	_SaveA7,a7
	rts
	
;======================================

ClearCounters:
	lea		_Counters,a0
	moveq	#0,d0
	moveq	#8-1,d7
.ClearCounters
	move.w	d0,(a0)+
	dbf		d7,.ClearCounters
	rts

CreateIndex:
	moveq	#0,d3		;Index
	
	move.w	(a1)+,d0	;x
	bge.s	.PosOrNullX
	or.w	d4,d3
.PosOrNullX
	add.w	d3,d3
	
	move.w	(a1)+,d1	;y
	bge.s	.PosOrNullY
	or.w	d4,d3
.PosOrNullY
	add.w	d3,d3

	move.w	(a1)+,d2	;z
	bge.s	.PosOrNullZ
	or.w	d4,d3
.PosOrNullZ
	rts

InitPts2:
	bsr.s	ClearCounters

	;===
	lea		_Counters,a0
	lea		SrcPts,a1
	moveq	#1,d4
	move.w	#NB_PTS-1,d7
.CreateCounters
	bsr.s	CreateIndex
	
	add.w	d3,d3
	add.w	d4,(a0,d3.w)
	dbf		d7,.CreateCounters
	
	;===
	lea		_Counters,a0
	lea		_Offsets,a1
	moveq	#0,d0
	move.w	d0,(a1)
	moveq	#7-1,d7
.CreateOffsets
	move.w	(a0)+,d0	;Counters[i]
	add.w	(a1)+,d0	;Offsets[i]
	move.w	d0,(a1)		;Offsets[i+1] = Offsets[i] + Counters[i]
	dbf		d7,.CreateOffsets
	;===
	
;	bsr		ClearCounters
	
	;===
;		lea		.Bits,a4
;		move.w	#NB_INTERPOLATED-1,d7
;		moveq	#0,d0
;.InitBits
;		move.b	d0,(a4)+
;		dbf		d7,.InitBits
;		bra		.SkipBits
;.Bits	ds.b	NB_INTERPOLATED		
;.SkipBits
		
	lea		_Offsets,a0
	lea		SrcPts,a1
;	moveq	#6,d5
	moveq	#1,d5
	moveq	#1,d4
	move.w	#NB_PTS-1,d7
.InitPts
	bsr		CreateIndex

	add.w	d3,d3
	move.w	(a0,d3.w),d6
	add.w	d5,(a0,d3.w)

	;Rescaling
	asr.w	#3,d0
	asr.w	#3,d1
	asr.w	#3,d2
	
	;Preprocessing
	move.w	d0,d0
	bge.s	.PosOrNullX
	neg.w	d0
.PosOrNullX
	move.w	d1,d1
	bge.s	.PosOrNullY
	neg.w	d1
.PosOrNullY
	move.w	d2,d2
	bge.s	.PosOrNullZ
	neg.w	d2
.PosOrNullZ

;		cmp.w	MaxValue,d0
;		blt.s	.SkipX
;		move.w	d0,MaxValue
;.SkipX

;	asr.w	#1,d0		;HACK
;	asr.w	#1,d1		;HACK
;	asr.w	#1,d2		;HACK
	
;		lea		.Bits,a4
;		move.b	#1,(a4,d0.w)
;		move.b	#1,(a4,d2.w)
	
	IFNE	FASTROT_LOW_ACCURACY
		mulu	#FASTROT_NB_COORDS*2,d0
		mulu	#FASTROT_NB_COORDS*2,d1
		mulu	#FASTROT_NB_COORDS*2,d2
	ELSE
		mulu	#FASTROT_NB_COORDS*4,d0
		mulu	#FASTROT_NB_COORDS*4,d1
		mulu	#FASTROT_NB_COORDS*4,d2
	ENDC
	
	lea		PtsPreca,a2
	mulu	#12,d6
	add.w	d6,a2

	lea		RotatedX,a3
	adda.w	d0,a3
	move.l	a3,(a2)+
		
	lea		RotatedY,a3
	adda.w	d1,a3
	move.l	a3,(a2)+
		
	lea		RotatedZ,a3
	adda.w	d2,a3
	move.l	a3,(a2)+

	dbf		d7,.InitPts

;		lea		.Bits,a4
;		move.w	#NB_INTERPOLATED-1,d7
;		moveq	#0,d1
;.CountBits
;		move.b	(a4)+,d0
;		beq.s	.NotUsed
;		addq.w	#1,d1
;.NotUsed		
;		dbf		d7,.CountBits
	rts

;MaxValue	dc.w	0

;======================================

	IFNE	FASTROT_BIG_TABLE
CreateBigBruteForceTable:

	lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
	lea		MulsTable+MULS_TABLE_START_OFFSET,a4
	lea		PixelTable2,a5
	lea		MulsTable+200*2,a4
	lea		BigBruteForceTable,a0

	moveq	#0,d1
	move.w	#256-1,d7
.LoopY

	moveq	#0,d0
	move.w	#256-1,d6
.LoopX

	move.w	d0,d2
	move.w	d1,d3

	exg.l	d2,d3

	add.w	d2,d2
	add.w	d2,d2
	add.w	d3,d3

	move.l	(a5,d2.w),d2
	move.w	(a4,d3.w),d3
	add.w	d2,d3
	swap	d2
;	or.w	d2,(a1,d3.w)
	move.w	d2,(a0)+
	move.w	d3,(a0)+

	addq.w	#1,d0
	dbf		d6,.LoopX

	addq.w	#1,d1
	dbf		d7,.LoopY
	rts
	ENDC
	
;======================================

CreateNewSinglePixelTable:
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
	
;	move.w	d1,(a0)+		;screen offset
	move.b	d1,(a0)+		;screen offset
	
;	addq.w	#1,d0			;next pixel
	dbf		d7,.CreateTable
	
	IFNE	FASTROT_TEST2
	move.l	a1,a0
	adda.l	#256*256-160,a1
	move.w	#160-1,d7
.Copy
;	move.b	(a0)+,-(a1)
	move.b	(a0)+,(a1)
;	sub.b	#80,(a1)+
	add.b	#80,(a1)+		**** this line to get rid of the NOT in the plot macro
	dbf		d7,.Copy
	ENDC
	
	rts

;======================================

	section data
	even

SrcPts:
;	INCLUDE	BUNNY.S
;	INCLUDE	DOLPHIN.S
;	INCBIN	CRV256.PTS
;	INCBIN	CRV512b.PTS
;	INCBIN	CRV512.PTS
;	INCBIN	CRV768.PTS
;	INCBIN	CRV900.PTS
	INCBIN	CRV1024.PTS

RotatedFrame	dc.l	0,0,0,0,0,0,0,0,0
Frame			dc.w	FRAME_SIZE,0,0,0,FRAME_SIZE,0,0,0,FRAME_SIZE

SinTable	INCBIN	SIN.LUT		;TODO: generate

	section bss
	even

StartBSS:

	IFNE	FASTROT_CLEAR_SAVED_POS
PtsClrOffsets	ds.w	NB_PTS*2
ClrOffsetsPtr1	ds.l	1
ClrOffsetsPtr2	ds.l	1
	ENDC

_SaveA7			ds.l	1
_Counters		ds.w	8
_Offsets		ds.w	8

PtsPreca		ds.l	NB_PTS*3

RotatedX		ds.b	NB_INTERPOLATED*FASTROT_NB_COORDS*FASTROT_ACCURACY
RotatedY		ds.b	NB_INTERPOLATED*FASTROT_NB_COORDS*FASTROT_ACCURACY
RotatedZ		ds.b	NB_INTERPOLATED*FASTROT_NB_COORDS*FASTROT_ACCURACY

MulsTable		ds.w	MULS_TABLE_SIZE

	IFNE	FASTROT_BIG_TABLE
PixelTable2		ds.w	SINGLE_PIXEL_TABLE_SIZE
	ENDC
PixelTable2bAddy	ds.l	1
	IFNE	FASTROT_TEST2
				ds.b	256*256
	ENDC
PixelTable2b	ds.b	320
	IFNE	FASTROT_TEST2
				ds.b	256*256
	ENDC

	IFNE	FASTROT_BIG_TABLE
BigBruteForceTable	ds.l	256*256
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

	IFNE	FASTROT_CODGEN
JumpTable		ds.l	8
FastrotCodgen	ds.b	40000
	ENDC

	IFNE	FASTROT_CODGEN2
JumpTable2		ds.l	8
FastrotCodgen2	ds.b	80000
	ENDC
	
SavedEnv		ds.l	SAVED_ENV_DWORD_SIZE

VBL_Flag		ds.w	1

EndBSS:

