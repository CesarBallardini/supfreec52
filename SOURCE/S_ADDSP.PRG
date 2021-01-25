/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ADDSPACE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ADDSPACE() Pads right of string with spaces
ณ 
ณ  Returns:
ณ  --------
ณ  <cPaddedString> => String padded with spaces.
ณ 
ณ  Syntax:
ณ  -------
ณ  ADDSPACE(cInString,nPadSpaces)
ณ 
ณ  Description:
ณ  ------------
ณ  Pads right side of <cInString> with <nPadSpaces> spaces.
ณ 
ณ  Truncates string if <nPadSpaces> is shorter than
ณ  original string length.
ณ 
ณ  Examples:
ณ  ---------
ณ   ADDSPACE("GARRY",10)     // => "GARRY           "
ณ 
ณ  Notes:
ณ  -------
ณ  For compatibility. In Clipper 5.x , the function
ณ  PADR() does the same thing.
ณ 
ณ  Source:
ณ  -------
ณ  S_ADDSP.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION addspace(cString,nDesiredLength)
nDesiredLength := iif(nDesiredLength#nil,nDesiredLength,len(cString) )
RETURN SUBST(cString+REPL(' ',nDesiredLength-LEN(cString)),1,nDesiredLength)

