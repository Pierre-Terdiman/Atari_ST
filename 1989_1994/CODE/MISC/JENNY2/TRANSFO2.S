DEBUT:	
	LEA.L 	D_PILE,A7
	
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP

	CLR.W 	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2

	MOVE.L	#5,D0	DEPART
	MOVE.L	#315,D1	ARRIVEE
	LEA	COORD,A0
	JSR	DO_TRANS
	MOVE.L	#15,D0	DEPART
	MOVE.L	#5,D1	ARRIVEE
	LEA	COORD,A0
	ADDQ.L	#2,A0
	JSR	DO_TRANS
	MOVE.L	#7,D0	DEPART
	MOVE.L	#100,D1	ARRIVEE
	LEA	COORD,A0
	ADDQ.L	#4,A0
	JSR	DO_TRANS
	MOVE.L	#195,D0	DEPART
	MOVE.L	#185,D1	ARRIVEE
	LEA	COORD,A0
	ADDQ.L	#6,A0
	JSR	DO_TRANS
	LEA	COORD,A0
	LEA	4*120*2(A0),A0
	MOVE.L	#$99999999,(A0)

	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	MOVE.L	#VBL,$70.W

BOUCLE	BRA.S	BOUCLE
FIN	MOVE.L	4.W,A0
	JMP	(A0)

VBL
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	MOVE	#$666,$FFFF8242.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	efecr
	ST	$FFFF8240.W
efecr	
	movea.l	SCREEN1,a0
;	LEA	160*60(A0),A0
	
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	sub.l	a1,a1
	sub.l	a2,a2
	sub.l	a3,a3
	sub.l	a4,a4
	sub.l	a5,a5
	sub.l	a6,a6
efecr1	
	MOVE	#199,D1
CLS
N	SET	0
	REPT	20
	MOVE	D0,N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D1,CLS

	LEA	COORD,A0
	ADDA.L	PNT,A0
	CMPI.L	#$99999999,(A0)
	BNE.S	OKOK
	CLR.L	PNT
	LEA	COORD,A0
OKOK	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace


	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	SF	$FFFF8240.W

;	CMPI.B	#$39,$FFFFFC02.W
;	BEQ	FIN
INTER_RTE	RTE
	MOVE.L	#0,D0	DEPART
	MOVE.L	#319,D1	ARRIVEE
	LEA	COORD,A0
DO_TRANS
	MOVE.L	#120,D2	EN 'D2' PASSES
	MOVE.L	D2,D6
	MOVE	D2,MODIF
	MOVE	D2,MODIF_

	LSL.L	#8,D0
	LSL.L	#8,D1
	CMP.L	D0,D1
	BGT.S	ROUTY1
ROUTY2	;D1 PLUS PETIT
	MOVE.L	D0,D2
	SUB.L	D1,D0	D1=AMPLITUDE
	DIVU	D6,D0
	SWAP	D0
	CLR	D0
	SWAP	D0
MODIF_	EQU	*+2
	MOVE	#0,D7
	SUBQ	#1,D7
DO_IT_AGAIN_	SUB.L	D0,D2
	MOVE.L	D2,D3
	LSR.L	#8,D3	CA EN FAIT UN
	MOVE	D3,(A0)
	ADDQ.L	#8,A0
	DBF	D7,DO_IT_AGAIN_
FINI2	RTS
****
	
ROUTY1	;D0 PLUS PETIT
	MOVE.L	D0,D2
	SUB.L	D0,D1	D1=AMPLITUDE
	DIVU	D6,D1
	SWAP	D1
	CLR	D1
	SWAP	D1
MODIF	EQU	*+2
	MOVE	#0,D7
	SUBQ	#1,D7
DO_IT_AGAIN	ADD.L	D1,D2
	MOVE.L	D2,D3
	LSR.L	#8,D3	CA EN FAIT UN
	MOVE	D3,(A0)
	ADDQ.L	#8,A0
	DBF	D7,DO_IT_AGAIN
FINI	RTS
****

*_______________________________________________________

	*entre	x1=d0,x2=d2,y1=d1,y2=d3*
	     *origin haut gauche ecran*
		*pas de clip*
*-------------------------------------------------------
************************************************
**ligne -15-vers 1.0 *code zerioul holocaust**
************************************************
trace:
	movea.l	SCREEN2,a0
	
	cmp.w	d0,d2
	bge.s 	suit1
	exg.l	d0,d2
	exg.l	d1,d3 
suit1
	move.w	d1,d7	

	cmp.w	d1,d3
	bge.s 	suit2
	
	exg.l	d1,d3	
	move.w	#-160,d5
	bra.s	suit2s
suit2
	move.w	#160,d5
suit2s
			*_a retoucher
	move.w	d2,d4	*
	sub.w	d0,d2	
	sub.w	d1,d3
	
	add.w	d0,d0	*pour posinit a0
	lea.l	posx(pc),a1		
	move.w	(a1,d0.w),d1
	add.w	d7,d7
	lea.l	posy(pc),a1		
	move.w 	(a1,d7.w),d7	
	add.w	d1,d7
	lea.l	(a0,d7.w),a0
	
	cmp.w	d2,d3
	bge.w	point2
	
	cmp.w	#17,d2
	ble	point11
	
	lea.l	fdpx(pc),a1		;d4=x2
	add.w	d4,d4
	add.w	d4,d4
	move.l	(a1,d4.w),d4
	move.w	d4,saut+2
	swap	d4
	
	lea.l	ddpx(pc),a1		
	add.w	d0,d0	
	move.l	(a1,d0.w),a1
	add.w	d4,a1
	
point1
	addq.l	#1,d2
	swap	d3
	divu	d2,d3	
	moveq.w	#0,d4

	move.w	d3,a2
	move.w	d5,a5
	move.w	#7,d0
	move.w	#6,d1
	move.w	#5,d2
	move.w	#4,d6
	move.w	#3,d7
	move.w	#2,d3
	move.w	#1,d5
	
	jmp	(a1)
lignt	macro

	bset.b	d0,(a0)
	add.w	a2,d4		8
	bcc.s	point111\@1
	add.w	a5,a0
point111\@1	
	bset.b	d1,(a0)		8
	add.w	a2,d4
	bcc.s	point112\@1
	add.w	a5,a0
point112\@1	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	point113\@1		8
	add.w	a5,a0
point113\@1	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	point114\@1		8
	add.w	a5,a0
point114\@1	
	bset.b	d7,(a0)
	add.w	a2,d4		8
	bcc.s	point115\@1
	add.w	a5,a0
point115\@1	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	point116\@1		8
	add.w	a5,a0
point116\@1	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	point117\@1		8
	add.w	a5,a0
point117\@1	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0		12
	bcc.s	point118\@1
	add.w	a5,a0			
point118\@1
	bset.b	d0,(a0)		8
	add.w	a2,d4
	bcc.s	point119\@1
	add.w	a5,a0
point119\@1	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	point1110\@1	8
	add.w	a5,a0		
point1110\@1	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	point1111\@1	8
	add.w	a5,a0
point1111\@1			
	bset.b	d6,(a0)
	add.w	a2,d4		8
	bcc.s	point1112\@1
	add.w	a5,a0
point1112\@1	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	point1113\@1	8
	add.w	a5,a0
point1113\@1	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	point1114\@1	8	
	add.w	a5,a0
point1114\@1	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	point1115\@1	8
	add.w	a5,a0
point1115\@1	
	bset.b	#0,(a0)
	add.w	a2,d4		12
	addq.l	#7,a0
	bcc.s	point1115\@1+12
	add.w	a5,a0

	endm
trace11
n	set	0
	rept	20
	lignt	n
n	set	n+1	
	endr
	
saut	bra	ftrac1
ftrac1
	rts

ftrac2	
	bset.b	d0,(a0)
	rts

ftrac3	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf31
	add.w	a5,a0
pointf31	
	bset.b	d1,(a0)
	rts

ftrac4	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf41
	add.w	a5,a0
pointf41	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf42
	add.w	a5,a0
pointf42	
	bset.b	d2,(a0)
	rts

ftrac5	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf51
	add.w	a5,a0
pointf51	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf52
	add.w	a5,a0
pointf52	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf53
	add.w	a5,a0
pointf53	
	bset.b	d6,(a0)
	rts

ftrac6	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf61
	add.w	a5,a0
pointf61	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf62
	add.w	a5,a0
pointf62	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf63
	add.w	a5,a0
pointf63	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf64
	add.w	a5,a0
pointf64	
	bset.b	d7,(a0)
	rts

ftrac7	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf71
	add.w	a5,a0
pointf71	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf72
	add.w	a5,a0
pointf72	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf73
	add.w	a5,a0
pointf73	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf74
	add.w	a5,a0
pointf74	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf75
	add.w	a5,a0
pointf75	
	bset.b	d3,(a0)
	
	rts

ftrac8	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf81
	add.w	a5,a0
pointf81	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf82
	add.w	a5,a0
pointf82	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf83
	add.w	a5,a0
pointf83	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf84
	add.w	a5,a0
pointf84	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf85
	add.w	a5,a0
pointf85	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf86
	add.w	a5,a0
pointf86	
	bset.b	d5,(a0)
	
	rts

ftrac9	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf91
	add.w	a5,a0
pointf91	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf92
	add.w	a5,a0
pointf92	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf93
	add.w	a5,a0
pointf93	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf94
	add.w	a5,a0
pointf94	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf95
	add.w	a5,a0
pointf95	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf96
	add.w	a5,a0
pointf96	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf97
	add.w	a5,a0
pointf97	
	bset.b	#0,(a0)
	
	rts

ftrac10	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf101
	add.w	a5,a0
pointf101	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf102
	add.w	a5,a0
pointf102	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf103
	add.w	a5,a0
pointf103	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf104
	add.w	a5,a0
pointf104	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf105
	add.w	a5,a0
pointf105	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf106
	add.w	a5,a0
pointf106	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf107
	add.w	a5,a0
pointf107	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf108
	add.w	a5,a0
pointf108	
	bset.b	d0,(a0)
	rts

ftrac11	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf111
	add.w	a5,a0
pointf111	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf112
	add.w	a5,a0
pointf112	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf113
	add.w	a5,a0
pointf113	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf114
	add.w	a5,a0
pointf114	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf115
	add.w	a5,a0
pointf115	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf116
	add.w	a5,a0
pointf116	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf117
	add.w	a5,a0
pointf117	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf118
	add.w	a5,a0
pointf118	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf119
	add.w	a5,a0
pointf119
	bset.b	d1,(a0)
	rts
	
ftrac12
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf121
	add.w	a5,a0
pointf121	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf122
	add.w	a5,a0
pointf122	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf123
	add.w	a5,a0
pointf123	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf124
	add.w	a5,a0
pointf124	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf125
	add.w	a5,a0
pointf125	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf126
	add.w	a5,a0
pointf126	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf127
	add.w	a5,a0
pointf127	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf128
	add.w	a5,a0
pointf128	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf129
	add.w	a5,a0
pointf129
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1210
	add.w	a5,a0
pointf1210
	bset.b	d2,(a0)
	rts
	
ftrac13	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf131
	add.w	a5,a0
pointf131	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf132
	add.w	a5,a0
pointf132	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf133
	add.w	a5,a0
pointf133	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf134
	add.w	a5,a0
pointf134	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf135
	add.w	a5,a0
pointf135	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf136
	add.w	a5,a0
pointf136	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf137
	add.w	a5,a0
pointf137	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf138
	add.w	a5,a0
pointf138	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf139
	add.w	a5,a0
pointf139
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1310
	add.w	a5,a0
pointf1310
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1311
	add.w	a5,a0
pointf1311
	bset.b	d6,(a0)
	rts
	
ftrac14	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf141
	add.w	a5,a0
pointf141	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf142
	add.w	a5,a0
pointf142	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf143
	add.w	a5,a0
pointf143	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf144
	add.w	a5,a0
pointf144	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf145
	add.w	a5,a0
pointf145	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf146
	add.w	a5,a0
pointf146	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf147
	add.w	a5,a0
pointf147	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf148
	add.w	a5,a0
pointf148	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf149
	add.w	a5,a0
pointf149
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1410
	add.w	a5,a0
pointf1410
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1411
	add.w	a5,a0
pointf1411
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf1412
	add.w	a5,a0
pointf1412
	bset.b	d7,(a0)
	rts
	
ftrac15	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf151
	add.w	a5,a0
pointf151	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf152
	add.w	a5,a0
pointf152	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf153
	add.w	a5,a0
pointf153	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf154
	add.w	a5,a0
pointf154	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf155
	add.w	a5,a0
pointf155	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf156
	add.w	a5,a0
pointf156	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf157
	add.w	a5,a0
pointf157	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf158
	add.w	a5,a0
pointf158	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf159
	add.w	a5,a0
pointf159
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1510
	add.w	a5,a0
pointf1510
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1511
	add.w	a5,a0
pointf1511
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf1512
	add.w	a5,a0
pointf1512
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf1513
	add.w	a5,a0
pointf1513
	bset.b	d3,(a0)
	rts
	
ftrac16	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf161
	add.w	a5,a0
pointf161	
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf162
	add.w	a5,a0
pointf162	
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf163
	add.w	a5,a0
pointf163	
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf164
	add.w	a5,a0
pointf164	
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf165
	add.w	a5,a0
pointf165	
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf166
	add.w	a5,a0
pointf166	
	bset.b	d5,(a0)
	add.w	a2,d4
	bcc.s	pointf167
	add.w	a5,a0
pointf167	
	bset.b	#0,(a0)
	add.w	a2,d4
	addq.l	#1,a0
	bcc.s	pointf168
	add.w	a5,a0
pointf168	
	bset.b	d0,(a0)
	add.w	a2,d4
	bcc.s	pointf169
	add.w	a5,a0
pointf169
	bset.b	d1,(a0)
	add.w	a2,d4
	bcc.s	pointf1610
	add.w	a5,a0
pointf1610
	bset.b	d2,(a0)
	add.w	a2,d4
	bcc.s	pointf1611
	add.w	a5,a0
pointf1611
	bset.b	d6,(a0)
	add.w	a2,d4
	bcc.s	pointf1612
	add.w	a5,a0
pointf1612
	bset.b	d7,(a0)
	add.w	a2,d4
	bcc.s	pointf1613
	add.w	a5,a0
pointf1613
	bset.b	d3,(a0)
	add.w	a2,d4
	bcc.s	pointf1614
	add.w	a5,a0
pointf1614
	bset.b	d5,(a0)
	rts	
	
point11
	lea.l	ppxpet(pc),a1
	add.w	d0,d0
	add.w	d0,a1
	
	tst.w	d3
	beq	point12
	move.w	d3,d6
	
	subq.l	#1,d6
	move.w	d2,d4
	addq.l	#2,a1
	move.w	(a1)+,d0
bpoint11
	bset.b	d0,(a0)
	add.w	(a1)+,a0
	move.w	(a1)+,d0
	sub.w	d3,d4
	bge.s	bpoint11
	add.w	d5,a0
	add.w	d2,d4
spoint11
	dbra.w	d6,bpoint11
	rts
point12
	subq.l	#1,d2
	addq.l	#2,a1
	move.w	(a1)+,d0
bpoint12	
	bset	d0,(a0)
	add.w	(a1)+,a0
	move.w	(a1)+,d0
	dbra.w	d2,bpoint12
	rts
point2
	addq.l	#1,d3
	swap	d2
	divu	d3,d2	
	moveq.w	#0,d4
	lea.l	ppxpet(pc),a1
	add.w	d0,d0
	add.w	d0,a1
	addq.l	#2,a1
	move.w	(a1)+,d0
	muls.w	#12,d3
	neg	d3
	lea.l	linvt(pc),a2
	jmp	(a2,d3.w)


lign	macro
	bset.b	d0,(a0)
	add.w	d5,a0
	add.w	d2,d4
	bcc.s	ligv\@1	
	add.w	(a1)+,a0
	move.w	(a1)+,d0
ligv\@1		
	endm

n	set	0
	rept	201
	lign	n
n	set	n+1	
	endr
linvt	
	
	rts
			
	DATA

ddpx	
n	set	0
	rept	20
	dc.l	trace11+n,trace11+n+8,trace11+n+16,trace11+n+24,trace11+n+32,trace11+n+40
	dc.l	trace11+n+48,trace11+n+56,trace11+n+68,trace11+n+76,trace11+n+84,trace11+n+92
	dc.l	trace11+n+100,trace11+n+108,trace11+n+116,trace11+n+124
n	set	n+136
	endr

fdpx
n	set	20*136
	rept	20
	dc.w 	n,ftrac2-saut-2,n,ftrac3-saut-2
	dc.w 	n,ftrac4-saut-2,n,ftrac5-saut-2
	dc.w 	n,ftrac6-saut-2,n,ftrac7-saut-2
	dc.w 	n,ftrac8-saut-2,n,ftrac9-saut-2
	dc.w 	n,ftrac10-saut-2,n,ftrac11-saut-2
	dc.w 	n,ftrac12-saut-2,n,ftrac13-saut-2
	dc.w 	n,ftrac14-saut-2,n,ftrac15-saut-2
	dc.w 	n,ftrac16-saut-2,n-136,ftrac1-saut-2
n	set	n-136
	endr

posx	
n	set	0
	rept	160/8
	dc.w	n,n,n,n
	dc.w	n,n,n,n
	dc.w	n+1,n+1,n+1,n+1
	dc.w	n+1,n+1,n+1,n+1
n	set	n+8
	endr  

posy:	
	
n	set 	-160*3
	rept	206	
	dc.w	n	
n	set n+160
	endr

ppxpet
	rept	(160/8)
	dc.w	7,7,0,6,0,5,0,4
	dc.w	0,3,0,2,0,1,0,0
	dc.w	1,7,0,6,0,5,0,4
	dc.w	0,3,0,2,0,1,0,0
	endr

FORME_DEP	DC	5,5,5,195
FORME_FIN	DC	100,20,310,190

 	BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1
PNT	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	32000*2
COORD	DS	4*120+4
