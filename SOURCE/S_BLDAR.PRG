*- first param MUST be an array now
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BLDARR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BLDARR() Builds an array from a delimited string
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  BLDARR(aTarget,nCount,cDelimited)
ณ 
ณ  Description:
ณ  ------------
ณ  Fills in the elements of an existing array <aTarget>
ณ  with <nCount> character values extracted from a delimited string
ณ  <cDelimited> of the form "Garry:Wyn:Ralph:Ed". The colon [:] is
ณ  the delimiter. The first parameter is an array of any length. It
ณ  will be sized to fit.
ณ 
ณ  Examples:
ณ  ---------
ณ   aLunch := array(3)
ณ   BLDARR(aLunch,3,"Pizza:Chicken:Burgers")
ณ       // =>  {"Pizza","Chicken","Burgers"}
ณ 
ณ  Notes:
ณ  -------
ณ  Array must be declared prior to calling.
ณ  Of course, in Clipper 5.01 you can also use:
ณ  myarray := {"Pizza","Chicken","Burgers"},
ณ  and this function is mainly here for compatibility.
ณ 
ณ  Source:
ณ  -------
ณ  S_BLDAR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION bldarr(aArray,nArrayLength,cInString)
local cNextElement,nIterator
asize(aArray,nArrayLength)
FOR nIterator = 1 TO nArrayLength
  cNextElement      := takeout(cInString,":",nIterator)
  aArray[nIterator] := cNextElement
NEXT
return nil
