/*
�����������������������������������������������������������������
� FUNCTION SETCENT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SETCENT() Determines if century is on/off
� 
�  Returns:
�  --------
�  <lCentury> => Century is on/off
� 
�  Syntax:
�  -------
�  SETCENT([lCentury])
� 
�  Description:
�  ------------
�  Returns current SET CENTURY setting and optionally
�  sets century on/off
� 
�  [lCentury]  True = ON False = OFF
� 
�  Examples:
�  ---------
�   lOldcentury := SETCENT(.f.)   //  SET CENTURY OFF
� 
�   // code
� 
�   SETCENT(lOldcentury)
� 
�  Source:
�  -------
�  S_SETCEN.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION SETCENT(lCentury)
local lOld
lOld = (LEN(DTOC(DATE()))==10)
if lCentury#nil
 SET CENTURY (lCentury)
endif
return lOld