/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION TRUEVAL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  TRUEVAL() Returns val of ALL numerics in a string
ณ 
ณ  Returns:
ณ  --------
ณ  <nValue> => all numerics value
ณ 
ณ  Syntax:
ณ  -------
ณ  TRUEVAL(cString)
ณ 
ณ  Description:
ณ  ------------
ณ  Removes all non-numeric characters from a <cString>,
ณ  and then converts it to numeric.
ณ 
ณ  Examples:
ณ  ---------
ณ   cString := "SUPERFUNCTION Library version 3.00"
ณ 
ณ   cNumber := TRUEVAL(cString)
ณ 
ณ   // (returns 3.0)
ณ 
ณ  Source:
ณ  -------
ณ  S_TRUEVA.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION trueval(cInString)
local nIter,cThisLetter
local nLenString := LEN(cInString)
local cOutValue := ''
for nIter = 1 TO nLenString
  cThisLetter := SUBST(cInString,nIter,1)
  IF cThisLetter$"0123456789."
    cOutValue += cThisLetter
  ENDIF
NEXT
RETURN VAL(cOutValue)
*: EOF: S_TRUEVA.PRG
