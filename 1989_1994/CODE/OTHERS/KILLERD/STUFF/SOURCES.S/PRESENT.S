		listchar	$0f,$1b,$43,11
		ttl	Presentation HOBBITS
		plen	60
		
;- aout 1988-


debut		movea.l	a7,a5
		movea.l	$04(a5),a5
		move.l	$0c(a5),d0
		add.l	$14(a5),d0
		add.l	$1c(a5),d0
		addi.l	#$400,d0
		move.l	d0,-(a7)
		move.l	a5,-(a7)
	 	clr.w	-(a7)
	 	move.w	#$04a,-(a7)	
	 	trap	#$01
	 	adda.l	#$0c,a7

		clr.l	-(a7)
		move.w	#$020,-(a7)
		trap	#$01		;passe en superviseur
		addq.l	#6,a7
		move.l	d0,-(a7)
		
	 	move.l	#32066,d0	;taille bloc … allouer
	 	bsr	malloc
	 	move.l	d0,buffer
	 	
	 	lea	n_fond,a0	;A0=ad nom du fichier … charger
	 	move.l	buffer,a1	;A1=ad de chargement
	 	bsr	charge_fichier	;chargement du fichier
	 	
	 	move.l	#32000,d0
	 	bsr	malloc		;m‚moire pour stocker le fond
	 	move.l	d0,im_fond	;d‚compress‚ (sans couleurs...)
	 	
	 	move.l	buffer,a4	;ad image compress‚e
	 	move.l	d0,a3		;ad pour image d‚compress‚e
	 	bsr	decomp_pc1
	 	
	 	moveq	#32,d0
	 	bsr	malloc
	 	move.l	d0,pal_fond	;sauvegarde de la pallette du fond
	 	move.l	d0,a1
	 	move.l	buffer,a0	;im comp
	 	move.w	(a0)+,d1	;pointe maintenant sur les couleurs
	 	moveq	#(32/4)-1,d7
sauv_pal	move.l	(a0)+,(a1)+
		dbf	d7,sauv_pal
		
		lea	n_sprite1,a0	;fichier 1 contenant les sprites
		move.l	buffer,a1	;ad de chargement
		bsr	charge_fichier	;->chargement !!!
		
		move.l	#32000,d0	
		bsr	malloc		;reserve 32000 octets pour les
		move.l	d0,im_sprite1	;sprites 1 (pas de pal. couleur)
		
		move.l	buffer,a4	;ad image compress‚e
		move.l	d0,a3		;ad destination
		bsr	decomp_pc1	;d‚compression
		
		
		move.l	pal_fond,-(a7)
		move.w	#$06,-(a7)
		trap	#$0e		;positionne la palette
		addq.l	#6,a7
		
		move.l	#37000,d0
		bsr	malloc		;reservation memoire pour anim
		move.l	d0,buffer2
		
		move.l	#5000,d0
		bsr	malloc		;idem
		move.l	d0,sauve
		
		move.w	#$02,-(a7)
		trap	#$0e
		addq.l	#2,a7
		move.l	d0,physique
		
		move.w	#-1,-(a7)
		move.l	#-1,-(a7)
		move.l	buffer2,-(a7)
		move.w	#$05,-(a7)
		trap	#$0e		;buffer2=logique
		lea	$0c(a7),a7
		
		move.l	im_fond,a0
		move.l	buffer2,a1
		bsr	block_copy	;copie du fond vers buffer2
		
		movea.l	a1,a0
		move.l	physique,a1
		bsr	block_copy	;afichage image fond
		
		move.w	#$07,-(a7)
		trap	#$01
		addq.l	#2,a7
		lea	$ff825e,a0
		move.w	#$0,(a0)
		move.w	#$07,-(a7)
		lea	fondu,a1
		moveq	#9,d7
image_in	move.w	(a1)+,(a0)
		move.w	#$b000,d6
tempo		nop
		dbf	d6,tempo
		dbf	d7,image_in	;+temps d'attente ?
		
		move.l	#$0,$4ba	;TIMER A ZERO
		
encore		move.l	#240,d0		;X
		move.l	#100*160,d1	;Y
		move.l	#79,d2	;W
		move.l	#80,d3		;H
		lea	ad_sprite,a4
ok		movem.l	d0-d3,-(a7)
		move.l	im_sprite1,a1
		move.l	buffer2,a0
		move.l	sauve,a2
recommence	move.l	(a4)+,d7
		cmpi.l	#-1,d7
		bne.s	cont
		lea	ad_sprite,a4
		bra.s	recommence
cont		adda.l	d7,a1		;ad du sprite
		add.w	(a4)+,d0	
		add.w	(a4)+,d1
		bsr	sprite_get
		bsr	sprite_draw
		move.l	physique,a3
		bsr	block_copy
		bsr	sprite_put
		;movem.l	d0-d4,-(a7)
		;move.w	#$025,-(a7)
		;trap	#$0e			;VSYNC ralentit les sprites
		;addq.l	#2,a7			;essai vitesse avec BLOCK_COPY 2
		;movem.l	(a7)+,d0-d4	;+VSYNC:45c,sans VSYNC:2be
		move.w	#$8000,d6
tempo2		nop
		dbf	d6,tempo2		
		movem.l	(a7)+,d0-d3
		subq.l	#6,d0
		tst.l	d0
		bpl.s	ok
		
		move.w	#$07,-(a7)
		trap	#$01
		addq.l	#2,a7
		cmpi.b	#$20,d0
		beq	encore
		move.l	$4ba,timer
		move.l	timer,d0
		nop
		nop
		
		move.w	#$020,-(a7)
		trap	#$01
		addq.l	#6,a7
		
		nop
		nop
fin		move.l	buffer,d0
		bsr	m_free
		move.l	buffer2,d0
		bsr	m_free
		move.l	im_fond,d0
		bsr	m_free
		move.l	pal_fond,d0
		bsr	m_free
		move.l	im_sprite1,d0
		bsr	m_free
		move.l	sauve,d0
		bsr	m_free
		
		move.w	#-1,-(a7)
		move.l	#-1,-(a7)
		move.l	physique,-(a7)
		move.w	#$05,-(a7)
		trap	#$0e
		lea	$0c(a7),a7
		
		clr.l	-(a7)
		trap	#$01
		
;*****************************************
;***************** DATA ******************
;*****************************************
		
		even
n_fond		dc.b	"LANKHMAR.PC1",0,0,0
n_sprite1	dc.b	"HOBBITS.PC1",0,0,0

		even
buffer		dc.l	0
buffer2		dc.l	0
im_fond		dc.l	0
im_sprite1	dc.l	0					 	
pal_fond	dc.l	0	 	
sauve		dc.l	0
physique	dc.l	0
fondu		dc.w	$000,$111,$221,$222,$332,$442,$443,$553,$664,$775
ad_sprite	dc.l	0
		dc.w	0,0	;offset x et y
sp_2		dc.l	40
		dc.w	0,0
sp_3		dc.l	80
		dc.w	0,0
sp_4		dc.l	120
		dc.w	0,0
sp_5		dc.l	79*160+(0/2)
		dc.w	0,0
sp_6		dc.l	79*160+(80/2)
		dc.w	0,0
sp_7		dc.l	79*160+(160/2)
		dc.w	0,0
sp_8		dc.l	79*160+(240/2)
		dc.w	0,0
		dc.l	-1
		
	 	
timer		dc.l	0		


		nolist
				

;*************** SPRITE_GET ***************
;entr‚e:A0=ad ‚cran,A2=ad sauvegarde fond
;       D0=x,D1=y*160,D2=w-1,D3=h-1

sprite_get	movem.l d0-d3/a0-a2,-(a7)
                andi.w  #$fff0,d0
                lsr.w   #1,d0
                adda.l  d0,a0
                adda.l  d1,a0
                movea.l a0,a1
                lsr.w   #4,d2
                addq.l  #1,d3
sg_in           moveq   #$0,d1
                move.w  d2,d1
sg_wd           move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+     
                dbf     d1,sg_wd
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     $a0(a0),a0
                movea.l a0,a1
                dbf     d3,sg_in
                movem.l (a7)+,d0-d3/a0-a2
                rts
                
;*************** SPRITE_PUT ***************
;entr‚e:A0=ad ‚cran,A2=ad sauvegarde fond
;       D0=x,D1=y*160,D2=w-1,D3=h-1

sprite_put	movem.l d0-d3/a0-a2,-(a7)
                andi.w  #$fff0,d0
                lsr.w   #1,d0
                adda.l  d0,a0
                adda.l  d1,a0
                movea.l a0,a1
                lsr.w   #4,d2
                addq.l  #1,d3
sp_in           moveq   #$0,d1
                move.w  d2,d1
sp_wd           move.l  (a2)+,(a1)+
                move.l  (a2)+,(a1)+     
                dbf     d1,sp_wd
                move.l  (a2)+,(a1)+
                move.l  (a2)+,(a1)+
                lea     $a0(a0),a0
                movea.l a0,a1
                dbf     d3,sp_in
                movem.l (a7)+,d0-d3/a0-a2
                rts
                
;*************** SPRITE_DRAW ***************
;entr‚e:A0=ad ‚cran,A1=ad sprite,A2=ad sauvegarde fond
;       D0=x,D1=y*160,D2=w-1,D3=h-1

sprite_draw	movem.l d0-d7/a0-a3,-(a7)
                move.l  d0,d7
                andi.w  #$0f,d7
                moveq   #$10,d4
                sub.w   d7,d4
                move.w  d4,decal
                andi.w  #$fff0,d0
                lsr.w   #1,d0
                adda.l  d0,a0
                adda.l  d1,a0
                lsr.w   #4,d2
                move.w  d2,sp_w
                moveq   #$0,d0
                move.l  d3,d7
fori            moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d3
                moveq   #0,d4
                move.w  d7,-(a7)
                move.w  decal,d7
                movea.l a0,a2
                movea.l a1,a3
                move.w  sp_w,d6
forj            clr.w   d0
                clr.w   d1
                clr.w   d2
                clr.w   d3      
                clr.w   d4
                moveq   #$0,d5
                move.w  (a1)+,d5
                lsl.l   d7,d5
                or.l    d5,d0
                or.l    d5,d1
                swap    d1
                moveq   #0,d5
                move.w  (a1)+,d5
                lsl.l   d7,d5
                or.l    d5,d0
                or.l    d5,d2
                swap    d2
                moveq   #0,d5
                move.w  (a1)+,d5        
                lsl.l   d7,d5
                or.l    d5,d0
                or.l    d5,d3
                swap    d3
                moveq   #0,d5
                move.w  (a1)+,d5
                lsl.l   d7,d5
                or.l    d5,d0
                or.l    d5,d4
                swap    d4
                swap    d0
                not.w   d0
                and.w   d0,(a0)
                or.w    d1,(a0)+
                and.w   d0,(a0)
                or.w    d2,(a0)+
                and.w   d0,(a0)
                or.w    d3,(a0)+
                and.w   d0,(a0)
                or.w    d4,(a0)+
                dbf     d6,forj
                
                move.w  (a7)+,d7
                swap    d0
                swap    d1
                swap    d2
                swap    d3
                swap    d4
                not.w   d0
                and.w   d0,(a0)
                or.w    d1,(a0)+
                and.w   d0,(a0)
                or.w    d2,(a0)+
                and.w   d0,(a0)
                or.w    d3,(a0)+
                and.w   d0,(a0)
                or.w    d4,(a0)+
                lea     $a0(a2),a0
                lea     $a0(a3),a1
                dbf     d7,fori
                
                movem.l (a7)+,d0-d7/a0-a3
                rts
sp_w            dc.w    0
decal           dc.w    0

;*************** CHARGEMENT FICHIER ***************
;entr‚e:A0=ad nom,A1=ad buffer de chargement
;sortie:(taille) contient le nb d'octets charg‚

charge_fichier  movem.l d0-d7/a0-a6,-(a7)
                move.l  a0,nom
                move.l  a1,taille
                
                clr.w   -(a7)           ;fichier en acc‚s lecture seulement
                move.l  a0,-(a7)        ;ad nom fichier
                move.w  #$03d,-(a7)
                trap    #$01            ;F_OPEN
                addq.l  #8,a7
                tst.l   d0
                bmi     er_f_open       ;erreur lors de l'ouverture
                move.w  d0,handle
                
                move.l  taille,a0
                move.l  a0,-(a7)        ;ad tampon lecture
                move.l  #700000,-(a7)   ;nb caracs … lire (700 Ko !!)
                move.w  handle,-(a7)
                move.w  #$03f,-(a7)
                trap    #$01
                lea     $0c(a7),a7
                tst.l   d0
                bmi     er_f_read
                move.l  d0,taille       ;TAILLE contient le nb d'octets charger
                
                move.w  handle,-(a7)
                move.w  #$03e,-(a7)
                trap    #$01
                addq.l  #4,a7
                tst.l   d0
                bmi     er_f_close
                
                movem.l (a7)+,d0-d7/a0-a6
                rts             
nom             dc.l    0
taille          dc.l    0                               
handle          dc.w    0

;*************** DECOMPILATION IMAGE PC1 ***************
;entr‚e:A4=ad image compress‚e,A3=ad d‚comp

decomp_pc1	movem.l d0-d7/a0-a6,-(a7)
                adda.l  #34,a4          ;pointe sur image … d‚compresser
                move.l  a3,ad_im_dest
                move.l  #32000,d0
                bsr     malloc
                move.l  d0,plan1
                move.l  d0,a0           ;plan couleur 0
                lea     $1f40(a0),a1    ;plan 1
                lea     $1f40(a1),a2    ;plan 2
                lea     $1f40(a2),a3    ;plan 3
                movem.l a0-a3,-(a7)
                move.w  #199,d0         ;200 lignes … decompresser
                
tes             move.l  a0,a5
                bsr     dec
                move.l  a5,a0
                move.l  a1,a5
                bsr     dec
                move.l  a5,a1
                move.l  a2,a5
                bsr     dec
                move.l  a5,a2
                move.l  a3,a5
                bsr     dec
                move.l  a5,a3
                dbf     d0,tes
                bra.s   aff
                
dec             move.b  #0,d1
dec10           cmpi.b  #40,d1
                beq     fi
                move.b  (a4)+,d2
                cmpi.b  #0,d2
                blt     cas
                addq.b  #1,d2
dec20           move.b  (a4)+,(a5)+
                addq.b  #1,d1
                subq.b  #1,d2
                cmpi.b  #0,d2
                bgt     dec20
                bra.s   dec10
cas             neg.b   d2
                addq.b  #1,d2
                move.b  (a4)+,d3
cas1            move.b  d3,(a5)+
                addq.b  #1,d1
                subq.b  #1,d2
                cmpi.b  #0,d2
                bgt     cas1
                bra.s   dec10
fi              rts             
aff             movem.l (a7)+,a0-a3
                move.l  ad_im_dest,a4
                move.w  #7999,d0
af1             move.w  (a0)+,(a4)+
                move.w  (a1)+,(a4)+
                move.w  (a2)+,(a4)+
                move.w  (a3)+,(a4)+
                dbf     d0,af1
                
                move.l  plan1,d0
                bsr     m_free
                
                movem.l (a7)+,d0-d7/a0-a6
                rts     
                
plan1           dc.l    0
ad_im_dest      dc.l    0

;*************** BLOCK_COPY ***************
;entr‚e:A0=ad source,A1=ad destination

block_copy      movem.l d0/a0-a1,-(a7)
                move.l  #499,d0
sp_bcl          move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                dbf     d0,sp_bcl
                movem.l (a7)+,d0/a0-a1
                rts

 
;*************** M_ALLOC ***************
;entr‚e:D0=nb octet … reserver
;sortie:D0=ad de la zone m‚moire allouer

malloc		move.l  d0,-(a7)
                move.w  #$048,-(a7)
                trap    #$01
                addq.l  #6,a7
                tst.l   d0
                beq.s   er_malloc
                addq.b  #1,nb_malloc
                rts
nb_malloc       dc.w    0               ;nb de blocs m‚moire allouer
                                        ;par le systeme
                                        
;*************** M_FREE *****************

m_free		move.l	d0,-(a7)
		move.w	#$49,-(a7)
		trap	#$01
		addq.l	#6,a7
		tst.l	d0
		bmi.s	er_m_free
		subq.b	#1,nb_malloc
		rts
		
;***************** GESTION ERREURS *****************

er_f_close	pea	er_f_cl_mes
		bra.s	cont_error
er_f_read	pea	er_f_re_mes
		bra.s	cont_error
er_f_open	pea	er_f_op_mes
		bra.s	cont_error
er_m_free	pea	er_m_fr_mes
		bra.s	cont_error		
er_malloc	pea	er_mem_mes
cont_error	move.w	#$09,-(a7)
		trap	#$01
		addq.l	#6,a7
		move.w	#$07,-(a7)
		trap	#$01
		addq.l	#2,a7
		clr.l	-(a7)
		trap	#$01
		nop
		even
er_m_fr_mes	dc.b	$1b,$45,$07
		dc.b	"M_FREE MEMORY ERROR",0		
er_mem_mes	dc.b	$1b,$45,$07
		dc.b	"NOT ENOUGH MEMORY ERROR",0
er_f_op_mes	dc.b	$1b,$45,$07
		dc.b	"OPEN ACCESS ERROR",0
er_f_re_mes	dc.b	$1b,$45,$07
		dc.b	"READ ACCESS ERROR",0
er_f_cl_mes	dc.b	$1b,$45,$07
		dc.b	"CLOSE ACCESS ERROR",0
		
