/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BOYEAR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BOYEAR() Determine beginning of year a date falls in
ณ 
ณ  Returns:
ณ  --------
ณ  <dReturn> => Date of the beginning of the year
ณ 
ณ  Syntax:
ณ  -------
ณ  BOYEAR([dTarget])
ณ 
ณ  Description:
ณ  ------------
ณ  Determines beginning of the year of a date and
ณ  returns it as <dReturn>. [dTarget] a date variable. Default is
ณ  DATE()
ณ 
ณ  Examples:
ณ  ---------
ณ   dBegyear := BOYEAR(date())
ณ 
ณ  Source:
ณ  -------
ณ  S_BOYEAR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION BOYEAR(dInDate)
local dReturn
local nSaveDate := SET_DATE(1)
dInDate := iif(valtype(dInDate)<>"D",date(),dInDate)
dReturn := CTOD("01/01/"+ right(TRANS(YEAR(dInDate),"9999"),2)  )
SET_DATE(nSaveDate)
return dReturn

