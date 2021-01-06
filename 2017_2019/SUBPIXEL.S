
;Subpixel tests
;Another (unrelated) interesting idea in here is to flip the quad's
;triangulation at runtime, always using the one that is faster to draw.

;	opt	o+,a+
	opt	o+
;	opt	p+

	section text
	
	bra		Start
UTIL_CLEAR_SCREEN_1P		= 1
UTIL_CLEAR_SCREEN_4P		= 1
UTIL_ROTATE_POINTS			= 0
UTIL_600_SCREEN_ADDRESS		= 0
UTIL_CREATE_PIXEL_TABLE		= 0
UTIL_CREATE_PIXEL_TABLE2	= 0
UTIL_CREATE_MULS_TABLE		= 0

FILLER_TABLE_SIZE			=	256

	INCLUDE		UTILS.S
	include	LIB/BSS.S
	include	LIB/SYS.S
	include	LIB/ENV.S
	include	LIB/STPS.S

;;;;;;;;;;;;;;;

FILLER_BSS		SET 0
FILLER_DATA		SET 0
FILLER_TEXT		SET 1
	include		poly.s

;;;;;;;;;;;;;;;

;Ceil_Regular	MACRO
;	tst.b	\1
;	beq.s	.null\@
;	add.w	#256,\1
;	clr.b	\1
;.null\@
;	ENDM

;MyCeil256b	MACRO
;	tst.b	\1
;	sne		\2
;	add.w	\2,\1
;	clr.b	\1
;	ENDM

Start:
;	moveq	#0,d0
;	moveq	#0,d3
;	move.w	#$ffff,d7
;.LL
;	move.w	d0,d1
;	Ceil_Regular	d1
;
;	move.w	d0,d2
;	MyCeil256b	d2,d3
;	
;	cmp.w	d1,d2
;	beq.s	.ok
;	illegal
;.ok
;	addq.w	#1,d0
;	dbf		d7,.LL	

;	moveq	#0,d0
;	moveq	#0,d1
;
;	move.w	#$1ff,d0
;	tst.b	d0
;	sne		d1
;	add.w	d1,d0
;	clr.b	d0
;
;
;	move.w	#$100,d0
;	tst.b	d0
;	sne		d1
;	add.w	d1,d0
;	clr.b	d0
;
;
;		
;	move.w	#$100,d0
;	tst.b	d0
;	sne		d1
;	add.w	d1,d1
;	clr.b	d1
;	clr.b	d0
;	add.w	d1,d0
;
;	move.w	#$101,d0
;	tst.b	d0
;	sne		d1
;	add.w	d1,d1
;	clr.b	d1
;	clr.b	d0
;	add.w	d1,d0

;	move.w	d4,$1234(a0)

;	move.w	#$1234,d1	323c
;	move.w	#$1234,d2	343c
;	move.w	#$1234,d6	3c3c
;	move.w	#$1234,d7	3e3c

;	or.w	#$1234,42(a0)
;	or.w	#$1234,(a0)

;	add.w	#$1234,42(a0)
;	add.w	#$1234,(a0)

;	move.w	#16,d0
;	move.w	#320-1,d7
;.loop
;	move.w	d0,d5
;	lsr.w	#4,d5
;	lsl.w	#3,d5
;	move.w	d0,d6
;	and.w	#~15,d6
;	lsr.w	#1,d6
;	cmp.w	d5,d6
;	beq.s	.same
;	illegal
;.same	
;	addq.w	#1,d0
;	dbf		d7,.loop	

	bsr		Lib_ClearBSS

	SwitchToSuper

	bsr		Lib_SaveEnv

	move.l	#ScreenBuffer,d0
	clr.b	d0
	move.l	d0,ScreenPtr1
	addi.l	#32000,d0
	move.l	d0,ScreenPtr2

	;Background trame 
;	move.l	ScreenPtr1,a0
;	move.l	ScreenPtr2,a1
;	move.w	#$aaaa,d0
;	move.l	#200-1,d7
;.SetPlan4
;N	set		0
;	REPT	20
;		move.w	d0,6+N(a0)
;		move.w	d0,6+N(a1)
;N	set		N+8
;	ENDR
;	not.w	d0
;	lea		160(a0),a0
;	lea		160(a1),a1
;	dbf		d7,.SetPlan4

	jsr		InitFiller

;	bra.s	NoDebug
Debug:
;	move.l	ScreenPtr2,a1
;;	move.w	#42,d6
;;	move.w	#0,d6
;	move.w	#4,d6
;	lsl.w	#8,d6
;;	move.w	#100,d7
;;	move.w	#42+15,d7
;;	move.w	#42+16,d7
;;	move.w	#15+1,d7
;	move.w	#4+16+16,d7
;	lsl.w	#8,d7
;	adda.w	#160*20,a1
;	LEA		TABL2,A2
;	bra	StartSpan

NoDebug:

;	move.l	#92,d0
;	move.l	d0,FrameCounter

Debug2:
;		lea		PolyData,a0
;		move.l	FrameCounter,d0
;	;		move.l	#100,d0
;		and.w	#2047,d0
;		;mulu	#12,d0
;		lsl.w	#4,d0
;		add.w	d0,a0
;		
;		lea		TestPoly,a1
;		move.l	(a0),(a1)+
;		move.l	8(a0),(a1)+
;		move.l	4(a0),(a1)+
;
;		move.l	ScreenPtr2,a1
;		;jsr		PolyTest


;	move.l	#2047,FrameCounter
;	bsr	DrawCube
;	addq.l	#1,FrameCounter
;	bra.s	Debug2



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
	
	move.l	#Vbl,$70.w

	move.w	#$2300,SR

	bsr		MainLoop

;Loop:
;	bra.s	Loop

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

BREAKPOINT
	BackToUser

;Quit
	clr.w	-(sp)
	trap	#1

;======================================

Vbl:
	addq.w	#1,NB_VBL
	rte
	
VSync
	clr.w	NB_VBL
.Wait	
	cmpi.w	#1,NB_VBL
	bne.s	.Wait
	rts

;======================================

Algo			dc.w	0
Triangulation	dc.w	0
Pause			dc.w	1
Toggle			dc.w	0

Planes			dc.w	0,2,0,2,4,4
Indices			dc.w	0,4,8,12	;front
				dc.w	4,20,24,8	;right
				dc.w	20,16,28,24	;back
				dc.w	16,0,12,28	;left
				dc.w	12,8,24,28	;top
				dc.w	20,4,0,16	;bottom

;	    28+------+24		0 = ---
;	     /|     /|			1 = +--
;	    / |    / |			2 = ++-
;	   /16+---/--+20		3 = -+-
;	12+------+8 /    y   z	4 = --+
;	  | /    | /     |  /	5 = +-+
;	  |/     |/      |/		6 = +++
;	 0+------+4      *---x	7 = -++

;FadePlan1	dc.w	$000,$111,$222,$333,$444,$555,$666,$777

DrawCube:

	lea		CubeData,a0	
	move.l	FrameCounter,d0
	and.w	#2047,d0
	;mulu	#12*8,d0
	lsl.w	#5,d0
	add.l	d0,a0

	lea		Indices,a2
	lea		Planes,a3
	moveq	#6-1,d7		;6 quads
.DrawQuad
	move.w	(a2)+,d0
	move.w	(a2)+,d1
	move.w	(a2)+,d2
	move.w	(a2)+,d3
	movem.l	d7/a2/a3,-(sp)
	
	lea		TestPoly,a4
	move.l	(a0,d0.w),(a4)
	move.l	(a0,d1.w),4(a4)
	move.l	(a0,d2.w),8(a4)
	movem.l	d0-d3,-(sp)
	;move.w	#$700,$ffff8240.w
	jsr		BackfaceCulling
	;move.w	#$112,$ffff8240.w
	movem.l	(sp)+,d0-d3
	tst.w	d7
	beq		.Culled

;	lea		FadePlan1,a6
;	neg.l	d5
;	swap	d5
;	lsr.w	#8,d5
;	;lsr.w	#6,d5
;	lsr.w	#2,d5
;	add.w	d5,d5
;	add.w	d5,a6
;	cmp.w	#0,(a3)
;	bne.s	.next
;	move.w	d5,$ffff8242.w
;	bra.s	.donecolor
;.next
;	cmp.w	#2,(a3)
;	bne.s	.next2
;	move.w	d5,$ffff8244.w
;	bra.s	.donecolor
;.next2
;	move.w	d5,$ffff8248.w
;.donecolor

;	bra.s	.tri1
	move.l	(a0,d0.w),(a4)
	move.l	(a0,d1.w),4(a4)
	move.l	(a0,d2.w),8(a4)
	movem.l	d0-d3,-(sp)
	;move.w	#$700,$ffff8240.w
	jsr		FindLargestDelta
	;move.w	#$112,$ffff8240.w
	move.w	d7,d6
	movem.l	(sp)+,d0-d3

	move.l	(a0,d0.w),(a4)
	move.l	(a0,d1.w),4(a4)
	move.l	(a0,d3.w),8(a4)
	movem.l	d0-d3,-(sp)
	jsr		FindLargestDelta
	movem.l	(sp)+,d0-d3
	
	cmp.w	d6,d7
	bge.s	.tri0
	move.w	#1,Triangulation
	bra.s	.tri1
.tri0
	move.w	#0,Triangulation
.tri1


	lea		TestPoly,a4
	cmp.w	#0,Triangulation
	bne.s	.Version1
	move.l	(a0,d0.w),(a4)+
	move.l	(a0,d1.w),(a4)+
	move.l	(a0,d2.w),(a4)+
	bra.s	.Version0
.Version1
	move.l	(a0,d0.w),(a4)+
	move.l	(a0,d1.w),(a4)+
	move.l	(a0,d3.w),(a4)+
.Version0

	move.l	ScreenPtr2,a1
	add.w	(a3),a1
	movem.l	d0-d3/a0-a1,-(sp)
	;jsr		PolyTest
		lea		TestPoly,a0
		jsr		DrawTriangle
	movem.l	(sp)+,d0-d3/a0-a1

	lea		TestPoly,a4
	cmp.w	#0,Triangulation
	bne.s	.Version1b
	move.l	(a0,d0.w),(a4)+
	move.l	(a0,d2.w),(a4)+
	move.l	(a0,d3.w),(a4)+
	bra.s	.Version0b
.Version1b
	move.l	(a0,d1.w),(a4)+
	move.l	(a0,d2.w),(a4)+
	move.l	(a0,d3.w),(a4)+
.Version0b
	
	move.l	a0,-(sp)
	;jsr		PolyTest
		lea		TestPoly,a0
		jsr		DrawTriangle
	move.l	(sp)+,a0

.Culled
	movem.l	(sp)+,d7/a2/a3
	lea		2(a3),a3
	dbf		d7,.DrawQuad
	rts

MainLoop:
	bsr		VSync

;	move.w	#$112,$FFFF8240.W
	move.w	#$111,$FFFF8240.W
;	move.w	#$777,$FFFF8242.W
;	move.w	#$700,$FFFF8244.W
;	move.w	#$070,$FFFF8246.W
	
	;move.w	#$773,$ffff8242.w
	;move.w	#$373,$ffff8244.w
	;move.w	#$337,$ffff8248.w

	;move.w	#$755,$ffff8242.w
	move.w	#$775,$ffff8242.w
	move.w	#$575,$ffff8244.w
	move.w	#$557,$ffff8248.w
	
	move.l	ScreenPtr2,a0
	moveq	#0,d0
;	bsr		ClearScreen_1Plane
;	bsr		ClearScreen_4Planes

;	bra	.pipo
	move.l	a7,usp
	move.l	a0,a7
Y_START	set	0
	lea		Y_START*160(a7),a7	
	moveq	#0,d0
	moveq	#0,d1
	
	moveq	#0,d2
	moveq	#0,d3
	
	moveq	#0,d4
	moveq	#0,d5
	
	moveq	#0,d6
	moveq	#0,d7
	
	move.l	d0,a0
	move.l	d0,a1
	
	move.l	d0,a2
	move.l	d0,a3
	
	move.l	d0,a4
	move.l	d0,a5
	
	move.l	d1,a6
N	set		40
	REPT	200-(Y_START*2)
	movem.l	d0-a6,N(a7)
	movem.l	d0-d4,N+15*4(a7)
N	set		N+160
	ENDR
	move.l	usp,a7
.pipo

;	move.l	ScreenPtr2,a1
;	move.w	#$aaaa,d0
;	move.l	#200-1,d7
;.SetPlan4
;N	set		0
;	REPT	20
;		move.w	d0,6+N(a1)
;N	set		N+8
;	ENDR
;	not.w	d0
;	lea		160(a1),a1
;	dbf		d7,.SetPlan4


	move.w	#$112,$FFFF8240.W

;	bra		.SkipDis


;	move.l	ScreenPtr1,a0
;	move.l	ScreenPtr2,a1
;	move.l	a0,a2
;	move.l	a1,a3
;
;	move.w	#$ffff,d0
;	move.w	#10-1,d7
;.Loop4
;
;	move.l	a2,a0
;	move.l	a3,a1
;
;	move.w	#200-1,d6
;.Loop5
;	move.w	d0,6(a0)
;	move.w	d0,6(a1)
;	lea		160(a0),a0
;	lea		160(a1),a1
;	dbf		d6,.Loop5
;	
;	add.l	#16,a2
;	add.l	#16,a3
;	
;	dbf		d7,.Loop4

;	bra		.SkipCube
	jsr		DrawCube
	bra		.DoneDraw
.SkipCube	


	lea		PolyData,a0
	move.l	FrameCounter,d0
;		move.l	#100,d0
	and.w	#2047,d0
	;mulu	#12,d0
	lsl.w	#4,d0
	add.w	d0,a0
	move.l	a0,-(sp)
	
	lea		TestPoly,a1
	cmp.w	#0,Triangulation
	bne.s	.Version1
	move.l	(a0),(a1)+
	move.l	8(a0),(a1)+
	move.l	4(a0),(a1)+
	bra.s	.Version0
.Version1
	move.l	(a0),(a1)+
	move.l	12(a0),(a1)+
	move.l	4(a0),(a1)+
.Version0
	move.l	ScreenPtr2,a1
	jsr		PolyTest

	move.l	(sp)+,a0
	
	lea		TestPoly,a1
	cmp.w	#0,Triangulation
	bne.s	.Version1b
	move.l	(a0),(a1)+
	move.l	12(a0),(a1)+
	move.l	8(a0),(a1)+
	bra.s	.Version0b
.Version1b
	move.l	4(a0),(a1)+
	move.l	12(a0),(a1)+
	move.l	8(a0),(a1)+
.Version0b
	move.l	ScreenPtr2,a1
	jsr		PolyTest


.DoneDraw
;		move.w	#-1,d0
;		move.l	ScreenPtr2,a1
;		adda.l	#160*150,a1
;N	SET	0
;		REPT	20
;		move.w	d0,N(a1)
;N	SET	N+8
;		ENDR		

	bsr		FlipBuffers

	tst.w	Pause
	bne.s	.Paused
	addq.l	#1,FrameCounter
	;cmpi.l	#2047,FrameCounter
	;bne.s	.Paused
	;clr.l	FrameCounter
.Paused

	cmp.w	#1,Toggle
	bne.s	.CanPauseAgain
	cmpi.b	#$3b,$fffffc02.w
	beq.s	.SkipKeyStuff
	cmpi.b	#$3c,$fffffc02.w
	beq.s	.SkipKeyStuff
	cmpi.b	#$3d,$fffffc02.w
	beq.s	.SkipKeyStuff
	move.w	#0,Toggle
	
.CanPauseAgain
	cmpi.b	#$3b,$fffffc02.w
	bne.s	.NoF1
	moveq	#1,d0
	sub.w	Pause,d0
	move.w	d0,Pause
	move.w	#1,Toggle
.NoF1

.CanF2Again
	cmpi.b	#$3c,$fffffc02.w
	bne.s	.NoF2
	moveq	#1,d0
	sub.w	Triangulation,d0
	move.w	d0,Triangulation
	move.w	#1,Toggle
.NoF2

.CanSwitchAgain
	cmpi.b	#$3d,$fffffc02.w
	bne.s	.NoF3
	moveq	#1,d0
	sub.w	Algo,d0
	move.w	d0,Algo
	move.w	#1,Toggle
.NoF3
.SkipKeyStuff


;	cmpi.b	#$f,$fffffc02.w
;	bne.s	.NoTab
	move.w	#$222,$FFFF8240.W
;.NoTab

	cmpi.b	#$39,$fffffc02.w
 	bne.s	.EndVBL
; 	move.w	#$4e71,Loop	;Replace bra with nop to fallback to Quit
	rts
.EndVBL:
	bra		MainLoop
	
InterRTE:
	rte

;======================================

FlipBuffers:
	move.l	ScreenPtr1,d0
	move.l	ScreenPtr2,ScreenPtr1
	move.l	d0,ScreenPtr2

	move.b	ScreenPtr1+1,$FFFF8201.w
	move.b	ScreenPtr1+2,$FFFF8203.w
	RTS

;======================================

	section data
	even

;;;;;;;;;;;;;;;
FILLER_BSS		SET 0
FILLER_DATA		SET 1
FILLER_TEXT		SET 0
	include		poly.s	
;;;;;;;;;;;;;;;

PolyData	incbin	poly.dat
CubeData	incbin	cube.dat

	section bss
	even

StartBSS:

;;;;;;;;;;;;;;;
FILLER_BSS		SET 1
FILLER_DATA		SET 0
FILLER_TEXT		SET 0
	include		poly.s	
;;;;;;;;;;;;;;;

				ds.b	256
ScreenBuffer	ds.b	32000*2
ScreenPtr1		ds.l	1
ScreenPtr2		ds.l	1

SavedEnv		ds.l	SAVED_ENV_DWORD_SIZE

FrameCounter	ds.l	1

NB_VBL			ds.w	1

EndBSS:

