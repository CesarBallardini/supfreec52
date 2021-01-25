#define INDAYS          1
#define INWEEKS         2
#define INMONTHS        3
#define INYEARS         4

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DTDIFF()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DTDIFF() Returns difference between dates
ณ 
ณ  Returns:
ณ  --------
ณ  <nDifference> => days,weeks,months or years between
ณ  dates
ณ 
ณ  Syntax:
ณ  -------
ณ  DTDIFF(dFirst,dSecond,nUnitType)
ณ 
ณ  Description:
ณ  ------------
ณ  Calculates difference between <dFirst> and <dSecond>
ณ  in quantity defined by <nUnitType> as:
ณ 
ณ  1=whole days    2=whole weeks
ณ 
ณ  3=whole months  4=whole years
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate     := ctod("10/15/89")
ณ   dDate2    := ctod("10/26/89")
ณ   nDiffdays     := DTDIFF(dDate,dDate2,1)
ณ   nDiffweeks    := DTDIFF(dDate,dDate2,2)
ณ   nDiffmonth    := DTDIFF(dDate,dDate2,3)
ณ   nDiffyears    := DTDIFF(dDate,dDate2,4)
ณ 
ณ  Source:
ณ  -------
ณ  S_DTDIFF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
