/*
�����������������������������������������������������������������
� FUNCTION AEXTRACT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AEXTRACT() Extract and return a conditional set from an array
� 
�  Returns:
�  --------
�  <aSubset> => subset of the array
� 
�  Syntax:
�  -------
�  AEXTRACT(aSource,bCondition,[nElement])
� 
�  Description:
�  ------------
�  Extracts elements meeting <bCondition> from <aSource>
�  and returns them as in an array.
� 
�  <bCondition> is a code block that, for each element
�  of <aSource> is passed the element and the position. So for
�  element 3 the codeblock would be called with
� 
�    EVAL(bCondition,aSource[3],3)
� 
�  [nElement]  if passed signals that <aSource> is an
�  array of arrays, and that [nElement] is to be extracted from
�  each subarray where <bCondition> is true.
� 
�  Examples:
�  ---------
�   aNames    := {"Fred","Wilma","Barney","Betty"}
�   aRubbels  := aextract(aNames,{|e|left(e,1)=="B"} )
� 
�   aDir := directory()
�   // extract for size > 100,000
�   aBig := aextract(aDir,{|e,n|aDir[n,2]> 100000})
�   // extract only the name element for size > 100,000
�   aBigNames := aextract(aDir,{|e,n|aDir[n,2]> 100000},1)
� 
�  Source:
�  -------
�  S_AEXTRA.PRG
� 
����������������������������������������������������������������� 
*/
function aextract(aArray,bCondition,nElement)
local aReturn := {}
local i
for i = 1 to len(aArray)
  if eval(bCondition,aArray[i],i)
    if nElement#nil
      aadd(aReturn,aArray[i,nElement])
    else
      aadd(aReturn,aArray[i])
    endif
  endif
next
return aReturn