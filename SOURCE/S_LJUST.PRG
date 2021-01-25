
/*
�����������������������������������������������������������������
� FUNCTION LJUST()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  LJUST() Left justifies a string
� 
�  Returns:
�  --------
�  <cJustified> => string left justified
� 
�  Syntax:
�  -------
�  LJUST(cTarget)
� 
�  Description:
�  ------------
�  Left justifies <cTarget>
� 
�  Examples:
�  ---------
�   string = "      Superfunction"
� 
�   string = LJUST(string)
� 
�   // (returns "Superfunction    "
� 
�  Source:
�  -------
�  S_LJUST.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION Ljust(cString)
RETURN padr(ALLTRIM(cString),LEN(cString))