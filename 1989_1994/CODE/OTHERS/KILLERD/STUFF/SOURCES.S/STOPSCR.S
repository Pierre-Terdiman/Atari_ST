orig_value	move.w	#$2700,sr
		lea	$0fffa00,a0
		lea	sauve_mfp,a1
		move.b	(a1)+,$07(a0)
		move.b	(a1)+,$13(a0)
		move.b	(a1)+,$1b(a0)
		move.b	(a1)+,$21(a0)
		move.l	(a1)+,$0120
		move.l	midi_orig+2,$0118
		move.l	vbl_orig+2,$070
		move.w	#$2000,sr
