
;04/02/90 - Paradox Scroller - Dan Nato/Holocaust
; Recoded Version: 10/12/91 - Zappy/Holocaust - Flexi Killer Scroller

	OPT	D+
	OPT	O+
;	OPT	P+
NB_STARS	EQU	250
VITESSE	EQU	10
X_CENTER	EQU	160
Y_CENTER	EQU	100

ptsin	equ 12		;.l
contrl	equ 4		;.l
x1	equ 38		;.w
y1	equ 40
x2	equ 42
y2	equ 44
bp1	equ 24		;.w
bp2	equ 26
bp3	equ 28
bp4	equ 30
wrt_mod	equ 36		;.w
patt	equ 46		;.l

pmsk	equ 50		;.w

clip	equ 54		;.w

xmn_c	equ 56		;.w
xmx_c	equ 60
ymn_c	equ 58
ymx_c	equ 62
ln_msk	equ 34		;.w
lstlin	equ 32		;.w

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

	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP

	MOVE.L  #CAMEO,A0
	MOVE.L  #CAMEO_END,A1
	JSR decrunch 
	MOVE.L	#1,MUS

	moveq	#1,d0
	jsr	ZIK

	MOVE.L	#BUFFERSCR,D0
	clr.b	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#150*256,D0
	MOVE.L	D0,SCREEN2

	BSR	PRP_CRB
	BSR	PRP_LET
	MOVE.L	#BUF2CRB,BUF_ACT_CRB
	MOVE.L	#BUF1CRB,ANNEX
	MOVE.W	#64*160,ADDIT
	MOVE.L	#CRB_REBOND,PNT_REBOND
	LEA	CRB_REBOND,A0
	LEA	320(A0),A1
	MOVE.L	-4(A1),-4(A0)

	BSR	PRP_CRB2
	BSR	PRP_FONT
	BSR	PRP_TEXT
	MOVE.L	#BUF_TEXT,PNT_TXT
	CLR	PNT1

	move.l	#FIN,$8.w
	move.l	#FIN,$c.w
	move.l	#FIN,$10.w
	move.l	#FIN,$14.w
	
	CLR.L	PNT_FAD
	CLR.L	PNT_FAD2
	move #$2300,sr

	move #2,-(sp)
	trap #14
	addq #2,sp
	move.l d0,ecran_gem

	move #4,-(sp)
	trap #14
	addq #2,sp
	move d0,res_save

	CLR	-(sp)
	moveq #-1,d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp

	move.l	SCREEN1,d0
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	
	move.l	SCREEN2,$44e.w

	move #$2700,sr
	move.l $70.w,vbl_save
	move.l $120.w,tb_save

	movem.l $ffff8240.w,d0-d7
	movem.l d0-d7,pal_save

	JSR	TOUT_NOIR

	MOVEA.L	SCREEN1,A1
	LEA	CAMEO_END+34,A0
	MOVE.L	#7999,D0
COPY	MOVE.L	(A0)+,(A1)+
	DBF	D0,COPY

	lea $fffffa07.w,a0
	movep.w (a0),d0
	move d0,mfp_save
	moveq #0,d0

	move.l usp,a6
	move.l a6,uusp

	MOVE.L	$114.W,SAUVE_114
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	MOVE.B	$FFFFFA0D.W,MFP7
	MOVE.B	$FFFFFA15.W,MFP8
	MOVE.B	$FFFFFA1D.W,MFP9
	
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	bsr demo
EFF_ECRS
	MOVE	#19199,D7
	MOVEA.L	SCREEN1,A6
EFF	CLR.L	(A6)+
	DBF	D7,EFF
	RTS
TOUT_NOIR
	CLR.L	$FFFF8240.W
	CLR.L	$FFFF8244.W
	CLR.L	$FFFF8248.W
	CLR.L	$FFFF824C.W
	CLR.L	$FFFF8250.W
	CLR.L	$FFFF8254.W
	CLR.L	$FFFF8258.W
	CLR.L	$FFFF825C.W
	RTS
FIN:
	move #$2700,sr
	MOVE.B	#8,$FFFFFC02.W

	MOVE.L	SAUVE_114,$114.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	MOVE.B	MFP7,$FFFFFA0D.W
	MOVE.B	MFP8,$FFFFFA15.W
	MOVE.B	MFP9,$FFFFFA1D.W

	move.l uusp,a6
	move.l a6,usp
	movem.l pal_save,d0-d7
	movem.l d0-d7,$ffff8240.w
	move.l vbl_save,$70.w
	move.l tb_save,$120.w
	lea $fffffa07.w,a0
	move mfp_save,d0
	movep.w d0,(a0)

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	move #$2300,sr

	move res_save,-(sp)
	move.l ecran_gem,d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp

	move.l SAUV_SP,-(sp)
	move #$20,-(sp)
	trap #1
	addq #6,sp

	clr -(sp)
	trap #1
	rts

VBL_STAR
	
	CLR.B	$FFFFFA1B.W
;	MOVE.L	#tb,$120.W
;	MOVE.B	#78,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	MOVEM.L	D0-D7/A0-6,-(SP)

	move #1,vbl_sync
	CMPI.L	#0,FLAG
	BEQ	NO_STAR

	SF	$FFFF8240.W
	MOVE	#$333,$FFFF8242.W
	MOVE	#$777,$FFFF8244.W
	MOVE	#$111,$FFFF8248.W
	MOVE.L	#$07770777,$FFFF8250.W
	MOVE.L	#$07770777,$FFFF8254.W
	MOVE.L	#$07770777,$FFFF8258.W
	MOVE.L	#$07770777,$FFFF825C.W

	CMPI.B	#$3B,$FFFFFC02.W
	BEQ.S	J
	CLR.L	FLAG2
;	MOVE	#$070,$FFFF8240.W
J
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NON2
	CMPI.L	#0,FLAG2
	BNE.S	NON2

	ADDQ.L	#1,MUS
	MOVE.L	MUS,D0
	JSR	MUSIX
;	bra.s	NON2
NON	MOVE.L	#1,FLAG2
NON2	JSR	MUSIX+4

	MOVE.L	SCREEN2,A0
	MOVE.L	PNT_STR,A1
	LEA	-NB_STARS*6*2(A1),A1
	MOVEQ	#0,D0
	ADDQ.W	#4,A1
	REPT	NB_STARS
	MOVE.W	(A1),D1
	MOVE.L	D0,(A0,D1.W)
	ADDQ.W	#6,A1
	ENDR

	MOVE.L	SCREEN2,A0
	MOVE.L	PNT_STR,A1
	REPT	NB_STARS
	MOVE.L	(A1)+,D0
	MOVE.W	(A1)+,D1
	OR.L	D0,(A0,D1.W)
	ENDR

	ADDI.L	#NB_STARS*6,PNT_STR
	MOVE.L	PNT_STR,A0
	CMPI.L	#-1,(A0)
	BNE.S	SUIT
	MOVE.L	#BUF_STAR,PNT_STR
NO_STAR
SUIT	

SWAP
	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2

	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	MOVEM.L	(SP)+,D0-D7/A0-A6

	cmp.b #$39,$fffffc02.w
	beq	FIN

	rte

VBL_WATER
	CLR.B	$FFFFFA1B.W
;	MOVE.L	#tb_FLEXI,$120.W
;	MOVE.B	#73,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	MOVE	#$001,$FFFF8240.W
	MOVE	#$005,$FFFF8248.W
	MOVEM.L	D0-D7/A0-6,-(SP)

	move #1,vbl_sync

	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2

	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	JSR	ZIK+8

	MOVEM.L	(SP)+,D0-D7/A0-A6

	cmp.b #$1,$fffffc02.w
	beq	FIN

	rTE

VBL_WATER2
	CLR.B	$FFFFFA1B.W

	MOVEM.L	D0-D7/A0-6,-(SP)

	move #1,vbl_sync

	move.l	SCREEN1,d0

	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	JSR	ZIK+8

	MOVEA.L	SCREEN1,A0
	LEA	160*70(A0),A0
	LEA	f01+34,A1
	ADDA.L	PNT_W3,A1
	MOVE	#38,D0
AFF_C	MOVE	#39,D1
AFF_L	MOVE.L	(A1)+,(A0)+
	DBF	D1,AFF_L
	DBF	D0,AFF_C
	LEA	PAL_WATER,A0
	ADDA.L	PNT_W,A0
	CMPI.L	#-1,(A0)
	BEQ.S	OK
	MOVE	(A0),$FFFF8242.W
	ADDQ.L	#1,PNT_W2
	CMPI.L	#2,PNT_W2
	BNE.S	OK2
	CLR.L	PNT_W2
	ADDQ.L	#2,PNT_W
	BRA.S	OK2
OK	CMPI.L	#160*39*2,PNT_W3
	BEQ.S	OK3
	ADD.L	#160*39,PNT_W3
	CLR.L	PNT_W
	CLR.L	PNT_W2
	BRA.S	OK2
OK3	MOVE.L	#1,WAT	
OK2	
	MOVEM.L	(SP)+,D0-D7/A0-A6

	cmp.b #$1,$fffffc02.w
	beq	FIN

	rTE

VBL_FLEXI	
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb_FLEXI,$120.W
	MOVE.B	#73,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	MOVE.L	#$00000600,$FFFF8240.W
	MOVE.L	#$04000300,$FFFF8244.W

	move	#$600,$ffff824a.w
	move	#$400,$ffff824c.w
	move	#$300,$ffff824e.w

	MOVEM.L	D0-D7/A0-6,-(SP)

	move	COLOR_FLEXI,$ffff8248.w

	move #1,vbl_sync

	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2

	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	JSR	ZIK+8

SUITV0	MOVE.L	SCREEN2,A0
;	LEA	160*64(A0),A0
	MOVEQ	#0,D0
	JSR	EFFAC_1

	MOVE.L	SCREEN2,D7
;	ADDI.L	#160*64,D7
	LEA	BUF1CRB2,A2
	MOVE.L	PNT_TXT,A3
	MOVE.L	(A3)+,A4
	ADDA.W	PNT1,A4
	MOVE.L	(A4),A4
	JSR	(A4)
	REPT	10
	MOVE.L	(A3)+,A4
	MOVE.L	(A4),A4
	JSR	(A4)
	ENDR

	ADDQ.W	#4,PNT1
	CMPI.W	#32,PNT1
	BNE.S	SUITP
	CLR.W	PNT1
	ADDQ.L	#4,PNT_TXT
SUITP	MOVE.L	PNT_TXT,A0
	CMPI.L	#-1,44(A0)
	BNE.S	SUIT2
	MOVE.L	#BUF_TEXT,PNT_TXT
SUIT2	
	MOVEM.L	(SP)+,D0-D7/A0-A6

	cmp.b #$1,$fffffc02.w
	beq	FIN

RTE	rte

it_vbl:	
	MOVE	#$2300,SR
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb,$120.W

	MOVE.B	#78,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	MOVEM.L	D0-D7/A0-6,-(SP)

	lea	pal,a0
	adda.l	pntcolor,a0
	cmpi	#$ffff,(a0)
	bne.s	it_is_okay
	lea	pal,a0
	clr.l	pntcolor
it_is_okay	

	MOVE	(A0),COLOR
	addq.l	#2,pntcolor

	MOVE.L	#$00000103,$FFFF8240.W
	MOVE.L	#$02140325,$FFFF8244.W
	MOVE.W	(A0),$FFFF8248.W
	MOVE.W	#$103,$FFFF824A.W
	MOVE.L	#$02140325,$FFFF824C.W

	move #1,vbl_sync

	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2

	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	MOVE.L	PNT_REBOND,A1
	SUBQ.L	#4,A1
	MOVE.L	SCREEN2,A0
	ADDA.W	(A1)+,A0
	LEA	48(A0),A0
	MOVEQ	#0,D0
	JSR	EFFAC
	MOVE.L	PNT_REBOND,A0
	MOVE.W	(A0),D7
	ADDI.W	#48,D7
	LEA	TABLE,A5
	MOVE.L	BUF_ACT_CRB,A2
	ADDA.W	ADDIT,A2

	REPT	9
	MOVE.L	(A5)+,A4
	JSR	(A4)
	ENDR

	MOVE.L	BUF_ACT_CRB,D0
	MOVE.L	ANNEX,BUF_ACT_CRB
	MOVE.L	D0,ANNEX

	SUBI.W	#64,ADDIT
	CMPI.W	#-64,ADDIT
	BNE.S	SUITZ
	MOVE.W	#64*159,ADDIT
SUITZ	ADDQ.L	#2,PNT_REBOND
	MOVE.L	PNT_REBOND,A0
	CMPI.W	#-1,(A0)
	BNE.S	SUIT2Z
	MOVE.L	#CRB_REBOND,PNT_REBOND
SUIT2Z
	JSR	ZIK+8

	movea.l	SCREEN2,A0
	LEA	32000(A0),A0
	movea.l	SCREEN2,A1
	LEA	32000(A1),A1

N	SET	0
N2	SET	0
	REPT	40
	MOVEM.L	N(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N2(A1)

	MOVEM.L	52+N(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,52+N2(A1)

	MOVEM.L	52*2+N(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,52*2+N2(A1)

	MOVE.L	52*3+N(A0),D0
	MOVE.L	D0,52*3+N2(A1)

N	SET	N-320
N2	SET	N2+160
	ENDR

	MOVEM.L	(SP)+,D0-D7/A0-A6
	cmp.b #$1,$fffffc02.w
	beq	FIN
	rte

it_vbl2	move.l	#RTE,$120.w
	MOVEM.L	D0-D7/A0-6,-(SP)
	move #1,vbl_sync

	LEA	FADING,A0
	ADDA.L	PNT_FAD,A0
	MOVEM.L	(A0),D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	CMPI.L	#20*2*16,PNT_FAD
	BGE.S	LA_BAS2

	CMPI.L	#2*2,PNT_FAD2
	BLE.S	LA_BAS
	CLR.L	PNT_FAD2
	ADD.L	#2*16,PNT_FAD
LA_BAS	ADDQ.L	#2,PNT_FAD2
LA_BAS2
	JSR	ZIK+8

	MOVEM.L	(SP)+,D0-D7/A0-A6
	cmp.b #$1,$fffffc02.w
	beq	FIN

	rte
	
VBL_EFF_CAMEO	move.l	#RTE,$120.w
	MOVEM.L	D0-D7/A0-6,-(SP)
	move #1,vbl_sync
	MOVE	#140,D0
	MOVE.L	SCREEN1,A0
	LEA	198*160+40(A0),A0
	
	MOVE.L	SCREEN1,A1
	LEA	199*160+40(A1),A1
	
EFF_CAM	MOVEM.L	(A0),D1-D7/A2-A6
	MOVEM.L	D1-D7/A2-A6,(A1)

	MOVEM.L	12*4(A0),D1-D7/A2-A6
	MOVEM.L	D1-D7/A2-A6,12*4(A1)
	LEA	-160(A0),A0
	LEA	-160(A1),A1
	DBF	D0,EFF_CAM
	
	ADDQ.L	#1,FLAG_CAMEO2
	CMPI.L	#140,FLAG_CAMEO2
	BNE.S	PAS_ENCORE
	MOVE.L	#1,FLAG_CAMEO
PAS_ENCORE	JSR	ZIK+8

	MOVEM.L	(SP)+,D0-D7/A0-A6
	cmp.b #$1,$fffffc02.w
	beq	FIN
	rte

IT_VBL4	SF	$FFFF8240.W
	MOVEM.L	D0-D7/A0-6,-(SP)
	JSR	ZIK+8
	MOVEM.L	(SP)+,D0-D7/A0-A6

	cmp.b #$1,$fffffc02.w
	beq	FIN
	rte

tb	MOVE	#$111,$FFFF8248.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb20,$120.W
	MOVE.B	#8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE

tb20	MOVE	#$222,$FFFF8248.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb21,$120.W
	MOVE.B	#9,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
tb21	MOVE	#$333,$FFFF8248.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb22,$120.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
tb22	MOVE	#$444,$FFFF8248.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb23,$120.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
tb23	MOVE	#$555,$FFFF8248.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb24,$120.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
tb24	MOVE	#$666,$FFFF8248.W
	move	#$777,$ffff824a.w
	move	#$777,$ffff824c.w
	move	#$777,$ffff824e.w

	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb5,$120.W
	MOVE.B	#10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE

tb5
;	move	COLOR,$ffff824a.w
;	move	COLOR,$ffff824c.w
;	move	COLOR,$ffff824e.w

;	MOVE	#$001,$FFFF8240.W
	MOVE	#$777,$FFFF8248.W

	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb2,$120.W
	MOVE.B	#199-78-10-10-10-10-9-8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	BCLR	#0,$FFFFFA0F.W
	RTE			

tb2
	DCB	127,$4E71
	CLR.B	$FFFF820A.W
	DCB	8,$4E71
	MOVE.B	#2,$FFFF820A.W
	MOVE	#$001,$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE			

tb_FLEXI	;MOVE	#$111,$FFFF8240.W
	move	COLOR_FLEXI,$ffff824a.w
	move	COLOR_FLEXI,$ffff824c.w
	move	COLOR_FLEXI,$ffff824e.w

	CLR.B	$FFFFFA1B.W
;	MOVE.L	#tb20,$120.W
;	MOVE.B	#8,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
COLOR_FLEXI	DS	1
demo:
	move.l SCREEN2,ad_ecran
	addq.l	#4,ad_ecran

	LEA	EMUL_LINEA,A0
	MOVE.L	A0,D0
		
	move.l a0,lineA_tab

	move.l #pattern,patt(a0)
	move #0,pmsk(a0)
	move #0,wrt_mod(a0)
	move #-1,bp1(a0)
	move #0,bp2(a0)
	move #0,bp3(a0)
	move #0,bp4(a0)

	move.l #it_vbl2,$70.w
	move #$2300,sr

	bsr text_convert
	
	lea text_buffer_end,a0
	lea text,a1
	lea font,a2
	moveq #0,d0
	move d0,d1
	move #30-1,d7		;30*5=150
text_lp:
	move.b (a1)+,d0
	move.b 3(a2,d0.w),-(a0)
	move.b 2(a2,d0.w),-(a0)
	move.b 1(a2,d0.w),-(a0)
	move.b 0(a2,d0.w),-(a0)
	move.b d1,-(a0)
	dbra d7,text_lp
	move.l a1,text_pt

	move.l #data_ads,ad_data_pt
	lea compteurs,a3
	MOVE	#127,COLONNE
	MOVE.L	#4,PLAN
	bsr construction
	
	lea ad_routines,a0
	move.l 16(a0),a2	;routine d'effa‡age
	move #-4,(a3)		;images
	move #-20,2(a3)	;compteur pour le scroll du buffer de texte 

	lea text_buffer_deb,a5
	move.l a5,text_buff_pt

	MOVE.L	#VBL_EFF_CAMEO,$70.W
WAIT_EFF	CMPI.L	#0,FLAG_CAMEO
	BEQ.S	WAIT_EFF

	MOVEM.L	D0-A6,SAVE_ALL
	JSR	EFF_ECRS
	MOVEM.L	SAVE_ALL,D0-A6
	move.l #it_vbl,$70.w

demo_lp:
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4
	move.l text_buff_pt,a5
	move.l SCREEN1,a6
;	lea	4(a6),a6
	ADDA.L	PLAN,A6
	bsr vsync

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICA

	move #$200,$ffff8240.w
HICA
	jsr (a2)
	move.l (a0)+,a1
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HIC
	move #$100,$ffff8240.w
HIC
	jsr (a1)

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICq
	move #$007,$ffff8240.w
HICq

;	clr	$ffff8240.w
	
	addQ #1,(a3)
	bne.S demo_lp

	move #-4,(a3)
	lea ad_routines,a0
	sub.l d1,text_buff_pt
	
	addQ #1,2(a3)
	bne.S demo_lp
	
	move #-20,2(a3)
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	movem.l 70(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,90(a5)
	movem.l 30(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,50(a5)
	movem.l -10(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,10(a5)
	movem.w -20(a5),d0-d4
	movem.w d0-d4,(a5)
	
	move.l text_pt,a1
	lea font,a6
	moveq #0,d0
	move d0,d1
	move #4-1,d7		;4*5=20
text_lp2:
	move.b (a1)+,d0
	cmp #255,d0
	bne	forme_change_pas

	addQ.l #4,ad_data_pt
	cmp.b #255,(a1)
	bne.s forme_suivante
	lea text,a1
	move.l #data_ads,ad_data_pt
forme_suivante:
	MOVE.L	#IT_VBL4,$70.W
	CMPI.L	#0,NUMBER_WAVE
	BNE.S	NOT_FIRST
	movem.l	d7/a6,-(sp)
	JSR	EFF_ECRS
	movem.l	(sp)+,d7/a6
NOT_FIRST	MOVE.L	#VBL_FLEXI,$70.W
	ADDQ.L	#1,NUMBER_WAVE
	CMPI.L	#3,NUMBER_WAVE	3!
	BNE.S	PAS_WATER

	MOVE	#31,COLONNE
	MOVE.L	#4,PLAN
	MOVE.L	#IT_VBL4,$70.W
	movem.l	D0-a6,-(sp)
	JSR	EFF_ECRS
	LEA	WATER,A0
	LEA	f01,a1
	JSR	decrunch
	movem.l	(sp)+,d0-a6
PAS_WATER	CMPI.L	#4,NUMBER_WAVE	3!
	BNE.S	PAS_STAR

	MOVE	#31,COLONNE
	MOVE.L	#6,PLAN
	MOVE.L	#VBL_STAR,$70.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

PAS_STAR
	JSR	TOUT_NOIR
	CLR	COLOR_FLEXI
	bsr construction
	MOVE	#$777,COLOR_FLEXI
	CMPI.L	#3,NUMBER_WAVE	3!
	BNE.S	PAS_WATER_

	MOVE.L	#VBL_WATER2,$70.W
WAI	CMPI.L	#0,WAT
	BEQ.S	WAI
	MOVE.L	#IT_VBL4,$70.W
	movem.l	d7/a6,-(sp)
	JSR	EFF_ECRS
	movem.l	(sp)+,d7/a6
	MOVE.L	#VBL_WATER,$70.W
	CLR.L	FLAG
PAS_WATER_	
	CMPI.L	#4,NUMBER_WAVE	3!
	BNE.S	PAS_STAR_
	MOVEM.L	D0-A6,-(SP)
	BSR	CALCULE
	MOVEQ	#1,D0
	JSR	MUSIX+8
	MOVEQ.L	#$24,D0
	JSR	MUSIX

	BCLR	#5,$FFFFFA11.W
	BCLR	#3,$FFFFFA17.W

	MOVEM.L	(SP)+,D0-A6
	MOVE.L	#1,FLAG
PAS_STAR_	
	move.b (a1)+,d0
	lea ad_routines,a0
	move.l 16(a0),a2	;routine d'effa‡age
	
forme_change_pas:
	move.b 3(a6,d0.w),-(a5)
	move.b 2(a6,d0.w),-(a5)
	move.b 1(a6,d0.w),-(a5)
	move.b 0(a6,d0.w),-(a5)
	move.b d1,-(a5)
	dbra d7,text_lp2
	move.l a1,text_pt
	bra demo_lp
	
	rts
	
text_convert:
	lea text,a0
	moveq #-1,d1
convert_lp:
	moveq #0,d0
	move.b (a0),d0
	cmp.b d1,d0
	bne.S convert_suite
	cmp.b #255,1(a0)
	beq.S convert_fin
	addq #1,a0
	bra.s convert_lp
convert_suite:
	cmp.b #$20,d0
	blo.s int2_conv
	cmp.b #$21,d0
	bhi.s int2_conv
	sub #$20,d0
	bra.S next_octet
int2_conv:
	cmp.b #$41,d0
	blo.s int3_conv
	cmp.b #$5a,d0
	bhi.s int3_conv
	sub #$3f,d0
	bra.S next_octet
int3_conv:
	cmp.b #$30,d0
	blo.s int4_conv
	cmp.b #$39,d0
	bhi.s int4_conv
	sub #$14,d0
	bra.S next_octet
int4_conv:
	cmp.b #$27,d0
	blo.s int5_conv
	cmp.b #$29,d0
	bhi.s int5_conv
	addQ #$2,d0
	bra.S next_octet
int5_conv:
	cmp.b #$2e,d0
	bne.s int6_conv
	subQ #$8,d0
	bra.S next_octet
int6_conv:
	cmp.b #$3a,d0
	bne.s int7_conv
	sub #$13,d0
	bra.S next_octet
int7_conv:
	cmp.b #$2c,d0
	bne.s int8_conv
	subQ #$4,d0
next_octet:
	lsl #2,d0
	move.b d0,(a0)+
	bra.S convert_lp
convert_fin:
	rts
int8_conv:
	jmp	FIN

vsync:
	move #0,vbl_sync
sync_wait:
	tst vbl_sync
	beq.s sync_wait

	rts
sort_demo:
	addq #4,sp
	rts 

construction:
	movem.l a0-a6/d1/d7,-(sp)
	
	lea off_bolean,a6		;effa‡age des bits
	move #125-1,d7		;500 octets
	moveq #0,d6
off_bol_lp:
	move.l d6,(a6)+
	dbra d7,off_bol_lp

	move.l #ad_routines,routs_pt
	lea	PtsFill,a3		;tableau ptsin
	move.l a3,usp
	move.l ad_data_pt,a4
	move.l (a4),a4		;coord des points
	move.l lineA_tab,a6
	lea routines,a5

	move #4-1,d7		;4 pas
pas_lp:
	move d7,-(sp)
	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move COLONNE,d7		;128 colonnes
col_lp:

	move #$1e1d,(a5)+		;move.b (a5)+,d7
	move #5-1,d6		;5 lignes
ligne_lp:

	move.b d6,d5		;pour obtenir code du btst
	add.b d5,d5
	addq.b #1,d5
	move.b d5,(a5)+
	move.b #7,(a5)+		;btst.l d4/3/2/1/0,d7
	move.l a5,-(sp)
	move #$6700,(a5)+		;beq.s (offset … d‚finir)

	move.l (a4),(a3)+	;l,c
	move.l 4(a4),(a3)+	;l+1,c
	move.l 4+24(a4),(a3)+	;l+1,c+1
	move.l 24(a4),(a3)+	;l,c+1
	move.l (a4),(a3)	;l,c
	move.l usp,a3
	addq #4,a4

	move #+30000,d4	;ymin
	move #-30000,d5	;ymax
	move 2(a3),d3	;recherche de ymin et ymax
	cmp d3,d4
	ble.s pas_inf1
	move d3,d4
pas_inf1:
	cmp d3,d5
	bge.s pas_sup1
	move d3,d5
pas_sup1:
	move 6(a3),d3
	cmp d3,d4
	ble.s pas_inf2
	move d3,d4
pas_inf2:
	cmp d3,d5
	bge.s pas_sup2
	move d3,d5
pas_sup2: 
	move 10(a3),d3
	cmp d3,d4
	ble.s pas_inf3
	move d3,d4
pas_inf3:
	cmp d3,d5
	bge.s pas_sup3
	move d3,d5
pas_sup3:	
	move 14(a3),d3
	cmp d3,d4
	ble.s pas_inf4
	move d3,d4
pas_inf4:
	cmp d3,d5
	bge.s pas_sup4
	move d3,d5
pas_sup4:
	sub d4,d5		;ymax-ymin
	move d5,d3		;sauve le compteur en y

	move d4,y1(a6)	;affichage du polygone avec $a006
aff_lp:	
	MOVEM.L	D0-D7/A0-A6,-(A7)
	jsr	FILL1
	MOVEM.L	(A7)+,D0-D7/A0-A6

	addQ #1,y1(a6)
	dbra d5,aff_lp

	REPT 4		;affichage des 4 lignes afin d'obtenir
	move.l (a3)+,x1(a6)	; la meme forme qu'avec polyfill.
	move.l (a3),x2(a6)

            movem.l d0-d7/a0-a6,-(a7)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	MOVE	x1(a6),D0
	MOVE	y1(a6),D1
	
	MOVE	x2(a6),D2
	MOVE	y2(a6),D3

                bsr     DRAW_A_LINE


                movem.l (a7)+,d0-d7/a0-a6

	ENDR
	
	move.l usp,a3

	move #+30000,d0		;xmin
	move #-30000,d1		;xmax
	move (a3),d2		;recherche de xmin et xmax
	cmp d2,d0
	ble.s xpas_inf1
	move d2,d0
xpas_inf1:
	cmp d2,d1
	bge.s xpas_sup1
	move d2,d1
xpas_sup1:
	move 4(a3),d2
	cmp d2,d0
	ble.s xpas_inf2
	move d2,d0
xpas_inf2:
	cmp d2,d1
	bge.s xpas_sup2
	move d2,d1
xpas_sup2: 
	move 8(a3),d2
	cmp d2,d0
	ble.s xpas_inf3
	move d2,d0
xpas_inf3:
	cmp d2,d1
	bge.s xpas_sup3
	move d2,d1
xpas_sup3:	
	move 12(a3),d2
	cmp d2,d0
	ble.s xpas_inf4
	move d2,d0
xpas_inf4:
	cmp d2,d1
	bge.s xpas_sup4
	move d2,d1
xpas_sup4:
	lsr #4,d0		;on obtient le num‚ro du groupe de 16 pixels
	lsr #4,d1
	sub d0,d1		;compteur
	lsl #3,d0		;*8 => offset en x
	muls #160,d4	;ymin*160 => offset en y
	add d4,d0		;offset / ad ‚cran en .w

	move.l ad_ecran,a0

	move d6,-(sp)
	move d7,-(sp)
	move.l a6,-(sp)
	lea off_bolean,a6
scan_y:			;rep‚rage du polygone
	move d0,d4		;sauvegarde des compteurs
	move d1,d2
scan_x:
	move (a0,d4.w),d5
	beq.s or_nul
	clr (a0,d4.w)		;effa‡age
	move #$006e,(a5)+		;or #$uuuu,vv(a6)
	move d5,(a5)+		;$uuuu
	move d4,(a5)+		;vv=d16
	move d4,d6		;note l'offset pour l'effa‡age (tjs >=0)
	lsr #3,d6
	move d6,d7
	and #$0007,d6
	lsr #3,d7
	bset.b d6,(a6,d7.w)
or_nul:
	addq #8,d4		;groupe suivant
	dbra d2,scan_x

	add #160,d0		;ligne suivante
	dbra d3,scan_y

	move.l (sp)+,a6
	move (sp)+,d7
	move (sp)+,d6

	move.l a5,d0	;on peut calculer l'offset pour beq.s
	move.l (sp)+,a1
	sub.l a1,d0
	subq #2,d0
	cmp #127,d0		;ok pour beq.S ?
	blo.s offset_short
	move #$6700,(a1)+		;beq.l
	move.l a5,a0
	move d0,d1
	addq #2,d0
	lsr #1,d1
off_l_lp:
	move -(a0),2(a0)
	dbra d1,off_l_lp
	move d0,(a1)+
	addq #2,a5
	bra.s off_l_fin
offset_short:
	move.b d0,1(a1)			;offset pour le beq.s
off_l_fin:

	cmp.l #routines+230000,a5
	blo.s mem_ok
	jmp	FIN
mem_ok:

	dbra d6,ligne_lp
	addq #4,a4

	dbra d7,col_lp
	add #24,a4

	move (sp)+,d7
	move #$4e75,(a5)+		;rts
	dbra d7,pas_lp



	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #$7e00,(a5)+		;moveq #0,d7
	lea off_bolean,a0	;routine d'effa‡age: les bits concernent
	moveq #0,d5		; les mots du premier plan,dans l'ordre;
	move #500-1,d7	; bit=1 effacer plan 1 de ce groupe de 16 
off_oct_lp:			; pixels, ne rien faire sinon.
	move.b (a0)+,d5
	moveq #8-1,d6
off_bit_lp:
	btst d6,d5
	beq.s bit_nul_off
	move #$3d47,(a5)+		;move d7,xx(a6)
	move #499,d4
	sub d7,d4
	lsl #3,d4
	add d6,d4
	lsl #3,d4
	move d4,(a5)+			;offset
	
	cmp.l #routines+230000,a5
	blo.s mem_ok2
	jmp	FIN
mem_ok2:

bit_nul_off:
	dbra d6,off_bit_lp
	dbra d7,off_oct_lp
	
	move #$4e75,(a5)+		;rts

	movem.l (sp)+,a0-a6/d1/d7
	rts

FILL1	MOVEQ.L	#3,D0
	LEA	PtsFill,a0
	LEA	BUF16DA,A1
	
	CLR.W	PNT_261E
LFCA0F4	MOVE.W	6(A0),D1
	MOVE.W	2(A0),D2
	SUB.W	D2,D1
	BEQ.S	LFCA13E
	MOVE.W	EMUL_LINEA-$299A+$29C2,D3
	MOVE.W	D3,D4
	SUB.W	D2,D4
	SUB.W	6(A0),D3
	MOVE.W	D4,D2
	EOR.W	D3,D2
	BPL.S	LFCA13E
	MOVE.W	4(A0),D2
	SUB.W	(A0),D2
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
LFCA132	ADD.W	(A0),D4
	MOVE.W	D4,(A1)+
	ADDQ.W	#1,PNT_261E
LFCA13E	LEA	4(A0),A0
	DBF	D0,LFCA0F4
	MOVE.W	PNT_261E,D0
	BNE.S	LFCA150
	RTS

LFCA150	LEA	BUF16DA,A0
	BSR.S	LFCA1DC
	MOVE.W	PNT_261E,D0
	ASR.W	#1,D0
	SUBQ.W	#1,D0

LFCA16C	MOVE.W	(A1)+,EMUL_LINEA+$26
	MOVE.W	(A1)+,EMUL_LINEA+$2A
	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR.S	FILL2
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
	DBF	D0,LFCA16C
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

VALEURS	DC.L	$FFFF7FFF
	DC.L	$3FFF1FFF
	DC.L	$0FFF07FF
	DC.L	$03FF01FF
	DC.L	$00FF007F
	DC.L	$003F001F
	DC.L	$000F0007
	DC.L	$00030001
	DC	$0000

FILL2	
	LEA	EMUL_LINEA-$299A+$299A,A4

	MOVE	$26(A4),D4
	MOVE	$28(A4),D5
	MOVE	$2A(A4),D6

	MOVE.W	D5,D0

	AND.W	50(A4),D0	MASK DU SAMPLE REMPLISSAGE
	ADD.W	D0,D0
	
	MOVEA.L	46(A4),A0	PNTEUR SUR SAMPLE REMPLISSAGE
	ADDA.W	D0,A0	
	
	TST.W	52(A4)	1 OU POLYPLANS
	SNE	D0
	AND.W	#$20,D0
	MOVE.W	D4,D1
	ASR.W	#4,D1
	MOVE.W	D6,D2
	ASR.W	#4,D2
	MOVEQ	#$F,D3
	AND.W	D3,D4
	ADD.W	D4,D4
	MOVE.W	VALEURS(PC,D4.W),D4
	AND.W	D3,D6
	ADD.W	D6,D6
	MOVE.W	VALEURS+2(PC,D6.W),D6
	NOT.W	D6
	SUB.W	D1,D2
	BNE.S	LFCA63C
	AND.W	D6,D4
LFCA63C	

	MOVEA.L	$44E.W,A1
	lea	4(a1),a1
	MULS.W	#160,D5
	ADDA.L	D5,A1

	MOVEA.W	D0,A2

	MOVE.W	#4,D7	NB PLANS
	MOVE	#8,D0
	MULS.W	D0,D1	
	ADDA.L	D1,A1	A1=SCREEN

	LEA	24(A4),A3	VALEUR DE LA COLOR DU PLAN 0

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
LFD1C7E	

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
                
DRAW_A_LINE
                cmp.w   d1,d3
                beq     DRAW_HORIZONTAL
                cmp.w   d0,d2
                beq     DRAW_VERTICAL

                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l	$44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0
                move.w  d0,d5
                eor.w   #$0f,d5
                and.w   #$0f,d5
                clr.w   d6
                bset    d5,d6
                move.w  d6,d7           OR Mask
                not.w   d6              AND Mask

                sub.w   d0,d2           u
                sub.w   d1,d3           v

                move.l  #0,a1
                move.l  #0,a2
                move.l  #0,a3
                move.l  #0,a4
                
                tst.w   d2
                bpl.s   .dr_1
                beq.s   .dr_2
                move.w  #-1,a1          d1x
                neg.w   d2              M
                bra.s   .dr_2
.dr_1
                move.w  #1,a1           d1x
.dr_2
                tst.w   d3
                bpl.s   .dr_3
                beq.s   .dr_4
                move.w  #-1,a2          d1y
                neg.w   d3              N
                bra.s   .dr_4
.dr_3
                move.w  #1,a2           d1y
.dr_4
                cmp.w   d2,d3
                blt.s   .dr_5
                move.w  a2,a4           d2y
                exg     d2,d3
                bra.s   .dr_6
.dr_5
                move.w  a1,a3           d2x
.dr_6 
                move.w  d2,d0
                lsr.w   #1,d0           S
                move.w  d2,d1           I

*               d0: S, d1: I, d2: M, d3: N, d6:AND Mask, d7:OR Mask
*               a0: Screen, a1: d1x, a2:d1y, a3:d2x, a5:d2y
.dr_7
*               PLOT THE POINT

                or.w    d7,(a0)

                add.w   d3,d0
                cmp.w   d0,d2
                bgt.s   .dr_8
        
                sub.w   d2,d0
                
                cmp.w   #0,a1
                beq.s   .dr_A5
                bmi.s   .dr_A6
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A5
                addq.l  #8,a0
                bra.s   .dr_A5
.dr_A6
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A5
                subq.l  #8,a0
.dr_A5
                cmp.w   #0,a2
                beq.s   .dr_A3
                bmi.s   .dr_A8
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A8
                lea     -160(a0),a0
                bra.s   .dr_A3
.dr_8
                cmp.w   #0,a3
                beq.s   .dr_A1
                bmi.s   .dr_A2
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A3
                addq.l  #8,a0
                bra.s   .dr_A3
.dr_A2
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A3
                subq.l  #8,a0
                bra.s   .dr_A3
.dr_A1
                cmp.w   #0,a4
                bmi.s   .dr_A4
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A4
                lea     -160(a0),a0
.dr_A3
                dbf     d1,.dr_7        
                rts

DRAW_HORIZONTAL
                cmp.w   d0,d2
                bne.s   .dr_h_1
                rts
.dr_h_1
                bgt.s   .dr_h_2
                exg     d0,d2
.dr_h_2
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l  $44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                move.w  d2,d3
                move.w  d0,d6
                
                and.w   #$fff0,d6
                lsr.w   #4,d6
                and.w   #$fff0,d2
                lsr.w   #4,d2
                
                sub.w   d6,d2

                lea     PIXEL_TABLE_LEFT,a1
                and.w   #$000f,d0
                lsl.w   #1,d0
                move.w  (a1,d0),d0
                lea     PIXEL_TABLE_RIGHT,a1
                and.w   #$000f,d3
                lsl.w   #1,d3
                move.w  (a1,d3),d3

                tst     d2
                bne.s   .dr_h_7
                
                and.w   d0,d3
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_7
                subq.w  #1,d2
                bne.s   .dr_h_8
                
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr.S     .dr_h_m_1
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_8
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr.S     .dr_h_m_1

                subq.w  #1,d2
                move.w  #$ffff,d6
                clr.w   d7
.dr_h_9
                bsr.S     .dr_h_m_1
                dbf     d2,.dr_h_9
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7

.dr_h_m_1       
                or.w    d6,(a0)
	lea	8(a0),a0
                rts

DRAW_VERTICAL
                cmp.w   d1,d3
                bgt.s   .dr_v_1
                exg     d1,d3
.dr_v_1
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l  $44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                eor.w   #$0f,d0
                and.w   #$0f,d0
                clr.w   d6
                bset    d0,d6
                move.w  d6,d7           OR Mask
                not.w   d7              AND Mask

                sub.w   d1,d3           Height
.dr_v_m_1
                or.w    d6,(a0)

                lea     160(a0),a0
                dbf     d3,.dr_v_m_1
                rts


PRP_CRB2	LEA	COURB_1,A0
	LEA	BUF1CRB2,A5
	LEA	DIFF_ROUTS,A2
	MOVE.W	#639,D7
REC_PRP_CRB	MOVEQ	#0,D1
	MOVE.W	(A0)+,D0	;0-4-8-12
	MOVE.W	(A0)+,D1	;((X AND -16)/2)+(Y*160)
	MOVE.L	D1,(A5)+
	MOVE.L	(A2,D0.W),(A5)+
	DBRA	D7,REC_PRP_CRB
	MOVEQ	#0,D0
	LEA	RIEN,A3
	MOVEQ	#63,D7
COMPLETE	MOVE.L	A3,(A5)+
	MOVE.L	(A2,D0.W),(A5)+
	DBRA	D7,COMPLETE
	RTS
	
PRP_FONT	LEA	FONT8_8,A0
	LEA	BUF_COD2,A1
	LEA	TABLE_ADR,A2
	MOVEQ	#0,D4
	MOVEQ	#60,D6
NB_FONT	MOVEQ	#7,D3
COLONNE2	MOVE.L	A1,(A2)+
	MOVEQ	#0,D4
	MOVEQ	#7,D7
COLONNE1	MOVE.B	(A0)+,D0
	BTST	D3,D0
	BEQ.S	NO_AFF
	CMPI.W	#2,D4
	BGE.S	OPTI_1
CONTINUE2	MOVEQ	#0,D4
	MOVE.L	#$205A225A,(A1)+
	MOVE.L	#$D1C74E91,(A1)+
CONTINUE1	DBRA	D7,COLONNE1
	SUBQ.L	#8,A0
	CMPI.W	#2,D4
	BGE.S	OPTI_2
CONTINUE3	DBRA	D3,COLONNE2
	ADDQ.L	#8,A0
	MOVE.W	#$4E75,(A1)+
	DBRA	D6,NB_FONT
	RTS

NO_AFF	ADDQ.W	#1,D4
	MOVE.W	#$504A,(A1)+
	BRA.S	CONTINUE1

OPTI_1	MOVE.W	D4,D5
	ADD.W	D5,D5
	SUBA.L	D5,A1
	ADD.W	D5,D5
	ADD.W	D5,D5
	MOVE.W	#$45EA,(A1)+
	MOVE.W	D5,(A1)+
	BRA.S	CONTINUE2

OPTI_2	MOVE.W	D4,D5
	ADD.W	D5,D5
	SUBA.L	D5,A1
	ADD.W	D5,D5
	ADD.W	D5,D5
	MOVE.W	#$45EA,(A1)+
	MOVE.W	D5,(A1)+
	BRA.S	CONTINUE3

PRP_TEXT	LEA	TEXT,A0
	LEA	BUF_TEXT,A1
CONTXT	CMPI.B	#-1,(A0)
	BEQ.S	FIN_TXT
	MOVEQ	#0,D0
	MOVE.B	(A0)+,D0
	SUBI.B	#32,D0
	LSL	#5,D0
	LEA	TABLE_ADR,A3
	ADDA.L	D0,A3
	MOVE.L	A3,(A1)+
	BRA.S	CONTXT
FIN_TXT	MOVE.L	#-1,(A1)
	RTS

	;CHACUNE DES ROUTINES PREND 36 NOPS !!!
BOULE1	MOVE.L	#$60006000,D0	;3
	MOVE.L	#$D000B000,D1	;3
	MOVE.L	#$B000D000,D2	;3
	OR.L	D0,(A0)		;5
	OR.L	D1,$A0(A0)		;6
	OR.L	D2,$140(A0)		;6
	OR.L	D0,$1E0(A0)		;6
	RTS			;4
	;TOTAL	=		36 NOPS
BOULE2	MOVE.L	#$6000600,D0
	MOVE.L	#$D000B00,D1
	MOVE.L	#$B000D00,D2
	OR.L	D0,(A0)
	OR.L	D1,$A0(A0)
	OR.L	D2,$140(A0)
	OR.L	D0,$1E0(A0)
	RTS
BOULE3	MOVE.L	#$600060,D0
	MOVE.L	#$D000B0,D1
	MOVE.L	#$B000D0,D2
	OR.L	D0,(A0)
	OR.L	D1,$A0(A0)
	OR.L	D2,$140(A0)
	OR.L	D0,$1E0(A0)
	RTS
BOULE4	MOVE.L	#$60006,D0
	MOVE.L	#$D000B,D1
	MOVE.L	#$B000D,D2
	OR.L	D0,(A0)
	OR.L	D1,$A0(A0)
	OR.L	D2,$140(A0)
	OR.L	D0,$1E0(A0)
	RTS	

PRP_CRB	LEA	COURB,A0
	LEA	BUF1CRB,A1
	LEA	BUF2CRB,A3
	LEA	ADR_ROUTS,A2
	MOVE.W	#159,D6
PRP_CRB2B	MOVEQ	#7,D7
PRP_CRB1	MOVE.W	(A0)+,D0
	MOVE.L	(A2,D0.W),(A1)+
	MOVE.L	(A2,D0.W),(A3)+
	MOVEQ	#0,D0
	MOVE.W	(A0),D0
	ADD.L	SCREEN2,D0
	MOVE.L	D0,(A1)+
	MOVEQ	#0,D0
	MOVE.W	(A0)+,D0
	ADD.L	SCREEN1,D0
	MOVE.L	D0,(A3)+
	DBRA	D7,PRP_CRB1
	DBRA	D6,PRP_CRB2B
	LEA	BUF1CRB,A0
	LEA	64*160(A0),A1
	MOVE.W	#(8*160)-1,D7
RECOP1	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	DBRA	D7,RECOP1
	LEA	BUF2CRB,A0
	LEA	64*160(A0),A1
	MOVE.W	#(8*160)-1,D7
RECOP2	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	DBRA	D7,RECOP2
	RTS

PRP_LET	LEA	MESSAG,A0
	LEA	ADR_ROUTS,A1
	LEA	TABLE,A2
	LEA	BUF_COD,A3
	MOVEQ	#9,D6
ANAL_3	MOVE.L	A3,(A2)+
	MOVEQ	#7,D3
ANAL_2	MOVEQ	#7,D7
ANAL_1A	MOVE.B	(A0)+,D0
	BTST	D3,D0
	BEQ.S	NOT_GAGA_C_ZAPPY_1991
	MOVE.L	#$225A205A,(A3)+	;MOVE.L (A2)+,A1
				;MOVE.L (A2)+,A0
	MOVE.L	#$D0C74E91,(A3)+	;JSR (A1)
				;ADDA.W D7,A0
CONTINUE	DBRA	D7,ANAL_1A
	MOVE.L	#$45EA0040,(A3)+
	SUBQ.L	#8,A0
	DBRA	D3,ANAL_2
	ADDQ.L	#8,A0
	MOVE.W	#$4E75,(A3)+
	DBRA	D6,ANAL_3
	RTS

NOT_GAGA_C_ZAPPY_1991
	MOVE.W	#$504A,(A3)+	;ADDQ.W #8,A2
	BSR.S	OPTIMIZE
	BRA.S	CONTINUE

OPTIMIZE	MOVE.W	#$504A,D1
	MOVE.W	#$45EA,D2
	MOVEQ	#0,D4
RECOM_TST	CMP.W	-2(A3),D1
	BNE.S	TEST2
	SUBQ.L	#2,A3
	ADDQ.W	#8,D4
	BRA.S	RECOM_TST
TEST2	CMP.W	-4(A3),D2
	BNE.S	CONT_OPT
	SUBQ.L	#4,A3
	ADD.W	2(A3),D4
	BRA.S	RECOM_TST
CONT_OPT	TST.W	D4
	BEQ.S	NO_OPT
	CMPI.W	#8,D4
	BNE.S	MAK_LEA
	MOVE.W	#$504A,(A3)+
	BRA.S	NO_OPT
MAK_LEA	MOVE.W	#$45EA,(A3)+
	MOVE.W	D4,(A3)+
NO_OPT	RTS

CALCULE	LEA	BUF_STAR,A5
	MOVE.W	#(768/VITESSE)-1,D7	;NOMBRE DE PHASE

RECOM_CALC	LEA	STAR,A0

	MOVE.W	#NB_STARS-1,D6

RECOM2	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVE.W	(A0)+,D0
	MOVE.W	(A0)+,D1
	MOVE.W	(A0),D2

;	MOVE.W	#$700,$FFFF8240.W
	SUB.W	#VITESSE,D2
	CMPI.W	#-255,D2
	BGT.S	ZOKA
	ADD.W	#512+255,D2
ZOKA	MOVE.W	D2,(A0)+
	MOVE.W	D2,D3
	EXT.L	D2
	SWAP	D2
	ASR.L	#8,D2
	ADDI.L	#$10000,D2
	ASR.L	#5,D2
	ASR.L	#4,D2

	EXT.L	D0
	ASL.W	#7,D0
	TST.W	D2
	BNE.S	DIVIS_1
	MOVEQ	#1,D2
DIVIS_1	DIVS.W	D2,D0

	EXT.L	D1
	ASL.W	#7,D1
	DIVS.W	D2,D1

	ADDI.W	#X_CENTER,D0
	ADDI.W	#Y_CENTER,D1

	BSR.S	CALC_ECRAN
;	MOVE.W	#$000,$FFFF8240.W

	DBRA	D6,RECOM2

	DBRA	D7,RECOM_CALC

	LEA	-NB_STARS*6*2(A5),A5
	MOVE.L	#BUF_STAR,PNT_STR

	LEA	BUF_STAR,A0
	LEA	-NB_STARS*6*2(A0),A0
	MOVE.W	#(NB_STARS*2)-1,D7
FINAL	MOVE.L	(A5)+,(A0)+
	MOVE.W	(A5)+,(A0)+
	DBRA	D7,FINAL

	MOVE.L	#-1,(A5)

	RTS

CALC_ECRAN	CMPI.W	#320,D0
	BGE.S	CLIP
	TST.W	D0
	BLT.S	CLIP
	CMPI.W	#195,D1
	BGE.S	CLIP
	TST.W	D1
	BLT.S	CLIP
	LEA	PNTS,A3
	MOVE.W	D0,D2
	ANDI.W	#15,D0
	ADD.W	D0,D0
	MOVE.W	(A3,D0.W),D0

	ANDI.W	#-16,D2
	LSR	#1,D2
	MULU.W	#160,D1
	ADD.W	D2,D1

	CMPI.W	#120,D3
	BLT.S	PLAN_1
	CMPI.W	#310,D3
	BLT.S	PLAN_2
	
	MOVE.W	D0,D2
	SWAP	D0
	MOVE.W	D2,D0
	MOVE.L	D0,(A5)+
	MOVE.W	D1,(A5)+
	RTS

PLAN_1	SWAP	D0
	CLR.W	D0
	SWAP	D0
	MOVE.L	D0,(A5)+
	MOVE.W	D1,(A5)+
	RTS

PLAN_2	SWAP	D0
	CLR.W	D0
	MOVE.L	D0,(A5)+
	MOVE.W	D1,(A5)+
	RTS

CLIP	MOVE.L	#0,(A5)+
	MOVE.W	#0,(A5)+
	RTS

decrunch:	movem.l d0-a6,-(sp)
	cmpi.l	#'Ice!',(a0)+	; Is data packed?
	bne.s	ice_03		; no!
	move.l	(a0)+,d0	; read packed data
	lea	-8(a0,d0.l),a5
	move.l	(a0)+,(sp)
	movea.l a1,a4
	movea.l a1,a6
	adda.l	(sp),a6
	movea.l a6,a3
	bsr.s	ice_08
	bsr.s	ice_04
	bsr	ice_0c		;; Picture decrunch!
	bcc.s	ice_03		;; These marked lines may be
	move.w	#$0f9f,d7	;; removed in your own sources
ice_00:	moveq	#3,d6		;; if you do not use the
ice_01:	move.w	-(a3),d4	;; additional algorithm.
	moveq	#3,d5		;;
ice_02:	add.w	d4,d4		;;
	addx.w	d0,d0		;;
	add.w	d4,d4		;;
	addx.w	d1,d1		;;
	add.w	d4,d4		;;
	addx.w	d2,d2		;;
	add.w	d4,d4		;;
	addx.w	d3,d3		;;
	dbra	d5,ice_02	;;
	dbra	d6,ice_01	;;
	movem.w d0-d3,(a3)	;;
	dbra	d7,ice_00	;;
ice_03:	movem.l (sp)+,d0-a6
	rts
ice_04:	bsr.s	ice_0c
	bcc.s	ice_07
	moveq	#0,d1
	bsr.s	ice_0c
	bcc.s	ice_06
	lea	ice_1a(pc),a1
	moveq	#4,d3
ice_05:	move.l	-(a1),d0
	bsr.s	ice_0f
	swap	d0
	cmp.w	d0,d1
	dbne	d3,ice_05
	add.l	20(a1),d1
ice_06:	move.b	-(a5),-(a6)
	dbra	d1,ice_06
ice_07:	cmpa.l	a4,a6
	bgt.s	ice_12
	rts
ice_08:	moveq	#3,d0
ice_09:	move.b	-(a5),d7
	ror.l	#8,d7
	dbra	d0,ice_09
	rts
ice_0a:	move.w	a5,d7
	btst	#0,d7
	bne.s	ice_0b
	move.l	-(a5),d7
	addx.l	d7,d7
	bra.s	ice_11
ice_0b:	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	bra.s	ice_11
ice_0c:	add.l	d7,d7
	beq.s	ice_0d
	rts
ice_0d:	move.w	a5,d7
	btst	#0,d7
	bne.s	ice_0e
	move.l	-(a5),d7
	addx.l	d7,d7
	rts
ice_0e:	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	rts
ice_0f:	moveq	#0,d1
ice_10:	add.l	d7,d7
	beq.s	ice_0a
ice_11:	addx.w	d1,d1
	dbra	d0,ice_10
	rts
ice_12:	lea	ice_1b(pc),a1
	moveq	#3,d2
ice_13:	bsr.s	ice_0c
	dbcc	d2,ice_13
	moveq	#0,d4
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bmi.s	ice_14
	bsr.s	ice_0f
ice_14:	move.b	6(a1,d2.w),d4
	add.w	d1,d4
	beq.s	ice_16
	lea	ice_1c(pc),a1
	moveq	#1,d2
ice_15:	bsr.s	ice_0c
	dbcc	d2,ice_15
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bsr.s	ice_0f
	add.w	d2,d2
	add.w	6(a1,d2.w),d1
	bra.s	ice_18
ice_16:	moveq	#0,d1
	moveq	#5,d0
	moveq	#0,d2
	bsr.s	ice_0c
	bcc.s	ice_17
	moveq	#8,d0
	moveq	#$40,d2
ice_17:	bsr.s	ice_0f
	add.w	d2,d1
ice_18:	lea	2(a6,d4.w),a1
	adda.w	d1,a1
	move.b	-(a1),-(a6)
ice_19:	move.b	-(a1),-(a6)
	dbra	d4,ice_19
	bra	ice_04
	DC.B $7f,$ff,$00,$0e,$00,$ff,$00,$07
	DC.B $00,$07,$00,$02,$00,$03,$00,$01
	DC.B $00,$03,$00,$01
ice_1a:	DC.B $00,$00,$01,$0d,$00,$00,$00,$0e
	DC.B $00,$00,$00,$07,$00,$00,$00,$04
	DC.B $00,$00,$00,$01
ice_1b:	DC.B $09,$01,$00,$ff,$ff,$08,$04,$02
	DC.B $01,$00
ice_1c:	DC.B $0b,$04,$07,$00,$01,$20,$00,$00
	DC.B $00,$20

	INCLUDE	COD_GENE.COD

SCREEN_Y_TABLE
                dc.w    0,160,320,480,640,800,960,1120,1280,1440,1600,1760,1920,2080,2240
                dc.w    2400,2560,2720,2880,3040,3200,3360,3520,3680,3840,4000,4160,4320,4480,4640
                dc.w    4800,4960,5120,5280,5440,5600,5760,5920,6080,6240,6400,6560,6720,6880,7040
                dc.w    7200,7360,7520,7680,7840,8000,8160,8320,8480,8640,8800,8960,9120,9280,9440
                dc.w    9600,9760,9920,10080,10240,10400,10560,10720,10880,11040,11200,11360,11520,11680,11840
                dc.w    12000,12160,12320,12480,12640,12800,12960,13120,13280,13440,13600,13760,13920,14080,14240
                dc.w    14400,14560,14720,14880,15040,15200,15360,15520,15680,15840,16000,16160,16320,16480,16640
                dc.w    16800,16960,17120,17280,17440,17600,17760,17920,18080,18240,18400,18560,18720,18880,19040
                dc.w    19200,19360,19520,19680,19840,20000,20160,20320,20480,20640,20800,20960,21120,21280,21440
                dc.w    21600,21760,21920,22080,22240,22400,22560,22720,22880,23040,23200,23360,23520,23680,23840
                dc.w    24000,24160,24320,24480,24640,24800,24960,25120,25280,25440,25600,25760,25920,26080,26240
                dc.w    26400,26560,26720,26880,27040,27200,27360,27520,27680,27840,28000,28160,28320,28480,28640
                dc.w    28800,28960,29120,29280,29440,29600,29760,29920,30080,30240,30400,30560,30720,30880,31040
                dc.w    31200,31360,31520,31680,31840
PIXEL_TABLE_LEFT
                dc.w    %1111111111111111
                dc.w    %0111111111111111
                dc.w    %0011111111111111
                dc.w    %0001111111111111
                dc.w    %0000111111111111
                dc.w    %0000011111111111
                dc.w    %0000001111111111
                dc.w    %0000000111111111
                dc.w    %0000000011111111
                dc.w    %0000000001111111
                dc.w    %0000000000111111
                dc.w    %0000000000011111
                dc.w    %0000000000001111
                dc.w    %0000000000000111
                dc.w    %0000000000000011
                dc.w    %0000000000000001
PIXEL_TABLE_RIGHT
                dc.w    %1000000000000000
                dc.w    %1100000000000000
                dc.w    %1110000000000000
                dc.w    %1111000000000000
                dc.w    %1111100000000000
                dc.w    %1111110000000000
                dc.w    %1111111000000000
                dc.w    %1111111100000000
                dc.w    %1111111110000000
                dc.w    %1111111111000000
                dc.w    %1111111111100000
                dc.w    %1111111111110000
                dc.w    %1111111111111000
                dc.w    %1111111111111100
                dc.w    %1111111111111110
                dc.w    %1111111111111111

MESS_X_COORD    dc.w    0
MESS_Y_COORD    dc.w    0

pal	
n	set	0	
	rept	4
	dcb	10,$300+n
n	set	n+$100
	endr
n	set	0	
	rept	6
	dcb	10,$700+n
n	set	n+$010
	endr
n	set	0	
	rept	6
	dcb	10,$770+n
n	set	n+$001
	endr

n	set	0	
	rept	6
	dcb	10,$777-n
n	set	n+$001
	endr

n	set	0	
	rept	6
	dcb	10,$770-n
n	set	n+$010
	endr
n	set	0	
	rept	4
	dcb	10,$700-n
n	set	n+$100
	endr
	dc.l	$ffffffff
		
pattern:	dc.w $ffff
MUSIX	INCBIN	TURRICAN.MSX

f01:	incbin	COUCHE2.dat		;90912 octets pour couche2
f02:	incbin	flexi.dat
f03:	incbin	delire2.dat
f04:	INCBIN	rond10b.DAT
f05:	incbin	last.dat

COURB	INCBIN	CIRCLE_2.CRB

EFFAC	INCBIN	EFF_BALS.EFF

COURB_1	INCBIN	CRB_3.CRB

EFFAC_1	INCBIN	CRB_3.EFF

	DS.L	1
CRB_REBOND	INCBIN	REBOND.CRB
	DC.W	-1

ZIK	INCBIN	COPPER.MUS
WATER	INCBIN	WATER.PI1

ADR_ROUTS	DC.L	DEC_1,DEC_2,DEC_3,DEC_4,DEC_5,DEC_6,DEC_7,DEC_8
	DC.L	DEC_9,DEC_10,DEC_11,DEC_12,DEC_13,DEC_14,DEC_15
	DC.L	DEC_16

MESSAG	DC.B	230,102,102,110,102,102,230,0	;H
	DC.B	108,198,198,198,198,198,108,0	;O
	DC.B	240,96,96,96,96,98,238,0	;L
	DC.B	108,198,198,198,198,198,108,0	;O
	DC.B	46,98,224,224,224,98,46,0	;C
	DC.B	24,56,56,76,124,140,206,0	;A
	DC.B	246,98,98,98,98,98,28,0		;U
	DC.B	110,194,240,60,14,134,236,0	;S
	DC.B	126,90,24,24,24,24,60,0		;T
	DC.B	0,0,0,0,0,0,0,0

FONT8_8	
	DC.B	0,0,0,0,0,0,0,0
	DC.B 24,24,48,48,0,96,96,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B 24,24,48,0,0,0,0,0
	DC.B 24,56,48,48,48,56,24,0
	DC.B 48,56,24,24,24,56,48,0
	DC.B 18,84,56,254,56,84,144,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B 0,0,0,0,48,48,96,0
	DC.B 0,0,0,126,126,0,0,0
	DC.B 0,0,0,0,0,48,48,0
	DC.B 254,0,252,0,248,0,240,0
	DC.B 124,198,206,214,230,198,124,0
	DC.B 24,56,56,24,24,60,60,0
 DC.B 60,94,102,12,24,54,126,0
 DC.B 126,126,6,28,6,126,124,0
 DC.B 28,60,108,204,254,254,12,0
 DC.B 126,126,64,124,6,126,124,0
 DC.B 60,102,96,124,102,102,60,0
 DC.B 126,118,76,12,24,24,24,0
 DC.B 60,102,102,60,102,102,60,0
 DC.B 60,102,102,62,6,6,60,0
 DC.B 0,0,48,48,0,48,48,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	0,0,0,0,0,0,0,0
 DC.B 60,102,102,12,0,24,24,0
	DC.B	0,0,0,0,0,0,0,0
	DC.B	124,230,230,254,230,230,230,0	;A
	DC.B	252,230,230,252,230,230,252,0	;B
	DC.B	124,230,224,224,224,230,124,0	;C
	DC.B	252,230,230,230,230,230,252,0	;D
	DC.B	254,224,224,248,224,224,254,0	;E
	DC.B	254,224,224,248,224,224,224,0	;F
	DC.B	124,230,224,224,238,230,124,0	;G
	DC.B	230,230,230,254,230,230,230,0	;H
	DC.B	124,56,56,56,56,56,124,0	;I
	DC.B	14,14,14,14,14,206,124,0	;J
	DC.B	230,238,252,248,252,238,230,0	;K
	DC.B	224,224,224,224,224,224,254,0	;L
	DC.B	198,238,246,230,230,230,230,0	;M
	DC.B	252,230,230,230,230,230,230,0	;N
	DC.B	124,230,230,230,230,230,124,0	;O
	DC.B	252,230,230,252,224,224,224,0	;P
	DC.B	121,230,230,230,238,252,118,0	;Q
	DC.B	252,230,230,252,236,230,230,0	;R
	DC.B	124,230,224,124,14,206,124,0	;S
	DC.B	254,56,56,56,56,56,56,0	;T
	DC.B	230,230,230,230,230,230,124,0	;U
	DC.B	230,230,230,230,230,124,56,0	;V
	DC.B	230,230,230,230,254,238,198,0	;W
	DC.B	198,238,124,56,124,238,198,0	;X
	DC.B	230,230,230,124,56,56,56,0	;Y
	DC.B	254,206,28,56,112,230,254,0	;Z
	DC.B	0,0,0,0,0,0,0,0
	DC.B 	254,0,126,0,62,0,30,0


TEXT	DC.B	"            "
	DC.B " AND LET'S GO FOR THE STORY OF THIS SCREEN !    THE FIRST VERSION WAS CODED TWO  ( T W O ! ! ) YEARS AGO BY    \DAN NATO/    AND IT WAS CALLED:  *THE PARADOX SCROLLER*, COZ IT WAS BASED UPON AN AMIGA DEMO BY PARADOX...    "
	DC.B "  BUT DAN IS SO LAZY !    THE SOURCE FILE WAS REALLY... STRANGE !  A REAL SHIT TO DECRYPT IT !     MOREOVER IT USED THE LINE A !  AN HORROR !        SO I, \ZAPPY/ OF **HOLOCAUST**, HAD ACTUALLY TO RECODE THE MAIN ROUTINES OF"
	DC.B " THE SCROLLER  ( EH DAN, I HAVE SPEEDED UP THE SCROLL TOO, AND ENLARGED THE FONTS... JUST WAIT UNTIL THE END OF THIS SCREEN ! )           I ADMIT I HAD REAL DIFFICULTIES TO WIPE OUT THE LINE A...  THERE WERE SO MANY BUGS ! "
	DC.B "  FOR EXAMPLE I SUCCEEDED IN HAVING FONTS WHICH WERE HALF-FILLED !??            WELL, ANYWAY IT FINALLY WORKS.    "
	DC.B "    LET'S HAVE SOME CREDITS !    THE FIRST ONE...   \DAN NATO/...     SO FAR THE BEST CODER AMONG US !   BUT THE LAZIEST TOO !   DEAR DAN, IT WOULD BE ***UTTERLY SMASHING*** TO FINISH ALL THE STUFF YOU BEGAN TO CODE !!!  "
	DC.B "  THE STAR WARS SCROLLER !   THE ZOOM !  EH ?!  *WHAT* ARE U DOING ??!      ANYWAY, HE CODED THE FIRST VERSION OF THIS SCROLLER, AS I'VE SAID EARLIER."
	DC.B "         THE SECOND MAN OF THIS DEMO IS...    \ELRIC/...   NOT THE ONE FROM THE STORMBRINGERS ! THE ONE FROM   *** HOLOCAUST *** !    HE HAS CODED THIS SCROLLER AND THE FIRST BOUNCING BALLS HOLOCAUST LOGO.           "
	DC.B "      AND FINALLY...      \ZAPPY/ !  WHO HAVE DONE NEARLY ALL, ANYWAY !   I HAVE RECODED SOME PARTS OF THE FLEXI KILLER SCROLLER, HAVE DONE SOME LITTLE ADDITIONAL CODING, HAVE PUT ALL TOGETHER  ( NOT SO EASY... ), HAVE DONE MOST"
	DC.B " OF THE WAVES ( ALL THE WAVES EXCEPT ONE, ANYWAY ), AND HAVE DRAWN THE INTRODUCTION LOGO...  ( A NICE ONE, I THINK ! DEDICATED TO CAMEO OF THE REPLICANTS.......! ) "
	DCB.B	20,32
	DC.B	-1
	EVEN	

DIFF_ROUTS	DC.L	BOULE1,BOULE2,BOULE3,BOULE4

		
data_ads:	dc.l	f01
	dc.l	f02
	dc.l	f03
	DC.L	f04
	dc.l	f05

FADING
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$000,$000,$000,$000,$000

	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$100,$100,$100,$000,$000,$000,$000

	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$100,$200,$200,$200,$000,$000,$000,$000

	DC	$000,$000,$000,$000,$000,$000,$000,$100
	DC	$200,$300,$300,$300,$100,$000,$000,$000

	DC	$000,$000,$000,$000,$000,$000,$100,$200
	DC	$300,$400,$400,$400,$200,$100,$000,$000

	DC	$000,$100,$000,$000,$000,$100,$200,$300
	DC	$400,$500,$500,$500,$300,$200,$100,$000

	DC	$000,$200,$000,$000,$100,$200,$300,$400
	DC	$500,$600,$600,$600,$400,$300,$200,$100

	DC	$000,$300,$100,$100,$200,$300,$400,$500
	DC	$600,$700,$700,$700,$500,$400,$300,$200

	DC	$000,$400,$100,$100,$200,$300,$400,$500
	DC	$600,$700,$700,$710,$500,$400,$300,$200

	DC	$000,$500,$100,$100,$200,$300,$400,$500
	DC	$600,$700,$710,$720,$500,$400,$300,$200

	DC	$000,$500,$100,$100,$200,$300,$400,$500
	DC	$600,$710,$720,$730,$510,$400,$300,$200

	DC	$000,$500,$100,$100,$200,$300,$400,$500
	DC	$610,$720,$730,$740,$520,$410,$300,$200

	DC	$000,$500,$100,$100,$200,$300,$400,$510
	DC	$620,$730,$740,$750,$530,$420,$310,$200

	DC	$000,$500,$100,$100,$200,$300,$410,$520
	DC	$630,$740,$750,$760,$540,$430,$320,$210

	DC	$000,$500,$100,$110,$210,$310,$420,$530
	DC	$640,$750,$760,$770,$550,$440,$330,$220

	DC	$000,$500,$100,$110,$210,$310,$420,$530
	DC	$640,$750,$760,$771,$550,$440,$330,$220

	DC	$000,$500,$100,$110,$210,$310,$420,$530
	DC	$640,$750,$760,$772,$550,$440,$330,$220

	DC	$000,$500,$100,$110,$210,$310,$420,$530
	DC	$640,$750,$761,$773,$551,$440,$330,$220

	DC	$000,$500,$100,$110,$210,$310,$420,$530
	DC	$640,$751,$762,$774,$552,$441,$330,$220

	DC	$000,$500,$100,$110,$210,$310,$420,$530
	DC	$641,$752,$763,$775,$553,$442,$331,$220

	DC	$000,$500,$100,$110,$210,$310,$420,$531
	DC	$642,$753,$764,$776,$554,$443,$332,$221



text:
	dc.b " . . . H O L O C A U S T . . ."
;	dc.b "                           . . . H O L O C A U S T . . ."
;	DC.B "      KEEPING THE DREAM ALIVE !!!       "
;	DC.B	"HERE IS...   THE FLEXI KILLER SCROLLER "
;	DC.B	"BY   DAN NATO  OF HOLOCAUST ! "
;	DC.B	"        HAVE YOU EVER SEEN SUCH A SWELL CIRCLE PERFECTION, BOYS !                YOU ARE ABOUT TO ENTER OUR KINGDOM OF MADNESS !"
	dc.b "                                "
	dc.b 255

	dc.b " LORD, "
;	DC.B "WHERE DID I SEE THIS WAVE BEFORE...   "
;	DC.B "A SPECIAL HELLO TO GRIFF OF ELECTRONIC IMAGES  ( INNER CIRCLE ) !     YOU WERE BLOODY RIGHT: NEITHER THE CAREBEARS NOR THE LOST BOYS CAN BEAT YOUR FLEXISCROLLER... "
;	DC.B "     BUT HOLOCAUST CAN !"
	dc.b "                                "

	dc.b 255
	dc.b " AND ONCE "
;	DC.B "MORE A PERVERT SCROLLING "
;	DC.B "TO BLAST YOUR EYES OUT OF YOUR HEAD...   "
;	DC.B "     BUT DON'T PANIC, MY ( ZAPPY OF HOLOCAUST ) SECOND NAME COULD BE: 'THE WAVE MASTER' !   "
;	DC.B "   OR PERHAPS:  'THE MAN WHO IS ABLE TO FIND WAVES WHICH MAKE YA FEEL AS IF YOU WERE PENETRATED BY THE NOISOME SCRAPS OF ALTAIR'S LIQUID MANURE SEPTIC TANK' ! ! !      I JUST LET YA IMAGINE WHAT IT COULD BE...! "
	
	dc.b "                                "
	DC.B	255

	DC.B "WHOOO !!!   YOU WERE WARNED !!! I'M ABLE TO FIND REAL OUTRAGEOUS WAVES !     "
	DC.B "  OK, THAT'S NOT A TRUE WATERSCROLLER...  BUT IT LOOKS LIKE !"

	dc.b "                 "
	
	DC.B	255
	
	DC.B "                               GREETINGS TIME !  I APOLOGIZE BUT I'M SURE I'LL FORGET ONE OF YOU IN THIS GREETINGS PART... "
	DC.B "      BUT I'M ALONE HERE, AND I'M TIRED. SO...        GREY THINGS ARE FOR:      "
	DC.B "       LEGACY  (HI VULCAN! IT IS A SCROLLER FOR REBELS, AIN'T IT!     HI PIXELKILLER! I'M SURE YOU ARE FINDING THIS SCREEN VERY UGLY!     HI DTX! HI FURY!  HOPE YOU'LL DO GREAT THINGS ON AMIGA!)"
	DC.B "       OVERLANDERS  (A BIG HI TO ALL OF YOU!)"
	DC.B "       MCODER  (I LOVE YOUR WAY OF CODING! AHAH!  NICE CUBE O MATIC'CONVERSION'!  (....))"
	DC.B "       UNDEAD  (AND TMB...  INCREDIBLE MUSICS AND CODES!)"
	DC.B "       THE MASTERS  (HI SKAVEN! THANKS AND THANKS FOR THE VIDEOS!)"
	DC.B "       NAOS  (I'M SORRY NOT TO KNOW YOU BETTER.)"
	DC.B "       ST CNX  (HI KRAZY REX!  I DON'T FORGET THE DISKMAG!)"
	DC.B "       VEGETABLES  (HI FISHBONE! NICE SCREENS!)"
	DC.B "       POLTERGEIST  (VERY GOOD GFXS!)"
	DC.B "       AWG  (HI ! WE'RE SORRY NOT TO HAVE SENT A SCREEN FOR THE WOLVERINE...)"
	DC.B "       THE STORMBRINGERS  (I (ZAPPY) LUV' YOUR FIRST SCREEN! SPECIAL HI TO... ELRIC!)"
	DC.B "       THE SILVERS  (HI, CRAM AND MARCO POLO!)"
	DC.B "       VMAX  (HI ROBOCAMP!)"
	DC.B "       OXYGENE  (I HAVE DOUBTS ABOUT THE RESET DEMO OF THE GENIUS... AHEM...)"
	DC.B "       FMC CNX  (HI KID! HOPE YOU'RE HAVING GOOD TIME!)"
	DC.B "       NEXT  (HI THERE!)"
	DC.B "       1984  (HI WILL!)"
	DC.B "       MYSTICS  (HI MAJOR FATAL!)"
	DC.B "       AND NOW SOME OTHER GREETS TO THE REST OF THE WORLD...  "
	DC.B "       THE LOST BOYS"
	DC.B "       THE CAREBEARS" 
	DC.B "       TEX"
	DC.B "       LEVEL 16"
	DC.B "       ULM"
	DC.B "       RESPECTABLES"
	DC.B "       INNER CIRCLE"
	DC.B "       SYNC"
	DC.B "       ACF"
	DC.B "       ZAPPY'S SENDING PERSONAL GREETS TO:"
	dc.b "       DARKNESS"
	DC.B "       CUCKATOOS"
	DC.B "       MEGA1"
	DC.B "       TOUBAB"
	DC.B "       SARAYAN"
	DC.B "       MIC DAX"
	DC.B "       STJC"
	DC.B "       ONLY"
	DC.B "       ARIOCH"
	DC.B "       NCC 1701"
	DC.B "       OXYGENE"
	DC.B "       PANZERBOY"
	DC.B "       CORPO"
	DC.B "       JINX"
	DC.B "       ZOCH"
	DC.B "       JUDAS"
	DC.B "       CHAMALOW"
	DC.B "       OYA SHIVO"
	DC.B "       WALTER OF OVR"
	DC.B "       IKI"
	DC.B "       AL"
	DC.B "       ALL THE MEMBERS OF THE U EMPIRE"
	DC.B "       AND OF COURSE TO... FRIZOTUS!"
	dc.b "                                "


	dc.b 255,255
	even
font:	
	dc.b %00000,%00000,%00000,%00000	;' '
	dc.b %00000,%11101,%11101,%00000	;!
	dc.b %01111,%10100,%10100,%01111	;a
	dc.b %01010,%10101,%10101,%11111	;b
	dc.b %10001,%10001,%10001,%11111	;c
	dc.b %01110,%10001,%10001,%11111	;d
	dc.b %10001,%10101,%10101,%11111	;e
	dc.b %10000,%10100,%10100,%11111	;f
	dc.b %10110,%10101,%10001,%01110	;g
	dc.b %11111,%00100,%00100,%11111	;h
	dc.b %00000,%10001,%11111,%10001	;i
	dc.b %00000,%10000,%11111,%10001	;j
	dc.b %11011,%00100,%00100,%11111	;k
	dc.b %00001,%00001,%00001,%11111	;l
	dc.b %11111,%01000,%01000,%11111	;m
	dc.b %01111,%10000,%10000,%11111	;n
	dc.b %11111,%10001,%10001,%11111	;o
	dc.b %01000,%10100,%10100,%11111	;p
	dc.b %11111,%10011,%10001,%11111	;q
	dc.b %11101,%10110,%10100,%11111	;r
	dc.b %10010,%10101,%10101,%01001	;s
	dc.b %00000,%10000,%11111,%10000	;t
	dc.b %11111,%00001,%00001,%11111	;u
	dc.b %11110,%00001,%00001,%11110	;v
	dc.b %11111,%00010,%00010,%11111	;w
	dc.b %11011,%00100,%00100,%11011	;x
	dc.b %00000,%11100,%00111,%11100	;y
	dc.b %10001,%11001,%10101,%10011	;z
	dc.b %01110,%10001,%10001,%01110	;0
	dc.b %00000,%00001,%11111,%01001	;1
	dc.b %01001,%10101,%10011,%00001	;2
	dc.b %01010,%10101,%10101,%10001	;3
	dc.b %00010,%11111,%01010,%00110	;4
	dc.b %10010,%10101,%10101,%11101	;5
	dc.b %00010,%10101,%10101,%01110	;6
	dc.b %11000,%10100,%10010,%10001	;7
	dc.b %01010,%10101,%10101,%01010	;8
	dc.b %01110,%10101,%10101,%01001	;9
	dc.b %00000,%00011,%00011,%00000	;.
	dc.b %00000,%01001,%00000,%00000	;:
	dc.b %00000,%00010,%00001,%00000	;,
	dc.b %00000,%00000,%11000,%00000	;'
	dc.b %00000,%10001,%01110,%00000	;(
	dc.b %00000,%01110,%10001,%00000	;)

*equivalence:
*	dc.b " !ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:,'()"
	
PAL_WATER
	DC	$000
	DC	$111
	DC	$222
	DC	$333
	DC	$444
	DC	$555
	DC	$666
	DC	$777
	DC	$777
	DC	$777
	DC	$777
	DC	$777
	DC	$777
	DC	$666
	DC	$555
	DC	$444
	DC	$333
	DC	$222
	DC	$111
	DC	$000
	
	DC.L	-1
STAR	INCBIN	STARS2.DAT
	EVEN

PNTS
N	SET	32768
	REPT	16
	DC.W	N
N	SET	N/2
	ENDR

routines
CAMEO	INCBIN	CAMEO2.PI1	4671 bytes
	bss
CAMEO_END	ds.b	90912-4671
BUF_COD	DS.W	3000
BUF1CRB	DS.B	20480
BUF2CRB	DS.B	20480-13872
	DS.B	13872-3000
	DS.B	NB_STARS*6*2
BUF_STAR	;DS.B	NB_STARS*6*(768/VITESSE)

	ds.b 	230010-90912-4671-46960-36966
	DS.B	116000-87467
BUF_TEXT	DS.L	4000	36966
TABLE_ADR	DS.L	8*61
BUF1CRB2	DS.L	(2*640)+128
RIEN	DS.L	40*4
BUF_COD2	ds.b	12742
END_COD
	
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	

SAUV_SP:		ds.l 1
uusp:		ds.l 1
ad_ecran:	ds.l 1
ecran_gem:	ds.l 1
vbl_save:	ds.l 1
tb_save:	ds.l 1
vbl_sync:	ds.w 1
pal_save:	ds.w 16
res_save:	ds.w 1
mfp_save:	ds.w 1
SAVEA0	DS.L	1
lineA_tab:	ds.l 1
routs_pt:	ds.l 1
text_pt:	ds.l 1
text_buff_pt:	ds.l 1
ad_data_pt:	ds.l 1
PNT_261E	DS	1
SAVEA2	DS.L	1
SAVE	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
compteurs:	ds.w 2
ad_routines:	ds.l 5
text_buffer:	ds.b 150
text_buffer_deb	equ text_buffer+20
text_buffer_end:ds.l 1
PNT_FAD	DS.L	1
PNT_FAD2	DS.L	1
pntcolor	ds.l	1
off_bolean:	ds.b 500
EMUL_LINEA	DS.B	60
	DS.B	256
BUFFERSCR	DS.B	150*256*2
	ds.b	256


MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
MFP7	DS.B	1
MFP8	DS.B	1
MFP9	DS.B	1

SAVE_ALL	DS.L	16
PNT_REBOND	DS.L	1
ADDIT	DS.W	1
COLOR	DS	1
BUF_ACT_CRB	DS.L	1
ANNEX	DS.L	1
TABLE	DS.L	10
BUF16DA	DS.B	512
PtsFill:	ds.b	512
PLAN	DS.L	1
PNT_TXT	DS.L	1
PNT1	DS.L	1
NUMBER_WAVE	DS.L	1
PNT_W	DS.L	1
PNT_W2	DS.L	1
PNT_W3	DS.L	1
WAT	DS.L	1
COLONNE	DS	1
PNT_STR	DS.L	1
FLAG	DS.L	1
FLAG2	DS.L	1
MUS	DS.L	1
SAUVE_114	DS.L	1
FLAG_CAMEO	DS.L	1
FLAG_CAMEO2	DS.L	1
