/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ADDSPACE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ADDSPACE() Pads right of string with spaces
³ 
³  Returns:
³  --------
³  <cPaddedString> => String padded with spaces.
³ 
³  Syntax:
³  -------
³  ADDSPACE(cInString,nPadSpaces)
³ 
³  Description:
³  ------------
³  Pads right side of <cInString> with <nPadSpaces> spaces.
³ 
³  Truncates string if <nPadSpaces> is shorter than
³  original string length.
³ 
³  Examples:
³  ---------
³   ADDSPACE("GARRY",10)     // => "GARRY           "
³ 
³  Notes:
³  -------
³  For compatibility. In Clipper 5.x , the function
³  PADR() does the same thing.
³ 
³  Source:
³  -------
³  S_ADDSP.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION addspace(cString,nDesiredLength)
nDesiredLength := iif(nDesiredLength#nil,nDesiredLength,len(cString) )
RETURN SUBST(cString+REPL(' ',nDesiredLength-LEN(cString)),1,nDesiredLength)

