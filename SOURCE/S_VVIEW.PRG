#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION VERTVIEW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  VERTVIEW() Pops up a vertical view of the current record
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  VERTVIEW([aFields,aFDescr],[cColor],[cTitle],[cFooter])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a vertical view of the current record's
ณ  values. Memos are displayed as "(memo - Enter to View)" and pressing CR
ณ  will view them.
ณ 
ณ  Pressing ESCAPE exits.
ณ 
ณ  The popup box is displayed centered on the screen. If
ณ  all fields do not fit into the box, scrolling is allowed with the
ณ  arrow keys.
ณ 
ณ  [aFields] and [aFDescr] are optional fields and field
ณ  descriptions.
ณ 
ณ  Default is all fields, with field names as
ณ  descriptions.
ณ 
ณ  [cColor] is the optional box color. Default is
ณ  sls_popcol()
ณ 
ณ  [cTitle] is an optional title string displayed at
ณ  top,left+1
ณ 
ณ  [cFooter] is a footer displayed at bottom,left+1.
ณ  Default footer is "ESCAPE to quit"
ณ 
ณ  Examples:
ณ  ---------
ณ   if nLastkey = K_ALT_V
ณ     VERTVIEW()
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_VVIEW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION vertview(aFields,aFDescr,cColor,cTitle,cFooter)
local cBox,oTb
local nField := 1
local nValuesLen,nDescLen
local aValues,i
local nTop,nLeft,nBottom,nRight
local cMemobox,nLastKey, nMouseR, nMouseC
cColor := iif(cColor#nil,cColor,sls_popcol())
cTitle := iif(cTitle#nil,cTitle,"")
cFooter:= iif(cFooter#nil,cFooter,"ESCAPE to quit")
if aFields==nil.or.aFDescr==nil
  aFields := afieldsx()
  aFdescr := afieldsx()
endif
aValues := array(len(aFields))
nDescLen   := bigelem(aFDescr)+1
for i = 1 to  len(aValues)
  aValues[i] := padr(aFdescr[i],nDescLen)+ MacroThis(aFields[i])
next

nValuesLen := bigelem(aValues)

nTop    := 0
nLeft   := 0
nBottom := min(len(aFields)+1,maxrow()-1)
nRight  := min(maxcol()-1,nValuesLen+1)
sbcenter(@nTop,@nLeft,@nBottom,@nRight)
nValuesLen := sbcols(nLeft,nRight,.f.)

cBox := makebox(ntop,nLeft,nBottom,nRight,cColor)
@nTop,nLeft+1 say cTitle
*@nBottom,nLeft+1 say cFooter
@nBottom,nLeft+1 say "[] [] [ OK ]"
oTb  := tbrowsenew(nTop+1,nLeft+1,nBottom-1,nRight-1)
oTb:addcolumn(tbcolumNnew(nil,{||padr(aValues[nField],nValuesLen) }   ))
oTb:skipblock := {|n|aaskip(n,@nField,len(aValues))}
while .t.
   while !oTb:stabilize()
   end
   nMouseR := 0; nMouseC := 0
   nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

   do case
   case nLastkey == K_UP
     oTb:up()
   case nLastkey == K_DOWN
     oTb:down()
   case nLastkey == K_PGUP
     oTb:pageup()
   case nLastkey == K_PGDN
     oTb:pagedown()
   case nLastkey == K_ENTER .and. "(memo - Enter"$aValues[nField]
      viewmemos(nTop,nLeft,nBottom,nRight,cColor,aFields[nField] )
   case nLastkey == K_ENTER .and. fieldtypex(aFields[nField])=="M"
      msg("That memo is empty")
   case nLastkey == K_ESC .or. nLastKey==K_MOUSERIGHT
     exit
   case nLastKey==K_MOUSELEFT .and. ;
        ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+9,nBottom,nLeft+14)
     exit
   case MBRZCLICK(oTb,nMouseR, nMouseC)
      keyboard chr(K_ENTER)
   case ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+1,nBottom,nLeft+3)
     oTb:up()
     IFMOUSEHD({||oTb:up()},oTb)
   case ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+5,nBottom,nLeft+7)
     oTb:down()
     IFMOUSEHD({||oTb:down()},oTb)
   case MBRZMOVE(oTb, nMouseR, nMouseC)
   endcase
end
unbox(cBox)
return nil

//--------------------------------------------------------------
static function MacroThis(expThis)
local expValue := &(expThis)
if valtype(expValue)=="C" .and. (chr(13)$expValue .or. chr(141)$expValue)
  return "(memo - Enter to View)"
else
  return trans(&(expThis),"")
endif
return nil

