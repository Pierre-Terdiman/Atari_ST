
                * CACHE SOURIS ( line a )
                
                DC.W $A00A         
                
                * cherche adresse ecran
                
                MOVE.W #3,-(SP)
                TRAP #14
                ADDQ.L #2,SP
                MOVE.L D0,A5
                
                * AFFICHE IMAGE 
                
                MOVEA.L #MESS1,A0
                
                BSR AFFICHE
                
                MOVE.L #CHAINE1+1,-(A7)* chaine ds pile 
                CLR.W -(A7)
     
                MOVE.W #$19,-(A7)      * transmet chaine processeur clavier
                TRAP #$E               *
                ADDQ.L #8,A7
                
                MOVE.W #5,-(A7)        * interruption nu 5 (pour stabilite ecran)
                MOVE.W #$1A,-(A7)      * stop interruption
                TRAP #$E
                ADDQ.L #4,A7
                
       * installe nouvelle routine d'interruption 
               
                MOVE.L #ROUTINE2,D0    * adresse de routine ds d0
                MOVE.W #$1C,D1         * vecteur ds d1
                BSR CHVECT
                MOVE.L D0,-(A7)
                
                MOVE.L #ROUTINE1,D0    * adresse de routine ds d0
                MOVE.W #$1A,D1         * vecteur ds d1
                BSR.S CHVECT
                MOVE.L D0,-(A7)
                CLR.L -(A7)
                

                MOVE.W #$20,-(A7)      * passage en mode super
                TRAP #1                * appel
                ADDQ.L #6,A7
                
                MOVE.L D0,-(A7)
                ANDI.W #-$701,SR
                
                
                
                BSR ATTENT             * apl routine attente pression touche
                ORI.W #$300,SR
                
                MOVE.W #$20,-(A7)      * revient mode utilisateur
                TRAP #1                * appel
                ADDQ.L #6,A7
                
     * remise en place des anciennes routines
                
                MOVE.L (A7)+,D0     
                MOVE.W #$1A,D1      
                BSR.S CHVECT
                MOVE.L (A7)+,D0     
                MOVE.W #$1C,D1      
                BSR.S CHVECT
                
     * ouvre interruption bloque
                
                MOVE.W #5,-(A7)
                MOVE.W #$1B,-(A7)
                TRAP #$E
                ADDQ.L #4,A7
                
                MOVE.L #CHAINE2,-(A7)   * chaine ds pile
                CLR.W -(A7)
                MOVE.W #$19,-(A7)      * transmet chaine processeur clavier
                TRAP #$E
                ADDQ.L #8,A7
                
                MOVEA.L #MESS,A0
                
                BSR AFFICHE          * affiche message
                
                * MONTRE SOURIS
                
                DC.W $A009
                * remet couleurs
                MOVE.L #PALETTE,-(SP)
                
                MOVE.W #6,-(SP)
                TRAP #14
                ADDQ.L #6,SP
                
                CLR.W -(A7)            * retour au burreau
 
                TRAP #1
        
                
CHVECT          MOVE.L D0,-(A7)        * vecteur
                MOVE.W D1,-(A7)        * numero
                MOVE.W #5,-(A7)        * change vecteur d'exception
     
                TRAP #$D
                ADDQ.L #8,A7
                RTS
                
        * ROUTINES INTERRUPTION        
          *********************
                
ROUTINE1        MOVEQ #$1D,D2
             
PAUSE           DBRA D2,PAUSE                   
                ADDQ.W #2,D1
                MOVE.W COULEURS(PC,D1.W),$FF8240  *registre de couleur
               * ADDQ.W #8,D1
               * MOVE.W COULEURS(PC,D1.W),$FF8242
               * SUBQ.W #8,D1
                
                
                CMPI.W #$60,D1
                BNE.S SORT1
                CLR.W D1
SORT1           RTE


ROUTINE2        ADDQ.W #2,COMPTEUR
                CMPI.W #$60,COMPTEUR
                BNE.S SAUT
                CLR.W COMPTEUR
SAUT            MOVE.W COMPTEUR,D1
                CLR.W $FF8240
                RTE
                
                
ATTENT          MOVE.W #7,-(A7)
                TRAP #1
                ADDQ.L #2,A7
                RTS
                
                
AFFICHE         MOVEM.L D0-D3/A0-A3,-(A7)
                MOVE.L A0,-(A7)
                MOVE.W #9,-(A7)
                TRAP #1
                ADDQ.L #6,A7
                MOVEM.L (A7)+,D0-D3/A0-A3
                RTS
                
          * DONNEES
            *******    
      
                EVEN
                
CHAINE1         DC.W $112
                
                EVEN
                
CHAINE2         DC.W $800

                EVEN
                
COMPTEUR        DC.W 0

                
                EVEN
                
COULEURS        DC.W 0
* couleurs 
                DC.W $110,$220,$330,$440,$550,$660,$770
                DC.W $670,$370,$070
                
                DC.W $071,$072,$074,$076,$077
                DC.W $067,$047,$027,$007
                
                DC.W $107,$207,$507,$607,$707
                DC.W $606,$505,$404,$303,$202,$101
                 DC.W $107,$207,$507,$607,$707
                 DC.W $606,$505,$404,$303,$202,$101
                dc.w $111,$222,$333,$444,$555,$666,$777,$666,$555,$444,$333,$222,$111
                dc.w $111,$222,$333,$444,$555,$666,$777,$666,$555,$444,$333,$222,$111
                
                EVEN
                
MESS1           DC.B 0
MESS            DC.B 0
                EVEN

PALETTE       
                DC.W $777,$700,$070,$007,$111,$222,$333,$444,$555,$000,$001,$010,$100,$200,$020
                dc.w $111,$222,$333,$512,$125,$142,$140               
               
                
