/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISPART()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISPART() Determines if a value is part of a set
³ 
³  Returns:
³  --------
³  <lIsPart> => if value is part of set
³ 
³  Syntax:
³  -------
³  ISPART(expX1,expX2,[expX3],...[expX10])
³ 
³  Description:
³  ------------
³  Compares a value <expX1> to a set of values of same
³  type <expX2..expX10> to determine if it is equal to any of
³  them. Returns True if it is, False otherwise. Up to 9 values to
³  compare.
³ 
³  Examples:
³  ---------
³   If ISPART(nChoice,5,6,7,12)
³     MSG("Need a DBF open")
³     loop
³   endif
³ 
³   If ISPART(cChars,"A","B","C","D")
³ 
³   endif
³ 
³  Source:
³  -------
³  S_ISPART.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION ispart(expTest,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16)
local aExpr := {x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16}
asize(aExpr,pcount()-1)
return (ascan(aExpr,expTest)>0)
