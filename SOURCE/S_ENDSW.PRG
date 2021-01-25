/*
�����������������������������������������������������������������
� FUNCTION ENDSWITH()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ENDSWITH() Determines if a string ends with another string
� 
�  Returns:
�  --------
�  <lEndsWith> => True or False, string 2 ends with
�  string 1
� 
�  Syntax:
�  -------
�  ENDSWITH(cTarget,cEndsWith)
� 
�  Description:
�  ------------
�  Determines if string 1 <cTarget> ends with string 2
�  <cEndsWith>
� 
�  Examples:
�  ---------
�   cStr1    = "SUPERFUNCTION"
�   cStr2    = "FUNCTION"
�   cStr3    = "FUNKY"
�   ENDSWITH(cStr1,cStr2)  //returns .t.
�   ENDSWITH(cStr1,cStr3)     //returns .f.
� 
�  Source:
�  -------
�  S_ENDSW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION endswith(cInString,cCompareString)
RETURN (cCompareString==RIGHT(cInString,LEN(cCompareString) ))