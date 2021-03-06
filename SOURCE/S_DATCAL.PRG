#define ISDAYS          1
#define ISWEEKS         2
#define ISMONTHS        3
#define ISYEARS         4

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DATECALC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DATECALC() Adds/subtracts days,weeks,months,years to a date
³ 
³  Returns:
³  --------
³  <dNew> => new date
³ 
³  Syntax:
³  -------
³  DATECALC(dStart,nUnits,nUnitType)
³ 
³  Description:
³  ------------
³  <nUnits> is the number of units to add or subtract.
³  If negative, subtraction takes place.
³ 
³  <nUnitType> is the type of unit, where 1=days ,2=wks,
³  3=mnths, 4=yrs
³ 
³  <dStart> is the source date, to which units are added
³  or subtracted.
³ 
³  Examples:
³  ---------
³   dDate          := ctod("10/15/89")
³ 
³   dLess5days    := DATECALC(dDate,-5,1)  // subtract 5 days
³   dLess5weeks   := DATECALC(dDate,-5,2)  // subtract 5 weeks
³   dAdd5months   := DATECALC(dDate,5,3) // add 5 months
³   dAdd5years    := DATECALC(dDate,5,4)  // add 5 years
³ 
³  Notes:
³  -------
³  Month adding/subtracting where the day of current
³  month is greater than the # of days in the target month is done
³  by using the # of days in the target month. i.e. 01/31/90 + 1
³  month = 02/28/90
³ 
³  If the input date is Feb 29th of a leap year, it is
³  adjusted to Feb 28th before month or year calculations.
³ 
³  Source:
³  -------
³  S_DATCAL.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
