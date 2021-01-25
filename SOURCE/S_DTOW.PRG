/*
�����������������������������������������������������������������
� FUNCTION DTOW()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  DTOW() Converts date to words
� 
�  Returns:
�  --------
�  <cDateWords> => date as words
� 
�  Syntax:
�  -------
�  DTOW(dTarget)
� 
�  Description:
�  ------------
�  Returns date in <dTarget> as words
� 
�  Examples:
�  ---------
�   dDate     := ctod("10/15/89")
�   cWdate     := DTOW(dDate)
�   // returns "October 15, 1989"
� 
�  Source:
�  -------
�  S_DTOW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION dtow(dIndate)
IF EMPTY(dIndate)
  RETURN SPACE(18)
ENDIF
RETURN PADR(CMONTH(dInDate)+' '+LTRIM(TRANS(DAY(dInDate),"99"))+', '+TRANS(YEAR(dInDate),"9999"),18)
