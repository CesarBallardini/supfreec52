/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ASORTMULT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ASORTMULT() Sort multiple arrays on order of single array
³ 
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  ASORTMULT(aArray1,aArray2,[...aArray15])
³ 
³  Description:
³  ------------
³  Sorts [aArray2] through [aArray15] based on the sort
³  results of [aArray1]. All arrays must be of the same length!
³  [aArray3]- [aArray15] are optional.
³ 
³  Examples:
³  ---------
³   // sort the fieldname array, as well as the arrays  containing
³   // field types, lengths, and decimals
³ 
³   ASORTMULT(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
³ 
³  Notes:
³  -------
³  ASORTMULTR() does the same, except sorts in reverse
³  order
³ 
³  Source:
³  -------
³  S_AMSORT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ASORTMULTR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ASORTMULTR() Reverse sort multiple arrays on order of single array
³ 
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  ASORTMULTR(aArray1,aArray2,[...aArray15])
³ 
³  Description:
³  ------------
³  Sorts [aArray2] through [aArray15] based on the sort
³  results of [aArray1]. Sort is in reverse (descending) order. All
³  arrays must be of the same length! [aArray3]-[aArray15] are
³  optional.
³ 
³  Examples:
³  ---------
³   // sort the fieldname array, as well as the arrays containing
³   // field types, lengths, and decimals
³ 
³   ASORTMULTR(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
³ 
³  Notes:
³  -------
³  ASORTMULT() does the same, except sorts in ascending
³  order
³ 
³  Source:
³  -------
³  S_AMSORT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

