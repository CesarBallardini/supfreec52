/* example
  use customer
  a := dbf2array()
  for i = 1 to len(a)
    @0+i,0 get a[i]
  next
  read
  if aupdated(a)
    array2dbf(a)
  endif
*/


/*
�����������������������������������������������������������������
� FUNCTION DBF2ARRAY()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  DBF2ARRAY() Returns an array of values for the current record
� 
�  Returns:
�  --------
�  <aValues> => an array of values in the current record
� 
�  Syntax:
�  -------
�  DBF2ARRAY()
� 
�  Description:
�  ------------
�  Returns an array of values for the current record,
�  with the order of the array the same as the ordinal field
�  order.
� 
�  Examples:
�  ---------
�   use customer
� 
�   a := DBF2ARRAY()            // store values
�   for i = 1 to len(a)
�     @0+i,0 get a[i]
�   next
� 
�   read                        // edit them
�   if AUPDATED(a)              // if they were updated from  the DBF values
�     ARRAY2DBF(a)              // save them
�   endif
� 
�  Source:
�  -------
�  S_DBARR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION DBF2ARRAY()
local aArray := array(fcount())
local i
for i = 1 to fcount()
   aArray[i] := FIELDGET(i)
next
return aArray

//-----------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION ARRAY2DBF()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ARRAY2DBF() Replaces current record with values in an array
� 
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  ARRAY2DBF(aValues)
� 
�  Description:
�  ------------
�  Replaces the values in the current record with the
�  values in <aValues>. Array order is assumed to be the same as
�  the ordinal field order.
� 
�  Examples:
�  ---------
�   use customer
�   a := DBF2ARRAY()            // store values
� 
�   for i = 1 to len(a)
�     @0+i,0 get a[i]
�   next
�   read                        // edit them
� 
�   if AUPDATED(a)              // if they were updated from
�                               // the DBF values
�     ARRAY2DBF(a)              // save them
�   endif
� 
�  Source:
�  -------
�  S_DBARR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION ARRAY2DBF(aArray)
local i
for i = 1 to fcount()
  FIELDPUT(i,aArray[i])
next
return nil

//-----------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AUPDATED()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AUPDATED() Determines if array contains updated values for record
� 
� 
�  Returns:
�  --------
�  <lUpdated> => Are the values in the array updated
� 
�  Syntax:
�  -------
�  AUPDATED(aCheck)
� 
�  Description:
�  ------------
�  Compares the values in an array (usually created with
�  a call to DBF2ARRAY() )  <aCheck> with the current values in the
�  current record. The order of the array is presumed to match the
�  order of the fields, and to be of length fcount(). If the values
�  in the array are updated (changed), True is returned.
� 
�  Examples:
�  ---------
�   use customer
�   a := DBF2ARRAY()            // store values
�   for i = 1 to len(a)
�     @0+i,0 get a[i]
�   next
�   read                               // edit them
�   if AUPDATED(a)              // if they were updated from  the DBF values
�     ARRAY2DBF(a)              // save them
�   endif
� 
�  Source:
�  -------
�  S_DBARR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION AUPDATED(aArray)
local i
local lUpdated := .f.
for i = 1 to fcount()
  if aArray[i]#FIELDGET(i)
    lUpdated := .t.
    exit
  endif
next
return lUpdated

//-----------------------------------------------------------------
