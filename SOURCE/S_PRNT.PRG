/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PRNT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PRNT() Writes a string of a given color at row, column
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  PRNT(nRow, nColumn, cString, nColor)
ณ 
ณ  Description:
ณ  ------------
ณ  <nRow>       row
ณ
ณ  <nColumn>    column
ณ 
ณ  <cString>    string
ณ 
ณ  <nColor>     color attribute
ณ 
ณ  Examples:
ณ  ---------
ณ   PRNT(10,10,"Hello there",47)  // +W/G
ณ
ณ  Notes:
ณ  -------
ณ  Here mainly for compatibility with older version. Was
ณ  previously a C function.
ณ
ณ
ณ  Source:
ณ  -------
ณ  S_PRNT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
