	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	CLR.L	TRUE
	CLR.L	TRUE2
	CLR.L	TRUE3

	LEA	TEXT,A0
	MOVE	#NB_LINES-1,D0
DO_Y	MOVE	#40-1,D1
DO_X	MOVEQ	#0,D2
	LEA	BUF_LINES,A1
	LEA	FONT8_8,A2
	MOVE.B	(A0)+,D2
	SUBI.B	#32,D2
	LSL	#3,D2
	ADDA.L	D2,A2
MOD	EQU	*+2
	LEA	0(A1),A1
N	SET	0
	REPT	8
	MOVE.B	(A2)+,N(A1)
N	SET	N+40
	ENDR
	ADDQ	#1,MOD
	DBF	D1,DO_X
;	CLR	MOD
	ADD	#40*7,MOD
	DBF	D0,DO_Y

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	move.l	#BUFFER,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0
	move.l	d0,SCREEN2

	MOVE.L	#INTER_RTE,$68.W
	MOVE.L	#TIMER_B,$120.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	MOVE.B	#$12,$FFFFFC02.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W
	MOVE.L	#VBL,$70.W
	MOVE	#$2300,SR
FIN
J	BRA.S	J
VBL
	SF	$FFFF8240.W
	CLR.B	$FFFFFA1B.W

	MOVE.B	#8*10,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	MOVE.L	SCREEN1,A1
	LEA	BUF_LINES,A0
MOD1	EQU	*+2
	LEA	0(A0),A0
N	SET	0
;	REPT	8*20
	MOVE	#8*20-1,D0
DO_IT	MOVE	(A0)+,N(A1)
	MOVE	(A0)+,N+8(A1)
	MOVE	(A0)+,N+16(A1)
	MOVE	(A0)+,N+24(A1)
	MOVE	(A0)+,N+32(A1)
	MOVE	(A0)+,N+40(A1)
	MOVE	(A0)+,N+48(A1)
	MOVE	(A0)+,N+56(A1)
	MOVE	(A0)+,N+64(A1)
	MOVE	(A0)+,N+72(A1)
	MOVE	(A0)+,N+80(A1)
	MOVE	(A0)+,N+88(A1)
	MOVE	(A0)+,N+96(A1)
	MOVE	(A0)+,N+104(A1)
	MOVE	(A0)+,N+112(A1)
	MOVE	(A0)+,N+120(A1)
	MOVE	(A0)+,N+128(A1)
	MOVE	(A0)+,N+136(A1)
	MOVE	(A0)+,N+144(A1)
	MOVE	(A0)+,N+152(A1)
;N	SET	N+160
	LEA	160(A1),A1
	DBF	D0,DO_IT

	MOVE.L	SCREEN1,D0
	LSL.L	#8,D0
	LEA	$FFFF8201.W,A0
	MOVEP.L	D0,(A0)

	TST.L	FLAG
	BNE	GERE_FLAG

	MOVEQ	#0,D0
	MOVE.B	$FFFFFC02.W,D0
	LEA	HIDDEN1,A0
	ADDA.L	TRUE,A0
	CMP.B	(A0),D0
	BNE.S	NO_OK
	ADDQ.L	#1,TRUE
	CMPI.L	#14,TRUE
	BNE.S	NO_OK
	MOVE	#$700,MODCOL
NO_OK
MODCOL	EQU	*+2
	MOVE	#$000,$FFFF8240.W

	MOVEQ	#0,D0
	MOVE.B	$FFFFFC02.W,D0
	LEA	HIDDEN2,A0
	ADDA.L	TRUE2,A0
	CMP.B	(A0),D0
	BNE.S	NO_OK2
	ADDQ.L	#1,TRUE2
	CMPI.L	#19,TRUE2
	BNE.S	NO_OK2
	MOVE	#$770,MODCOL2
NO_OK2
MODCOL2	EQU	*+2
	MOVE	#$000,$FFFF8240.W

	MOVEQ	#0,D0
	MOVE.B	$FFFFFC02.W,D0
	LEA	HIDDEN3,A0
	ADDA.L	TRUE3,A0
	CMP.B	(A0),D0
	BNE.S	NO_OK3
	ADDQ.L	#1,TRUE3
	CMPI.L	#17,TRUE3
	BNE.S	NO_OK3
	MOVE	#$777,MODCOL3
NO_OK3
MODCOL3	EQU	*+2
	MOVE	#$000,$FFFF8240.W



	CMPI.B	#$48,$FFFFFC02.W
	BNE.S	NO_HAUT
	CMPI.L	#NB_LINES,NUMERO_LINE
	BGE.S	NO_HAUT
	ADDQ.L	#1,NUMERO_LINE
	ADD	#40,MOD1
	MOVE	#40,MOD2
	MOVE.L	#1,FLAG
NO_HAUT
	CMPI.B	#$50,$FFFFFC02.W
	BNE.S	NO_BAS
	TST.L	NUMERO_LINE
	BLE.S	NO_BAS
	SUBQ.L	#1,NUMERO_LINE
	SUB	#40,MOD1
	MOVE	#-40,MOD2
	MOVE.L	#2,FLAG
NO_BAS	BRA.S	PLUS_LOIN
GERE_FLAG	ADDQ.L	#1,TIME
MOD2	EQU	*+2
	MOVE	#0,D0
	ADD	D0,MOD1
	CMPI.L	#7,TIME
	BNE.S	PLUS_LOIN
	CLR.L	TIME
	CLR.L	FLAG
PLUS_LOIN	CMPI.B	#$1C,$FFFFFC02.W
	BNE.S	PAS_RETURN
	CMPI.L	#2,NUMERO_LINE
	BLT.S	PAS_RETURN
	MOVE	#$070,$FFFF8240.W
PAS_RETURN	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_TIME
	ST	$FFFF8240.W
NO_TIME	MOVE	#$444,$FFFF8242.W
	CMPI.B	#$1,$FFFFFC02.W
	BNE.S	INTER_RTE
;	MOVE.L	NUMERO_LINE,$E0000
	MOVE.L	4.W,A0
	JMP	(A0)
INTER_RTE	RTE

TIMER_B	MOVE	#$001,$FFFF8240.W
	MOVE	#$777,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.B	#8,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W
	MOVE.L	#TB2,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

TB2	SF	$FFFF8240.W
	MOVE	#$444,$FFFF8242.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#TIMER_B,$120.W
	BCLR	#0,$FFFFFA0F.W
	RTE

	SECTION	DATA
	*	"****************************************"
TEXT
	DC.B	"                                        "
	DC.B	"****************************************"
	DC.B	"*     C H O I C E   O F   G O D S      *"
	DC.B	"*              -MAIN MENU-             *"
	DC.B	"****************************************"
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"==============THE SCREENS==============="
	DC.B	"                                        "
	DC.B	"          Use arrows to scroll          "
	DC.B	"          and RETURN to select.         "
	DC.B	"                                        "
	DC.B	"            AROUND THE EARTH            "
	dc.b	"           INVERTED LANDSCAPES          "
	DC.B	"           ELRIC FULL SPRITES           "
	DC.B	"   MY SOCKS ARE ATOMIC FLAME THROWERS   "
	DC.B	"          THE FACE IN THE ABYSS         "
	DC.B	"          FLEXI-KILLER-SCROLLER         "
	DC.B	"               BIG SCREEN               "
	DC.B	"               LIGHT SEEDS              "
	DC.B	"                OVERDOSE                "
	DC.B	"                AMBITION                "
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"==============THE MEMBERS==============="
	DC.B	"        ( in alphabetical order )       "
	DC.B	"                                        "
	DC.B	"                                        "
	dc.b	"        BLYZARD     -    Gfxs           "
	DC.B	"        DAN NATO    -    Coder          "
	DC.B	"        ELRIC       -    Coder          "
	DC.B	"        NONE        -    Coder          "
	dc.b	"        SLEDGE      -    Gfxs           "
	DC.B	"        ZAPPY       -    Coder/Gfxs     "
	DC.B	"        ZERIOUL     -    Coder          "
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"===========THE HALLYHALLO'S============="
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"  LEGACY - OVERLANDERS - ST CNX - NAOS  "
	DC.B	"   VEGETABLES - MCODER - PULSION - ULM  "
	DC.B	"                                        "
	DC.B	"                                        "
	dc.b	"================THE INFOS==============="
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"   Disks format: 79 tracks/10 sectors.  "
	dc.b	"     There are hidden screens, boys.    "
	dc.b	"             Go and find them!          "
	DC.B	"                                        "
	dc.b	"            You can contact us:         "
	DC.B	"                                        "
	dc.b	"           3615 STMAG, bal ZAPPY        "
	DC.B	"                                        "
	dc.b	"     3615 RTEL, or 3614 RTEL1, bals     "
	dc.b	"     ZAPPY, ELRIC, DAN NATO or even     "
	dc.b	"                HOLOCAUST.              "
	DC.B	"                                        "
	DC.B	"                                        "
	dc.b	"===========THE SPECIAL THANKS==========="
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"To -BRAIN- for his trackloading routies."
	DC.B	"                                        "
	dc.b	"  To -GRIFF- for his Protracker Replay  "
	dc.b	"           Routine in Maggie 8.         "
	DC.B	"                                        "
	dc.b	"To -SKAVEN- for all the videos'n books. "
	DC.B	"                                        "
	DC.B	"                                        "
	DC.B	"                                        "
END_TXT
NB_LINES=(END_TXT-TEXT)/40

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

FLAG	DC.L	0
TIME	DC.L	0
NUMERO_LINE	DC.L	0

TRUE	DC.L	0
TRUE2	DC.L	0
TRUE3	DC.L	0
HIDDEN1	DC.B	$17,$39,$2C,$10,$31,$31,$10,$39,$1F,$12,$12,$39,$17,$14
HIDDEN2	DC.B	$13,$10,$2E,$1E,$16,$12,$26,$39
	DC.B	$2C,$12,$39,$26,$18,$2F,$12,$39,$15,$18,$16
HIDDEN3	DC.B	$23,$18,$26,$18,$2E,$10,$16,$1F,$14,$39
	DC.B	$21,$18,$13,$12,$2F,$12,$13
	BSS
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	64000
BUF_LINES	DS.B	40*8*NB_LINES
ENDBUF