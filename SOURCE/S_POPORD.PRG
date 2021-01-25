#include "inkey.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SPOPORDER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SPOPORDER() Popup allows user to change viewing (index) order
ณ 
ณ  Returns:
ณ  --------
ณ  <nOrder> => current index order
ณ 
ณ  Syntax:
ณ  -------
ณ  SPOPORDER()
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a list of current index keys, with first
ณ  option being <Natural (record) order>. If an index order is
ณ  selected, index order is set to that order. Current index order (after
ณ  selection and change) is returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   nIndexOrd := spoporder()
ณ 
ณ  Source:
ณ  -------
ณ  S_POPORD.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function spoporder()
local nKey  := 0
local expRead
local nOldOrder := indexord()
local nRecord   := recno()
local lFound    := .f.
local aKeys := po_fillk()
nKey := mchoice(aKeys,5,15,5+len(aKeys)+2,65,"Select Index Key")
if nKey > 0
  set order to (nKey-1)
endif
return indexord()


static function po_fillk
local aKeys := {"<Natural (record) Order>" }
local i := 1
while !empty(indexkey(i))
  aadd(aKeys,indexkey(i))
  i++
end
return aKeys

