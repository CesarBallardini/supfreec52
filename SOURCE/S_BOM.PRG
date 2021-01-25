/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BOM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BOM() Calculates beginning of the month date
ณ 
ณ  Returns:
ณ  --------
ณ  <dReturn> => Date which is beginning of the month
ณ 
ณ  Syntax:
ณ  -------
ณ  BOM(dTarget)
ณ 
ณ  Description:
ณ  ------------
ณ  Calculates date which is beginning of the month from
ณ  <dTarget>
ณ 
ณ  Examples:
ณ  ---------
ณ   dDate := ctod("10/15/90")
ณ 
ณ   dBom  := BOM(DDate)    //    => 10/01/90
ณ 
ณ  Source:
ณ  -------
ณ  S_BOM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION bom(dInDate)
local nPrevDateFormat  := SET_DATE(1)
local dReturn          := CTOD(TRANSFORM(MONTH(dInDate),'99')+"/01/"+;
                          TRANSFORM(YEAR(dInDate),'9999'))
SET_DATE(nPrevDateFormat)
return dReturn
