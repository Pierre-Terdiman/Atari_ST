
YM_PLAYE: BRA     INIT
L0011:    BRA     END 
L0012:    BRA     PLAY
MUSIXX:   DS.W    2 
INIT:     MOVEM.L A0-A6/D0-D7,-(A7) 
          MOVE.B  #2,$484.W
          LEA     VOICE1(PC),A0 
          LEA     FINEFFAC(PC),A1 
          SUBA.L  A0,A1 
          MOVE.L  A1,D1 
          SUBQ.L  #1,D1 
LOOP1:    CLR.B   (A0)+ 
          DBF     D1,LOOP1
          MOVEA.L MUSIXX(PC),A0 
          LEA     OFFSET(PC),A1 
          MOVE.W  #$977,4(A1) 
          MOVE.W  #$9F8,6(A1) 
          MOVE.B  D0,2(A1)
          MOVE.B  D0,3(A1)
          LEA     INST_STA(PC),A1 
          LEA     22(A0),A0 
          MOVEQ   #$F,D0
LOOP2:    MOVE.L  A0,(A1)+
          LEA     150(A0),A0
          DBF     D0,LOOP2
          LEA     STECHG(PC),A1 
          MOVE.W  #$4E71,D0 
          MOVEQ   #5,D1 
NOPFILL:  MOVE.W  D0,(A1)+
          DBF     D1,NOPFILL
          LEA     VOICE1(PC),A1 
          LEA     L0079(PC),A2
          MOVE.L  A2,12(A1) 
          MOVE.L  A2,30(A1) 
          MOVE.L  A2,48(A1) 
          MOVE.L  A2,66(A1) 
          LEA     INST0(PC),A2
          LEA     CHIP(PC),A1 
          MOVE.L  A2,(A1) 
          MOVE.L  A2,6(A1)
          MOVE.L  A2,12(A1) 
          MOVE.L  A2,18(A1) 
          LEA     T_COMMAN(PC),A0 
          LEA     NO_COMMA(PC),A1 
          MOVE.L  A1,60(A0) 
          MOVE.L  A1,56(A0) 
          MOVE.L  A1,52(A0) 
          MOVE.L  A1,48(A0) 
          MOVE.L  A1,(A0)+
          LEA     PORTAMEN(PC),A1 
          MOVE.L  A1,(A0)+
          LEA     L002A(PC),A1
          MOVE.L  A1,(A0)+
          LEA     L002C(PC),A1
          MOVE.L  A1,(A0)+
          LEA     VIBRATO_(PC),A1 
          MOVE.L  A1,(A0)+
          LEA     L0031(PC),A1
          MOVE.L  A1,(A0)+
          LEA     SET_VOLU(PC),A1 
          MOVE.L  A1,(A0)+
          LEA     VOLUME_S(PC),A1 
          MOVE.L  A1,(A0)+
          LEA     NUL(PC),A1
          MOVE.L  A1,(A0)+
          LEA     DELAY(PC),A1
          MOVE.L  A1,(A0)+
          LEA     SET_TEMP(PC),A1 
          MOVE.L  A1,(A0)+
          LEA     ARPEGIO(PC),A1
          MOVE.L  A1,(A0)+
          LEA     8.W,A0
          MOVE.L  (A0),D2 
          LEA     NO_STE(PC),A1 
          MOVE.L  A1,(A0) 
          MOVEA.L A7,A2 
          MOVE.B  #1,$FFFF8901.W 	8901
          MOVE.W  #$7FF,$FFFF8924.W	8924
          MOVE.W  #$401,$FFFF8922.W	8922
STFRETUR: MOVE.L  D2,(A0) 
          MOVEM.L (A7)+,A0-A6/D0-D7 
END:      MOVE.L  D0,-(A7)
          MOVEQ   #$C,D0
YM_RESET: MOVE.B  D0,$FFFF8800.W 	8800
          CLR.B   $FFFF8802.W		8802
          DBF     D0,YM_RESET 
          MOVE.L  (A7)+,D0
          MOVE.L  #$700FF00,$FFFF8800.W
          RTS 
NO_STE:   LEA     STECHG(PC),A1 
          MOVE.W  #$4E71,D0 
          MOVEQ   #5,D1 
NOPFILL2: MOVE.W  D0,(A1)+
          DBF     D1,NOPFILL2 
          MOVEA.L A2,A7 
          PEA     STFRETUR(PC)
          RTS 
PLAY:     MOVEM.L A0-A6/D0-D7,-(A7) 
          LEA     MASK7(PC),A0
          MOVE.B  #-1,(A0)
          LEA     OFFSET(PC),A4 
          ADDQ.B  #1,3(A4)
          MOVE.B  3(A4),D0
          CMP.B   2(A4),D0
          BLT     JOUE_INS
          CLR.B   3(A4) 
          MOVEA.L MUSIXX(PC),A0 
          MOVEA.L A0,A2 
          ADDA.W  4(A4),A2
          ADDA.W  6(A4),A0
          MOVEQ   #0,D0 
          MOVEQ   #0,D1 
          MOVE.B  8(A4),D0
          MOVE.B  0(A2,D0.W),D1 
          SWAP    D1
          LSR.L   #6,D1 
          ADD.W   0(A4),D1
          LEA     CHIP(PC),A5 
          LEA     VOICE1(PC),A6 
          BSR.S   PLAYVOIC
          LEA     CHIP2(PC),A5
          LEA     VOICE2(PC),A6 
          BSR.S   PLAYVOIC
          LEA     CHIP3(PC),A5
          LEA     VOICE3(PC),A6 
          BSR.S   PLAYVOIC
STECHG:   LEA     CHIP4(PC),A5
          LEA     VOICE4(PC),A6 
          BSR     PLAYSTE 
          BRA     LIGNE_SU
PLAYVOIC: MOVE.L  0(A0,D1.L),D3 
          MOVE.W  2(A0,D1.L),2(A6)
          SWAP    D3
          TST.W   D3
          BEQ.S   PAS_INIT
          MOVEA.L 12(A6),A1 
          MOVE.W  4(A6),(A1)
          SWAP    D3
          MOVE.L  D3,(A6) 
          ANDI.W  #$F00,D3
          CMP.W   #$300,D3
          BNE.S   L0020 
          LEA     16(A0,D1.W),A1
          MOVE.W  (A1),4(A6)
          MOVE.L  A1,12(A6) 
          CLR.W   (A1)
L0020:    MOVE.B  #-1,6(A6) 
          MOVEQ   #0,D2 
          MOVE.B  2(A6),D2
          ANDI.W  #$F0,D2 
          LSR.B   #4,D2 
          LEA     INST_STA(PC),A1 
          ADD.W   D2,D2 
          ADD.W   D2,D2 
          MOVE.L  0(A1,D2.W),(A5) 
          CLR.W   4(A5) 
PAS_INIT: CLR.W   8(A6) 
          CLR.B   10(A6)
          ADDQ.W  #4,D1 
          RTS 
LIGNE_SU: ADDI.W  #$10,0(A4)
          CMPI.W  #$400,0(A4) 
          BNE.S   JOUE_INS
          CLR.W   0(A4) 
          ADDQ.B  #1,8(A4)
          ANDI.B  #$7F,8(A4)
          MOVEA.L MUSIXX(PC),A0 
          MOVE.B  8(A4),D0
          CMP.B   2422(A0),D0 
          BNE.S   JOUE_INS
          MOVE.B  21(A0),8(A4)
JOUE_INS: LEA     CHIP(PC),A5 
          LEA     VOICE1(PC),A6 
          BSR.S   CHECK_CO
          MOVEQ   #0,D2 
          BSR     READ_INS
          LEA     CHIP2(PC),A5
          LEA     VOICE2(PC),A6 
          BSR.S   CHECK_CO
          MOVEQ   #1,D2 
          BSR     READ_INS
          LEA     CHIP3(PC),A5
          LEA     VOICE3(PC),A6 
          BSR.S   CHECK_CO
          MOVEQ   #2,D2 
          BSR     READ_INS
          BSR     IN_YM 
          MOVEM.L (A7)+,A0-A6/D0-D7 
RTS:      RTS 
PLAYSTE:  LEA     $FFFF8900.W,A2 
          MOVE.L  0(A0,D1.W),D3 
          TST.B   D3
          BEQ.S   RTS 
          MOVE.W  #$7FF,36(A2)
          MOVE.W  #$4C0,D4
          ADD.B   D3,D4 
          MOVE.W  D4,34(A2) 
          MOVE.L  D3,D4 
          SWAP    D4
          MOVE.B  D4,33(A2) 
          LSR.W   #5,D3 
          ANDI.W  #$78,D3 
          LEA     T_SPL(PC),A1
          ADDA.W  D3,A1 
          MOVE.L  (A1)+,D5
          MOVE.L  (A1),D6 
          MOVEP.L D5,1(A2)
          MOVEP.L D6,13(A2) 
          MOVE.B  #1,1(A2)
          RTS 
CHECK_CO: MOVEQ   #0,D2 
          MOVE.B  3(A6),D2
          MOVE.B  2(A6),D0
          ANDI.W  #$F,D0
          ADD.W   D0,D0 
          ADD.W   D0,D0 
          LEA     T_COMMAN(PC),A1 
          MOVEA.L 0(A1,D0.W),A1 
          JSR     (A1)
          RTS 
NO_COMMA: RTS 
PORTAMEN: SUB.W   D2,(A6) 
          BMI.S   PORTUP
          RTS 
PORTUP:   CLR.W   (A6)
          RTS 
L002A:    ADD.W   D2,(A6) 
          CMPI.W  #$FFF,(A6)
          BGE.S   PORTDOWN
          RTS 
PORTDOWN: MOVE.W  #$FFF,(A6)
          RTS 
L002C:    TST.B   6(A6) 
          BEQ.S   PORTA_FI
          MOVE.W  4(A6),D3
          CMP.W   (A6),D3 
          BGT.S   PORTONE_
          BEQ.S   PORTA_FI
          SUB.W   D2,(A6) 
          CMP.W   (A6),D3 
          BGE.S   PORTA_FI
          BRA.S   PORTA_PA
PORTONE_: ADD.W   D2,(A6) 
          CMP.W   (A6),D3 
          BLE.S   PORTA_FI
PORTA_PA: RTS 
PORTA_FI: CLR.B   6(A6) 
          MOVE.W  4(A6),(A6)
          MOVE.W  4(A6),16(A6)
          RTS 
VIBRATO_: LEA     SINUS(PC),A0
          MOVEQ   #0,D3 
          MOVE.B  4(A6),D3
          MOVE.B  0(A0,D3.W),9(A6)
          ADD.B   D2,4(A6)
          RTS 
L0031:    LEA     SINUS(PC),A0
          MOVEQ   #0,D3 
          MOVE.B  4(A6),D3
          MOVE.B  0(A0,D3.W),10(A6) 
          ADD.B   D2,4(A6)
          RTS 
SET_VOLU: ANDI.B  #$F,D2
          MOVE.B  D2,7(A6)
          CLR.B   2(A6) 
          RTS 
VOLUME_S: TST.B   3(A4) 
          BNE.S   PAS_SLID
          MOVE.B  D2,9(A6)
PAS_SLID: RTS 
NUL:      LEA     INST0(PC),A0
          MOVE.L  A0,(A5) 
          CLR.B   8(A6) 
          CLR.B   2(A6) 
          RTS 
DELAY:    TST.B   D2
          BEQ.S   FINITO_D
          ANDI.B  #$F,D2
          CLR.B   2(A6) 
          CLR.W   4(A5) 
          SUB.B   D2,11(A6) 
          MOVE.B  11(A6),9(A6)
          RTS 
FINITO_D: CLR.B   11(A6)
          RTS 
SET_TEMP: MOVE.B  D2,2(A4)
          CLR.B   2(A6) 
          RTS 
ARPEGIO:  TST.B   11(A6)
          BNE.S   PAS_ARPE
          MOVE.B  D2,10(A6) 
          NOT.B   11(A6)
          RTS 
PAS_ARPE: CLR.W   10(A6)
          RTS 
READ_INS: MOVEA.L (A5),A0 
          MOVE.B  21(A0),D0 
          TST.B   D0
          BEQ.S   SOUND 
          CMP.B   #1,D0 
          BEQ     DRUM
          MOVE.B  D0,D1 
          ANDI.W  #$F,D1
          CMP.B   #$F,D1
          BEQ     YM_CTRL2
          BRA     YM_CTRL 
SOUND:    LEA     MASK7(PC),A1
          MOVEQ   #1,D0 
          LSL.B   D2,D0 
          EOR.B   D0,(A1) 
          MOVE.B  4(A5),D0
          MOVE.B  22(A0,D0.W),D1
          ADDQ.W  #1,D0 
          CMP.B   #$40,D0 
          BNE.S   YA_PAS_D
          MOVEQ   #$3F,D0 
YA_PAS_D: MOVE.B  D0,4(A5)
          BCLR    #7,D1 
          BEQ.S   L003E 
          MOVE.B  22(A0,D0.W),4(A5) 
L003E:    ANDI.W  #$F,D1
          ADD.B   9(A6),D1
          SUB.B   7(A6),D1
          BPL.S   PAS_VOL_
          MOVEQ   #0,D1 
PAS_VOL_: CMP.B   #$F,D1
          BLE.S   PAS_PLUS
          MOVEQ   #$F,D1
PAS_PLUS: MOVE.B  D1,8(A6)
          MOVE.W  (A6),D3 
          MOVE.B  5(A5),D0
          MOVE.W  86(A0,D0.W),D1
          ADDQ.W  #2,D0 
          CMP.B   #$40,D0 
          BNE.S   NON_PAS_
          MOVEQ   #$3E,D0 
NON_PAS_: MOVE.B  D0,5(A5)
          BCLR    #14,D1
          BEQ.S   C_PAS_UN
          MOVE.W  86(A0,D0.W),D0
          ADD.W   D0,D0 
          MOVE.B  D0,5(A5)
C_PAS_UN: BCLR    #15,D1
          BEQ.S   OFFSETPO
          NEG.W   D1
OFFSETPO: MOVE.B  10(A6),D0 
          EXT.W   D0
          ADD.W   D0,D1 
          ADD.W   D1,D3 
          TST.W   D3
          BMI.S   C_UN_NEG
          CMP.W   #$FFF,D3
          BLE.S   L0045 
          MOVE.W  #$FFF,D3
          BRA.S   L0045 
C_UN_NEG: MOVEQ   #0,D3 
L0045:    MOVE.W  D3,16(A6) 
          RTS 
DRUM:     MOVE.B  4(A5),D0
          LEA     BRUIT(PC),A1
          MOVE.B  54(A0,D0.W),(A1)
          MOVE.B  22(A0,D0.W),D1
          MOVE.B  D1,D3 
          ANDI.W  #$F0,D3 
          LSR.W   #4,D3 
          LSL.W   D2,D3 
          LEA     MASK7(PC),A1
          EOR.B   D3,(A1) 
          ADDQ.W  #1,D0 
          CMP.B   #$20,D0 
          BNE.S   L0047 
          MOVEQ   #$1F,D0 
L0047:    MOVE.B  D0,4(A5)
          ANDI.W  #$F,D1
          ADD.B   9(A6),D1
          SUB.B   7(A6),D1
          BPL.S   L0048 
          MOVEQ   #0,D1 
L0048:    CMP.B   #$F,D1
          BLE.S   L0049 
          MOVEQ   #$F,D1
L0049:    MOVE.B  D1,8(A6)
          MOVE.B  5(A5),D0
          MOVE.W  86(A0,D0.W),D1
          ADDQ.W  #2,D0 
          CMP.B   #$40,D0 
          BNE.S   L004A 
          MOVEQ   #$3E,D0 
L004A:    MOVE.B  D0,5(A5)
          ADD.B   10(A6),D1 
          TST.W   D1
          BMI.S   L004B 
          CMP.W   #$FFF,D1
          BLE.S   L004C 
          MOVE.W  #$FFF,D1
          BRA.S   L004C 
L004B:    MOVEQ   #0,D1 
L004C:    MOVE.W  D1,16(A6) 
          RTS 
YM_CTRL:  LEA     LONG_OND(PC),A1 
          ANDI.W  #$F0,D0 
          LSR.W   #4,D0 
          ORI.W   #8,D0 
          MOVE.B  D0,2(A1)
          MOVE.B  #$D,$FFFF8800.W
          MOVE.B  D0,$FFFF8802.W 
          MOVE.B  #$10,8(A6)
          MOVE.B  4(A5),D0
          MOVE.W  22(A0,D0.W),D1
          ADDQ.W  #2,D0 
          CMP.B   #$40,D0 
          BNE.S   L004E 
          MOVEQ   #$3E,D0 
L004E:    MOVE.B  D0,4(A5)
          MOVE.W  D1,(A1) 
          MOVE.W  (A6),D3 
          MOVE.B  5(A5),D0
          MOVE.B  86(A0,D0.W),D1
          ADDQ.W  #1,D0 
          CMP.B   #$20,D0 
          BNE.S   L004F 
          MOVE.B  #$1F,D0 
L004F:    MOVE.B  D0,5(A5)
          BCLR    #7,D1 
          BEQ.S   L0050 
          MOVE.B  86(A0,D0.W),5(A5) 
L0050:    SUBI.B  #$40,D1 
          ADD.B   10(A6),D1 
          EXT.W   D1
          ADD.W   D1,D3 
          TST.W   D3
          BMI.S   L0051 
          CMP.W   #$FFF,D3
          BLE.S   L0052 
          MOVE.W  #$FFF,D3
          BRA.S   L0052 
L0051:    MOVEQ   #0,D3 
L0052:    MOVE.W  D3,16(A6) 
          ADDI.W  #$20,D0 
          MOVE.B  86(A0,D0.W),D1
          MOVE.B  D1,D3 
          ANDI.W  #$F0,D3 
          LSR.W   #4,D3 
          LSL.W   D2,D3 
          LEA     MASK7(PC),A1
          EOR.B   D3,(A1) 
          ANDI.W  #$F,D1
          BEQ.S   PAS_DE_V
          ADD.B   9(A6),D1
          SUB.B   7(A6),D1
          BPL.S   L0053 
          MOVEQ   #0,D1 
L0053:    CMP.B   #$F,D1
          BLE.S   L0054 
          MOVEQ   #$F,D1
L0054:    MOVE.B  D1,8(A6)
PAS_DE_V: RTS 
YM_CTRL2: LEA     LONG_OND(PC),A1 
          ANDI.W  #$F0,D0 
          LSR.W   #4,D0 
          ORI.W   #8,D0 
          MOVE.B  2(A1),D1
          CMP.B   D0,D1 
          BEQ.S   NOCHANGE
          MOVE.B  D0,2(A1)
          MOVE.B  #$D,$FFFF8800.W
          MOVE.B  D0,$FFFF8802.W 
NOCHANGE: MOVE.B  #$10,8(A6)
          MOVE.B  4(A5),D0
          MOVE.B  22(A0,D0.W),D1
          ADDQ.W  #1,D0 
          CMP.B   #$20,D0 
          BNE.S   L0058 
          MOVE.B  #$1F,D0 
L0058:    MOVE.B  D0,4(A5)
          MOVE.B  D1,D3 
          ANDI.W  #$F0,D3 
          LSR.W   #4,D3 
          MOVE.W  D3,D4 
          LSL.W   D2,D3 
          LEA     MASK7(PC),A1
          EOR.B   D3,(A1) 
          ANDI.W  #$F,D1
          BEQ.S   YA_DU_BU
          ADD.B   9(A6),D1
          SUB.B   7(A6),D1
          BPL.S   L0059 
          MOVEQ   #0,D1 
          BRA.S   L005A 
L0059:    CMP.B   #$F,D1
          BLE.S   L005A 
          MOVEQ   #$F,D1
L005A:    MOVE.B  D1,8(A6)
          MOVE.B  5(A5),D1
          ADD.B   D1,D1 
          BRA.S   PERIODE4
YA_DU_BU: BTST    #0,D4 
          BNE.S   BUZZNOTO
          MOVE.B  5(A5),D0
          MOVE.B  54(A0,D0.W),D1
          MOVE.W  D0,D3 
          ADD.W   D3,D3 
          ADDQ.B  #1,D0 
          CMP.B   #$20,D0 
          BNE.S   TOUJOURS
          MOVE.B  #$1E,D0 
TOUJOURS: BCLR    #7,D1 
          BEQ.S   L005D 
          MOVE.B  54(A0,D0.W),D0
L005D:    MOVE.B  D0,5(A5)
          SUBI.B  #$40,D1 
          EXT.W   D1
          MOVE.W  (A6),2(A1)
          ADD.W   D1,2(A1)
          MOVE.W  86(A0,D3.W),16(A6)
          RTS 
BUZZNOTO: MOVE.B  5(A5),D0
          MOVE.B  54(A0,D0.W),3(A1) 
          MOVE.B  D0,D1 
          ADD.W   D1,D1 
          ADDQ.W  #1,D0 
          CMP.B   #$20,D0 
          BNE.S   L005F 
          MOVEQ   #$1E,D0 
L005F:    MOVE.B  D0,5(A5)
PERIODE4: MOVE.W  (A6),D3 
          MOVE.W  D1,D0 
          MOVE.W  86(A0,D0.W),D1
          BCLR    #14,D1
          BEQ.S   L0061 
          MOVE.W  88(A0,D0.W),D0
          MOVE.B  D0,5(A5)
L0061:    BCLR    #15,D1
          BEQ.S   L0062 
          NEG.W   D1
L0062:    MOVE.B  10(A6),D0 
          ADD.W   D0,D1 
          ADD.W   D1,D3 
          TST.W   D3
          BMI.S   L0063 
          CMP.W   #$FFF,D3
          BLE.S   L0064 
          MOVE.W  #$FFF,D3
          BRA.S   L0064 
L0063:    MOVEQ   #0,D3 
L0064:    MOVE.W  D3,16(A6) 
          RTS 
IN_YM:    LEA     VOICE1(PC),A0 
          LEA     VOICE2(PC),A1 
          LEA     VOICE3(PC),A2 
          MOVE.L  #$100,D0
          MOVE.B  16(A0),D0 
          SWAP    D0
          MOVE.B  17(A0),D0 
          MOVE.L  #$2000300,D1
          MOVE.B  16(A1),D1 
          SWAP    D1
          MOVE.B  17(A1),D1 
          MOVE.L  #$4000500,D2
          MOVE.B  16(A2),D2 
          SWAP    D2
          MOVE.B  17(A2),D2 
          MOVE.L  #$8000700,D3
          MOVE.B  MASK7(PC),D3
          SWAP    D3
          MOVE.B  8(A0),D3
          MOVE.L  #$9000A00,D4
          MOVE.B  8(A2),D4
          SWAP    D4
          MOVE.B  8(A1),D4
          MOVE.W  #$600,D5
          MOVE.B  BRUIT(PC),D5
          MOVE.L  #$B000C00,D6
          MOVE.B  LONG_OND(PC),D6 
          SWAP    D6
          MOVE.B  L0074(PC),D6
          LEA     $FFFF8800.W,A0 
          MOVEP.L D0,0(A0)
          MOVEP.L D1,0(A0)
          MOVEP.L D2,0(A0)
          MOVEP.L D3,0(A0)
          MOVEP.L D4,0(A0)
          MOVEP.W D5,0(A0)
          MOVEP.L D6,0(A0)
          RTS 
VOICE1:   DS.W    9
VOICE2:   DS.W    9 
VOICE3:   DS.W    9 
VOICE4:   DS.W    9 
CHIP:     DS.W    3 
CHIP2:    DS.W    3 
CHIP3:    DS.W    3 
CHIP4:    DS.W    3 
OFFSET:   DS.W    5 
INST_STA: DS.W    32
T_COMMAN: DS.W    32
MASK7:    DC.B   $00
BRUIT:    DC.B   $00
LONG_OND: DC.B   $00
L0074:    DC.B   $00,$00
FINEFFAC: DC.B   $00
SINUS:    DS.W    7 
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$02,$02
          DC.B   $02,$02,$02,$02,$02,$02,$02,$02
          DC.B   $02,$02,$02,$02,$02,$02,$02,$02
          DC.B   $02,$02,$02,$02,$02,$02,$02,$02
          DC.B   $02,$02,$02,$02,$02,$02,$02,$02
          DC.B   $02,$02,$02,$02,$02,$02,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$00,$00,$00,$00
          DS.W    12
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE
          DC.B   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
          DC.B   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
          DC.B   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
          DC.B   $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
          DC.B   $FE,$FE,$FE,$FE,$FE,$FE,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          DC.B   $FF,$FF,$FF,$FF,$00,$00,$00,$00
          DS.W    5 
T_SPL:    DS.W    64
INST0:    DS.W    11
L0079:    DS.W    53
          DC.B   $00,' ~~  wh'
          DC.B   'o',$27,'s bad ' 
          DC.B   '?!  ~~' 
SONG:     DC.B   'Obolon 5' 
          DC.B   '3 : the ' 
          DC.B   'MIX  ',$00,'1e' 
          DC.B   'r buzz n' 
          DC.B   'on bug',$82,' ' 
          DC.B   '  0/',$00,$00,$00,$00 
          DC.B   $00,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,'@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   '@@@@',$03,$BB,$03,$BB 
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,'1er ' 
          DC.B   'buzz non' 
          DC.B   ' bug',$82,'   ' 
          DC.B   '1O',$00,$00,$00,$00,$01,$01 
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,'@@@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   '@@',$03,$BB,$03,$BB,$03,$BB 
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,'buzz o' 
          DC.B   'vr 1   8' 
          DC.B   '5f    2o' 
          DC.B   $10,$10,$10,$10,$10,$10,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   '""""""""' 
          DC.B   '""""""""' 
          DC.B   '""""""""' 
          DC.B   '""""""""' 
          DS.W    32
          DC.B   'offbeat ' 
          DC.B   '!!      ' 
          DC.B   '    3',$00,$0F,$0E
          DC.B   $0E,$0E,$0E,$0E,$0E,$0D,$0D,$0C
          DC.B   $0B,$0A,$00,$00,$00,$00,$00,$00
          DS.W    55
          DC.B   'tambour ' 
          DC.B   '        ' 
          DC.B   '    4',$01,$9F,$1F
          DC.B   $1D,$1D,$1B,$1B,$1B,$1B,$19,$19
          DC.B   $17,$17,$00,$00,$00,$00,$00,$00
          DS.W    7 
          DC.B   $13,$13,$13,$13,$13,$13,$13,$13
          DC.B   $13,$13,$13,$13,$0B,$0B,$0B,$0B
          DC.B   $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
          DC.B   $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
          DC.B   $02,$F6,$03,'F',$03,$96,$03,$E6
          DC.B   $04,'6',$04,$86,$04,$86,$04,$D6
          DC.B   $05,'&',$05,'v',$05,$C6,$06,$16
          DC.B   $04,$B3,$04,$B3,$04,$B3,$04,$B3
          DC.B   $04,$B3,$04,$B3,$04,$B3,$04,$B3
          DC.B   $04,$B3,$04,$B3,$04,$B3,$04,$B3
          DC.B   $04,$B3,$04,$B3,$04,$B3,$04,$B3
          DC.B   $04,$B3,$04,$B3,$04,$B3,$04,$B3
          DC.B   'hit hat ' 
          DC.B   '        ' 
          DC.B   '    5',$01,$9D,$1E
          DC.B   $1D,$1C,$1C,$1C,$10,$10,$10,$10
          DC.B   $10,$10,$10,$10,$10,$10,$10,$10
          DC.B   $10,$12,$11,$10,$10,$10,$10,$10
          DC.B   $10,$10,$10,$10,$10,$10,$0C,$0C
          DC.B   $0C,$0C,$0C,$0C,$0C,$00,$00,$00
          DS.W    11
          DC.B   $00,'<',$00,'x',$00,$EF,$01,$DE
          DC.B   $01,$DE,$01,$DE,$00,$00,$00,$00
          DS.W    24
          DC.B   'FLIPPER ' 
          DC.B   '002  078' 
          DC.B   '    6',$00,$0F,$0F
          DC.B   $0F,$0E,$0E,$0E,$0D,$0D,$0D,$0C
          DC.B   $0C,$0C,$0B,$0B,$0B,$0A,$0A,$0A
          DC.B   $09,$09,$09,$08,$08,$08,$00,$00
          DS.W    21
          DC.B   $C0,'w',$00,$00,$00,$00,$00,$00
          DS.W    26
          DC.B   'buzz ovr' 
          DC.B   ' 1   775' 
          DC.B   '    7O',$10,$10 
          DC.B   $10,$10,$10,$10,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,'<<' 
          DC.B   '<<<<<<<<' 
          DC.B   '<<<<<<<<' 
          DC.B   '<<<<<<<<' 
          DC.B   '<<<<<<',$00,$00 
          DS.W    31
          DC.B   'FLIPPER ' 
          DC.B   '002  10c' 
          DC.B   '    8',$00,$0F,$0F
          DC.B   $0F,$0E,$0E,$0E,$0D,$0D,$0D,$0C
          DC.B   $0C,$0C,$0B,$0B,$0B,$0A,$0A,$0A
          DC.B   $09,$09,$09,$08,$08,$08,$00,$00
          DS.W    21
          DC.B   $C0,$86,$00,$00,$00,$00,$00,$00
          DS.W    26
          DC.B   'buzz ovr' 
          DC.B   ' 1   b2c' 
          DC.B   '    9o',$10,$10 
          DC.B   $10,$10,$10,$10,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,'--' 
          DC.B   '--------' 
          DC.B   '--------' 
          DC.B   '--------' 
          DC.B   '------',$00,$00 
          DS.W    31
          DC.B   'FLIPPER ' 
          DC.B   '002  166' 
          DC.B   '    a',$00,$0F,$0F
          DC.B   $0F,$0E,$0E,$0E,$0D,$0D,$0D,$0C
          DC.B   $0C,$0C,$0B,$0B,$0B,$0A,$0A,$0A
          DC.B   $09,$09,$09,$08,$08,$08,$00,$00
          DS.W    21
          DC.B   $C0,$B3,$00,$00,$00,$00,$00,$00
          DS.W    26
          DC.B   'xbdrum  ' 
          DC.B   '        ' 
          DC.B   '    b',$01,$9F,$1F
          DC.B   $1F,$1F,$1F,$10,$8D,$80,$80,$80
          DC.B   $80,$80,$90,$90,$90,$90,$00,$00
          DS.W    7 
          DC.B   $0B,$0B,$0B,$0B,$0B,$0B,$11,$11
          DC.B   $10,$10,$10,$10,$0B,$0B,$0B,$0B
          DC.B   $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
          DC.B   $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
          DC.B   $03,'G',$04,$88,$05,$04,$06,$80
          DC.B   $09,$FB,$06,$80,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DS.W    16
          DC.B   '1er buzz' 
          DC.B   ' vibr',$82,'  ' 
          DC.B   '    C/',$00,$00 
          DS.W    7 
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   $01,$01,$01,$01,$01,$01,$01,$01
          DC.B   '@ACA@?=',$BF
          DC.B   $00,'@@@@@@@'
          DC.B   '@@@@@@@@' 
          DC.B   '@@@@@@@@' 
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   $03,$BB,$03,$BB,$03,$BB,$03,$BB
          DC.B   'delay de' 
          DC.B   'lay dela' 
          DC.B   'y   D',$00,$0C,$0D
          DC.B   $0E,$0C,$0B,$0A,$0A,$09,$09,$08
          DC.B   $08,$07,$07,$06,$06,$05,$04,$00
          DS.W    55
          DC.B   'x snare ' 
          DC.B   'DRUM    ' 
          DC.B   '    e',$01,$9F,$1F
          DC.B   $1F,$9F,$1E,$8D,$8D,$80,$10,$10
          DC.B   $10,$10,$10,$10,$10,$10,$10,$10
          DC.B   $10,$10,$10,$10,$10,$10,$10,$10
          DC.B   $10,$10,$10,$10,$10,$10,$11,$10
          DC.B   $0F,$0E,$0D,$0C,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$11,$11
          DC.B   $11,$11,$11,$11,$11,$11,$02,'8'
          DC.B   $02,$9C,$03,$00,$03,'d',$03,$C8
          DC.B   $04,',',$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,$0F,$D1
          DC.B   $0F,$D1,$0F,$D1,$0F,$D1,'fl' 
          DC.B   'ute cz  ' 
          DC.B   '        ' 
          DC.B   '  f',$00,$0A,$0B,$0C,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
          DC.B   $0D,$0D,$0D,$0D,$00,$00,$00,$00
          DS.W    2 
          DC.B   $00,$02,$00,$04,$00,$02,$00,$00
          DC.B   $80,$02,$80,$04,$80,$02,'@',$00
          DC.B   $00,$04,$00,$00,$00,$00,$00,$00
          DS.W    16
          DC.B   $0E,$00,$01,$02,$03,$04,$05,$06
          DC.B   $06,$01,$04,$02,$05,$03,$06,$00
          DS.W    56
          DC.B   $00,$07,$07,'up',$00,$00,$A0 
          DC.B   '6',$01,$00,$00,$B6,$02,$00,$00
          DS.W    1 
          DC.B   $03,$BB,'p',$00,$00,$C9,'0',$00
          DS.W    1 
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$0C,'0',$00,$00,$A0
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$00,$C9,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$EF,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,$DE,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$00,$EF,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,'f0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$C9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,'x0',$00,$00,$00 
          DC.B   $B0,$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$0C,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$C9,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$00,$EF,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,'f0',$00,$00,'x' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$A9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$B3,'0',$00,$00,$A9
          DC.B   '0',$00,$00,$00,$00,$00,$03,$BB
          DC.B   'p',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$A0,'0',$00,$00,$00
          DC.B   $B6,$02,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$A0
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$C9,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$EF,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'f0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$C9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,'x0',$00,$00,$00 
          DC.B   $B0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$C9,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'f0',$00,$00,'x' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'p',$00,$00,$A9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$B3,'0',$00,$00,$A9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'6',$01,$00,$00
          DC.B   $B6,$02,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$A0
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$C9,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'f0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$C9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$00 
          DC.B   $B0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$C9,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'f0',$00,$00,'x' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$00,$A9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'6',$01,$00,$00
          DC.B   $B6,$02,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$C9,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$EF,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'f0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$00 
          DC.B   $B0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,$EF,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'f0',$00,$00,'x' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   'P',$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$00,$A9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'6',$01,$00,$00
          DC.B   $B6,$02,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$A0
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$EF,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'f0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$00 
          DC.B   $B0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'f0',$00,$00,'x' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$00,$A9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'6',$01,$00,$00
          DC.B   $B6,$02,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$A0
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$EF,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'f0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$00 
          DC.B   $B0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,'x'
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$C9
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,'x0',$00,$00,$EF 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,$0C
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'f0',$00,$00,'x' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$01,$DE 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$01,'R'
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$01,$DE,'0',$00,$01,'?'
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$00,$A9
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$01,$DE
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'6',$01,$00,$EF
          DC.B   'f',$01,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'?0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$0C,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,'x0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'?0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'6',$01,$00,$EF
          DC.B   'f',$01,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'?0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'('
          DC.B   $10,$00,$01,$0C,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$00,'x0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,'?0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'x'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,$F6,$00,$00,$EF
          DC.B   'f',$01,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$01,'?0',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$0C,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,'x0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,$F6,$00,$00,$EF
          DC.B   'f',$01,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$01,'?0',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$0C,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$01,$DE,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$0C,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$0C,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,'x0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x',$F6,$00,$00,$EF
          DC.B   'f',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$00,'0',$00,$00,$EF
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$A0,$F3,$03,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$86,$F3,$03,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$86,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A0,'0',$00,$01,$0C
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$86,'0',$00,$01,'?'
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$A0,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$EF,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$C9,'0',$00,$01,'?'
          DC.B   $D0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$B3,$F0,$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$B3
          DC.B   $F0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$00,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$0C,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,'x0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x',$F6,$00,$00,$EF
          DC.B   'f',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$00,'0',$00,$00,$EF
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,'x',$F3,$03,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'k',$F3,$03,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,'k0',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'x0',$00,$01,$0C 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,'k0',$00,$01,'?' 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,'x',$F0,$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$00,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$00,'0',$00,$01,'?'
          DC.B   $D0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'e',$F0,$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$B3
          DC.B   $F0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$00,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$0C,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,'x0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,$DE,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'f0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$01,'R0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,'?0',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$A9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$01,$DE,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$EF,'6',$00,$00,$EF
          DC.B   'f',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$D5,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$EF
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$A0,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,'x',$F0,$00,$00,$EF
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$EF
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,'k0',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,'e0',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,'k0',$00,$01,'f' 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,'x0',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$86,$F0,$00,$01,'f'
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$00,'0',$00,$01,$0C
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$A0,'0',$00,$01,'f'
          DC.B   $D0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$B3,$F0,$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$00
          DC.B   'P',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$00,'0',$00,$00,$B3
          DC.B   $F0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$00,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '`',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$C9,'3',$04,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$00,$A9,'3',$04,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$C9,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$00,$EF,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$00,$B3,'0',$00,$01,'f'
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$00,$00,'0',$00,$00,$00
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uV',$00,$00,$EF 
          DC.B   'f',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   'P',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$07,'uP',$00,$00,$EF 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$07,'uP',$00,$00,$EF 
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$07,'uP',$00,$00,$EF 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'<'
          DC.B   $10,$00,$07,'uP',$00,$00,$EF 
          DC.B   '`',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$07,'uP',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uP',$00,$01,$0C 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$07,'uP',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$07,'uP',$00,$01,'?' 
          DC.B   $D0,$00,$00,$00,$00,$00,$00,'C'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$07,'uP',$00,$01,$0C 
          DC.B   $80,$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$07,'uP',$00,$01,'?' 
          DC.B   $D0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uP',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   'P',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$00,$B3 
          DC.B   $F0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uP',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$07,'uP',$00,$00,$00 
          DC.B   '`',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uP',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   $B0,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$00,'Z'
          DC.B   $10,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00,$07,'u'
          DC.B   '@',$00,$07,'uP',$00,$01,'f' 
          DC.B   $A0,$00,$00,$00,$00,$00,$07,'u'
          DC.B   $E0,$00,$07,'uP',$00,$00,$00 
          DC.B   '0',$00,$00,$00,$00,$00
