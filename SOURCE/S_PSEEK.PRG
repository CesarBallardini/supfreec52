#include "inkey.ch"
/*
�����������������������������������������������������������������
� FUNCTION SPOPSEEK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SPOPSEEK() Popup seek based on present index keys
� 
�  Returns:
�  --------
�  <lFound> => seek succesful or not
� 
�  Syntax:
�  -------
�  SPOPSEEK([aKeys])
� 
�  Description:
�  ------------
�  Pops up first a box asking for which index selection,
�  and when the index key is selected, asks for a value to be
�  entered to seek on. Performs a seek and returns <lFound>
�  success. The index order is saved and restored.
� 
�  [aKeys] is an optional array of current index keys.
� 
�  Examples:
�  ---------
�   IF choice = POP_SEEK
�      if SPOPSEEK()
�        redrawscreen()
�      endif
�   ENDIF
� 
�  Source:
�  -------
�  S_PSEEK.PRG
� 
����������������������������������������������������������������� 
*/
function spopseek(aKeys)
local nKey  := 0
local expRead
local nOldOrder := indexord()
local nRecord   := recno()
local lFound    := .f.
aKeys := iif(aKeys#nil,aKeys,ps_fillk())
if len(aKeys) > 1
   nKey := mchoice(aKeys,5,15,5+len(aKeys)+2,65,"Select Index Key")
elseif len(aKeys)==1
   nKey := 1
else
   msg("No Index Open")
endif
if nKey > 0
  expRead := eval( &("{||"+aKeys[nKey]+"}") )
  popread(.t.,"Seek value:",@expRead,"@K")
  if lastkey()<>K_ESC .and. !empty(expRead)
     IF VALTYPE(expRead)=="C"
       expRead := trim(expRead)
     endif
     set order to (nKey)
     seek expRead
     lFound := found()
     if !found()
       msg("Not Found")
       go nRecord
     endif
  endif
endif
set order to (nOldOrder)
return lFound


static function ps_fillk
local aKeys := {}
local i := 1
while !empty(indexkey(i))
  aadd(aKeys,indexkey(i))
  i++
end
return aKeys