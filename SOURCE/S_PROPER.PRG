/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PROPER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PROPER() Capitalizes first letters of string, lowers rest
³ 
³  Returns:
³  --------
³  <cProper> => string properized
³ 
³  Syntax:
³  -------
³  PROPER(cTarget)
³ 
³  Description:
³  ------------
³  Capitalizes all first letters of words in <cTarget>
³  and converts the rest to lowercase
³ 
³  Examples:
³  ---------
³   cString := "SUPER liBraRy"
³ 
³   cString := PROPER(string)
³ 
³   // (returns "Super Library"
³ 
³  Notes:
³  -------
³  There are cases where this just won't work - for
³  instance I.B.M. would be converted to I.b.m.
³ 
³  Source:
³  -------
³  S_PROPER.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
