
;LK	MOVEQ	#0,D0			* 1
;       MOVEQ   #0,D1			* 1
;	MOVEA.L	MES_PNT,A2		* 5
;	CMPI.B	#-1,320(A2)             * 4 NOPS.     320=40*8
;	BEQ.S	 AGAIN			* 3 SI OUI, 2 SI NON
;        MOVEA.L	MES_PNT,A2	* 5
;        MOVE.L  (A2)+,D0		* 3
;        MOVE.L  (A2)+,D0		* 3
;        MOVE.L	A2,MES_PNT		* 5
;        BRA.S   LA_SUITE		* 3
;AGAIN	MOVE.L	#MES_F,MES_PNT		* 7
;	MOVEQ	#0,D0			* 1
;       MOVEQ   #0,D1			* 1
;	MOVEA.L	MES_PNT,A2		* 5
;        MOVE.L	A2,MES_PNT		* 5


;LA_SUITE
;INC     SET	0
;INC2	SET	0

;        REPT 40
;        LEA.L   $78000+160,A1 		* 3
;        MOVE.L  (A2)+,A0		* 3
;        MOVE.L  (A2)+,D0		* 3
;        ADDA.L  D0,A1			* 2
                
;	MOVEM.L	INC(A0),D0-D7/A3-A6	* 28
;	MOVEM.L	D0-D7/A3-A6,INC2(A1)	* 27
	
;	MOVEM.L	INC+48(A0),D0-D7/A3-A6	* 28
;	MOVEM.L	D0-D7/A3-A6,INC2+48(A1) * 27

;INC     SET	INC+160
;INC2	SET	INC2+230
;        ENDR
