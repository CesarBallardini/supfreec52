/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BIGELEM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BIGELEM() Returns length of longest string in an array
³ 
³  Returns:
³  --------
³  <nLength> => Length of longest string in an array
³ 
³  Syntax:
³  -------
³  BIGELEM(aTarget)
³ 
³  Description:
³  ------------
³  Determines the length of the longest string element
³  in <aTarget> Array may have mixed types
³ 
³  Examples:
³  ---------
³   ?BIGELEM(  {"1","22","333"}  )  => returns 3
³ 
³  Notes:
³  -------
³  This was a C function in previous SuperLibs
³ 
³  Source:
³  -------
³  S_BIGEL.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


