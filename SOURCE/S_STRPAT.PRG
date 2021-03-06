/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION STRIP_PATH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  STRIP_PATH() Strip path and optionally extension from a
³  filespec
³ 
³  Returns:
³  --------
³  <cFile> => file name with path and optionally
³  extension stripped
³ 
³  Syntax:
³  -------
³  STRIP_PATH(cInSpec, [lStripExt])
³ 
³  Description:
³  ------------
³  Returns <cInSpec>, the name of a file with its path
³  stripped.
³ 
³  [lStripExt] if True will strip the extension as well.
³  Default is false.
³ 
³  Examples:
³  ---------
³   ?STRIP_PATH("C:\HAIRY\CRITTERS\MONKEY.DBF")
³   //  => returns "MONKEY.DBF"
³ 
³   ?STRIP_PATH("C:\HAIRY\CRITTERS\MONKEY.DBF",.T.)
³   //  => returns "MONKEY"
³ 
³  Source:
³  -------
³  S_STRPAT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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



