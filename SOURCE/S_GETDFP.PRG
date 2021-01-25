/*
�����������������������������������������������������������������
� FUNCTION GETDFP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  GETDFP() Gets SET DEFAULT path
� 
�  Returns:
�  --------
�  SET DEFAULT path as string
� 
�  Syntax:
�  -------
�  GETDFP()
� 
�  Description:
�  ------------
�  Retrieves and returns SET DEFAULT path from Clipper.
�  Appends a "\" if needed. If no SET DEFAULT is active, returns an
�  empty string ""
� 
�  Examples:
�  ---------
�   // using ERASE, for instance
� 
�   ERASE (getdfp()+tempfile)
� 
�  Source:
�  -------
�  S_GETDFP.PRG
� 
����������������������������������������������������������������� 
*/
Function getdfp
local cDefaultPath := alltrim(SET(_SET_DEFAULT))
* is it empty?
if !empty(cDefaultPath)
    * is there a "\" on the end?
    if right(cDefaultPath,1)#"\"
      cDefaultPath += "\"
    endif
endif
return cDefaultPath




