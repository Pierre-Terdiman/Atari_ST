
	IFNE	FILLER_TEXT
TRY_DOUBLE	= 0
TRY_FLOOR	= 0
TRY_TRAME	= 0
	
	section text

	opt	o+

MyCeil	MACRO
	tst.b	\1
	beq.s	.null\@
;	clr.b	\1
	add.w	#256,\1
.null\@
;	asr.w	#8,\1
	lsr.w	#8,\1
	ENDM

MyCeil256	MACRO
	tst.b	\1
	beq.s	.null\@
	add.w	\2,\1
	clr.b	\1
.null\@
	ENDM
	
NewCeil256	MACRO
	tst.b	\1
	sne		\2
	add.w	\2,\1
	clr.b	\1
	ENDM

Floor256	MACRO
	clr.b	\1
	ENDM
	
;a4 = polygon data
;dc.w	x0_8.8		0
;dc.w	y0_8.8		2
;dc.w	x1_8.8		4
;dc.w	y1_8.8		6
;dc.w	x2_8.8		8
;dc.w	y2_8.8		10
BackfaceCulling:
	move.w	(a4),d3
	lsr.w	#1,d3
	move.w	4(a4),d0
	lsr.w	#1,d0
	sub.w	d0,d3

	move.w	2(a4),d4
	lsr.w	#1,d4
	move.w	6(a4),d0
	lsr.w	#1,d0
	sub.w	d0,d4

	move.w	8(a4),d6
	lsr.w	#1,d6
	move.w	4(a4),d0
	lsr.w	#1,d0
	sub.w	d0,d6

	move.w	$a(a4),d5
	lsr.w	#1,d5
	move.w	6(a4),d0
	lsr.w	#1,d0
	sub.w	d0,d5
	
	muls.w	d3,d5
	muls.w	d6,d4
	sub.l	d4,d5
;	bgt.s	.Visible
	ble.s	.Visible
	moveq	#0,d7
	rts
.Visible
	moveq	#1,d7
	rts
	
FindLargestDelta:
	move.w	2(a4),d0	;y0
	move.w	6(a4),d1	;y1
	move.w	10(a4),d2	;y2
	lsr.w	#1,d0
	lsr.w	#1,d1
	lsr.w	#1,d2
	
	move.w	d0,d7
	sub.w	d1,d7
	bge.s	.pos0
	neg.w	d7
.pos0

	move.w	d0,d4
	sub.w	d2,d4
	bge.s	.pos1
	neg.w	d4
.pos1
	cmp.w	d4,d7
	bge.s	.ok
	move.w	d4,d7	
.ok

	move.w	d1,d4
	sub.w	d2,d4
	bge.s	.pos2
	neg.w	d4
.pos2
	cmp.w	d4,d7
	bge.s	.ok2
	move.w	d4,d7	
.ok2
	rts
	
PolyTest:
	lea		TestPoly,a0

;a0 = polygon data
;a1 = screen address
;dc.w	x0_8.8		0
;dc.w	y0_8.8		2
;dc.w	x1_8.8		4
;dc.w	y1_8.8		6
;dc.w	x2_8.8		8
;dc.w	y2_8.8		10

	move.w	(a0),d3
	lsr.w	#1,d3
	move.w	4(a0),d0
	lsr.w	#1,d0
	sub.w	d0,d3

	move.w	2(a0),d4
	lsr.w	#1,d4
	move.w	6(a0),d0
	lsr.w	#1,d0
	sub.w	d0,d4

	move.w	8(a0),d6
	lsr.w	#1,d6
	move.w	4(a0),d0
	lsr.w	#1,d0
	sub.w	d0,d6

	move.w	$a(a0),d5
	lsr.w	#1,d5
	move.w	6(a0),d0
	lsr.w	#1,d0
	sub.w	d0,d5
	
	muls.w	d3,d5
	muls.w	d6,d4
	sub.l	d4,d5
;	bgt.s	.Visible
	ble.s	.Visible
	RTS
.Visible

DrawTriangle:
	move.l	a1,usp

	move.w	2(a0),d0	;y0
	move.w	6(a0),d1	;y1
	move.w	10(a0),d2	;y2

;		lsr.w	#1,d0
;		lsr.w	#1,d1
;		lsr.w	#1,d2
	
	moveq	#0,d3
	
	cmp.w	d0,d1
	bls.s	.skp0
	moveq.w	#4,d3
.skp0

	cmp.w	d1,d2
	bls.s	.skp1
	addq.w	#2,d3
.skp1

	cmp.w	d2,d0
	bls.s	.skp2
	addq.w	#1,d3
.skp2

;		move.w	2(a0),d0	;y0
;		move.w	6(a0),d1	;y1
;		move.w	10(a0),d2	;y2

	;;;;;;;

	lea		ConfigTable,a6
	lsl.w	#3,d3
	adda.w	d3,a6

	move.l	a0,a1
	move.l	a0,a2
	move.l	a0,a3
	move.l	a0,a4
	
	tst.b	(a6)	;Type
;	beq.s	.LeftType							***
	bne.s	.LeftType							***
	move.w	#$3c3c,_SAVE_XM_I
	move.w	#$343c,_SAVE_dXMtoB_I
	bra.s	.RightType
.LeftType	
	move.w	#$3e3c,_SAVE_XM_I
	move.w	#$323c,_SAVE_dXMtoB_I
.RightType	

	moveq	#0,d0
	move.b	1(a6),d0	;Top
	add.w	d0,a0		;a0 = top vertex

	move.b	2(a6),d0	;Middle
	add.w	d0,a1		;a1 = middle vertex

	move.b	3(a6),d0	;Bottom
	add.w	d0,a2		;a2 = bottom vertex

;	move.b	4(a6),d0	;Right					***
	move.b	5(a6),d0	;Right					***
	add.w	d0,a3		;a3 = right vertex

;	move.b	5(a6),d0	;Left					***
	move.b	4(a6),d0	;Left					***
	add.w	d0,a4		;a4 = left vertex

	;;;;;;;
	; Compute slopes and usual stuff

ComputeGradient	MACRO
	moveq	#0,\1
	move.w	(\2),\1
	sub.w	(\3),\1
	ext.l	\1
	asl.l	#8,\1
	move.w	2(\2),d0
	sub.w	2(\3),d0
	;ext.w	d0
	;asr.w	#8,d0
	beq.s	.zero\@
	divs	d0,\1
.zero\@
	ENDM

ComputeGradient2	MACRO
	moveq	#0,d4	
	moveq	#0,\1
	move.w	(\2),\1
	sub.w	(\3),\1
	bhs.s	.pos0\@
	neg.w	\1
	addq.w	#1,d4
.pos0\@
	asl.l	#8,\1
	move.w	2(\2),d0
	sub.w	2(\3),d0
	bhs.s	.pos1\@
	neg.w	d0
	addq.w	#1,d4
.pos1\@
	;ext.w	d0
	;asr.w	#8,d0
	tst.w	d0
	beq.s	.zero\@
	divu	d0,\1
	ble.s	.zero\@
	cmp.w	#1,d4
	bne.s	.noFlip\@
	neg.w	\1
.noFlip\@
	bra.s	.nonzero\@
.zero\@
	moveq	#0,\1
.nonzero\@
	ENDM

	ComputeGradient2	d1,a3,a0
	ComputeGradient2	d2,a4,a0
	ComputeGradient2	d3,a2,a1

	move.w	d3,_SAVE_dXMtoB

BP:
	;;;;;;;
	; Compute #scanlines to go to the middle vertex
;	const udword CeilYBottom	= MyCeil(VBot->y);
;	const udword CeilYMiddle	= MyCeil(VMid->y);
;	const udword CeilYTop		= MyCeil(VTop->y);
;	udword Count				= CeilYMiddle - CeilYTop;
;	udword Count2				= CeilYBottom - CeilYMiddle;

	move.w	(a1),d4		;VMid->x
	move.w	d4,_SAVE_XM

	move.w	2(a2),d0	;VBot->y
	MyCeil	d0

	move.w	2(a1),d4	;VMid->y
	MyCeil	d4
	sub.w	d4,d0		;d0 = Count2

	move.w	d0,Count2

	move.w	2(a0),d5	;VTop->y
	MyCeil	d5
	sub.w	d5,d4		;d4 = Count
	
	move.w	(a0),d6		;VTop->x => CurrentXL
	move.w	d6,d7		;VTop->x => CurrentXR
	
SubPixel
		cmpi.b	#$f,$fffffc02.w
		beq.s	.SkipSubpixel

		move.l	d5,-(sp)
	
		; Prestep for subpixel accuracy
		;const float PreStep = VTop->y - float(CeilYTop);
		
		move.w	2(a0),d3	;VTop->y
		lsl.w	#8,d5		;float(CeilYTop)
		sub.w	d5,d3		;PreStep
		neg.w	d3			;PreStep'
		
		; Prestep slopes
		;const float XR = VTop->x - PreStep * dXR;
		
		tst.w	d1
		ble.s	.dXRNegative
			move.w	d3,d6		;PreStep'
			mulu.w	d1,d6		;PreStep' * dXR
			lsr.l	#8,d6
			add.w	d6,d7		;PreStep' * dXR + VTop->x = VTop->x - PreStep * dXR = XR
		bra.s	.dXRPositive
.dXRNegative
			move.w	d1,d6		;dXR
			neg.w	d6			;- dXR
			mulu.w	d3,d6		;- PreStep' * dXR
			lsr.l	#8,d6
			neg.w	d6			;PreStep' * dXR
			add.w	d6,d7		;VTop->x + PreStep' * dXR = VTop->x - PreStep * dXR = XR
.dXRPositive
		
;	move.w	d3,d6		;PreStep
;	muls.w	d1,d6		;PreStep * dXR
;	lsr.l	#8,d6
;	;move.w	(a0),d7		;VTop->x => CurrentXR
;	sub.w	d6,d7		;XR
		
		;const float XL = VTop->x - PreStep * dXL;

		tst.w	d2
		ble.s	.dXLNegative
			move.w	d3,d6		;PreStep'
			mulu.w	d2,d6		;PreStep' * dXL
			lsr.l	#8,d6
			add.w	(a0),d6		;VTop->x + PreStep' * dXL = VTop->x - PreStep * dXL = XL
		bra.s	.dXLPositive
.dXLNegative
			move.w	d2,d6		;dXL
			neg.w	d6			;-dXL
			mulu.w	d3,d6		;- PreStep' * dXL
			lsr.l	#8,d6
			neg.w	d6			;PreStep' * dXL
			add.w	(a0),d6		;VTop->x + PreStep' * dXL = VTop->x - PreStep * dXL = XL
.dXLPositive

;	move.w	d3,d6		;PreStep
;	muls.w	d2,d6		;PreStep * dXL
;	lsr.l	#8,d6
;	sub.w	(a0),d6		;PreStep * dXL - VTop->x
;	neg.w	d6			;XL
			
		;const float PreStep2 = VMid->y - float(CeilYMiddle);

		move.w	2(a1),d5	;VMid->y
		move.w	d5,d3
		MyCeil	d5
		lsl.w	#8,d5		;float(CeilYMiddle)
		sub.w	d5,d3		;PreStep2
		neg.w	d3			;PreStep2'

		; Prestep slopes
		;const float XM = VMid->x - PreStep2 * dXMiddleToBottom;

		move.w	_SAVE_dXMtoB,d5
		;tst.w	d5
		;tst.w	_SAVE_dXMtoB
		ble.s	.dXMNegative		
			mulu.w	d5,d3		;PreStep2' * dXMiddleToBottom
			lsr.l	#8,d3
			add.w	(a1),d3		;VMid->x + PreStep2' * dXMiddleToBottom = VMid->x - PreStep2 * dXMiddleToBottom = XM
		bra.s	.dXMPositive
.dXMNegative
			neg.w	d5			;-dXMiddleToBottom
			mulu.w	d5,d3		;-PreStep2' * dXMiddleToBottom
			lsr.l	#8,d3
			neg.w	d3			;PreStep2' * dXMiddleToBottom
			add.w	(a1),d3		;VMid->x + PreStep2' * dXMiddleToBottom = VMid->x - PreStep2 * dXMiddleToBottom = XM
.dXMPositive
		move.w	d3,_SAVE_XM

;	muls.w	_SAVE_dXMtoB,d3	;PreStep2 * dXMiddleToBottom
;	lsr.l	#8,d3
;	sub.w	(a1),d3				;PreStep2 * dXMiddleToBottom - VMid->x
;	neg.w	d3
;	move.w	d3,_SAVE_XM
	
		move.l	(sp)+,d5

.SkipSubpixel
	
	move.l	usp,a1

	move.w	#$4e71,Modify
	lea		NewTableScreenOffset2,a2
	lea		NewFillerTable-16*8,a5				;****************
	move.l	a5,usp
	move.w	#$ffff,a3

;	move.w	#256,d0
	moveq	#0,d0

	IFNE	TRY_TRAME
		btst	#0,d5
		beq.s	.zero
		move.w	#$aaaa,d0
		bra.s	.one
.zero
		move.w	#$5555,d0
.one
		move.w	d0,a3
	ENDC

	mulu.w	#160,d5
	adda.w	d5,a1

	tst.w	d4
	beq		StartPart2
;	subq.w	#1,d4

Restart

	move.l	a1,a6
	mulu	#160,d4
	add.w	d4,a6
	
	move.w	#127,d4
	
	IFNE	TRY_DOUBLE
		swap	d2
		swap	d6
		move.w	d1,d2
		move.w	d7,d6
		swap	d2
		swap	d6
		move.w	#63,d7
	ENDC

	IFNE	TRY_FLOOR
		lsl.l	#8,d1
		lsl.l	#8,d2
		lsl.l	#8,d6
		lsl.l	#8,d7
	ENDC

StartSpan

	IFNE	TRY_FLOOR
		move.l	d6,d5
		move.l	d7,d3
		swap	d5
		swap	d3
	ELSE
	IFEQ	TRY_DOUBLE
		move.w	d6,d5
;		MyCeil	d5		;const sdword StartPix = MyCeil(CurrentXL);
;		MyCeil256	d5,d0
;		NewCeil256	d5,d0
		Floor256	d5

		move.w	d7,d3
;		MyCeil	d3		;MyCeil(CurrentXR)
;		MyCeil256	d3,d0
;		NewCeil256	d3,d0
		Floor256	d3
	ELSE
		move.w	d6,d5
		swap	d6
		move.w	d6,d3
		swap	d6
;		MyCeil256	d5,d0
;		MyCeil256	d3,d0
		NewCeil256	d5,d0
		NewCeil256	d3,d0
	ENDC
	ENDC
	
	;We could get rid of this line without subpixel...
	sub.w	d5,d3	;sdword NbPixels = MyCeil(CurrentXR) - StartPix;
;	beq.s	ZeroPixel
;	ble.s	ZeroPixel
	blo.s	ZeroPixel	;todo: get rid of this by extending the table "negatively"?
;		blo	DEBUGHELP

	;Compact version, obviously not optimal, but doesn't use a lot of memory
	; NewFillerTable	ds.l	FILLER_TABLE_SIZE*16*2	;2 dwords per entry
	; Row address = nb_pixels * 16 * 2 * 4 = d3 * 128
	; We have d3 in 8:8 format so once the fractional part is cleared we want (d3 >> 8) << 7 = d3 >> 1
	; Inside a row we want (xmin & 15) * 8 = (d5 & 15) * 8
	; We have d5 in 8:8 format so once the fractional part is cleared we want (d5 >> 8) << 3 = d5 >> 5
	;
	; If we'd transpose the table we'd get:
	; Shift0:
	;		ds.l	FILLER_TABLE_SIZE*2	;2 dwords per entry
	; Shift1:
	;		ds.l	FILLER_TABLE_SIZE*2	;2 dwords per entry
	; ...
	; Shift address = xmin * FILLER_TABLE_SIZE*2*4 = xmin * 256*8 = d5 * 2048
	; With d5 in 8:8 format that gives d5 << 3
	; Inside a shift we want d3 * 2 * 4 = d3 * 8
	; With d3 in 8:8 format that gives (d3 >> 8) << 3 = d3 >> 5
	; Now if we shift everything by 5 and work with longs? first one becomes a swap and second one disappears?
	; add.l / move.l / and.l / swap
	; add.l / move.l / and.l
	; -2 (adds) +2 (floors) -1 (swap) +4 (lsr.w#5) + 2 (lsr.w#1)
	; unclear, the sub.w may become a sub.l etc
	move.l	a1,a0
	lsr.w	#5,d5			;xmin*8		TODO: consider using a larger table to shift less
;	IFNE	TRY_TRAME
;		move.l	(a2,d5.w),d0
;		swap	d0
;		add.w	d0,a0
;		swap	d0
;		move.w	d0,a3
;	ELSE
		adda.w	(a2,d5.w),a0	;screen offset for this shift
;	ENDC
	and.w	d4,d5			;xmin & 15      TODO: consider using a larger table to replace with clr.b, save register
	lsr.w	#1,d3			;nb pixels*128	TODO: consider using a larger table to remove instruction
	add.w	d3,d5
	move.l	usp,a5
	add.w	d5,a5			;TODO: align table on 64K, replace with move.w d5,a5, save 2 nops
	;Here we could be fetching the address of a routine hardcoded for the proper
	;mask / length, making the code faster at the expense of memory usage.
	move.l	(a5)+,d5
	IFNE	TRY_TRAME
		and.w	d0,d5
	ENDC
	or.w	d5,(a0)
	swap	d5
	
;		lea		.EndMove(pc,d5.w),a5
;		move.w	d5,(pc,d5.w)
	
	jmp		.EndMove(pc,d5.w)
OFFSET SET 20*8
	REPT	20
		move.w	a3,OFFSET(a0)
OFFSET SET OFFSET-8
	ENDR
.EndMove
		;This one is one nop more expensive but leaves unused space in the table
;		neg.w	d5			1
;		add.w	d5,d5		1
;		addq.w	#8,d5		1
;		add.w	d5,a0		2
;		move.w	(a5),d5		2

		;But could we make this the first/last entry in the previous table?
		move.l	(a5),d5		3
		add.w	d5,a0		2
		swap	d5			1
		
	IFNE	TRY_TRAME
		and.w	d0,d5
	ENDC
	or.w	d5,(a0)
.Done

ZeroPixel
	IFNE	TRY_FLOOR
			add.l	d2,d6	;CurrentXL+=dXL;
			add.l	d1,d7	;CurrentXR+=dXR;
	ELSE
		IFEQ	TRY_DOUBLE
			add.w	d2,d6	;CurrentXL+=dXL;
			add.w	d1,d7	;CurrentXR+=dXR;
		ELSE
			add.l	d2,d6
		ENDC
	ENDC

	IFNE	TRY_TRAME
		not.w	d0
		move.w	d0,a3
	ENDC

	lea		160(a1),a1
	cmpa.l	a1,a6
	bne		StartSpan

	IFNE	TRY_DOUBLE
		swap	d2
		swap	d6
		move.w	d2,d1
		move.w	d6,d7
		swap	d2
		swap	d6
	ENDC
	
StartPart2

Modify
	nop

Count2	= *+2
	move.w	#$1234,d4
;	tst.w	d4
	beq.s	.EndPoly
;	subq.w	#1,d4

_SAVE_XM_I		= *
	nop
_SAVE_XM		= *
	nop
_SAVE_dXMtoB_I	= *
	nop
_SAVE_dXMtoB	= *
	nop

	move.w	#$4e75,Modify
	
	IFNE	TRY_FLOOR
		rts
	ENDC
	
	bra		Restart

.EndPoly
;	illegal
	rts

;DEBUGCOUNT	dc.l	0
;DEBUGVALUE	ds.l	1600
;DEBUGHELP
;;	tst.w	d3
;;	beq.s	.skkip
;	cmp.l	#1600,DEBUGCOUNT
;	beq.s	.skkip
;	lea		DEBUGVALUE,a0
;	move.l	DEBUGCOUNT,d0
;	lsl.w	#2,d0
;	add.w	d0,a0
;	move.l	d3,(a0)
;	;move.l	d3,DEBUGVALUE
;	addq.l	#1,DEBUGCOUNT
;.skkip	
;	rts

InitFiller
	;=======

	;Create max table
	lea		NewTableXmax,a0
	move.w	#$8000,d7
	moveq	#16-1,d0
.Loop0b
	move.w	d7,(a0)+
	lsr.w	#1,d7
	ori.w	#$8000,d7
	dbf		d0,.Loop0b

	;=======

	;Create min table
	;				Shift0						Shift1					...		Shift15
	;1 pixel		motif	#bits_in_motif	|	motif	#bits_in_motif	...|	motif	#bits_in_motif
	;2 pixels		motif	#bits_in_motif	|	motif	#bits_in_motif	...|	motif	#bits_in_motif
	;...
	;16 pixels		motif	#bits_in_motif	|	motif	#bits_in_motif	...|	motif	#bits_in_motif

	;Create first 16 rows	
;	lea		NewTableXmin,a0
								lea		NewFillerTable,a0
	move.w	#$8000,d7
	moveq	#16-1,d1
.ForEachLength
	move.w	d7,d6
	moveq	#16-1,d0
.ForEachShift
		moveq	#0,d5
		moveq	#16-1,d4
.CountBits
		btst	d4,d7
		beq.s	.nullbit
		addq.w	#1,d5
.nullbit
		dbf		d4,.CountBits

	move.w	d7,(a0)+	;Motif
	
	subq.w	#1,d5		;#bits-1
	move.w	d5,(a0)+
	
								lea		4(a0),a0
	
	lsr.w	#1,d7
	dbf		d0,.ForEachShift
	
	move.w	d6,d7
	lsr.w	#1,d7
	ori.w	#$8000,d7
	dbf		d1,.ForEachLength

	;=======

	;Extend table to FILLER_TABLE_SIZE pixels to avoid doing this clamp at runtime:
;			cmpi.w	#15,d3
;			ble.s	.ll
;			move.w	#15,d3
;.ll
	;Replicate last row FILLER_TABLE_SIZE-16 times
;	lea		NewTableXmin,a1
								lea		NewFillerTable,a1
;	lea		16*16*4(a1),a1
								lea		16*16*8(a1),a1
	move.w	#(FILLER_TABLE_SIZE-16)-1,d7
.Copy
;	lea		NewTableXmin,a0
								lea		NewFillerTable,a0
	;lea		15*16*4(a0),a0
								lea		15*16*8(a0),a0

	move.w	#16-1,d6
.CopyRow
	move.l	(a0)+,(a1)+
								move.l	(a0)+,(a1)+
	dbf		d6,.CopyRow
	dbf		d7,.Copy

	;Patch table
;	lea		NewTableXmin,a0
								lea		NewFillerTable,a0
	move.w	#FILLER_TABLE_SIZE-1,d7
	moveq	#0,d0	;nb pixels
.NextRow
;	move.l	a0,a1
	
	move.w	#16-1,d6
.NextColumn
	move.w	(a0),d2
	move.w	d0,d1
	sub.w	2(a0),d1
;	addq.w	#1,d1

	;beware, we switched their positions as well
	move.w	d2,2(a0)
	move.w	d1,(a0)
	
	lea		4(a0),a0
									lea		4(a0),a0
	dbf		d6,.NextColumn

;	move.l	a1,a0
;	lea		16*4(a0),a0
	addq.w	#1,d0
	dbf		d7,.NextRow

	;=======

Spread:
	;Spread out
;	lea		NewTableXmin,a0
;	lea		NewTableXmin2,a1
								lea		NewFillerTable,a0
	move.w	#(FILLER_TABLE_SIZE*16)-1,d7
	moveq	#0,d0
.SpreadOut
;	move.w	(a0)+,d1
;	move.w	(a0)+,d2
	move.w	(a0),d1
	move.w	2(a0),d2

	moveq	#0,d6
	moveq	#0,d4

	move.w	d1,d5
	and.w	#15,d5
	ble.s	.Done
	subq.w	#1,d5
	add.w	d5,d5
	lea		NewTableXmax,a2
	move.w	(a2,d5.w),d6
.Done

	move.w	d1,d5
	and.w	#~15,d5
	lsr.w	#2,d5
	
		move.w	d5,a4	1
		add.w	a4,a4	2?
		addq.w	#8,a4
		neg.w	d5		1?

;;	move.w	d1,(a1)+
;	move.w	d5,(a1)+
;	move.w	d2,(a1)+
;	move.w	d6,(a1)+
;;	move.w	d5,(a1)+
;		move.w	a4,(a1)+

;	move.w	d1,(a0)+
	move.w	d5,(a0)+
	move.w	d2,(a0)+
	move.w	d6,(a0)+
;	move.w	d5,(a0)+
		move.w	a4,(a0)+

	dbf		d7,.SpreadOut

	;=======
	
;KillTable
;	;TODO: redo later
;	lea		NewFillerTable+FILLER_TABLE_SIZE*16*8,a0
;	moveq	#20-1,d6
;.NextRow
;	lea		-16*8(a0),a0
;	move.l	a0,a1
;	moveq	#16-1,d7
;	moveq	#0,d0
;.ClearRow
;	move.l	d0,(a1)+
;	move.l	d0,(a1)+
;	dbf		d7,.ClearRow
;	dbf		d6,.NextRow
	
	
	;=======

	;Create delta table
;	lea		NewTableDelta,a0
;	moveq	#0,d4
;	move.w	#FILLER_TABLE_SIZE-1,d7
;.Loop0c
;	move.w	d4,d3
;	cmpi.w	#15,d3
;	ble.s	.ll
;	move.w	#15,d3
;.ll
;	lsl.w	#5,d3
;	move.w	d3,(a0)+
;	addq.w	#1,d4
;	dbf		d7,.Loop0c

	rts

	ENDC	;FILLER_TEXT

	IFNE	FILLER_DATA
	section data
	even

;TestPoly	dc.w	41164,46078,58592,15183,23122,15537
;TestPoly	dc.w	32768,46080,50504,15359,15031,15360
;TestPoly	dc.w	32767,5120,15031,35839,50504,35839
;TestPoly	dc.w	32767,5120,15031,25839,45504,35839
;TestPoly	dc.w	32767,5120,15031,35839,45504,25839
TestPoly	dc.w	25235,14008,21176,33132,40300,37191

LEFT	= 0
RIGHT	= 1
DUMMY	= 255
SIZEOFV	= 4

ConfigTable
	dc.b	255,255,255,255,255,255,DUMMY,DUMMY
	dc.b	LEFT,2*SIZEOFV,1*SIZEOFV,0*SIZEOFV,1*SIZEOFV,0*SIZEOFV,DUMMY,DUMMY
	dc.b	LEFT,1*SIZEOFV,0*SIZEOFV,2*SIZEOFV,0*SIZEOFV,2*SIZEOFV,DUMMY,DUMMY
	dc.b	RIGHT,1*SIZEOFV,2*SIZEOFV,0*SIZEOFV,0*SIZEOFV,2*SIZEOFV,DUMMY,DUMMY
	dc.b	LEFT,0*SIZEOFV,2*SIZEOFV,1*SIZEOFV,2*SIZEOFV,1*SIZEOFV,DUMMY,DUMMY
	dc.b	RIGHT,2*SIZEOFV,0*SIZEOFV,1*SIZEOFV,1*SIZEOFV,0*SIZEOFV,DUMMY,DUMMY
	dc.b	RIGHT,0*SIZEOFV,1*SIZEOFV,2*SIZEOFV,2*SIZEOFV,1*SIZEOFV,DUMMY,DUMMY
	dc.b	255,255,255,255,255,255,DUMMY,DUMMY
	
;NewTableScreenOffset
;N	SET	0
;	REPT	20
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;	DC.W	N,0
;N	SET	N+8
;	ENDR

NewTableScreenOffset2
N	SET	0
	REPT	20
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
	DC.W	N,$aaaa,0,0
	DC.W	N,$5555,0,0
N	SET	N+8
	ENDR
	
	ENDC	;FILLER_DATA

	IFNE	FILLER_BSS
	section bss
	even
	
;NewTableDelta	ds.w	FILLER_TABLE_SIZE
NewTableXmax	ds.w	16
;NewTableXmin2	ds.l	FILLER_TABLE_SIZE*16*2	;2 dwords per entry
;NewTableXmin	ds.l	FILLER_TABLE_SIZE*16
				ds.l	16*2
NewFillerTable	ds.l	FILLER_TABLE_SIZE*16*2	;2 dwords per entry
	ENDC	;FILLER_BSS
