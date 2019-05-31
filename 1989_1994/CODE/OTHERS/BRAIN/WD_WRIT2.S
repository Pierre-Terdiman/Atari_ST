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
	
	MOVE.L	#1,-(SP)
	MOVE.L	#20,-(SP)
	MOVE.L	#0,-(SP)
	MOVE.L	#0,-(SP)
	PEA	BUFFER
	JSR	TRACK
	ADDA.L	#20,SP
	
	PEA	0.W
	TRAP	#1

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
* REGISTRES UTILISES : D4 ET D5
* ********************
*
* VALEUR DU DRIVE DANS D0
* ***********************
*
***************************************************************************
Set_drive:
	move.w	d0,d4

	cmpi.w	#1,d0
	bgt.s	End_Set

	addq.b	#1,d4
	lsl.b	#1,d4
	or.w	d1,d4
	eori.b	#7,d4
	andi.b	#7,d4

Select:	move.w	sr,-(a7)
	ori.w	#$700,sr

	move.b	#$e,$ff8800
	move.b	$ff8800,d5

	andi.b	#$f8,d5
	or.b	d4,d5
	move.b	d5,$ff8802

	move.w	(a7)+,sr
End_Set: 
	rts

***************************************************************************
* TEST_DMA (A ENLEVER SI PAS UTILISE)
* --------
*
* FONCTION : TEST DU STATUS FDC ET AFFICHAGE SI ERREUR
* ==========
*
* REGISTRES UTILISES : A1 ET D7
* ********************
*
* AUCUN PARAMETRE ATTENDU.
***************************************************************************
Test_DMA:
	move.w	Fdc_count,d7
	bsr.s	Attend

	lea	NUL(pc),a1	Si pas d'erreur
	bsr.s	Aff_DMA

PROT_:	btst	#6,d7		Write Protected
	beq.s	DAM_
	lea	PROT(pc),a1
	bsr.s	Aff_DMA

DAM_:	btst	#5,d7		Data Adress Mark
	beq.s	RNF_
	lea	DAM(pc),a1
	bsr.s	Aff_DMA

RNF_:	btst	#4,d7		Record Not Found
	beq.s	CRC_
	lea	RNF(pc),a1
	bsr.s	Aff_DMA

CRC_:	btst	#3,d7		Checksum error
	beq.s	End_test
	lea	CRC(pc),a1

Aff_DMA:
	move.l	a1,-(a7)
	move.w	#9,-(a7)
	trap	#1		CCONWS
	addq.l	#6,a7

End_test:
	rts

	EVEN

NUL:	DC.b 27,'Y',32+5,32+35,'         ',0
PROT:	DC.b 27,'Y',32+5,32+35,'PROTECTED',7,0
DAM:	DC.b 27,'Y',32+5,32+38,'DAM ERROR',7,0
RNF:	DC.b 27,'Y',32+5,32+38,'RNF ERROR',7,0
CRC:	DC.b 27,'Y',32+5,32+38,'CRC ERROR',7,0

	EVEN
BUFFER	CLR	$FFFF8240.W