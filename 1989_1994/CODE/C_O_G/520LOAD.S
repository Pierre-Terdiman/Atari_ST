;Loader Choice Of Gods pour 520 ST.
;Assembler avec 15K.
;J'explique: la Choice Of Gods est une d‚mo qui, … l'origine, tourne
;sur tout modŠle de ST. Un demi-m‚ga suffit.
;Mais il y a un bug dans le boot ( vous seriez aimable de me dire lequel
;en bal ZAPPY sur Rtel, car malgr‚ tous mes efforts, j'ai pas trouv‚ ce
;que c'‚tait! - j'ai aucun 520 pour tester... ) qui fait que tout plante
;si on n'a pas un m‚ga. Ce petit loader DEVRAIT marcher sur 520. J'en sais
;rien, j'ai pas de quoi tester...

;Cependant:
;* AprŠs l'intro, tout plante. C'est normal, le loader a ‚t‚ ‚cras‚...
;* Devil's Balls plante sur 520. A cause de ce loader, qui, situ‚ en
;  fin de m‚moire, se fait ‚craser en plein d‚compactage => fatal...
;* Ambition plante. Seule la 1Šre partie marche. C'est dommage, car
;  le reste ‚tait pas mal! ( Surtout la partie 4 )
;* Tout le reste est visible sur un 520. Et meme, la musique est r‚tablie
;  sur STE dans le dernier ‚cran, alors qu'elle ne se jouait pas
;  auparavant. ALLEZ SAVOIR POURQUOI!!
;* AprŠs avoir charg‚ et ex‚cut‚ un ‚cran, ce loader chargera directement
;  le suivant. Jusqu'… ce qu'il tombe sur un ‚cran qui fait tout planter.
;* Je sais, c'est fastidieux. Mais c'est mieux que rien. Cette d‚mo est
;  vraiment trop vieille pour que je me donne + de mal pour elle. 
;  Attendez plutot notre prochaine d‚mo qui sera INFINIMENT mieux!!!

;Bon courage...

MODE:	EQU	1
PIC_ALGO:	EQU	0
DEC_SPACE:	EQU	$0000
RESTORE_SPACE:	EQU	0

ADR_LOAD=$1000
;ADR_FIN=$7FFFC

	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	MOVE	#1,-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	PEA	MESSAGE(PC)
	MOVE	#9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

;	MOVE.L	#1,NUM_DEM
	MOVE.L	#CH,$70.W
JH	;nop
	BRA.S	JH
	
	JMP	SUITE

CH	;SF	$FFFF8240.W
	MOVEQ	#0,D0
	CMPI.B	#$1,$FFFFFC02.W
	BLT.S	NO
	CMPI.B	#15,$FFFFFC02.W
	BGT.S	NO
	MOVE.B	$FFFFFC02.W,D0
;	MOVE.L	D0,$E0000
	SUBQ.L	#1,D0
	MOVE.L	D0,NUM_DEM
	MOVE	#$4E71,JH
	MOVE.L	#NO,$70.W
;	MOVE	$FFFFFC02.W,$FFFF8240.W
	
NO	RTE
;dcbb "                                        "
MESSAGE
 DC.B "CHOICE OF GODS LOADER FOR 520 ST.",$A,$D
 dc.b "Appuyez sur une des touches suivantes:",$a,$d
 dc.b "ESC.Intro",$a,$d
 dc.b "1.Around the Earth",$a,$d
 dc.b "2.Inverted Landscapes ",$a,$d
 dc.b "3.Elric Fullsprites",$a,$d
 dc.b "4.My Socks are Atomic Flame Throwers",$a,$d
 dc.b "5.The Face in the Abyss",$a,$d
 dc.b "6.Flexi-Killer-Scroller",$a,$d
 dc.b "7.Devil's Balls",$a,$d
 dc.b "8.Light Seeds",$a,$d
 dc.b "9.Attack of Indigestion",$a,$d
 dc.b "0.Ambition",$a,$d
 dc.b ").Japanese way of life",$a,$d
 dc.b "-.Hidden 1 ( 3DF )",$a,$d
 dc.b "`.Japanese Journey ( Hidden 2 )",$a,$d
 dc.b "BACK.A coder is not a guy you can trust",$a,$d,0,0

;*Explications sommaires: je me contente de mettre ce loader en
;*$7E0C0, ce qui bouffe 8000 octets, et ces 8000 octets en moins
;*suffisent … faire planter certains ‚crans...
;
;*Puis je saute en $7E0C0, et le loader charge l'‚cran choisi … partir
;*de $1000, le d‚compacte et l'ex‚cute. A la fin de chaque ‚cran inclus
;*sur le disk est effectu‚ un JMP $500.W. Je mets donc en $500 une bete
;*instruction qui va incr‚menter le num‚ro de la d‚mo choisie, et re-
;*-jumper en $7E0C0.
;
;*Il n'y aurait aucun probleme si certains ‚crans ne prenaient pas plus
;*de 519000 octets pour s'ex‚cuter... faites le calcul:
;*$1000+519000=$7FB58... il reste donc 1911 octets libres dans un 520.
;*Et comme j'ai r‚serv‚ les 8000 derniers... POUM!

SUITE:

	LEA	$500.W,A0
	MOVE	#$52B9,(A0)+
	MOVE.L	#$7E31A,(A0)+
	MOVE	#$4EF9,(A0)+
	MOVE.L	#$7E0C0,(A0)
;	MOVE.L	$42A.W,MOD_ADR

	LEA	PRG,A0
	LEA	$7E0C0,A1
	MOVE	#(7999/4)-1,D0
COPPRG	MOVE.L	(A0)+,(A1)+
	DBF	D0,COPPRG
	JMP	$7E0C0	

;7e0c0
************
	OPT	O+,A+,P+
PRG
	LEA	NEWPILE,A7
	MOVE	#$2700,SR
	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.B	#2,$FFFF820A.W
	CLR.B	$FFFF8260.W
	move.l	#$31415926,$426.W
	LEA	PRG(PC),A0
	MOVE.L	A0,$42A.W

	MOVE.B	#$1E,$FFFFFA07.W
	MOVE.B	#$64,$FFFFFA09.W
	MOVE.B	#$00,$FFFFFA0F.W
	MOVE.B	#$1E,$FFFFFA13.W
	MOVE.B	#$00,$FFFFFA1B.W
	MOVE.B	#$47,$FFFFFA21.W
	MOVE.B	#$64,$FFFFFA15.W
	MOVE.B	#$48,$FFFFFA17.W
	MOVE.B	#$00,$FFFFFA19.W
	MOVE.B	#$FF,$FFFFFA1F.W

	move.L	#$707FFFF,$fFFf8800.W
	move	#$2420,$ffff8604.w
	move.b	#$00,$ffff8609.w
	move.b	#$7b,$ffff860b.w
	move.b	#$c4,$ffff860d.w
	MOVE.B	#$3,$FFFFFC04.W
	MOVE.B	#$95,$FFFFFC04.W
	MOVE.B	#$3,$FFFFFC00.W
	MOVE.B	#$96,$FFFFFC00.W
	MOVE	#$C8,D0
.E	NOP
	DBF	D0,.E
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.B	#$12,$FFFFFC02.W

	LEA	PRG(PC),A0
	MOVE.L	A0,$008.W
	MOVE.L	A0,$00C.W
	MOVE.L	A0,$010.W
	MOVE.L	A0,$014.W
	MOVE.L	A0,$018.W
	MOVE.L	A0,$01C.W
	MOVE.L	A0,$020.W
	
	LEA	RTE2(PC),A0
	MOVE.L	A0,$68.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$70.W
	BRA.S	CONTINUE_GAIEMENT
RTE2	RTE
;FIN	MOVE.L	4.W,A0
;	JMP	(A0)
CONTINUE_GAIEMENT
	OPT	O-,A-,P-
	LEA	ADR_LOAD,A0
	OPT	O+,A+,P+
	MOVE.L	#$7E0B8,D0
EFF	CLR.L	(A0)+
	CMP.L	D0,A0
	BLE.S	EFF

	LEA	AJOUT(PC),A0
	CLR.L	(A0)

	move.l	#$763BC,d0
	CLR.B	D0
	LEA	SCREEN1(PC),A0
	move.l	d0,(A0)

	BSR	EFFACE_TOUT
	move.l	SCREEN1,d0	
	lsr.l	#8,d0		
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
	
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

LOAD_MENU	BSR.S	INIT_ALL
	BRA	GO_AHEAD
INIT_ALL	MOVE	#$2700,SR
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	SUBA.L	A0,A0
	SUBA.L	A1,A1
	SUBA.L	A2,A2
	SUBA.L	A3,A3
	SUBA.L	A4,A4
	SUBA.L	A5,A5
	SUBA.L	A6,A6
	MOVEM.L	D0-D7,$FFFF8240.W
	MOVE.B	#2,$FFFF820A.W
	CLR.B	$FFFF8260.W
;	CLR.L	$426.W
;	CLR.L	$42A.W
	MOVE.B	#$1E,$FFFFFA07.W
	MOVE.B	#$64,$FFFFFA09.W
	MOVE.B	#$00,$FFFFFA0F.W
	MOVE.B	#$1E,$FFFFFA13.W
	MOVE.B	#$00,$FFFFFA1B.W
	MOVE.B	#$47,$FFFFFA21.W
	MOVE.B	#$64,$FFFFFA15.W
	MOVE.B	#$48,$FFFFFA17.W
	MOVE.B	#$00,$FFFFFA19.W
	MOVE.B	#$FF,$FFFFFA1F.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W

	MOVE.B	#$12,$FFFFFC02.W

	LEA	PRG(PC),A0
	MOVE.L	A0,$008.W
	MOVE.L	A0,$00C.W
	MOVE.L	A0,$010.W
	MOVE.L	A0,$014.W
	MOVE.L	A0,$018.W
	MOVE.L	A0,$01C.W
	MOVE.L	A0,$020.W
	
	LEA	RTE(PC),A0
	MOVE.L	A0,$68.W
	MOVE.L	A0,$134.W
	MOVE.L	A0,$120.W
	MOVE.L	A0,$70.W
	RTS
RTE	RTE
WRONG_DISK
	BSR	EFFACE_TOUT
	ST	$FFFF8242.W
	LEA	WRONGMES,A1
	MOVE.L	SCREEN1,A2
	LEA	160*100(A2),A2
	BSR	AF_LIGNE
	BSR	AF_LIGNE
r	cmpi.b	#$39,$fffffc02.w
	bne.s	r
e	cmpi.b	#$39,$fffffc02.w
	beq.s	e
	CLR	$FFFF8240.W
GO_AHEAD
	CLR	D0	FACE
	CLR	D1	PISTE
	MOVEQ	#0,D2
	MOVE	#1,D2	SECT
	BSR	TRACK_LOADING
****
	LEA	DATAS_FILES(PC),A0
	OPT	O-,P-,A-
NUM_DEM	EQU	*+2
	MOVE.L	#0,D3
	OPT	O+,P+,A+
	LSL	#3,D3
	ADD.L	D3,A0
	MOVE	(A0)+,D7	DISK1=0  2=1
	OPT	O-,A-,P-
	LEA	ADR_LOAD,A1
	OPT	O+,A+,P+
	CMPI.L	#'DISK',(A1)
	BNE.S	DISK_1
DISK_2	TST	D7
	BEQ.S	WRONG_DISK
	BRA.S	OKAY
DISK_1	TST	D7
	BNE.S	WRONG_DISK
OKAY	
	LEA	MESSAGES,A1
	MOVE.L	NUM_DEM,D7
	MULU	#40*4,D7
	ADDA.L	D7,A1
	BSR	EFFACE_TOUT
	MOVE.L	SCREEN1,A2
	LEA	160*50(A2),A2
	BSR.S	AF_LIGNE
	BSR.S	AF_LIGNE
	BSR.S	AF_LIGNE
	BSR.S	AF_LIGNE
	
	ST	$FFFF8242.W
	
	MOVE	(A0)+,D0	FACE
	MOVE	(A0)+,D1	PISTE
	MOVEQ	#0,D2
	MOVE	(A0)+,D2	SECT
	BSR.S	TRACK_LOADING
	LEA	DECRUNCHMES,A1
	MOVE.L	SCREEN1,A2
	LEA	160*(50+6*8)(A2),A2
	BSR.S	AF_LIGNE

	BSR	D_PACK
	LEA	NUM_DEM(PC),A0
	CMPI.L	#9,(A0)
	BEQ.S	NOREL
	BSR	RELOC
NOREL	MOVE	#$2300,SR
	OPT	O-,A-,P-
	JMP	ADR_LOAD
	OPT	O+,A+,P+

AF_LIGNE	MOVE	#(40/2)-1,D7
DO_A_Y	
	moveq	#0,d5
	LEA	FONT8_8,A3
	LEA	FONT8_8,A4
	MOVE.B	(A1)+,D5
	SUBI.B	#32,D5
	LSL	#3,D5
	ADDA.L	D5,A3
	moveq	#0,d5
	MOVE.B	(A1)+,D5
	SUBI.B	#32,D5
	LSL	#3,D5
	ADDA.L	D5,A4
	MOVE	#7,D6

DO_A_X	LEA	MOD_AF1(PC),A5
	MOVE.B	(A3)+,(A5)
	LEA	MOD_AF2(PC),A5
	MOVE.B	(A4)+,(A5)
MOD_AF1	EQU	*+2
MOD_AF2	EQU	*+3
	MOVE	#0,(A2)
	LEA	160(A2),A2
	DBF	D6,DO_A_X
	LEA	-160*8+8(A2),A2
	DBF	D7,DO_A_Y
	LEA	8*160(A2),A2
	RTS

TRACK_LOADING	
	LEA	FACE(PC),A0
	MOVE	D0,(A0)
	LEA	PISTE(PC),A1
	LEA	PISTE2(PC),A2
	MOVE	D1,(A1)
	MOVE	D1,(A2)
	LEA	NB_SECT(PC),A0
	CMPI.L	#10,D2
	BLE.S	PAS_PLUS_DE_10
	MOVE.L	D2,D3
	DIVS	#10,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVE	D3,D4	NB * 10 SECT A LIRE
	SWAP	D3
	MOVE	D3,D5	ET RESTE
	SUBQ.L	#1,D4
AGAIN	
	MOVEM.L	D4/A0-A2,-(SP)
	MOVE	#10,(A0)
	BSR.S	LOADING
	LEA	AJOUT(PC),A3
	ADD.L	#512*10,(A3)
	MOVEM.L	(SP)+,D4/A0-A2
	ADDQ	#1,(A1)
	ADDQ	#1,(A2)
;r	cmpi.b	#$39,$fffffc02.w
;	bne.s	r
;e	cmpi.b	#$39,$fffffc02.w
;	beq.s	e
	DBF	D4,AGAIN
	TST.L	D3
	BEQ.S	FINI
	MOVE	D5,(A0)
	BSR.S	LOADING
	BRA.S	FINI
PAS_PLUS_DE_10	MOVE	D2,(A0)
	BSR.S	LOADING
FINI	RTS

LOADING
;	lea	ADR_LOAD.W,a0
	OPT	O-,A-,P-
	LEA	ADR_LOAD,A0
	OPT	O+,A+,P+
AJOUT	EQU	*+2
	ADDA.L	#0,A0
	movea.l	a0,a1
	lea	$FFFF8604.W,a6
	st	$43E.W
	moveq	#0,d0
FACE	EQU	*+2
	move	#0,D1
	bsr	Set_drive
Tracks:	move.w	#$86,d2
PISTE	EQU	*+2
	move.w	#0,d3
	bsr.S	WD_write
	move.w	#$80,d2
	moveq	#%00010001,d3
	bsr.s	WD_write
Wait_Tracks:	bsr.S	Wait_done
	moveq	#0,d0
CHARGE:	move.l	a0,d1
	move.b	d1,$FFFF860D.W
	lsr.l	#8,d1
	move.b	d1,$FFFF860B.W
	lsr.l	#8,d1
	move.b	d1,$FFFF8609.W
DMA_in:	move.w	#$90,2(a6)
	move.w	#$190,2(a6)
	move.w	#$90,d2
	moveq	#1,d3
	bsr.s	WD_write
	move.w	#$82,d2
PISTE2	EQU	*+2
	move.w	#0,d3
	bsr.s	WD_write
	addq.w	#1,d0
	move.w	#$84,d2
	move.w	d0,d3
	bsr.s	WD_write
	move.w	#$80,d2
	move.w	#%10000000,d3
	bsr.s	WD_write
	bsr.s	Wait_done
	adda.l	#512,a0
NB_SECT	EQU	*+2
	cmpi.w	#0,d0
	bne.s	CHARGE
	move.b	#7,d0
	bsr.s	Select
	sf	$43E.W
	movea.l	a1,a0
	RTS
;	jmp	(a0)
WD_write:	move.w	d2,2(a6)
	move.w	d3,(a6)
Attend:	moveq	#40,d1
Attend1:dbf	d1,Attend1
	rts
Wait_done:	bsr.s	Attend
Wait:	btst	#5,$FFFFFa01.W
	bne.s	Wait
	rts
;Set_drive:	moveq	#5,d0
;Select:	move.w	sr,-(a7)
;	ori.w	#$700,sr
;	move.b	#$e,$ffFF8800.W
;	move.b	$ffFF8800.W,d1
;	andi.b	#$f8,d1
;	or.b	d0,d1
;	move.b	d1,$ffFF8802.W
;	move.w	(a7)+,sr
;	rts
Set_drive:
	move.w	d0,d4
	cmpi.w	#1,d0
	bgt.s	End_set
	addq.b	#1,d4
	lsl.b	#1,d4
	or.w	d1,d4
	eori.b	#7,d4
	andi.b	#7,d4
	MOVE.L	D4,D0
;	moveq	#5,d0		Selectionner le drive A	
Select:	move.w	sr,-(a7)
	ori.w	#$700,sr
	move.b	#$e,$fFFf8800.W
	move.b	$fFFf8800.W,d1
	andi.b	#$f8,d1
	or.b	d0,d1
	move.b	d1,$fFFf8802.W
	move.w	(a7)+,sr
End_set	rts

RELOC
	OPT	O-,A-,P-
	LEA	ADR_LOAD,A0
	OPT	O+,A+,P+
	MOVE.L	A0,A1
	ADD.L	2(A0),A1
	ADD.L	6(A0),A1
	LEA	31(A1),A1
	MOVEQ	#0,D0
	OPT	O-,A-,P-	
	LEA	ADR_LOAD+28,A0
	OPT	O+,A+,P+
	MOVE.L	A0,D1
	
RELOCATION	MOVE.B	(A1)+,D0
	BEQ.S	RELOC_END
	CMP.W	#1,D0
	BNE.S	RELOC1
	ADD.W	#254,A0
	BRA.S	RELOCATION
RELOC1	ADD.W	D0,A0
	ADD.L	D1,(A0)
	BRA.S	RELOCATION
RELOC_END	RTS

D_PACK
	OPT	O-,A-,P-
	LEA	ADR_LOAD,A0
	OPT	O+,A+,P+
	movem.l	d0-a6,-(a7)
	cmp.l	#"ATM5",(a0)+
	bne	not_packed
	link	a2,#-28
	move.l	(a0)+,d0
	ifne	MODE
	lea	4(a0,d0.l),a5
	move.l	d0,-(a7)
	elseif
	move.l	a1,a5
	add.l	d0,a5
	endc
	move.l	a5,a4
	ifne	MODE
	ifne	DEC_SPACE
	lea	DEC_SPACE(a4),a5
	endc
	endc
	lea	-$c(a4),a4
	move.l	(a0)+,d0
	move.l	a0,a6
	add.l	d0,a6
	ifne	PIC_ALGO
	moveq	#0,d0
	move.b	-(a6),d0
	move	d0,-2(a2)
	ifne	RESTORE_SPACE
	lsl	#2,d0
	sub	d0,a4
	endc
	elseif
	ifne	RESTORE_SPACE
	clr	-2(a2)
	endc
	subq	#1,a6
	endc
	ifne	RESTORE_SPACE
	lea	buff_marg(pc),a3
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.save
.save_m:	move.b	(a4)+,(a3)+
	subq	#1,d0
.save:	bne.s	.save_m
	movem.l	a3-a4,-(a7)
	endc
	ifne	PIC_ALGO
	pea	(a5)
	endc
	move.b	-(a6),d7
	bra	take_type
decrunch:	move	d3,d5
take_lenght:	add.b	d7,d7
.cont_take:	dbcs	d5,take_lenght
	beq.s	.empty1
	bcc.s	.next_cod
	sub	d3,d5
	neg	d5
	bra.s	.do_copy1
.next_cod:	moveq	#3,d6
	bsr.s	get_bit2
	beq.s	.next_cod1
	bra.s	.do_copy
.next_cod1:	moveq	#7,d6
	bsr.s	get_bit2
	beq.s	.next_cod2
	add	#15,d5
	bra.s	.do_copy
.empty1:	move.b	-(a6),d7
	addx.b	d7,d7
	bra.s	.cont_take
.next_cod2:	moveq	#13,d6
	bsr.s	get_bit2
	add	#255+15,d5
.do_copy:	add	d3,d5
.do_copy1:	lea	decrun_table(pc),a4
	move	d5,d2
	bne.s	bigger
	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a6),d7
	addx.b	d7,d7
.not_empty:	bcs.s	.ho_kesako
	moveq	#1,d6
	bra.s	word
.ho_kesako:	moveq	#3,d6
	bsr.s	get_bit2
	tst.b	-28(a2)
	beq.s	.ho_kesako1
	move.b	10-28(a2,d5.w),-(a5)
	bra	tst_end
.ho_kesako1:	move.b	(a5),d0
	btst	#3,d5
	bne.s	.ho_kesako2
	bra.s	.ho_kesako3
.ho_kesako2:	add.b	#$f0,d5
.ho_kesako3:	sub.b	d5,d0
	move.b	d0,-(a5)
	bra	tst_end
get_bit2:	clr	d5
.get_bits:	add.b	d7,d7
	beq.s	.empty
.cont:	addx	d5,d5
	dbf	d6,.get_bits
	tst	d5
	rts
.empty:	move.b	-(a6),d7
	addx.b	d7,d7
	bra.s	.cont
bigger:	moveq	#2,d6
word:	bsr.s	get_bit2
contus:	move	d5,d4
	move.b	14(a4,d4.w),d6
	ext	d6
	tst.b	1-28(a2)
	bne.s	.spe_ofcod1
	addq	#4,d6
	bra.s	.nospe_ofcod1
.spe_ofcod1:	bsr.s	get_bit2
	move	d5,d1
	lsl	#4,d1
	moveq	#2,d6
	bsr.s	get_bit2
	cmp.b	#7,d5
	blt.s	.take_orof
	moveq	#0,d6
	bsr.s	get_bit2
	beq.s	.its_little
	moveq	#2,d6
	bsr.s	get_bit2
	add	d5,d5
	or	d1,d5
	bra.s	.spe_ofcod2
.its_little:	or.b	2-28(a2),d1
	bra.s	.spe_ofcod3
.take_orof:	or.b	3-28(a2,d5.w),d1
.spe_ofcod3:	move	d1,d5
	bra.s	.spe_ofcod2
.nospe_ofcod1:	bsr.s	get_bit2
.spe_ofcod2:	add	d4,d4
	beq.s	.first
	add	-2(a4,d4.w),d5
.first:	lea	1(a5,d5.w),a4
	move.b	-(a4),-(a5)
.copy_same:	move.b	-(a4),-(a5)
	dbf	d2,.copy_same
	bra.s	tst_end
make_jnk:	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a6),d7
	addx.b	d7,d7
.not_empty:	bcs.s	string
	move.b	-(a6),-(a5)
tst_end:	cmp.l	a5,a3
	bne.s	make_jnk
	cmp.l	a6,a0
	beq.s	work_done
take_type:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.nospe_ofcod
	move.b	-(a6),d0
	lea	2-28(a2),a1
	move.b	d0,(a1)+
	moveq	#1,d1
	moveq	#6,d2
.next:	cmp.b	d0,d1
	bne.s	.no_off_4b
	addq	#2,d1
.no_off_4b:	move.b	d1,(a1)+
	addq	#2,d1
	dbf	d2,.next
	st	1-28(a2)
	bra.s	.spe_ofcod
.nospe_ofcod:	sf	1-28(a2)
.spe_ofcod:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.relatif
	lea	10-28(a2),a1
	moveq	#15,d0
.next_f:	move.b	-(a6),(a1)+
	dbf	d0,.next_f
	st	-28(a2)
	bra.s	.freq
.relatif:	sf	-28(a2)
.freq:	clr	d3
	move.b	-(a6),d3
	move.b	-(a6),d0
	lsl	#8,d0
	move.b	-(a6),d0
	move.l	a5,a3
	sub	d0,a3
	bra.s	make_jnk
string:	bra	decrunch
work_done:
	ifne	PIC_ALGO
	move.l	(a7)+,a0
	pea	(a2)
	bsr.s	decod_picture
	move.l	(a7)+,a2
	endc
	ifne	RESTORE_SPACE
	movem.l	(a7)+,a3-a4
	endc
	ifne	MODE
	move.l	(a7)+,d0
	bsr.S	copy_decrun
	endc
	ifne	RESTORE_SPACE
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.restore
.restore_m:	move.b	-(a3),-(a4)
	subq	#1,d0
.restore:	bne.s	.restore_m
	endc
	unlk	a2
not_packed:	movem.l	(a7)+,d0-a6
 	rts
decrun_table:	dc.w	32,32+64,32+64+256,32+64+256+512,32+64+256+512+1024
	dc.w	32+64+256+512+1024+2048,32+64+256+512+1024+2048+4096
	dc.b	0,1,3,4,5,6,7,8
	ifne	PIC_ALGO
decod_picture:	move	-2(a2),d7
.next_picture:	dbf	d7,.decod_algo
	rts
.decod_algo:	move.l	-(a0),d0
	lea	0(a5,d0.l),a1
.no_odd:	lea	$7d00(a1),a2
.next_planes:	moveq	#3,d6
.next_word:	move	(a1)+,d0
	moveq	#3,d5
.next_bits:	add	d0,d0
	addx	d1,d1
	add	d0,d0
	addx	d2,d2
	add	d0,d0
	addx	d3,d3
	add	d0,d0
	addx	d4,d4
	dbf	d5,.next_bits
	dbf	d6,.next_word
	movem	d1-d4,-8(a1)
	cmp.l	a1,a2
	bne.s	.next_planes
	bra.s	.next_picture
	endc
	ifne	MODE
copy_decrun:	lsr.l	#4,d0
	lea	-12(a6),a6
.copy_decrun:	rept	4
	move.l	(a5)+,(a6)+
	endr
	dbf	d0,.copy_decrun
	rts
	endc
	ifne	RESTORE_SPACE
buff_marg:	dcb.b	$90+DEC_SPACE+$C
	endc

	DATA
*Je vous indique o— se trouvent tous les ‚crans: si vous voulez les
*r‚cup‚rer, faites comme chez vous!
DATAS_FILES
*INTRO
	DC	0
	DC	1
	DC	31
	DC	288
*AROUND THE EARTH
	DC	0	DISK
	DC	0	FACE
	DC	1	PISTE DE DEPART
	DC	239	NB DE SECT A LIRE
*INVERTED LANDSCAPES
	DC	0
	DC	0
	DC	25
	DC	68
*SPRITES ELRIC/FULL
	DC	0
	DC	0
	DC	32
	DC	34
*MY SOCKS ARE ATOMIC FLAME THROWERS
	DC	0
	DC	0
	DC	36
	DC	94
*THE FACE IN THE ABYSS
	DC	0
	DC	0
	DC	46
	DC	77
*FLEXI KILLER SCROLLER
	DC	0
	DC	0
	DC	58
	DC	117
*DEVIL'S BALLS
	DC	1
	DC	0
	DC	1
	DC	249
*LIGHT SEEDS
	DC	1
	DC	0
	DC	26
	DC	156
*ATTACK OF INDIGESTION
	DC	1
	DC	0
	DC	42
	DC	32
*AMBITION
	DC	0
	DC	1
	DC	0
	DC	302
*JAPANESE WAY OF LIFE
	DC	1
	DC	0
	DC	61
	DC	91
*A CODER IS NOT A GUY YOU CAN TRUST
	DC	1
	DC	1
	DC	37
	DC	159
*DHARMAQUATION
	DC	0
	DC	1
	DC	60
	DC	167
*HIDDEN1 = 3D FULL LAMENTABLE
	DC	0
	DC	0
	DC	72
	DC	19
*HIDDEN2 = JAPANESE JOURNEY
	DC	1
	DC	0
	DC	46
	DC	141

	TEXT

INTER_RTE	RTE
EFFACE_TOUT
	MOVE.L	SCREEN1,A2
	MOVE	#7999,D7
EFFACE_ZOU	CLR.L	(A2)+
	DBF	D7,EFFACE_ZOU
	RTS
	SECTION	DATA
MESSAGES
	DC.B	"          CHOICE OF GODS INTRO          "
	DC.B	"                                        "
	DC.B	"   Please wait about 30 seconds after   "
	DC.B	"                loading...              "

	DC.B	"            AROUND THE EARTH            "
	DC.B	"                                        "
	DC.B	" Just because we love the soundtrack... "
	dc.b	"               ENJOY IT!                "

	dc.b	"           INVERTED LANDSCAPES          "
	DC.B	"                                        "
	DC.B	"   Filled and line vectors in perfect   "
	dc.b	"      harmony. Zappy strikes again!     "

	DC.B	"           ELRIC FULL SPRITES           "
	DC.B	"                                        "
	dc.b	"We just present here THE Ultimate Sprite"
	dc.b	"Routy ever coded on this good old ST... "

	DC.B	"   MY SOCKS ARE ATOMIC FLAME THROWERS   "
	DC.B	"                                        "
	dc.b	"   A screen commited by Zappy the Mad.  "
	dc.b	"    Dedicated to LEGACY, of course...   "

	DC.B	"          THE FACE IN THE ABYSS         "
	DC.B	"                                        "
	DC.B	"  Again a multipart. The oldest in our  "
	dc.b	"        demo, again by the Big Z.       "

	DC.B	"          FLEXI-KILLER-SCROLLER         "
	DC.B	"                                        "
	dc.b	" HERE IT IS!! Finally released after 2  "
	dc.b	"  years in a drawer: Dan Nato's child!  "

	DC.B	"              DEVIL'S BALLS             "
	DC.B	"                                        "
	dc.b	"       Is it fullscreen or what ?       "
	dc.b	"      This screen looks terrific !      "

	DC.B	"               LIGHT SEEDS              "
	DC.B	"                                        "
	dc.b	"    With Zerioul's 3D'n line routies.   "
	dc.b	" Elric doesn't like this screen. Snif.. "


	DC.B	"          ATTACK OF INDIGESTION         "
	DC.B	"                                        "
	DC.B	"                  Burp.                 "
	DC.B	"                                        "

	DC.B	"                AMBITION                "
	DC.B	"                                        "
	dc.b	"       A nice multi-part by ELRIC...    "
	dc.b	"     Prepare for some chaotic codes!    "

	dc.b	"          JAPANESE WAY OF LIFE          "
	DC.B	"                                        "
	dc.b	"     MAD! Zappy is completely MAD!!     "
	DC.B	"                                        "


	DC.B	"   A CODER IS NOT A GUY YOU CAN TRUST   "
	DC.B	"                                        "
	DC.B	"  So don't believe them when they say   "
	dc.b	"             that they rule!            "

	DC.B	"             DHARMAQUATION              "
	DC.B	"                                        "
	DC.B	" A very little multipart, just to fill  "
	dc.b	"               the disk!                "

	DC.B	"              HIDDEN SCREEN             "
	DC.B	"                                        "
	DC.B	"            It's a surprise...          "
	DC.B	"                                        "

	DC.B	"            JAPANESE JOURNEY            "
	DC.B	"                                        "
	DC.B	"  There are some bugs in this screen,   "
	dc.b	"        and we're sorry for this...     "

DECRUNCHMES	DC.B	"                DEPACKING               "
WRONGMES	DC.B	"         INSERT THE OTHER DISK          "
	DC.B	"            AND PRESS SPACE.            "
*	0 = Around the Earth
*	1 = Inverted Landscapes
*	2 = Elric Fullsprites
*	3 = My Socks are Atomic Flame Throwers
*	4 = The Face in the Abyss
*	5 = Flexi-Killer-Scroller
*	6 = Big Screen
*	7 = Light Seeds
*	8 = Attack of Indigestion
*	9 = Ambition
*	10= Japanese way of life
*	11= Hidden 1 ( 3DF )
*	12= Japanese Journey ( Hidden 2 )
*	13= A coder is not a guy you can trust
FONT8_8
font:   	dc.l	$00000000,$00000000,$00181818,$18001800,$00666666 
	dc.l	$00000000,$0066FF66,$66FF6600,$183E603C,$067C1800 
	dc.l	$00666C18,$30664600,$1C361C38,$6F663B00,$00181818 
	dc.l	$00000000,$000E1C18,$181C0E00,$00703818,$18387000 
	dc.l	$00663CFF,$3C660000,$0018187E,$18180000,$00000000 
	dc.l	$00181830,$0000007E,$00000000,$00000000,$00181800 
	dc.l	$00060C18,$30604000,$003C666E,$76663C00,$00183818 
	dc.l	$18187E00,$003C660C,$18307E00,$007E0C18,$0C663C00 
	dc.l	$000C1C3C,$6C7E0C00,$007E607C,$06663C00,$003C607C 
	dc.l	$66663C00,$007E060C,$18303000,$003C663C,$66663C00 
	dc.l	$003C663E,$060C3800,$00001818,$00181800,$00001818 
	dc.l	$00181830,$060C1830,$180C0600,$00007E00,$007E0000 
	dc.l	$6030180C,$18306000,$003C660C,$18001800,$003C666E 
	dc.l	$6E603E00,$00183C66,$667E6600,$007C667C,$66667C00 
	dc.l	$003C6660,$60663C00,$00786C66,$666C7800,$007E607C 
	dc.l	$60607E00,$007E607C,$60606000,$003E6060,$6E663E00 
	dc.l	$0066667E,$66666600,$007E1818,$18187E00,$00060606 
	dc.l	$06663C00,$00666C78,$786C6600,$00606060,$60607E00 
	dc.l	$0063777F,$6B636300,$0066767E,$7E6E6600,$003C6666 
	dc.l	$66663C00,$007C6666,$7C606000,$003C6666,$666C3600 
	dc.l	$007C6666,$7C6C6600,$003C603C,$06063C00,$007E1818 
	dc.l	$18181800,$00666666,$66667E00,$00666666,$663C1800 
	dc.l	$0063636B,$7F776300,$0066663C,$3C666600,$0066663C 
	dc.l	$18181800,$007E0C18,$30607E00,$001E1818,$18181E00 
	dc.l	$00406030,$180C0600,$00781818,$18187800,$00081C36 
	dc.l	$63000000,$00000000,$0000FF00,$00183C7E,$7E3C1800 
	dc.l	$00003C06,$3E663E00,$0060607C,$66667C00,$00003C60 
	dc.l	$60603C00,$0006063E,$66663E00,$00003C66,$7E603C00 
	dc.l	$000E183E,$18181800,$00003E66,$663E067C,$0060607C 
	dc.l	$66666600,$00180038,$18183C00,$00060006,$0606063C 
	dc.l	$0060606C,$786C6600,$00381818,$18183C00,$0000667F 
	dc.l	$7F6B6300,$00007C66,$66666600,$00003C66,$66663C00 
	dc.l	$00007C66,$667C6060,$00003E66,$663E0606,$00007C66 
	dc.l	$60606000,$00003E60,$3C067C00,$00187E18,$18180E00 
	dc.l	$00006666,$66663E00,$00006666,$663C1800,$0000636B 
	dc.l	$7F3E3600,$0000663C,$183C6600,$00006666,$663E0C78 
	dc.l	$00007E0C,$18307E00,$00183C7E,$7E183C00,$18181818 
	dc.l	$18181818,$007E787C,$6E660600,$08183878,$38180800 
	even

;FLAG	DC.L	0
;TIME	DC.L	0
;NUMERO_LINE	DC.L	0

;TRUE	DC.L	0
;;TRUE2	DC.L	0
;TRUE3	DC.L	0
;HIDDEN1	DC.B	$17,$39,$2C,$10,$31,$31,$10,$39,$1F,$12,$12,$39,$17,$14
;;HIDDEN2	DC.B	$13,$10,$2E,$1E,$16,$12,$26,$39
;;	DC.B	$2C,$12,$39,$26,$18,$2F,$12,$39,$15,$18,$16
;HIDDEN3	DC.B	$23,$18,$26,$18,$2E,$10,$16,$1F,$14,$39
;	DC.B	$21,$18,$13,$12,$2F,$12,$13
	BSS
SCREEN1	DS.L	1
;	DS.B	256
;BUFFER	DS.B	64000
;BUF_LINES	DS.B	40*8*NB_LINES
;ENDBUF
	DS.L	256
NEWPILE	DS.L	1