/*
�����������������������������������������������������������������
� FUNCTION STAGFIELDS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STAGFIELDS() Tag fields
� 
�  Returns:
�  --------
�  aTagged => an array of element #'s of the tagged items
� 
�  Syntax:
�  -------
�  STAGFIELDS([aFieldnames],[cTitle],[cMark])
� 
�  Description:
�  ------------
�  Tags selected items in an array of fields, returning
�  an array of element #'s of tagged items in the array of fields.
� 
�  [aFieldNames] - an array of field names. Default -
�  all fields
� 
�  [cTitle]      - title for the popup. Default none
� 
�  [cMark]       - character used to mark as tagged.
� 
�                          Default is checkmark chr(251)
� 
�  Examples:
�  ---------
�   aTagged := STAGFIELDS()
� 
�   for i = 1 to len(aTagged)
� 
�     ?field(aTagged[i])   // fieldname
� 
�   next
� 
�  Source:
�  -------
�  S_TAGF.PRG
� 
����������������������������������������������������������������� 
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