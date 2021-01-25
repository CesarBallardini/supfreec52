/*
�����������������������������������������������������������������
� FUNCTION BOYEAR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BOYEAR() Determine beginning of year a date falls in
� 
�  Returns:
�  --------
�  <dReturn> => Date of the beginning of the year
� 
�  Syntax:
�  -------
�  BOYEAR([dTarget])
� 
�  Description:
�  ------------
�  Determines beginning of the year of a date and
�  returns it as <dReturn>. [dTarget] a date variable. Default is
�  DATE()
� 
�  Examples:
�  ---------
�   dBegyear := BOYEAR(date())
� 
�  Source:
�  -------
�  S_BOYEAR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION BOYEAR(dInDate)
local dReturn
local nSaveDate := SET_DATE(1)
dInDate := iif(valtype(dInDate)<>"D",date(),dInDate)
dReturn := CTOD("01/01/"+ right(TRANS(YEAR(dInDate),"9999"),2)  )
SET_DATE(nSaveDate)
return dReturn
