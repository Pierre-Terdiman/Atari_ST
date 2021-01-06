
;Pixel table

PIXEL_RANGE						= CLIP_X*2
SINGLE_PIXEL_TABLE_SIZE			= PIXEL_RANGE*2
SINGLE_PIXEL_TABLE_START_OFFSET	= 4*(PIXEL_RANGE/2)		;4*160 to add 160 to x (move them to screen center)

;a0 = destination
CreatePixelTableForOrW:
	moveq	#3,d3
	moveq	#4,d4
	moveq	#0,d0				;x value
	move.w	#PIXEL_RANGE-1,d7	;table valid for PIXEL_RANGE pixels
	move.w	#$8000,d2
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
	rts
