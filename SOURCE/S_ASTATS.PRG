//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AVARIANCE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AVARIANCE() Determines the variance of an array with condition
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <nVariance> => Array variance
ณ 
ณ  Syntax:
ณ  -------
ณ  AVARIANCE(aTarget,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  <aTarget> is the target array. Normally an array of
ณ  numeric values. [bCondition] is an optional codeblock used to
ณ  select a subset of the array. This could be used to filter out
ณ  0's or non-numeric elements. The block must accept an array
ณ  element as a parameter, and return true or false <expL> to
ณ  determine if this element is part of the desired subset.
ณ 
ณ  Examples:
ณ  ---------
ณ   v := AVARIANCE(aSales)
ณ   v := AVARIANCE(aSales,{|e|valtype(e)=="N".and.e<>0})
ณ 
ณ  Source:
ณ  -------
ณ  S_ASTATS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION aVariance(aArray,bCondition)
local nAverage,i
local nVariance := 0
local nCount := 0
nAverage := aAverage(aArray,bCondition)
if bCondition#nil
   FOR i = 1 to len(aArray)
     if eval(bCondition,aArray[i])
      nVariance += (nAverage-aArray[i] )^2
      nCount++
     endif
   ENDFOR
else
   FOR i = 1 to len(aArray)
      nVariance += (nAverage-aArray[i] )^2
      nCount++
   ENDFOR
endif
return ( nVariance/nCount )

//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ASTDDEV()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ASTDDEV() Standard deviation of an array with condition
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <nStdDev> => Standard deviation
ณ 
ณ  Syntax:
ณ  -------
ณ  ASTDDEV(aTarget,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  <aTarget> is the target array. Normally an array of
ณ  numeric values. [bCondition] is an optional codeblock used to
ณ  select a subset of the array. This could be used to filter out
ณ  0's or non-numeric elements. The block must accept an array
ณ  element as a parameter, and return true or false <expL> to
ณ  determine if this element is part of the desired subset.
ณ 
ณ  Examples:
ณ  ---------
ณ   v := ASTDDEV(aSales)
ณ   v := ASTDDEV(aSales,{|e|valtype(e)=="N".and.e<>0})
ณ 
ณ  Source:
ณ  -------
ณ  S_ASTATS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION aStdDev(aArray,bCondition)
return sqrt(aVariance(aArray,bCondition))

//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AAVERAGE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AAVERAGE() Determines average of an array with condition
ณ 
ณ  Returns:
ณ  --------
ณ  <nAverage> => Average of the array
ณ 
ณ  Syntax:
ณ  -------
ณ  AAVERAGE(aTarget,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  <aTarget> is the target array. Normally an array of numeric values.
ณ 
ณ  [bCondition] is an optional codeblock used to select
ณ  a subset of the array. This could be used to filter out 0's or
ณ  non-numeric elements. The block must accept an array element as
ณ  a parameter, and return true or false <expL> to determine if
ณ  this element is part of the desired subset.
ณ 
ณ  Examples:
ณ  ---------
ณ   v := AAVERAGE(aSales)
ณ   v := AAVERAGE(aSales,{|e|valtype(e)=="N".and.e<>0})
ณ 
ณ  Source:
ณ  -------
ณ  S_ASTATS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION aAverage(a,bCondition)
return (aSum(a,bCondition)/aMatches(a,bCondition) )

//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ASUM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ASUM() Determines the sum of an array with condition
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <nArraySum> => Array sum
ณ 
ณ  Syntax:
ณ  -------
ณ  ASUM(aTarget,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  <aTarget> is the target array. Normally an array of
ณ  numeric values. [bCondition] is an optional codeblock used to
ณ  select a subset of the array. This could be used to filter out
ณ  0's or non-numeric elements.
ณ 
ณ  The block must accept an array element as a
ณ  parameter, and return true or false <expL> to determine if this
ณ  element is part of the desired subset.
ณ 
ณ  Examples:
ณ  ---------
ณ   v := ASUM(aSales)
ณ   v := ASUM(aSales,{|e|valtype(e)=="N".and.e<>0})
ณ 
ณ  Source:
ณ  -------
ณ  S_ASTATS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION aSum(a,bCondition)
local nRet := 0
local i
if bCondition#nil
 for i = 1 to len(a)
   if eval(bCondition,a[i])
     nRet+= a[i]
   endif
 next
else
  for i = 1 to len(a)
    nRet+= a[i]
  next
endif
return (nRet)

//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AMATCHES()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AMATCHES() Counts the matches of an array with condition
ณ 
ณ  Returns:
ณ  --------
ณ  <nMatches> => Number of matches
ณ 
ณ  Syntax:
ณ  -------
ณ  AMATCHES(aTarget,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  <aTarget> is the target array. Normally an array of
ณ  numeric values.
ณ 
ณ  [bCondition] is an optional codeblock used to select
ณ  a subset of the array. This could be used to filter out 0's or
ณ  non-numeric elements. The block must accept an array element as
ณ  a parameter, and return true or false <expL> to determine if
ณ  this element is part of the desired subset.
ณ 
ณ  Without [bCondition], the length of the array is
ณ  returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   v := AMATCHES(aSales)
ณ   v := AMATCHES(aSales,{|e|valtype(e)=="N".and.e<>0})
ณ   v := AMATCHES(aSales,{|e|valtype(e)=="C".and.e=="D"})
ณ 
ณ  Source:
ณ  -------
ณ  S_ASTATS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION aMatches(a,bCondition)
local i,nMatches := 0
if bCondition#nil
  for i =1 to len(a)
   if eval(bCondition,a[i])
     nMatches++
   endif
  next
else
  nMatches := len(a)
endif
return nMatches


