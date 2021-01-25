/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION WOMONTH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  WOMONTH() Calculates week of the month (# of 7 day periods)
ณ 
ณ  Returns:
ณ  --------
ณ  <nWeek> => week of the month
ณ 
ณ  Syntax:
ณ  -------
ณ  WOMONTH(dDate)
ณ 
ณ  Description:
ณ  ------------
ณ  Calculates current number of 7 day periods for the
ณ  month from <dDate>
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate := ctod("10/15/90")
ณ 
ณ   nDom  := WOMONTH(dDate)
ณ 
ณ   // (returns 3)
ณ 
ณ  Source:
ณ  -------
ณ  S_WOMON.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION womonth(dDate)
local nDayOfMonth := DAY(dDate)
RETURN INT(nDayOfMonth/7)+IIF(nDayOfMonth%7>0,1,0)
