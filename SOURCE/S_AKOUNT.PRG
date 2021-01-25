/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AKOUNT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AKOUNT() Counts exact matches of value in array
ณ 
ณ  Returns:
ณ  --------
ณ  <nMatches>  => Number of matches
ณ 
ณ  Syntax:
ณ  -------
ณ  AKOUNT(aTarget,expWhatever)
ณ 
ณ  Description:
ณ  ------------
ณ  Counts # of exact matches of <expWhatever> in
ณ  <aTarget>. <expWhatever> can be of any type.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   AFIELDS(aFields,aTypes)
ณ   nChar  := AKOUNT(aTypes,"C")  // count C fields
ณ   nNum   := AKOUNT(aTypes,"N")  // count N fields
ณ   nDate  := AKOUNT(aTypes,"D")  // count D fields
ณ 
ณ  Notes:
ณ  -------
ณ  See also AMATCHES() which allows a code block.
ณ 
ณ  Source:
ณ  -------
ณ  S_AKOUNT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION akount(aArray,expValue)
local nIterator
local nMatchKount  := 0
local cTypeNeeded  := VALTYPE(expValue)
local narrayLength := aleng(aArray)
for nIterator = 1 TO narrayLength
  IF VALTYPE(aArray[nIterator])==cTypeNeeded
    IF aArray[nIterator] == expValue
      nMatchKount++
    ENDIF
  ENDIF
NEXT
RETURN nMatchKount
