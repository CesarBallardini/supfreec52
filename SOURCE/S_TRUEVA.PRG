/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION TRUEVAL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  TRUEVAL() Returns val of ALL numerics in a string
³ 
³  Returns:
³  --------
³  <nValue> => all numerics value
³ 
³  Syntax:
³  -------
³  TRUEVAL(cString)
³ 
³  Description:
³  ------------
³  Removes all non-numeric characters from a <cString>,
³  and then converts it to numeric.
³ 
³  Examples:
³  ---------
³   cString := "SUPERFUNCTION Library version 3.00"
³ 
³   cNumber := TRUEVAL(cString)
³ 
³   // (returns 3.0)
³ 
³  Source:
³  -------
³  S_TRUEVA.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
