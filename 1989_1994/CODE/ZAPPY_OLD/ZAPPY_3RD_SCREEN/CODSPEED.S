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
        add.W  #160*132,D0
	bra	SET

ABC_J:	sub	#65,d0	
	lsl.b	#4,d0	
	bra	SET

KLM_T:	sub	#75,d0	
	lsl.b	#4,d0	
	add.w	#33*160,d0
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
	move.l	#20*1000,-(sp)  	
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
        DC.B  "                                             "
	DC.B  "                                            "
	DC.B  "          HI THERE VIEWERS !                "
	DC.B  "THIS IS ZAPPY'S CONTRIBUTION TO THE -KLOUG"
	DC.B	" DEMO- FROM THE -BLACK CATS-.         YOU"
	DC.B	" CERTAINLY HAVE NEVER HEARD ABOUT ME COZ"
	DC.B	" IT'S THE FIRST TIME I RELEASE A SCREEN FOR"
	DC.B	" A BIG DEMO-DISK.       YOU CAN FOUND MY TWO"
	DC.B	" FIRST SCREENS ON THE 3615 GEN4    ( PUB ! ) "
	
	DC.B  " THIS DEMO WAS THE PERFECT OCCASION FOR ME TO USE THE "
	DC.B  "BIG LOGO YOU SEE ABOVE...        IT'S REALLY TOUGH TO "
	DC.B  "INCLUDE IT IN A SCREEN:      FIRST OF ALL, IT'S A 4 BITPLANES LOGO"
	DC.B  ", AND MOVING IT NEEDS A LOT OF CPU-TIME.        SECOND, "
	DC.B  "I CAN'T PREDECALE IT      ( NOT ENOUGH MEMORY ON A 520 ST ! )"
	DC.B  "   AND THEN I CAN'T MOVE IT LEFT AND RIGHT     ( NOT ENOUGH"
	DC.B  " PROCESSOR TIME TO SHIFT IT WITH ROXL DURING THE"
	DC.B  " VBL ! ).      I CAN'T NEITHER DIST IT, FOR THE SAME "
	DC.B  "REASONS.   ( EH, WE'RE NOT ON STE, AND THAT'S A PITY ! )"
	DC.B	" ZOOMING IT IS NEARLY IMPOSSIBLE  ( REALTIME-ZOOMING, I MEAN, NOT"
	DC.B	" A ZOOM LIKE IN THE BLACK MONOLITH TEAM'S THIRD SCREEN OF THE SKID ROW"
	DC.B	" DEMO... ) "
	DC.B  "  AND FINALLY IT'S SO "
	DC.B  "BIG THAT I HAVEN'T ANY SPACE LEFT ON THE SCREEN "
	DC.B  "TO PUT THE PICTURE I'VE JUST FINISHED TO DRAW...       "
	DC.B  "THE ONLY SOLUTION WAS THE SYNC-SCROLLING, BUT I'M NOT"
	DC.B  " THAT GOOD...  ( FOR INSTANCE, HEY HEY )       "
	DC.B  "           AND THAT'S WHY HERE'S ANYHOW A SIMPLE 320 X 89 "
	DC.B  "BOUNCING LOGO...                    NICE ?     "
	DC.B  "        I DON'T KNOW...     I'VE RECEIVED SOME "
	DC.B  "DIFFERENT OPINIONS ABOUT IT...     -DARKNESS-"
	DC.B  "   ( THAT'S A FRIEND. )  FIND IT UNSIGHTLY COZ     'IT"
	DC.B  " DOESN'T LOOK REAL'.   ( I REALLY DON'T SEE WHAT"
	DC.B  " THAT MEANS ? )         ON THE OTHER HAND, "
	DC.B  "-H.O-  ( CHANGE YOUR PSEUDONYM, IT'S COMPLETELY RIDICULOUS ! )"
	DC.B	" FROM  -HOLOCAUST-"
	DC.B  " FIND THE LOGO BEAUTIFUL.             ( EH, IT SEEMS "
	DC.B  "THERE'S A LOT OF DIFFERENTS TASTES IN THE UNIVERSE... )  "
	DC.B  "            PERSONNALY, I THINK IT'S JUST AVERAGE.    "
	DC.B  " THE LOGO ITSELF IS GOOD, BUT I MISSED IT...  IT'S "
	DC.B  "EVEN NOT ANTI-ALIASED !!  BEEEEEEEEEEH !  UGLY !            "
	DC.B  " AND IT'S SO OLD...             I'VE NEVER SUCCEEDED UNTIL NOW"
	DC.B  " IN USING IT IN A DEMO.       OKAY, I STOP BORING "
	DC.B  "YOU WITH IT.                         GOING ON"
	DC.B  " WITH THE CREDITS...    I'VE DONE ALL THE CODING."
	DC.B  "  THIS SCREEN FEATURES NOTHING SPECIAL:   A NORMAL 'ZAPPY' BOUNCING LOGO,"
	DC.B  " A NORMAL 'KLOUG' DISTORTED LOGO, AND A NORMAL BORING SCROLLING.    "
	DC.B  "  AND I'M HOWEVER COMPLETELY OUT OF CPU-TIME !"
	DC.B  "     YEAH, GREAT !               IT'S BECAUSE OF"
	DC.B	" TWO FACTS:      1-     THERE'S A SOUNDTRACK WHICH"
	DC.B	" TAKES ABOUT 50 PERCENT OF THE CPU-TIME.        "
	DC.B	"  2-     IT ISN'T VERY EASY TO WORK WITH 4 BITPLANES PICTURES."
	DC.B	"     BUT I THINK WE'VE ALREADY HAD TOO MUCH 'ONE-BITPLANE-MANIA-SCREENS', I WOULD LIKE"
	DC.B	" RATHER SEE COLORED AND WELL-DRAWN PICTURES INSTEAD OF 'ONE-COLOR-AND-FULL-OF-RASTERS' LOGO."
	DC.B	"    ( H.O, I'M SPEAKING FOR YOU.  STOP CODING SUCH SCREENS !  DON'T TRY TO RE-CODE TCB'S"
	DC.B	" TECHTRON DEMO ! )                  WELL.            
	DC.B  " THE SOUNDTRACKER REPLAY ROUTINE IS BY"
	DC.B  " -CHECKSUM-   FROM  -EQUINOX-.         THE"
	DC.B  " -MUSIC-  WAS ORIGINALLY "
	DC.B  "USED IN THE VERY NICE   -KEFRENS MEGADEMO 7-"
	DC.B  "   (  -KEFRENS- IS A FAMOUS AND GREAT AMIGA CREW.  THEIR MUSICS"
	DC.B  " ARE REALLY  -STUNNING !!!-    I PARTICULARY LIKE THE MUSIC THEY"
	DC.B  "'VE USED IN THEIR MEGADEMO 8...   YES, THE MARVELLOUS ONE WHICH"
	DC.B  " WAS COMPOSED BY -JESPER KID-"
	DC.B  " FROM  -THE SILENTS- )"
	DC.B  "       I'M BORED TO HEAR ALWAYS THE"
	DC.B  " SAME MAD MAX'S CREATIONS, EVEN IF THEY'RE GREAT."
	DC.B  "                           NO, NO, NOT AGAIN THE -ROLL OUT- TUNE,"
	DC.B  " NOOOOOOO !!!                     NOXIOUS.                        "
	DC.B  " WELL.          THE LOGO AND THE FONTS WERE DRAWN BY ME. "
	DC.B  "  SORRY TO HAVE USE THESE FONTS ONCE MORE,  AS IN"
	DC.B  " THE 'AGHWEY NODEI CHODEI', BUT I REALLY   -CAN'T-"
	DC.B  "  STAND LOOKING AT THE KNIGHT HAWKS' ONES AGAIN !   THEY"
	DC.B  " WERE USED AT LEAST 42.000 TIMES !!!     BORING ! "
	DC.B  "           HMM...          DEMO-WORLD BEGIN TO BE A"
	DC.B	" LITTLE BORING, DON'T YOU THINK ? "
	DC.B  "               THERE'S A LOT OF DEMOS"
	DC.B  " WHICH ARE TRULY USELESS.    ALWAYS THE SAME GOOD"
	DC.B  " BUT NOT ORIGINAL JOCHEN HIPPEL'S SONGS, A BIT OF"
	DC.B  " BAD SONGS FROM THE OTHERS, WITH ONE OR TWO EXCEPTIONS,"
	DC.B  "  ALWAYS THE SAME FONTS   ( KNIGHT HAWKS BUT MEGADEATH TOO, JUST LOOK ABOVE ! )"
	DC.B  "  AND ALWAYS THE SAME CODE.              RASTERS...            "
       	DC.B  "      DOC WAVES...               DISTORTED LOGOS..."
	DC.B  "                   LAME EQUALIZERS OR VU-METERS...                  "
	DC.B  "          DO YA REMEMBER TEX'S VERY FIRST DEMO ?"
	DC.B  "         YES, THAT WAS THE TIME THEY NEED 'EXTENSOR' TO"
	DC.B  " HAVE MUSICS...              GOOD TIME.             "
	DC.B  " BUT...   BAH, AFTER ALL, EVEN IF DEMOS BEGIN TO BORE ME, IT'S ALWAYS"
	DC.B  " NICE TO SEE, AND INTERESTING TO READ...         "
	DC.B  " WELL, END OF THE SPEECH.    IT'S TIME TO SEND WHAT"
	DC.B  " YOU ARE WAITING FOR, THE    -GREY THINGS-."
	DC.B  "       (  AND THAT DOESN'T MEAN THE 'MOUSES', STUPID !!! )"
	DC.B  "        HI TO:               "
	DC.B  "          -H.O- FROM -HOLOCAUST-         ("
	DC.B  " GIVE ME BACK MY DOC OF"
	DC.B  " A-DEBOG !!        HI TO ALL THE OTHERS, DAN NATO, ZERIOUL, ETC... )"
	DC.B  "          -DARKNESS-          ( NICE FONTS.   NOT REALLY" 
	DC.B  " ORIGINAL, BUT NICE.  I WOULD LIKE TO SEE ONE OF"
	DC.B  " YOUR SOURCE-CODE...   IT SEEMS THERE'S SOME STRANGE"
	DC.B  " THINGS IN THEM.   NICE WEREWOLF PICTURE BUT...  ONE PLANE, AAAAAARG ! )"
	DC.B  "          -MARVIN-          ( VERY NICE LOGO !   THE COLORS ARE"
	DC.B  " REALLY WELL-CHOSEN !  I'VE SOME GREAT IDEAS FOR IT... )"
	DC.B  "          -KILLER D OF FMC CONNEXION-          ( 'SAYONARA' LITTLE GIRL !  HOPE YOU'LL SUCCEED"
	DC.B  " IN CODING YOUR SCREEN.  PUB:  THE  -FULLSHOW-  BY  -KILLER D-  IS GREAT !"
	DC.B  "        HI TO HUTCH AND TO KRYSTAL.  )"
	DC.B  "          -TOUBAB-          ( NICE TRAINER MODE FOR FLAPS II...              ...              DATA DISKS !        I WANT DATA DISKS !!! "
	DC.B	"DO YA HAVE THE MUSIC FROM 'A PREHISTORIC TALE' ? )"
	DC.B  "          -ARIOCH-          ( HOPE YOUR ST WON'T DIE BEFORE YOU GET MY SCREENS ! )"
	DC.B  "          -MIC DAX-          ( I HATE TUESDAYS !!!    OH NOOOO ! )"
	DC.B  "          -WATSIT-          ( THANKS FOR THE EUROPEAN DEMO, THE SYNTAX TERROR AND THE POLTERGEIST ! )"
	DC.B  "          -STJC-          "
	DC.B  "          -OXYGENE-          ( LEADER         LEADER         LEADER         LEADER         34.66.03.57 ! )"
	DC.B  "          -MEGA1-          ( A LEMMINGS FAN ? )"
	DC.B  "          -PANZERBOY-          ( THANKS FOR THE THIRD ISSUE OF MAGGI ! )"
	DC.B  "          -CUCKATOOS-          "
	DC.B  "          -ROCKSTAR-          "
	DC.B  "          -NCC 1701-          "
	DC.B  "          -LEGACY-          ( THANKS FURY FOR THE ULM MEGADEMO.  WHAT ABOUT THE GFXS ? )"
	DC.B  "          -ST CONNEXION-          "
	DC.B  "          -THE OVERLANDERS-          ( INCREDIBLE SCREENS IN THE EUROPEAN... HI ZIGGY AND ADSO. )"
	DC.B  "          -THE CAREBEARS-          "
	DC.B  "          -THE LOST BOYS-          ( I AM TERRIBLY DISAPPOINTED AFTER HAVING SEEN YOUR GAME... "
	DC.B	"I THOUGHT IT WOULD BE A GAME WITH A LOT OF SCROLLS IN EVERY DIRECTIONS AND BIG SPRITES EVERYWHERE ON"
	DC.B	" THE SCREEN.........     NO OTHER COMMENT...        )"
	DC.B  "          -THE EXCEPTIONS-          "
	DC.B  "          -THE REPLICANTS-          "
	DC.B  "          -ULM-          "
	DC.B  "          -NEXT-          "
	DC.B  "          --          "
	DC.B  "          --          "
	DC.B  "          --          "
	DC.B  "          --          "


	dc.b	$ff
		
FILENAME:	dc.b	"SPEED.TXT",0	
HANDLE:	dc.l	1	

	section bss	
TEXT_COMP:	ds.l	20*1000		;4K DE RESERVE

	end
