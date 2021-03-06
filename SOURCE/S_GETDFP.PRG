/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION GETDFP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  GETDFP() Gets SET DEFAULT path
³ 
³  Returns:
³  --------
³  SET DEFAULT path as string
³ 
³  Syntax:
³  -------
³  GETDFP()
³ 
³  Description:
³  ------------
³  Retrieves and returns SET DEFAULT path from Clipper.
³  Appends a "\" if needed. If no SET DEFAULT is active, returns an
³  empty string ""
³ 
³  Examples:
³  ---------
³   // using ERASE, for instance
³ 
³   ERASE (getdfp()+tempfile)
³ 
³  Source:
³  -------
³  S_GETDFP.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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





