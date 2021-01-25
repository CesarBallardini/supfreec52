/*
�����������������������������������������������������������������
� FUNCTION CENTR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CENTR() Centers a string in x spaces
� 
�  Returns:
�  --------
�  <cCentered> => String centered
� 
�  Syntax:
�  -------
�  CENTR(cInString,[nSpaces])
� 
�  Description:
�  ------------
�  Centers <cInString> in [nSpaces] spaces
� 
�  [nSpaces] spaces is optional. Default is current
�  string length
� 
�  Examples:
�  ---------
� 
�   cString := "Superfunction "
� 
�   cString := CENTR(cString,20)     //   => "  Superfunction  "
� 
�  Notes:
�  -------
�  In Clipper 5.01, use PADC(), which does the same
�  thing and faster. Here for compatibility.
� 
�  Source:
�  -------
�  S_CENTR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION centr(cInstring,nPadWidth)
nPadwidth := iif(nPadWidth#nil,nPadWidth,len(cInString))
return PADC(alltrim(cInstring),nPadWidth)