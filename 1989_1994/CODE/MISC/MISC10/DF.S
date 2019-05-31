;	LEA	TXT(PC),A0
;	LEA	P(PC),A1
;	MOVE.B	(A0),(A1)
;	MOVE.B	1(A0),1(A1)
;	MOVE.B	2(A0),2(A1)
;	MOVE.B	3(A0),3(A1)
;	MOVE.L	(A1),D0
;P	DC.B	'    '
;;	DS.B	1
;TXT	DC.B	'ABCD'
************************************************************************
