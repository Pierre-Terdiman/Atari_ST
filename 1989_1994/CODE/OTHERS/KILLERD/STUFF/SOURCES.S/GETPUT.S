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
