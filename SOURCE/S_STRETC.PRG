/*
�����������������������������������������������������������������
� FUNCTION STRETCH()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STRETCH() Imbeds characters in a string
� 
�  Returns:
�  --------
�  <cStretched> => string with characters imbedded
� 
�  Syntax:
�  -------
�  STRETCH(cSource,cFill,nEvery)
� 
�  Description:
�  ------------
�  Imbeds character <cFill> in string <cSource> every
�  <nEvery> character
� 
�  Examples:
�  ---------
�   cString := "SUPERFUNCTION"
� 
�   cString := STRETCH(cString,' ',1)
� 
�   // (returns "S U P E R F U N C T I O N")
� 
�  Notes:
�  -------
�  This hombre might be called EXPAND in other parts
� 
�  Source:
�  -------
�  S_STRETC.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION stretch(cInString,cImbedChar,nFrequency)
local nIter,nLenString,cOutString
cOutString := ''
nLenString := LEN(cInString)
for nIter = 1 TO nLenString-nFrequency STEP nFrequency
  cOutString += ( SUBST(cInString,nIter,nFrequency)+cImbedChar )
NEXT
cOutString += ( SUBST(cInString,nIter) )
RETURN cOutString