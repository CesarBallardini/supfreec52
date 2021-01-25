/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STOD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STOD() Returns date from string in the form YYYYMMDD
ณ 
ณ  Returns:
ณ  --------
ณ  <dDate> => date from string
ณ 
ณ  Syntax:
ณ  -------
ณ  STOD(cStringDate)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns date from string of the form YYYYMMDD
ณ  <cStringDate>
ณ 
ณ  Examples:
ณ  ---------
ณ   cStrdate := "19890102"
ณ 
ณ   dNewdate := STOD(cStrdate)
ณ 
ณ   // (returns 01/02/89 type date)
ณ 
ณ  Source:
ณ  -------
ณ  S_STOD.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION Stod(cStringDate)
local nSaveDaveFormat := SET_DATE(1)
local dReturnDate     := CTOD(SUBSTR(cStringDate,5,2)+'/';
                       +SUBSTR(cStringDate,7,2)+'/';
                       +SUBSTR(cStringDate,1,4))
SET_DATE(nSaveDaveFormat)
RETURN dReturnDate
