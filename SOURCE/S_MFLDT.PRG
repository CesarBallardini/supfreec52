/*
�����������������������������������������������������������������
� FUNCTION MFIELDSTYPE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  MFIELDSTYPE() Pops up a list of fields of given type(s)
� 
�  Returns:
�  --------
�  <cFieldName> => name of selected field
� 
�  Syntax:
�  -------
�  MFIELDSTYPE(cType,[cTitle],[nTop,nLeft,nBottom,nRight])
� 
�  Description:
�  ------------
�  <cType> is a string containing 1 or more field TYPE
�  symbols:
�
�       C   Character
�       N   Numeric
�       D   Date
�       L   Logical
�       M   Memo
� 
�  Only fields of this type(s) are presented for the
�  picklist. If no fields of this type(s) are present, a "" is returned.
� 
�  [cTitle] is a string placed at the top of the popup
�  box for a title
� 
�  [nTop,nLeft,nBottom,nRight] are the coordinates of
�  the box
� 
�  Examples:
�  ---------
�   // this selects memo field to edit
�
�   use customer
� 
�   cField := mfieldstype("M")
� 
�   if !empty(cField)
�      memoedit(FIELDGET(FIELDPOS(cField)),0,0,24,79)
�   endif
� 
�  Source:
�  -------
�  S_MFLDT.PRG
�
�����������������������������������������������������������������
*/
FUNCTION mfieldsType(cType,cTitle,nTop,nLeft,nBottom,nRight)
local  nSelection,cFieldName
local aFieldList  := aFieldsType(cType)

IF !used() .or. len(aFieldList)=0
  RETURN ''
ENDIF
cTitle := iif(cTitle#nil,cTitle,"")

nSelection := MCHOICE(aFieldList,nTop,nLeft,nBottom,nRight,cTitle)
cFieldName  := IIF(nSelection > 0, aFieldList[nSelection],'')
RETURN cFieldName