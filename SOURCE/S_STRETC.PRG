/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STRETCH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STRETCH() Imbeds characters in a string
ณ 
ณ  Returns:
ณ  --------
ณ  <cStretched> => string with characters imbedded
ณ 
ณ  Syntax:
ณ  -------
ณ  STRETCH(cSource,cFill,nEvery)
ณ 
ณ  Description:
ณ  ------------
ณ  Imbeds character <cFill> in string <cSource> every
ณ  <nEvery> character
ณ 
ณ  Examples:
ณ  ---------
ณ   cString := "SUPERFUNCTION"
ณ 
ณ   cString := STRETCH(cString,' ',1)
ณ 
ณ   // (returns "S U P E R F U N C T I O N")
ณ 
ณ  Notes:
ณ  -------
ณ  This hombre might be called EXPAND in other parts
ณ 
ณ  Source:
ณ  -------
ณ  S_STRETC.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION stretch(cInString,cImbedChar,nFrequency)
local nIter,nLenString,cOutString
cOutString := ''
nLenString := LEN(cInString)
for nIter = 1 TO nLenString-nFrequency STEP nFrequency
  cOutString += ( SUBST(cInString,nIter,nFrequency)+cImbedChar )
NEXT
cOutString += ( SUBST(cInString,nIter) )
RETURN cOutString
