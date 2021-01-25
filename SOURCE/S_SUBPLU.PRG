/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SUBPLUS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SUBPLUS() Returns multiple substrings
ณ 
ณ  Returns:
ณ  --------
ณ  <cSubs> => new string from multiple substrings
ณ 
ณ  Syntax:
ณ  -------
ณ  SUBPLUS(cSource,<nStart1,nCount1>,...[nStart8,nCount8])
ณ 
ณ  Description:
ณ  ------------
ณ  Extracts from string <cSource> from position
ณ  <nStart1> for <nCount1>
ณ 
ณ  characters, and repeats for sets
ณ  [nStart2-nCount2...nStart8-nCount8]
ณ 
ณ  Examples:
ณ  ---------
ณ   cString := "PREFONTAINE"
ณ 
ณ   cGarble := SUBPLUS(cString,6,1,5,1,1,1,3,1)
ณ 
ณ   // garble  =  "NOPE"
ณ 
ณ  Source:
ณ  -------
ณ  S_SUBPLU.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION subplus(cInstring,nStart1,nChars1,nStart2,nChars2,;
                 nStart3,nChars3,nStart4,nChars4)
local nIter
local cOutString := ''
IF nStart1#nil .and. nChars1#nil
  cOutString += ( SUBST(cInstring,nStart1,nChars1))
ENDIF
IF nStart2#nil .and. nChars2#nil
  cOutString += ( SUBST(cInstring,nStart2,nChars2))
ENDIF
IF nStart3#nil .and. nChars3#nil
  cOutString += (SUBST(cInstring,nStart3,nChars3))
ENDIF
IF nStart4#nil .and. nChars4#nil
  cOutString += ( SUBST(cInstring,nStart4,nChars4))
ENDIF
RETURN cOutString
*: EOF: S_SUBPLU.PRG
