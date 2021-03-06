/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AKOUNT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AKOUNT() Counts exact matches of value in array
³ 
³  Returns:
³  --------
³  <nMatches>  => Number of matches
³ 
³  Syntax:
³  -------
³  AKOUNT(aTarget,expWhatever)
³ 
³  Description:
³  ------------
³  Counts # of exact matches of <expWhatever> in
³  <aTarget>. <expWhatever> can be of any type.
³ 
³  Examples:
³  ---------
³ 
³   AFIELDS(aFields,aTypes)
³   nChar  := AKOUNT(aTypes,"C")  // count C fields
³   nNum   := AKOUNT(aTypes,"N")  // count N fields
³   nDate  := AKOUNT(aTypes,"D")  // count D fields
³ 
³  Notes:
³  -------
³  See also AMATCHES() which allows a code block.
³ 
³  Source:
³  -------
³  S_AKOUNT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
