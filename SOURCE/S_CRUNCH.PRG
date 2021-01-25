/*
�����������������������������������������������������������������
� FUNCTION CRUNCH()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CRUNCH() Moves spaces in a string to end of string
� 
�  Returns:
�  --------
�  <cCrunched> string with spaces moved to end
� 
�  Syntax:
�  -------
�  CRUNCH(cOriginal,nAllor1)
� 
�  Description:
�  ------------
�  Moves spaces to end of string <cOriginal>. If
�  <nAllor1> = 1, moves all but single spaces to right end of the
�  string. If <nAllor1> = 0 moves all spaces to the right end.
� 
�  Examples:
�  ---------
� 
�  cString := "SUPER    Library version 2.50"
� 
�  cString := CRUNCH(cString,1) // "SUPER Library version 2.50  "
� 
�  cString := CRUNCH(cString,0) // "SUPERLibraryversion2.50     "
� 
�  Notes:
�  -------
�  Handy for names (i.e. FIRST and LAST)
� 
�  Source:
�  -------
�  S_CRUNCH.PRG
� 
����������������������������������������������������������������� 
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
