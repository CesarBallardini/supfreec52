/*
�����������������������������������������������������������������
� FUNCTION AT2CHAR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AT2CHAR() Returns the String color equivalent of a color number
� 
�  Returns:
�  --------
�  <cColorString> => Color string
� 
�  Syntax:
�  -------
�  AT2CHAR(nColorAttribute)
� 
�  Description:
�  ------------
�  <nColorAttribute> the numeric color to be converted,
�  is changed to <cColorString>, a clipper color string.
� 
�  Examples:
�  ---------
�   AT2CHAR(47)  // =>  "W/G"
� 
�  Source:
�  -------
�  S_AT2C.PRG
� 
����������������������������������������������������������������� 
*/
Function At2char(nColor)
local aFore   := {"N","B","G","BG","R","RB","GR","W",;
                  "N+","B+","G+","BG+","R+","RB+","GR+","W+"}
local aBack   := {"N","B","G","BG","R","RB","GR","W",;
                  "N*","B*","G*","BG*","R*","RB*","GR*","W*"}
local nFore         := nColor%16
local nBack         := INT(nColor/16)
local cForeground   := aFore[nFore+1]
local cBackGround   := aBack[nBack+1]
return ( cForeground+'/'+cBackGround )