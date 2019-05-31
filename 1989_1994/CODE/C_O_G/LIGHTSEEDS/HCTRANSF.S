;	opt	o+

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
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

;	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
;	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
;	MOVE.B	#4,$FFFFFA19.W
;	BCLR	#3,$FFFFFA17.W
;	MOVE.L	#INTER_TMA,$134.W
;	ORI.B	#$20,$FFFFFA13.W
;	ORI.B	#$20,$FFFFFA07.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR
	SF	$FFFF8242.W

	MOVE.L	SCREEN2,A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE

	REPT	6
	bsr	poly
	ENDR

	st	$ffff8240.w

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$39,$FFFFFC02.W
	BNE	INTER_RTE
	MOVE.L	#VBL_TRANSFO1,$70.W
	CLR.L	PNT
INTER_RTE	RTE

VBL_TRANSFO1
	CLR.B	$FFFFFA1B.W
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR1
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR1
	SF	$FFFF8242.W

	MOVE.L	SCREEN2,A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	80(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100(A0),A0
	JSR	EFFACE
	MOVE.L	SCREEN2,A0
	LEA	160*100(A0),A0
	LEA	80(A0),A0
	JSR	EFFACE

	REPT	6
	bsr	poly1
	ENDR

	st	$ffff8240.w

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$3B,$FFFFFC02.W
	BNE	POPO
	MOVE.L	#VBL_TRANSFO2,$70.W
	CLR.L	PNT
POPO	RTE

VBL_TRANSFO2
	CLR.B	$FFFFFA1B.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR2
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR2
	SF	$FFFF8242.W
	move.l	SCREEN2,a0
	JSR	EFFACE
	move.l	SCREEN2,a0
	LEA	160*100(A0),A0
	JSR	EFFACE

	REPT	3
	bsr	poly2
	ENDR

	st	$ffff8240.w

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$3C,$FFFFFC02.W
	BNE	GNY
	CLR.L	PNT
	MOVE.L	#VBL_TRANSFO3,$70.W
GNY	RTE


VBL_TRANSFO3
	CLR.B	$FFFFFA1B.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_PROCESSOR3
	MOVE	#$700,$FFFF8240.W
NO_PROCESSOR3
	SF	$FFFF8242.W
	move.l	SCREEN2,a0
	LEA	80(A0),A0
	JSR	EFFACE
	move.l	SCREEN2,a0
	LEA	80(A0),A0
	LEA	160*100(A0),A0
	JSR	EFFACE

	REPT	3
	bsr	poly3
	ENDR

	st	$ffff8240.w

	move.l	SCREEN2,d0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.B	#$1,$FFFFFC02.W
	BEQ	FIN
	RTE


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
	MOVE.L	#TB0_IR,$120.W
	BCLR	#0,$FFFFFA0F.W	
	RTE			

EFFACE
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVE.L	#0,A1
	MOVE.L	#0,A2
	MOVE.L	#0,A3
	MOVE.L	#0,A4
	MOVE.L	#0,A5
	MOVE.L	#0,A6
N	SET	0
	REPT	100
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
N	SET	N+160
	ENDR
	RTS

poly3:
	LEA	points3,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*3(A1)
	BNE.S	OKAYC
	SUB.L	#4*4*3,PNT
	BRA.S	poly3

OKAYC	ADD.L	#4*4,PNT
	BRA	OKAY2
poly2:
	LEA	points2,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*3(A1)
	BNE.S	OKAYB
	SUB.L	#4*4*3,PNT
	BRA.S	poly2

OKAYB	ADD.L	#4*4,PNT
	BRA.S	OKAY2
poly1:
	LEA	points1,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*6(A1)
	BNE.S	OKAYZ
	SUB.L	#4*4*6,PNT
	BRA.S	poly1

OKAYZ	ADD.L	#4*4,PNT
	BRA.S	OKAY2

poly:
	LEA	points,A1
	ADDA.L	PNT,A1
	CMPI.B	#-1,4*4*6(A1)
	BNE.S	OKAY
	SUB.L	#4*4*6,PNT
	BRA.S	poly
	
OKAY	ADD.L	#4*4,PNT
OKAY2	
	lea.l	tpoly(pc),a5
	move.w	(a5)+,d0		*d0=ndpoints
	
	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0		*calc avec tpoint
	
	move.w	(a5),d1
	move.w	2(a1,d1),d2
	lea.l	2(a5),a2
	move.w	(a2)+,d3
t_petit
	cmp.w	2(a1,d3.w),d2
	blt.s	st_ptit
	lea.l	-2(a2),a5
	move.w	2(a1,d3.w),d2
st_ptit
	move.w	(a2)+,d3
	dbra.w	d0,t_petit				
********************************************************************	
	move.w	d2,codmpyin+2		*calc ligne
	
	lea.l	calc(pc),a4		*pas touch
				*point=a1			*pointpoint=a5
				*tdpoint=a5
	add.w	d7,d7	
	add.l	#tpoly+2,d7		*d7=fin de table
				*calc tgauche
	lea.l	tgauch,a3
	lea.l	(a5),a2
b_calct_g	
	move.w	(a2)+,d4		*pointe suivant tabe
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g
	lea.l	tpoly+2(pc),a2
s_calct_g	
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g	
	bsr	calcord
	bra.b	b_calct_g	
s1_calct_g		
				**droit
	lea.l	tdroit,a3
	move.l	d7,mcodtd+2
	move.l	#tpoly+2,d7	
	lea.l	(a5),a2
b_calct_d		
	move.w	(a2),d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_d
mcodtd	move.l	#t_points+2,a2
s_calct_d	
	move.w	-(a2),d4
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_d	
	bsr	calcord
	bra.b	b_calct_d	
s1_calct_d	
******************************************************************
					*affiche poly			
				*peut toucher a4
	move.l	SCREEN2,a0
	
	move.w	d1,d6

codmpyin	move.w	#100,d0
	sub.w	d0,d6
	subq.l	#1,d6
	lea.l	p_t_ord(pc),a1		
	add.w	d0,d0
	add.w	(a1,d0.w),a0 	*add ydeb	
	
	lea.l	tgauch,a1	
	lea.l	p_t_left(pc),a2	
	lea.l	p_t_right(pc),a3	
	
	move.w	#$ffff,d7
	
;	move.w	#$f0,$ffff8240.W

	
bouclaff 	
	move.w	(a1)+,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a2,d0.w),d0
	
	move.w	tdroit-tgauch-2(a1),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a3,d1.w),d1
	
	lea.l	(a0,d0.w),a4	*add xdeb
	sub.w	d0,d1
	jmp	tdrempvd(pc,d1.w)	
*********************************************
tdrempvd
	bra.w	pdaffpa1
	dc.l	0
	bra.w	pdaffpa2
	dc.l	0
	bra.w	pdaffpa3	
	dc.l	0
	bra.w	pdaffpa4
	dc.l	0
	bra.w	pdaffpa5
	dc.l	0
	bra.w	pdaffpa6
	dc.l	0
	bra.w	pdaffpa7
	dc.l	0
	bra.w	pdaffpa8
	dc.l	0
	bra.w	pdaffpa9
	dc.l	0
	bra.w	pdaffpa10
	dc.l	0
	bra.w	pdaffpa11
	dc.l	0
	bra.w	pdaffpa12
	dc.l	0
	bra.w	pdaffpa13
	dc.l	0
	bra.w	pdaffpa14
	dc.l	0
	bra.w	pdaffpa15
	dc.l	0
	bra.w	pdaffpa16
	dc.l	0
	bra.w	pdaffpa17
	dc.l	0
	bra.w	pdaffpa18
	dc.l	0
	bra.w	pdaffpa19
	dc.l	0
	bra.w	pdaffpa20

pdaffpa1
	swap	d0
	swap	d1
	and.w	d0,d1
	or.w	d1,(a4)	
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa2
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa3
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa4
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	2
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 
	rts
pdaffpa5
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	3
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 
	rts
pdaffpa6
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	4
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa7
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	5
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa8
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	6
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa9
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	7
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa10
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	8
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa11
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	9
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa12
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	10
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa13
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	11
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa14
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	12
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa15
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	13
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa16

	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	14
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa17
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	15
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa18
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	16
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa19
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	17
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa20
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	18
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts


*********************************************
calcord	
	
	moveq.l	#0,d4
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ASL.W	#6,D4
	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#10,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4

	sub.w	#0,d4
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts
	


	DATA
tpoly	dc.w	4
	dc.w	0,4,8,12

t_points	
	dc.w	0,75
	dc.w	0,199
	dc.w	75,199
	dc.w	150,0
	
p_t_left
n	set	0
          	rept	20
            dc.w    %1111111111111111,n
            dc.w    %0111111111111111,n
            dc.w    %0011111111111111,n
            dc.w    %0001111111111111,n
            dc.w    %0000111111111111,n
            dc.w    %0000011111111111,n
            dc.w    %0000001111111111,n
            dc.w    %0000000111111111,n
            dc.w    %0000000011111111,n
            dc.w    %0000000001111111,n
            dc.w    %0000000000111111,n
            dc.w    %0000000000011111,n
            dc.w    %0000000000001111,n
            dc.w    %0000000000000111,n
            dc.w    %0000000000000011,n
            dc.w    %0000000000000001,n
n	set	n+8
	endr

p_t_right
n	set	0
            rept	20
            dc.w    %1000000000000000,n
            dc.w    %1100000000000000,n
            dc.w    %1110000000000000,n
            dc.w    %1111000000000000,n
            dc.w    %1111100000000000,n
            dc.w    %1111110000000000,n
            dc.w    %1111111000000000,n
            dc.w    %1111111100000000,n
            dc.w    %1111111110000000,n
            dc.w    %1111111111000000,n
            dc.w    %1111111111100000,n
            dc.w    %1111111111110000,n
            dc.w    %1111111111111000,n
            dc.w    %1111111111111100,n
            dc.w    %1111111111111110,n
            dc.w    %1111111111111111,n
n	set	n+8
	endr
	
p_t_ord
n	set	0
	rept	200
	dc.w	n
n	set	n+160
	endr	


points	
	INCBIN	POLYTRAN.DAT
	DC.L	-1
	DC.L	-1

points1
	INCBIN	TRANSHC.DAT
	DC.L	-1
	DC.L	-1
	
points2
	INCBIN	TRANSFOH.DAT
	DC.L	-1
	DC.L	-1

points3
	INCBIN	TRANSFOC.DAT
	DC.L	-1
	DC.L	-1
	
PART1	DC.W	%1111111111111111
	DC.W	%0111111111111111
	DC.W	%0011111111111111
	DC.W	%0001111111111111
	DC.W	%0000111111111111
	DC.W	%0000011111111111
	DC.W	%0000001111111111
	DC.W	%0000000111111111
	DC.W	%0000000011111111
	DC.W	%0000000001111111
	DC.W	%0000000000111111
	DC.W	%0000000000011111
	DC.W	%0000000000001111
	DC.W	%0000000000000111
	DC.W	%0000000000000011
	DC.W	%0000000000000001

PART2	DC.W	%1000000000000000
	DC.W	%1100000000000000
	DC.W	%1110000000000000
	DC.W	%1111000000000000
	DC.W	%1111100000000000
	DC.W	%1111110000000000
	DC.W	%1111111000000000
	DC.W	%1111111100000000
	DC.W	%1111111110000000
	DC.W	%1111111111000000
	DC.W	%1111111111100000
	DC.W	%1111111111110000
	DC.W	%1111111111111000
	DC.W	%1111111111111100
	DC.W	%1111111111111110
	DC.W	%1111111111111111

PNTS
N	SET	32768
	REPT	16
	DC.W	N
N	SET	N/2
	ENDR

	
 	BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SAUVE	DS.L	1	
ANC_VBL	DS.L	1	
ANC_TB	DS.L	1	
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
ANC_ECR	DS.L	1	
PNT	DS.L	1
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

tdroit	ds.w	800
tgauch	ds.w	800
