
/*
�����������������������������������������������������������������
� FUNCTION ENHANCED()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ENHANCED() Returns color integer for ENHANCED setting
� 
�  Returns:
�  --------
�  <nColor> => color integer for ENHANCED setting
� 
�  Syntax:
�  -------
�  ENHANCED()
� 
�  Description:
�  ------------
�  Gets the 2nd part of the color string and converts it
�  to color INTEGER
�
�  Examples:
�  ---------
�   nEnh := ENHANCED()
�   ATT(10,10,10,20,nEnh)
�
�  Notes:
�  -------
�  See appendix for more info on Super.Lib color usage
�
�
�  Source:
�  -------
�  S_ENHAN.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION enhanced
local cColorsFore := "N...B...G...BG..R...BR..GR..W...N+..B+..G+..BG+.R+..BR+.GR+.W+.."
local cColorsBack := "N...B...G...BG..R...BR..GR..W...N*..B*..G*..BG*.R*..BR*.GR*.W*.."
local cSetcolor   := takeout(Setcolor(),",",2)
local cForeGround := takeout(cSetcolor,"/",1)
local cBackGround := takeout(cSetcolor,"/",2)
local nForeGround := int((AT(cForeGround,cColorsFore)-1)/4)
local nBackGround := int(((AT(cBackGround,cColorsBack)-1)/4)*16)

RETURN (nBackGround+nForeGround)
