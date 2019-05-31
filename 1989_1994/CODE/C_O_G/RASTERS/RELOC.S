;	LEA	A+$0E,A0
	LEA	A+2,A1
	LEA	A+6,A2
	LEA	A,A3
	MOVE.L	A3,D1
	CLR.L	D1
	ADD.L	(A1),D1
	ADD.L	(A2),D1
	MOVE.L	D1,ADR_TAB
	JSR	RELOC
;	MOVE.L	(A0),D0
BUFFER	DS.L	4
ADR_TAB	DS.L	1
A	INCBIN	WAVE.PRG
PROG	EQU	A+28

RELOC	LEA	PROG,A0
	MOVE.L	A0,A1
	MOVE.L	A0,D1
	ADD.L	ADR_TAB,A1
	ADD.L	#3,A1		HMMM
	MOVEQ	#0,D0
	
RELOC0	MOVE.B	(A1)+,D0
	BEQ	RELOC_END
	CMP.W	#1,D0
	BNE.S	RELOC1
	ADD.W	#254,A0
	BRA.S	RELOC0
RELOC1	ADD.W	D0,A0
	ADD.L	D1,(A0)
	BRA.S	RELOC0
RELOC_END	RTS


;bon alors pour reloger:                 

;soit tu charge sans pexec, alors si A   
;est l'adresse de chargement, le mot     
;long en A+14 (A+$0E) te donne la taille 
;de la table de reloc, et en aditionnant 
;les mots longs A+2 et A+6, tu obtient   
;l'adresse de cette table:               
;R=(A+2)+(A+6)+A                         

;(avec (A+2)<=> contenu de A+2)          

;toutes les adresses a reloger sont      
;positionn‚es come si le programme etait 
;charg‚ a l'adresse 0. Donc pour reloger 
;une telle adresse, il faut lui          
;aditionner elle meme. Encore faut-il    
;savoir ou se trouvent les adresses a    
;reloger...tres simple:                  
;la table de reloc te donne une suite    
;d'octets, chaque octet te donne le      
;deplacment de la prochaine instruction  
;a reloger relativement a celle en       
;cours. Si je suis sur la premiere (en   
;A+28 car l'entete d'un executable est   
;de 28) et que le premier octet de la    
;table = 12, je dois reloger l'adresse   
;en A+28+12. je n'ai plus qu'a           
;additionner a+28 (adresse de debut du   
;programme) au contenu de l'adresse      
;a+28+12. On n'aditionne que des mots    
;longs car on n'a que des mots longs a   
;reloger.                                
;Si j'ai un octet = a 254, je ne dois    
;pas faire de relocation, je doit        
;simplement me positionner 254 octets    
;apres l'adresse en cours.               
;pour les bsr ou bcc ou dbcc, pas de     
;reloc a faire puisque ce sont des sauts 
;relatifs !! on ne reloge que les trucs  
;du genre jmp adresse ou move            

;adresse,truc                            

;voila, en guise d'exemple, voir         
;l'article sur quartet dans le 52 (je    
;crois), ou je reloge singsong.prg qui   
;est inclus au programme (incbin). (je   
;ruse en ayant deja calcul‚ la position  
;de la table de reloc hehe).             
                                        
