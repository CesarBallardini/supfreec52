/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GETDFP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  GETDFP() Gets SET DEFAULT path
ณ 
ณ  Returns:
ณ  --------
ณ  SET DEFAULT path as string
ณ 
ณ  Syntax:
ณ  -------
ณ  GETDFP()
ณ 
ณ  Description:
ณ  ------------
ณ  Retrieves and returns SET DEFAULT path from Clipper.
ณ  Appends a "\" if needed. If no SET DEFAULT is active, returns an
ณ  empty string ""
ณ 
ณ  Examples:
ณ  ---------
ณ   // using ERASE, for instance
ณ 
ณ   ERASE (getdfp()+tempfile)
ณ 
ณ  Source:
ณ  -------
ณ  S_GETDFP.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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





