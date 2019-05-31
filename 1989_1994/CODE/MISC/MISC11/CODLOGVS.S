INIT  	move.l  #TEXT,a5	
	move.l	#TEXT_COMP,a4	
		
SCRUT:	moveq	#0,d0
	move.b (a5)+,d0 
	cmp.b	#85,d0
	bhs	UVW_Z	
	cmp.b	#75,d0
	bhs	KLM_T	
	cmp.b	#65,d0
	bhs	ABC_J	
	cmp.b	#58,d0
	beq	POINT2	
	cmp.b	#59,d0
	beq	PNT_VIRG
	cmp.b	#63,d0
	beq	INTER	
	cmp.b	#48,d0	
	bhs	N_01_89 
	cmp.b	#34,d0
	beq	GUILL	
	cmp.b	#39,d0
	beq	APOST   
	cmp.b	#40,d0
	beq	PARENT_G
	cmp.b	#41,d0
	beq	PARENT_D
	cmp.b	#44,d0
	beq	VIRG	
	cmp.b	#46,d0
	beq	POINT	
	cmp.b	#45,d0
	beq	TIRET	
	cmp.b	#33,d0
	beq	EXCL
	cmp.b	#32,d0
	beq	SPACE	

SPACE:	sub  #25,d0
	lsl   #4,d0
        add.W  #160*160,D0
	bra	SET

ABC_J:	sub	#65,d0	
	lsl.b	#4,d0
	
	bra	SET

KLM_T:	sub	#75,d0	
	lsl.b	#4,d0	
	add.w	#81*160,d0
	bra	SET

UVW_Z:	sub	#85,d0	
	lsl.b	#4,d0	
	add.w	#66*160,d0	
	bra	SET

N_01_89:	sub	#48,d0
	lsl.b	#4,d0	
	add.w	#99*160,d0	
	bra	SET		

APOST:	sub   #30,d0
        lsl   #4,d0
        add.w  #160*66,d0
	bra	SET

GUILL:	
	add.w	#160*(100),d0
	bra	SET

POINT2:	SUB   #53,D0
        LSL  #4,D0
        
	add.w	#160*132,d0
	bra	SET

PNT_VIRG: move.w	#144,d0
	add.w	#160*(52),d0
	bra	SET

INTER:	SUB  #55,D0
        LSL  #4,D0
        ADD.W  #160*66,D0
	bra	SET

PARENT_G:	SUB  #39,D0
            LSL  #4,D0 
	add.w	#160*132,d0
	bra	SET

PARENT_D:	SUB  #39,D0
           LSL  #4,D0
	add.w	#160*132,d0
	bra	SET

VIRG:	SUB  #40,D0
       LSL  #4,D0

	add.w	#160*132,d0
	bra	SET

POINT:   SUB  #39,D0
         LSL  #4,D0
	add.w	#160*66,d0
	bra	SET

TIRET:	SUB  #42,D0
        LSL  #4,D0
 
	add.w	#160*132,d0
	bra	SET

EXCL:	SUB   #27,D0
        LSL  #4,D0
	add.w	#160*66,d0
	bra	SET


SET:	move.w	d0,(a4)+	
	cmp.b	#$ff,(a5)	
	bne	SCRUT		
	move.w	#$ffff,(a4)	
	
	move.w	#0,-(sp)	
	move.l	#FILENAME,-(sp)	
	move.w	#$3c,-(sp)	
	trap 	#1		
	lea	8(sp),sp	
	tst	d0		
	move.w	d0,HANDLE	
	
	pea	TEXT_COMP	
	move.l	#1000,-(sp)  	
	move.w	HANDLE,-(sp)	
	move.w	#$40,-(sp)	
	trap	#1		
	lea	12(sp),sp	
	tst.w	d0		
	
	move.w	HANDLE,-(sp)	
	move.w	#$3e,-(sp)
	trap #1
	lea 	4(sp),sp	
	
	move.w	#1,-(sp)	
	trap #1			
	addq.l	#2,sp		
	
	clr.l 	-(sp)		
	trap #1			

	section data	
TEXT:
      DC.B  "  ABCDEFGHIJKLMNOPQRST                         "
	
	dc.b	$ff
		
FILENAME:	dc.b	"SPEED.TXT",0	
HANDLE:	dc.l	1	

	section bss	
TEXT_COMP:	ds.b	100		;4K DE RESERVE

	end
