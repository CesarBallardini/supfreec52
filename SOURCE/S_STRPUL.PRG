/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION STRPULL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  STRPULL() Extract text between 2 characters in a string
³ 
³  Returns:
³  --------
³  <cExtract> => text extracted
³ 
³  Syntax:
³  -------
³  STRPULL(cSource,cDelim1,cDelim2)
³ 
³  Description:
³  ------------
³  Extracts text from <cSource> between characters
³  <cDelim1> and <cDelim2>.
³ 
³  If <cDelim1> is empty, uses beginning of <cSource>.
³ 
³  If <cDelim2> is empty, uses end of <cSource>.
³ 
³  Examples:
³  ---------
³   cString := "SUPERFUNCTION"
³ 
³   cString := STRPULL(cString,'E','C')
³ 
³   // (returns "RFUN")
³ 
³  Source:
³  -------
³  S_STRPUL.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION strpull(cInString,cDelim1,cDelim2)
local cOutString,nAt1,nAt2
IF EMPTY(cDelim1) .AND. !(" "==cDelim1)
  cInString := "±"+cInString
  cDelim1   := "±"
ENDIF
IF EMPTY(cDelim2) .AND. !(" "==cDelim2)
  cInString := cInString+"²"
  cDelim2   := "²"
ENDIF
nAt1  := AT(cDelim1,cInString)
cOutString := ''
IF nAt1 > 0
  nAt1 := nAt1+len(cDelim1)
  nAt2 :=AT(cDelim2,SUBST(cInString,nAt1))
  IF nAt2 > 0
    nAt2 := nAt2+nAt1-1
    IF (nAt2-nAt1) > 0
      cOutString := SUBST(cInString,nAt1,(nAt2-nAt1))
    ENDIF
  ENDIF
ENDIF
RETURN cOutString
*: EOF: S_STRPUL.PRG

