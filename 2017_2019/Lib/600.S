
;a0 = save buffer
Init600:	
	lea		$600.w,a1
	move.w	#(16000/8)-1,d7
.SaveRAM:
	REPT	8
		move.l	(a1)+,(a0)+
	ENDR
	dbf		d7,.SaveRAM
	
	lea		$600.W,a0
	move.w	#(16000/8)-1,d7
	moveq	#0,d0
.ClearRAM:
	REPT	8
		move.l	d0,(a0)+
	ENDR
	dbf		d7,.ClearRAM
	rts
	
;a0 = save buffer
Restore600:	
	lea		$600.w,a0
	move.w	#(16000/8)-1,d7
.RestoreRAM:
	REPT	8
		move.l	(a1)+,(a0)+
	ENDR
	dbf		d7,.RestoreRAM
	rts

