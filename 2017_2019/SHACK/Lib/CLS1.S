
;a0 = screen address
;d0 = clear value (word)
Lib_ClearScreen_1P:
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
