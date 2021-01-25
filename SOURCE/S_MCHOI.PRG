
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MCHOICE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MCHOICE() Does a boxed, achoice() style popup on an array
ณ 
ณ  Returns:
ณ  --------
ณ  <expN> Achoice selection
ณ 
ณ  Syntax:
ณ  -------
ณ  MCHOICE(aOptions,[nTop,nLeft],[nBottom,nRight],[cTitle],[lTrigger],;
ณ                   [nStart],[@nRow],[aSelectable])
ณ 
ณ  Description:
ณ  ------------
ณ  Provides a box for selection from array <aOptions> of
ณ  character elements.
ณ 
ณ  [nTop,nLeft] may be specifed to determine the
ณ  starting top and left of the popup box.
ณ 
ณ  [nBottom,nRight] may be specified to complete the box
ณ  dimensions.
ณ 
ณ  Default box dimensions are centered on the screen. If the dimensions
ณ  passed are not wide enough to display the mouse hot areas on the
ณ  bottom, the box is widened and centered on the screen.
ณ 
ณ  [cTitle] is a string to display at the top of the box.
ณ 
ณ  [lTrigger] determines (yes or no) whether a return is
ณ  to be executed on a first letter match.(default .f.)
ณ 
ณ  [nStart] optional starting element (default 1)
ณ  [@nRow] optional starting row. Pass by reference to retain value
ณ  between calls.
ณ 
ณ  [aSelectable] is an array of logicals that determines which items
ณ  are selectable. This array must be the same size as [aOptions], and
ณ  all elements must be either True or False, not NIL. Where an element
ณ  is False, the corresponding element in [aOptions] will be dimmed
ณ  and will emit a BEEP when you attempt to select it.
ณ
ณ  Examples:
ณ  ---------
ณ   aMeals   := {"Pizza","Chicken","Chinese"}
ณ   nSelect  := mchoice(aMeals)
ณ 
ณ   // or box with title
ณ   aMeals   := {"Pizza","Chicken","Chinese"}
ณ   nSelect  := mchoice(aMeals,,,,"Meals")
ณ 
ณ   // or box with title, first letter match = return and top/left specified
ณ   aMeals   := {"Pizza","Chicken","Chinese"}
ณ   nSelect  := mchoice(aMeals,10,10,,,"Meals",.t.)
ณ 
ณ   //to retain element and position between calls
ณ   nSelect := 1
ณ   nRow    := 1
ณ   aMeals   := {"Pizza","Chicken","Chinese"}
ณ   while nSelect > 0
ณ     nSelect  := mchoice(aMeals,,,,,"Meals",.t.,nSelect,@nRow)
ณ     // code
ณ   endif
ณ 
ณ 
ณ  Notes:
ณ  -------
ณ  Bottom of window adjusts (shrinks) to adjust to array
ณ  size if needed.
ณ 
ณ  Now uses Tbrowse() instead of ACHOICE().
ณ 
ณ  Source:
ณ  -------
ณ  S_MCHOI.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION mchoice(aOptions,nTop,nLeft,nBottom,nRight,cTitle,lAlpha,nStart,nRow,aSelectable)

LOCAL lAlphaSelects, cFirstLetters
LOCAL nIterator,nArrayLength
LOCAL cUnderScreen,nOldCursor
local nLastKey,cLastKey,nFound
local nElement := 1
local oTb, nMouseR, nMouseC

*- set cursor off
nOldCursor   := setcursor(0)
nArrayLength := aleng(aOptions)
mc_dodim(@nTop,@nLeft,@nBottom,@nRight,aOptions)

if aSelectable==nil
        aSelectable := ARRAY(len(aOptions))
        AFILL(aSelectable,.t.)
endif

if valtype(cTitle)=="C"
    if len(cTitle) > ((nRight-nLeft)-1)
        cTitle = left(cTitle,nRight-nLeft-1)
    endif
endif

IF nArrayLength> 0
  cFirstLetters := ''
  FOR nIterator = 1 TO nArrayLength
    cFirstLetters += UPPER(LEFT(aOptions[nIterator],1))
  NEXT
  
  lAlphaSelects := iif(lAlpha#nil,lAlpha,.f.)
  
  *- figure out the box dimensions and draw it
  nBottom       := MIN(nBottom,nArrayLength+nTop+1)
  cUnderScreen  :=makebox(nTop,nLeft,nBottom,nRight,sls_popcol())
  @nTop,nLeft+1 SAY IIF(cTitle#nil,cTitle,'')
  if sls_ismouse()
      devpos(nBottom,nright - 33)
      devout("[][] [ENTER=OK] [ESC=Cancel]")
  endif
  oTb:= tBrowseNew(nTop+1,nLeft+1,nBottom-1,nRight-1)
  oTb:addcolumn(tbcolumnNew(nil,{||aOptions[nElement]}))
  oTb:getcolumn(1):width := sbcols(nLeft,nRight,.f.)
  oTb:Skipblock  := {|n|aaskip(n,@nElement,len(aOptions))}
  oTb:goTopBlock := {||nElement := 1}
  oTb:goBottomBlock := {||nElement := len(aOptions)}

  *: here set up the color handling - unselectable items are drawn
  *: as dimmed
  oTb:colorspec := setcolor()+","+"+N/"+takeout(takeout(Setcolor(),",",1) ,"/",2) +",+N/"+takeout(takeout(Setcolor(),",",2) ,"/",2)
  oTb:getcolumn(1):colorblock := {||iif(aSelectable[nElement],{1,2},{6,7})}

 if nStart#nil .and. nStart <= len(aOptions)
   if nRow#nil
     oTb:RowPos := nRow
     nElement := nStart
     oTb:configure()
   else
     mc_goto(nStart,nElement,oTb)
   endif
 endif

  while .t.
    while !oTb:stabilize()
    end
    nLastKey := rat_event(0)
    nMouseR := rat_eqmrow()
    nMouseC := rat_eqmcol()
    do case
    CASE nLastKey = K_UP          && UP ONE ROW
      if nElement > 1
        oTb:UP()
      else
        oTb:gobottom()
      endif
    CASE nLastKey = K_DOWN        && DOWN ONE ROW
      if nElement < len(aOptions)
        oTb:DOWN()
      else
        oTb:gotop()
      endif
    CASE nLastKey = K_PGUP        && UP ONE PAGE
      oTb:PAGEUP()
    CASE nLastKey = K_HOME        && HOME
      oTb:GOTOP()
    CASE nLastKey = K_PGDN        && DOWN ONE PAGE
      oTb:PAGEdOWN()
    CASE nLastKey = K_END         && END
      oTb:GOBOTTOM()
    CASE nLastKey = K_ENTER       && ENTER
      *: Just make sure its selectable
      if aSelectable[nElement]
         exit
      else
         tone(300,1)
         tone(600,1)
         tone(300,1)
      endif
    CASE nLastKey = K_ESC
      nElement := 0
      EXIT
    case (cLastKey:=upper(chr(nLastkey)))$cFirstLetters
        IF cLastkey==upper(left(aOptions[nElement],1)) .and. lAlphaSelects
           *: Just make sure its selectable
           if aSelectable[nElement]
              exit
           else
              tone(300,1)
              tone(600,1)
              tone(300,1)
           endif
        else
          nFound := at(cLastKey,subst(cFirstLetters,nElement+1))
          nFound := iif(nFound> 0,nFound+nElement,nFound)
          if nFound==0 .and. nElement > 1
            nFound := at(cLastKey,cFirstLetters)
          endif
          if nFound > 0
            if nFound<>nElement
              mc_goto(nFound,nElement,oTb)
            endif
            if lAlphaSelects
               *: Just make sure its selectable
               if aSelectable[nElement]
                  exit
               else
                  tone(300,1)
                  tone(600,1)
                  tone(300,1)
               endif
            endif
          endif
        endif
    case nLastKey == K_MOUSELEFT
          do case
          case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-33, nBottom, nRight-31)
             oTb:up()
             IFMOUSEHD({||oTb:up()},oTb)
          case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-30, nBottom, nRight-28)
             oTb:down()
             IFMOUSEHD({||oTb:down()},oTb)
          case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-26, nBottom, nRight-17)
             keyboard chr(K_ENTER)
          case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-15, nBottom, nRight-4)
             keyboard chr(K_ESC)
          case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
             keyboard chr(K_ENTER)
          case MBRZCLICK(oTb,nMouseR, nMouseC)
             *: Just make sure its selectable
             if aSelectable[nElement]
                exit
             else
                tone(300,1)
                tone(600,1)
                tone(300,1)
             endif
          endcase
    endcase
  end
  unbox(cUnderScreen)
  nRow := oTb:rowpos
else
   nElement := 0
ENDIF
SETCURSOR(nOldCursor)
RETURN nElement

//===============================================================
static function mc_goto(nNew,nCurrent,oTb)
local nIter
local nDiff := ABS(nNew-nCurrent)
dispbegin()
if nNew > nCurrent
  for nIter := 1 to nDiff
    oTb:down()
    while !oTb:stabilize()
    end
  next
else
  for nIter := 1 to nDiff
    oTb:up()
    while !oTb:stabilize()
    end
  next
endif
dispend()
return nil


//--------------------------------------------------------------
static function findbigest(aItems)
local aBiggest := 0
local i
for i = 1 to len(aItems)
  aBiggest := max(aBiggest,len(trans(aItems[i],"")))
next
return aBiggest


//--------------------------------------------------------------
static function mc_dodim(nTop,nLeft,nBottom,nRight,aItems)
local nLongest := findbigest(aItems)
if nTop==nil.or.nLeft==Nil
  nTop     := 0
  nLeft    := 0
  nBottom  := min(len(aItems)+2,maxrow())
  nRight   := min(nLongest+2,maxcol())
  sbcenter(@nTop,@nLeft,@nBottom,@nRight)
elseif nBottom==nil .or. nRight==nil
  nBottom  := min(nTop+len(aItems)+2,maxrow())
  nRight   := min(nLeft+nLongest+2,maxcol())
endif
if sls_ismouse() .and. (nRight-nLeft-1)<34
  nRight := nLeft+34
  nLongest := 34
  sbcenter(@nTop,@nLeft,@nBottom,@nRight)
endif
nBottom    := min(nBottom,nTop+len(aItems)+2)
return nil




