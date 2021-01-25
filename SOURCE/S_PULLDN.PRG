// slight behavior change - boxes are 1 character wider.

#INCLUDE "INKEY.CH"
#define   A_BOXTOPBAR     1
#define   A_TOPBARCOLOR   2
#define   A_MENUBOXCOLOR  3
#define   A_MENUBOXFRAME  4
#define   A_SHADOWPOS     5
#define   A_SHADOWATT     6
#define   A_MENUBARROW    7

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PULLDN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PULLDN() Pulldown menu creator, handler
ณ 
ณ  Returns:
ณ  --------
ณ  <nSelection> => Selection in the form menu.prompt
ณ  (i.e. 2.04)
ณ 
ณ  Syntax:
ณ  -------
ณ  PULLDN(nSelection,aOptions,[aAttributes],[aColumns])
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a pulldown menu with up to 8 separate boxes.
ณ  Selection process starts with <nSelection>.
ณ 
ณ  Each element of <aOptions> defines a menu.
ณ 
ณ  A menu definition is a delimited string in the form:
ณ 
ณ        "TITLE:prompt:prompt:prompt"
ณ 
ณ  with up to 99 prompts per string.
ณ 
ณ  When a selection is made, the number of the selection
ณ  is returned, in the form BOX.OPTION . So option 2 in box 3 would
ณ  come back as 3.02.
ณ 
ณ  [aAttributes] is a box definition array. It is 7
ณ  elements long and defines the following:
ณ 
ณ  Element:          1. <lDraw>      Draw top bar box? T/F
ณ                    2. <cBarColor>  Top bar color
ณ                    3. <cBoxColor>  Menu Box color
ณ                    4. <cBoxFrame>  Menu Box frame
ณ                    5. <nShadowPos> Menu Box shadow position
ณ                               (0,1,3,7,9)
ณ                    6. <nShadowAtt> Menu Box shadow attribute
ณ                    7. <nBarRow>    Row to start menu bar
ณ 
ณ  [aColumns] is an array of title column positions to
ณ  override the internal 'figerin algorithm.
ณ 
ณ  Examples:
ณ  ---------
ณ   aOptions := { "Datafiles:Use Datafile",;
ณ                 "Indices:Select Indices:Index order",;
ณ                 "Editing:Replacement:Tabular Edit",;
ณ                 "Reporting:Build Query:Print Lists",;
ณ                 "Other:List file:Change Directory",;
ณ                 "Quit" }
ณ 
ณ   aAttrib := { .t.,;               // draw the top bar box
ณ                'W/B,GR/R,,,W/N',;  // top bar color
ณ                'W/B,N/R,,,W/N',;   // drop box color
ณ                cSingle_frame,;     // drop box frame
ณ                3,;                 // drop box shadow position
ณ                8,;                 // drop box shadow  attribute
ณ                0 }                 // row # of menu bar
ณ 
ณ   nSel  := 1.01
ณ   do while .t.
ณ       nSel := PULLDN(nSel,aOptions,aAttrib)
ณ       do case
ณ       CASE nSel = 0  && TRAP 0
ณ           nSel = 1.01
ณ       case nSel = 1
ณ       case nSel = 2
ณ       case nSel = 3
ณ       case nSel = 4
ณ       endcase
ณ   enddo
ณ 
ณ  Warnings:
ณ  ----------
ณ  It takes some work to start all options and titles
ณ  with a first letter that is unique so that first letter selection may
ณ  take place.
ณ 
ณ  Notes:
ณ  -------
ณ  First letter selection takes place on the following
ณ  priority: next matching element first letter, next matching box
ณ  title first letter.
ณ 
ณ  Passing a menu array element with title only will
ณ  result in no menu box, with the title being the only selection
ณ  and returning a selection value of <MENU>.1.
ณ  (i.e. a 'Quit' box)
ณ 
ณ  Source:
ณ  -------
ณ  S_PULLDN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION pulldn(nSelection,acOptions,aAttributes,aColumns)
local aTitles       := {}
local aBoxOptions   := {}
local aColumnPos    := {}
local i
local cOldColor,cTopLine,nOldCursor
local cTitleTrigs,nSepSpace,nTitleLine,nLastBox,nCurrBox,nStartElement
local nBoxLen,nBoxRows,nLenTitle
local nBoxLeft,nBoxRight,nBoxTop,nBoxBottom
local cThisBox
local nLastKey,nReturn
local lMainDone := .f.
local nMouseR, nMouseC, nMouseTop

nSelection := MAX(1.01,nSelection)

cTitleTrigs := parsearrays(acOptions,aTitles,aBoxOptions)

IF VALTYPE(aAttributes) <> "A"
  aAttributes := array(7)
  aAttributes[A_BOXTOPBAR   ] := .T.
  aAttributes[A_TOPBARCOLOR ] := Setcolor()
  aAttributes[A_MENUBOXCOLOR] := Setcolor()
  aAttributes[A_MENUBOXFRAME] := sls_frame()
  aAttributes[A_SHADOWPOS   ] := 0
  aAttributes[A_SHADOWATT   ] := 0
  aAttributes[A_MENUBARROW  ] := 0
ENDIF


cOldColor := Setcolor(aAttributes[A_TOPBARCOLOR])
cTopLine := Savescreen(aAttributes[A_MENUBARROW],0,;
           aAttributes[A_MENUBARROW]+2,79)

IF aAttributes[A_BOXTOPBAR]
  DISPBOX(aAttributes[A_MENUBARROW],0,aAttributes[A_MENUBARROW]+2,79,;
               aAttributes[A_MENUBOXFRAME])
ENDIF

*- get menu aTitles,positions
nLenTitle := 0
for i = 1 TO LEN(aTitles)
  nLenTitle  += LEN(aTitles[i])
NEXT

nSepSpace  := INT((77-nLenTitle)/(LEN(acOptions)+1))

nTitleLine := IIF(aAttributes[A_BOXTOPBAR],aAttributes[A_MENUBARROW]+1,;
              aAttributes[A_MENUBARROW])

IF aColumns ==nil
  aColumns := array(len(aTitles))
  aColumns[1] :=nSepSpace+1
  @nTitleLine,aColumns[1] say aTitles[1]
  FOR i = 2 TO LEN(acOptions)
    aColumns[i] = aColumns[i-1]+LEN(aTitles[i-1])+nSepSpace
    @nTitleLine,aColumns[i] SAY aTitles[i]
  NEXT
ELSE
  FOR i = 1 TO LEN(acOptions)
    @nTitleLine,aColumns[i] say aTitles[i]
  NEXT
ENDIF


*- init last menu #, current menu # , and starting element
nLastBox        := LEN(acOptions)
nCurrBox        := MAX(INT(nSelection),1)
nStartElement   := ROUND(MAX((nSelection-nCurrBox)*100,1),0)

Setcolor(aAttributes[A_MENUBOXCOLOR])
*- main loop
nOldCursor = setcursor(0)
WHILE !lMainDone
  nBoxLen    := bigelem(aBoxOptions[nCurrBox])
  nBoxRows   := len(aBoxOptions[nCurrBox])
  // nBoxRows   := MIN(20,len(aBoxOptions[nCurrBox]) )  // old

  nBoxLeft   := aColumns[nCurrBox]
  nBoxLeft   := nBoxLeft-(MAX(nBoxLeft+nBoxLen-76,0))
  nBoxRight  := nBoxLeft+nBoxLen+3
  nBoxTop    := nTitleLine+1
  nBoxBottom := nBoxTop + nBoxRows+1
  
  *- save the screen
  cThisBox = Savescreen(nBoxTop-1,nBoxLeft-1,nBoxBottom+1,nBoxRight+1)

  *- hilite the first letter of the menu title
  IF aAttributes[A_TOPBARCOLOR]==aAttributes[A_MENUBOXCOLOR]
    @nTitleLine,aColumns[nCurrBox] say left(aTitles[nCurrBox],1) color "+W/N"
  ELSE
    @nTitleLine,aColumns[nCurrBox] say left(aTitles[nCurrBox],1)
  ENDIF

  *- draw the menu box
  IF nBoxRows > 0
    bxx(nBoxTop,nBoxLeft,nBoxBottom,nBoxRight,SETCOLOR(),;
       aAttributes[A_SHADOWPOS],aAttributes[A_SHADOWATT],;
       aAttributes[A_MENUBOXFRAME])
    
       nLastKey := BRZARRAY(aBoxOptions[nCurrBox],;
                   nBoxTop+1,nBoxLeft+1,nBoxBottom-1,nBoxRight-1,;
                   nStartElement,cTitleTrigs,nTitleLine, aColumns, aTitles)
    
  ELSE
       nLastKey := rat_event(0)
       nMouseR := rat_eqmrow()
       nMouseC := rat_eqmcol()
       if nLastKey==13 .or. upper(chr(nLastKey))==subst(cTitleTrigs,nCurrBox,1)
         nLAstKey := 1010
       elseif upper(chr(nLastKey))$cTitleTrigs
         nLastKey := 2000+at(upper(chr(nLastkey)),cTitleTrigs)
       elseif (nMouseTop := ;
            MouseOnTop(nTitleLine,aColumns,aTitles,nMouseR,nMouseC) ) > 0
         if nMouseTop == nCurrBox
           nLastKey := 1010
         else
           nLastKey := 2000 + nMouseTop
         endif
       endif
  ENDIF
  *- restore the screen and colors
  Restscreen(nBoxTop-1,nBoxLeft-1,nBoxBottom+1,nBoxRight+1,cThisBox)
  
  *- if a selection was made, return the menu and option in the form menu.option
  do case
  case nLastKey==K_LEFT
     nCurrBox := iif(nCurrBox=1,len(aTitles),nCurrBox-1)
     nStartElement := 1
  case nLastKey==K_RIGHT
     nCurrBox := iif(nCurrBox=len(aTitles),1,nCurrBox+1)
     nStartElement := 1
  case nLastKey > 2000   // a title key
     nCurrBox := nLastKey-2000
     nStartElement := 1
  case nLastKey > 1000    // an element selected
     nLastKey -=1000
     nReturn    := nCurrBox+(nLastKey/100)
     lMainDone := .t.
  case nLastKey==K_ESC
     nReturn := 0
     lMainDone := .t.
  endcase

ENDDO
*- clean up, return value
Restscreen(aAttributes[A_MENUBARROW],0,;
           aAttributes[A_MENUBARROW]+2,79,cTopLine)
Setcolor(cOldColor)
SETCURSOR (nOldCursor)
RETURN nReturn


//--------------------------------------------------------------
STATIC FUNCTION BRZARRAY(aArray,nTop,nLeft,nBott,nright,;
                nStart,cTitleTrigs,nTitleTop, aColumns, aTitles)
LOCAL cTagScreen
LOCAL oBrowse
LOCAL nElement := 1
local nLastKey,cLastKey, nMouseR, nMouseC, nMouseTop, nMouseBox
local nWidth := nRight-nLeft-1
local nFound
local ldone  := .f.
local bKeyBlock
oBrowse := TBROWSENEW(ntop,nLeft,nBott,nright)
oBrowse:colsep := ""

*- ADD THE TBCOLUMNS
oBrowse:ADDCOLUMN(tbColumnNew(nil,{||padr(aArray[nElement],nWidth)} ))
oBrowse:skipblock  := {|n|aaskip(n,@nElement,LEN(aArray))}
oBrowse:gotopblock := {||agotop(nElement,oBrowse)}
oBrowse:gobottomblock := {||agobot(nElement,LEN(aArray),oBrowse)}

if nStart>1
  agoto(nStart,nElement,oBrowse)
endif
WHILE !lDone
   WHILE !oBrowse:STABILIZE()
   END
   nLastKey := rat_event(0)
   nMouseR := rat_eqmrow()
   nMouseC := rat_eqmcol()
   do case
   CASE nLastKey = K_UP
    if nElement>1         && UP ONE ROW
     oBrowse:UP()
    else
     oBrowse:GOBOTTOM()
    endif
   CASE nLastKey = K_PGUP        && UP ONE PAGE
     oBrowse:PAGEUP()
   CASE nLastKey = K_HOME        && HOME
     oBrowse:GOTOP()
   CASE nLastKey = K_DOWN        && DOWN ONE ROW
     if nElement <len(aArray)
       oBrowse:DOWN()
     else
       oBrowse:GOTOP()
     endif
   CASE nLastKey = K_PGDN        && DOWN ONE PAGE
     oBrowse:PAGEdOWN()
   CASE nLastKey = K_END         && END
     oBrowse:GOBOTTOM()
   case (cLastKey:=upper(chr(nLastKey)))$"ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890"
        nFound := ASCAN(aArray,{|e|upper(LEFT(e,1))==cLastKey},nElement)
        if nFound==0 .and. nElement > 1
          nFound := ASCAN(aArray,{|e|upper(LEFT(e,1))==cLastKey})
        endif
        if nFound > 0
          agoto(nFound,nElement,oBrowse)
          nLastKey := nFound+1000
          lDone := .t.
        elseif cLastkey$cTitleTrigs
          nLastKey := 2000+at(cLastKey,cTitleTrigs)
          lDone := .t.
        endif
   case nLastKey = K_ENTER
          nLastKey := nElement+1000
          lDone := .t.
   case nLastKey = K_LEFT .or. nLastKey = K_RIGHT .or. nLastKey = K_ESC
          lDone := .t.
          EXIT
   case  ( (bKeyBlock := SetKey(nLastKey)) <> NIL )
         Eval(bKeyBlock, "PULLDN", nil, aArray[nElement])

   case (nMouseTop := ;
            MouseOnTop(nTitleTop,aColumns,aTitles,nMouseR,nMouseC) ) > 0
         nLastKey := 2000+nMouseTop
         lDone := .t.
   case (nMouseBox := ;
            MiceInBox(ntop,nLeft,nBott,nright,nMouseR,nMouseC) ) > 0
         agoto(nMouseBox,nElement,oBrowse)
         nLastKey := nMouseBox+1000
         lDone := .t.
   endcase
ENDDO
return nLastKey

//-----------------------------------------------
static proc agoTop(nElement,oBrz)
local nTemp := nElement
while nTemp > 1
  oBrz:up()
  nTemp--
end
return
//-----------------------------------------------
static proc agoBot(nElement,nLen,oBrz)
local nTemp := nElement
while nTemp < nLen
  oBrz:down()
  nTemp++
end
while !oBrz:stabilize()
end
return

//===============================================================
static function agoto(nNew,nCurrent,oBrowz)
local nIter
local nDiff := ABS(nNew-nCurrent)
if nNew > nCurrent
  for nIter := 1 to nDiff
    oBrowz:down()
    while !oBrowz:stabilize()
    end
  next
else
  for nIter := 1 to nDiff
    oBrowz:up()
    while !oBrowz:stabilize()
    end
  next
endif
return nil

//===============================================================
static function parsearrays(aInDef,aTitles,aBoxes)
local aAll,cPreMacro
local i
local cTFirst := ""
for i = 1 to len(aInDef)
  cPreMacro := "["+strtran(aIndef[i],":","],[")+"]"
  aAll      := &( "{"+cPreMacro+"}" )
  aadd(aTitles,aAll[1])
  cTFirst += left(aTitles[i],1)
  adel(aAll,1)
  asize(aAll,len(aAll)-1)
  aadd(aBoxes,aAll)
next
return ( cTFirst )


static function MouseOnTop(nTop,aColumns,aTitles,nMRow,nMCol)
local i, nIntitle
nIntitle := 0
if nMRow==nTop
  FOR i = 1 TO LEN(aTitles)
    if nMCol >=aColumns[i] .and. nMCol <= (aColumns[i]+len(aTitles[i])-1)
      nInTitle := i
      exit
    endif
  NEXT
endif
return nInTitle


static function MiceInBox(nTop,nLeft,nBottom,nRight,nMRow,nMCol)
local i, nInBox
nInBox := 0
if nMRow>= nTop .and. nMRow <= nBottom
  if nMCol>= nLeft .and. nMCol <= nRight
    nInBox := (nMRow-nTop)+1
  endif
endif
return nInBox


