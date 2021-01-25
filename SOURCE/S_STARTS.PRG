/*
�����������������������������������������������������������������
� FUNCTION STARTSW()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STARTSW() Determines if a string starts with another string
� 
�  Returns:
�  --------
�  <lStartsWith> => String 1 starts with string 2
� 
�  Syntax:
�  -------
�  STARTSW(cTarget,cStarts)
� 
�  Description:
�  ------------
�  Determines if string 1 <cTarget> starts with string 2
�  <cStarts>
� 
�  Examples:
�  ---------
�   cStr1    := "SUPERFUNCTION"
� 
�   cStr2    := "SUPER"
� 
�   cStr3    := "SOUP"
� 
�   STARTSW(cStr1,cStr2)    //returns .t.
� 
�   STARTSW(cStr1,cStr3)    //returns .f.
� 
�  Source:
�  -------
�  S_STARTS.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION startsw(cInString,cStartsWith)
RETURN (cStartsWith==LEFT(cInString,LEN(cStartsWith)))