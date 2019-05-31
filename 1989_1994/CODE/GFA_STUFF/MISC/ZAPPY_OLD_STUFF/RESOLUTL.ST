debut:
CLS
PRINT " programme de resolutions de systemes d'equations du premier degr‚ "
PRINT ""
PRINT
PRINT "premiere equation"
PRINT
INPUT "nombre d' x :",x
INPUT "nombre d' y :",y
INPUT "nombre      :",z
PRINT
PRINT "deuxieme equation"
PRINT
INPUT "nombre d' x :",a
INPUT "nombre d' y :",b
INPUT "nombre      :",c
PRINT
PRINT "vos deux equations sont :"
PRINT x;"x + ";y;"y + ";z;" = 0"
PRINT a;"x + ";b;"y + ";c;" = 0"
PRINT
INPUT "etes vous d'accord ? ( o/n ) ",r$
IF r$="n"
  GOTO debut
ENDIF
IF a*y-x*b=0
  GOTO autres
ENDIF
p=(x*c-a*z)/(a*y-x*b)
o=(-(b*p)-c)/a
PRINT "x= ";o
PRINT "y= ";p
PRINT
GOTO i
i:
INPUT "voulez vous recomencer ? ( o/n )",w$
IF w$="o"
  GOTO debut
ENDIF
IF w$="n"
  GOSUB effacement
ENDIF
PRINT "pardon ???"
GOTO i
autres:
IF x/a=z/c
  PRINT "il y a une infinit‚ de solutions"
  GOTO i
ELSE
  PRINT "il y a impossibilit‚"
  GOTO i
ENDIF
END
PROCEDURE effacement
  COLOR 0
  DEFLINE
  BOX 1,1,620,199
  x=0
  xx=0
  y=620
  z=199
  REPEAT
    BOX x,xx,y,z
    INC x
    DEC y
    xx=xx+1
    z=z-1
    PAUSE 1
  UNTIL x=101
  PRINT AT(1,1);"a bientot...."
  PAUSE 50
  CLS
  EDIT
RETURN
