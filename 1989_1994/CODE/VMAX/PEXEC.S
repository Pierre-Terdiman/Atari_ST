
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

	PEA	0
	PEA	0
	PEA	NOM
	CLR.W	-(SP)
	MOVE	#$4B,-(SP)
	TRAP	#1
	ADDA.L	#16,A7

	CLR.W	-(A7)		
	TRAP	#1

NOM	DC.B	"a:\vmax6.prg",0   
	EVEN

	section	bss
	
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	