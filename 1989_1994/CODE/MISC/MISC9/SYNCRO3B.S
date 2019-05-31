	MOVE	#0,-(SP)
	MOVE	#2,-(SP)
	MOVE	#1,-(SP)
	MOVE.L	#TAM,-(SP)
	MOVE	#3,-(SP)
	MOVE	#4,-(SP)
	TRAP	#13
	ADDA.L	#14,SP
	
TAM	
	OPT	O+,A+,P+
 	SECTION	TEXT 

  BSR.S     L0005 
	PEA	TT
	MOVE	#$9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

  LEA	L000D,A6
  MOVE.L  $70.W,(A6)
  LEA	L0002,A6
  MOVE.L  A6,$70.W
L0000:JMP     L0000 

L0002:MOVE.W  #$F00,D7
  MOVE.B  #$18,D0 
  MOVEQ   #0,D6 
  MOVEQ   #0,D5 
  LEA     L000F,A0
  LEA     L000A,A1
  LEA	L000E,A6
  ADDA.L  (A6),A1
  CMPI.W  #-1,(A1)
  BNE.S     L0003 
  LEA	L000E,A6
  CLR.L   (A6)
  LEA     L000A,A1
L0003:ADDA.W  (A1),A0 
  MOVE    #$2700,SR 
L0004:TST.B   $FFFF8209.W
  BEQ.S     L0004 
  SUB.B   $FFFF8209.W,D0 
  LSR.L   D0,D0 
  JSR     (A0)
  MOVE.W  #0,$FFFF8240.W 
  MOVE    #$2300,SR 
  LEA	L000E,A6 
  ADDQ.L  #2,(A6)
  RTE 
L0005:MOVEQ   #0,D0 
  LEA     L000F,A0
  MOVE.W  #$A8,D5 
L0006:MOVE.W  #$4E71,(A0)+
  DBF     D5,L0006
  MOVE.W  #$ED,D7 
L0007:MOVE.W  #7,D6 
L0008:MOVE.W  #$31FC,(A0)+
  MOVE.W  D0,(A0)+
  MOVE.W  #-$7DC0,(A0)+ 
  ADDQ.W  #1,D0 
  DBF     D6,L0008
  MOVE.W  #$31FC,(A0)+
  MOVE.W  #0,(A0)+
  MOVE.W  #-$7DC0,(A0)+ 
  MOVE.W  #$5B,D6 
L0009:MOVE.W  #$4E71,(A0)+
  DBF     D6,L0009
  DBF     D7,L0007
  MOVE.W  #$4E75,(A0)+
  RTS 
 	SECTION	DATA 
L000A:DS.L	1;DS.W    1,0 
  DC.B   $00,$02,$00,$04,$00,$06,$00,$08
  DC.B   $00,$0A,$00,$0C,$00,$0E,$00,$10
  DC.B   $00,$12,$00,$14,$00,$16,$00,$18
  DC.B   $00,$1A,$00,$1C,$00,$1E,$00,' '
  DC.B   $00,'"',$00,'$',$00,'&',$00,'('
  DC.B   $00,'*',$00,',',$00,'.',$00,'0'
  DC.B   $00,'2',$00,'4',$00,'6',$00,'8'
  DC.B   $00,':',$00,'<',$00,'>',$00,'@'
  DC.B   $00,'B',$00,'D',$00,'F',$00,'H'
  DC.B   $00,'J',$00,'L',$00,'N',$00,'P'
  DC.B   $00,'R',$00,'T',$00,'V',$00,'X'
  DC.B   $00,'Z',$00,'\',$00,'^',$00,'`'
  DC,B   $00,'b',$00,'d',$00,'f',$00,'h'
  DC.B   $00,'j',$00,'l',$00,'n',$00,'p'
  DC.B   $00,'r',$00,'t',$00,'v',$00,'x'
  DC.B   $00,'z%,$00,'|',$00,'~',$00,$80
  DC.B   $00,$80,$00,'~',$00,'|',$00,'z'
  DC.B   $00,'x',$00,'v',$00,'t',$00,'r'
  DC.B   $00,'p',$00,'n',$00,'l',$00,'j'
  DC.B   $00,'h',$00,'f',$00,'d',$00,'b'
  DC.B   $00,'`',$00,'^',$00,'\',$00,'Z'
  DC.B   $00,'X',$00,'V',$00,'T',$00,'R'
  DC.B   $00,'P',$00,'N',$00,'L',$00,'J'
  DC.B   $00,'H',$00,'F',$00,'D',$00,'B'
  DC.B   $00,'@',$00,'>',$00,'<',$00,':'
  DC.B   $00,'8',$00,'6',$00,'4',$00,'2'
  DC.B   $00,'0',$00,'.',$00,',',$00,'*'
  DC.B   $00,'(',$00,'&%,$00,'$',$00,'"'
  DC.B   $00,' ',$00,$1E,$00,$1C,$00,$1A
  DC.B   $00,$18,$00,$16,$00,$14,$00,$12
  DC.B   $00,$10,$00,$0E,$00,$0C,$00,$0A
  DC.B   $00,$08,$00,$06,$00,$04,$00,$02
  DS.L	1	;DS.W    1,0 
  DC.B   $FF,$FF
TT	DC.B	"TRY TO CRACK THAT, ELRIC ! ",0
L000B DS.L	16
L000C DS.L	1
L000D ds.l	1
L000E DS.L	1
L000F DS.L	$A9
