/*
�����������������������������������������������������������������
� FUNCTION SETEXACT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SETEXACT() Determines if exact is on/off
� 
�  Returns:
�  --------
�  <lExact> => Exact is on/off
� 
�  Syntax:
�  -------
�  SETEXACT([lNew])
� 
�  Description:
�  ------------
�  Returns current SET EXACT setting and optionally sets
�  exact on/off with [lNew]  .t. = ON .f. = OFF
� 
�  Examples:
�  ---------
�   nOldexact = SETEXACT(.f.) // SET EXACT OFF
� 
�   * code
� 
�   SETEXACT(nOldexact)
� 
�  Source:
�  -------
�  S_SETEX.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION SETEXACT(lExact)
return SET(_SET_EXACT,lExact)