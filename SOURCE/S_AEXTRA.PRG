/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AEXTRACT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AEXTRACT() Extract and return a conditional set from an array
³ 
³  Returns:
³  --------
³  <aSubset> => subset of the array
³ 
³  Syntax:
³  -------
³  AEXTRACT(aSource,bCondition,[nElement])
³ 
³  Description:
³  ------------
³  Extracts elements meeting <bCondition> from <aSource>
³  and returns them as in an array.
³ 
³  <bCondition> is a code block that, for each element
³  of <aSource> is passed the element and the position. So for
³  element 3 the codeblock would be called with
³ 
³    EVAL(bCondition,aSource[3],3)
³ 
³  [nElement]  if passed signals that <aSource> is an
³  array of arrays, and that [nElement] is to be extracted from
³  each subarray where <bCondition> is true.
³ 
³  Examples:
³  ---------
³   aNames    := {"Fred","Wilma","Barney","Betty"}
³   aRubbels  := aextract(aNames,{|e|left(e,1)=="B"} )
³ 
³   aDir := directory()
³   // extract for size > 100,000
³   aBig := aextract(aDir,{|e,n|aDir[n,2]> 100000})
³   // extract only the name element for size > 100,000
³   aBigNames := aextract(aDir,{|e,n|aDir[n,2]> 100000},1)
³ 
³  Source:
³  -------
³  S_AEXTRA.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
