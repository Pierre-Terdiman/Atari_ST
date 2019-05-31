	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP

	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	MOVE.B	#$12,$FFFFFC02.W
	DC.W	$A00A

	MOVE.L	$44E.W,A0
	MOVE.L	#7999,D0
EFF_SCR	CLR.L	(A0)+
	DBRA	D0,EFF_SCR

	ANDI.B	#%11111000,$484.W

	CLR.L	D0
	CLR.L	D1
	CLR.L	D2
;	BSR	PREP_GRF

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL

;	MOVEQ	#1,D0
;	JSR	MUZAXX

	MOVE.L	#8,NB_PART

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W

BOUCLE	JMP	BOUCLE

FIN	MOVE.L	ANC_VBL,$70.W

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W

	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	
	
VBLR	SF	$FFFF8240.W
	CMPI.L	#8,NB_PART
	BNE	SUITV0
	BSR	TEST_LET
	CLR.L	NB_PART
SUITV0	BSR	SCROLL
	BSR	SCROLL

	CMPI.B	#$39,$FFFFFC02.W
 	BEQ	FIN
	RTE


SCROLL	MOVE.L	$44E.W,A0
	LEA	160(A0),A0
	LEA	BUF_LET,A1
	REPT	8
	ROXL	(A1)

	ROXL	154(A0)
	ROXL	146(A0)
	ROXL	138(A0)
	ROXL	130(A0)
	ROXL	122(A0)
	ROXL	114(A0)
	ROXL	106(A0)
	ROXL	98(A0)
	ROXL	90(A0)
	ROXL	82(A0)
	ROXL	74(A0)
	ROXL	66(A0)
	ROXL	58(A0)	
	ROXL	50(A0)
	ROXL	42(A0)
	ROXL	34(A0)
	ROXL	26(A0)
	ROXL	18(A0)
	ROXL	10(A0)
	ROXL	2(A0)
	LEA	160(A0),A0
	ADDQ.L	#2,A1
	ENDR
	ADDI.L	#1,NB_PART
	RTS


TEST_LET	MOVEQ	#0,D0
	LEA	TEXT1,A0	
	ADDA.L	POINT,A0
	LEA	FONT8_8,A1
	CMPI.B	#$FF,(A0)
	BNE	SUITTST
	CLR.L	POINT
	LEA	TEXT1,A0
SUITTST	MOVE.B	(A0),D0	
	SUBI.B	#32,D0	
	LSL.W	#3,D0	
	ADDA.L	D0,A1	
	LEA	BUF_LET,A2
	MOVE.B	(A1)+,(A2)
	MOVE.B	(A1)+,2(A2)
	MOVE.B	(A1)+,4(A2)
	MOVE.B	(A1)+,6(A2)
	MOVE.B	(A1)+,8(A2)
	MOVE.B	(A1)+,10(A2)
	MOVE.B	(A1)+,12(A2)
	MOVE.B	(A1)+,14(A2)
	ADDI.L	#1,POINT
	RTS
	
	SECTION	DATA
;MUZAXX	INCBIN	MUS3.MUS


TEXT1
 dc.b " Bon, je suis enerve. Zappy au clavier. Je suis enerve."
 dc.b " Alors j'ai decide de taper un texte pour tous vous casser."
 dc.b " Je n'epargerai personne. Vous allez tous me hair apres ca, mais tant pis: je suis enerve. "
 dc.b " Alors vous allez tous vous en prendre plein dans la tete pour pas un rond. ( Oui, vous avez pu"
 dc.b " remarquer que mon style etait legerement moins recherche que celui auquel mes"
 dc.b " fabuleux messages sur STMag, Gen4 et Rtel vous ont habitue. Mais c'est normal: je suis enerve. )"
 dc.b " Tiens, parlons en de Rtel... Rtel: le serveur maudit. "
 dc.b "  Je rappelle a nos amis etrangers qui auraient suivi l'idee saugrenue venue se loger dans les trefonds de leur labyrinthique cerveau, idee selon laquelle lire ce texte defilant ( scrolltext ) serait quelque chose a ne pas omettre de faire,"
 dc.b " que STMag, Gen4 et Rtel sont 3 serveurs accessibles via minitel. Ce qui n'empeche pas"
 dc.b " Rtel d'etre un infame repaire de cretinoides boutonneux"
 dc.b " ou se retrouvent tous les plus grands abrutis que la Terre ait jamais eu a supporter. Il y a plusieurs races de cretins, sur Rtel, attention, c'est bien range. "
 dc.b "Tout d'abord, et bien que ce ne soit pas inherent a Rtel, mais plutot au monde telematique en general, il y a les PURS DEBILES"
 dc.b " dont la preoccupation principale est de barbouiller meticuleusement l'ecran avec des memos RIDICULES, tout ca pour impressionner la galerie, qui, en regle generale, et puisque la nature est mal faite, n'en a strictement rien a foutre. "
 dc.b "Je les hais. Je les meprise. J'ai envie de leur cracher dessus, parfois. Souvent. Tout le temps. "
 dc.b "Je peux pas les blairer. Non mais faut etre PRETENTIEUX, quand meme. Grrrr!              "
 dc.b " Deuxieme categorie de trouduculs astronomiques: les demandeurs de news...  J'arrive a me connecter sur Rtel1 apres des efforts demesurement titanesques, j'arrive peniblement jusqu'a ma bal, je presse delicatement Envoi pour repondre a mon "
 dc.b "cher et precieux correspondant, quand... paf! Ah, un contact. Bon, ok, Sommaire, je repondrai plus tard, autant voir tout de suite de quoi il s'agit des fois que ce soit important.        Contact: XONBUL: 'ta des news?'                 ... "
 dc.b "    Primaire.          Bon, je reponds: 'Non.'          ...        Contact: XONBUL: 'connar'      .............     Dans ces moments la, on a envie de tuer.         NON SEULEMENT CET ABRUTI SIDERAL M'AGRESSE, ME DIT MEME PAS BONJOUR, ME "
 dc.b "PRECISE MEME PAS SA MACHINE POUR QUE JE LUI REPONDE, MAIS EN PLUS IL M'INSULTE EN FAISANT DES FAUTES D'ORTHOGRAPHE..!!        ... J'ai du mal a me maitriser, quelquefois... Alors je tape mon frere, faute de mieux.    JE LES HAIS AUSSI, CES "
 dc.b "SALES MOMES! Des news, pfff, lamentable. Pays de sauvages.                     Troisieme categorie de desagreables: ceux qui parlent de... Pin's...       maman, aide moi. Je reve.        Y'a rien de plus ridiculement inutile qu'un Pin's. "
 dc.b "Il y en a qui COLLECTIONNENT les Pin's !! MAIS JE REVE!  Il faut vraiment etre d'une stupidite VERTIGINEUSE pour payer 500 balles un PIN'S!   Vous me direz: y'a bien des collectionneurs de timbres.  Oui, mais non.  C'est pas pareil.  Les"
 dc.b " Pin's, on les collectionne PARCE QUE ca s'appelle des Pin's, et parce que c'est une vulgaire mode que je hais. Les Pin's existaient bien avant qu'on ait entendu parler des Pin's, seulement tout le monde s'en tapait le popotin avec un balai "
 dc.b "a chiottes.  Grrr!   Je hais les Pin's.              "
 dc.b " Beaucoup de choses m'enervent, je sais. D'habitude je ne dis rien. Mais la je suis enerve. Il faut que je me calme, alors paf! Un scroll.            "
 dc.b "      Certains d'entre vous ( les plus hideux ) ont du remarquer que cette demo n'etait absolument pas protegee.  Sur Rtel, en club Demo ( pass Demo ), j'ai lu a propos de certaines demos dont je tairai les noms par pure charite pour leurs "
 dc.b "auteurs, que celles ci avaient pris des mois de retard a cause de lamentables problemes de protection...    C'est grave, quand meme. PROTEGER une demo. RIDICULE. PUERIL. CON.  Comme si les routines developpees dans les demos ST etaient des "
 dc.b "chefs d'oeuvres.  L'interet d'une routine de demo est tellemnt minusculissime que j'attacherai plus d'importance a un documentaire sur les papillons sous alimentes du Guatemala.  Admettons qu'un 'ripper' ( ripper, ahah! ) vienne jeter un "
 dc.b "oeil humide et fatigue sur vos ridicules petits bouts de code. MAIS QU'EST CE QUE CA PEUT BIEN VOUS FOUTRE!?  Raaaaaaaaaah! Un flingue, pretez moi un flingue!                          "
 dc.b " Grompf..       En fait, je sais ce qui m'enerve: c'est d'etre dans un groupe de MERDE, avec un nom d'apocalypse post-nucleaire.       Un groupe nul, avec des individus grotesques et pretentieux.  "
 dc.b " Par exemple, Elric.                      ...                         "
 dc.b " PFFFFFAHAHAHAHAHAHAHAHA!!!                  Hum.                     "
 dc.b "Je ne tenterai pas ici de vous donner la liste de ses defauts, je suis limite a 523K de memoire, mais il y en a tout de meme quelques uns flagrants:   "
 dc.b " Elric est pretentieux. Il n'arrete pas de me les briser avec ses routines pseudo-recherchees que n'importe quel programmeur pondrait en deux temps trois mouvements pour peu qu'il s'y mette pour de bon. Il va dire que je dis ca par jalousie,"
 dc.b " etc, et que tout ca est faux. Mais dites lui, vous: J'EN AI RIEN A SECOUER, DE CES ROUTINES MINABLES!!! "

 dc.b "   Et puis alors ce qui me gonfle encore plus, c'est son jeu.     Deja, le nom: 'Ultimate Fight'.                   .....                  "
 dc.b "  Quel nom ridicule.              Et encore.  Au debut, c'etait en Francais: 'L'Ultime Attaque'.... Pfahaha! Voir sur son ecran un logo avec ce nom la, c'est vraiment tres drole. Surtout quand on voit en immense dans les credits:"
 dc.b " 'Special thanks to GENERATION4'..     On ferait trois fois le tour des 2 hemispheres, on trouverait pas plus leche-cul !!!           "
 dc.b " Bon, ca encore, ca me derange pas trop.  Mais a entendre Elric, ce jeu est la 8eme merveille du Monde, attention! Enfin la 9eme: il aurait lui meme pris la 8eme position...    Il n'arrete pas de me rebattre les oreilles avec, c'est "
 dc.b "horrible.  En plus c'est un jeu a la Mach 3, et je HAIS les jeux a la Mach 3/Space Harrier. Et puis Bruno, puisque Hubert ne te le dit pas en face, je le dis pour lui: tes graphismes sont hideux. Merci Hubert.                           "
 dc.b " Mais le tour d'Hubert viendra, j'en suis toujours a Elric...   Il ne va pas s'en tirer a si bon compte.  Il faut aussi que je vous dise qu'Elric n'est JAMAIS a l'heure. Ca m'enerve. A un moment, il avait 9 ( NEUF ) heures de retard a un "
 dc.b "rendez-vous. ( Avec moi, comme par hasard. )   ...et ne comptez pas sur lui pour s'excuser, ca lui ecorcherait la tronche. Qu'il a tres laide. Si, si: tres tres laide, meme. Et puis il est tout petit. Tiens, voila: c'est un nain. Elric est "
 dc.b "un nain, autant physiquement qu'intellectuellement. Paf. Revelation.                 Dire que c'est dans le meme groupe que moi.                                   "
 dc.b " Bon, assez parle d'Elric, a force d'y penser j'ai envie de vomir.                 "


 dc.b "             ...                "
 dc.b " J'avais pense vous parlez de tous les membres d'Holocaust, un a un, de dire que Dan Nato, Zerioul, None et Blyzard etaient 4 gros flemmards et que Sledge dessinait comme une savate, mais finalement, apres reflexion, c'etait surtout Elric "
 dc.b "que je visais.      Les autres sont supportables.    Et etant donne qu'Elric a lu le debut de ce texte, je compte sur lui pour ne pas me louper dans un autre ecran...  Donc pas question de faire mon auto-critique.   ( Quoique, c'est vite"
 dc.b " fait: Zappy/Holocaust: la perfection existe. Fini. )                               Mais non, je plaisante.                            "
 dc.b " La perfection existe PRESQUE.    Toujours modeste, c'est ma devise.                                          "
 dc.b " J'ai une meilleure idee, je vais parler de LEADER.                 Caisse?          Pardon: qu'est-ce?           Eh bien ma foi, c'est un RTC.            ...             Ca vous avance pas beaucoup, hein les incultes.           Reseau "
 dc.b "Telephonique Commute, si vous preferez.                   Certes, entends-je au loin.             L'equivalent d'un serveur 361X, mais fait par un particulier, et accessible via le numero de telephone du dit particulier. "
 dc.b " Dans le cas present, le numero est 34.66.03.57 et le particulier s'appelle Oxygene. Non, pas le groupe nul, hein. ( Nul, oui. Tous les groupes sont nuls. Salut les copains! )          Leader est un RTC excellent. Parce qu'il est rapide, "
 dc.b "deja. Pas comme Rtel ou on attend 3 heures l'affichage de 3 pixels.  La c'est fast et nickel.  Bon, on y rencontre quelques tetes de pioche ( Salut, Slight, ca boume? ) et quelques rigolos ( Coucou ODC, j'aime tes routines de 80 droites,"
 dc.b " si, si, vraiment. ) mais en regle generale, les personnes qui y deambulent sont tout-a-fait recommandables. ( Y'a un certain Zappy, par exemple, tres cool, tres bien. )                       "
 dc.b "    Tiens, je vais lancer un petit concours. Les reponses devront etre donnees dans ma bal sur Leader exclusivement. Le gagnant gagnera ( si si, le gagnant gagnera, promis... )... je disais donc: le gagnant gagnera le source assembleur de"
 dc.b " l'ecran de son choix dans cette demo. Je precise: le source tel qu'il est sur mes disks, c'est-a-dire non commente, et pas forcement clair. Mais c'est comme ca. Voila donc la question:          quelle est mon actrice preferee?              "
 dc.b "     Dur dur, hein.         Oui, je sais.          Les habitues du serveur maudit pourront peut etre trouver l'inspiration sur mon repondeur, mais.......        J'en dis trop.               Indice:  ce n'est ni Marthe Villalonga, ni Rosy "
 dc.b "Varte.          Hop, a vous de jouer.             Ce concours est tres serieux, quoi qu'il en soit.                           "
 DC.B "               ",$FF




	even
 
FONT8_8	
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
PALETTE
	REPT	5
	DC.W	$020,$131,$242,$353,$464,$575,$676,$777
	ENDR

	SECTION	BSS
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
POINT	DS.L	1
NB_PART	DS.L	1
BUF_LET	DS.B	(1*8)*2
