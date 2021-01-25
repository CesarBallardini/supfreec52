/*
�����������������������������������������������������������������
� FUNCTION NOZDIV()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  NOZDIV() Prevents divide-by-zero
� 
�  Returns:
�  --------
�  <nNumber> => division result
� 
�  Syntax:
�  -------
�  NOZDIV(nNumber)
� 
�  Description:
�  ------------
�  Prevents divide-by-zero by converting a number to 1
�  if it is zero, otherwise leaving it as-is.
� 
�  Not really needed in 5.01, but here for backward
�  compatibility.
� 
�  Examples:
�  ---------
�   x = 5
�   y = 0
� 
�   z = x/NOZDIV(y)
� 
�  Source:
�  -------
�  S_NOZDIV.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION NOZDIV(nValue)
RETURN IIF(nValue=0,1,nValue)