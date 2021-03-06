/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DAYSIN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DAYSIN() Calculates number of days in a month
³ 
³  Returns:
³  --------
³  <nDays> => days in month of target date
³ 
³  Syntax:
³  -------
³  DAYSIN(dTarget)
³ 
³  Description:
³  ------------
³  Returns # of days in month in which <dTarget> falls
³ 
³  Examples:
³  ---------
³   dDate    := ctod("10/15/89")
³ 
³   nDimonth := DAYSIN(dDate)  // (returns 31)
³ 
³  Source:
³  -------
³  S_DAYSIN.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION daysin(dInDate)
local nReturn
local nMonth  := month(dInDate)
local nYear   := year(dInDate)
if nMonth=2  // february, check for leap year
  if (nYear%4=0 .and. nYear%100#0).or. (nYear%400=0)  && leap year
    nReturn := 29
  else
    nReturn := 28
  endif
else
  nReturn   :=  {31,28,31,30,31,30,31,31,30,31,30,31}[nMonth]
endif
return nReturn
