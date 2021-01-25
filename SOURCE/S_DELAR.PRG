/*
�����������������������������������������������������������������
� FUNCTION DELARRAY()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  DELARRAY() Deletes all elements of an array
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  DELARRAY(aTarget)
� 
�  Description:
�  ------------
�  Deletes all elements of an array <aTarget>. Basically
�  un-initializes the array.
� 
�  Examples:
�  ---------
�     // Same as
� 
�   afill(aTarget,nil)
� 
�   (In 5.01 you can do afill(aTarget,NIL) instead, but
�  this is here for compatibility.)
� 
�  Source:
�  -------
�  S_DELAR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION delarray(aArray)
local nLen := len(aArray)
aSize(aArray,0)
aSize(aArray,nLen)
RETURN ''