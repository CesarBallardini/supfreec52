*- first param MUST be an array now
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BLDARR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BLDARR() Builds an array from a delimited string
³ 
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  BLDARR(aTarget,nCount,cDelimited)
³ 
³  Description:
³  ------------
³  Fills in the elements of an existing array <aTarget>
³  with <nCount> character values extracted from a delimited string
³  <cDelimited> of the form "Garry:Wyn:Ralph:Ed". The colon [:] is
³  the delimiter. The first parameter is an array of any length. It
³  will be sized to fit.
³ 
³  Examples:
³  ---------
³   aLunch := array(3)
³   BLDARR(aLunch,3,"Pizza:Chicken:Burgers")
³       // =>  {"Pizza","Chicken","Burgers"}
³ 
³  Notes:
³  -------
³  Array must be declared prior to calling.
³  Of course, in Clipper 5.01 you can also use:
³  myarray := {"Pizza","Chicken","Burgers"},
³  and this function is mainly here for compatibility.
³ 
³  Source:
³  -------
³  S_BLDAR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION bldarr(aArray,nArrayLength,cInString)
local cNextElement,nIterator
asize(aArray,nArrayLength)
FOR nIterator = 1 TO nArrayLength
  cNextElement      := takeout(cInString,":",nIterator)
  aArray[nIterator] := cNextElement
NEXT
return nil
