
        MOVE.W  #0,POIROT1
	MOVE.W  #0,POIROT2

	lea	TEXTE,a0	;debut du texte dans a0
	move.l	a0,MEM_LET	Position fonte (Table)


SCROLL:	

	MOVEA.L  ECRAN,A1
        MOVEA.L  ECRAN,A0
        LEA.L    160(A0),A0  

;INC     SET  0

	REPT    98      

	MOVEM.L	(A0),D0-D3
	MOVEM.L	D0-D3,(A1)
	
	;MOVEM.L	48(A0),D0-D7/A2-A6
	;MOVEM.L	D0-D7/A2-A6,208(A1)
	
	;MOVEM.L	96(A0),D0-D7/A2-A6
	;MOVEM.L	D0-D7/A2-A6,256(A1)
	
	;MOVEM.L	144(A0),D0-D3
	;MOVEM.L	D0-D3,304(A1)

	LEA.L   160(A1),A1  *=SUBA.L	#160,A1
	LEA.L   160(A0),A0   *=ADDA.L	#320,A0

;INC     SET   INC+160

	ENDR


       
	rts



AFF_FNT:	
	
	moveA.l	#FONT+34,a2	Pointe sur les fontes
	moveA.l	MEM_LET,a0
	adda.w	(a0),a2
	moveA.l	ECRAN,a1	(8 pixels de large)
	LEA.L   15680(A1),A1    *=adda.l	#152,a1
                                *=ADDA.L  #149*160,A1
	
	
        MOVE.W  POIROT1,D0
AJ      ADDA.L  #160,A2
        DBF  D0,AJ
        addq   #1,POIROT1
	MOVEM.L	(A2),D0-D3
	MOVEM.L	D0-D3,(A1)
        CMPI.W  #32,POIROT1
        BEQ     OTHER
        BRA.S   FIN_SCR

OTHER   MOVE.W  #0,POIROT1
    	addq.l	#2,a0		On passe … une autre lettre
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	On sauvegarde le pointeur
FIN_SCR RTS
******************************



