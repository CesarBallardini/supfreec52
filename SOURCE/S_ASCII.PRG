/*
�����������������������������������������������������������������
� FUNCTION ASCIITABLE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ASCIITABLE() Pops up an ASCII table for character selection
� 
� 
�  Returns:
�  --------
�  <nChar> => ascii value of character selected
� 
�  Syntax:
�  -------
�  ASCIITABLE([bAction],[cTitle],[nStart])
� 
�  Description:
�  ------------
�  This is a popup ASCII table, allowing selection of an
�  ASCII character [bAction] optional codeblock which will be
�  eval'd and passed the character if a character is selected. i.e.
�  eval(codeblock,chr(nChar))
� 
�  [cTitle] is an optional box title. Default is none.
� 
�  [nStart] is an optional starting ASCII number.
�  Default is 1.
� 
�  Examples:
�  ---------
�   IF ( nChar := ASCIITABLE() ) > 0
�     cChar := chr(nChar)
�   ENDIF
� 
�  Source:
�  -------
�  S_ASCII.PRG
� 
����������������������������������������������������������������� 
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
