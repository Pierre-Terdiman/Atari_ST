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
	MOVE.L	A1,MOD_RET
	MOVE.L	A0,MOD_ZIK
	LEA	BSS_DEB,A0
	LEA	BSS_END,A1
ZERT	CLR.L	(A0)+
	CMP.L	A1,A0
	BLE.S	ZERT
	LEA.L 	D_PILE,A7
;	PEA	0.W
;	MOVE 	#$20,-(SP)
;	TRAP 	#1
;	ADDQ.L 	#6,SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	
	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1		
	add.l	#64000,d0		
	move.l	d0,SCREEN2

	JSR	PRO
******
	LEA	PART1,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160(A1),A1
	MOVE	#127,D7
AFF_Y	MOVE	#(112/4)-1,D6
AFF_X	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y
******
	LEA	PART2,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160+112(A1),A1
	MOVE	#127,D7
AFF_Y2	MOVE	#(112/4)-1,D6
AFF_X2	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X2
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y2
******
	LEA	PART3,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160(A1),A1
	LEA	230*100(A1),A1
	LEA	230*28(A1),A1
	MOVE	#127,D7
AFF_Y3	MOVE	#(112/4)-1,D6
AFF_X3	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X3
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y3
******
	LEA	PART4,A0
	LEA	BUFY,A1
	JSR	depack

	LEA	BUFY+34,A0
	MOVE.L	SCREEN1,A1
	LEA	160+112(A1),A1
	LEA	230*100(A1),A1
	LEA	230*28(A1),A1
	MOVE	#127,D7
AFF_Y4	MOVE	#(112/4)-1,D6
AFF_X4	MOVE.L	(A0)+,(A1)+
	DBF	D6,AFF_X4
	LEA	48(A0),A0
	LEA	70+48(A1),A1
	DBF	D7,AFF_Y4
******
	MOVE.L	#VBLR_IR,$70.W
	MOVE.L	#TB0_IR,$120.W
	
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	BRA.S	BOUCLE
MOD_RET	EQU	*+2
	JMP	MOD_RET
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
	MOVEM.L	BUFY+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W
MOD_ZIK	EQU	*+2
	JSR	MOD_ZIK
	LEA	DEGRADE,A0
INTER_RTE	RTE

INTER_TMA:	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR
full
	LEA	$FFFF8209.W,A3
	LEA	$FFFF8260.W,A6
	LEA	$FFFF820A.W,A5

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
	LEA	$FFFF8209.W,A6
	LEA	$FFFF8260.W,A4
	LEA	$FFFF820A.W,A3
	MOVEQ	#0,D1		
	MOVEQ	#$10,D6
	MOVE	#42-1,D5
	MOVE.L	#(226/2)-1,D0

SYNCHRO	MOVE.B	(A6),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		
	DCB	97-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-1-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	
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
	MOVE	(A0)+,$FFFF8252.W
*
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4-4,$4E71
	MOVE	(A0)+,$FFFF8252.W

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
	DCB	8-4,$4E71
	MOVE	(A0)+,$FFFF8252.W

	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	MOVE	A4,(A3)
	DCB	88-2,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4-1,$4E71
	MOVE	(A0)+,$FFFF8252.W
FD	NOP
	;REPT	42
	MOVE	A4,(A4)
	MOVE.B	#0,(A4)
	DCB	88,$4E71
	MOVE.b	#0,(A3)
	MOVE	a4,(A3)
	DCB	13,$4E71
	MOVE	a4,(A4)
	MOVE.B	#0,(A4)
	DCB	12-4-4,$4E71
	MOVE	(A0)+,$FFFF8252.W
	;ENDR
	DBF	D5,FD
SUITE
;OKAY	move.l	SCREEN1,d0
;	move.l	SCREEN2,SCREEN1		
;	move.l	d0,SCREEN2

	move.l	SCREEN1,d0
	ADD.L	D1,D0
	lsr.l	#8,d0
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
	JSR	PRO
	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	.E
	MOVE	#$4E71,BOUCLE
.E	RTE
Y_VALUE	DC.L	0

TB0_IR	RTE

FIN:	MOVE.L	4.W,A0
	JMP	(A0)

PRO	MOVEM.L	D0/A0-A1,-(SP)
	LEA	BUF,A0
	LEA	BUF2,A1
PT_Y	EQU	*+2
	LEA	0(A1),A1
	MOVE	#(84+14)-1,D0
COPC	MOVE	(A1)+,(A0)+
	DBF	D0,COPC
;	CMPI.B	#$3B,$FFFFFC02.W
;	BNE.S	NO3B
;	ADDQ	#2,PT_Y
;NO3B	CMPI.B	#$3C,$FFFFFC02.W
;	BNE.S	NO3C
;	SUBQ	#2,PT_Y
NO3C	MOVEM.L	(SP)+,D0/A0-A1
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
PART1	INCBIN	COL1.PAK
PART2	INCBIN	COL2b.PAK
PART3	INCBIN	COL3.PAK
PART4	INCBIN	COL4.PAK

DEGRADE	
;;DC $010,$010,$020,$020,$030,$030,$040,$040,$050,$050,$060,$060,$070,$070
; DC $001,$002,$101,$101,$101,$202,$202,$202,$303,$303,$303,$404,$404,$404,$505,$505,$505,$606,$606,$606
 
;;DC $071,$071,$072,$072,$073,$073,$074,$074,$075,$075,$076,$076,$077,$077
; DC $707,$707,$707,$717,$717,$717,$727,$727,$727,$737,$737,$737,$747,$747,$747,$757,$757,$757,$767,$767,$767,$767

;;DC $177,$177,$277,$277,$377,$377,$477,$477,$577,$577,$677,$677,$777,$777
BUF	DS	84+14
	DCB	2,$101
	DC	$101,$101,$202,$202,$202,$202,$303,$303,$303,$303,$404,$404,$404,$404
	DCB	4*2,$403
	DC	$303,$303,$203,$203,$103,$103,$102,$102,$101,$101,$001,$001
	DC	$101,$101,$102,$102,$103,$103,$203,$203,$303,$303
	DCB	30*2,$403
	DC	$404,$404,$405,$405,$406,$406,$407,$407,$406,$406,$405,$405,$404,$404
	DCB	256,$403

BUF2

 DCB	2,$100
 DC	$200
 DC	$100

 DCB	2,$200
 DC	$300
 DC	$200

 DCB	2,$300
 DC	$400
 DC	$300

 DCB	2,$400
 DC	$500
 DC	$400

 DCB	2,$500
 DC	$600
 DC	$500

 DCB	2,$600
 DC	$700
 DC	$600

 DCB	2,$700
 DC	$710
 DC	$700

 DCB	2,$710
 DC	$720
 DC	$710

 DCB	2,$720
 DC	$730
 DC	$720

 DCB	2,$730
 DC	$740
 DC	$730

 DCB	2,$740
 DC	$750
 DC	$740

 DCB	2,$750
 DC	$760
 DC	$750

 DCB	2,$760
 DC	$770
 DC	$760

 DCB	2,$770
 DC	$771
 DC	$770

 DCB	2,$771
 DC	$772
 DC	$771

 DCB	2,$772
 DC	$773
 DC	$772

 DCB	2,$773
 DC	$774
 DC	$773

 DCB	2,$774
 DC	$775
 DC	$774

 DCB	2,$775
 DC	$776
 DC	$775

 DCB	2,$776
 DC	$777
 DC	$776

 DCB	2,$777
 DC	$767
 DC	$777

 DCB	2,$767
 DC	$757
 DC	$767

 DCB	2,$757
 DC	$747
 DC	$757

 DCB	2,$747
 DC	$737
 DC	$747

 DCB	2,$737
 DC	$727
 DC	$737
 DCB	2,$727
 DC	$717
 DC	$727
 DCB	2,$717
 DC	$707
 DC	$717
 DCB	2,$707
 DC	$706
 DC	$707
 DCB	2,$706
 DC	$705
 DC	$706
 DCB	2,$705
 DC	$704
 DC	$705
 DCB	2,$704
 DC	$703
 DC	$704
 DCB	2,$703
 DC	$702
 DC	$703
 DCB	2,$702
 DC	$701
 DC	$702
 DCB	2,$701
 DC	$700
 DC	$701
 DCB	2,$700
 DC	$600
 DC	$700
 DCB	2,$600
 DC	$500
 DC	$600
 DCB	2,$500
 DC	$400
 DC	$500
 DCB	2,$400
 DC	$300
 DC	$400
 DCB	2,$300
	DCB	7*2,$777
	
 	SECTION BSS
BSS_DEB
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	64000
BUFY	DS.B	32066
BSS_END