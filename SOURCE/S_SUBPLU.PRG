/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SUBPLUS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SUBPLUS() Returns multiple substrings
³ 
³  Returns:
³  --------
³  <cSubs> => new string from multiple substrings
³ 
³  Syntax:
³  -------
³  SUBPLUS(cSource,<nStart1,nCount1>,...[nStart8,nCount8])
³ 
³  Description:
³  ------------
³  Extracts from string <cSource> from position
³  <nStart1> for <nCount1>
³ 
³  characters, and repeats for sets
³  [nStart2-nCount2...nStart8-nCount8]
³ 
³  Examples:
³  ---------
³   cString := "PREFONTAINE"
³ 
³   cGarble := SUBPLUS(cString,6,1,5,1,1,1,3,1)
³ 
³   // garble  =  "NOPE"
³ 
³  Source:
³  -------
³  S_SUBPLU.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
