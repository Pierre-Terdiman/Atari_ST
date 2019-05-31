 TEXT 
Begin:
          PEA     0.W
          MOVE.W  #$20,-(A7)
          TRAP    #1
          ADDQ.L	#6,SP
          
          LEA     ZIK+2688(PC),A0 
          LEA     ZIK+12(PC),A1 
          MOVE.L  A0,(A1) 
          MOVEQ   #6,D0 
          JSR	ZIK
          
          MOVE.L	#ZIK+8,$4D2.W
          
          MOVE	#$7,-(SP)
          TRAP	#1
          ADDQ.L	#2,SP
          
          CLR.L	$4D2.W
          JSR	ZIK+4
          
          PEA	0.W
          TRAP	#1
          
ZIK	INCBIN	FRAG.MUS