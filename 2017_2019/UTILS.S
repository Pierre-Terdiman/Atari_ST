

;======================================

MyMacro	MACRO
	ENDM

;======================================

;test
PlotDotNoProj16b	MACRO
	swap	d0				;1
	swap	d1				;1

	add.w	d1,d1			;1
	move.w	(a4,d1.w),d1	;4
	
	add.b	(a5,d0.w),d1	;4	<= that's not going to work (overflow doesn't modify the high byte of d1)

	move.b	(ax,d0.w),d0	;4	=> uses extra register, maybe can abuse the offsets to avoid this
	or.b/bset d0,(a1,d1.w)	;5
							;Total: 20 nops/dot
	ENDM

;test
PlotDotNoProj16c	MACRO
	swap	d0				;1
	swap	d1				;1
	
	add.w	d0,d0			;1
	add.w	d0,d0			;1
	add.w	d1,d1			;1

	move.l	(a5,d0.w),d0	;5
	add.w	(a4,d1.w),a1	;5
	add.w	d0,d1			;2
	swap	d0				;1
	or.w	d0,(a1)			;3
							;Total: 21 nops/dot :(
	ENDM

;test
PlotDotNoProj16d	MACRO
	swap	d0				;1 assumes multiplied by 256
	swap	d1				;1
	
	move.b	d1,d0			;1 merges x & y
	
	add.w	d0,d0			;1

	move.w	(a4,d0.w),d1	;4	combined screen offset from both x & y
	move.w	(a5,d0.w),d0	;4
	or.w	d0,(a1,d1.w)	;5
							;Total: 17 nops/dot potentially
	ENDM

;test
PlotDotNoProj16e	MACRO
	swap	d0				;1 assumes multiplied by 256
	swap	d1				;1
	
	move.b	d1,d0			;1 merges x & y
	
	add.w	d0,d0			;1
	add.w	d0,d0			;1

	move.l	(a4,d0.w),d0	;4
	move.w	d0,d1			;1
	swap	d0				;1
	or.w	d0,(a1,d1.w)	;5
							;Total: 16 nops/dot potentially
	ENDM


	IFNE	UTIL_CREATE_PIXEL_TABLE
;Plot a dot, no projection, 16bit accuracy
PlotDotNoProj16	MACRO
	swap	d0				;1
	swap	d1				;1
	
;	add.w	d0,d0			;1
;	add.w	d0,d0			;1
	and.w	d2,d0			;1	;this one for FASTROT_TEST
	add.w	d1,d1			;1

	move.l	(a5,d0.w),d0	;5
	move.w	(a4,d1.w),d1	;4
	add.w	d0,d1			;1
	swap	d0				;1
	or.w	d0,(a1,d1.w)	;5
							;Total: 21 nops/dot :(
	ENDM


PlotDotNoProj8	MACRO
;	add.w	d0,d0			;1
;	add.w	d0,d0			;1
	and.w	d2,d0			;1	;this one for FASTROT_TEST
;	and.w	#~3,d0			;1
	add.w	d1,d1			;1

	move.l	(a5,d0.w),d0	;5
	move.w	(a4,d1.w),d1	;4
	add.w	d0,d1			;1
	swap	d0				;1
	or.w	d0,(a1,d1.w)	;5
							;Total: 19 => 18
	ENDM

PlotDotNoProj8Codgen2	MACRO
;	move.l	(a5,d0.w),d0	;5
;	add.w	d0,d1			;1
;	swap	d0				;1
;	or.w	d0,(a1,d1.w)	;5
							;Total: 12

	move.l	d0,a5			1
	move.b	(a5),d2			2
	add.w	d2,d1			1

;	move.b	(a5,d0.w),d2	4
;	add.w	d2,d1			1

;		move.w	d1,d3
;		eor.w	#$fff9,d3
;		bset	d0,(a1,d3.w)	;5

;	add.b	(a5,d0.w),d1
;	not.w	d0				;1
;	bset	d0,(a1,d1.w)	;5
							;Total: 11 => 10
		move.l	d1,a1
		bset	d0,(a1)
	ENDM


; We want these:
; d0 + d4 + d6
; d0 - d4 + d6
; d0 + d4 - d6
; d0 - d4 - d6
; We could recompute them from scratch each time but we have access to the previous quantity
; after plotting two dots (d0 is not modified). So we can instead compute the deltas from one
; quantity to the next.
; d0 + d4 + d6
;				-d4*2
; d0 - d4 + d6
;				-d6*2
; d0 - d4 - d6
;				+d4*2 +d6*2
; d0 + d4 - d6
PlotDotNoProj8Codgen3_	MACRO

	;===
	move.w	d4,d0
	add.w	d6,d4	;d4 = d4+d6
	sub.w	d0,d6	;d6 = d6-d4
	
	move.w	d5,d0
	add.w	d7,d5	;d5 = d5+d7
	sub.w	d0,d7	;d7 = d7-d5
	;===

	move.w	a0,d0
	add.w	d4,d0	;d0 = d0+d4+d6
	
	move.w	a2,d1
	add.w	d5,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

;	ENDM
;PlotDotNoProj8Codgen3b	MACRO

	move.w	a0,d0
;		not.w	d0
	add.w	d6,d0	;d0 = d0-d4+d6
	
	move.w	a2,d1
	add.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

;	ENDM
;PlotDotNoProj8Codgen3b	MACRO

	move.w	a0,d0
;		not.w	d0
	sub.w	d6,d0
	
	move.w	a2,d1
	sub.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

	move.w	a0,d0
;		not.w	d0
	sub.w	d4,d0
	
	move.w	a2,d1
	sub.w	d5,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)
	ENDM





;- swap x and z so that the constant values are a0/a2, that way we don't need to change the signs. That saves the 2 loads already.
;- a2 is always null for some reason. That saves one load.
;- we can maybe sort the dots to take advantage of similar offsets or something
PlotDotNoProj8Codgen3	MACRO

;	suba.l	a2,a2
;	move.w	#0,a2	???
;	move.w	#0,d6
;	move.w	#0,d7
;	move.w	#0,d5

	;===
	move.w	d4,d0
	add.w	d6,d4	;d4 = d4+d6
	sub.w	d0,d6	;d6 = d6-d4
	;===

	move.w	a0,d0
;	add.w	d4,d0
;	add.w	d6,d0
		add.w	d4,d0
	
;	move.w	a2,d1
;	add.w	d5,d1
		move.w	d5,d1
	add.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

	;===
	move.w	a0,d0
;	add.w	d4,d0
;	sub.w	d6,d0
		sub.w	d6,d0
	
;	move.w	a2,d1
;	add.w	d5,d1
		move.w	d5,d1
	sub.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

	;===
	move.w	a0,d0
;	sub.w	d4,d0
;	add.w	d6,d0
		add.w	d6,d0
	
;	move.w	a2,d1
;	sub.w	d5,d1
;	add.w	d7,d1
		move.w	d7,d1
		sub.w	d5,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)

	;===
	move.w	a0,d0
;	sub.w	d4,d0
;	sub.w	d6,d0
		sub.w	d4,d0
	
	move.w	a2,d1		** zero
;		move.w	d5,d1
	sub.w	d5,d1
	sub.w	d7,d1

		move.l	d0,a5
		move.b	(a5),d2
		add.w	d2,d1

;		bset	d0,(a1,d1.w)
			move.l	d1,a1
			bset	d0,(a1)
		eor.w	d3,d1
		not.b	d0
		bset	d0,(a4,d1.w)
	ENDM








;x in d0
;	add.b	(a5,d0.w),d1	;4	gives the screen offset
;	not.w	d0				;1	gives the pixel mask
;	bset	d0,(a1,d1.w)	;5
;Total: 10!


;	move.l	(a5,d0.w),d0	;5
;	add.w	(a4,d1.w),d0	;4
;	move.w	d0,a1			;? extends the sign anyway so, doesn't work
;	swap	d0				;1
;	or.w	d0,(a1)			;3

;If we could find a way to avoid the "rts":
;To beat: 1+5+1+1+5 = 13
;	and.w	dx,d0				1
;	jmp		(a6,d0.w)			4
;	or.w	#$5678,126(a1,d2.w)	6 <= potentially better with bset/registers
;	jmp		(ax)				2 <= not possible to do when the code has been unrolled

PlotDotNoProj8xp	MACRO
;	move.b	(ax,d0.w),dx	4
	add.w	d0,d0			1
	add.w	d0,d0			1
	add.w	d1,d1			1

	move.l	(a5,d0.w),a1	5
	move.w	a1,dx			1
	add.w	(a4,d1.w),a1	5
;	or.w	dx,(a1)			3
	bset	dx,(a1)			3
	ENDM

;BigTable version
PlotDotNoProj8BT	MACRO

;	move.w	#0,d0
;	move.w	#0,d1

	add.w	#160,d0
	add.w	#100,d1

;	exg.l	d0,d1

	lsl.w	#8,d0
	move.b	d1,d0

		swap	d0
		clr.w	d0
		swap	d0

	add.l	d0,d0
	add.l	d0,d0
	
	move.l	(a5,d0.l),d0
	move.w	d0,d1
	swap	d0
	or.w	d0,(a1,d1.w)
	ENDM



PlotDotNoProj8xy	MACRO
		move.w	d0,d1
		swap	d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d1

	move.l	(a5,d0.w),d0
	move.w	(a4,d1.w),d1
	add.w	d0,d1
	swap	d0
	or.w	d0,(a1,d1.w)
	ENDM
	ENDC

	IFNE	UTIL_CREATE_PIXEL_TABLE2
;Plot a dot, no projection, 16bit accuracy
;test
;DOES NOT WORK YET
PlotDotNoProj16	MACRO
	swap	d0
	swap	d1
	
	add.w	d0,d0
	add.w	d1,d1

	move.w	(a5,d0.w),d0
	move.w	(a4,d1.w),d1
	add.b	d0,d1
;	swap	d0
	lsr.w	#8,d0			***use register here
	or.b	d0,(a1,d1.w)
	ENDM
	ENDC
	
;======================================

;SIN_TABLE_SIZE must be defined (size of table in number of entries)
;\1 = sin table address (16bit values)
;\2 = input angle  (between 0 and SIN_TABLE_SIZE-1), output sin
;\3 = output cos
GetSinCos	MACRO
	and.w	#SIN_TABLE_SIZE-1,\2	;wrap angle value
	move.w	\2,\3
	add.w	\2,\2					;*2 to access the word table
	move.w	(\1,\2.w),\2			;sin(angle)
	add.w	#SIN_TABLE_SIZE/4,\3	;angle + PI/2 for cos	
	and.w	#SIN_TABLE_SIZE-1,\3	;wrap angle value
	add.w	\3,\3					;*2 to access the word table
	move.w	(\1,\3.w),\3			;cos(angle)
	ENDM

;======================================

; Sets a rotation matrix around the X axis.
;		 1		0		0
;	RX = 0		cx		sx
;		 0		-sx		cx
;\1 = destination matrix (9 16bit values)
;\2 = sx
;\3 = cx
ComputeRotMatrixX	MACRO
	move.w	#$7fff,(\1)+
	move.w	#0,(\1)+
	move.w	#0,(\1)+
	
	move.w	#0,(\1)+
	move.w	\3,(\1)+
	move.w	\2,(\1)+
	
	move.w	#0,(\1)+
	move.w	\2,(\1)
	neg.w	(\1)+
	move.w	\3,(\1)+
	ENDM

;======================================

; Sets a rotation matrix around the Y axis.
;		 cy		0		-sy
;	RY = 0		1		0
;		 sy		0		cy
;\1 = destination matrix (9 16bit values)
;\2 = sy
;\3 = cy
ComputeRotMatrixY	MACRO
	move.w	\3,(\1)+
	move.w	#0,(\1)+
	move.w	\2,(\1)
	neg.w	(\1)+
	
	move.w	#0,(\1)+
	move.w	#$7fff,(\1)+
	move.w	#0,(\1)+
	
	move.w	\2,(\1)+
	move.w	#0,(\1)+
	move.w	\3,(\1)+
	ENDM

;======================================

; Sets a rotation matrix around the Z axis.
;		 cz		sz		0
;	RZ = -sz	cz		0
;		 0		0		1
;\1 = destination matrix (9 16bit values)
;\2 = sz
;\3 = cz
ComputeRotMatrixZ	MACRO
	move.w	\3,(\1)+
	move.w	\2,(\1)+
	move.w	#0,(\1)+
	
	move.w	\2,(\1)
	neg.w	(\1)+
	move.w	\3,(\1)+
	move.w	#0,(\1)+
	
	move.w	#0,(\1)+
	move.w	#0,(\1)+
	move.w	#$7fff,(\1)+
	ENDM

;======================================

;			cy		sx.sy		-sy.cx
;	RY.RX	0		cx			sx
;			sy		-sx.cy		cx.cy
;\1 = destination matrix (9 16bit values)
;\2 = sx = sy
;\3 = cx = cy
;WARNING: input registers cannot be 'd0'
ComputeRotMatrixXY_OneAngle	MACRO
;	ext.l	\2		;sx
;	ext.l	\3		;cx
	move.w	\3,(\1)+
	
	move.w	\2,d0
	muls	\2,d0
	add.l	d0,d0
	swap	d0
	move.w	d0,(\1)+

	move.w	\2,d0
	muls	\3,d0
	add.l	d0,d0
	swap	d0
	neg.w	d0
	move.w	d0,(\1)+

	move.w	#0,(\1)+
	move.w	\3,(\1)+
	move.w	\2,(\1)+
	
	move	\2,(\1)+

	move.w	\2,d0
	muls	\3,d0
	add.l	d0,d0
	swap	d0
	neg.w	d0
	move.w	d0,(\1)+

	move.w	\3,d0
	muls	\3,d0
	add.l	d0,d0
	swap	d0
	move.w	d0,(\1)+
	ENDM

;======================================

;			cy		sx.sy		-sy.cx
;	RY.RX	0		cx			sx
;			sy		-sx.cy		cx.cy
;\1 = destination matrix (9 16bit values)
;\2 = sx
;\3 = cx
;\4 = sy
;\5 = cy
;WARNING: input registers cannot be 'd0'
ComputeRotMatrixXY_TwoAngles	MACRO
	move.w	\5,(\1)+
	
	move.w	\2,d0
	muls	\4,d0
	add.l	d0,d0
	swap	d0
	move.w	d0,(\1)+

	move.w	\4,d0
	muls	\3,d0
	add.l	d0,d0
	swap	d0
	neg.w	d0
	move.w	d0,(\1)+

	move.w	#0,(\1)+
	move.w	\3,(\1)+
	move.w	\2,(\1)+
	
	move.w	\4,(\1)+

	move.w	\2,d0
	muls	\5,d0
	add.l	d0,d0
	swap	d0
	neg.w	d0
	move.w	d0,(\1)+

	move.w	\3,d0
	muls	\5,d0
	add.l	d0,d0
	swap	d0
	move.w	d0,(\1)+
	ENDM

;======================================

	IFNE	UTIL_CLEAR_SCREEN_1P
;a0 = screen address
;d0 = clear value (word)
ClearScreen_1Plane:
	move.w	#200-1,d7
.Clear
	move.w	d0,(a0)
N	set		8
	REPT	20-1
	move.w	d0,N(a0)
N	set		N+8
	ENDR
	lea		160(a0),a0
	dbf		d7,.Clear
	rts
	ENDC

;======================================

	IFNE	UTIL_CLEAR_SCREEN_4P
;a0 = screen address
ClearScreen_4Planes:
	;TODO: generate this code to speedup compile time
	move.l	a7,usp
	move.l	a0,a7
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	d1,a0
	move.l	d1,a1
	move.l	d1,a2
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6
NB	set		(32000/4)/15
N	set		0
	REPT	NB
	movem.l	d0-a6,N(a7)
;	lea		15*4(a7),a7
N	set		N+15*4
	ENDR
	adda.l	#NB*15*4,a7
	move.l	d0,(a7)+
	move.l	d0,(a7)+
	move.l	d0,(a7)+
	move.l	d0,(a7)+
	move.l	d0,(a7)+
	move.l	usp,a7
	rts
	ENDC

;======================================

	IFNE	UTIL_ROTATE_POINTS
;Rotate vectors. Regular version, computes z, no special tricks.
;Also stores results in destination buffer, which is slower than using the results directly.
;a0 = source (x y z 16bits)
;a1 = destination (x y z 16bits)
;a2 = rotation matrix
;d7 = nb pts - 1
RotatePoints:
.RotateVector

	move.w	(a0)+,d3	;x
	move.w	d3,d0
	muls.w	(a2),d0
	move.w	d3,d1
	muls.w	6(a2),d1
	move.w	d3,d2
	muls.w	12(a2),d2
		
	move.w	(a0)+,d5	;y
	move.w	d5,d4
	muls.w	2(a2),d4
	add.l	d4,d0
	move.w	d5,d4
	muls.w	2+6(a2),d4
	add.l	d4,d1
	move.w	d5,d4
	muls.w	2+12(a2),d4
	add.l	d4,d2

	move.w	(a0)+,d6	;z
	move.w	d6,d4
	muls.w	4(a2),d4
	add.l	d4,d0
	move.w	d6,d4
	muls.w	4+6(a2),d4
	add.l	d4,d1
	move.w	d6,d4
	muls.w	4+12(a2),d4
	add.l	d4,d2

	add.l	d0,d0
	swap	d0
	add.l	d1,d1
	swap	d1
	add.l	d2,d2
	swap	d2
	
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.w	d2,(a1)+

	dbf		d7,.RotateVector
	rts
	
;Special version that doesn't do the final "lsr #15" but instead output the dword as-is.
RotatePointsSpecial:
.RotateVector

	move.w	(a0)+,d3	;x
	move.w	d3,d0
	muls.w	(a2),d0
	move.w	d3,d1
	muls.w	6(a2),d1
	move.w	d3,d2
	muls.w	12(a2),d2
		
	move.w	(a0)+,d5	;y
	move.w	d5,d4
	muls.w	2(a2),d4
	add.l	d4,d0
	move.w	d5,d4
	muls.w	2+6(a2),d4
	add.l	d4,d1
	move.w	d5,d4
	muls.w	2+12(a2),d4
	add.l	d4,d2

	move.w	(a0)+,d6	;z
	move.w	d6,d4
	muls.w	4(a2),d4
	add.l	d4,d0
	move.w	d6,d4
	muls.w	4+6(a2),d4
	add.l	d4,d1
	move.w	d6,d4
	muls.w	4+12(a2),d4
	add.l	d4,d2

	move.l	d0,(a1)+
	move.l	d1,(a1)+
	move.l	d2,(a1)+

	dbf		d7,.RotateVector
	rts
	ENDC

;======================================

	IFNE	UTIL_600_SCREEN_ADDRESS
;a0 = save buffer
Init600:	
	lea		$600.w,a1
	move.w	#16000-1,d7
.SaveRAM:
	move.l	(a1)+,(a0)+
	dbf		d7,.SaveRAM
	
	lea		$600.W,a0
	move.w	#16000-1,d7
	moveq	#0,d0
.ClearRAM:
	move.l	d0,(a0)+
	dbf		d7,.ClearRAM
	rts
	
;a0 = save buffer
Restore600:	
	lea		$600.w,a0
	move.w	#16000-1,d7
.RestoreRAM:
	move.l	(a1)+,(a0)+
	dbf		d7,.RestoreRAM
	rts
	ENDC
	
;======================================

	IFNE	UTIL_CREATE_PIXEL_TABLE
SINGLE_PIXEL_TABLE_SIZE			= 320*2
SINGLE_PIXEL_TABLE_START_OFFSET	= 4*160		;4*160 to add 160 to x (move them to screen center)
;PixelTable2	ds.w	320*2

;a0 = destination
CreateSinglePixelTable:
;	lea		.PixelTable,a1
;	lea		PixelTable2,a0
	moveq	#3,d3
	moveq	#4,d4
;	moveq	#1,d3
;	move.w	#~3,d4
	moveq	#0,d0			;x value
	move.w	#320-1,d7		;table valid for 320 pixels
	move.w	#$8000,d2
.CreateTable
;	move.w	d0,d1
;	and.w	#15,d1
;	add.w	d1,d1
;	move.w	(a1,d1.w),d1
;	move.w	d1,(a0)+		;pixel mask

	move.w	d2,(a0)+		;pixel mask
	lsr.w	#1,d2
	bne.s	.NotZero
	move.w	#$8000,d2
.NotZero
	
	move.w	d0,d1
	lsr.w	d4,d1
	lsl.w	d3,d1
;	lsr.w	d3,d1	***
;	and.w	d4,d1	***doesn't work
	move.w	d1,(a0)+		;screen offset
	
	addq.w	#1,d0			;next pixel
	dbf		d7,.CreateTable
	rts
;.PixelTable	dc.w	$8000,$4000,$2000,$1000,$800,$400,$200,$100,$80,$40,$20,$10,$8,$4,$2,$1
	ENDC

	IFNE	UTIL_CREATE_PIXEL_TABLE2
SINGLE_PIXEL_TABLE_SIZE			= 320
SINGLE_PIXEL_TABLE_START_OFFSET	= 2*160		;2*160 to add 160 to x (move them to screen center)
;a0 = destination
CreateSinglePixelTable:
	moveq	#0,d0			;x value
	move.w	#320-1,d7		;table valid for 320 pixels
	move.w	#$8000,d2
.CreateTable
	move.w	d2,d3
	lsr.w	#1,d2
	bne.s	.NotZero
	move.w	#$8000,d2
.NotZero

	move.w	d0,d1
	lsr.w	#4,d1
	lsl.w	#3,d1
	
	tst.b	d3
	beq.s	.NullByte
	addq.w	#1,d1
.NullByte
	lsr.w	#8,d3

	move.b	d3,(a0)+		;pixel mask
	move.b	d1,(a0)+		;screen offset
	
	addq.w	#1,d0			;next pixel
	dbf		d7,.CreateTable
	rts
	ENDC

;======================================

	IFNE	UTIL_CREATE_MULS_TABLE
MULS_TABLE_SIZE			= 400
MULS_TABLE_START_OFFSET	= 200*2+2*100	;200*2 to skip the negative y part, 100*2 to add 100 to y (move them to screen center)
;a0 = destination
CreateMulsTable:
	move	#-200*160,d1
	move	#400-1,d0
.InitMulsTable
	move	d1,(a0)+
	add		#160,d1
	dbf		d0,.InitMulsTable
	rts
;MulsTable		ds.w	400
	ENDC

;======================================
