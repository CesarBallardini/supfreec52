/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SETEXACT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SETEXACT() Determines if exact is on/off
ณ 
ณ  Returns:
ณ  --------
ณ  <lExact> => Exact is on/off
ณ 
ณ  Syntax:
ณ  -------
ณ  SETEXACT([lNew])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns current SET EXACT setting and optionally sets
ณ  exact on/off with [lNew]  .t. = ON .f. = OFF
ณ 
ณ  Examples:
ณ  ---------
ณ   nOldexact = SETEXACT(.f.) // SET EXACT OFF
ณ 
ณ   * code
ณ 
ณ   SETEXACT(nOldexact)
ณ 
ณ  Source:
ณ  -------
ณ  S_SETEX.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SETEXACT(lExact)
return SET(_SET_EXACT,lExact)
