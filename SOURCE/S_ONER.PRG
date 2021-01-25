/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ONE_READ()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ONE_READ() Pop-up window with 1-4 Say/Get combinations
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  ONE_READ(cSay,cGetName,cPicture,...)
ณ 
ณ  Description:
ณ  ------------
ณ  For 1-4 iterations of <cSay..cPicture>, a popup
ณ  window will display a Say <cSay>, do a Get on the variable named in
ณ  <cGetNAme> with a Picture of <cPicture>. A read will then be
ณ  issued.
ณ 
ณ  This is here for compatibility. POPREAD() provides a
ณ  cleaner solution.
ณ 
ณ  NOTE: the variables named in <cGetName> CANNOT be
ณ  local or static.
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate := date()
ณ   cTime := space(8)
ณ   lFun  := .t.
ณ 
ณ   ONE_READ("Current Date","dDATE","@D",;
ณ       "Current Time","cTIME","99:99:99",;
ณ       "Having Fun ?","lFUN","Y")
ณ 
ณ  Notes:
ณ  -------
ณ  This is here only for compatibility with older
ณ  versions. Next release, it will cease to be.
ณ 
ณ  See POPREAD() for a better implementation.
ณ 
ณ  Source:
ณ  -------
ณ  S_ONER.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION one_read(cM1,cV1,cP1,cM2,cV2,cP2,cM3,cV3,cP3,cM4,cV4,cP4)
LOCAL aParams := { {cM1,cV1,cP1},{cM2,cV2,cP2},{cM3,cV3,cP3},{cM4,cV4,cP4} }
LOCAL nTop:=0,nLeft:=0
LOCAL nBottom,nRight
LOCAL nLength, nDepth
LOCAL i,cBox
LOCAL nOldCursor
LOCAL cMacro
local getlist := {}

asize(aParams,INT(pcount()/3) )
nRight  := 20
nBottom := len(aParams)+2

for i = 1 to len(aParams)
  nRight  := max(nRight ,len(aParams[i,1])+2)
  nRight  := max(nRight ,len(trans(&( aParams[i,2]),aParams[i,3] ))+2)
next
nRight  := min(nRight ,78)

sbcenter(@nTop,@nLeft,@nBottom,@nRight)

cBox := makebox(nTop,nLeft,nBottom,nRight,sls_popcol() )
nOldCursor := setcursor(1)

FOR i = 1 to len(aParams)
  cMacro := aParams[i,2]
  @nTop+i,nLeft+1 say aParams[i,1] get &cMacro picture aParams[i,3]
NEXT
RAT_READ(getlist)

SETCURSOR(nOldCursor)
unbox(cbox)
RETURN ''



