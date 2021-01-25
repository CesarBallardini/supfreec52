/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STAGFIELDS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STAGFIELDS() Tag fields
ณ 
ณ  Returns:
ณ  --------
ณ  aTagged => an array of element #'s of the tagged items
ณ 
ณ  Syntax:
ณ  -------
ณ  STAGFIELDS([aFieldnames],[cTitle],[cMark])
ณ 
ณ  Description:
ณ  ------------
ณ  Tags selected items in an array of fields, returning
ณ  an array of element #'s of tagged items in the array of fields.
ณ 
ณ  [aFieldNames] - an array of field names. Default -
ณ  all fields
ณ 
ณ  [cTitle]      - title for the popup. Default none
ณ 
ณ  [cMark]       - character used to mark as tagged.
ณ 
ณ                          Default is checkmark chr(251)
ณ 
ณ  Examples:
ณ  ---------
ณ   aTagged := STAGFIELDS()
ณ 
ณ   for i = 1 to len(aTagged)
ณ 
ณ     ?field(aTagged[i])   // fieldname
ณ 
ณ   next
ณ 
ณ  Source:
ณ  -------
ณ  S_TAGF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function stagfields(aFieldNames,cTitle,cMark)
local aReturn
local aStruc,i
if aFieldNames==nil
  aFieldNames := array(fcount())
  aStruc      := dbstruct()
  for i = 1 to len(aStruc)
    aFieldNames[i] := aStruc[i,1]
  next
endif
aReturn := TAGARRAY(aFieldNames,cTitle,cMark)
return aReturn
