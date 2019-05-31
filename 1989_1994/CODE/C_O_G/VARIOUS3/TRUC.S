; Flexi Killer Scroller revu et corrig‚ par Zappy/Holocaust:
; * plus de Line A
; * MOVE D6,x(An)
; * routines g‚n‚rales modifi‚es


DEBUT:	MOVEA.L	A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L	$14(A5),D0
	ADD.L	$1C(A5),D0
	ADD.L 	#$100,D0
	MOVE.L	D0,-(SP)
	MOVE.L	A5,-(SP)
	MOVE	#0,-(SP)
	MOVE	#$4A,-(SP)
	TRAP	#1
	LEA	12(SP),SP

	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	

	MOVE.L	#BUFFERSCR,D0
	clr.b	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#150*256,D0
	MOVE.L	D0,SCREEN2

	move.l	#FIN,$8.w
	move.l	#FIN,$c.w
	move.l	#FIN,$10.w
	move.l	#FIN,$14.w
	move	#$2300,sr


	CLR	-(sp)
	PEA	-1.W
	PEA	-1.W
	move #5,-(sp)
	trap #14
	lea 12(sp),sp

	move.l	SCREEN1,d0
	lsr.l	#8,d0	
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	
	move.l	SCREEN1,$44e.w

	move #$2700,sr
	move.l $70.w,vbl_save
	move.l $120.w,tb_save

	movem.l $ffff8240.w,d0-d7
	movem.l d0-d7,pal_save

	lea $fffffa07.w,a0
	movep.w (a0),d0
	move d0,mfp_save
	moveq #0,d0

	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	move.l	#tb,$120.w
	sf	$ffff8242.w
	sf	$ffff8244.w
	sf	$ffff8246.w
	sf	$ffff8248.w
	sf	$ffff8250.w
	bsr demo
FIN:
	move #$2700,sr
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W

	movem.l pal_save,d0-d7
	movem.l d0-d7,$ffff8240.w
	move.l vbl_save,$70.w
	move.l tb_save,$120.w
	lea $fffffa07.w,a0
	move mfp_save,d0
	movep.w d0,(a0)

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	move #$2300,sr

	PEA	0.W
	trap #1


it_vbl:	MOVE	#$777,$FFFF8240.W
	;MOVE	#$001,$FFFF8250.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb,$120.W
;	MOVE.B	#78,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W


SWAP
	JSR	FLEXI_ROUTY
	
	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1	
	move.l	d0,SCREEN2

	lsr.l	#8,d0	
	move.l	#$ffff8201,a0
	movep	d0,(a0)



	cmp.b #$39,$fffffc02.w
	beq	FIN

	rte

tb
	DCB	127,$4E71
	CLR.B	$FFFF820A.W
	DCB	8,$4E71
	MOVE.B	#2,$FFFF820A.W
	CLR.B	$FFFFFA1B.W
;	MOVE.L	#tb3,$120.W
;	MOVE.B	#2,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
RTE	RTE		

demo:
	MOVE.L	#text,TEXT_EC
	move.l	#COURB1,COURB_EC
	MOVE	#32-1,COLONNE
		
	LEA	EMUL_LINEA,A0
	MOVE.L	A0,D0
	
	move.l a0,lineA_tab

	move.l #pattern,46(a0)
	move #0,50(a0)
	move #0,36(a0)
	move #-1,24(a0)
	move #0,26(a0)
	move #0,28(a0)
	move #0,30(a0)

	move #$2300,sr
	
	bsr text_convert
	
	lea text_buffer_end,a0
	MOVEA.L	TEXT_EC,a1
	lea font,a2
	moveq #0,d0
	move d0,d1
	move #30-1,d7	;30*5=150
text_lp:
	move.b (a1)+,d0
	move.b 3(a2,d0.w),-(a0)
	move.b 2(a2,d0.w),-(a0)
	move.b 1(a2,d0.w),-(a0)
	move.b 0(a2,d0.w),-(a0)
	move.b d1,-(a0)
	dbra d7,text_lp
	move.l a1,text_pt

	lea compteurs,a3
	
	bsr construction
	
	lea ad_routines,a0
	move.l 16(a0),a2	;routine d'effa‡age
	move #-4,(a3)	;images
	move #-20,2(a3)	;compteur pour le scroll du buffer de texte 

	
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	MOVEM.L	D0-A6,SAVE_ALL
	
	MOVE.L	#it_vbl,$70.w
BOUCLE	JMP	BOUCLE

FLEXI_ROUTY
	MOVEM.L	SAVE_ALL,D0-A6
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4

	move.l	#$ffffffff,d6
	move.l text_buff_pt,a5
	move.l SCREEN1,a6

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICA

	move #$200,$ffff8240.w
HICA


	jsr (a2)
	move.l (a0)+,a1
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HIC
	move #$100,$ffff8240.w
HIC
	jsr (a1)

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICq
	move #$007,$ffff8240.w
HICq

;	clr	$ffff8240.w
	
	addQ #1,(a3)
	bne END_ROUTY

	move #-4,(a3)
	lea ad_routines,a0
	sub.l d1,text_buff_pt
	
	addQ #1,2(a3)
	bne END_ROUTY
	
	move #-20,2(a3)
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	movem.l 70(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,90(a5)
	movem.l 30(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,50(a5)
	movem.l -10(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,10(a5)
	movem.w -20(a5),d0-d4
	movem.w d0-d4,(a5)
	
	move.l text_pt,a1
	lea font,a6
	moveq #0,d0
	move d0,d1
	move #4-1,d7	;4*5=20
text_lp2:
	move.b (a1)+,d0
	cmpi.b	#255,d0
	bne.s	pas_la_fin
	MOVEA.L	TEXT_EC,A1
	move.l a1,text_pt
	move.b (a1)+,d0
pas_la_fin
	move.b 3(a6,d0.w),-(a5)
	move.b 2(a6,d0.w),-(a5)
	move.b 1(a6,d0.w),-(a5)
	move.b 0(a6,d0.w),-(a5)
	move.b d1,-(a5)
	dbra d7,text_lp2
	move.l a1,text_pt
END_ROUTY	
	MOVEM.L	D0-A6,SAVE_ALL
	RTS
	
text_convert:
	MOVEA.L	TEXT_EC,A0
	moveq #-1,d1
convert_lp:
	moveq #0,d0
	move.b (a0),d0
	cmp.b d1,d0
	bne.S convert_suite
	cmp.b #255,1(a0)
	beq.S convert_fin
	addq #1,a0
	bra.s convert_lp
convert_suite:
	cmp.b #$20,d0
	blo.s int2_conv
	cmp.b #$21,d0
	bhi.s int2_conv
	sub #$20,d0
	bra.S next_octet
int2_conv:
	cmp.b #$41,d0
	blo.s int3_conv
	cmp.b #$5a,d0
	bhi