/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DOYEAR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DOYEAR() Calculates day of the year from date
³ 
³  Returns:
³  --------
³  <nDayOfYear> => day of the year of date
³ 
³  Syntax:
³  -------
³  DOYEAR(dTarget)
³ 
³  Description:
³  ------------
³  Calculates day of the year from <dTarget>
³ 
³  Examples:
³  ---------
³   dDate   := ctod("10/15/90")
³   nDoYear := DOYEAR(dDate)   //(returns 288)
³ 
³  Source:
³  -------
³  S_DOYEAR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION doyear(dInDate)
local nOldDate, nReturn
nOldDate := SET_DATE(1)
nReturn  :=  dInDate- CTOD("01/01/"+RIGHT(DTOC(dInDate),2)) +1
SET_DATE(nOldDate)
RETURN nReturn
