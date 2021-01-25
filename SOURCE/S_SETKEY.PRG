//---------------------------------------------------------

/*
�����������������������������������������������������������������
� FUNCTION SAVESETKEYS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SAVESETKEYS() Saves active set keys to an array
� 
�  Returns:
�  --------
�  <aSaved> => setkey setting saved to an array
� 
�  Syntax:
�  -------
�  SAVESETKEYS([lClear])
� 
�  Description:
�  ------------
�  Saves the inkey codes and codeblocks associated with
�  all active setkeys to an array.
� 
�  [lClear] If True, clear any active setkeys (set to NIL)
� 
�  Examples:
�  ---------
�   aSaved := SAVESETKEYS(.t.)
� 
�   * do stuff
� 
�   RESTSETKEYS(aSaved)
� 
�  Source:
�  -------
�  S_SETKEY.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION RESTSETKEYS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  RESTSETKEYS() Restores  set keys saved with SAVESETKEYS()
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  RESTSETKEYS(aSaved)
� 
�  Description:
�  ------------
�  SAVESETKEYS() saves the inkey codes and codeblocks
�  associated with all active setkeys to an array. RESTSETKEYS()
�  takes the saved array and restores the setkeys back.
� 
�  Examples:
�  ---------
�   aSaved := SAVESETKEYS(.t.)
� 
�   * do stuff
� 
�   RESTSETKEYS(aSaved)
� 
�  Source:
�  -------
�  S_SETKEY.PRG
� 
����������������������������������������������������������������� 
*/
function restsetkeys(akSaved)
local i
for i = 1 to len(akSaved)
  setkey(aksaved[i,1],akSaved[i,2])
next
return nil

