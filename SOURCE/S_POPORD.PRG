#include "inkey.ch"
/*
�����������������������������������������������������������������
� FUNCTION SPOPORDER()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SPOPORDER() Popup allows user to change viewing (index) order
� 
�  Returns:
�  --------
�  <nOrder> => current index order
� 
�  Syntax:
�  -------
�  SPOPORDER()
� 
�  Description:
�  ------------
�  Pops up a list of current index keys, with first
�  option being <Natural (record) order>. If an index order is
�  selected, index order is set to that order. Current index order (after
�  selection and change) is returned.
� 
�  Examples:
�  ---------
�   nIndexOrd := spoporder()
� 
�  Source:
�  -------
�  S_POPORD.PRG
� 
����������������������������������������������������������������� 
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
