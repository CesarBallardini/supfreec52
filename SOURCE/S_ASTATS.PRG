//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AVARIANCE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AVARIANCE() Determines the variance of an array with condition
� 
� 
�  Returns:
�  --------
�  <nVariance> => Array variance
� 
�  Syntax:
�  -------
�  AVARIANCE(aTarget,[bCondition])
� 
�  Description:
�  ------------
�  <aTarget> is the target array. Normally an array of
�  numeric values. [bCondition] is an optional codeblock used to
�  select a subset of the array. This could be used to filter out
�  0's or non-numeric elements. The block must accept an array
�  element as a parameter, and return true or false <expL> to
�  determine if this element is part of the desired subset.
� 
�  Examples:
�  ---------
�   v := AVARIANCE(aSales)
�   v := AVARIANCE(aSales,{|e|valtype(e)=="N".and.e<>0})
� 
�  Source:
�  -------
�  S_ASTATS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION ASTDDEV()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ASTDDEV() Standard deviation of an array with condition
� 
� 
�  Returns:
�  --------
�  <nStdDev> => Standard deviation
� 
�  Syntax:
�  -------
�  ASTDDEV(aTarget,[bCondition])
� 
�  Description:
�  ------------
�  <aTarget> is the target array. Normally an array of
�  numeric values. [bCondition] is an optional codeblock used to
�  select a subset of the array. This could be used to filter out
�  0's or non-numeric elements. The block must accept an array
�  element as a parameter, and return true or false <expL> to
�  determine if this element is part of the desired subset.
� 
�  Examples:
�  ---------
�   v := ASTDDEV(aSales)
�   v := ASTDDEV(aSales,{|e|valtype(e)=="N".and.e<>0})
� 
�  Source:
�  -------
�  S_ASTATS.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION aStdDev(aArray,bCondition)
return sqrt(aVariance(aArray,bCondition))

//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AAVERAGE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AAVERAGE() Determines average of an array with condition
� 
�  Returns:
�  --------
�  <nAverage> => Average of the array
� 
�  Syntax:
�  -------
�  AAVERAGE(aTarget,[bCondition])
� 
�  Description:
�  ------------
�  <aTarget> is the target array. Normally an array of numeric values.
� 
�  [bCondition] is an optional codeblock used to select
�  a subset of the array. This could be used to filter out 0's or
�  non-numeric elements. The block must accept an array element as
�  a parameter, and return true or false <expL> to determine if
�  this element is part of the desired subset.
� 
�  Examples:
�  ---------
�   v := AAVERAGE(aSales)
�   v := AAVERAGE(aSales,{|e|valtype(e)=="N".and.e<>0})
� 
�  Source:
�  -------
�  S_ASTATS.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION aAverage(a,bCondition)
return (aSum(a,bCondition)/aMatches(a,bCondition) )

//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION ASUM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ASUM() Determines the sum of an array with condition
� 
� 
�  Returns:
�  --------
�  <nArraySum> => Array sum
� 
�  Syntax:
�  -------
�  ASUM(aTarget,[bCondition])
� 
�  Description:
�  ------------
�  <aTarget> is the target array. Normally an array of
�  numeric values. [bCondition] is an optional codeblock used to
�  select a subset of the array. This could be used to filter out
�  0's or non-numeric elements.
� 
�  The block must accept an array element as a
�  parameter, and return true or false <expL> to determine if this
�  element is part of the desired subset.
� 
�  Examples:
�  ---------
�   v := ASUM(aSales)
�   v := ASUM(aSales,{|e|valtype(e)=="N".and.e<>0})
� 
�  Source:
�  -------
�  S_ASTATS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION AMATCHES()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AMATCHES() Counts the matches of an array with condition
� 
�  Returns:
�  --------
�  <nMatches> => Number of matches
� 
�  Syntax:
�  -------
�  AMATCHES(aTarget,[bCondition])
� 
�  Description:
�  ------------
�  <aTarget> is the target array. Normally an array of
�  numeric values.
� 
�  [bCondition] is an optional codeblock used to select
�  a subset of the array. This could be used to filter out 0's or
�  non-numeric elements. The block must accept an array element as
�  a parameter, and return true or false <expL> to determine if
�  this element is part of the desired subset.
� 
�  Without [bCondition], the length of the array is
�  returned.
� 
�  Examples:
�  ---------
�   v := AMATCHES(aSales)
�   v := AMATCHES(aSales,{|e|valtype(e)=="N".and.e<>0})
�   v := AMATCHES(aSales,{|e|valtype(e)=="C".and.e=="D"})
� 
�  Source:
�  -------
�  S_ASTATS.PRG
� 
����������������������������������������������������������������� 
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

