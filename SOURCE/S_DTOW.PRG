/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DTOW()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DTOW() Converts date to words
³ 
³  Returns:
³  --------
³  <cDateWords> => date as words
³ 
³  Syntax:
³  -------
³  DTOW(dTarget)
³ 
³  Description:
³  ------------
³  Returns date in <dTarget> as words
³ 
³  Examples:
³  ---------
³   dDate     := ctod("10/15/89")
³   cWdate     := DTOW(dDate)
³   // returns "October 15, 1989"
³ 
³  Source:
³  -------
³  S_DTOW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION dtow(dIndate)
IF EMPTY(dIndate)
  RETURN SPACE(18)
ENDIF
RETURN PADR(CMONTH(dInDate)+' '+LTRIM(TRANS(DAY(dInDate),"99"))+', '+TRANS(YEAR(dInDate),"9999"),18)

