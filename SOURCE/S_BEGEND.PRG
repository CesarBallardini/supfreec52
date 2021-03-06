#define THEBEGINNING    1
#define THEEND          0
#define OFWEEK          1
#define OFMONTH         2
#define OFQUARTER       3


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BEGEND()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BEGEND() Determines beginning or end of week,month or quarter
³ 
³ 
³  Returns:
³  --------
³  <dReturnDate> => Date of  beginning/end of week,month,qtr
³ 
³  Syntax:
³  -------
³  BEGEND(dStartDate,nBeginEnd,nWkMnthQtr,[nDayofWeek])
³ 
³  Description:
³  ------------
³  Returns date which is beginning (1) or end (0)
³  <nBeginEnd> of week (1) , month (2) ,or quarter (3)
³  <nWkMnthQtr> in which input date <dStartDate> falls. If week,
³  [nDayofWeek] is day of the week beginning or end of the week
³  <nBeginEnd> falls on, with Sunday being 1 and Saturday being 7.
³ 
³  Examples:
³  ---------
³   dDate := ctod("01/15/90")
³   bow   := BEGEND(dDate,1,1,1)  // beg of week
³   eow   := BEGEND(dDate,0,1,7)  // end of week
³   bom   := BEGEND(dDate,1,2)    // beg of month
³   eow   := BEGEND(dDate,0,2)    // end of month
³   boq   := BEGEND(dDate,1,3)    // beg of quarter
³   eoq   := BEGEND(dDate,0,3)    // end of quarter
³ 
³  Source:
³  -------
³  S_BEGEND.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION BEGEND(dInDate,nBeginOrEnd,nWeekMonthQuarter,nFirstDayOfWeek)
LOCAL  tdate,nStoreDate

* change to AMERICAN date format, store old format
nStoreDate := SET_DATE(1)
DO CASE
CASE EMPTY(dInDate)
CASE nWeekMonthQuarter = OFWEEK
  DO WHILE !DOW(dInDate)=nFirstDayOfWeek
    dInDate := dInDate+ IIF(nBeginOrEnd=THEBEGINNING,-1,1)
  ENDDO
CASE nWeekMonthQuarter = OFMONTH
  tdate = LEFT(DTOS(dInDate),6)
  IF nBeginOrEnd = THEBEGINNING
    dInDate := Stod(tdate+"01")
  ELSE
    dInDate := Stod(tdate+RIGHT(STR(daysin(dInDate)+100),2))
  ENDIF
CASE nWeekMonthQuarter = OFQUARTER
  DO CASE
  CASE MONTH(dInDate) < 4
    dInDate := CTOD(IIF(nBeginOrEnd=THEBEGINNING,"01/01/","03/31/")+;
              RIGHT(DTOC(dInDate),2) )
  CASE MONTH(dInDate) < 7
    dInDate := CTOD(IIF(nBeginOrEnd=THEBEGINNING,"04/01/","06/30/")+;
              RIGHT(DTOC(dInDate),2) )
  CASE MONTH(dInDate) < 10
    dInDate := CTOD(IIF(nBeginOrEnd=THEBEGINNING,"07/01/","09/30/")+;
              RIGHT(DTOC(dInDate),2) )
  CASE MONTH(dInDate) < 13
    dInDate := CTOD(IIF(nBeginOrEnd=THEBEGINNING,"10/01/","12/31/")+;
              RIGHT(DTOC(dInDate),2) )
  ENDCASE
ENDCASE

* restore to old SET DATE format
SET_DATE(nStoreDate)
RETURN dInDate
