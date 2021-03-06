/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION STAGFIELDS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  STAGFIELDS() Tag fields
³ 
³  Returns:
³  --------
³  aTagged => an array of element #'s of the tagged items
³ 
³  Syntax:
³  -------
³  STAGFIELDS([aFieldnames],[cTitle],[cMark])
³ 
³  Description:
³  ------------
³  Tags selected items in an array of fields, returning
³  an array of element #'s of tagged items in the array of fields.
³ 
³  [aFieldNames] - an array of field names. Default -
³  all fields
³ 
³  [cTitle]      - title for the popup. Default none
³ 
³  [cMark]       - character used to mark as tagged.
³ 
³                          Default is checkmark chr(251)
³ 
³  Examples:
³  ---------
³   aTagged := STAGFIELDS()
³ 
³   for i = 1 to len(aTagged)
³ 
³     ?field(aTagged[i])   // fieldname
³ 
³   next
³ 
³  Source:
³  -------
³  S_TAGF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
