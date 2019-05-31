 move.w #$20,-(a7)
 trap #1
 addq.l #6,a7
 lea fic,a0
 lea fin,a1
 move.l #$41118,a2
copy	move.l (a0)+,(a2)+
	cmp.l a0,a1
	bge copy
	clr.l $45cea
	move.b #8,$484
	clr.b $45c84
	move.l $45ad4,$45adc
	move.b #7,d4
	move.b #$3f,d1
	andi.w #$3f,d1
	or.b $41cdb,d1
	move.b d4,$ff8800
	move.b d1,$ff8802
	add.b #1,d4
	clr.b $41ccf
	clr.b $41ccd
	move.l #$41118,-(a7)
	move.w #$f4,-(a7)
	move.w #7,-(a7)
	move.w #0,-(a7)
	move.w #$1f,-(a7)
	trap #14
	add.l #14,a7
	move.b #1,$4114a
wait    move.w #7,-(a7)
	trap #1
	addq.l #6,a7
	jsr wait
	even
fic	incbin music.bin
fin
