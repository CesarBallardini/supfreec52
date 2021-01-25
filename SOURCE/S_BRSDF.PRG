
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
// browsesdf("test.sdf",{"First","Last","Date","Buyer"},{"C","C","D","L"},{15,20,8,3})

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BROWSESDF()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BROWSESDF() Tbrowse an SDF file
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  BROWSESDF(cFile,aDesc,aTypes,aLengths)
ณ 
ณ  Description:
ณ  ------------
ณ  Tbrowses an SDF file <cFile>, using column headers in
ณ  <aDesc>, with field 'types' in <aTypes>, and field lengths in
ณ  <aLengths>
ณ 
ณ  Examples:
ณ  ---------
ณ
ณ   //sample.sdf looks like this:
ณ 
ณ   //AHLBERG              STEPHEN           23.4519890226
ณ   //SMITH                JEFF              45.0019890301
ณ   //SMITH                DENNIS             0.0019890313
ณ   //ALVARADO             DAVID             25.0019890330
ณ 
ณ   //note: widths have to be exact
ณ
ณ 
ณ   browseSDF("sample.sdf",{"Last","First","Due","Date"},;
ณ                          {"C","C","N","D"},;
ณ                          {20,15,8,8})
ณ 
ณ  Source:
ณ  -------
ณ  S_BRSDF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function browseSDF(cFile,aDesc,aTypes,aLens)
local cThisLine,nLastKey, nMouseR, nMouseC
local i,oTb,cInScreen
local nHandle := fopen(cFile,64)
local nTop    := 3
local nLeft   := 5
local nBottom := 22
local nRight  := 75
IF Ferror() <> 0
  msg("Error opening file : "+cFile)
  RETURN ''
ENDIF
cInscreen := makebox(nTop,nLeft,nBottom,nRight,sls_normcol())
@nTop,nLeft+1 say "[SDF file Browse]"
@nBottom-2,nLeft+1 to nBottom-2,nRight-1
@nBottom-1,nLeft+1 say " [] [] [] []  [ESCAPE or ENTER]=done"

oTb := tbrowsenew(nTop+1,nLeft+1,nBottom-3,nRight-1)
for i = 1 to len(aTypes)
  oTb:addcolumn(tbcolumnnew(aDesc[i],;
                bsmakeb(i,aTypes,aLens,nHandle) ))
next

oTb:skipblock     := {|n|bsd_tskip(n,nHandle)}
oTb:gotopblock    := {||bsd_ftop(nHandle)}
oTb:gobottomblock := {||bsd_fbot(nHandle)}
oTb:headsep := "ฤ"
oTb:colsep := "ณ"

while .T.
  DISPBEGIN()
  while !oTb:stabilize()
  end
  DISPEND()

  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

  do case
  case nLastKey == K_UP
    oTb:UP()
  case nLastKey == K_DOWN
    oTb:down()
  case nLastKey == K_PGUP
    oTb:PAGEUP()
  case nLastKey == K_PGDN
    oTb:PAGEdown()
  case nLastKey == K_HOME
    oTb:gotop()
  case nLastKey == K_END
    oTb:gobottom()
  case nLastKey == K_LEFT
    oTb:left()
  case nLastKey == K_RIGHT
    oTb:right()
  case ISMOUSEAT(nMouseR, nMouseC,nBottom-1,nLeft+2,nBottom-1,nLeft+4)
    oTb:up()
    IFMOUSEHD({||oTb:up()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC,nBottom-1,nLeft+6,nBottom-1,nLeft+8)
    oTb:down()
    IFMOUSEHD({||oTb:down()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC,nBottom-1,nLeft+10,nBottom-1,nLeft+12)
    oTb:right()
    IFMOUSEHD({||oTb:right()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC,nBottom-1,nLeft+14,nBottom-1,nLeft+16)
    oTb:left()
    IFMOUSEHD({||oTb:left()},oTb)
  case MBRZMOVE(oTb, nMouseR, nMouseC, nTop+3,nLeft+1,nBottom-3,nRight-1)
  case nLastKey == K_ENTER .or. nLastKey == K_ESC .or. ;
     (nLastKey==K_MOUSELEFT .and. ;
     ISMOUSEAT(nMouseR, nMouseC, nBottom-1,nLeft+19,nBottom-1,nLeft+40) )
    exit
  endcase
end
fclose(nHandle)
unbox(cInscreen)
return nil

//--------------------------------------------------------------------------
static FUNCTION bsd_fbot(nHandle)
FSEEK(nHandle,0,2)
RETURN ''

//--------------------------------------------------------------------------
static FUNCTION bsd_ftop(nHandle)
FSEEK(nHandle,0)
RETURN ''

//--------------------------------------------------------------
static function bsd_tskip(n,nHandle)
local nMoved   := 0
if n > 0
  while nMoved < n
    if fmove2next(nHandle)
      nMoved++
    else
      exit
    endif
  end
elseif n < 0
  while nMoved > n
    if fmove2prev(nHandle)
      nMoved--
    else
      exit
    endif
  end
endif
return nMoved

//--------------------------------------------------------------------------
static function bsmakeb(i,aTypes,aLens,nHandle)
local bBlock
local nStart := 0
local nLen
for nLen = 1 to i-1
  nStart += aLens[nLen]
next
nStart += 1
do case
case aTypes[i]=="C"
  bBlock := {||padr(subst(sfreadline(nHandle),nStart,aLens[i]),aLens[i])  }
case aTypes[i]=="N"
  bBlock := {||padl(subst(sfreadline(nHandle),nStart,aLens[i]),aLens[i]) }
case aTypes[i]=="D"
  bBlock := {||stod(subst(sfreadline(nHandle),nStart,8)) }
case aTypes[i]=="L"
  bBlock := {||iif(subst(sfreadline(nHandle),nStart,1)=="T",.t.,.f.) }
endcase
return bBlock


