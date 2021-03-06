/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION MFIELDS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  MFIELDS() Pops up a selection box for current dbf fields
³ 
³  Returns:
³  --------
³  <cFieldName> => field name or "" if none selected
³ 
³  Syntax:
³  -------
³  Mfields([cTitle],[nTop,nLeft,nBottom,nRight])
³ 
³  Description:
³  ------------
³  Popus up a box and presents an selection menu for the
³  current dbf fields.
³ 
³  [cTitle] is a title for the box.
³ 
³  [nTop...nRight]  are coordinates of the box. Default
³  is centered.
³ 
³  Examples:
³  ---------
³   cFieldname := MFIELDS()
³
³   // *or
³
³   cFieldname := MFIELDS("Pick a Field")
³
³   //*or
³
³   cFieldname := MFIELDS('Pick a Field',10,10,20,40)
³
³  Source:
³  -------
³  S_MFLD.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
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
