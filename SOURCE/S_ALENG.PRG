/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ALENG()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ALENG() Actual length of an array, less trailing nil elements
³ 
³  Returns:
³  --------
³  <aLength>  => Actual array length, less trailing NILs
³ 
³  Syntax:
³  -------
³  ALENG(aTarget)
³ 
³  Description:
³  ------------
³  Determines the actual length of <aTarget>, less
³  trailing nils.
³ 
³  Examples:
³  ---------
³ 
³   a := {1,2,3,4,5,nil,nil,nil}
³   ?len(a)       // => returns 8
³   ?aleng(a)     // => returns 5
³ 
³  Notes:
³  ------
³  This was a C function in prior Super.Libs
³ 
³  Source:
³  -------
³  S_ALENG.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


