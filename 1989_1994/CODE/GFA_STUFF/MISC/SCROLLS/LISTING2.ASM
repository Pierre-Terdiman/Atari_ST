;***********************************************************
;
;       Programme de scroll horizontal
;
;***********************************************************

PHYSBASE  EQU     2   ;No de la fonction Xbios PHYSBASE
                      ;pour r‚cup‚rer l'adresse de l'‚cran.

CCONIN    EQU     1   ;No de la fonction Gemdos CCONIN
                      ;pour attendre un caractŠre au clavier

H_ECRAN   equ     8*15    ;Hauteur de l'‚cran … d‚caler
CADRE_GAUCHE equ  8       ;Epaisseur cadre gauche en octets
CADRE_HAUT equ    8*2     ;Hauteur du cadre haut en pixels

LG_LIGNE  equ     160     ;Largeur totale de
                          ;l'‚cran en octets

          section data

adr_ecran  dc.l      0    ;Adresse de l'‚cran o— commence
                          ;le scroll

;***********************************************************
;
;       Programme principal
;

          section text

; Lit l'adresse de la m‚moire vid‚o

          move.w    #PHYSBASE,-(sp)
          trap      #14
          addq      #2,sp
          move.l    d0,a0       ;Adresse ‚cran dans a0

; Calcule l'adresse du coin sup‚rieur gauche du cadre
; dans lequel se fait le scroll

          lea       LG_LIGNE*CADRE_HAUT+CADRE_GAUCHE(a0),a0
          move.l    a0,adr_ecran

; Boucle d'appel de la routine de d‚calage horizontal

          move.w    #100,d1     ; Routine appel‚e 100 fois
boucle:
          bsr       scroll
          dbra      d1,boucle

; Attend un appui sur une touche

          move.w  #CCONIN,-(sp)
          trap    #1
          addq.l  #2,sp

;Fin du programme

          clr.w     -(sp)
          trap      #1
        
;***********************************************************
;
;       Routine de scroll horizontal … gauche 8 pixels
;
;       a0, d0 modifi‚s

scroll:   move.l    adr_ecran,a0    ;adresse ‚cran dans a0
          move.w    #H_ECRAN-1,d0   ;Nombre de lignes

ligsui:
          move.b    1(a0),(a0)      ;1er plan
          move.b    8(a0),1(a0)
          move.b    9(a0),8(a0)
          move.b    16(a0),9(a0)
          move.b    17(a0),16(a0)
          move.b    24(a0),17(a0)
          move.b    25(a0),24(a0)
          move.b    32(a0),25(a0)
          move.b    33(a0),32(a0)
          move.b    40(a0),33(a0)
          move.b    41(a0),40(a0)
          move.b    48(a0),41(a0)
          move.b    49(a0),48(a0)
          move.b    56(a0),49(a0)
          move.b    57(a0),56(a0)
          move.b    64(a0),57(a0)
          move.b    65(a0),64(a0)
          move.b    72(a0),65(a0)
          move.b    73(a0),72(a0)
          move.b    80(a0),73(a0)
          move.b    81(a0),80(a0)
          move.b    88(a0),81(a0)
          move.b    89(a0),88(a0)
          move.b    96(a0),89(a0)
          move.b    97(a0),96(a0)
          move.b    104(a0),97(a0)
          move.b    105(a0),104(a0)
          move.b    112(a0),105(a0)
          move.b    113(a0),112(a0)
          move.b    120(a0),113(a0)
          move.b    121(a0),120(a0)
          move.b    128(a0),121(a0)
          move.b    129(a0),128(a0)
          move.b    136(a0),129(a0)
          move.b    137(a0),136(a0)

          move.b    3(a0),2(a0)     ;2eme plan
          move.b    10(a0),3(a0)
          move.b    11(a0),10(a0)
          move.b    18(a0),11(a0)
          move.b    19(a0),18(a0)
          move.b    26(a0),19(a0)
          move.b    27(a0),26(a0)
          move.b    34(a0),27(a0)
          move.b    35(a0),34(a0)
          move.b    42(a0),35(a0)
          move.b    43(a0),42(a0)
          move.b    50(a0),43(a0)
          move.b    51(a0),50(a0)
          move.b    58(a0),51(a0)
          move.b    59(a0),58(a0)
          move.b    66(a0),59(a0)
          move.b    67(a0),66(a0)
          move.b    74(a0),67(a0)
          move.b    75(a0),74(a0)
          move.b    82(a0),75(a0)
          move.b    83(a0),82(a0)
          move.b    90(a0),83(a0)
          move.b    91(a0),90(a0)
          move.b    98(a0),91(a0)
          move.b    99(a0),98(a0)
          move.b    106(a0),99(a0)
          move.b    107(a0),106(a0)
          move.b    114(a0),107(a0)
          move.b    115(a0),114(a0)
          move.b    122(a0),115(a0)
          move.b    123(a0),122(a0)
          move.b    130(a0),123(a0)
          move.b    131(a0),130(a0)
          move.b    138(a0),131(a0)
          move.b    139(a0),138(a0)

          move.b    5(a0),4(a0)     ;3eme plan
          move.b    12(a0),5(a0)
          move.b    13(a0),12(a0)
          move.b    20(a0),13(a0)
          move.b    21(a0),20(a0)
          move.b    28(a0),21(a0)
          move.b    29(a0),28(a0)
          move.b    36(a0),29(a0)
          move.b    37(a0),36(a0)
          move.b    44(a0),37(a0)
          move.b    45(a0),44(a0)
          move.b    52(a0),45(a0)
          move.b    53(a0),52(a0)
          move.b    60(a0),53(a0)
          move.b    61(a0),60(a0)
          move.b    68(a0),61(a0)
          move.b    69(a0),68(a0)
          move.b    76(a0),69(a0)
          move.b    77(a0),76(a0)
          move.b    84(a0),77(a0)
          move.b    85(a0),84(a0)
          move.b    92(a0),85(a0)
          move.b    93(a0),92(a0)
          move.b    100(a0),93(a0)
          move.b    101(a0),100(a0)
          move.b    108(a0),101(a0)
          move.b    109(a0),108(a0)
          move.b    116(a0),109(a0)
          move.b    117(a0),116(a0)
          move.b    124(a0),117(a0)
          move.b    125(a0),124(a0)
          move.b    132(a0),125(a0)
          move.b    133(a0),132(a0)
          move.b    140(a0),133(a0)
          move.b    141(a0),140(a0)

          move.b    7(a0),6(a0)     ;4eme plan
          move.b    14(a0),7(a0)
          move.b    15(a0),14(a0)
          move.b    22(a0),15(a0)
          move.b    23(a0),22(a0)
          move.b    30(a0),23(a0)
          move.b    31(a0),30(a0)
          move.b    38(a0),31(a0)
          move.b    39(a0),38(a0)
          move.b    46(a0),39(a0)
          move.b    47(a0),46(a0)
          move.b    54(a0),47(a0)
          move.b    55(a0),54(a0)
          move.b    62(a0),55(a0)
          move.b    63(a0),62(a0)
          move.b    70(a0),63(a0)
          move.b    71(a0),70(a0)
          move.b    78(a0),71(a0)
          move.b    79(a0),78(a0)
          move.b    86(a0),79(a0)
          move.b    87(a0),86(a0)
          move.b    94(a0),87(a0)
          move.b    95(a0),94(a0)
          move.b    102(a0),95(a0)
          move.b    103(a0),102(a0)
          move.b    110(a0),103(a0)
          move.b    111(a0),110(a0)
          move.b    118(a0),111(a0)
          move.b    119(a0),118(a0)
          move.b    126(a0),119(a0)
          move.b    127(a0),126(a0)
          move.b    134(a0),127(a0)
          move.b    135(a0),134(a0)
          move.b    142(a0),135(a0)
          move.b    143(a0),142(a0)

          lea       LG_LIGNE(a0),a0   ;a0 pointe vers
                                      ;la ligne suivante.
          dbra      d0,ligsui         ;d‚cale ligne suivante
          rts

          end
