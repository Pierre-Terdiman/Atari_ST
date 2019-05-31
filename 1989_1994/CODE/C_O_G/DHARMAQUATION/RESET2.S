PT_DEPART = 0
NB_STARS = 300
VITESSE = 4

P = 256
P_DEC = 8
X_CENTER = 60
Y_CENTER = 100

LIM_Z_1 = 65
LIM_Z_2 = 300

SHOW_TIME = 0
ROTATION = 1

CLIP_HAUT = 0
CLIP_BAS = 190
CLIP_DROIT = 319
CLIP_GAUCHE = 0

speed	EQU 60	; timer d (pre-div 4)

	OPT O+,OW-

ON_COMMENCE:
	LEA	my_stack,SP

	MOVE.L	#FINISHED,$008.w	
	MOVE.L	#FINISHED,$00C.w	
	MOVE.L	#FINISHED,$010.w	
	MOVE.L	#FINISHED,$014.w	
	MOVE.L	#8,NB_PART

	LEA	CHOICE,A0
	LEA	TABLE1,A1
	MOVE.L	A0,(A1)+
CHERCHE	CMPI	#$4E75,(A0)+
	BNE.S	CHERCHE
	CMPI	#$9999,(A0)
	BEQ.S	CHERCHE_PLUS
	MOVE.L	A0,(A1)+
	BRA.S	CHERCHE
CHERCHE_PLUS	LEA	OF,A0
	LEA	TABLE2,A1
	MOVE.L	A0,(A1)+
CHERCHE2	CMPI	#$4E75,(A0)+
	BNE.S	CHERCHE2
	CMPI	#$9999,(A0)
	BEQ.S	CHERCHE_PLUS2
	MOVE.L	A0,(A1)+
	BRA.S	CHERCHE2
CHERCHE_PLUS2	LEA	GODS,A0
	LEA	TABLE3,A1
	MOVE.L	A0,(A1)+
CHERCHE3	CMPI	#$4E75,(A0)+
	BNE.S	CHERCHE3
	CMPI	#$9999,(A0)
	BEQ.S	CHERCHE_PLUS3
	MOVE.L	A0,(A1)+
	BRA.S	CHERCHE3
CHERCHE_PLUS3
	MOVE.L	#OFFSET_TABLE,-(SP)
	MOVE.L	#BUF_STARS,-(SP)
	MOVE.L	#DATA_STARS,-(SP)
	MOVE.L	#PT_STARS,-(SP)
	JSR	CALCULE_STARS

	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1
	add.l	#32000,d0		
	move.l	d0,SCREEN2

	MOVE	#$777,$FFFF8242.W
	MOVE	#$777,$FFFF8250.W
	
	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	LEA	TABLE1,A1
	MOVE.L	(A1),A1
	MOVEM.L	(A1),D0-D6
	MOVE.L	SCREEN1,A0
	JSR	7*4(A1)
	
	LEA	TABLE1+4,A2
	MOVE.L	A2,SAVEA2

	MOVE.L	#VBL_DEBUT,$70.W
	CLR.L	$42A.W
	CLR.L	$426.W
	
	JSR	Wait_Vbl
	JSR	Init_Voltab

	JSR	Wait_Vbl

	LEA	mt_data,A0
	JSR	mt_init

	JSR	init_ints
	MOVE.L	#TB0_IR,$120.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

WAIT	BRA.S	WAIT

	OPT	O+
	
VBL_DEBUT	MOVE.L	#1,$140.W
	RTE	

init_ints	MOVEQ #$13,D0	; pause keyboard
	BSR Writeikbd	; (stop from sending)
	MOVE #$2700,SR
	CLR.B $fffffa07.W
	MOVE.B #$50,$fffffa09.W
	CLR.B $fffffa13.W
	MOVE.B #$50,$fffffa15.W
	BCLR.B #3,$fffffa17.W
	MOVE.B #0,$FFFFFA1D.W
	MOVE.B #speed,$FFFFFA25.W
	MOVE.B #1,$FFFFFA1D.W
	MOVE.L	#VBLSTARS,$70.W
	MOVE.L	#key_rout,$118.W
	MOVE #0,D0
	BSR Select_PlayRout
	CLR key	
	LEA sndbuff1(PC),A1
	MOVE #$2300,SR
	MOVEQ #$11,D0
	BSR Writeikbd
	MOVEQ #$12,D0
	BSR Writeikbd
	BSR flush
	RTS


Wait_Vbl	TST.L	$140.W
	BEQ.S	Wait_Vbl
	clr.l	$140.W
	RTS

; Flush IKBD

flush	BTST.B #0,$FFFFFC00.W	; any waiting?
	BEQ.S .flok	; exit if none waiting.
	MOVE.B $FFFFFC02.W,D0	; get next in queue
	BRA.S flush	; and continue
.flok	RTS

; Write d0 to IKBD

Writeikbd	BTST.B #1,$FFFFFC00.W
	BEQ.S Writeikbd	; wait for ready
	MOVE.B D0,$FFFFFC02.W	; and send...
	RTS

; Keyboard handler interrupt routine...

key_rout	MOVE #$2500,SR	; ipl 5 for 'cleanness' 
	MOVE D0,-(SP)
	MOVE.B $FFFFFC00.W,D0
	BTST #7,D0	; int req?
	BEQ.S .end	
	BTST #0,D0	; 
	BEQ.S .end
	MOVE.B $FFFFFC02.W,key	; store keypress
.end	MOVE (SP)+,D0
	RTE
key	DC.W 0

; The vbl - calls sequencer and vbl filler.

TB0_IR	MOVE	#$001,$FFFF8240.W
	CLR.B	$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
	RTE	
TIME_	DC.L	0
VBLSTARS	MOVEM.L	D0-D6/A0/A2-A6,-(SP)
	MOVE.L	#1,$140.W
	MOVE.L	SAVEA2,A2

	MOVE.L	(A2)+,A3
	CMPI.L	#0,-4(A2)
	BNE.S	ROUL
	CLR.L	PNT_FAD
	ADDQ.L	#1,PNT_3D
	CMPI.L	#1,PNT_3D
	BNE.S	NOT_1
	LEA	TABLE2,A2
	BRA.S	GO_GO
NOT_1	CMPI.L	#2,PNT_3D
	BNE.S	NOT_2
	LEA	TABLE3,A2
	BRA.S	GO_GO
NOT_2	CLR.L	PNT_3D
	LEA	TABLE1,A2
GO_GO	MOVE.L	(A2)+,A3
ROUL	MOVEM.L	(A3),D0-D6
	MOVE.L	SCREEN1,A0
	JSR	7*4(A3)
	MOVE.L	A2,SAVEA2
	LEA	COLORS,A2
	ADDA.L	PNT_FAD,A2
	MOVE	(A2),MODCOL
	ADDQ.L	#2,PNT_FAD
	
	SF	$FFFF8240.W
MODCOL	EQU	*+2
	MOVE	#$777,$FFFF8242.W
	MOVE	MODCOL,$FFFF8250.W
	MOVE	#$444,$FFFF8244.W
	MOVE	#$222,$FFFF8248.W
	MOVE	#$111,$FFFF824C.W

;	CMPI	#$444,MODCOL
;	BLE.S	STAR_GAGNE
	MOVE	MODCOL,$FFFF8246.W
;	BRA.S	SAUT1_
;STAR_GAGNE	MOVE	#$444,$FFFF8246.W
;SAUT1_	CMPI	#$222,MODCOL
;	BLE.S	STAR_GAGNE2
	MOVE	MODCOL,$FFFF824A.W
;	BRA.S	SAUT2
;STAR_GAGNE2	MOVE	#$222,$FFFF824A.W
;SAUT2	CMPI	#$111,MODCOL
;	BLE.S	STAR_GAGNE3
	MOVE	MODCOL,$FFFF824E.W
;	BRA.S	SAUT3
;STAR_GAGNE3	MOVE	#$111,$FFFF824E.W
SAUT3
	ST	$FFFF8252.W
	ST	$FFFF8254.W
	ST	$FFFF8258.W
	ST	$FFFF8258.W
	ST	$FFFF825A.W
	ST	$FFFF825C.W
	ST	$FFFF825E.W
GNOPS
	CMPI.L	#8,NB_PART
	BNE	SUITV0
	BSR	TEST_LET
	CLR.L	NB_PART
SUITV0	BSR	SCROLL
	BSR	SCROLL

VBL	
	MOVE.L	PT_STARS,A4
	MOVE.L	-4(A4),A0
	MOVE.L	SCREEN1,A2
	LEA	2(A2),A2
	MOVEQ	#0,D0
	MOVE.W	(A0)+,D6
CONT_EFF	ADDQ.W	#4,A0
	MOVE.W	(A0)+,D1
	MOVE.L	D0,(A2,D1.W)
	DBRA	D6,CONT_EFF

	MOVE.L	(A4)+,A0
	MOVE.W	(A0)+,D6
CONT_AFF	MOVE.L	(A0)+,D0
	MOVE.W	(A0)+,D1
	OR.L	D0,(A2,D1.W)
	DBRA	D6,CONT_AFF

	CMPA.L	#FIN_TABLE,A4
	BNE.S	PAS_FINI_STARS
	LEA	OFFSET_TABLE,A4
PAS_FINI_STARS	MOVE.L	A4,PT_STARS
;	MOVEM.L D0-D6/A0/A2-A6,-(SP)
VBL_SUITE	BSR Vbl_play
	BSR mt_music	
	MOVEM.L (SP)+,D0-D6/A0/A2-A6
	SF	$FFFF8240.W
	;CMPI.B	#$39,$FFFFFC02.W
	;BEQ.S	FINISHED
	RTE
FINISHED	MOVE.L	4.W,A0
	JMP	(A0)
;VBL_PLAY	MOVEM.L	D0-D6/A0/A2-A6,-(SP)
;	BRA.S	VBL_SUITE
; Vbl player - this is a kind of 'Paula' Emulator(!)

Vbl_play:	MOVEA.L	buff_ptr(PC),A4
	MOVE.L A1,D0	; current pos in buffer
	CMP.L #endbuff1,d0
	BNE.S .norm
	MOVE.L #sndbuff1,d0	; wooky case(at end of buf)
.norm	MOVE.L D0,buff_ptr
	SUB.L A4,D0
	BEQ skipit
	BHI.S higher
	ADDI.W #$800,D0	; abs
higher	LSR.W #1,D0
	MOVE.L #endbuff1,D1
	SUB.L A4,D1
	LSR.W #1,D1
	CLR.W fillx1	; assume no buf overlap
	CMP.W D1,D0	; check for overlap
	BCS.S higher1
	MOVE.W D1,fillx1	; ok so there was overlap!!
higher1	SUB.W fillx1(PC),D0	; subtract any overlap
	MOVE.W D0,fillx2	; and store main
; A4 points to place to fill
	LEA freqs(PC),A3	; int.w/frac.w freq tab

.voices_1_2	MOVE.L #sndbuff1,buffbase	
	LEA.L ch1s(PC),A5
	MOVE.W amove(pc),D0
	BSR add1	; move voice 1
	LEA.L ch2s(PC),A5
	MOVE.W aadd(pc),D0
	BSR add1	; add voice 2

	LEA $802(A4),A4
.voices_3_4	MOVE.L #sndbuff2,buffbase	
	LEA.L ch3s(PC),A5	
	MOVE.W amove(pc),D0
	BSR add1	; move voice 3	
	LEA.L ch4s(PC),A5	
	MOVE.W aadd(pc),D0
	BSR add1	; add voice 4		; add voice 4
	RTS

; Routine to add/move one voice to buffer. The real Paula emulation part!!

add1	PEA (A4)	; save buff pos
	LEA moda(PC),A2
	MOVE.W D0,(A2)
	MOVE.W D0,modb-moda(A2)	; self modifying
	MOVE.W D0,modc-moda(A2)	; add/move code(see below)
	MOVE.W D0,modd-moda(A2)	
	MOVE.W D0,mode-moda(A2)	
	MOVE.L (A5),A2	; current sample end address
	MOVEM.W 6(A5),D1/D2	; period/volume
	ADD.W D1,D1
	ADD.W D1,D1	; *4 for lookup
	MOVEM.W 0(A3,D1),D1/D4	; get int.w/frac.w
	MOVE.L voltab_ptr(PC),A6	; base of volume table
	LSL.W #8,D2
	ADD.W D2,A6	; ptr to volume table
	MOVEQ #0,d5
	MOVE.W 4(A5),d5	; sample length
	CMP.L #nulsamp+2,A2
	BNE.S .vcon
	MOVEQ.L	#0,D4	; channel is off.
	MOVEQ.L	#0,D1	; clear all if off.
	MOVE.L voltab_ptr(PC),A6	; zero vol(safety!!)
	CLR.W 16(A5)	; clear frac part
.vcon	NEG.L d5
	MOVE.L A6,D6	; vol ptr
	MOVEQ.L	#0,D2	; clr top byte for sample
; Setup Loop stuff
	MOVE.L 10(a5),A0	; loop addr
	MOVEQ #0,D3
	MOVE.W 14(a5),D3	; loop length
	NEG.L D3
	MOVEM.W D1/D4,loopfreq
	CMP.L #-2,D3
	BNE.S isloop
noloop	MOVE.L D2,loopfreq	; no loop-no frequency
	LEA nulsamp+2(PC),A0	 	; no loop-point to nul
isloop	MOVE.L D3,looplength
	MOVE.W 16(A5),D3	; clear fraction part
	MOVE.W fillx1(PC),D0
	BSR.S addit	; 
	MOVE.W fillx2(PC),D0
	TST.W fillx1
	BEQ.S nores
	MOVE.L buffbase(PC),A4	; buffer base
nores	BSR.S addit
	NEG.L d5	; +ve offset(as original!)
	MOVE.L A2,(A5)	; store voice address
	MOVE.W d5,4(A5)	; store offset for next time
	MOVE.W D3,16(A5)	; clear fraction part
skipit	MOVE.L (SP)+,A4
	RTS
	
; Add D0 sample bytes to buffer

addit	MOVE.W D0,donemain+2	; lets go!!
	LSR #2,D0	; /4 for speed
	SUBQ #1,D0	; -1 (dbf)
	BMI.S donemain	; none to do?
makelp	MOVE.B (A2,d5.L),D6	; fetch sample byte
	MOVE.L D6,A6
	MOVE.B (A6),D2	; lookup in vol tab
moda	ADD.W D2,(A4)+	; add/move to buffer(self modified)
	ADD.W D4,D3	; add frac part
	ADDX.W D1,d5	; add ints.(carried thru)
	BCS.S lpvoice1	; voice looped?
CONT1	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
modb	ADD.W D2,(A4)+
	ADD.W D4,D3	; 
	ADDX.W D1,d5
	BCS.S lpvoice2
CONT2	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
modc	ADD.W D2,(A4)+
	ADD.W D4,D3	;
	ADDX.W D1,d5
	BCS lpvoice3
CONT3	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
modd	ADD.W D2,(A4)+	;
	ADD.W D4,D3
	ADDX.W D1,d5
CONT4	DBCS  D0,makelp
	BCS lpvoice4
donemain	MOVE.W #0,D0
	AND #3,D0	; remaining bytes.
	SUBQ #1,D0
	BMI.S yeah
niblp	MOVE.B (A2,d5.L),D6
	MOVE.L D6,A6
	MOVE.B (A6),D2
mode	ADD.W D2,(A4)+
	ADD.W D4,D3
	ADDX.W D1,d5
CONT5	DBCS D0,niblp
	BCS lpvoicelast
yeah	RTS

buffbase	DS.L 1
loopfreq:	DS.W 2
looplength:	DS.L 1
voltab_ptr	DS.L 1

lpvoice	MACRO
	MOVE.L A0,A2 
	EXT.L D5
	ADD.L looplength(PC),D5	; fetch loop constants
	MOVEM.W loopfreq(PC),D1/D4	; (channel independent)
	MOVEQ #0,D2
	MOVE D2,CCR	
 	BRA \1
	ENDM

lpvoice1:	lpvoice CONT1	;
lpvoice2:	lpvoice CONT2	; loop routs
lpvoice3:	lpvoice CONT3	; (since code is repeated)
lpvoice4:	lpvoice CONT4	;
lpvoicelast:	lpvoice CONT5	;

aadd	ADD.W D2,(A4)+
amove	MOVE.W D2,(A4)+

nulsamp	ds.l 2	; nul sample.
buff_ptr:	dc.l 0
sndbuff1:	ds.w $400	; buffer for voices 1+2
endbuff1:	dc.w -1
sndbuff2	ds.w $400	; buffer for voices 3+4
endbuff2	dc.w -1

fillx1:	DC.W 0
fillx2:	DC.W 0


temp:	dc.l	0
setsam_dat:	dc.w	%0000000011010100  	;mastervol
	dc.w	%0000010010000110  	;treble
	dc.w	%0000010001000110  	;bass
	dc.w	%0000000000000001  	;mixer

; Select The Playback Routine D0.W = 0 to 6

Select_PlayRout:MOVE.W SR,-(SP)
	MOVE #$2700,SR
	MOVE.L Output_Routs,$110.W
	JSR rout_tab
	MOVE.W (SP)+,SR
	RTS

rout_tab	BRA.W YM2149_Setup

Which_replay	DC.W 0	; 0 - 6 as below
Output_Routs	DC.L YM2149_Player

; YM2149 Setup rout - turns off ste dma(if machine is st) and clears YM.

YM2149_Setup:	
	BSR Initsoundchip	; init soundchip
	RTS

; Ste Stereo Setup rout - turns off YM 2149 and setsup dma.

; Setup rout for all other output routs - kills both dma and YM sound.

Internal_Off:	
	BSR Killsoundchip
 	RTS

; YM2149 Soundchip output.

YM2149_Player:	move.w (a1)+,d7
	bmi.s .loopit
.contsnd	add.w $800(a1),d7
	lsl #3,d7
	move.l a1,usp
	lea $ffff8800.w,a1	; output
	move.l sound_look+4(pc,d7.w),(a1)
	move.l sound_look(pc,d7.w),d7	; using quartet table.
	movep.l d7,(a1)
	move.l usp,a1
	rte
.loopit	lea sndbuff1(pc),a1
	move.w (a1)+,d7
	bra.w .contsnd
sound_look:	incbin quarfast.tab


; ST specific initialisation routines - sets up shadow amiga registers.

STspecific:	LEA  nulsamp+2(PC),A2
	MOVEQ #0,D0
	LEA ch1s(pc),A0
	BSR initvoice
	LEA ch2s(pc),A0
	BSR initvoice	;init shadow regs
	LEA ch3s(pc),A0
	BSR initvoice
	LEA ch4s(pc),A0
	BSR initvoice
	LEA sndbuff1(PC),A0
	MOVE.L A0,buff_ptr
	LEA sndbuff2(PC),A1
	MOVEQ.L	#0,D1
	MOVEQ #$7F,D0
.setbuf1	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+	; clear 2 ring buffers
	MOVE.L	D1,(A1)+
	MOVE.L	D1,(A1)+
	MOVE.L	D1,(A1)+
	MOVE.L	D1,(A1)+
	DBF D0,.setbuf1
	RTS
initvoice:	MOVE.L A2,(A0)	; point voice to nul sample
	MOVE.W #2,4(A0)	
	MOVE.W D0,6(A0)	; period=0
	MOVE.W D0,8(A0)	; volume=0
	MOVE.L A2,10(A0)	; and loop point to nul sample
	MOVE.W #2,14(A0)
	MOVE.W D0,16(A0)	; clear fraction part.
	RTS

; Initialise Soundchip

Initsoundchip:	LEA $FFFF8800.W,A0
	MOVE.B #7,(A0)	; turn on sound
	MOVE.B #$c0,D0
	AND.B (a0),D0
	OR.B #$38,D0
	MOVE.B d0,2(a0)
	MOVE.W #$0500,d0	; clear out ym2149
.initslp	MOVEP.W	d0,(a0)
	SUB.W #$0100,d0
	BPL.S .initslp
	RTS

; Reset sound chip

Killsoundchip	MOVE.W D0,-(SP)
	MOVE.B #7,$ffff8800.W	
	MOVE.B #7,D0
	OR.B $ffff8800.W,D0
	MOVE.B D0,$ffff8802.W
	MOVE.W (SP)+,D0
	RTS

; Make sure Volume lookup table is on a 256 byte boundary.

Init_Voltab	LEA vols+256(PC),A0
	MOVE.L A0,D0
	CLR.B D0
	LEA voltab_ptr(PC),A1
	TST.L (A1)
	BNE.S .alreadyinited
	MOVE.L D0,(A1)
	MOVE.L D0,A1
	MOVE.W #(16640/16)-1,D0
.lp	MOVE.L (A0)+,(A1)+
	MOVE.L (A0)+,(A1)+
	MOVE.L (A0)+,(A1)+
	MOVE.L (A0)+,(A1)+
	DBF D0,.lp
.alreadyinited	RTS


; Shadow Amiga Registers.
	
ch1s	DS.W 9
ch2s	DS.W 9
ch3s	DS.W 9
ch4s	DS.W 9

;********************************************
;* ----- Protracker V1.1A Playroutine ----- *
;* Lars "Zap" Hamre/Amiga Freelancers 1990  *
;* Bekkeliveien 10, N-2010 STRÿMMEN, Norway *
;********************************************

n_cmd	EQU	2  ; W
n_cmdlo	EQU	3  ; low B of n_cmd
n_start	EQU	4  ; L
n_length	EQU	8  ; W
n_loopstart	EQU	10 ; L
n_replen	EQU	14 ; W
n_period	EQU	16 ; W
n_finetune	EQU	18 ; B
n_volume	EQU	19 ; B
n_dmabit	EQU	20 ; W
n_toneportdirec	EQU	22 ; B
n_toneportspeed	EQU	23 ; B
n_wantedperiod	EQU	24 ; W
n_vibratocmd	EQU	26 ; B
n_vibratopos	EQU	27 ; B
n_tremolocmd	EQU	28 ; B
n_tremolopos	EQU	29 ; B
n_wavecontrol	EQU	30 ; B
n_glissfunk	EQU	31 ; B
n_sampleoffset	EQU	32 ; B
n_pattpos	EQU	33 ; B
n_loopcount	EQU	34 ; B
n_funkoffset	EQU	35 ; B
n_wavestart	EQU	36 ; L
n_reallength	EQU	40 ; W

; Initialise module

mt_init	MOVE.L	A0,mt_SongDataPtr
	LEA	mt_mulu(PC),A1
	MOVE.L	A0,D0
	ADD.L	#12,D0
	MOVEQ	#$1F,D1
	MOVEQ	#$1E,D3
mt_lop4	MOVE.L	D0,(A1)+
	ADD.L	D3,D0
	DBRA	D1,mt_lop4
	LEA	$3B8(A0),A1
	MOVEQ	#127,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
mt_lop2 MOVE.B	(A1)+,D1
	CMP.B	D2,D1
	BLE.S	mt_lop
	MOVE.L	D1,D2
mt_lop	DBRA	D0,mt_lop2
	ADDQ.W	#1,d2
	ASL.L	#8,D2
	ASL.L	#2,D2
	LEA	4(A1,D2.L),A2
	LEA	mt_SampleStarts(PC),A1
	ADD.W	#$2A,A0
	MOVEQ	#$1E,D0
mt_lop3 CLR.L	(A2)
	MOVE.L	A2,(A1)+
	MOVEQ	#0,D1
	MOVE.B	D1,2(A0)
	MOVE.W	(A0),D1
	ASL.L	#1,D1
	ADD.L	D1,A2
	ADD.L	D3,A0
	DBRA	D0,mt_lop3
	LEA	mt_speed(PC),A1
	MOVE.B	#6,(A1)
	MOVEQ	#0,D0
	MOVE.B	D0,mt_SongPos-mt_speed(A1)
	MOVE.B	D0,mt_counter-mt_speed(A1)
	MOVE.W	D0,mt_PattPos-mt_speed(A1)
	BRA STspecific

; Vbl Sequencer

mt_music
	ADDQ.B	#1,mt_counter
	MOVE.B	mt_counter(PC),D0
	CMP.B	mt_speed(PC),D0
	BLO.S	mt_NoNewNote
	CLR.B	mt_counter
	TST.B	mt_PattDelTime2
	BEQ.S	mt_GetNewNote
	BSR.S	mt_NoNewAllChannels
	BRA	mt_dskip

mt_NoNewNote
	BSR.S	mt_NoNewAllChannels
	BRA	mt_NoNewPosYet

mt_NoNewAllChannels
	LEA	ch1s(pc),A5
	LEA	mt_chan1temp(PC),A6
	BSR	mt_CheckEfx
	LEA	ch2s(pc),A5
	LEA	mt_chan2temp(PC),A6
	BSR	mt_CheckEfx
	LEA	ch3s(pc),A5
	LEA	mt_chan3temp(PC),A6
	BSR	mt_CheckEfx
	LEA	ch4s(pc),A5
	LEA	mt_chan4temp(PC),A6
	BRA	mt_CheckEfx

mt_GetNewNote
	MOVE.L	mt_SongDataPtr(PC),A0
	LEA	12(A0),A3
	LEA	952(A0),A2	;pattpo
	LEA	1084(A0),A0	;patterndata
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE.B	mt_SongPos(PC),D0
	MOVE.B	(A2,D0.W),D1
	ASL.L	#8,D1
	ASL.L	#2,D1
	ADD.W	mt_PattPos(PC),D1

	LEA	ch1s(pc),A5
	LEA	mt_chan1temp(PC),A6
	BSR.S	mt_PlayVoice
	LEA	ch2s(pc),A5
	LEA	mt_chan2temp(PC),A6
	BSR.S	mt_PlayVoice
	LEA	ch3s(pc),A5
	LEA	mt_chan3temp(PC),A6
	BSR.S	mt_PlayVoice
	LEA	ch4s(pc),A5
	LEA	mt_chan4temp(PC),A6
	BSR.S	mt_PlayVoice
	BRA	mt_SetDMA

mt_PlayVoice
	TST.L	(A6)
	BNE.S	mt_plvskip
	MOVE.W	n_period(A6),6(A5)
mt_plvskip
	MOVE.L	(A0,D1.L),(A6)
	ADDQ.L	#4,D1
	MOVEQ	#0,D2
	MOVE.B	n_cmd(A6),D2
	LSR.B	#4,D2
	MOVE.B	(A6),D0
	AND.B	#$F0,D0
	OR.B	D0,D2
	BEQ	mt_SetRegs
	MOVEQ	#0,D3
	MOVE	D2,D4
	SUBQ.L	#1,D2
	ASL.L	#2,D2
	MULU	#30,D4
	MOVE.L	mt_SampleStarts(PC,D2.L),n_start(A6)
	MOVE.W	(A3,D4.L),n_length(A6)
	MOVE.W	(A3,D4.L),n_reallength(A6)
	MOVE.B	2(A3,D4.L),n_finetune(A6)
	MOVE.B	3(A3,D4.L),n_volume(A6)
	MOVE.W	4(A3,D4.L),D3 ; Get repeat
	TST.W	D3
	BEQ	mt_NoLoop
	MOVE.L	n_start(A6),D2	; Get start
	ASL.W	#1,D3
	ADD.L	D3,D2	; Add repeat
	MOVE.L	D2,n_loopstart(A6)
	MOVE.L	D2,n_wavestart(A6)
	MOVE.W	4(A3,D4.L),D0	; Get repeat
	ADD.W	6(A3,D4.L),D0	; Add replen
	MOVE.W	D0,n_length(A6)
	MOVE.W	6(A3,D4.L),n_replen(A6)	; Save replen
	MOVEQ	#0,D0
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)	; Set volume
	BRA	mt_SetRegs
mt_SampleStarts	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

mt_NoLoop
	MOVE.L	n_start(A6),D2
	ADD.L	D3,D2
	MOVE.L	D2,n_loopstart(A6)
	MOVE.L	D2,n_wavestart(A6)
	MOVE.W	6(A3,D4.L),n_replen(A6)	; Save replen
	MOVEQ	#0,D0
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)	; Set volume
mt_SetRegs
	MOVE.W	(A6),D0
	AND.W	#$0FFF,D0
	BEQ	mt_CheckMoreEfx	; If no note
	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0E50,D0
	BEQ.S	mt_DoSetFineTune
	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	CMP.B	#3,D0	; TonePortamento
	BEQ.S	mt_ChkTonePorta
	CMP.B	#5,D0
	BEQ.S	mt_ChkTonePorta
	CMP.B	#9,D0	; Sample Offset
	BNE.S	mt_SetPeriod
	BSR	mt_CheckMoreEfx
	BRA.S	mt_SetPeriod

mt_DoSetFineTune
	BSR	mt_SetFineTune
	BRA.S	mt_SetPeriod

mt_ChkTonePorta
	BSR	mt_SetTonePorta
	BRA	mt_CheckMoreEfx

mt_SetPeriod
	MOVEM.L	D1-D2/A2,-(SP)
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1
	LEA	mt_PeriodTable(PC),A2
	MOVEQ	#36,D2
mt_ftuloop
	CMP.W	(A2)+,D1
	DBHS	D2,mt_ftuloop
	MOVEQ	#0,D1
	MOVE.B	n_finetune(A6),D1
	MULU	#36*2,D1
	MOVE.W	-2(A2,D1.L),n_period(A6)
	MOVEM.L	(SP)+,D1-D2/A2

	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0ED0,D0 	; Notedelay
	BEQ	mt_CheckMoreEfx

	BTST	#2,n_wavecontrol(A6)
	BNE.S	mt_vibnoc
	CLR.B	n_vibratopos(A6)
mt_vibnoc
	BTST	#6,n_wavecontrol(A6)
	BNE.S	mt_trenoc
	CLR.B	n_tremolopos(A6)
mt_trenoc
	MOVE.L	n_start(A6),(A5)	; Set start
	MOVEQ.l	 #0,D0
	MOVE.W	n_length(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,(A5)	; point to end of sample
	MOVE.W	D0,4(A5)	; Set length
	MOVE.W	n_period(A6),6(A5)	; Set period
	BRA	mt_CheckMoreEfx
 
mt_SetDMA
	MOVE.L	D0,-(SP)
	MOVEQ.L	#0,D0
	LEA	ch4s(PC),A5
	LEA	mt_chan4temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVEQ.L	#0,D0
	LEA	ch3s(PC),A5
	LEA	mt_chan3temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVEQ.L	#0,D0
	LEA	ch2s(PC),A5
	LEA	mt_chan2temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVEQ.L	#0,D0
	LEA	ch1s(PC),A5
	LEA	mt_chan1temp(PC),A6
	MOVE.L	n_loopstart(A6),10(A5)
	MOVE.W	n_replen(A6),D0
	ADD.L	D0,D0
	ADD.L	D0,10(A5)
	MOVE.W	D0,14(A5)

	MOVE.L	(SP)+,D0

mt_dskip
	ADD.W	#16,mt_PattPos
	MOVE.B	mt_PattDelTime,D0
	BEQ.S	mt_dskc
	MOVE.B	D0,mt_PattDelTime2
	CLR.B	mt_PattDelTime
mt_dskc	TST.B	mt_PattDelTime2
	BEQ.S	mt_dska
	SUBQ.B	#1,mt_PattDelTime2
	BEQ.S	mt_dska
	SUB.W	#16,mt_PattPos
mt_dska	TST.B	mt_PBreakFlag
	BEQ.S	mt_nnpysk
	SF	mt_PBreakFlag
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	CLR.B	mt_PBreakPos
	LSL.W	#4,D0
	MOVE.W	D0,mt_PattPos
mt_nnpysk
	CMP.W	#1024,mt_PattPos
	BLO.S	mt_NoNewPosYet
mt_NextPosition	
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	LSL.W	#4,D0
	MOVE.W	D0,mt_PattPos
	CLR.B	mt_PBreakPos
	CLR.B	mt_PosJumpFlag
	ADDQ.B	#1,mt_SongPos
	AND.B	#$7F,mt_SongPos
	MOVE.B	mt_SongPos(PC),D1
	MOVE.L	mt_SongDataPtr(PC),A0
	CMP.B	950(A0),D1
	BLO.S	mt_NoNewPosYet
	CLR.B	mt_SongPos
mt_NoNewPosYet	
	TST.B	mt_PosJumpFlag
	BNE.S	mt_NextPosition
	RTS

mt_CheckEfx
	BSR	mt_UpdateFunk
	MOVE.W	n_cmd(A6),D0
	AND.W	#$0FFF,D0
	BEQ.S	mt_PerNop
	MOVE.B	n_cmd(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_Arpeggio
	CMP.B	#1,D0
	BEQ	mt_PortaUp
	CMP.B	#2,D0
	BEQ	mt_PortaDown
	CMP.B	#3,D0
	BEQ	mt_TonePortamento
	CMP.B	#4,D0
	BEQ	mt_Vibrato
	CMP.B	#5,D0
	BEQ	mt_TonePlusVolSlide
	CMP.B	#6,D0
	BEQ	mt_VibratoPlusVolSlide
	CMP.B	#$E,D0
	BEQ	mt_E_Commands
SetBack	MOVE.W	n_period(A6),6(A5)
	CMP.B	#7,D0
	BEQ	mt_Tremolo
	CMP.B	#$A,D0
	BEQ	mt_VolumeSlide
mt_Return2
	RTS

mt_PerNop
	MOVE.W	n_period(A6),6(A5)
	RTS

mt_Arpeggio
	MOVEQ	#0,D0
	MOVE.B	mt_counter(PC),D0
	DIVS	#3,D0
	SWAP	D0
	CMP.W	#0,D0
	BEQ.S	mt_Arpeggio2
	CMP.W	#2,D0
	BEQ.S	mt_Arpeggio1
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	LSR.B	#4,D0
	BRA.S	mt_Arpeggio3

mt_Arpeggio1
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#15,D0
	BRA.S	mt_Arpeggio3

mt_Arpeggio2
	MOVE.W	n_period(A6),D2
	BRA.S	mt_Arpeggio4

mt_Arpeggio3
	ASL.W	#1,D0
	MOVEQ	#0,D1
	MOVE.B	n_finetune(A6),D1
	MULU	#36*2,D1
	LEA	mt_PeriodTable(PC),A0
	ADD.L	D1,A0
	MOVEQ	#0,D1
	MOVE.W	n_period(A6),D1
	MOVE.L D3,-(SP)
	MOVEQ	#36,D3
mt_arploop
	MOVE.W	(A0,D0.W),D2
	CMP.W	(A0)+,D1
	BHS.S	.arp4
	DBF	D3,mt_arploop
	MOVE.L (SP)+,D3
	RTS
.arp4	MOVE.W	D2,6(A5)
	MOVE.L (SP)+,D3
	RTS

mt_Arpeggio4
	MOVE.W	D2,6(A5)
	RTS

mt_FinePortaUp
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaUp
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	SUB.W	D0,n_period(A6)
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#113,D0
	BPL.S	mt_PortaUskip
	AND.W	#$F000,n_period(A6)
	OR.W	#113,n_period(A6)
mt_PortaUskip
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS	
 
mt_FinePortaDown
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaDown
	CLR.W	D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	ADD.W	D0,n_period(A6)
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#856,D0
	BMI.S	mt_PortaDskip
	AND.W	#$F000,n_period(A6)
	OR.W	#856,n_period(A6)
mt_PortaDskip
	MOVE.W	n_period(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS

mt_SetTonePorta
	MOVE.L	A0,-(SP)
	MOVE.W	(A6),D2
	AND.W	#$0FFF,D2
	MOVEQ	#0,D0
	MOVE.B	n_finetune(A6),D0
	MULU	#37*2,D0
	LEA	mt_PeriodTable(PC),A0
	ADD.L	D0,A0
	MOVEQ	#0,D0
mt_StpLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_StpFound
	ADDQ.W	#2,D0
	CMP.W	#37*2,D0
	BLO.S	mt_StpLoop
	MOVEQ	#35*2,D0
mt_StpFound
	MOVE.B	n_finetune(A6),D2
	AND.B	#8,D2
	BEQ.S	mt_StpGoss
	TST.W	D0
	BEQ.S	mt_StpGoss
	SUBQ.W	#2,D0
mt_StpGoss
	MOVE.W	(A0,D0.W),D2
	MOVE.L	(SP)+,A0
	MOVE.W	D2,n_wantedperiod(A6)
	MOVE.W	n_period(A6),D0
	CLR.B	n_toneportdirec(A6)
	CMP.W	D0,D2
	BEQ.S	mt_ClearTonePorta
	BGE	mt_Return2
	MOVE.B	#1,n_toneportdirec(A6)
	RTS

mt_ClearTonePorta
	CLR.W	n_wantedperiod(A6)
	RTS

mt_TonePortamento
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_TonePortNoChange
	MOVE.B	D0,n_toneportspeed(A6)
	CLR.B	n_cmdlo(A6)
mt_TonePortNoChange
	TST.W	n_wantedperiod(A6)
	BEQ	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_toneportspeed(A6),D0
	TST.B	n_toneportdirec(A6)
	BNE.S	mt_TonePortaUp
mt_TonePortaDown
	ADD.W	D0,n_period(A6)
	MOVE.W	n_wantedperiod(A6),D0
	CMP.W	n_period(A6),D0
	BGT.S	mt_TonePortaSetPer
	MOVE.W	n_wantedperiod(A6),n_period(A6)
	CLR.W	n_wantedperiod(A6)
	BRA.S	mt_TonePortaSetPer

mt_TonePortaUp
	SUB.W	D0,n_period(A6)
	MOVE.W	n_wantedperiod(A6),D0
	CMP.W	n_period(A6),D0
	BLT.S	mt_TonePortaSetPer
	MOVE.W	n_wantedperiod(A6),n_period(A6)
	CLR.W	n_wantedperiod(A6)

mt_TonePortaSetPer
	MOVE.W	n_period(A6),D2
	MOVE.B	n_glissfunk(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_GlissSkip
	MOVEQ	#0,D0
	MOVE.B	n_finetune(A6),D0
	MULU	#36*2,D0
	LEA	mt_PeriodTable(PC),A0
	ADD.L	D0,A0
	MOVEQ	#0,D0
mt_GlissLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_GlissFound
	ADDQ.W	#2,D0
	CMP.W	#36*2,D0
	BLO.S	mt_GlissLoop
	MOVEQ	#35*2,D0
mt_GlissFound
	MOVE.W	(A0,D0.W),D2
mt_GlissSkip
	MOVE.W	D2,6(A5) 	; Set period
	RTS

mt_Vibrato
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_Vibrato2
	MOVE.B	n_vibratocmd(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_vibskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_vibskip
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_vibskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_vibskip2
	MOVE.B	D2,n_vibratocmd(A6)
mt_Vibrato2
	MOVE.B	n_vibratopos(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVEQ	#0,D2
	MOVE.B	n_wavecontrol(A6),D2
	AND.B	#$03,D2
	BEQ.S	mt_vib_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_vib_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_vib_set
mt_vib_rampdown
	TST.B	n_vibratopos(A6)
	BPL.S	mt_vib_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_sine
	MOVE.B	0(A4,D0.W),D2
mt_vib_set
	MOVE.B	n_vibratocmd(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#7,D2
	MOVE.W	n_period(A6),D0
	TST.B	n_vibratopos(A6)
	BMI.S	mt_VibratoNeg
	ADD.W	D2,D0
	BRA.S	mt_Vibrato3
mt_VibratoNeg
	SUB.W	D2,D0
mt_Vibrato3
	MOVE.W	D0,6(A5)
	MOVE.B	n_vibratocmd(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,n_vibratopos(A6)
	RTS

mt_TonePlusVolSlide
	BSR	mt_TonePortNoChange
	BRA	mt_VolumeSlide

mt_VibratoPlusVolSlide
	BSR.S	mt_Vibrato2
	BRA	mt_VolumeSlide

mt_Tremolo
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_Tremolo2
	MOVE.B	n_tremolocmd(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_treskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_treskip
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_treskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_treskip2
	MOVE.B	D2,n_tremolocmd(A6)
mt_Tremolo2
	MOVE.B	n_tremolopos(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVEQ	#0,D2
	MOVE.B	n_wavecontrol(A6),D2
	LSR.B	#4,D2
	AND.B	#$03,D2
	BEQ.S	mt_tre_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_tre_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_tre_set
mt_tre_rampdown
	TST.B	n_vibratopos(A6)
	BPL.S	mt_tre_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_sine
	MOVE.B	0(A4,D0.W),D2
mt_tre_set
	MOVE.B	n_tremolocmd(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#6,D2
	MOVEQ	#0,D0
	MOVE.B	n_volume(A6),D0
	TST.B	n_tremolopos(A6)
	BMI.S	mt_TremoloNeg
	ADD.W	D2,D0
	BRA.S	mt_Tremolo3
mt_TremoloNeg
	SUB.W	D2,D0
mt_Tremolo3
	BPL.S	mt_TremoloSkip
	CLR.W	D0
mt_TremoloSkip
	CMP.W	#$40,D0
	BLS.S	mt_TremoloOk
	MOVE.W	#$40,D0
mt_TremoloOk
	MOVE.W	D0,8(A5)
	MOVE.B	n_tremolocmd(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,n_tremolopos(A6)
	RTS

mt_SampleOffset
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	BEQ.S	mt_sononew
	MOVE.B	D0,n_sampleoffset(A6)
mt_sononew
	MOVE.B	n_sampleoffset(A6),D0
	LSL.W	#7,D0
	CMP.W	n_length(A6),D0
	BGE.S	mt_sofskip
	SUB.W	D0,n_length(A6)
	LSL.W	#1,D0
	ADD.L	D0,n_start(A6)
	RTS
mt_sofskip
	MOVE.W	#$0001,n_length(A6)
	RTS

mt_VolumeSlide
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	LSR.B	#4,D0
	TST.B	D0
	BEQ.S	mt_VolSlideDown
mt_VolSlideUp
	ADD.B	D0,n_volume(A6)
	CMP.B	#$40,n_volume(A6)
	BMI.S	mt_vsuskip
	MOVE.B	#$40,n_volume(A6)
mt_vsuskip
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)
	RTS

mt_VolSlideDown
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
mt_VolSlideDown2
	SUB.B	D0,n_volume(A6)
	BPL.S	mt_vsdskip
	CLR.B	n_volume(A6)
mt_vsdskip
	MOVE.B	n_volume(A6),D0
	MOVE.W	D0,8(A5)
	RTS

mt_PositionJump
	MOVE.B	n_cmdlo(A6),D0
	SUBQ.B	#1,D0
	MOVE.B	D0,mt_SongPos
mt_pj2	CLR.B	mt_PBreakPos
	ST 	mt_PosJumpFlag
	RTS

mt_VolumeChange
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	CMP.B	#$40,D0
	BLS.S	mt_VolumeOk
	MOVEQ	#$40,D0
mt_VolumeOk
	MOVE.B	D0,n_volume(A6)
	MOVE.W	D0,8(A5)
	RTS

mt_PatternBreak
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	MOVE.L	D0,D2
	LSR.B	#4,D0
	MULU	#10,D0
	AND.B	#$0F,D2
	ADD.B	D2,D0
	CMP.B	#63,D0
	BHI.S	mt_pj2
	MOVE.B	D0,mt_PBreakPos
	ST	mt_PosJumpFlag
	RTS

mt_SetSpeed
	MOVE.B	3(A6),D0
	BEQ	mt_Return2
	CLR.B	mt_counter
	MOVE.B	D0,mt_speed
	RTS

mt_CheckMoreEfx
	BSR	mt_UpdateFunk
	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	CMP.B	#$9,D0
	BEQ	mt_SampleOffset
	CMP.B	#$B,D0
	BEQ	mt_PositionJump
	CMP.B	#$D,D0
	BEQ.S	mt_PatternBreak
	CMP.B	#$E,D0
	BEQ.S	mt_E_Commands
	CMP.B	#$F,D0
	BEQ.S	mt_SetSpeed
	CMP.B	#$C,D0
	BEQ	mt_VolumeChange
	RTS	

mt_E_Commands
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F0,D0
	LSR.B	#4,D0
	BEQ.S	mt_FilterOnOff
	CMP.B	#1,D0
	BEQ	mt_FinePortaUp
	CMP.B	#2,D0
	BEQ	mt_FinePortaDown
	CMP.B	#3,D0
	BEQ.S	mt_SetGlissControl
	CMP.B	#4,D0
	BEQ	mt_SetVibratoControl
	CMP.B	#5,D0
	BEQ	mt_SetFineTune
	CMP.B	#6,D0
	BEQ	mt_JumpLoop
	CMP.B	#7,D0
	BEQ	mt_SetTremoloControl
	CMP.B	#9,D0
	BEQ	mt_RetrigNote
	CMP.B	#$A,D0
	BEQ	mt_VolumeFineUp
	CMP.B	#$B,D0
	BEQ	mt_VolumeFineDown
	CMP.B	#$C,D0
	BEQ	mt_NoteCut
	CMP.B	#$D,D0
	BEQ	mt_NoteDelay
	CMP.B	#$E,D0
	BEQ	mt_PatternDelay
	CMP.B	#$F,D0
	BEQ	mt_FunkIt
	RTS

mt_FilterOnOff
	RTS	

mt_SetGlissControl
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,n_glissfunk(A6)
	OR.B	D0,n_glissfunk(A6)
	RTS

mt_SetVibratoControl
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,n_wavecontrol(A6)
	OR.B	D0,n_wavecontrol(A6)
	RTS

mt_SetFineTune
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	MOVE.B	D0,n_finetune(A6)
	RTS

mt_JumpLoop
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_SetLoop
	TST.B	n_loopcount(A6)
	BEQ.S	mt_jumpcnt
	SUBQ.B	#1,n_loopcount(A6)
	BEQ	mt_Return2
mt_jmploop	MOVE.B	n_pattpos(A6),mt_PBreakPos
	ST	mt_PBreakFlag
	RTS

mt_jumpcnt
	MOVE.B	D0,n_loopcount(A6)
	BRA.S	mt_jmploop

mt_SetLoop
	MOVE.W	mt_PattPos(PC),D0
	LSR.W	#4,D0
	MOVE.B	D0,n_pattpos(A6)
	RTS

mt_SetTremoloControl
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,n_wavecontrol(A6)
	OR.B	D0,n_wavecontrol(A6)
	RTS

mt_RetrigNote
	MOVE.L	D1,-(SP)
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_rtnend
	MOVEQ	#0,D1
	MOVE.B	mt_counter(PC),D1
	BNE.S	mt_rtnskp
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1
	BNE.S	mt_rtnend
	MOVEQ	#0,D1
	MOVE.B	mt_counter(PC),D1
mt_rtnskp
	DIVU	D0,D1
	SWAP	D1
	TST.W	D1
	BNE.S	mt_rtnend
mt_DoRetrig
	MOVE.L D0,-(SP)
	MOVEQ #0,D0
	MOVE.L	n_start(A6),(A5)	; Set sampledata pointer
	MOVE.W	n_length(A6),D0
	ADD D0,D0
	ADD.L D0,(A5)
	MOVE.W D0,4(A5)	; Set length
	MOVEQ #0,D0
	MOVE.L	n_loopstart(A6),10(A5)	; loop sample ptr
	MOVE.L	n_replen(A6),D0
	ADD D0,D0
	ADD.L D0,10(A5)
	MOVE.W D0,14(A5)
	MOVE.L (SP)+,D0
mt_rtnend
	MOVE.L	(SP)+,D1
	RTS

mt_VolumeFineUp
	TST.B	mt_counter
	BNE	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$F,D0
	BRA	mt_VolSlideUp

mt_VolumeFineDown
	TST.B	mt_counter
	BNE	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	BRA	mt_VolSlideDown2

mt_NoteCut
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	CMP.B	mt_counter(PC),D0
	BNE	mt_Return2
	CLR.B	n_volume(A6)
	MOVE.W	#0,8(A5)
	RTS

mt_NoteDelay
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	CMP.B	mt_counter,D0
	BNE	mt_Return2
	MOVE.W	(A6),D0
	BEQ	mt_Return2
	MOVE.L	D1,-(SP)
	BRA	mt_DoRetrig

mt_PatternDelay
	TST.B	mt_counter
	BNE	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	TST.B	mt_PattDelTime2
	BNE	mt_Return2
	ADDQ.B	#1,D0
	MOVE.B	D0,mt_PattDelTime
	RTS

mt_FunkIt
	TST.B	mt_counter
	BNE	mt_Return2
	MOVE.B	n_cmdlo(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,n_glissfunk(A6)
	OR.B	D0,n_glissfunk(A6)
	TST.B	D0
	BEQ	mt_Return2
mt_UpdateFunk
	MOVEM.L	A0/D1,-(SP)
	MOVEQ	#0,D0
	MOVE.B	n_glissfunk(A6),D0
	LSR.B	#4,D0
	BEQ.S	mt_funkend
	LEA	mt_FunkTable(PC),A0
	MOVE.B	(A0,D0.W),D0
	ADD.B	D0,n_funkoffset(A6)
	BTST	#7,n_funkoffset(A6)
	BEQ.S	mt_funkend
	CLR.B	n_funkoffset(A6)

	CLR.B	n_funkoffset(A6)
	MOVE.L	n_loopstart(A6),D0
	MOVEQ	#0,D1
	MOVE.W	n_replen(A6),D1
	ADD.L	D1,D0
	ADD.L	D1,D0
	MOVE.L	n_wavestart(A6),A0
	ADDQ.L	#1,A0
	CMP.L	D0,A0
	BLO.S	mt_funkok
	MOVE.L	n_loopstart(A6),A0
mt_funkok
	MOVE.L	A0,n_wavestart(A6)
	MOVEQ	#-1,D0
	SUB.B	(A0),D0
	MOVE.B	D0,(A0)
mt_funkend
	MOVEM.L	(SP)+,A0/D1
	RTS

*********

	OPT	O+,W-
CALCULE_STARS	LINK	A5,#-20

	JMP	INIT_STARS

REVIENT_INIT	MOVE.L	16(A5),A4	BUFFER DE DESTINATION
	MOVE.L	20(A5),A2	ADRESSE DE LA TABLE D'OFFSET

	IFNE	ROTATION
	 MOVE.L	#TABLE_SINUS,PT_SINUS
	 MOVE.L	#TABLE_COSINUS,PT_COSINUS
	ENDC

	MOVE.W	#(768/VITESSE)-1,D6
RECOM_TABLE	MOVE.L	A4,(A2)+
	MOVE.L	A4,PT_SOV
	ADDQ.W	#2,A4
	CLR.W	COMPT
	MOVE.L	12(A5),A3
	LEA	PT_DEPART*10(A3),A3
	MOVE.W	#NB_STARS-1,D7
RECOM_CALCULE	
	IFNE	SHOW_TIME
	 NOT.W	$FFFF8240.W
	ENDC
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVE.W	(A3)+,D0	D0=Xe
	MOVE.W	(A3)+,D1	D1=Ye
	MOVE.W	(A3),D2	D2=Ze
	MOVE.W	D2,D5
	MOVE.W	D2,D4
	SUBI.W	#VITESSE,D5
	CMPI.W	#-256,D5
	BGT.S	PAS_CLIP_Z
	ADDI.W	#768,D5
	MOVE.W	4(A3),2(A3)
PAS_CLIP_Z	MOVE.W	D5,(A3)+

	IFNE	ROTATION
	 EXT.L	D0
	 EXT.L	D1
	 MOVEM.L	D2-D5,-(SP)
	 MOVE.L	PT_SINUS,A0
	 MOVE.L	PT_COSINUS,A1
	 MOVE.W	(A3),D5	OFFSET POUR SIN & COS
	 MOVE.W	(A0,D5.W),D2	SIN T
	 MOVE.W	(A1,D5.W),D3	COS_T
	 EXT.L	D3
	 EXT.L	D2
	 MULS.W	D0,D3	D3=XCOS T
	 MULS.W	D1,D2	D2=YSIN T
	 SUB.L	D2,D3	D3=X COS T -Y SIN T
	 MOVE.W	(A0,D5.W),D4	SIN T
	 MOVE.W	(A1,D5.W),D5	COS_T
	 MULS.W	D0,D4	D4=X SIN T
	 MULS.W	D1,D5	D5=Y COS T
	 ADD.L	D4,D5	D5=X SIN T + Y COS T
	 MOVE.L	D3,D0	D0=NEW X
	 MOVE.L	D5,D1	D1=NEW Y
	 MOVE.W	(A3),D5

	 ADDQ.W	#2,D5
	 CMPI.W	#720,D5
	 BLT.S	OK_REPLACE
	 MOVEQ	#0,D5
OK_REPLACE	 MOVE.W	D5,(A3)+
	 ADDQ.W	#2,A3
	 MOVEM.L	(SP)+,D2-D5
	ELSE
	 EXT.L	D0
	 EXT.L	D1
	 ASL.L	#P_DEC,D0	Xe=Xe*256
	 ASL.L	#P_DEC,D1	Ye=Ye*256
	 ADDQ.W	#4,A3
	ENDC

	MOVE.W	#P,D3	D3=|P|
	ADD.W	D3,D2	D2=|P|+Ze
	TST.W	D2
	BGT.S	PAS_Q_INF_0
	MOVE.W	#0,D0
	MOVE.W	#0,D1
	BRA	PAS_POZ
PAS_Q_INF_0	DIVS.W	D2,D0
	DIVS.W	D2,D1
	ADDI.W	#X_CENTER,D0
	ADDI.W	#Y_CENTER,D1

	CMPI.W	#CLIP_GAUCHE,D0
	BGE.S	X_POSITIF
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	BRA.S	PAS_POZ
X_POSITIF	CMPI.W	#CLIP_DROIT,D0
	BLE.S	X_CLIPPê
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	BRA.S	PAS_POZ
X_CLIPPê	CMPI.W	#CLIP_HAUT,D1
	BGE.S	Y_POSITIF
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	BRA.S	PAS_POZ
Y_POSITIF	CMPI.W	#CLIP_BAS,D1
	BLE.S	Y_CLIPPê
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	BRA.S	PAS_POZ
Y_CLIPPê
	LEA	TABLE_X,A0
	LEA	TABLE_Y,A1
	ASL.L	#2,D0
	MOVE.W	2(A0,D0.W),D2	INCREMENT
	MOVE.W	(A0,D0.W),D0	MOTIF
	ASL.L	#1,D1
	MOVE.W	(A1,D1.W),D1	Y*160
	ADD.W	D2,D1
	CMPI.W	#LIM_Z_1,D4
	BGE.S	SECOND_TEST
	SWAP	D0
	CLR.W	D0	MOTIF SUR LE PREMIER PLAN
	BRA.S	OK
SECOND_TEST	CMPI.W	#LIM_Z_2,D4
	BGE.S	THIRD_TEST
	SWAP	D0
	CLR.W	D0
	SWAP	D0	MOTIF SUR LE DEUXIEME PLAN
	BRA.S	OK
THIRD_TEST	MOVE.W	D0,-(SP)
	SWAP	D0
	MOVE.W	(SP)+,D0	MOTIF SUR LES 2 PREMIERS PLANS
OK	TST.L	D0
	BEQ.S	PAS_POZ
	MOVE.L	D0,(A4)+
	MOVE.W	D1,(A4)+
	ADDQ.W	#1,COMPT
PAS_POZ	DBRA	D7,RECOM_CALCULE
	MOVE.L	PT_SOV,A0
	MOVE.W	COMPT,(A0)
	SUBQ.W	#1,(A0)
	DBRA	D6,RECOM_TABLE

	MOVE.L	20(A5),A3
	LEA	(768/VITESSE)*4(A3),A2
	MOVE.L	-4(A2),-4(A3)

	MOVE.L	8(A5),A2
	MOVE.L	20(A5),(A2)

	UNLK	A5
	RTS

INIT_STARS	MOVE.L	12(A5),A0	BUFFER DE DESTINATION
	LEA	PT_DEPART*10(A0),A0
	MOVE.W	#NB_STARS-1,D5
REPEAT_STARS	MOVE.W	4(A0),D0	Z0
	MOVE.W	#(768/VITESSE)-1,D7
TEST_Z	SUBI.W	#VITESSE,D0
	CMPI.W	#-256,D0
	BGT.S	PAS_LOOP_Z
	ADDI.W	#768,D0	Z
	BRA.S	FINI_TEST_Z
PAS_LOOP_Z	DBRA	D7,TEST_Z
FINI_TEST_Z	ADDQ.W	#1,D7
	ADD.W	D7,D7
	MOVE.W	#718,D6
	SUB.W	D7,D6
	MOVE.W	D6,8(A0)
	LEA	10(A0),A0
	DBRA	D5,REPEAT_STARS
	JMP	REVIENT_INIT

SCROLL	MOVE.L	SCREEN1,A0
	LEA	190*160(A0),A0
	LEA	BUF_LET,A5
	REPT	8
	ROXL	(A5)
	ROXL	154(A0)
	ROXL	146(A0)
	ROXL	138(A0)
	ROXL	130(A0)
	ROXL	122(A0)
	ROXL	114(A0)
	ROXL	106(A0)
	ROXL	98(A0)
	ROXL	90(A0)
	ROXL	82(A0)
	ROXL	74(A0)
	ROXL	66(A0)
	ROXL	58(A0)	
	ROXL	50(A0)
	ROXL	42(A0)
	ROXL	34(A0)
	ROXL	26(A0)
	ROXL	18(A0)
	ROXL	10(A0)
	ROXL	2(A0)
	LEA	160(A0),A0
	ADDQ.L	#2,A5
	ENDR
	ADDI.L	#1,NB_PART
	RTS

TEST_LET	MOVEQ	#0,D0
	LEA	TEXT1,A0	
	ADDA.L	POINT,A0
	LEA	FONT8_8,A5
	CMPI.B	#$FF,(A0)
	BNE	SUITTST
	CLR.L	POINT
	LEA	TEXT1,A0
SUITTST	MOVE.B	(A0),D0	
	SUBI.B	#32,D0	
	LSL.W	#3,D0	
	ADDA.L	D0,A5	
	LEA	BUF_LET,A2
	MOVE.B	(A5)+,(A2)
	MOVE.B	(A5)+,2(A2)
	MOVE.B	(A5)+,4(A2)
	MOVE.B	(A5)+,6(A2)
	MOVE.B	(A5)+,8(A2)
	MOVE.B	(A5)+,10(A2)
	MOVE.B	(A5)+,12(A2)
	MOVE.B	(A5)+,14(A2)
	ADDI.L	#1,POINT
	RTS
	
mt_FunkTable dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

mt_VibratoTable	
	dc.b   0, 24, 49, 74, 97,120,141,161
	dc.b 180,197,212,224,235,244,250,253
	dc.b 255,253,250,244,235,224,212,197
	dc.b 180,161,141,120, 97, 74, 49, 24

mt_PeriodTable
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

mt_chan1temp	dc.l	0,0,0,0,0,$00010000,0,  0,0,0,0
mt_chan2temp	dc.l	0,0,0,0,0,$00020000,0,  0,0,0,0
mt_chan3temp	dc.l	0,0,0,0,0,$00040000,0,  0,0,0,0
mt_chan4temp	dc.l	0,0,0,0,0,$00080000,0,  0,0,0,0

mt_SongDataPtr	dc.l 0

mt_speed	dc.b 6
mt_counter	dc.b 0
mt_SongPos	dc.b 0
mt_PBreakPos	dc.b 0
mt_PosJumpFlag	dc.b 0
mt_PBreakFlag	dc.b 0
mt_LowMask	dc.b 0
mt_PattDelTime	dc.b 0
mt_PattDelTime2	dc.b 0
	dc.b 0

mt_PattPos	dc.w 0

mt_mulu	dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

freqs	ds.l 2
	incbin freq2.bin	; frequency table. int.w/frac.w
	even

vols	ds.l 64
	incbin pt_volta.dat	; 65 ,256 byte lookups.
	even
mt_data	incbin	ALFA.mod

TABLE_X	
N	SET	0
	REPT	20
	DC.W	32768,N,16384,N,8192,N,4096,N,2048,N,1024,N,512,N,256,N,128,N,64,N,32,N,16,N,8,N,4,N,2,N,1,N
N	SET	N+8
	ENDR

TABLE_Y
N	SET	0
	REPT	200
	DC.W	N*160
N	SET	N+1
	ENDR

TABLE_SINUS	INCBIN	SINUS.STR
	EVEN

TABLE_COSINUS	INCBIN	COSINUS.STR
	EVEN
DATA_STARS	INCBIN	STARSR3D.STR
	EVEN
********
CHOICE	INCBIN	CHOICE.DAT
	DC	$9999
OF	INCBIN	OF.DAT
	DC	$9999
GODS	INCBIN	GODS.DAT
	DC	$9999
PNT_3D	DC.L	0
COLORS
	DCB	4,$001
	DCB	9,$002
	DCB	14,$112
	DCB	18,$223
	DCB	22,$334
	DCB	25,$445
	DCB	27,$556
	DCB	29,$667
	DCB	30,$777
PNT_FAD	DC.L	0

TEXT1	
 DC.B "                                  "
 DC.B "This is all, boys!  The demo is now over! "
 DC.B	"               ",$FF

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


	section bss
TABLE1	DS.L	180
TABLE2	DS.L	180
TABLE3	DS.L	180
POINT	DS.L	1
NB_PART	DS.L	1
BUF_LET	DS.B	(1*8)*2

PT_SINUS	DS.L	1
PT_COSINUS	DS.L	1
SAVEA2	DS.L	1
COMPT	DS.W	1
OFFSET	DS.L	1
SAVER	DS.L	1
PT_SOV	DS.L	1
PT_STARS	DS.L	1
	DS.L	2
OFFSET_TABLE	DS.L	(768/VITESSE)
FIN_TABLE
	DS.L	256
my_stack	DS.L	1

SCREEN2	DS.L	1
SCREEN1	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	32000
BUF_STARS	DS.B	238000
