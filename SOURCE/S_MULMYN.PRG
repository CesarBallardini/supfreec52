
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MULTIMSGYN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MULTIMSGYN()          Multi-line popup message - yes -no
ณ 
ณ  Returns:
ณ  --------
ณ  <lYesNo> => True or False for yes or no
ณ 
ณ  Syntax:
ณ  -------
ณ  MULTIMSGYN(aMsgs,[cYes,[cNo],[cColor],[cTitle],[lCenter],[nTop,nLeft])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a multi-line message contained in array
ณ  <aMsgs> and prompts for a Yes or No. Returns <lYesNo> based on
ณ  response.
ณ 
ณ  Each element of the array may be of type CNDL.
ณ 
ณ  [cYes]  Yes prompt - default is "Yes"
ณ 
ณ  [cNo]   No prompt - default is "No"
ณ 
ณ  [cColor]  popup color- default is sls_popcol()
ณ 
ณ  [cTitle] string to display at box top - default is
ณ  none
ณ 
ณ  [lCenter]  center the messages in the box (each line
ณ  centered) - default is no - left justified.
ณ 
ณ  [nTop,nLeft]  popup box top and left. Default is
ณ  centered on the screen.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?multimsgyn({"Would you really like","to fly?"},"Sure","Nope")
ณ   ?multimsgyn({"Is it ",date()+1,"yet?"},"Sure","Nope",;
ณ         "N/W","There yet")
ณ 
ณ   ?multimsgyn({"Start with",nStart,"End with",nEnd},;
ณ         nil,nil,,nil,nil,.t.,10,10)
ณ 
ณ  Source:
ณ  -------
ณ  S_MULMYN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION MULTIMSGYN(aMsgs,cYes,cNo,cColor,cTitle,lCenter,nTop,nLeft)
local cBox,oTb,nMouseR, nMouseC
local nMessage := 1
local nLongest
local nLastKey
local aPrompts
local cHi,cLo
local nYesNo := 1
local nOldYN := 2
local nBottom,nRight
local nCursor := SETCURSOR(0)
local nRow := row(), nCol := col()
if aMsgs#nil .and. valtype(aMsgs)=="A"
  cColor  := iif(cColor#nil,cColor,sls_popcol())
  cLo     := takeout(cColor,",",1)
  cHi     := takeout(cColor,",",2)
  cTitle  := iif(cTitle#nil,cTitle,"")
  lCenter := iif(lCenter#nil,lCenter,.f.)
  cYes    := iif(cYes#nil,cYes,"Yes")
  cNo     := iif(cNo #nil,cNo ,"No ")

  nLongest := dodim(@nTop,@nLeft,@nBottom,@nRight,aMsgs,cYes,cNo)

  nLongest := MAX(nLongest,sbcols(nLeft,nRight,.f.))

  aPrompts := getprompts(cYes,cNo,nLeft,nRight)

  cBox := makebox(nTop,nLeft,nBottom,nRight,cColor)

  @nTop,nLeft+1 say ctitle

  oTb  := tbrowsenew(nTop+1,nLeft+1,nBottom-2,nRight-1)
  if lCenter
    oTb:addcolumn(tbcolumnNew(nil,{||ampadc(aMsgs[nMessage],nLongest)}))
  else
    oTb:addcolumn(tbcolumNnew(nil,{||ampadr(aMsgs[nMessage],nLongest)}))
  endif
  oTb:skipblock := {|n|aaskip(n,@nMessage,len(aMsgs))}
  oTb:colorspec := cLo+","+cLo
  while .t.
     dispbegin()
     @nBottom-1,aPrompts[nOldYN,1] say aPrompts[nOldYN,2] color cLo
     nOldYn := nYesNo
     while !oTb:stabilize()
     end
     @nBottom-1,aPrompts[nYesNo,1] say aPrompts[nYesNo,2] color cHi
     dispend()
     nLastKey := rat_event(0)
     nMouseR  := rat_eqmrow()
     nMouseC  := rat_eqmcol()
     do case
     case nLastkey == K_UP
       oTb:up()
     case nLastkey == K_DOWN
       oTb:down()
     case nLastkey == K_LEFT .or. nLastKey == K_RIGHT .or. ;
          nLastkey==K_TAB .or. nLAstKey == K_SH_TAB
       nYesNo := iif(nYesNo == 1,2,1)
     case nLastKey == K_ENTER
       exit
     case nLastKey == K_ESC
       nYesNo := 0
       exit
     case upper(chr(nLastkey))==upper(left(cYes,1))
        nYesno := 1
        exit
     case upper(chr(nLastkey))==upper(left(cNo,1))
        nYesno  := 0
        exit
     case nLastkey==K_MOUSELEFT .and. nMouseR==nBottom-1
        do case
        case nMouseC >=aPrompts[1,1] .and. ;
             nMouseC <= (aPrompts[1,1]+len(aPrompts[1,2])-1)
             nYesno := 1
             exit
        case nMouseC >=aPrompts[2,1] .and. ;
             nMouseC <= (aPrompts[2,1]+len(aPrompts[2,2])-1)
             nYesno := 2
             exit
        endcase
     endcase
  end
  unbox(cBox)
endif

setcursor(nCursor)
devpos(nRow,nCol)
return (nYesNo == 1)

//--------------------------------------------------------------
static function dodim(nTop,nLeft,nBottom,nRight,aMsgs,cYes,cNo)
local nLongest := findbigest(aMsgs)
nLongest := max(nLongest,len(cYes+cNo)+1)
if nTop==nil.or.nLeft==Nil
  nTop     := 0
  nLeft    := 0
  nBottom  := min(len(aMsgs)+3,maxrow())
  nRight   := min(nLongest+2,maxcol())
  sbcenter(@nTop,@nLeft,@nBottom,@nRight)
else
  nBottom  := nTop+min(len(aMsgs)+3,maxrow())
  nRight   := nLeft+min(nLongest+2,maxcol())
endif
return nLongest

//--------------------------------------------------------------
static function findbigest(aMsgs)
local aBiggest := 0
local i
local cValtype
for i = 1 to len(aMsgs)
  cValtype := valtype(aMsgs[i])
  aBiggest := max(aBiggest,len(trans(aMsgs[i],"")))
next
return aBiggest

//--------------------------------------------------------------
static function ampadc(expVar,nWidth)
if valtype(expVar)=="L"
  return PADC(IIF(expVar,"Yes","No"),nWidth)
else
  return PADC(expVar,nWidth)
endif
return nil

//--------------------------------------------------------------
static function ampadr(expVar,nWidth)
if valtype(expVar)=="L"
  return PADR(IIF(expVar,"Yes","No"),nWidth)
else
  return PADR(expVar,nWidth)
endif
return nil

//--------------------------------------------------------------
static function getprompts(cYes,cNo,nLeft,nRight)
local nCols    := nRight-nLeft-1
local nPadding := INT((nCols-len(cYes+cNo))/3)
return {{nLeft+nPadding+1,cYes},{nLeft+nPadding+1+len(cYes)+nPadding+1,cNo}}


