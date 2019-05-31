;MODE=1 depack data from a0 to a0 
;MODE=0 depack data from a0 to a1 (RESTORE SPACE a 1 inutile! si MODE=0)
;PIC_ALGO = 0 decrunch file not encoded with special picture algorythm.
;PIC_ALGO = 1 decrunch all files with or without picture algorythm.
;DEC_SPACE = (lesser decrunch space is gived after packing by atomik v3.5)
;RESTORE_SPACE = 1 the allocated decrunch space will be restored .
;RESTORE_SPACE = 0 the allocated decrunch space will not be restored.

MODE:	EQU	0
PIC_ALGO:	EQU	0
DEC_SPACE:	EQU	$0	 ;MAX IS $7FFE (no odd value!)
RESTORE_SPACE:	EQU	0



	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	LEA	DATA_HS,A0
	MOVE.L	A0,POIT
		
	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1

	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
******
	LEA	IMG,A0
	LEA	BUFPAK,A1
	JSR	depack

	MOVE.L	SCREEN1,A1
	LEA	1600(A1),A1
	LEA	BUFPAK,A0
	LEA	56*480(A0),A2
	LEA	56*480(A2),A3
	LEA	56*480(A3),A4
	MOVE	#480-1,D1
G2
	MOVE.L	A1,A5
	MOVE	#28-1,D0
H2Z	MOVE	(A0)+,(A1)+
	MOVE	(A2)+,(A1)+
	MOVE	(A3)+,(A1)+
	MOVE	(A4)+,(A1)+
	
	;MOVE.L	(A1)+,(A0)+
	;MOVE.L	(A1)+,(A0)+
	DBF	D0,H2Z
	LEA	230(A5),A1
	DBF	D1,G2

******
TEST
	TST.L	$5A0.W
	BEQ.S	.STF
	MOVE.L	#PALETTE2,MODPAL1+2
	MOVE.L	#PALETTE1,MODPAL2+2
.STF
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	MOVE.L	#VBLR_IR,$70.W
	MOVE.L	#TB0_IR,$120.W

	MOVE.B	#$12,$FFFFFC02.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	BRA.S	BOUCLE

VBLR_IR
	CLR.B	$FFFFFA1B.W
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W

	TST	FLAG
	BNE.S	RR
MODPAL1	LEA	PALETTE1,A0
MODDEG2	LEA	0(A0),A0
	CMPI	#-1,-32(A0)
	BEQ.S	.NON2
	SUBI	#1,CNTFAD
	BNE.S	.NON
	MOVE	#5,CNTFAD
	ADD	#-32,MODDEG2+2
.NON
.NON2
	BRA.S	EE
RR
MODPAL2	LEA	PALETTE2,A0
MODDEG1	LEA	0(A0),A0
	CMPI	#-1,-32(A0)
	BEQ.S	.NON2
	SUBI	#1,CNTFAD
	BNE.S	.NON
	MOVE	#5,CNTFAD
	ADD	#-32,MODDEG1+2
.NON
.NON2
EE	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	.STF
	MOVE	#1,FLAG
.STF	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	.STE
	CLR	FLAG
.STE
INTER_RTE	RTE
FLAG	DC	0
CNTFAD	DC	5
	DCB	16,-1
PALETTE1B
	DC	$000,$001,$111,$212,$222,$323,$333,$434
	DC	$444,$545,$555,$656,$666,$767,$777,$777
	DC	$000,$000,$000,$101,$111,$212,$222,$323
	DC	$333,$434,$444,$545,$555,$656,$666,$666
	DC	$000,$000,$000,$000,$000,$101,$111,$212
	DC	$222,$323,$333,$434,$444,$545,$555,$555
	DC	$000,$000,$000,$000,$000,$000,$000,$101
	DC	$111,$212,$222,$323,$333,$434,$444,$444
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$101,$111,$212,$222,$323,$333,$333
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$101,$111,$212,$222,$222
PALETTE1	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$000,$000,$101,$111,$111
	DCB	16,0
	DCB	16,-1
PALETTE2B
	DC	$000,$888,$111,$999,$222,$AAA,$333,$BBB
	DC	$444,$CCC,$555,$DDD,$666,$EEE,$777,$FFF
	DC	$000,$000,$000,$888,$111,$999,$222,$AAA
	DC	$333,$BBB,$444,$CCC,$555,$DDD,$666,$EEE
	DC	$000,$000,$000,$000,$000,$888,$111,$999
	DC	$222,$AAA,$333,$BBB,$444,$CCC,$555,$DDD
	DC	$000,$000,$000,$000,$000,$000,$000,$888
	DC	$222,$999,$222,$AAA,$333,$BBB,$444,$CCC
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$111,$888,$111,$999,$222,$AAA,$333,$BBB
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$888,$111,$999,$222,$AAA
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$000,$000,$888,$111,$999
	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$000,$000,$000,$000,$888
PALETTE2	DC	$000,$000,$000,$000,$000,$000,$000,$000
	DC	$000,$000,$000,$000,$000,$000,$000,$000


INTER_TMA:	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR
full
	LEA	$FFFF8209,A3
	LEA	$FFFF8260,A6
	LEA	$FFFF820A,A5

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100
	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D2
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D0,(A5)
	REPT	6
	NOP
	ENDR
	MOVE.B	D1,(A5)

*******

	MOVEA.L	POIT,A2

	MOVE.L	#$FFFF8209,A6
	MOVE.L	#$FFFF8260,A4
	MOVE.L	#$FFFF820A,A3
	MOVEQ	#0,D1		
	MOVEQ	#$10,D6
	MOVE.L	#228-12+2-1-1-1,D0

SYNCHRO	MOVE.B	(A6),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		
	DCB	97-3-4,$4E71

	REPT	9
	MOVE.L	(A2)+,A1	*3
	JSR	(A1)	*4
	ENDR
	
	DCB	7-1,$4E71
	MOVEQ	#42-1,D1

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13-12,$4E71
	MOVE.L	(A0)+,$FFFF8240.W	6
	MOVE.L	(A0)+,$FFFF8244.W	6
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-6,$4E71
	MOVE.L	(A0)+,$FFFF8248.W	6

	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88-5*6-2,$4E71
	MOVE.L	(A0)+,$FFFF824C.W
	MOVE.L	(A0)+,$FFFF8250.W
	MOVE.L	(A0)+,$FFFF8254.W
	MOVE.L	(A0)+,$FFFF8258.W
	MOVE.L	(A0)+,$FFFF825C.W
	LEA	-32(A0),A0
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-1,$4E71

FULLSCREEN	NOP
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71
	DBF	D0,FULLSCREEN

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	;	ICI=116	NOPS

	CLR.B	$FFFF820A.W 
	DCB	8,$4E71

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	MOVE	A4,(A3)
	DCB	88-2,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-1,$4E71
	
.F	NOP
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4,$4E71
	DBF	D1,.F
SUITE
	CMPI.B	#$50,$FFFFFC02.W
	BNE.S	PAS_HAUT
	CMPI.L	#230*400,Y_VALUE
	BEQ.S	PAS_HAUT
	ADD.L	#230,Y_VALUE
PAS_HAUT	CMPI.B	#$48,$FFFFFC02.W
	BNE.S	PAS_BAS
	TST.L	Y_VALUE
	BEQ.S	PAS_BAS
	SUB.L	#230,Y_VALUE
PAS_BAS
	CMPI.B	#$4B,$FFFFFC02.W
	BNE.S	PAS_GA
	ADDQ.L	#8,Y_VALUE
PAS_GA	CMPI.B	#$4D,$FFFFFC02.W
	BNE.S	PAS_DR
	SUBQ.L	#8,Y_VALUE
PAS_DR
	MOVEQ	#0,D0	
	MOVEQ	#0,D1
	MOVE.L	Y_VALUE,D0
	
	LSR.L	#8,D0
	MOVE.L	D0,D1
	LSL.L	#8,D1

	MOVE.L	Y_VALUE,D0
	SUB.L	D1,D0

	LEA	DATA_HS,A0

	TST.L	D0
	BNE.S	DEJ
	LEA	RIEN,A0
	MOVE.L	A0,POIT
	BRA.S	OKAY
DEJ	SUBQ.L	#2,D0
	MULU	#18,D0
	ADDA.L	D0,A0
	MOVE.L	A0,POIT

OKAY
;	move.l	SCREEN1,d0
;	move.l	SCREEN2,SCREEN1		
;	move.l	d0,SCREEN2

	move.l	SCREEN1,d0
	ADD.L	D1,D0
	lsr.l	#8,d0
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
Y_VALUE	DC.L	0

TB0_IR	RTE

FIN:	MOVE.L	4.W,A0
	JMP	(A0)

H0
	DCB	128-4-3-4,$4E71
	RTS

H70
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	3+17*5,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	NOP
	RTS	=4 NOPS
H44
	DCB	3+18*5,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	NOP
	RTS	=4 NOPS
H24
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	1+17*5,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	REPT	3
	NOP
	ENDR
	RTS	=4 NOPS
H2
	NOP
	DCB	18*5,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	REPT	3
	NOP
	ENDR
	RTS	=4 NOPS
H80
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	7*5,$4E71
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	3+9*5,$4E71

	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	NOP
	RTS

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
DATA_HS
 DC.L H44,H44,H2,H2,H2,H80,H0,H0,H0
 DC.L H44,H44,H2,H2,H80,H0,H0,H0,H0
 DC.L H44,H44,H2,H80,H0,H0,H0,H0,H0
 DC.L H44,H44,H80,H0,H0,H0,H0,H0,H0
 DC.L H44,H24,H24,H2,H80,H0,H0,H0,H0
 DC.L H44,H24,H24,H80,H0,H0,H0,H0,H0
 DC.L H24,H2,H2,H2,H2,H2,H0,H0,H0
 DC.L H24,H2,H2,H2,H2,H0,H0,H0,H0
 DC.L H24,H2,H2,H2,H0,H0,H0,H0,H0
 DC.L H24,H2,H2,H0,H0,H0,H0,H0,H0
 DC.L H24,H2,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H0,H0,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H24,H24,H80,H80,H0,H0
 DC.L H70,H44,H2,H2,H2,H80,H0,H0,H0
 DC.L H70,H44,H2,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H2,H80,H0,H0,H0,H0,H0
 DC.L H44,H2,H2,H2,H2,H2,H0,H0,H0
 DC.L H44,H2,H2,H2,H2,H0,H0,H0,H0
 DC.L H44,H2,H2,H2,H0,H0,H0,H0,H0
 DC.L H44,H2,H2,H0,H0,H0,H0,H0,H0
 DC.L H44,H2,H0,H0,H0,H0,H0,H0,H0
 DC.L H44,H0,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H2,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H0,H0,H0,H0,H0,H0,H0
 DC.L H44,H44,H44,H2,H80,H0,H0,H0,H0
 DC.L H44,H44,H44,H80,H0,H0,H0,H0,H0
 DC.L H70,H70,H2,H2,H2,H80,H0,H0,H0
 DC.L H70,H70,H2,H2,H80,H0,H0,H0,H0
 DC.L H70,H70,H2,H80,H0,H0,H0,H0,H0
 DC.L H44,H24,H2,H2,H2,H2,H0,H0,H0
 DC.L H44,H24,H2,H2,H2,H0,H0,H0,H0
 DC.L H44,H24,H2,H2,H0,H0,H0,H0,H0
 DC.L H44,H24,H2,H0,H0,H0,H0,H0,H0
 DC.L H44,H24,H0,H0,H0,H0,H0,H0,H0
 DC.L H70,H0,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H44,H2,H2,H80,H0,H0,H0
 DC.L H70,H44,H44,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H44,H80,H0,H0,H0,H0,H0
 DC.L H44,H24,H24,H2,H80,H70,H0,H0,H0
 DC.L H70,H44,H24,H24,H80,H0,H0,H0,H0
 DC.L H44,H44,H2,H2,H0,H0,H0,H0,H0
 DC.L H44,H44,H2,H0,H0,H0,H0,H0,H0
 DC.L H44,H44,H0,H0,H0,H0,H0,H0,H0
 DC.L H70,H24,H2,H2,H0,H0,H0,H0,H0
 DC.L H70,H24,H2,H0,H0,H0,H0,H0,H0
 DC.L H70,H24,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H2,H2,H2,H80,H0,H0
 DC.L H70,H70,H44,H2,H2,H80,H0,H0,H0
 DC.L H70,H70,H44,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H2,H2,H2,H2,H2,H0,H0
 DC.L H70,H44,H2,H2,H2,H2,H0,H0,H0
 DC.L H70,H44,H2,H2,H2,H0,H0,H0,H0
 DC.L H70,H44,H2,H2,H0,H0,H0,H0,H0
 DC.L H70,H44,H2,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H24,H2,H2,H0,H0
 DC.L H24,H24,H24,H24,H24,H2,H0,H0,H0
 DC.L H24,H24,H24,H24,H24,H0,H0,H0,H0
 DC.L H70,H44,H44,H44,H80,H0,H0,H0,H0
 DC.L H70,H70,H70,H2,H2,H2,H80,H0,H0
 DC.L H70,H70,H70,H2,H2,H80,H0,H0,H0
 DC.L H70,H70,H70,H2,H80,H0,H0,H0,H0
 DC.L H70,H44,H24,H2,H2,H2,H2,H0,H0
 DC.L H44,H44,H44,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H2,H2,H0,H0,H0,H0
 DC.L H70,H44,H24,H2,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H0,H0,H0,H0,H0,H0
 DC.L H70,H70,H0,H0,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H70,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H2,H2,H80,H0,H0
 DC.L H70,H70,H44,H44,H2,H80,H0,H0,H0
 DC.L H70,H70,H44,H44,H80,H0,H0,H0,H0
 DC.L H70,H70,H44,H24,H24,H2,H80,H0,H0
 DC.L H70,H44,H44,H2,H2,H2,H0,H0,H0
 DC.L H70,H44,H44,H2,H2,H0,H0,H0,H0
 DC.L H70,H44,H44,H2,H0,H0,H0,H0,H0
 DC.L H70,H44,H44,H0,H0,H0,H0,H0,H0
 DC.L H70,H70,H24,H2,H2,H0,H0,H0,H0
 DC.L H70,H70,H24,H2,H0,H0,H0,H0,H0
 DC.L H70,H70,H24,H0,H0,H0,H0,H0,H0
 DC.L H70,H24,H24,H24,H24,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H24,H24,H24,H0,H0
 DC.L H70,H70,H70,H44,H2,H2,H80,H0,H0
 DC.L H44,H44,H44,H44,H2,H2,H0,H0,H0
 DC.L H44,H44,H44,H44,H2,H0,H0,H0,H0
 DC.L H44,H44,H44,H44,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H2,H2,H2,H0,H0,H0
 DC.L H70,H70,H44,H2,H2,H0,H0,H0,H0
 DC.L H70,H70,H44,H2,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H0,H0,H0,H0,H0,H0
 DC.L H70,H44,H24,H24,H24,H0,H0,H0,H0
 DC.L H70,H70,H24,H24,H0,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H44,H80,H2,H0,H0
 DC.L H70,H70,H44,H44,H44,H80,H0,H0,H0
 DC.L H70,H70,H70,H44,H24,H2,H2,H80,H0
 DC.L H44,H44,H44,H44,H24,H2,H2,H0,H0
 DC.L H44,H44,H44,H44,H24,H2,H0,H0,H0
 DC.L H44,H44,H44,H44,H24,H0,H0,H0,H0
 DC.L H70,H44,H44,H44,H0,H0,H0,H0,H0
 DC.L H70,H70,H70,H2,H2,H2,H0,H0,H0
 DC.L H70,H70,H70,H2,H2,H0,H0,H0,H0
 DC.L H70,H70,H70,H2,H0,H0,H0,H0,H0
 DC.L H70,H70,H70,H0,H0,H0,H0,H0,H0
 DC.L H24,H70,H70,H24,H24,H0,H0,H0,H0
 DC.L H70,H24,H24,H24,H24,H24,H24,H0,H0
 DC.L H44,H44,H44,H44,H44,H2,H2,H0,H0
 DC.L H44,H44,H44,H44,H44,H2,H0,H0,H0
 DC.L H44,H44,H44,H44,H44,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H2,H2,H2,H0,H0
 DC.L H70,H70,H44,H44,H2,H2,H0,H0,H0
 DC.L H70,H70,H44,H44,H2,H0,H0,H0,H0
 DC.L H70,H70,H44,H44,H0,H0,H0,H0,H0
 DC.L H70,H44,H44,H24,H24,H24,H0,H0,H0
 DC.L H70,H70,H70,H24,H2,H0,H0,H0,H0
 DC.L H70,H70,H70,H24,H0,H0,H0,H0,H0
 DC.L H24,H24,H24,H24,H70,H70,H0,H0,H0
 DC.L H44,H44,H44,H44,H44,H24,H2,H2,H2
 DC.L H44,H44,H44,H44,H44,H24,H2,H2,H0
 DC.L H70,H44,H44,H44,H44,H2,H2,H0,H0
 DC.L H70,H44,H44,H44,H44,H2,H0,H0,H0
 DC.L H70,H44,H44,H44,H44,H0,H0,H0,H0
 DC.L H70,H44,H44,H44,H24,H24,H2,H0,H0
 DC.L H70,H70,H70,H44,H2,H2,H0,H0,H0
 DC.L H70,H70,H70,H44,H2,H0,H0,H0,H0
 DC.L H70,H70,H70,H44,H0,H0,H0,H0,H0

RIEN	REPT	9
	DC.L	H0
	ENDR

IMG	INCBIN	VGA1.PAK

 	SECTION BSS
POIT	DS.L	1
SCREEN1	DS.L	1
	DS.B	256
BUFFER	DS.B	(230+10)*480
BUFPAK	DS.B	110400