	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	D0,SAUV_SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.B	#$12,$FFFFFC02.W

	MOVE.L	$44E.W,A0
	MOVE	#7999,D0
EFF	CLR.L	(A0)+
	DBRA	D0,EFF

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,SAUV_PAL
	MOVE	#7,$FFFF8242.W

	ANDI.B	#%11111000,$484.W

	BSR	PREP_ROUL

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W

BOUCLE	JMP	BOUCLE

FIN	MOVE.L	ANC_VBL,$70.W

	MOVE.B	#8,$FFFFFC02.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVEM.L	SAUV_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	SAUV_SP,-(SP)	
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

	*******   V B L  &  P R O C E D U R E S   *******
VBLR	MOVE.W	#$700,$FFFF8240.W
	TST.L	FLAG
  	BNE.S	SUITV0
	BSR	TESTT
SUITV0	CMPI.L	#1,FLAG
	BNE.S	SUITV1
	BRA.S	MONT
SUITV1	CMPI.L	#2,FLAG
	BNE.S	SUITV2
	BRA.S	DESS
SUITV2	BSR	AFF_ROL
SUITV3	CLR	$FFFF8240.W

	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE

MONT	SUBQ.L	#1,COUNT_LIG	
	ADDQ.L	#1,COUNTF
	BSR	AFF_ROL
	CMPI.L	#8,COUNTF
	BEQ	CM
	BRA	FINM
CM	CLR.L	COUNTF
	CLR.L	FLAG
FINM	BRA	SUITV3	

DESS	ADDQ.L	#1,COUNT_LIG	
	ADDQ.L	#1,COUNTF
	BSR	AFF_ROL
	CMPI.L	#8,COUNTF
	BEQ	CD
	BRA	FIND
CD	CLR.L	COUNTF
	CLR.L	FLAG
FIND	BRA	SUITV3	

TESTT	CMPI.B	#$48,$FFFFFC02.W
	BNE	SUIT1
	CMPI.L	#0,COUNT_LIG
	BEQ	FINT
	MOVE.L	#1,FLAG
	BRA	FINT
SUIT1	CMPI.B	#$50,$FFFFFC02.W
	BNE	FINT
	CMPI.L	#40*81,COUNT_LIG
	BEQ	FINT
	MOVE.L	#2,FLAG
FINT	RTS

AFF_ROL	LEA	BUF_ROUL,A0
	MOVE.L	COUNT_LIG,D0
	LSL.L	#5,D0
	ADDA.L	D0,A0	
	MOVE.L	$44E.W,A1
INC	SET	0
	REPT	8*9
	MOVE.W	(A0)+,INC+16(A1)
	MOVE.W	(A0)+,INC+24(A1)
	MOVE.W	(A0)+,INC+32(A1)
	MOVE.W	(A0)+,INC+40(A1)
	MOVE.W	(A0)+,INC+48(A1)
	MOVE.W	(A0)+,INC+56(A1)
	MOVE.W	(A0)+,INC+64(A1)
	MOVE.W	(A0)+,INC+72(A1)
	MOVE.W	(A0)+,INC+80(A1)
	MOVE.W	(A0)+,INC+88(A1)
	MOVE.W	(A0)+,INC+96(A1)
	MOVE.W	(A0)+,INC+104(A1)
	MOVE.W	(A0)+,INC+112(A1)
	MOVE.W	(A0)+,INC+120(A1)
	MOVE.W	(A0)+,INC+128(A1)
	MOVE.W	(A0)+,INC+136(A1)

INC	SET	INC+160
	ENDR
	RTS
		
PREP_ROUL	CLR.L	D0
	MOVE.L	#44,D1
	LEA	BUF_ROUL,A0
	LEA	TEXT,A1	
NEW_LIG	REPT	32
	MOVEQ	#0,D0
	LEA	FONT8_8,A2
	MOVE.B	(A1)+,D0
	SUBI.B	#32,D0
	LSL.L	#3,D0
	ADDA.L	D0,A2	
	MOVE.B	(A2)+,(A0)
	MOVE.B	(A2)+,32(A0)
	MOVE.B	(A2)+,64(A0)
	MOVE.B	(A2)+,96(A0)
	MOVE.B	(A2)+,128(A0)
	MOVE.B	(A2)+,160(A0)
	MOVE.B	(A2)+,192(A0)
	MOVE.B	(A2)+,224(A0)
	ADDQ.L	#1,A0
	ENDR
	ADDA.L	#32*7,A0
	DBRA	D1,NEW_LIG
	RTS
	
	SECTION	DATA
	*	"********************************"   
TEXT	
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"********************************"
	DC.B	"* C H O I C E   O F   G O D S  *"
	DC.B	"*      -ALTERNATIVE MENU-      *"
	DC.B	"********************************"
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"==========THE SCREENS==========="
	DC.B	"                                "
	DC.B	"      Use arrows to scroll      "
	DC.B	"      and SPACE to select.      "
	DC.B	"                                "
	DC.B	"     FLEXI-KILLER-SCROLLER      "
	DC.B	"        DIGITAL DAYDREAM        "
	DC.B	"            OVERDOSE            "
	DC.B	"           LIGHT SEEDS          "
	DC.B	"        ZAPPY'S MULTIPART       "
	DC.B	"      ELRIC IN FULL SPRITES     "
	DC.B	"          M.S.A.A.F.T.          "
	dc.b	"       INVERTED LANDSCAPES      "
	DC.B	"            AMBITION            "
	DC.B	"        AROUND THE GLOBE        "
	DC.B	"          DEVIL'S BALLS         "
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"==========THE MEMBERS==========="
	DC.B	"    ( in alphabetical order )   "
	DC.B	"                                "
	DC.B	"                                "
	dc.b	"    BLYZARD     -    Gfxs       "
	DC.B	"    DAN NATO    -    Coder      "
	DC.B	"    ELRIC       -    Coder      "
	DC.B	"    NONE        -    Coder      "
	dc.b	"    SLEDGE      -    Gfxs       "
	DC.B	"    ZAPPY       -    Coder/Gfxs "
	DC.B	"    ZERIOUL     -    Coder      "
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"=======THE HALLYHALLO'S========="
	DC.B	"                                "
	DC.B	"                                "
	DC.B	" LEGACY - OVERLANDERS - ST CNX  "
	DC.B	"   NAOS - VEGETABLES - MCODER   "
	DC.B	"                                "
	DC.B	"                                "
	dc.b	"============THE INFOS==========="
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"Disk format: 79 tracks/10 sect. "
	dc.b	"There's an hidden screen, boys. "
	dc.b	"        Go and find it!         "
	DC.B	"                                "
	dc.b	"       You can contact us:      "
	DC.B	"                                "
	dc.b	"Minitel:                        "
	dc.b	" 3615 STMAG, bal ZAPPY          "
	DC.B	"                                "
	dc.b	" 3615 RTEL, or 3614 RTEL1, bals "
	dc.b	" ZAPPY, ELRIC, DAN NATO or even "
	dc.b	" HOLOCAUST.                     "
	DC.B	"                                "
	dc.b	"Letters:                        "
	dc.b	" ZAPPY:     TERDIMAN Pierre     "
	dc.b	"            8 rue Pasteur       "
	dc.b	"            95160 MONTMORENCY   "
	DC.B	"                                "
	DC.B	"                                "
	dc.b	"=======THE SPECIAL THANKS======="
	DC.B	"                                "
	DC.B	"                                "
	DC.B	"To -BRAIN- for his trackloading "
	dc.b	"routines.                       "
	DC.B	"                                "
	dc.b	"To -GRIFF- for his Protracker   "
	dc.b	"Replay Routine in Maggie 8.     "
	DC.B	"                                "
	dc.b	"To -SKAVEN- for his nice pic.   "
	DC.B	"                                "
	DC.B	"                                "
	EVEN
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

	SECTION	BSS
SAUV_PAL	DS.L	8	;sauve init palette
ANC_VBL	DS.L	1	;sauve vbl
SAUV_SP	DS.L	1	;sauve user stack
COUNT_LIG	DS.L	1	;No de la ligne actuelle
FLAG	DS.L	1	;flag:1,monte-2,descend-3,ne fait rien
COUNTF	DS.L	1	;comteur sup de 1 … 8
BUF_ROUL	DS.B	(38*8)*50	;buffer total pour le texte	