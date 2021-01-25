/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MFIELDS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MFIELDS() Pops up a selection box for current dbf fields
ณ 
ณ  Returns:
ณ  --------
ณ  <cFieldName> => field name or "" if none selected
ณ 
ณ  Syntax:
ณ  -------
ณ  Mfields([cTitle],[nTop,nLeft,nBottom,nRight])
ณ 
ณ  Description:
ณ  ------------
ณ  Popus up a box and presents an selection menu for the
ณ  current dbf fields.
ณ 
ณ  [cTitle] is a title for the box.
ณ 
ณ  [nTop...nRight]  are coordinates of the box. Default
ณ  is centered.
ณ 
ณ  Examples:
ณ  ---------
ณ   cFieldname := MFIELDS()
ณ
ณ   // *or
ณ
ณ   cFieldname := MFIELDS("Pick a Field")
ณ
ณ   //*or
ณ
ณ   cFieldname := MFIELDS('Pick a Field',10,10,20,40)
ณ
ณ  Source:
ณ  -------
ณ  S_MFLD.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
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
