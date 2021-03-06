/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ONE_READ()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ONE_READ() Pop-up window with 1-4 Say/Get combinations
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  ONE_READ(cSay,cGetName,cPicture,...)
³ 
³  Description:
³  ------------
³  For 1-4 iterations of <cSay..cPicture>, a popup
³  window will display a Say <cSay>, do a Get on the variable named in
³  <cGetNAme> with a Picture of <cPicture>. A read will then be
³  issued.
³ 
³  This is here for compatibility. POPREAD() provides a
³  cleaner solution.
³ 
³  NOTE: the variables named in <cGetName> CANNOT be
³  local or static.
³ 
³  Examples:
³  ---------
³   dDate := date()
³   cTime := space(8)
³   lFun  := .t.
³ 
³   ONE_READ("Current Date","dDATE","@D",;
³       "Current Time","cTIME","99:99:99",;
³       "Having Fun ?","lFUN","Y")
³ 
³  Notes:
³  -------
³  This is here only for compatibility with older
³  versions. Next release, it will cease to be.
³ 
³  See POPREAD() for a better implementation.
³ 
³  Source:
³  -------
³  S_ONER.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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



