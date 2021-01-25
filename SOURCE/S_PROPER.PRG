/*
�����������������������������������������������������������������
� FUNCTION PROPER()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PROPER() Capitalizes first letters of string, lowers rest
� 
�  Returns:
�  --------
�  <cProper> => string properized
� 
�  Syntax:
�  -------
�  PROPER(cTarget)
� 
�  Description:
�  ------------
�  Capitalizes all first letters of words in <cTarget>
�  and converts the rest to lowercase
� 
�  Examples:
�  ---------
�   cString := "SUPER liBraRy"
� 
�   cString := PROPER(string)
� 
�   // (returns "Super Library"
� 
�  Notes:
�  -------
�  There are cases where this just won't work - for
�  instance I.B.M. would be converted to I.b.m.
� 
�  Source:
�  -------
�  S_PROPER.PRG
� 
����������������������������������������������������������������� 
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