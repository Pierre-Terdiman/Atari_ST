PREPA
TBL4:	LEA	TABLE_A4,A0
	MOVE	#319,D7
.DEBT	CLR.L	(A0)+
	DBF	D7,.DEBT

	LEA	MINI_TABLE,A1
	MOVEQ	#0,D6	D6=X
	MOVEQ	#20-1,D7
.F	MOVEQ	#16-1,D0
.SXTEEN	MOVE	(A1),(A0)+
	MOVE	D6,(A0)+
	ADDQ	#2,D6
	DBF	D0,.SXTEEN
	ADDQ	#2,A1
	DBF	D7,.F

	MOVE	#319,D7
.FINT	CLR	(A0)+
	MOVE	#640,(A0)+
	DBF	D7,.FINT
TBL2:
	LEA	TABLE_A2,A0
;	MOVE	#319,D7
;.DEBT	CLR.L	(A0)+
;	DBF	D7,.DEBT

	LEA	MINI_TABLE,A1
	MOVEQ	#0,D6	D6=X
	MOVEQ	#20-1,D7
.F	MOVEQ	#16-1,D0
.SXTEEN	MOVE	(A1),(A0)+
	MOVE	D6,(A0)
	MOVE	D6,D5
	AND	#15,D5
	MULU	#1280,D5
	SUB	D5,(A0)+
	ADDQ	#2,D6
	DBF	D0,.SXTEEN
	ADDQ	#2,A1
	DBF	D7,.F

	MOVE	#319,D7
.FINT	CLR	(A0)+
	MOVE	#640,(A0)+
	DBF	D7,.FINT

	RTS


MINI_TABLE
N	SET	0
	REPT	20
	DC	N
N	SET	N+8
	ENDR

INIT	LEA	BUF_COD_GEN,A5
	MOVE	#160,D7
	MOVE	#ADR_SCR,D6
	SUB	#160,D6
	MOVE.L	#TABLE_A2,D5
	MOVE.L	D5,D4
	MOVE.L	#TABLE_A4,D2
	MOVE.L	D2,D0

	ADD.W	D7,D6	1  PROCHAINE LIGNE:+160
	MOVE.W	D6,A3	1  A3=ADR ECRAN EN .W, WARNING!
	MOVE.L	A3,A6	1  A6=ECRAN TOO (LE A5 DE FULBERT)
	MOVE.L	D4,A2	1  D4=A2=TABLE_A2
	MOVE.L	D0,A4	1  D0=A4=TABLE_A4

	MOVE.W	(A1)+,D1	2  X2
	ADD.W	D1,D1	1  
	ADD.W	D1,D1	1
	ADD	D1,A4	2  A4=TABLE_A4+X2*4
	ADD	(A4)+,A6	3  OFFSET. A6=>DERNIER MOT
	MOVE	(A4),D3	2  NEW_X2 CLIPP�*2

	MOVE.W	(A0)+,D1	2  X1
	ADD	D1,D1	1
	ADD	D1,D1	1
	ADD	D1,A2	2  A2=TABLE_A2+X1*4
	ADD	(A2)+,A3	3  OFFSET. A3=>1ER MOT
	SUB	(A2),D3	2  (A2) CONTIENT ICI X1*2-LE D�CALAGE... RUS�, HEIN?
			   ;D'OU D3=X2*2-(X1*2-D�CALAGE)=(X2-X1)*2+D�CALAGE, ZOU.
	JMP	(A5,D3.W)	4  GO TO HELL!

;TOTAL:31 NOPS. +58=89 NOPS.

;FULBERT'S ROUTINE:
;1	ADD.W	D5,D4	;PROCHAINE LIGNE:+160
;2	MOVE.W	(A0)+,D0	;X1
;2	MOVE.W	(A1)+,D1	;X2
;1	ADD.W	D0,D0	;X1*2
;1	ADD.W	D1,D1	;X2*2
;1	MOVE.L	D4,A4	;A4=ADRESSE ECRAN ACTUELLE
;1	MOVE.L	D4,A5	;A5=ADRESSE ECRAN ACTUELLE
;5	ADDA.W	(A2,D0.W),A4	;ON SE PLACE AU PREMIER MOT UTILIS�
;5	ADDA.W	(A2,D1.W),A5	;ON SE PLACE AU DERNIER MOT UTILIS�
;1	SUB.W	D0,D1	;D1=DISTANCE*2
;4	ADD.W	(A3,D0.W),D1	;D1=DISTANCE*2+(X1 AND 15)*1280
;5	MOVE.L	(A6,D1.W),A7	;A7=ADRESSE DE LA ROUTINE(<$10000)
;2	JMP	(A7)	;ON Y GO!
;
;TOTAL:31+58=89 NOPS.

	BSS
TABLE_A4
	DS.L	320*3
TABLE_A2
	DS.L	320*2
