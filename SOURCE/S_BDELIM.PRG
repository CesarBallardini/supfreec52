#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
// browsedelim("test.asc",{"First","Last","Buyer?","Date"},{"C","C","L","D"},{15,25,3,8})

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BROWSEDELIM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BROWSEDELIM() Tbrowse a delimited file
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  BROWSEDELIM(cFile,aDesc,aTypes,aLens,[cFieldDelim],;
ณ            [cCharDelim])
ณ 
ณ  Description:
ณ  ------------
ณ  Browse delimited file <cFile>.
ณ 
ณ  Column titles are contained in <aDesc> (one for each 'field').
ณ 
ณ  Field types are contained in <aTypes>, Field lengths
ณ  are contained in <aLens>.
ณ 
ณ  [cFieldDelim] - Field delimiter - default is a comma [,]
ณ 
ณ  [cCharDelim] - Character type delimiter - default is
ณ  a double quote [""]
ณ 
ณ  Examples:
ณ  ---------
ณ
ณ   //sample.asc looks like  this:
ณ 
ณ   //"AHLBERG","STEPHEN",23.45,19890226
ณ   //"SMITH","JEFF",45.00,19890301
ณ   //"SMITH","DENNIS",0.00,19890313
ณ   //"ALVARADO","DAVID",25.00,19890330
ณ   //"AMPOLSUK","EARL",60.00,19890406
ณ   //"ANDRADE","GARRY",55.00,19890301
ณ   //"ANDRADE","WALT",99.99,19890703
ณ
ณ 
ณ   browsedelim("sample.asc",{"First","Last","Due","Date"},;
ณ                          {"C","C","N","D"},;
ณ                          {15,25,6,8})
ณ 
ณ  Source:
ณ  -------
ณ  S_BDELIM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function browsedelim(cFile,aDesc,aTypes,aLens,cFieldDel,cCharDel)
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
cFieldDel := iif(cFieldDel#nil,cfieldDel,",")
cCharDel := iif(cCharDel#nil,cCharDel,["])

cInscreen := makebox(nTop,nLeft,nBottom,nRight,sls_normcol())
@nTop,nLeft+1 say "[Delimited file Browse]"
@nBottom-2,nLeft+1 to nBottom-2,nRight-1
@nBottom-1,nLeft+1 say " [] [] [] []  [ESCAPE or ENTER]=done"

oTb := tbrowsenew(nTop+1,nLeft+1,nBottom-3,nRight-1)
for i = 1 to len(aTypes)
  oTb:addcolumn(tbcolumnnew(aDesc[i],;
                bdmakeb(i,aTypes,aLens,cFieldDel,cCharDel,nHandle) ))
next

oTb:skipblock     := {|n|bd_tskip(n,nHandle)}
oTb:gotopblock    := {||bd_ftop(nHandle)}
oTb:gobottomblock := {||bd_fbot(nHandle)}
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
static function isfeof(nHandle)
local nOldPos := FSEEK(nHandle,0,1)
local lEof := (fseek(nHandle,0,2)==nOldPos)
fseek(nHandle,nOldPos)
return lEof

//--------------------------------------------------------------------------
static FUNCTION bd_fbot(nHandle)
FSEEK(nHandle,0,2)
RETURN ''


//--------------------------------------------------------------------------
static FUNCTION bd_ftop(nHandle)
FSEEK(nHandle,0)
RETURN ''

//--------------------------------------------------------------
static function bd_tskip(n,nHandle)
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
static function bdmakeb(i,aTypes,aLens,cFieldDel,cCharDel,nHandle)
local bBlock
do case
case aTypes[i]=="C"
  bBlock := {||RemoveC(padr(takeout(sfreadline(nHandle),cFieldDel,i),aLens[i]),cCharDel)  }
case aTypes[i]=="N"
  bBlock := {||padl(takeout(sfreadline(nHandle),cFieldDel,i),aLens[i]) }
case aTypes[i]=="D"
  bBlock := {||stod(takeout(sfreadline(nHandle),cFieldDel,i)) }
case aTypes[i]=="L"
  bBlock := {||iif(takeout(sfreadline(nHandle),cFieldDel,i)=="T",.t.,.f.) }
endcase
return bBlock

//--------------------------------------------------------------------------
static function removeC(cStr,cKill)
return strtran(cStr,cKill,'')


