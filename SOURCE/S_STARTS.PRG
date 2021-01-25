/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STARTSW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STARTSW() Determines if a string starts with another string
ณ 
ณ  Returns:
ณ  --------
ณ  <lStartsWith> => String 1 starts with string 2
ณ 
ณ  Syntax:
ณ  -------
ณ  STARTSW(cTarget,cStarts)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines if string 1 <cTarget> starts with string 2
ณ  <cStarts>
ณ 
ณ  Examples:
ณ  ---------
ณ   cStr1    := "SUPERFUNCTION"
ณ 
ณ   cStr2    := "SUPER"
ณ 
ณ   cStr3    := "SOUP"
ณ 
ณ   STARTSW(cStr1,cStr2)    //returns .t.
ณ 
ณ   STARTSW(cStr1,cStr3)    //returns .f.
ณ 
ณ  Source:
ณ  -------
ณ  S_STARTS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION startsw(cInString,cStartsWith)
RETURN (cStartsWith==LEFT(cInString,LEN(cStartsWith)))
