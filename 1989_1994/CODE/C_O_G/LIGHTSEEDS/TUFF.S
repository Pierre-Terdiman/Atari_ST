	TEXT
DEBUT:	MOVEA.L  A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L 	$14(A5),D0
	ADD.L 	$1C(A5),D0
	ADD.L 	#$100,D0		
	MOVE.L 	D0,-(SP)		
	MOVE.L 	A5,-(SP)
	MOVE 	#0,-(SP)
	MOVE 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP
	
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	MOVE.L 	D0,SAUVE

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
**
	LEA	BUF_BOUL,A1
	MOVE	#15,D7
	
DOIT	LEA	BOUL,A0
	LEA	BOUL,A2
	MOVE	#31,D0
COP	MOVE	(A0)+,(A1)+
	DBF	D0,COP
	MOVE	#31,D6
DECAL	ROXR	(A2)
	LEA	2(A2),A2
	DBF	D6,DECAL
	DBF	D7,DOIT

**
	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2
			
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	MOVE.B	$FFFFFA15.W,MFP7
	MOVE.B	$FFFFFA17.W,MFP8
	MOVE.B	$FFFFFA19.W,MFP9
	MOVE.B	$FFFFFA1F.W,MFP10


	MOVE.L	$68.W,SAUVE_HBL
	MOVE.L	$134.W,SAUVE_TMA
	MOVE.L	#INTER_RTE,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	
	MOVE	#4,-(SP)
	TRAP 	#14
	ADDQ.L	#2,SP
	MOVE	D0,RES
	
	MOVE	#2,-(SP)
	TRAP 	#14
	ADDQ.L 	#2,SP
	MOVE.L	D0,ANC_ECR
	
	CLR.W 	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
	LEA	DATA_Y,A0
	MOVE.L	A0,USP
	        
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBL_IR,$70.W
	MOVE.L	$120.W,ANC_TB
	MOVE.L	#TB0_IR,$120.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	JMP	BOUCLE

FIN:	
	MOVE	#$2700,SR
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	MOVE.B	MFP7,$FFFFFA15.W
	MOVE.B	MFP8,$FFFFFA17.W
	MOVE.B	MFP9,$FFFFFA19.W
	MOVE.B	MFP10,$FFFFFA1F.W
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	SAUVE_TMA,$134.W
	MOVE.L	SAUVE_HBL,$68.W

	MOVE	#$2300,SR


	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	#2,$FFFF820A.W
	
	MOVE.W 	RES,-(SP)
	MOVE.L	ANC_ECR,-(SP)
	MOVE.L	ANC_ECR,-(SP)
	MOVE.W 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP
	
	MOVE.L	SAUVE,-(SP)
	MOVE.W 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	

	CLR.W 	-(SP)
	TRAP	#1
	
VBL_IR	
	SF	$FFFF8240.W
	MOVE	#$444,$FFFF8242.W
	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

;	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
;	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
;	MOVE.B	#4,$FFFFFA19.W
;	BCLR	#3,$FFFFFA17.W
;	MOVE.L	#INTER_TMA,$134.W
;	ORI.B	#$20,$FFFFFA13.W
;	ORI.B	#$20,$FFFFFA07.W

	MOVE.L	SCREEN2,A0
	LEA	140*160(A0),A0
	MOVEQ	#0,D0
N	SET	0
	REPT	60
	MOVE	D0,N(A0)
	MOVE	D0,N+8(A0)
	MOVE	D0,N+16(A0)
	MOVE	D0,N+24(A0)
	MOVE	D0,N+32(A0)
	MOVE	D0,N+40(A0)
	MOVE	D0,N+48(A0)
	MOVE	D0,N+56(A0)
	MOVE	D0,N+64(A0)
	MOVE	D0,N+72(A0)
	MOVE	D0,N+80(A0)
	MOVE	D0,N+88(A0)
	MOVE	D0,N+96(A0)
	MOVE	D0,N+104(A0)
	MOVE	D0,N+112(A0)
	MOVE	D0,N+120(A0)
	MOVE	D0,N+128(A0)
	MOVE	D0,N+136(A0)
	MOVE	D0,N+144(A0)
	MOVE	D0,N+152(A0)
N	SET	N+160
	ENDR

	MOVE.L	SCREEN2,A0
	LEA	-160*29(A0),A0
	LEA	BUF_BOUL,A1
	LEA	80(A0),A0
	MOVE.L	USP,A2
	MOVE	(A2),D0
	MULU	#160,D0
	ADDA.L	D0,A0

N	SET	0
	REPT	10
	CLR	N(A0)
	CLR	N+8(A0)
N	SET	N+160
	ENDR
	
;N	SET	0
	REPT	16
	MOVE	(A1)+,N(A0)
	MOVE	(A1)+,N+8(A0)
N	SET	N+160
	ENDR
	REPT	10
	CLR	N(A0)
	CLR	N+8(A0)
N	SET	N+160
	ENDR

	LEA	DATA_Y,A0
	ADDA.L	PNT_REB,A0
	CMPI.B	#-1,(A0)
	BNE.S	OK
	LEA	DATA_Y,A0
	CLR.L	PNT_REB
OK	MOVE.L	A0,USP
	MOVE	#1,D0
	MOVE	#150,D1
	MOVE	#168,D2
	MOVE	(A0),D3
	CMPI	#150,D3
	BGE.S	LP
	MOVE	#150,D3
LP	jsr	trace
	MOVE.L	USP,A0
	MOVE	#319,D0
	MOVE	#150,D1
	MOVE	#168,D2
	MOVE	(A0),D3
	CMPI	#150,D3
	BGE.S	LP2
	MOVE	#150,D3
LP2	jsr	trace
	
	addq.l	#2,PNT_REB
		


	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
INTER_RTE	RTE

INTER_TMA:	CLR.B	$FFFFFA07.W		; ARRET DU MFP POUR NE PAS
	CLR.B	$FFFFFA09.W		; ETRE GENE
	MOVE	#$2100,SR		; ON AUTORISE LA HBL

	MOVE.L	A6,USP
	
full
	MOVE.L	#$FFFF8209,A6
	MOVE.L	#$FFFF8260,A4
	MOVE.L	#$FFFF820A,A3

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100		; ATTENTE DE LA PROCHAINE HBL
				; (FIXE A 16 CYCLES PRES ENVIRONS)
	MOVE	#$2700,SR		; ON COUPE TOUTE LES ITs
	MOVE	#$2300,(SP)		; AU RETOUR LE VBL SERA AUTORISEE

	MOVEQ	#29,D2		; ON ATTEND LE BON MOMENT
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D0,(A3)		; ET HOP! PLUS DE BORDER HAUT
	REPT	6
	NOP
	ENDR
	MOVE.B	D1,(A3)

	RTE
	
TB0_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB0_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE	

TB1_IR
     REPT 127
	NOP			
     ENDR
	MOVE.B	#0,$FFFF820A.W	
     REPT 8
     	NOP			
     ENDR
	MOVE.B	#2,$FFFF820A.W	
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB0_IR,$120	
	BCLR	#0,$FFFFFA0F.W	
	RTE			
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
DATA_Y
 DC 299-100
 DC 295-100
 DC 291-100
 DC 286-100
 DC 282-100
 DC 278-100
 DC 274-100
 DC 270-100
 DC 266-100
 DC 263-100
 DC 259-100
 DC 255-100
 DC 252-100
 DC 248-100
 DC 245-100
 DC 242-100
 DC 238-100
 DC 235-100
 DC 232-100
 DC 229-100
 DC 226-100
 DC 223-100
 DC 221-100
 DC 218-100
 DC 215-100
 DC 213-100
 DC 210-100
 DC 208-100
 DC 205-100
 DC 203-100
 DC 201-100
 DC 199-100
 DC 197-100
 DC 195-100
 DC 193-100
 DC 191-100
 DC 189-100
 DC 187-100
 DC 185-100
 DC 184-100
 DC 182-100
 DC 180-100
 DC 179-100
 DC 177-100
 DC 176-100
 DC 174-100
 DC 173-100
 DC 172-100
 DC 171-100
 DC 169-100
 DC 168-100
 DC 167-100
 DC 166-100
 DC 165-100
 DC 164-100
 DC 163-100
 DC 162-100
 DC 161-100
 DC 161-100
 DC 160-100
 DC 159-100
 DC 158-100
 DC 158-100
 DC 157-100
 DC 156-100
 DC 156-100
 DC 155-100
 DC 155-100
 DC 154-100
 DC 154-100
 DC 154-100
 DC 153-100
 DC 153-100
 DC 152-100
 DC 152-100
 DC 152-100
 DC 152-100
 DC 151-100
 DC 151-100
 DC 151-100
 DC 151-100
 DC 151-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 150-100
 DC 151-100
 DC 151-100
 DC 151-100
 DC 151-100
 DC 151-100
 DC 152-100
 DC 152-100
 DC 152-100
 DC 152-100
 DC 153-100
 DC 153-100
 DC 154-100
 DC 154-100
 DC 154-100
 DC 155-100
 DC 155-100
 DC 156-100
 DC 156-100
 DC 157-100
 DC 158-100
 DC 158-100
 DC 159-100
 DC 160-100
 DC 161-100
 DC 161-100
 DC 162-100
 DC 163-100
 DC 164-100
 DC 165-100
 DC 166-100
 DC 167-100
 DC 168-100
 DC 169-100
 DC 171-100
 DC 172-100
 DC 173-100
 DC 174-100
 DC 176-100
 DC 177-100
 DC 179-100
 DC 180-100
 DC 182-100
 DC 184-100
 DC 185-100
 DC 187-100
 DC 189-100
 DC 191-100
 DC 193-100
 DC 195-100
 DC 197-100
 DC 199-100
 DC 201-100
 DC 203-100
 DC 205-100
 DC 208-100
 DC 210-100
 DC 213-100
 DC 215-100
 DC 218-100
 DC 221-100
 DC 223-100
 DC 226-100
 DC 229-100
 DC 232-100
 DC 235-100
 DC 238-100
 DC 242-100
 DC 245-100
 DC 248-100
 DC 252-100
 DC 255-100
 DC 259-100
 DC 263-100
 DC 266-100
 DC 270-100
 DC 274-100
 DC 278-100
 DC 282-100
 DC 286-100
 DC 291-100
 DC 295-100
 DC 299-100

	DC.L	-1

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


BOUL	DC %0000011111100000,%0000000000000000
	DC %0011111111111100,%0000000000000000
	DC %0111111111111110,%0000000000000000
	DC %0111111111111110,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %1111111111111111,%0000000000000000
	DC %0111111111111110,%0000000000000000
	DC %0111111111111110,%0000000000000000
	DC %0011111111111100,%0000000000000000
	DC %0000011111100000,%0000000000000000
	
		
 	BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
ancl	ds.w	1
stimb	ds.l	1
SAUVE	DS.L	1	
ANC_VBL	DS.L	1	
ANC_TB	DS.L	1	
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
PNT_REB	DS.L	1
ANC_ECR	DS.L	1	
SCREEN1	DS.L	1
SCREEN2	DS.L	1
RES	DS.W	1	
ANC_PAL	DS.W	16
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
MFP7	DS.B	1
MFP8	DS.B	1
MFP9	DS.B	1
MFP10	DS.B	1
	DS.B	256
BUFFER	DS.B	32000*2
BUF_BOUL	DS	(16*2)*16
