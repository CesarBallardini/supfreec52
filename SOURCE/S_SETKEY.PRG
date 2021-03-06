//---------------------------------------------------------

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SAVESETKEYS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SAVESETKEYS() Saves active set keys to an array
³ 
³  Returns:
³  --------
³  <aSaved> => setkey setting saved to an array
³ 
³  Syntax:
³  -------
³  SAVESETKEYS([lClear])
³ 
³  Description:
³  ------------
³  Saves the inkey codes and codeblocks associated with
³  all active setkeys to an array.
³ 
³  [lClear] If True, clear any active setkeys (set to NIL)
³ 
³  Examples:
³  ---------
³   aSaved := SAVESETKEYS(.t.)
³ 
³   * do stuff
³ 
³   RESTSETKEYS(aSaved)
³ 
³  Source:
³  -------
³  S_SETKEY.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function savesetkeys(lClear)
local akSaved := {}
local bSaved
local i
lClear := iif(lClear#nil,lClear,.f.)
for i = -40 to 310
  if (bSaved := setkey(i))#nil
    aadd(akSaved,{i,bSaved})
    if lClear
      setkey(i,nil)
    endif
  endif
next
return akSaved
//---------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION RESTSETKEYS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  RESTSETKEYS() Restores  set keys saved with SAVESETKEYS()
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  RESTSETKEYS(aSaved)
³ 
³  Description:
³  ------------
³  SAVESETKEYS() saves the inkey codes and codeblocks
³  associated with all active setkeys to an array. RESTSETKEYS()
³  takes the saved array and restores the setkeys back.
³ 
³  Examples:
³  ---------
³   aSaved := SAVESETKEYS(.t.)
³ 
³   * do stuff
³ 
³   RESTSETKEYS(aSaved)
³ 
³  Source:
³  -------
³  S_SETKEY.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function restsetkeys(akSaved)
local i
for i = 1 to len(akSaved)
  setkey(aksaved[i,1],akSaved[i,2])
next
return nil


