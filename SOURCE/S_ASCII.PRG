/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ASCIITABLE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ASCIITABLE() Pops up an ASCII table for character selection
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <nChar> => ascii value of character selected
ณ 
ณ  Syntax:
ณ  -------
ณ  ASCIITABLE([bAction],[cTitle],[nStart])
ณ 
ณ  Description:
ณ  ------------
ณ  This is a popup ASCII table, allowing selection of an
ณ  ASCII character [bAction] optional codeblock which will be
ณ  eval'd and passed the character if a character is selected. i.e.
ณ  eval(codeblock,chr(nChar))
ณ 
ณ  [cTitle] is an optional box title. Default is none.
ณ 
ณ  [nStart] is an optional starting ASCII number.
ณ  Default is 1.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF ( nChar := ASCIITABLE() ) > 0
ณ     cChar := chr(nChar)
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_ASCII.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function asciitable(bAction,cTitle,nStart)
local nRow := row(),nCol := col()
local nTop    := 0
local nLeft   := 0
local nBottom := 16
local nRight  := 65
local aGrid := grid()
local nChar := 0

sbcenter(@nTop,@nLeft,@nBottom,@nRight)

nChar := PSTABMENU(nTop,nLeft,nBottom,nRight,aGrid,cTitle,nStart)
devpos(nRow,nCol)
if nChar > 0
  if bAction#nil
    eval(bAction,chr(nChar))
  endif
endif
return nChar

//--------------------------------------------------------------

static function grid
local aGrid := array(255)
local iCount
for iCount := 1 to 255
   aGrid[iCount] := chr(iCount)
next
return  aGrid

