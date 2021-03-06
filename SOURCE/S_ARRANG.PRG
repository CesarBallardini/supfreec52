/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ARRANGE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ARRANGE() Rearranges text in a string
³ 
³ 
³  Returns:
³  --------
³  <cNewString> => String rearranged
³ 
³  Syntax:
³  -------
³  ARRANGE(cInString,nStart,nLength,nNewPosit)
³ 
³  Description:
³  ------------
³  Extracts text from <cInString> starting at <nStart>
³  for a length of <nLength> and moves it to position
³  <nNewPosition>.
³ 
³  Examples:
³  ---------
³   cString := "SUPERFUNCTION"
³   cString := ARRANGE(cString,6,8,1)
³    // =>  "FUNCTIONSUPER"
³ 
³  Notes:
³  ------
³  New position is position AFTER text is cut from
³  original position
³ 
³  Source:
³  -------
³  S_ARRANG.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION arrange(cInstring,nStart,nHowmany,nNewPosition)
LOCAL nStringLength := LEN(cInstring)
LOCAL cExtraction   := SUBST(cInstring,nStart,nHowmany)
cInstring     := STUFF(cInstring,nStart,nHowmany,"")
cInstring     := STUFF(cInstring,nNewPosition,0,cExtraction)
RETURN cInstring
