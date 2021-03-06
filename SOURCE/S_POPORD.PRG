#include "inkey.ch"
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SPOPORDER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SPOPORDER() Popup allows user to change viewing (index) order
³ 
³  Returns:
³  --------
³  <nOrder> => current index order
³ 
³  Syntax:
³  -------
³  SPOPORDER()
³ 
³  Description:
³  ------------
³  Pops up a list of current index keys, with first
³  option being <Natural (record) order>. If an index order is
³  selected, index order is set to that order. Current index order (after
³  selection and change) is returned.
³ 
³  Examples:
³  ---------
³   nIndexOrd := spoporder()
³ 
³  Source:
³  -------
³  S_POPORD.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

