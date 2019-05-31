NB_PTS=50
NB_SEG=NB_PTS/2
PAS=3
NB_POS=50
NB_POS2=360/PAS

NB_PTSB=54
NB_SEG2=NB_PTSB/2
PASB=2
NB_POSB=50
NB_POS2B=360/PASB

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

	MOVEQ	#1,D0
	JSR	ZIK

	MOVE	#42,ZOOMED
	MOVE	#-42,ZOOMED2
	MOVE	#-42,ZOOMED3

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W



	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	LEA	DATA_X,A1
;	MOVE	#45*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	move	#256,z_pt_fuite
	move.l	#NB_POS2-1,d7
ici	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTS-1,D6
;	rept	NB_PTS
OP1	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,OP1
;	endr
	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	dbf	d7,ici


	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
;	LEA	DATA_X,A1
	move	#256,z_pt_fuite
	move.l	#NB_POS-1,d7
ici2	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTS-1,D6
;	rept	NB_PTS
OP2	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,OP2
;	endr
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	ADD.L	#NB_PTS*2*2,PNT_GG
	dbf	d7,ici2

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move.l	#NB_PTS*4*NB_POS,PNT_GG
;	LEA	DATA_X,A1
;	MOVE	#45*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	move	#256,z_pt_fuite
	move.l	#NB_POS2-1,d7
ici3	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTS-1,D6
;	rept	NB_PTS
OP3	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,OP3
;	endr
;	ADD	#2*PAS,x_angle
	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	dbf	d7,ici3
**************

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	CLR.L	PNT_GG
;	LEA	DATA_X,A1
	move	#256,z_pt_fuite
	move.l	#NB_POSB-1,d7
ici5	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTSB-1,D6
;	rept	NB_PTSB
OP5	jsr	sp_to_pl2
	jsr	ROUTINE
	DBF	D6,OP5
;	endr
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	ADD.L	#NB_PTSB*2*2,PNT_GG
	dbf	d7,ici5

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move.l	#NB_PTSB*4*NB_POSB,PNT_GG
;	LEA	DATA_X,A1
;	MOVE	#45*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	move	#256,z_pt_fuite
	move.l	#NB_POS2B-1,d7
ici6	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTSB-1,D6
;	rept	NB_PTSB
OP6	jsr	sp_to_pl2
	jsr	ROUTINE
	DBF	D6,OP6
;	endr
	ADD	#2*PASB,x_angle
	ADD	#2*PASB,y_angle
	ADD	#2*PASB,z_angle
	dbf	d7,ici6

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	move.l	#NB_PTSB*4*NB_POSB,PNT_GG
;	LEA	DATA_X,A1
	move	#256,z_pt_fuite
	move.l	#NB_POSB-1,d7
ici7	CLR.L	POINTEUR
	jsr	trigo
	MOVE.L	#NB_PTSB-1,D6
;	rept	NB_PTSB
OP7	jsr	sp_to_pl2
	jsr	ROUTINE
	DBF	D6,OP7
;	endr
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
;	ADD	#2*PAS,z_angle
	SUB.L	#NB_PTSB*2*2,PNT_GG
	dbf	d7,ici7

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
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

;	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
;	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
;	MOVE.B	#4,$FFFFFA19.W
;	BCLR	#3,$FFFFFA17.W
;	MOVE.L	#INTER_TMA,$134.W
;	ORI.B	#$20,$FFFFFA13.W
;	ORI.B	#$20,$FFFFFA07.W

;	MOVE	#$000,$FFFF8242.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF
	ST	$FFFF8240.W
EF	JSR	EFECR
	
	REPT	NB_SEG
	LEA	DATA_X,A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace
	ENDR

	LEA	COLORS,A0
	ADDA.L	TIME,A0
	CMPI.B	#-1,2(A0)
	BEQ.S	LETSGO
	CLR.L	PNT
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,TIME2
	CMPI.L	#5,TIME2
	BNE.S	LETSGO
	CLR.L	TIME2
	ADDQ.L	#2,TIME
	
LETSGO	
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#4*2*NB_SEG*(NB_POS+NB_POS2*2),PNT
	BNE.S	NO_P
	
	LEA	COLORS2,A0
	ADDA.L	TIME3,A0
	CMPI.B	#-1,2(A0)
	BEQ.S	LETSGO2
	MOVE.L	#4*2*NB_SEG*(NB_POS+NB_POS2*2-1),PNT
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,TIME4
	CMPI.L	#5,TIME4
	BNE.S	NO_P
	CLR.L	TIME4
	ADDQ.L	#2,TIME3
	BRA.S	NO_P
LETSGO2
	MOVE.L	#VBL_IR2,$70.W
	CLR.L	PNT
	CLR.L	TIME
	CLR.L	TIME2
	CLR.L	TIME3
	CLR.L	TIME4
NO_P	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
INTER_RTE	RTE
VBL_IR2
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

;	MOVE	#$666,$FFFF8242.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF2
	ST	$FFFF8240.W
EF2	JSR	EFECR
	
	REPT	NB_SEG2
	LEA	DATA_X,A0
	ADDA.L	#4*2*NB_SEG*(NB_POS+NB_POS2*2),A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace
	ENDR
	
	LEA	COLORS,A0
	ADDA.L	TIME,A0
	CMPI.B	#-1,2(A0)
	BEQ.S	LETSG
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,TIME2
	CMPI.L	#5,TIME2
	BNE.S	LETSG
	CLR.L	TIME2
	ADDQ.L	#2,TIME
LETSG

	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#4*2*NB_SEG2*(NB_POS2B+NB_POSB*2),PNT
	BNE.S	NO_P2
	CLR.L	PNT
	MOVE.L	#VBL_INTER,$70.W
	CLR.L	TIME
	CLR.L	TIME2
	CLR.L	TIME3
	CLR.L	TIME4
NO_P2	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

VBL_INTER	MOVE.L	#VBL_INTER2,$70.W
	JSR	EFECR
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE
VBL_INTER2	MOVE.L	#VBL_CUBE,$70.W
	JSR	EFECR
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE

VBL_CUBE   
	*sf	$ffff8240.w

	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	PAS_ZOOM
	SUBQ	#1,ZOOMED2
	ADDQ	#1,ZOOMED
PAS_ZOOM	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	PAS_ZOOM2
	ADDQ	#1,ZOOMED2
	SUBQ	#1,ZOOMED
PAS_ZOOM2

	CMPI.B	#$3D,$FFFFFC02.W
	BNE.S	PAS_ZOOMB
	ADDQ	#1,ZOOMED3
PAS_ZOOMB	CMPI.B	#$3E,$FFFFFC02.W
	BNE.S	PAS_ZOOM2B
	SUBQ	#1,ZOOMED3
PAS_ZOOM2B

	LEA	tpoitesp1,A0
	LEA	2(A0),A0
	MOVE	ZOOMED,D0
	SWAP	D0
	MOVE	ZOOMED,D0
	MOVE	ZOOMED2,D1
	SWAP	D1
	MOVE	ZOOMED2,D1
	MOVE	ZOOMED3,D2
	SWAP	D2
	MOVE	ZOOMED3,D2
	
	MOVE.L	D1,(A0)+
	MOVE	D2,(A0)+	*

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+
	MOVE	D2,(A0)+	*

	MOVE.L	D0,(A0)+
	MOVE	D2,(A0)+	*

	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	MOVE	D2,(A0)+	*

	MOVE.L	D1,(A0)+
	MOVE	D0,(A0)+

	MOVE	D1,(A0)+
	MOVE.L	D0,(A0)+

	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+

	MOVE	D1,(A0)+
	MOVE	D0,(A0)+

	move.l	SCREEN1,d0
	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
	move.l	d0,SCREEN2
	move.l	d1,SCREEN1
	
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	PO
	ST	$FFFF8240.W
PO	jsr	ZIK+4
	bsr	efecr
	move.w	$fffffc02.w,key
	bsr	calcpoint
	bsr	tobj
	bsr	calcrot
	SF	$FFFF8240.W
	*st	$ffff8240.w
	
	cmpI.b	#$39,$FFFFFC02.W
	BNE.S	RETOUR
	CLR.L	PNT
	MOVE.L	#VBL_CADRE,$70.W	
RETOUR	rte

EFECR	

	movea.l	SCREEN1,a0
;	LEA	160*61(A0),A0
	
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
N	SET	0
	REPT	200
	movem.l	d0-d7/a1-a6,N(a0)
	movem.l	d0-d7/A1-A6,N+4*14(a0)
	movem.l	d0-d7/A1-A4,N+4*14*2(a0)
N	SET	N+160
	ENDR
	RTS
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

	
VBL_CADRE
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	EF_CADRE
	ST	$FFFF8240.W
EF_CADRE	JSR	EFECR
	
	REPT	4
	LEA	CADRE,A0
	ADDA.L	PNT,A0
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,D3
	ADD.L	#4*2,PNT
	jsr	trace
	ENDR

	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	CMPI.L	#4*2*4*49,PNT
	BNE.S	CONTINUE
	
	MOVE.L	#VBL_INTER3,$70.W
	
CONTINUE	JSR	ZIK+4
	SF	$FFFF8240.W
	CMPI.B	#$1,$FFFFFC02.W
	BEQ	FIN
	RTE
VBL_INTER3	MOVE.L	#VBL_INTER4,$70.W
	JSR	EFECR
	JSR	ZIK+4
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE
VBL_INTER4	MOVE.L	#VBL_EXPLO,$70.W
	JSR	EFECR
	JSR	ZIK+4
	CLR.L	PNT
	MOVE.L	#200*(80-3),PNT2
	MOVE.L	#$07770777,$FFFF8244.W
	MOVE.L	#$07770777,$FFFF8248.W
	MOVE.L	#$07770777,$FFFF824C.W
	MOVE.L	#$07770777,$FFFF8250.W
	MOVE.L	#$07770777,$FFFF8254.W
	MOVE.L	#$07770777,$FFFF8258.W
	MOVE.L	#$07770777,$FFFF825C.W

	MOVE	#$111,$FFFF8242.W
	MOVE	#$333,$FFFF8244.W
	MOVE	#$555,$FFFF8248.W
	MOVE	#$777,$FFFF8250.W

	move.l	SCREEN1,d0
;	MOVE.L	SCREEN2,SCREEN1
;	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	RTE


VBL_EXPLO
	CLR.B	$FFFFFA1B.W

	CMPI.B	#$1,$FFFFFC02.W
	BEQ	NON

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	P
	ST	$FFFF8240.W
P
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	MOVEQ	#0,D2
	LEA	EXPLOY,A1
	ADDA.L	PNT2,A1
	ADDA.L	PNT2,A1
	MOVE.L	SCREEN1,A2
	
	MOVE	#200-1,D0
EFF_PT	MOVE	(A1)+,D1
	MOVE.B	D2,(A2,D1.W)
	MOVE.B	D2,2(A2,D1.W)
	MOVE.B	D2,4(A2,D1.W)
	MOVE.B	D2,6(A2,D1.W)
	DBF	D0,EFF_PT
	
	ADD.L	#200,PNT
	CMPI.L	#200*80,PNT
	BNE.S	OK
	CLR.L	PNT
OK

	ADD.L	#200,PNT2
	CMPI.L	#200*80,PNT2
	BNE.S	OK2
	CLR.L	PNT2
OK2

 	LEA	EXPLOX,A0
	ADDA.L	PNT,A0
	LEA	EXPLOY,A1
	ADDA.L	PNT,A1
	ADDA.L	PNT,A1
	
	MOVE.L	SCREEN1,A2
	ADDA.L	PNTP,A2

	MOVE	#200-1,D0
AFF_PT	MOVE	(A1)+,D1
	MOVE.B	(A0)+,D2
	OR.B	D2,(A2,D1.W)
	DBF	D0,AFF_PT

	MOVE	$FFFF8242.W,D0
	MOVE	$FFFF8244.W,D1
	MOVE	$FFFF8248.W,D2
	MOVE	$FFFF8250.W,D3

	MOVE	D0,$FFFF8244.W
	MOVE	D1,$FFFF8248.W
	MOVE	D2,$FFFF8250.W
	MOVE	D3,$FFFF8242.W
	
	ADDQ.L	#2,PNTP
	CMPI.L	#8,PNTP
	BNE.S	KJ
	CLR.L	PNTP
KJ	
NOTY	
NON	SF	$FFFF8240.W

	MOVE.L	SCREEN1,A0
	CLR.B	160(A0)
	CLR.B	162(A0)
	CLR.B	164(A0)
	CLR.B	166(A0)

	CLR.B	160+153(A0)
	CLR.B	160+155(A0)
	CLR.B	160+157(A0)
	CLR.B	160+159(A0)
	
	CLR.B	160*199(A0)
	CLR.B	160*199+2(A0)
	CLR.B	160*199+4(A0)
	CLR.B	160*199+6(A0)

	JSR	ZIK+4

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

trigo	movem.l d0-d7/a4-a6,-(a7)

	lea cos_tab,a4	;a4 pointe table cos
	lea sin_tab,a5	;a5 pointe table sin

	lea x_angle,a6
	move.w (a6)+,d2	;d2=x_angle
	move.w (a6)+,d1	;d1=y_angle
	move.w (a6)+,d0	;d0=z_angle
	
	move.w 0(a5,d2.w),d5	;d5=sin_x
	move.w 0(a4,d2.w),d4	;d4=cos_x
	move.w 0(a5,d1.w),d3	;d3=sin_y
	move.w 0(a4,d1.w),d2	;d2=cos_y
	move.w 0(a5,d0.w),d1	;d1=sin_z
	move.w 0(a4,d0.w),d0	;d0=cos_z

	lea var_3d,a6	;a6 pointe la zone
			;qui contiendra les
			;calculs 
			;intermediaires

	moveq #9,d7		;d7 contient le nombre 
			;de decalages a faire	
			;pour diviser par 512
			
	;****** calcul de C *****
	
sp_c	move.w d3,d6	;sin_y*512
	neg.w d6		;inverse signe
	move.w d6,(a6)+	;-sin_y*512
	
	;****** calcul de F *****
	
sp_f	move.w d2,d6	;cos_y*512 
	muls d5,d6		;cos_y*512*sin_x*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_y*sin_x*512
	
	;****** calcul de I *****
	
sp_i	move.w d2,d6	;cos_y*512
	muls d4,d6		;cos_y*512*cos_x*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_y*cos_x*512

	;****** calcul de A *****	

sp_a	move.w d0,d6	;cos_z*512
	muls d2,d6		;cos_z*512*cos_y*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_z*cos_y*512

	;****** calcul de D *****

sp_d	move.w d1,d6	;sin_z*512
	muls d4,d6		;sin_z*512*cos_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke resultat
			;dans a4

	move.w d0,d6	;cos_z*512
	muls d3,d6		;cos_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d5,d6		;cos_z*sin_y*512
			;     *sin_x*512
	asr.l d7,d6		;divise par 512
	sub.w a4,d6		;soustrait resultat
			;stock‚ dans a4
	move.w d6,(a6)+	

	;****** calcul de G *****

sp_g	move.w d1,d6	;sin_z*512
	muls d5,d6		;sin_z*512*sin_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4

	move.w d0,d6	;cos_z*512
	muls d3,d6		;cos_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d4,d6		;cos_z*sin_y*512
			;     *cos_x*512
	asr.l d7,d6		;divise par 512
	add.w a4,d6		;ajoute resultat
			;stock‚ dans a4
	move.w d6,(a6)+	

	;****** calcul de B *****
	
sp_b	move.w d1,d6	;sin_z*512
	muls d2,d6		;sin_z*512*cos_y*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;sin_z*cos_y*512

	;****** calcul de E *****
	
sp_e	move.w d0,d6	;cos_z*512
	muls d4,d6		;cos_z*512*cos_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4
	
	move.w d1,d6	;sin_z*512
	muls d3,d6		;sin_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d5,d6		;sin_z*sin_y*512
			;     *sin_x*512
	asr.l d7,d6		;divise par 512
	add.w a4,d6		;ajoute resultat
			;stock‚ dans a4
	move.w d6,(a6)+	
	
	;****** calcul de H *****

sp_h	move.w d0,d6	;cos_z*512
	muls d5,d6		;cos_z*512*sin_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4
	
	move.w d1,d6	;sin_z*512
	muls d3,d6		;sin_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d4,d6		;sin_z*sin_y*512
			;     *cos_x*512
	asr.l d7,d6		;divise par 512
	sub.w a4,d6		;soustrait resultat
			;stock‚ dans a4
	move.w d6,(a6)+	
	
	movem.l (a7)+,d0-d7/a4-a6
	rts

;********************************************
; calcul des coordonnees planes             *
; en entree: xe,ye,ze                       *
;            x_angle,y_angle,z_angle        *
;            z_pt_fuite z du point de fuite *
; en sortie: xp,yp coordonn‚es planes       *
;            new_xe,new_ye,new_ze nouvelles *
;            coordonn‚es spatiales          *
;********************************************

sp_to_pl2 movem.l d0-d7/a1-a6,-(a7)
	
	lea points2,a6		;a6 pointe coords
	ADDA.L	PNT_GG,A6
	ADDA.L	POINTEUR,A6
	JMP	SUITE_SP
sp_to_pl movem.l d0-d7/a1-a6,-(a7)
	
	lea points,a6		;a6 pointe coords
	ADDA.L	PNT_GG,A6
	ADDA.L	POINTEUR,A6
SUITE_SP	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
;	move.w (a6)+,d2	;d2=ze
	MOVEQ	#0,D2
	SUB	#160,D0
	SUB	#100,D1
	ADD.L	#4,POINTEUR
	
;	lea depla,a3
;	move.w (a3)+,d3	;xdep
;	move.w (a3)+,d4	;ydep
;	move.w (a3)+,d5	;zdep
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	ext.l d3
	ext.l d4
	ext.l d5
	moveq #9,d6
	asl.l d6,d3 	;xdep*512
	asl.l d6,d4		;ydep*512
	asl.l d6,d5		;zdep*512
	movea.l d3,a1	
	movea.l d4,a2
	movea.l d5,a3
	
	lea var_3d,a6	;pointe zone de
			;calcul 
			;intermediaire

	move.w d0,d3	;d3=xe
	move.w d1,d4	;d4=ye
	move.w d2,d5	;d5=ze

	muls (a6)+,d3	;d3=c*xe*512
	muls (a6)+,d4	;d4=f*ye*512
	muls (a6)+,d5	;d5=i*ze*512
	add.l d4,d5		; + f*ye*512
	add.l d3,d5		; + c*xe*512
	add.l a3,d5		; + zdep*512
	move.l d5,a5	;a5=new_ze*512
	divs z_pt_fuite,d5	;d5=new_ze/z_pt_fuite

	move.w #512,d7
	sub.w d5,d7		;d7=512*q
			;d7=512*
			;(1-new_ze/z_pt_fuite)
	
	move.w d0,d3	;d3=xe
	move.w d1,d4	;d4=ye	
	move.w d2,d5	;d5=ze
		
	muls (a6)+,d3	;d3=a*xe*512
	muls (a6)+,d4	;d4=d*ye*512
	muls (a6)+,d5	;d5=g*ze*512
	add.l d4,d5		;+ a*xe*512
	add.l d3,d5		;+ d*xe*512
	add.l a1,d5		;+ xdep*512
	move.l d5,a4	;a4=new_xe*512
	divs d7,d5		;d5.w=
			;(new_xe*512)/(q*512)
			;d5=new_xe/q
	
	muls (a6)+,d0	;d0=b*xe*512
	muls (a6)+,d1	;d1=e*ye*512
	muls (a6)+,d2	;d2=h*ze*512
	add.l d0,d1		; + b*xe*512
	add.l d1,d2		; + e*ye*512
	add.l a2,d2		; + ydep*512
	move.l d2,d6	;d6=new_ye*512
	divs d7,d2		;d2.w=new_ye/q
	
	lea xp,a6		;a6 pointe zone
			;sauvergarde coords
			;plane qu'on
			;centre … l'‚cran

	add.w #160,d5	;d5=xp+160
	move.w d5,(a6)+	;xp
	
	add.w #100,d2	;d2=yp+100
	move.w d2,(a6)+	;yp

	move.l a4,d5	;new_xe*512
	move.l a5,d7	;new_ze*512
	moveq #9,d0
	asr.l d0,d5		;new_xe
	asr.l d0,d6		;new_ye
	asr.l d0,d7		;new_ze
			
			;sauve nouvelles 
			;coords spatiales
	move.w d5,(a6)+	;new_xe
	move.w d6,(a6)+	;new_ye
	move.w d7,(a6)+	;new_ze
	MOVE	D7,ZA	
	movem.l (a7)+,d0-d7/a1-a6
	rts

ROUTINE
	MOVE	xp,D0
	CMPI	#0,D0
	BGT.S	CLIP1
	MOVE	#1,D0
CLIP1	CMPI	#320,D0
	BLT.S	CLIP2
	MOVE	#319,D0
CLIP2	MOVE	D0,(A1)+

	MOVE	yp,D0
	CMPI	#0,D0
	BGT.S	CLIP3
	MOVE	#1,D0
CLIP3	CMPI	#200,D0
	BLT.S	CLIP4
	MOVE	#199,D0
CLIP4	MOVE	D0,(A1)+
	RTS

* ROUTINES ZERIOUL (CUBE)
calcrot
	sub.w	#1,attvbl
	beq.s	calcrots	
	bra	finacal
calcrots
	move.w	#10,attvbl
	moveq	#0,d0
	move.b	key,d0
	
	cmp.w	#7,d0
	bgt.s	finacal
	beq.s	changobj
	subq	#1,d0
	
	lea.l	adag1,a0
	moveq.l	#1,d1
	and.w	d0,d1
	bne.s	suitadcal
	
	sub.w	d1,d0
	add.w	d0,a0
	sub.w	#2,(a0)
	bra.s	finacal
suitadcal
	sub.w	d1,d0
	add.w	d0,a0
	add.w	#2,(a0)
	bra.s	finacal
changobj	
	add.w	#8,numobj
	lea.l	paobj,a0
	add.w	numobj,a0
	move.l	(a0)+,d0	
	bgt.s	schangobj	
	move.w	#-8,numobj
	bra.s	changobj
schangobj	
	move.l	d0,ptchang2+2
	addq.l	#2,d0
	move.l	d0,ptchang1+2
	move.l	(a0),ptchang3+2	
	clr.l	adag1
	clr.w	adag3
	clr.w	ang1
	clr.w	ang2
	clr.w	ang3
finacal	
	move.w	ang1,d0
	add.w	adag1,d0
	and.w	#$1ff,d0
	move.w	d0,ang1
	
	move.w	ang2,d0
	add.w	adag2,d0
	and.w	#$1ff,d0
	move.w	d0,ang2
	
	move.w	ang3,d0
	add.w	adag3,d0
	and.w	#$1ff,d0
	move.w	d0,ang3

	rts

efecr	
	movea.l	SCREEN1,a0
	lea.l	160*200(a0),a0
	
	moveq	#1,d0
	moveq	#1,d1
	moveq	#1,d2
	moveq	#1,d3
	moveq	#1,d4
	moveq	#1,d5
	moveq	#1,d6
	moveq	#1,d7
;	sub.l	a0,a0
	move.l	#1,a1
	move.l	#1,a2
	move.l	#1,a3
	move.l	#1,a4
	move.l	#1,a5
	move.l	#1,a6
;	sub.l	a1,a1
;	sub.l	a2,a2
;	sub.l	a3,a3
;	sub.l	a4,a4
;	sub.l	a5,a5
;	sub.l	a6,a6

n	set	32
	rept	150
	movem.l	d0-d7/a1-a6,n(a0)
	movem.l	d0-d7,n+14*4(a0)
n	set	n-160
	endr
	rts

	******************
	*matrix 3axe(zyx)*
	******************
calcpoint	
	lea.l	tsin(pc),a0
	lea.l	128(a0),a1
ang1	equ	*+2
	move.w	#0,d0
ang2	equ	*+2
	move.w	#0,d1
ang3	equ	*+2	
	move.w	#0,d2

	move.w	(a0,d1.w),d3	-sinb
	neg	d3
	move.w	d3,modf3+2	

	move.w	d0,d3		d3=a-b
	sub.w	d1,d3		
	add.w	d0,d1		d1=a+b

	move.w	(a1,d1.w),d4	1/2(cos(a+b)+cos(a-b))
	add.w	(a1,d3.w),d4	cosacosb
	asr	d4
	move.w	d4,modf1+2		
	
	move.w	(a0,d1.w),d4	-1:2(sin(a+b)+sin((a-b))
	add.w	(a0,d3.w),d4	-sinacosb
	asr	d4
	neg	d4
	move.w	d4,modf2+2		

	sub.w	d0,d1
	move.w	d1,d3		
	sub.w	d2,d3		d3=b-c
	add.w	d1,d2		d2=b+c
	
	move.w	(a0,d2.w),d4	-1:2(sin(b+c)-sin((b-c))
	sub.w	(a0,d3.w),d4	-sinccosb
	asr	d4
	neg	d4
	move.w	d4,modf6+2		
	
	move.w	(a1,d2.w),d4	1/2(cos(b+c)+cos(b-c))
	add.w	(a1,d3.w),d4	cosbcosc
	asr	d4
	move.w	d4,modf9+2		

	sub.w	d1,d2
	move.w	d0,d3
	sub.w	d2,d3		d3=a-c
	add.w	d0,d2		d2=a+c
	
	move.w	(a0,d2.w),d4	1:2(sin(a+c)+sin(a-c))
	add.w	(a0,d3.w),d4	sinacosc
	asr	d4
	move.w	d4,addmodf1
	
	move.w	(a1,d2.w),d4	1:2(cos(a+c)+cos(a-c))
	add.w	(a1,d3.w),d4	cosacosc
	asr	d4
	move.w	d4,addmodf2
	
	move.w	(a1,d3.w),d4	1:2(cos(a-c)-cos(a+c))
	sub.w	(a1,d2.w),d4	sinasinc
	asr	d4
	move.w	d4,addmodf3
	
	move.w	(a0,d2.w),d4	1:2(sin(a+c)-sin(a-c))
	sub.w	(a0,d3.w),d4	cosasinc
	asr	d4
	move.w	d4,addmodf4

	sub.w	d0,d2
	move.w	#14,d3

	move.w	(a1,d0.w),d4	-cosasinbsinc+sinacosc
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf1	equ	*+2
	add.w	#0,d4
	move.w	d4,modf4+2
	
	move.w	(a0,d0.w),d4	sinasinbsinc+cosacosc
	muls.w	(a0,d1.w),d4
	muls.w	(a0,d2.w),d4
	asr.l	d3,d4
addmodf2	equ	*+2
	add.w	#0,d4
	move.w	d4,modf5+2
	
	move.w	(a1,d0.w),d4	cosasinbcosc+sinasinc
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
addmodf3	equ	*+2
	add.w	#0,d4
	move.w	d4,modf7+2
	
	move.w	(a0,d0.w),d4	-sinasinbcosc+cosasinc
	muls.w	(a0,d1.w),d4
	muls.w	(a1,d2.w),d4
	asr.l	d3,d4
	neg	d4
addmodf4	equ	*+2
	add.w	#0,d4
	move.w	d4,modf8+2
	
	lea.l	t_points,a0
ptchang3	lea.l	tpoitesp1,a1
	lea.l	tz+255*2,a2

	move.w	#160,d5
	move.w	#100,d6
	
	move.w	(a1)+,d7

bmatrix
	move.w	(a1)+,a3
	move.w	(a1)+,a4
	move.w	(a1)+,d4

	move.w	a3,d0
	move.w	a4,d1
	move.w	d4,d2

modf1	muls	#1<<7,d0
modf2	muls	#0,d1
modf3	muls	#0,d2
	add.l	d1,d0
	add.l	d2,d0
	
	move.w	a3,d1
	move.w	a4,d2
	move.w	d4,d3

modf4	muls	#0,d1
modf5	muls	#1<<7,d2
modf6	muls	#0,d3
	add.l	d2,d1
	add.l	d3,d1
	
	move.w	a3,d2
	move.w	a4,d3
	
modf7	muls	#0,d2
modf8	muls	#0,d3
modf9	muls	#1<<7,d4
	add.l	d3,d2
	add.l	d4,d2
	
	asr.w	#7,d2
	add.w	d2,d2
	
	add.w	#20,d2
	
	muls	(a2,d2.w),d0
	muls	(a2,d2.w),d1
	
	swap	d0
	swap	d1
	
	add.w	d5,d0
	add.w	d6,d1
	
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	
	dbra.w	d7,bmatrix
	rts

	incbin	tsin7.aid
tsin	incbin	tsin7.aid
	incbin	tsin7.aid

tz	incbin	tzoom.aid

*----------------------------------------------------
tobj
	
ptchang1	move.l	#tpoly1+2,chbobj
ptchang2	move.w	tpoly1,d0
bobj	
	move.w	d0,sauvd0
chbobj	equ	*+2
	move.l	tpoly1,d6
	add.l	#4,chbobj
	bsr	poly
	move.w	sauvd0,d0
	dbra.w	d0,bobj	
	
	rts

sauvd0	dc.w	0
*----------------------------------------------------	
	************************
	**trace de poly 1 plan**	
	************************
poly:
				*chercher +haut
  	move.l	d6,a5
  	move.w	(a5)+,plan
  	lea.l	t_points,a1		*point	Y1		
				****************
	move.w	2(a5),d0
	move.w	4(a5),d1
	move.w	6(a5),d2		test	face
	move.w	(a1,d0.w),d3	     cachee
	sub.w	(a1,d1.w),d3
	move.w	2(a1,d0.w),d4
	sub.w	2(a1,d1.w),d4
	move.w	(a1,d2.w),d0
	sub.w	(a1,d1.w),d0
	move.w	2(a1,d2.w),d5
	sub.w	2(a1,d1.w),d5
	muls	d3,d5
	muls	d0,d4	
	sub.l	d4,d5
	bgt.s	ncaches	
	rts 
				****************
ncaches	
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
	addq.l	#4,d6
	add.l	d6,d7		
				*d7=fin de table
				*calc tgauche
	lea.l	tgauch,a3
	lea.l	(a5),a2
b_calct_g	
	move.w	(a2)+,d4		*pointe suivant tabe
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g
	move.l	d6,a2
s_calct_g	
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g	
	bsr	calcord
	bra.b	b_calct_g	
s1_calct_g		
	move.w	#0,(a3)
				**droit
	lea.l	tdroit,a3
	move.l	d7,mcodtd+2
	move.l	d6,d7	
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
	move.w	#-4,(a3)
******************************************************************
					*affiche poly			
				*peut toucher a4
	move.l	SCREEN1,a0

codmpyin	move.w	#100,d0
	lea.l	p_t_ord(pc),a1		
	add.w	d0,d0
	add.w	(a1,d0.w),a0 	*add ydeb	
plan	dc.w	$4e71
	
	lea.l	tgauch,a1	
	lea.l	tdroit,a5
	lea.l	p_t_left(pc),a2	
	lea.l	p_t_right(pc),a3	
	lea.l	tdrempvd(pc),a6
	
	move.w	#$fffc,d3
	move.w	#$ffff,d7

pvalpoly	macro
				;256+12
 	moveq	#-4,d0		;4
	and.w	(a1)+,d0		;8
	move.l	(a2,d0.w),d0	;20
	
	moveq	#-4,d1		;4
	and.w	(a5)+,d1		;8
	move.l	(a3,d1.w),d1	;20	

	move.l	a0,a4		;4	
	add.w	d0,a4		;8	

	sub.w	d0,d1		;4	

	jmp	(a6,d1.w)		;16	
	endm
	pvalpoly
*********************************************
	rts
	bra.w	pdaffpa1
tdrempvd				
	bra.w	pdaffpa1		;12	
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
	
	pvalpoly 				
	

pdaffpa2
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

pdaffpa3
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	
	pvalpoly 				
	

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
	
	pvalpoly 				
	

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
	
	pvalpoly 				
	

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

	pvalpoly 						
	

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
	
	pvalpoly 					
	

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
	
	pvalpoly 				
	

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

	pvalpoly 				 	
	

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
	
	pvalpoly 				 	
	

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

	pvalpoly 				 	
	

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

	pvalpoly 				
	

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
	
	pvalpoly 				


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

	pvalpoly 				 	
	

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
	
	pvalpoly 				
	

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
	
	pvalpoly 				
	

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
	
	pvalpoly 				
	

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
	
	pvalpoly 				
	

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
	
	pvalpoly 				
 	

pdaffpa20
	swap	d0		;4
	or.w	d0,(a4)		;12
n	set	8
	rept	18
	move.w	d7,n(a4)		;12*18
n	set	n+8
	endr
	swap	d1		;4
	or.w	d1,n(a4)		;12
	lea.l	160(a0),a0		;8
	
	pvalpoly 				
	


*********************************************
calcord	
	
	moveq.l	#0,d4
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ASL.W	#7,D4
	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#11,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4
	
	add.w	d0,d0	
	add.w	d0,d0
	sub.w	d1,d1
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts



*_______________________________________________________

	*entre	x1=d0,x2=d2,y1=d1,y2=d3*
	     *origin haut gauche ecran*
		*pas de clip*
*-------------------------------------------------------
************************************************
**ligne -15-vers 1.0 *code zerioul holocaust**
************************************************
trace:
	movea.l	SCREEN1,a0
	
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

	dc.w	-8,-6
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
n	set	30*160
	rept	200
	dc.w	n
n	set	n+160
	endr			
	*------------variable------------*

np	equ	4

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

buffl:		
	dc.w	21216,21216,21184,21216,21216,21216,21216,21168
	dc.w	10688,10704,21216,21216,21152,21120,10656,21216	
	
n	set	15840
	rept	10
	dc.w	n
n	set	16+n
	endr

	dc.w	10672,21200,21216,21216,21216,21216,21216	

n	set	0
	rept	10
	dc.w	n
n	set	8*2+n
	endr
	
n	set	5280	
	rept	10
	dc.w	n
n	set	n+16
	endr	
	
n	set	10560	
	rept	6
	dc.w	n
n	set	n+16
	endr	


ZIK	INCBIN	KILLER.ALC

cos_tab	incbin 'COSIN.DAT'	;tables sinus cosinus
sin_tab	equ cos_tab+720

points	
	INCBIN	POINTS1.DAT
points2
	INCBIN	POINTS2.DAT

COLORS	DC	$0,$111,$222,$333,$444,$555,$666
	DCB	20,$777
	DC.L	-1
COLORS2	DC	$777,$666,$555,$444,$333,$222,$111
	DCB	10,$0
	DC.L	-1
*CUBE
adag1	dc.w	0
adag2	dc.w	0
adag3	dc.w	0
attvbl	dc.w	10
numobj	dc.w	0	
paobj	dc.l	tpoly1,tpoitesp1,tpoly2,tpoitesp2,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11,face12,face13,face14,face15,face16 	

face11	dc.w	$5488,4,0,4,8,12
face12	dc.w	$5888,4,16,0,12,28
face13	dc.w	$5c88,4,12,8,24,28
face14	dc.w	$5888,4,4,20,24,8
face15	dc.w	$5c88,4,16,20,4,0 
face16	dc.w	$4e71,4,28,24,20,16

tpoitesp1	
	dc.w	8-1
	dc.w	-42,-42,-42		1
	dc.w	-42,42,-42		2
	dc.w	42,42,-42		3	
	dc.w	42,-42,-42		4
	dc.w	-42,-42,42		5	
	dc.w	-42,42,42		6	
	dc.w	42,42,42		7
	dc.w	42,-42,42		8
*****************************************************
tpoly2	dc.w	7-1
	dc.l	face21,face22,face23,face24,face25,face26,face27 	

face21	dc.w	$5488,4,0,4,8,12	avd
face22	dc.w	$5888,4,0,12,32,36	dhaut
face23	dc.w	$5888,4,36,32,28,16	dhaut
face24	dc.w	$5c88,5,12,8,24,28,32	droit
face25	dc.w	$5888,4,4,20,24,8	bas
face26	dc.w	$5c88,5,16,20,4,0,36 	gauche	
face27	dc.w	$4e71,4,28,24,20,16	arrie

tpoitesp2	
	dc.w	10-1
	dc.w	-40,-15,-25		1=0
	dc.w	-40,32,-25		2=4
	dc.w	40,32,-25		3=8	
	dc.w	40,-15,-25		4=12
	dc.w	-40,-15,25		5=16	
	dc.w	-40,32,25		6=15	
	dc.w	40,32,25		7=24
	dc.w	40,-15,25		8=28
	dc.w	40,-32,0		9=32
	dc.w	-40,-32,0		10=36

CADRE

; NB PTS=8
; Forme de d‚part
; DC 1,199,319,199
; DC 319,199,319,1
; DC 319,1,1,1
; DC 1,1,1,199
; Transformation
 DC 4,196,315,196
 DC 315,196,315,2
 DC 315,2,4,2
 DC 4,2,4,196
 DC 7,193,312,193
 DC 312,193,312,3
 DC 312,3,7,3
 DC 7,3,7,193
 DC 10,190,309,190
 DC 309,190,309,4
 DC 309,4,10,4
 DC 10,4,10,190
 DC 13,187,306,187
 DC 306,187,306,5
 DC 306,5,13,5
 DC 13,5,13,187
 DC 16,185,303,185
 DC 303,185,303,6
 DC 303,6,16,6
 DC 16,6,16,185
 DC 20,182,299,182
 DC 299,182,299,8
 DC 299,8,20,8
 DC 20,8,20,182
 DC 23,179,296,179
 DC 296,179,296,9
 DC 296,9,23,9
 DC 23,9,23,179
 DC 26,176,293,176
 DC 293,176,293,10
 DC 293,10,26,10
 DC 26,10,26,176
 DC 29,173,290,173
 DC 290,173,290,11
 DC 290,11,29,11
 DC 29,11,29,173
 DC 32,171,287,171
 DC 287,171,287,12
 DC 287,12,32,12
 DC 32,12,32,171
 DC 35,168,284,168
 DC 284,168,284,13
 DC 284,13,35,13
 DC 35,13,35,168
 DC 39,165,280,165
 DC 280,165,280,15
 DC 280,15,39,15
 DC 39,15,39,165
 DC 42,162,277,162
 DC 277,162,277,16
 DC 277,16,42,16
 DC 42,16,42,162
 DC 45,160,274,160
 DC 274,160,274,17
 DC 274,17,45,17
 DC 45,17,45,160
 DC 48,157,271,157
 DC 271,157,271,18
 DC 271,18,48,18
 DC 48,18,48,157
 DC 51,154,268,154
 DC 268,154,268,19
 DC 268,19,51,19
 DC 51,19,51,154
 DC 55,151,264,151
 DC 264,151,264,21
 DC 264,21,55,21
 DC 55,21,55,151
 DC 58,148,261,148
 DC 261,148,261,22
 DC 261,22,58,22
 DC 58,22,58,148
 DC 61,146,258,146
 DC 258,146,258,23
 DC 258,23,61,23
 DC 61,23,61,146
 DC 64,143,255,143
 DC 255,143,255,24
 DC 255,24,64,24
 DC 64,24,64,143
 DC 67,140,252,140
 DC 252,140,252,25
 DC 252,25,67,25
 DC 67,25,67,140
 DC 70,137,249,137
 DC 249,137,249,26
 DC 249,26,70,26
 DC 70,26,70,137
 DC 74,135,245,135
 DC 245,135,245,28
 DC 245,28,74,28
 DC 74,28,74,135
 DC 77,132,242,132
 DC 242,132,242,29
 DC 242,29,77,29
 DC 77,29,77,132
 DC 80,129,239,129
 DC 239,129,239,30
 DC 239,30,80,30
 DC 80,30,80,129
 DC 83,126,236,126
 DC 236,126,236,31
 DC 236,31,83,31
 DC 83,31,83,126
 DC 86,123,233,123
 DC 233,123,233,32
 DC 233,32,86,32
 DC 86,32,86,123
 DC 90,121,229,121
 DC 229,121,229,34
 DC 229,34,90,34
 DC 90,34,90,121
 DC 93,118,226,118
 DC 226,118,226,35
 DC 226,35,93,35
 DC 93,35,93,118
 DC 96,115,223,115
 DC 223,115,223,36
 DC 223,36,96,36
 DC 96,36,96,115
 DC 99,112,220,112
 DC 220,112,220,37
 DC 220,37,99,37
 DC 99,37,99,112
 DC 102,110,217,110
 DC 217,110,217,38
 DC 217,38,102,38
 DC 102,38,102,110
 DC 105,107,214,107
 DC 214,107,214,39
 DC 214,39,105,39
 DC 105,39,105,107
 DC 109,104,210,104
 DC 210,104,210,41
 DC 210,41,109,41
 DC 109,41,109,104
 DC 112,101,207,101
 DC 207,101,207,42
 DC 207,42,112,42
 DC 112,42,112,101
 DC 115,98,204,98
 DC 204,98,204,43
 DC 204,43,115,43
 DC 115,43,115,98
 DC 118,96,201,96
 DC 201,96,201,44
 DC 201,44,118,44
 DC 118,44,118,96
 DC 121,93,198,93
 DC 198,93,198,45
 DC 198,45,121,45
 DC 121,45,121,93
 DC 125,90,194,90
 DC 194,90,194,47
 DC 194,47,125,47
 DC 125,47,125,90
 DC 128,87,191,87
 DC 191,87,191,48
 DC 191,48,128,48
 DC 128,48,128,87
 DC 131,85,188,85
 DC 188,85,188,49
 DC 188,49,131,49
 DC 131,49,131,85
 DC 134,82,185,82
 DC 185,82,185,50
 DC 185,50,134,50
 DC 134,50,134,82
 DC 137,79,182,79
 DC 182,79,182,51
 DC 182,51,137,51
 DC 137,51,137,79
 DC 140,76,179,76
 DC 179,76,179,52
 DC 179,52,140,52
 DC 140,52,140,76
 DC 144,73,175,73
 DC 175,73,175,54
 DC 175,54,144,54
 DC 144,54,144,73
 DC 147,71,172,71
 DC 172,71,172,55
 DC 172,55,147,55
 DC 147,55,147,71
 DC 150,68,169,68
 DC 169,68,169,56
 DC 169,56,150,56
 DC 150,56,150,68
 DC 153,65,166,65
 DC 166,65,166,57
 DC 166,57,153,57
 DC 153,57,153,65
 DC 156,62,163,62
 DC 163,62,163,58
 DC 163,58,156,58
 DC 156,58,156,62

 DC 159,60,160,60
 DC 160,60,160,59
 DC 160,59,159,59
 DC 159,59,159,60
; Forme d'arriv‚e
 DC 160,60,160,60
 DC 160,60,160,60
 DC 160,60,160,60
 DC 160,60,160,60

*DATA EXPLO
EXPLOX	INCBIN	EXPLOX2
EXPLOY	INCBIN	EXPLOY2

 	BSS
*** BSS TRANSFO
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SAUVE	DS.L	1	
ANC_VBL	DS.L	1	
ANC_TB	DS.L	1	
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
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
xe	ds.w 1		;coordonnees spatiales
ye	ds.w 1
ze	ds.w 1

xdep	ds.w 1		;d‚placements
ydep	ds.w 1
zdep	ds.w 1

xp	ds.w 1		;coordonnees planes
yp	ds.w 1

new_xe	ds.w 1		;nouvelles coords 
new_ye	ds.w 1		;aprŠs rotation
new_ze	ds.w 1

x_angle	ds.w 1		;angles de rotation
y_angle	ds.w 1
z_angle	ds.w 1	

z_pt_fuite	ds.w 1		;coordonn‚es z du 
			;du point de fuite

var_3d	ds.w 9                  ;tableau pour calculs
POINTEUR	DS.L	1

DATA_X
	DS	NB_POS*NB_PTS*2
	DS	NB_POS2*NB_PTS*2
	DS	NB_POS2*NB_PTS*2

	DS	NB_POSB*NB_PTSB*2
	DS	NB_POS2B*NB_PTSB*2
	DS	NB_POSB*NB_PTSB*2

CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1
PNT	DS.L	1
PNT_GG	DS.L	1
TIME	DS.L	1
TIME2	DS.L	1
TIME3	DS.L	1
TIME4	DS.L	1
stimb	ds.l	1
*BSS EXPLO
PNTP	DS.L	1
PNT2	DS.L	1
*****BSS CUBE
ZOOMED	DS	1
ZOOMED2	DS	1
ZOOMED3	DS	1
	even
key	dS.b	0
	even 
posl	ds.l	1
ptlet	ds.l	1
posc1	ds.l	1
posc2	ds.l	1
indad	ds.w	1
ptdsc	ds.w	1
vsiff	ds.w	1
tdscr1	ds.w	32*21*2*4
tdscr2	ds.w	32*21*2*4
tdscr3	ds.w	32*21*2*4
tdscr4	ds.w	32*21*2*4

t_points	ds.w	20	
tdroit	ds.w	200
tgauch	ds.w	200
