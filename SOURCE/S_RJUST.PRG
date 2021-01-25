/*
�����������������������������������������������������������������
� FUNCTION RJUST()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  RJUST() Right justifies a string
� 
�  Returns:
�  --------
�  <cJustified> => string right justified
� 
�  Syntax:
�  -------
�  RJUST(cTarget)
� 
�  Description:
�  ------------
�  Right justifies <cTarget>
� 
�  Examples:
�  ---------
�   string        := "Superfunction      "
� 
�   string        := RJUST(string)
� 
�   // (returns       "      Superfunction"
� 
�  Source:
�  -------
�  S_RJUST.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION Rjust(cInstring)
return PADL(alltrim(cInstring),len(cInString) )