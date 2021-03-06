
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION LJUST()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  LJUST() Left justifies a string
³ 
³  Returns:
³  --------
³  <cJustified> => string left justified
³ 
³  Syntax:
³  -------
³  LJUST(cTarget)
³ 
³  Description:
³  ------------
³  Left justifies <cTarget>
³ 
³  Examples:
³  ---------
³   string = "      Superfunction"
³ 
³   string = LJUST(string)
³ 
³   // (returns "Superfunction    "
³ 
³  Source:
³  -------
³  S_LJUST.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION Ljust(cString)
RETURN padr(ALLTRIM(cString),LEN(cString))
