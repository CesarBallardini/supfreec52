#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SACHOICE()                          *changed*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SACHOICE() Achoice replacement, uses TBROWSE, codeblock
³ 
³  Returns:
³  --------
³  <nSelection> => selection, 0 if none
³ 
³  Syntax:
³  -------
³  SACHOICE(nTop,nLeft,nBottom,nRight,aOptions,[bKeyBlock],[nStart],[@nRow],;
³           [nMRow, nMCol],[bMouse])
³ 
³  Description:
³  ------------
³  This semi-replaces ACHOICE() by using TBROWSE
³  instead, and by accepting an exception codeblock instead of a user
³  defined function.
³ 
³  <nTop,nLeft,nBottom,nRight> are the dimensions.
³ 
³  <aOptions> is the array. It need not be of type
³  Character.
³ 
³  First-letter presses go to the next matching letter
³  of the next character-type element.
³  Up/down/home/end/pageup/pagedown are used to position the
³  cursor. ENTER returns the current selection. Escape returns 0.
³ 
³  The screen is not saved and restored. This is a
³  building block function, like ACHOICE(), so save and restore the
³  screen, draw a box around it, etc, as you would ACHOICE().
³ 
³  [bKeyBlock] a codeblock which will be executed if an
³  exception key is received (any key not otherwise meaningful). The
³  codeblock will be evaluated and will be passed:
³ 
³           1. current element #
³           2. exception key value
³           3. the tbrowse object
³ 
³  as parameters.
³ 
³  [nStart] is an optional starting element. Default is 1.
³  [@nRow] is an optional starting row. Default is 1. Pass by reference
³  to retain value between calls.
³ 
³ 
³  [nMRow, nMCol]  (new in 3.5) Directs sachoice() to draw
³  the "[][]" for mouse up/down at nMrow, nMCol, and to be aware of mouse
³  clicks on these buttons. (the screen under the arrows is saved/restored)
³ 
³ 
³  [bMouse] is a codeblock to evaluate mouse clicks other than those
³  meaningful to sachoice(). The codeblock is evaluated as follows:
³            eval(bMouse,mouserow, mousecolumn)
³ 
³ 
³ 
³  Examples:
³  ---------
³   USE CUSTOMER
³ 
³   aFlds       := afieldsx()
³   bExcept     := {|e,k|msg("You pressed ",str(k))}
³   ?SACHOICE(10,10,20,12,aFlds,bExcept)
³ 
³   //to retain element and position between calls
³   nSelect := 1
³   nRow    := 1
³   aMeals   := {"Pizza","Chicken","Chinese"}
³   while nSelect > 0
³     nSelect  := sachoice(10,10,20,20,aMeals,nil,nSelect,@nRow)
³     // code
³   endif
³ 
³ 
³ 
³  Notes:
³  -------
³  This will be a lot easier to mouse-ize than ACHOICE.
³  (or is that RAT-ify..)
³ 
³  Source:
³  -------
³  S_ACHOI.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function sachoice(nTop,nLeft,nBottom,nRight,aOptions,bKeyBlock,nStart,nRow,;
                  nMRow, nMCol,bMouse)

LOCAL lAlphaSel, cFirst
LOCAL nIterator, oTb, cArrows
LOCAL nLastKey,cLastKey,nFound
local nElement := 1
local nMouseR:=0, nMouseC:=0
nStart := iif(nStart#nil,nStart,1)
if nMRow#nil .and. nMCol#nil .and. sls_ismouse()
      cArrows := savescreen(nMRow,nMCol,nMRow, nMCol+5)
      devpos(nMRow,nMCol)
      devout("[][]")
endif

IF len(aOptions)> 0
  cFirst := ''
  FOR nIterator = 1 TO len(aOptions)
    if valtype(aOptions[nIterator])=="C"
      cFirst += UPPER(LEFT(aOptions[nIterator],1))
    else
      cFirst += chr(32)
    endif
  NEXT

  oTb:= tBrowseNew(nTop,nLeft,nBottom,nRight)
  oTb:addcolumn(tbcolumnNew(nil,{||aOptions[nElement]}))
  oTb:getcolumn(1):width := min(findbigest(aOptions),sbcols(nLeft,nRight,.f.) )
  oTb:Skipblock     := {|n|aaskip(n,@nElement,len(aOptions))}
  oTb:goTopBlock    := {||nElement := 1}
  oTb:goBottomBlock := {||nElement := len(aOptions)}

  if nStart#nil .and. nStart <= len(aOptions)
    if nRow#nil
      oTb:RowPos := nRow
      nElement   := nStart
      oTb:configure()
    else
      ac_goto(nStart,nElement,oTb)
    endif
  endif
  while .t.
    dispbegin()
    while !oTb:stabilize()
    end
    dispend()

    nLastKey := rat_event(0,.F.,.F.,@nMouseR, @nMouseC)

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
      oTb:PAGEDOWN()
    CASE nLastKey = K_END         && END
      oTb:GOBOTTOM()
    CASE nLastKey = K_ENTER       && ENTER
      exit
    CASE nLastKey = K_ESC
      nElement := 0
      EXIT
    case (cLastKey:=upper(chr(nLastkey)))$cFirst .and. cLastkey#chr(32)
      nFound := at(cLastKey,subst(cFirst,nElement+1))
      nFound := iif(nFound> 0,nFound+nElement,nFound)
      if nFound==0 .and. nElement > 1
        nFound := at(cLastKey,cFirst)
      endif
      if nFound > 0
        if nFound<>nElement
          ac_goto(nFound,nElement,oTb)
        endif
      endif
    case nLastKey == K_MOUSELEFT
          do case
          case nMRow#nil .and. nMCol#nil .and. ;
              ISMOUSEAT(nMouseR, nMouseC, nMRow,nMCol, nMRow, nMCol+2)
                oTb:up()
                IFMOUSEHD({||oTb:up()},oTb)
          case nMRow#nil .and. nMCol#nil .and. ;
                ISMOUSEAT(nMouseR, nMouseC, nMRow,nMCol+3, nMRow, nMCol+5)
             oTb:down()
             IFMOUSEHD({||oTb:down()},oTb)
          case MBRZMOVE(oTb,nMouseR, nMouseC,nTop,nLeft,nBottom,nRight)
             keyboard chr(13)
          case MBRZCLICK(oTb,nMouseR, nMouseC)
             EXIT
          case bMouse#nil
             eval(bMouse,nMouseR, nMouseC)
          endcase
    case SETKEY(nLastkey)#nil
      eval( SETKEY(nLastkey),procname(1),procline(1),readvar() )
    case bKeyBlock#nil
      eval(bKeyBlock,nElement,nLastkey,oTb)
    endcase
  end
ENDIF
nrow := oTb:rowpos
if cArrows#nil
      restscreen(nMRow,nMCol,nMRow, nMCol+5,cArrows)
endif
RETURN nElement

//===============================================================
static function ac_goto(nNew,nCurrent,oTb)
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



