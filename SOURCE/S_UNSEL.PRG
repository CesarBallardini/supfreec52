/*
�����������������������������������������������������������������
� FUNCTION UNSELECTED()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  UNSELECTED() Returns color integer for UNSELECTED setting
� 
�  Returns:
�  --------
�  <nColor> => numeric color integer for unselected
�  color setting
� 
�  Syntax:
�  -------
�  UNSELECTED()
� 
�  Description:
�  ------------
�  Returns numeric color integer for use with functions
�  which require it
�
�  like ATT(), PRNT().
�
�  Examples:
�  ---------
�   nUnsel = UNSELECTED()
�
�   PRNT(10,10,"Waiting...",nUnsel)
�
�  Notes:
�  -------
�
�  Source:
�  -------
�  S_UNSEL.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION unselected
local cColorsFore := "N...B...G...BG..R...BR..GR..W...N+..B+..G+..BG+.R+..BR+.GR+.W+.."
local cColorsBack := "N...B...G...BG..R...BR..GR..W...N*..B*..G*..BG*.R*..BR*.GR*.W*.."
local cSetcolor   := takeout(Setcolor(),",",5)
local cForeGround := takeout(cSetcolor,"/",1)
local cBackGround := takeout(cSetcolor,"/",2)
local nForeGround := int((AT(cForeGround,cColorsFore)-1)/4)
local nBackGround := int(((AT(cBackGround,cColorsBack)-1)/4)*16)
RETURN INT((nBackGround+nForeGround))
