//---------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SAVESETKEYS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SAVESETKEYS() Saves active set keys to an array
ณ 
ณ  Returns:
ณ  --------
ณ  <aSaved> => setkey setting saved to an array
ณ 
ณ  Syntax:
ณ  -------
ณ  SAVESETKEYS([lClear])
ณ 
ณ  Description:
ณ  ------------
ณ  Saves the inkey codes and codeblocks associated with
ณ  all active setkeys to an array.
ณ 
ณ  [lClear] If True, clear any active setkeys (set to NIL)
ณ 
ณ  Examples:
ณ  ---------
ณ   aSaved := SAVESETKEYS(.t.)
ณ 
ณ   * do stuff
ณ 
ณ   RESTSETKEYS(aSaved)
ณ 
ณ  Source:
ณ  -------
ณ  S_SETKEY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RESTSETKEYS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  RESTSETKEYS() Restores  set keys saved with SAVESETKEYS()
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  RESTSETKEYS(aSaved)
ณ 
ณ  Description:
ณ  ------------
ณ  SAVESETKEYS() saves the inkey codes and codeblocks
ณ  associated with all active setkeys to an array. RESTSETKEYS()
ณ  takes the saved array and restores the setkeys back.
ณ 
ณ  Examples:
ณ  ---------
ณ   aSaved := SAVESETKEYS(.t.)
ณ 
ณ   * do stuff
ณ 
ณ   RESTSETKEYS(aSaved)
ณ 
ณ  Source:
ณ  -------
ณ  S_SETKEY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function restsetkeys(akSaved)
local i
for i = 1 to len(akSaved)
  setkey(aksaved[i,1],akSaved[i,2])
next
return nil


