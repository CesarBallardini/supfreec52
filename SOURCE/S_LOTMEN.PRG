
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
static aCurrent
static nElement := 1
static aStack   := {}

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLOTUSMENU()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SLOTUSMENU() 1-2-3 style menu
ณ 
ณ  Returns:
ณ  --------
ณ  <expReturn> => depends on several factors
ณ 
ณ  Syntax:
ณ  -------
ณ  SLOTUSMENU(nTop,nLeft,nBottom,nRight,aOptions,[lBox],;
ณ        [lSaveRest],[lReset])
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a 1-2-3 style menu from <nTop>,<nLeft> to
ณ  <nTop+1>,<nRight>.
ณ 
ณ  <nTop> is the menu option line. <nTop+1> is the
ณ  message line.
ณ 
ณ  <aOptions> is an array of arrays in the format:
ณ 
ณ  {  {cOption,cMessage,expAction},
ณ  {cOption,cMessage,expAction},... }
ณ 
ณ  where <cOption> is the option prompt, <cMessage> is
ณ  the option message, and <expAction> is the option action.
ณ 
ณ  <expAction> may be of three types:
ณ 
ณ      1.    a codeblock, in which case it is executed on
ณ            ENTER
ณ 
ณ      2.    a submenu array of the form:
ณ 
ณ         {  {cOption,cMessage,expAction},  ;
ณ             {cOption,cMessage,expAction},... }
ณ            which is displayed on ENTER. Pressing ESCAPE
ณ            from the submenu returns to the prior menu.
ณ 
ณ            The submenu <expaction> may be a codeblock,
ณ            another subarray, or any other value, etc.
ณ            Thus nesting can go as deep as you like.
ณ 
ณ      3.    any other value, which is returned to the
ณ            calling program on ENTER.
ณ 
ณ  Pressing ESCAPE from the main menu returns 0
ณ 
ณ  [lBox]  If True, the menu is drawn inside of a popup
ณ  box. Actual dimensions of the menu area then become
ณ  <nTop>+1,<nLeft>+1 to <nTop>+2,<nRight>-1. Default is False - no box.
ณ 
ณ  [lSaveRest] If True, the underlying screen is saved
ณ  and restored on entrance/exit. Default is False - no restore.
ณ 
ณ  [lReset] If True, the menu is reset to first option
ณ  on exit. Default is False - menu remembers where it was.
ณ 
ณ  SLOTUSCLEAR() resets the menu.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   proc test
ณ   local nReturn := 0
ณ   local aMain := {}
ณ   local aSub1 := {{"Pizza",     "Eat Pizza", {||pizza()}},;
ณ                   {"Spaghetti", "Eat Spaghetti", {||spagett()}},;
ณ                   {"Tortellini","Eat Tortellini", {||tortellini()}} }
ณ 
ณ   local aSub2 := {{"Steak",     "Eat Steak", {||steak()}},;
ณ                   {"Hamburger", "Eat Hamburger",  {||burgers()}},;
ณ                   {"Chili Dog", "Eat Chili Dog",  {||burntwice()}}  }
ณ 
ณ   aadd(aMain,{"Italian","Eat Italian food",aSub1})
ณ   aadd(aMain,{"American","Eat American food",aSub2})
ณ   aadd(aMain,{"Quit","Just not hungry - Quit",0})
ณ   aadd(aMain,{"Relief","Already ate - need Alka Seltzer",{||alka()} })
ณ 
ณ   SLOTUSMENU(0,0,0,79,aMain,.t.,.t.,.t.)
ณ 
ณ   SLOTUSCLEAR()  // !! always use this to clear the menu
ณ 
ณ  Notes:
ณ  -------
ณ 
ณ  Always use SLOTUSCLEAR() after calling SLOTUSMENU()
ณ 
ณ  Source:
ณ  -------
ณ  S_LOTMEN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLOTUSMENU(nTop,nLeft,nbottom,nRight,aOptions,lBox,lSaveRest,lReset)
LOCAL oTb,cBox,nColumn
LOCAL nTbTop,nTbLeft,nTbBottom,nTbRight,nWidth
LOCAL expReturn := 0
LOCAL nLastkey,cLastkey,nFirstLetter
LOCAL nMouseR, nMouseC

lBox      := iif(lBox#nil,lBox,.f.)
lSaveRest := iif(lSaveRest#nil,lSaveRest,.f.)
lReset    := iif(lReset#nil,lReset,.f.)
if lBox
  nBottom  := nTop+3
  nTbTop   := nTop+1
  nTbLeft  := nLeft+1
  nTbRight := nRight-1
else
  nBottom  := nTop+1
  nTbTop   := nTop
  nTbLeft  := nLeft
  nTbRight := nRight
endif
if lSaveRest
  if lBox
    cBox := Makebox(nTop,nLeft,nBottom,nRight)
  else
    cBox := Savescreen(nTop,nLeft,nBottom,nRight)
  endif
ELSEIF lBox
    Makebox(nTop,nLeft,nBottom,nRight)
endif
nWidth    := nTbRight-nTbLeft+1
if len(aStack)=0
  aCurrent  := aOptions
endif
oTb := BuildTb(nTbTop,nTbLeft,nTbTop,nTbRight,nWidth)
oTb:colpos := nElement

while .t.
  dispbegin()
  while !oTb:stabilize()
  end
  if aCurrent[oTb:colpos,2]#nil
    @nTbTop+1,nTbLeft say padr(aCurrent[oTb:colpos,2],nWidth)
  else
    scroll(nTbTop+1,nTbLeft,ntbTop+1,nTbRight,0)
  endif
  dispend()

  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

  do case
  case nLastKey == K_ENTER      //
    if valtype(aCurrent[oTb:colpos,3])=="A"
      aadd(aStack,{aCurrent,oTb:colpos})
      aCurrent := aCurrent[oTb:colpos,3]
      oTb := BuildTb(nTbTop,nTbLeft,nTbTop,nTbRight,nWidth)
      oTb:colpos := 1
    elseif valtype(aCurrent[oTb:colpos,3])=="B"
      eval(aCurrent[oTb:colpos,3])
    else
      expReturn := aCurrent[oTb:colpos,3]
      exit
    endif
  case nLastKey == K_ESC  .OR. nLastKey==K_MOUSERIGHT     // abort or right mouse
    if len(aStack)>0
      aCurrent := atail(aStack)[1]
      oTb := BuildTb(nTbTop,nTbLeft,nTbTop,nTbRight,nWidth)
      oTb:colpos :=  atail(aStack)[2]
      aSize(aStack,len(aStack)-1)
    else
      exit
    endif
  case nLastKey == K_LEFT     // allow movement (left)
     IF oTb:colpos > 1
       oTb:left()
     ELSE
       oTb:colpos  := len(aCurrent)
       oTb:refreshall()
     ENDIF
  case nLastKey == K_RIGHT    // allow movement (right)
     IF oTb:colpos < len(aCurrent)
       oTb:right()
     ELSE
       oTb:colpos  := 1
       oTb:refreshall()
     ENDIF
  CASE (cLastkey := upper(chr(nLastkey)))$"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
     if cLastkey == upper(left(aCurrent[oTb:colpos,1],1))
       keyboard chr(13)
     elseif (nFirstLetter := ascan(aCurrent,{|e|e[1]#nil.and.upper(left(e[1],1))==cLastKey },oTb:colpos+1)) > 0 ;
        .or. (nFirstLetter := ascan(aCurrent,{|e|e[1]#nil.and.upper(left(e[1],1))==cLastKey },1,oTb:colpos)) > 0
       oTb:colpos  := nFirstLetter
       oTb:refreshall()
     endif
  case MBRZMOVE(oTb,nMouseR,nMouseC)
     keyboard chr(K_ENTER)
  case MBRZCLICK(oTb,nMouseR,nMouseC)
     keyboard chr(K_ENTER)
  endcase
end
nElement := oTb:colpos
if lSaveRest
  if lBox
    unbox(cBox)
  else
    restscreen(nTop,nLeft,nBottom,nRight,cBox)
  endif
endif
if lReset
  SLOTUSCLEAR()
endif
return expReturn

//----------------------------------------------------------------------
FUNCTION SLOTUSCLEAR
aStack := {}
nElement := 1
return nil

//-----------------------------------------------------------------
static function BuildTb(ntop,nLeft,nbottom,nRight,nWidth)
local oTb,nColumn
local ntotWidth := ttlwidth()
scroll(nTop,nLeft,nBottom,nRight,0)
if ntotWidth >= nWidth
  oTb := tbrowsenew(nTop,nLeft,nbottom,nRight)
else
  oTb := tbrowsenew(nTop,nLeft,nbottom,nLeft+nTotWidth-1)
endif
for nColumn = 1 to len(aCurrent)
  oTb:addcolumn(tbColumnNew(nil,lmblock(nColumn)))
next
otb:skipblock := {|n|0}
return oTb

//-----------------------------------------------------------------
static function lmblock(i)
return {||aCurrent[i,1]}


//-----------------------------------------------------------------
static function ttlwidth
local nWidth := 0
aeval(aCurrent,{|e|nWidth+=len(e[1])+1})
return nWidth



