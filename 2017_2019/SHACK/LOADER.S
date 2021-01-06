
;	opt	o+,a+
	opt	o+
;	opt	p+

TARGET	equ	$600

	section text

	bra.s	Start

;	include	LIB/BSS.S
;	include	LIB/ENV.S
	include	LIB/STPS.S
;	include	LIB/SYS.S

;MESSAGE
; dc.b "CHECKPOINT",$a,$d,0,0
;MESSAGE2
; dc.b "CHECKPOINT2",$a,$d,0,0
;MESSAGE3
; dc.b "CHECKPOINT3",$a,$d,0,0
;MESSAGE4
; dc.b "CHECKPOINT4",$a,$d,0,0

	even
Quit:
	bra.s	Quit

InterRTE:
	rte

	even
Start:
;	move.w	#(LoaderCodeEnd-LoaderCodeStart)/4,d0

;	SwitchToSuper
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

;;	lea		PRG_END(pc),a0
;;	lea		PRG(pc),a1
;;	sub.l	a1,a0
;	move.l	#PRG_END-PRG,a0
;	lea		Start(pc),a2
;	add.l	#TARGET,a0
;	cmp.l	a2,a0
;	blt.s	.ok
;	move.w	#$707,$ffff8240.w
;	
;	lea		MESSAGE(pc),a0
;	move.l	a2,(a0)
;	add.b	#65,(a0)
;	add.b	#65,1(a0)
;	add.b	#65,2(a0)
;	add.b	#65,3(a0)
;	PEA		MESSAGE(PC)
;	MOVE	#9,-(SP)
;	TRAP	#1
;	ADDQ.L	#6,SP
;	
;.stop	bra.s	.stop	
;.ok
;
;	PEA		MESSAGE(PC)
;	MOVE	#9,-(SP)
;	TRAP	#1
;	ADDQ.L	#6,SP

	MOVE.L	4(SP),A0	MSHRINK
	MOVE.L	$C(A0),D0	
	ADD.L	$14(A0),D0	
	ADD.L	$1C(A0),D0	
	ADD.L	#$100,D0
	MOVE.L	D0,-(SP)
	MOVE.L	A0,-(SP)
	CLR.W	-(SP)
	MOVE.W	#$4A,-(SP)
	TRAP	#1
	LEA	12(SP),SP

;	PEA		MESSAGE2(PC)
;	MOVE	#9,-(SP)
;	TRAP	#1
;	ADDQ.L	#6,SP

;	bsr		Lib_ClearBSS

;	PEA		MESSAGE3(PC)
;	MOVE	#9,-(SP)
;	TRAP	#1
;	ADDQ.L	#6,SP

	move.w	#$2700,SR

	clr.b	$FFFFFA07.w
	clr.b	$FFFFFA09.w

;Redirect exception vectors to quit
	lea		Quit(PC),a0
	move.l	a0,$008.w
	move.l	a0,$00C.w
	move.l	a0,$010.w
	move.l	a0,$014.w
	move.l	a0,$018.w
	move.l	a0,$01c.w
	move.l	a0,$020.w
	move.l	a0,$024.w

	lea		InterRTE(PC),a0
	move.l	a0,$008.w
	move.l	a0,$00C.w
	move.l	a0,$010.w
	move.l	a0,$014.w
	move.l	a0,$018.w
	move.l	a0,$01c.w
	move.l	a0,$020.w
	move.l	a0,$024.w
	move.l	a0,$68.w
	move.l	a0,$70.w
	move.l	a0,$114.w
	move.l	a0,$118.w
	move.l	a0,$120.w
	move.l	a0,$134.w

	move.l	a0,$70.w
;	move.w	#$2300,SR
	move.w	#$2700,SR

;	move.w	#$007,$ffff8240.w

	move.l	#$00010001,d0
	MOVE.l	d0,D1
	MOVE.l	d0,D2
	MOVE.l	d0,D3
	MOVE.l	d0,D4
	MOVE.l	d0,D5
	MOVE.l	d0,D6
	MOVE.l	d0,D7
;	MOVEQ	#0,D0
;	MOVEQ	#0,D1
;	MOVEQ	#0,D2
;	MOVEQ	#0,D3
;	MOVEQ	#0,D4
;	MOVEQ	#0,D5
;	MOVEQ	#0,D6
;	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W


	;Copy the copy-code
	lea		LoaderCodeStart(PC),a0
	move.w	#(LoaderCodeEnd-LoaderCodeStart)/4,d0
;	lea		$7E0C0,a1
;	lea		$7f710,a1
	lea		$7faf8,a1
;	move.w	#(7999/4)-1,d0
.Move
	move.l	(a0)+,(a1)+
	dbf		d0,.Move
	move.l	#PRG,a0
	jmp		$7faf8
;	jmp		$7f710
;	jmp		$7E0C0

	LEA		PRG(PC),A0
LoaderCodeStart:
	move	#TARGET,A1	
	MOVE	#(PRG_END-PRG)/4,D0
COPING
	MOVE.L	(A0)+,(A1)+
	DBF		D0,COPING

;	move.w	#$070,$ffff8240.w
Reloc:
	move	#TARGET,A0
	
	MOVE.L	A0,A1
	ADD.L	2(A0),A1
	ADD.L	6(A0),A1
	LEA		31(A1),A1
	MOVEQ	#0,D0
	
	LEA		28(A0),A0
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
RELOC_END:

;	move.w	#$700,$ffff8240.w
	move	#TARGET,A1	
	JMP		(a1)
LoaderCodeEnd:

PRG	INCBIN	HACK.BIN
;PRG	INCBIN	HACK2.BIN
PRG_END

	section data
	even

	section bss
	even

StartBSS:
EndBSS:
