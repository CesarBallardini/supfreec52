#include "inkey.ch"
/*
�����������������������������������������������������������������
� FUNCTION GETAKEY()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  GETAKEY() Gets intent of last keystroke
� 
�  Returns:
�  --------
�  <cIntent> as key direction (FWD,BWD,ESC,CTW,UNK)
� 
�  Syntax:
�  -------
�  GETAKEY(nKeyVal)
� 
�  Description:
�  ------------
�  Gives key direction of last key, for evaluating what
�  direction in a read the user is heading.
� 
�  Examples:
�  ---------
�   If GETAKEY(LASTKEY())=="FWD"
�       nActive_field++
�   elseif GETAKEY(LASTKEY())=="BWD"
�       nActive_field--
�   endif
� 
�  Source:
�  -------
�  S_GETKEY.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION getakey(nLastKey)
DO CASE
CASE nLastKey = K_DOWN .OR. nLastKey = K_ENTER  .OR. nLastKey = K_PGDN
  RETURN "FWD"
CASE nLastKey = K_UP  .OR. nLastKey = K_PGUP
  RETURN "BWD"
CASE nLastKey = K_ESC
  RETURN "ESC"
CASE nLastKey = K_CTRL_END
  RETURN "CTW"
OTHERWISE
  RETURN "FWD"
ENDCASE
return ""
