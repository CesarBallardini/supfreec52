/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ALLBUT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ALLBUT() Returns all but last x characters
ณ 
ณ  Returns:
ณ  --------
ณ  <cAllBut> => All but last n characters
ณ 
ณ  Syntax:
ณ  -------
ณ  ALLBUT(cInString,nAllBut)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns all but the rightmost <nAllbutt> letters of
ณ  <cInString>
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   string := "SUPERFUNCTION"
ณ   string := ALLBUT(string,8)    //  => returns  "SUPER"
ณ 
ณ  Notes:
ณ  -------
ณ  Useful when you don't know the length of a string in
ณ  order to take left(x) characters.
ณ 
ณ  Source:
ณ  -------
ณ  S_ALLBUT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION allbut(cInstring,nAllbut)
RETURN LEFT(cInstring,(LEN(cInstring) -nAllbut))
