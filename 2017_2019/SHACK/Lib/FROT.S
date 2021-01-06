;68000 version of my 1995 "fastrot" article

;==============================

	IFNE	FASTROT_DEBUG

;Debug rendering function
;Renders rotated frame and interpolated vectors

_DebugPlotDot	MACRO
	add.w	d0,d0
	add.w	d0,d0
	add		d1,d1
	
	move.l	(a5,d0.w),d0
	move	d0,d2
	swap	d0
	add.w	(a4,d1.w),d2
	or.w	d0,(a1,d2.w)
	ENDM

_DrawInterpolatedAxis:
	;Draw interpolated vectors. This code needs to take into account any optimization or tweaks
	;we used in the interpolation code.
	move.w	#NB_INTERPOLATED-1,d7
.AffInter
	move.l	(a0)+,d0
	move.l	(a0)+,d1
	IFNE	FASTROT_COMPUTE_Z
		move.l	(a0)+,d2
	ENDC
	
	;do the missing "lsr #15" from RotatePointsSpecial
	;FASTROT_NOTE1: the two removed adds are part of the "lsr" and we only do them to move the bits where we want them.
	;We can get rid of the adds by making sure all interpolated values are twice as big, which is achieved by simply
	;doubling the interpolation increments. See other FASTROT_NOTE1.
;	add.l	d0,d0
	swap	d0
;	add.l	d1,d1
	swap	d1
	
	;We're not doing proper projection so d2 == z is ignored
	
	_DebugPlotDot
	
	dbf		d7,.AffInter
	rts

FastRot_DebugRenderFrame:
	;bra		.PlotFrameExtents
;	lea		PixelTable,a2
	move.l	ScreenPtr2,a1
	lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
	lea		MulsTable+MULS_TABLE_START_OFFSET,a4

	lea		RotatedX,a0
	bsr.s	_DrawInterpolatedAxis

	lea		RotatedY,a0
	bsr.s	_DrawInterpolatedAxis

	lea		RotatedZ,a0
	bsr.s	_DrawInterpolatedAxis
	
.PlotFrameExtents
	;Here we simply draw one dot at each end of the rotated frame
	lea		RotatedFrame,a0
	move.w	#3-1,d7
.AffFrameDot
	move.l	(a0)+,d0	;x from RotatePointsSpecial
	move.l	(a0)+,d1	;y from RotatePointsSpecial
	move.l	(a0)+,d2	;z from RotatePointsSpecial
	
	;do the missing "lsr #15" from RotatePointsSpecial
	add.l	d0,d0
	swap	d0
	add.l	d1,d1
	swap	d1
	
	;We're not doing proper projection so d2 == z is ignored
	
	_DebugPlotDot	

	dbf		d7,.AffFrameDot	
	rts

	ENDC

;==============================

	IFNE	FASTROT_USE_HACK
NB_UNROLLED	=	NB_INTERPOLATED/2
	ELSE
NB_UNROLLED	=	NB_INTERPOLATED
	ENDC

;- - - - - - - - - - - - - - -

_PrepInterp	MACRO
	divs	#NB_INTERPOLATED,\1
	ext.l	\1
		;FASTROT_NOTE1: double interpolation increment to remove adds in plot macro. See other FASTROT_NOTE1.
		add.l	\1,\1
		IFNE	FASTROT_INTERNAL_SCALE
			;FASTROT_NOTE2: this other one is a cheap way to scale the object without increasing FRAME_SIZE/NB_INTERPOLATED.
			add.l	\1,\1
		ENDC

;This commented out bit was in FastRot.s
;		IFNE	FASTROT_TEST
;			add.l	d3,d3
;			add.l	d3,d3
;		ENDC
;		clr.b	d3
;		add.l	d3,d3	;HACK	
		
	moveq	#0,\2

	;FASTROT_NOTE2: this hack isn't a safe optimization: by tweaking the coordinates of the source data/pts,
	;we can make sure we'll never need odd interpolated vectors. So we don't compute them.
	IFNE	FASTROT_USE_HACK
		;FASTROT_NOTE2: double interpolation increment to skip odd vectors
		add.l	\1,\1
	ENDC
	ENDM

;- - - - - - - - - - - - - - -

_Interp	MACRO
	IFNE	FASTROT_LOW_ACCURACY
		move.l	\1,d6
		swap	d6
;This commented out bit was in FastRot.s in the X interpolation
;		IFNE	FASTROT_TEST
;			add.w	d6,d6
;			add.w	d6,d6
;			add.w	#10,d6
;		ENDC
		move.w	d6,(a2)+
	ELSE
		move.l	\1,(a2)+
	ENDC
	add.l	\2,\1	;Interpolation
	ENDM

;- - - - - - - - - - - - - - -

;Generic version
_FastRot_InterpolateAxis
;	move.l	(a1)+,d3
;	move.l	(a1)+,d4
;	move.l	(a1)+,d5
	movem.l	(a1)+,d3-d5
	
	_PrepInterp	d3,d0
	_PrepInterp	d4,d1
	IFNE	FASTROT_COMPUTE_Z
		_PrepInterp	d5,d2
	ENDC

	REPT	NB_UNROLLED
		;TODO: try movem.l here?
		
		;Interpolate X
		_Interp	d0,d3

		;Interpolate Y - we cannot use the macro because of FASTROT_INTERP_MULTABLE
		IFNE	FASTROT_LOW_ACCURACY
			move.l	d1,d6
			swap	d6
			IFNE	FASTROT_INTERP_MULTABLE
				add.w	d6,d6
				move.w	(a4,d6.w),d6
			ENDC
			move.w	d6,(a2)+
		ELSE
			move.l	d1,(a2)+
		ENDC
		add.l	d4,d1
		
		;Interpolate Z
		IFNE	FASTROT_COMPUTE_Z
			_Interp	d2,d5
		ENDC

		IFNE	FASTROT_USE_HACK
			lea		FASTROT_NB_COORDS*FASTROT_ACCURACY(a2),a2
		ENDC
	ENDR
	rts

;- - - - - - - - - - - - - - -

	IFNE	FASTROT_ROTA_XY
;Copy of the above with bits disabled for 2D XY rotations
_FastRot_InterpolateAxisSpecial:
	movem.l	(a1)+,d3-d5
	
	_PrepInterp	d3,d0
	IFNE	FASTROT_COMPUTE_Z
		_PrepInterp	d5,d2
	ENDC

	REPT	NB_UNROLLED
		;TODO: try movem.l here?
		
		;Interpolate X		
		_Interp	d0,d3

		;Y interpolation is entirely skipped in this special function (that's the whole point)		
		lea		FASTROT_ACCURACY(a2),a2
		
		;Interpolate Z		
		IFNE	FASTROT_COMPUTE_Z
			_Interp	d2,d5
		ENDC

		IFNE	FASTROT_USE_HACK
			lea		FASTROT_NB_COORDS*FASTROT_ACCURACY(a2),a2
		ENDC
	ENDR
	rts
	ENDC	;FASTROT_ROTA_XY

;- - - - - - - - - - - - - - -

FastRot_Interpolate_Version0:

	;Rotate the frame (3 pts) with regular rotation code
	lea		Frame,a0
	lea		RotatedFrame,a1
	lea		Matrix,a2
	move.w	#3-1,d7
	bsr		RotatePointsSpecial

	;Interpolate NB_INTERPOLATED vectors along the frame axes
	
	lea		RotatedFrame,a1
	IFNE	FASTROT_INTERP_MULTABLE
;		lea		MulsTable+MULS_TABLE_START_OFFSET,a4
		lea		MulsTable+200*2,a4	;TODO: comment this
	ENDC
	
	lea		RotatedX,a2
	IFNE	FASTROT_ROTA_XY
		bsr		_FastRot_InterpolateAxisSpecial
	ELSE
		bsr		_FastRot_InterpolateAxis
	ENDC

	lea		RotatedY,a2
	bsr		_FastRot_InterpolateAxis

	lea		RotatedZ,a2
	bsr		_FastRot_InterpolateAxis
	rts
	
;==============================

	IFNE	FASTROT_INIT_VERSION0
FastRot_InitPts_Version0:
	lea		Pts,a0
	lea		SrcPts,a1
	move.w	#(NB_PTS*3)-1,d7
.Process
	move.w	(a1)+,d1

	;Rescale factor. This will depend on the 3D data.
;	ext.l	d1		
	asr.w	#3,d1
;	divs	#32768/80,d1

;	tst.w	d1
;	bge.s	.PosOrNull
;	neg.w	d1
;	move.w	#0,d1
;.PosOrNull		

	;Preprocessing. This will depend on selected version/algo.
	
	;Component is used to fetch interpolated vectors from "RotatedX" arrays. We have to premultiply
	;by sizeof(array[0]) (typically 12 in vanilla version)
	muls	#FASTROT_NB_COORDS*FASTROT_ACCURACY,d1

	move.w	d1,(a0)+
	dbf		d7,.Process
	rts
	ENDC
	
;==============================

	IFNE	FASTROT_VERSION0
;Basic version. Does not use symmetry, does not project, vanilla code written for clarity rather than speed.
;"Clarity" is relative considering the combinatorial explosion and the use of macros to tackle it......
FastRot_Version0:
	lea		Pts,a0
	move.l	ScreenPtr2,a1
	IFNE	FASTROT_INTERP_MULTABLE
		lea	160*100(a1),a1
	ENDC
	IFNE	FASTROT_BSET
		moveq	#0,d3
		lea		64(a1),a1
	ENDC
	lea		PixelTable2+SINGLE_PIXEL_TABLE_START_OFFSET,a5
	IFEQ	FASTROT_INTERP_MULTABLE
		lea		MulsTable+MULS_TABLE_START_OFFSET,a4
	ENDC
	move.w	#NB_PTS-1,d7
.AffDot

	;These could be avoided by having a dedicated ProcessComponent macro for X.
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2

;The biggest issue in this version is also the biggest strength: it tests the signs
;of all components at runtime (slow), meaning it's compatible with animated vertices.
;We can precompute all this away but then vertices must remain constant in local space.
ProcessComponent	MACRO
	move.w	(a0)+,d6	;x, y or z
	bge.s	.\1
	neg.w	d6
	adda.w	d6,a3
	IFNE	FASTROT_LOW_ACCURACY
		sub.w	(a3)+,d0
		sub.w	(a3)+,d1
		IFNE	FASTROT_COMPUTE_Z
			sub.w	(a3)+,d2
		ENDC
	ELSE
		sub.l	(a3)+,d0
		sub.l	(a3)+,d1
		IFNE	FASTROT_COMPUTE_Z
			sub.l	(a3)+,d2
		ENDC
	ENDC
	bra.s	.\2
.\1
	adda.w	d6,a3
	IFNE	FASTROT_LOW_ACCURACY
		add.w	(a3)+,d0
		add.w	(a3)+,d1
		IFNE	FASTROT_COMPUTE_Z
			add.w	(a3)+,d2
		ENDC
	ELSE
		add.l	(a3)+,d0
		add.l	(a3)+,d1
		IFNE	FASTROT_COMPUTE_Z
			add.l	(a3)+,d2
		ENDC
	ENDC
.\2
	ENDM

	lea		RotatedX,a3
	ProcessComponent	PosX,NegX
	lea		RotatedY,a3
	ProcessComponent	PosY,NegY
	lea		RotatedZ,a3
	ProcessComponent	PosZ,NegZ

	IFEQ	FASTROT_LOW_ACCURACY
		;The swaps are done in the interpolation instead when FASTROT_LOW_ACCURACY is used.
		swap	d0
		swap	d1
	ENDC
	
	;At this point, d0=x, d1=y, d2=z. So now we draw the pixel.

	IFEQ	FASTROT_INTERP_MULTABLE
		add		d1,d1			;y*2 = offset in muls table
		move.w	(a4,d1.w),d1	;d1 = y*160 = screen offset
	ENDC

	IFNE	FASTROT_COMPUTE_Z
		;TODO: move test close to d2 computation where it could be avoided
		;but then we cannot add to d1 directly...
		;Also compute Z first to reject dots
		
		;Put z>0 dots on plane 1, z<0 dots on plane 2
		IFNE	FASTROT_LOW_ACCURACY
			tst.w	d2
		ELSE
			tst.l	d2
		ENDC
		bge.s	.FrontPlane
		addq.w	#2,d1
.FrontPlane
;TODO: try something like this instead?
;		seq		d2
;		addq.w	#1,d2
;		add.w	d2,d2
	ENDC
	
	IFNE	FASTROT_BSET
		;move.w	d0,d3
		;not.w	d3
		move.b	(a5,d0.w),d3
		add.w	d3,d1
		bset	d0,(a1,d1.w)
	ELSE
		;x*4 = offset in pixel table	
		add.w	d0,d0
		add.w	d0,d0
;		and.w	#~3,d0
		move.l	(a5,d0.w),d0
		add.w	d0,d1
		swap	d0
		or.w	d0,(a1,d1.w)
	ENDC

	dbf		d7,.AffDot
	rts
	ENDC
	
;==============================
