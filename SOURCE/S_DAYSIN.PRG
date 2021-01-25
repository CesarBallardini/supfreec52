/*
�����������������������������������������������������������������
� FUNCTION DAYSIN()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  DAYSIN() Calculates number of days in a month
� 
�  Returns:
�  --------
�  <nDays> => days in month of target date
� 
�  Syntax:
�  -------
�  DAYSIN(dTarget)
� 
�  Description:
�  ------------
�  Returns # of days in month in which <dTarget> falls
� 
�  Examples:
�  ---------
�   dDate    := ctod("10/15/89")
� 
�   nDimonth := DAYSIN(dDate)  // (returns 31)
� 
�  Source:
�  -------
�  S_DAYSIN.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION daysin(dInDate)
local nReturn
local nMonth  := month(dInDate)
local nYear   := year(dInDate)
if nMonth=2  // february, check for leap year
  if (nYear%4=0 .and. nYear%100#0).or. (nYear%400=0)  && leap year
    nReturn := 29
  else
    nReturn := 28
  endif
else
  nReturn   :=  {31,28,31,30,31,30,31,31,30,31,30,31}[nMonth]
endif
return nReturn