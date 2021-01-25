/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ARRANGE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ARRANGE() Rearranges text in a string
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <cNewString> => String rearranged
ณ 
ณ  Syntax:
ณ  -------
ณ  ARRANGE(cInString,nStart,nLength,nNewPosit)
ณ 
ณ  Description:
ณ  ------------
ณ  Extracts text from <cInString> starting at <nStart>
ณ  for a length of <nLength> and moves it to position
ณ  <nNewPosition>.
ณ 
ณ  Examples:
ณ  ---------
ณ   cString := "SUPERFUNCTION"
ณ   cString := ARRANGE(cString,6,8,1)
ณ    // =>  "FUNCTIONSUPER"
ณ 
ณ  Notes:
ณ  ------
ณ  New position is position AFTER text is cut from
ณ  original position
ณ 
ณ  Source:
ณ  -------
ณ  S_ARRANG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION arrange(cInstring,nStart,nHowmany,nNewPosition)
LOCAL nStringLength := LEN(cInstring)
LOCAL cExtraction   := SUBST(cInstring,nStart,nHowmany)
cInstring     := STUFF(cInstring,nStart,nHowmany,"")
cInstring     := STUFF(cInstring,nNewPosition,0,cExtraction)
RETURN cInstring
