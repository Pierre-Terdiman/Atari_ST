;Routine de d�compactage de 3D g�n�r�� - 20/03/93










; APPAREMMENT IL MANQUE --> UN <-- BIT NUL..











;VERSION BETA - UTILISER LE CODE AUTOMODIFIE POUR GAGNER DE LA
;MEMOIRE POUR LA VF

;TESTER LES BITS 2 PAR 2

;OPTIMISER EN UTILISANT LES REGISTRES LIBRES
;EX POUR LE ADD #16,D1 => GARDER 16 DANS UN Dx

;SI BUG => VERIFIER SI Y'A BIEN DES JSR NEXT_BIT PARTOUT

;A1 = pointeur sur les donn�es
;A2 = pointeur sur les flags pour les offsets
;A0 = pointeur sur le buffer destination
;D7 = comme pour le compactage
;D1 = offset courant pour la construction du code
;D6 = incr�ment de D1

	OPT	O+,W-

MAIN	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	LEA	DONNEES,A1
	LEA	OFFSETS,A2
	LEA	BUFCOD,A0
ANEW	MOVEQ	#7,D7
	MOVEQ	#6,D1
	REPT	8
	MOVE.L	(A1)+,(A0)+
	ENDR
BOUCLE	BTST	D7,(A2)
	BNE	BIT_ALLUM�
** 1ER BIT NUL **
	JSR	NEXT_BIT
	BTST	D7,(A2)
	BNE	BIT2_ALLUM�
** ICI = 2 BITS NULS SE SUIVAIENT **
;	JSR	NEXT_BIT
	ADD	#16,D1
	BRA	TST_FIN_ECRAN

** ICI = 1ER BIT NUL, 2EME BIT ALLUM� **
BIT2_ALLUM�	
	ADDQ	#2,D1	PLAN 1
	MOVE	#8+6,D6
RACCORD	MOVE	(A1)+,D0
	BEQ	CODE_DU_CLR_W
	CMPI	#$3140,D0
	BLT	C_EST_UNE_BETE_DONNEE
	CMPI	#$3147,D0
	BLE	CODE_DES_MOVE_DN
C_EST_UNE_BETE_DONNEE
	CMPI	#8+6,D6
	BEQ.S	C_EST_BIEN_UNE_DONNEE    VOIRE TEST MOVE L
	CMPI	#$2140,D0
	BLT	C_EST_BIEN_UNE_DONNEE
	CMPI	#$2147,D0
	BGT	C_EST_BIEN_UNE_DONNEE
_MOVE_L	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN
C_EST_BIEN_UNE_DONNEE
	MOVE	#$317C,(A0)+
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN
CODE_DES_MOVE_DN
	MOVE	D0,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN
CODE_DU_CLR_W	
	MOVE	#$4268,(A0)+
	MOVE	D1,(A0)+
	ADD	D6,D1
	BRA	TST_FIN_ECRAN

**BIT 1 ALLUM�
BIT_ALLUM�	JSR	NEXT_BIT
	BTST	D7,(A2)
	BNE	DEUX_BITS_ALLUM�S
** ICI = 1ER BIT ALLUM�, 2EME BIT NUL **
	MOVE	#16,D6
	BRA	RACCORD	OK???????????????

**************************** 2 BITS A 1 ********************************

DEUX_BITS_ALLUM�S
	TST.L	(A1)
	BEQ	_CLR_L
	TST	(A1)
	BEQ	_CLR_W
**TST MOVE_L A VIRER A LA FIN **
	CMPI	#$2140,(A1)
	BLT	NON
	CMPI	#$2147,(A1)
	BGT	NON
SI 	;ICI=MOVE.L BIZARRE
	MOVE	#$070,$FFFF8240.W
	BRA.S	SI
NON	CMPI	#$3140,(A1)
	BLT	NON2
	CMPI	#$3147,(A1)
	BGT	NON2
;MOVE 1ER BIT
	MOVE	(A1)+,(A0)+
	MOVE	D1,(A0)+
	ADDQ	#2,D1
	MOVE	#14,D6
	BRA	RACCORD
NON2	
	;DONNEE	CLR	=> MOVE.L
	;DONNEE	DONNEE	=> MOVE.L
	;DONNEE	MOVE	=> RACCORD

	CMPI	#$2140,2(A1)
	BLT	SUIT
	CMPI	#$2147,2(A1)
	BGT	SUIT
PB	
	MOVE	#$007,$FFFF8240.W
	BRA.S	PB
SUIT	CMPI	#$3140,2(A1)
	BLT	_MOVEL
	CMPI	#$3147,2(A1)
	BGT	_MOVEL
	MOVE	#$317C,(A0)+
	MOVE	(A1)+,(A0)+
	MOVE	D1,(A0)+
	ADDQ	#2,D1
	MOVE	#14,D6
	BRA	RACCORD

_MOVEL	MOVE	#$217C,(A0)+
	MOVE.L	(A1)+,(A0)+
	MOVE	D1,(A0)+
	ADD	#16,D1
	BRA	TST_FIN_ECRAN
	
_CLR_L	ADDQ	#4,A1
	MOVE	#$42A8,(A0)+
	MOVE	D1,(A0)+
	ADD	#16,D1
	BRA	TST_FIN_ECRAN
_CLR_W	ADDQ	#2,A1
	MOVE	#$4268,(A0)+
	MOVE	D1,(A0)+
	ADDQ	#2,D1
	MOVE	#14,D6
	BRA	RACCORD
NEXT_BIT
	SUBQ	#1,D7
	BGE	YY2
	MOVEQ	#7,D7
	ADDQ	#1,A2
YY2	RTS

TST_FIN_ECRAN
	CMPI	#31990,D1
	BEQ.S	FIN_ECRAN
	JSR	NEXT_BIT
	BRA	BOUCLE
FIN_ECRAN	MOVE	#$4E75,(A0)+
	CMPI.L	#$99999999,(A1)
	BEQ.S	TERMIN�
	BRA	ANEW
TERMIN�	NOP
	NOP
	BRA.S	TERMIN�
	DATA
FLAG	DC.L	0
DONNEES	INCBIN	COD1
	DC.L	$99999999
OFFSETS	INCBIN	COD2
	BSS
BUFCOD	DS.B	200000