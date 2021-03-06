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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION DBF2ARRAY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  DBF2ARRAY() Returns an array of values for the current record
³ 
³  Returns:
³  --------
³  <aValues> => an array of values in the current record
³ 
³  Syntax:
³  -------
³  DBF2ARRAY()
³ 
³  Description:
³  ------------
³  Returns an array of values for the current record,
³  with the order of the array the same as the ordinal field
³  order.
³ 
³  Examples:
³  ---------
³   use customer
³ 
³   a := DBF2ARRAY()            // store values
³   for i = 1 to len(a)
³     @0+i,0 get a[i]
³   next
³ 
³   read                        // edit them
³   if AUPDATED(a)              // if they were updated from  the DBF values
³     ARRAY2DBF(a)              // save them
³   endif
³ 
³  Source:
³  -------
³  S_DBARR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ARRAY2DBF()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ARRAY2DBF() Replaces current record with values in an array
³ 
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  ARRAY2DBF(aValues)
³ 
³  Description:
³  ------------
³  Replaces the values in the current record with the
³  values in <aValues>. Array order is assumed to be the same as
³  the ordinal field order.
³ 
³  Examples:
³  ---------
³   use customer
³   a := DBF2ARRAY()            // store values
³ 
³   for i = 1 to len(a)
³     @0+i,0 get a[i]
³   next
³   read                        // edit them
³ 
³   if AUPDATED(a)              // if they were updated from
³                               // the DBF values
³     ARRAY2DBF(a)              // save them
³   endif
³ 
³  Source:
³  -------
³  S_DBARR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION ARRAY2DBF(aArray)
local i
for i = 1 to fcount()
  FIELDPUT(i,aArray[i])
next
return nil

//-----------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AUPDATED()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AUPDATED() Determines if array contains updated values for record
³ 
³ 
³  Returns:
³  --------
³  <lUpdated> => Are the values in the array updated
³ 
³  Syntax:
³  -------
³  AUPDATED(aCheck)
³ 
³  Description:
³  ------------
³  Compares the values in an array (usually created with
³  a call to DBF2ARRAY() )  <aCheck> with the current values in the
³  current record. The order of the array is presumed to match the
³  order of the fields, and to be of length fcount(). If the values
³  in the array are updated (changed), True is returned.
³ 
³  Examples:
³  ---------
³   use customer
³   a := DBF2ARRAY()            // store values
³   for i = 1 to len(a)
³     @0+i,0 get a[i]
³   next
³   read                               // edit them
³   if AUPDATED(a)              // if they were updated from  the DBF values
³     ARRAY2DBF(a)              // save them
³   endif
³ 
³  Source:
³  -------
³  S_DBARR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

