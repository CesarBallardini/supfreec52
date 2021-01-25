/*
�����������������������������������������������������������������
� FUNCTION NBR2STR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  NBR2STR() Correctly orders numerics where negative
� 
�  Returns:
�  --------
�  String
� 
�  Syntax:
�  -------
�  NBR2STR(nNumber)
� 
�  Description:
�  ------------
�  Ensure numeric fields are correctly ordered when
�  converting to type character and when taking negatives into account.
� 
�  This is done by attaching CR, DB or CZ to the end of
�  the number to overcome the placement of (-+) in the ASCII scale.
� 
�  Examples:
�  ---------
�   index on LASTNAME+NBR2STR(amount_due) to NEWINDEX
� 
�  Source:
�  -------
�  S_NBR2ST.PRG
� 
����������������������������������������������������������������� 
*/
*FUNCTION nbr2str(nNumber)
*RETURN TRANS(nNumber,"@CX")+IIF(nNumber=0," CZ","")
*--- the above was incorrect
/*
�����������������������������������������������������������������
� FUNCTION NBR2STR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  NBR2STR() Correctly orders numerics where negative
� 
�  Returns:
�  --------
�  String
� 
�  Syntax:
�  -------
�  NBR2STR(nNumber)
� 
�  Description:
�  ------------
�  Ensure numeric fields are correctly ordered when
�  converting to type character and when taking negatives into account.
� 
�  This is done by attaching CR, DB or CZ to the end of
�  the number to overcome the placement of (-+) in the ASCII scale.
� 
�  Examples:
�  ---------
�   index on LASTNAME+NBR2STR(amount_due) to NEWINDEX
� 
�  Source:
�  -------
�  S_NBR2ST.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION nbr2str(nNumber)
RETURN TRANS(1000000000000+nNumber,"")
