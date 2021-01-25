/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DTOW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DTOW() Converts date to words
ณ 
ณ  Returns:
ณ  --------
ณ  <cDateWords> => date as words
ณ 
ณ  Syntax:
ณ  -------
ณ  DTOW(dTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns date in <dTarget> as words
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate     := ctod("10/15/89")
ณ   cWdate     := DTOW(dDate)
ณ   // returns "October 15, 1989"
ณ 
ณ  Source:
ณ  -------
ณ  S_DTOW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION dtow(dIndate)
IF EMPTY(dIndate)
  RETURN SPACE(18)
ENDIF
RETURN PADR(CMONTH(dInDate)+' '+LTRIM(TRANS(DAY(dInDate),"99"))+', '+TRANS(YEAR(dInDate),"9999"),18)

