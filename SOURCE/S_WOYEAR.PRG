/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION WOYEAR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  WOYEAR() Calculates week of the year (# of 7 day periods)
ณ 
ณ  Returns:
ณ  --------
ณ  <nWeek> => week of the year of date
ณ 
ณ  Syntax:
ณ  -------
ณ  WOYEAR(dDate)
ณ 
ณ  Description:
ณ  ------------
ณ  Calculates number of 7 day periods passed for the
ณ  year from <dDate>
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate    := ctod("10/15/90")
ณ 
ณ   nWoYear  := WOYEAR(dDate)
ณ 
ณ   // (returns 40)
ณ 
ณ  Source:
ณ  -------
ณ  S_WOYEAR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION woyear(dDate)
local nDayOfYear := DOYEAR(dDate)
RETURN INT(nDayOfYear/7)+IIF(nDayOfYear%7>0,1,0)
