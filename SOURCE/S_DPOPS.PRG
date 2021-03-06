
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPMONTH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPMONTH() Popup month selection
³ 
³  Returns:
³  --------
³  <nMonth> => number of the month selected
³ 
³  Syntax:
³  -------
³  POPMONTH([nStart])
³ 
³  Description:
³  ------------
³  Popup a picklist of months January -
³  December.[nStart] is a month 1 - 12
³
³  Examples:
³  ---------
³   nMonth := POPMONTH()
³
³  Source:
³  -------
³  S_DPOPS.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION POPMONTH(nStart)
local aMonths := {"January",;
                  "February",;
                  "March",;
                  "April",;
                  "May",;
                  "June",;
                  "July",;
                  "August",;
                  "September",;
                  "October",;
                  "November",;
                  "December"}
return MCHOICE(aMonths,nil,nil,nil,nil,"Select Month:",.t.,nStart)


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPVDATE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  POPVDATE() Pops up a picklist of virtual dates
³ 
³  Returns:
³  --------
³  <dSelected> => selected date
³
³  Syntax:
³  -------
³  POPVDATE([dStart],[lWords],[cTitle])
³ 
³  Description:
³  ------------
³  Pops up a virtual picklist of dates, beginning with
³  the current date. As user scrolls down, date increases. As user
³  scrolls up, date decreases. Page up/Page down move by 30 day
³  increments. Ctrl-Pgup/Ctrl-Pgdn move by 365 day increments. Home
³  key returns to the starting date.
³ 
³  [dStart] the starting date, today's date by default
³ 
³  [lWords] show dates as words, False by default
³ 
³  [cTitle] popup box title, none by default
³
³  Examples:
³  ---------
³   dDate := POPVDATE(date(),.t.,"Pick a Date")
³
³  Source:
³  -------
³  S_DPOPS.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION POPVDATE(dStart,lWords,cTitle)
local nTop:=0,nLeft:=0,nBottom:=17,nRight:=28
local oTb,cBox
local nElement := 0
local nLastKey, nMouseR, nMouseC
local dReturn

dStart := iif(dStart#nil,dStart,date())
lWords := iif(lWords#nil,lWords,.f.)
cTitle := iif(cTitle#nil,cTitle,"")
nRight := max(nRight,len(cTitle))
sbcenter(@nTop,@nLeft,@nBottom,@nRight)
cBox   := makebox(nTop,nLeft,nBottom,nRight,sls_popcol())
@nBottom-3,nLeft+1 to nBottom-3,nRight-1
@nTop,nLeft+1 say left(cTitle,sbcols(nLeft,nRight,.f.))
@nBottom-2,nLeft+1 say "[][] "
@nBottom-1,nLeft+1 say "[ENTER=OK] [ESCAPE=Cancel]"
oTb    := tbrowsenew(nTop+1,nLeft+1,nBottom-4,nRight-1)
if lWords
  oTb:addcolumn(tbcolumnNew(nil,{||dtow(dStart+(nElement))}))
else
  oTb:addcolumn(tbcolumnNew(nil,{||dStart+(nElement)}))
endif
oTb:skipblock := {|n|nElement+=n,n}
while .t.
  while !oTb:stabilize()
  end
  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
  do case
  case nLastKey == K_DOWN
    oTb:down()
  case nLastKey == K_UP
    oTb:up()
  case nLastKey == K_PGDN
    nElement += 30
    oTb:refreshall()
  case nLastKey == K_PGUP
    nElement -= 30
    oTb:refreshall()
  case nLastKey == K_CTRL_PGDN
    nElement += 365
    oTb:refreshall()
  case nLastKey == K_CTRL_PGUP
    nElement -= 365
    oTb:refreshall()
  case nLastKey == K_HOME
    nElement := 0
    oTb:refreshall()
  case nLastKey == K_ESC .or. nLastkey==K_MOUSERIGHT
    dReturn := dStart
    exit
  case nLastKey == K_ENTER
    dReturn :=  dStart+(nElement)
    exit
  case nLastKey==K_MOUSELEFT
     do case
     case ISMOUSEAT(nMouseR, nMouseC, nBottom-1,nLeft+1,nBottom-1,nLeft+10)
        keyboard chr(K_ENTER)
     case ISMOUSEAT(nMouseR, nMouseC, nBottom-1,nLeft+12,nBottom-1,nLeft+26)
        keyboard chr(K_ESC)
     case BRZUPDOWN(oTb,nBottom-2,nMouseR, nMouseC,nLeft+1,nLeft+3,nLeft+4,nLeft+6)
     case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
       keyboard chr(K_ENTER)
     case MBRZCLICK(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
       EXIT
     endcase
  endcase
end
unbox(cBox)
return dReturn

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPVYEAR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  POPVYEAR() Pops up a picklist of virtual years
³ 
³  Returns:
³  --------
³  <nSelected> => selected year
³
³  Syntax:
³  -------
³  POPVYEAR([cTitle])
³
³  Description:
³  ------------
³  Pops up a virtual picklist of years, beginning with
³  the current year. As user scrolls down, year increases. As user
³  scrolls up, year decreases. Home key returns to the starting
³  year.
³ 
³  [cTitle]  is a popup box title, none by default
³
³  Examples:
³  ---------
³   nYear := POPVYEAR("Pick a Year")
³
³  Source:
³  -------
³  S_DPOPS.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION POPVYEAR(cTitle)
local nTop:=0,nLeft:=0,nBottom:=17,nRight:=28
local oTb,cBox
local nElement := 0
local nLastKey, nMouseR, nMouseC
local nReturn
local nStart

nStart := year(date())
cTitle := iif(cTitle#nil,cTitle,"")
nRight := max(nRight,len(cTitle))
sbcenter(@nTop,@nLeft,@nBottom,@nRight)
cBox   := makebox(nTop,nLeft,nBottom,nRight,sls_popcol())
@nBottom-3,nLeft+1 to nBottom-3,nRight-1
@nTop,nLeft+1 say left(cTitle,sbcols(nLeft,nRight,.f.))
@nBottom-2,nLeft+1 say "[][] "
@nBottom-1,nLeft+1 say "[ENTER=OK] [ESCAPE=Cancel]"
oTb    := tbrowsenew(nTop+1,nLeft+1,nBottom-4,nRight-1)
oTb:addcolumn(tbcolumnNew(nil,{||trans(nStart+(nElement),"9999")}))
oTb:skipblock := {|n|nElement+=n,n}
while .t.
  while !oTb:stabilize()
  end
  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
  do case
  case nLastKey == K_DOWN
    oTb:down()
  case nLastKey == K_UP
    oTb:up()
  case nLastKey == K_PGDN
    oTb:pagedown()
  case nLastKey == K_PGUP
    oTb:pageup()
  case nLastKey == K_HOME
    nElement := 0
    oTb:refreshall()
  case nLastKey == K_ESC .or. nLastkey==K_MOUSERIGHT
    nReturn := nStart
    exit
  case nLastKey == K_ENTER
    nReturn :=  nStart+(nElement)
    exit
  case nLastKey==K_MOUSELEFT
     do case
     case ISMOUSEAT(nMouseR, nMouseC, nBottom-1,nLeft+1,nBottom-1,nLeft+10)
        keyboard chr(K_ENTER)
     case ISMOUSEAT(nMouseR, nMouseC, nBottom-1,nLeft+12,nBottom-1,nLeft+26)
        keyboard chr(K_ESC)
     case BRZUPDOWN(oTb,nBottom-2,nMouseR, nMouseC,nLeft+1,nLeft+3,nLeft+4,nLeft+6)
     case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
       keyboard chr(K_ENTER)
     case MBRZCLICK(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
       EXIT
     endcase
  endcase
end
unbox(cBox)
return nReturn



static function BRZUPDOWN(oTb,nRow,nMouseR,nMouseC,nUpL,nUpR,nDownL,nDownR)
local lHandled := .f.
local bBlock
if nRow == nMouseR
  if nMouseC >= nUpL .and. nMouseC <=nUpR
    bBLock := {||oTb:up()}
  elseif nMouseC >= nDownL .and. nMouseC <=nDownR
    bBLock := {||oTb:down()}
  endif
endif
if bBlock#nil
    lHandled := .t.
    EVAL(bBlock)
    IFMOUSEHD(bBlock, oTb)
endif
return lHandled

