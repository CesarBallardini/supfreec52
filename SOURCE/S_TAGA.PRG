
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#define GOINGDOWN 1
#define GOINGUP   2
#ifndef K_SPACE
#define K_SPACE 32
#endif
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION TAGARRAY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  TAGARRAY() Tag selected elements of an array
ณ 
ณ  Returns:
ณ  --------
ณ  An array containing the element numbers of the tagged
ณ  items
ณ 
ณ  Syntax:
ณ  -------
ณ  TAGARRAY(aArray,[cTitle],[cMark])
ณ 
ณ  Description:
ณ  ------------
ณ  Tag items in <aArray>
ณ 
ณ  Optional title [cTitle] . Optional mark [cMark].
ณ 
ณ  Default title is none. Default mark is chr(251) - the
ณ  checkmark.
ณ 
ณ  Examples:
ณ  ---------
ณ   aArr := {1,2,3,4,5,6,7}
ณ 
ณ   aSel := TAGARRAY(aArr,"Which Items","X")
ณ   for i = 1 to len(aSel)
ณ     DO_SOMETHING_WITH( aArr[ aSel[i] ] )
ณ   next
ณ 
ณ  Source:
ณ  -------
ณ  S_TAGA.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION TAGARRAY(aArray,cTitle,cMark,aLogical)
LOCAL aTagged := {}
LOCAL cTagScreen
LOCAL oTb
local nDirection  := GOINGDOWN
LOCAL nElement := 1
local nTaggedItems := 0
local nTop,nLeft,nBottom,nRight
local nLastKey,i, cLastKey
local nFoundTagged
local nMouseR, nMouseC
local aButtons
local nButton := 0
aLogical := iif(aLogical#nil,aLogical,array(len(aArray)))

if (len(aLogical) != len(aArray) )
  asize(aLogical,len(aArray))
endif
//aeval(aLogical,{|e| e := iif(e == NIL,.f.,e)})
tafillnil(aLogical,.f.)

for i = 1 to len(aLogical)
  if aLogical[i]
    aadd(aTagged,i)
    nTaggedItems++
  endif
next


IF aArray#nil .and. LEN(aArray)>0 .and. ;
         AMATCHES(aArray,{|e|valtype(e)=="U"})=0

  nTop    := 5
  nLeft   := 15
  nBottom := 20
  nRight  := 65

  cMark := IIF(cMark#NIL,cMark,"๛")
  *- DRAW THE BOX
  cTagScreen=MAKEBOX(nTop,nLeft,nBottom,nRight,SLS_POPCOL())
  if cTitle#NIL
    @nTop+1,nLeft+1 say cTitle
    @nTop+2,nLeft+1 to nTop+2,nRight-1
  endif
  @nBottom-2,nLeft+1 to nBottom-2,nRight-1
  @nBottom-1,nLeft+1 say "[][]  [space=TAG]  [C=CLEAR  ]  [F10=DONE ]"
  aButtons := {;
              {nBottom-1,nLeft+1,nBottom-1,nLeft+3,K_UP},;
              {nBottom-1,nLeft+4,nBottom-1,nLeft+6,K_DOWN},;
              {nBottom-1,nLeft+09,nBottom-1,nLeft+19,K_SPACE},;
              {nBottom-1,nLeft+22,nBottom-1,nLeft+32,ASC("C")},;
              {nBottom-1,nLeft+35,nBottom-1,nLeft+45,K_F10};
              }

  *- BUILD THE TBROWSE OBJECT
  oTb := TBROWSENEW(iif(cTitle#nil,nTop+3,nTop+1),nLeft+1,nBottom-3,nRight-1)
  oTb:COLSEP := "ณ"

  *- ADD THE TBCOLUMNS
  oTb:ADDCOLUMN(tbColumnNew(nil,{||IIF((Ascan(aTagged,nElement)> 0) ,padc(cMark,5),space(5))} ))
  oTb:ADDCOLUMN(tbColumnNew(nil,{||padr(aArray[nElement],35)} ))
  oTb:SKIPBLOCK := {|N|AASKIP(N,@nElement,LEN(aArray))}
  oTb:goBottomBlock := {|| nElement := len(aArray)}
  oTb:goTopBlock    := {|| nElement := 1}


  DO WHILE .T.
     WHILE !oTb:STABILIZE()
     END
     nButton := 0
     nMouseR := 0
     nMouseC := 0

     nLastKey := RAT_EVENT(0,.f.,.f.,@nMouseR, @nMouseC)
     cLastkey := upper(chr(nLastkey))
     if nLastKey==K_MOUSELEFT
       nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
       if nButton<>0
         cLastKey := upper(chr(nButton))
       endif
     endif

     do case
     case nLastkey = K_UP .or. nButton==K_UP         && up one row
       oTb:up()
       nDirection := GOINGUP
       if nButton==K_UP
         IFMOUSEHD({||oTb:up()},oTb)
       endif
      case nLastkey = K_PGUP        && up one page
        oTb:pageUp()
        nDirection := GOINGUP
      case nLastkey = K_HOME        && home
        oTb:gotop()
        nDirection := GOINGDOWN
      case nLastkey = K_DOWN  .or. nButton==K_DOWN           && down one row
        oTb:down()
        nDirection := GOINGDOWN
        if nButton==K_DOWN
          IFMOUSEHD({||oTb:down()},oTb)
        endif
      case nLastkey = K_PGDN        && down one page
        oTb:pageDown()
        nDirection := GOINGDOWN
      case nLastkey = K_END         && end
        oTb:gobottom()
        nDirection := GOINGUP
     case nLastKey = K_SPACE .or. nButton==K_SPACE
       *- LOOK FOR RECORD # IN ARRAY
       nFoundTagged = aSCAN(aTagged,nElement)
       if nFoundTagged > 0
         aDEL(aTagged,nFoundTagged)
         nTaggedItems--
         ASIZE(aTagged,nTaggedItems)
       else
         aadd(aTagged,nElement)
         nTaggedItems++
       endif
       oTb:REFRESHCURRENT()
       IF nDirection == GOINGUP
          oTb:up()
       ELSE
          oTb:down()
       ENDIF
     case nLastKey = K_F10 .OR. nButton==K_F10
       EXIT
     case cLastKey=="C"
       ASIZE(aTagged,0)
       nTaggedItems  := 0
       oTb:REFRESHALL()

     case MBRZMOVE(oTb,nMouseR,nMouseC,;
               iif(cTitle#nil,nTop+3,nTop+1),nLeft+1,nBottom-3,nRight-1)
     case MBRZCLICK(oTb,nMouseR,nMouseC)
             keyboard " "
     endcase
  ENDDO
  unbox(cTagScreen)
ENDIF
afill(aLogical,.f.)
for i = 1 to len(aTagged)
   aLogical[aTagged[i]] := .t.
next

return aTagged


static function tafillnil(aIn,expFill)
local i
for i = 1 to len(aIn)
  if aIn[i]==nil
    aIn[i] := expFill
  endif
next
return nil


