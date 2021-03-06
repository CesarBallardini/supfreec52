/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SETCENT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SETCENT() Determines if century is on/off
³ 
³  Returns:
³  --------
³  <lCentury> => Century is on/off
³ 
³  Syntax:
³  -------
³  SETCENT([lCentury])
³ 
³  Description:
³  ------------
³  Returns current SET CENTURY setting and optionally
³  sets century on/off
³ 
³  [lCentury]  True = ON False = OFF
³ 
³  Examples:
³  ---------
³   lOldcentury := SETCENT(.f.)   //  SET CENTURY OFF
³ 
³   // code
³ 
³   SETCENT(lOldcentury)
³ 
³  Source:
³  -------
³  S_SETCEN.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SETCENT(lCentury)
local lOld
lOld = (LEN(DTOC(DATE()))==10)
if lCentury#nil
 SET CENTURY (lCentury)
endif
return lOld
