/*
�����������������������������������������������������������������
� FUNCTION ASORTMULT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ASORTMULT() Sort multiple arrays on order of single array
� 
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  ASORTMULT(aArray1,aArray2,[...aArray15])
� 
�  Description:
�  ------------
�  Sorts [aArray2] through [aArray15] based on the sort
�  results of [aArray1]. All arrays must be of the same length!
�  [aArray3]- [aArray15] are optional.
� 
�  Examples:
�  ---------
�   // sort the fieldname array, as well as the arrays  containing
�   // field types, lengths, and decimals
� 
�   ASORTMULT(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
� 
�  Notes:
�  -------
�  ASORTMULTR() does the same, except sorts in reverse
�  order
� 
�  Source:
�  -------
�  S_AMSORT.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION ASORTMULTR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ASORTMULTR() Reverse sort multiple arrays on order of single array
� 
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  ASORTMULTR(aArray1,aArray2,[...aArray15])
� 
�  Description:
�  ------------
�  Sorts [aArray2] through [aArray15] based on the sort
�  results of [aArray1]. Sort is in reverse (descending) order. All
�  arrays must be of the same length! [aArray3]-[aArray15] are
�  optional.
� 
�  Examples:
�  ---------
�   // sort the fieldname array, as well as the arrays containing
�   // field types, lengths, and decimals
� 
�   ASORTMULTR(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
� 
�  Notes:
�  -------
�  ASORTMULT() does the same, except sorts in ascending
�  order
� 
�  Source:
�  -------
�  S_AMSORT.PRG
� 
����������������������������������������������������������������� 
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
