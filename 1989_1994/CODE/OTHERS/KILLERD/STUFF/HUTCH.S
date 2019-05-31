screen equ $75000
debut:
 lea debut,sp
 clr.l -(sp)
 move.w #$20,-(sp)
 trap #1
 addq.l #6,sp
 move.l d0,ancpile
 jsr save_pal
 jsr init_pt
 jsr mod_txt32
 jsr decomp_pic
 jsr get_blk
 jsr INTER_ON
get_key:
 move.b $fffffc02,d0
 cmp.b #$39,d0
 bne.s get_key
 jsr INTER_OFF
 jsr load_pal
 move.l ancpile,-(sp)
 move.w #$20,-(sp)
 trap #1
 addq.l #6,sp
 clr.w -(sp)
 trap #1
ancpile:
 dc.l 0
ecran:
 dc.l 0
resol:
 dc.w 0
pal_back:
 ds.w 32
save_pal:
 move.w #3,-(sp)
 trap #$e
 addq.l #2,sp
 move.l d0,ecran
 move.w #4,-(sp)
 trap #$e
 addq.l #2,sp
 move.w d0,resol
 lea pal_back,a0
 lea $ffff8240,a1
 moveq #15,d0
spal1:
 move.w (a1),(a0)+
 clr.w (a1)+
 dbra d0,spal1
 clr.w -(sp)
 move.l #screen,-(sp)
 move.l #screen,-(sp)
 move.w #5,-(sp)
 trap #$e
 lea 12(sp),sp
 rts
load_pal:
 move.w resol,-(sp)
 move.l ecran,-(sp)
 move.l ecran,-(sp)
 move.w #5,-(sp)
 trap #$e
 lea 12(sp),sp
 pea pal_back
 move.w #6,-(sp)
 trap #$e
 addq.l #6,sp
 rts
decomp_pic:
 move.l #screen,a0
 move.w #$9600/4-1,d0
dpic1:
 clr.l (a0)+
 dbra d0,dpic1
 move.l fnt32,a3
 lea font_32+34,a5
 jsr decomp
 move.l #screen,a3
 lea  TITRE+34,a5
decomp:
 move.l #$c7,d4
 move.l #6,a0
 moveq #4,d6
 moveq #$28,d7
dec9:
 clr.b d1
 move.l a3,a4
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
 add.l a0,a4
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
 add.l a0,a4
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
 add.l #$a0,a3
 dbra d4,dec9
 rts
get_blk:
 move.l pays32,a0
 move.l adscr32,a1
 move.w #(32*160)/4-1,d0
gets1:
 move.l (a0)+,(a1)+
 dbra d0,gets1
 rts
deb_adr:
tmp32:      dc.l -$aa00
adfnt32:    dc.l -$a800
fnt32:      dc.l -$7d00
pays32:     dc.l -$1400
adscr32:    dc.l 32160
init_pt:
 lea deb_adr,a0
 moveq #4,d0
inpt5:
 add.l #screen,(a0)+
 dbra d0,inpt5
 move.l adfnt32,a0
 move.l fnt32,d2
 moveq #4,d0
inpt3:
 moveq #9,d1
inpt4:
 move.l d2,(a0)+
 add.l #16,d2
 dbra d1,inpt4
 add.l #31*160,d2
 dbra d0,inpt3
 move.w #4,pt_let32
 rts
mod_txt32:
 lea txt_32,a0
 moveq #0,d0
mods1:
 move.b (a0),d0
 cmp.b #-1,d0
 beq fin_mod
 cmp.b #"A",d0
 blt.s mods2
 cmp.b #"Z",d0
 bhi.s mods2
 sub.b #"A",d0
 bra mods7
mods2:
 cmp.b #"0",d0
 blt.s mods3
 cmp.b #"9",d0
 bhi.s mods3
 sub.b #"0"-26,d0
 bra mods7
mods3:
 cmp.b #"'",d0
 blt.s mods4
 cmp.b #")",d0
 bhi.s mods4
 sub.b #"'"-36,d0
 bra mods7
mods4:
 cmp.b #",",d0
 blt.s mods5
 cmp.b #".",d0
 bhi.s mods5
 sub.b #","-40,d0
 bra mods7
mods5:
 cmp.b #"!",d0
 bne.s mods6
 move.b #39,d0
 bra mods7
mods6:
 cmp.b #":",d0
 bne.s MODS6_2
 move.b #43,d0
 bra mods7
MODS6_2:
 move.b #44,d0
mods7:
 move.b d0,(a0)+
 bra mods1
fin_mod:
 rts
scroll_32:
 cmp.w #4,pt_let32
 bne.s scr32_3
 lea txt_32,a0
 move.w pt_txt32,d0
 move.b (a0,d0.w),d1
 bpl.s scr32_1
 clr.w pt_txt32
 bra.s scroll_32
scr32_1:
 addq.w #1,pt_txt32
 ext.w d1
 asl #2,d1
 move.l adfnt32,a0
 move.l (a0,d1.w),a0
 move.l tmp32,a1
 addq.l #6,a0
 moveq #31,d0
scr32_2:
 move.w (a0),(a1)+
 move.w 8(a0),(a1)+
 lea 160(a0),a0
 dbra d0,scr32_2
 clr.w pt_let32
scr32_3:
 move.l adscr32,a0
 move.l tmp32,a1
 move.w pt_let32,d0
 bclr #0,d0
 add.w d0,a1
 moveq #31,d1
 MOVEq #8,D2
scr32_4:
 moveq #0,d0
 move.w (a1),d0
 lsl.l d2,d0
 move.w d0,(a1)+
 swap d0
 moveq #0,d4
 move.w $9e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$9e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $96(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$96(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $8e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$8e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $86(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$86(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $7e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$7e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $76(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$76(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $6e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$6e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $66(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$66(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $5e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$5e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $56(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$56(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $4e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$4e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $46(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$46(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $3e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$3e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $36(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$36(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $2e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$2e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $26(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$26(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $1e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$1e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $16(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$16(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $e(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$e(a0)
 move.l d4,d0
 swap d0
 moveq #0,d4
 move.w $6(a0),d4
 lsl.l d2,d4
 or.w d0,d4
 move.w d4,$6(a0)
 adda.l #160,a0
 addq.l #2,a1
 dbra d1,scr32_4
 addq.w #1,pt_let32
 rts
INTER_ON:
 moveq #2,d0
 jsr player
 CLR.B $FFFFFA1B
 MOVE.B $FFFFFA09,ANCA09
 ANDI.B #$DF,$FFFFFA09
 MOVE.B $FFFFFA07,ANCA07
 ANDI.B #$FE,$FFFFFA07
 MOVE.L #MFP,$120
 MOVE.B $FFFFFA13,ANCA13
 ORI.B #1,$FFFFFA07
 ORI.B #1,$FFFFFA13
 MOVE.L $70,ANCVBL
 MOVE.L #VBL,$70
 MOVE.B #$12,$FFFFFC02
 RTS
INTER_OFF:
 moveq #0,d0
 jsr player
 MOVE.B ANCA09,$FFFFFA09
 MOVE.B ANCA07,$FFFFFA07
 MOVE.B ANCA13,$FFFFFA13
 MOVE.L ANCVBL,$70
 MOVE.B #$8,$FFFFFC02
 RTS
ANCVBL:
 DC.L 0
ANCA07: DC.B 0
ANCA09: DC.B 0
ANCA13: DC.W 0
MFP:
 MOVEM.L D0-A0,-(SP)
 LEA $FFFFFA21,A0
 MOVE.B (A0),D0
MFPS1:
 CMP.B (A0),D0
 BEQ.S MFPS1
 BCLR #1,$FFFF820A
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 Dc.W $4E71
 BSET #1,$FFFF820A
 MOVEM.L font_32+2,D0-D7
 MOVEM.L D0-D7,$FFFF8240
 clr.b $fffffa1b
 BCLR #0,$FFFFFA0F
 MOVEM.L (SP)+,D0-A0
 RTE
pt_vbl: dc.w 0
VBL:
 MOVEM.L D0-a6,-(SP)
vbl_s1:
 MOVE.w #1,pt_vbl
 MOVEM.L TITRE+2,D0-D7
 MOVEM.L D0-D7,$FFFF8240
 MOVE.B #199,$FFFFFA21
 MOVE.B #8,$FFFFFA1B
 jsr scroll_32
 jsr player+8
 MOVEM.L (SP)+,D0-a6
 RTE
player:
 incbin "a:\roll_out.b"
 even
pt_let32:
 dc.w 0
pt_txt32:
 dc.w 0
font_32:
 incbin "a:\fontes.pc1"
 even
TITRE:
 incbin "a:\um.pc1"
 even

txt_32:
 DC.B "                   "
	DC.B "         YEAAAAHHH!! HERE IS THE CONNEXION, STRIKING BACK WITH A BRAND NEW LOW-BORDERED SCROLL ! OTHERS BANDS PLAY, CONNEXION KILL...   THESE INTRO WAS CODED BY ME - HUTCH - , FOR THE BIRTH OF OUR BAND! "
	DC.B " THREE MEMBERS: DELTA CRUZ , KILLER D ( THE BEST GIRL WHO BELONGS TO A COMPUTER-GROUP ALL OVER EUROPE ), AND ME, HUTCH, BEST SWAPPER IN THIS COUNTRY !! GREETINGS TO: K-REN (KISS), THE REPLICANTS (EXPECIALLY SNAKE AND COBRA), "
	DC.B " THE MARVELLOUS V8 (YODA AND DEMONIAK), AUTOMATION, THE LOST BOYS, TCB, MAD' VISION ... AND ALL OTHERS CREWS. MEGA FUCK TO BEN... AND WATCH OUT FOR OUR NEXT VECTOR DEMO !! WRAAAAAAAAAAAP....."
	DC.B "         ",0 
 DC.B -1
 END
