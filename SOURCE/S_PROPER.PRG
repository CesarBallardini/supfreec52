/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROPER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROPER() Capitalizes first letters of string, lowers rest
ณ 
ณ  Returns:
ณ  --------
ณ  <cProper> => string properized
ณ 
ณ  Syntax:
ณ  -------
ณ  PROPER(cTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Capitalizes all first letters of words in <cTarget>
ณ  and converts the rest to lowercase
ณ 
ณ  Examples:
ณ  ---------
ณ   cString := "SUPER liBraRy"
ณ 
ณ   cString := PROPER(string)
ณ 
ณ   // (returns "Super Library"
ณ 
ณ  Notes:
ณ  -------
ณ  There are cases where this just won't work - for
ณ  instance I.B.M. would be converted to I.b.m.
ณ 
ณ  Source:
ณ  -------
ณ  S_PROPER.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION PROPER(cInString)
local nIter,cOutString,cThisChar,lCapNext

lCapNext   := .T.
cOutString := ''

*- loop for length of string
FOR nIter = 1 TO LEN(cInString)
  cThisChar  := SUBST(cInString,nIter,1)
  *- if its not alpha,cap the next alpha character
  IF !UPPER(cThisChar) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ'"
    lCapNext := .T.
  ELSE
    *- capitalise it or lower() it accordingly
    IF lCapNext
      cThisChar := UPPER(cThisChar)
      lCapNext  := .F.
    ELSE
      cThisChar := LOWER(cThisChar)
    ENDIF
  ENDIF
  *- add it to the cOutString
  cOutString += cThisChar
NEXT
RETURN cOutString

*: EOF: S_PROPER.PRG
