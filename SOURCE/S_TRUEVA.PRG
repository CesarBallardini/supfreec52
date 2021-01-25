/*
�����������������������������������������������������������������
� FUNCTION TRUEVAL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  TRUEVAL() Returns val of ALL numerics in a string
� 
�  Returns:
�  --------
�  <nValue> => all numerics value
� 
�  Syntax:
�  -------
�  TRUEVAL(cString)
� 
�  Description:
�  ------------
�  Removes all non-numeric characters from a <cString>,
�  and then converts it to numeric.
� 
�  Examples:
�  ---------
�   cString := "SUPERFUNCTION Library version 3.00"
� 
�   cNumber := TRUEVAL(cString)
� 
�   // (returns 3.0)
� 
�  Source:
�  -------
�  S_TRUEVA.PRG
� 
����������������������������������������������������������������� 
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