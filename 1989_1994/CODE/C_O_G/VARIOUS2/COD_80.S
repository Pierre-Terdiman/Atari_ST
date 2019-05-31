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
	ADD.W	#81*160,D0
	BRA	SET

IJKL:	sub	#73,d0	
	lsl.b	#4,d0
	MULU	#5,D0
	LSR.B	#1,D0
	ADD.W	#81*160*2,D0
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
	move.l	#1000,-(sp)  	
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
	DC.B	"  AND HERE COMES ANOTHER SCREEN BY ZAPPY OF -HOLOCAUST-!"
	DC.B	"   THIS ONE IS RATHER OLD...  IT WAS CODED DURING THE SNORK"
	DC.B	" PARTY.      BUT... THE FIRST ONE !     AS YOU SEE, IT IS NOT"
	DC.B	" WHAT WE CAN CALL BRAND NEW STUFF...    ANYWAY, SINCE THERE"
	DC.B	" WAS TRACKS LEFT ON THE DISK...         IT STILL LOOKS QUITE GOOD."
	DC.B	"     CODE AND GFXS BY ZAPPY.  MUSIC BY BIG ALEC OF -DELTA FORCE-,"
	DC.B	" TAKEN FROM 'SICKEST SO FAR' IN 'PUNISH YOUR MACHINE', AND I"
	DC.B	" FEEL CHEAP FOR THIS RIP... SHAME ON ME!        BY THE WAY,"
	DC.B	" I DREW THESE FONTS AFTER HAVING SEEN A 'VISION' LOGO ON AMIGA..."
	DC.B	"  ANOTHER SORT OF RIP...  BUT I DO NOT CARE, NOBODY WILL BE MAD"
	DC.B	" ENOUGH TO READ THIS SCROLLER, THEN NOBODY WILL KNOW THAT !!   "
	DCB	10," "
	DC.L	-1
			
FILENAME:	dc.b	"BIG.TXT",0	
HANDLE:	dc.l	1	

	section bss	
TEXT_COMP:	ds.B	10000		;4K DE RESERVE

	end





