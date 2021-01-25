/*
�����������������������������������������������������������������
� FUNCTION ALLBUT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ALLBUT() Returns all but last x characters
� 
�  Returns:
�  --------
�  <cAllBut> => All but last n characters
� 
�  Syntax:
�  -------
�  ALLBUT(cInString,nAllBut)
� 
�  Description:
�  ------------
�  Returns all but the rightmost <nAllbutt> letters of
�  <cInString>
� 
�  Examples:
�  ---------
� 
�   string := "SUPERFUNCTION"
�   string := ALLBUT(string,8)    //  => returns  "SUPER"
� 
�  Notes:
�  -------
�  Useful when you don't know the length of a string in
�  order to take left(x) characters.
� 
�  Source:
�  -------
�  S_ALLBUT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION allbut(cInstring,nAllbut)
RETURN LEFT(cInstring,(LEN(cInstring) -nAllbut))