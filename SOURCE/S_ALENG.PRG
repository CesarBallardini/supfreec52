/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ALENG()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ALENG() Actual length of an array, less trailing nil elements
ณ 
ณ  Returns:
ณ  --------
ณ  <aLength>  => Actual array length, less trailing NILs
ณ 
ณ  Syntax:
ณ  -------
ณ  ALENG(aTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines the actual length of <aTarget>, less
ณ  trailing nils.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   a := {1,2,3,4,5,nil,nil,nil}
ณ   ?len(a)       // => returns 8
ณ   ?aleng(a)     // => returns 5
ณ 
ณ  Notes:
ณ  ------
ณ  This was a C function in prior Super.Libs
ณ 
ณ  Source:
ณ  -------
ณ  S_ALENG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function Aleng(aArray)
local i,nActualLength := 0
for i = 1 to len(aArray)
   if aArray[i]#nil
     nActualLength++
   else
     exit
   endif
next
return nActualLength


