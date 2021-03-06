/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CENTR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CENTR() Centers a string in x spaces
³ 
³  Returns:
³  --------
³  <cCentered> => String centered
³ 
³  Syntax:
³  -------
³  CENTR(cInString,[nSpaces])
³ 
³  Description:
³  ------------
³  Centers <cInString> in [nSpaces] spaces
³ 
³  [nSpaces] spaces is optional. Default is current
³  string length
³ 
³  Examples:
³  ---------
³ 
³   cString := "Superfunction "
³ 
³   cString := CENTR(cString,20)     //   => "  Superfunction  "
³ 
³  Notes:
³  -------
³  In Clipper 5.01, use PADC(), which does the same
³  thing and faster. Here for compatibility.
³ 
³  Source:
³  -------
³  S_CENTR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION centr(cInstring,nPadWidth)
nPadwidth := iif(nPadWidth#nil,nPadWidth,len(cInString))
return PADC(alltrim(cInstring),nPadWidth)
