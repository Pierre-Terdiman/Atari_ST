flock		equ	$43e

	PEA	0.W
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
*******	
	MOVE.L	#1,-(SP)	NB SECT A LIRE
	MOVE.L	#20,-(SP)	PISTE
	MOVE.L	#0,-(SP)	FACE
	MOVE.L	#0,-(SP)	DRIVE
	PEA	BUFFER
	JSR	TRACK_LOADING
	LEA	20(SP),SP

	PEA	0.W
	TRAP	#1

TRACK_LOADING
	move.l	4(a7),a0	Adresse du buffer
	move.l	8(a7),d0	Drive
	move.l	12(a7),d1	Face
	move.l	16(a7),d2	Piste
	move.l	20(a7),d3	Nombre de secteur

***************************************************************************
	movem.l	D4-D7/A1-A6,-(a7)	Sauver les autres regs

	moveq	#0,d4		Raz de d4
	moveq	#0,d5		Raz de d5

	lea	$FFFF8606.W,a6

	st	flock		bloquer la vbl disquette

	bsr	Set_drive	Selectionner Drive

	addq.w	#1,d3	Nombre de secteur + 1
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
	moveq	#1,d4		Lecture a partir du secteur 1.

***************************************************************************

*******
CHARGE:
*******
Set_DMA:move.l	a0,d5
	move.b	d5,$FFFF860D.W
	lsr.l	#8,d5
	move.b	d5,$FFFF860B.W
	lsr.l	#8,d5
	move.b	d5,$FFFF8609.W
	
***************************************************************************

************
Read_sector:
************
DMA_in:	move.w	#$90,(a6)
	move.w	#$190,(a6)
	move.w	#$90,d6
	moveq	#1,d7	On lit 1 secteur
	bsr.s	WD_write

	move.w	#$82,d6	Piste dans Track register
	move.w	d2,d7
	bsr.s	WD_write

	move.w	#$84,d6	Secteur dans Sector register
	move.w	d4,d7
	bsr.s	WD_write

	move.w	#$80,d6
	move.w	#%10000000,D7	Commande Read Sector
	bsr.s	WD_write
	bsr.s	Wait_done

	adda.l	#512,a0	Buffer + 512 octets
	addq.w	#1,d4	Secteur + 1
	cmp.w	d3,d4	A-t-on tout lu ?
	bne.s	CHARGE	Non, alors on continue...

	bsr.s	Test_DMA	

***************************************************************************
Motor_off:
	move.b	#7,d4	Eteindre la led du drive selectionne
	bsr.s	Select	et arreter le moteur

***************************************************************************
;	move.w	#$80,d6	< A enlever
;	move.w	#$d0,d7	< si l'on veut arreter
;	bsr.s	WD_write	< le moteur a la fin.

***************************************************************************

	sf	flock		Liberer la vbl disquette

	movem.l	(a7)+,D4-D7/A1-A6	Restaurer les registres

	rts			Fin de la routine...Retour a l'envoyeur !

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
	move.w	d7,$FFFF8604.W

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
	move.w	$FFFF8604.W,d7
	bsr.s	Attend

	lea	NUL(pc),a1	Si pas d'erreur
	bsr.s	Aff_DMA

DAM_:	btst	#5,d7		Data Address Mark
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

NUL:	DC.b 27,'Y',32+5,32+38,'   ',0
DAM:	DC.b 27,'Y',32+5,32+38,'DAM',7,0
RNF:	DC.b 27,'Y',32+5,32+38,'RNF',7,0
CRC:	DC.b 27,'Y',32+5,32+38,'CRC',7,0

	EVEN
BUFFER	DS.B	512