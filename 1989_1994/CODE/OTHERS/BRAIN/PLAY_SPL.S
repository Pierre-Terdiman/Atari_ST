***************************************************************************
*	ROUTINE DE REPLAY 'TIMER A' V 1.0 POUR 'SPELL CASTERS'
*	------------------------------------------------------
* (C) DENIS NARDEAU LE 04/01/1992 ET LE 13/01/1992.
***************************************************************************

* VECTEURS MFP UTILISEES *
MFP	EQU	$FFFA00
AER	EQU	MFP+$03
IERA	EQU	MFP+$07
IERB	EQU	MFP+$09
IPRA	EQU	MFP+$0B
ISRA	EQU	MFP+$0F
IMRA	EQU	MFP+$13
IMRB	EQU	MFP+$15
VECTEUR	EQU	MFP+$17
TACR	EQU	MFP+$19
TADR	EQU	MFP+$1F
TIMAVEC	EQU	$134

* VECTEURS CLAVIER *
ACCONT	EQU	$FFFC00
ACDATA	EQU	$FFFC02

* ADRESSE DU PSG YAMAHA *
PSG	EQU	$FF8800

* REGISTRES MODIFIES DANS LA ROUTINE D'INTERRUPTION TIMER A *
REGS	REG	D0/D1/A0-A2


	SECTION TEXT

	CLR.L	-(A7)
	MOVE.W	#$20,-(A7)
	TRAP	#1			MODE SUPERVISEUR
	ADDQ.L	#6,A7
	MOVE.L	D0,STACK		SAUVEGARDE DU STACK POINTER
***************************************************************************
	MOVE.B	#6,$484			CLIC & REPEAT CLAVIER OFF

	JSR	VIDE_CLAVIER		VIDER LE BUFFER CLAVIER

	JSR	INIT_PSG		INITIALISATION DU PSG (REGS A 0)
***************************************************************************
SAUVE_MFP:
	MOVE.W	#$2700,SR		IPL 7

	MOVE.B	IERA,MFPMEM		/ SAUVEGARDE
	MOVE.B	IERB,MFPMEM+1		/ DES
	MOVE.B	IMRA,MFPMEM+2		/ VALEURS
	MOVE.B	IMRB,MFPMEM+3		/ INITIALES
	MOVE.B	TADR,MFPMEM+4		/ DES
	MOVE.B	TACR,MFPMEM+5		/ REGISTRES
	MOVE.B	VECTEUR,MFPMEM+6	/ DU MFP

	MOVE.L	#TIMAVEC,OLD134		SAUVER ANCIEN VECTEUR TIMER A
	MOVE.L	$118,OLD118
***************************************************************************
SET_FREQ:
	MOVE.B	#1,TACR			4 PRE-DIVISIONS (1)
	MOVE.B	#61,TADR		FREQUENCE DES SAMPLES
***************************************************************************
VAL_MFP:
	ORI.B	#32,IMRA		BIT 5 A 1
	ORI.B	#32,IERA		BIT 5 A 1
	BCLR	#3,VECTEUR		AUTOMATIC END OF INTERRUPT

	MOVE.L	#SAMPLE,SAMPTR+2	ADR. DE DEBUT DU SAMPLE DANS POINTEUR
	MOVE.L	#FINSAM,ENDSAMPTR+2	ADR. DE FIN DU SAMPLE DANS POINTEUR

	MOVE.L	#NEW_134,TIMAVEC	INSTALLER LA NOUVELLE ROUTINE D'INTERRUPTION TIMER A
	MOVE.L	#NOTHING,$118

	MOVE.W	#$2300,SR		IPL 3
***************************************************************************
KEY:
	TST.B	PLAY_FLAG		SAMPLE FINI ?
	BEQ.S	REST_MFP		OUI, ON SORT

   	BTST	#0,ACCONT		SINON
	BEQ.S	KEY			ATTENTE DE
	CMPI.B	#$39,ACDATA		LA BARRE D'ESPACEMENT
	BNE.S	KEY			ARMOIRE, ALORS ON BOUCLE

	SF	PLAY_FLAG		ARRETER LE REPLAY
***************************************************************************
REST_MFP:	
	MOVE.W	#$2700,SR		IPL 7

	MOVE.B	MFPMEM,IERA		/ RESTAURATION
	MOVE.B	MFPMEM+1,IERB		/ DES
	MOVE.B	MFPMEM+2,IMRA		/ VALEURS
	MOVE.B	MFPMEM+3,IMRB		/ INITIALES
	MOVE.B	MFPMEM+4,TADR		/ DES
	MOVE.B	MFPMEM+5,TACR		/ REGISTRES
	MOVE.B	MFPMEM+6,VECTEUR	/ DU MFP

	MOVE.L	OLD134,TIMAVEC		RESTAURER L'ANCIEN VECTEUR TIMER A
	MOVE.L	OLD118,$118
	MOVE.B	#7,$484			CLIC & REPEAT CLAVIER ON

	MOVE.W	#$2300,SR		IPL 3

	JSR	VIDE_CLAVIER		VIDE LE CLAVIER
***************************************************************************
	MOVE.L	STACK,-(A7)
	MOVE.W	#$20,-(A7)
	TRAP	#1			MODE USER
	ADDQ.L	#6,A7

	CLR.W	-(A7)
	MOVE.W	#$4C,-(A7)
	TRAP	#1			PTERM
***************************************************************************
* VIDANGE DU BUFFER CLAVIER
***************************************************************************
VIDE_CLAVIER:
  	BTST	#0,ACCONT
	BEQ.S	CLAVIER_VIDE
	MOVE.B	ACDATA,D0
	BRA.S	VIDE_CLAVIER
CLAVIER_VIDE:
	RTS
***************************************************************************
* INITIALISATION DU PSG A PARTIR DU MAIN
* (A APPELER EN DEBUT PG ET POUR COUPER LE SON)
***************************************************************************
INIT_PSG:
	LEA	PSG,A3			PSG LECTURE
	MOVEQ	#10,D2			VOLUME DU CANAL C (10)
INIT_PSG2:	
	MOVE.B	D2,(A3)			NUMERO DE REGISTRE DANS $FF8800
	CMPI.B	#7,D2			REGISTRE 7 DU PSG ?
	BEQ.S	REG7			OUI, NE PAS ECRIRE DANS LE PSG
	SF	2(A3)			$FF8802 = 0
	BRA.S	INIT_CONT
REG7:
	ST	2(A3)			$FF8802 = $FF (-1)
INIT_CONT:
	DBF	D2,INIT_PSG2		BOUCLER SUR LE NOMBRE DE REGISTRES
	RTS
***************************************************************************
* ROUTINE D'INTERRUPTION TIMER A (BAHBAH MAURICE CA TOURNE !!!)
*
* PARAMETRES ATTENDUS A PARTIR DU MAIN :
* --------------------------------------
* DEBUT SAMPLE DANS : SAMPTR+2
* FIN SAMPLE DANS   : ENDSAMPTR+2
***************************************************************************
NEW_134:
	NOP				A MODIFIER EN 'RTE' SI BESOIN
	MOVEM.L	REGS,-(A7)		SAUVER LES REGISTRES

	MOVE.W	SR,-(A7)		>>> A ENLEVER DANS LE JEU <<<

	MOVE.W	#$2300,SR		IPL 3

	TST.B	PLAY_FLAG		ARRET A PARTIR DU MAIN ?
  	BEQ.S	CUT_134			OUI, SHUNTER VECTEUR TIMER A

	MOVEQ	#0,D0			SINON, RAZ DE D0 ET...
SAMPTR:
	MOVE.L	#0,A0			ADRESSE SAMPLE EN COURS DANS A0
	OR.B	(A0)+,D0		OCTET A JOUER DANS D0

ENDSAMPTR:
	MOVE.L	#0,A1			ADRESSE DE FIN DU SAMPLE

	CMPA.L	A0,A1			LE SAMPLE EST-IL FINI ?
	BEQ.S	CUT_134			OUI, ON SHUNTE LE VECTEUR $134
	MOVE.L	A0,SAMPTR+2		SINON, NOUVELLE ADRESSE SAMPLE

PLAYSAM:
	LEA	TABLE,A1		ADRESSE DE LA TABLE VOLUME
	LEA	PSG,A2			ADRESSE DU PSG EN LECTURE

	LSL.W	#3,D0			VALEUR DE D0 * 8

	MOVE.L	(A1,D0.W),D1		VOLUME REGS 8 ET 9 DANS D1
	MOVE.W	4(A1,D0.W),D0		VOLUME REG 10 DANS D0

	MOVEP.L	D1,(A2)			ECRIRE REGISTRES 8,9
	MOVEP.W	D0,(A2)			ET 10 DANS LE PSG

	BRA.S	QUIT_134		SORTIR
CUT_134:
	MOVE.W	#$4E73,NEW_134		SHUNTER LA ROUTINE TIMER A
	SF	PLAY_FLAG		FLAG DE FIN DE REPLAY

QUIT_134:
	MOVE.W	(A7)+,SR		>>> A ENLEVER DANS LE JEU <<<

	MOVEM.L	(A7)+,REGS		RESTAURER LES REGISTRES
NOTHING:
	RTE
***************************************************************************
	SECTION DATA
********************************************
* ICI SE TROUVE LES SAMPLES A REJOUER
SAMPLE:
	INCBIN	E:\SAMPLES2.SPL\WELCOME.SPL
FINSAM:
********************************************
	EVEN

*************************************************************************
* FLAG D'ARRET POSITIONNE DANS LE MAIN (ICI CLAVIER) OU EN FIN DE REPLAY
* FLAG =  0 => NE PAS JOUER LE SAMPLE
* FLAG = -1 => JOUER LE SAMPLE
PLAY_FLAG:
	DC.B	-1

	EVEN
***************************************************
* ICI SE TROUVE LA TABLE DES VOLUMES
TABLE:	INCBIN	F:\SOURCASM.001\REP8TABL.BIN

	EVEN
***************************************************************************
	SECTION BSS
	
STACK:	DS.L	1		SAUVEGARDE ANCIEN STACK POINTER

OLD134:
	DS.L	1		SAUVEGARDE ANCIEN POINTEUR TIMER A

MFPMEM:	DS.B	8		SAUVEGARDE DES ANCIENNES VALEURS MFP

OLD118:	DS.B	1		SAUVEGARDE DE L'ANCIEN VECTEUR $118

	END