#include "inkey.ch"
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AMSG()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AMSG() Pop up message box for an array of messages
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  aMsg(aMsgs,[cTitle],[cFooter],[lCenter],[cColor],[nTop,nLeft])
³ 
³  Description:
³  ------------
³  Pops up a box to display messages in <aMsgs>. Each
³  element of <aMsgs> can be of type Character, Numeric, Date or
³  Logical.
³ 
³  The box is centered in the middle of the screen by
³  default.
³ 
³  [cTitle]  is an optional title string displayed at
³  <nTop>,<nLeft+1>
³ 
³  [cFooter] is an optional footer string displayed at
³  <nBottom>, <nLeft+1>. Default footer is "Press a key.."
³ 
³  [lCenter]  determines center messages in box or not.
³  by default, message lines are left justified. Passing True
³  causes messages to be centered.
³ 
³  [cColor] is the color of the popup box. By default,
³  is sls_popcol()
³ 
³  [nTop,nLeft] are optional TOP/LEFT dimensions for the
³  box. Default is centered on the screen, and big enough to hold
³  all of the message lines.
³ 
³  Examples:
³  ---------
³ 
³  aArray := {"Attention:","all items are on sale for",1.99,;
³     "today only",date()}
³ 
³  amsg(aArray,"Sale",nil,.t.)
³ 
³  Notes:
³  -------
³  If there are more message lines than will fit in the
³  box, up/down arrows will scroll the messages.
³ 
³  See MSG()
³ 
³  Source:
³  -------
³  S_AMSG.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function aMsg(aMsgs,cTitle,cFooter,lCenter,cColor,nTop,nLeft,nBottom,nRight)
local cBox,oTb
local nMessage := 1
local nLongest, nLastKey
local nMouseR:=0,nMouseC:=0
local lPastBottom := .f.
local nCursor := SETCURSOR(0)

if aMsgs#nil .and. valtype(aMsgs)=="A"
  cColor   := iif(cColor#nil,cColor,sls_popcol())
  cTitle   := iif(cTitle#nil,cTitle,"")
  cFooter  := iif(cFooter#nil,cFooter,"Press a key..")
  lCenter  := iif(lCenter#nil,lCenter,.f.)
  nLongest := am_dodim(@nTop,@nLeft,@nBottom,@nRight,aMsgs,cFooter)
  nLongest := MAX(MAX(nLongest,sbcols(nLeft,nRight,.f.)),17)

  lPastBottom := (((nBottom-2)-(nTop+1))<len(aMsgs) )
  cBox := makebox(nTop,nLeft,nBottom,nRight,cColor)
  @nTop,nLeft+1 say ctitle
  if lPastBottom
     @nBottom,nRight-6 say "[][]"
     @nBottom-1,nLeft+1 say cFooter
  else
     @nBottom,nLeft+1 say cFooter
  endif
  oTb  := tbrowsenew(nTop+1,nLeft+1,nBottom-2,nRight-1)
  oTb:addcolumn(tbcolumnNew(nil,{||ampad(aMsgs[nMessage],nLongest,lCenter)}))
  oTb:skipblock := {|n|aaskip(n,@nMessage,len(aMsgs))}
  oTb:colorspec := takeout(setcolor(),",",1)+","+takeout(setcolor(),",",1)

  while .t.
     while !oTb:stabilize()
     end

     nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

     do case
     case lPastBottom
         do case
         case nLastkey == K_UP .or. ;
                ISMOUSEAT(nMouseR, nMouseC, nBottom, nRight-6,nBottom,nRight-4)
           oTb:pageup()
         case nLastkey == K_DOWN .or. ;
                ISMOUSEAT(nMouseR, nMouseC, nBottom, nRight-3,nBottom,nRight-1)
           oTb:pagedown()
         endcase
     otherwise
       exit
     endcase
  end
  unbox(cBox)
endif
setcursor(nCursor)
return nil

//--------------------------------------------------------------
static function am_dodim(nTop,nLeft,nBottom,nRight,aMsgs,cFooter)
local nLongest := 0
local i, cValtype
for i = 1 to len(aMsgs)
  cValtype := valtype(aMsgs[i])
  nLongest := max(nLongest,len(trans(aMsgs[i],"")))
next
if nTop==nil.or.nLeft==Nil.or.nBottom==nil.or.nRight==nil
   nTop     := 0
   nLeft    := 0
   nBottom  := min(len(aMsgs)+3,maxrow())
   nRight   := min(nLongest+2,maxcol())
   nright   := max(nRight,len(cFooter)+2)
   sbcenter(@nTop,@nLeft,@nBottom,@nRight)
endif
return nLongest


//--------------------------------------------------------------
static function ampad(expVar,nWidth,lCenter)
if valtype(expVar)=="L"
  expVar := IIF(expVar,"Yes","No")
endif
if lCenter
  return PADC(expVar,nWidth)
endif
return PADR(expVar,nWidth)
