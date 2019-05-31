;MODE=1 depack data from a0 to a0 
;MODE=0 depack data from a0 to a1 (RESTORE SPACE a 1 inutile! si MODE=0)
;PIC_ALGO = 0 decrunch file not encoded with special picture algorythm.
;PIC_ALGO = 1 decrunch all files with or without picture algorythm.
;DEC_SPACE = (lesser decrunch space is gived after packing by atomik v3.5)
;RESTORE_SPACE = 1 the allocated decrunch space will be restored .
;RESTORE_SPACE = 0 the allocated decrunch space will not be restored.

MODE:	EQU	0
PIC_ALGO:	EQU	1
DEC_SPACE:	EQU	$0002	 ;MAX IS $7FFE (no odd value!)
RESTORE_SPACE:	EQU	0
DEBUT:	
	LEA.L 	D_PILE,A7
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	
	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	CLR.W 	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP

	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1		
	add.l	#32000,d0		
	move.l	d0,SCREEN2

	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)
******
	LEA	GOKU_GêNêRê,A0
	MOVE	#199,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
GENERE	MOVE	D2,D1
	REPT	3
	MOVE.L	#$4CED1FFF,(A0)+
	MOVE	D1,(A0)+
	MOVE.L	#$48EE1FFF,(A0)+
	MOVE	D1,(A0)+
	ADD	#13*4,D1
	ENDR
	MOVE	#$2D6D,(A0)+
	MOVE	D1,(A0)+
	MOVE	D1,(A0)+
	ADD	#160,D2
	DBF	D0,GENERE
	MOVE	#$4E75,(A0)+

	LEA	PART4,A0
	LEA	BUFY,A1
	JSR	depack

	MOVEM.L	BUFY+2,D0-D7
	MOVEM.L	D0-D7,PAL_GOKU

	LEA	BUFY+34,A0
	LEA	BUF_GOKU,A1
	MOVE	#7999,D0
COP1	MOVE.L	(A0)+,(A1)+
	DBF	D0,COP1

	LEA	PART3,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	LEA	BUF_GOKU,A1
	LEA	32000(A1),A1
	MOVE	#7999,D0
COP2	MOVE.L	(A0)+,(A1)+
	DBF	D0,COP2

	LEA	PART2,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	LEA	BUF_GOKU,A1
	ADDA.L	#64000,A1
	MOVE	#7999,D0
COP3	MOVE.L	(A0)+,(A1)+
	DBF	D0,COP3

	LEA	PART1,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	LEA	BUF_GOKU,A1
	ADDA.L	#96000,A1
	MOVE	#7999,D0
COP4	MOVE.L	(A0)+,(A1)+
	DBF	D0,COP4
******
	MOVE	#199,D1
COP2Z	LEA	BUF_GOKU,A0
	MOVE	#40-1,D0
COP	MOVE.L	(A0)+,(A1)+
	DBF	D0,COP
	DBF	D1,COP2Z

	LEA	BUF_DEPART,A1
	MOVE	#59,D1
COP2B	LEA	BUF_GOKU,A0
	MOVE	#40-1,D0
COPB	MOVE.L	(A0)+,(A1)+
	DBF	D0,COPB
	DBF	D1,COP2B

	MOVE.L	#VBLR_IR,$70.W
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

WAITONS	TST	FLAG_GOKU
	BEQ.S	WAITONS
	LEA	PART5,A0
	LEA	BUF_GOKU,A1
	JSR	depack
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
	MOVE.L	SCREEN2,A0
	MOVE	#7999,D0
OUTY	CLR.L	(A0)+
	DBF	D0,OUTY
	LEA	BUF_GOKU+34,A0
	MOVE.L	SCREEN2,A1
	LEA	160*100+16(A1),A1
	MOVE	#12-1,D0
AFY	MOVE	#18-1,D1
AFX	MOVE	(A0),(A1)
	ADDQ	#8,A0
	ADDQ	#8,A1
	DBF	D1,AFX
	LEA	16(A0),A0
	LEA	16(A1),A1
	DBF	D0,AFY
	CLR	$FFFF8242.W
	move.l	SCREEN2,d0
	lsr.l	#8,d0
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
	MOVE.L	#VBL_GOKU3,$70.W
***
	LEA	PART6,A0
	LEA	BUF_GOKU,A1
	JSR	depack
	MOVE.L	SCREEN1,A0
	MOVE	#7999,D0
OUTY2	CLR.L	(A0)+
	DBF	D0,OUTY2
	LEA	BUF_GOKU+34,A0
	MOVE.L	SCREEN1,A1
	MOVE	#200-1,D0
AFY2	MOVE	#20-1,D1
AFX2	MOVE	(A0),(A1)
	ADDQ	#8,A0
	ADDQ	#8,A1
	DBF	D1,AFX2
	DBF	D0,AFY2

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.B	#$20,$FFFFFA07.W
	MOVE.B	$FFFFFA07.W,$FFFFFA13.W
	MOVE.B	$FFFFFA09.W,$FFFFFA15.W
	MOVE.L	#INTER_RTE,$134.W
	MOVE.B	#38*2+20,$FFFFFA1F.W
	MOVE.B	#1,$FFFFFA19.W
	MOVE.B	#$40,$FFFFFA17.W
	MOVE.L	#BEAT,BEAT1
	LEA	BEAT,A0
	MOVE.W	#((TEST_FIN-BEAT)/2)-1,D7
.CONT	MOVE.B	(A0),D0
	ADDI.B	#$80,D0
	MOVE.B	D0,(A0)+
	MOVE.B	(A0),D0
	ADDI.B	#$80,D0
	MOVE.B	D0,(A0)+
	DBRA	D7,.CONT
	LEA	BEAT,A0
	LEA	TEST_FIN,A1
	MOVE.W	#255,D7
.A	MOVE.B	(A0)+,(A1)+
	DBRA	D7,.A


	MOVE	#$2700,SR
	JSR	SOUNDOFF


	MOVE.L	BEAT1,A0
	MOVE.L	#PLAY_B,$134.W
	MOVE.L	#VBL_GOKU4,$70.W
	move.l	SCREEN1,d7
	lsr.l	#8,d7
	LEA	$FFFF8201.W,A6
	movep	d7,(a6)

	MOVE.W	#$8800,A1
	LEA	CODE,A2

	MOVE.W	#$2300,SR
	ST	$FFFF8242.W
BOUCLE	BRA.S	BOUCLE
VBL_GOKU4
	CMPA.L	#TEST_FIN,A0
	BLE.S	.NO
	LEA	BEAT,A0
	MOVE.L	#INTER_RTE,$134.W
	MOVE.L	#VBL_FINALE,$70.W
.NO	
	MOVE.W	#$8800,A1
	LEA	CODE,A2

	LEA	FAD_END,A6
MODFDEND	EQU	*+2
	LEA	0(A6),A6
	CMPI	#-1,(A6)
	BEQ.S	.OUT
	SUBQ	#1,BAZOUNGA
	BNE.S	.OUT
	MOVE	#20,BAZOUNGA
	ADDQ	#2,MODFDEND
	MOVE	(A6),$FFFF8242.W
.OUT	RTE
BAZOUNGA	DC	20
FAD_END	DC	$777,$667,$556,$445,$334,$223,$112,$000,-1
VBLR_IR
	CLR.B	$FFFFFA1B.W
	MOVEM.L	PAL_GOKU,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	SCREEN2,A6
	LEA	BUF_DEPART,A5
MOD_GOKU	EQU	*+2
	ADDA.L	#0,A5
	JSR	GOKU_GêNêRê	
	ADD.L	#160,MOD_GOKU

;	CMPI.L	#(61+200*4)*160,MOD_GOKU
	CMPI.L	#6*160,MOD_GOKU
	BNE.S	OKAY
	MOVE.L	#VBL_GOKU2,$70.W
OKAY	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2

	move.l	SCREEN1,d0
	lsr.l	#8,d0
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
INTER_RTE	RTE
TB0_IR	RTE
COMPTE	DC	0
FLAG_GOKU	DC	0
GOKU_PNT	DC	5
VBL_GOKU2
	LEA	FAD_GOKU,A0
MODFDGKU	EQU	*+2
	LEA	0(A0),A0
	CMPI	#-1,(A0)
	BEQ.S	.ROUL2
	SUBQ	#1,GOKU_PNT
	BNE.S	.ROUL
	MOVE	#5,GOKU_PNT
	MOVE	(A0),$FFFF825E.W
	ADDQ	#2,MODFDGKU
.ROUL
	RTE
.ROUL2	MOVE.L	#VBL_INTER,$70.W
	RTE
VBL_INTER	MOVE	#1,FLAG_GOKU
	RTE
SOUNDOFF
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE.W	#$8800,A0
	MOVEQ	#$A,D0
SET_YM1	MOVE.B	D1,(A0)	;ON REMET LES 10 REGISTRES SONORES A ZERO
	CLR.B	2(A0)
	ADDQ.W	#1,D1
	DBRA	D0,SET_YM1
	MOVE.B	#7,(A0)
	MOVE.B	#$FF,2(A0)
	RTS
VBL_GOKU3	

TRALALA	MOVE	#$777,$FFFF8242.W
	TST	TRALALA+2
	BEQ.S	.NOIR
	CLR	TRALALA+2
	RTE
.NOIR	MOVE	#$777,TRALALA+2
	RTE

VBL_FINALE	JSR	SOUNDOFF
	RTE

PLAY_B	;ST	$FFFF8240.W
	MOVEQ	#0,D0	;1
	MOVE.B	(A0)+,D0	;2
	LSL.W	#3,D0	;3
	MOVE.L	0(A2,D0.W),D1	;5
	MOVE.W	4(A2,D0.W),D2	;5
	MOVEP.L	D1,(A1)	;6
	MOVEP.W	D2,(A1)	;4     ;=26 NOPS
	;SF	$FFFF8240.W
	RTE	;5    ;=31 NOPS

FAD_GOKU
	DC	$752,$641,$530,$420,$310,$200,$100,$0,-1

FIN:	MOVE.L	4.W,A0
	JMP	(A0)

depack:	movem.l	d0-a6,-(a7)
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
	bsr	copy_decrun
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
PART1	INCBIN	GOKU_1.PAK
PART2	INCBIN	GOKU_2.PAK
PART3	INCBIN	GOKU_3.PAK
PART4	INCBIN	GOKU_4.PAK
PART5	INCBIN	WANTSOME.PAK
PART6	INCBIN	NO.PAK
BEAT1	DS.L	1
CODE	INCBIN	TABLEREP.BIN
BEAT	INCBIN	BOOM.SPL
TEST_FIN	DCB.B	256,0
 	SECTION BSS

F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	64000
BUFY	DS.B	33000
GOKU_GêNêRê	DS.B	8402
PAL_GOKU	DS.B	32
BUF_DEPART	DS.B	160*60
BUF_GOKU	DS.B	32000*4+32000