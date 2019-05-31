SEG=6
NB_PTS=4*SEG
PAS=3
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_X,A1
	
;	MOVE	#16*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	
	move	#256,z_pt_fuite

	move.l	#NB_POS-1,d7
ici	CLR.L	POINTEUR
	jsr	trigo
	ADD.L	#2,POINTEUR2
	rept	NB_PTS
	jsr	sp_to_pl
	jsr	ROUTINE
	endr
;	ADD	#2*PAS,x_angle
;	ADD	#2*PAS,y_angle
	ADD	#2*PAS,z_angle
	dbf	d7,ici



	CLR	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE	#5,-(SP)
	TRAP	#14
	ADDA.L	#12,SP


	JMP	PROG
	
	clr.l	-(sp)
	trap	#1


trigo	movem.l d0-d7/a4-a6,-(a7)

	lea cos_tab,a4	;a4 pointe table cos
	lea sin_tab,a5	;a5 pointe table sin

	lea x_angle,a6
	move.w (a6)+,d2	;d2=x_angle
	move.w (a6)+,d1	;d1=y_angle
	move.w (a6)+,d0	;d0=z_angle
	
	move.w 0(a5,d2.w),d5	;d5=sin_x
	move.w 0(a4,d2.w),d4	;d4=cos_x
	move.w 0(a5,d1.w),d3	;d3=sin_y
	move.w 0(a4,d1.w),d2	;d2=cos_y
	move.w 0(a5,d0.w),d1	;d1=sin_z
	move.w 0(a4,d0.w),d0	;d0=cos_z

	lea var_3d,a6	;a6 pointe la zone
			;qui contiendra les
			;calculs 
			;intermediaires

	moveq #9,d7		;d7 contient le nombre 
			;de decalages a faire	
			;pour diviser par 512
			
	;****** calcul de C *****
	
sp_c	move.w d3,d6	;sin_y*512
	neg.w d6		;inverse signe
	move.w d6,(a6)+	;-sin_y*512
	
	;****** calcul de F *****
	
sp_f	move.w d2,d6	;cos_y*512 
	muls d5,d6		;cos_y*512*sin_x*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_y*sin_x*512
	
	;****** calcul de I *****
	
sp_i	move.w d2,d6	;cos_y*512
	muls d4,d6		;cos_y*512*cos_x*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_y*cos_x*512

	;****** calcul de A *****	

sp_a	move.w d0,d6	;cos_z*512
	muls d2,d6		;cos_z*512*cos_y*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;cos_z*cos_y*512

	;****** calcul de D *****

sp_d	move.w d1,d6	;sin_z*512
	muls d4,d6		;sin_z*512*cos_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke resultat
			;dans a4

	move.w d0,d6	;cos_z*512
	muls d3,d6		;cos_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d5,d6		;cos_z*sin_y*512
			;     *sin_x*512
	asr.l d7,d6		;divise par 512
	sub.w a4,d6		;soustrait resultat
			;stock‚ dans a4
	move.w d6,(a6)+	

	;****** calcul de G *****

sp_g	move.w d1,d6	;sin_z*512
	muls d5,d6		;sin_z*512*sin_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4

	move.w d0,d6	;cos_z*512
	muls d3,d6		;cos_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d4,d6		;cos_z*sin_y*512
			;     *cos_x*512
	asr.l d7,d6		;divise par 512
	add.w a4,d6		;ajoute resultat
			;stock‚ dans a4
	move.w d6,(a6)+	

	;****** calcul de B *****
	
sp_b	move.w d1,d6	;sin_z*512
	muls d2,d6		;sin_z*512*cos_y*512
	asr.l d7,d6		;divise par 512
	move.w d6,(a6)+	;sin_z*cos_y*512

	;****** calcul de E *****
	
sp_e	move.w d0,d6	;cos_z*512
	muls d4,d6		;cos_z*512*cos_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4
	
	move.w d1,d6	;sin_z*512
	muls d3,d6		;sin_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d5,d6		;sin_z*sin_y*512
			;     *sin_x*512
	asr.l d7,d6		;divise par 512
	add.w a4,d6		;ajoute resultat
			;stock‚ dans a4
	move.w d6,(a6)+	
	
	;****** calcul de H *****

sp_h	move.w d0,d6	;cos_z*512
	muls d5,d6		;cos_z*512*sin_x*512
	asr.l d7,d6		;divise par 512
	movea.w d6,a4	;stocke dans a4
	
	move.w d1,d6	;sin_z*512
	muls d3,d6		;sin_z*512*sin_y*512
	asr.l d7,d6		;divise par 512
	muls d4,d6		;sin_z*sin_y*512
			;     *cos_x*512
	asr.l d7,d6		;divise par 512
	sub.w a4,d6		;soustrait resultat
			;stock‚ dans a4
	move.w d6,(a6)+	
	
	movem.l (a7)+,d0-d7/a4-a6
	rts

;********************************************
; calcul des coordonnees planes             *
; en entree: xe,ye,ze                       *
;            x_angle,y_angle,z_angle        *
;            z_pt_fuite z du point de fuite *
; en sortie: xp,yp coordonn‚es planes       *
;            new_xe,new_ye,new_ze nouvelles *
;            coordonn‚es spatiales          *
;********************************************

sp_to_pl movem.l d0-d7/a1-a6,-(a7)
	
	lea 	points,a6		;a6 pointe coords
	ADDA.L	POINTEUR,A6
	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
	sub	#160,d0
	sub	#100,d1
	moveq	#0,d2
	ADD.L	#4,POINTEUR
	
	lea depla,a3
	move.w #0,d3	;xdep
	move.w #0,d4	;xdep
	move.w #0,d5	;xdep
	
	move	d5,d4
	add	d2,d4
	cmpi.l	#255,d4
	bgt.s	oh_no
	bra.s	oh_yes
	
oh_no	sub	#255,D5
oh_yes	clr.l	d4
	
	ext.l d3
	ext.l d4
	ext.l d5
	moveq #9,d6
	asl.l d6,d3 	;xdep*512
	asl.l d6,d4		;ydep*512
	asl.l d6,d5		;zdep*512
	movea.l d3,a1	
	movea.l d4,a2
	movea.l d5,a3
	
	lea var_3d,a6	;pointe zone de
			;calcul 
			;intermediaire

	move.w d0,d3	;d3=xe
	move.w d1,d4	;d4=ye
	move.w d2,d5	;d5=ze

	muls (a6)+,d3	;d3=c*xe*512
	muls (a6)+,d4	;d4=f*ye*512
	muls (a6)+,d5	;d5=i*ze*512
	add.l d4,d5		; + f*ye*512
	add.l d3,d5		; + c*xe*512
	add.l a3,d5		; + zdep*512
	move.l d5,a5	;a5=new_ze*512
	divs z_pt_fuite,d5	;d5=new_ze/z_pt_fuite

	move.w #512,d7
	sub.w d5,d7		;d7=512*q
			;d7=512*
			;(1-new_ze/z_pt_fuite)
	
	move.w d0,d3	;d3=xe
	move.w d1,d4	;d4=ye	
	move.w d2,d5	;d5=ze
		
	muls (a6)+,d3	;d3=a*xe*512
	muls (a6)+,d4	;d4=d*ye*512
	muls (a6)+,d5	;d5=g*ze*512
	add.l d4,d5		;+ a*xe*512
	add.l d3,d5		;+ d*xe*512
	add.l a1,d5		;+ xdep*512
	move.l d5,a4	;a4=new_xe*512
	divs d7,d5		;d5.w=
			;(new_xe*512)/(q*512)
			;d5=new_xe/q
	
	muls (a6)+,d0	;d0=b*xe*512
	muls (a6)+,d1	;d1=e*ye*512
	muls (a6)+,d2	;d2=h*ze*512
	add.l d0,d1		; + b*xe*512
	add.l d1,d2		; + e*ye*512
	add.l a2,d2		; + ydep*512
	move.l d2,d6	;d6=new_ye*512
	divs d7,d2		;d2.w=new_ye/q
	
	lea xp,a6		;a6 pointe zone
			;sauvergarde coords
			;plane qu'on
			;centre … l'‚cran

	add.w #160,d5	;d5=xp+160
	move.w d5,(a6)+	;xp
	
	add.w #100,d2	;d2=yp+100
	move.w d2,(a6)+	;yp

	move.l a4,d5	;new_xe*512
	move.l a5,d7	;new_ze*512
	moveq #9,d0
	asr.l d0,d5		;new_xe
	asr.l d0,d6		;new_ye
	asr.l d0,d7		;new_ze
			
			;sauve nouvelles 
			;coords spatiales
	move.w d5,(a6)+	;new_xe
	move.w d6,(a6)+	;new_ye
	move.w d7,(a6)+	;new_ze
	MOVE	D7,ZA	
	movem.l (a7)+,d0-d7/a1-a6
	rts

ROUTINE
	MOVEQ	#0,D0
	MOVE	xp,D0
	CMPI	#0,D0
	BGE.S	OK
	MOVEQ	#0,D0
OK	CMPI	#320,D0
	BLT.S	OK2
	MOVE.L	#319,D0
OK2	MOVE	D0,(A1)+

	MOVEQ	#0,D0
	MOVE	yp,D0
	CMPI	#0,D0
	BGE.S	OK3
	MOVEQ	#0,D0
OK3	CMPI	#200,D0
	BLT.S	OK4
	MOVE.L	#199,D0
OK4	MOVE	D0,(A1)+

	RTS

SET_SCR:	move.l	#BUFFERSCR,d0	
	and.l	#$ffffff00,d0		
	move.l	d0,SCREEN1
	add.l	#32000,d0		
	move.l	d0,SCREEN2
	rts				
	
	
	

PROG:

main
	clr.l	-(sp)
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	MOVE.L	#FIN,$8.W
	MOVE.L	#FIN,$C.W
	MOVE.L	#FIN,$10.W
	MOVE.L	#FIN,$14.W

	move.w	#0,-(sp)
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea.l	12(sp),sp

	JSR	SET_SCR
	


mainloop

	move.l	SCREEN2,a0
;	LEA	160*70(A0),A0
;	LEA	64(A0),A0
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVE.L	#0,A1
	MOVE.L	#0,A2
	MOVE.L	#0,A3
	MOVE.L	#0,A4
	MOVE.L	#0,A5
	MOVE.L	#0,A6
N	SET	32-8
	REPT	200
	MOVEM.L	D0-D7/A1-A6,N(A0)
	MOVEM.L	D0-D7/A1-A6,N+14*4(A0)
;	MOVEM.L	D0-D7/A1-A4,N+14*4*2(A0)
N	SET	N+160
	ENDR
;	move.w	#$ff,$ffff8240.w
	REPT	SEG
	bsr	poly
	ENDR
;	move.w	#$fff,$ffff8240.w	

	move.w	#$25,-(sp)
	trap	#14
	addq.l	 #2,sp

	
	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)


	
	cmp.b	#$39,$fffffc02.w
	bne	mainloop

FIN
	clr.w	-(sp)
	trap	#1
	

poly:
				*chercher +haut
;  	lea.l	t_points(pc),a1	*point	Y1		
	LEA	DATA_X,A1
	ADDA.L	PNT,A1
	CMPI	#-1,(A1)
	BNE.S	OKAY
	CLR.L	PNT
	LEA	DATA_X,A1
	BRA.S	OKAY2
OKAY	ADD.L	#4*4,PNT
OKAY2	lea.l	tpoly(pc),a5
	move.w	(a5)+,d0		*d0=ndpoints
	
	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0		*calc avec tpoint
	
	move.w	(a5),d1
	move.w	2(a1,d1),d2
	lea.l	2(a5),a2
	move.w	(a2)+,d3
t_petit
	cmp.w	2(a1,d3.w),d2
	blt.s	st_ptit
	lea.l	-2(a2),a5
	move.w	2(a1,d3.w),d2
st_ptit
	move.w	(a2)+,d3
	dbra.w	d0,t_petit				
********************************************************************	
	move.w	d2,codmpyin+2		*calc ligne
	
	lea.l	calc(pc),a4		*pas touch
				*point=a1			*pointpoint=a5
				*tdpoint=a5
	add.w	d7,d7	
	add.l	#tpoly+2,d7		*d7=fin de table
				*calc tgauche
	lea.l	tgauch(pc),a3
	lea.l	(a5),a2
b_calct_g	
	move.w	(a2)+,d4		*pointe suivant tabe
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g
	lea.l	tpoly+2(pc),a2
s_calct_g	
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g	
	bsr	calcord
	bra.b	b_calct_g	
s1_calct_g		
				**droit
	lea.l	tdroit(pc),a3
	move.l	d7,mcodtd+2
	move.l	#tpoly+2,d7	
	lea.l	(a5),a2
b_calct_d		
	move.w	(a2),d4
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_d
mcodtd	move.l	#t_points+2,a2
s_calct_d	
	move.w	-(a2),d4
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_d	
	bsr	calcord
	bra.b	b_calct_d	
s1_calct_d	
******************************************************************
					*affiche poly			
				*peut toucher a4
	move.l	SCREEN2,a0
	
	move.w	d1,d6

codmpyin	move.w	#100,d0
	sub.w	d0,d6
	subq.l	#1,d6
	lea.l	p_t_ord(pc),a1		
	add.w	d0,d0
	add.w	(a1,d0.w),a0 	*add ydeb	
	
	lea.l	tgauch(pc),a1	
	lea.l	p_t_left(pc),a2	
	lea.l	p_t_right(pc),a3	
	
	move.w	#$ffff,d7
	
;	move.w	#$f0,$ffff8240.W

	
bouclaff 	
	move.w	(a1)+,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a2,d0.w),d0
	
	move.w	tdroit-tgauch-2(a1),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a3,d1.w),d1
	
	lea.l	(a0,d0.w),a4	*add xdeb
	sub.w	d0,d1
	jmp	tdrempvd(pc,d1.w)	
*********************************************
tdrempvd
	bra.w	pdaffpa1
	dc.l	0
	bra.w	pdaffpa2
	dc.l	0
	bra.w	pdaffpa3	
	dc.l	0
	bra.w	pdaffpa4
	dc.l	0
	bra.w	pdaffpa5
	dc.l	0
	bra.w	pdaffpa6
	dc.l	0
	bra.w	pdaffpa7
	dc.l	0
	bra.w	pdaffpa8
	dc.l	0
	bra.w	pdaffpa9
	dc.l	0
	bra.w	pdaffpa10
	dc.l	0
	bra.w	pdaffpa11
	dc.l	0
	bra.w	pdaffpa12
	dc.l	0
	bra.w	pdaffpa13
	dc.l	0
	bra.w	pdaffpa14
	dc.l	0
	bra.w	pdaffpa15
	dc.l	0
	bra.w	pdaffpa16
	dc.l	0
	bra.w	pdaffpa17
	dc.l	0
	bra.w	pdaffpa18
	dc.l	0
	bra.w	pdaffpa19
	dc.l	0
	bra.w	pdaffpa20

pdaffpa1
	swap	d0
	swap	d1
	and.w	d0,d1
	or.w	d1,(a4)	
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa2
	swap	d0
	or.w	d0,(a4)
	swap	d1
	or.w	d1,8(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa3
	swap	d0
	or.w	d0,(a4)
	move.w	d7,8(a4)
	swap	d1
	or.w	d1,16(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa4
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	2
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 
	rts
pdaffpa5
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	3
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 
	rts
pdaffpa6
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	4
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa7
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	5
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa8
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	6
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa9
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	7
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa10
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	8
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa11
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	9
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa12
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	10
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa13
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	11
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa14
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	12
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa15
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	13
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa16

	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	14
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa17
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	15
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa18
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	16
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa19
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	17
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts
pdaffpa20
	swap	d0
	or.w	d0,(a4)
n	set	8
	rept	18
	move.w	d7,n(a4)
n	set	n+8
	endr
	swap	d1
	or.w	d1,n(a4)
	lea.l	160(a0),a0
	dbra.w	d6,bouclaff 	
	rts


*********************************************
calcord	
	
	moveq.l	#0,d4
	SUB.W	D0,D2
	SUB.W	D1,D3
	bne.s	scalcnul
	rts
scalcnul	
	move.w	d2,d4
	
	ASL.W	#6,D4
	ext.l	d4
	DIVS.W	d3,D4	*x(+1)=(dx/dy)+x
	move.w	#10,d2
	ext.l	d4
	ASL.L	d2,D4
	
	add.w	d3,d3
	add.w	d3,d3
	neg	d3
	SWAP	d4

	sub.w	#0,d4
	JMP	(a4,d3)

	rept	201
	MOVE.W	d0,(A3)+
	ADDX.L	d4,d0
	endr
calc
	rts
	

	section	data
tpoly	dc.w	4
	dc.w	0,4,8,12

t_points	
	dc.w	0,75
	dc.w	0,199
	dc.w	75,199
	dc.w	150,0
	
p_t_left
n	set	0
          	rept	20
            dc.w    %1111111111111111,n
            dc.w    %0111111111111111,n
            dc.w    %0011111111111111,n
            dc.w    %0001111111111111,n
            dc.w    %0000111111111111,n
            dc.w    %0000011111111111,n
            dc.w    %0000001111111111,n
            dc.w    %0000000111111111,n
            dc.w    %0000000011111111,n
            dc.w    %0000000001111111,n
            dc.w    %0000000000111111,n
            dc.w    %0000000000011111,n
            dc.w    %0000000000001111,n
            dc.w    %0000000000000111,n
            dc.w    %0000000000000011,n
            dc.w    %0000000000000001,n
n	set	n+8
	endr

p_t_right
n	set	0
            rept	20
            dc.w    %1000000000000000,n
            dc.w    %1100000000000000,n
            dc.w    %1110000000000000,n
            dc.w    %1111000000000000,n
            dc.w    %1111100000000000,n
            dc.w    %1111110000000000,n
            dc.w    %1111111000000000,n
            dc.w    %1111111100000000,n
            dc.w    %1111111110000000,n
            dc.w    %1111111111000000,n
            dc.w    %1111111111100000,n
            dc.w    %1111111111110000,n
            dc.w    %1111111111111000,n
            dc.w    %1111111111111100,n
            dc.w    %1111111111111110,n
            dc.w    %1111111111111111,n
n	set	n+8
	endr
	
p_t_ord
n	set	0
	rept	200
	dc.w	n
n	set	n+160
	endr	

cos_tab	incbin 'COSIN.DAT'	;tables sinus cosinus
sin_tab	equ cos_tab+720

points	
; NB PTS=24
; Forme de d‚part
 DC 152,76,152,124,136,124,136,76
 DC 112,76,112,124,96,124,96,76
 DC 136,108,112,108,112,92,136,92
 DC 160,124,160,76,176,76,176,124
 DC 200,124,176,124,176,108,200,108
 DC 200,92,176,92,176,76,200,76
; Transformation
 DC 150,76,150,123,134,122,135,75
 DC 114,76,114,123,99,122,99,75
 DC 138,108,114,108,114,92,138,92
 DC 158,124,158,77,174,77,174,124
 DC 199,123,175,123,175,107,199,107
 DC 200,92,176,92,176,76,200,76
 DC 149,76,149,122,133,121,134,75
 DC 117,76,117,122,102,121,102,75
 DC 140,109,117,109,117,93,140,93
 DC 157,124,156,78,172,78,172,124
 DC 198,123,174,123,174,107,198,107
 DC 200,92,176,92,176,76,200,76
 DC 148,76,147,121,132,120,133,75
 DC 120,76,120,121,105,120,105,75
 DC 143,110,120,110,120,94,143,94
 DC 155,125,155,80,170,79,170,124
 DC 197,123,174,123,174,107,197,107
 DC 200,92,177,92,177,77,200,77
 DC 146,76,146,120,131,119,132,75
 DC 123,76,122,120,108,119,108,75
 DC 145,111,122,111,122,95,145,95
 DC 154,125,153,81,168,81,168,125
 DC 196,122,173,122,173,107,196,107
 DC 200,93,177,93,177,77,200,77
 DC 145,76,144,119,130,118,131,75
 DC 126,76,125,119,111,118,112,75
 DC 148,112,125,112,125,96,148,96
 DC 152,126,152,83,166,82,167,125
 DC 195,122,172,122,172,107,195,107
 DC 200,93,178,93,178,78,200,78
 DC 144,76,143,118,129,117,130,75
 DC 129,76,128,118,114,117,115,75
 DC 150,112,128,112,128,97,150,97
 DC 151,126,150,84,164,83,165,125
 DC 194,122,172,122,172,107,194,107
 DC 200,93,178,93,178,78,200,78
 DC 143,76,141,117,128,116,129,74
 DC 132,76,131,117,117,116,118,74
 DC 152,113,131,113,131,98,152,98
 DC 149,127,148,86,162,84,163,126
 DC 193,121,171,121,171,106,193,106
 DC 201,94,179,94,179,79,201,79
 DC 141,76,140,116,127,115,128,74
 DC 135,76,133,116,120,115,121,74
 DC 155,114,133,114,133,99,155,99
 DC 148,127,147,87,160,86,161,126
 DC 192,121,170,121,170,106,192,106
 DC 201,94,179,94,179,79,201,79
 DC 140,76,139,115,125,113,127,74
 DC 137,76,136,115,123,113,124,74
 DC 157,115,136,115,136,100,157,100
 DC 147,128,145,88,158,87,160,126
 DC 191,121,170,121,170,106,191,106
 DC 201,94,180,94,180,80,201,80
 DC 139,76,137,114,124,112,126,74
 DC 140,76,139,114,126,112,128,74
 DC 160,116,139,116,139,101,160,101
 DC 145,128,144,90,156,88,158,127
 DC 190,120,169,120,169,106,190,106
 DC 201,95,180,95,180,80,201,80
 DC 137,76,136,113,123,111,125,74
 DC 143,76,141,113,129,111,131,74
 DC 162,116,141,116,141,102,162,102
 DC 144,129,142,91,154,90,156,127
 DC 189,120,168,120,168,106,189,106
 DC 201,95,181,95,181,81,201,81
 DC 136,76,134,112,122,110,124,74
 DC 146,76,144,112,132,110,134,74
 DC 164,117,144,117,144,103,164,103
 DC 142,129,140,93,152,91,154,127
 DC 188,120,168,120,168,106,188,106
 DC 201,95,181,95,181,81,201,81
 DC 135,76,133,111,121,109,123,73
 DC 149,76,147,111,135,109,137,73
 DC 167,118,147,118,147,104,167,104
 DC 141,130,139,94,151,92,153,128
 DC 187,119,167,119,167,105,187,105
 DC 202,96,182,96,182,82,202,82
 DC 134,76,131,110,120,108,122,73
 DC 152,76,150,110,138,108,140,73
 DC 169,119,150,119,150,105,169,105
 DC 139,130,137,96,149,93,151,128
 DC 186,119,167,119,167,105,186,105
 DC 202,96,182,96,182,82,202,82
 DC 132,76,130,109,119,107,121,73
 DC 155,76,152,109,141,107,144,73
 DC 172,120,152,120,152,106,172,106
 DC 138,131,136,97,147,95,149,128
 DC 185,119,166,119,166,105,185,105
 DC 202,96,183,96,183,83,202,83
 DC 131,76,128,108,118,106,120,73
 DC 158,76,155,108,144,106,147,73
 DC 174,120,155,120,155,107,174,107
 DC 136,131,134,99,145,96,147,129
 DC 184,118,165,118,165,105,184,105
 DC 202,97,183,97,183,83,202,83
 DC 130,76,127,107,116,104,119,73
 DC 160,76,158,107,147,104,150,73
 DC 176,121,158,121,158,108,176,108
 DC 135,132,132,100,143,97,146,129
 DC 183,118,165,118,165,105,183,105
 DC 202,97,184,97,184,84,202,84
 DC 128,76,126,106,115,103,118,73
 DC 163,76,160,106,150,103,153,73
 DC 179,122,160,122,160,109,179,109
 DC 134,132,131,101,141,99,144,129
 DC 182,118,164,118,164,105,182,105
 DC 202,97,184,97,184,84,202,84
 DC 127,76,124,105,114,102,117,72
 DC 166,76,163,105,153,102,156,72
 DC 181,123,163,123,163,110,181,110
 DC 132,133,129,103,139,100,142,130
 DC 181,117,163,117,163,104,181,104
 DC 203,98,185,98,185,85,203,85
 DC 126,76,123,104,113,101,116,72
 DC 169,76,166,104,156,101,160,72
 DC 184,124,166,124,166,111,184,111
 DC 131,133,128,104,137,101,140,130
 DC 180,117,163,117,163,104,180,104
 DC 203,98,185,98,185,85,203,85
 DC 125,76,121,103,112,100,115,72
 DC 172,76,169,103,159,100,163,72
 DC 186,124,169,124,169,112,186,112
 DC 129,134,126,106,135,102,139,130
 DC 179,117,162,117,162,104,179,104
 DC 203,98,186,98,186,86,203,86
 DC 123,76,120,102,111,99,114,72
 DC 175,76,171,102,162,99,166,72
 DC 188,125,171,125,171,113,188,113
 DC 128,134,124,107,133,104,137,131
 DC 178,116,161,116,161,104,178,104
 DC 203,99,186,99,186,86,203,86
 DC 122,76,118,101,110,98,113,72
 DC 178,76,174,101,165,98,169,72
 DC 191,126,174,126,174,114,191,114
 DC 126,135,123,109,131,105,135,131
 DC 177,116,161,116,161,104,177,104
 DC 203,99,187,99,187,87,203,87
 DC 121,76,117,100,109,97,112,72
 DC 181,76,177,100,168,97,172,72
 DC 193,127,177,127,177,115,193,115
 DC 125,135,121,110,129,106,133,131
 DC 176,116,160,116,160,104,176,104
 DC 203,99,187,99,187,87,203,87
 DC 120,76,116,100,108,96,112,72
 DC 184,76,179,100,172,96,176,72
 DC 196,128,179,128,179,116,196,116
 DC 124,136,120,112,128,108,132,132
 DC 176,116,160,116,160,104,176,104
 DC 204,100,188,100,188,88,204,88
 DC 118,76,114,99,106,94,111,71
 DC 186,76,182,99,175,94,179,71
 DC 198,128,182,128,182,116,198,116
 DC 122,136,118,113,126,109,130,132
 DC 175,115,159,115,159,103,175,103
 DC 204,100,188,100,188,88,204,88
 DC 117,76,113,98,105,93,110,71
 DC 189,76,185,98,178,93,182,71
 DC 200,129,185,129,185,117,200,117
 DC 121,136,116,114,124,110,128,132
 DC 174,115,158,115,158,103,174,103
 DC 204,100,188,100,188,88,204,88
 DC 116,76,111,97,104,92,109,71
 DC 192,76,188,97,181,92,185,71
 DC 203,130,188,130,188,118,203,118
 DC 119,137,115,116,122,111,126,132
 DC 173,115,158,115,158,103,173,103
 DC 204,100,189,100,189,89,204,89
 DC 114,76,110,96,103,91,108,71
 DC 195,76,190,96,184,91,188,71
 DC 205,131,190,131,190,119,205,119
 DC 118,137,113,117,120,113,124,133
 DC 172,114,157,114,157,103,172,103
 DC 204,101,189,101,189,89,204,89
 DC 113,76,108,95,102,90,107,71
 DC 198,76,193,95,187,90,192,71
 DC 208,132,193,132,193,120,208,120
 DC 116,138,112,119,118,114,123,133
 DC 171,114,156,114,156,103,171,103
 DC 204,101,190,101,190,90,204,90
 DC 112,76,107,94,101,89,106,71
 DC 201,76,196,94,190,89,195,71
 DC 210,132,196,132,196,121,210,121
 DC 115,138,110,120,116,115,121,133
 DC 170,114,156,114,156,103,170,103
 DC 204,101,190,101,190,90,204,90
 DC 111,76,105,93,100,88,105,70
 DC 204,76,199,93,193,88,198,70
 DC 212,133,199,133,199,122,212,122
 DC 113,139,108,122,114,116,119,134
 DC 169,113,155,113,155,102,169,102
 DC 205,102,191,102,191,91,205,91
 DC 109,76,104,92,99,87,104,70
 DC 207,76,201,92,196,87,201,70
 DC 215,134,201,134,201,123,215,123
 DC 112,139,107,123,112,118,117,134
 DC 168,113,154,113,154,102,168,102
 DC 205,102,191,102,191,91,205,91
 DC 108,76,103,91,97,85,103,70
 DC 209,76,204,91,199,85,204,70
 DC 217,135,204,135,204,124,217,124
 DC 111,140,105,124,110,119,116,134
 DC 167,113,154,113,154,102,167,102
 DC 205,102,192,102,192,92,205,92
 DC 107,76,101,90,96,84,102,70
 DC 212,76,207,90,202,84,208,70
 DC 220,136,207,136,207,125,220,125
 DC 109,140,104,126,108,120,114,135
 DC 166,112,153,112,153,102,166,102
 DC 205,103,192,103,192,92,205,92
 DC 105,76,100,89,95,83,101,70
 DC 215,76,209,89,205,83,211,70
 DC 222,136,209,136,209,126,222,126
 DC 108,141,102,127,106,122,112,135
 DC 165,112,152,112,152,102,165,102
 DC 205,103,193,103,193,93,205,93
 DC 104,76,98,88,94,82,100,70
 DC 218,76,212,88,208,82,214,70
 DC 224,137,212,137,212,127,224,127
 DC 106,141,100,129,104,123,110,135
 DC 164,112,152,112,152,102,164,102
 DC 205,103,193,103,193,93,205,93
 DC 103,76,97,87,93,81,99,69
 DC 221,76,215,87,211,81,217,69
 DC 227,138,215,138,215,128,227,128
 DC 105,142,99,130,103,124,109,136
 DC 163,111,151,111,151,101,163,101
 DC 206,104,194,104,194,94,206,94
 DC 102,76,95,86,92,80,98,69
 DC 224,76,218,86,214,80,220,69
 DC 229,139,218,139,218,129,229,129
 DC 103,142,97,132,101,125,107,136
 DC 162,111,151,111,151,101,162,101
 DC 206,104,194,104,194,94,206,94
 DC 100,76,94,85,91,79,97,69
 DC 227,76,220,85,217,79,224,69
 DC 232,140,220,140,220,130,232,130
 DC 102,143,96,133,99,127,105,136
 DC 161,111,150,111,150,101,161,101
 DC 206,104,195,104,195,95,206,95
 DC 99,76,92,84,90,78,96,69
 DC 230,76,223,84,220,78,227,69
 DC 234,140,223,140,223,131,234,131
 DC 100,143,94,135,97,128,103,137
 DC 160,110,149,110,149,101,160,101
 DC 206,105,195,105,195,95,206,95
 DC 98,76,91,83,88,76,95,69
 DC 232,76,226,83,223,76,230,69
 DC 236,141,226,141,226,132,236,132
 DC 99,144,92,136,95,129,102,137
 DC 159,110,149,110,149,101,159,101
 DC 206,105,196,105,196,96,206,96
 DC 96,76,90,82,87,75,94,69
 DC 235,76,228,82,226,75,233,69
 DC 239,142,228,142,228,133,239,133
 DC 98,144,91,137,93,131,100,137
 DC 158,110,148,110,148,101,158,101
 DC 206,105,196,105,196,96,206,96
 DC 95,76,88,81,86,74,93,68
 DC 238,76,231,81,229,74,236,68
 DC 241,143,231,143,231,134,241,134
 DC 96,145,89,139,91,132,98,138
 DC 157,109,147,109,147,100,157,100
 DC 207,106,197,106,197,97,207,97
 DC 94,76,87,80,85,73,92,68
 DC 241,76,234,80,232,73,240,68
 DC 244,144,234,144,234,135,244,135
 DC 95,145,88,140,89,133,96,138
 DC 156,109,147,109,147,100,156,100
 DC 207,106,197,106,197,97,207,97
 DC 93,76,85,79,84,72,91,68
 DC 244,76,237,79,235,72,243,68
 DC 246,144,237,144,237,136,246,136
 DC 93,146,86,142,87,134,95,138
 DC 155,109,146,109,146,100,155,100
 DC 207,106,198,106,198,98,207,98
 DC 91,76,84,78,83,71,90,68
 DC 247,76,239,78,238,71,246,68
 DC 248,145,239,145,239,137,248,137
 DC 92,146,84,143,85,136,93,139
 DC 154,108,145,108,145,100,154,100
 DC 207,107,198,107,198,98,207,98
 DC 90,76,82,77,82,70,89,68
 DC 250,76,242,77,241,70,249,68
 DC 251,146,242,146,242,138,251,138
 DC 90,147,83,145,83,137,91,139
 DC 153,108,145,108,145,100,153,100
 DC 207,107,199,107,199,99,207,99
 DC 89,76,81,76,81,69,88,68
 DC 253,76,245,76,244,69,252,68
 DC 253,147,245,147,245,139,253,139
 DC 89,147,81,146,81,138,89,139
 DC 152,108,144,108,144,100,152,100
 DC 207,107,199,107,199,99,207,99
 DC 88,76,80,76,80,67,88,68
 DC 256,76,247,76,248,67,256,68
 DC 256,148,247,148,247,140,256,140
 DC 88,148,80,148,80,140,88,140
 DC 152,108,144,108,144,100,152,100
 DC 208,108,200,108,200,100,208,100
; Forme d'arriv‚e
 DC 152,76,152,124,136,124,136,76
 DC 112,76,112,124,96,124,96,76
 DC 136,108,112,108,112,92,136,92
 DC 160,124,160,76,176,76,176,124
 DC 200,124,176,124,176,108,200,108
 DC 200,92,176,92,176,76,200,76

depla		
	dc	0,0,0
	
PART1	DC.W	%1111111111111111
	DC.W	%0111111111111111
	DC.W	%0011111111111111
	DC.W	%0001111111111111
	DC.W	%0000111111111111
	DC.W	%0000011111111111
	DC.W	%0000001111111111
	DC.W	%0000000111111111
	DC.W	%0000000011111111
	DC.W	%0000000001111111
	DC.W	%0000000000111111
	DC.W	%0000000000011111
	DC.W	%0000000000001111
	DC.W	%0000000000000111
	DC.W	%0000000000000011
	DC.W	%0000000000000001

PART2	DC.W	%1000000000000000
	DC.W	%1100000000000000
	DC.W	%1110000000000000
	DC.W	%1111000000000000
	DC.W	%1111100000000000
	DC.W	%1111110000000000
	DC.W	%1111111000000000
	DC.W	%1111111100000000
	DC.W	%1111111110000000
	DC.W	%1111111111000000
	DC.W	%1111111111100000
	DC.W	%1111111111110000
	DC.W	%1111111111111000
	DC.W	%1111111111111100
	DC.W	%1111111111111110
	DC.W	%1111111111111111

PNTS
N	SET	32768
	REPT	16
	DC.W	N
N	SET	N/2
	ENDR


;	section bss

xe	ds.w 1		;coordonnees spatiales
ye	ds.w 1
ze	ds.w 1

xdep	ds.w 1		;d‚placements
ydep	ds.w 1
zdep	ds.w 1

xp	ds.w 1		;coordonnees planes
yp	ds.w 1

new_xe	ds.w 1		;nouvelles coords 
new_ye	ds.w 1		;aprŠs rotation
new_ze	ds.w 1

x_angle	ds.w 1		;angles de rotation
y_angle	ds.w 1
z_angle	ds.w 1	
 
z_pt_fuite	ds.w 1		;coordonn‚es z du 
			;du point de fuite

var_3d	ds.w 9                  ;tableau pour calculs
POINTEUR	DS.L	1
POINTEUR2	DS.L	1
DATA_X
	DS	NB_POS*NB_PTS
;DATA_Y
	DS	NB_POS*NB_PTS

	DC.L	$FFFFFFFF
	section bss

tdroit	ds.w	800
tgauch	ds.w	800

X1	DS.W	1
X2	DS.W	1
Y	DS.L	1
SENS	DS.W	1

SCREEN2	DS.L	1
SCREEN1	DS.L	1
ANC_VBL	DS.L	1
CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1	
PNT_X	DS.L	1
PNT_Y	DS.L	1
PNT	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	64000
	DS.B	256
