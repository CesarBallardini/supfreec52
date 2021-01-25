//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AMVARIANCE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AMVARIANCE() Variance on a given element of multi-dim array
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <nVariance> => average of array element
ณ 
ณ  Syntax:
ณ  -------
ณ  AMVARIANCE(aMult,nElem,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns variance of array <aMult> element <nElem>.
ณ  [bCondition] is an optional codeblock used to select a subset of
ณ  the array. This could be used to filter out 0's or non-numeric
ณ  elements. The block must accept a subarray as a parameter, and
ณ  return  true or false <expL> to determine if this element is
ณ  part of the desired subset. Please note that the codeblock
ณ  accepts the whole subarray, not  just subarray element <nElem>
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   ?"Total file size here is "
ณ   ??AMSUM(DIRECTORY(),2)
ณ 
ณ   ?"Total .EXE file size here is "
ณ   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
ณ 
ณ   ?"Variance:"
ณ   ??AMVARIANCE(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
ณ 
ณ  Notes:
ณ  -------
ณ  Coded by Matthew Maier.
ณ 
ณ  Presumes all sub-arrays are of equal length
ณ 
ณ  Source:
ณ  -------
ณ  S_AMSTAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AMSTDDEV()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AMSTDDEV() Standard Deviation on a given element of
ณ  multi-dim array
ณ 
ณ  Returns:
ณ  --------
ณ  <nVariance> => average of array element
ณ 
ณ  Syntax:
ณ  -------
ณ  AMSTDDEV(aMult,nElem,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns Standard Deviation of array <aMult> element
ณ  <nElem>.  [bCondition] is an optional codeblock used to select a
ณ  subset of the array. This could be used to filter out 0's or
ณ  non-numeric elements.
ณ 
ณ  The block must accept a subarray as a parameter, and
ณ  return true or false <expL> to determine if this element is
ณ  part of the desired subset. Please note that the codeblock
ณ  accepts the whole subarray, not  just subarray element <nElem>
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Total file size here is "
ณ   ??AMSUM(DIRECTORY(),2)
ณ 
ณ   ?"Total .EXE file size here is "
ณ   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
ณ 
ณ   ?"Standard Deviation:"
ณ   ??AMSTDDEV(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
ณ 
ณ  Notes:
ณ  -------
ณ  Coded by Matthew Maier.
ณ 
ณ  Presumes all sub-arrays are of equal length
ณ 
ณ  Source:
ณ  -------
ณ  S_AMSTAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION amStdDev(aArray,nElem,bCondition)
return(sqrt(amVariance(aArray,nElem,bCondition)))


//------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AMAVERAGE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AMAVERAGE() Average on a given element of multi-dim array
ณ 
ณ  Returns:
ณ  --------
ณ  <nAverage> => average of array element
ณ 
ณ  Syntax:
ณ  -------
ณ  AMAVERAGE(aMult,nElem,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns average of array <aMult> element <nElem>.
ณ 
ณ  [bCondition] is an optional codeblock used to select
ณ  a subset of the  array. This could be used to filter out 0's or
ณ  non-numeric elements.  The block must accept a subarray as a
ณ  parameter, and return  true or false <expL> to determine if this
ณ  element is part of the desired  subset.
ณ 
ณ  Please not that the codeblock accepts the whole
ณ  subarray, not  just subarray element <nElem>
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   ?"Average file size here is "
ณ   ??amaverage(DIRECTORY(),2)
ณ 
ณ   ?"Average .EXE file size here is "
ณ   ??amaverage(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
ณ 
ณ   use customer
ณ   ?"Average field size "
ณ   ??amaverage(DBSTRUCT(),3)
ณ 
ณ  Notes:
ณ  -------
ณ  Presumes all sub-arrays are of equal length
ณ 
ณ  Coded by Matthew Maier.
ณ 
ณ  Source:
ณ  -------
ณ  S_AMSTAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AMSUM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AMSUM() Sum on a given element of multi-dim array
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <nSum> => sum of array element
ณ 
ณ  Syntax:
ณ  -------
ณ  AMSUM(aMult,nElem,[bCondition])
ณ 
ณ  Description:
ณ  ------------
ณ  Returns sum of array <aMult> element <nElem>.
ณ 
ณ  [bCondition] is an optional codeblock used to select
ณ  a subset of the  array. This could be used to filter out 0's or
ณ  non-numeric elements.  The block must accept a subarray as a
ณ  parameter, and return  true or false <expL> to determine if this
ณ  element is part of the desired subset. Please note that the
ณ  codeblock accepts the whole subarray, not  just subarray element
ณ  <nElem>
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   ?"Total file size here is "
ณ   ??AMSUM(DIRECTORY(),2)
ณ 
ณ   ?"Total .EXE file size here is "
ณ   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
ณ 
ณ   use customer
ณ   ?"Total field size "
ณ   ??AMSUM(DBSTRUCT(),3)
ณ 
ณ   use customer
ณ   ?"Total CHARACTER field size "
ณ   ??AMSUM(DBSTRUCT(),3,{|e|e[2]=="C"} )
ณ 
ณ  Notes:
ณ  -------
ณ  Coded by Matthew Maier.
ณ 
ณ  Presumes all sub-arrays are of equal length
ณ 
ณ  Source:
ณ  -------
ณ  S_AMSTAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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


