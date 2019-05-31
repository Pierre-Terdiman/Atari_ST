 SECTION TEXT

    MOVE.W  #1,-(SP)
    MOVE.W  #0,-(SP)
    MOVE.W  #0,-(SP)
    MOVE.W  #1,-(SP)
    MOVE.W  #0,-(SP)
    CLR.L   -(SP)
    MOVE.L  #TAMPON,-(SP)
    MOVE.W  #8,-(SP)
    TRAP    #14
    ADDA.L  #20,SP

 MOVE.W  #1,-(SP)
 MOVE.W  #-1,-(SP)
 MOVE.L  #-1,-(SP)
 MOVE.L  #TAMPON,-(SP)
 MOVE.W  #18,-(SP)
 TRAP    #14
 ADD.L   #14,SP


	LEA	TAMPON,A0
	MOVE	#$601C,(A0)
	LEA	30(A0),A0
	LEA	BUFFER,A1
	MOVE.L	#(512-30)/4,D0
COPY	MOVE.L	(A1)+,(A0)+
	DBF	D0,COPY

	LEA	TAMPON,A0
	CLR.W	D1
	MOVE.W	#$FE,D0
L79E6A	ADD.W	(A0)+,D1
	DBF	D0,L79E6A
	MOVE.W	#$1234,D0
	SUB.W	D1,D0
	
	LEA	TAMP_END,A0
	LEA	-2(A0),A0
	MOVE	D0,(A0)


ECRIT:

    MOVE.W  #1,-(SP)
    MOVE.W  #0,-(SP)
    MOVE.W  #0,-(SP)
    MOVE.W  #1,-(SP)
    MOVE.W  #0,-(SP)
    CLR.L   -(SP)
    MOVE.L  #TAMPON,-(SP)
    MOVE.W  #9,-(SP)
    TRAP    #14
    ADDA.L  #20,SP
    TRAP #1

TAMPON   
	DS.B	512
TAMP_END
	DS.B	512
BUFFER
