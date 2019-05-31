INIT  	move.l  #TEXT,a5	
	move.l	#TEXT_COMP,a4	
		
SCRUT:	moveq	#0,d0
	move.b (a5)+,d0 

	cmp.b	#89,d0
	bhs	YZ
	cmp.b	#85,d0
	bhs	UVWX
	cmp.b	#81,d0
	bhs	QRST
	cmp.b	#77,d0
	bhs	MNOP
	cmp.b	#73,d0
	bhs	IJKL

	cmp.b	#69,d0
	bhs	EFGH
	cmp.b	#65,d0
	bhs	ABCD

	cmp.b	#39,d0
	beq	APOS
	cmp.b	#44,d0
	beq	VIRG	
	cmp.b	#46,d0
	beq	POINT	
	cmp.b	#45,d0
	beq	TIRET	

	cmp.b	#33,d0
	beq	EXCL

	cmp.b	#32,d0
	beq	SPACE	

SPACE:   
	sub	#29,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.L	#81*160*7,D0
	bra	SET


ABCD:	sub	#65,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	bra	SET
EFGH:	SUB	#69,D0
	LSL.B	#4,D0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.W	#113*160,D0
	BRA	SET

IJKL:	sub	#73,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.W	#113*160*2,D0
	bra	SET
MNOP:	sub	#77,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.W	#81*160*3,D0
	bra	SET
QRST:	sub	#81,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.W	#81*160*4,D0
	bra	SET

UVWX:	sub	#85,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.W	#81*160*5,D0
	bra	SET
YZ:	sub	#89,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.L	#81*160*6,D0
	bra	SET
	
APOS:   
	sub	#38,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.L	#81*160*7,D0
	bra	SET


VIRG:	
	sub	#44,d0	
	ADD.L	#81*160*7,D0
	bra	SET

EXCL:   
	sub	#31,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.L	#81*160*6,D0
	bra	SET

POINT:	
	sub	#43,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.L	#81*160*6,D0
	bra	SET

TIRET:   
	sub	#43,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.L	#81*160*7,D0
	bra	SET

SET:	move.L	d0,(a4)+	
	cmp.b	#$ff,(a5)	
	bne	SCRUT		
	move.L	#$ffff,(a4)	
	
	move.w	#0,-(sp)	
	move.l	#FILENAME,-(sp)	
	move.w	#$3c,-(sp)	
	trap 	#1		
	lea	8(sp),sp	
	tst	d0		
	move.w	d0,HANDLE	
	
	pea	TEXT_COMP	
	move.l	#60,-(sp)  	
	move.w	HANDLE,-(sp)	
	move.w	#$40,-(sp)	
	trap	#1		
	lea	12(sp),sp	
	tst.w	d0		
	
	move.w	HANDLE,-(sp)	
	move.w	#$3e,-(sp)
	trap #1
	lea 	4(sp),sp	
	
	move.w	#1,-(sp)	
	trap #1			
	addq.l	#2,sp		
	
	clr.l 	-(sp)		
	trap #1			

	section data	
TEXT:
	DC.B  "LLABCDEFGHIJKL"
	


	dc.b	$ff
		
FILENAME:	dc.b	"LOGO.TXT",0	
HANDLE:	dc.l	1	

	section bss	
TEXT_COMP:	ds.B	4*15		;4K DE RESERVE

	end





