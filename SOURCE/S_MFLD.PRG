/*
�����������������������������������������������������������������
� FUNCTION MFIELDS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  MFIELDS() Pops up a selection box for current dbf fields
� 
�  Returns:
�  --------
�  <cFieldName> => field name or "" if none selected
� 
�  Syntax:
�  -------
�  Mfields([cTitle],[nTop,nLeft,nBottom,nRight])
� 
�  Description:
�  ------------
�  Popus up a box and presents an selection menu for the
�  current dbf fields.
� 
�  [cTitle] is a title for the box.
� 
�  [nTop...nRight]  are coordinates of the box. Default
�  is centered.
� 
�  Examples:
�  ---------
�   cFieldname := MFIELDS()
�
�   // *or
�
�   cFieldname := MFIELDS("Pick a Field")
�
�   //*or
�
�   cFieldname := MFIELDS('Pick a Field',10,10,20,40)
�
�  Source:
�  -------
�  S_MFLD.PRG
�
�����������������������������������������������������������������
*/
FUNCTION mfields(cTitle,nTop,nLeft,nBottom,nRight)
local nSelection,cFieldName
local aFieldList

*- if no DBf, we're gone
IF !used()
  RETURN ''
ENDIF

aFieldList := AFIELDSX(aFieldList)
cTitle     := iif(cTitle#nil,cTitle,"")

nSelection := MCHOICE(aFieldList,nTop,nLeft,nBottom,nRight,cTitle)

*- was a field selected?
cFieldName  = IIF(nSelection > 0, aFieldList[nSelection],'')

*- return the selection
RETURN cFieldName