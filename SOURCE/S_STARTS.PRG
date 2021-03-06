/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION STARTSW()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  STARTSW() Determines if a string starts with another string
³ 
³  Returns:
³  --------
³  <lStartsWith> => String 1 starts with string 2
³ 
³  Syntax:
³  -------
³  STARTSW(cTarget,cStarts)
³ 
³  Description:
³  ------------
³  Determines if string 1 <cTarget> starts with string 2
³  <cStarts>
³ 
³  Examples:
³  ---------
³   cStr1    := "SUPERFUNCTION"
³ 
³   cStr2    := "SUPER"
³ 
³   cStr3    := "SOUP"
³ 
³   STARTSW(cStr1,cStr2)    //returns .t.
³ 
³   STARTSW(cStr1,cStr3)    //returns .f.
³ 
³  Source:
³  -------
³  S_STARTS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION startsw(cInString,cStartsWith)
RETURN (cStartsWith==LEFT(cInString,LEN(cStartsWith)))
