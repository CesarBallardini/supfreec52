/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RJUST()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  RJUST() Right justifies a string
ณ 
ณ  Returns:
ณ  --------
ณ  <cJustified> => string right justified
ณ 
ณ  Syntax:
ณ  -------
ณ  RJUST(cTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Right justifies <cTarget>
ณ 
ณ  Examples:
ณ  ---------
ณ   string        := "Superfunction      "
ณ 
ณ   string        := RJUST(string)
ณ 
ณ   // (returns       "      Superfunction"
ณ 
ณ  Source:
ณ  -------
ณ  S_RJUST.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION Rjust(cInstring)
return PADL(alltrim(cInstring),len(cInString) )
