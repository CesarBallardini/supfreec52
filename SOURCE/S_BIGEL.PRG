/*
�����������������������������������������������������������������
� FUNCTION BIGELEM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BIGELEM() Returns length of longest string in an array
� 
�  Returns:
�  --------
�  <nLength> => Length of longest string in an array
� 
�  Syntax:
�  -------
�  BIGELEM(aTarget)
� 
�  Description:
�  ------------
�  Determines the length of the longest string element
�  in <aTarget> Array may have mixed types
� 
�  Examples:
�  ---------
�   ?BIGELEM(  {"1","22","333"}  )  => returns 3
� 
�  Notes:
�  -------
�  This was a C function in previous SuperLibs
� 
�  Source:
�  -------
�  S_BIGEL.PRG
� 
����������������������������������������������������������������� 
*/
Function BIGELEM(aArray)
local nLongest := 0
local nIterator
for nIterator = 1 to len(aArray)
   if valtype(aArray[nIterator])=="C"
     nLongest := max(nLongest,len(aArray[nIterator]))
   endif
next
return nLongest

