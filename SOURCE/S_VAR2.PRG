/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION VAR2CHAR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  VAR2CHAR() Converts any type variable to character type
ณ 
ณ  Returns:
ณ  --------
ณ  <cCharVal> => value as character
ณ 
ณ  Syntax:
ณ  -------
ณ  Var2char(expX)
ณ 
ณ  Description:
ณ  ------------
ณ  Converts variable in <expX> to type character
ณ 
ณ  Examples:
ณ  ---------
ณ   dtype := ctod("01/01/80")
ณ 
ณ   ntype := 128.45
ณ 
ณ   ltype := .t.
ณ 
ณ   VAR2CHAR(dtype)   // returns "01/01/80"
ณ 
ณ   VAR2CHAR(ntype)   // returns "128.45"
ณ 
ณ   VAR2CHAR(ltype)       //returns ".t."
ณ 
ณ  Warnings:
ณ  ----------
ณ  Numerics will be returned with a length of 10 minimum
ณ 
ณ  You may wish to trim this.
ณ 
ณ  Notes:
ณ  -------
ณ  Returns memo types as ""
ณ 
ณ  PREVIOUSLY ACCEPTED THE 'NAME' OF THE VARIABLE. NOW
ณ  THE VALUE IS PASSED IN DIRECTLY.
ณ 
ณ  Source:
ณ  -------
ณ  S_VAR2.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION var2char(expAnyType)
DO CASE
CASE VALTYPE(expAnyType) == "C"
  RETURN expAnyType
CASE VALTYPE(expAnyType) == "D"
  RETURN DTOC(expAnyType)
CASE VALTYPE(expAnyType) == "N"
  RETURN ALLTRIM(STR(expAnyType))
CASE VALTYPE(expAnyType) == "L"
  RETURN IIF(expAnyType,".T.",".F.")
CASE TYPE(expAnyType) == "M"
  RETURN ''
ENDCASE
return ''
