/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DELARRAY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DELARRAY() Deletes all elements of an array
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  DELARRAY(aTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Deletes all elements of an array <aTarget>. Basically
ณ  un-initializes the array.
ณ 
ณ  Examples:
ณ  ---------
ณ     // Same as
ณ 
ณ   afill(aTarget,nil)
ณ 
ณ   (In 5.01 you can do afill(aTarget,NIL) instead, but
ณ  this is here for compatibility.)
ณ 
ณ  Source:
ณ  -------
ณ  S_DELAR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION delarray(aArray)
local nLen := len(aArray)
aSize(aArray,0)
aSize(aArray,nLen)
RETURN ''
