/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION MFIELDSTYPE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  MFIELDSTYPE() Pops up a list of fields of given type(s)
³ 
³  Returns:
³  --------
³  <cFieldName> => name of selected field
³ 
³  Syntax:
³  -------
³  MFIELDSTYPE(cType,[cTitle],[nTop,nLeft,nBottom,nRight])
³ 
³  Description:
³  ------------
³  <cType> is a string containing 1 or more field TYPE
³  symbols:
³
³       C   Character
³       N   Numeric
³       D   Date
³       L   Logical
³       M   Memo
³ 
³  Only fields of this type(s) are presented for the
³  picklist. If no fields of this type(s) are present, a "" is returned.
³ 
³  [cTitle] is a string placed at the top of the popup
³  box for a title
³ 
³  [nTop,nLeft,nBottom,nRight] are the coordinates of
³  the box
³ 
³  Examples:
³  ---------
³   // this selects memo field to edit
³
³   use customer
³ 
³   cField := mfieldstype("M")
³ 
³   if !empty(cField)
³      memoedit(FIELDGET(FIELDPOS(cField)),0,0,24,79)
³   endif
³ 
³  Source:
³  -------
³  S_MFLDT.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
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
