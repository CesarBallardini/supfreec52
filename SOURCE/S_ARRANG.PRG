/*
�����������������������������������������������������������������
� FUNCTION ARRANGE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ARRANGE() Rearranges text in a string
� 
� 
�  Returns:
�  --------
�  <cNewString> => String rearranged
� 
�  Syntax:
�  -------
�  ARRANGE(cInString,nStart,nLength,nNewPosit)
� 
�  Description:
�  ------------
�  Extracts text from <cInString> starting at <nStart>
�  for a length of <nLength> and moves it to position
�  <nNewPosition>.
� 
�  Examples:
�  ---------
�   cString := "SUPERFUNCTION"
�   cString := ARRANGE(cString,6,8,1)
�    // =>  "FUNCTIONSUPER"
� 
�  Notes:
�  ------
�  New position is position AFTER text is cut from
�  original position
� 
�  Source:
�  -------
�  S_ARRANG.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION arrange(cInstring,nStart,nHowmany,nNewPosition)
LOCAL nStringLength := LEN(cInstring)
LOCAL cExtraction   := SUBST(cInstring,nStart,nHowmany)
cInstring     := STUFF(cInstring,nStart,nHowmany,"")
cInstring     := STUFF(cInstring,nNewPosition,0,cExtraction)
RETURN cInstring