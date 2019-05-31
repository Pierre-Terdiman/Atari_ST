TAILLE=5056
NB_PTS=64
NB_POS=79

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	LEA	DATAS2,A1
;	MOVE	#16*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	move	#256,z_pt_fuite
	move.l	#NB_POS-1,d7
ici	;CLR.L	POINTEUR
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	jsr	trigo
	MOVE	#NB_PTS-1,D6
UN_PT	jsr	sp_to_pl
	jsr	ROUTINE2
	DBF	D6,UN_PT
;	ADD	#2,x_angle
;	ADD	#2,y_angle
	ADD	#6,z_angle
	dbf	d7,ici

	clr	x_angle
	clr	y_angle
	clr	z_angle
	CLR.L	POINTEUR
	LEA	DATAS3,A1
;	MOVE	#16*2,x_angle
;	MOVE	#16*2,y_angle
;	MOVE	#16*2,z_angle
	move	#256,z_pt_fuite
	move.l	#NB_POS-1,d7
ici2	;CLR.L	POINTEUR
	MOVEQ	#0,D1
	MOVEQ	#0,D0
	jsr	trigo
	MOVE	#NB_PTS-1,D6
UN_PT2	jsr	sp_to_pl
	jsr	ROUTINE2
	DBF	D6,UN_PT2
;	ADD	#2,x_angle
	ADD	#6,y_angle
;	ADD	#2,z_angle
	dbf	d7,ici2

	LEA	TABLE_X,A0
	LEA	TABLE_X2,A1
	MOVEQ	#0,D0
DO_TX	MOVE.L	D0,D7
	MOVEQ	#0,D2
	DIVU	#16,D0
	MOVE	D0,D2
	LSL	#3,D2
	*MOVE	#$004,$FFFF8240.W
	MOVE	D2,(A0)	OFFSET
	SWAP	D0
	CMPI	#$7,D0
	BGT.S	PLUS_UN
	BRA.S	PLUS_LOIN
PLUS_UN	ADDQ	#1,(A0)
	SUBQ.L	#8,D0
PLUS_LOIN	
	LEA	KK,A5
	LSL	#3,D0
	JSR	(A5,D0.W)
	MOVE.B	D0,(A1)+
	LEA	2(A0),A0
	MOVE.L	D7,D0
	ADDQ.L	#1,D0
	CMPI.L	#320,D0
	BNE	DO_TX
	MOVE.L	#BUFEFF,D0
	MOVE.L	D0,DATEFF
	ADD.L	#64*6,D0
	MOVE.L	D0,DATEFF2
	JMP	PROG

KK	MOVE.B	#%10000000,D0
	NOP
	RTS
	MOVE.B	#%01000000,D0
	NOP
	RTS
	MOVE.B	#%00100000,D0
	NOP
	RTS	
	MOVE.B	#%00010000,D0
	NOP
	RTS	
	MOVE.B	#%00001000,D0
	NOP
	RTS	
	MOVE.B	#%00000100,D0
	NOP
	RTS
	MOVE.B	#%00000010,D0
	NOP
	RTS
	MOVE.B	#%00000001,D0
	NOP
	RTS

**

sp_to_pl movem.l d0-d7/a1-a6,-(a7)
	lea DATAS,a6		;a6 pointe coords
	ADDA.L	POINTEUR,A6
	move.w (a6)+,d0	;d0=xe
	move.w (a6)+,d1	;d1=ye
	moveq	#0,d2
	ADDQ.L	#4,POINTEUR

	sub	#160,d0
	sub	#100,d1

	
	lea depla,a3
;	ADDA.L	POINTEUR2,A3
;	move.w (a3)+,d3	;xdep
;	move.w (a3)+,d4	;ydep
	move.w (a3)+,d5	;zdep
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
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
;	MOVE	D7,ZA	
	movem.l (a7)+,d0-d7/a1-a6
	rts

ROUTINE2
	MOVE	xp,(A1)+
	MOVE	yp,(A1)+
	RTS

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

**
cos_tab	incbin 'COSIN.DAT'	;tables sinus cosinus
sin_tab	equ cos_tab+720
	EVEN
depla
	DC	0,0,0
	EVEN

POINTEUR	DS.L	1
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

var_3d	ds.w 9                  ;tableau pour calculs
*************
;***************************************************************************
; Unpacking source for Pack-Ice Version 2.1
; a0: Pointer on packed Data
; a1: Pointer on destination of unpacked data
decrunch:	movem.l d0-a6,-(sp)
		cmpi.l	#'Ice!',(a0)+	; Is data packed?
		bne.s	ice_03		; no!
		move.l	(a0)+,d0	; read packed data
		lea	-8(a0,d0.l),a5
		move.l	(a0)+,(sp)
		movea.l a1,a4
		movea.l a1,a6
		adda.l	(sp),a6
		movea.l a6,a3
		bsr.s	ice_08
		bsr.s	ice_04
		bsr	ice_0c		;; Picture decrunch!
		bcc.s	ice_03		;; These marked lines may be
		move.w	#$0f9f,d7	;; removed in your own sources
ice_00:		moveq	#3,d6		;; if you do not use the
ice_01:		move.w	-(a3),d4	;; additional algorithm.
		moveq	#3,d5		;;
ice_02:		add.w	d4,d4		;;
		addx.w	d0,d0		;;
		add.w	d4,d4		;;
		addx.w	d1,d1		;;
		add.w	d4,d4		;;
		addx.w	d2,d2		;;
		add.w	d4,d4		;;
		addx.w	d3,d3		;;
		dbra	d5,ice_02	;;
		dbra	d6,ice_01	;;
		movem.w d0-d3,(a3)	;;
		dbra	d7,ice_00	;;
ice_03:		movem.l (sp)+,d0-a6
		rts
ice_04:		bsr.s	ice_0c
		bcc.s	ice_07
		moveq	#0,d1
		bsr.s	ice_0c
		bcc.s	ice_06
		lea	ice_1a(pc),a1
		moveq	#4,d3
ice_05:		move.l	-(a1),d0
		bsr.s	ice_0f
		swap	d0
		cmp.w	d0,d1
		dbne	d3,ice_05
		add.l	20(a1),d1
ice_06:		move.b	-(a5),-(a6)
		dbra	d1,ice_06
ice_07:		cmpa.l	a4,a6
		bgt.s	ice_12
		rts
ice_08:		moveq	#3,d0
ice_09:		move.b	-(a5),d7
		ror.l	#8,d7
		dbra	d0,ice_09
		rts
ice_0a:		move.w	a5,d7
		btst	#0,d7
		bne.s	ice_0b
		move.l	-(a5),d7
		addx.l	d7,d7
		bra.s	ice_11
ice_0b:		move.l	-5(a5),d7
		lsl.l	#8,d7
		move.b	-(a5),d7
		subq.l	#3,a5
		add.l	d7,d7
		bset	#0,d7
		bra.s	ice_11
ice_0c:		add.l	d7,d7
		beq.s	ice_0d
		rts
ice_0d:		move.w	a5,d7
		btst	#0,d7
		bne.s	ice_0e
		move.l	-(a5),d7
		addx.l	d7,d7
		rts
ice_0e:		move.l	-5(a5),d7
		lsl.l	#8,d7
		move.b	-(a5),d7
		subq.l	#3,a5
		add.l	d7,d7
		bset	#0,d7
		rts
ice_0f:		moveq	#0,d1
ice_10:		add.l	d7,d7
		beq.s	ice_0a
ice_11:		addx.w	d1,d1
		dbra	d0,ice_10
		rts
ice_12:		lea	ice_1b(pc),a1
		moveq	#3,d2
ice_13:		bsr.s	ice_0c
		dbcc	d2,ice_13
		moveq	#0,d4
		moveq	#0,d1
		move.b	1(a1,d2.w),d0
		ext.w	d0
		bmi.s	ice_14
		bsr.s	ice_0f
ice_14:		move.b	6(a1,d2.w),d4
		add.w	d1,d4
		beq.s	ice_16
		lea	ice_1c(pc),a1
		moveq	#1,d2
ice_15:		bsr.s	ice_0c
		dbcc	d2,ice_15
		moveq	#0,d1
		move.b	1(a1,d2.w),d0
		ext.w	d0
		bsr.s	ice_0f
		add.w	d2,d2
		add.w	6(a1,d2.w),d1
		bra.s	ice_18
ice_16:		moveq	#0,d1
		moveq	#5,d0
		moveq	#0,d2
		bsr.s	ice_0c
		bcc.s	ice_17
		moveq	#8,d0
		moveq	#$40,d2
ice_17:		bsr.s	ice_0f
		add.w	d2,d1
ice_18:		lea	2(a6,d4.w),a1
		adda.w	d1,a1
		move.b	-(a1),-(a6)
ice_19:		move.b	-(a1),-(a6)
		dbra	d4,ice_19
		bra	ice_04
		DC.B $7f,$ff,$00,$0e,$00,$ff,$00,$07
		DC.B $00,$07,$00,$02,$00,$03,$00,$01
		DC.B $00,$03,$00,$01
ice_1a:		DC.B $00,$00,$01,$0d,$00,$00,$00,$0e
		DC.B $00,$00,$00,$07,$00,$00,$00,$04
		DC.B $00,$00,$00,$01
ice_1b:		DC.B $09,$01,$00,$ff,$ff,$08,$04,$02
		DC.B $01,$00
ice_1c:		DC.B $0b,$04,$07,$00,$01,$20,$00,$00
		DC.B $00,$20
	EVEN
Z_LOG	INCBIN	ZAPPY.PI1
	EVEN
FAD_Z	
	DC $001,$777,$444,$000,$000,$000,$000,$000
	DCB	8,0
	
	DC $001,$666,$333
	DCB	13,0

	DC $001,$555,$222
	DCB	13,0

	DC $001,$444,$111
	DCB	13,0

	DC $001,$333,$001
	DCB	13,0

	DC $001,$222,$001
	DCB	13,0
	DC $001,$111,$001
	DCB	13,0
	DC $001,$001,$001
	DCB	13,0
	
	DC $000,$001,$001,$001,$001,$001,$001,$001
	DC $001,$001,$001,$001,$001,$001,$001,$001
	DC.L	-1
	
FAD_Z2	DC $000,$001,$002,$002,$002,$002,$002,$001
	DC $002,$002,$002,$002,$002,$002,$002,$002

	DC $000,$001,$002,$003,$003,$003,$002,$001
	DC $003,$002,$003,$003,$003,$002,$003,$003

	DC $000,$001,$002,$003,$004,$004,$002,$001
	DC $003,$002,$004,$004,$004,$002,$003,$004

	DC $000,$001,$002,$003,$005,$005,$002,$001
	DC $003,$002,$005,$005,$005,$002,$003,$005

	DC $000,$001,$002,$003,$005,$006,$002,$001
	DC $003,$002,$006,$006,$006,$002,$003,$006

	DC $000,$001,$002,$003,$005,$007,$002,$001
	DC $003,$002,$007,$007,$007,$002,$003,$007

	DC $000,$001,$012,$013,$015,$017,$012,$001
	DC $013,$012,$017,$017,$007,$012,$013,$017

	DC $000,$001,$012,$023,$025,$027,$012,$001
	DC $023,$022,$027,$027,$007,$022,$023,$027

	DC $000,$001,$012,$023,$035,$037,$012,$001
	DC $033,$022,$037,$037,$007,$022,$033,$037

	DC $000,$001,$012,$023,$045,$047,$012,$001
	DC $043,$022,$047,$047,$007,$022,$033,$047

	DC $000,$001,$012,$023,$045,$057,$012,$001
	DC $043,$022,$057,$047,$007,$022,$033,$057

	DC $000,$001,$012,$023,$045,$067,$012,$001
	DC $043,$022,$067,$047,$007,$022,$033,$067

	DC $000,$001,$012,$023,$045,$067,$012,$001
	DC $043,$022,$077,$047,$007,$022,$033,$077

	DC $000,$101,$112,$123,$145,$167,$112,$001
	DC $143,$022,$177,$147,$007,$122,$133,$177

	DC $000,$101,$212,$223,$245,$267,$112,$001
	DC $143,$022,$277,$247,$007,$222,$233,$277

	DC $000,$101,$212,$323,$345,$367,$112,$001
	DC $143,$022,$377,$347,$007,$222,$333,$377

	DC $000,$101,$212,$323,$445,$467,$112,$001
	DC $143,$022,$477,$347,$007,$222,$333,$477

	DC $000,$101,$212,$323,$545,$567,$112,$001
	DC $143,$022,$577,$347,$007,$222,$333,$577

	DC $000,$101,$212,$323,$545,$667,$112,$001
	DC $143,$022,$677,$347,$007,$222,$333,$677
	
	DC $000,$101,$212,$323,$545,$767,$112,$001
	DC $143,$022,$677,$347,$007,$222,$333,$777
	DC.L	-1
FAD_Z3	DC $000,$000,$101,$212,$434,$656,$001,$000
	DC $032,$011,$566,$236,$006,$111,$222,$666
	DC $000,$000,$000,$101,$323,$545,$000,$000
	DC $021,$000,$455,$125,$005,$000,$111,$555
	DC $000,$000,$000,$000,$212,$434,$000,$000
	DC $010,$000,$344,$014,$004,$000,$000,$444
	DC $000,$000,$000,$000,$101,$323,$000,$000
	DC $000,$000,$233,$003,$003,$000,$000,$333
	DC $000,$000,$000,$000,$000,$212,$000,$000
	DC $000,$000,$122,$002,$002,$000,$000,$222
	DC $000,$000,$000,$000,$000,$101,$000,$000
	DC $000,$000,$011,$001,$001,$000,$000,$111
	DCB	16,0
	DC.L	-1

ANC_VBL	DS.L	1
FORCE_DEMO	DS.L	1
PNT_FAD	DS.L	1
PNT_FAD2	DS.L	1
*************

PROG
	PEA	0.W
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#FINI,$8.W
	MOVE.L	#FINI,$C.W
	MOVE.L	#FINI,$10.W
	
          LEA     ZIK+2688(PC),A0 
          LEA     ZIK+12(PC),A1 
          MOVE.L  A0,(A1) 
          MOVEQ   #6,D0 
          JSR	ZIK
	
	MOVE.L	#BUF,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#32000,D0
	MOVE.L	D0,SCREEN2
	ADD.L	#32000,D0
	MOVE.L	D0,SCREEN3

	JSR	INIT_TXT

	LEA	ADR_ROUTS,A0
	LEA	TABLE_ADR,A1
	MOVE.L	A0,(A1)+
	MOVEQ	#0,D0
	MOVE	#255,D7
GENERATION	CLR	OFFSET
	MOVEQ	#7,D1
TEST_X	BTST	D1,D0
	BNE	BIT_A_UN
CONTINUE	ADDQ	#4,OFFSET
	DBF	D1,TEST_X
	MOVE	#$4E75,(A0)+
	MOVE.L	A0,(A1)+
	ADDQ.L	#1,D0
	DBF	D7,GENERATION
	MOVE	#$444,$FFFF8244.W
	MOVE	#$777,$FFFF8242.W
	MOVE	#$001,$FFFF8240.W
	MOVE.L	#VBL,$70.W

	LEA	Z_LOG,A0
	MOVE.L	SCREEN3,A1
	JSR	decrunch
WET	CMPI.L	#0,FORCE_DEMO
	BEQ.S	WET
FAD1	LEA	FAD_Z,A0
	ADDA.L	PNT_FAD,A0
	CMPI.B	#-1,(A0)
	BEQ.S	OKAYGO
	MOVEM.L	(A0),D0-D6/A1
	MOVEM.L	D0-D6/A1,$FFFF8240.W
	ADD.L	#16*2,PNT_FAD
XETY	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#10000,PNT_FAD2
	BNE.S	XETY
	CLR.L	PNT_FAD2
	BRA.S	FAD1
OKAYGO	
	MOVE.L	#VBL_ZIK,$70.W
	MOVE.L	SCREEN1,A0
	LEA	48*160(A0),A0
	MOVE.L	SCREEN2,A1
	LEA	48*160(A1),A1
	MOVE.L	SCREEN3,A2
	LEA	34(A2),A2
	MOVE	#((96*160)/4)-1,D0
AFF_Z	MOVE.L	(A2),(A0)+
	MOVE.L	(A2)+,(A1)+
	DBF	D0,AFF_Z
	CLR.L	PNT_FAD
	CLR.L	PNT_FAD2
FAD2	LEA	FAD_Z2,A0
	ADDA.L	PNT_FAD,A0
	CMPI.B	#-1,(A0)
	BEQ.S	OKAYGO2
	MOVEM.L	(A0),D0-D6/A1
	MOVEM.L	D0-D6/A1,$FFFF8240.W
	ADD.L	#16*2,PNT_FAD
XETY2	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#10000,PNT_FAD2
	BNE.S	XETY2
	CLR.L	PNT_FAD2
	BRA.S	FAD2
OKAYGO2	CLR.L	PNT_FAD2
PQ2	CLR.L	PNT_FAD
PQ	ADDQ.L	#1,PNT_FAD
	CMPI.L	#10000,PNT_FAD
	BNE.S	PQ
	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#20,PNT_FAD2
	BNE.S	PQ2
	
	CLR.L	PNT_FAD
	CLR.L	PNT_FAD2
FAD3	LEA	FAD_Z3,A0
	ADDA.L	PNT_FAD,A0
	CMPI.B	#-1,(A0)
	BEQ.S	OKAYGO3
	MOVEM.L	(A0),D0-D6/A1
	MOVEM.L	D0-D6/A1,$FFFF8240.W
	ADD.L	#16*2,PNT_FAD
XETY3	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#5000,PNT_FAD2
	BNE.S	XETY3
	CLR.L	PNT_FAD2
	BRA.S	FAD3
OKAYGO3	JSR	INIT_TXT
	CLR.L	COMPTEUR
	JSR	EFF_SCR
	MOVE.L	#TEXTE2,MODIF
	MOVE	#$444,$FFFF8244.W
	MOVE	#$777,$FFFF8242.W
	MOVE	#$001,$FFFF8240.W
	MOVE.L	#VBL,$70.W

J	BRA.S	J
VBL_ZIK	
	MOVEM.L	D0-A6,-(SP)
	JSR	ZIK+8
	MOVEM.L	(SP)+,D0-A6
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FINI
	RTE
	
VBL	MOVEM.L	D0-A6,-(SP)
;GLOUBI	MOVE.L	$466.W,D4
;WAIT	CMP.L	$466.W,D4
;	BEQ.S	WAIT
	JSR	ZIK+8
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	NO_COLOR
	ST	$FFFF8240.W
NO_COLOR	;MOVE	#$444,$FFFF8244.W
	;MOVE	#$777,$FFFF8242.W
	JSR	GERE_EFF
;	MOVE.L	SCREEN1,A4
;	MOVEQ	#0,D0	
;	MOVE	#199,D7
;EFFACE	MOVE	D0,(A4)
;	MOVE	D0,8(A4)
;	MOVE	D0,16(A4)
;	MOVE	D0,24(A4)
;	MOVE	D0,32(A4)
;	MOVE	D0,40(A4)
;	MOVE	D0,48(A4)
;	MOVE	D0,56(A4)
;	MOVE	D0,64(A4)
;	MOVE	D0,72(A4)
;	MOVE	D0,80(A4)
;	MOVE	D0,88(A4)
;	MOVE	D0,96(A4)
;	MOVE	D0,104(A4)
;	MOVE	D0,112(A4)
;	MOVE	D0,120(A4)
;	MOVE	D0,128(A4)
;	MOVE	D0,136(A4)
;	MOVE	D0,144(A4)
;	MOVE	D0,152(A4)
;	LEA	160(A4),A4
;	DBF	D7,EFFACE
***
	MOVE.L	DATEFF,A6

	MOVEM.L	REGS1,D0-A5
	MOVE.L	SAVEPNTPLAN,PNT_PLAN
	MOVE.L	SAVEPNTTXT,PNT_TXT
	MOVE.L	SAVEPNTDATAS,PNT_DATAS
	MOVE	SAVEXDEP,X_DEP
	MOVE	SAVEYDEP,Y_DEP
	MOVE.L	NB_LETTERS,NBLET
	MOVE.L	SAVEDAT,DAT_PNT
	JSR	BIG_ROUTY
	MOVE.L	DAT_PNT,SAVEDAT
	MOVE.L	NBLET,NB_LETTERS
	MOVE.L	PNT_PLAN,SAVEPNTPLAN
	MOVE.L	PNT_TXT,SAVEPNTTXT
	MOVE.L	PNT_DATAS,SAVEPNTDATAS
	MOVE	Y_DEP,SAVEYDEP
	MOVE	X_DEP,SAVEXDEP
	MOVEM.L	D0-A5,REGS1

	CMPI.L	#81,COMPTEUR
	BEQ.S	NO_ADD
	ADDQ.L	#1,COMPTEUR
NO_ADD	CMPI.L	#13,COMPTEUR
	BLE	NO_SECOND	

	MOVEM.L	REGS2,D0-A5
	MOVE.L	SAVEPNTPLAN2,PNT_PLAN
	MOVE.L	SAVEPNTTXT2,PNT_TXT
	MOVE.L	SAVEPNTDATAS2,PNT_DATAS
	MOVE	SAVEXDEP2,X_DEP
	MOVE	SAVEYDEP2,Y_DEP
	MOVE.L	NB_LETTERS2,NBLET
	MOVE.L	SAVEDAT2,DAT_PNT
	
	JSR	BIG_ROUTY
	
	MOVE.L	DAT_PNT,SAVEDAT2
	MOVE.L	NBLET,NB_LETTERS2
	MOVE.L	PNT_PLAN,SAVEPNTPLAN2
	MOVE.L	PNT_TXT,SAVEPNTTXT2
	MOVE.L	PNT_DATAS,SAVEPNTDATAS2
	MOVE	X_DEP,SAVEXDEP2
	MOVE	Y_DEP,SAVEYDEP2
	MOVEM.L	D0-A5,REGS2
NO_SECOND
	CMPI.L	#26,COMPTEUR
	BLE	NO_THIRD
	MOVEM.L	REGS3,D0-A5
	MOVE.L	SAVEPNTPLAN3,PNT_PLAN
	MOVE.L	SAVEPNTTXT3,PNT_TXT
	MOVE.L	SAVEPNTDATAS3,PNT_DATAS
	MOVE	SAVEXDEP3,X_DEP
	MOVE	SAVEYDEP3,Y_DEP
	MOVE.L	NB_LETTERS3,NBLET
	MOVE.L	SAVEDAT3,DAT_PNT

	JSR	BIG_ROUTY

	MOVE.L	DAT_PNT,SAVEDAT3
	MOVE.L	NBLET,NB_LETTERS3
	MOVE.L	PNT_PLAN,SAVEPNTPLAN3
	MOVE.L	PNT_TXT,SAVEPNTTXT3
	MOVE.L	PNT_DATAS,SAVEPNTDATAS3
	MOVE	X_DEP,SAVEXDEP3
	MOVE	Y_DEP,SAVEYDEP3
	MOVEM.L	D0-A5,REGS3
NO_THIRD
	CMPI.L	#39,COMPTEUR
	BLE	NO_FOURTH
	MOVEM.L	REGS4,D0-A5
	MOVE.L	SAVEPNTPLAN4,PNT_PLAN
	MOVE.L	SAVEPNTTXT4,PNT_TXT
	MOVE.L	SAVEPNTDATAS4,PNT_DATAS
	MOVE	SAVEXDEP4,X_DEP
	MOVE	SAVEYDEP4,Y_DEP
	MOVE.L	NB_LETTERS4,NBLET
	MOVE.L	SAVEDAT4,DAT_PNT

	JSR	BIG_ROUTY

	MOVE.L	DAT_PNT,SAVEDAT4
	MOVE.L	NBLET,NB_LETTERS4
	MOVE.L	PNT_PLAN,SAVEPNTPLAN4
	MOVE.L	PNT_TXT,SAVEPNTTXT4
	MOVE.L	PNT_DATAS,SAVEPNTDATAS4
	MOVE	X_DEP,SAVEXDEP4
	MOVE	Y_DEP,SAVEYDEP4
	MOVEM.L	D0-A5,REGS4
NO_FOURTH	CMPI.L	#52,COMPTEUR
	BLE	NO_FIFTH
	MOVEM.L	REGS5,D0-A5
	MOVE.L	SAVEPNTPLAN5,PNT_PLAN
	MOVE.L	SAVEPNTTXT5,PNT_TXT
	MOVE.L	SAVEPNTDATAS5,PNT_DATAS
	MOVE	SAVEXDEP5,X_DEP
	MOVE	SAVEYDEP5,Y_DEP
	MOVE.L	NB_LETTERS5,NBLET
	MOVE.L	SAVEDAT5,DAT_PNT

	JSR	BIG_ROUTY

	MOVE.L	DAT_PNT,SAVEDAT5
	MOVE.L	NBLET,NB_LETTERS5
	MOVE.L	PNT_PLAN,SAVEPNTPLAN5
	MOVE.L	PNT_TXT,SAVEPNTTXT5
	MOVE.L	PNT_DATAS,SAVEPNTDATAS5
	MOVE	X_DEP,SAVEXDEP5
	MOVE	Y_DEP,SAVEYDEP5
	MOVEM.L	D0-A5,REGS5
NO_FIFTH	CMPI.L	#65,COMPTEUR
	BLE	NO_SIX
	MOVEM.L	REGS6,D0-A5
	MOVE.L	SAVEPNTPLAN6,PNT_PLAN
	MOVE.L	SAVEPNTTXT6,PNT_TXT
	MOVE.L	SAVEPNTDATAS6,PNT_DATAS
	MOVE	SAVEXDEP6,X_DEP
	MOVE	SAVEYDEP6,Y_DEP
	MOVE.L	NB_LETTERS6,NBLET
	MOVE.L	SAVEDAT6,DAT_PNT

	JSR	BIG_ROUTY

	MOVE.L	DAT_PNT,SAVEDAT6
	MOVE.L	NBLET,NB_LETTERS6
	MOVE.L	PNT_PLAN,SAVEPNTPLAN6
	MOVE.L	PNT_TXT,SAVEPNTTXT6
	MOVE.L	PNT_DATAS,SAVEPNTDATAS6
	MOVE	X_DEP,SAVEXDEP6
	MOVE	Y_DEP,SAVEYDEP6
	MOVEM.L	D0-A5,REGS6
NO_SIX
	MOVE.L	SCREEN1,A4
	clr.l	(a4)

	move.l	DATEFF,d0	
	MOVE.L	DATEFF2,DATEFF
	MOVE.L	D0,DATEFF2
	
	move.l	SCREEN1,d0	
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	MOVEM.L	(SP)+,D0-A6
	
;	MOVE	#$001,$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FINI
	RTE
	
FINI	MOVE.L	ANC_VBL,$70.W
	MOVE	#$004,$FFFF8240.W
	MOVE	#$777,$FFFF8242.W
	JSR	ZIK+4
	PEA	0.W
	TRAP	#1

EFF_SCR	MOVE.L	SCREEN1,A0
	MOVE.L	SCREEN2,A1
	MOVE	#7999,D0
LKJH	CLR.L	(A0)+
	CLR.L	(A1)+
	DBF	D0,LKJH
	RTS
BIG_ROUTY
	MOVE.L	SCREEN1,A4
	ADDA.L	PNT_PLAN,A4
	LEA	TABLE_X,A5
;	LEA	TABLE_X2,A6
	MOVE.L	DAT_PNT,A0
	ADDA.L	PNT_DATAS,A0
MODIF	EQU	*+2
	LEA	TEXTE,A3
	ADDA.L	PNT_TXT,A3
	CMPI.B	#-1,(A3)	
	BEQ	FINITO2
	LEA	FONT8_8,A1
	MOVEQ	#7,D4
	MOVEQ	#0,D3
	MOVE.B	(A3),D3
	SUBI.B	#32,D3
	LSL	#3,D3
	ADDA.L	D3,A1
	LEA	TABLE_Y,A3
DO_LINE	MOVEQ	#0,D3
	MOVE.B	(A1)+,D3
	LSL	#2,D3
	LEA	TABLE_ADR,A2
	ADDA.L	D3,A2
	MOVE.L	(A2),A2
	JSR	(A2)
	LEA	8*4(A0),A0
	DBF	D4,DO_LINE

	CMPI.L	#1,NBLET
	BNE.S	NON_RT
	CLR.L	NBLET
	BRA.S	GO
	
NON_RT	SUB.L	#64*4,PNT_DATAS
	CMPI.L	#0,PNT_DATAS
	BEQ.S	PLAN_2
	BRA.S	PLAN_1
PLAN_2	MOVE.L	#2,PNT_PLAN
	MOVE.L	#1,NBLET
	BRA.S	GO
PLAN_1	CLR.L	PNT_PLAN
GO	CMPI.L	#-64*4,PNT_DATAS
	BNE.S	FINITO
	MOVE.L	#TAILLE*4-64*4,PNT_DATAS
	ADDQ.L	#6,PNT_TXT

;	LEA	TEXTE,A3	*
;	ADDA.L	PNT_TXT,A3	*	
;	CMPI.B	#$20,(A3)	*
;	BNE.S	LET_US_GO	*
;	MOVE.L	#64*4,PNT_DATAS	*
LET_US_GO	
	ADD	#8*6,X_DEP
	CMP	#160,X_DEP
	BLT.S	FINITO
	SUB	#160+152,X_DEP
	ADDQ	#8,Y_DEP
FINITO	RTS
FINITO2	MOVE.L	#1,FORCE_DEMO	
	RTS
NBLET	DS.L	1

REGS1	DS.L	16
DAT_PNT	DS.L	1
SAVEPNTTXT	DS.L	1
SAVEPNTPLAN	DS.L	1
SAVEPNTDATAS	DS.L	1
NB_LETTERS	DS.L	1
SAVEDAT	DS.L	1

REGS2	DS.L	16
SAVEPNTTXT2	DS.L	1
SAVEPNTPLAN2	DS.L	1
SAVEPNTDATAS2	DS.L	1
NB_LETTERS2	DS.L	1
SAVEDAT2	DS.L	1

REGS3	DS.L	16
SAVEPNTTXT3	DS.L	1
SAVEPNTPLAN3	DS.L	1
SAVEPNTDATAS3	DS.L	1
NB_LETTERS3	DS.L	1
SAVEDAT3	DS.L	1
SAVEXDEP	DS	1
SAVEYDEP	DS	1
SAVEXDEP2	DS	1
SAVEYDEP2	DS	1
SAVEXDEP3	DS	1
SAVEYDEP3	DS	1

REGS4	DS.L	16
DAT_PNT4	DS.L	1
SAVEPNTTXT4	DS.L	1
SAVEPNTPLAN4	DS.L	1
SAVEPNTDATAS4	DS.L	1
NB_LETTERS4	DS.L	1
SAVEDAT4	DS.L	1

REGS5	DS.L	16
SAVEPNTTXT5	DS.L	1
SAVEPNTPLAN5	DS.L	1
SAVEPNTDATAS5	DS.L	1
NB_LETTERS5	DS.L	1
SAVEDAT5	DS.L	1

REGS6	DS.L	16
SAVEPNTTXT6	DS.L	1
SAVEPNTPLAN6	DS.L	1
SAVEPNTDATAS6	DS.L	1
NB_LETTERS6	DS.L	1
SAVEDAT6	DS.L	1
SAVEXDEP4	DS	1
SAVEYDEP4	DS	1
SAVEXDEP5	DS	1
SAVEYDEP5	DS	1
SAVEXDEP6	DS	1
SAVEYDEP6	DS	1

PNT_DATAS	DS.L	1
PNT_TXT	DS.L	1
PNT_PLAN	DS.L	1
BIT_A_UN	MOVE	#$3028,(A0)+	MOVE OFFSET(A0),D0
	MOVE	OFFSET,(A0)+
	MOVE	#$3228,(A0)+	MOVE OFFSET+2(A0),D1
	MOVE	OFFSET,(A0)
	ADD	#2,(A0)+
	MOVE	#$4EB9,(A0)+	JSR AFF_PNT
	MOVE.L	#AFF_PNT,(A0)+
	BRA	CONTINUE
AFF_PNT	
; D0=X    D1=Y
ROUTINE	ADD	X_DEP,D0
	ADD	Y_DEP,D1
	MOVEQ	#0,D2
	CMPI	#199,D1
	BLE.S	NO_CLIP
	MOVEQ	#0,D0
	MOVEQ	#0,D1
NO_CLIP	TST	D1
	BGT.S	TOUTOK
	MOVEQ	#0,D0
	MOVEQ	#0,D1
TOUTOK	CMPI	#319,D0
	BLE.S	PASGRR
	MOVEQ	#0,D1
	MOVEQ	#0,D0
PASGRR	TST	D0
	BGT.S	ENFIN
	MOVEQ	#0,D0
	MOVEQ	#0,D1
ENFIN	*ST	$FFFF8240.W
;	MULU	#160,D1	12
;	LEA	TABLE_Y,A3	*8
	ADD	D1,D1	*
;	ADDA.L	D1,A5	*
	MOVE	(A3,d1.w),D1	*

	MOVE.L	D0,D2
;	LEA	TABLE_X,A5
	ADD	D0,D0
;	ADDA.L	D0,A5
	ADD	(A5,D0.W),D1
;	LEA	TABLE_X2,A6
;	ADDA.L	D2,A5
	ADD	#640,D2
	MOVE.B	(A5,D2.W),D0

	OR.B	D0,(A4,D1.W)
	MOVE	D1,(A6)+
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	RTS
GERE_EFF	MOVE.L	DATEFF,A6
	MOVEQ	#0,D1
	MOVE.L	SCREEN1,A4
	REPT	64*6
	MOVE	(A6)+,D1
	CLR.B	(A4,D1.W)
	ENDR
	RTS

INIT_TXT
	MOVE.L	#TAILLE*4-64*4,SAVEPNTDATAS
	MOVE	#-152,SAVEXDEP
	MOVE	#-8,SAVEYDEP
	CLR.L	SAVEPNTTXT
	MOVE.L	#DATAS,SAVEDAT
	
	MOVE.L	#TAILLE*4-64*4,SAVEPNTDATAS2
	MOVE	#-144,SAVEXDEP2
	MOVE.L	#1,SAVEPNTTXT2
	MOVE	#-8,SAVEYDEP2
	MOVE.L	#DATAS2,SAVEDAT2

	MOVE.L	#TAILLE*4-64*4,SAVEPNTDATAS3
	MOVE	#-136,SAVEXDEP3
	MOVE.L	#2,SAVEPNTTXT3
	MOVE	#-8,SAVEYDEP3
	MOVE.L	#DATAS3,SAVEDAT3

	MOVE.L	#TAILLE*4-64*4,SAVEPNTDATAS4
	MOVE	#-128,SAVEXDEP4
	MOVE.L	#3,SAVEPNTTXT4
	MOVE	#-8,SAVEYDEP4
	MOVE.L	#DATAS,SAVEDAT4
	
	MOVE.L	#TAILLE*4-64*4,SAVEPNTDATAS5
	MOVE	#-120,SAVEXDEP5
	MOVE.L	#4,SAVEPNTTXT5
	MOVE	#-8,SAVEYDEP5
	MOVE.L	#DATAS2,SAVEDAT5

	MOVE.L	#TAILLE*4-64*4,SAVEPNTDATAS6
	MOVE	#-112,SAVEXDEP6
	MOVE.L	#5,SAVEPNTTXT6
	MOVE	#-8,SAVEYDEP6
	MOVE.L	#DATAS3,SAVEDAT6

	RTS

	DATA
	even
ZIK	INCBIN	FRAG.MUS

TEXTE	
 ;dc.b"                                       "
 DC.B " HERE COMES A NEW SCREEN FROM THE MOST "
 DC.B "ACTIVE MEMBER OF **H O L O C A U S T** "
; dc.b "                                       "
 dc.L	-1,-1
	EVEN
TEXTE2
 ;dc.b"                                       "
 DC.B " LET'S BEGIN WITH A NICE PICTURE....   "
; dc.b "                                       "
 dc.L	-1,-1
	EVEN
 
FONT8_8	
;	DCB.L	(50-13)*6,$FFFFFFFF
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

TABLE_Y
N	SET	0
	REPT	200
	DC	N
N	SET	N+160
	ENDR
	EVEN
	
DATAS	INCBIN	TXTDAT
X_DEP	DC	0
Y_DEP	DC	0
	BSS
OFFSET	DS	1
	EVEN
DATEFF	DS.L	1
DATEFF2	DS.L	1
BUFEFF	DS	64*6*2
COMPTEUR	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
SCREEN3	DS.L	1
	DS.B	256
BUF	DS.B	64000
	DS.B	32000
TABLE_ADR	DS.L	258
ADR_ROUTS	DS.B	15000
DATAS2	DS.B	TAILLE*4
DATAS3	DS.B	TAILLE*4
TABLE_X
	DS	320	*!TABLE_X2 JUSTE
	EVEN		*DERRIERE
TABLE_X2			*OBLIGATOIREMENT
	DS.B	320
	EVEN
