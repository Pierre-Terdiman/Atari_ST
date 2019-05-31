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
	
	CLR.L 	-(SP)
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	MOVE.L 	D0,SAUVE

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
			
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	MOVE	#4,-(SP)
	TRAP 	#14
	ADDQ.L	#2,SP
	MOVE	D0,RES
	
	MOVE	#2,-(SP)
	TRAP 	#14
	ADDQ.L 	#2,SP
	MOVE.L	D0,ANC_ECR
	
	CLR.W 	-(SP)
	MOVE.L	#$F8000,-(SP)
	MOVE.L	#$F8000,-(SP)
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP


	LEA.L	$FFFF8240.W,A0
	MOVEM.L	(A0),D0-D7
	LEA.L	ANC_PAL,A0
	MOVEM.L	D0-D7,(A0)
	
        
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBL_IR,$70.W
	MOVE.L	$120.W,ANC_TB
	MOVE.L	#TB0_IR,$120.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W



BOUCLE	JMP	BOUCLE

FIN:	
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	ANC_TB,$120.W
	
	LEA.L	ANC_PAL,A0
	MOVEM.L	(A0),D0-D7
	LEA.L	$FFFF8240.W,A0
	MOVEM.L	D0-D7,(A0)
	
	MOVE 	RES,-(SP)	
	MOVE.L	ANC_ECR,-(SP)	
	MOVE.L	ANC_ECR,-(SP)	
	MOVE 	#5,-(SP)	
	TRAP 	#14		
	LEA.L 	12(SP),SP	
	
	MOVE.L	SAUVE,-(SP)	
	MOVE 	#$20,-(SP)	
	TRAP 	#1		
	ADDQ.L 	#6,SP		
	
;	PEA	CHUT_DA	   	
;	MOVE	#$20,-(A7) 	
;	TRAP	#14        	
;	ADDQ.L	#6,A7      	

	CLR.W 	-(SP)		
	TRAP	#1		
	





VBL_IR	

	ST	$FFFF8240.W

	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W



	MOVE	#1,D0
	MOVE	#1,D1
	
	MOVE	#160,D2
	MOVE	#100,D3
	
                
                movem.l d6-d7/a0,-(a7)
                bsr     DRAW_A_LINE
                movem.l (a7)+,d6-d7/a0


	SF	$FFFF8240.W

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE


 


TB0_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB0_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			




                
DRAW_A_LINE
                cmp.w   d1,d3
                beq     DRAW_HORIZONTAL
                cmp.w   d0,d2
                beq     DRAW_VERTICAL

                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                LEA  $F8000,a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0
                move.w  d0,d5
                eor.w   #$0f,d5
                and.w   #$0f,d5
                clr.w   d6
                bset    d5,d6
                move.w  d6,d7           OR Mask
                not.w   d6              AND Mask

                sub.w   d0,d2           u
                sub.w   d1,d3           v

                move.l  #0,a1
                move.l  #0,a2
                move.l  #0,a3
                move.l  #0,a4
                
                tst.w   d2
                bpl.s   .dr_1
                beq.s   .dr_2
                move.w  #-1,a1          d1x
                neg.w   d2              M
                bra.s   .dr_2
.dr_1
                move.w  #1,a1           d1x
.dr_2
                tst.w   d3
                bpl.s   .dr_3
                beq.s   .dr_4
                move.w  #-1,a2          d1y
                neg.w   d3              N
                bra.s   .dr_4
.dr_3
                move.w  #1,a2           d1y
.dr_4
                cmp.w   d2,d3
                blt.s   .dr_5
                move.w  a2,a4           d2y
                exg     d2,d3
                bra.s   .dr_6
.dr_5
                move.w  a1,a3           d2x
.dr_6 
                move.w  d2,d0
                lsr.w   #1,d0           S
                move.w  d2,d1           I

*               d0: S, d1: I, d2: M, d3: N, d6:AND Mask, d7:OR Mask
*               a0: Screen, a1: d1x, a2:d1y, a3:d2x, a5:d2y
.dr_7
*               PLOT THE POINT

                and.w   d6,(a0)
                or.w    d7,2(a0)
                or.w    d7,4(a0)
                or.w    d7,6(a0)

                add.w   d3,d0
                cmp.w   d0,d2
                bgt.s   .dr_8
        
                sub.w   d2,d0
                
                cmp.w   #0,a1
                beq.s   .dr_A5
                bmi.s   .dr_A6
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A5
                addq.l  #8,a0
                bra.s   .dr_A5
.dr_A6
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A5
                subq.l  #8,a0
.dr_A5
                cmp.w   #0,a2
                beq.s   .dr_A3
                bmi.s   .dr_A8
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A8
                lea     -160(a0),a0
                bra.s   .dr_A3
.dr_8
                cmp.w   #0,a3
                beq.s   .dr_A1
                bmi.s   .dr_A2
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A3
                addq.l  #8,a0
                bra.s   .dr_A3
.dr_A2
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A3
                subq.l  #8,a0
                bra.s   .dr_A3
.dr_A1
                cmp.w   #0,a4
                bmi.s   .dr_A4
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A4
                lea     -160(a0),a0
.dr_A3
                dbf     d1,.dr_7        
                rts

DRAW_HORIZONTAL
                cmp.w   d0,d2
                bne.s   .dr_h_1
                rts
.dr_h_1
                bgt.s   .dr_h_2
                exg     d0,d2
.dr_h_2
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                LEA  $F8000,a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                move.w  d2,d3
                move.w  d0,d6
                
                and.w   #$fff0,d6
                lsr.w   #4,d6
                and.w   #$fff0,d2
                lsr.w   #4,d2
                
                sub.w   d6,d2

                lea     PIXEL_TABLE_LEFT,a1
                and.w   #$000f,d0
                lsl.w   #1,d0
                move.w  (a1,d0),d0
                lea     PIXEL_TABLE_RIGHT,a1
                and.w   #$000f,d3
                lsl.w   #1,d3
                move.w  (a1,d3),d3

                tst     d2
                bne.s   .dr_h_7
                
                and.w   d0,d3
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_7
                subq.w  #1,d2
                bne.s   .dr_h_8
                
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr     .dr_h_m_1
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_8
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr     .dr_h_m_1

                subq.w  #1,d2
                move.w  #$ffff,d6
                clr.w   d7
.dr_h_9
                bsr     .dr_h_m_1
                dbf     d2,.dr_h_9
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7

.dr_h_m_1       
                and.w   d7,(a0)+                
                or.w    d6,(a0)+                
                or.w    d6,(a0)+                
                or.w    d6,(a0)+                
                rts

DRAW_VERTICAL
                cmp.w   d1,d3
                bgt.s   .dr_v_1
                exg     d1,d3
.dr_v_1
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                LEA  $F8000,a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                eor.w   #$0f,d0
                and.w   #$0f,d0
                clr.w   d6
                bset    d0,d6
                move.w  d6,d7           OR Mask
                not.w   d7              AND Mask

                sub.w   d1,d3           Height
.dr_v_m_1
                and.w   d7,(a0)+
                or.w    d6,(a0)+
                or.w    d6,(a0)+
                or.w    d6,(a0)+
                lea     152(a0),a0
                dbf     d3,.dr_v_m_1
                rts




	 
	section   data

;CHUT_DA	DC.B	7,$FF,6,0,8,0,9,0,$A,0


SCREEN_Y_TABLE
                dc.w    0,160,320,480,640,800,960,1120,1280,1440,1600,1760,1920,2080,2240
                dc.w    2400,2560,2720,2880,3040,3200,3360,3520,3680,3840,4000,4160,4320,4480,4640
                dc.w    4800,4960,5120,5280,5440,5600,5760,5920,6080,6240,6400,6560,6720,6880,7040
                dc.w    7200,7360,7520,7680,7840,8000,8160,8320,8480,8640,8800,8960,9120,9280,9440
                dc.w    9600,9760,9920,10080,10240,10400,10560,10720,10880,11040,11200,11360,11520,11680,11840
                dc.w    12000,12160,12320,12480,12640,12800,12960,13120,13280,13440,13600,13760,13920,14080,14240
                dc.w    14400,14560,14720,14880,15040,15200,15360,15520,15680,15840,16000,16160,16320,16480,16640
                dc.w    16800,16960,17120,17280,17440,17600,17760,17920,18080,18240,18400,18560,18720,18880,19040
                dc.w    19200,19360,19520,19680,19840,20000,20160,20320,20480,20640,20800,20960,21120,21280,21440
                dc.w    21600,21760,21920,22080,22240,22400,22560,22720,22880,23040,23200,23360,23520,23680,23840
                dc.w    24000,24160,24320,24480,24640,24800,24960,25120,25280,25440,25600,25760,25920,26080,26240
                dc.w    26400,26560,26720,26880,27040,27200,27360,27520,27680,27840,28000,28160,28320,28480,28640
                dc.w    28800,28960,29120,29280,29440,29600,29760,29920,30080,30240,30400,30560,30720,30880,31040
                dc.w    31200,31360,31520,31680,31840
PIXEL_TABLE_LEFT
                dc.w    %1111111111111111
                dc.w    %0111111111111111
                dc.w    %0011111111111111
                dc.w    %0001111111111111
                dc.w    %0000111111111111
                dc.w    %0000011111111111
                dc.w    %0000001111111111
                dc.w    %0000000111111111
                dc.w    %0000000011111111
                dc.w    %0000000001111111
                dc.w    %0000000000111111
                dc.w    %0000000000011111
                dc.w    %0000000000001111
                dc.w    %0000000000000111
                dc.w    %0000000000000011
                dc.w    %0000000000000001
PIXEL_TABLE_RIGHT
                dc.w    %1000000000000000
                dc.w    %1100000000000000
                dc.w    %1110000000000000
                dc.w    %1111000000000000
                dc.w    %1111100000000000
                dc.w    %1111110000000000
                dc.w    %1111111000000000
                dc.w    %1111111100000000
                dc.w    %1111111110000000
                dc.w    %1111111111000000
                dc.w    %1111111111100000
                dc.w    %1111111111110000
                dc.w    %1111111111111000
                dc.w    %1111111111111100
                dc.w    %1111111111111110
                dc.w    %1111111111111111

MESS_X_COORD    dc.w    0
MESS_Y_COORD    dc.w    0


 	SECTION BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SAUVE	DS.L	1	
ANC_VBL DS.L	1	
ANC_TB	DS.L	1	
ANC_ECR	DS.L	1	
RES	DS.W	1	
ANC_PAL	DS.W	16
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
