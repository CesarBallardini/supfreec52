/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION MENU_V()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  MENU_V() Vertical popup menu from variable # parameters
³ 
³  Returns:
³  --------
³  <nSelection> => selection - 0 for no selection
³ 
³  Syntax:
³  -------
³  MENU_V(cTitle,cOption1,[cOption2,...cOption16])
³ 
³  Description:
³  ------------
³  Creates a popup vertical menu in a centered box,
³  using <cTitle> as the title, and performing a menu to on
³  <cOption1...cOption16> (variable #)
³ 
³  <cTitle> may be passed as "" for no title.
³ 
³  [cOption2..cOption16] are optional
³ 
³  Examples:
³  ---------
³   nChoice :=  menu_v("Selection","Edit","Add","Quit")
³ 
³       -or-
³ 
³   nChoice :=  menu_v("","Edit","Add","Quit")
³ 
³  Source:
³  -------
³  S_MENUV.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


