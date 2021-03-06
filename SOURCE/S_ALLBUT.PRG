/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ALLBUT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ALLBUT() Returns all but last x characters
³ 
³  Returns:
³  --------
³  <cAllBut> => All but last n characters
³ 
³  Syntax:
³  -------
³  ALLBUT(cInString,nAllBut)
³ 
³  Description:
³  ------------
³  Returns all but the rightmost <nAllbutt> letters of
³  <cInString>
³ 
³  Examples:
³  ---------
³ 
³   string := "SUPERFUNCTION"
³   string := ALLBUT(string,8)    //  => returns  "SUPER"
³ 
³  Notes:
³  -------
³  Useful when you don't know the length of a string in
³  order to take left(x) characters.
³ 
³  Source:
³  -------
³  S_ALLBUT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION allbut(cInstring,nAllbut)
RETURN LEFT(cInstring,(LEN(cInstring) -nAllbut))
