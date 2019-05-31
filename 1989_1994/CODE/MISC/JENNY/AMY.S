CONTRL	EQU	4
PTSIN	EQU	12
FG_BP1	EQU	24
FG_BP2	EQU	26
FG_BP3	EQU	28
FG_BP4	EQU	30
WRT_MOD	EQU	36
Y1	EQU	40
PATPTR	EQU	46
PATMSK	EQU	50
MULTIFILL	EQU	52
CLIP	EQU	54
XMN_CLIP	EQU	56
YMN_CLIP	EQU	58
XMX_CLIP	EQU	60
YMX_CLIP	EQU	62
;INIT	EQU	$A000
;POLYGON	EQU	$A006


SEG=(5*2*4*4)/4
NB_PTS=4*SEG
PAS=1
NB_POS=(360/PAS)/4

PROG:

main
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	MOVE.L	#FIN,$8.W
	MOVE.L	#FIN,$C.W
	MOVE.L	#FIN,$10.W
	MOVE.L	#FIN,$14.W
	MOVE.L	#FIN,$18.W
	MOVE.L	#FIN,$1c.W
	MOVE.L	#FIN,$20.W

	CLR	-(SP)
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea.l	12(sp),sp

;	moveq	#0,d0
;	jsr	sound
;	jsr	sound+18

	JSR	LINE_A_INIT
		
	MOVE	#1,FG_BP1(A0)
	CLR	FG_BP2(A0)
	CLR	FG_BP3(A0)
	CLR	FG_BP4(A0)
	
	MOVE	#0,WRT_MOD(A0)
	
	MOVE.L	#FILL,PATPTR(A0)
	
	MOVE	#1,PATMSK(A0)
	CLR	MULTIFILL(A0)
	MOVE	#1,CLIP(A0)
	move	#1,XMN_CLIP(A0)
	move	#1,YMN_CLIP(A0)
	move	#319,XMX_CLIP(A0)
	move	#199,YMX_CLIP(A0)

	JSR	SET_SCR
	MOVE	#$777,$FFFF8242.W
	MOVE	#$777,$FFFF8250.W
	
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	LEA	BUFCOD,A0
	MOVE.L	A0,SAVEA0
	LEA	TABLE,A4
	MOVE.L	A4,SAVEA4
	MOVEM.L	D0-A6,INIT


	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_X,A1
	
;	MOVE	#90*2,x_angle
;	MOVE	#180*2,y_angle
;	MOVE	#70*2,z_angle

	move	#256,z_pt_fuite

	move.l	#(NB_POS)-1,d7
ici	CLR.L	POINTEUR
	CLR.L	PNT
	LEA	DATA_X,A1
	jsr	trigo
	ADD.L	#2,POINTEUR2
	MOVE	#NB_PTS-1,D6
II	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,II
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
	ADD	#2*PAS,z_angle
	MOVEM.L	D0-A6,-(SP)
	JSR	GEN
	MOVEM.L	(SP)+,D0-A6
	dbf	d7,ici
;	MOVE	#90*2,x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	LEA	DATA_X,A1
	CLR.L	PNT
	jsr	trigo
	ADD.L	#2,POINTEUR2
	MOVE	#NB_PTS-1,D6
IIb	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,IIb
	MOVEM.L	D0-A6,-(SP)
	JSR	GEN
	MOVEM.L	(SP)+,D0-A6
	JMP	TERMINATED

;mainloop	MOVE.L	#NB_POS-1,D0
GEN	MOVEM.L	INIT,D0-A6
	MOVE.L	D0,SAVED0
	JSR	EFF
	MOVE	#SEG-1,D6
II2	MOVE.L	D6,-(SP)
	bsr	poly
	MOVE.L	(SP)+,D6
	DBF	D6,II2

	MOVE	#3999,D0
	MOVE.L	SCREEN1,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KL	MOVE	(A1),(A2)+
	MOVE	(A0),(A1)+
	LEA	8(A0),A0
	dbf	d0,KL

	JSR	GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D3
	LEA	DATAS,A0
	LEA	FINAL,A1
	LEA	-8(A0),A0
LOOPED	LEA	8(A0),A0
	MOVE.L	(A0),D2
	MOVE.L	4(A0),D1
	CMPI.L	#0,(A0)
	BEQ.S	OKVAZY
	CMP.L	D0,D1
	BLE.S	LOOPED
	MOVE.L	D1,D0
	MOVE.L	D2,D4
;	MOVE.L	#1,4(A0)
	BRA.S	LOOPED
	
OKVAZY	
	LEA	DATAS,A0	;
	LEA	-8(A0),A0	;
BOUI	LEA	8(A0),A0	;
	CMP.L	(A0),D4	;
	BNE.S	BOUI	;
	CLR.L	4(A0)	;

	MOVE.L	D4,(A1)+
	MOVE.L	D0,(A1)+
	CMPI.L	#7,D3
	BEQ.S	LP
	ADDQ.L	#1,D3
	MOVEQ	#0,D0
	LEA	DATAS,A0
	LEA	-8(A0),A0
	BRA.S	LOOPED
	
LP	LEA	DATAS,A0
	MOVE	#1999,D0
P	CLR.L	(A0)+
	DBF	D0,P
	JSR	GENERE2

	MOVE.L	SAVED0,D0
;	DBF	D0,GEN
	MOVEM.L	D0-A6,INIT
	RTS
INIT	DS.L	16
GEN2
	MOVE.L	D0,SAVED0
	JSR	EFF
	CLR.L	PNT
;	REPT	SEG
	bsr	poly
;	ENDR

	MOVE	#3999,D0
	MOVE.L	SCREEN1,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KLD	MOVE	(A1),(A2)+
	MOVE	(A0),(A1)+
	LEA	8(A0),A0
	dbf	d0,KLD

	JSR	GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D3
	LEA	DATAS,A0
	LEA	FINAL,A1
	LEA	-8(A0),A0
QLOOPED	LEA	8(A0),A0
	MOVE.L	(A0),D2
	MOVE.L	4(A0),D1
	CMPI.L	#0,(A0)
	BEQ.S	QOKVAZY
	CMP.L	D0,D1
	BLE.S	QLOOPED
	MOVE.L	D1,D0
	MOVE.L	D2,D4
;	MOVE.L	#1,4(A0)
	BRA.S	QLOOPED
	
QOKVAZY	
	LEA	DATAS,A0	;
	LEA	-8(A0),A0	;
DBOUI	LEA	8(A0),A0	;
	CMP.L	(A0),D4	;
	BNE.S	DBOUI	;
	CLR.L	4(A0)	;


	MOVE.L	D4,(A1)+
	MOVE.L	D0,(A1)+
	CMPI.L	#7,D3
	BEQ.S	QLP
	ADDQ.L	#1,D3
	MOVEQ	#0,D0
	LEA	DATAS,A0
	LEA	-8(A0),A0
	BRA.S	QLOOPED
	
QLP	LEA	DATAS,A0
	MOVE	#1999,D0
QP	CLR.L	(A0)+
	DBF	D0,QP
	JSR	GENERE2

	MOVE.L	SAVED0,D0

TERMINATED	JSR	EFF

	MOVE.L	SCREEN1,A0
	LEA	2(A0),A0
	MOVE	#3999,D0
PLAN2	MOVE	#$FFFF,(A0)
	LEA	8(A0),A0
	DBF	D0,PLAN2
	
	MOVE.L	SCREEN1,A0
	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	JSR	8*4(A1)
	
	LEA	TABLE+4,A1

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

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBL_IR,$70.W
	MOVE.L	$120.W,ANC_TB
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

J	JMP	J
;0000
;0001	42
;0010	44
;0011	46
;0100	48
;0101	4A
;0110	4C
;0111	4E
;1000	50
;1001	52
;1010	54
TB0_IR	
	MOVE	#$666,$FFFF8246.W
	MOVE	#$666,$FFFF8254.W
	MOVE	#$006,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB1_IR,$120.W
	MOVE.B	#20,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB1_IR	
	MOVE	#$555,$FFFF8246.W
	MOVE	#$555,$FFFF8254.W
	MOVE	#$005,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB2_IR,$120.W
	MOVE.B	#15,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB2_IR	
	MOVE	#$444,$FFFF8246.W
	MOVE	#$444,$FFFF8254.W
	MOVE	#$004,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB3_IR,$120.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB3_IR	
	MOVE	#$333,$FFFF8246.W
	MOVE	#$333,$FFFF8254.W
	MOVE	#$003,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB4_IR,$120.W
	MOVE.B	#5,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB4_IR	
	MOVE	#$222,$FFFF8246.W
	MOVE	#$222,$FFFF8254.W
	MOVE	#$002,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB5_IR,$120.W
	MOVE.B	#3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB5_IR	
	MOVE	#$111,$FFFF8246.W
	MOVE	#$111,$FFFF8254.W
	MOVE	#$001,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB6_IR,$120.W
	MOVE.B	#200-154,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB6_IR	
	MOVE	#$222,$FFFF8246.W
	MOVE	#$222,$FFFF8254.W
	MOVE	#$002,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB7_IR,$120.W
	MOVE.B	#3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TB7_IR	
	MOVE	#$333,$FFFF8246.W
	MOVE	#$333,$FFFF8254.W
	MOVE	#$003,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB8_IR,$120.W
	MOVE.B	#5,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB8_IR	
	MOVE	#$444,$FFFF8246.W
	MOVE	#$444,$FFFF8254.W
	MOVE	#$004,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB9_IR,$120.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB9_IR	
	MOVE	#$555,$FFFF8246.W
	MOVE	#$555,$FFFF8254.W
	MOVE	#$005,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB10_IR,$120.W
	MOVE.B	#15,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB10_IR	
	MOVE	#$666,$FFFF8246.W
	MOVE	#$666,$FFFF8254.W
	MOVE	#$006,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB11_IR,$120.W
	MOVE.B	#20,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB11_IR	
	MOVE	#$777,$FFFF8246.W
	MOVE	#$777,$FFFF8254.W
	MOVE	#$007,$FFFF8244.W
	CLR.B	$FFFFFA1B.W
;	MOVE.L	#TB11_IR,$120.W
;	MOVE.B	#20,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE

VBL_IR
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TB0_IR,$120.W
	MOVE.B	#82-56-3,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	MOVE.L	SCREEN1,A0

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIM
	ST	$FFFF8240.W
NO_TIM	
 
	MOVE.L	(A1)+,A2
	CMPI.L	#0,-4(A1)
	BNE.S	ROUL
	LEA	TABLE+4,A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	JSR	8*4(A2)

;	MOVEM.L	D0-A6,-(SP)
;	MOVE.L	SCREEN1,A1
;	MOVE.L	SCREEN1,A0
;	LEA	32000(A0),A0
;	MOVE	#81,D7
;DAMO
;	MOVE	(A1),(A0)
;	MOVE.L	6(A1),6(A0)
;	MOVE.L	6+16(A1),6+16(A0)
;	MOVE.L	6+32(A1),6+32(A0)
;	MOVE.L	6+48(A1),6+48(A0)
;	MOVE.L	6+64(A1),6+64(A0)
;	MOVE.L	6+80(A1),6+80(A0)
;	MOVE.L	6+96(A1),6+96(A0)
;	MOVE.L	6+112(A1),6+112(A0)
;	MOVE.L	6+128(A1),6+128(A0)
;	MOVE.L	6+144(A1),6+144(A0)
	
;	LEA	-160(A0),A0
;	LEA	160(A1),A1
;	DBF	D7,DAMO

;	MOVEM.L	(SP)+,D0-A6

	SF	$FFFF8240.W
	
KK
;	movem.l	d0-a6,-(sp)
;	JSR	sound+26
;	movem.l	(sp)+,d0-a6
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	RTE
FIN:	
;	jsr	sound+22
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
	MOVE.L	ANC_TB,$70.W
	MOVE.L	ANC_VBL,$70.W
	MOVE	#$2300,SR

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	#2,$FFFF820A.W
	
	PEA	0.W
	TRAP	#1

EFF	move.l	SCREEN1,a0
	MOVE	#7999,D0
HA	CLR.L	(A0)+
	DBF	D0,HA
	RTS	
SAVED0	DS.L	1
SAVEA0	DS.L	1
SAVEA4	DS.L	1
GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVE.L	#-16+6,D7	OFFSET
	LEA	BUF1,A1
	LEA	BUF2,A2
	LEA	DATAS,A6
;	MOVE.L	SAVEA0,A0
;	MOVE.L	SAVEA4,A4
;	MOVE.L	A0,(A4)+
;	MOVE.L	A4,SAVEA4
	
LOOP	ADD.L	#16,D7
	CMPI	#32000,D7
	BGT	FINI
	MOVE	(A1)+,D0
	MOVE	(A1)+,D1
	MOVE	(A2)+,D2
	MOVE	(A2)+,D3

	CMP	D0,D2
	BEQ.S	SAME_MOT1
	CMP	D1,D3
	BEQ.S	SAME_MOT2
	CMPI	#0,D3
	BEQ.S	PLAN2_VIDE
MOVEL	;MOVE	#$217C,(A0)+
	;MOVE	D2,(A0)+
	;MOVE	D3,(A0)+


	MOVE	D2,D5
	SWAP	D5
	MOVE	D3,D5
	JSR	DO_IT
	
	;MOVE	D7,(A0)+
	BRA.S	LOOP
PLAN2_VIDE	CMPI	#0,D2
	BNE.S	MOVEL
	;MOVE	#$42A8,(A0)+
	;MOVE	D7,(A0)+
	BRA.S	LOOP

SAME_MOT2	CMPI	#0,D2
	BNE.S	MOVE_PLAN1
CLR_PLAN1	;MOVE	#$4268,(A0)+
	;MOVE	D7,(A0)+
	BRA.S	LOOP
MOVE_PLAN1	;MOVE	#$317C,(A0)+
	;MOVE	D2,(A0)+
	;MOVE	D7,(A0)+
	BRA.S	LOOP

SAME_MOT1	CMP	D1,D3
	BEQ.S	LOOP
	CMPI	#0,D3
	BNE.S	MOVE_PLAN2
CLR_PLAN2	;MOVE	#$4268,(A0)+
	;MOVE	D7,(A0)
	;ADDQ	#2,(A0)+
	BRA.S	LOOP
MOVE_PLAN2	;MOVE	#$317C,(A0)+
	;MOVE	D3,(A0)+
	;MOVE	D7,(A0)
	;ADDQ	#2,(A0)+
	BRA	LOOP
	
		
FINI	;MOVE	#$4E75,(A0)+
	;MOVE.L	A0,SAVEA0
	RTS

GENERE2
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D6
	MOVE.L	#-16+6,D7	OFFSET
	LEA	BUF1,A1
	LEA	BUF2,A2
	LEA	FINAL,A6
	MOVE.L	SAVEA0,A0
	MOVE.L	SAVEA4,A4
	MOVE.L	A0,(A4)+
	MOVE.L	A4,SAVEA4
	REPT	8
	MOVE.L	(A6)+,(A0)+
	MOVE.L	(A6)+,D0
	ENDR
	MOVEQ	#0,D0
WLOOP	ADD.L	#16,D7
	CMPI	#32000,D7
	BGT	WFINI
	MOVE	(A1)+,D0
	MOVE	(A1)+,D1
	MOVE	(A2)+,D2
	MOVE	(A2)+,D3

	CMP	D0,D2
	BEQ	WSAME_MOT1
	CMP	D1,D3
	BEQ.S	WSAME_MOT2
	CMPI	#0,D3
	BEQ.S	WPLAN2_VIDE
WMOVEL	

	MOVE.B	#$40,D6
	LEA	FINAL,A6
	MOVE	D2,D5
	SWAP	D5
	MOVE	D3,D5
	LEA	-8(A6),A6
TROUVE	LEA	8(A6),A6
	CMP.L	(A6),D5
	BEQ.S	C_LE_MEME
	ADDQ.B	#1,D6
	CMPI.B	#$48,D6
	BEQ.S	PADFRQ
	BRA.S	TROUVE
C_LE_MEME	MOVE.B	#$21,(A0)+
	MOVE.B	D6,(A0)+
	MOVE	D7,(A0)+
	BRA.S	WLOOP
PADFRQ	
	MOVE	#$217C,(A0)+
	MOVE	D2,(A0)+
	MOVE	D3,(A0)+
	MOVE	D7,(A0)+
	BRA.S	WLOOP
WPLAN2_VIDE	CMPI	#0,D2
	BNE.S	WMOVEL
	MOVE	#$42A8,(A0)+
	MOVE	D7,(A0)+
	BRA.S	WLOOP

WSAME_MOT2	CMPI	#0,D2
	BNE.S	WMOVE_PLAN1
WCLR_PLAN1	MOVE	#$4268,(A0)+
	MOVE	D7,(A0)+
	BRA.S	WLOOP
WMOVE_PLAN1	
	MOVE.B	#$40,D6
	LEA	FINAL,A6
	MOVE	D2,D5
	LEA	-8(A6),A6
TROUVE2	LEA	8(A6),A6
	CMP	2(A6),D5
	BEQ.S	C_LE_MEME2
	ADDQ.B	#1,D6
	CMPI.B	#$48,D6
	BEQ.S	PADFRQ2
	BRA.S	TROUVE2
C_LE_MEME2	MOVE.B	#$31,(A0)+
	MOVE.B	D6,(A0)+
	MOVE	D7,(A0)+
	BRA	WLOOP
PADFRQ2

	MOVE	#$317C,(A0)+
	MOVE	D2,(A0)+
	MOVE	D7,(A0)+
	BRA	WLOOP

WSAME_MOT1	CMP	D1,D3
	BEQ	WLOOP
	CMPI	#0,D3
	BNE.S	WMOVE_PLAN2
WCLR_PLAN2	MOVE	#$4268,(A0)+
	MOVE	D7,(A0)
	ADDQ	#2,(A0)+
	BRA	WLOOP
WMOVE_PLAN2	
	MOVE.B	#$40,D6
	LEA	FINAL,A6
	MOVE	D3,D5
	LEA	-8(A6),A6
TROUVE3	LEA	8(A6),A6
	CMP	2(A6),D5
	BEQ.S	C_LE_MEME3
	ADDQ.B	#1,D6
	CMPI.B	#$48,D6
	BEQ.S	PADFRQ3
	BRA.S	TROUVE3
C_LE_MEME3	MOVE.B	#$31,(A0)+
	MOVE.B	D6,(A0)+
	MOVE	D7,(A0)
	ADDQ	#2,(A0)+
	BRA	WLOOP
PADFRQ3


	MOVE	#$317C,(A0)+
	MOVE	D3,(A0)+
	MOVE	D7,(A0)
	ADDQ	#2,(A0)+
	BRA	WLOOP
	
		
WFINI	MOVE	#$4E75,(A0)+
	MOVE.L	A0,SAVEA0
	RTS

DO_IT	MOVEM.L	D0-A6,-(SP)
	LEA	DATAS,A0
HERE	CMPI.L	#0,(A0)
	BEQ.S	OKEY
	CMP.L	(A0),D5
	BEQ.S	IDEM
	LEA	8(A0),A0
	BRA.S	HERE
IDEM	LEA	4(A0),A0
	ADDQ.L	#1,(A0)+
	BRA.S	HER
	
OKEY	MOVE.L	D5,(A0)+
	MOVE.L	#1,(A0)+
HER	MOVEM.L	(SP)+,D0-A6
	RTS

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

sp_to_pl movem.l d0-d7/a1-a6,-(a7)
	
	lea 	points,a6		;a6 pointe coords
	ADDA.L	POINTEUR,A6
	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
	moveq	#0,d2
;	ADD	#30,D2
	ADD.L	#4,POINTEUR
	SUB	#160,D0
	SUB	#100,D1
	
	lea depla,a3
	adda.l	POINTEUR2,A3
	move.w #0,d3	;xdep
	clr.l	d4	;ydep
	move.w (a3)+,d5	;zdep
;	move	#-25,d4
	clr	d5
;	move	#85,D5

;	move	d5,d4
;	add	d2,d4
;	cmpi.l	#255,d4
;	bgt.s	oh_no
;	bra.s	oh_yes
;	
;oh_no	sub	#255,D5
;oh_yes	clr.l	d4
	
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
	MOVE	xp,(A1)+
	MOVE	yp,(A1)+
	RTS

SET_SCR:	move.l	#BUFFERSCR,d0	
	and.l	#$ffffff00,d0		
	move.l	d0,SCREEN1
	add.l	#32000,d0		
	move.l	d0,SCREEN2
	rts				
	

poly:
	JSR	LINE_A_INIT
	
	LEA	DATA_X,A5
	ADDA.L	PNT,A5
	CMPI	#$9999,(A5)
	BNE.S	OKAY
	CLR.L	PNT
	LEA	DATA_X,A5
	BRA.S	OKAY2
OKAY	ADD.L	#4*4,PNT
OKAY2	
	moveq	#0,d3

	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move	2(a5),d4
	move	6(a5),d5
	move	10(a5),d6
	move	14(a5),d7

	cmp	d4,d5
	bgt	d5_pg
	move	d4,d5
d5_pg	
	cmp	d6,d5
	bgt	d5_pg2
	move	d6,d5
d5_pg2	
	cmp	d7,d5
	bgt	d5_pg3
	move	d7,d5
d5_pg3	addq	#1,d5
	move	d5,ymax

	moveq	#0,d3

	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move	2(a5),d4
	move	6(a5),d5
	move	10(a5),d6
	move	14(a5),d7

	cmp	d4,d5
	blt	d5_pgh
	move	d4,d5
d5_pgh
	cmp	d6,d5
	blt	d5_pg2h
	move	d6,d5
d5_pg2h	
	cmp	d7,d5
	blt	d5_pg3h
	move	d7,d5
d5_pg3h	subq	#1,d5
	move	d5,ymin
	
;	LEA	TAB,A5
	LEA	_PTSIN,A6
	MOVE.L	(A5)+,(A6)+
	MOVE.L	(A5)+,(A6)+
	MOVE.L	(A5)+,(A6)+
	MOVE.L	(A5)+,(A6)+
	LEA	-4*4(A5),A5
	MOVE.L	(A5)+,(A6)+
	
	MOVE	ymin,D3
LOOP1	MOVE	D3,Y1(A0)
	MOVE.L	A0,-(SP)
;	DC	POLYGON
	cmp	#0,d3
	blt.s	saut
	cmp	#200,d3
	bge.s	saut
	JSR	LINE_A_POLYGON
saut	
	MOVE.L	(SP)+,A0
	ADDQ	#1,D3
	CMP	ymax,D3
	BNE	LOOP1

	RTS
ymin	ds	1
ymax	ds	1
LINE_A_INIT
	LEA	EMUL_LINEA,A0
;	LEA	$299A,A0
	MOVE.L	A0,D0
;	LEA	$FCA002,A1
;	LEA	$FC9FC2,A2
	RTS

LINE_A_POLYGON
	MOVEM.L	D3-D7/A3-A5,-(SP)
	JSR	_FCA0D6
	MOVEM.L	(SP)+,D3-D7/A3-A5
	RTS

_FCA0D6	;MOVEA.L	$299E,A0
	;MOVE.W	2(A0),D0
	;SUBQ.W	#1,D0
	MOVEQ	#3,D0      NB DE POINTS-1
	
;	MOVEA.L	$29A6,A0
	LEA	_PTSIN,A0
	
;	LEA	$16DA,A1
	LEA	BUF16DA,A1
;	CLR.W	$261E
	CLR.W	PNT_261E
	
LFCA0F4	MOVE.W	6(A0),D1
	MOVE.W	2(A0),D2
	SUB.W	D2,D1
	BEQ.S	LFCA13E
	MOVE.W	EMUL_LINEA-$299A+$29C2,D3
;	MOVE.W	$29C2,D3
	MOVE.W	D3,D4
	SUB.W	D2,D4
	SUB.W	6(A0),D3
	MOVE.W	D4,D2
	EOR.W	D3,D2
	BPL.S	LFCA13E
	MOVE.W	4(A0),D2
	SUB.W	0(A0),D2
	ADD.W	D2,D2
	MULS.W	D2,D4
	DIVS.W	D1,D4
	BPL.S	LFCA12E
	NEG.W	D4
	ADDQ.W	#1,D4
	ASR.W	#1,D4
	NEG.W	D4
	BRA.S	LFCA132
LFCA12E	ADDQ.W	#1,D4
	ASR.W	#1,D4
LFCA132	ADD.W	0(A0),D4
	MOVE.W	D4,(A1)+
;	ADDQ.W	#1,$261E
	ADDQ.W	#1,PNT_261E
	
LFCA13E	LEA	4(A0),A0
	DBF	D0,LFCA0F4
;	MOVE.W	$261E,D0
	MOVE.W	PNT_261E,D0
	BNE.S	LFCA150
	RTS
LFCA150	
	;LEA	$16DA,A0
	LEA	BUF16DA,A0
	BSR	LFCA1DC
;	MOVE.W	$261E,D0
	MOVE.W	PNT_261E,D0
	ASR.W	#1,D0
	SUBQ.W	#1,D0
	TST.W	EMUL_LINEA+$29D0-$299A
	BNE.S	LFCA18A
LFCA16C	
	MOVE.W	(A1)+,EMUL_LINEA+$29C0-$299A
	MOVE.W	(A1)+,EMUL_LINEA+$29C4-$299A
;	MOVE.W	(A1)+,$29C0
;	MOVE.W	(A1)+,$29C4
	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR	_FCA5F6
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
	DBF	D0,LFCA16C
	RTS
LFCA18A	
	MOVE.W	(A1)+,EMUL_LINEA+$29C0-$299A
	MOVE.W	(A1)+,EMUL_LINEA+$29C4-$299A
;	MOVE.W	(A1)+,$29C0
;	MOVE.W	(A1)+,$29C4

	MOVE	EMUL_LINEA+$29D2-$299A,D1
	MOVE	EMUL_LINEA+$29C0-$299A,D2
	MOVE	EMUL_LINEA+$29C4-$299A,D3
;	MOVE.W	$29D2,D1
;	MOVE.W	$29C0,D2
;	MOVE.W	$29C4,D3
	CMP.W	D1,D2
	BGE.S	LFCA1B6
	CMP.W	D1,D3
	BLT.S	LFCA1D6
;	MOVE.W	D1,$29C0
	MOVE.W	D1,EMUL_LINEA+$29C0-$299A
LFCA1B6	
	MOVE.W	EMUL_LINEA+$29D6-$299A,D1
;	MOVE.W	$29D6,D1
	CMP.W	D1,D3
	BLE.S	LFCA1CA
	CMP.W	D1,D2
	BGT.S	LFCA1D6
;	MOVE.W	D1,$29C4
	MOVE.W	D1,EMUL_LINEA+$29C4-$299A
LFCA1CA	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR	_FCA5F6
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
LFCA1D6	DBF	D0,LFCA18A
	RTS
LFCA1DC	SUBQ.W	#2,D0
	BCS.S	LFCA1FC
	MOVE.W	D0,D1
	MOVEA.L	A0,A1
LFCA1E4	MOVE.W	D1,D0
	MOVEA.L	A1,A0
LFCA1E8	MOVE.W	(A0)+,D2
	CMP.W	(A0),D2
	BLE.S	LFCA1F4
	MOVE.W	(A0),-2(A0)
	MOVE.W	D2,(A0)
LFCA1F4	DBF	D0,LFCA1E8
	DBF	D1,LFCA1E4
LFCA1FC	RTS
	MOVEQ	#1,D1
	MOVE.W	6(A7),D0
	MULS.W	4(A7),D0
	BGE.S	LFCA20C
	NEG.W	D1
LFCA20C	MOVE.W	8(A7),D2
	DIVS.W	D2,D0
	TST.W	D2
	BGE.S	LFCA21A
	NEG.W	D1
	NEG.W	D2
LFCA21A	MOVE.L	D3,-(A7)
	MOVE.L	D0,D3
	BGE.S	LFCA222
	NEG.L	D3
LFCA222	SWAP	D3
	ADD.W	D3,D3
	CMP.W	D2,D3
	BLT.S	LFCA22C
	ADD.W	D1,D0
LFCA22C	MOVE.L	(A7)+,D3
	RTS
	MOVE.W	D2,-(A7)
	MOVE.W	D3,-(A7)
;	MULS.W	$2998,D1
	MULS.W	#160,D1

	MOVE.W	EMUL_LINEA,D3
	MOVE.B	_FCA259(PC,D3.W),D3
	MOVE.W	D0,D2
	EXT.L	D2
	AND.W	#$FFF0,D2
	ASR.W	D3,D2
	ADD.L	D2,D1
	AND.W	#$F,D0
	MOVE.W	(A7)+,D3
	MOVE.W	(A7)+,D2
	RTS
_FCA259	DC.L	$03020001
	DC.L	$00000000

_FCA5D4	DC	$FFFF
_FCA5D6	DC.L	$7FFF3FFF
	DC.L	$1FFF0FFF
	DC.L	$07FF03FF
	DC.L	$01FF00FF
	DC.L	$007F003F
	DC.L	$001F000F
	DC.L	$00070003
	DC.L	$00010000
_FCA5F6
	LEA	EMUL_LINEA,A4
	MOVEM.W	$26(A4),D4-D6
	MOVE.W	D5,D0
	AND.W	$32(A4),D0
	ADD.W	D0,D0
	MOVEA.L	$2E(A4),A0
	ADDA.W	D0,A0
	TST.W	$34(A4)
	SNE	D0
	AND.W	#$20,D0
	MOVE.W	D4,D1
	ASR.W	#4,D1
	MOVE.W	D6,D2
	ASR.W	#4,D2
	MOVEQ	#$F,D3
	AND.W	D3,D4
	ADD.W	D4,D4
	MOVE.W	_FCA5D4(PC,D4.W),D4
	AND.W	D3,D6
	ADD.W	D6,D6
	MOVE.W	_FCA5D6(PC,D6.W),D6
	NOT.W	D6
	SUB.W	D1,D2
	BNE.S	LFCA63C
	AND.W	D6,D4
LFCA63C	MOVEA.L	$9A(A4),A5
;TEST	JMP	(A5)
;	JMP	LFD1B58
	
LFD1B58
	MOVEA.L	SCREEN1,A1
;	MULS.W	-2(A4),D5
	MULS.W	#160,D5
	
	ADDA.L	D5,A1
	MOVEA.W	D0,A2
;	MOVE.W	0(A4),D7

	MOVE.W	#4,D7
	
	MOVE.W	D7,D0
	ADD.W	D0,D0
	MULS.W	D0,D1
	ADDA.L	D1,A1
	SUBQ.W	#1,D7
	LEA	$18(A4),A3
	MOVE.W	$24(A4),D1
	ADD.W	D1,D1
TST	LEA	_FD1B86(PC,D1.W),A5
	ADDA.W	(A5),A5
;	JMP	(A5)
	JMP	LFD1C52
	
_FD1B86	DC.L	$00CC0130
	DC.L	$009C014A
	DC.L	$4E56FFEC

LFD1C52

	NOT.W	D4
	NOT.W	D6
LFD1C56	MOVEA.L	A1,A4
	MOVE.W	D2,D5
	MOVE.W	(A0),D3
	ADDA.W	A2,A0
	TST.W	(A3)+
	BNE.S	LFD1C88
	MOVE.W	D4,D1
	AND.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1C7E
	SUBQ.W	#1,D5
	BCS.S	LFD1C78
	CLR.W	D1
LFD1C70	ADDA.W	D0,A4
	MOVE.W	D1,(A4)
	DBF	D5,LFD1C70
LFD1C78	MOVE.W	D6,D1
	ADDA.W	D0,A4
	AND.W	D1,(A4)
LFD1C7E	DBF	D7,LFD1C56
	NOT.W	D4
	NOT.W	D6
	RTS
LFD1C88	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D4,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1CAE
	SUBQ.W	#1,D5
	BCS.S	LFD1CA2
LFD1C9A	ADDA.W	D0,A4
	MOVE.W	D3,(A4)
	DBF	D5,LFD1C9A
LFD1CA2	ADDA.W	D0,A4
	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D6,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A4)
LFD1CAE	DBF	D7,LFD1C56
	NOT.W	D4
	NOT.W	D6
	RTS



FILL	
	DC.L	-1
	DC.L	-1
	DC.L	-1
	DC.L	-1
	
TAB	
	DC	50,70
	DC	12,175
	DC	120,190
	DC	410,150

	DC	50,70

cos_tab	incbin 'COSIN.DAT'	;tables sinus cosinus
sin_tab	equ cos_tab+720

;sound	incbin	htl.mus

points
Y	SET	-64*2
	REPT	4
X	SET	-64*2
 DC 144+X,84+Y
 DC 144+X,116+Y
 DC 176+X,116+Y
 DC 176+X,84+Y
 DC 144+X+32,84+Y+32
 DC 144+X+32,116+Y+32
 DC 176+X+32,116+Y+32
 DC 176+X+32,84+Y+32
X	SET	X+64
 DC 144+X,84+Y
 DC 144+X,116+Y
 DC 176+X,116+Y
 DC 176+X,84+Y
 DC 144+X+32,84+Y+32
 DC 144+X+32,116+Y+32
 DC 176+X+32,116+Y+32
 DC 176+X+32,84+Y+32
X	SET	X+64
 DC 144+X,84+Y
 DC 144+X,116+Y
 DC 176+X,116+Y
 DC 176+X,84+Y
 DC 144+X+32,84+Y+32
 DC 144+X+32,116+Y+32
 DC 176+X+32,116+Y+32
 DC 176+X+32,84+Y+32
X	SET	X+64
 DC 144+X,84+Y
 DC 144+X,116+Y
 DC 176+X,116+Y
 DC 176+X,84+Y
 DC 144+X+32,84+Y+32
 DC 144+X+32,116+Y+32
 DC 176+X+32,116+Y+32
 DC 176+X+32,84+Y+32
X	SET	X+64
 DC 144+X,84+Y
 DC 144+X,116+Y
 DC 176+X,116+Y
 DC 176+X,84+Y
 DC 144+X+32,84+Y+32
 DC 144+X+32,116+Y+32
 DC 176+X+32,116+Y+32
 DC 176+X+32,84+Y+32
Y	SET	Y+64
	ENDR
depla		
	dc	255
	
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


;	section bss

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
POINTEUR2	DS.L	1
DATA_X
	DS	NB_PTS*2
;	DS	NB_POS*NB_PTS
;;DATA_Y
;	DS	NB_POS*NB_PTS

	DC	$9999
	section bss

;tdroit	ds.w	800
;tgauch	ds.w	800
;
;X1	DS.W	1
;X2	DS.W	1
;Y	DS.L	1
;SENS	DS.W	1

SCREEN2	DS.L	1
SCREEN1	DS.L	1
ANC_VBL	DS.L	1
ANC_TB	DS.L	1
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
	even
CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1	
PNT_X	DS.L	1
PNT_Y	DS.L	1
PNT	DS.L	1

*LINE_A_EMUL

PNT_261E	DS	1
EMUL_LINEA	DS.B	100
BUF16DA	DS.B	512
BUF299A	DS.B	512
	even
_PTSIN	DS.B	100
	even
	DS.B	256
BUFFERSCR	DS.B	64000
	even
TABLE	DS.L	360
BUF1	DS.B	8000
BUF2	DS.B	8000
FINAL	DS.L	16
DATAS	DS.B	8000
BUFCOD	DS.B	305000
