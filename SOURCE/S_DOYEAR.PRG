/*
�����������������������������������������������������������������
� FUNCTION DOYEAR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  DOYEAR() Calculates day of the year from date
� 
�  Returns:
�  --------
�  <nDayOfYear> => day of the year of date
� 
�  Syntax:
�  -------
�  DOYEAR(dTarget)
� 
�  Description:
�  ------------
�  Calculates day of the year from <dTarget>
� 
�  Examples:
�  ---------
�   dDate   := ctod("10/15/90")
�   nDoYear := DOYEAR(dDate)   //(returns 288)
� 
�  Source:
�  -------
�  S_DOYEAR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION doyear(dInDate)
local nOldDate, nReturn
nOldDate := SET_DATE(1)
nReturn  :=  dInDate- CTOD("01/01/"+RIGHT(DTOC(dInDate),2)) +1
SET_DATE(nOldDate)
RETURN nReturn