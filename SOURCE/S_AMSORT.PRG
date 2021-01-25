/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ASORTMULT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ASORTMULT() Sort multiple arrays on order of single array
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  ASORTMULT(aArray1,aArray2,[...aArray15])
ณ 
ณ  Description:
ณ  ------------
ณ  Sorts [aArray2] through [aArray15] based on the sort
ณ  results of [aArray1]. All arrays must be of the same length!
ณ  [aArray3]- [aArray15] are optional.
ณ 
ณ  Examples:
ณ  ---------
ณ   // sort the fieldname array, as well as the arrays  containing
ณ   // field types, lengths, and decimals
ณ 
ณ   ASORTMULT(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
ณ 
ณ  Notes:
ณ  -------
ณ  ASORTMULTR() does the same, except sorts in reverse
ณ  order
ณ 
ณ  Source:
ณ  -------
ณ  S_AMSORT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function aSortmult(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15)
local aAll    := {a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15}
local aSorter := array(len(a1))
local nArrays := pcount()
local i,nNext,aThis
for i = 1 to len(aSorter)
  aThis := {}
  for nNext = 1 to nArrays
    aadd(aThis,aAll[nNext,i])
  next
  aSorter[i] := aThis
next

asort(aSorter,,,{|x,y|x[1]<y[1]})

for i = 1 to len(aSorter)
  for nNext = 1 to nArrays
    aAll[nNext,i] := aSorter[i,nNext]
  next
next
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ASORTMULTR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ASORTMULTR() Reverse sort multiple arrays on order of single array
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  ASORTMULTR(aArray1,aArray2,[...aArray15])
ณ 
ณ  Description:
ณ  ------------
ณ  Sorts [aArray2] through [aArray15] based on the sort
ณ  results of [aArray1]. Sort is in reverse (descending) order. All
ณ  arrays must be of the same length! [aArray3]-[aArray15] are
ณ  optional.
ณ 
ณ  Examples:
ณ  ---------
ณ   // sort the fieldname array, as well as the arrays containing
ณ   // field types, lengths, and decimals
ณ 
ณ   ASORTMULTR(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
ณ 
ณ  Notes:
ณ  -------
ณ  ASORTMULT() does the same, except sorts in ascending
ณ  order
ณ 
ณ  Source:
ณ  -------
ณ  S_AMSORT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function aSortmultr(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15)
local aAll    := {a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15}
local aSorter := array(len(a1))
local nArrays := pcount()
local i,nNext,aThis
for i = 1 to len(aSorter)
  aThis := {}
  for nNext = 1 to nArrays
    aadd(aThis,aAll[nNext,i])
  next
  aSorter[i] := aThis
next

asort(aSorter,,,{|x,y|x[1]>y[1]})

for i = 1 to len(aSorter)
  for nNext = 1 to nArrays
    aAll[nNext,i] := aSorter[i,nNext]
  next
next
return nil

