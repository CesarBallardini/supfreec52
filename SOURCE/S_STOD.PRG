/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION STOD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  STOD() Returns date from string in the form YYYYMMDD
³ 
³  Returns:
³  --------
³  <dDate> => date from string
³ 
³  Syntax:
³  -------
³  STOD(cStringDate)
³ 
³  Description:
³  ------------
³  Returns date from string of the form YYYYMMDD
³  <cStringDate>
³ 
³  Examples:
³  ---------
³   cStrdate := "19890102"
³ 
³   dNewdate := STOD(cStrdate)
³ 
³   // (returns 01/02/89 type date)
³ 
³  Source:
³  -------
³  S_STOD.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION Stod(cStringDate)
local nSaveDaveFormat := SET_DATE(1)
local dReturnDate     := CTOD(SUBSTR(cStringDate,5,2)+'/';
                       +SUBSTR(cStringDate,7,2)+'/';
                       +SUBSTR(cStringDate,1,4))
SET_DATE(nSaveDaveFormat)
RETURN dReturnDate
