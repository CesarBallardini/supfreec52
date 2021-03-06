/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BOM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BOM() Calculates beginning of the month date
³ 
³  Returns:
³  --------
³  <dReturn> => Date which is beginning of the month
³ 
³  Syntax:
³  -------
³  BOM(dTarget)
³ 
³  Description:
³  ------------
³  Calculates date which is beginning of the month from
³  <dTarget>
³ 
³  Examples:
³  ---------
³   dDate := ctod("10/15/90")
³ 
³   dBom  := BOM(DDate)    //    => 10/01/90
³ 
³  Source:
³  -------
³  S_BOM.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION bom(dInDate)
local nPrevDateFormat  := SET_DATE(1)
local dReturn          := CTOD(TRANSFORM(MONTH(dInDate),'99')+"/01/"+;
                          TRANSFORM(YEAR(dInDate),'9999'))
SET_DATE(nPrevDateFormat)
return dReturn
