gorithm, then P> is shown.
  If it is not in the correct format, then -> is shown, which indicates that
  the normal compression routine is used.
  If you never use this feature, you can kill the 15 marked lines of the 
  unpacking sources in your routines.
- Some files returned with "Data could not be packed". This only occured, if
  there were (somewhere in the file) more than 1038 bytes in a sequence 
  that could not be packed. I corrected this and files like Castle Master 2
  should not make any problems anymore.
- Other changes in packing and unpacking source have been done.
  The old unpacking source is not compatible with the new one!
- With the source "ice_unpa.s", you can unpack data to whatever address you
  like (e.g.: original address: $32345, target address: $72213). Please
  check out that the target address is at least 120 ($78) bytes higher than
  the source address. Otherwise, you might overwrite the original data.
- You do not need the packed length for unpacking anymore. You,POINTC
	CLR.L	FLAG
FINV1	ADDI.L	#1,FLAG
	RTS

	SECTION	DATA
SPR	INCBIN	NEW_ELE.PI1

;ELE_MVT	DC.L	

COURSE	DC.L	SPR+34,SPR+34+32,SPR+34+64,SPR+34+96,SPR+34+128,SPR+34+(160*38),SPR+34+32,-1

	SECTION	BSS
SAUV_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
POINTC	DS.L	1 
FLAG	DS.L	1
ELE_POS	DS.L	1