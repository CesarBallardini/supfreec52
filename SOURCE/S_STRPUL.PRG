/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STRPULL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STRPULL() Extract text between 2 characters in a string
ณ 
ณ  Returns:
ณ  --------
ณ  <cExtract> => text extracted
ณ 
ณ  Syntax:
ณ  -------
ณ  STRPULL(cSource,cDelim1,cDelim2)
ณ 
ณ  Description:
ณ  ------------
ณ  Extracts text from <cSource> between characters
ณ  <cDelim1> and <cDelim2>.
ณ 
ณ  If <cDelim1> is empty, uses beginning of <cSource>.
ณ 
ณ  If <cDelim2> is empty, uses end of <cSource>.
ณ 
ณ  Examples:
ณ  ---------
ณ   cString := "SUPERFUNCTION"
ณ 
ณ   cString := STRPULL(cString,'E','C')
ณ 
ณ   // (returns "RFUN")
ณ 
ณ  Source:
ณ  -------
ณ  S_STRPUL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION strpull(cInString,cDelim1,cDelim2)
local cOutString,nAt1,nAt2
IF EMPTY(cDelim1) .AND. !(" "==cDelim1)
  cInString := "ฑ"+cInString
  cDelim1   := "ฑ"
ENDIF
IF EMPTY(cDelim2) .AND. !(" "==cDelim2)
  cInString := cInString+"ฒ"
  cDelim2   := "ฒ"
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

