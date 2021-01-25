/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BIGELEM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BIGELEM() Returns length of longest string in an array
ณ 
ณ  Returns:
ณ  --------
ณ  <nLength> => Length of longest string in an array
ณ 
ณ  Syntax:
ณ  -------
ณ  BIGELEM(aTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines the length of the longest string element
ณ  in <aTarget> Array may have mixed types
ณ 
ณ  Examples:
ณ  ---------
ณ   ?BIGELEM(  {"1","22","333"}  )  => returns 3
ณ 
ณ  Notes:
ณ  -------
ณ  This was a C function in previous SuperLibs
ณ 
ณ  Source:
ณ  -------
ณ  S_BIGEL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function BIGELEM(aArray)
local nLongest := 0
local nIterator
for nIterator = 1 to len(aArray)
   if valtype(aArray[nIterator])=="C"
     nLongest := max(nLongest,len(aArray[nIterator]))
   endif
next
return nLongest


