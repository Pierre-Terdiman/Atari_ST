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

*****
;A1 = pointeur sur les donnÇes
;A2 = pointeur sur les flags pour les offsets
;A0 = pointeur sur le buffer destination
;D7 = comme pour le compactage
;D1 = offset courant pour la construction du code
;D6 = incrÇment de D1

	OPT	O+,W-

MAIN	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	LEA	DONNEES,A0
	JSR	D_PACK
	LEA	OFFSETS,A0
	JSR	D_PACK
	
	LEA	DONNEES,A1
	LEA	OFFSETS,A2
	LEA	BUFCOD,A0
	MOVEQ	#7,D7
ANEW	MOVEQ	#6,D1
	REPT	8
	MOVE.L	(A1)+,(A0)+
	ENDR
BOUCLE	BTST	D7,(A2)
	BNE	BIT_ALLUMê
** 1ER BIT NUL **
	JSR	NEXT_BIT
	BTST	D7,(A2)
	BNE	BIT2_ALLUMê
** ICI = 2 BITS NULS SE SUIVAIENT **
;	JSR	NEXT_BIT
	ADD	#16,D1
	BRA	TST_FIN_ECRAN

** ICI = 1ER BIT NUL, 2EME BIT ALLUMê **
BIT2_ALLUMê	
	ADDQ	#2,D1	PLAN 1
	MOVE	#8+6,D6
RACCORD	MOVE	(A1)+,D0
	BEQ	CODE_DU_CLR_W
	CMPI	#$3140,D0
	BLT	C_EST_UNE_BETE_DONNEE
	CMPI	#$3147,D0
	BLE	CODE_DES_MOVE_DN
C_EST_UNE_BETE_DONNEE
;	CMPI	#8+6,D6
;	BEQ.S	C_EST_BIEN_UNE_DONNEE    VOIRE TEST MOVE L
	CMPI	#$2140,D0
	BLT	C_EST_BIEN_UNE_DONNEE
	CMPI	#$2147,D0
	BGT	C_EST_BIEN_UNE_DONNEE
_MOVE_L	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN
C_EST_BIEN_UNE_DONNEE
	MOVE	#$317C,(A0)+
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN
CODE_DES_MOVE_DN
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN
CODE_DU_CLR_W	
	MOVE	#$4268,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN

**BIT 1 ALLUMê
BIT_ALLUMê	JSR	NEXT_BIT
	BTST	D7,(A2)
	BNE	DEUX_BITS_ALLUMêS
** ICI = 1ER BIT ALLUMê, 2EME BIT NUL **
	MOVE	#16,D6
	BRA	RACCORD	OK???????????????

**************************** 2 BITS A 1 ********************************

DEUX_BITS_ALLUMêS
	TST.L	(A1)
	BEQ	_CLR_L
	TST	(A1)
	BEQ	_CLR_W
**TST MOVE_L A VIRER A LA FIN **
	CMPI	#$2140,(A1)
	BLT	NON
	CMPI	#$2147,(A1)
	BGT	NON
SI 	;ICI=MOVE.L BIZARRE
	MOVE	#$070,$FFFF8240.W
	BRA.S	SI
NON	CMPI	#$3140,(A1)
	BLT	NON2
	CMPI	#$3147,(A1)
	BGT	NON2
;MOVE 1ER BIT
	MOVE	(A1)+,(A0)+
	MOVE	D1,(A0)+
	ADDQ	#2,D1
	MOVE	#14,D6
	BRA	RACCORD
NON2	
	;DONNEE	CLR	=> MOVE.L
	;DONNEE	DONNEE	=> MOVE.L
	;DONNEE	MOVE	=> RACCORD

	CMPI	#$2140,2(A1)
	BLT	SUIT
	CMPI	#$2147,2(A1)
	BGT	SUIT
PB	
	MOVE	#$007,$FFFF8240.W
	BRA.S	PB
SUIT	CMPI	#$3140,2(A1)
	BLT	_MOVEL
	CMPI	#$3147,2(A1)
	BGT	_MOVEL
	MOVE	#$317C,(A0)+
	MOVE	(A1)+,(A0)+
	MOVE	D1,(A0)+
	ADDQ	#2,D1
	MOVE	#14,D6
	BRA	RACCORD

_MOVEL	MOVE	#$217C,(A0)+
	MOVE.L	(A1)+,(A0)+
	MOVE	D1,(A0)+
	ADD	#16,D1
	BRA	TST_FIN_ECRAN
	
_CLR_L	ADDQ	#4,A1
	MOVE	#$42A8,(A0)+
	MOVE	D1,(A0)+
	ADD	#16,D1
	BRA	TST_FIN_ECRAN
_CLR_W	ADDQ	#2,A1
	MOVE	#$4268,(A0)+
	MOVE	D1,(A0)+
	ADDQ	#2,D1
	MOVE	#14,D6
	BRA	RACCORD
NEXT_BIT
	SUBQ	#1,D7
	BGE	YY2
	MOVEQ	#7,D7
	ADDQ	#1,A2
YY2	RTS

TST_FIN_ECRAN
	CMPI	#31990+16,D1
	BEQ.S	FIN_ECRAN
	JSR	NEXT_BIT
	BRA	BOUCLE
FIN_ECRAN	MOVE	#$4E75,(A0)+
	JSR	NEXT_BIT
	CMPI.L	#$99999999,(A1)
	BEQ.S	TERMINê
	BRA	ANEW
TERMINê	MOVE.L	#$99999999,(A0)
	NOP
	NOP
	;BRA.S	TERMINê

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	move.w	#5,-(sp)
	trap	#14
	lea.l	12(sp),sp

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	MOVEQ	#0,D0
	LEA	BUFCOD,A0
	LEA	CHAISE,A1
	MOVE.L	A0,(A1)+
LM	MOVE	(A0)+,D0
	CMPI	#$4E75,D0
	BNE.S	LM
	CMPI.L	#$99999999,(A0)
	BEQ.S	FINITED
	MOVE.L	A0,(A1)+
	BRA.S	LM
FINITED
	JSR	SET_SCR
*0000	40
*0001	42
*0010	44
*0011	46
*0100	48*
*0101	4A*
*0110	4C*
*0111	4E*
*1000	50
*1001	52
*1010	54
*1011	56
*1100	58*
*1101	5A*
*1110	5C*
*1111	5E*
*********
DO_IT_AGAIN	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W

	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	JSR	EFF
	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	LEA	IMG+34,A2
	MOVE	#7999,D0
COPY	MOVE.L	(A2),(A0)+
	MOVE.L	(A2)+,(A1)+
	DBF	D0,COPY
	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	MOVE	#3999,D0
COPYIMG	MOVE	#$FFFF,6(A0)
	MOVE	#$FFFF,6(A1)
	ADDQ.L	#8,A0
	ADDQ.L	#8,A1
	DBF	D0,COPYIMG
	MOVEM.L	IMG+2,D0-D3
	MOVEM.L	D0-D3,$FFFF8240.W
	MOVE.L	#$00000544,$FFFF8250.W
	MOVE.L	#$05220411,$FFFF8254.W
	MOVE.L	#$03000300,$FFFF8258.W
	MOVE.L	#$05330100,$FFFF825C.W

	LEA	DONNEES,A0
	JSR	EFF2

	LEA	CHAISE,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D7
;	MOVE.L	SCREEN1,A0
	LEA	DONNEES,A0
	JSR	8*4(A1)
;	MOVE.L	SCREEN2,A0
;	JSR	8*4(A1)
	
	LEA	CHAISE+4,A1
	MOVE.L	A1,SAVEA1
	MOVE	#$2300,SR
WAIT	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	WAIT
	MOVE.L	#VBL_IR,$70.W
KOKO
J	BRA.S	J
	MOVE	#$60FE,KOKO
	BRA	DO_IT_AGAIN
SAVEA1	DC.L	0
VBL_IR	CLR.B	$FFFFFA1B.W
;	MOVEM.L	IMG+2,D0-D3
;	MOVEM.L	D0-D3,$FFFF8250.W
	MOVEM.L	IMG+2,D0-D3
	MOVEM.L	D0-D3,$FFFF8240.W

	MOVE.L	#$00000544,$FFFF8250.W
	MOVE.L	#$05220411,$FFFF8254.W
	MOVE.L	#$03000300,$FFFF8258.W
	MOVE.L	#$05330100,$FFFF825C.W

	MOVE.L	SAVEA1,A1
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIM
	ST	$FFFF8240.W
NO_TIM	
	MOVE.L	(A1)+,A2
	CMPI.L	#0,-4(A1)
	BNE.S	ROUL
	MOVE.L	#RTE,$70.W
	MOVE	#$4E71,KOKO
	RTE
	LEA	CHAISE,A1
	MOVE.L	(A1)+,A2
ROUL	MOVEM.L	(A2),D0-D7
	MOVE.L	SCREEN1,A0
	LEA	DONNEES,A0
	JSR	8*4(A2)
;	MOVE.L	SCREEN2,A0
;	JSR	8*4(A2)
	MOVE.L	A1,SAVEA1

	LEA	DONNEES,A2
	MOVE.L	SCREEN2,A3
;	MOVE.L	SCREEN1,A2
;	MOVE.L	SCREEN2,A3
	ADDQ.L	#6,A3
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

	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	SF	$FFFF8240.W
RTE	RTE
FIN:	MOVE.L	4.W,A0
	JMP	(A0)

EFF	move.l	SCREEN1,a0
EFF2	MOVE	#7999,D0
HA	CLR.L	(A0)+
	DBF	D0,HA
	RTS	

SET_SCR:	move.l	#BUFFERSCR,d0	
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0		
	move.l	d0,SCREEN2
	rts				

D_PACK
;	LEA	ADR_LOAD,A0
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
	DATA
FLAG	DC.L	0
IMG	INCBIN	B:\GOKU_F1.PI1
DONNEES	INCBIN	XP1B.DAT	147662
	DS.B	147674-(*-DONNEES)
OFFSETS	INCBIN	XP2B.DAT	60002
	DS.B	60002-(*-OFFSETS)
	BSS
SCREEN2	DS.L	1
SCREEN1	DS.L	1
	
	DS.B	256
BUFFERSCR	DS.B	64000
CHAISE	DS.L	200

BUFCOD	DS.B	363000
