	opt x+
	
* Musics format ETERNAL extract from NO BUDDIES LAND
* by STILL from N.G.C
***************************************************
* buddies1:
*
*param1	=	song+10388
*param2	=	song+34
*param3	=	song+21654
*param4	=	song+38
*param5	=	5
*param6	=	song+46
*
* buddies2:
*
* zic1
*
*param1	=	song+10388
*param2	=	song+34
*param3	=	song+16088
*param4	=	song+38
*param5	=	5
*param6	=	song+46
*
* zic2
*
*param1	=	song+36204
*param2	=	song+34
*param3	=	song+43572
*param4	=	song+38
*param5	=	10
*param6	=	song+46
*
******************************

	move.w	#$101,-(a7)
	trap	#14
	addq.l	#2,a7

	pea	main(pc)
	move.w	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	clr.w	-(sp)
	trap	#1
	
main	move.l	#param1,param2
	move.l	#param3,param4
	move.w	#param5,param6
	moveq	#0,d0
	jsr	song
	jsr	song+8
	move.l	#song+4,$4e6.w
	clr.l	$4e6.w	
	move.l	#$ff,d0
	jsr	song
	jsr	song+12
	move.l	#$08080000,$ffff8800.w
	move.l	#$09090000,$ffff8800.w
	move.l	#$0a0a0000,$ffff8800.w
	rts

song	incbin	buddies2.mus
songf

param1	=	song+10388
param2	=	song+34
param3	=	song+16088
param4	=	song+38
param5	=	5
param6	=	song+46
