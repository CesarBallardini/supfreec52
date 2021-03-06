#include "inkey.ch"
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SPOPSEEK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SPOPSEEK() Popup seek based on present index keys
³ 
³  Returns:
³  --------
³  <lFound> => seek succesful or not
³ 
³  Syntax:
³  -------
³  SPOPSEEK([aKeys])
³ 
³  Description:
³  ------------
³  Pops up first a box asking for which index selection,
³  and when the index key is selected, asks for a value to be
³  entered to seek on. Performs a seek and returns <lFound>
³  success. The index order is saved and restored.
³ 
³  [aKeys] is an optional array of current index keys.
³ 
³  Examples:
³  ---------
³   IF choice = POP_SEEK
³      if SPOPSEEK()
³        redrawscreen()
³      endif
³   ENDIF
³ 
³  Source:
³  -------
³  S_PSEEK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
