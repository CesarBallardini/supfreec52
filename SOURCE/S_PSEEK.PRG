#include "inkey.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SPOPSEEK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SPOPSEEK() Popup seek based on present index keys
ณ 
ณ  Returns:
ณ  --------
ณ  <lFound> => seek succesful or not
ณ 
ณ  Syntax:
ณ  -------
ณ  SPOPSEEK([aKeys])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up first a box asking for which index selection,
ณ  and when the index key is selected, asks for a value to be
ณ  entered to seek on. Performs a seek and returns <lFound>
ณ  success. The index order is saved and restored.
ณ 
ณ  [aKeys] is an optional array of current index keys.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF choice = POP_SEEK
ณ      if SPOPSEEK()
ณ        redrawscreen()
ณ      endif
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_PSEEK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
