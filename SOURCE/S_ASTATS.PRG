//------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AVARIANCE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AVARIANCE() Determines the variance of an array with condition
³ 
³ 
³  Returns:
³  --------
³  <nVariance> => Array variance
³ 
³  Syntax:
³  -------
³  AVARIANCE(aTarget,[bCondition])
³ 
³  Description:
³  ------------
³  <aTarget> is the target array. Normally an array of
³  numeric values. [bCondition] is an optional codeblock used to
³  select a subset of the array. This could be used to filter out
³  0's or non-numeric elements. The block must accept an array
³  element as a parameter, and return true or false <expL> to
³  determine if this element is part of the desired subset.
³ 
³  Examples:
³  ---------
³   v := AVARIANCE(aSales)
³   v := AVARIANCE(aSales,{|e|valtype(e)=="N".and.e<>0})
³ 
³  Source:
³  -------
³  S_ASTATS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ASTDDEV()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ASTDDEV() Standard deviation of an array with condition
³ 
³ 
³  Returns:
³  --------
³  <nStdDev> => Standard deviation
³ 
³  Syntax:
³  -------
³  ASTDDEV(aTarget,[bCondition])
³ 
³  Description:
³  ------------
³  <aTarget> is the target array. Normally an array of
³  numeric values. [bCondition] is an optional codeblock used to
³  select a subset of the array. This could be used to filter out
³  0's or non-numeric elements. The block must accept an array
³  element as a parameter, and return true or false <expL> to
³  determine if this element is part of the desired subset.
³ 
³  Examples:
³  ---------
³   v := ASTDDEV(aSales)
³   v := ASTDDEV(aSales,{|e|valtype(e)=="N".and.e<>0})
³ 
³  Source:
³  -------
³  S_ASTATS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION aStdDev(aArray,bCondition)
return sqrt(aVariance(aArray,bCondition))

//------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AAVERAGE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AAVERAGE() Determines average of an array with condition
³ 
³  Returns:
³  --------
³  <nAverage> => Average of the array
³ 
³  Syntax:
³  -------
³  AAVERAGE(aTarget,[bCondition])
³ 
³  Description:
³  ------------
³  <aTarget> is the target array. Normally an array of numeric values.
³ 
³  [bCondition] is an optional codeblock used to select
³  a subset of the array. This could be used to filter out 0's or
³  non-numeric elements. The block must accept an array element as
³  a parameter, and return true or false <expL> to determine if
³  this element is part of the desired subset.
³ 
³  Examples:
³  ---------
³   v := AAVERAGE(aSales)
³   v := AAVERAGE(aSales,{|e|valtype(e)=="N".and.e<>0})
³ 
³  Source:
³  -------
³  S_ASTATS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION aAverage(a,bCondition)
return (aSum(a,bCondition)/aMatches(a,bCondition) )

//------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ASUM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ASUM() Determines the sum of an array with condition
³ 
³ 
³  Returns:
³  --------
³  <nArraySum> => Array sum
³ 
³  Syntax:
³  -------
³  ASUM(aTarget,[bCondition])
³ 
³  Description:
³  ------------
³  <aTarget> is the target array. Normally an array of
³  numeric values. [bCondition] is an optional codeblock used to
³  select a subset of the array. This could be used to filter out
³  0's or non-numeric elements.
³ 
³  The block must accept an array element as a
³  parameter, and return true or false <expL> to determine if this
³  element is part of the desired subset.
³ 
³  Examples:
³  ---------
³   v := ASUM(aSales)
³   v := ASUM(aSales,{|e|valtype(e)=="N".and.e<>0})
³ 
³  Source:
³  -------
³  S_ASTATS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AMATCHES()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AMATCHES() Counts the matches of an array with condition
³ 
³  Returns:
³  --------
³  <nMatches> => Number of matches
³ 
³  Syntax:
³  -------
³  AMATCHES(aTarget,[bCondition])
³ 
³  Description:
³  ------------
³  <aTarget> is the target array. Normally an array of
³  numeric values.
³ 
³  [bCondition] is an optional codeblock used to select
³  a subset of the array. This could be used to filter out 0's or
³  non-numeric elements. The block must accept an array element as
³  a parameter, and return true or false <expL> to determine if
³  this element is part of the desired subset.
³ 
³  Without [bCondition], the length of the array is
³  returned.
³ 
³  Examples:
³  ---------
³   v := AMATCHES(aSales)
³   v := AMATCHES(aSales,{|e|valtype(e)=="N".and.e<>0})
³   v := AMATCHES(aSales,{|e|valtype(e)=="C".and.e=="D"})
³ 
³  Source:
³  -------
³  S_ASTATS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


