	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	D0,SAUV_SP
	
	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	MOVE.L	#FIN,$008
	MOVE.L	#FIN,$00C
	MOVE.L	#FIN,$010
	MOVE.L	#FIN,$014
	MOVE.L	#FIN,$018
	MOVE.L	#FIN,$01C
	MOVE.L	#FIN,$020
	MOVE.L	#FIN,$024
	
	ANDI.B	#%11111000,$484.W
	
	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
	MOVE.L	#$00000777,$FFFF8240.W
	MOVE.L	#$00070777,$FFFF8244.W
	MOVE.L	#$00700070,$FFFF8248.W
	MOVE.L	#$00700070,$FFFF824C.W
	MOVE.B	$FFFF8201.W,SAUVEC
	MOVE.B	$FFFF8203.W,SAUVEC+1
	
	BSR	PSPREQ
	BSR	PREP_BUF
	BSR	PREPCOD1
	CLR.W	OFF_SET
	MOVE.L	#BOUG3,LOD_PROC
	BSR	PREP_ECR
	
	MOVE.L	#FONT1+34+(160*132)+112,SOV_LET
	CLR.L	POS_LET
	CLR.B	SCRP1

	MOVE.B	$FFFFFA07.W,MFP
	MOVE.B	$FFFFFA09.W,MFP+1
	MOVE.B	$FFFFFA0F.W,MFP+2
	MOVE.B	$FFFFFA13.W,MFP+3
	MOVE.B	$FFFFFA1B.W,MFP+4
	MOVE.B	$FFFFFA21.W,MFP+5
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W

	MOVEQ	#2,D0
	JSR	MUZAXX
	CLR.L	POS1
	CLR.L	POS2
	CLR.L	POS3

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W
	MOVE.L	$120.W,ANC_TIM
	MOVE.L	#TB0,$120.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W
	
LOOP	JMP	LOOP

FIN	MOVE.L	ANC_VBL,$70.W
	MOVE.L	ANC_TIM,$120.W
	
	MOVE.B	MFP,$FFFFFA07.W
	MOVE.B	MFP+1,$FFFFFA09.W
	MOVE.B	MFP+2,$FFFFFA0F.W
	MOVE.B	MFP+3,$FFFFFA13.W
	MOVE.B	MFP+4,$FFFFFA1B.W
	MOVE.B	MFP+5,$FFFFFA21.W
	
	MOVE.B	SAUVEC,$FFFF8201.W
	MOVE.B	SAUVEC+1,$FFFF8203.W

	ORI.B	#%00000111,$484.W
	
	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W
	
	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP	
	
	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	
	*******	V B L  &  P R O C E D U R E S   *******
VBLR	MOVE.L	#$00000777,$FFFF8240.W
	MOVE.L	#$00070777,$FFFF8244.W
	MOVE.L	#$00700070,$FFFF8248.W
	MOVE.L	#$00700070,$FFFF824C.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#199,$FFFFFA21.W
	MOVE.L	#TB0,$120.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	LOD_PROC,A0
	JSR	(A0)
	BSR	EFFEQ
	BSR	EQUALZ
	BRA	SCROL8X8
SUITV0	BSR	SWAPEC
	JSR	MUZAXX+8
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

TB0	CLR.B	$FFFFFA1B.W
	MOVE.L	FONT1+2,$FFFF8240.W
	MOVE.L	FONT1+6,$FFFF8244.W
	MOVE.L	FONT1+10,$FFFF8248.W
	MOVE.L	FONT1+14,$FFFF824C.W
	MOVE.L	FONT1+18,$FFFF8250.W
	MOVE.L	FONT1+22,$FFFF8254.W
	MOVE.L	FONT1+26,$FFFF8258.W
	MOVE.L	FONT1+30,$FFFF825C.W
	REPT	55
	NOP
	ENDR
	CLR.B	$FFFF820A.W
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MOVE.B	#2,$FFFF820A.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	BCLR	#0,$FFFFFA0F.W
	RTE

EQUALZ	MOVEQ	#0,D0
	MOVE.B	#8,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D0
	LEA	BUFSPREQ,A0
	LSL.L	#5,D0
	LSL.L	#5,D0
	ADDA.L	D0,A0
	MOVE.L	SCREEN2,A1
	LEA	160*5(A1),A1
	LEA	TAB1,A2
	ADDA.L	POS1,A2
	CMPI.B	#-1,(A2)
	BNE	SUITAF1
	CLR.L	POS1
	LEA	TAB1,A2
SUITAF1	MOVEQ	#0,D0
	MOVE.B	(A2),D0
	MOVE.L	D0,D1
	ANDI.W	#%0000000000001111,D0
	LSL.L	#6,D0
	ADDA.L	D0,A0
	ANDI.W	#%1111111111110000,D1
	LSR.L	#1,D1
	ADDA.L	D1,A1
	BSR	AFF_VOIC

	MOVEQ	#0,D0
	MOVE.B	#9,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D0
	LEA	BUFSPREQ,A0
	LSL.L	#5,D0
	LSL.L	#5,D0
	ADDA.L	D0,A0
	MOVE.L	SCREEN2,A1
	LEA	160*5(A1),A1
	LEA	TAB2,A2
	ADDA.L	POS2,A2
	CMPI.B	#-1,(A2)
	BNE	SUITAF2
	CLR.L	POS2
	LEA	TAB2,A2
SUITAF2	MOVEQ	#0,D0
	MOVE.B	(A2),D0
	MOVE.L	D0,D1
	ANDI.W	#%0000000000001111,D0
	LSL.L	#6,D0
	ANDI.W	#%1111111111110000,D1
	LSR.L	#1,D1
	ADDA.L	D0,A0
	ADDA.L	D1,A1	
	BSR	AFF2VOIC

	MOVEQ	#0,D0
	MOVE.B	#$A,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D0
	LEA	BUFSPREQ,A0
	LSL.L	#5,D0
	LSL.L	#5,D0
	ADDA.L	D0,A0
	MOVE.L	SCREEN2,A1
	LEA	160*5(A1),A1
	LEA	TAB3,A2
	ADDA.L	POS3,A2
	CMPI.B	#-1,(A2)
	BNE	SUITAF3
	CLR.L	POS3
	LEA	TAB3,A2
SUITAF3	MOVEQ	#0,D0
	MOVE.B	(A2),D0
	MOVE.L	D0,D1
	ANDI.W	#%0000000000001111,D0
	LSL.L	#6,D0
	ANDI.W	#%1111111111110000,D1
	LSR.L	#1,D1
	ADDA.L	D0,A0
	ADDA.L	D1,A1
	ADDQ.L	#2,A1
	BSR	AFF2VOIC
	RTS

AFF_VOIC
N	SET	0
N2	SET	0
	REPT	16
	MOVE.W	N2(A0),N(A1)
	MOVE.W	N2+2(A0),N+8(A1)
	MOVE.W	N2(A0),N+160(A1)
	MOVE.W	N2+2(A0),N+160+8(A1)
	MOVE.W	N2(A0),N+320(A1)
	MOVE.W	N2+2(A0),N+320+8(A1)
	MOVE.W	N2(A0),N+480(A1)
	MOVE.W	N2+2(A0),N+480+8(A1)
	MOVE.W	N2(A0),N+640(A1)
	MOVE.W	N2+2(A0),N+640+8(A1)
N	SET	N+640
N2	SET	N2+4
	ENDR
	RTS

AFF2VOIC	
N	SET	2
N2	SET	0
	REPT	16
	MOVE.W	N2(A0),D0
	MOVE.W	N2+2(A0),D1
	OR.W	D0,N(A1)
	OR.W	D1,N+8(A1)
	OR.W	D0,N+160(A1)
	OR.W	D1,N+160+8(A1)
	OR.W	D0,N+320(A1)
	OR.W	D1,N+320+8(A1)
	OR.W	D0,N+480(A1)
	OR.W	D1,N+480+8(A1)
	OR.W	D0,N+640(A1)
	OR.W	D1,N+640+8(A1)
N2	SET	N2+4
N	SET	N+640
	ENDR
	RTS

EFFEQ	LEA	TAB1,A0
	ADDA.L	POS1,A0
	MOVEQ	#0,D0
	MOVE.B	-(A0),D0
	ANDI.W	#%1111111111110000,D0
	LSR.L	#1,D0
	MOVE.L	SCREEN2,A1
	LEA	160*5(A1),A1
	ADDA.L	D0,A1
	BSR	EFF_VOIC
	ADDQ.L	#1,POS1
	LEA	TAB2,A0
	ADDA.L	POS2,A0
	MOVEQ	#0,D0
	MOVE.B	-(A0),D0
	ANDI.W	#%1111111111110000,D0
	LSR.L	#1,D0
	MOVE.L	SCREEN2,A1
	LEA	160*5(A1),A1
	ADDA.L	D0,A1
	BSR	EFF2VOIC
	ADDQ.L	#1,POS2
	LEA	TAB3,A0
	ADDA.L	POS3,A0
	MOVEQ	#0,D0
	MOVE.B	-(A0),D0
	ANDI.W	#%1111111111110000,D0
	LSR.L	#1,D0
	MOVE.L	SCREEN2,A1
	LEA	160*5(A1),A1
	ADDA.L	D0,A1
	ADDQ.L	#2,A1
	BSR	EFF2VOIC
	ADDQ.L	#1,POS3
	RTS
	
EFF_VOIC
N	SET	0
	REPT	16*5
	CLR.W	N(A1)
	CLR.W	N+8(A1)
N	SET	N+160
	ENDR	
	RTS
				
EFF2VOIC
N	SET	2
	REPT	16*5
	CLR.W	N(A1)
	CLR.W	N+8(A1)
N	SET	N+160
	ENDR	
	RTS

BOUG1	LEA	BUF_GRF2,A0
	ADDA.W	OFF_SET,A0
	MOVE.L	SCREEN2,A1
	LEA	80(A1),A1
	JSR	BUFCOD1
	CMPI.W	#20*80,OFF_SET
	BNE	SUITBG1
	MOVE.W	#-2,OFF_SET
	MOVE.L	#BOUG4,LOD_PROC
SUITBG1	ADDI.W	#20,OFF_SET
	RTS

BOUG2	LEA	BUF_GRF1,A0
	ADDA.W	OFF_SET,A0
	MOVE.L	SCREEN2,A1
	LEA	80(A1),A1
	JSR	BUFCOD1
	CMPI.W	#0,OFF_SET
	BNE	SUITBG2
	MOVE.W	#20,OFF_SET
	MOVE.L	#BOUG3,LOD_PROC
SUITBG2	SUBI.W	#20,OFF_SET
	RTS

BOUG3	LEA	GRAPH,A0
	ADDA.W	OFF_SET,A0
	MOVE.L	SCREEN2,A1
	LEA	80(A1),A1
	JSR	BUFCOD2
	CMPI.W	#20,OFF_SET
	BNE	SUITBG3
	MOVE.W	#-2,OFF_SET
	MOVE.L	#BOUG1,LOD_PROC
SUITBG3	ADDQ.W	#2,OFF_SET
	RTS

BOUG4	MOVE.L	#GRAPH+(40*80),A0
	ADDA.W	OFF_SET,A0
	MOVE.L	SCREEN2,A1
	LEA	80(A1),A1
	JSR	BUFCOD2
	CMPI.W	#0,OFF_SET
	BNE	SUITBG4
	MOVE.W	#(20*80)+2,OFF_SET
	MOVE.L	#BOUG2,LOD_PROC
SUITBG4	SUBQ.W	#2,OFF_SET
	RTS
	
SCROL8X8	MOVE.L	SCREEN2,A0
	ADDA.L	#200*160,A0
	BSR	DECAL
	CMPI.B	#1,SCRP1
	BLO	PART1
	BEQ	PART2
	CMPI.B	#3,SCRP1
	BLO	PART3
	BEQ	PART4

	
DECAL	
N	SET	0
	REPT	33
	MOVEM.L	N+8(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N(A0)
	MOVEM.L	N+60(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N+52(A0)
	MOVEM.L	N+112(A0),D0-D7/A2-A5
	MOVEM.L	D0-D7/A2-A5,N+104(A0)
N	SET	N+160
	ENDR
	RTS

PART1	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(200*160),A1
N	SET	0
	REPT	33
	MOVE.B	N+9(A0),N(A1)
	MOVE.B	N+11(A0),N+2(A1)
	MOVE.B	N+13(A0),N+4(A1)
	MOVE.B	N+15(A0),N+6(A1)
N	SET	N+160
	ENDR
	BSR	NEW_LET1
	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#153+(200*160),A1
N	SET	0
	REPT	33
	MOVE.B	N(A0),N(A1)
	MOVE.B	N+2(A0),N+2(A1)
	MOVE.B	N+4(A0),N+4(A1)
	MOVE.B	N+6(A0),N+6(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	SUITV0

PART2	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(200*160),A1
N	SET	0
	REPT	33
	MOVE.L	N(A0),N(A1)
	MOVE.L	N+4(A0),N+4(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	SUITV0

PART3	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(200*160),A1
N	SET	0
	REPT	33
	MOVE.B	N+1(A0),N(A1)
	MOVE.B	N+8(A0),N+1(A1)
	MOVE.B	N+3(A0),N+2(A1)
	MOVE.B	N+10(A0),N+3(A1)
	MOVE.B	N+5(A0),N+4(A1)
	MOVE.B	N+12(A0),N+5(A1)
	MOVE.B	N+7(A0),N+6(A1)
	MOVE.B	N+14(A0),N+7(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	SUITV0
	
PART4	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(200*160),A1
N	SET	0
	REPT	33
	MOVE.L	N+8(A0),N(A1)
	MOVE.L	N+12(A0),N+4(A1)
N	SET	N+160
	ENDR
	CLR.B	SCRP1
	BRA	SUITV0
	
NEW_LET1	LEA	TEXT1,A0
	ADDA.L	POS_LET,A0
	CMPI.B	#$FF,(A0)
	BNE	SUITNL1
	CLR.L	POS_LET
	LEA	TEXT1,A0
SUITNL1	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	LSL.W	#2,D0
	LEA	CORES1,A1
	ADDA.L	D0,A1
	MOVE.L	(A1),SOV_LET
	ADDQ.L	#1,POS_LET
	RTS
	
SWAPEC	MOVE.L	SCREEN2,D0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREP_ECR	MOVE.L	#BUFFER,D0
	ANDI.B	#0,D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000+6400,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PSPREQ	LEA	BUFSPREQ,A0
	LEA	64*16(A0),A0
	MOVEQ	#14,D0
	MOVEQ	#0,D1
	MOVEQ	#14,D2
RECOMP	MOVE.W	D0,D5
EFF_BF	ADDQ.L	#4,A0
	DBRA	D5,EFF_BF
	MOVE.W	D1,D5
AFF_BF	MOVE.W	#%1111111111111111,(A0)+
	ADDQ.L	#2,A0
	DBRA	D5,AFF_BF
	MOVEQ	#14,D6
DEC16	MOVE.L	A0,A2
	SUBA.L	#64,A0
	MOVEQ	#31,D7
REAFF	MOVE.W	(A0)+,(A2)+	
	DBRA	D7,REAFF
	MOVEQ	#31,D7
DECALP	ROXR	(A0)+
	DBRA	D7,DECALP
	DBRA	D6,DEC16
	SUBQ.W	#1,D0
	ADDQ.W	#1,D1
	DBRA	D2,RECOMP
	RTS		

PREP_BUF	LEA	GRAPH,A0
	LEA	BUF_GRF1,A1
	MOVEQ	#1,D7
RECOMTOUT	MOVE.W	#159,D1
AFFT1	MOVEQ	#9,D0
RCLIG1	MOVE.W	(A0)+,(A1)+
	DBRA	D0,RCLIG1
	LEA	20(A0),A0
	DBRA	D1,AFFT1
	MOVE.L	#GRAPH+20,A0
	LEA	BUF_GRF2,A1
	DBRA	D7,RECOMTOUT
	RTS

PREPCOD1	LEA	BUFCOD1,A0
	MOVEQ	#0,D2
	MOVEQ	#79,D1
RECOMCDG	MOVEQ	#9,D0
RECOMCD1	MOVE.W	#$3358,(A0)+
	MOVE.W	D2,(A0)+
	ADDQ.W	#8,D2
	DBRA	D0,RECOMCD1
	ADDI.W	#80,D2
	DBRA	D1,RECOMCDG
	MOVE.W	#$4E75,(A0)
	BSR	PREPCOD2
	RTS

PREPCOD2	LEA	BUFCOD2,A0
	MOVEQ	#0,D2
	MOVEQ	#79,D0
RECOMCDG2	MOVE.W	#9,D1
RECOMCD2	MOVE.W	#$3358,(A0)+
	MOVE.W	D2,(A0)+
	ADDQ.W	#8,D2
	DBRA	D1,RECOMCD2
	ADDI.W	#80,D2
	MOVE.L	#$41E80014,(A0)+
	DBRA	D0,RECOMCDG2
	MOVE.W	#$4E75,(A0)
	RTS

	SECTION	DATA
MUZAXX	INCBIN	ASTAROD.MUS

GRAPH	INCBIN	ZUUL_1.H_C

FONT1	INCBIN	FNT_ZAP.PI1

TEXT1	DC.B	"ABCDEFGHIJKLMNOPQRSTUVWXYZ   !'(),-./    0123456789   :?   WRAP   ",$FF
	EVEN

CORES1	INCLUDE	CORESZAP.S	

	DC.B	0
TAB1	
N	SET	0
	REPT	142
	DC.B	N
N	SET	N+1
	ENDR
	REPT	142
	DC.B	N
N	SET	N-1
	ENDR
	DC.B	-1

	DC.B	0
TAB2
N	SET	144
	REPT	144
	DC.B	N
N	SET	N-1
	ENDR
	REPT	144
	DC.B	N
N	SET	N+1
	ENDR
	DC.B	-1	

	DC.B	72
TAB3
N	SET	72
	REPT	72
	DC.B	N
N	SET	N+1
	ENDR
	REPT	144
	DC.B	N
N	SET	N-1
	ENDR
	REPT	72
	DC.B	N
N	SET	N+1
	ENDR
	DC.B	-1

	SECTION	BSS
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
ANC_TIM	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
POS1	DS.L	1
POS2	DS.L	1
POS3	DS.L	1
LOD_PROC	DS.L	1
OFF_SET	DS.W	1
POS_LET	DS.L	1
SOV_LET	DS.L	1
MFP	DS.B	8
SCRP1	DS.B	1
	EVEN
SAUVEC	DS.W	1	
	DS.B	256
BUFFER	DS.L	24000
	DS.B	256
BUFSPREQ	DS.W	1024*16
BUF_GRF1	DS.W	1600
BUF_GRF2	DS.W	1600
BUFCOD1	DS.W	1600+1
BUFCOD2	DS.W	(22*80)+1