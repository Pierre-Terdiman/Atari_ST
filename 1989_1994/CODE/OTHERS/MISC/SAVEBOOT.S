debut
;***** message *********
 pea texte
 move.w #9,-(sp)
 trap #1
 addq.l #6,sp
;****introduire disquette,attente d'une touche****
 move.w #1,-(sp)
 trap #1
 addq.l #2,sp 
 cmp.b #"*",d0
 beq fin
lecture
;***lecture du bootsecteur****
 move.w #1,-(sp);nb
 clr.w -(sp)    ;face
 move.w #0,-(sp);piste
 move.w #1,-(sp);secteur
 clr.w -(sp)    ;lecteur
 clr.l -(sp)
 pea tampon
 move.w #8,-(sp)
 trap #14
 lea 20(a7),a7
;****affichage des infos du boot********
 pea infos
 move.w #9,-(sp)
 trap #1
 addq.l #6,sp
**********************************
;*******modif du boot*************
**********************************
 pea modifs
 move.w #9,-(sp)
 trap #1
 addq.l #6,sp
 move.w #1,-(sp)
 trap #1
 addq.L #2,sp
 cmp.b #"m",d0
 beq gomodif
 cmp.b #"M",d0
 beq gomodif
 cmp.b #"*",d0
 beq fin
 cmp.b #"e",d0
 beq ecriture
 cmp.b #"E",d0
 beq ecriture
 bra debut
gomodif
******* chargement du new boot*********
 lea tampon,a0
 move.w #$601c,(a0)
 lea 30(a0),a0 ;debut du nouveau bootmaison
 lea newboot,a1
 lea finboot,a2
 sub.l a1,a2
 move.L a2,d0
 subq.l #1,d0
charge:
 move.b (a1)+,(a0)+
 dbra d0,charge
****generation du new boot*********
 move.w #1,-(sp)
 move.w #-1,-(sp)
 move.l #-1,-(sp)
 pea tampon
 move.w #18,-(sp)
 trap #14
 lea 14(a7),a7
*****ecriture du new boot*********
 move.w #1,-(sp);nb
 clr.w -(sp)    ;face
 move.w #0,-(sp);piste
 move.w #1,-(sp);secteur
 clr.w -(sp)    ;lecteur
 clr.l -(sp)
 pea tampon
 move.w #9,-(sp)
 trap #14
 lea 20(a7),a7
 bra debut

******boot sous forme de fichier******
ecriture
 pea newdisk
 move.w #9,-(sp)
 trap #1
 addq.l #6,sp
 move.w #1,-(sp)
 trap #1
 addq.L #2,sp
***creation fichier+ open
 clr.w -(sp)
 pea filename
 move.w #$3c,-(sp)
 trap #1
 addq.l #8,a7
 move.w d0,-(sp);handle
***ecriture
 pea tampon
 move.l #512,-(sp)
 move.w d0,-(sp)
 move.w #$40,-(sp)
 trap #1
 lea 12(a7),a7
***close
 ;move.w (sp)+,d0
 ;move.w d0,-(sp)
 move.w #$3e,-(sp)
 trap #1
 addq.l #4,sp
 bra debut 
filename
 dc.b "boot.boo",0,0
fin
 clr.w -(sp)
 trap #1
 rts
retlig
 move.w         #$a,-(sp) *retour a la ligne
 move.w         #2,-(sp)
 trap           #1
 addq.l         #4,sp
 move.w         #$d,-(sp)
 move.w         #2,-(sp)
 trap           #1
 addq.l         #4,sp
 rts
newboot
**** new boot ****
DEBUT	LEA	NOM?(PC),A0		DEMANDE LE NOM
	BSR	PRINT
	LEA	BUFF(PC),A6
	BSR	READ_L

	LEA	START?(PC),A0	ADRESSE DE DEPART
	BSR	PRINT
	LEA	BUFF1(PC),A6
	BSR	READ_L
	BSR	TRANS
	LEA	START(PC),A0
	MOVE.L	D7,(A0)

	LEA	END?(PC),A0		ADRESSE DE FIN
	BSR	PRINT
	LEA	BUFF1(PC),A6
	BSR	READ_L
	BSR	TRANS
	LEA	END(PC),A0
	MOVE.L	D7,(A0)
	BRA	SUITE

BUFF	DC.B	12
	DC.B	0
	DS.B	12
	DC.B	0

BUFF1	DC.B	7
	DC.B	0
	DS.B	8

START	DS.L	1

END	DS.L	1

PRINT	PEA	(A0)
	MOVE	#9,-(SP)
	TRAP	#1
	ADDQ	#6,SP
	RTS

READ_L	PEA	(A6)
	MOVE	#10,-(SP)
	TRAP	#1
	ADDQ	#6,SP
	RTS
TRANS
	MOVEQ	#0,D7
	SUBQ	#1,D0
	ADDQ	#2,A6
BTRANS	MOVEQ	#0,D1
	MOVE.B	(A6)+,D1
	CMP.B	#"0",D1
	BLT.S	PAS0
	CMP.B	#"9",D1
	BGT.S	PAS9
	SUB.B	#"0",D1
	LSL.L	#4,D7
	OR	D1,D7
	BRA	NEXT_CH
PAS0
PAS9	CMP.B	#"A",D1
	BLT	DEBUT
	CMP.B	#"F",D1
	BGT	DEBUT
	SUB	#"A",D1
	ADD	#10,D1
	LSL.L	#4,D7
	OR	D1,D7
NEXT_CH	DBRA	D0,BTRANS
	RTS
NOM?	DC.B	27,"ENOM: ",0
START?	DC.B	13,10,"ADR DEPART: ",0
END?	DC.B	13,10,"ADR FIN: ",0
SU	DC.B	13,10,10,10,"PRESS SPACE TO EXIT",0
	EVEN
SUITE	

	LEA	SU(PC),A0
	BSR	PRINT

	MOVE.L	START(PC),A0
	MOVE.L	END(PC),A1
	LEA	$80000,A2
	MOVE.L	A0,(A2)+
	MOVE.L	A1,(A2)+
BR	MOVE.L	(A0)+,(A2)+
	CMP.L	A1,A0
	BLT.S	BR
	MOVE.L	#$80000,$42E.W
	MOVE.L	#$78000,$436.W
	MOVE.L	#$78000,$44E.W
WAIT	CMP.B	#$39,$FFFFFC02.W
	BNE.S	WAIT
	RTS
finboot
 even
texte
 dc.b 27,"E==========> BOOTBOOM <==========",$d,$a,$d,$a
 DC.B "* POUR FINIR",$D,$A
 dc.b "CODE BY KEN  (01/01/91 V1.1) ",$d,$a
 dc.b "  lecture du boot",$a,$d,0
newdisk
 dc.b "==>introduire une disquette <==",$a,$d,0
infos
 dc.b "==> lecture du boot ok",$a,$d,0
modifs
 dc.b "===> operations sur le boot <===",$a,$d
 dc.b "attention un boot peut en cacher",$a,$d
 dc.b "un autre...",$a,$d
 dc.b "* salut a bientot...........",$a,$d
 dc.b "e boot sous forme de fichier",$a,$d
 dc.b "m bootcode mis en action ...",$a,$d,0
 even
tampon
 ds.b 600

 