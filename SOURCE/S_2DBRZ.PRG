static nElement

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BROWSE2D()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BROWSE2D() Popup  tbrowse of 2 dimension array (array of arrays)
³ 
³  Returns:
³  --------
³  <nSelection> => selected item, 0 if none
³ 
³  Syntax:
³  -------
³  BROWSE2D(nTop,nLeft,nBottom,nRight,aArr,[aHead],[cColor],;
³        [cTitle],[bExcept])
³ 
³  Description:
³  ------------
³  Pops up a box at <nTop,nLeft,nBottom,nRight> and
³  tbrowses array contained in <aArr>.
³ 
³  <aArr> must be a 2 dimensioned array, like the ones
³  returned from DIRECTORY() or DBSTRUCT().
³ 
³  i.e. { array(n),array(n),array(n) } where <n> is the
³  same length for each subarray.
³ 
³  [aHead] an array of column headers matching the
³  number of elements in a single subarray of <aArr>. Default is
³  none.
³ 
³  [cColor] popup box color. Default is sls_popcol()
³ 
³  [cTitle] title string for the box. Default is none.
³ 
³  [bExcept] is a codeblock that will be evaluated for
³  any exception keys - any keys other than up/ down/ right/ left/
³  pgup/ pgdn/ home/ end/ enter/ esc. [bExcept] will be passed the
³  parameters: key value, tbrowse object, element
³ 
³  Examples:
³  ---------
³ 
³   proc test
³ 
³   local a := directory()
³   browse2d(5,5,20,40,a, ;
³           {"File","Size","Date","Time","Attribute"},,"Choose a File")
³ 
³   use customer
³   a := dbstruct()
³   browse2d(5,5,20,40,a,nil,nil,nil,;
³    {|k|msg(str(k)+" is not a valid key")})
³   // note the exception block
³ 
³  Source:
³  -------
³  S_2DBRZ.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function browse2d(nTop,nLeft,nBottom,nRight,aArr,aHead,cColor,cTitle,bExcept)
local nColumn,nLastKey, nMouseR, nMouseC
local cBox,oTb,lHeaders
local nReturn

dispbegin()
if nRight-nLeft<40
  nRight := nLeft+40
  while nRight>maxcol()
    nLeft--
    nRight--
  end
endif
cColor  := iif(cColor#nil,cColor,sls_popcol())
cTitle  := iif(ctitle#nil,cTitle,"")
cBox    := makebox(nTop,nLeft,nBottom,nRight,cColor)
@ nBottom,nLeft+1 say "[][][][]  [ENTER=OK] [ESC=CANCEL]"
lHeaders:= aHead#nil
aHead   := iif(aHead#nil,aHead,array(len(aArr[1])) )
oTb     := tbrowsenew(nTop+1,nLeft+1,nBottom-2,nRight-1)
if lHeaders
  oTb:headsep := "Δ"
endif
oTb:colsep := "³"

nElement    := 1
@nTop,nLeft+1 say cTitle

for nColumn = 1 to len(aArr[1])
  oTb:addColumn(TBColumnNew(aHead[nColumn],b2block(aArr,nColumn)))
  oTb:getcolumn(nColumn):width := findbigest(aArr,nColumn,aHead)
next
oTb:skipblock       := {|n|aaskip(n,@nElement,len(aArr))}
oTb:gobottomblock   := {||nElement := len(aArr)}
oTb:gotopblock      := {||nElement := 1}


dispend()
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
  case nLastkey == K_LEFT
    oTb:left()
  case nLastkey == K_RIGHT
    oTb:right()
  case nLastkey == K_HOME
    oTb:gotop()
  case nLastkey == K_END
    oTb:gobottom()
  case nLastkey == K_ENTER
    exit
  case nLastkey == K_ESC
    nElement := 0
    exit
  case nLastKey == K_MOUSELEFT
    DO CASE
    CASE ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+1,nBottom,nLeft+3)
        oTb:up()
        IFMOUSEHD({||oTb:up()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+4,nBottom,nLeft+6)
        oTb:down()
        IFMOUSEHD({||oTb:down()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+7,nBottom,nLeft+9)
        oTb:right()
        IFMOUSEHD({||oTb:right()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+10,nBottom,nLeft+12)
        oTb:left()
        IFMOUSEHD({||oTb:left()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+15,nBottom,nLeft+24)
        exit
    CASE ISMOUSEAT(nMouseR, nMouseC,nBottom,nLeft+26,nBottom,nLeft+37)
        nElement := 0
        exit
    CASE MBRZMOVE(oTb,nMouseR,nMouseC,nTop+3,nLeft+1,nBottom-2,nRight-1)
    CASE MBRZCLICK(oTb,nMouseR,nMouseC)
         keyboard chr(K_ENTER)
    ENDCASE

  case bExcept#nil
    eval(bExcept,nLastKey,oTb,nElement)

  endcase
end
unbox(cBox)
nReturn  := nElement
nElement := nil
return nReturn


static function b2block(a,i)
return {||a[nElement,i]}


//--------------------------------------------------------------
static function findbigest(aItems,nElement,aHead)
local aBiggest := 0
local i
for i = 1 to len(aItems)
  aBiggest := max(aBiggest,len(trans(aItems[i,nElement],"")))
next
if aHead[nElement]#nil
  aBiggest := max(aBiggest,len(trans(aHead[nElement],"")))
endif
return aBiggest






