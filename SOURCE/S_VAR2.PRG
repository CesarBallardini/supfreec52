/*
�����������������������������������������������������������������
� FUNCTION VAR2CHAR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  VAR2CHAR() Converts any type variable to character type
� 
�  Returns:
�  --------
�  <cCharVal> => value as character
� 
�  Syntax:
�  -------
�  Var2char(expX)
� 
�  Description:
�  ------------
�  Converts variable in <expX> to type character
� 
�  Examples:
�  ---------
�   dtype := ctod("01/01/80")
� 
�   ntype := 128.45
� 
�   ltype := .t.
� 
�   VAR2CHAR(dtype)   // returns "01/01/80"
� 
�   VAR2CHAR(ntype)   // returns "128.45"
� 
�   VAR2CHAR(ltype)       //returns ".t."
� 
�  Warnings:
�  ----------
�  Numerics will be returned with a length of 10 minimum
� 
�  You may wish to trim this.
� 
�  Notes:
�  -------
�  Returns memo types as ""
� 
�  PREVIOUSLY ACCEPTED THE 'NAME' OF THE VARIABLE. NOW
�  THE VALUE IS PASSED IN DIRECTLY.
� 
�  Source:
�  -------
�  S_VAR2.PRG
� 
����������������������������������������������������������������� 
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