; Fullscreen total 460*274 - Zappy/Holocaust

; Se reporter … la s‚rie d'articles sur le full dans STMAG pour plus de
; d‚tails !

	OPT	O+

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

	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP

	CLR.W	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.L	#FIN,$008.W	D‚tournement des bombes
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	MOVE.L	#BUFFERSCR,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1

	MOVE.L	SCREEN1,A1	Affiche image
	LEA	160(A1),A1
	LEA	IMAGE+34,A0
	MOVE	#15754,D0
AFF	MOVE.L	(A0)+,(A1)+
	DBF	D0,AFF
	
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	MOVE.B	$FFFFFA15.W,MFP7
	MOVE.B	$FFFFFA17.W,MFP8
	MOVE.B	$FFFFFA19.W,MFP9
	MOVE.B	$FFFFFA1F.W,MFP10

	MOVE.L	$68.W,SAUVE_HBL
	MOVE.L	$134.W,SAUVE_TMA
	MOVE.L	#INTER_RTE,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	MOVE.B	#$12,$FFFFFC02.W
	DC.W	$A00A

	ANDI.B	#%11111000,$484.W

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	JMP	BOUCLE

VBLR
	CLR.B	$FFFFFA1B.W
	MOVEM.L	IMAGE+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.B	#0,$FFFFFA19.W		Pr‚paration du Timer A
	MOVE.B	#99,$FFFFFA1F.W	pour l'overscan haut
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W

	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

; … partir d'ici il reste environ 30 lignes de temps machine avant le
; d‚clenchement de l'interruption. ( l'‚quivalent de la bordure haut
; avant la premiŠre ligne de full, quoi. )

INTER_RTE	RTE


INTER_TMA:	CLR.B	$FFFFFA07.W	Au cas o—...
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR	HBL autoris‚e
	
full
	LEA	$FFFF8209.W,A3
	LEA	$FFFF8260.W,A1
	LEA	$FFFF820A.W,A0

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100	Attente de la prochaine Hbl
;			( fixe … 16 cycles prŠs environ )
	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D2
SYNCHRO_PREMIERE
	DBF	D2,SYNCHRO_PREMIERE
	NOP

	MOVE.B	D0,(A0)	Border haut out
	DCB	6,$4E71
	MOVE.B	D1,(A0)

*******	Passons aux choses s‚rieuses; le full!

	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6

SYNCHRO_FULL	MOVE.B	(A3),D7
	BEQ.S	SYNCHRO_FULL
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	DCB	97,$4E71	
; A la fin de la synchro on est au milieu d'une ligne, donc on attend la
;fin de cette ligne pour commencer le full la ligne suivante. D'o— le
;LEA 160(A1),A1 lors de l'affichage de l'image... ( Logique... )

;Rappel: 1 ligne=128 nops=512 cycles
; 1 ligne normale=160 octets=320 pixels
; 1 ligne full=230 octets=460 pixels en th‚orie

	REPT	227	227 lignes
	MOVE.B	D3,(A1)	Haute r‚solution
	NOP
	MOVE.B	D4,(A1)	Basse r‚solution  -- Plus de border gauche
	DCB	89,$4E71
	MOVE.B	D4,(A0)	60 Hz
	MOVE.B	D3,(A0)	50 Hz -- Plus de border droit
	DCB	13,$4E71
	MOVE.B	D3,(A1)	Stabilisateur
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR

**
	MOVE.B	D3,(A1)	2 lignes sp‚ciales pour le border bas
	NOP
	MOVE.B	D4,(A1)

	DCB	89,$4E71

	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	CLR.B	$FFFF820A.W 	Border bas out
;			Retour 50 Hz ligne suivante
    REPT 6+2
     	NOP			
     ENDR
* 2eme ligne
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	MOVE.B	D3,(A0)	...ici !

	DCB	87,$4E71
	
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71

	REPT	45	45 lignes dans le border bas
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	89,$4E71
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR

;Total=274 lignes de full

	MOVE	#$2300,SR
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	RTE

FIN:	
	MOVE	#$2700,SR
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	MOVE.B	MFP7,$FFFFFA15.W
	MOVE.B	MFP8,$FFFFFA17.W
	MOVE.B	MFP9,$FFFFFA19.W
	MOVE.B	MFP10,$FFFFFA1F.W
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	SAUVE_TMA,$134.W
	MOVE.L	SAUVE_HBL,$68.W

	MOVE	#$2300,SR

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	#2,$FFFF820A.W
	
	MOVE.L	SAUV_SP,-(SP)
	MOVE.W 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	
	PEA	0.W
	TRAP	#1

	DATA
IMAGE	INCBIN	SSUMMER.KID

	BSS
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
SCREEN1	DS.L	1
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
MFP7	DS.B	1
MFP8	DS.B	1
MFP9	DS.B	1
MFP10	DS.B	1
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	64000
