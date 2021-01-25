/*
�����������������������������������������������������������������
� FUNCTION ADDSPACE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ADDSPACE() Pads right of string with spaces
� 
�  Returns:
�  --------
�  <cPaddedString> => String padded with spaces.
� 
�  Syntax:
�  -------
�  ADDSPACE(cInString,nPadSpaces)
� 
�  Description:
�  ------------
�  Pads right side of <cInString> with <nPadSpaces> spaces.
� 
�  Truncates string if <nPadSpaces> is shorter than
�  original string length.
� 
�  Examples:
�  ---------
�   ADDSPACE("GARRY",10)     // => "GARRY           "
� 
�  Notes:
�  -------
�  For compatibility. In Clipper 5.x , the function
�  PADR() does the same thing.
� 
�  Source:
�  -------
�  S_ADDSP.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION addspace(cString,nDesiredLength)
nDesiredLength := iif(nDesiredLength#nil,nDesiredLength,len(cString) )
RETURN SUBST(cString+REPL(' ',nDesiredLength-LEN(cString)),1,nDesiredLength)
