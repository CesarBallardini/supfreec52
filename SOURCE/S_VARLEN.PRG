/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION VARLEN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  VARLEN() Returns length of a variable  of any type
³ 
³  Returns:
³  --------
³  <nLength> => Length of variable
³ 
³  Syntax:
³  -------
³  Varlength(expX)
³ 
³  Description:
³  ------------
³  Converts expX to character with VAR2CHAR() and then
³  returns its length
³ 
³  Examples:
³  ---------
³   VARLEN(123.45)    //returns 6
³ 
³   VARLEN(.F.)       //returns 3
³ 
³   VARLEN(DATE())  //returns 8
³ 
³  Source:
³  -------
³  S_VARLEN.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
