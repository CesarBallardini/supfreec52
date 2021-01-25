/*
�����������������������������������������������������������������
� FUNCTION ALENG()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ALENG() Actual length of an array, less trailing nil elements
� 
�  Returns:
�  --------
�  <aLength>  => Actual array length, less trailing NILs
� 
�  Syntax:
�  -------
�  ALENG(aTarget)
� 
�  Description:
�  ------------
�  Determines the actual length of <aTarget>, less
�  trailing nils.
� 
�  Examples:
�  ---------
� 
�   a := {1,2,3,4,5,nil,nil,nil}
�   ?len(a)       // => returns 8
�   ?aleng(a)     // => returns 5
� 
�  Notes:
�  ------
�  This was a C function in prior Super.Libs
� 
�  Source:
�  -------
�  S_ALENG.PRG
� 
����������������������������������������������������������������� 
*/
Function Aleng(aArray)
local i,nActualLength := 0
for i = 1 to len(aArray)
   if aArray[i]#nil
     nActualLength++
   else
     exit
   endif
next
return nActualLength

