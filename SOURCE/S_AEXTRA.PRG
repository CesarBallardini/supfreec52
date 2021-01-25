/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AEXTRACT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AEXTRACT() Extract and return a conditional set from an array
ณ 
ณ  Returns:
ณ  --------
ณ  <aSubset> => subset of the array
ณ 
ณ  Syntax:
ณ  -------
ณ  AEXTRACT(aSource,bCondition,[nElement])
ณ 
ณ  Description:
ณ  ------------
ณ  Extracts elements meeting <bCondition> from <aSource>
ณ  and returns them as in an array.
ณ 
ณ  <bCondition> is a code block that, for each element
ณ  of <aSource> is passed the element and the position. So for
ณ  element 3 the codeblock would be called with
ณ 
ณ    EVAL(bCondition,aSource[3],3)
ณ 
ณ  [nElement]  if passed signals that <aSource> is an
ณ  array of arrays, and that [nElement] is to be extracted from
ณ  each subarray where <bCondition> is true.
ณ 
ณ  Examples:
ณ  ---------
ณ   aNames    := {"Fred","Wilma","Barney","Betty"}
ณ   aRubbels  := aextract(aNames,{|e|left(e,1)=="B"} )
ณ 
ณ   aDir := directory()
ณ   // extract for size > 100,000
ณ   aBig := aextract(aDir,{|e,n|aDir[n,2]> 100000})
ณ   // extract only the name element for size > 100,000
ณ   aBigNames := aextract(aDir,{|e,n|aDir[n,2]> 100000},1)
ณ 
ณ  Source:
ณ  -------
ณ  S_AEXTRA.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
