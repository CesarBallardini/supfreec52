/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CENTR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CENTR() Centers a string in x spaces
ณ 
ณ  Returns:
ณ  --------
ณ  <cCentered> => String centered
ณ 
ณ  Syntax:
ณ  -------
ณ  CENTR(cInString,[nSpaces])
ณ 
ณ  Description:
ณ  ------------
ณ  Centers <cInString> in [nSpaces] spaces
ณ 
ณ  [nSpaces] spaces is optional. Default is current
ณ  string length
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   cString := "Superfunction "
ณ 
ณ   cString := CENTR(cString,20)     //   => "  Superfunction  "
ณ 
ณ  Notes:
ณ  -------
ณ  In Clipper 5.01, use PADC(), which does the same
ณ  thing and faster. Here for compatibility.
ณ 
ณ  Source:
ณ  -------
ณ  S_CENTR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION centr(cInstring,nPadWidth)
nPadwidth := iif(nPadWidth#nil,nPadWidth,len(cInString))
return PADC(alltrim(cInstring),nPadWidth)
