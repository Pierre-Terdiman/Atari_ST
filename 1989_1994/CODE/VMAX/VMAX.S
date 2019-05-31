 	SECTION TEXT
DEBUT:	MOVE.L  A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L 	$14(A5),D0
	ADD.L 	$1C(A5),D0
	ADD.L 	#$100,D0		
	MOVE.L 	D0,-(SP)		
        MOVE.L 	A5,-(SP)
	CLR 	-(SP)
	MOVE 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP
	
	CLR.L 	-(SP)			
	MOVE 	#$20,-(SP)		
	TRAP 	#1			
	ADDQ.L 	#6,SP			
	MOVE.L 	D0,SAUVE		
			
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
	
	CLR	-(SP)		
	MOVE.L	#-1,-(SP)		
	MOVE.L	#-1,-(SP)		
	MOVE 	#5,-(SP)		
	TRAP 	#14			
	LEA.L 	12(SP),SP		

	LEA.L	$FFFF8240.W,A0		
	MOVEM.L	(A0),D0-D7		
	LEA.L	ANC_PAL,A0		
	MOVEM.L	D0-D7,(A0)		
	
	MOVE.L	$70,ANC_VBL		
	MOVE.L	#VBL_IR,$70		
	MOVE.L	$120,ANC_TB		
	MOVE.L	#TB00_IR,$120		
	
	DC.W	$A00A			
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W		
	BSET	#0,$FFFFFA07.W		
	BSET	#0,$FFFFFA13.W		


	movem.l	IMAGE+2,d0-d7	
	movem.l	d0-d7,$ff8240	

	bsr	SET_SCR		
	lea	TEXTE,a0	
	move.l	a0,MEM_LET	
	MOVE	#0,PART_AFF	


BOUCLE	JMP	BOUCLE

FIN:	
        MOVE.B  #2,$FFFF820A.W
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W		
	MOVE.B	MFP2,$FFFFFA09.W		
	MOVE.B	MFP3,$FFFFFA0F.W		
	MOVE.B	MFP4,$FFFFFA13.W		
	MOVE.B	MFP5,$FFFFFA1B.W		
	MOVE.B	MFP6,$FFFFFA21.W		
	
	MOVE.L	ANC_VBL,$70		
	MOVE.L	ANC_TB,$120		
	
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
	ADDQ.L	#2,SP
	




VBL_IR	
	CMPI.B	#$15,$FFFFFC02.W
	BNE.S	P
	MOVE	#$777,$FFFF8240.W
P

	CLR.B	$FFFFFA1B.W
;	MOVE.B	#30,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

        bsr	SWAP_SCR

	bsr	SCROLL
	bsr	AFF_FNT	
        CLR	$FFFF8240.W

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
	
TB00_IR	
        MOVE   #$010,$FF8240
        CLR.B	$FFFFFA1B.W
	MOVE.B	#30,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB01_IR,$120
	BCLR	#0,$FFFFFA0F.W
	RTE			



;TBF_IR
;     REPT 127
;	NOP				
;     ENDR
;	MOVE.B	#0,SYNCRO		
;     REPT 8
;     	NOP				
;     ENDR
;	MOVE.B	#2,SYNCRO		
;	CLR.B	$FFFFFA1B.W		
;	MOVE.L	#TB00_IR,$120		
;	BCLR	#0,$FFFFFA0F.W		
;	RTE				

SET_SCR:	move.l	#BUFFERSCR,d0	
	and.l	#$ffffff00,d0		
	move.l	d0,SCREEN1		
	add.l	#32000,d0		
	move.l	d0,SCREEN2		
	rts				

SWAP_SCR:	move.l	SCREEN1,d0	
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2		
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	rts
SCROLL:	
        move.l	SCREEN2,a0	
	move.l	SCREEN2,a1
	adda.l	#8,a1
	
	rept 	33*20		
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	endr


	rts

AFF_FNT:	cmp.w	#1,PART_AFF
	blo	PART1
	beq	PART2
	cmp.w	#3,PART_AFF
	blo	PART3
	beq	PART4
	
PART1:	move.l	#IMAGE+34,a2	
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1	
	adda.l	#152,a1
INC	set	0
	rept	33
	move.b	INC+9(a2),INC(a1)
	move.b	INC+11(a2),INC+2(a1)
	move.b	INC+13(a2),INC+4(a1)
        move.b  INC+15(a2),INC+6(a1)
INC	set	INC+160
	endr
	
	addq.l	#2,a0		
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	
	
	move.l	#IMAGE+34,a2
	adda.w	(a0),a2
INC	set 	0
	rept 	33
	move.b	INC+0(a2),INC+1(a1)
	move.b	INC+2(a2),INC+3(a1)
	move.b	INC+4(a2),INC+5(a1)
        move.b  INC+6(a2),INC+7(a1)
        
INC	set	INC+160
	endr
	MOVE	#1,PART_AFF
	bra	FIN_SCRO	
	
PART2:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#152,a1
INC	set	0
	rept	33
	move.l	INC(a2),INC(a1)
	MOVE	INC+4(a2),INC+4(a1)
        MOVE  INC+6(a2),INC+6(a1)
INC	set	INC+160
	endr
	MOVE	#2,PART_AFF
	bra	FIN_SCRO

PART3:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#152,a1
INC	set	0
	rept	33
	move.b	INC+1(a2),INC(a1)	
	move.b	INC+3(a2),INC+2(a1)	
	move.b	INC+5(a2),INC+4(a1)
        move.b  INC+7(a2),INC+6(a1)
	move.b	INC+8(a2),INC+1(a1)	
	move.b	INC+10(a2),INC+3(a1)	
	move.b	INC+12(a2),INC+5(a1)	
        move.b  INC+14(a2),INC+7(a1)
INC	set	INC+160
	endr
	MOVE	#3,PART_AFF
	bra	FIN_SCRO

PART4:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#152,a1
INC	set	0
	rept	33
	move.l	INC+8(a2),INC(a1)
	MOVE	INC+12(a2),INC+4(a1)
        MOVE  INC+14(a2),INC+6(a1)
INC	set	INC+160
	endr
	MOVE	#0,PART_AFF
	bra	FIN_SCRO

FIN_SCRO	rts	


	section   data

TEXTE:	INCBIN	TXT
IMAGE:	INCBIN	fontes2.PI1
	

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
VSYNC	DS.B	1			
	ds.b	256		
BUFFERSCR:ds.b	32000*2
	ds.b	256	
SCREEN1:	ds.l	1
SCREEN2:	ds.l	1
MEM_LET:	ds.l	1
PART_AFF:	ds.l    1
		