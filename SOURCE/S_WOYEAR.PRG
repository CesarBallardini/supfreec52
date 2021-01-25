/*
�����������������������������������������������������������������
� FUNCTION WOYEAR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  WOYEAR() Calculates week of the year (# of 7 day periods)
� 
�  Returns:
�  --------
�  <nWeek> => week of the year of date
� 
�  Syntax:
�  -------
�  WOYEAR(dDate)
� 
�  Description:
�  ------------
�  Calculates number of 7 day periods passed for the
�  year from <dDate>
� 
�  Examples:
�  ---------
�   dDate    := ctod("10/15/90")
� 
�   nWoYear  := WOYEAR(dDate)
� 
�   // (returns 40)
� 
�  Source:
�  -------
�  S_WOYEAR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION woyear(dDate)
local nDayOfYear := DOYEAR(dDate)
RETURN INT(nDayOfYear/7)+IIF(nDayOfYear%7>0,1,0)