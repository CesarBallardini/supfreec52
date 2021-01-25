/*
�����������������������������������������������������������������
� FUNCTION VARLEN()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  VARLEN() Returns length of a variable  of any type
� 
�  Returns:
�  --------
�  <nLength> => Length of variable
� 
�  Syntax:
�  -------
�  Varlength(expX)
� 
�  Description:
�  ------------
�  Converts expX to character with VAR2CHAR() and then
�  returns its length
� 
�  Examples:
�  ---------
�   VARLEN(123.45)    //returns 6
� 
�   VARLEN(.F.)       //returns 3
� 
�   VARLEN(DATE())  //returns 8
� 
�  Source:
�  -------
�  S_VARLEN.PRG
� 
����������������������������������������������������������������� 
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