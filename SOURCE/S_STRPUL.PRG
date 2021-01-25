/*
�����������������������������������������������������������������
� FUNCTION STRPULL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STRPULL() Extract text between 2 characters in a string
� 
�  Returns:
�  --------
�  <cExtract> => text extracted
� 
�  Syntax:
�  -------
�  STRPULL(cSource,cDelim1,cDelim2)
� 
�  Description:
�  ------------
�  Extracts text from <cSource> between characters
�  <cDelim1> and <cDelim2>.
� 
�  If <cDelim1> is empty, uses beginning of <cSource>.
� 
�  If <cDelim2> is empty, uses end of <cSource>.
� 
�  Examples:
�  ---------
�   cString := "SUPERFUNCTION"
� 
�   cString := STRPULL(cString,'E','C')
� 
�   // (returns "RFUN")
� 
�  Source:
�  -------
�  S_STRPUL.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION strpull(cInString,cDelim1,cDelim2)
local cOutString,nAt1,nAt2
IF EMPTY(cDelim1) .AND. !(" "==cDelim1)
  cInString := "�"+cInString
  cDelim1   := "�"
ENDIF
IF EMPTY(cDelim2) .AND. !(" "==cDelim2)
  cInString := cInString+"�"
  cDelim2   := "�"
ENDIF
nAt1  := AT(cDelim1,cInString)
cOutString := ''
IF nAt1 > 0
  nAt1 := nAt1+len(cDelim1)
  nAt2 :=AT(cDelim2,SUBST(cInString,nAt1))
  IF nAt2 > 0
    nAt2 := nAt2+nAt1-1
    IF (nAt2-nAt1) > 0
      cOutString := SUBST(cInString,nAt1,(nAt2-nAt1))
    ENDIF
  ENDIF
ENDIF
RETURN cOutString
*: EOF: S_STRPUL.PRG
