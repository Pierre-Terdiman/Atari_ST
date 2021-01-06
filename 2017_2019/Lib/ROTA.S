
;Special version that doesn't do the final "lsr #15" but instead output the dword as-is.
;ROTA_SPECIAL	=	1

;Rotate vectors. Regular version, computes z, no special tricks.
;Also stores results in destination buffer, which is slower than using the results directly.
;a0 = source (x y z 16bits)
;a1 = destination (x y z 16bits) or 32bits with ROTA_SPECIAL
;a2 = rotation matrix
;d7 = nb pts - 1
RotatePointsSpecial:
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

	IFNE	ROTA_SPECIAL
		move.l	d0,(a1)+
		move.l	d1,(a1)+
		move.l	d2,(a1)+
	ELSE
		add.l	d0,d0
		swap	d0
		add.l	d1,d1
		swap	d1
		add.l	d2,d2
		swap	d2
		
		move.w	d0,(a1)+
		move.w	d1,(a1)+
		move.w	d2,(a1)+
	ENDC
	
	dbf		d7,.RotateVector
	rts
