#define ISDAYS          1
#define ISWEEKS         2
#define ISMONTHS        3
#define ISYEARS         4

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DATECALC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DATECALC() Adds/subtracts days,weeks,months,years to a date
ณ 
ณ  Returns:
ณ  --------
ณ  <dNew> => new date
ณ 
ณ  Syntax:
ณ  -------
ณ  DATECALC(dStart,nUnits,nUnitType)
ณ 
ณ  Description:
ณ  ------------
ณ  <nUnits> is the number of units to add or subtract.
ณ  If negative, subtraction takes place.
ณ 
ณ  <nUnitType> is the type of unit, where 1=days ,2=wks,
ณ  3=mnths, 4=yrs
ณ 
ณ  <dStart> is the source date, to which units are added
ณ  or subtracted.
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate          := ctod("10/15/89")
ณ 
ณ   dLess5days    := DATECALC(dDate,-5,1)  // subtract 5 days
ณ   dLess5weeks   := DATECALC(dDate,-5,2)  // subtract 5 weeks
ณ   dAdd5months   := DATECALC(dDate,5,3) // add 5 months
ณ   dAdd5years    := DATECALC(dDate,5,4)  // add 5 years
ณ 
ณ  Notes:
ณ  -------
ณ  Month adding/subtracting where the day of current
ณ  month is greater than the # of days in the target month is done
ณ  by using the # of days in the target month. i.e. 01/31/90 + 1
ณ  month = 02/28/90
ณ 
ณ  If the input date is Feb 29th of a leap year, it is
ณ  adjusted to Feb 28th before month or year calculations.
ณ 
ณ  Source:
ณ  -------
ณ  S_DATCAL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION datecalc(dInDate,nAddorSubtract,nPeriodType)
LOCAL dReturn,cStringDate,nOldDate
LOCAL nTheDay,nTheMonth,nTheYear,nDaysInMonth,nTotalMonths

nOldDate = SET_DATE(1)
dReturn = dInDate
DO CASE
CASE EMPTY(dInDate)
  dReturn := dInDate
CASE nPeriodType = ISDAYS
  dReturn := dInDate + (nAddorSubtract)
CASE nPeriodType = ISWEEKS
  dReturn := dInDate + (7 * nAddorSubtract)
CASE nPeriodType = ISMONTHS
  nTheDay       := DAY(dInDate)
  nTheMonth     := MONTH(dInDate)
  nTheYear      := YEAR(dInDate)
  nTotalMonths  := (nTheYear*12)+nTheMonth+nAddorSubtract-1
  nTheYear      := INT(nTotalMonths/12)
  nTheMonth     := nTotalMonths%12+1
  nDaysInMonth  :=  {31,28,31,30,31,30,31,31,30,31,30,31}[nTheMonth]
  nTheDay       := MIN(nTheDay,nDaysInMonth)
  dReturn       := CTOD(STR(nTheMonth,2) + "/" + STR(nTheDay,2) +;
                   "/" + STR(nTheYear,4))
CASE nPeriodType = ISYEARS
  if month(dInDate)=2 .and. day(dInDate)=29
    dInDate   := dInDate-1   && adjust for leapyear
  endif
  cStringDate := VAL(DTOS(dInDate))
  cStringDate := Alltrim(STR(cStringDate + (nAddorSubtract*10000)))
  dReturn     := Stod(cStringDate)
ENDCASE
SET_DATE(nOldDate)
RETURN dReturn
