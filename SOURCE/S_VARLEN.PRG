/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION VARLEN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  VARLEN() Returns length of a variable  of any type
ณ 
ณ  Returns:
ณ  --------
ณ  <nLength> => Length of variable
ณ 
ณ  Syntax:
ณ  -------
ณ  Varlength(expX)
ณ 
ณ  Description:
ณ  ------------
ณ  Converts expX to character with VAR2CHAR() and then
ณ  returns its length
ณ 
ณ  Examples:
ณ  ---------
ณ   VARLEN(123.45)    //returns 6
ณ 
ณ   VARLEN(.F.)       //returns 3
ณ 
ณ   VARLEN(DATE())  //returns 8
ณ 
ณ  Source:
ณ  -------
ณ  S_VARLEN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION varlen(expAny)
DO CASE
CASE VALTYPE(expAny) == "C"
  RETURN len(expAny)
CASE VALTYPE(expAny) == "D"
  RETURN 8
CASE VALTYPE(expAny) == "N"
  return len(alltrim(str(expAny)))
CASE VALTYPE(expAny) == "L"
  return 3
ENDCASE
return 0
