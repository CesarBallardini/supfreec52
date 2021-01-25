//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AMVARIANCE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AMVARIANCE() Variance on a given element of multi-dim array
� 
� 
�  Returns:
�  --------
�  <nVariance> => average of array element
� 
�  Syntax:
�  -------
�  AMVARIANCE(aMult,nElem,[bCondition])
� 
�  Description:
�  ------------
�  Returns variance of array <aMult> element <nElem>.
�  [bCondition] is an optional codeblock used to select a subset of
�  the array. This could be used to filter out 0's or non-numeric
�  elements. The block must accept a subarray as a parameter, and
�  return  true or false <expL> to determine if this element is
�  part of the desired subset. Please note that the codeblock
�  accepts the whole subarray, not  just subarray element <nElem>
� 
�  Examples:
�  ---------
� 
�   ?"Total file size here is "
�   ??AMSUM(DIRECTORY(),2)
� 
�   ?"Total .EXE file size here is "
�   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
� 
�   ?"Variance:"
�   ??AMVARIANCE(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
� 
�  Notes:
�  -------
�  Coded by Matthew Maier.
� 
�  Presumes all sub-arrays are of equal length
� 
�  Source:
�  -------
�  S_AMSTAT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION amVariance(aArray,nElem,bCondition)
  local nAverage, i
  local nVariance := 0
  local nCount    := 0
  local nReturn   := 0
  if (valtype(nElem) == 'N')
    nAverage    := amAverage(aArray,nElem,bCondition)
    bCondition  := iif(valtype(bCondition) == 'B',bCondition,{||.t.})
    for i := 1 to len(aArray)
      if (eval(bCondition,aArray[i]))
        nVariance += ((nAverage-aArray[i][nElem] )^2)
        nCount++
      endif
    next
    nReturn := (nVariance/nCount)
  endif
return (nReturn)

//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AMSTDDEV()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AMSTDDEV() Standard Deviation on a given element of
�  multi-dim array
� 
�  Returns:
�  --------
�  <nVariance> => average of array element
� 
�  Syntax:
�  -------
�  AMSTDDEV(aMult,nElem,[bCondition])
� 
�  Description:
�  ------------
�  Returns Standard Deviation of array <aMult> element
�  <nElem>.  [bCondition] is an optional codeblock used to select a
�  subset of the array. This could be used to filter out 0's or
�  non-numeric elements.
� 
�  The block must accept a subarray as a parameter, and
�  return true or false <expL> to determine if this element is
�  part of the desired subset. Please note that the codeblock
�  accepts the whole subarray, not  just subarray element <nElem>
� 
�  Examples:
�  ---------
�   ?"Total file size here is "
�   ??AMSUM(DIRECTORY(),2)
� 
�   ?"Total .EXE file size here is "
�   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
� 
�   ?"Standard Deviation:"
�   ??AMSTDDEV(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
� 
�  Notes:
�  -------
�  Coded by Matthew Maier.
� 
�  Presumes all sub-arrays are of equal length
� 
�  Source:
�  -------
�  S_AMSTAT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION amStdDev(aArray,nElem,bCondition)
return(sqrt(amVariance(aArray,nElem,bCondition)))


//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AMAVERAGE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AMAVERAGE() Average on a given element of multi-dim array
� 
�  Returns:
�  --------
�  <nAverage> => average of array element
� 
�  Syntax:
�  -------
�  AMAVERAGE(aMult,nElem,[bCondition])
� 
�  Description:
�  ------------
�  Returns average of array <aMult> element <nElem>.
� 
�  [bCondition] is an optional codeblock used to select
�  a subset of the  array. This could be used to filter out 0's or
�  non-numeric elements.  The block must accept a subarray as a
�  parameter, and return  true or false <expL> to determine if this
�  element is part of the desired  subset.
� 
�  Please not that the codeblock accepts the whole
�  subarray, not  just subarray element <nElem>
� 
�  Examples:
�  ---------
� 
�   ?"Average file size here is "
�   ??amaverage(DIRECTORY(),2)
� 
�   ?"Average .EXE file size here is "
�   ??amaverage(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
� 
�   use customer
�   ?"Average field size "
�   ??amaverage(DBSTRUCT(),3)
� 
�  Notes:
�  -------
�  Presumes all sub-arrays are of equal length
� 
�  Coded by Matthew Maier.
� 
�  Source:
�  -------
�  S_AMSTAT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION amAverage(a,nElem,bCondition)
  local nRet := 0
  if (valtype(nElem) == 'N')
    nRet := amSum(a,nElem,bCondition)
    nRet := (nRet/aMatches(a,bCondition) )
  endif
return (nRet)

//------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AMSUM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AMSUM() Sum on a given element of multi-dim array
� 
� 
�  Returns:
�  --------
�  <nSum> => sum of array element
� 
�  Syntax:
�  -------
�  AMSUM(aMult,nElem,[bCondition])
� 
�  Description:
�  ------------
�  Returns sum of array <aMult> element <nElem>.
� 
�  [bCondition] is an optional codeblock used to select
�  a subset of the  array. This could be used to filter out 0's or
�  non-numeric elements.  The block must accept a subarray as a
�  parameter, and return  true or false <expL> to determine if this
�  element is part of the desired subset. Please note that the
�  codeblock accepts the whole subarray, not  just subarray element
�  <nElem>
� 
�  Examples:
�  ---------
� 
�   ?"Total file size here is "
�   ??AMSUM(DIRECTORY(),2)
� 
�   ?"Total .EXE file size here is "
�   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
� 
�   use customer
�   ?"Total field size "
�   ??AMSUM(DBSTRUCT(),3)
� 
�   use customer
�   ?"Total CHARACTER field size "
�   ??AMSUM(DBSTRUCT(),3,{|e|e[2]=="C"} )
� 
�  Notes:
�  -------
�  Coded by Matthew Maier.
� 
�  Presumes all sub-arrays are of equal length
� 
�  Source:
�  -------
�  S_AMSTAT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION amSum(a,nElem,bCondition)
  local nRet := 0
  local i
  if (valtype(nElem) == 'N')
    bCondition := iif(valtype(bCondition) == 'B',bCondition,{||.t.})
    for i := 1 to len(a)
      if (eval(bCondition,a[i]))
        nRet+= a[i][nElem]
      endif
    next
  endif
return (nRet)

