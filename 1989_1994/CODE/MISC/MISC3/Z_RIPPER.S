ADR_RIP = $F58F0

	OPT	O+

 	CLR.L	-(SP)
 	MOVE	#$20,-(SP)
 	TRAP	#1
 	ADDQ.L	#6,SP

	PEA	MSG
	MOVE	#9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	

 	MOVE.L	#$31415926,$426.W
 	MOVE.L	#ADR_RIP,$42A.W

 	LEA	ROUTINE,A0
 	LEA	ADR_RIP,A1
 	MOVE.L	#(10000/4)-1,D0
COP	MOVE.L	(A0)+,(A1)+
 	DBF	D0,COP
RELOC
	LEA	ADR_RIP,A0
	MOVE.L	A0,A1
	ADD.L	2(A0),A1
	ADD.L	6(A0),A1
	LEA	31(A1),A1
	MOVEQ	#0,D0
	
	LEA	ADR_RIP+28,A0
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
RELOC_END	
	
	PEA	MSG2
	MOVE	#9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	

TET 	CMPI.B	#$02,$FFFFFC02.W
 	BEQ	BOOTER
 	CMPI.B	#$03,$FFFFFC02.W
 	BNE.S	TET
* Retour au bureau
 	CLR.L	-(SP)
 	TRAP	#1
* Boot
BOOT	DS.B	512
	EVEN
BOOTER
	MOVE	#1,-(SP)
	MOVE	#0,-(SP)
	MOVE	#0,-(SP)
	MOVE	#1,-(SP)
	MOVE	#0,-(SP)
	CLR.L	-(SP)
	MOVE.L	#BOOT,-(SP)
	MOVE	#8,-(SP)
	TRAP	#14
	ADDA.L	#20,SP
	JMP	BOOT

MSG	DC.B	'* Z-Ripper v1.0 * - Code by Zappy/Holocaust 18/11/91',$a,$A,$d,0
	;DC.B	'Nom de la sauvegarde ? ',$a,$d,$a,0
	EVEN
MSG2	
	DC.B	'La routine est relog‚e en $FD800.',$a,$d,$a
	dc.b	'1......Ex‚cuter un boot ( ex‚cutable de pr‚f‚rence ! )',$a,$d
	dc.b	'2.....................................Partir du bureau',0
	EVEN
**** 
ROUTINE
	INCBIN	ROUTINE.DAT