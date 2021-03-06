/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ASCIITABLE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ASCIITABLE() Pops up an ASCII table for character selection
³ 
³ 
³  Returns:
³  --------
³  <nChar> => ascii value of character selected
³ 
³  Syntax:
³  -------
³  ASCIITABLE([bAction],[cTitle],[nStart])
³ 
³  Description:
³  ------------
³  This is a popup ASCII table, allowing selection of an
³  ASCII character [bAction] optional codeblock which will be
³  eval'd and passed the character if a character is selected. i.e.
³  eval(codeblock,chr(nChar))
³ 
³  [cTitle] is an optional box title. Default is none.
³ 
³  [nStart] is an optional starting ASCII number.
³  Default is 1.
³ 
³  Examples:
³  ---------
³   IF ( nChar := ASCIITABLE() ) > 0
³     cChar := chr(nChar)
³   ENDIF
³ 
³  Source:
³  -------
³  S_ASCII.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

