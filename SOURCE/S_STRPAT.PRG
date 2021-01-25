/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STRIP_PATH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STRIP_PATH() Strip path and optionally extension from a
ณ  filespec
ณ 
ณ  Returns:
ณ  --------
ณ  <cFile> => file name with path and optionally
ณ  extension stripped
ณ 
ณ  Syntax:
ณ  -------
ณ  STRIP_PATH(cInSpec, [lStripExt])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns <cInSpec>, the name of a file with its path
ณ  stripped.
ณ 
ณ  [lStripExt] if True will strip the extension as well.
ณ  Default is false.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?STRIP_PATH("C:\HAIRY\CRITTERS\MONKEY.DBF")
ณ   //  => returns "MONKEY.DBF"
ณ 
ณ   ?STRIP_PATH("C:\HAIRY\CRITTERS\MONKEY.DBF",.T.)
ณ   //  => returns "MONKEY"
ณ 
ณ  Source:
ณ  -------
ณ  S_STRPAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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



