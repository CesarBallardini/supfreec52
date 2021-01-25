/*
�����������������������������������������������������������������
� FUNCTION PRNT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PRNT() Writes a string of a given color at row, column
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  PRNT(nRow, nColumn, cString, nColor)
� 
�  Description:
�  ------------
�  <nRow>       row
�
�  <nColumn>    column
� 
�  <cString>    string
� 
�  <nColor>     color attribute
� 
�  Examples:
�  ---------
�   PRNT(10,10,"Hello there",47)  // +W/G
�
�  Notes:
�  -------
�  Here mainly for compatibility with older version. Was
�  previously a C function.
�
�
�  Source:
�  -------
�  S_PRNT.PRG
� 
����������������������������������������������������������������� 
*/
function prnt(nRow,nColumn,cString,nAttribute)
local  cColor
if valtype(nAttribute)=="C"
   cColor := nAttribute
elseif valtype(nAttribute)=="N"
   cColor := at2char(nAttribute)
else
   cColor := setcolor()
endif
@nRow,nColumn say cString color cColor
return nil