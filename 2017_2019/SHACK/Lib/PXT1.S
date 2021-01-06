
;Pixel table

PIXEL_RANGE						= CLIP_X*2
SINGLE_PIXEL_TABLE_SIZE			= PIXEL_RANGE*2
;SINGLE_PIXEL_TABLE_START_OFFSET	= CLIP_X
SINGLE_PIXEL_TABLE_START_OFFSET	= CLIP_X

;TEST	dc.w	0

;a0 = destination
CreatePixelTableForBset:

;	lea		TEST,a0
;	moveq	#0,d0
;	bset	d0,(a0)
;	addq	#1,d0
;	bset	d0,(a0)
	
	moveq	#3,d3
	moveq	#4,d4
	moveq	#0,d0				;x value
	moveq	#0,d5				;x value
;		move.w	#160,d0
	move.w	#PIXEL_RANGE-1,d7	;table valid for PIXEL_RANGE pixels
	
.CreateTable
;		subq.w	#1,d5			;next pixel	**** this line to get rid of the NOT in the plot macro
	subq.w	#1,d0			;next pixel	**** this line to get rid of the NOT in the plot macro
	move.w	d0,d1
;		move.w	d5,d1
	lsr.w	d4,d1
	lsl.w	d3,d1

	move.w	d0,d2
	and.w	#15,d2
	cmp.w	#7,d2
	ble.s	.nu
	addq.w	#1,d1
.nu	
;	addq.w	#1,d0			;next pixel	**** this line to get rid of the NOT in the plot macro

	move.b	d1,(a0)+		;screen offset	
	dbf		d7,.CreateTable	
	rts


;Default code that needs an extra NOT X in the plot code
;.CreateTable
;	move.w	d0,d1
;	lsr.w	d4,d1
;	lsl.w	d3,d1
;
;	move.w	d0,d2
;	and.w	#15,d2
;	cmp.w	#7,d2
;	ble.s	.nu
;	addq.w	#1,d1
;.nu	
;	addq.w	#1,d0
;	move.b	d1,(a0)+
;	dbf		d7,.CreateTable	
