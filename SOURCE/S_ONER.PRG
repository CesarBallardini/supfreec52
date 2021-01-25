/*
�����������������������������������������������������������������
� FUNCTION ONE_READ()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ONE_READ() Pop-up window with 1-4 Say/Get combinations
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  ONE_READ(cSay,cGetName,cPicture,...)
� 
�  Description:
�  ------------
�  For 1-4 iterations of <cSay..cPicture>, a popup
�  window will display a Say <cSay>, do a Get on the variable named in
�  <cGetNAme> with a Picture of <cPicture>. A read will then be
�  issued.
� 
�  This is here for compatibility. POPREAD() provides a
�  cleaner solution.
� 
�  NOTE: the variables named in <cGetName> CANNOT be
�  local or static.
� 
�  Examples:
�  ---------
�   dDate := date()
�   cTime := space(8)
�   lFun  := .t.
� 
�   ONE_READ("Current Date","dDATE","@D",;
�       "Current Time","cTIME","99:99:99",;
�       "Having Fun ?","lFUN","Y")
� 
�  Notes:
�  -------
�  This is here only for compatibility with older
�  versions. Next release, it will cease to be.
� 
�  See POPREAD() for a better implementation.
� 
�  Source:
�  -------
�  S_ONER.PRG
� 
����������������������������������������������������������������� 
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


