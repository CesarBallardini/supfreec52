#include "inkey.ch"
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPREAD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPREAD() Pops up a box with 1-5 say-get combinations
³ 
³  Returns:
³  --------
³  nothing
³
³  Syntax:
³  -------
³  POPREAD(lStacked,[nTop,nLeft,cColor],cSay,@expGet,cPicture...)
³ 
³  Description:
³  ------------
³  [lStacked]   .t. = GETS are displayed below SAYS,
³               .f. = GETS are displayed beside SAYS (default)
³
³  [next 3 params may be option params - see below]
³ 
³  For 1-5 iterations of  [cSay,@expGet,cPicture]  a
³  popup window will display a Say <cSay>, do a Get on the variable
³  passed by reference in <@expGet> with a Picture of <cPicture>. A
³  read will then be issued.
³
³  If params 2,3 and 4 are passed as Numeric/Numeric/Chr
³  then they are evaluated as the top,left and color for the popup
³  box.
³
³  [nTop] = top
³  [nLeft] = left
³  [cColor] = color string
³
³  Examples:
³  ---------
³   dDate := date()
³   cTime := space(8)
³   lFun  := .t.
³ 
³   POPREAD(.t.,"Current Date",@dDATE,"@D",;
³       "Current Time",@cTIME,"99:99:99",;
³       "Having Fun ?",@lFUN,"Y")
³ 
³  Notes:
³  -------
³  This is an intelligent version of ONE_READ. 2nd param
³  is passed by reference rather than by name - cutting down
³  DRASTICALLY on the macro expansion and greatly simplifying the
³  code. To pass by reference, preface the parameter with @.
³ 
³  Source:
³  -------
³  S_POPR.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION popread(lBelow,m1,v1,p1,m2,v2,p2,m3,v3,p3,m4,v4,p4,m5,v5,p5,m6,v6,p6)
local nReadCount,nTop,nLeft,nRight,nBottom
local cThiscolor,cOldColor,nTempWidth
local nIter,string,nBoxWidth,cUnder,nPcount,nStartSays,nOldCursor
local aSets := {{m1,v1,p1,{|_1|v1:=iif(_1#nil,_1,v1)} },;
                {m2,v2,p2,{|_1|v2:=iif(_1#nil,_1,v2)} },;
                {m3,v3,p3,{|_1|v3:=iif(_1#nil,_1,v3)} },;
                {m4,v4,p4,{|_1|v4:=iif(_1#nil,_1,v4)} },;
                {m5,v5,p5,{|_1|v5:=iif(_1#nil,_1,v5)} },;
                {m6,v6,p6,{|_1|v6:=iif(_1#nil,_1,v6)} }}
local getlist := {}
local bF10 := setkey(K_F10,{||CTRLW()})

nPcount    := Pcount()-1
nStartSays   := 1
cOldColor  := Setcolor()

cThiscolor := sls_popcol()

IF VALTYPE(m1)=="N"
  nPcount    := nPcount-3
  asize(asets,nPcount)
  nTop       := m1
  nLeft      := v1
  cThiscolor := p1
  nStartSays := 2
ENDIF

nReadCount   := INT(nPcount/3)
nReadCount   := MIN(nReadCount,5)

nBoxWidth    := 4
FOR nIter = nStartSays TO nReadCount+nStartSays-1
  nTempWidth := IIF(lBelow,;
      MAX(LEN(aSets[nIter,1]),LEN(TRANS(aSets[nIter,2],aSets[nIter,3])))+2,;
      LEN(aSets[nIter,1])+LEN(TRANS(aSets[nIter,2],aSets[nIter,3]))+4)
  nBoxWidth = MAX(nBoxWidth,nTempWidth)
NEXT
nBoxWidth = MIN(nBoxWidth,75)

*- figure window dimensions
IF !(VALTYPE(nTop)+VALTYPE(nLeft)=="NN")
  IF lBelow
    nTop := INT((24-nReadCount*2)/2)-1
  ELSE
    nTop := INT((24-nReadCount)/2)-1
  ENDIF
  nLeft  := INT((79-nBoxWidth)/2)+1
ENDIF
nRight = nLeft+nBoxWidth+1
nBottom = IIF(lBelow,nTop+(nReadCount*2)+1,nTop+nReadCount+1)+3
if (nRight-nLeft-1) < 23
    nRight := nLeft+24
    sbcenter(@nTop,@nLeft,@nBottom,@nRight)
endif

*- draw window
cUnder  :=makebox(nTop,nLeft,nBottom,nRight,cThisColor)
@nBottom-2,nLeft+1 to nBottom-2,nRight-1

*- turn cursor on
nOldCursor = setcursor()
SET CURSOR ON

*- put cursor at starting position
devpos(nTop,nLeft)

*- loop through and put up says/gets/pictures , then READ
FOR nIter= nStartSays TO nReadCount+nStartSays-1
  @ROW()+1,nLeft+2 SAY aSets[nIter,1]
  IF lBelow
    @ROW()+1,nLeft+2 GET aSets[nIter,2] PICT aSets[nIter,3]
  ELSE
    @ROW(),COL()+2 GET aSets[nIter,2]  PICT aSets[nIter,3]
  ENDIF
NEXT
*READ
aeval(GetList,{|g|g:display()})
@nBottom-1,nLeft+1 say "[F10=OK] [ESC=Cancel]"
RAT_READ(Getlist,1,.f.,27,{|r,c|pr_read(r,c,nBottom-1,nLeft)})
if lastkey()<> K_ESC
 FOR nIter= nStartSays TO nReadCount+nStartSays-1
   eval(aSets[nIter,4],aSets[nIter,2])
 NEXT
ENDIF
*- put things back as they were
SETCURSOR(nOldCursor)
Setcolor(cOldColor)
unbox(cUnder)
setkey(K_F10,bF10)
RETURN ''

static function pr_read(r,c,b,l)
if r=b
  if c>=l+1 .and. c<=l+8
     keyboard chr(K_CTRL_W)
  elseif c>=l+10 .and. c <=l+21
     keyboard chr(K_ESC)
  endif
endif
RETURN NIL
