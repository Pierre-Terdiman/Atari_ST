* PARAMETRES ATTENDUS:	A0 : ADRESSE DU BUFFER
* ********************	D0 : DRIVE
*		D1 : FACE
*		D2 : PISTE
*		D3 : NOMBRE DE SECTEUR A ECRIRE
*
* LES VALEURS DOIVENT ETRE PASSEES SUR LA PILE, UNE RESTAURATION
* DE LA PILE EST NECESSAIRE APRES UN APPEL A CET ROUTINE.
*

	PEA	0.W
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	#BUFFER,ADR
	MOVE.L	#2,TRACK
	MOVE	#121,D7
	DIVS	#10,D7
	MOVE	D7,D6
	CLR	D7
	SWAP	D7
	SUB.L	#1,D6
	
WRITED	MOVE.L	#10,-(SP)
	MOVE.L	TRACK,-(SP)
	MOVE.L	#0,-(SP)
	MOVE.L	#0,-(SP)
	MOVE.L	ADR,-(SP)
;	PEA	BUFFER
	JSR	TRACK
	ADDA.L	#20,SP
	ADD.L	#512*10,ADR
	ADDQ.L	#1,TRACK
	DBF	D6,WRITED

	MOVE.L	D7,-(SP)
	MOVE.L	TRACK,-(SP)
	MOVE.L	#0,-(SP)
	MOVE.L	#0,-(SP)
	MOVE.L	ADR,-(SP)
	JSR	TRACK
	ADDA.L	#20,SP

	PEA	0.W
	TRAP	#1

ADR	DS.L	1
TRACK	DS.L	1
regs		reg	d0-d7/a0-a6

flock		equ	$43e

Dma_control	equ	$ff8606
Fdc_count	equ	$ff8604

Dma_high	equ	$ff8609
Dma_mid		equ	$ff860b
Dma_low		equ	$ff860d

TRACK
***************************************************************************
	move.l	4(a7),a0	Adresse du buffer
	move.l	8(a7),d0	Drive
	move.l	12(a7),d1	Face
	move.l	16(a7),d2	Piste
	move.l	20(a7),d3	Nombre de secteurs a ecrire

***************************************************************************
	movem.l	regs,-(a7)	Sauver les registres

	moveq	#0,d4	Efface D4 et D5
	moveq	#0,d5

	lea	Dma_control,a6

	st	flock	Bloquer la vbl disquette

	bsr	Set_drive	Selectionner Drive

	addq.w	#1,d3	Nombre de secteurs+1
*			a cause du test.

Seek:	tst.w	d2	Piste = zero ?
	bne.s	Tracks	Non, alors on positionne la
*			tete sur la piste courante

***************************************************************************
	move.w	#$82,d6	Piste = zero
	move.w	#$ff,d7	RESTORE TRACK 0 (255)
	bsr	WD_write
	
	move.w	#$80,d6
	moveq	#1,d7
	bsr	WD_write
	bra.s	Wait_Tracks

***************************************************************************
Tracks:	move.w	#$86,d6
	move.w	d2,d7
	bsr	WD_write
	
	move.w	#$80,d6
	moveq	#%00010001,d7	SEEK TRACK (h=1, V=0, r1=0 et r0=1)
	bsr.s	WD_write

***************************************************************************
Wait_Tracks:
	bsr	Wait_done
	moveq	#1,d4	Lecture a partir du secteur 1.

***************************************************************************

******
ECRIT:
******
Set_DMA:move.l	a0,d5
	move.b	d5,Dma_low
	lsr.l	#8,d5
	move.b	d5,Dma_mid
	lsr.l	#8,d5
	move.b	d5,Dma_high
	
***************************************************************************

*************
Write_sector:
*************
DMA_in:	move.w	#$190,(a6)
	move.w	#$90,(a6)
	move.w	#$190,d6
	moveq	#1,d7	On ecrit 1 secteur
	bsr.s	WD_write

	move.w	#$182,d6	Piste dans Track register
	move.w	d2,d7
	bsr.s	WD_write

	move.w	#$184,d6	Secteur dans Sector register
	move.w	d4,d7
	bsr.s	WD_write

	move.w	#$180,d6
	move.w	#%10100000,D7	Commande Write Sector
	bsr.s	WD_write
	bsr.s	Wait_done

	adda.l	#512,a0	Buffer + 512 octets
	addq.w	#1,d4	Secteur + 1
	cmp.w	d3,d4	A-t-on ecrit tout les secteurs ?
	bne.s	ECRIT	Non, alors on continue...

	bsr.s	Test_DMA	Test des eventuelles erreurs

***************************************************************************
Motor_off:
	move.b	#7,d4	Eteindre la led du drive selectionne
	bsr.s	Select	et arreter le moteur

***************************************************************************
Dma_reset:
;	move.w	#$80,d6	< A enlever
;	move.w	#$d0,d7	< si l'on veut arreter
;	bsr.s	WD_write	< le moteur a la fin
***************************************************************************

	sf	flock	Liberer la vbl disquette

	movem.l	(a7)+,regs	Restaurer les registres

	rts		Fin de la routine...Retour a l'envoyeur !

***************************************************************************
* WD_WRITE
* --------
*
* FONCTION : EXECUTE UNE COMMANDE FDC
* ==========
*
* REGISTRES UTILISES : D6, D7 ET A6
*
* COMMANDE A EXECUTER DANS D6 ET VALEUR DANS D7
***************************************************************************
WD_write:
	move.w	d6,(a6)
	bsr.s	Attend
	move.w	d7,Fdc_count

***************************************************************************
* ATTEND
* ------
*
* FONCTION : PAUSE ENTRE CHAQUE ORDRE
* ==========
*
* REGISTRE UTILISE : D5
*
* AUCUN PARAMETRE ATTENDU
***************************************************************************
Attend:	moveq	#40,d5

Attend1:dbf	d5,Attend1
	rts

***************************************************************************
* WAIT_DONE ET WAIT
* -----------------
*
* FONCTION : PAUSE ET TEST DE LA FIN D'UN ORDRE
* ==========
*
* AUCUN REGISTRE UTILISE
* AUCUN PARAMETRE ATTENDU
***************************************************************************
Wait_done:
	bsr.s	Attend

Wait:	btst	#5,$fffa01
	bne.s	Wait
	rts

***************************************************************************
* SET_DRIVE
* ---------
*
* FONCTION : SELECTIONNE ET DESELECTIONNE LE DRIVE (A OU B)
* ==========
*
* REGISTRES UTILISES : D4 