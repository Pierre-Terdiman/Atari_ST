Z=10

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
	CLR.L	PNT
	CLR.L	OFFSET
	CLR	Y_VALUE
	CLR	Y_VALUE2
	CLR	Y_VALUE3
	CLR	Y_VALUE4
	CLR	Y_VALUE5
	CLR	Y_VALUE6
	CLR	Y_VALUE7
	CLR	Y_VALUE8
	CLR	Y_VALUE9
		
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
	MOVE.L	#RTE,$120.W
	
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
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	CLR	$FFFF8240.W
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	LEA	Y_LOGO,A0
	ADDA.L	PNT,A0
	LEA	Y_VALUE,A2
LA_BAS	MOVE	Z*0(A0),(A2)+
	MOVE	Z*2(A0),(A2)+
	MOVE	Z*4(A0),(A2)+
	MOVE	Z*6(A0),(A2)+
	MOVE	Z*8(A0),(A2)+
	MOVE	Z*10(A0),(A2)+
	MOVE	Z*12(A0),(A2)+
	MOVE	Z*14(A0),(A2)+
	MOVE	Z*16(A0),(A2)+
	ADDQ.L	#2,PNT
	CMPI.L	#100*2,PNT
	BNE.S	OKAY
	CLR.L	PNT
OKAY	LEA	BUFFER,A0
	ADDA	Y_VALUE,A0
	LEA	H,A1
	MOVE.L	#19,D0
COPY_H	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_H

	LEA	BUFFER+4*2,A0
	ADDA	Y_VALUE2,A0
	LEA	O,A1
	MOVE.L	#19,D0
COPY_O	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_O


	LEA	BUFFER+4*2*2,A0
	ADDA	Y_VALUE3,A0
	LEA	L,A1
	MOVE.L	#19,D0
COPY_L	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_L

	LEA	BUFFER+4*2*3,A0
	ADDA	Y_VALUE4,A0
	LEA	O,A1
	MOVE.L	#19,D0
COPY_O2	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_O2

	LEA	BUFFER+4*2*4,A0
	ADDA	Y_VALUE5,A0
	LEA	C,A1
	MOVE.L	#19,D0
COPY_C	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_C

	LEA	BUFFER+4*2*5,A0
	ADDA	Y_VALUE6,A0
	LEA	A,A1
	MOVE.L	#19,D0
COPY_A	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_A

	LEA	BUFFER+4*2*6,A0
	ADDA	Y_VALUE7,A0
	LEA	U,A1
	MOVE.L	#19,D0
COPY_U	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_U

	LEA	BUFFER+4*2*7,A0
	ADDA	Y_VALUE8,A0
	LEA	S,A1
	MOVE.L	#19,D0
COPY_S	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_S

	LEA	BUFFER+4*2*8,A0
	ADDA	Y_VALUE9,A0
	LEA	T,A1
	MOVE.L	#19,D0
COPY_T	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_T

	st	$ffff8240.w
	
	LEA	BUFFER,A0
	LEA	$FFFF8240.W,A1

	CLR.L	D1
	MOVE.L	#$FFFF8209,A3
	MOVE.L	#199,D0
	MOVEQ	#$10,D6
	clr.l	d7
	MOVE	#$2700,SR

SYNCHRO	MOVE.B	(A3),D7     
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	97
	NOP	
	ENDR
SYNC
;	REPT	200
	DCB	10,$4E71
	DCB	36,$3298	MOVE	(A0)+,(A1)
	DCB	10-3,$4E71
	DBF	D0,SYNC
;	ENDR


	MOVE	#$070,(A1)
;	LEA	BUFFER,A0
;	MOVEQ	#0,D0
;	MOVEQ	#0,D1
;	MOVEQ	#0,D2
;	MOVEQ	#0,D3
;	MOVEQ	#0,D4
;	MOVEQ	#0,D5
;	MOVEQ	#0,D6
;	MOVEQ	#0,D7
;N	SET	0
;	REPT	450
;	MOVEM.L	D0-D7,N(A0)
;N	SET	N+4*8
;	ENDR	

 
	LEA	BUFFER,A0
	ADDA	Y_VALUE,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR
	LEA	BUFFER+4*2,A0
	ADDA	Y_VALUE2,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*2,A0
	ADDA	Y_VALUE3,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*3,A0
	ADDA	Y_VALUE4,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*4,A0
	ADDA	Y_VALUE5,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*5,A0
	ADDA	Y_VALUE6,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*6,A0
	ADDA	Y_VALUE7,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*7,A0
	ADDA	Y_VALUE8,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	LEA	BUFFER+4*2*8,A0
	ADDA	Y_VALUE9,A0
N	SET	0
	REPT	20	
	CLR.L	N(A0)
	CLR	N+4(A0)
N	SET	N+72
	ENDR

	MOVE	#$700,$FFFF8240.W
	
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NOT_F1
	CMPI.L	#36*8,OFFSET
	BGT.S	NOT_F1
	ADD.L	#36,OFFSET	
NOT_F1
	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	NOT_F2
	CMPI.L	#0,OFFSET
	BEQ.S	NOT_F2
	SUB.L	#36,OFFSET	
NOT_F2


	LEA	LA_BAS,A0
	LEA	TABLE,A2
	ADDA.L	OFFSET,A2
	REPT	9
	MOVE.L	(A2)+,(A0)+
	ENDR
	MOVE	#$000,(A1)

	


	
	MOVE	#$2300,SR
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
RTE	RTE


 


TB0_IR	
	CLR.B	$FFFFFA1B.W
	MOVE.B	#1,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB0_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			







	 
	section   data
H	
	DC	$100,$000,$100
	DC	$200,$000,$200
	DC	$300,$000,$300
	DC	$400,$000,$400

	DC	$500,$000,$500
	DC	$600,$000,$600
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$700,$700
	DC	$700,$700,$700
	DC	$700,$700,$700
	DC	$700,$700,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$600,$000,$600
	DC	$500,$000,$500

	DC	$400,$000,$400
	DC	$300,$000,$300
	DC	$200,$000,$200
	DC	$100,$000,$100

O	
	DC	$000,$100,$000
	DC	$000,$200,$000
	DC	$000,$300,$000
	DC	$400,$400,$400

	DC	$500,$000,$500
	DC	$600,$000,$600
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$600,$000,$600
	DC	$500,$000,$500

	DC	$400,$400,$400
	DC	$000,$300,$000
	DC	$000,$200,$000
	DC	$000,$100,$000


L	
	DC	$100,$000,$000
	DC	$200,$000,$000
	DC	$300,$000,$000
	DC	$400,$000,$000

	DC	$500,$000,$000
	DC	$600,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$600,$600,$600
	DC	$500,$500,$500

	DC	$400,$400,$400
	DC	$300,$300,$300
	DC	$200,$200,$200
	DC	$100,$100,$100


C	
	DC	$000,$100,$100
	DC	$000,$200,$200
	DC	$000,$300,$300
	DC	$400,$400,$400

	DC	$500,$500,$500
	DC	$600,$600,$600
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$700,$000,$000
	DC	$600,$600,$600
	DC	$500,$500,$500

	DC	$400,$400,$400
	DC	$000,$300,$300
	DC	$000,$200,$200
	DC	$000,$100,$100

A	
	DC	$100,$100,$100
	DC	$200,$200,$200
	DC	$300,$300,$300
	DC	$400,$400,$400

	DC	$500,$000,$500
	DC	$600,$000,$600
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$700,$700
	DC	$700,$700,$700
	DC	$700,$700,$700
	DC	$700,$700,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$600,$000,$600
	DC	$500,$000,$500

	DC	$400,$000,$400
	DC	$300,$000,$300
	DC	$200,$000,$200
	DC	$100,$000,$100

U	
	DC	$100,$000,$100
	DC	$200,$000,$200
	DC	$300,$000,$300
	DC	$400,$000,$400

	DC	$500,$000,$500
	DC	$600,$000,$600
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$700,$000,$700
	DC	$600,$600,$600
	DC	$500,$500,$500

	DC	$400,$400,$400
	DC	$300,$300,$300
	DC	$200,$200,$200
	DC	$100,$100,$100


S	
	DC	$000,$100,$100
	DC	$000,$200,$200
	DC	$000,$300,$300
	DC	$000,$400,$400

	DC	$000,$500,$000
	DC	$000,$600,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$600,$000
	DC	$000,$500,$000

	DC	$400,$400,$000
	DC	$300,$300,$000
	DC	$200,$200,$000
	DC	$100,$100,$000

T	
	DC	$100,$100,$100
	DC	$200,$200,$200
	DC	$300,$300,$300
	DC	$400,$400,$400

	DC	$500,$500,$500
	DC	$000,$600,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$700,$000
	DC	$000,$600,$000
	DC	$000,$500,$000

	DC	$000,$400,$000
	DC	$000,$300,$000
	DC	$000,$200,$000
	DC	$000,$100,$000

Y_LOGO
 DC 5112
 DC 5400
 DC 5688
 DC 6048
 DC 6336
 DC 6624
 DC 6912
 DC 7200
 DC 7488
 DC 7776
 DC 8064
 DC 8280
 DC 8496
 DC 8784
 DC 8928
 DC 9144
 DC 9360
 DC 9504
 DC 9648
 DC 9792
 DC 9864
 DC 9936
 DC 10008
 DC 10080
 DC 10080
 DC 10152
 DC 10080
 DC 10080
 DC 10008
 DC 9936
 DC 9864
 DC 9792
 DC 9648
 DC 9504
 DC 9360
 DC 9144
 DC 8928
 DC 8784
 DC 8496
 DC 8280
 DC 8064
 DC 7776
 DC 7488
 DC 7200
 DC 6912
 DC 6624
 DC 6336
 DC 6048
 DC 5688
 DC 5400
 DC 5040
 DC 4752
 DC 4464
 DC 4104
 DC 3816
 DC 3528
 DC 3240
 DC 2952
 DC 2664
 DC 2376
 DC 2088
 DC 1872
 DC 1656
 DC 1368
 DC 1224
 DC 1008
 DC 792
 DC 648
 DC 504
 DC 360
 DC 288
 DC 216
 DC 144
 DC 72
 DC 72
 DC 72
 DC 72
 DC 72
 DC 144
 DC 216
 DC 288
 DC 360
 DC 504
 DC 648
 DC 792
 DC 1008
 DC 1224
 DC 1368
 DC 1656
 DC 1872
 DC 2088
 DC 2376
 DC 2664
 DC 2952
 DC 3240
 DC 3528
 DC 3816
 DC 4104
 DC 4464
 DC 4752

 DC 5112
 DC 5400
 DC 5688
 DC 6048
 DC 6336
 DC 6624
 DC 6912
 DC 7200
 DC 7488
 DC 7776
 DC 8064
 DC 8280
 DC 8496
 DC 8784
 DC 8928
 DC 9144
 DC 9360
 DC 9504
 DC 9648
 DC 9792
 DC 9864
 DC 9936
 DC 10008
 DC 10080
 DC 10080
 DC 10152
 DC 10080
 DC 10080
 DC 10008
 DC 9936
 DC 9864
 DC 9792
 DC 9648
 DC 9504
 DC 9360
 DC 9144
 DC 8928
 DC 8784
 DC 8496
 DC 8280
 DC 8064
 DC 7776
 DC 7488
 DC 7200
 DC 6912
 DC 6624
 DC 6336
 DC 6048
 DC 5688
 DC 5400
 DC 5040
 DC 4752
 DC 4464
 DC 4104
 DC 3816
 DC 3528
 DC 3240
 DC 2952
 DC 2664
 DC 2376
 DC 2088
 DC 1872
 DC 1656
 DC 1368
 DC 1224
 DC 1008
 DC 792
 DC 648
 DC 504
 DC 360
 DC 288
 DC 216
 DC 144
 DC 72
 DC 72
 DC 72
 DC 72
 DC 72
 DC 144
 DC 216
 DC 288
 DC 360
 DC 504
 DC 648
 DC 792
 DC 1008
 DC 1224
 DC 1368
 DC 1656
 DC 1872
 DC 2088
 DC 2376
 DC 2664
 DC 2952
 DC 3240
 DC 3528
 DC 3816
 DC 4104
 DC 4464
 DC 4752

TABLE
ZA	SET	1
	REPT	10
	MOVE	ZA*0(A0),(A2)+
	MOVE	ZA*2(A0),(A2)+
	MOVE	ZA*4(A0),(A2)+
	MOVE	ZA*6(A0),(A2)+
	MOVE	ZA*8(A0),(A2)+
	MOVE	ZA*10(A0),(A2)+
	MOVE	ZA*12(A0),(A2)+
	MOVE	ZA*14(A0),(A2)+
	MOVE	ZA*16(A0),(A2)+
ZA	SET	ZA+1
	ENDR
	
 	SECTION BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SAUVE	DS.L	1
OFFSET	DS.L	1
ANC_VBL 	DS.L	1	
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
PNT	DS.L	1
Y_VALUE	DS	1
Y_VALUE2	DS	1
Y_VALUE3	DS	1
Y_VALUE4	DS	1
Y_VALUE5	DS	1
Y_VALUE6	DS	1
Y_VALUE7	DS	1
Y_VALUE8	DS	1
Y_VALUE9	DS	1
BUFFER	DS.L	36*100
