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
	MOVE.W 	#0,-(SP)
	MOVE.W 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP
	
	CLR.L 	-(SP)			
	MOVE.W 	#$20,-(SP)		
	TRAP 	#1			
	ADDQ.L 	#6,SP			
	MOVE.L 	D0,SAUVE		



	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

			
	
	MOVE.W	#4,-(SP)		
	TRAP 	#14			
	ADDQ.L	#2,SP			
	MOVE.W	D0,RES			
	
	MOVE.W	#2,-(SP)		
	TRAP 	#14			
	ADDQ.L 	#2,SP			
	MOVE.L	D0,ANC_ECR		
	
	MOVE.W 	#0,-(SP)		
	MOVE.L	#-1,-(SP)		
	MOVE.L	#-1,-(SP)		
	MOVE.W 	#5,-(SP)		
	TRAP 	#14			
	LEA.L 	12(SP),SP		

	LEA.L	$ffff8240.w,A0		
	MOVEM.L	(A0),D0-D7		
	LEA.L	ANC_PAL,A0		
	MOVEM.L	D0-D7,(A0)		
	
	
	
	MOVE.L	$70,ANC_VBL		
	MOVE.L	#VBL_IR,$70		
	MOVE.L	$120,ANC_TB		
	MOVE.L	#TB00_IR,$120		
	
	DC.W	$A00A			
	MOVE.B	#$12,$FFFFFC02.W
	

	movem.l	IMAGE+2,d0-d7	
	movem.l	d0-d7,$ff8240	

	bsr	SET_SCR		
	lea	TEXTE,a0	
	move.l	a0,MEM_LET	
	move.w	#0,PART_AFF	



BOUCLE:	
	MOVE.B	VSYNC,D0		
WAIT	CMP.B	VSYNC,D0		
	BEQ.S	WAIT
	CMP.B	#$39,$FFFFFC02.W
	BNE.S	BOUCLE			

FIN:	
        MOVE.B  #2,$FFFF820A.W
	MOVE.B	#8,$FFFFFC02.W	
	
	MOVE.L	ANC_VBL,$70		
	MOVE.L	ANC_TB,$120		
	
	LEA.L	ANC_PAL,A0		
	MOVEM.L	(A0),D0-D7		
	LEA.L	$FFFF8240.W,A0		
	MOVEM.L	D0-D7,(A0)		
	
	MOVE.W 	RES,-(SP)		
	MOVE.L	ANC_ECR,-(SP)		
	MOVE.L	ANC_ECR,-(SP)		
	MOVE.W 	#5,-(SP)		
	TRAP 	#14			
	LEA.L 	12(SP),SP		
	
	MOVE.L	SAUVE,-(SP)		
	MOVE.W 	#$20,-(SP)		
	TRAP 	#1			
	ADDQ.L 	#6,SP			
	

	CLR.W 	-(SP)			
	TRAP	#1			
	




VBL_IR	
	CLR	$FFFF8240.W

	JSR	SWAP_SCR
	JSR	AFF_FNT
	JSR	SCROLL
	
full	
	MOVE.L	#$FFFF8209,A3	
	MOVE.L	#$FFFF8260,A1	
	MOVE.L	#$FFFF820A,A0	
	MOVE	#32,D0		* NB DE LIGNES
	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6
	MOVE	#$2700,SR


SYNCHRO	MOVE.B	(A3),D7     * SYNCHRO
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	2
	NOP	
	ENDR
	REPT	19
	move.l	(a6)+,(a5)+			 
	ENDR



	
FULLSCREEN

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

;	MOVE	(a6)+,$ffff8240.W		
;	MOVE	(a6),$ffff8242.W
;	MOVE	(a6)+,$ffff8244.W	* MOVE.W=4 NOPS
		
	REPT	4
	NOP				
	ENDR
	
	* ESSAI=20
	REPT	17
	move.l	(a6)+,(a5)+			 
	ENDR

	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)


	REPT	2
	move.l	(a6)+,(a5)+			 
	ENDR
	
	REPT	3		
	NOP
	ENDR
	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	move.l	(a6)+,(a5)+			 

	REPT	4
	NOP			 
	ENDR

	DBF	D0,FULLSCREEN


	MOVE	#$700,$FFFF8240.W



	MOVE	#$777,$FFFF8240.W
;	bsr	SCROLL2
	CLR	$FFFF8240.W
	NOT.B	VSYNC		
	RTE			
	
	
TB00_IR	
	RTE			


SET_SCR:	move.l	#BUFFERSCR,d0	
	and.l	#$ffffff00,d0		
	move.l	d0,SCREEN1		
	add.l	#64000,d0		
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
        move.l	SCREEN2,a5	
	move.l	SCREEN2,a6
	adda.l	#8+160,a6
	adda.l	#160,a5
;	RTS	
;SCROLL2
	rept 	(33*38)-19
	move.l	(a6)+,(a5)+
	endr


	rts

AFF_FNT:	cmp.w	#1,PART_AFF
	blo	PART1
	beq	PART2
	cmp.w	#3,PART_AFF
	blo	PART3
	beq	PART4
	
PART1:	move.l	#IMAGE+34,a2	Pointe sur les fontes
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1	(8 pixels de large)
	adda.l	#216+160,a1
INC	set	0
INC2	SET	0
	rept	33
	move.b	INC+9(a2),INC2(a1)
	move.b	INC+11(a2),INC2+2(a1)
	move.b	INC+13(a2),INC2+4(a1)
        move.b  INC+15(a2),INC2+6(a1)  * ok je pense
INC	set	INC+160
INC2	SET	INC2+230
	endr
	
	addq.l	#2,a0		On passe … une autre lettre
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	On sauvegarde le pointeur
	
	move.l	#IMAGE+34,a2
	adda.w	(a0),a2
INC	set 	0
INC2	set 	0
	rept 	33
	move.b	INC+0(a2),INC2+1(a1)
	move.b	INC+2(a2),INC2+3(a1)
	move.b	INC+4(a2),INC2+5(a1)  * ok
        move.b  INC+6(a2),INC2+7(a1)
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#1,PART_AFF
	bra	FIN_SCRO	
	
PART2:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+160,a1
INC	set	0
INC2	set	0
	rept	33
	move.l	INC(a2),INC2(a1)
	move.w	INC+4(a2),INC2+4(a1)
        move.w  INC+6(a2),INC2+6(a1)      * ok
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#2,PART_AFF
	bra	FIN_SCRO

PART3:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+160,a1
INC	set	0
INC2	set	0
	rept	33
	move.b	INC+1(a2),INC2(a1)	
	move.b	INC+3(a2),INC2+2(a1)	
	move.b	INC+5(a2),INC2+4(a1)
        move.b  INC+7(a2),INC2+6(a1)
	move.b	INC+8(a2),INC2+1(a1)	
	move.b	INC+10(a2),INC2+3(a1)	
	move.b	INC+12(a2),INC2+5(a1)	
        move.b  INC+14(a2),INC2+7(a1)      * ok ?
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#3,PART_AFF
	bra	FIN_SCRO

PART4:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+160,a1
INC	set	0
INC2	set	0

	rept	33
	move.l	INC+8(a2),INC2(a1)
	move.w	INC+12(a2),INC2+4(a1)
        move.w  INC+14(a2),INC2+6(a1)  * ok?
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#0,PART_AFF
	bra	FIN_SCRO

FIN_SCRO	rts	

	section   data

TEXTE:	INCBIN	speed.txt
IMAGE:	INCBIN	fontes1.PI1

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
VSYNC	DS.B	1			
	ds.b	256		
BUFFERSCR:ds.b	64000*2		
				
	ds.b	256		
SCREEN1:	ds.l	1	
SCREEN2:	ds.l	1	
MEM_LET:	ds.l	1
PART_AFF:	ds.l    1

		