/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ENDSWITH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ENDSWITH() Determines if a string ends with another string
³ 
³  Returns:
³  --------
³  <lEndsWith> => True or False, string 2 ends with
³  string 1
³ 
³  Syntax:
³  -------
³  ENDSWITH(cTarget,cEndsWith)
³ 
³  Description:
³  ------------
³  Determines if string 1 <cTarget> ends with string 2
³  <cEndsWith>
³ 
³  Examples:
³  ---------
³   cStr1    = "SUPERFUNCTION"
³   cStr2    = "FUNCTION"
³   cStr3    = "FUNKY"
³   ENDSWITH(cStr1,cStr2)  //returns .t.
³   ENDSWITH(cStr1,cStr3)     //returns .f.
³ 
³  Source:
³  -------
³  S_ENDSW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION endswith(cInString,cCompareString)
RETURN (cCompareString==RIGHT(cInString,LEN(cCompareString) ))
