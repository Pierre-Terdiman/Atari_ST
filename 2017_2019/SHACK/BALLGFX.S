
GFX_PIXEL_SIZE	= 16	;Must be a multiple of 16
Gfx			ds.w	16*GFX_PIXEL_SIZE*(1+(GFX_PIXEL_SIZE/16))
;Gfx2		ds.w	16*GFX_PIXEL_SIZE*(1+(GFX_PIXEL_SIZE/16))
DitherFlag	dc.w	0

InitGfx:

	;1) Generate the gfx
	moveq	#GFX_PIXEL_SIZE,d5
	lsr		#1,d5			;radius
;	lsr		#3,d5			;radius
	move.l	d5,a1
	mulu	d5,d5
;	add.l	#32,d5			;make gfx a bit fatter
	
	moveq	#GFX_PIXEL_SIZE-1,d7
	moveq	#0,d1			;y
.GenerateGfxY
	moveq	#GFX_PIXEL_SIZE-1,d6
	move.w	#$8000,d4		;pixel-mask
	moveq	#0,d0			;x
.GenerateGfxX
	;Must generate pixel (x,y)

	cmp.w	#0,DitherFlag
	beq.s	.NoDither
	move.w	d0,d2
	add.w	d1,d2
	and.w	#1,d2
	beq.s	.SkipPixel
.NoDither
	
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
	dbf		d6,.GenerateGfxX
	addq	#2,a0
	addq	#1,d1
	dbf		d7,.GenerateGfxY
	
	;2) Pre-shift 15 more times
	moveq	#15-1,d5
.Shift
	moveq	#GFX_PIXEL_SIZE-1,d7
.ShiftGfxY
	moveq	#(1+(GFX_PIXEL_SIZE/16))-1,d6
.ShiftGfxX
	move.w	-2*GFX_PIXEL_SIZE*(1+(GFX_PIXEL_SIZE/16))(a0),d4
	roxr	d4
	move.w	d4,(a0)+
	dbf		d6,.ShiftGfxX
	dbf		d7,.ShiftGfxY
	dbf		d5,.Shift
	rts

