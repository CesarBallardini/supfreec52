/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CRUNCH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CRUNCH() Moves spaces in a string to end of string
ณ 
ณ  Returns:
ณ  --------
ณ  <cCrunched> string with spaces moved to end
ณ 
ณ  Syntax:
ณ  -------
ณ  CRUNCH(cOriginal,nAllor1)
ณ 
ณ  Description:
ณ  ------------
ณ  Moves spaces to end of string <cOriginal>. If
ณ  <nAllor1> = 1, moves all but single spaces to right end of the
ณ  string. If <nAllor1> = 0 moves all spaces to the right end.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  cString := "SUPER    Library version 2.50"
ณ 
ณ  cString := CRUNCH(cString,1) // "SUPER Library version 2.50  "
ณ 
ณ  cString := CRUNCH(cString,0) // "SUPERLibraryversion2.50     "
ณ 
ณ  Notes:
ณ  -------
ณ  Handy for names (i.e. FIRST and LAST)
ณ 
ณ  Source:
ณ  -------
ณ  S_CRUNCH.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION crunch(cInstring,nAllorSingle)
local nIterator
local nStringLen := LEN(cInstring)
cInstring        := Alltrim(cInstring)
IF nAllorSingle = 0 // crunch out all spaces
  cInstring := STRTRAN(cInstring," ","")
ELSE  // crunch out all but single spaces
  DO WHILE SPACE(2)$cInstring
    cInstring := STRTRAN(cInstring,SPACE(2),SPACE(1))
  ENDDO
ENDIF
RETURN padr(cInstring,nStringLen)

