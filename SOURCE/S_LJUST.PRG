
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION LJUST()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  LJUST() Left justifies a string
ณ 
ณ  Returns:
ณ  --------
ณ  <cJustified> => string left justified
ณ 
ณ  Syntax:
ณ  -------
ณ  LJUST(cTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Left justifies <cTarget>
ณ 
ณ  Examples:
ณ  ---------
ณ   string = "      Superfunction"
ณ 
ณ   string = LJUST(string)
ณ 
ณ   // (returns "Superfunction    "
ณ 
ณ  Source:
ณ  -------
ณ  S_LJUST.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION Ljust(cString)
RETURN padr(ALLTRIM(cString),LEN(cString))
