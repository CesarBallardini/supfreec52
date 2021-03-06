/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION STRETCH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  STRETCH() Imbeds characters in a string
³ 
³  Returns:
³  --------
³  <cStretched> => string with characters imbedded
³ 
³  Syntax:
³  -------
³  STRETCH(cSource,cFill,nEvery)
³ 
³  Description:
³  ------------
³  Imbeds character <cFill> in string <cSource> every
³  <nEvery> character
³ 
³  Examples:
³  ---------
³   cString := "SUPERFUNCTION"
³ 
³   cString := STRETCH(cString,' ',1)
³ 
³   // (returns "S U P E R F U N C T I O N")
³ 
³  Notes:
³  -------
³  This hombre might be called EXPAND in other parts
³ 
³  Source:
³  -------
³  S_STRETC.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
