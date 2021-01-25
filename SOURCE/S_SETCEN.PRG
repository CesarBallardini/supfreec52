/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SETCENT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SETCENT() Determines if century is on/off
ณ 
ณ  Returns:
ณ  --------
ณ  <lCentury> => Century is on/off
ณ 
ณ  Syntax:
ณ  -------
ณ  SETCENT([lCentury])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns current SET CENTURY setting and optionally
ณ  sets century on/off
ณ 
ณ  [lCentury]  True = ON False = OFF
ณ 
ณ  Examples:
ณ  ---------
ณ   lOldcentury := SETCENT(.f.)   //  SET CENTURY OFF
ณ 
ณ   // code
ณ 
ณ   SETCENT(lOldcentury)
ณ 
ณ  Source:
ณ  -------
ณ  S_SETCEN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SETCENT(lCentury)
local lOld
lOld = (LEN(DTOC(DATE()))==10)
if lCentury#nil
 SET CENTURY (lCentury)
endif
return lOld
