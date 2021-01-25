/*
�����������������������������������������������������������������
� FUNCTION CLS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CLS() Clear the screen with optional color,character
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  CLS([nAttribute],[cChar])
� 
�  Description:
�  ------------
�  Clear the screen.
�
�  Optional color [nAttribute] and character [cChar].
� 
�  Examples:
�  ---------
�   CLS()   // clears screen with current color
� 
�   CLS(48) // clears screen with black on cyan
� 
�   CLS(8,chr(177))  // clears screen grey on black
�                    // with character 177
� 
�  Notes:
�  -------
�  Of course in Clipper 5.01 you can also do:
�  dispbox(0,0,24,79,repl(chr(177),9),"+N/N") and get the same
�  result.
�
�
�  Source:
�  -------
�  S_CLS.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION cls(ncColorAtt,cFillCharacter)
local cColorString
cColorString   := iif(valtype(ncColorAtt)=="N",at2char(ncColorAtt),ncColorAtt)
cFillCharacter := repl( iif(cFillCharacter#nil,cFillCharacter," "),9 )
dispbox(0,0,maxrow(),maxcol(),cFillCharacter,cColorString)
RETURN ''
