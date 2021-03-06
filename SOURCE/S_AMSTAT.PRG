//------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AMVARIANCE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AMVARIANCE() Variance on a given element of multi-dim array
³ 
³ 
³  Returns:
³  --------
³  <nVariance> => average of array element
³ 
³  Syntax:
³  -------
³  AMVARIANCE(aMult,nElem,[bCondition])
³ 
³  Description:
³  ------------
³  Returns variance of array <aMult> element <nElem>.
³  [bCondition] is an optional codeblock used to select a subset of
³  the array. This could be used to filter out 0's or non-numeric
³  elements. The block must accept a subarray as a parameter, and
³  return  true or false <expL> to determine if this element is
³  part of the desired subset. Please note that the codeblock
³  accepts the whole subarray, not  just subarray element <nElem>
³ 
³  Examples:
³  ---------
³ 
³   ?"Total file size here is "
³   ??AMSUM(DIRECTORY(),2)
³ 
³   ?"Total .EXE file size here is "
³   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
³ 
³   ?"Variance:"
³   ??AMVARIANCE(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
³ 
³  Notes:
³  -------
³  Coded by Matthew Maier.
³ 
³  Presumes all sub-arrays are of equal length
³ 
³  Source:
³  -------
³  S_AMSTAT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AMSTDDEV()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AMSTDDEV() Standard Deviation on a given element of
³  multi-dim array
³ 
³  Returns:
³  --------
³  <nVariance> => average of array element
³ 
³  Syntax:
³  -------
³  AMSTDDEV(aMult,nElem,[bCondition])
³ 
³  Description:
³  ------------
³  Returns Standard Deviation of array <aMult> element
³  <nElem>.  [bCondition] is an optional codeblock used to select a
³  subset of the array. This could be used to filter out 0's or
³  non-numeric elements.
³ 
³  The block must accept a subarray as a parameter, and
³  return true or false <expL> to determine if this element is
³  part of the desired subset. Please note that the codeblock
³  accepts the whole subarray, not  just subarray element <nElem>
³ 
³  Examples:
³  ---------
³   ?"Total file size here is "
³   ??AMSUM(DIRECTORY(),2)
³ 
³   ?"Total .EXE file size here is "
³   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
³ 
³   ?"Standard Deviation:"
³   ??AMSTDDEV(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
³ 
³  Notes:
³  -------
³  Coded by Matthew Maier.
³ 
³  Presumes all sub-arrays are of equal length
³ 
³  Source:
³  -------
³  S_AMSTAT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION amStdDev(aArray,nElem,bCondition)
return(sqrt(amVariance(aArray,nElem,bCondition)))


//------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AMAVERAGE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AMAVERAGE() Average on a given element of multi-dim array
³ 
³  Returns:
³  --------
³  <nAverage> => average of array element
³ 
³  Syntax:
³  -------
³  AMAVERAGE(aMult,nElem,[bCondition])
³ 
³  Description:
³  ------------
³  Returns average of array <aMult> element <nElem>.
³ 
³  [bCondition] is an optional codeblock used to select
³  a subset of the  array. This could be used to filter out 0's or
³  non-numeric elements.  The block must accept a subarray as a
³  parameter, and return  true or false <expL> to determine if this
³  element is part of the desired  subset.
³ 
³  Please not that the codeblock accepts the whole
³  subarray, not  just subarray element <nElem>
³ 
³  Examples:
³  ---------
³ 
³   ?"Average file size here is "
³   ??amaverage(DIRECTORY(),2)
³ 
³   ?"Average .EXE file size here is "
³   ??amaverage(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
³ 
³   use customer
³   ?"Average field size "
³   ??amaverage(DBSTRUCT(),3)
³ 
³  Notes:
³  -------
³  Presumes all sub-arrays are of equal length
³ 
³  Coded by Matthew Maier.
³ 
³  Source:
³  -------
³  S_AMSTAT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AMSUM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AMSUM() Sum on a given element of multi-dim array
³ 
³ 
³  Returns:
³  --------
³  <nSum> => sum of array element
³ 
³  Syntax:
³  -------
³  AMSUM(aMult,nElem,[bCondition])
³ 
³  Description:
³  ------------
³  Returns sum of array <aMult> element <nElem>.
³ 
³  [bCondition] is an optional codeblock used to select
³  a subset of the  array. This could be used to filter out 0's or
³  non-numeric elements.  The block must accept a subarray as a
³  parameter, and return  true or false <expL> to determine if this
³  element is part of the desired subset. Please note that the
³  codeblock accepts the whole subarray, not  just subarray element
³  <nElem>
³ 
³  Examples:
³  ---------
³ 
³   ?"Total file size here is "
³   ??AMSUM(DIRECTORY(),2)
³ 
³   ?"Total .EXE file size here is "
³   ??AMSUM(DIRECTORY(),2,{|e|".EXE"$e[1]}  )
³ 
³   use customer
³   ?"Total field size "
³   ??AMSUM(DBSTRUCT(),3)
³ 
³   use customer
³   ?"Total CHARACTER field size "
³   ??AMSUM(DBSTRUCT(),3,{|e|e[2]=="C"} )
³ 
³  Notes:
³  -------
³  Coded by Matthew Maier.
³ 
³  Presumes all sub-arrays are of equal length
³ 
³  Source:
³  -------
³  S_AMSTAT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


