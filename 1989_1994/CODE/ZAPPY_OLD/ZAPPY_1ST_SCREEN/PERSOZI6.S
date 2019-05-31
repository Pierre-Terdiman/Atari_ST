IERA	EQU	$FFFA07		* INTERUPTION ENABLE A
IERB	EQU	$FFFA09		* INTERUPTION ENABLE B
ISRA	EQU	$FFFA0F		* INTERUPTION IN-SERVICE A
IMRA	EQU	$FFFA13		* INTERUPTION MASQUE A
TBCR	EQU	$FFFA1B		* TIMER B CONTROL REGISTER
TBDR	EQU	$FFFA21		* TIMER B DONNEE REGISTER
SYNCRO	EQU	$FF820A		* REGISTRE SYNCRO SHIFTER
COUL_0	EQU	$FF8240
COUL_1	EQU	$FF8242		* ADRESSES DES REGISTRES
COUL_2	EQU	$FF8244		* DE LA PALETTE DU SHIFTER
COUL_3	EQU	$FF8246
COUL_4	EQU	$FF8248
COUL_5	EQU	$FF824A
COUL_6	EQU	$FF824C
COUL_7	EQU	$FF824E
COUL_8	EQU	$FF8250
COUL_9	EQU	$FF8252
COUL_10	EQU	$FF8254
COUL_11	EQU	$FF8256
COUL_12	EQU	$FF8258
COUL_13	EQU	$FF825A
COUL_14	EQU	$FF825C
COUL_15	EQU	$FF825E
ACIA	EQU	$FFFC02		* LECTURE DE L'ACIA CLAVIER
PSG	EQU	$FF8800	        * pour le son...


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
	
	CLR.L 	-(SP)			* PASSAGE EN SUPERVISEUR
	MOVE.W 	#$20,-(SP)		*
	TRAP 	#1			*
	ADDQ.L 	#6,SP			*
	MOVE.L 	D0,SAUVE		* SAUVE LA PILE UTILISATEUR
			
	MOVE.B	IERA,MFP1		*
	MOVE.B	IERB,MFP2		*
	MOVE.B	ISRA,MFP3		* SAUVE LES REGISTRES
	MOVE.B	IMRA,MFP4		* UTILISES DU MFP
	MOVE.B	TBCR,MFP5		*
	MOVE.B	TBDR,MFP6		*
	
	CLR.B	IERA			* VIRE TOUTES LES
	CLR.B	IERB			* INTERUPTIONS
	

	MOVE.L	#BUFFER,D0		* ADRESSE DU BUFFER POUR ECRAN
	ANDI.L	#$FFFFFF00,D0		* SUPRIME LES 8 BITS "FAIBLE"
	ADD.L	#512,D0			* ET FAIT MULTIPLE DE 256
	MOVE.L	D0,ECRAN		* ON SAUVE L'ADRESSE CALCULEE
	
	MOVE.W	#4,-(SP)		* APPEL FONCTION GETREZ
	TRAP 	#14			* XBIOS...
	ADDQ.L	#2,SP			*
	MOVE.W	D0,RES			* SAUVE LA RESOLUTION
	
	MOVE.W	#2,-(SP)		* APPEL FONCTION PHYSBASE
	TRAP 	#14			* XBIOS
	ADDQ.L 	#2,SP			*
	MOVE.L	D0,ANC_ECR		* SAUVE L'ADRESSE ECRAN
	
	MOVE.W 	#0,-(SP)		* BASSE RESOLUTION
	MOVE.L	ECRAN,-(SP)		* PHYSBASE A ECRAN
	MOVE.L	ECRAN,-(SP)		* LOGBASE A ECRAN
	MOVE.W 	#5,-(SP)		* FONCTION SETSCREEN
	TRAP 	#14			* DU XBIOS
	LEA.L 	12(SP),SP		*

	MOVEA.L	ECRAN,A1		* ADRESSE DE L'ECRAN DANS A1
        ADDA.L  #4800,A1
	MOVEA.L	#FOND+34,A0		* ADRESSE DE L'IMAGE DANS A0
	MOVE.L	#7999,D0		* 8000 MOTS LONG A COPIER
COPY1	MOVE.L	(A0)+,(A1)+		* COPIE L'IMAGE DANS L'ECRAN
	DBF	D0,COPY1		* TANT QUE...

	MOVEA.L	ECRAN,A1		* ADRESSE DE L'ECRAN DANS A1
	MOVEA.L	#ROBOT+34,A0		* ADRESSE DE L'IMAGE DANS A0
	MOVE.L	#3999,D0		* 8000 MOTS LONG A COPIER
COPY2	MOVE.L	(A0)+,(A1)+		* COPIE L'IMAGE DANS L'ECRAN
	DBF	D0,COPY2		* TANT QUE...
	
	LEA.L	COUL_0,A0		* ADRESSE PALETTE SHIFTER
	MOVEM.L	(A0),D0-D7		* RECUPERE LES 16 REGISTRES
	LEA.L	ANC_PAL,A0		* ADRESSE DE SAUVEGARDE
	MOVEM.L	D0-D7,(A0)		* SAUVE LES 16 REGISTRES
	
	MOVE.L #MES_F,MES_PNT		* INIT POINTEUR MESSAGE
	MOVE.B	#4,NB_BIT		* 4 DECALAGE
	
	MOVEQ	#1,D0			* NETOIE D0
	JSR	MUSIQUE4		* INITIALISE LA MUSIQUE
        MOVE.W  #4,MUSIC
	
	;MOVEQ	#1,D0			* SPRITE 0 A AFFICHER
	;BSR	MOULIN			* AFFICHE LE SPRITE DU MOULIN
	
	LEA.L	TB_SPR,A5		* ADRESSE DE LA TABLE SPRITE
	MOVEQ	#0,D0			* NETOIE D0
	MOVEA.L	(A5,D0.W),A0		* ADRESSE SPRITE HAMBURGER 0
	MOVEA.L	(A5,D0.W),A2		* ADRESSE SPRITE HAMBURGER 0
	MOVEA.L	(A5,D0.W),A4		* ADRESSE SPRITE HAMBURGER 0
	BSR	HAMBUR			* AFFICHE LES 3 HAMBURGERS
	
	MOVE.L	$70,ANC_VBL		* SAUVE L'ANCIEN VECTEUR VBL
	MOVE.L	#VBL_IR,$70		* ET PLACE LE MIEN...
	MOVE.L	$120,ANC_TB		* SAUVE ANCIEN VECTEUR TIMER B
	MOVE.L	#TB00_IR,$120		* ET PLACE LE MIEN...
	
	DC.W	$A00A			* CACHE LA SOURIS (LINE A)
	MOVE.B	#$12,ACIA		* INIT CLAV
	
	CLR.B	TBCR			* ARRET DU TIMER B (PLUS PRUDENT)
	BSET	#0,IERA			* AUTORISE LES INTERUPTIONS
	BSET	#0,IMRA			* SUR LE TIMER B

**********************************************************************
			* ON TOURNE ICI TANT QU'ON N'A PAS APPUYE SUR
			* LA BARRE D'ESPACE CAR TOUTES L'ANIMATION EST
			* FAITE DANS INTERUPTION VBL...
BOUCLE:	
	MOVE.B	VSYNC,D0		* ATTEND UNE SYNCRO VERTICALE
WAIT	CMP.B	VSYNC,D0		* POUR LE TESTS DES TOUCHES
	BEQ.S	WAIT
        JSR  ZICTEST
	CMP.B	#$39,ACIA		* TESTE ESPACE (CODE SCAN)
	BNE.S	BOUCLE			* SI ESPACE, ON SORT DE L'INTRO
***********************************************************************

FIN:	
	MOVE.B	#8,ACIA			* REMET LE CLAVIER
	MOVE.B	MFP1,IERA		* RESTAURE LE MFP
	MOVE.B	MFP2,IERB		*
	MOVE.B	MFP3,ISRA		*
	MOVE.B	MFP4,IMRA		*
	MOVE.B	MFP5,TBCR		*
	MOVE.B	MFP6,TBDR		*
	
	MOVE.L	ANC_VBL,$70		* REMET LE VECTEUR VBL
	MOVE.L	ANC_TB,$120		* REMET LE VECTEUR TIMER C
	
	LEA.L	ANC_PAL,A0		* ADRESSE PALETTE SAUVEE
	MOVEM.L	(A0),D0-D7		* RECUPERE LES 16 REGISTRES
	LEA.L	COUL_0,A0		* ADRESSE PALETTE SHIFTER
	MOVEM.L	D0-D7,(A0)		* RESTITUE LES COULEURS
	
	MOVE.W 	RES,-(SP)		* ANCIENNE RESOLUTION
	MOVE.L	ANC_ECR,-(SP)		* ANCIEN ECRAN PHYSIQUE
	MOVE.L	ANC_ECR,-(SP)		* ANCIEN ECRAN LOGIQUE
	MOVE.W 	#5,-(SP)		* FONCTION SETSCREEN
	TRAP 	#14			* DU XBIOS
	LEA.L 	12(SP),SP		* CORRIGE LA PILE
	
	MOVE.L	SAUVE,-(SP)		* RETOUR EN UTILISATEUR
	MOVE.W 	#$20,-(SP)		* AVEC LA FONCTION SUPER
	TRAP 	#1			* DU GEMDOS
	ADDQ.L 	#6,SP			*
	
	PEA	CHUT_DA	   		* ADRESSE DES PARAMETRES
	MOVE.W	#$20,-(A7) 		* FONCTION DOSOUND
	TRAP	#14        		* DU XBIOS
	ADDQ.L	#6,A7      		* CORIGE LA PILE

	CLR.W 	-(SP)			* FIN DU PROGRAMME
	TRAP	#1			* FONCTION PTERM
	


********* SOUS PROGRAMMES D'INTERUPTION ************

ZICTEST CMP.B  #$3B,ACIA
        BNE.S  SUITE   
        MOVEQ  #1,D0
        JSR  MUSIQUE
        MOVE.W #1,MUSIC
SUITE   CMP.B  #$3C,ACIA
        BNE.S SUITE2
        MOVEQ  #2,D0
        JSR MUSIQUE
        MOVE.W #1,MUSIC
SUITE2  CMP.B  #$3D,ACIA
        BNE.S SUITE3
        MOVEQ  #3,D0
        JSR MUSIQUE
        MOVE.W #1,MUSIC
SUITE3  CMP.B  #$3E,ACIA
        BNE.S SUITE4
        MOVEQ  #1,D0
        JSR MUSIQUE2
        MOVE.W #2,MUSIC
SUITE4  CMP.B  #$3F,ACIA
        BNE.S SUITE5
        MOVEQ #2,D0
        JSR  MUSIQUE2
        MOVE.W  #2,MUSIC
SUITE5  CMP.B  #$40,ACIA
        BNE.S  SUITE6
        MOVEQ #0,D0
        JSR  MUSIQUE3
        MOVE.W  #3,MUSIC
SUITE6  CMP.B  #$41,ACIA
        BNE.S  SUITE7
        MOVEQ #1,D0
        JSR  MUSIQUE4
        MOVE.W  #4,MUSIC
SUITE7  CMP.B  #$42,ACIA
        BNE.S END
        MOVEQ #0,D0
        JSR  MUSIQUE5
        MOVE.W  #5,MUSIC
END     RTS



VBL_IR	
        MOVE.B  #0,SYNCRO 
	MOVEM.L	D0,-(SP)		* SAUVE LE REGISTRE
	CLR.B	TBCR			* ARRET DU TIMER B
	MOVE.B	#1,TBDR		* INTERUPTION SUR LIGNE 117  (109)
	MOVE.B	#8,TBCR			* TIMER C EN EVENT COUNT MODE
	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL0,A5			* ADRESSE NOUVELLE PALETTE DANS A5
     REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET LA NOUVELLE PALETTE EN PLACE
     ENDR

	CMP.W	#1,MUSIC
	BEQ.S	VBL8			* SI OUI, ALORS MUSIQUE ON
	ADDQ.W	#1,POIROT4		* SI NON, ON INCREMENTE COMPTEUR
	BRA.S	VBL10			* ET ON EXECUTE PAS LA MUSIQUE
VBL8	JSR	MUSIQUE+8		* MUSIQUE SVP...
VBL10   CMP.W	#2,MUSIC
	BEQ.S	VBL11			* SI OUI, ALORS MUSIQUE ON
	ADDQ.W	#1,POIROT4		* SI NON, ON INCREMENTE COMPTEUR
	BRA.S	VBL12			* ET ON EXECUTE PAS LA MUSIQUE
VBL11	JSR	MUSIQUE2+8		* MUSIQUE SVP...
VBL12   CMP.W	#3,MUSIC
	BEQ.S	VBL13			* SI OUI, ALORS MUSIQUE ON
	ADDQ.W	#1,POIROT4		* SI NON, ON INCREMENTE COMPTEUR
	BRA.S	VBL14			* ET ON EXECUTE PAS LA MUSIQUE
VBL13	JSR	MUSIQUE3+8		* MUSIQUE SVP...
VBL14   CMP.W	#4,MUSIC
	BEQ.S	VBL15			* SI OUI, ALORS MUSIQUE ON
	ADDQ.W	#1,POIROT4		* SI NON, ON INCREMENTE COMPTEUR
	BRA.S	VBL16			* ET ON EXECUTE PAS LA MUSIQUE
VBL15	JSR	MUSIQUE4+8		* MUSIQUE SVP...
VBL16   CMP.W	#5,MUSIC
	BEQ.S	VBL17			* SI OUI, ALORS MUSIQUE ON
	ADDQ.W	#1,POIROT4		* SI NON, ON INCREMENTE COMPTEUR
	BRA.S	VBL9			* ET ON EXECUTE PAS LA MUSIQUE
VBL17	JSR	MUSIQUE5+8		* MUSIQUE SVP...



VBL9	BSR	HAMBURGER		* ANIME HAMBURGER
VBL7	CMP.W	#50*5,POIROT1		* VOIR PLUS HAUT SAUF QU'ICI
	BEQ.S	VBL4			* C'EST POUR LE SCROLL TEXTE
	ADDQ.W	#1,POIROT1		*
	BRA.S	VBL3			*
VBL4	BSR	SCR_TXT			*
	BSR	DEFIL
VBL3	MOVEM.L	(SP)+,D0		* RESTAURE LE REGISTRE
	NOT.B	VSYNC			* BASCULE POUR SYNCRO
	RTE				* FIN DE L'INTERUPTION VBL

******************************

TB00_IR	
        MOVE.B  #2,SYNCRO
        CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#93,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB0_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)



TB0_IR	

	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1,A5			* ADRESSE DE LA NOUVELLE PALETTE
        REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET EN PLACE LA NOUVELLE PALETTE
	ENDR
        CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#8,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB11_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)


TB11_IR	
	MOVE.B	#0,SYNCRO	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL11,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB12_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB12_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL12,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB13_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB13_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL13,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB14_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB14_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL14,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB15_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB15_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL15,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB16_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB16_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL16,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB17_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB17_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL17,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB18_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB18_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL18,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB19_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB19_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL19,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1A_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1A_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1A,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1B_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1B_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1B,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1C_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1C_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1C,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1D_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1D_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1D,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1E_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1E_IR	
	LEA.L	COUL_14,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1E,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	MOVE.L	(A5),(A6)		* MET EN PLACE LA NOUVELLE PALETTE
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#1,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1F_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1F_IR	
	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1F,A5			* ADRESSE DE LA NOUVELLE PALETTE
        REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET EN PLACE LA NOUVELLE PALETTE
	ENDR
        CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#7,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1G_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1G_IR	
	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1G,A5			* ADRESSE DE LA NOUVELLE PALETTE
        REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET EN PLACE LA NOUVELLE PALETTE
	ENDR
        CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#7,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1H_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1H_IR	
	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL1H,A5			* ADRESSE DE LA NOUVELLE PALETTE
        REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET EN PLACE LA NOUVELLE PALETTE
	ENDR
        CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#13,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB2_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB2_IR	
	MOVE.B	#2,SYNCRO	
	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	LEA.L	PAL2,A5			* ADRESSE DE LA NOUVELLE PALETTE
     	REPT 8
        MOVE.L	(A5)+,(A6)+		* MET EN PLACE LA NOUVELLE PALETTE
	ENDR
        CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#57,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TBF_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)



TBF_IR
     REPT 127
	NOP				* BOUCLE D'ATTENTE...
     ENDR
	MOVE.B	#0,SYNCRO		* PASSAGE EN 60 HZ
     REPT 8
     	NOP				* BOUCLE D'ATTENTE
     ENDR
	MOVE.B	#2,SYNCRO		* RETOUR EN 50 HZ
	CLR.B	TBCR			* ARRET DU TIMER B
	MOVE.L	#TB00_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* INTERUPTION TRAITEE
	RTE				* RETOUR
**********************************************************************
DEFIL:  
        MOVE.L	ECRAN,A4		* ADRESSE DE L'ECRAN
	ADDA.L	#160*102,A4		* DECALE A PARTIR DE LA LIGNE 195
          rept 13
          roxl.w    152(a4)
          roxl.w    144(a4)
          roxl.w    136(a4)         ;D‚cale le 1er plan
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
          move.w    (a4),152(a4)
          roxl.w    154(a4)
          roxl.w    146(a4)
          roxl.w    138(a4)         ;D‚cale le 2eme plan
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
         roxl.w    18(a4)
         roxl.w    10(a4)
         roxl.w    2(a4)
          move.w    2(a4),154(a4)
          roxl.w    158(a4)
          roxl.w    150(a4)
          roxl.w    142(a4)
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
         roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)  
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          move.w    6(a4),158(a4)
          adda.l    #160,A4
          ENDR


          rept 10
          roxl.w    152(a4)
          roxl.w    144(a4)
          roxl.w    136(a4)         ;D‚cale le 1er plan
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
          move.w    (a4),152(a4)
          roxl.w    154(a4)
          roxl.w    146(a4)
          roxl.w    138(a4)         ;D‚cale le 2eme plan
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
         roxl.w    18(a4)
         roxl.w    10(a4)
         roxl.w    2(a4)
          move.w    2(a4),154(a4)
          roxl.w    158(a4)
          roxl.w    150(a4)
          roxl.w    142(a4)
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
         roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)  
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          roxl.w    152(a4)
          roxl.w    144(a4)
          roxl.w    136(a4)         ;D‚cale le 1er plan
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
          move.w    (a4),152(a4)
          roxl.w    154(a4)
          roxl.w    146(a4)
          roxl.w    138(a4)         ;D‚cale le 2eme plan
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
         roxl.w    18(a4)
         roxl.w    10(a4)
         roxl.w    2(a4)
          move.w    2(a4),154(a4)
          roxl.w    158(a4)
          roxl.w    150(a4)
          roxl.w    142(a4)
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
         roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)  
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          move.w    6(a4),158(a4)
          adda.l    #160,A4
          ENDR
         
          rept 10
          roxl.w    152(a4)
          roxl.w    144(a4)
          roxl.w    136(a4)         ;D‚cale le 1er plan
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
          move.w    (a4),152(a4)
          roxl.w    154(a4)
          roxl.w    146(a4)
          roxl.w    138(a4)         ;D‚cale le 2eme plan
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
         roxl.w    18(a4)
         roxl.w    10(a4)
         roxl.w    2(a4)
          move.w    2(a4),154(a4)
          roxl.w    158(a4)
          roxl.w    150(a4)
          roxl.w    142(a4)
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
         roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)  
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          roxl.w    152(a4)
          roxl.w    144(a4)
          roxl.w    136(a4)         ;D‚cale le 1er plan
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
          move.w    (a4),152(a4)
          roxl.w    154(a4)
          roxl.w    146(a4)
          roxl.w    138(a4)         ;D‚cale le 2eme plan
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
         roxl.w    18(a4)
         roxl.w    10(a4)
         roxl.w    2(a4)
          move.w    2(a4),154(a4)
          roxl.w    158(a4)
          roxl.w    150(a4)
          roxl.w    142(a4)
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
         roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)  
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          roxl.w    152(a4)
          roxl.w    144(a4)
          roxl.w    136(a4)         ;D‚cale le 1er plan
          roxl.w    128(a4)
          roxl.w    120(a4)
          roxl.w    112(a4)
          roxl.w    104(a4)
          roxl.w    96(a4)
          roxl.w    88(a4)
          roxl.w    80(a4)
          roxl.w    72(a4)
          roxl.w    64(a4)
          roxl.w    56(a4)
          roxl.w    48(a4)
          roxl.w    40(a4)
          roxl.w    32(a4)
          roxl.w    24(a4)
          roxl.w    16(a4)
          roxl.w    8(a4)
          roxl.w    (a4)
          move.w    (a4),152(a4)
          roxl.w    154(a4)
          roxl.w    146(a4)
          roxl.w    138(a4)         ;D‚cale le 2eme plan
          roxl.w    130(a4)
          roxl.w    122(a4)
          roxl.w    114(a4)
          roxl.w    106(a4)
          roxl.w    98(a4)
          roxl.w    90(a4)
          roxl.w    82(a4)
          roxl.w    74(a4)
          roxl.w    66(a4)
          roxl.w    58(a4)
          roxl.w    50(a4)
          roxl.w    42(a4)
          roxl.w    34(a4)
          roxl.w    26(a4)
         roxl.w    18(a4)
         roxl.w    10(a4)
         roxl.w    2(a4)
          move.w    2(a4),154(a4)
          roxl.w    158(a4)
          roxl.w    150(a4)
          roxl.w    142(a4)
          roxl.w    134(a4)
          roxl.w    126(a4)
          roxl.w    118(a4)
          roxl.w    110(a4)
          roxl.w    102(a4)
         roxl.w    94(a4)
          roxl.w    86(a4)
          roxl.w    78(a4)
          roxl.w    70(a4)
          roxl.w    62(a4)
          roxl.w    54(a4)  
          roxl.w    46(a4)
          roxl.w    38(a4)
          roxl.w    30(a4)
          roxl.w    22(a4)
          roxl.w    14(a4)
          roxl.w    6(a4)
          move.w    6(a4),158(a4)
          adda.l    #160,A4
          ENDR
         RTS
SCR_TXT	MOVEQ	#32,D0			* 33 LIGNES A DECALER
	MOVE.L	#160,D1			* VALEUR D'INCREMENT (1 LIGNE)
	LEA.L	CAR_BUF,A5		* ADRESSE DU BUFFER CARACTERE
	MOVE.L	ECRAN,A4		* ADRESSE DE L'ECRAN
	ADDA.L	#160*102,A4		* DECALE A PARTIR DE LA LIGNE 195

DECAL:

	MOVE.B	160*0+5(A4),160*0+4(A4)		* PLAN 3
 ;       MOVE.B	160*0+5(A4),160*1+4(A4)		
	MOVE.B	160*0+12(A4),160*0+5(A4)
  ;      MOVE.B	160*0+12(A4),160*1+5(A4)
	MOVE.B	160*0+13(A4),160*0+12(A4)
   ;     MOVE.B	160*0+13(A4),160*1+12(A4)
	MOVE.B	160*0+20(A4),160*0+13(A4)
    ;    MOVE.B	160*0+20(A4),160*1+13(A4)
	MOVE.B	160*0+21(A4),160*0+20(A4)
     ;   MOVE.B	160*0+21(A4),160*1+20(A4)
	MOVE.B	160*0+28(A4),160*0+21(A4)
	;MOVE.B	160*0+28(A4),160*1+21(A4)
	MOVE.B	160*0+29(A4),160*0+28(A4)
;	MOVE.B	160*0+29(A4),160*1+28(A4)
	MOVE.B	160*0+36(A4),160*0+29(A4)
	;MOVE.B	160*0+36(A4),160*1+29(A4)
	MOVE.B	160*0+37(A4),160*0+36(A4)
	;MOVE.B	160*0+37(A4),160*1+36(A4)
	MOVE.B	160*0+44(A4),160*0+37(A4)
	;MOVE.B	160*0+44(A4),160*1+37(A4)
	MOVE.B	160*0+45(A4),160*0+44(A4)
	;MOVE.B	160*0+45(A4),160*1+44(A4)
	MOVE.B	160*0+52(A4),160*0+45(A4)
	;MOVE.B	160*0+52(A4),160*1+45(A4)
	MOVE.B	160*0+53(A4),160*0+52(A4)
	;MOVE.B	160*0+53(A4),160*1+52(A4)
	MOVE.B	160*0+60(A4),160*0+53(A4)
 	;MOVE.B	160*0+60(A4),160*1+53(A4)
	MOVE.B	160*0+61(A4),160*0+60(A4)
	;MOVE.B	160*0+61(A4),160*1+60(A4)
	MOVE.B	160*0+68(A4),160*0+61(A4)
	;MOVE.B	160*0+68(A4),160*1+61(A4)
	MOVE.B	160*0+69(A4),160*0+68(A4)
	;MOVE.B	160*0+69(A4),160*1+68(A4)
	MOVE.B	160*0+76(A4),160*0+69(A4)	
 	;MOVE.B	160*0+76(A4),160*1+69(A4)	
	MOVE.B	160*0+77(A4),160*0+76(A4)
	;MOVE.B	160*0+77(A4),160*1+76(A4)
	MOVE.B	160*0+84(A4),160*0+77(A4)
	;MOVE.B	160*0+84(A4),160*1+77(A4)
	MOVE.B	160*0+85(A4),160*0+84(A4)
	;MOVE.B	160*0+85(A4),160*1+84(A4)
	MOVE.B	160*0+92(A4),160*0+85(A4)
	;MOVE.B	160*0+92(A4),160*1+85(A4)
	MOVE.B	160*0+93(A4),160*0+92(A4)
	;MOVE.B	160*0+93(A4),160*1+92(A4)
	MOVE.B	160*0+100(A4),160*0+93(A4)
	;MOVE.B	160*0+100(A4),160*1+93(A4)
	MOVE.B	160*0+101(A4),160*0+100(A4)
	;MOVE.B	160*0+101(A4),160*1+100(A4)
	MOVE.B	160*0+108(A4),160*0+101(A4)
	;MOVE.B	160*0+108(A4),160*1+101(A4)
	MOVE.B	160*0+109(A4),160*0+108(A4)
	;MOVE.B	160*0+109(A4),160*1+108(A4)
	MOVE.B	160*0+116(A4),160*0+109(A4)
	;MOVE.B	160*0+116(A4),160*1+109(A4)
	MOVE.B	160*0+117(A4),160*0+116(A4)
	;MOVE.B	160*0+117(A4),160*1+116(A4)
	MOVE.B	160*0+124(A4),160*0+117(A4)
	;MOVE.B	160*0+124(A4),160*1+117(A4)
	MOVE.B	160*0+125(A4),160*0+124(A4)
	;MOVE.B	160*0+125(A4),160*1+124(A4)
	MOVE.B	160*0+132(A4),160*0+125(A4)
	;MOVE.B	160*0+132(A4),160*1+125(A4)
	MOVE.B	160*0+133(A4),160*0+132(A4)
	;MOVE.B	160*0+133(A4),160*1+132(A4)
	MOVE.B	160*0+140(A4),160*0+133(A4)
	;MOVE.B	160*0+140(A4),160*1+133(A4)
	MOVE.B	160*0+141(A4),160*0+140(A4)
	;MOVE.B	160*0+141(A4),160*1+140(A4)
	MOVE.B	160*0+148(A4),160*0+141(A4)
	;MOVE.B	160*0+148(A4),160*1+141(A4)
	MOVE.B	160*0+149(A4),160*0+148(A4)
	;MOVE.B	160*0+149(A4),160*1+148(A4)
	MOVE.B	160*0+156(A4),160*0+149(A4)
	;MOVE.B	160*0+156(A4),160*1+149(A4)
	MOVE.B	160*0+157(A4),160*0+156(A4)
	;MOVE.B	160*0+157(A4),160*1+156(A4)
	MOVE.B	4(A5),160*0+157(A4)	*
	;MOVE.B	4(A5),160*1+157(A4)	*

	MOVE.B	5(A5),4(A5)		* SCROLL LE BUFFER
	MOVE.B	10(A5),5(A5)		* TROISIEMES PLANS
	MOVE.B	11(A5),10(A5)		*


	ADDA.L	#12,A5
	ADDA.L D1,A4			* AJOUTE 1 LIGNE
	DBF D0,DECAL			* ET ON BOUCLE 33 FOIS






	SUBQ.B #1,NB_BIT		* ON DECREMENTE LE COMPTEUR
	BEQ.S NEXTCHAR			* SI 0, PREND LE CARACTERE SUIVANT
	RTS				* RETOUR

NEXTCHAR:
	MOVE.B	#4,NB_BIT		* REMET LE COMPTEUR A 32
	MOVEQ	#0,D0			* NETOIE D0
	MOVE.L	MES_PNT,A0		* POINTEUR TEXTE DANS D0
	MOVE.B	(A0)+,D0		* MET LE CARACTERE SUIVANT DANS D0
	CMPI.B	#-1,D0			* SI -1, ON RECOMMENCE LE TEXTE
	BEQ	 AGAIN			*
	MOVE.L	A0,MES_PNT		* SAUVE LE POINTEUR
	CMPI.B	#-2,D0			* SI -2, ESPACE
	BEQ	SPACE			*
	CMPI.B	#39,D0			* SI D0 > 39 -> CINQUIEME RANGE
	BGT	LINE5			* * DANS LA PAGE GRAPHIQUE
	CMPI.B	#29,D0			* SI D0 > 29 -> QUATRIEME RANGE
	BGT.S	LINE4			* DANS LA PAGE GRAPHIQUE
	CMPI.B	#19,D0			* SI D0> > 19 -> TROISIEME RANGE
	BGT.S	LINE3			* DANS LA PAGE GRAPHIQUE
	CMPI.B	#9,D0			* SI D0 > 9 -> DEUXIEME RANGE
	BGT.S	LINE2			* DANS LA PAGE GRAPHIQUE
LINE1:	LSL.L	#4,D0			* MULTIPLIE D0 PAR 16
	LEA.L	FONTES,A1		* ADRESSE DES FONTS EN MEMOIRE
	ADDA.L	#34,A1			* ON SAUTE LES DATAS INUTILES
	ADDA.L	D0,A1			* ADRESSE DU PROCHAIN CAR DANS A1
	MOVE.L	A1,CAR_ADR		* SAUVE SON ADRESSE DANS CAR_ADR
	BSR	LOAD_C			* COPIE LE CARACTERE DANS BUFFER
	RTS				*
LINE2:	SUB.B	#10,D0			* POSITION DU CAR DANS LA LIGNE
	LSL.L	#4,D0			* MULTIPLIE PAR 16
	LEA.L	FONTES,A1		* ADRESSE DES FONTS EN MEMOIRE
	ADDA.L	#34,A1			* SAUTE LES DATAS INUTILES
	ADDA.L	#160*33,A1		* (160*32): 32 LIGNES...
	ADDA.L	D0,A1			* POUR POINTE SUR LE CARACTERE
	MOVE.L	A1,CAR_ADR		* SAUVE ADRESSE DANS CAR_ADR
	BSR	LOAD_C			* COPIE LE CARACTERE DANS LE BUFFER
	RTS				* RETOUR
LINE3:	SUB.B	#20,D0			* VOIR AU DESSUS...
	LSL.L	#4,D0			*
	LEA.L	FONTES,A1		*
	ADDA.L	#34,A1			*
	ADDA.L	#160*66,A1		*
	ADDA.L	D0,A1			*
	MOVE.L	A1,CAR_ADR		*
	BSR	LOAD_C			*
	RTS				*
LINE4:	SUB.B	#30,D0			* VOIR AU DESSUS DU DESSUS
	LSL.L	#4,D0			*
	LEA.L	FONTES,A1		*
	ADDA.L	#34,A1			*
	ADDA.L	#160*99,A1		*
	ADDA.L	D0,A1			*
	MOVE.L	A1,CAR_ADR		*
	BSR	LOAD_C			*
	RTS				*
LINE5:	SUB.B	#40,D0			* VOIR AU DESSUS DU DESSUS DU...ETC...
	LSL.L	#4,D0			*
	LEA.L	FONTES,A1		*
	ADDA.L	#34,A1			*
	ADDA.L	#160*132,A1		*
	ADDA.L	D0,A1			*
	MOVE.L	A1,CAR_ADR		*
	BSR	LOAD_C			*
	RTS				*

SPACE	LEA	CAR_BUF,A0		* ADRESSE DU BUFFER DANS A0
     REPT 99				*
	CLR.L	(A0)+			* ON EFFACE LE BUFFER (DATA A 0)
     ENDR				*
	RTS				* RETOUR

AGAIN	MOVE.L	#MES_F,MES_PNT		* REINITIALISE LE POINTEUR TEXTE
	BRA	NEXTCHAR	        * ET ON RECOMMENCE...

LOAD_C	MOVE.L	CAR_ADR,A0		* ADRESSE DU CAR DANS A0
	LEA	CAR_BUF,A1	        * ADRESSE DU BUFFER DANS A1
	MOVE.L	#160,D0			* VALEUR D'INCREMENT
     REPT  33				*
	MOVE.L	(A0),(A1)+		* COPIE PREMIER ET DEUXIEME PLAN
	MOVE.W	4(A0),(A1)+		* COPIE TROISIEME ET QUATRIEME PLAN
	MOVE.L	8(A0),(A1)+		* COPIE LE PLAN 1 ET 2  SUIVANT
	MOVE.W	12(A0),(A1)+		* COPIE LE PLAN 3 ET 4 SUIVANT
	ADDA.L	D0,A0			* ON AJOUTE 160 (LIGNE SUIVANTE)
     ENDR				*
	RTS				* ET HOP...RETOUR

**********************************************************************

;MOULIN
;	MOVEQ	#0,D0			* NETOIE D0
;	LEA.L	TB_MOUL,A5		* ADRESSE DE LA TABLE SPRITE
;	MOVE.B	N_SPR,D0		* NUMERO DU SPRITE
;	ADDQ.B	#1,N_SPR		* ON L'INCCREMENTE
;	CMP.B	#16,N_SPR		* EST IL EGALE A 16
;	BNE.S	MOUL2			* NON? ALORS ON CONTINUE
;	CLR.B	N_SPR			* OUI ALORS ON REMET A 0
;MOUL2	LSL.L	#2,D0			* MULTIPLIE PAR 4
;	MOVEA.L	(A5,D0.W),A0		* ADRESSE SOURCE DU SPRITE 1
;	MOVEA.L	ECRAN,A1		* ADRESSE DE L'ECRAN DANS A1
;	ADDA.L	#(160*0)+(112/2),A1	* ADRESSE DESTINATION DU SPRITE
;	MOVE.L	#88,D7			* NOMBRE DE LIGNE A TRANSFERE
;	MOVE.L	#104,D6			* INCREMENT (1 LIGNE)
;MOUL3	
;     REPT 14
;     	MOVE.L	(A0)+,(A1)+		* ON COPIE UNE LIGNE DU SPRITE
;     ENDR
;	ADDA.L	D6,A0			* A0 POINTE SUR LA LIGNE SUIVANTE
;	ADDA.L	D6,A1			* A1     "      "      "
;	DBF	D7,MOUL3		* ET ON BOUCLE 89 FOIS
;	RTS				* RETOUR (OF COURSE)

**********************************************************************

HAMBURGER
	LEA.L	PSG,A6			* ADRESSE DU PSG
	LEA.L	TB_SPR,A5		* ADRESSE DE LA TABLE SPRITE
	MOVEQ	#0,D0			* NETOIE D0
	MOVE.B	#8,(A6)			* DEMANDE VOLUME CANAL 1
	MOVE.B	(A6),D0			* VOLUME CANAL 1
	LSL.L	#2,D0			* MULTIPLIE PAR 4
	MOVEA.L	(A5,D0.W),A0		* ADRESSE SOURCE DU SPRITE 1
	MOVE.B	#9,(A6)			* DEMANDE VOLUME CANAL 2
	MOVE.B	(A6),D0			* VOLUME CANAL 2
	LSL.L	#2,D0			* MULTIPLIE PAR 4
	MOVEA.L	(A5,D0.W),A2		* ADRESSE SOURCE DU SPRITE 2
	MOVE.B	#10,(A6)		* DEMANDE VOLUME CANAL 3
	MOVE.B	(A6),D0			* VOLUME CANAL 13
	LSL.L	#2,D0			* MULTIPLIE PAR 4
	MOVEA.L	(A5,D0.W),A4		* ADRESSE SOURCE DU SPRITE 3
HAMBUR	MOVEA.L	ECRAN,A1		* ADRESSE ECRAN DANS A1
	MOVEA.L	A1,A3			* COPIE DANS A3
	MOVEA.L	A1,A5			* ET A5
	ADDA.L	#(160*165)+(48/2),A1	* POSITION DU SPRITE 1
	ADDA.L	#(160*165)+(144/2),A3	* POSITION DU SPRITE 2
	ADDA.L	#(160*165)+(240/2),A5	* POSITION DU SPRITE 3
	MOVE.L	#5,D6			* 6 BOUCLES A AFFECTUER
	MOVE.L	#1600,D7		* VALEUR D'INCREMENT (10 LIGNES)
TRANSFERE
	MOVEM.L	(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,(A1)		* ET LE RECOPIE
	MOVEM.L	(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,(A3)		* ET LE RECOPIE
	MOVEM.L	(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,(A5)		* ET LE RECOPIE
	MOVEM.L	160(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,160(A1)		* ET LE RECOPIE
	MOVEM.L	160(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,160(A3)		* ET LE RECOPIE
	MOVEM.L	160(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,160(A5)		* ET LE RECOPIE
	MOVEM.L	320(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,320(A1)		* ET LE RECOPIE
	MOVEM.L	320(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,320(A3)		* ET LE RECOPIE
	MOVEM.L	320(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,320(A5)		* ET LE RECOPIE
	MOVEM.L	480(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,480(A1)		* ET LE RECOPIE
	MOVEM.L	480(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,480(A3)		* ET LE RECOPIE
	MOVEM.L	480(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,480(A5)		* ET LE RECOPIE
	MOVEM.L	640(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,640(A1)		* ET LE RECOPIE
	MOVEM.L	640(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,640(A3)		* ET LE RECOPIE
	MOVEM.L	640(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,640(A5)		* ET LE RECOPIE
	MOVEM.L	800(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,800(A1)		* ET LE RECOPIE
	MOVEM.L	800(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,800(A3)		* ET LE RECOPIE
	MOVEM.L	800(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,800(A5)		* ET LE RECOPIE
	MOVEM.L	960(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,960(A1)		* ET LE RECOPIE
	MOVEM.L	960(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,960(A3)		* ET LE RECOPIE
	MOVEM.L	960(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,960(A5)		* ET LE RECOPIE
	MOVEM.L	1120(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,1120(A1)		* ET LE RECOPIE
	MOVEM.L	1120(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,1120(A3)		* ET LE RECOPIE
	MOVEM.L	1120(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,1120(A5)		* ET LE RECOPIE
	MOVEM.L	1280(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,1280(A1)		* ET LE RECOPIE
        MOVEM.L	1280(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,1280(A3)		* ET LE RECOPIE
	MOVEM.L	1280(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,1280(A5)		* ET LE RECOPIE
	MOVEM.L	1440(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,1440(A1)		* ET LE RECOPIE
	MOVEM.L	1440(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,1440(A3)		* ET LE RECOPIE
	MOVEM.L	1440(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,1440(A5)		* ET LE RECOPIE
	ADDA.L	D7,A0			* A0 POINTE 10 LIGNE EN DESSOUS
	ADDA.L	D7,A1			* A1 POINTE 10 LIGNE EN DESSOUS
	ADDA.L	D7,A2			* A2 POINTE 10 LIGNE EN DESSOUS
	ADDA.L	D7,A3			* A3 POINTE 10 LIGNE EN DESSOUS
	ADDA.L	D7,A4			* A4 POINTE 10 LIGNE EN DESSOUS
	ADDA.L	D7,A5			* A5 POINTE 10 LIGNE EN DESSOUS
	DBF	D6,TRANSFERE		* ET ON BOUCLE 6 FOIS
	MOVEM.L	(A0),D0-D5		* RECUPERE SPRITE 1
	MOVEM.L	D0-D5,(A1)		* ET LE RECOPIE
	MOVEM.L	(A2),D0-D5		* RECUPERE SPRITE 2
	MOVEM.L	D0-D5,(A3)		* ET LE RECOPIE
	MOVEM.L	(A4),D0-D5		* RECUPERE SPRITE 3
	MOVEM.L	D0-D5,(A5)		* ET LE RECOPIE
	RTS				* RETOUR A L'ENVOYEUR...

**********************************************************************

	SECTION DATA
	EVEN

NEW_PAL	DC.W	$233,$233,$300,$700,$210,$320,$122,$122
	DC.W	$202,$707,$344,$344,$320,$540,$000,$777

MES_F	DC.B  -2,-2
        DC.B   0,1,2,3,4,5,6,7,8,9,10,11,12,13,14

	DC.B  -1
	EVEN
ROBOT   INCBIN  "14.pi1"
        EVEN
MUSIQUE	INCBIN	"ASTA2.MUS"	* ROUTINE ET DATA MUSIQUE
	EVEN
MUSIQUE2 INCBIN "ROLOUT.MUS"
         EVEN
MUSIQUE3 INCBIN "TEX1.MUS"
         EVEN
MUSIQUE4 INCBIN "TCB01.MUS"
         EVEN
MUSIQUE5 INCBIN "CYBER2.MUS"
         EVEN
FONTES	INCBIN	"GOODFNT.PI1"	* LES FONTES
	EVEN
FOND	INCBIN	"FOND4.PI1"		* LE FOND
	EVEN
SPRITES	INCBIN	"SPRITES2.PI1"		* LES SPRITES HAMBURGER
	EVEN
;MOU_SPR	INCBIN	"SPRITES2.PI1"	* LES SPRITES DU MOULIN
;	EVEN


;************ TABLE D'ADRESSE DES SPRITES HAMBURGER EN MEMOIRE **********
TB_SPR	DC.L	SPRITES+34+(160*1)+(0/2),SPRITES+34+(160*1)+(48/2)
	DC.L	SPRITES+34+(160*1)+(96/2),SPRITES+34+(160*1)+(144/2)
	DC.L	SPRITES+34+(160*1)+(192/2),SPRITES+34+(160*1)+(240/2)
	DC.L	SPRITES+34+(160*63)+(0/2),SPRITES+34+(160*63)+(48/2)
	DC.L	SPRITES+34+(160*63)+(96/2),SPRITES+34+(160*63)+(144/2)
	DC.L	SPRITES+34+(160*63)+(192/2),SPRITES+34+(160*63)+(240/2)
	DC.L	SPRITES+34+(160*125)+(0/2),SPRITES+34+(160*125)+(48/2)
	DC.L	SPRITES+34+(160*125)+(96/2),SPRITES+34+(160*125)+(144/2)
	DC.L	SPRITES+34+(160*125)+(144/2),SPRITES+34+(160*125)+(144/2)
	EVEN

*************** TABLE D'ADRESSE DES SPRITES MOULIN EN MEMOIRE **********
;TB_MOUL	DC.L	MOU_SPR+34+(160*0)+(0/2),MOU_SPR+34+(160*0)+(0/2)
;	DC.L	MOU_SPR+34+(160*0)+(0/2),MOU_SPR+34+(160*0)+(0/2)
;	DC.L	MOU_SPR+34+(160*0)+(112/2),MOU_SPR+34+(160*0)+(112/2)
;	DC.L	MOU_SPR+34+(160*0)+(112/2),MOU_SPR+34+(160*0)+(112/2)
;	DC.L	MOU_SPR+34+(160*90)+(0/2),MOU_SPR+34+(160*90)+(0/2)
;	DC.L	MOU_SPR+34+(160*90)+(0/2),MOU_SPR+34+(160*90)+(0/2)
;	DC.L	MOU_SPR+34+(160*90)+(112/2),MOU_SPR+34+(160*90)+(112/2)
;	DC.L	MOU_SPR+34+(160*90)+(112/2),MOU_SPR+34+(160*90)+(112/2)
;	EVEN
************************* LES DIFFERENTES PALETTES *********************
PAL0    DC.W    $030,$700,$000,$012,$023,$034,$045,$056
        DC.W    $077,$111,$222,$666,$444,$333,$555,$777
        EVEN
PAL1	DC.W	$000,$000,$000,$000,$323,$434,$545,$656
	DC.W	$000,$000,$000,$000,$212,$101,$577,$777
	EVEN
PAL11   DC.W    $100 
        EVEN
PAL12   DC.W    $200 
        EVEN
PAL13   DC.W    $300
        EVEN
PAL14   DC.W    $400
        EVEN
PAL15   DC.W    $500
        EVEN
PAL16   DC.W    $600
        EVEN
PAL17   DC.W    $700
        EVEN
PAL18   DC.W    $710
        EVEN
PAL19   DC.W    $720
        EVEN
PAL1A   DC.W    $730
        EVEN
PAL1B   DC.W    $740
        EVEN
PAL1C   DC.W    $750
        EVEN
PAL1D   DC.W    $760
        EVEN
PAL1E   DC.W    $770
        EVEN
PAL1F   DC.W    $000,$000,$000,$000,$112,$113,$223,$224
        DC.W    $000,$000,$000,$000,$003,$002,$000,$334
        EVEN
PAL1G   DC.W    $000,$000,$000,$000,$446,$556,$557,$667
        DC.W    $000,$000,$000,$000,$445,$335,$000,$777
        EVEN
PAL1H   DC.W    $000,$000,$000,$000,$444,$333,$222,$111
        DC.W    $000,$000,$000,$000,$555,$666,$000,$000
        EVEN
PAL2	DC.W	$700,$001,$011,$022,$033,$032,$043,$000
	DC.W	$723,$734,$744,$754,$300,$400,$500,$777
	EVEN

CHUT_DA	DC.B	7,$FF,6,0,8,0,9,0,$A,0

 	SECTION BSS
 	EVEN
F_PILE	DS.L 	128			* FIN DE LA PILE
D_PILE	DS.L 	1			* DEBUT DE LA PILE
ECRAN	DS.L 	1			* ADRESSE DE L'ECRAN
SAUVE	DS.L	1			* SAUVE LA PILE UTILISATEUR
ANC_VBL DS.L	1			* SAUVE LE VECTEUR VBL
ANC_TB	DS.L	1			* SAUVE LE VECTEUR TIMER B
ANC_ECR	DS.L	1			* SAUVE L'ADRESSE DE L'ECRAN
CAR_BUF	DS.L	99			* BUFFER POUR FONTS
MES_PNT	DS.L	1			* POINTEUR SUR MESSAGE
CAR_ADR	DS.L	1			* ADRESSE DATA DU CARACTERE
POIROT1	DS.W	1			* COMPTEURS POUR FAIRE DEMARRER
POIROT2	DS.W	1			* LES ANIMATIONS, LES UNES
POIROT3	DS.W	1			* APRES LES AUTRES
POIROT4	DS.W	1			*
RES	DS.W	1			* SAUVE LA RESOLUTION
ANC_PAL	DS.W	16			* SAUVE LA PALETTE
MFP1	DS.B	1			* SAUVE LES REGISTRES DU MFP
MFP2	DS.B	1			*
MFP3	DS.B	1			*
MFP4	DS.B	1			*
MFP5	DS.B	1			*
MFP6	DS.B	1			*
BUFFER	DS.B	45000			* BUFFER POUR L'ECRAN
VSYNC	DS.B	1			* POUR LA SYNCRO VERTICALE
NB_BIT	DS.B	1			* NOMBRE DE DECALAGE EFFECTUE
N_SPR	DS.B	1			* NUMERO DU SPRITE MOULIN
MUSIC   DS.W    1
