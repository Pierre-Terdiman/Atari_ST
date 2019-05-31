 move.w #$20,-(a7)
 trap #1
 addq.l #6,a7
 move.l $31415926,$426
 move.l #error,$42a
 move.w #$20,-(a7)
 trap #1
 addq.l #6,a7
 clr -(a7)
 trap #1
error move.w #$2700,sr
	move.b #2,$ff820a
	pea tex
	move.w #9,-(a7)
	trap #1
	addq.l #6,a7
wait	nop
	bra wait
	rts
tex	dc.b $1B,$45,'RESET',0
	 