/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION RJUST()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  RJUST() Right justifies a string
³ 
³  Returns:
³  --------
³  <cJustified> => string right justified
³ 
³  Syntax:
³  -------
³  RJUST(cTarget)
³ 
³  Description:
³  ------------
³  Right justifies <cTarget>
³ 
³  Examples:
³  ---------
³   string        := "Superfunction      "
³ 
³   string        := RJUST(string)
³ 
³   // (returns       "      Superfunction"
³ 
³  Source:
³  -------
³  S_RJUST.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION Rjust(cInstring)
return PADL(alltrim(cInstring),len(cInString) )
