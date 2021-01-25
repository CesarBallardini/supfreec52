/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DOYEAR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DOYEAR() Calculates day of the year from date
ณ 
ณ  Returns:
ณ  --------
ณ  <nDayOfYear> => day of the year of date
ณ 
ณ  Syntax:
ณ  -------
ณ  DOYEAR(dTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Calculates day of the year from <dTarget>
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate   := ctod("10/15/90")
ณ   nDoYear := DOYEAR(dDate)   //(returns 288)
ณ 
ณ  Source:
ณ  -------
ณ  S_DOYEAR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION doyear(dInDate)
local nOldDate, nReturn
nOldDate := SET_DATE(1)
nReturn  :=  dInDate- CTOD("01/01/"+RIGHT(DTOC(dInDate),2)) +1
SET_DATE(nOldDate)
RETURN nReturn
