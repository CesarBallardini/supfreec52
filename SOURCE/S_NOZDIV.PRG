/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION NOZDIV()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  NOZDIV() Prevents divide-by-zero
ณ 
ณ  Returns:
ณ  --------
ณ  <nNumber> => division result
ณ 
ณ  Syntax:
ณ  -------
ณ  NOZDIV(nNumber)
ณ 
ณ  Description:
ณ  ------------
ณ  Prevents divide-by-zero by converting a number to 1
ณ  if it is zero, otherwise leaving it as-is.
ณ 
ณ  Not really needed in 5.01, but here for backward
ณ  compatibility.
ณ 
ณ  Examples:
ณ  ---------
ณ   x = 5
ณ   y = 0
ณ 
ณ   z = x/NOZDIV(y)
ณ 
ณ  Source:
ณ  -------
ณ  S_NOZDIV.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION NOZDIV(nValue)
RETURN IIF(nValue=0,1,nValue)
