#define INDAYS          1
#define INWEEKS         2
#define INMONTHS        3
#define INYEARS         4

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DTDIFF()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DTDIFF() Returns difference between dates
³ 
³  Returns:
³  --------
³  <nDifference> => days,weeks,months or years between
³  dates
³ 
³  Syntax:
³  -------
³  DTDIFF(dFirst,dSecond,nUnitType)
³ 
³  Description:
³  ------------
³  Calculates difference between <dFirst> and <dSecond>
³  in quantity defined by <nUnitType> as:
³ 
³  1=whole days    2=whole weeks
³ 
³  3=whole months  4=whole years
³ 
³  Examples:
³  ---------
³   dDate     := ctod("10/15/89")
³   dDate2    := ctod("10/26/89")
³   nDiffdays     := DTDIFF(dDate,dDate2,1)
³   nDiffweeks    := DTDIFF(dDate,dDate2,2)
³   nDiffmonth    := DTDIFF(dDate,dDate2,3)
³   nDiffyears    := DTDIFF(dDate,dDate2,4)
³ 
³  Source:
³  -------
³  S_DTDIFF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION dtdiff(dDate1,dDate2,nDiffType)
local nReturn,nGreater,nLesser,nIterator

DO CASE
CASE (EMPTY(dDate1) .OR. EMPTY(dDate2))
  nReturn := 0
CASE dDate1=dDate2
  nReturn :=0
CASE nDiffType = INDAYS
  nReturn := ABS(dDate1-dDate2)
CASE nDiffType = INWEEKS
  nReturn := INT(ABS(dDate1-dDate2)/7)
CASE nDiffType = INMONTHS
  nGreater := IIF(dDate1 > dDate2,dDate1,dDate2)
  nLesser  := IIF(dDate1 < dDate2,dDate1,dDate2)
  nReturn  := 0
  DO WHILE nLesser <= nGreater
    nReturn++
    nLesser := nLesser+daysin(nLesser)
  ENDDO
  nReturn  := nReturn-1
CASE nDiffType = INYEARS
  nGreater := VAL(DTOS(IIF(dDate1 > dDate2,dDate1,dDate2)))
  nLesser  := VAL(DTOS(IIF(dDate1 < dDate2,dDate1,dDate2)))
  nReturn  := 0
  DO WHILE nLesser < nGreater
    nReturn++
    nLesser := nLesser+10000
  ENDDO
  nReturn := nReturn-1
ENDCASE
RETURN nReturn
