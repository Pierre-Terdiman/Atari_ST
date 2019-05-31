NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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

	lea var_3d,a6	;a6 poi dc 0
 dc 3
 dc 6
 dc 10
 dc 13
 dc 17
 dc 20
 dc 24
 dc 27
 dc 30
 dc 34
 dc 37
 dc 40
 dc 43
 dc 46
 dc 49
 dc 52
 dc 55
 dc 58
 dc 61
 dc 64
 dc 66
 dc 69
 dc 71
 dc 74
 dc 76
 dc 78
 dc 80
 dc 82
 dc 84
 dc 86
 dc 88
 dc 89
 dc 91
 dc 92
 dc 93
 dc 95
 dc 96
 dc 97
 dc 97
 dc 98
 dc 99
 dc 99
 dc 99
 dc 99
 dc 100
 dc 99
 dc 99
 dc 99
 dc 99
 dc 98
 dc 97
 dc 97
 dc 96
 dc 95
 dc 93
 dc 92
 dc 91
 dc 89
 dc 88
 dc 86
 dc 84
 dc 82
 dc 80
 dc 78
 dc 76
 dc 74
 dc 71
 dc 69
 dc 66
 dc 64
 dc 61
 dc 58
 dc 55
 dc 52
 dc 49
 dc 46
 dc 43
 dc 40
 dc 37
 dc 34
 dc 30
 dc 27
 dc 24
 dc 20
 dc 17
 dc 13
 dc 10
 dc 6
 dc 3
 dc -1
 dc -4
 dc -7
 dc -11
 dc -14
 dc -18
 dc -21
 dc -25
 dc -28
 dc -31
 dc -35
 dc -38
 dc -41
 dc -44
 dc -47
 dc -51
 dc -53
 dc -56
 dc -59
 dc -62
 dc -65
 dc -67
 dc -70
 dc -72
 dc -75
 dc -77
 dc -79
 dc -81
 dc -83
 dc -85
 dc -87
 dc -89
 dc -90
 dc -92
 dc -NB_PTS=400
PAS=4
NB_POS=360/PAS

	clr	x_angle
	clr	y_angle
	clr	z_angle

	CLR.L	POINTEUR
	
	LEA	DATA_Y,A2
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
;	ADD	#2*PAS,z_angle
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
	move.w (a6)+,d0	;d0=