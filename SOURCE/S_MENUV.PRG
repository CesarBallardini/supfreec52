/*
�����������������������������������������������������������������
� FUNCTION MENU_V()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  MENU_V() Vertical popup menu from variable # parameters
� 
�  Returns:
�  --------
�  <nSelection> => selection - 0 for no selection
� 
�  Syntax:
�  -------
�  MENU_V(cTitle,cOption1,[cOption2,...cOption16])
� 
�  Description:
�  ------------
�  Creates a popup vertical menu in a centered box,
�  using <cTitle> as the title, and performing a menu to on
�  <cOption1...cOption16> (variable #)
� 
�  <cTitle> may be passed as "" for no title.
� 
�  [cOption2..cOption16] are optional
� 
�  Examples:
�  ---------
�   nChoice :=  menu_v("Selection","Edit","Add","Quit")
� 
�       -or-
� 
�   nChoice :=  menu_v("","Edit","Add","Quit")
� 
�  Source:
�  -------
�  S_MENUV.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION menu_v(cTitle,cOption1,cOption2,cOption3,cOption4,cOption5,;
                cOption6,cOption7,cOption8,cOption9,cOption10,cOption11,;
                cOption12,cOption13,cOption14,cOption15 )

local nTop,nLeft,nBottom,nright,nSelection,nOptionCount
local cUnderScreen,nLongest
local nIterator,nOldCursor
local aOptions := {cOption1,cOption2,cOption3,cOption4,cOption5,;
                cOption6,cOption7,cOption8,cOption9,cOption10,cOption11,;
                cOption12,cOption13,cOption14,cOption15 }
local aPrompts := {}

nOldCursor := setcursor(0)

*- how many nOptionCount - maximum 15
nOptionCount := pcount()-1
nOptionCount := MIN(nOptionCount,15)
asize(aOptions,nOptionCount)

nLongest := LEN(cTitle)
FOR nIterator = 1 TO nOptionCount
  nLongest = MAX(nLongest,LEN(aOptions[nIterator]) )
NEXT

*figure out the box dimensions  and draw the box
nTop      := 5
nBottom   := 7+nOptionCount
nLeft     := INT((79-nLongest)/2 - 1)
nright    := max(nLeft+15,nLeft+nLongest+2)
SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
cUnderScreen :=makebox(nTop,nLeft,nBottom,nRight,sls_popcol())
@nTop,nLeft+1 SAY cTitle color sls_popcol()
@nBottom,nLeft+1 say "[ESC=Cancel]"

*- loop through and @prompt the nOptionCount
FOR nIterator = 1 TO nOptionCount
    aadd(aPrompts,{nTop+nIterator,nLeft+2,aOptions[nIterator]})
NEXT

*- get the selection
nSelection := RAT_MENU2(aPrompts,1,.t.,;
    {|r,c|iif(r==nBottom.and.c>=nLeft+1.and.c<=nLeft+12,KBDESC(),NIL)})

*- hit the road, jack
unbox(cUnderScreen)

*- set cursor back
SETCURSOR(nOldCursor)
RETURN nSelection

