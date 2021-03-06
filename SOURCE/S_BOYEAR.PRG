/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BOYEAR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BOYEAR() Determine beginning of year a date falls in
³ 
³  Returns:
³  --------
³  <dReturn> => Date of the beginning of the year
³ 
³  Syntax:
³  -------
³  BOYEAR([dTarget])
³ 
³  Description:
³  ------------
³  Determines beginning of the year of a date and
³  returns it as <dReturn>. [dTarget] a date variable. Default is
³  DATE()
³ 
³  Examples:
³  ---------
³   dBegyear := BOYEAR(date())
³ 
³  Source:
³  -------
³  S_BOYEAR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION BOYEAR(dInDate)
local dReturn
local nSaveDate := SET_DATE(1)
dInDate := iif(valtype(dInDate)<>"D",date(),dInDate)
dReturn := CTOD("01/01/"+ right(TRANS(YEAR(dInDate),"9999"),2)  )
SET_DATE(nSaveDate)
return dReturn

