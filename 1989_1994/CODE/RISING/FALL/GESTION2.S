ptchang1	move.l	#tpoly1+2,chbobj
chbobj	equ	*+2
	move.l	tpoly1,d6
  	move.l	d6,a5
  	move.w	(a5)+,plan
  	lea.l	t_points,a1	*point	Y1		


ncaches
;	move.w	(a5)+,d0	*d0=ndpoints
	MOVEQ	#4,D0

	moveq.l	#0,d7
	add.w	d0,d7
	subq.l	#2,d0	*calc avec tpoint
	
	move.w	(a5),d1	offset pt1
	move.w	2(a1,d1),d2	y du pt1
	lea.l	2(a5),a2	a2=a5+2=pointe offset pt2
	move.w	(a2)+,d3	offset pt2
t_petit
	cmp.w	2(a1,d3.w),d2	cmp ypt2,ypt1
	blt.s	st_ptit
	lea.l	-2(a2),a5	a5=a2+2-2=a5+2=offset pt2
	move.w	2(a1,d3.w),d2	d2=ypt2
st_ptit
	move.w	(a2)+,d3
	dbra.w	d0,t_petit				
********************************************************************	
;d2=ymin
;	move.w	d2,codmpyin+2	*calc ligne
	;d2 sera *‚ par 160 et add‚ … l'adr ‚cran

;	lea.l	calc(pc),a4	*pas touch
			*point=a1			*pointpoint=a5
			*tdpoint=a5
	add.w	d7,d7	
	addq.l	#4,d6	d6=tpoly1+4
	add.l	d6,d7		
			*d7=fin de table
			*calc tgauche
	lea.l	tgauch,a3
	lea.l	(a5),a2
b_calct_g	
	move.w	(a2)+,d4	*pointe suivant tabe
	move.w	(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	
	cmp.l	d7,a2	
	bne.s	s_calct_g
	move.l	d6,a2
s_calct_g	
	move.w	(a2),d4	
	move.w	(a1,d4.w),d2
	move.w	2(a1,d4.w),d3
	
	cmp.w	d3,d1
	bgt.s	s1_calct_g	
	bsr	calcord
	bra.b	b_calct_g	
s1_calct_g		
	move.w	#0,(a3)
				**droit
	lea.l	tdroit,a3
	move.l	d7,mcodtd+2
	move.l	d6,d7	
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
	move.w	#-4,(a3)
******************************************************************
tpoly1	dc.w	6-1
	dc.l	face11,face12,face13,face14,face15,face16 	

face11	dc.w	$5488,4,0,4,8,12
face12	dc.w	$5888,4,16,0,12,28
face13	dc.w	$5c88,4,12,8,24,28
face14	dc.w	$5888,4,4,20,24,8
face15	dc.w	$5c88,4,16,20,4,0 
face16	dc.w	$4e71,4,28,24,20,16

tpoitesp1	
	dc.w	8-1
	dc.w	-50,-50,-50		0
	dc.w	-50,50,-50		1*4
	dc.w	50,50,-50		3
	dc.w	50,-50,-50		4
	dc.w	-50,-50,50		5
	dc.w	-50,50,50		6
	dc.w	50,50,50		7
	dc.w	50,-50,50		8
*****************************************************
plan
t_points