/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION WOYEAR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  WOYEAR() Calculates week of the year (# of 7 day periods)
³ 
³  Returns:
³  --------
³  <nWeek> => week of the year of date
³ 
³  Syntax:
³  -------
³  WOYEAR(dDate)
³ 
³  Description:
³  ------------
³  Calculates number of 7 day periods passed for the
³  year from <dDate>
³ 
³  Examples:
³  ---------
³   dDate    := ctod("10/15/90")
³ 
³   nWoYear  := WOYEAR(dDate)
³ 
³   // (returns 40)
³ 
³  Source:
³  -------
³  S_WOYEAR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION woyear(dDate)
local nDayOfYear := DOYEAR(dDate)
RETURN INT(nDayOfYear/7)+IIF(nDayOfYear%7>0,1,0)
