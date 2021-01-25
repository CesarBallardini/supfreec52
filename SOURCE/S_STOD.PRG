/*
�����������������������������������������������������������������
� FUNCTION STOD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STOD() Returns date from string in the form YYYYMMDD
� 
�  Returns:
�  --------
�  <dDate> => date from string
� 
�  Syntax:
�  -------
�  STOD(cStringDate)
� 
�  Description:
�  ------------
�  Returns date from string of the form YYYYMMDD
�  <cStringDate>
� 
�  Examples:
�  ---------
�   cStrdate := "19890102"
� 
�   dNewdate := STOD(cStrdate)
� 
�   // (returns 01/02/89 type date)
� 
�  Source:
�  -------
�  S_STOD.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION Stod(cStringDate)
local nSaveDaveFormat := SET_DATE(1)
local dReturnDate     := CTOD(SUBSTR(cStringDate,5,2)+'/';
                       +SUBSTR(cStringDate,7,2)+'/';
                       +SUBSTR(cStringDate,1,4))
SET_DATE(nSaveDaveFormat)
RETURN dReturnDate