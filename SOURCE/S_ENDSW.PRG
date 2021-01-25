/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ENDSWITH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ENDSWITH() Determines if a string ends with another string
ณ 
ณ  Returns:
ณ  --------
ณ  <lEndsWith> => True or False, string 2 ends with
ณ  string 1
ณ 
ณ  Syntax:
ณ  -------
ณ  ENDSWITH(cTarget,cEndsWith)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines if string 1 <cTarget> ends with string 2
ณ  <cEndsWith>
ณ 
ณ  Examples:
ณ  ---------
ณ   cStr1    = "SUPERFUNCTION"
ณ   cStr2    = "FUNCTION"
ณ   cStr3    = "FUNKY"
ณ   ENDSWITH(cStr1,cStr2)  //returns .t.
ณ   ENDSWITH(cStr1,cStr3)     //returns .f.
ณ 
ณ  Source:
ณ  -------
ณ  S_ENDSW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION endswith(cInString,cCompareString)
RETURN (cCompareString==RIGHT(cInString,LEN(cCompareString) ))
