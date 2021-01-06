
;Define these values before including
;SCREEN_BYTE_WIDTH		= 160
;SCREEN_HEIGHT			= 200
;SCREEN_GUARDBAND		= 100	;Extra number of lines on each side of the screen
MULS_TABLE_SIZE			= SCREEN_HEIGHT+SCREEN_GUARDBAND*2
MULS_TABLE_ITEM_SIZE	= 2		;for words
;Input is going to be between -SCREEN_HEIGHT/2 and +SCREEN_HEIGHT/2 (e.g. -100/+100 for a regular 200-lines screen)
;Screen offsets are between 0 and SCREEN_HEIGHT so we remap the input by virtually adding SCREEN_HEIGHT/2.
;Then we must skip the top guardband i.e. SCREEN_GUARDBAND
MULS_TABLE_START_OFFSET		= (SCREEN_GUARDBAND+SCREEN_HEIGHT/2)*MULS_TABLE_ITEM_SIZE

;a0 = destination
CreateMulsTable:
	move.w	#-SCREEN_GUARDBAND*SCREEN_BYTE_WIDTH,d1
		sub.w	#(SCREEN_HEIGHT/2)*SCREEN_BYTE_WIDTH,d1
	move.w	#MULS_TABLE_SIZE-1,d0
.InitMulsTable
	move.w	d1,(a0)+
	add.w	#SCREEN_BYTE_WIDTH,d1
	dbf		d0,.InitMulsTable
	rts
;MulsTable		ds.w	MULS_TABLE_SIZE

