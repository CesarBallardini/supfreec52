/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CRUNCH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CRUNCH() Moves spaces in a string to end of string
³ 
³  Returns:
³  --------
³  <cCrunched> string with spaces moved to end
³ 
³  Syntax:
³  -------
³  CRUNCH(cOriginal,nAllor1)
³ 
³  Description:
³  ------------
³  Moves spaces to end of string <cOriginal>. If
³  <nAllor1> = 1, moves all but single spaces to right end of the
³  string. If <nAllor1> = 0 moves all spaces to the right end.
³ 
³  Examples:
³  ---------
³ 
³  cString := "SUPER    Library version 2.50"
³ 
³  cString := CRUNCH(cString,1) // "SUPER Library version 2.50  "
³ 
³  cString := CRUNCH(cString,0) // "SUPERLibraryversion2.50     "
³ 
³  Notes:
³  -------
³  Handy for names (i.e. FIRST and LAST)
³ 
³  Source:
³  -------
³  S_CRUNCH.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

