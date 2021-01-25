/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISPART()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISPART() Determines if a value is part of a set
ณ 
ณ  Returns:
ณ  --------
ณ  <lIsPart> => if value is part of set
ณ 
ณ  Syntax:
ณ  -------
ณ  ISPART(expX1,expX2,[expX3],...[expX10])
ณ 
ณ  Description:
ณ  ------------
ณ  Compares a value <expX1> to a set of values of same
ณ  type <expX2..expX10> to determine if it is equal to any of
ณ  them. Returns True if it is, False otherwise. Up to 9 values to
ณ  compare.
ณ 
ณ  Examples:
ณ  ---------
ณ   If ISPART(nChoice,5,6,7,12)
ณ     MSG("Need a DBF open")
ณ     loop
ณ   endif
ณ 
ณ   If ISPART(cChars,"A","B","C","D")
ณ 
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_ISPART.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ispart(expTest,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16)
local aExpr := {x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16}
asize(aExpr,pcount()-1)
return (ascan(aExpr,expTest)>0)
