SEG=(4*2)/4
NB_PTS=4*SEG
PAS=1
NB_POS=(256/4)+1

main
	CLR.L	-(SP)
	MOVE	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	move	#0,adag1
	move	#0,adag3
	move	#-2,adag2

	MOVE	#2*5,ang3

;	MOVE.L	#FIN,$8.W
;	MOVE.L	#FIN,$C.W
;	MOVE.L	#FIN,$10.W
;	MOVE.L	#FIN,$14.W

	CLR	-(SP)
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	MOVE	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	clr.l	HIDDEN

	JSR	LINE_A_INIT
	MOVE	#1,24(A0)
	CLR	26(A0)
	CLR	28(A0)
	CLR	30(A0)
	CLR	36(A0)
	MOVE.L	#FILL,46(A0)
	MOVE	#1,50(A0)
	CLR	52(A0)
	MOVE	#1,54(A0)
	move	#1,56(A0)
	move	#1,58(A0)
	move	#319,60(A0)
	move	#199,62(A0)

	JSR	SET_SCR
	MOVE	#$777,$FFFF8242.W
	MOVE	#$777,$FFFF8250.W

	MOVE.L	#TABLE_DAT,ADR_TABL
	
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	LEA	BUFCOD,A0
	MOVE.L	A0,SAVEA0
	LEA	TABLE,A4
	MOVE.L	A4,SAVEA4
	MOVEM.L	D0-A6,REG_GEN

;	move	#$9999,modif
;	JMP	AGAIN
*************
	move.l	#(NB_POS)-1,d7
ici	MOVE.L	D7,SAVED7
	ADDQ.L	#1,FLAG2
	sub	#4,modz
	Jsr	calcpoint
	Jsr	calcrot
	CLR.L	FLAG_PTS

	MOVEM.L	D0-A6,-(SP)
	movem.l	REG_GEN,D0-A6
GEN
	JSR	EFF
	ADDQ.L	#1,HIDDEN
	CMPI.L	#10,HIDDEN
	BLE.S	HIDE
	bsr	poly_
;	bsr	poly_
HIDE
;	CLR.L	PNT2
;	MOVE	#(SEG/2)-1,D6
;DO_SEG2	bsr	poly2
;	DBF	D6,DO_SEG2

	MOVE	#3999,D0
	MOVE.L	SCREEN1,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KL	MOVE	(A1),(A2)+
	MOVE	(A0),(A1)+
	ADDQ.L	#8,A0
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
	TST.L	(A0)
	BEQ.S	OKVAZY
	CMP.L	D0,D1
	BLE.S	LOOPED
	MOVE.L	D1,D0
	MOVE.L	D2,D4
;	MOVE.L	#1,4(A0)
	BRA.S	LOOPED
SAVED7	DC.L	0
HIDDEN	DC.L	0
OKVAZY
	LEA	DATAS,A0	;
	LEA	-8(A0),A0	;
BOUI	ADDQ.L	#8,A0	;
	CMP.L	#DATAS+8000,A0
	BEQ	LP

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

	MOVEM.L	D0-A6,REG_GEN
	MOVEM.L	(SP)+,D0-A6
	CLR.L	PNT
	CLR.L	PNT2

ADR_TABL	EQU	*+2
	LEA	ADR_TABL,A1
	MOVE	(A1)+,D0
;	MOVE	#100,MOD_Y
;	SUB	D0,MOD_Y
;	MOVE	#0,MOD_Z
;	SUB	D0,MOD_Z
	MOVE.L	A1,ADR_TABL
	MOVE.L	SAVED7,D7
	dbf	d7,ici

;	MOVE.L	#tpoitesp1,MODC
;	MOVE	#99,MOD_Y
;	MOVE	#$3E19,MODC2
;	MOVE.L	#$4E714E71,MODC3
;	MOVE.L	#$4E714E71,MODC4
;	MOVE.L	#$4E714E71,MODC5

***********
AGAIN	JSR	EFF
	clr.l	HIDDEN
;	jmp	pppo
	MOVE.L	#points2,MODC

	LEA	DATAS,A0
	MOVE.L	#(8000/4)-1,D0
F	CLR.L	(A0)+
	DBF	D0,F
	LEA	BUF1,A0
	MOVE.L	#(8000/4)-1,D0
FT	CLR.L	(A0)+
	DBF	D0,FT
	LEA	BUF2,A0
	MOVE.L	#(8000/4)-1,D0
FR	CLR.L	(A0)+
	DBF	D0,FR

	clr.l	HIDDEN
	clr	modz
	move	#0,adag1
	move	#0,adag3
	move	#-2,adag2

	MOVE	#2*5,ang3
	clr	ang2
	clr	ang1

	MOVE.L	#TABLE_DAT,ADR_TABLZ
	
	LEA	BUFCOD2,A0
	MOVE.L	A0,SAVEA0
	LEA	TABLE2,A4
	MOVE.L	A4,SAVEA4
	MOVEM.L	D0-A6,REG_GEN

;	move	#$9999,modif

*************
	move.l	#(NB_POS)-1,d7
iciZ	MOVE.L	D7,SAVED7
	ADDQ.L	#1,FLAG2
	sub	#4,modz
	Jsr	calcpoint
	Jsr	calcrot
	CLR.L	FLAG_PTS

	MOVEM.L	D0-A6,-(SP)
	movem.l	REG_GEN,D0-A6
GENZ
	JSR	EFF
	ADDQ.L	#1,HIDDEN
	CMPI.L	#48,HIDDEN
	BGT.S	HIDE1
	bsr	poly_
	BRA.S	HIDE12
HIDE1	ADD.L	#16,PNT
	ADD.L	#16,PNT2
HIDE12	CMPI.L	#10,HIDDEN
	BLE.S	HIDE2
	bsr	poly_
	BRA.S	HIDE22
HIDE2	ADD.L	#16,PNT
	ADD.L	#16,PNT2
HIDE22
;	CLR.L	PNT2
;	MOVE	#(SEG/2)-1,D6
;DO_SEG2	bsr	poly2
;	DBF	D6,DO_SEG2

	MOVE	#3999,D0
	MOVE.L	SCREEN1,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KLZ	MOVE	(A1),(A2)+
	MOVE	(A0),(A1)+
	ADDQ.L	#8,A0
	dbf	d0,KLZ

	JSR	GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D3
	LEA	DATAS,A0
	LEA	FINAL,A1
	LEA	-8(A0),A0
LOOPEDZ	LEA	8(A0),A0
	MOVE.L	(A0),D2
	MOVE.L	4(A0),D1
	TST.L	(A0)
	BEQ.S	OKVAZYZ
	CMP.L	D0,D1
	BLE.S	LOOPEDZ
	MOVE.L	D1,D0
	MOVE.L	D2,D4
;	MOVE.L	#1,4(A0)
	BRA.S	LOOPEDZ
;SAVED7	DC.L	0
OKVAZYZ
	LEA	DATAS,A0	;
	LEA	-8(A0),A0	;
BOUIZ	ADDQ.L	#8,A0	;
	CMP.L	#DATAS+8000,A0
	BEQ	LPZ

	CMP.L	(A0),D4	;
	BNE.S	BOUIZ	;
	CLR.L	4(A0)	;

	MOVE.L	D4,(A1)+
	MOVE.L	D0,(A1)+
	CMPI.L	#7,D3
	BEQ.S	LPZ
	ADDQ.L	#1,D3
	MOVEQ	#0,D0
	LEA	DATAS,A0
	LEA	-8(A0),A0
	BRA.S	LOOPEDZ

LPZ	LEA	DATAS,A0
	MOVE	#1999,D0
PZ	CLR.L	(A0)+
	DBF	D0,PZ
	JSR	GENERE2

	MOVEM.L	D0-A6,REG_GEN
	MOVEM.L	(SP)+,D0-A6
	CLR.L	PNT
	CLR.L	PNT2

ADR_TABLZ	EQU	*+2
	LEA	ADR_TABLZ,A1
	MOVE	(A1)+,D0
;	MOVE	#100,MOD_Y
;	SUB	D0,MOD_Y
;	MOVE	#0,MOD_Z
;	SUB	D0,MOD_Z
	MOVE.L	A1,ADR_TABLZ
	MOVE.L	SAVED7,D7
	dbf	d7,iciZ

pppo	MOVE.L	#tpoitesp1,MODC
	MOVE	#99,MOD_Y
	MOVE	#$3E19,MODC2
	MOVE.L	#$4E714E71,MODC3
	MOVE.L	#$4E714E71,MODC4
	MOVE.L	#$4E714E71,MODC5

***********
	JSR	EFF

	LEA	TABLE2,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	MOVE.L	SCREEN2,A0
	JSR	8*4(A1)
	MOVE.L	#TABLE2+4,MOD_ADR_3D

	MOVE	#7,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	MOVE.L	SCREEN1,A0
	JSR	8*4(A1)
	MOVE.L	#TABLE+4,MOD_ADR_3D2

VBL
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_COLOR
	SF	$FFFF8240.W
NO_COLOR	;JSR	ZIK+8
MOD_ADR_3D	EQU	*+2
	LEA	MOD_ADR_3D,A1
	MOVE.L	(A1)+,A2
	TST.L	-4(A1)
	BNE	ROUL
	MOVE.L	#TABLE2+4,MOD_ADR_3D
	LEA	MOD_ADR_3D,A1
	MOVE.L	(A1),A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	MOVE.L	SCREEN2,A0
	JSR	8*4(A2)
	MOVE.L	A1,MOD_ADR_3D
**
MOD_ADR_3D2	EQU	*+2
	LEA	MOD_ADR_3D2,A1
	MOVE.L	(A1)+,A2
	TST.L	-4(A1)
	BNE	ROUL2
	MOVE.L	#TABLE+4,MOD_ADR_3D2
	LEA	MOD_ADR_3D2,A1
	MOVE.L	(A1),A1
	MOVE.L	(A1)+,A2
ROUL2	MOVEM.L	(A2),D0-D7
	MOVE.L	SCREEN1,A0
	JSR	8*4(A2)
	MOVE.L	A1,MOD_ADR_3D2

newvbl
	ST	$FFFF8240.W
	MOVE	#$112,$FFFF8242.W	0001
	MOVE	#$700,$FFFF8244.W	0010
	MOVE	#$700,$FFFF8246.W	0011
	MOVE	#$007,$FFFF8248.W	0100
	MOVE	#$700,$FFFF824A.W	0101
	MOVE	#$700,$FFFF824C.W	0110
	MOVE	#$700,$FFFF824E.W	0111
	MOVE	#$112,$FFFF8250.W	1000
	MOVE	#$112,$FFFF8252.W	1001
	MOVE	#$700,$FFFF8254.W	1010
	MOVE	#$700,$FFFF8256.W	1011
	MOVE	#$700,$FFFF8258.W	1100
	MOVE	#$334,$FFFF825A.W	1101
	MOVE	#$700,$FFFF825C.W	1110
	MOVE	#$700,$FFFF825E.W	1111

;	move.l	SCREEN1,d0
;	move.l	SCREEN2,d1
	move.b	SCREEN2+1,$ffff8201.w
	move.b	SCREEN2+2,$ffff8203.w
;	move.l	d0,SCREEN2
;	move.l	d1,SCREEN1

	MOVE.L	SCREEN1,A2
	MOVE.L	SCREEN2,A3
	ADDQ.L	#2,A3
	MOVE	#199,D0
RECOP
N	SET	0
	REPT	10
	MOVE	N+6(A2),N(A3)		5
	MOVE	N+8(A2),N+8(A3)	5
N	SET	N+16
	ENDR
	LEA	160(A2),A2
	LEA	160(A3),A3
	DBF	D0,RECOP
	
;	bsr	calcpoint
;	bsr	tobj
;	bsr	calcrot

;	LEA	COLORS,A0
;MOD_PNT_COL	EQU	*+2
;	LEA	0(A0),A0
;	CMPI	#-1,(A0)
;	BNE.S	PUT_COL
;	CLR	MOD_PNT_COL
;	LEA	COLORS,A0
;PUT_COL	MOVE	(A0),COLP1
;	ADDQ	#2,MOD_PNT_COL
;	LEA	COLORS,A0
;MOD_PNT_COL2	EQU	*+2
;	LEA	64*2(A0),A0
;	CMPI	#-1,(A0)
;	BNE.S	PUT_COL2
;	CLR	MOD_PNT_COL2
;	LEA	COLORS,A0
;PUT_COL2	MOVE	(A0),COLP2
;	ADDQ	#2,MOD_PNT_COL2

	ST	$FFFF8240.W
	JSR	VSYNC
	BRA	VBL
COLP1	DC	0
COLP2	DC	0
VSYNC	MOVE.L	$466.W,D1
WAIT_VBL	CMP.L	$466,D1
	BEQ.S	WAIT_VBL
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTS

AFF_CADRE	MOVE.L	SCREEN1,A0
	LEA	192*160(A0),A1
	MOVE	#7,D1
DO_Y	MOVE	#19,D0
DO_X	MOVE	#$FFFF,2(A0)
	MOVE	#$FFFF,2(A1)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	DBF	D0,DO_X
	DBF	D1,DO_Y

	MOVE.L	SCREEN1,A0
	MOVE	#199,D0
DO_PIX	MOVE.B	#$FF,2(A0)
	MOVE.B	#$FF,153+2(A0)
	LEA	160(A0),A0
	DBF	D0,DO_PIX
	RTS
EFF_PLAN2	MOVE.L	SCREEN1,A0
	LEA	192*160(A0),A1
	MOVE	#7,D1
DO_Y_	MOVE	#19,D0
DO_X_	CLR	2(A0)
	CLR	2(A1)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	DBF	D0,DO_X_
	DBF	D1,DO_Y_

	MOVE.L	SCREEN1,A0
	MOVE	#199,D0
DO_PIX_	CLR.B	2(A0)
	CLR.B	153+2(A0)
	LEA	160(A0),A0
	DBF	D0,DO_PIX_
	RTS
FIN
	MOVE.L	4.W,A0
	JMP	(A0)

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

LOOP	ADD.L	#16,D7
	CMPI	#32000,D7
	BGT	FINI
	MOVE	(A1)+,D0
	MOVE	(A1)+,D1
	MOVE	(A2)+,D2
	MOVE	(A2)+,D3

	CMP	D0,D2
	BEQ.S	LOOP
	CMP	D1,D3
	BEQ.S	LOOP
	TST	D3
	BEQ.S	PLAN2_VIDE
MOVEL
	MOVE	D2,D5
	SWAP	D5
	MOVE	D3,D5
	JSR	DO_IT
	BRA.S	LOOP
PLAN2_VIDE	TST	D2
	BNE.S	MOVEL
	BRA.S	LOOP

FINI	RTS

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
	TST	D3
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
WPLAN2_VIDE	TST	D2
	BNE.S	WMOVEL
	MOVE	#$42A8,(A0)+
	MOVE	D7,(A0)+
	BRA.S	WLOOP

WSAME_MOT2	TST	D2
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
	TST	D3
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
HERE	TST.L	(A0)
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
calcrot
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
adag1	dc.w	0
adag2	dc.w	0
adag3	dc.w	0
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
MODC	EQU	*+2
ptchang3	lea.l	points,a1
	lea.l	tz+210*2,a2
modz	equ	*+2
	lea	0(a2),a2

	move.w	#161,d5
MOD_Y	EQU	*+2
	move.w	#100,d6
MODC2	NOP
;	move.w	(a1)+,d7
MODC3	MOVE	#NB_PTS-1,D7
bmatrix
	move.w	(a1)+,a3
	move.w	(a1)+,a4
	move.w	(a1)+,d4
;	moveq	#0,d4
MODC4	LEA	-160(A3),A3	
MODC5	LEA	-100(A4),A4	
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

	LEA	-29*160(A0),A0
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

SET_SCR:	move.l	#BUFFERSCR,d0	
	and.l	#$ffffff00,d0		
	move.l	d0,SCREEN1
	add.l	#32000,d0		
	move.l	d0,SCREEN2
	rts				

FLAG2	DC.L	1
poly2	CMP.L	#10,FLAG2
	BGT.S	AFF_TRUC
	ADD.L	#16,PNT
	ADD.L	#16,PNT2
	RTS
poly_:
;	cmp.l	#(NB_POS-9),FLAG2
;	BLE.S	AFF_TRUC
;	ADD.L	#16,PNT
;	ADD.L	#16,PNT2
;	RTS
AFF_TRUC	
;	cmpi.l	#((SEG-14)/2)*16,PNT2
;	BLT.S	III
;	ADD.L	#16,PNT2
;	ADD.L	#16,PNT
;	RTS
III	MOVE.L	D6,-(SP)
	JSR	LINE_A_INIT

	LEA	t_points,A5
	ADDA.L	PNT,A5
OKAY	ADD.L	#4*4,PNT
	ADD.L	#4*4,PNT2
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
LOOP1	MOVE	D3,40(A0)
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
	MOVE.L	(SP)+,D6
	RTS
ymin	ds	1
ymax	ds	1
LINE_A_INIT
	LEA	EMUL_LINEA,A0
	MOVE.L	A0,D0
	RTS

LINE_A_POLYGON
	MOVEM.L	D3-D7/A3-A5,-(SP)
	JSR	_FCA0D6
	MOVEM.L	(SP)+,D3-D7/A3-A5
	RTS

_FCA0D6
	MOVEQ	#3,D0
	
	LEA	_PTSIN,A0
	LEA	BUF16DA,A1
	CLR	PNT_261E
	
LFCA0F4	MOVE	6(A0),D1
	MOVE	2(A0),D2
	SUB	D2,D1
	BEQ.S	LFCA13E
	MOVE	EMUL_LINEA-$299A+$29C2,D3
	MOVE	D3,D4
	SUB	D2,D4
	SUB	6(A0),D3
	MOVE	D4,D2
	EOR	D3,D2
	BPL.S	LFCA13E
	MOVE	4(A0),D2
	SUB	0(A0),D2
	ADD	D2,D2
	MULS	D2,D4
	DIVS	D1,D4
	BPL.S	LFCA12E
	NEG	D4
	ADDQ	#1,D4
	ASR	#1,D4
	NEG	D4
	BRA.S	LFCA132
LFCA12E	ADDQ	#1,D4
	ASR	#1,D4
LFCA132	ADD	0(A0),D4
	MOVE	D4,(A1)+
	ADDQ	#1,PNT_261E
	
LFCA13E	LEA	4(A0),A0
	DBF	D0,LFCA0F4
	MOVE	PNT_261E,D0
	BNE.S	LFCA150
	RTS
LFCA150	
	LEA	BUF16DA,A0
	BSR	LFCA1DC
	MOVE	PNT_261E,D0
	ASR	#1,D0
	SUBQ	#1,D0
	TST	EMUL_LINEA+$29D0-$299A
	BNE.S	LFCA18A
LFCA16C	
	MOVE	(A1)+,EMUL_LINEA+$29C0-$299A
	MOVE	(A1)+,EMUL_LINEA+$29C4-$299A
	MOVE	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR	_FCA5F6
	MOVEA.L	(A7)+,A1
	MOVE	(A7)+,D0
	DBF	D0,LFCA16C
	RTS
LFCA18A	
	MOVE	(A1)+,EMUL_LINEA+$29C0-$299A
	MOVE	(A1)+,EMUL_LINEA+$29C4-$299A

	MOVE	EMUL_LINEA+$29D2-$299A,D1
	MOVE	EMUL_LINEA+$29C0-$299A,D2
	MOVE	EMUL_LINEA+$29C4-$299A,D3
	CMP	D1,D2
	BGE.S	LFCA1B6
	CMP	D1,D3
	BLT.S	LFCA1D6
	MOVE	D1,EMUL_LINEA+$29C0-$299A
LFCA1B6	
	MOVE	EMUL_LINEA+$29D6-$299A,D1
	CMP	D1,D3
	BLE.S	LFCA1CA
	CMP	D1,D2
	BGT.S	LFCA1D6
	MOVE	D1,EMUL_LINEA+$29C4-$299A
LFCA1CA	MOVE	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR	_FCA5F6
	MOVEA.L	(A7)+,A1
	MOVE	(A7)+,D0
LFCA1D6	DBF	D0,LFCA18A
	RTS
LFCA1DC	SUBQ	#2,D0
	BCS.S	LFCA1FC
	MOVE	D0,D1
	MOVEA.L	A0,A1
LFCA1E4	MOVE	D1,D0
	MOVEA.L	A1,A0
LFCA1E8	MOVE	(A0)+,D2
	CMP	(A0),D2
	BLE.S	LFCA1F4
	MOVE	(A0),-2(A0)
	MOVE	D2,(A0)
LFCA1F4	DBF	D0,LFCA1E8
	DBF	D1,LFCA1E4
LFCA1FC	RTS
	MOVEQ	#1,D1
	MOVE	6(A7),D0
	MULS	4(A7),D0
	BGE.S	LFCA20C
	NEG	D1
LFCA20C	MOVE	8(A7),D2
	DIVS	D2,D0
	TST	D2
	BGE.S	LFCA21A
	NEG	D1
	NEG	D2
LFCA21A	MOVE.L	D3,-(A7)
	MOVE.L	D0,D3
	BGE.S	LFCA222
	NEG.L	D3
LFCA222	SWAP	D3
	ADD	D3,D3
	CMP	D2,D3
	BLT.S	LFCA22C
	ADD	D1,D0
LFCA22C	MOVE.L	(A7)+,D3
	RTS
	MOVE	D2,-(A7)
	MOVE	D3,-(A7)
	MULS	#160,D1

	MOVE	EMUL_LINEA,D3
	MOVE.B	_FCA259(PC,D3.W),D3
	MOVE	D0,D2
	EXT.L	D2
	AND	#$FFF0,D2
	ASR	D3,D2
	ADD.L	D2,D1
	AND	#$F,D0
	MOVE	(A7)+,D3
	MOVE	(A7)+,D2
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

_FD1B86	DC.L	$00CC0130
	DC.L	$009C014A
	DC.L	$4E56FFEC

_FCA5F6
	LEA	EMUL_LINEA,A4
	MOVEM	$26(A4),D4-D6
	MOVE	D5,D0
	AND	$32(A4),D0
	ADD	D0,D0
	MOVEA.L	$2E(A4),A0
	ADDA	D0,A0
	TST	$34(A4)
	SNE	D0
	AND	#$20,D0
	MOVE	D4,D1
	ASR	#4,D1
	MOVE	D6,D2
	ASR	#4,D2
	MOVEQ	#$F,D3
	AND	D3,D4
	ADD	D4,D4
	MOVE	_FCA5D4(PC,D4.W),D4
	AND	D3,D6
	ADD	D6,D6
	MOVE	_FCA5D6(PC,D6.W),D6
	NOT	D6
	SUB	D1,D2
	BNE.S	LFCA63C
	AND	D6,D4
LFCA63C	MOVEA.L	$9A(A4),A5
LFD1B58
	MOVEA.L	SCREEN1,A1
	MULS	#160,D5
	ADDA.L	D5,A1
	MOVEA	D0,A2

	MOVE	#4,D7
	MOVE	D7,D0
	ADD	D0,D0
	MULS	D0,D1
	ADDA.L	D1,A1
	MOVEQ	#0,D7
	
	LEA	$18(A4),A3
	MOVE	$24(A4),D1
	ADD	D1,D1
TST	LEA	_FD1B86(PC,D1.W),A5
	ADDA	(A5),A5

LFD1C52

	NOT	D4
	NOT	D6
LFD1C56	MOVEA.L	A1,A4
	MOVE	D2,D5
	MOVE	(A0),D3
	ADDA	A2,A0
	TST	(A3)+
	BNE.S	LFD1C88
	MOVE	D4,D1
	AND	D1,(A1)
	ADDQ.L	#8,A1
	SUBQ	#1,D5
	BCS.S	LFD1C7E
	SUBQ	#1,D5
	BCS.S	LFD1C78
	CLR	D1
LFD1C70	ADDA	D0,A4
	MOVE	D1,(A4)
	DBF	D5,LFD1C70
LFD1C78	MOVE	D6,D1
	ADDA	D0,A4
	AND	D1,(A4)
LFD1C7E	DBF	D7,LFD1C56
	NOT	D4
	NOT	D6
	RTS

LFD1C88	MOVE	(A4),D1
	EOR	D3,D1
	AND	D4,D1
	EOR	D3,D1
	MOVE	D1,(A1)
	ADDQ.L	#8,A1
	SUBQ	#1,D5
	BCS.S	LFD1CAE
	SUBQ	#1,D5
	BCS.S	LFD1CA2
LFD1C9A	ADDA	D0,A4
	MOVE	D3,(A4)
	DBF	D5,LFD1C9A
LFD1CA2	ADDA	D0,A4
	MOVE	(A4),D1
	EOR	D3,D1
	AND	D6,D1
	EOR	D3,D1
	MOVE	D1,(A4)
LFD1CAE	DBF	D7,LFD1C56
	NOT	D4
	NOT	D6
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

	incbin	tsin.aid
tsin	incbin	tsin.aid
	incbin	tsin.aid

tz	incbin	tzoom.aid

points2

 DC 160-50,100-50,-50
 DC 160-50,100+50,-50
 DC 160+50,100+50,-50
 DC 160+50,100-50,-50

 DC 50+160,100-50,-50
 DC 50+160,100+50,-50
 DC 50+160,100+50,50
 DC 50+160,100-50,50

points

 DC 50+160,100-50,-50
 DC 50+160,100+50,-50
 DC 50+160,100+50,50
 DC 50+160,100-50,50

 DC 160-50,100-50,50
 DC 160-50,100+50,50
 DC 160+50,100+50,50
 DC 160+50,100-50,50




*
depla		
;	include	z2.dat
	dc	255
TABLE_DAT
 DC 1
 DC 2
 DC 3
 DC 4
 DC 5
 DC 6
 DC 7
 DC 8
 DC 10
 DC 11
 DC 12
 DC 13
 DC 14
 DC 15
 DC 16
 DC 17
 DC 18
 DC 20
 DC 21
 DC 22
 DC 23
 DC 24
 DC 25
 DC 26
 DC 27
 DC 28
 DC 29
 DC 31
 DC 32
 DC 33
 DC 34
 DC 35
 DC 36
 DC 37
 DC 38
 DC 39
 DC 41
 DC 42
 DC 43
 DC 44
 DC 45
 DC 46
 DC 47
 DC 48
 DC 49
 DC 51
 DC 52
 DC 53
 DC 54
 DC 55
 DC 56
 DC 57
 DC 58
 DC 59
 DC 61
 DC 62
 DC 63
 DC 64
 DC 65
 DC 66
 DC 67
 DC 68
 DC 70
 DC 71
 DC 72
 DC 73
 DC 74
 DC 75
 DC 76
 DC 77
 DC 78
 DC 80
 DC 81
 DC 82
 DC 83
 DC 84
 DC 85
 DC 86
 DC 87
 DC 88
 DC 90
 DC 91
 DC 92
 DC 93
 DC 94
 DC 95
 DC 96
 DC 97
 DC 98
 DC 100
 DC 100
 DC 100

FAD_IN	DC	$0,$111,$222,$333,$444,$555,$666,$777
	DC	-1
FAD_OUT	DC	$777,$666,$555,$444,$333,$222,$111,$0
	DC	-1

PART1	DC	%1111111111111111
	DC	%0111111111111111
	DC	%0011111111111111
	DC	%0001111111111111
	DC	%0000111111111111
	DC	%0000011111111111
	DC	%0000001111111111
	DC	%0000000111111111
	DC	%0000000011111111
	DC	%0000000001111111
	DC	%0000000000111111
	DC	%0000000000011111
	DC	%0000000000001111
	DC	%0000000000000111
	DC	%0000000000000011
	DC	%0000000000000001

PART2	DC	%1000000000000000
	DC	%1100000000000000
	DC	%1110000000000000
	DC	%1111000000000000
	DC	%1111100000000000
	DC	%1111110000000000
	DC	%1111111000000000
	DC	%1111111100000000
	DC	%1111111110000000
	DC	%1111111111000000
	DC	%1111111111100000
	DC	%1111111111110000
	DC	%1111111111111000
	DC	%1111111111111100
	DC	%1111111111111110
	DC	%1111111111111111

PNTS
N	SET	32768
	REPT	16
	DC	N
N	SET	N/2
	ENDR


		
	*_______variables________*
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

	section	data

paobj	dc.l	tpoly1,tpoitesp1,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11,face12,face13,face14,face15,face16 	

face11	dc.w	$5488,4,0,4,8,12	DEVANT
face12	dc.w	$4E71,4,16,0,12,28	BAS
face13	dc.w	$5888,4,12,8,24,28	DROITE
face14	dc.w	$4E71,4,4,20,24,8	HAUT
face15	dc.w	$5888,4,16,20,4,0 	GAUCHE
face16	dc.w	$5488,4,28,24,20,16	DERRIERE

tpoitesp1	
	dc.w	8-1
	dc.w	-47,-47,-47		0
	dc.w	-47,47,-47		4
	dc.w	47,47,-47		8
	dc.w	47,-47,-47		12

	dc.w	-47,-47,47		16
	dc.w	-47,47,47		20
	dc.w	47,47,47		24
	dc.w	47,-47,47		28
;ZIK	INCBIN	LOGICAL.MUS
	even
COLORS
 DC $000
 DC $000
 DC $000
 DC $000
 DC $000
 DC $000
 DC $111
 DC $111
 DC $111
 DC $111
 DC $111
 DC $222
 DC $222
 DC $222
 DC $222
 DC $222
 DC $222
 DC $333
 DC $333
 DC $333
 DC $333
 DC $333
 DC $333
 DC $444
 DC $444
 DC $444
 DC $444
 DC $444
 DC $444
 DC $444
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $777
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $666
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $555
 DC $444
 DC $444
 DC $444
 DC $444
 DC $444
 DC $444
 DC $444
 DC $333
 DC $333
 DC $333
 DC $333
 DC $333
 DC $333
 DC $222
 DC $222
 DC $222
 DC $222
 DC $222
 DC $222
 DC $111
 DC $111
 DC $111
 DC $111
 DC $111
 DC $000
 DC $000
 DC $000
 DC $000
 DC $000

 DC -1
	section bss

t_points	ds.w	NB_PTS*2
	DS.B	200
modif	Ds	1
tgauch	ds.w	200
tdroit	ds.w	200
SCREEN2	DS.L	1
SCREEN1	DS.L	1
FLAG_PTS	DS.L	1
ANC_VBL	DS.L	1
CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1	
PNT_X	DS.L	1
PNT_Y	DS.L	1
PNT	DS.L	1
PNT2	DS.L	1
REG_GEN	DS.L	16
*LINE_A_EMUL

PNT_261E	DS	1
EMUL_LINEA	DS.B	100
BUF16DA	DS.B	512
BUF299A	DS.B	512

_PTSIN	DS.B	100
	
	DS.B	256
BUFFERSCR	DS.B	64000
TABLE	DS.L	360
TABLE2	DS.L	360
BUF1	DS.B	8000
BUF2	DS.B	8000
FINAL	DS.L	16
DATAS	DS.B	8000
BUFCOD	DS.B	91000
BUFCOD2	DS.B	105000
