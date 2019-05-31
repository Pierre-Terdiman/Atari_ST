L0013 EQU ZUEND+$1BA
L0014 EQU ZUEND+$342
 TEXT 
Begin:
0276B0  601C                      BRA.S   28(PC)                 L0000
0276B2  9049424D2020BF94          DC.B   $90,'IBM  ',$BF,$94
0276BA  9B00020201000270          DC.B   $9B,$00,$02,$02,$01,$00,$02,'p'
0276C2  00A005F903000900          DC.B   $00,$A0,$05,$F9,$03,$00,$09,$00
0276CA  02000000                  DC.B   $02,$00,$00,$00
0276CE  487A01A6            L0000:PEA     422(PC)                L0011
0276D2  3F3C0009                  MOVE.W  #9,-(A7)              
0276D6  4E41                      TRAP    #1                    
0276D8  5C8F                      ADDQ.L  #6,A7                 
0276DA  41FA0154                  LEA     340(PC),A0             L000E
0276DE  43FA038A                  LEA     906(PC),A1             L0013
0276E2  740D                      MOVEQ   #$D,D2                
0276E4  3018                L0001:MOVE.W  (A0)+,D0              
0276E6  720C                      MOVEQ   #$C,D1                
0276E8  3299                L0002:MOVE.W  (A1)+,(A1)            
0276EA  0C410005                  CMPI.W  #5,D1                 
0276EE  6602                      BNE.S   2(PC)                  L0003
0276F0  4440                      NEG.W   D0                    
0276F2  D151                L0003:ADD.W   D0,(A1)               
0276F4  51C9FFF2                  DBF     D1,-14(PC)             L0002
0276F8  5489                      ADDQ.L  #2,A1                 
0276FA  51CAFFE8                  DBF     D2,-24(PC)             L0001
0276FE  2F3C001A0005              MOVE.L  #$1A0005,-(A7)        
027704  4E4E                      TRAP    #$E                   
027706  588F                      ADDQ.L  #4,A7                 
027708  2F3C001A0006              MOVE.L  #$1A0006,-(A7)        
02770E  4E4E                      TRAP    #$E                   
027710  588F                      ADDQ.L  #4,A7                 
027712  41FA0192                  LEA     402(PC),A0             L0012
027716  43FA04DA                  LEA     1242(PC),A1            L0014
02771A  2290                      MOVE.L  (A0),(A1)             
02771C  2F380120                  MOVE.L  $120.S,-(A7)          
027720  1F38FA07                  MOVE.B  -$5F9.S,-(A7)         
027724  1F38FA13                  MOVE.B  -$5ED.S,-(A7)         
027728  41FA0080                  LEA     128(PC),A0             L0008
02772C  21C80120                  MOVE.L  A0,$120.S             
027730  00380001FA07              ORI.B   #1,-$5F9.S            
027736  00380001FA13              ORI.B   #1,-$5ED.S            
02773C  11FC0001FA21              MOVE.B  #1,-$5DF.S            
027742  2F3804CE                  MOVE.L  $4CE.S,-(A7)          
027746  41FA0076                  LEA     118(PC),A0             L0009
02774A  21C804CE                  MOVE.L  A0,$4CE.S             
02774E  0C38003BFC02        L0004:CMPI.B  #$3B,-$3FE.S          ;(#";") 
027754  6606                      BNE.S   6(PC)                  L0005
027756  11FC0002820A              MOVE.B  #2,-$7DF6.S           
02775C  0C38003CFC02        L0005:CMPI.B  #$3C,-$3FE.S          ;(#"<") 
027762  6604                      BNE.S   4(PC)                  L0006
027764  4238820A                  CLR.B   -$7DF6.S              
027768  0C380039FC02        L0006:CMPI.B  #$39,-$3FE.S          ;(#"9") 
02776E  66DE                      BNE.S   -34(PC)                L0004
027770  21DF04CE                  MOVE.L  (A7)+,$4CE.S          
027774  11DFFA13                  MOVE.B  (A7)+,-$5ED.S         
027778  11DFFA07                  MOVE.B  (A7)+,-$5F9.S         
02777C  21DF0120                  MOVE.L  (A7)+,$120.S          
027780  2F3C001B0005              MOVE.L  #$1B0005,-(A7)        
027786  4E4E                      TRAP    #$E                   
027788  588F                      ADDQ.L  #4,A7                 
02778A  2F3C001B0006              MOVE.L  #$1B0006,-(A7)        
027790  4E4E                      TRAP    #$E                   
027792  588F                      ADDQ.L  #4,A7                 
027794  2078044E                  MOVEA.L $44E.S,A0             
027798  303C1F3F                  MOVE.W  #$1F3F,D0             
02779C  4298                L0007:CLR.L   (A0)+                 
02779E  51C8FFFC                  DBF     D0,-4(PC)              L0007
0277A2  31FC07778240              MOVE.W  #$777,-$7DC0.S        
0277A8  4E75                      RTS                           
0277AA  2C7A0446            L0008:MOVEA.L 1094(PC),A6            L0014
0277AE  31D68240                  MOVE.W  (A6),-$7DC0.S         
0277B2  4DFA043E                  LEA     1086(PC),A6            L0014
0277B6  5496                      ADDQ.L  #2,(A6)               
0277B8  4238FA0F                  CLR.B   -$5F1.S               
0277BC  4E73                      RTE                           
0277BE  42788240            L0009:CLR.W   -$7DC0.S              
0277C2  41FA00E2                  LEA     226(PC),A0             L0012
0277C6  7063                      MOVEQ   #$63,D0               
0277C8  4298                L000A:CLR.L   (A0)+                 
0277CA  51C8FFFC                  DBF     D0,-4(PC)              L000A
0277CE  41FA00D6                  LEA     214(PC),A0             L0012
0277D2  43FA041E                  LEA     1054(PC),A1            L0014
0277D6  2288                      MOVE.L  A0,(A1)               
0277D8  41FA0290                  LEA     656(PC),A0             L0013
0277DC  43FA006E                  LEA     110(PC),A1             L000F
0277E0  45FA0086                  LEA     134(PC),A2             L0010
0277E4  700D                      MOVEQ   #$D,D0                
0277E6  48E7FFFC            L000B:MOVEM.L A0-A5/D0-D7,-(A7)     
0277EA  3011                      MOVE.W  (A1),D0               
0277EC  4CD800FE                  MOVEM.L (A0)+,D1-D7           
0277F0  41FA00B4                  LEA     180(PC),A0             L0012
0277F4  D1C0                      ADDA.L  D0,A0                 
0277F6  48E03F00                  MOVEM.L D2-D7,-(A0)           
0277FA  3101                      MOVE.W  D1,-(A0)              
0277FC  0C510018                  CMPI.W  #$18,(A1)             
027800  6E04                      BGT.S   4(PC)                  L000C
027802  4412                      NEG.B   (A2)                  
027804  6008                      BRA.S   8(PC)                  L000D
027806  0C51018C            L000C:CMPI.W  #$18C,(A1)            
02780A  6D02                      BLT.S   2(PC)                  L000D
02780C  4412                      NEG.B   (A2)                  
02780E  4280                L000D:CLR.L   D0                    
027810  1012                      MOVE.B  (A2),D0               
027812  4880                      EXT.W   D0                    
027814  D151                      ADD.W   D0,(A1)               
027816  4CDF3FFF                  MOVEM.L (A7)+,A0-A5/D0-D7     
02781A  D1FC0000001C              ADDA.L  #$1C,A0               
027820  5489                      ADDQ.L  #2,A1                 
027822  528A                      ADDQ.L  #1,A2                 
027824  51C8FFC0                  DBF     D0,-64(PC)             L000B
027828  11FC0008FA1B              MOVE.B  #8,-$5E5.S            
02782E  4E75                      RTS                           
027830  0110001101010100    L000E:DC.B   $01,$10,$00,$11,$01,$01,$01,$00
027838  0110001000110001          DC.B   $01,$10,$00,$10,$00,$11,$00,$01
027840  0101011101000010          DC.B   $01,$01,$01,$11,$01,$00,$00,$10
027848  00010111                  DC.B   $00,$01,$01,$11
02784C  00C600FE013600AA    L000F:DC.B   $00,$C6,$00,$FE,$01,'6',$00,$AA
027854  00C600E200FE011A          DC.B   $00,$C6,$00,$E2,$00,$FE,$01,$1A
02785C  0136015200AA00E2          DC.B   $01,'6',$01,'R',$00,$AA,$00,$E2
027864  011A0152                  DC.B   $01,$1A,$01,'R'
027868  020202FCFCFCFCFC    L0010:DC.B   $02,$02,$02,$FC,$FC,$FC,$FC,$FC
027870  FCFC02020202              DC.B   $FC,$FC,$02,$02,$02,$02
027876  1B62011B59202C54    L0011:DC.B   $1B,'b',$01,$1B,'Y ,T' 
02787E  484520434F52504F          DC.B   'HE CORPO' 
027886  524154494F4E1B59          DC.B   'RATION',$1B,'Y' 
02788E  242C46312D46323A          DC.B   '$,F1-F2:' 
027896  2035302D36302048          DC.B   ' 50-60 H' 
02789E  7A1B620F1B48003A          DC.B   'z',$1B,'b',$0F,$1B,'H',$00,':'
0278A6                      L0012:DS.W    4,0 
0278AE  62B3                      DC.B   'b',$B3
ZUEND: END
