CLIP	EQU	54
XMN_CLIP	EQU	56
YMN_CLIP	EQU	58
XMX_CLIP	EQU	60
YMX_CLIP	EQU	62

SEG=20
NB_PTS=4*SEG
PAS=3
NB_POS=(360/PAS)
;NB_POS=(20)

LARG_FONTE = 32
HAUT_FONTE = 32
	LEA	ZIK,A1
	MOVE.L	A0,CHG_RETURN
	MOVE.L	A1,MOD_ZIK
	MOVE.L	A1,MOD_ZIK2

	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	lea	ici_,a0
cont	clr.l	(a0)+
	cmp.l	#ended,a0
	ble.s	cont
	

;	MOVEQ	#1,D0
;	JSR	ZIK

;	LEA	FIN,A0
;	MOVE.L	A0,$008.W
;	MOVE.L	A0,$00C.W
;	MOVE.L	A0,$010.W
;	MOVE.L	A0,$014.W
;	MOVE.L	A0,$018.W
;	MOVE.L	A0,$01C.W
;	MOVE.L	A0,$020.W

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	MOVE.L	D0,SCREEN3
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
;	MOVE.L	D0,SCREEN_STABLE2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
;	MOVE.L	#BUF_SCR3,D0
;	CLR.B	D0
;	MOVE.L	D0,SCREEN3
;	MOVE.B	SCREEN3+1,$FFFF8201.W
;	MOVE.B	SCREEN3+2,$FFFF8203.W
	MOVE.L	#BUF1,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN_BIDON
	
	MOVE.L	#TEXT,PT_TEXT
	MOVE.W	#0,PART_FONTE
	MOVE.W	#152,PT_BUF
	MOVE.L	#FONTS+34+(160*33*4)+6*16,SOV_ADR
	MOVE.W	#4,NO_DEC
	MOVE.W	#0,PT_AFF

	CLR.W	VBL_FLAG


;	JMP	PROG
;	MOVE.W	#$2700,SR
;	CLR.B	$FFFFFA07.W
;	CLR.B	$FFFFFA09.W
	
;	CLR.B	$FFFFFA1B.W
;	BSET	#0,$FFFFFA07.W
;	BSET	#0,$FFFFFA13.W

;	BSET	#0,$FFFFFA07.W
;	BSET	#5,$FFFFFA07.W
;	BSET	#6,$FFFFFA09.W
;	MOVE.B	$FFFFFA07.W,$FFFFFA13.W
;	MOVE.B	$FFFFFA09.W,$FFFFFA15.W
;	MOVE.B	#$40,$FFFFFA17.W
;	MOVE.W	#$2300,SR

;	MOVE.W	#$2700,SR
;	MOVE.B	#1,$FFFFFA07.W
;	CLR.B	$FFFFFA09.W
;	MOVE.B	$FFFFFA07.W,$FFFFFA13.W
;	MOVE.B	$FFFFFA09.W,$FFFFFA15.W
;	JSR	ZIK
;	MOVE.W	#$2300,SR

PROG	JSR	LINE_A_INIT
	MOVE	#1,24(A0)
	CLR	26(A0)
	CLR	28(A0)
	CLR	30(A0)
	MOVE	#0,36(A0)
	MOVE.L	#FILL,46(A0)
	MOVE	#1,50(A0)
	CLR	52(A0)
	MOVE	#1,CLIP(A0)
	move	#1,XMN_CLIP(A0)
	move	#1,YMN_CLIP(A0)
	move	#319,XMX_CLIP(A0)
	move	#199,YMX_CLIP(A0)

	MOVE.L	#VBL_DEBUT,$70.W
	MOVE.L	#TB0,$120.W

;	st	$FFFF8242.W

	LEA	BUFCOD,A0
	MOVE.L	A0,SAVEA0
	LEA	TABLE,A4
	MOVE.L	A4,SAVEA4
	MOVEM.L	D0-A6,INIT
	CLR.L	POINTEUR
	MOVE	#2*30*3,x_angle
	MOVE	#2*30*3,y_angle
	MOVE	#0,z_angle
	move	#256,z_pt_fuite
	move.l	#(NB_POS),d7
ici	CLR.L	POINTEUR
	LEA	DATA_X,A1
	jsr	trigo
	ADD.L	#2,POINTEUR2
	MOVE.L	D6,-(SP)
	MOVE.L	#NB_PTS-1,D6
LAB1	jsr	sp_to_pl
	jsr	ROUTINE
	DBF	D6,LAB1
	MOVE.L	(SP)+,D6
	ADD	#2*PAS,x_angle
	ADD	#2*PAS,y_angle
;	ADD	#2,z_angle
	JSR	TST_ANG
	MOVEM.L	D0-A6,-(SP)
	MOVEM.L	INIT,D0-A6
	CLR.L	PNT
	JSR	GEN
	MOVEM.L	D0-A6,INIT
	MOVEM.L	(SP)+,D0-A6
	dbf	d7,ici

;	MOVE	#0,x_angle
;	MOVE	#0,y_angle
;	CLR.L	POINTEUR
;	LEA	DATA_X,A1
;	jsr	trigo
;	ADD.L	#2,POINTEUR2
;	MOVE.L	D6,-(SP)
;	MOVE.L	#NB_PTS-1,D6
;LAB1Z	jsr	sp_to_pl
;	jsr	ROUTINE
;	DBF	D6,LAB1Z
;	MOVE.L	(SP)+,D6
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
;	ADD	#2,z_angle
;	MOVEM.L	D0-A6,-(SP)
;	MOVEM.L	INIT,D0-A6
;	CLR.L	PNT
;	JSR	GEN
;	MOVEM.L	D0-A6,INIT
;	MOVEM.L	(SP)+,D0-A6
	JMP	TERMINATED
ZIK	MOVE	#$700,$FFFF8240.W
	RTS
TST_ANG	cmpi	#360*2,x_angle
	blT.s	roule
	clr	x_angle
	clr	y_angle
roule	rts
mainloop
GEN
	MOVE.L	D0,SAVED0
	JSR	EFF
	MOVE.L	#SEG-1,D0
LAB2	MOVE.L	D0,-(SP)
	bsr	poly
	MOVE.L	(SP)+,D0
	DBF	D0,LAB2

	MOVE	#1999,D0
	MOVE.L	SCREEN3,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KL	MOVE.L	(A1),(A2)+
	MOVE.L	(A0)+,(A1)+
	dbf	d0,KL

	JSR	GENERE1
	MOVEQ	#0,D0
	MOVEQ	#0,D3
	LEA	DATAS,A0
	LEA	FINAL,A1
	SUBQ.L	#8,A0
LOOPED	ADDQ.L	#8,A0
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

OKVAZY	
	LEA	DATAS,A0	;
	SUBQ.L	#8,A0
BOUI	ADDQ.L	#8,A0	;
	cmp.l	#DATAS+8000,A0
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
	SUBQ.L	#8,A0
	BRA.S	LOOPED
	
LP	LEA	DATAS,A0
	MOVE	#1999,D0
P	CLR.L	(A0)+
	DBF	D0,P
	JSR	GENERE2

	MOVE.L	SAVED0,D0
	RTS
GEN2
	MOVE.L	D0,SAVED0
	JSR	EFF
	CLR.L	PNT
	MOVE.L	#SEG-1,D0
LAB2B	MOVE.L	D0,-(SP)
	bsr	poly
	MOVE.L	(SP)+,D0
	DBF	D0,LAB2B

	MOVE	#1999,D0
	MOVE.L	SCREEN3,A0
	LEA	BUF2,A1
	LEA	BUF1,A2
KLD	MOVE.L	(A1),(A2)+
	MOVE.L	(A0)+,(A1)+
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
	cmp.l	#DATAS+8000,A0
	BEQ	QLP

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
	MOVE.L	SCREEN_BIDON,A0
	MOVE	#7999,D0
GAZO	CLR.L	(A0)+
	DBF	D0,GAZO

	LEA	TABLE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
	MOVE.L	SCREEN_BIDON,A0
	JSR	8*4(A1)

	LEA	TABLE+4,A1
	move.l	A1,SAVEA1
	SUBQ.L	#1,HC_FLAG
JUMP	BRA.S	JUMP

HC_ROUTY
	MOVE.L	SAVEA1,A1

	MOVE.L	(A1)+,A2
	TST.L	-4(A1)
	BNE.S	ROUL
	LEA	TABLE+4,A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	MOVE.L	SCREEN_BIDON,A0
	JSR	8*4(A2)
	MOVE.L	A1,SAVEA1
;	MOVE	#$070,$FFFF8240.W
	MOVE.L	SCREEN_BIDON,A0
	LEA	160*10(A0),A0
	MOVE.L	SCREEN2,A1
MOD_DEP	EQU	*+2
	LEA	(100-17)*160(A1),A1
;	LEA	-10*160(A1),A1
	ADDA	MOD_DEP,A0
MOD_NB_LINES	EQU	*+2
	MOVE	#0,D0
HU
N	SET	0
	REPT	10
	MOVE	N+6(A0),N+6(A1)
	MOVE	N+8(A0),N+8+6(A1)
N	SET	N+16
	ENDR
	LEA	160(A0),A0
	LEA	160(A1),A1
	DBF	D0,HU
	TST	MOD_DEP
	BEQ.S	DO_NOT
	SUB	#160,MOD_DEP
	ADDQ	#2,MOD_NB_LINES
DO_NOT	RTS
SAVEA1	DC.L	0
HC_FLAG	DC.L	1
FLAG_BIP	DC.L	0
CHG_RETURN	EQU	*+2
FIN	
	JMP	FIN

EFF	move.l	SCREEN3,a0
	MOVE	#1999,D0
HA	CLR.L	(A0)+
;	ADDQ.L	#,A0
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
MOVEL	MOVE	D2,D5
	SWAP	D5
	MOVE	D3,D5
	JSR	DO_IT
	
	BRA.S	LOOP
PLAN2_VIDE	CMPI	#0,D2
	BNE.S	MOVEL
	BRA.S	LOOP

SAME_MOT2	CMPI	#0,D2
	BNE.S	MOVE_PLAN1
CLR_PLAN1	BRA.S	LOOP
MOVE_PLAN1	BRA.S	LOOP

SAME_MOT1	CMP	D1,D3
	BEQ.S	LOOP
	CMPI	#0,D3
	BNE.S	MOVE_PLAN2
CLR_PLAN2	BRA.S	LOOP
MOVE_PLAN2	BRA	LOOP
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
			;stock� dans a4
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
			;stock� dans a4
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
			;stock� dans a4
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
			;stock� dans a4
	move.w d6,(a6)+	
	
	movem.l (a7)+,d0-d7/a4-a6
	rts

;********************************************
; calcul des coordonnees planes             *
; en entree: xe,ye,ze                       *
;            x_angle,y_angle,z_angle        *
;            z_pt_fuite z du point de fuite *
; en sortie: xp,yp coordonn�es planes       *
;            new_xe,new_ye,new_ze nouvelles *
;            coordonn�es spatiales          *
;********************************************

sp_to_pl movem.l d0-d7/a1-a6,-(a7)
MOD	EQU	*+2	
	lea 	points,a6		;a6 pointe coords
	ADDA.L	POINTEUR,A6
	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
	moveq	#0,d2
;	ADD	#20,D2
	ADD.L	#4,POINTEUR
	SUB	#160,D0
	SUB	#100,D1
	
	lea depla,a3
	adda.l	POINTEUR2,A3
	move.w (a3)+,d5	;zdep
	SUB	#100,D5

	MOVE.L	#100,D5

	lea depla2,a3
	adda.l	POINTEUR2,A3
	move.w (a3)+,d4
	NEG	D4
	ADD	#50,D4
	
	MOVEQ	#0,D4

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
			;centre � l'�cran

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
	MOVE	D0,(A1)+

	MOVE	yp,D0
	MOVE	D0,(A1)+

	RTS
NOIR	DCB	16,0
VBL_DEBUT	MOVEM.L	D0-A6,-(SP)
	CLR.B	$FFFFFA1B.W
	MOVEM.L	NOIR,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

CHG_2	EQU	*+3
	MOVE.B	#100-18,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	CMPI.B	#(99-96),CHG_2
	BNE.S	SUITE_1
	MOVE.L	#VBL_PART1,$70.W
SUITE_1	
	TST.L	HC_FLAG
	BNE.S	NO_3D_
	JSR	HC_ROUTY
	ADDQ.B	#2,CHG
	SUBQ.B	#1,CHG_2
	ADDQ	#1,CHG_3
NO_3D_
	JSR	SCROL_ROUTY
MOD_ZIK	EQU	*+2
	JSR	$12345678

	MOVEM.L	(SP)+,D0-A6
	RTE

VBL_PART1	MOVEM.L	D0-A6,-(SP)
	;ADDQ.W	#1,VBL_FLAG
	;ADDQ.L	#1,$466.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#(99-97),$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	TST.L	HC_FLAG
	BNE.S	NO_3D
	JSR	HC_ROUTY
NO_3D	JSR	SCROL_ROUTY
MOD_ZIK2	EQU	*+2
	JSR	$12345678
	MOVEM.L	(SP)+,D0-A6
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIME
	MOVE	#$700,$FFFF8240.W
NO_TIME	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

RTE	RTE

TB0
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8240.W
	MOVEM.L	D0-D3,-(SP)
	MOVEM.L	FONTS+2+2,D0-D3
	MOVEM.L	D0-D3,$FFFF8242.W
	MOVE.L	#$07770777,D0
	MOVE.L	D0,$FFFF8250.W
	MOVE.L	D0,$FFFF8254.W
	MOVE.L	D0,$FFFF8258.W
	MOVE.L	D0,$FFFF825C.W
	MOVEM.L	(SP)+,D0-D3
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB1,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB1
	CLR.B	$FFFFFA1B.W
	MOVE	#$001,$FFFF8240.W
CHG	EQU	*+3
	MOVE.B	#34,$FFFFFA21.W	;197
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB2
	CLR.B	$FFFFFA1B.W
	MOVE	#$777,$FFFF8240.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB3,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE
TB3
	CLR.B	$FFFFFA1B.W
	CLR	$FFFF8240.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB0,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TA0	RTE

SCROL_ROUTY	;CMPI.W	#1,VBL_FLAG
	;BLT.S	IT_VBL

	BSR	GEST_SCROLL
	BSR	SWAPEC
	RTS
	;CLR.W	VBL_FLAG
	;BRA	IT_VBL

GEST_SCROLL	MOVE.W	NO_DEC,D0
	JMP	ROUTS_DEC(PC,D0.W)
ROUTS_DEC	BRA	DEC_0
	BRA	DEC_1
	BRA	DEC_2
	BRA	DEC_3

GEST_AFFICH	
	MOVEQ	#0,D0
	MOVE.L	SCREEN2,A1
CHG_3	EQU	*+2
	MOVE	#100-16,D0
	MULU	#160,D0
	ADDA.L	D0,A1
;	LEA	160*(100-16)(A1),A1
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	LEA	-320(A1),A1
	MOVEM.L	D0-D7,(A1)
	MOVEM.L	D0-D7,32(A1)
	MOVEM.L	D0-D7,64(A1)
	MOVEM.L	D0-D7,96(A1)
	MOVEM.L	D0-D7,128(A1)
	LEA	160(A1),A1
	MOVEM.L	D0-D7,(A1)
	MOVEM.L	D0-D7,32(A1)
	MOVEM.L	D0-D7,64(A1)
	MOVEM.L	D0-D7,96(A1)
	MOVEM.L	D0-D7,128(A1)
	LEA	160(A1),A1

	MOVE.W	PT_AFF,D0
	JMP	ROUTS_AFF(PC,D0.W)
ROUTS_AFF	BRA	AFF_20_00
	BRA	AFF_19_01
	BRA	AFF_18_02
	BRA	AFF_17_03
	BRA	AFF_16_04
	BRA	AFF_15_05
	BRA	AFF_14_06
	BRA	AFF_13_07
	BRA	AFF_12_08
	BRA	AFF_11_09
	BRA	AFF_10_10
	BRA	AFF_09_11
	BRA	AFF_08_12
	BRA	AFF_07_13
	BRA	AFF_06_14
	BRA	AFF_05_15
	BRA	AFF_04_16
	BRA	AFF_03_17
	BRA	AFF_02_18
	BRA	AFF_01_19

DEC_0	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL,A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVE.L	(A2)+,(A3)+
	MOVE.L	(A2)+,(A3)+
	LEA	152(A2),A2
	LEA	152(A3),A3
	DBRA	D7,.RECOP_FONTE
	MOVE.W	#4,NO_DEC
	LEA	BUFFER_SCROLL,A0
	BSR	GEST_AFFICH
	MOVE.W	PT_BUF,D0
	ADDQ.W	#8,D0
	CMPI.W	#160,D0
	BLT.S	.C_EST_BON_1
	MOVEQ	#0,D0
.C_EST_BON_1	MOVE.W	D0,PT_BUF
	MOVE.W	PT_AFF,D0
	ADDQ.W	#4,D0
	CMPI.W	#80,D0
	BLT.S	.C_EST_BON_2
	MOVEQ	#0,D0
.C_EST_BON_2	MOVE.W	D0,PT_AFF
	MOVE.L	PT_TEXT,A0
	MOVE.W	PART_FONTE,D0
	ADDQ.W	#8,D0
	CMPI.W	#LARG_FONTE/2,D0
	BLT.S	.C_EST_BON_3
	MOVEQ	#0,D0
	ADDQ.W	#1,A0
	CMPI.B	#-1,10(A0)
	BNE.S	.C_EST_BON_3
	LEA	TEXT,A0
.C_EST_BON_3	MOVE.W	D0,PART_FONTE
	MOVE.L	A0,PT_TEXT
	RTS

DEC_1	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE),A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVE.L	SOV_ADR,A4
	MOVE.L	#$F000F,D5
	MOVE.L	#$FFF0FFF0,D6
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVE.L	(A4)+,D0	PLAN 1&2
	MOVE.L	(A4)+,D1	PLAN 3&4
	MOVE.L	(A2)+,D2	PLAN 1&2
	MOVE.L	(A2)+,D3	PLAN 3&4
	LSL.L	#4,D0
	LSL.L	#4,D1
	AND.L	D6,D0
	AND.L	D6,D1
	ROL.L	#4,D2
	ROL.L	#4,D3
	AND.L	D5,D2
	AND.L	D5,D3
	SWAP	D2
	SWAP	D3
	OR.L	D0,D2
	OR.L	D1,D3
	MOVE.L	D2,(A3)+
	MOVE.L	D3,(A3)+
	LEA	152(A2),A2
	LEA	152(A3),A3
	LEA	152(A4),A4
	DBRA	D7,.RECOP_FONTE
	MOVE.W	#8,NO_DEC
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE),A0
	BSR	GEST_AFFICH
	RTS

DEC_2	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*2),A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVE.L	SOV_ADR,A4
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVEP.L	1(A4),D0
	MOVEP.L	(A2),D1
	MOVEP.L	D0,(A3)
	MOVEP.L	D1,1(A3)
	LEA	160(A2),A2
	LEA	160(A3),A3
	LEA	160(A4),A4
	DBRA	D7,.RECOP_FONTE
	MOVE.W	#12,NO_DEC
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*2),A0
	BSR	GEST_AFFICH
	RTS

DEC_3	MOVE.L	PT_TEXT,A0
	LEA	CORES_FONTS,A1
	LEA	FONTS+34,A2
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*3),A3
	ADDA.W	PT_BUF,A3
	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	ADD.W	D0,D0
	ADDA.W	(A1,D0.W),A2	A2=ADRESSE DE LA FONTE
	ADD.W	PART_FONTE,A2	MOITI� GAUCHE OU DROITE:ON ADDITIONNE 8 OU 0
	MOVE.L	SOV_ADR,A4

	MOVE.L	A2,SOV_ADR	;TRES IMPORTANT

	MOVE.L	#$0FFF,D5
	MOVE.L	#$F000F000,D6
	MOVEQ	#HAUT_FONTE-1,D7
.RECOP_FONTE	MOVE.L	(A4)+,D0	PLAN 1&2
	MOVE.L	(A4)+,D1	PLAN 3&4
	MOVE.L	(A2)+,D2	PLAN 1&2
	MOVE.L	(A2)+,D3	PLAN 3&4
	ROR.L	#4,D0
	ROR.L	#4,D1
	AND.L	D6,D0
	AND.L	D6,D1
	SWAP	D0
	SWAP	D1
	LSR.L	#4,D2
	LSR.L	#4,D3
	AND.W	D5,D2
	AND.W	D5,D3
	OR.L	D0,D2
	OR.L	D1,D3
	MOVE.L	D2,(A3)+
	MOVE.L	D3,(A3)+
	LEA	152(A2),A2
	LEA	152(A3),A3
	LEA	152(A4),A4
	DBRA	D7,.RECOP_FONTE
	CLR.W	NO_DEC
	LEA	BUFFER_SCROLL+(160*HAUT_FONTE*3),A0
	BSR	GEST_AFFICH
	RTS

AFF_20_00	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D6
	MOVEM.L	D0-D6,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_20_00+2
	RTS

AFF_19_01	MOVEQ	#HAUT_FONTE-1,D7
	MOVE.L	(A0)+,152(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_19_01+2
	RTS

AFF_18_02	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,144(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_18_02+2
	RTS

AFF_17_03	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,136(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVE.L	(A0)+,132(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_17_03+2
	RTS

AFF_16_04	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,128(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_16_04+2
	RTS

AFF_15_05	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,120(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_15_05+2
	RTS

AFF_14_06	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,112(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_14_06+2
	RTS

AFF_13_07	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,104(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,148(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,88(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_13_07+2
	RTS

AFF_12_08	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,96(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,140(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	MOVE.L	(A0)+,88(A1)
	MOVE.L	(A0)+,92(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_12_08+2
	RTS

AFF_11_09	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,88(A1)
	MOVEM.L	(A0)+,D0-D6
	MOVEM.L	D0-D6,132(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_11_09+2
	RTS

AFF_10_10	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,80(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A3
	MOVEM.L	D0-D6/A2-A3,124(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A3
	MOVEM.L	D0-D6/A2-A3,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_10_10+2
	RTS

AFF_09_11	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,72(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,116(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D6
	MOVEM.L	D0-D6,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_09_11+2
	RTS

AFF_08_12	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,64(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,108(A1)
	MOVE.L	(A0)+,152(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_08_12+2
	RTS

AFF_07_13	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,56(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,100(A1)
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,144(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_07_13+2
	RTS

AFF_06_14	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,48(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,92(A1)
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,136(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,(A1)
	MOVE.L	(A0)+,44(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_06_14+2
	RTS

AFF_05_15	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,40(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,84(A1)
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,128(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_05_15+2
	RTS

AFF_04_16	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,32(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,76(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A4
	MOVEM.L	D0-D6/A2-A4,120(A1)
	MOVEM.L	(A0)+,D0-D6/A2
	MOVEM.L	D0-D6/A2,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_04_16+2
	RTS

AFF_03_17	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,24(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,68(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,112(A1)
	MOVE.L	(A0)+,156(A1)
	MOVEM.L	(A0)+,D0-D5
	MOVEM.L	D0-D5,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_03_17+2
	RTS

AFF_02_18	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,16(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,60(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,104(A1)
	MOVEM.L	(A0)+,D0-D2
	MOVEM.L	D0-D2,148(A1)
	MOVEM.L	(A0)+,D0-D3
	MOVEM.L	D0-D3,(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_02_18+2
	RTS

AFF_01_19	MOVEQ	#HAUT_FONTE-1,D7
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,8(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,52(A1)
	MOVEM.L	(A0)+,D0-D6/A2-A5
	MOVEM.L	D0-D6/A2-A5,96(A1)
	MOVEM.L	(A0)+,D0-D4
	MOVEM.L	D0-D4,140(A1)
	MOVE.L	(A0)+,(A1)
	MOVE.L	(A0)+,4(A1)
	LEA	160(A1),A1
	DBRA	D7,AFF_01_19+2
	RTS
SWAPEC	
	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	CMPI.B	#$1,$FFFFFC02.W
	BNE.S	GO_GO
	MOVE.B	SCREEN3+1,$FFFF8201.W
	MOVE.B	SCREEN3+2,$FFFF8203.W
	RTS
GO_GO	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
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
LOOP1	MOVE	D3,40(A0)
	MOVE.L	A0,-(SP)
;	DC	POLYGON
	TST	d3
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
	MULS.W	#(160/4),D1

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
LFD1B58
	MOVEA.L	SCREEN3,A1
	MULS.W	#(160/4),D5
	
	ADDA.L	D5,A1
	MOVEA.W	D0,A2

;	MOVE.W	#1,D7
	MOVEQ	#2,D0
;	MOVE.W	D7,D0
;	ADD.W	D0,D0
;	MULS.W	D0,D1
	LSL	#1,D1

	ADDA.L	D1,A1

	MOVEQ	#0,D7

	LEA	$18(A4),A3
	;MOVE.W	$24(A4),D1
	;ADD.W	D1,D1
TST	;LEA	_FD1B86(PC,D1.W),A5
	;ADDA.W	(A5),A5
;	JMP	(A5)
;	JMP	LFD1C52


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
;	ADDQ.L	#8,A1
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
LFD1C7E	;DBF	D7,LFD1C56
	NOT.W	D4
	NOT.W	D6
	RTS
LFD1C88	
	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D4,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A1)+

;	ADDQ.L	#8,A1
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
LFD1CAE	;DBF	D7,LFD1C56
	NOT.W	D4
	NOT.W	D6
	RTS
_FD1B86	DC.L	$00CC0130
	DC.L	$009C014A
	DC.L	$4E56FFEC

	DATA
;ZIK	INCBIN	LEVEL1A.MUS
;	EVEN
FONTS	INCBIN	FNT.PI1
	EVEN
CORES_FONTS	
N	SET	0
N2	SET	160*(HAUT_FONTE+1)
N3	SET	160*(HAUT_FONTE+1)*2
N4	SET	160*(HAUT_FONTE+1)*3
N5	SET	160*(HAUT_FONTE+1)*4
	DC	N5+6*16	ESP
	DC	N5+6*16	!
	DC	N5+4*16	"
	DC	N5+6*16	#
	DC	N5+6*16	$
	DC	N5+6*16	%
	DC	N5+6*16	&
	DC	N5+3*16	'
	DC	N3+160-32	(
	DC	N3+160-16	)
	DC	N5+6*16	*
	DC	N5+6*16	+
	DC	N5+2*16	,
	DC	N5	-
	DC	N3+160-16*4	.
	DC	N5+6*16	/
NN	SET	0
	REPT	10
	DC	N4+NN
NN	SET	NN+16
	ENDR
	DC	N3+160-16*3	:
	DC	N5+160*5	;
	DC	N5+6*16	<
	DC	N5+6*16	=
	DC	N5+6*16	>
	DC	N5+6*16	?
	DC	N5+6*16	

	DC.W	N,N+16,N+32,N+48,N+64,N+80,N+96,N+112,N+128,N+144
	DC.W	N2,N2+16,N2+32,N2+48,N2+64,N2+80,N2+96,N2+112,N2+128,N2+144
	DC.W	N3,N3+16,N3+32,N3+48,N3+64,N3+80

TEXT
 DC.B " THIS WAS -HOLOCAUST- AGAIN, ON THE ROAD TO THE ULTIMATE RULE...   "
 DC.B "  YES, THIS IS NEARLY THE END.   THIS SCREEN WAS NOT REALLY IMPRESSIVE, ANYWAY.  "
 DC.B "    BUT DON'T FORGET IT WAS CODED IN -ONE- DAY...  ( I ALREADY HAD THE GFXS, I ADMIT. )      "
 DC.B "   WELL.   I'M SURE YOU WANT A FINAL AND NICE PART... "
 DC.B "   OKAY...   LET'S HAVE...    TRIDIMENSIONAL PLANE VECTORS...    "
 DC.B "   YEEEEAAAAAAAH!    -THIS- IS NICE, I THINK..    AND IT CLOSES THIS LITTLE DEMO.           "
 DC.B "   HERE COMES A FINAL GREETINGS LIST:                       "
 	DC.B	"  LEGACY - OVERLANDERS - ST CNX - NAOS -"
	DC.B	" VEGETABLES - MCODER - PULSION - ULM -"
	dc.b	" TEX - SILVERS - DELTA FORCE -"
	dc.b	" THE CAREBEARS - THE LOST BOYS -"
	DC.B	" FIREHAWKS - ZUUL - ACF - MYSTICS - HMD -"
	DC.B	" NPG - PRISM - INNER CIRCLE - AWG -"
	DC.B	" PHALANX - THALION - BLACK CATS - SYNC -"
	DC.B	" EQUINOX - CHAOS - UNDEAD - RESPECTABLES -"
	DC.B	" REPLICANTS - MJJ PROD - ART OF CODE - "
 DC.B "OXGENE - WILL - MAJOR FATAL - MARCO POLO - MEGA ONE - ODC - JEDI - DARKNESS - AMAURY AND CO -"
 DC.B " R-BOY - KHELT - BRAIN - CREATEUR - VMAX - ZARATHUSTRA - WALTER - SKAVEN - KILROY - NULLOS - OYA SHIVO - "
 DC.B "JOKER - SLIDE NEUROX - CHAMALOW - ZOCH - CORPO - AL - BOULDOG - SAMOS - IKI - KILLER D - TOUBAB - VULPES - SCARECROW - PANZERBOY - IO - ACCS - NCC - AND ALL PRINCES OF CHAOS AND AMBER...       "
	DC.B	"                    "
	DC.B	"                    ",-1
	EVEN
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

cos_tab	incbin '\COSIN.DAT'
sin_tab	equ cos_tab+720

points
 DC 168,76
 DC 168,124
 DC 184,124
 DC 184,76
 DC 176,68
 DC 176,84
 DC 200,84
 DC 200,68
 DC 176,116
 DC 176,132
 DC 200,132
 DC 200,116
 DC 176,68
 DC 168,76
 DC 176,84
 DC 184,76
 DC 168,124
 DC 176,132
 DC 184,124
 DC 176,116
 DC 144,68
 DC 144,132
 DC 160,132
 DC 160,68
 DC 112,68
 DC 112,132
 DC 128,132
 DC 128,68
 DC 120,92
 DC 120,108
 DC 152,108
 DC 152,92
 DC 208,68
 DC 208,76
 DC 256,76
 DC 256,68
 DC 208,80
 DC 208,88
 DC 248,88
 DC 248,80
 DC 208,92
 DC 208,100
 DC 240,100
 DC 240,92
 DC 208,104
 DC 208,112
 DC 232,112
 DC 232,104
 DC 208,116
 DC 208,124
 DC 224,124
 DC 224,116
 DC 208,128
 DC 208,136
 DC 216,136
 DC 216,128
 DC 104,68
 DC 56,68
 DC 56,76
 DC 104,76
 DC 104,80
 DC 64,80
 DC 64,88
 DC 104,88
 DC 104,92
 DC 72,92
 DC 72,100
 DC 104,100
 DC 104,104
 DC 80,104
 DC 80,112
 DC 104,112
 DC 104,116
 DC 88,116
 DC 88,124
 DC 104,124
 DC 104,128
 DC 96,128
 DC 96,136
 DC 104,136
 DC 0,0


depla		
	dc	255
depla2
	dc	0
	
	SECTION	BSS
ici_
	DS.B	256+10000
BUFFER	DS.L	16000
	DS.B	256+10000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
SCREEN3	DS.L	1
SCREEN_BIDON	DS.L	1
VBL_FLAG	DS.W	1
BUFFER_SCROLL	DS.L	40*HAUT_FONTE*4
PT_TEXT	DS.L	1
PT_BUF	DS.W	1
SOV_ADR	DS.L	1
NO_DEC	DS.W	1
PT_AFF	DS.W	1
PART_FONTE	DS.W	1
TABLE	DS.L	190
*******
xe	ds.w 1
ye	ds.w 1
ze	ds.w 1
xdep	ds.w 1
ydep	ds.w 1
zdep	ds.w 1
xp	ds.w 1
yp	ds.w 1
new_xe	ds.w 1
new_ye	ds.w 1
new_ze	ds.w 1
x_angle	ds.w 1
y_angle	ds.w 1
z_angle	ds.w 1	
z_pt_fuite	ds.w 1
var_3d	ds.w 9
POINTEUR	DS.L	1
POINTEUR2	DS.L	1
DATA_X
	DS	NB_PTS*2
	ds	1

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
;	DS.B	256
;BUF_SCR3	DS.B	32000
_PTSIN	DS.B	100
	DS.B	256
BUF1	DS.B	8000
BUF2	DS.B	8000
DATAS	DS.B	8000
	DS.B	8000
FINAL	DS.L	16
INIT	DS.L	16	

BUFCOD	;DS.B	395000
	DS.B	290000
ended
