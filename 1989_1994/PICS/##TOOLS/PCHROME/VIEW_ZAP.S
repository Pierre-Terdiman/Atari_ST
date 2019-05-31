
* Le viewer avec ripper int‚gr‚ dans toute sa splendeur.

	opt	o-,w+

	SECTION	TEXT

	CLR.L	-(A7)
	MOVE.W	#$20,-(A7)
	TRAP	#1
	ADDQ.W	#6,A7
	MOVE.L	D0,OldStack
	MOVE.B	$FFFF820A.W,OldFrq

	SF	KeyEsc
	BSR	ClearKbd
	BSR	InitScr
	BSR	SaveAll

	MOVE.W	#0,FileType
	CLR.W	NbPic
	LEA	FileExts(PC),A0
	LEA	FileJump(PC),A1
CopyExts	MOVEA.L	ExtPoint(PC),A2
	MOVE.B	(A0)+,(A2)+
	BEQ.S	L0001
	MOVE.B	(A0)+,(A2)+
	MOVE.B	(A0)+,(A2)+
	MOVE.L	(A1)+,FJumpPoint
	BSR	SearchFiles
	BRA.S	CopyExts

L0001	TST.W	NbPic
	BEQ	EndPrg
	CLR.W	CurrentPic
	LEA	ListLength,A0
	LEA	ListFiles,A1
NextPic	MOVE.W	CurrentPic(PC),D0
	MOVE.W	D0,D1
	ADD.W	D0,D0
	ADD.W	D0,D0
	MULU	#$14,D1
	MOVEA.L	0(A0,D0.W),A2
	LEA	0(A1,D1.W),A6
	MOVE.L	A6,PicLen
	MOVEM.L	A0-A2,-(A7)
	MOVE.L	#110000,MaxLength
	MOVE.L	#LoadBuf,LoadAdr
	BSR	LoadFile
	CMPI.L	#'ICE!',LoadBuf
	BNE.S	NotPacked
	MOVEM.L	A0-A6/D0-D7,-(A7)
	MOVE.L	MaxLength,D0
	ADD.L	D0,LoadAdr
	LEA	LoadBuf,A0
	MOVEA.L	LoadAdr,A1
	BSR	IceDepack
	MOVEM.L	(A7)+,A0-A6/D0-D7

NotPacked	MOVEM.L	(A7)+,A0-A2
	TST.L	D0
	BNE.S	L0006

	MOVEM.L	A0-A6/D0-D7,-(A7)
	MOVE.W	#5,VBLCount
.WaitVbl1	TST.W	VBLCount
	BNE.S	.WaitVbl1
	JSR	(A2)
	MOVE.W	#5,VBLCount
.WaitVbl2	TST.W	VBLCount
	BNE.S	.WaitVbl2
	BSR	GetKey
	BSR	ClearKbd
	MOVEM.L	(A7)+,A0-A6/D0-D7

L0006	TST.B	KeyEsc
	BNE	EndPrg
	ADDQ.W	#1,CurrentPic
	MOVE.W	NbPic,D0
	CMP.W	CurrentPic,D0
	BNE	NextPic
	CLR.W	CurrentPic
	BRA	NextPic
LoadFile	CLR.W	-(A7)
	MOVE.L	PicLen(PC),-(A7)
	MOVE.W	#$3D,-(A7)
	TRAP	#1
	ADDQ.W	#8,A7
	MOVE.L	D0,D5
	TST.L	D0
	BMI.S	.TooLarge
	MOVE.L	LoadAdr(PC),-(A7)
	MOVE.L	MaxLength(PC),-(A7)
	MOVE.W	D5,-(A7)
	MOVE.W	#$3F,-(A7)
	TRAP	#1
	LEA	12(A7),A7
	TST.L	D0
	BPL.S	.OkLength
	MOVE.W	D5,-(A7)
	MOVE.W	#$3E,-(A7)
	TRAP	#1
	ADDQ.L	#4,A7
.TooLarge	MOVEQ	#-1,D0
	RTS
.OkLength	MOVE.L	D0,MaxLength
	MOVE.W	D5,-(A7)
	MOVE.W	#$3E,-(A7)
	TRAP	#1
	ADDQ.L	#4,A7
	MOVEQ	#0,D0
	RTS

PicLen	DC.L	0
LoadAdr	DC.L	0
MaxLength	DC.L	0

SearchFiles
	PEA	(A0)
	PEA	(A1)
	LEA	FileName(PC),A1
	MOVE.W	FileType,D0
	ADDI.W	#$41,D0
	MOVE.B	D0,(A1)+
	MOVE.B	#':',(A1)+
	MOVE.B	#'\',(A1)+
	MOVE.B	#'*',(A1)+
	MOVE.B	#'.',(A1)+
	MOVEA.L	ExtPoint(PC),A0
	MOVE.B	(A0)+,(A1)+
	MOVE.B	(A0)+,(A1)+
	MOVE.B	(A0)+,(A1)+
	CLR.B	(A1)

	PEA	NewDTA(PC)
	MOVE.W	#$1A,-(A7)
	TRAP	#1
	ADDQ.W	#6,A7

	MOVE.W	#0,-(A7)
	PEA	FileName(PC)
	MOVE.W	#$4E,-(A7)
	TRAP	#1
	ADDQ.W	#8,A7
	TST.L	D0
	BNE.S	.NoFile
.NextFile	BSR.S	L0010
	MOVE.W	#$4F,-(A7)
	TRAP	#1
	ADDQ.W	#2,A7
	TST.L	D0
	BEQ.S	.NextFile
.NoFile	MOVEA.L	(A7)+,A1
	MOVEA.L	(A7)+,A0
	RTS

L0010	LEA	L0016,A0
	LEA	FileName(PC),A1
	LEA	ListFiles(PC),A2
	LEA	ListLength(PC),A3
	MOVE.W	NbPic(PC),D0
	MOVE.W	D0,D1
	ADD.W	D1,D1
	ADD.W	D1,D1
	ADDA.W	D1,A3
	MOVE.L	FJumpPoint(PC),(A3)
	MULU	#$14,D0
	ADDA.W	D0,A2
	MOVE.B	(A1)+,(A2)+
	MOVE.B	(A1)+,(A2)+
	MOVE.B	(A1)+,(A2)+
	MOVEQ	#$C,D0
L0011	MOVE.B	(A0)+,(A2)+
	DBF	D0,L0011
	CLR.B	(A2)
	ADDQ.W	#1,NbPic
	RTS

FileType	DC.W	0
ExtPoint	DC.L	L0014
L0014	DC.L	0
NewDTA	DCB.W	15,0
L0016	DCB.W	7,0
NbPic	DC.W	0
FileName	DCB.W	32,0
ListFiles	DCB.W	800,0
ListLength	DCB.W	160,0
FJumpPoint	DC.L	0
CurrentPic	DC.W	0
FileExts	DC.B	'PC1TN?PCS',0
FileJump	DC.L	DegasDisp
	DC.L	TinyDisp
	DC.L	PCSDisp


DegasDisp	BSR	GetKey
	BSR	ClearKbd
	MOVEM.L	BlackPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.B	OldFrq(PC),$FFFF820A.W
	MOVE.W	#$10,VBLCount
.Vsync1	TST.W	VBLCount
	BNE.S	.Vsync1
	MOVEA.L	LoadAdr,A0
	BSR	DepackDegas
	BSR	AffDegas
	MOVE.W	VBLToWait,VBLCount

.Vsync2	BSR	TestKbd
	TST.B	KeyEsc
	BNE.S	.EndDisp
	TST.B	KeySpace
	BNE.S	.Pause
	TST.W	VBLCount
	BNE.S	.Vsync2
.EndDisp	RTS
.Pause	BSR	TestKbd
	TST.B	KeyEsc
	BNE.S	.EndDisp
	TST.B	KeySpace
	BNE.S	.Pause
	RTS


TinyDisp	BSR	GetKey
	BSR	ClearKbd
	MOVEM.L	BlackPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.B	OldFrq(PC),$FFFF820A.W
	MOVE.W	#$10,VBLCount
.Vsync1	TST.W	VBLCount
	BNE.S	.Vsync1
	MOVEA.L	LoadAdr,A0
	BSR	DepackTiny
	BSR	AffDegas
	MOVE.W	VBLToWait,VBLCount
.Vsync2	BSR	TestKbd
	TST.B	KeyEsc
	BNE.S	.EndDisp
	TST.B	KeySpace
	BNE.S	.Pause
	TST.W	VBLCount
	BNE.S	.Vsync2
.EndDisp	RTS
.Pause	BSR	TestKbd
	TST.B	KeyEsc
	BNE.S	.EndDisp
	TST.B	KeySpace
	BNE.S	.Pause
	RTS


PCSDisp	BSR	GetKey
	BSR	ClearKbd
	MOVEM.L	BlackPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVEA.L	Screen2,A0
	BSR	ClearScreen
	MOVEA.L	Screen1,A0
	BSR	ClearScreen
	MOVEA.L	LoadAdr,A0
	BSR	PreparePCS

	MOVE.W	#$A,VBLCount
.Vsync1	TST.W	VBLCount
	BNE.S	.Vsync1

	BSR	SetVBL
	MOVE.W	VBLToWait,D1
.Vsync2	BSR	TestKbd
	TST.B	KeySpace
	BNE.S	.Pause
	tst.b	KeySave
	beq.s	.NoSave
	bsr.s	SavePCS
.NoSave	TST.B	KeyEsc
	BNE.S	.EndDisp
	ADDQ.W	#1,VBLCount
.Vsync3	TST.W	VBLCount
	BNE.S	.Vsync3
	SUBQ.W	#1,D1
	BPL.S	.Vsync2
.EndDisp	BSR	RemoveVBL
	MOVEM.L	BlackPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.L	Screen1,D0
	LSR.W	#8,D0
	MOVE.L	D0,$FFFF8200.W
	RTS

.Pause	BSR	TestKbd
	TST.B	KeyEsc
	BNE.S	.EndDisp
	TST.B	KeySpace
	BNE.S	.Pause
	BRA.S	.EndDisp

*******************************************************************************

SavePCS	bsr	RemoveVBL
	bsr	RestAll
	bsr	RestScr

	lea	SaveMsg1(pc),a0
	bsr	Print
	pea	SaveInput
	move.w	#10,-(a7)
	trap	#1
	addq.l	#6,a7
	lea	SaveName(pc),a0
	clr.w	d0
	move.b	SaveInput+1,d0
	clr.b	(a0,d0.w)

	move.w	#$19,-(a7)
	trap	#1
	addq.l	#2,a7
	cmp.b	#':',SaveName+1
	bne.s	.OkDrv
	clr.w	d0
	move.b	SaveName,d0
	cmp.b	#$60,d0
	blt.s	.Maj
	sub.b	#'a',d0
	bra.s	.OkDrv
.Maj	sub.b	#'A',d0
.OkDrv	addq.w	#1,d0
	move.w	d0,-(a7)
	pea	Free(pc)
	move.w	#$36,-(a7)
	trap	#1
	addq.l	#8,a7
	lea	Free(pc),a0
	move.l	8(a0),d0
	move.l	12(a0),d1
	mulu	d1,d0
	move.l	(a0),d1
	mulu	d1,d0
	move.l	#51136,d1
	tst.b	Swapping
	beq.s	.NoSwap3
	add.l	d1,d1
.NoSwap3	cmp.l	d1,d0
	bhs.s	ReRetry
	lea	SaveMsg4(pc),a0
	bsr	Print
	move.w	#7,-(a7)
	trap	#1
	addq.l	#2,a7
	bra	EndSave

ReRetry	clr.w	-(a7)
	pea	SaveName(pc)
	move.w	#$3c,-(a7)
	trap	#1
	addq.l	#8,a7
	tst.w	d0
	bmi	DiskError
	move.w	d0,d7

	move.l	ScrBuf1,-(a7)
	move.l	#32000,-(a7)
	move.w	d7,-(a7)
	move.w	#$40,-(a7)
	trap	#1
	lea	12(a7),a7
	bmi	DiskError
	tst.b	Swapping
	beq.s	.NoSwap
	move.l	ScrBuf2,-(a7)
	move.l	#32000,-(a7)
	move.w	d7,-(a7)
	move.w	#$40,-(a7)
	trap	#1
	lea	12(a7),a7
	bmi.s	DiskError
.NoSwap	move.l	Pal2Point,d0
	sub.l	#32,d0
	move.l	d0,-(a7)
	move.l	#19136,-(a7)
	move.w	d7,-(a7)
	move.w	#$40,-(a7)
	trap	#1
	lea	12(a7),a7
	bmi.s	DiskError
	tst.b	Swapping
	beq.s	.NoSwap2
	move.l	Pal1Point,d0
	sub.l	#32,d0
	move.l	d0,-(a7)
	move.l	#19136,-(a7)
	move.w	d7,-(a7)
	move.w	#$40,-(a7)
	trap	#1
	lea	12(a7),a7
	bmi.s	DiskError
.NoSwap2	bsr.s	FClose
	lea	SaveMsg2(pc),a0
	bsr.s	Print
	move.w	#7,-(a7)
	trap	#1
	addq.l	#2,a7
	
EndSave	bsr	SaveAll
	bsr	InitScr
	bsr	SetVBL
	rts	

DiskError	lea	SaveMsg4(pc),a0
	bsr.s	Print
.Test	move.w	#1,-(a7)
	trap	#1
	addq.l	#2,a7
	cmp.b	#'o',d0
	beq.s	Retry
	cmp.b	#'O',d0
	beq.s	Retry
	cmp.b	#'n',d0
	beq.s	NoRetry
	cmp.b	#'N',d0
	bne.s	.Test
NoRetry	bsr.s	FClose
	pea	SaveName(pc)
	move.w	#$41,-(a7)
	trap	#1
	addq.l	#6,a7
	bra.s	EndSave
Retry	bsr.s	FClose
	bra	ReRetry

FClose	move.w	d7,-(a7)
	move.w	#$3e,-(a7)
	trap	#1
	addq.l	#4,a7
	rts

Print	move.l	a0,-(a7)
	move.w	#9,-(a7)
	trap	#1
	addq.l	#6,a7
	rts

SaveMsg1	dc.b	27,'E',27,'e'
	dc.b	'Entrez le nom du fichier … sauver:',10,13,0
SaveMsg2	dc.b	10,13
	dc.b	'Sauvegarde effectu‚e!',0
SaveMsg3	dc.b	10,13
	dc.b	'Erreur disque! Recommencer? ',0
SaveMsg4	dc.b	10,13
	dc.b	'Disque plein!',0
SaveInput	dc.b	40,0
SaveName	dcb.b	40,0
	even
Free	dc.l	0,0,0,0

*******************************************************************************

PreparePCS	SF	Swapping
	MOVE.L	Screen2,ScrBuf1
	MOVE.L	Screen1,ScrBuf2
	MOVE.L	#PCSPal1,Pal1Point
	MOVE.L	#PCSPal2,Pal2Point
	LEA	6(A0),A1
	MOVEA.L	A0,A6
	MOVE.B	#0,NewFrq
	BTST	#0,5(A6)
	BEQ.S	.No50Hz
	MOVE.B	#2,NewFrq
.No50Hz	MOVE.B	NewFrq,$FFFF820A.W
	MOVEA.L	ScrBuf1,A0
	BSR.S	DepackPCS
	MOVEA.L	Pal1Point,A0
	BSR	L0040
	TST.B	4(A6)
	BEQ.S	.SingleScreen
	ST	Swapping
	MOVEA.L	ScrBuf2,A0
	BSR.S	DepackPCS
	MOVEA.L	Pal2Point,A0
	BSR	L0040
	BSR	L004A
	BSR	L004D
.SingleScreen
	ADDI.L	#32,Pal1Point
	ADDI.L	#32,Pal2Point
	RTS

DepackPCS	MOVEQ	#0,D6
	MOVE.W	#$28,D2
	MOVE.W	#$C8,D3
	MOVEQ	#5,D4
	MOVE.B	(A1)+,D7
	LSL.W	#8,D7
	MOVE.B	(A1)+,D7
L0033	MOVEQ	#0,D0
	SUBQ.W	#1,D7
	BMI.S	L0039
	MOVE.B	(A1)+,D0
	BMI.S	L003A
	BEQ.S	L0034
	CMP.B	#1,D0
	BEQ.S	L003B
	BRA.S	L0035
L0034	MOVE.B	(A1)+,D0
	LSL.W	#8,D0
	MOVE.B	(A1)+,D0
L0035	SUBQ.W	#1,D0
	MOVE.B	(A1)+,D1
L0036	MOVE.B	D1,0(A0,D6.W)
	ADDQ.W	#1,D6
	ANDI.W	#1,D6
	BNE.S	L0037
	ADDQ.W	#8,A0
L0037	SUBQ.W	#1,D2
	BNE.S	L0038
	MOVEQ	#$28,D2
	SUBQ.W	#1,D3
	BNE.S	L0038
	MOVE.W	#$C8,D3
	LEA	-31998(A0),A0
	SUBQ.W	#1,D4
	BEQ.S	L0039
L0038	DBF	D0,L0036
	BRA.S	L0033
L0039	RTS
L003A	NEG.B	D0
	BRA.S	L003C
L003B	MOVE.B	(A1)+,D0
	LSL.W	#8,D0
	MOVE.B	(A1)+,D0
L003C	SUBQ.W	#1,D0
L003D	MOVE.B	(A1)+,D1
	MOVE.B	D1,0(A0,D6.W)
	ADDQ.W	#1,D6
	ANDI.W	#1,D6
	BNE.S	L003E
	ADDQ.W	#8,A0
L003E	SUBQ.W	#1,D2
	BNE.S	L003F
	MOVEQ	#$28,D2
	SUBQ.W	#1,D3
	BNE.S	L003F
	MOVE.W	#$C8,D3
	LEA	-31998(A0),A0
	SUBQ.W	#1,D4
	BEQ.S	L0039
L003F	DBF	D0,L003D
	BRA	L0033
L0040	MOVE.B	(A1)+,D7
	LSL.W	#8,D7
	MOVE.B	(A1)+,D7
L0041	MOVEQ	#0,D0
	SUBQ.W	#1,D7
	BMI.S	L0045
	MOVE.B	(A1)+,D0
	BMI.S	L0046
	BEQ.S	L0042
	CMP.B	#1,D0
	BEQ.S	L0047
	BRA.S	L0043
L0042	MOVE.B	(A1)+,D0
	LSL.W	#8,D0
	MOVE.B	(A1)+,D0
L0043	SUBQ.W	#1,D0
	MOVE.B	(A1)+,D1
	LSL.W	#8,D1
	MOVE.B	(A1)+,D1
L0044	MOVE.W	D1,(A0)+
	DBF	D0,L0044
	BRA.S	L0041
L0045	RTS
L0046	NEG.B	D0
	BRA.S	L0048
L0047	MOVE.B	(A1)+,D0
	LSL.W	#8,D0
	MOVE.B	(A1)+,D0
L0048	SUBQ.W	#1,D0
L0049	MOVE.B	(A1)+,D1
	LSL.W	#8,D1
	MOVE.B	(A1)+,D1
	MOVE.W	D1,(A0)+
	DBF	D0,L0049
	BRA.S	L0041

L004A	BTST	#0,4(A6)
	BNE.S	.Youpi
	MOVEM.L	A0-A6/D0-D7,-(A7)
	MOVEA.L	ScrBuf1,A0
	MOVEA.L	ScrBuf2,A1
	MOVE.W	#$1F3F,D0
.Loop	MOVE.L	(A0)+,D1
	EOR.L	D1,(A1)+
	DBF	D0,.Loop
	MOVEM.L	(A7)+,A0-A6/D0-D7
.Youpi	RTS

L004D	BTST	#1,4(A6)
	BNE.S	.Youpi
	MOVEM.L	A0-A6/D0-D7,-(A7)
	MOVEA.L	Pal1Point,A0
	MOVEA.L	Pal2Point,A1
	MOVE.W	#$255F,D0
.Loop	MOVE.W	(A0)+,D1
	EOR.W	D1,(A1)+
	DBF	D0,.Loop
	MOVEM.L	(A7)+,A0-A6/D0-D7
.Youpi	RTS

NewFrq	DC.B	0
Swapping	DC.B	0

VBL2	BTST	#1,$FFFF820A.W
	BNE.S	.In50Hz
	MOVE.B	#$16,$700.w
	MOVE.L	#HBL60Hz,$68.W
	BRA.S	.In60Hz
.In50Hz	MOVE.B	#$34,$700.W
	MOVE.L	#HBL50Hz,$68.W
.In60Hz	MOVE	#$2100,SR
	PEA	(A0)
	PEA	(A1)
	MOVEA.L	Pal2Point(PC),A0
	LEA	-30(A0),A0
	LEA	$FFFF8242.W,A1
	MOVE.W	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVE.L	(A0)+,(A1)+
	MOVEA.L	(A7)+,A1
	MOVEA.L	(A7)+,A0
.WaitHBL	TST.B	$700.W
	BNE.S	.WaitHBL
	MOVE	#$2300,SR
	MOVE.W	D0,-(A7)
.TestKbd	BTST	#0,$FFFFFC00.W
	BEQ.S	.KbdClear
	MOVE.B	$FFFFFC02.W,D0
	BRA.S	.TestKbd
.KbdClear	MOVE.W	(A7)+,D0
	TST.W	VBLCount
	BLE.S	.NoSub
	SUBQ.W	#1,VBLCount
.NoSub	MOVE.L	D0,-(A7)
	MOVE.L	Pal1Point,D0
	TST.B	Swapping
	BEQ.S	.Swap1
	MOVE.L	Pal2Point,Pal1Point
.Swap1	MOVE.L	D0,Pal2Point
	MOVE.L	ScrBuf1,D0
	TST.B	Swapping
	BEQ.S	.Swap2
	MOVE.L	ScrBuf2,ScrBuf1
.Swap2	MOVE.L	D0,ScrBuf2
	LSR.W	#8,D0
	MOVE.L	D0,$FFFF8200.W
	MOVE.L	(A7)+,D0
	RTS

HBL50Hz	SUBQ.B	#1,$700.W
	BLE.S	.EndHBL
	RTE
.EndHBL	MOVE	#$2700,SR
	MOVEM.L	A0-A6/D0-D7,-(A7)
	MOVE.L	A7,SaveA7a
	LEA	$FFFF8209.W,A6
	MOVEQ	#0,D0
	MOVEQ	#$40,D7
.WaitShift	MOVE.B	(A6),D0
	BEQ.S	.WaitShift
	SUB.W	D0,D7
	LSL.W	D7,D0
	MOVE.W	#$10,D0
	DBF	D0,*
	NOP
	MOVEA.L	Pal2Point(PC),A7
	REPT	199
	MOVEM.L	(A7)+,A0-A6/D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVEM.L	A0-A6,$FFFF8240.W
	MOVE.L	(A7)+,$FFFF825C.W
	LEA	$FFFF8240.W,A0
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.W	#0,$FFFF8240.W
	MOVE.L	(A7)+,(A0)+
	MOVE.W	#0,D0
	DBF	D0,*
	NOP
	ENDR
	MOVE.L	#0,A7
SaveA7a	EQU	*-4
	MOVEM.L	(A7)+,A0-A6/D0-D7
	MOVE.L	#EmptyHBL,$68.W
	MOVE.B	#$23,(A7)
EmptyHBL	RTE

HBL60Hz	SUBQ.B	#1,$700.W
	BLE.S	.EndHBL
	RTE
.EndHBL	MOVE	#$2700,SR
	MOVEM.L	A0-A6/D0-D7,-(A7)
	MOVE.L	A7,SaveA7b
	LEA	$FFFF8209.W,A6
	MOVEQ	#0,D0
	MOVEQ	#$40,D7
.WaitShift	MOVE.B	(A6),D0
	BEQ.S	.WaitShift
	SUB.W	D0,D7
	LSL.W	D7,D0
	MOVE.W	#$10,D0
	DBF	D0,*
	MOVEA.L	Pal2Point(PC),A7
	REPT	199
	MOVEM.L	(A7)+,A0-A6/D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVEM.L	A0-A6,$FFFF8240.W
	MOVE.L	(A7)+,$FFFF825C.W
	LEA	$FFFF8240.W,A0
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.L	(A7)+,(A0)+
	MOVE.W	#0,$FFFF8240.W
	MOVE.L	(A7)+,(A0)+
	MOVE.W	#0,D0
	DBF	D0,*
	ENDR
	MOVE.L	#0,A7
SaveA7b	EQU	*-4
	MOVEM.L	(A7)+,A0-A6/D0-D7
	MOVE.L	#EmptyHBL,$68.W
	MOVE.B	#$23,(A7)
	RTE

SetVBL	MOVE.B	#$12,$FFFFFC02.W
	LEA	OldVBL(PC),A0
	MOVE.L	$4D2.W,(A0)+
	MOVE	#$2700,SR
	MOVE.L	#VBL2,$4D2.W
	MOVE	#$2300,SR
	RTS

RemoveVBL	LEA	OldVBL(PC),A0
	MOVE	#$2700,SR
	MOVE.L	(A0)+,$4D2.W
	MOVE	#$2300,SR
	MOVE.B	#8,$FFFFFC02.W
	RTS
OldVBL	DCB.L	10,0

GetKey	MOVE.W	D7,-(A7)
.Test	BTST	#0,$FFFFFC00.W
	BEQ.S	.NoCarac
	MOVE.B	$FFFFFC02.W,D7
	BRA.S	.Test
.NoCarac	MOVE.W	(A7)+,D7
	RTS

AffDegas	MOVEA.L	Screen2,A0
	MOVEA.L	Screen1,A1
	MOVE.W	#7999,D0
.Copy	MOVE.L	(A0)+,(A1)+
	DBF	D0,.Copy
	MOVE.W	#1,VBLCount
.Vsync	TST.W	VBLCount
	BNE.S	.Vsync
	MOVEM.L	PicPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	RTS
	
DepackDegas
	ADDQ.W	#2,A0
	MOVEQ	#$F,D0
	LEA	PicPal,A1
.DegasFD	MOVE.W	(A0)+,D1
	MOVE.W	D1,(A1)+
	DBF	D0,.DegasFD
	MOVEA.L	Screen2,A1
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVE.W	#$C7,D5
.DegasFE	MOVE.B	(A0)+,D1
	EXT.W	D1
	BPL.S	.Degas03
	CMP.B	#-$80,D1
	BEQ.S	.DegasFE
	NEG.W	D1
	MOVE.B	(A0)+,D2
.DegasFF	MOVE.B	D2,(A1)+
	ADDQ.W	#1,D3
	CMP.B	#$28,D3
	BEQ.S	.Degas01
	BTST	#0,D3
	BNE.S	.Degas00
	ADDQ.W	#6,A1
.Degas00	DBF	D1,.DegasFF
	BRA.S	.DegasFE
.Degas01	MOVEQ	#0,D3
	ADDQ.W	#1,D4
	CMP.B	#4,D4
	BEQ.S	.Degas02
	SUBA.W	#$98,A1
	BRA.S	.Degas00
.Degas02	MOVEQ	#0,D4
	DBF	D5,.Degas00
	BRA.S	.Degas07
.Degas03	MOVE.B	(A0)+,(A1)+
	ADDQ.W	#1,D3
	CMP.B	#$28,D3
	BEQ.S	.Degas05
	BTST	#0,D3
	BNE.S	.Degas04
	ADDQ.W	#6,A1
.Degas04	DBF	D1,.Degas03
	BRA.S	.DegasFE
.Degas05	MOVEQ	#0,D3
	ADDQ.W	#1,D4
	CMP.B	#4,D4
	BEQ.S	.Degas06
	SUBA.W	#$98,A1
	BRA.S	.Degas04
.Degas06	MOVEQ	#0,D4
	DBF	D5,.Degas04
.Degas07	RTS

DepackTiny	MOVEQ	#8,D6
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVE.B	(A0)+,D0
	CMP.B	#2,D0
	BLE.S	.Tiny09
	ADDQ.W	#4,A0
	SUBQ.B	#3,D0
.Tiny09	MOVE.B	D0,$FFFF8260.W
	MOVEQ	#$F,D0
	LEA	PicPal(PC),A1
.Tiny0A	MOVE.B	(A0)+,D1
	LSL.W	D6,D1
	MOVE.B	(A0)+,D1
	MOVE.W	D1,(A1)+
	DBF	D0,.Tiny0A
	MOVE.B	(A0)+,D0
	LSL.W	D6,D0
	MOVE.B	(A0)+,D0
	MOVE.W	D0,D1
	ADDQ.W	#2,A0
	MOVEA.L	A0,A1
	LEA	0(A0,D1.W),A2
	MOVEA.L	Screen2,A0
	MOVEA.L	A0,A3
.Tiny0B	MOVEQ	#0,D0
	MOVE.B	(A1)+,D0
	BMI.S	.Tiny11
	BEQ.S	.Tiny0C
	CMP.B	#1,D0
	BEQ.S	.Tiny12
	BRA.S	.Tiny0D
.Tiny0C	MOVE.B	(A1)+,D0
	LSL.W	D6,D0
	MOVE.B	(A1)+,D0
.Tiny0D	SUBQ.W	#1,D0
	MOVE.B	(A2)+,D1
	LSL.W	D6,D1
	MOVE.B	(A2)+,D1
.Tiny0E	MOVE.W	D1,(A0)
	LEA	160(A0),A0
	ADDQ.W	#1,D2
	CMP.W	#$C8,D2
	BLT.S	.Tiny0F
	MOVEQ	#0,D2
	LEA	-31992(A0),A0
	ADDQ.W	#1,D3
	CMP.W	#$14,D3
	BLT.S	.Tiny0F
	MOVEQ	#0,D3
	ADDQ.W	#2,D4
	CMP.W	#6,D4
	BGT.S	.Tiny10
	LEA	0(A3,D4.W),A0
.Tiny0F	DBF	D0,.Tiny0E
	BRA.S	.Tiny0B
.Tiny10	RTS
.Tiny11	NEG.B	D0
	BRA.S	.Tiny13
.Tiny12	MOVE.B	(A1)+,D0
	LSL.W	D6,D0
	MOVE.B	(A1)+,D0
.Tiny13	SUBQ.W	#1,D0
.Tiny14	MOVE.B	(A2)+,D1
	LSL.W	D6,D1
	MOVE.B	(A2)+,D1
	MOVE.W	D1,(A0)
	LEA	160(A0),A0
	ADDQ.W	#1,D2
	CMP.W	#$C8,D2
	BLT.S	.Tiny15
	MOVEQ	#0,D2
	LEA	-31992(A0),A0
	ADDQ.W	#1,D3
	CMP.W	#$14,D3
	BLT.S	.Tiny15
	MOVEQ	#0,D3
	ADDQ.W	#2,D4
	CMP.W	#6,D4
	BGT.S	.Tiny10
	LEA	0(A3,D4.W),A0
.Tiny15	DBF	D0,.Tiny14
	BRA	.Tiny0B
	MOVE.B	$FFFFFC02.W,D0
	CMP.B	#$39,D0
	BEQ.S	.Tiny16
	RTS
.Tiny16	ADDQ.W	#4,A7


EndPrg	BSR	RestAll
	BSR.S	RestScr
	MOVE.L	OldStack,-(A7)
	MOVE.W	#$20,-(A7)
	TRAP	#1
	ADDQ.W	#6,A7
	CLR.W	-(A7)
	TRAP	#1

InitScr	MOVE.W	#2,-(A7)
	TRAP	#$E
	ADDQ.W	#2,A7
	MOVE.L	D0,OldScreen
	MOVE.W	#4,-(A7)
	TRAP	#$E
	ADDQ.W	#2,A7
	MOVE.W	D0,OldRez
	MOVE.L	#Buffer2,D0
	CLR.B	D0
	MOVE.L	D0,Screen2
	MOVE.L	#Buffer1,D0
	CLR.B	D0
	MOVE.L	D0,Screen1
	LSR.W	#8,D0
	MOVE.L	D0,$FFFF8200.W
	MOVE.W	#0,-(A7)
	MOVE.L	#-1,-(A7)
	MOVE.L	#-1,-(A7)
	MOVE.W	#5,-(A7)
	TRAP	#$E
	ADDA.W	#$C,A7
	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,OldPal
	RTS

RestScr	MOVEM.L	OldPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.W	OldRez,-(A7)
	MOVE.L	OldScreen,-(A7)
	MOVE.L	OldScreen,-(A7)
	MOVE.W	#5,-(A7)
	TRAP	#$E
	ADDA.W	#$C,A7
	move.l	Old4d2,$4D2.W
	MOVE.B	OldFrq(PC),$FFFF820A.W
	RTS

SaveAll	move.l	$4d2.w,Old4d2
	LEA	OldAll,A0
	MOVE	USP,A1
	MOVE.L	A1,(A0)+
	MOVE.L	$68.W,(A0)+
	MOVE.L	$70.W,(A0)+
	MOVE.L	$118.W,(A0)+
	MOVE.L	$134.W,(A0)+
	MOVE.L	$120.W,(A0)+
	MOVE.B	$FFFFFA07.W,(A0)+
	MOVE.B	$FFFFFA09.W,(A0)+
	MOVE.B	$FFFFFA13.W,(A0)+
	MOVE.B	$FFFFFA15.W,(A0)+
	MOVE.B	$FFFFFA1F.W,(A0)+
	MOVE.B	$FFFFFA21.W,(A0)+
	MOVE.B	$FFFFFA19.W,(A0)+
	MOVE.B	$FFFFFA1B.W,(A0)+
	MOVE.B	$FFFFFA17.W,(A0)+
	MOVE	#$2700,SR
	MOVE.L	#VBL1,$4D2.W
	MOVE	#$2300,SR
	RTS

RestAll	MOVE	#$2700,SR
	LEA	OldAll,A0
	MOVEA.L	(A0)+,A1
	MOVE	A1,USP
	MOVE.L	(A0)+,$68.W
	MOVE.L	(A0)+,$70.W
	MOVE.L	(A0)+,$118.W
	MOVE.L	(A0)+,$134.W
	MOVE.L	(A0)+,$120.W
	MOVE.B	(A0)+,$FFFFFA07.W
	MOVE.B	(A0)+,$FFFFFA09.W
	MOVE.B	(A0)+,$FFFFFA13.W
	MOVE.B	(A0)+,$FFFFFA15.W
	MOVE.B	(A0)+,$FFFFFA1F.W
	MOVE.B	(A0)+,$FFFFFA21.W
	MOVE.B	(A0)+,$FFFFFA19.W
	MOVE.B	(A0)+,$FFFFFA1B.W
	MOVE.B	(A0)+,$FFFFFA17.W
	MOVE	#$2300,SR
	RTS

VBL1	TST.W	VBLCount
	BLE.S	.NoSub
	SUBQ.W	#1,VBLCount
.NoSub	RTS

TestKbd	CLR.L	Key
.Test	MOVE.W	#$B,-(A7)
	TRAP	#1
	ADDQ.W	#2,A7
	TST.L	D0
	BEQ.S	.NoCarac
	MOVE.W	#1,-(A7)
	TRAP	#1
	ADDQ.W	#2,A7
	MOVE.L	D0,Key
	BRA.S	.Test
.NoCarac	MOVE.L	Key(PC),D0
	TST.B	D0
	BEQ.S	.NoASCII
	CMP.B	#$1B,D0
	SEQ	KeyEsc
	CMP.B	#' ',D0
	SEQ	KeySpace
	CMP.B	#$D,D0
	BNE.S	.NoASCII
	SF	KeySpace
.NoASCII	SWAP	D0
	cmp.b	#$1F,d0
	seq	KeySave
	CMP.B	#$3B,D0
	BLT.S	.NoFunc
	CMP.B	#$44,D0
	BGT.S	.NoFunc
	SUBI.B	#$3B,D0
	EXT.W	D0
	LSL.W	#8,D0
	ADD.W	D0,D0
	ADDI.W	#$32,D0
	MOVE.W	D0,VBLToWait
.NoFunc	RTS

Key	DCB.W	4,0

ClearKbd	MOVEM.L	A0-A6/D0-D7,-(A7)
.Test	MOVE.W	#$B,-(A7)
	TRAP	#1
	ADDQ.W	#2,A7
	TST.L	D0
	BEQ.S	.Empty
	MOVE.W	#7,-(A7)
	TRAP	#1
	ADDQ.W	#2,A7
	BRA.S	.Test
.Empty	MOVEM.L	(A7)+,A0-A6/D0-D7
	RTS

VBLToWait	DC.W	$320
OldFrq	DC.B	0,0

	MOVEM.L	PicPal,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	RTS
	MOVE.L	Screen2,D7
	MOVE.L	Screen1,Screen2
	MOVE.L	D7,Screen1
	MOVE.B	D7,D0
	LSR.W	#8,D7
	MOVE.L	D7,$FFFF8200.W
	MOVE.B	D0,$FFFF820D.W
	MOVE.W	#1,VBLCount
L0229	TST.W	VBLCount
	BNE.S	L0229
	RTS

ClearScreen
	LEA	32000(A0),A0
	MOVEQ	#0,D1
	MOVE.L	D1,D2
	MOVE.L	D1,D3
	MOVE.L	D1,D4
	MOVE.L	D1,D5
	MOVE.L	D1,D6
	MOVE.L	D1,D7
	MOVEA.L	D1,A1
	MOVEA.L	D1,A2
	MOVEA.L	D1,A3
	MOVEA.L	D1,A4
	MOVEA.L	D1,A5
	MOVEA.L	D1,A6
	MOVEQ	#$18,D0
.Clear	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A6/D1-D7,-(A0)
	MOVEM.L	A1-A4/D1-D4,-(A0)
	DBF	D0,.Clear
	RTS
	MOVE.W	#$1F3F,D0
L022C	MOVE.L	(A0)+,(A1)+
	DBF	D0,L022C
	RTS


IceDepack	MOVEM.L	A0-A6/D0-D7,-(A7)
	BSR.S	.Ice32
	CMPI.L	#$49434521,D0
	BNE.S	.Ice31
	BSR.S	.Ice32
	LEA	-8(A0,D0.L),A5
	BSR.S	.Ice32
	MOVE.L	D0,(A7)
	MOVEA.L	A1,A4
	MOVEA.L	A1,A6
	ADDA.L	D0,A6
	MOVEA.L	A6,A3
	MOVE.B	-(A5),D7
	BSR.S	.Ice34
	MOVEA.L	A3,A6
	BSR.S	.Ice38
	BCC.S	.Ice31
	MOVE.W	#$F9F,D7
	BSR.S	.Ice38
	BCC.S	.Ice2E
	MOVEQ	#$F,D0
	BSR.S	.Ice3A
	MOVE.W	D1,D7
.Ice2E	MOVEQ	#3,D6
.Ice2F	MOVE.W	-(A3),D4
	MOVEQ	#3,D5
.Ice30	ADD.W	D4,D4
	ADDX.W	D0,D0
	ADD.W	D4,D4
	ADDX.W	D1,D1
	ADD.W	D4,D4
	ADDX.W	D2,D2
	ADD.W	D4,D4
	ADDX.W	D3,D3
	DBF	D5,.Ice30
	DBF	D6,.Ice2F
	MOVEM.W	D0-D3,(A3)
	DBF	D7,.Ice2E
.Ice31	MOVEM.L	(A7)+,A0-A6/D0-D7
	RTS
.Ice32	MOVEQ	#3,D1
.Ice33	LSL.L	#8,D0
	MOVE.B	(A0)+,D0
	DBF	D1,.Ice33
	RTS
.Ice34	BSR.S	.Ice38
	BCC.S	.Ice37
	MOVEQ	#0,D1
	BSR.S	.Ice38
	BCC.S	.Ice36
	LEA	.Ice45(PC),A1
	MOVEQ	#4,D3
.Ice35	MOVE.L	-(A1),D0
	BSR.S	.Ice3A
	SWAP	D0
	CMP.W	D0,D1
	DBNE	D3,.Ice35
	ADD.L	20(A1),D1
.Ice36	MOVE.B	-(A5),-(A6)
	DBF	D1,.Ice36
.Ice37	CMPA.L	A4,A6
	BGT.S	.Ice3D
	RTS
.Ice38	ADD.B	D7,D7
	BNE.S	.Ice39
	MOVE.B	-(A5),D7
	ADDX.B	D7,D7
.Ice39	RTS
.Ice3A	MOVEQ	#0,D1
.Ice3B	ADD.B	D7,D7
	BNE.S	.Ice3C
	MOVE.B	-(A5),D7
	ADDX.B	D7,D7
.Ice3C	ADDX.W	D1,D1
	DBF	D0,.Ice3B
	RTS
.Ice3D	LEA	.Ice46(PC),A1
	MOVEQ	#3,D2
.Ice3E	BSR.S	.Ice38
	DBCC	D2,.Ice3E
	MOVEQ	#0,D4
	MOVEQ	#0,D1
	MOVE.B	1(A1,D2.W),D0
	EXT.W	D0
	BMI.S	.Ice3F
	BSR.S	.Ice3A
.Ice3F	MOVE.B	6(A1,D2.W),D4
	ADD.W	D1,D4
	BEQ.S	.Ice41
	LEA	.Ice47(PC),A1
	MOVEQ	#1,D2
.Ice40	BSR.S	.Ice38
	DBCC	D2,.Ice40
	MOVEQ	#0,D1
	MOVE.B	1(A1,D2.W),D0
	EXT.W	D0
	BSR.S	.Ice3A
	ADD.W	D2,D2
	ADD.W	6(A1,D2.W),D1
	BPL.S	.Ice43
	SUB.W	D4,D1
	BRA.S	.Ice43
.Ice41	MOVEQ	#0,D1
	MOVEQ	#5,D0
	MOVEQ	#-1,D2
	BSR.S	.Ice38
	BCC.S	.Ice42
	MOVEQ	#8,D0
	MOVEQ	#$3F,D2
.Ice42	BSR.S	.Ice3A
	ADD.W	D2,D1
.Ice43	LEA	2(A6,D4.W),A1
	ADDA.W	D1,A1
	MOVE.B	-(A1),-(A6)
.Ice44	MOVE.B	-(A1),-(A6)
	DBF	D4,.Ice44
	BRA	.Ice34
	DC.B	$7F,$FF,$00,$0E,$00,$FF,$00,$07
	DC.B	$00,$07,$00,$02,$00,$03,$00,$01
	DC.B	$00,$03,$00,$01
.Ice45	DC.B	$00,$00,$01,$0D,$00,$00,$00,$0E
	DC.B	$00,$00,$00,$07,$00,$00,$00,$04
	DC.B	$00,$00,$00,$01
.Ice46	DC.B	$09,$01,$00,$FF,$FF,$08,$04,$02
	DC.B	$01,$00
.Ice47	DC.B	$0B,$04,$07,$00,$01,$1F,$FF,$FF
	DC.B	$00,$1F

	SECTION	BSS

ScrBuf1	DS.L	1
ScrBuf2	DS.L	1
Pal1Point	DS.L	1
Pal2Point	DS.L	1
OldAll	DS.B	40
KeyEsc	DS.B	1
KeySpace	DS.B	1
KeySave	ds.b	1
VBLCount	DS.W	1
Screen1	DS.L	1
Screen2	DS.L	1
OldScreen	DS.L	1
OldStack	DS.L	1
Old4d2	ds.l	1
OldRez	DS.W	1
OldPal	DS.B	32
BlackPal	DS.B	32
PicPal	DS.B	32
PCSPal1	DS.B	19232
PCSPal2	DS.B	19487
Buffer1	DS.B	32256
Buffer2	DS.B	32001
LoadBuf

