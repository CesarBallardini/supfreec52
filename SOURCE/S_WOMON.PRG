/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION WOMONTH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  WOMONTH() Calculates week of the month (# of 7 day periods)
³ 
³  Returns:
³  --------
³  <nWeek> => week of the month
³ 
³  Syntax:
³  -------
³  WOMONTH(dDate)
³ 
³  Description:
³  ------------
³  Calculates current number of 7 day periods for the
³  month from <dDate>
³ 
³  Examples:
³  ---------
³   dDate := ctod("10/15/90")
³ 
³   nDom  := WOMONTH(dDate)
³ 
³   // (returns 3)
³ 
³  Source:
³  -------
³  S_WOMON.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION womonth(dDate)
local nDayOfMonth := DAY(dDate)
RETURN INT(nDayOfMonth/7)+IIF(nDayOfMonth%7>0,1,0)
