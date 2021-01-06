
SAVED_ENV_DWORD_SIZE	=	14+8+2+2

send_ikbd:
; sendet Byte aus d0 an IKBD
	lea		$fffffc00.w,A0
.waitkeyready:
	btst	#1,(A0)
	beq.s	.waitkeyready
	move.b	D0,2(A0)
	rts

Lib_SaveEnv:
	lea		SavedEnv,a0	;a0 = buffer of SAVED_ENV_DWORD_SIZE dword where env variables get saved
	
	;14 dwords
	move.l	$008.w,(a0)+
	move.l	$00C.w,(a0)+
	move.l	$010.w,(a0)+
	move.l	$014.w,(a0)+
	move.l	$018.w,(a0)+
	move.l	$01c.w,(a0)+
	move.l	$020.w,(a0)+
	move.l	$024.w,(a0)+
	move.l	$68.w,(a0)+
	move.l	$70.w,(a0)+
	move.l	$114.w,(a0)+
	move.l	$118.w,(a0)+
	move.l	$120.w,(a0)+
	move.l	$134.w,(a0)+

	;8 dwords
	movem.l	$ffff8240.w,d0-d7
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	move.l	d2,(a0)+
	move.l	d3,(a0)+
	move.l	d4,(a0)+
	move.l	d5,(a0)+
	move.l	d6,(a0)+
	move.l	d7,(a0)+

	;8 bytes = 2 dwords
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$fffffa19.w,(a0)+
	move.b	$fffffa1b.w,(a0)+
	move.b	$fffffa1d.w,(a0)+

	;8 bytes = 2 dwords
	move.b	$FFFF8201.w,(a0)+
	move.b	$FFFF8203.w,(a0)+
	move.b	$FFFF820d.w,(a0)+
	move.b	$ffff8260.w,(a0)+
	move.b	$ffff820a.w,(a0)+
	move.b	#0,(a0)+	;padding
	move.w	SR,(a0)+
	
	moveq	#$12,D0		; Maus aus
	bsr		send_ikbd
	
	rts
	
Lib_RestoreEnv:
	lea		SavedEnv,a0	;a0 = buffer of SAVED_ENV_DWORD_SIZE dword where env variables get saved

	move.l	(a0)+,$008.w
	move.l	(a0)+,$00C.w
	move.l	(a0)+,$010.w
	move.l	(a0)+,$014.w
	move.l	(a0)+,$018.w
	move.l	(a0)+,$01c.w
	move.l	(a0)+,$020.w
	move.l	(a0)+,$024.w
	move.l	(a0)+,$68.w
	move.l	(a0)+,$70.w
	move.l	(a0)+,$114.w
	move.l	(a0)+,$118.w
	move.l	(a0)+,$120.w
	move.l	(a0)+,$134.w

	movem.l	(a0)+,d0-d7
	movem.l	d0-d7,$ffff8240.w

	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$fffffa19.w
	move.b	(a0)+,$fffffa1b.w
	move.b	(a0)+,$fffffa1d.w

	move.b	(a0)+,$FFFF8201.w
	move.b	(a0)+,$FFFF8203.w
	move.b	(a0)+,$FFFF820d.w
	move.b	(a0)+,$ffff8260.w
	move.b	(a0)+,$ffff820a.w
	lea		1(a0),a0	;padding
	move.w	(a0)+,SR
	
	moveq	#$08,D0		; Maus wieder ein
	bsr		send_ikbd
	
	rts
