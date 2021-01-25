/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DAYSIN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DAYSIN() Calculates number of days in a month
ณ 
ณ  Returns:
ณ  --------
ณ  <nDays> => days in month of target date
ณ 
ณ  Syntax:
ณ  -------
ณ  DAYSIN(dTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns # of days in month in which <dTarget> falls
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate    := ctod("10/15/89")
ณ 
ณ   nDimonth := DAYSIN(dDate)  // (returns 31)
ณ 
ณ  Source:
ณ  -------
ณ  S_DAYSIN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
