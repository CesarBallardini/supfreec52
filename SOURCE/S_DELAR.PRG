/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DELARRAY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DELARRAY() Deletes all elements of an array
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  DELARRAY(aTarget)
³ 
³  Description:
³  ------------
³  Deletes all elements of an array <aTarget>. Basically
³  un-initializes the array.
³ 
³  Examples:
³  ---------
³     // Same as
³ 
³   afill(aTarget,nil)
³ 
³   (In 5.01 you can do afill(aTarget,NIL) instead, but
³  this is here for compatibility.)
³ 
³  Source:
³  -------
³  S_DELAR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION delarray(aArray)
local nLen := len(aArray)
aSize(aArray,0)
aSize(aArray,nLen)
RETURN ''
