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
	MOVE.L	#$78000,-(SP)
	MOVE.L	#$78000,-(SP)
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
	CLR	$FFFF8240.W
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	LEA	BUFFER,A0
	LEA	H,A1
	MOVE.L	#19,D0
COPY_H	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_H

	LEA	BUFFER+4*2,A0
	LEA	O,A1
	MOVE.L	#19,D0
COPY_O	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_O


	LEA	BUFFER+4*2*2,A0
	LEA	L,A1
	MOVE.L	#19,D0
COPY_L	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_L

	LEA	BUFFER+4*2*3,A0
	LEA	O,A1
	MOVE.L	#19,D0
COPY_O2	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_O2

	LEA	BUFFER+4*2*4,A0
	LEA	C,A1
	MOVE.L	#19,D0
COPY_C	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_C

	LEA	BUFFER+4*2*5,A0
	LEA	A,A1
	MOVE.L	#19,D0
COPY_A	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_A

	LEA	BUFFER+4*2*6,A0
	LEA	U,A1
	MOVE.L	#19,D0
COPY_U	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_U

	LEA	BUFFER+4*2*7,A0
	LEA	S,A1
	MOVE.L	#19,D0
COPY_S	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_S

	LEA	BUFFER+4*2*8,A0
	LEA	T,A1
	MOVE.L	#19,D0
COPY_T	MOVE.L	(A1)+,(A0)+
	MOVE	(A1)+,(A0)+
	LEA	33*2(A0),A0
	DBF	D0,COPY_T

	
	LEA	BUFFER,A0
	LEA	$FFFF8240.W,A1

	MOVE.L	#$FFFF8209,A3	
	MOVEQ	#$10,D6
	MOVE	#$2700,SR

SYNCHRO	MOVE.B	(A3),D7     
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	97
	NOP	
	ENDR

	REPT	20
	DCB	10,$4E71
	DCB	36,$3298	MOVE	(A0)+,(A1)
	DCB	10,$4E71
	ENDR
	
	MOVE	#$2300,SR
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


 	SECTION BSS
 	EVEN
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
BUFFER	DS	36*200
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
