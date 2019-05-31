* Loader principal - Japtro.

* A sauver via Genst ( pas Monst ) sous le nom JAPLOAD.BLC et Ö
* exÇcuter avec JAP_EXE.S

* Structure du fichier principal:
*	incbin	DBZ.DAT	28952
*	incbin	laby.DAT	59672
*	incbin	xtunnel.dat	15802
*	INCBIN	DRAPO.DAT	8464
*	INCBIN	TOTAL.DAT	31598
*	INCBIN	CUBEF.DAT	23838
*	incbin	cubes.dat	5842
*	incbin	logo.dat	70052
	
ADR_LOAD=$E7960

FACE_INIT	=	1	0 ou 1
PIST_INIT	=	0	0=bootsecteur

MODE:	EQU	1	FROM A0 TO A0
PIC_ALGO:	EQU	0
DEC_SPACE:	EQU	$0	 ;MAX IS $7FFE (no odd value!)
RESTORE_SPACE:	EQU	0

;	CLR.L	-(SP)
;	MOVE	#$20,-(SP)
;	TRAP	#1
;	ADDQ	#6,SP

;	CLR	-(SP)
;	PEA	-1.W
;	PEA	-1.W
;	MOVE	#5,-(SP)
;	TRAP	#14
;	LEA	12(SP),SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	MOVE.L	#FIN,$018.W
	MOVE.L	#FIN,$01C.W
	MOVE.L	#FIN,$020.W
	LEA	NEWPILE,A7
	MOVE.L	#BUF,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN

	MOVEQ	#1,D0
	JSR	ZIK	

	LEA	FNT+34,A0
	LEA	GFX,A1
	MOVE	#3999,D0
R	MOVE	(A1)+,(A0)
	ADDQ	#8,A0
	DBF	D0,R

	MOVE.L	#$01010101,$FFFF8240.W
	MOVE.L	#$01010101,$FFFF8244.W
	MOVE.L	#VBL2,$70.W
	move.l	#RTE,$120.W
	move.l	#RTE,$134.W
	MOVE.L	#MSG,MOD_MES
	MOVE.L	#$31415926,$426.W
	MOVE.L	#RESET_RT,$42A.W

	lea	BUF,a0
	lea	$f0000,a1
zer	clr.l	(a0)+
	cmp.l	a1,a0
	ble.s	zer

	JMP	trui
FLAG_POURRI	DC	0
HOP	
	MOVE.L	#RT_ZIK,A0
	MOVE.L	#RETZ,A1
	MOVEM.L	D0-A7,SAVERZ
	TST	FLAG_POURRI
	BEQ.S	.NORM2
	JMP	FNT
.NORM2	JMP	buf2
SAVERZ	DS.L	32
rte	rte
RESET_RT	MOVE	#$2700,SR
	CLR	FLAG_POURRI
	LEA	NEWPILE,A7
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.L	#rte,$70.W
	move.l	#rte,$120.W
	move.l	#rte,$134.W
	move.l	#rte,$68.W
	MOVE.L	#$31415926,$426.W
	MOVE.L	#RESET_RT,$42A.W
	
	MOVE.B	#$00,$FFFFFA0F.W
	MOVE.B	#$1E,$FFFFFA13.W
	MOVE.B	#$00,$FFFFFA1B.W
	MOVE.B	#$47,$FFFFFA21.W
	MOVE.B	#$64,$FFFFFA15.W
	MOVE.B	#$48,$FFFFFA17.W
	MOVE.B	#$00,$FFFFFA19.W
	MOVE.B	#$FF,$FFFFFA1F.W

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
	
	JMP	trui
COLORS_OFF
	MOVE.L	#$01010101,$FFFF8240.W
	MOVE.L	#$01010101,$FFFF8244.W
	MOVE.L	#$01010101,$FFFF8248.W
	MOVE.L	#$01010101,$FFFF824C.W
	MOVE.L	#$01010101,$FFFF8250.W
	MOVE.L	#$01010101,$FFFF8254.W
	MOVE.L	#$01010101,$FFFF8258.W
	MOVE.L	#$01010101,$FFFF825C.W
	RTS

RETZ	MOVEM.L	SAVERZ,D0-A7
trui	LEA	NEWPILE,A7
	MOVE.L	#VBL_STABLE,$70.W
	move.l	#RTE,$120.W
	move.l	#RTE,$134.W
	move	#$2300,sr
	;STOP	#$2300
	;STOP	#$2300
	;CLR.B	$FFFF8260.W
	BSR	COLORS_OFF

ADR_RETOUR
	MOVE.L	#BUF,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN

	move.l	SCREEN,d0
	lsr.l	#8,d0		
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)

	CLR	MOD1
	CLR	MOD2
	TST	FLAG_POURRI
	BEQ.S	.NORM3

	MOVE.L	#64000/4+500,D1
	LEA	FNT,A1
.CC	CLR.L	(A1)+
	DBF	D1,.CC

	LEA	FNT+34,A0
	LEA	GFX,A1
	MOVE	#3999,D0
.R2	MOVE	(A1)+,(A0)
	ADDQ	#8,A0
	DBF	D0,.R2

	CLR	FLAG_POURRI
.NORM3	
	JSR	GERE_FNT
	JSR	DêCALE
	JSR	FAD1

	cmpi	#2,FLAG
	BNE	SPEC
	MOVE	#50-1,D0
WA	JSR	VSYNC
	DBF	D0,WA
	BRA	SPEC2
SPEC	JSR	CHARGEZ
TAILLE	EQU	*+2
	MOVE.L	#0,D0

	LEA	buf2,A1
	TST	FLAG_POURRI
	BEQ.S	TT_EST_OK
	MOVE.L	#64000/4+500,D1
	LEA	FNT,A1
CC	CLR.L	(A1)+
	DBF	D1,CC
	LEA	FNT,A1
TT_EST_OK	
	LSR.L	#2,D0
	SUBQ.L	#1,D0
RECOP	MOVE.L	(A0)+,(A1)+
	DBF	D0,RECOP

	LEA	ADR_LOAD,A0
	MOVE	#99000/4,D0
.F	CLR.L	(A0)+
	DBF	D0,.F

	LEA	buf2,A0
	TST	FLAG_POURRI
	BEQ.S	.NORM
	JSR	COLORS_OFF	
	LEA	FNT,A0
.NORM	JSR	depack
	JSR	RELOC
	CMPI	#1,FLAG
	BEQ	HOP
SPEC2	TST	FLAG_POURRI
	BNE.S	.POK
	JSR	FAD2
	JSR	EFF_êCRAN
.POK	CMPI	#2,FLAG
	BEQ	trui
	BRA	HOP
EFF_êCRAN
	MOVE.L	SCREEN,A0
	MOVE	#7999,D0
FGH	CLR.L	(A0)+
	DBF	D0,FGH
	RTS
MINIBUF	DS	20
DêCALE
	MOVE.L	SCREEN,A0
	MOVE	#200-1-8,D1
	MOVE.L	A0,A1
.Z
	MOVE.L	A1,A0
*
	LEA	MINIBUF,A5
N	SET	0
	REPT	20
	MOVE	N(A0),(A5)+
N	SET	N+8
	ENDR
*
	MOVE	#3-1,D7
.X	LEA	MINIBUF,A5
	MOVE	#20-1,D0
.F	
	ROXR	(A5)+
	DBF	D0,.F
	DBF	D7,.X
*
	MOVE.L	A1,A0
	LEA	MINIBUF,A5
N	SET	0
	REPT	20
	MOVE	(A5)+,N+2+160*3(A0)
N	SET	N+8
	ENDR
*

	LEA	160(A1),A1
	DBF	D1,.Z
	RTS

FAD1	
BO	BSR	VSYNC
BO2	BSR	VSYNC
	SUBQ	#1,TIME
	BNE.S	BO2
	MOVE	#4,TIME
	LEA	FAD_1,A0
MOD1	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BEQ.S	RET
	MOVE	(A0),$FFFF8242.W
	MOVE	(A0),$FFFF8246.W
	MOVE	-10(A0),$FFFF8244.W
	ADDQ.W	#2,MOD1
	BRA.S	FAD1
RET	RTS
FAD2
	BSR	VSYNC
BO3	BSR	VSYNC
	SUBQ	#1,TIME
	BNE.S	BO3
	MOVE	#4,TIME
	LEA	FAD_2,A0
MOD2	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,-10(A0)
	BEQ.S	RET2
	MOVE	(A0),$FFFF8242.W
	MOVE	(A0),$FFFF8246.W
	MOVE	-10(A0),$FFFF8244.W
	SUBQ.W	#2,MOD2
	BRA.S	FAD2
RET2	RTS

VSYNC	CMPI.W	#1,VBL_FLAG
	BLT.S	VSYNC
	CLR.W	VBL_FLAG
	RTS

VBL	ADDQ	#1,VBL_FLAG
	MOVEM.L	D0-A6,SAVE
VBL_S	JSR	ZIK+8
	MOVEM.L	SAVE,D0-A6
	CLR.B	$FFFF8260.W
	RTE
VBL2	ADDQ	#1,VBL_FLAG
	CLR.B	$FFFF8260.W
RTE	RTE
VBL_STABLE
	MOVEM.L	D0-A6,SAVE
	LEA	$FFFF8209.W,A4
	LEA	$FFFF8260.W,A6
	LEA	$FFFF820A.W,A5
	MOVEQ	#0,D1		
	MOVEQ	#$10,D6
	MOVE.L	#199,D0
SYNCHRO	MOVE.B	(A4),D7
	BEQ.S	SYNCHRO
	SUB.W	D7,D6
	LSL.W	D6,D1
	DCB	97-1,$4E71
ful	nop
	MOVE	A6,(A6)
	MOVE.B	#0,(A6)
	DCB	88,$4E71
	MOVE.B	#0,(A5)
	MOVE	A6,(A5)
	DCB	13,$4E71
	MOVE    a6,(A6)
	MOVE.B  #0,(A6)
	DCB	12-4,$4E71
	dbf	d0,ful
	SUBQ	#1,PTITE_PAUSE
	BNE.S	.NOF
	MOVE	#5,PTITE_PAUSE
	MOVE.L	#VBL,$70.W
.NOF	JMP	VBL_S
PTITE_PAUSE	DC	5
SAVE	DS.L	16
RELOC
	LEA	buf2,A0
	TST	FLAG_POURRI
	BEQ.S	.E
	LEA	FNT,A0
.E	MOVE.L	A0,A1
	ADD.L	2(A0),A1
	ADD.L	6(A0),A1
	LEA	31(A1),A1
	MOVEQ	#0,D0

	LEA	buf2+28,A0
	TST	FLAG_POURRI
	BEQ.S	.E2
	LEA	FNT+28,A0
.E2	MOVE.L	A0,D1
	
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

VBL_FLAG	DC	0
TIME	DC	4
	dc	$9999
	DCB	5,$101
FAD_1	DC	$101,$212,$323,$434,$545,$656
FAD_2	DC	$777
	DC	$9999
FIN	MOVE	#$700,$FFFF8240.W
	MOVE	#$2700,SR
.Z	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	.Z
	JMP	RESET_RT
GERE_FNT	
	JSR	EFF_êCRAN
	CLR	FLAG
	CLR	MOD_OFFSET
	CLR	MOD_ROX
	CLR	X
MOD_MES	EQU	*+2
	LEA	MSG,A6
DEBUT	MOVEQ	#0,D6
	MOVE.B	(A6)+,D6
	CMPI.B	#$99,D6
	BNE.S	AZERTY
	MOVE.L	#MSG,MOD_MES
	MOVE.L	#DATA_FILES,MODADRDEP
	JMP	GERE_FNT
AZERTY	CMPI.B	#-10,D6
	BNE.S	.OUF
	MOVE	#1,FLAG_POURRI
	BRA	FINI3
.OUF	CMPI.B	#-1,D6
	BEQ	FINI3
	CMPI.B	#-3,D6
	BEQ	FINI4
	CMPI.B	#-4,D6
	BEQ	FINI5
	CMPI.B	#-5,D6
	BEQ	FINI6

	CMPI.B	#-2,D6
	BNE.S	.P
	CLR	X
	ADD	#160*14,MOD_OFFSET
	BRA.S	DEBUT
.P	SUBI.B	#$20,D6
	BNE.S	.NOT_ESP
	ADDQ	#8,X
	BRA.S	DEBUT
.NOT_ESP	ADD	D6,D6
	ADD	D6,D6
	LEA	TABL_FNT,A5
	MOVE.L	(A5,D6.W),A1

	LEA	BUF_FNT,A0
;	LEA	FNT+34,A1
	MOVE	#15,D0
.R	MOVE	(A1),(A0)+
	LEA	160(A1),A1
	DBF	D0,.R

	LEA	SAVER,A2
	MOVE.L	SCREEN,A1
	LEA	160*70(A1),A1
MOD_OFFSET	EQU	*+2
	LEA	0(A1),A1

	MOVE	X,D2
	MOVE	D2,D4
	LSR	#4,D2
	MOVE	D2,D7
	LSL	#4,D7
	SUB	D7,D4
	LSL	#3,D2
	ADD	D2,A1
	MOVE	D4,MOD_ROX

	LEA	BUF_FNT,A0
	MOVE	#16-1,D7
.DO_IT	MOVEQ	#0,D4
	MOVEQ	#0,D1
	MOVEQ	#0,D3
	MOVEQ	#16,D2
	MOVE	(A0)+,D0
.BIT_OFF	SUBQ	#1,D2
	ADDQ	#1,D1
	CMPI	#-1,D2
	BEQ.S	.END_
	BTST	D2,D0
	BEQ.S	.BIT_OFF
	MOVE	D1,D3
	BSET	D2,D4
	BRA.S	.BIT_OFF
.END_
	SWAP	D4

	MOVEQ	#0,D2
MOD_ROX	EQU	*+2
	MOVE	#0,D2
	BEQ.S	.ROOL
	SUBQ	#1,D2
.J	ROXR.L	D4
	DBF	D2,.J

.ROOL	MOVE	D4,8(A1)
	SWAP	D4
	OR	D4,(A1)

;	MOVE	D4,(A1)
	MOVE	D3,(A2)+
	LEA	160(A1),A1
;	LEA	160(A0),A0
	DBF	D7,.DO_IT
FINI	MOVE	#$9999,(A2)
	NOP

	LEA	SAVER,A0
.CONT2	MOVE	(A0),D0
.CONT	ADDQ	#2,A0
	CMPI	#$9999,(A0)
	BEQ.S	FINI2
	CMP	(A0),D0
	BGE.S	.CONT
	BRA.S	.CONT2
FINI2	NOP
	ADDQ	#1,D0
	ADD	D0,X
	BRA	DEBUT
FINI4	MOVE	#1,FLAG
FINI3	MOVE.L	SAVE_ANCIENT,SAVE_ANCIENT2
	MOVE.L	MOD_MES,SAVE_ANCIENT
	MOVE.L	A6,MOD_MES
	RTS
SAVE_ANCIENT	DC.L	0
SAVE_ANCIENT2	DC.L	0
FINI5	MOVE	#2,FLAG
	BRA.S	FINI3
FINI6	
	lea	buf2,a0
	lea	$e7960,a1
zer2	clr.l	(a0)+
	cmp.l	a1,a0
	ble.s	zer2

	BRA.S	FINI3
FLAG	DC	0

	;DATA
MSG
 dc.b ' HERE COMES THE INTRO...',-1

 DC.B ' -- LET"S GO !!! --',-10

 DC.B ' DRAGONBALL IS GOOD ',-2
 DC.B '      FOR YOU !',-1

 dc.b ' HERE IS WHAT THEY SAY...',-1

 DC.B ' MADOKA SAYS...',-1
 
 DC.B ' HOLOCAUST FOREVER !',-1
 
 DC.B ' FULLSCREEN...',-2
 DC.B ' REALTIME...',-2
 DC.B ' 3D DOTS...',-2
 DC.B ' -EAT THIS!-',-1

 DC.B ' WOW! PREVIOUS SCREEN WAS',-2
 DC.B ' REALLY GOOD !!',-1
 
 DC.B ' CUBES EVERYWHERE...',-2,-2
 DC.B '   THE RETURN!',-1
 
 DC.B ' EXTENDED TUNNEL...',-2,-2
 DC.B ' HARD CODE!',-10
 
 DC.B ' FULLSCREEN RULES! ',-1
 
 DC.B '        -- RISING FORCE --     ',-2,-2
 DC.B '            BY HOLOCAUST',-1
 dc.b 'AND NOW... ',-2
 DC.B '   A 1200-DOTS FULL-TUNNEL...',-1
 dc.b ' W E    L O V E    M A D O K A !',-1
 DC.B 'WELL...FULLSCREEN IS BETTER !',-2,-2
 DC.B '  THIS IS A FRENCH DEMO! ',-5
 DC.B 'LET US HAVE SOME PRECALCULS..',-2
 DC.B '  CONTROL THE FLY WITH ARROW',-2
 DC.B '  KEYS-INSERT-CLR HOME-ESC-1',-2
 dc.b '  YOU SHOULD STAND TWO METERS',-2
 DC.B '   IN FRONT OF YOUR MONITOR',-2
 DC.B '      TO SEE THIS PART...',-2
 DC.B '       ...PLEASE WAIT...',-3



 dc.b '        -- THE CREDITS --',-4
 dc.b '    2048-STARS-INTRO BY ELRIC',-2
 DC.B '          BETTER THAN',-2
 dc.b '        SANITY"S ONES!!!',-4
 dc.b '      FALLING CUBES BY ZAPPY',-4
 dc.b '         1200-DOTS TUNNEL',-2
 dc.b '          BY ELRIC-ZAPPY',-4
 dc.b '       DOT SPHERES BY ELRIC',-4
 dc.b '      VECTORBLAST BY ZAPPY',-4
 dc.b '   RIDICULOUS RUBBER BY ZAPPY',-4
 dc.b '   OBVIOUS DISASTER SCROLLER',-2,-2
 DC.B '               BY ELRIC',-4
 DC.B '  FRACTAL MOUNTAINS BY ZAPPY',-2
 DC.B '   THERE ARE 4096 DOTS IN 16',-2
 DC.B '             COLORS...',-4
 dc.b '      LAST EFFECT BY ELRIC',-4
 dc.b '          FONTS BY ZAPPY',-4
 dc.b '     ...AND MUSIX BY -JESS-',-2,-2
 DC.B '      OF --OVERLANDERS-- !',-4

 dc.b '       -- THE GREETINGS --',-4

 dc.b '            - LEGACY -',-2,-2
 DC.B '       HI FRED! NICE WORK!',-4

 dc.b '         - OVERLANDERS -',-2,-2
 DC.B '     YOHO ZIGGY! SNES RULES!',-4

 DC.B '            - MCODER -',-2,-2
 DC.B '       OUR OBVIOUS DISASTER',-2
 DC.B '            CONVERSION',-2
 DC.B '         IS IN FULLSCREEN...',-2
 DC.B '              HEY HEY...',-4
 
 DC.B '           - ABSTRACT -',-2,-2
 DC.B '       ON S"EN B... MARCEL!',-4
 
 DC.B '             - DUNE -',-2,-2
 DC.B '    VERY NICE CRYSTAL II  GUYS!!',-4
 
 DC.B '           - MJJ PROD -',-2,-2
 DC.B '             HI NIKO!',-4
 
 DC.B '           - EQUINOX -',-2,-2
 DC.B '    HI KEOPS! WE ARE CODING A',-2
 DC.B '         SURPRISE FOR YOU...',-2
 DC.B '          WAIT AND SEE!',-4
 
 DC.B '          - HEMOROIDS -',-2,-2
 DC.B '      GRRR! TWO FALCONS....!!!',-2,-2
 DC.B '  SPECIAL HI TO CORWIN -HMD PC-',-4
 
 DC.B '           - PULSION -',-2,-2
 DC.B '        HI TO ALL OF YOU!',-2,-4
 
 DC.B '           AND TO...',-4
 DC.B '   OXYGENE-RICKST-CREATEUR',-4
 DC.B '     RBOY-ODIN-KHELT-BRAIN',-4
 DC.B '      BIEX-SKAVEN-ALTAIR',-4
 DC.B '       SARAYAN-TOUBAB-AL',-4
 DC.B '   MANU ST FROM AUTHENTIK...',-4
 DC.B '       AND TO KILLER D...',-4
 
 DC.B ' OK GUYS... SHOW OVER... ',-2
 DC.B ' WAIT FOR -JAPTRO!-',-1

 DC.B '       WE WANT MORE !',-4
 DC.B 'HERE COMES BONUS SCREENS!',-4
 DC.B '   LET"S MEET -MADOKA-!!!',-1

 DC.B 'OK. NOW IT IS REALLY OVER.',-4
 DC.B '    IT WAS -RISING FORCE-',-2,-2
 DC.B '     SPECIAL PREVIEW FOR',-2,-2
 DC.B '        ABSTRACT!!!',-4

 DC.B 'OUR NEXT DEMO IS',-2,-2
 DC.B 'NEARLY FINISHED !',-4
 
 DC.B '      TO BE RELEASED...',-4

; DC.B '   AND --- O N L Y ---',-2
; DC.B '        FOR THEM!!!',-4
; DC.B '   DO -NOT- SWAP IT!!!',-4
; DC.B '    TO BE CONTINUED...',-4
 
 DC.B $99
	EVEN
ERROR
 DC.B ' DISK ERROR! ',-2
 DC.B 'LOADED DATAS ARE NOT PACKED!',-2
 DC.B 'CHECK DISK AND PRESS SPACE.',-1
	EVEN

TABL_FNT	
	DC.L	FNT+34+160*16+120	ESPACE
	DC.L	FNT+34+160*16+120-16-8	!
	DC.L	FNT+34+160*16+120-8-8	"
	REPT	10
	DC.L	FNT+34
	ENDR
	DC.L	FNT+34+160*16*2+8*10
	
	DC.L	FNT+34+160*16+120-24-8	.
	DC.L	FNT+34	
	
	DC.L	FNT+34+160*32+9*8	0
N	SET	0
	REPT	9
	DC.L	FNT+34+160*32+N
N	SET	N+8
	ENDR

	REPT	31-13-1-10
	DC.L	FNT+34
	ENDR
N	SET	0
	REPT	15
	DC.L	FNT+34+N
N	SET	N+8
	ENDR
N	SET	0
	REPT	11
	DC.L	FNT+34+160*16+N
N	SET	N+8
	ENDR

SAVE_ANT	DC.L	0
CHARGEZ
	CLR.L	AJOUT
MODADRDEP	EQU	*+2
	LEA	DATA_FILES,A0
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	;MOVE	#FACE_INIT,D0	FACE
	;MOVE	#PIST_INIT,D1	PISTE
	;MOVE	#BLOC_INIT,D2	SECT A LIRE
	MOVE	(A0)+,D0
	MOVE	(A0)+,D1
	MOVE	(A0)+,D2
	MOVE	(A0)+,OFF7_DEP
	MOVE.L	(A0)+,TAILLE
	MOVE.L	MODADRDEP,SAVE_ANT
	MOVE.L	A0,MODADRDEP
	JSR	TRACK_LOADING
	LEA	ADR_LOAD,A0
OFF7_DEP	EQU	*+2
	LEA	0(A0),A0
	
	;LEA	DECRUNCHMES,A1
	;MOVE.L	SCREEN1,A2
	;LEA	160*(50+6*8)(A2),A2
	;JSR	AF_LIGNE

	;JSR	D_PACK
	;CMPI.L	#9,NUM_DEM
	;BEQ.S	NOREL
	;JSR	RELOC
;NOREL	MOVE	#$2300,SR
;	JMP	ADR_LOAD
	NOP
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
	JSR	LOADING
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
	BEQ.S	FINIz
	TST	D5
	BEQ.S	FINIz
	MOVE	D5,(A0)
	JSR	LOADING
	BRA.S	FINIz
PAS_PLUS_DE_10	MOVE	D2,(A0)
	JSR	LOADING
FINIz	RTS

LOADING
;	lea	ADR_LOAD.W,a0
	LEA	ADR_LOAD,A0
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


DATA_FILES
;*SPHERE
;	DC	FACE_INIT
;	DC	PIST_INIT+(5202+22684+54240+15176+7696+12012)/5120
;	DC	(9464/512)+11
;	DC	(5202+22684+54240+15176+7696+12012)-((5202+22684+54240+15176+7696+12012)/5120)*5120
;	DC	9464

;*STARS INTRO
;	DC	FACE_INIT	FACE
;	DC	PIST_INIT+(5202+22684+54240+15176+7696)/5120	PISTE
;	DC	(12012/512)+11	NB DE BLOCS A LIRE
;	DC	(5202+22684+54240+15176+7696)-((5202+22684+54240+15176+7696)/5120)*5120
;	DC	12012

* Labyrinthe/fin de l'intro
	DC	FACE_INIT
	DC	PIST_INIT+((28952)/5120)
	DC	(59672/512)+11
	DC	28952-((28952/5120)*5120)
	DC.L	59672
* "Total"
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464)/5120)
	DC	(31598/512)+11
	DC	(28952+59672+15802+8464)-((28952+59672+15802+8464)/5120)*5120)
	DC.L	31598
* Image DBZ
	DC	FACE_INIT
	DC	PIST_INIT
	DC	(28952/512)+11
	DC	0
	DC.L	28952
* Logo + Samples
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464+31598+23838+5842)/5120)
	DC	(70052/512)+11
	DC	(28952+59672+15802+8464+31598+23838+5842)-((28952+59672+15802+8464+31598+23838+5842)/5120)*5120)
	DC.L	70052
* Drapeau
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802)/5120)
	DC	(8464/512)+11
	DC	(28952+59672+15802)-((28952+59672+15802)/5120)*5120)
	DC.L	10000	;8464
* Logo + Samples
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464+31598+23838+5842)/5120)
	DC	(70052/512)+11
	DC	(28952+59672+15802+8464+31598+23838+5842)-((28952+59672+15802+8464+31598+23838+5842)/5120)*5120)
	DC.L	70052
* Cube full/dots
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464+31598)/5120)
	DC	(23838/512)+11
	DC	(28952+59672+15802+8464+31598)-((28952+59672+15802+8464+31598)/5120)*5120)
	DC.L	24000
* Logo + Samples
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464+31598+23838+5842)/5120)
	DC	(70052/512)+11
	DC	(28952+59672+15802+8464+31598+23838+5842)-((28952+59672+15802+8464+31598+23838+5842)/5120)*5120)
	DC.L	70052
* Cubes full
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464+31598+23838)/5120)
	DC	(5842/512)+11
	DC	(28952+59672+15802+8464+31598+23838)-((28952+59672+15802+8464+31598+23838)/5120)*5120)
	DC.L	5842
* Extended Tunnel
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672)/5120)
	DC	(15802/512)+11
	DC	(28952+59672)-((28952+59672)/5120)*5120)
	DC.L	15802
*****
* Logo + Samples
	DC	FACE_INIT
	DC	PIST_INIT+((28952+59672+15802+8464+31598+23838+5842)/5120)
	DC	(70052/512)+11
	DC	(28952+59672+15802+8464+31598+23838+5842)-((28952+59672+15802+8464+31598+23838+5842)/5120)*5120)
	DC.L	70052


depack:	movem.l	d0-a6,-(a7)
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
	bsr	copy_decrun
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
	JSR	FAD2
	MOVE.L	#BUF,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN
	move.l	SCREEN,d0
	lsr.l	#8,d0		
	LEA	$FFFF8201.W,A0
	movep	d0,(a0)
	CLR	MOD1
	CLR	MOD2
	;MOVE.L	MOD_MES,-(SP)
	MOVE.L	#ERROR,MOD_MES
	JSR	GERE_FNT
	;MOVE.L	(SP)+,MOD_MES
	MOVE.L	SAVE_ANCIENT2,MOD_MES
	JSR	FAD1
.WAIT_AGAIN	
	JSR	VSYNC
	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	.WAIT_AGAIN
	JSR	FAD2
	MOVE.L	SAVE_ANT,MODADRDEP
	movem.l	(a7)+,d0-a6
	PEA	ADR_RETOUR
	RTS
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

RT_ZIK	MOVEM.L	D0-A6,SAVE
	JSR	ZIK+8
	MOVEM.L	SAVE,D0-A6
	RTS
ZIK	INCBIN	a:\TLB.SND
GFX	INCBIN	a:\FNT.PAK
	EVEN

	BSS
	DS.L	256
NEWPILE	DS.L	1
X	DS	1
BUF_FNT	DS	16
SCREEN	DS.L	1
SAVER	DS	16+1
FNT	DS.B	32066
	DS.B	256
BUF	DS.B	32000
buf2	ds.b	80000
tst