/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION VAR2CHAR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  VAR2CHAR() Converts any type variable to character type
³ 
³  Returns:
³  --------
³  <cCharVal> => value as character
³ 
³  Syntax:
³  -------
³  Var2char(expX)
³ 
³  Description:
³  ------------
³  Converts variable in <expX> to type character
³ 
³  Examples:
³  ---------
³   dtype := ctod("01/01/80")
³ 
³   ntype := 128.45
³ 
³   ltype := .t.
³ 
³   VAR2CHAR(dtype)   // returns "01/01/80"
³ 
³   VAR2CHAR(ntype)   // returns "128.45"
³ 
³   VAR2CHAR(ltype)       //returns ".t."
³ 
³  Warnings:
³  ----------
³  Numerics will be returned with a length of 10 minimum
³ 
³  You may wish to trim this.
³ 
³  Notes:
³  -------
³  Returns memo types as ""
³ 
³  PREVIOUSLY ACCEPTED THE 'NAME' OF THE VARIABLE. NOW
³  THE VALUE IS PASSED IN DIRECTLY.
³ 
³  Source:
³  -------
³  S_VAR2.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
