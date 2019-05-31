.s	.end
	move.w	d1,(a1)+
	addq.b	#1,d0
	bpl.s	.copy
.end	move.w	d0,contrl3
	move.w	#1,contrl1
	govdi	8

	EXPORT	v_contourfill
	docont	1,1
	govdi	103

	EXPORT	vr_recfl
	docont	2,0
	govdi	114

	EXPORT	v_pieslice
	moveq	#3,d0
	bra.s	gdp_arcpie

	EXPORT	v_arc
	moveq	#2,d0
gdp_arcpie
	docont	4,2
	clr.l	ptsin+4
	clr.l	ptsin+8
	clr.w	ptsin+14
	bra	gdp_all

	EXPORT	v_bar
	docont	2,0
	moveq	#1,d0
	bra.s	gdp_all	

	EXPORT	v_circle
	docont	3,0
	moveq	#4,d0
	clr.l	ptsin+4
	clr.w	ptsin+10
	bra.s	gdp_all

	EXPORT	v_ellarc
	docont	2,2
	moveq	#6,d0
	bra.s	gdp_all

	EXPORT	v_ellpie
	docont	2,2
	moveq	#7,d0
	bra.s	gdp_all

	EXPORT	v_ellipse
	docont	2,0
	moveq	#5,d0
	bra.s	gdp_all

	EXPORT	v_rbox
	moveq	#8,d0
gdp_box	docont	2,0
gdp_all	move.w	d0,contrl+10
	govdi	11

	EXPORT	v_rfbox
	moveq	#8,d0
	bra.s	gdp_box

	EXPORT	v_justified
	moveq	#2,d0
	moveq	#0,d1
	lea	intin+4,a1
.copy	move.b	(a0)+,d1		convert C string into words
	beq.s	.end
	move.w	d1,(a1)+
	addq.b	#1,d0
	bpl.s	.copy
.end	move.w	d0,contrl3
	move.w	#2,contrl1
	moveq	#10,d0
	bra.s	gdp_all


	DEFV	AttributeFunctions

	EXPORT	vswr_mode
	docont	0,1
	govdi	32

	EXPORT	vs_color
	docont	0,4
	govdi	14

	EXPORT	vsl_type
	docont	0,1
	govdi	15

	EXPORT	vsl_udsty
	docont	0,1
	govdi	113

	EXPORT	vsl_width
	docont	1,0
	clr.w	ptsin+2
	govdi	16

	EXPORT	vsl_color
	docont	0,1
	govdi	17

	EXPORT	vsl_ends
	docont	0,2
	govdi	108

	EXPORT	vsm_type
	docont	0,1
	govdi	18

	EXPORT	vsm_height
	docont	1,0
	clr.w	ptsin
	govdi	19

	EXPORT	vsm_color
	docont	0,1
	govdi	20

	EXPORT	vst_height
	docont	1,0
	clr.w	ptsin
	govdi	12

	EXPORT	vst_point
	docont	0,1
	govdi	107

	EXPORT	vst_rotation
	docont	0,1
	govdi	13

	EXPORT	vst_font
	docont	0,1
	govdi	21

	EXPORT	vst_color
	docont	0,1
	govdi	22

	EXPORT	vst_effects
	docont	0,1
	govdi	106

	EXPORT	vst_alignment
	docont	0,2
	govdi	39

	EXPORT	vsf_interior
	docont	0,1
	govdi	23

	EXPORT	vsf_style
	docont	57*
	dc.b	0,0,0	58*
	dc.b	0,0,0	59*
	dc.b	0,0,0	60*
	dc.b	0,0,0	61*
	dc.b	0,0,0	62*
	dc.b	0,0,0	63*
	dc.b	0,0,0	64*
	dc.b	0,0,0	65*
	dc.b	0,0,0	66*
	dc.b	0,0,0	67*
	dc.b	0,0,0	68*
	dc.b	0,0,0	69*
	dc.b	4,3,0	70
	dc.b	8,3,0	71
	dc.b	6,1,0	72
	dc.b	8,1,0	73
	dc.b	8,1,0	74
	dc.b	4,1,1	75
	dc.b	3,1,1	76
	dc.b	0,5,0	77
	dc.b	1,1,1	78
	dc.b	0,5,0	79
	dc.b	0,1,1	80
	dc.b	0,1,1	81
	dc.b	0,0,0	82*
	dc.b	0,0,0	83*
	dc.b	0,0,0	84*
	dc.b	0,0,0	85*
	dc.b	0,0,0	86*
	dc.b	0,0,0	87*
	dc.b	0,0,0	88*
	dc.b	0,0,0	89*
	dc.b	0,2,2	90
	dc.b	0,0,0	91*
	dc.b	0,0,0	92*
	dc.b	0,0,0	93*
	dc.b	0,0,0	94*
	dc.b	0,0,0	95*
	dc.b	0,0,0	96*
	dc.b	0,0,0	97*
	dc.b	0,0,0	98*
	dc.b	0,0,0	99*
	dc.b	5,1,0	100
	dc.b	5,1,0	101
	dc.b	1,1,0	102
	dc.b	1,1,0	103
	dc.b	2,5,0	104
	dc.b	6,1,0	105
	dc.b	2,1,0	106
	dc.b	1,1,0	107
	dc.b	6,5,0	108
	dc.b	0,0,0	109*
	dc.b	0,1,1	110
	dc.b	0,1,0	111
	dc.b	2,1,0	112 ** Control(4)=1 **
	dc.b	2,1,1	113
	dc.b	1,1,1	114
	dc.b	0,0,0	115
	dc.b	0,0,0	116
	dc.b	0,0,0	117
	dc.b	0,0,0	118
	dc.b	0,0,0	119
	dc.b	0,1,2	120
	dc.b	3,1,2	121
	dc.b	0,0,0	122*
	dc.b	0,0,0	123*
	dc.b	0,1,1	124
	dc.b	0,1,3	125
	even

	SECTION	BSS
* these don't need initialising so can go in the BSS section
control		ds.w	4
global		ds.w	14
int_in		ds.w	16
int_out		ds.w	7
addr_in		ds.l	2
addr_out	ds.l	1


*********** END OF AES *****************

