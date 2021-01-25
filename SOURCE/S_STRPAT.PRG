/*
�����������������������������������������������������������������
� FUNCTION STRIP_PATH()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STRIP_PATH() Strip path and optionally extension from a
�  filespec
� 
�  Returns:
�  --------
�  <cFile> => file name with path and optionally
�  extension stripped
� 
�  Syntax:
�  -------
�  STRIP_PATH(cInSpec, [lStripExt])
� 
�  Description:
�  ------------
�  Returns <cInSpec>, the name of a file with its path
�  stripped.
� 
�  [lStripExt] if True will strip the extension as well.
�  Default is false.
� 
�  Examples:
�  ---------
�   ?STRIP_PATH("C:\HAIRY\CRITTERS\MONKEY.DBF")
�   //  => returns "MONKEY.DBF"
� 
�   ?STRIP_PATH("C:\HAIRY\CRITTERS\MONKEY.DBF",.T.)
�   //  => returns "MONKEY"
� 
�  Source:
�  -------
�  S_STRPAT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION STRIP_PATH(cInPath, lStripExt)
local cOutSpec

cOutSpec := cInPath
if "\"$cInPath
   cOutSpec := subst(cInPath,RAT("\",cInPath)+1)
elseif ":"$cInPath
   cOutSpec := subst(cInPath,RAT(":",cInPath)+1)
endif

if lStripExt .and. "."$cOutSpec
   cOutSpec := subst(cOutSpec,1,AT(".",cOutSpec)-1)
endif

return cOutSpec


