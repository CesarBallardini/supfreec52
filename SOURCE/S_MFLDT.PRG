/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MFIELDSTYPE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MFIELDSTYPE() Pops up a list of fields of given type(s)
ณ 
ณ  Returns:
ณ  --------
ณ  <cFieldName> => name of selected field
ณ 
ณ  Syntax:
ณ  -------
ณ  MFIELDSTYPE(cType,[cTitle],[nTop,nLeft,nBottom,nRight])
ณ 
ณ  Description:
ณ  ------------
ณ  <cType> is a string containing 1 or more field TYPE
ณ  symbols:
ณ
ณ       C   Character
ณ       N   Numeric
ณ       D   Date
ณ       L   Logical
ณ       M   Memo
ณ 
ณ  Only fields of this type(s) are presented for the
ณ  picklist. If no fields of this type(s) are present, a "" is returned.
ณ 
ณ  [cTitle] is a string placed at the top of the popup
ณ  box for a title
ณ 
ณ  [nTop,nLeft,nBottom,nRight] are the coordinates of
ณ  the box
ณ 
ณ  Examples:
ณ  ---------
ณ   // this selects memo field to edit
ณ
ณ   use customer
ณ 
ณ   cField := mfieldstype("M")
ณ 
ณ   if !empty(cField)
ณ      memoedit(FIELDGET(FIELDPOS(cField)),0,0,24,79)
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_MFLDT.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
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
