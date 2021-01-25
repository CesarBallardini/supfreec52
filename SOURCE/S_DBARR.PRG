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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DBF2ARRAY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DBF2ARRAY() Returns an array of values for the current record
ณ 
ณ  Returns:
ณ  --------
ณ  <aValues> => an array of values in the current record
ณ 
ณ  Syntax:
ณ  -------
ณ  DBF2ARRAY()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns an array of values for the current record,
ณ  with the order of the array the same as the ordinal field
ณ  order.
ณ 
ณ  Examples:
ณ  ---------
ณ   use customer
ณ 
ณ   a := DBF2ARRAY()            // store values
ณ   for i = 1 to len(a)
ณ     @0+i,0 get a[i]
ณ   next
ณ 
ณ   read                        // edit them
ณ   if AUPDATED(a)              // if they were updated from  the DBF values
ณ     ARRAY2DBF(a)              // save them
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_DBARR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ARRAY2DBF()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ARRAY2DBF() Replaces current record with values in an array
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  ARRAY2DBF(aValues)
ณ 
ณ  Description:
ณ  ------------
ณ  Replaces the values in the current record with the
ณ  values in <aValues>. Array order is assumed to be the same as
ณ  the ordinal field order.
ณ 
ณ  Examples:
ณ  ---------
ณ   use customer
ณ   a := DBF2ARRAY()            // store values
ณ 
ณ   for i = 1 to len(a)
ณ     @0+i,0 get a[i]
ณ   next
ณ   read                        // edit them
ณ 
ณ   if AUPDATED(a)              // if they were updated from
ณ                               // the DBF values
ณ     ARRAY2DBF(a)              // save them
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_DBARR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ARRAY2DBF(aArray)
local i
for i = 1 to fcount()
  FIELDPUT(i,aArray[i])
next
return nil

//-----------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AUPDATED()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AUPDATED() Determines if array contains updated values for record
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <lUpdated> => Are the values in the array updated
ณ 
ณ  Syntax:
ณ  -------
ณ  AUPDATED(aCheck)
ณ 
ณ  Description:
ณ  ------------
ณ  Compares the values in an array (usually created with
ณ  a call to DBF2ARRAY() )  <aCheck> with the current values in the
ณ  current record. The order of the array is presumed to match the
ณ  order of the fields, and to be of length fcount(). If the values
ณ  in the array are updated (changed), True is returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   use customer
ณ   a := DBF2ARRAY()            // store values
ณ   for i = 1 to len(a)
ณ     @0+i,0 get a[i]
ณ   next
ณ   read                               // edit them
ณ   if AUPDATED(a)              // if they were updated from  the DBF values
ณ     ARRAY2DBF(a)              // save them
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_DBARR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

