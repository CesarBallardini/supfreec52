#define INDAYS          1
#define INWEEKS         2
#define INMONTHS        3
#define INYEARS         4

/*
�����������������������������������������������������������������
� FUNCTION DTDIFF()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  DTDIFF() Returns difference between dates
� 
�  Returns:
�  --------
�  <nDifference> => days,weeks,months or years between
�  dates
� 
�  Syntax:
�  -------
�  DTDIFF(dFirst,dSecond,nUnitType)
� 
�  Description:
�  ------------
�  Calculates difference between <dFirst> and <dSecond>
�  in quantity defined by <nUnitType> as:
� 
�  1=whole days    2=whole weeks
� 
�  3=whole months  4=whole years
� 
�  Examples:
�  ---------
�   dDate     := ctod("10/15/89")
�   dDate2    := ctod("10/26/89")
�   nDiffdays     := DTDIFF(dDate,dDate2,1)
�   nDiffweeks    := DTDIFF(dDate,dDate2,2)
�   nDiffmonth    := DTDIFF(dDate,dDate2,3)
�   nDiffyears    := DTDIFF(dDate,dDate2,4)
� 
�  Source:
�  -------
�  S_DTDIFF.PRG
� 
����������������������������������������������������������������� 
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