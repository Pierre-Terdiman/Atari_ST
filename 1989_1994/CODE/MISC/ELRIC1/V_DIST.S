	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	D0,SAUV_SP
	
	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	MOVE.L	#FIN,$008
	MOVE.L	#FIN,$00C
	MOVE.L	#FIN,$010
	MOVE.L	#FIN,$014
	MOVE.L	#FIN,$018
	MOVE.L	#FIN,$01C
	MOVE.L	#FIN,$020
	MOVE.L	#FIN,$024

	ANDI.B	#%11111000,$484.W
	
	