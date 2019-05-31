	OPT	O+,P+,A+
;Loader principal - Japtro

;MODE=1 depack data from a0 to a0 
;MODE=0 depack data from a0 to a1 (RESTORE SPACE a 1 inutile! si MODE=0)
;PIC_ALGO = 0 decrunch file not encoded with special picture algorythm.
;PIC_ALGO = 1 decrunch all files with or without picture algorythm.
;DEC_SPACE = (lesser decrunch space is gived after packing by atomik v3.5)
;RESTORE_SPACE = 1 the allocated decrunch space will be restored .
;RESTORE_SPACE = 0 the allocated decrunch space will not be restored.

MODE:	EQU	1
PIC_ALGO:	EQU	0
DEC_SPACE:	EQU	$0000	 *$80;MAX IS $7FFE (no odd value!)
RESTORE_SPACE:	EQU	0

*************************************************************************
	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE	#$2700,SR
	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	MOVE.B	#$1E,$FFFFFA07.W
	MOVE.B	#$64,$FFFFFA09.W
	MOVE.B	#$00,$FFFFFA0F.W
	MOVE.B	#$1E,$FFFFFA13.W
	MOVE.B	#$00,$FFFFFA1B.W
	MOVE.B	#$47,$FFFFFA21.W
	MOVE.B	#$64,$FFFFFA15.W
	MOVE.B	#$48,$FFFFFA17.W
	MOVE.B	#$00,$FFFFFA19.W
	MOVE.B	#$FF,$FFFFFA1F.W

	move.L	#$707FFFF,$fFFf8800.W
	move	#$2420,$ffff8604.w
	move.b	#$00,$ffff8609.w
	move.b	#$7b,$ffff860b.w
	move.b	#$c4,$ffff860d.w
	MOVE.B	#$3,$FFFFFC04.W
	MOVE.B	#$95,$FFFFFC04.W
	MOVE.B	#$3,$FFFFFC00.W
	MOVE.B	#$96,$FFFFFC00.W
	MOVE	#$C8,D0
E	NOP
	DBF	D0,E
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.B	#$12,$FFFFFC02.W

	LEA	RTE2Y(PC),A0
	MOVE.L	A0,$68.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$70.W
	BRA.S	UIUI
RTE2Y	RTE
UIUI
	LEA	$500.W,A1
	LEA	PRG,A0
	MOVE	#(140000/6),D0
PIPI	REPT	3
	MOVE.L	(A0)+,(A1)+
	ENDR
	DBF	D0,PIPI

	JMP	$500.W

*************************************************************************
;	JMP	POPO
PRG	

;	LEA	$A6000,A0
;	LEA	RTS,A1
;	REPT	5
;	MOVE.L	A1,(A0)+
;	ENDR
PRG2	BRA	DEBUT
;RTS	REPT	2*10
;	RTS
;	ENDR
D_PACK
	LEA	ADR_LOAD,A0
	movem.l	d0-a6,-(a7)
	cmp.l	#"ATM5",(a0)+
	bne	not_packed
	link	a2,#-28
	move.l	(a0)+,d0
	ifne	MODE
	lea	4(a0,d0.l),a5
	move.l	d0,-(a7)
	elseif
	move.l	a1,a5
	add.l	d0,a5
	endc
	move.l	a5,a4
	ifne	MODE
	ifne	DEC_SPACE
	lea	DEC_SPACE(a4),a5
	endc
	endc
	lea	-$c(a4),a4
	move.l	(a0)+,d0
	move.l	a0,a6
	add.l	d0,a6
	ifne	PIC_ALGO
	moveq	#0,d0
	move.b	-(a6),d0
	move	d0,-2(a2)
	ifne	RESTORE_SPACE
	lsl	#2,d0
	sub	d0,a4
	endc
	elseif
	ifne	RESTORE_SPACE
	clr	-2(a2)
	endc
	subq	#1,a6
	endc
	ifne	RESTORE_SPACE
	lea	buff_marg(pc),a3
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.save
.save_m:	move.b	(a4)+,(a3)+
	subq	#1,d0
.save:	bne.s	.save_m
	movem.l	a3-a4,-(a7)
	endc
	ifne	PIC_ALGO
	pea	(a5)
	endc
	move.b	-(a6),d7
	bra	take_type
decrunch:	move	d3,d5
take_lenght:	add.b	d7,d7
.cont_take:	dbcs	d5,take_lenght
	beq.s	.empty1
	bcc.s	.next_cod
	sub	d3,d5
	neg	d5
	bra.s	.do_copy1
.next_cod:	moveq	#3,d6
	bsr.s	get_bit2
	beq.s	.next_cod1
	bra.s	.do_copy
.next_cod1:	moveq	#7,d6
	bsr.s	get_bit2
	beq.s	.next_cod2
	add	#15,d5
	bra.s	.do_copy
.empty1:	move.b	-(a6),d7
	addx.b	d7,d7
	bra.s	.cont_take
.next_cod2:	moveq	#13,d6
	bsr.s	get_bit2
	add	#255+15,d5
.do_copy:	add	d3,d5
.do_copy1:	lea	decrun_table(pc),a4
	move	d5,d2
	bne.s	bigger
	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a6),d7
	addx.b	d7,d7
.not_empty:	bcs.s	.ho_kesako
	moveq	#1,d6
	bra.s	word
.ho_kesako:	moveq	#3,d6
	bsr.s	get_bit2
	tst.b	-28(a2)
	beq.s	.ho_kesako1
	move.b	10-28(a2,d5.w),-(a5)
	bra	tst_end
.ho_kesako1:	move.b	(a5),d0
	btst	#3,d5
	bne.s	.ho_kesako2
	bra.s	.ho_kesako3
.ho_kesako2:	add.b	#$f0,d5
.ho_kesako3:	sub.b	d5,d0
	move.b	d0,-(a5)
	bra	tst_end
get_bit2:	clr	d5
.get_bits:	add.b	d7,d7
	beq.s	.empty
.cont:	addx	d5,d5
	dbf	d6,.get_bits
	tst	d5
	rts
.empty:	move.b	-(a6),d7
	addx.b	d7,d7
	bra.s	.cont
bigger:	moveq	#2,d6
word:	bsr.s	get_bit2
contus:	move	d5,d4
	move.b	14(a4,d4.w),d6
	ext	d6
	tst.b	1-28(a2)
	bne.s	.spe_ofcod1
	addq	#4,d6
	bra.s	.nospe_ofcod1
.spe_ofcod1:	bsr.s	get_bit2
	move	d5,d1
	lsl	#4,d1
	moveq	#2,d6
	bsr.s	get_bit2
	cmp.b	#7,d5
	blt.s	.take_orof
	moveq	#0,d6
	bsr.s	get_bit2
	beq.s	.its_little
	moveq	#2,d6
	bsr.s	get_bit2
	add	d5,d5
	or	d1,d5
	bra.s	.spe_ofcod2
.its_little:	or.b	2-28(a2),d1
	bra.s	.spe_ofcod3
.take_orof:	or.b	3-28(a2,d5.w),d1
.spe_ofcod3:	move	d1,d5
	bra.s	.spe_ofcod2
.nospe_ofcod1:	bsr.s	get_bit2
.spe_ofcod2:	add	d4,d4
	beq.s	.first
	add	-2(a4,d4.w),d5
.first:	lea	1(a5,d5.w),a4
	move.b	-(a4),-(a5)
.copy_same:	move.b	-(a4),-(a5)
	dbf	d2,.copy_same
	bra.s	tst_end
make_jnk:	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a6),d7
	addx.b	d7,d7
.not_empty:	bcs.s	string
	move.b	-(a6),-(a5)
tst_end:	cmp.l	a5,a3
	bne.s	make_jnk
	cmp.l	a6,a0
	beq.s	work_done
take_type:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.nospe_ofcod
	move.b	-(a6),d0
	lea	2-28(a2),a1
	move.b	d0,(a1)+
	moveq	#1,d1
	moveq	#6,d2
.next:	cmp.b	d0,d1
	bne.s	.no_off_4b
	addq	#2,d1
.no_off_4b:	move.b	d1,(a1)+
	addq	#2,d1
	dbf	d2,.next
	st	1-28(a2)
	bra.s	.spe_ofcod
.nospe_ofcod:	sf	1-28(a2)
.spe_ofcod:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.relatif
	lea	10-28(a2),a1
	moveq	#15,d0
.next_f:	move.b	-(a6),(a1)+
	dbf	d0,.next_f
	st	-28(a2)
	bra.s	.freq
.relatif:	sf	-28(a2)
.freq:	clr	d3
	move.b	-(a6),d3
	move.b	-(a6),d0
	lsl	#8,d0
	move.b	-(a6),d0
	move.l	a5,a3
	sub	d0,a3
	bra.s	make_jnk
string:	bra	decrunch
work_done:
	ifne	PIC_ALGO
	move.l	(a7)+,a0
	pea	(a2)
	bsr.s	decod_picture
	move.l	(a7)+,a2
	endc
	ifne	RESTORE_SPACE
	movem.l	(a7)+,a3-a4
	endc
	ifne	MODE
	move.l	(a7)+,d0
	bsr.S	copy_decrun
	endc
	ifne	RESTORE_SPACE
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.restore
.restore_m:	move.b	-(a3),-(a4)
	subq	#1,d0
.restore:	bne.s	.restore_m
	endc
	unlk	a2
not_packed:	movem.l	(a7)+,d0-a6
 	rts
decrun_table:	dc.w	32,32+64,32+64+256,32+64+256+512,32+64+256+512+1024
	dc.w	32+64+256+512+1024+2048,32+64+256+512+1024+2048+4096
	dc.b	0,1,3,4,5,6,7,8
	ifne	PIC_ALGO
decod_picture:	move	-2(a2),d7
.next_picture:	dbf	d7,.decod_algo
	rts
.decod_algo:	move.l	-(a0),d0
	lea	0(a5,d0.l),a1
.no_odd:	lea	$7d00(a1),a2
.next_planes:	moveq	#3,d6
.next_word:	move	(a1)+,d0
	moveq	#3,d5
.next_bits:	add	d0,d0
	addx	d1,d1
	add	d0,d0
	addx	d2,d2
	add	d0,d0
	addx	d3,d3
	add	d0,d0
	addx	d4,d4
	dbf	d5,.next_bits
	dbf	d6,.next_word
	movem	d1-d4,-8(a1)
	cmp.l	a1,a2
	bne.s	.next_planes
	bra.s	.next_picture
	endc
	ifne	MODE
copy_decrun:	lsr.l	#4,d0
	lea	-12(a6),a6
.copy_decrun:	rept	4
	move.l	(a5)+,(a6)+
	endr
	dbf	d0,.copy_decrun
	rts
	endc
	ifne	RESTORE_SPACE
buff_marg:	dcb.b	$90+DEC_SPACE+$C
	endc

DEBUT	LEA	NEWPILE,A7
	MOVE	#$2700,SR

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.B	#2,$FFFF820A.W
	CLR.B	$FFFF8260.W
;	move.l	#$31415926,$426.W
;	MOVE.L	#PRG,$42A.W

	MOVE.B	#$1E,$FFFFFA07.W
	MOVE.B	#$64,$FFFFFA09.W
	MOVE.B	#$00,$FFFFFA0F.W
	MOVE.B	#$1E,$FFFFFA13.W
	MOVE.B	#$00,$FFFFFA1B.W
	MOVE.B	#$47,$FFFFFA21.W
	MOVE.B	#$64,$FFFFFA15.W
	MOVE.B	#$48,$FFFFFA17.W
	MOVE.B	#$00,$FFFFFA19.W
	MOVE.B	#$FF,$FFFFFA1F.W

	move.L	#$707FFFF,$fFFf8800.W
	move	#$2420,$ffff8604.w
	move.b	#$00,$ffff8609.w
	move.b	#$7b,$ffff860b.w
	move.b	#$c4,$ffff860d.w
	MOVE.B	#$3,$FFFFFC04.W
	MOVE.B	#$95,$FFFFFC04.W
	MOVE.B	#$3,$FFFFFC00.W
	MOVE.B	#$96,$FFFFFC00.W
	MOVE	#$C8,D0
.E	NOP
	DBF	D0,.E
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.B	#$12,$FFFFFC02.W

	LEA	PRG(PC),A0
	MOVE.L	A0,$008.W
	MOVE.L	A0,$00C.W
	MOVE.L	A0,$010.W
	MOVE.L	A0,$014.W
	MOVE.L	A0,$018.W
	MOVE.L	A0,$01C.W
	MOVE.L	A0,$020.W
	
	LEA	RTE2(PC),A0
	MOVE.L	A0,$68.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$70.W
	BRA.S	CONTINUE_GAIEMENT
RTE2	RTE

CONTINUE_GAIEMENT
POPO
	LEA	INTER_RTE,A0
	MOVE.L	A0,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
;	CLR.B	$FFFFFA13.W
;	CLR.B	$FFFFFA15.W

	MOVE.B	#$12,$FFFFFC02.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	ST	$FFFF8242.W
	LEA	VBL_INIT,A0
	MOVE.L	A0,$70.W
	LEA	TB_INIT,A0
	MOVE.L	A0,$120.W
	MOVE	#$2300,SR

	CMPI.B	#4,$FFFF8001.W
	BNE	GO_AHEAD
	LEA	FIRST_MES(PC),A1
	MOVE.L	SCREEN1,A2
	LEA	160*40(A2),A2
	BSR	AF_MES

	LEA	_520_(PC),A1
	MOVE.L	SCREEN1,A2
	LEA	160*80(A2),A2
	BSR	AF_MES
	CLR.L	$426.W
	CLR.L	$42A.W
STOP	BRA.S	STOP

_520_
 DC.B	"Sorry, but you ABSOLUTELY NEED at least "
 dc.b	"     one megabyte to see this demo.     "
 dc.b	"                                        "
 dc.b	"    EH KEOPS! GO AND BUY XTRA RAM !!    "
 dc.b	"                                        "
 dc.b	"Since we are extremely cool coders, the "
 dc.b	"sources files of this demo are available"
 dc.b	"       from your local swapper...       "
 dc.b	"                                        "
 dc.b	"            To contact us:              "
 dc.b	"               3614 RTEL1               "
 dc.b	"    Bals Zappy, Elric-HC or Holocaust   ",-1

FIRST_MES	
	DC.B	"                 JAPTRO                 "
	DC.B	"           ( Japanese Dentro )          "
	dc.b	"                                        "
	dc.b	"            Holocaust  - 1993           ",-1
	EVEN
SECOND_MES	DC.B	"         This is an STF/STE demo.       ",-1
	EVEN
GO_AHEAD
	opt	o+,a+,p+
	LEA	ADR_END(PC),A0
	opt	o-,a-,p-
	LEA	$FFFF0,A1
	opt	o+,a+,p+
GOGO	CLR.L	(A0)+
	CMP.L	A1,A0
	BLE.S	GOGO

	OPT	O-,P-,A-
	LEA	$9E200,A0
	OPT	O+,P+,A+
	move.l	A0,d0
	CLR.B	D0
	LEA	SCREEN1,A0
	move.l	d0,(A0)
	MOVE.L	SCREEN1,A0
	BSR	EFF_ECR

	move.l	SCREEN1,d0
	lsr.l	#8,d0		
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)

	LEA	FIRST_MES(PC),A1
	MOVE.L	SCREEN1,A2
	LEA	160*40(A2),A2
	BSR.S	AF_MES

	LEA	SECOND_MES(PC),A1
	MOVE.L	SCREEN1,A2
	LEA	160*80(A2),A2
	BSR.S	AF_MES

GATO
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D7
	LEA	DATAS_FILES(PC),A0
	OPT	O-,P-,A-
NUM_DEM	EQU	*+2
	MOVE.L	#0,D3
	OPT	O+,A+,P+
	LSL	#3,D3
	ADD.L	D3,A0
	MOVE	(A0)+,D7	DISK1=0  2=1

	MOVE	(A0)+,D0	FACE
	MOVE	(A0)+,D1	PISTE
	MOVEQ	#0,D2
	MOVE	(A0)+,D2	SECT
	JSR	TRACK_LOADING
	LEA	INTER_RTE,A0
	MOVE.L	A0,$70.W
	MOVE.L	A0,$120.W
	SF	$FFFF8242.W

	JSR	D_PACK
;	CMPI.L	#9,NUM_DEM
;	BEQ.S	NOREL
	JSR	RELOC
NOREL	MOVE	#$2300,SR

	LEA	RET(PC),A0
	LEA	ZIK(PC),A1

	BRA	ADR_LOAD

RET	LEA	NUM_DEM,A0
	ADDQ.L	#1,(A0)
	BRA.S	GATO
ZIK	;BSR	Z1
	RTS
	RTS
	RTS
	RTS
	RTS
	RTS
	RTS
	RTS
	;BSR	Z2
	RTS
;Z1	MOVEM.L	D0-A6,-(SP)
;	MOVEQ	#0,D0
;	BSR	Z
;	MOVEM.L	(SP)+,D0-A6
;	RTS
;Z2	MOVEM.L	D0-A6,-(SP)
;	BSR	Z+4
;	MOVEM.L	(SP)+,D0-A6
;	RTS
;Z	INCBIN	FOFT.MUS

AF_MES	MOVE	#(40/2)-1,D7
.DO_A_Y
	moveq	#0,d5
	LEA	FONT8_8,A3
	LEA	FONT8_8,A4
	MOVE.B	(A1)+,D5
	SUBI.B	#32,D5
	LSL	#3,D5
	ADDA.L	D5,A3
	moveq	#0,d5
	MOVE.B	(A1)+,D5
	SUBI.B	#32,D5
	LSL	#3,D5
	ADDA.L	D5,A4
	MOVEQ	#7,D6

.DO_A_X	LEA	MOD_AF1,A6
	MOVE.B	(A3)+,(A6)
	LEA	MOD_AF2,A6
	MOVE.B	(A4)+,(A6)
MOD_AF1	EQU	*+2
MOD_AF2	EQU	*+3
	MOVE	#0,(A2)
	LEA	160(A2),A2
	DBF	D6,.DO_A_X
	LEA	-160*8+8(A2),A2
	DBF	D7,.DO_A_Y
	LEA	7*160(A2),A2
	CMPI.B	#-1,(A1)
	BNE.S	AF_MES
	RTS

* A0 = ADRESSE DE CHARGEMENT
* A1 = SAUVEGARDE ADRESSE DE LANCEMENT DU PROGRAMME
* A6 = ADRESSE DMA
* D0 = COMPTEUR DE SECTEUR
* D1 = COMPTEUR DE PAUSE ET TRANSFERT DE DONNEE DANS LE BUFFER
* D2 = REGISTRE POUR COMMANDE DMA
* D3 = REGISTRE POUR VALEUR DMA

TRACK_LOADING	LEA	AJOUT,A0
	CLR.L	(A0)
	LEA	FACE(PC),A0
	MOVE	D0,(A0)
	LEA	PISTE(PC),A1
	LEA	PISTE2(PC),A2
	MOVE	D1,(A1)
	MOVE	D1,(A2)
	LEA	NB_SECT(PC),A0
	CMPI.L	#10,D2
	BLE.S	PAS_PLUS_DE_10
	MOVE.L	D2,D3
	DIVS	#10,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVE	D3,D4	NB * 10 SECT A LIRE
	SWAP	D3
	MOVE	D3,D5	ET RESTE
	SUBQ.L	#1,D4
AGAIN	
	MOVEM.L	D4/A0-A2,-(SP)
	MOVE	#10,(A0)
	JSR	LOADING
	LEA	AJOUT(PC),A3
	ADD.L	#512*10,(A3)
	MOVEM.L	(SP)+,D4/A0-A2
	ADDQ	#1,(A1)
	ADDQ	#1,(A2)
;r	cmpi.b	#$39,$fffffc02.w
;	bne.s	r
;e	cmpi.b	#$39,$fffffc02.w
;	beq.s	e
	DBF	D4,AGAIN
	TST.L	D3
	BEQ.S	FINI
	TST	D5
	BEQ.S	FINI
	MOVE	D5,(A0)
	JSR	LOADING
	BRA.S	FINI
PAS_PLUS_DE_10	MOVE	D2,(A0)
	JSR	LOADING
FINI	RTS

LOADING
;	lea	ADR_LOAD.W,a0
	LEA	ADR_LOAD,A0
AJOUT	EQU	*+2
	ADDA.L	#0,A0
	movea.l	a0,a1
	lea	$FFFF8604.W,a6
	st	$43E.W
	moveq	#0,d0
FACE	EQU	*+2
	move	#0,D1
	bsr	Set_drive
Tracks:	move.w	#$86,d2
PISTE	EQU	*+2
	move.w	#0,d3
	bsr.S	WD_write
	move.w	#$80,d2
	moveq	#%00010001,d3
	bsr.s	WD_write
Wait_Tracks:	bsr.S	Wait_done
	moveq	#0,d0
CHARGE:	move.l	a0,d1
	move.b	d1,$FFFF860D.W
	lsr.l	#8,d1
	move.b	d1,$FFFF860B.W
	lsr.l	#8,d1
	move.b	d1,$FFFF8609.W
DMA_in:	move.w	#$90,2(a6)
	move.w	#$190,2(a6)
	move.w	#$90,d2
	moveq	#1,d3
	bsr.s	WD_write
	move.w	#$82,d2
PISTE2	EQU	*+2
	move.w	#0,d3
	bsr.s	WD_write
	addq.w	#1,d0
	move.w	#$84,d2
	move.w	d0,d3
	bsr.s	WD_write
	move.w	#$80,d2
	move.w	#%10000000,d3
	bsr.s	WD_write
	bsr.s	Wait_done
	adda.l	#512,a0
NB_SECT	EQU	*+2
	cmpi.w	#0,d0
	bne.s	CHARGE
	move.b	#7,d0
	bsr.s	Select
	sf	$43E.W
	movea.l	a1,a0
	RTS
;	jmp	(a0)
WD_write:	move.w	d2,2(a6)
	move.w	d3,(a6)
Attend:	moveq	#40,d1
Attend1:dbf	d1,Attend1
	rts
Wait_done:	bsr.s	Attend
Wait:	btst	#5,$FFFFFa01.W
	bne.s	Wait
	rts
;Set_drive:	moveq	#5,d0
;Select:	move.w	sr,-(a7)
;	ori.w	#$700,sr
;	move.b	#$e,$ffFF8800.W
;	move.b	$ffFF8800.W,d1
;	andi.b	#$f8,d1
;	or.b	d0,d1
;	move.b	d1,$ffFF8802.W
;	move.w	(a7)+,sr
;	rts
Set_drive:
	move.w	d0,d4
	cmpi.w	#1,d0
	bgt.s	End_set
	addq.b	#1,d4
	lsl.b	#1,d4
	or.w	d1,d4
	eori.b	#7,d4
	andi.b	#7,d4
	MOVE.L	D4,D0
;	moveq	#5,d0		Selectionner le drive A	
Select:	move.w	sr,-(a7)
	ori.w	#$700,sr
	move.b	#$e,$fFFf8800.W
	move.b	$fFFf8800.W,d1
	andi.b	#$f8,d1
	or.b	d0,d1
	move.b	d1,$fFFf8802.W
	move.w	(a7)+,sr
End_set	rts

RELOC
	LEA	ADR_LOAD,A0
	MOVE.L	A0,A1
	ADD.L	2(A0),A1
	ADD.L	6(A0),A1
	LEA	31(A1),A1
	MOVEQ	#0,D0
	
	LEA	ADR_LOAD+28,A0
	MOVE.L	A0,D1
	
RELOCATION	MOVE.B	(A1)+,D0
	BEQ.S	RELOC_END
	CMP.W	#1,D0
	BNE.S	RELOC1
	ADD.W	#254,A0
	BRA.S	RELOCATION
RELOC1	ADD.W	D0,A0
	ADD.L	D1,(A0)
	BRA.S	RELOCATION
RELOC_END	RTS

	DATA
DATAS_FILES
*INTRO: EXPLOSION
	DC	0	DISK
	DC	0	FACE
	DC	1	PISTE DE DEPART
	DC	200	NB SECT A LIRE
*INTRO:PART 1
	DC	0
	DC	0
	DC	21
	DC	304

	TEXT
VBL_INIT
	SF	$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	A5,-(SP)
	LEA	DêGRADê(PC),A5
	MOVE.L	A5,USP
	MOVE.L	(SP)+,A5
INTER_RTE	RTE
TB_INIT	CLR.B	$FFFFFA1B.W
	MOVE.L	A5,-(SP)
	MOVE.L	USP,A5
	MOVE	(A5)+,$FFFF8242.W
	MOVE.L	A5,USP
	MOVE.L	(SP)+,A5
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE
DêGRADê
	REPT	25
	DC	$667,$556,$445,$334,$223,$112,$002,$000
	ENDR

;TIMER_B	MOVE	#$001,$FFFF8240.W
;	MOVE	#$777,$FFFF8242.W
;	CLR.B	$FFFFFA1B.W
;	MOVE.B	#8,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB2,$120.W
;	BCLR	#0,$FFFFFA0F.W
;	RTE

EFF_ECR	MOVE	#7999,D7
.EFF	CLR.L	(A0)+
	DBF	D7,.EFF
	RTS

	SECTION	DATA

	*	"****************************************"

;	dc.b	"                                        "

FONT8_8
font:   	dc.l	$00000000,$00000000,$00181818,$18001800,$00666666 
	dc.l	$00000000,$0066FF66,$66FF6600,$183E603C,$067C1800 
	dc.l	$00666C18,$30664600,$1C361C38,$6F663B00,$00181818 
	dc.l	$00000000,$000E1C18,$181C0E00,$00703818,$18387000 
	dc.l	$00663CFF,$3C660000,$0018187E,$18180000,$00000000 
	dc.l	$00181830,$0000007E,$00000000,$00000000,$00181800 
	dc.l	$00060C18,$30604000,$003C666E,$76663C00,$00183818 
	dc.l	$18187E00,$003C660C,$18307E00,$007E0C18,$0C663C00 
	dc.l	$000C1C3C,$6C7E0C00,$007E607C,$06663C00,$003C607C 
	dc.l	$66663C00,$007E060C,$18303000,$003C663C,$66663C00 
	dc.l	$003C663E,$060C3800,$00001818,$00181800,$00001818 
	dc.l	$00181830,$060C1830,$180C0600,$00007E00,$007E0000 
	dc.l	$6030180C,$18306000,$003C660C,$18001800,$003C666E 
	dc.l	$6E603E00,$00183C66,$667E6600,$007C667C,$66667C00 
	dc.l	$003C6660,$60663C00,$00786C66,$666C7800,$007E607C 
	dc.l	$60607E00,$007E607C,$60606000,$003E6060,$6E663E00 
	dc.l	$0066667E,$66666600,$007E1818,$18187E00,$00060606 
	dc.l	$06663C00,$00666C78,$786C6600,$00606060,$60607E00 
	dc.l	$0063777F,$6B636300,$0066767E,$7E6E6600,$003C6666 
	dc.l	$66663C00,$007C6666,$7C606000,$003C6666,$666C3600 
	dc.l	$007C6666,$7C6C6600,$003C603C,$06063C00,$007E1818 
	dc.l	$18181800,$00666666,$66667E00,$00666666,$663C1800 
	dc.l	$0063636B,$7F776300,$0066663C,$3C666600,$0066663C 
	dc.l	$18181800,$007E0C18,$30607E00,$001E1818,$18181E00 
	dc.l	$00406030,$180C0600,$00781818,$18187800,$00081C36 
	dc.l	$63000000,$00000000,$0000FF00,$00183C7E,$7E3C1800 
	dc.l	$00003C06,$3E663E00,$0060607C,$66667C00,$00003C60 
	dc.l	$60603C00,$0006063E,$66663E00,$00003C66,$7E603C00 
	dc.l	$000E183E,$18181800,$00003E66,$663E067C,$0060607C 
	dc.l	$66666600,$00180038,$18183C00,$00060006,$0606063C 
	dc.l	$0060606C,$786C6600,$00381818,$18183C00,$0000667F 
	dc.l	$7F6B6300,$00007C66,$66666600,$00003C66,$66663C00 
	dc.l	$00007C66,$667C6060,$00003E66,$663E0606,$00007C66 
	dc.l	$60606000,$00003E60,$3C067C00,$00187E18,$18180E00 
	dc.l	$00006666,$66663E00,$00006666,$663C1800,$0000636B 
	dc.l	$7F3E3600,$0000663C,$183C6600,$00006666,$663E0C78 
	dc.l	$00007E0C,$18307E00,$00183C7E,$7E183C00,$18181818 
	dc.l	$18181818,$007E787C,$6E660600,$08183878,$38180800 
	even

	BSS
	DS.L	256
NEWPILE	DS.L	1
SCREEN1	DS.L	1
ADR_END
ADR_LOAD	DS.B	110000
;	DS.B	256
;BUFFER	DS.B	32000