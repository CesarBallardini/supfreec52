/*
�����������������������������������������������������������������
� FUNCTION WOMONTH()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  WOMONTH() Calculates week of the month (# of 7 day periods)
� 
�  Returns:
�  --------
�  <nWeek> => week of the month
� 
�  Syntax:
�  -------
�  WOMONTH(dDate)
� 
�  Description:
�  ------------
�  Calculates current number of 7 day periods for the
�  month from <dDate>
� 
�  Examples:
�  ---------
�   dDate := ctod("10/15/90")
� 
�   nDom  := WOMONTH(dDate)
� 
�   // (returns 3)
� 
�  Source:
�  -------
�  S_WOMON.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION womonth(dDate)
local nDayOfMonth := DAY(dDate)
RETURN INT(nDayOfMonth/7)+IIF(nDayOfMonth%7>0,1,0)