
;a0 = screen address
;d0 = clear value (dword)
Lib_ClearScreen_2P:
	move.w	#200-1,d7
.Clear
	move.l	d0,(a0)
N	set		8
	REPT	20-1
		move.l	d0,N(a0)
N	set		N+8
	ENDR
	lea		160(a0),a0
	dbf		d7,.Clear
	rts
