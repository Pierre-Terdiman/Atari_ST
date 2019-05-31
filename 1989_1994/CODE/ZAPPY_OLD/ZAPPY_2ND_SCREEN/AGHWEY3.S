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
	

	MOVE.L	#BUFFERL,D0		* ADRESSE DU BUFFER POUR ECRAN
	ANDI.L	#$FFFFFF00,D0		* SUPRIME LES 8 BITS "FAIBLE"
	ADD.L	#512,D0			* ET FAIT MULTIPLE DE 256
	MOVE.L	D0,ADRLOGO		* ON SAUVE L'ADRESSE CALCULEE
	
;	MOVE.L	#BUFFERF,D0		* ADRESSE DU BUFFER POUR ECRAN
;	ANDI.L	#$FFFFFF00,D0		* SUPRIME LES 8 BITS "FAIBLE"
;	ADD.L	#512,D0			* ET FAIT MULTIPLE DE 256
;	MOVE.L	D0,ADRFONT		* ON SAUVE L'ADRESSE CALCULEE
	
	MOVE.W	#4,-(SP)		* APPEL FONCTION GETREZ
	TRAP 	#14			* XBIOS...
	ADDQ.L	#2,SP			*
	MOVE.W	D0,RES			* SAUVE LA RESOLUTION
	
	MOVE.W	#2,-(SP)		* APPEL FONCTION PHYSBASE
	TRAP 	#14			* XBIOS
	ADDQ.L 	#2,SP			*
	MOVE.L	D0,ANC_ECR		* SAUVE L'ADRESSE ECRAN
	
	MOVE.W 	#0,-(SP)		* BASSE RESOLUTION
	MOVE.L	#-1,-(SP)		* PHYSBASE A ECRAN
	MOVE.L	#-1,-(SP)		* LOGBASE A ECRAN
	MOVE.W 	#5,-(SP)		* FONCTION SETSCREEN
	TRAP 	#14			* DU XBIOS
	LEA.L 	12(SP),SP		*

	LEA.L	COUL_0,A0		* ADRESSE PALETTE SHIFTER
	MOVEM.L	(A0),D0-D7		* RECUPERE LES 16 REGISTRES
	LEA.L	ANC_PAL,A0		* ADRESSE DE SAUVEGARDE
	MOVEM.L	D0-D7,(A0)		* SAUVE LES 16 REGISTRES
	
        
;        move.l ADRFONT,a3
;        lea  FONT+34,a5
;        JSR  decomp
        move.l ADRLOGO,a3
        lea  LOGO+34,a5
        JSR  decomp
	
;	MOVE.L #MES_F,MES_PNT		* INIT POINTEUR MESSAGE
        ;MOVE.L #MES_F2,MES_PNT2

        MOVE.W  #0,POIROT1
	MOVE.W  #0,POIROT2
        MOVE.W  #0,POIROT3

	MOVEQ	#1,D0			* NETOIE D0
	BSR	MUSIC		* INITIALISE LA MUSIQUE
;	MOVE.W  #1,MUS
	
	bsr	SET_SCR		;preparation des ecrans
        MOVEA.L  SCREEN2,A1
        MOVEA.L  ADRLOGO,A0
        MOVE.L  #99,D0
LOG1    BSR    AFF_LOGO
        DBF D0,LOG1

        MOVEA.L  SCREEN1,A1
        MOVEA.L  ADRLOGO,A0
        MOVE.L  #99,D0
LOG2    BSR    AFF_LOGO
        DBF  D0,LOG2

	MOVE.L	$70,ANC_VBL		* SAUVE L'ANCIEN VECTEUR VBL
	MOVE.L	#VBL_IR,$70		* ET PLACE LE MIEN...
	MOVE.L	$120,ANC_TB		* SAUVE ANCIEN VECTEUR TIMER B
	MOVE.L	#TB0_IR,$120		* ET PLACE LE MIEN...
	
	DC.W	$A00A			* CACHE LA SOURIS (LINE A)
	MOVE.B	#$12,ACIA		* INIT CLAV
	
	CLR.B	TBCR			* ARRET DU TIMER B (PLUS PRUDENT)
	BSET	#0,IERA			* AUTORISE LES INTERUPTIONS
	BSET	#0,IMRA			* SUR LE TIMER B

	bsr	SET_SCR		;preparation des ecrans
	lea	TEXTE,a0	;debut du texte dans a0
        LEA     TEXTE2,A1
	move.l	a0,MEM_LET	Position fonte (Table)
        MOVE.L  A1,MEM_LET2
	move.w	#0,PART_AFF	(2 Parties)



BOUCLE:	
	MOVE.B	VSYNC,D0		* ATTEND UNE SYNCRO VERTICALE
WAIT	CMP.B	VSYNC,D0		* POUR LE TESTS DES TOUCHES
	BEQ.S	WAIT
	CMP.B	#$39,ACIA		* TESTE ESPACE (CODE SCAN)
	BNE.S	BOUCLE			* SI ESPACE, ON SORT DE L'INTRO
***********************************************************************

FIN:	
        MOVE.B  #2,SYNCRO
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
	


decomp:
 move.l #100,d4       * $C7
 move.l #6,a0
 moveq #4,d6
 moveq #$28,d7
  
dec9:
 clr.b d1
 movea.l a3,a4

dec8:
 move.l a4,-(sp)
 clr.b d3

dec7:
 move.b (a5)+,d0
 tst.b d0
 bmi.s dec1
 addq.b #1,d0

dec3:
 move.b (a5)+,(a4)+
 addq.b #1,d3
 move.l a4,d5
 btst #0,d5
 bne.s dec2
 adda.l a0,a4

dec2:
 subq.b #1,d0
 bne.s dec3
 bra.s dec4

dec1:
 neg.b d0
 addq.b #1,d0
 move.b (a5)+,d2

dec6:
 move.b d2,(a4)+
 addq.b #1,d3
 move.l a4,d5
 btst #0,d5
 bne.s dec5
 adda.l a0,a4

dec5:
 subq.b #1,d0
 bne.s dec6

dec4:
 cmp.b d7,d3
 bne.s dec7
 move.l (sp)+,a4
 addq.l #2,a4
 addq.b #1,d1
 cmp.b d6,d1
 bne.s dec8
 adda.l #$a0,a3
 dbra d4,dec9
 rts

AFF_LOGO MOVE.L  D0,-(SP)
	MOVEM.L	(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,160(A1)
	MOVEM.L	48(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,208(A1)
	MOVEM.L	96(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,256(A1)
	MOVEM.L	144(A0),D0-D3
	MOVEM.L	D0-D3,304(A1)

	LEA.L   160(A1),A1  *=SUBA.L	#160,A1
	LEA.L   160(A0),A0   *=ADDA.L	#320,A0

        MOVE.L  (SP)+,D0
        RTS

VBL_IR	
        ;MOVE.W  #$777,$FF8240
;	MOVEM.L	D0,-(SP)		* SAUVE LE REGISTRE
	CLR.B	TBCR			* ARRET DU TIMER B
	MOVE.B	#96,TBDR		* INTERUPTION SUR LIGNE 117
	MOVE.B	#8,TBCR			* TIMER C EN EVENT COUNT MODE
	LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	MOVEA.L #LOGO+2,A5              * ADRESSE COULEURS
     REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET LA NOUVELLE PALETTE EN PLACE
     ENDR
        ADDQ   #1,POIROT2
        CMPI.W  #200,POIROT2 
        BLT  NOTOK

        CMPI.B   #$42,ACIA
        BEQ   BLANC
        BRA.S  NOIR
BLANC   MOVE.W   #$777,$FF8240

NOIR 
	
        ADDQ   #1,POIROT1
        CMPI.W  #9,POIROT1
        BEQ.S  AG
        BRA.S  SUITE0
AG      MOVE.W  #1,POIROT1
SUITE0  CMPI.W  #1,POIROT1
        BEQ.S  PART1
        BRA.S  SUITE1
PART1   MOVEA.L #PART12+34,A0
SUITE1  CMPI.W  #2,POIROT1
        BEQ.S  PART2
        BRA.S  SUITE2
PART2   MOVEA.L #PART12+34,A0
        LEA.L  16320(A0),A0
SUITE2  CMPI.W  #3,POIROT1
        BEQ.S  PART3
        BRA.S  SUITE3
PART3   MOVEA.L #PART34+34,A0
SUITE3  CMPI.W  #4,POIROT1
        BEQ.S  PART4
        BRA.S  SUITE4
PART4   MOVEA.L #PART34+34,A0
        LEA.L  16320(A0),A0
SUITE4  CMPI.W  #5,POIROT1
        BEQ.S  PART5
        BRA.S  SUITE5
PART5   MOVEA.L #PART56+34,A0
SUITE5  CMPI.W  #6,POIROT1
        BEQ.S  PART6
        BRA.S  SUITE6
PART6   MOVEA.L #PART56+34,A0
        LEA.L  16320(A0),A0
SUITE6  CMPI.W  #7,POIROT1
        BEQ.S  PART7
        BRA.S  SUITE7
PART7   MOVEA.L #PART78+34,A0
SUITE7  CMPI.W  #8,POIROT1
        BEQ.S  PART8
        BRA.S  SUITE8
PART8   MOVEA.L #PART78+34,A0
        LEA.L  16320(A0),A0
SUITE8
        MOVEA.L  SCREEN2,A1
        LEA.L    20800(A1),A1  

INC     SET  0

	REPT    98      

	MOVEM.L	INC(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,INC+160(A1)
	
	MOVEM.L	INC+48(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,INC+208(A1)
	
	MOVEM.L	INC+96(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,INC+256(A1)
	
	MOVEM.L	INC+144(A0),D0-D3
	MOVEM.L	D0-D3,INC+304(A1)

;	LEA.L   160(A1),A1  *=SUBA.L	#160,A1
;	LEA.L   160(A0),A0   *=ADDA.L	#320,A0

INC     SET   INC+160

	ENDR
NOTOK   bsr	SCROLL
	bsr	AFF_FNT	
        CMPI.W  #200,POIROT2
        BLT   NOTOK2     
        BSR     MUSIC+8
        BSR     SCROLLV
        BSR     AFF_FNT2
NOTOK2  bsr	SWAP_SCR
;        MOVEM.L	(SP)+,D0		* RESTAURE LE REGISTRE
	NOT.B	VSYNC			* BASCULE POUR SYNCRO
        MOVE.W  #$0,$FF8240
	RTE				* FIN DE L'INTERUPTION VBL



;mdk0	move.l	#buffsp1,a6      adresse du buffer
;        move.l  ADRFONT,A5
;        MOVE.L  SCREEN2,A0
;        MOVEQ	#0,D0			* NETOIE D0
;	MOVE.L	MES_PNT2,A2		* POINTEUR TEXTE DANS D0
;	MOVE.B	(A2)+,D0		* MET LE CARACTERE SUIVANT DANS D0
;	CMPI.B	#-1,D0			* SI -1, ON RECOMMENCE LE TEXTE
;	BEQ	 AGAIN3			*
;        MOVE.L	A2,MES_PNT2		* SAUVE LE POINTEUR
;        BRA.S   CONT211
;AGAIN3	MOVE.L	#MES_F2,MES_PNT2		* REINITIALISE LE POINTEUR TEXTE

;CONT211  LSL    #4,D0
        
;        adda.l  D0,a0
;affmdk  moveq	#22-1,d0
;        move.l  a0,(a6)+
;affmd1	move.l  (a5)+,d1
;	move.l  (a5)+,d2
;	move.l  (a0),d3
;	move.l  4(a0),d4
;	move.l  d3,(a6)+
;	move.l  d4,(a6)+
	
;	move.l  d1,d7
;	or.l    d2,d7
;	move.l  d7,d6
;	swap    d6
;	or.l    d6,d7
;	not.l   d7         masque obtenu
	
;	and.l   d7,d3
;	and.l   d7,d4
;	or.l    d1,d3
;	or.l    d2,d4
;	move.l  d3,(a0)+ 	        
;        move.l  d4,(a0)+

;	move.l  (a5)+,d1
;	move.l  (a5)+,d2
;	move.l  (a0),d3
;	move.l  4(a0),d4
;	move.l  d3,(a6)+
;	move.l  d4,(a6)+
	
;	move.l  d1,d7
;	or.l    d2,d7
;	move.l  d7,d6
;	swap    d6
;	or.l    d6,d7
;	not.l   d7         masque obtenu
	
;	and.l   d7,d3
;	and.l   d7,d4
;	or.l    d1,d3
;	or.l    d2,d4
;	move.l  d3,(a0)+ 	        
;        move.l  d4,(a0)+
;        lea	160-16(a5),a5
;        lea	160-16(a0),a0
;        dbra	d0,affmd1
;        rts
        
;buff_coord dc.b 0,0,0,0
 
;buffsp1 ds.b 22*16+4        buffer de sauvegarde des 3 sprites MDK
;	ds.b 22*16+4
;	ds.b 22*16+4

TB0_IR	
        LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	MOVEA.L #FONT+2,A5              * ADRESSE COULEURS
     REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET LA NOUVELLE PALETTE EN PLACE
     ENDR
        
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#34,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TB1_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

TB1_IR	
        LEA.L	COUL_0,A6		* ADRESSE PALETTE SHIFTER DANS A6
	MOVEA.L #PART12+2,A5              * ADRESSE COULEURS
     REPT 8
     	MOVE.L	(A5)+,(A6)+		* MET LA NOUVELLE PALETTE EN PLACE
     ENDR
        
	CLR.B	TBCR			* ARRET DU TIMER
	MOVE.B	#69,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	MOVE.L	#TBF_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

;TB1_IR	
;        MOVE  #$001,COUL_0
;	CLR.B	TBCR			* ARRET DU TIMER
;	MOVE.B	#16,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
;	MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
;	MOVE.L	#TBF_IR,$120		* NOUVELLE ROUTINE TIMER B
;	BCLR	#0,ISRA			* LIBERE L'INTERUPTION
;	RTE				* FIN DE L'INTERUPTION (RETOUR)






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
	MOVE.L	#TB0_IR,$120		* NOUVELLE ROUTINE TIMER B
	BCLR	#0,ISRA			* INTERUPTION TRAITEE
	RTE				* RETOUR
**********************************************************************
	
**********************************************************************

**** Procedures ****
SCROLLV:	
        MOVEA.L  SCREEN2,A2
	MOVEA.L  SCREEN2,A1
        MOVEA.L  SCREEN2,A0
        LEA.L    320(A0),A0  

INC     SET  0

	REPT    90      

	MOVEM.L	INC(A0),D0-D3
	MOVEM.L	D0-D3,INC(A1)
	MOVEM.L D0-D3,INC+144(A2)

	;MOVEM.L	48(A0),D0-D7/A2-A6
	;MOVEM.L	D0-D7/A2-A6,208(A1)
	
	;MOVEM.L	96(A0),D0-D7/A2-A6
	;MOVEM.L	D0-D7/A2-A6,256(A1)
	
	;MOVEM.L	144(A0),D0-D3
	;MOVEM.L	D0-D3,304(A1)

;	LEA.L   160(A1),A1  *=SUBA.L	#160,A1
;	LEA.L   160(A0),A0   *=ADDA.L	#320,A0

INC     SET   INC+160

	ENDR


       
	rts



AFF_FNT2:	
	moveA.l	#FONT2+34,a2
	moveA.l	MEM_LET2,a0
	adda.w	(a0),a2
	moveA.l	SCREEN2,a1
	LEA.L   14400(A1),A1
        MOVEA.L SCREEN1,A3
        LEA.L   14400(A3),A3
        MOVE.W  POIROT3,D0
AJ      LEA.L  160(A2),A2
        DBF  D0,AJ
        addq   #1,POIROT3
	MOVEM.L	(A2),D0-D3
	MOVEM.L	D0-D3,(A1)
        MOVEM.L D0-D3,160(A3)
        CMPI.W  #27,POIROT3
        BEQ     OTHER2
        BRA.S   FIN_SCR2

OTHER2   MOVE.W  #0,POIROT3
    	addq.l	#2,a0		On passe … une autre lettre
	cmp.w	#$ffff,(a0)
	bne	GO_LET2
	lea	TEXTE2,a0
GO_LET2:	move.l	a0,MEM_LET2	On sauvegarde le pointeur
FIN_SCR2 
         RTS
******************************






SET_SCR:	move.l	#BUFFERSCR,d0	;adresse buffer dans d0
	and.l	#$ffffff00,d0		;adresse multiple de 256
	move.l	d0,SCREEN1		;adresse obtenue dans SCREEN1
        move.l	#BUFFERSCR2,d0	;adresse buffer dans d0
	and.l	#$ffffff00,d0		;adresse multiple de 256
	move.l	d0,SCREEN2		;adresse obtenue dans SCREEN1
;	add.l	#32000,d0		;32000 octets plus loin...
;	move.l	d0,SCREEN2		;...SCREEN2
	rts				;retour

SWAP_SCR:	move.l	SCREEN1,d0	;adresse Ecran courant dans d0
	move.l	SCREEN2,SCREEN1		;ecran travail sur ecran courant
	move.l	d0,SCREEN2		;ecran courant sur ecran travail
	;l… en fait il a permut‚ les deux ecrans travail et courant	
	;il a mis l'un sur l'autre et vice-versa,c'est le SWAP-SCREEN
	lsr.l	#8,d0		8*2=16
	moveA.l	#$ffff8201,a0
	movep	d0,(a0)
	rts
SCROLL:	
        moveA.l	SCREEN1,a0	Ecran de travail
        LEA.L   15520(A0),A0    *=ADDA.L  #160*149,A0
	moveA.l	SCREEN1,a1
	LEA.L   15528(A1),A1        *=adda.l  #8,a1
	                            *=ADDA.L  #149*160,A1

	rept 	33*20		Hauteur du scroll*20
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	endr
      
	rts



AFF_FNT:	cmp.w	#1,PART_AFF
	blo	PART1S
	beq	PART2S
	cmp.w	#3,PART_AFF
	blo	PART3S
	beq	PART4S
	
PART1S:	moveA.l	#FONT+34,a2	Pointe sur les fontes
	moveA.l	MEM_LET,a0
	adda.w	(a0),a2
	moveA.l	SCREEN1,a1	(8 pixels de large)
	LEA.L   15672(A1),A1    *=adda.l	#152,a1
                                *=ADDA.L  #149*160,A1
INC	set	0
	rept	33
	move.b	INC+9(a2),INC(a1)
	move.b	INC+11(a2),INC+2(a1)
	move.b	INC+13(a2),INC+4(a1)
        move.b  INC+15(a2),INC+6(a1)  * ok je pense
INC	set	INC+160
	endr
	
	addq.l	#2,a0		On passe … une autre lettre
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	On sauvegarde le pointeur
	
	moveA.l	#FONT+34,a2
	adda.w	(a0),a2
INC	set 	0
	rept 	33
	move.b	INC+0(a2),INC+1(a1)
	move.b	INC+2(a2),INC+3(a1)
	move.b	INC+4(a2),INC+5(a1)  * ok
        move.b  INC+6(a2),INC+7(a1)
        
INC	set	INC+160
	endr
	move.w	#1,PART_AFF
	bra	FIN_SCRO	
	
PART2S:	moveA.l	#FONT+34,a2
	moveA.l	MEM_LET,a0
	adda.w	(a0),a2
	moveA.l	SCREEN1,a1
	LEA.L   15672(A1),A1    *=adda.l	#152,a1
                                *=ADDA.L  #149*160,A1
INC	set	0
	rept	33
	move.l	INC(a2),INC(a1)
	move.w	INC+4(a2),INC+4(a1)
        move.w  INC+6(a2),INC+6(a1)      * ok
INC	set	INC+160
	endr
	move.w	#2,PART_AFF
	bra	FIN_SCRO

PART3S:	moveA.l	#FONT+34,a2
	moveA.l	MEM_LET,a0
	adda.w	(a0),a2
	moveA.l	SCREEN1,a1
	LEA.L   15672(A1),A1   *=adda.l	#152,a1
                               *=ADDA.L  #149*160,A1
INC	set	0
	rept	33
	move.b	INC+1(a2),INC(a1)	
	move.b	INC+3(a2),INC+2(a1)	
	move.b	INC+5(a2),INC+4(a1)
        move.b  INC+7(a2),INC+6(a1)
	move.b	INC+8(a2),INC+1(a1)	
	move.b	INC+10(a2),INC+3(a1)	
	move.b	INC+12(a2),INC+5(a1)	
        move.b  INC+14(a2),INC+7(a1)      * ok ?
INC	set	INC+160
	endr
	move.w	#3,PART_AFF
	bra	FIN_SCRO

PART4S:	moveA.l	#FONT+34,a2
	moveA.l	MEM_LET,a0
	adda.w	(a0),a2
	moveA.l	SCREEN1,a1
	LEA.L   15672(A1),A1    *=adda.l	#152,a1
                                *=ADDA.L  #149*160,A1
INC	set	0
	rept	33
	move.l	INC+8(a2),INC(a1)
	move.w	INC+12(a2),INC+4(a1)
        move.w  INC+14(a2),INC+6(a1)  * ok?
INC	set	INC+160
	endr
	move.w	#0,PART_AFF
	bra	FIN_SCRO

FIN_SCRO	  
;        LEA.L    31680(A1),A1      *=ADDA.L   #160*198,A1   
;        MOVEA.L  SCREEN2,A0
;        LEA.L    23840(A0),A0      *=ADDA.L   #149*160,A0

;	REPT	16      
;	MOVEM.L	(A0),D0-D7/A2-A6
;	MOVEM.L	D0-D7/A2-A6,160(A1)
	
;	MOVEM.L	48(A0),D0-D7/A2-A6
;	MOVEM.L	D0-D7/A2-A6,208(A1)
	
;	MOVEM.L	96(A0),D0-D7/A2-A6
;	MOVEM.L	D0-D7/A2-A6,256(A1)
	
;	MOVEM.L	144(A0),D0-D3
;	MOVEM.L	D0-D3,304(A1)


;	LEA.L   -160(A1),A1  *=SUBA.L	#160,A1
;	LEA.L   320(A0),A0   *=ADDA.L	#320,A0

;	ENDR
        RTS

******************************



	
**** Variables ***

	section   data
MUSIC:  INCBIN  GEAR.MUS
TEXTE:	INCBIN	SPEED.TXT
TEXTE2: INCBIN  COSMOS.TXT
FONT:	INCBIN	FONTES1.PI1
FONT2:  INCBIN  COSMOS.PI1
LOGO:   INCBIN  LOGOGEN4.PC1

PART12  INCBIN  PART12.PI1
        EVEN
PART34  INCBIN  PART34.PI1
        EVEN
PART56  INCBIN  PART56.PI1
        EVEN
PART78  INCBIN  PART78.PI1
        EVEN




;MES_F	
;        DC.B   0,1,2,3,4,5,6,7,8,9
;        DC.B   9,8,7,6,5,4,3,2,1,0
;	DC.B  -1
;	EVEN

;MES_F2  DC.B   0,10,20,30,40,30,20,10
;        DC.B   -1
;        EVEN


CHUT_DA	DC.B	7,$FF,6,0,8,0,9,0,$A,0

 	SECTION BSS
 	EVEN
ADRLOGO DS.L    1
;MES_PNT DS.L    1
;MES_PNT2 DS.L    1
;BIDON   DS.L    1
F_PILE	DS.L 	128			* FIN DE LA PILE
D_PILE	DS.L 	1			* DEBUT DE LA PILE
SAUVE	DS.L	1			* SAUVE LA PILE UTILISATEUR
ANC_VBL DS.L	1			* SAUVE LE VECTEUR VBL
ANC_TB	DS.L	1			* SAUVE LE VECTEUR TIMER B
ANC_ECR	DS.L	1			* SAUVE L'ADRESSE DE L'ECRAN
POIROT1	DS.W	1			* COMPTEURS POUR FAIRE DEMARRER
POIROT2	DS.W	1			* LES ANIMATIONS, LES UNES
POIROT3	DS.W	1			* APRES LES AUTRES
;POIROT4	DS.W	1			*
RES	DS.W	1			* SAUVE LA RESOLUTION
ANC_PAL	DS.W	16			* SAUVE LA PALETTE
MFP1	DS.B	1			* SAUVE LES REGISTRES DU MFP
MFP2	DS.B	1			*
MFP3	DS.B	1			*
MFP4	DS.B	1			*
MFP5	DS.B	1			*
MFP6	DS.B	1			*
VSYNC	DS.B	1			* POUR LA SYNCRO VERTICALE
BUFFERL DS.B    16000
	ds.b	256		;tranquille pour les merdes
BUFFERSCR:ds.b	45000		;buffer de 64000 octets pour les deux ecrans
	ds.b	256	
	ds.b	256		;tranquille pour les merdes
BUFFERSCR2:ds.b	45000		;buffer de 64000 octets pour les deux ecrans
	ds.b	256	
SCREEN1:	ds.l	1	;ecran	courant
SCREEN2:	ds.l	1	;ecran	travail
MEM_LET:	ds.l	1
MEM_LET2:       DS.L    1
PART_AFF:	ds.l    1
