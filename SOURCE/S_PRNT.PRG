/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PRNT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PRNT() Writes a string of a given color at row, column
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  PRNT(nRow, nColumn, cString, nColor)
³ 
³  Description:
³  ------------
³  <nRow>       row
³
³  <nColumn>    column
³ 
³  <cString>    string
³ 
³  <nColor>     color attribute
³ 
³  Examples:
³  ---------
³   PRNT(10,10,"Hello there",47)  // +W/G
³
³  Notes:
³  -------
³  Here mainly for compatibility with older version. Was
³  previously a C function.
³
³
³  Source:
³  -------
³  S_PRNT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
