/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION NOZDIV()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  NOZDIV() Prevents divide-by-zero
³ 
³  Returns:
³  --------
³  <nNumber> => division result
³ 
³  Syntax:
³  -------
³  NOZDIV(nNumber)
³ 
³  Description:
³  ------------
³  Prevents divide-by-zero by converting a number to 1
³  if it is zero, otherwise leaving it as-is.
³ 
³  Not really needed in 5.01, but here for backward
³  compatibility.
³ 
³  Examples:
³  ---------
³   x = 5
³   y = 0
³ 
³   z = x/NOZDIV(y)
³ 
³  Source:
³  -------
³  S_NOZDIV.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION NOZDIV(nValue)
RETURN IIF(nValue=0,1,nValue)
