/*
�����������������������������������������������������������������
� FUNCTION BOM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BOM() Calculates beginning of the month date
� 
�  Returns:
�  --------
�  <dReturn> => Date which is beginning of the month
� 
�  Syntax:
�  -------
�  BOM(dTarget)
� 
�  Description:
�  ------------
�  Calculates date which is beginning of the month from
�  <dTarget>
� 
�  Examples:
�  ---------
�   dDate := ctod("10/15/90")
� 
�   dBom  := BOM(DDate)    //    => 10/01/90
� 
�  Source:
�  -------
�  S_BOM.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION bom(dInDate)
local nPrevDateFormat  := SET_DATE(1)
local dReturn          := CTOD(TRANSFORM(MONTH(dInDate),'99')+"/01/"+;
                          TRANSFORM(YEAR(dInDate),'9999'))
SET_DATE(nPrevDateFormat)
return dReturn