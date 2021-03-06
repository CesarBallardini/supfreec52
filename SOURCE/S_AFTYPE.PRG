/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AFIELDSTYPE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AFIELDSTYPE() Returns an array of field names of particular type
³ 
³  Returns:
³  --------
³  <aFields> => an array of field names of the selected type(s)
³ 
³  Syntax:
³  -------
³  AFIELDSTYPE(cTypes)
³ 
³  Description:
³  ------------
³  <cTypes> is a string containing one or more field
³  type symbols
³ 
³  Valid symbols are:
³ 
³       C   character    N   numeric
³       L   logical      D    date          M   memo
³ 
³  If no fields of the specified type(s) exist, an empty
³  array will be returned.
³ 
³  Examples:
³  ---------
³   aMemos := AFIELDSTYPE("M")  // an array of memo fields
³   aNums  := AFIELDSTYPE("N")  // an array of numeric fields
³   aNums  := AFIELDSTYPE("LD")  // an array of date &logical fields
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function afieldstype(cType)
local aStruct := dbstruct()
local aReturn := {}
if valtype(cType)=="C"
   cType := upper(cType)
   AEVAL(aStruct,{|e|iif(e[2]$cType,aadd(aReturn,e[1]),nil)} )
endif
return aReturn

//----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION QFLDSTYPE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  QFLDSTYPE() Count # of fields of a given type or types
³ 
³  Returns:
³  --------
³  <nCount> => number of fields of the specified type(s)
³ 
³  Syntax:
³  -------
³  QFLDSTYPE(cTypes)
³ 
³  Description:
³  ------------
³  <cTypes> is a string containing one or more field
³  type symbols
³ 
³  Valid symbols are:
³ 
³           C   character
³           N   numeric
³           L   logical
³           D   date
³           M   memo
³ 
³  If no fields of the specified type(s) exist, 0 will
³  be returned
³ 
³  Examples:
³  ---------
³   nMemos := AFIELDSTYPE("M")   // number of memo fields
³   nNums  := AFIELDSTYPE("N")   // number of numeric fields
³   nNums  := AFIELDSTYPE("LD")  // number of date and logical fields
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function qfldstype(cType)
local aStruct := dbstruct()
local nReturn := 0
if valtype(cType)=="C"
   cType := upper(cType)
   AEVAL(aStruct,{|e|iif(e[2]$cType,nReturn++,nil)} )
endif
return nReturn

//----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AFIELDSX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AFIELDSX() Returns an array of field names for current dbf
³ 
³  Returns:
³  --------
³  <aFields> => an array of fields for the current dbf
³ 
³  Syntax:
³  -------
³  AFIELDSX()
³ 
³  Description:
³  ------------
³  AFIELDSX() creates and returns an array of field names
³  from the current dbf. Unlike AFIELDS(), it does not
³  require an initialized array beforehand.
³ 
³  Examples:
³  ---------
³ 
³   aArray := AFIELDSX()
³   nSelect :=   mchoice( aArray ,10,10,20,20,"Pick Field")
³   if  nSelect > 0
³     ?"Field "+aArray[nSelect]+" was selected"
³   endif
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function afieldsx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[1])} )
return aReturn

//----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AFTYPESX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AFTYPESX() Returns an array of field types for current dbf
³ 
³  Returns:
³  --------
³  <aFields> => an array of field types for the current
³  dbf
³ 
³  Syntax:
³  -------
³  AFTYPESX()
³ 
³  Description:
³  ------------
³  AFTYPESX() creates and returns an array of field types
³  from the current dbf. Unlike AFIELDS(), it does not
³  require an initialized array beforehand.
³ 
³  Examples:
³  ---------
³   aArray := AFIELDSX()
³   aTypes := AFTYPESX()
³ 
³   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) >  0
³ 
³      ?"Field "+aArray[nSelect]+" was selected"
³      ?" of type     "+aTypes[nSelect]
³ 
³   endif
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function aftypesx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[2])} )
return aReturn

//----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AFLENSX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AFLENSX() Returns an array of field LENGTHS for current dbf
³ 
³  Returns:
³  --------
³  <aFields> => an array of field LENGTHS for the
³  current dbf
³ 
³  Syntax:
³  -------
³  AFLENSX()
³ 
³  Description:
³  ------------
³  AFLENSX() creates and returns an array of field
³  lengths from the current dbf. Unlike AFIELDS(), it does not
³  require an initialized array beforehand.
³ 
³  Examples:
³  ---------
³   aArray := AFIELDSX()
³   aTypes := AFTYPESX()
³   aLens  := AFLENSX()
³   aDeci  := AFDECIX()
³ 
³   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) >  0
³      ?"Field "+aArray[nSelect]+" was selected"
³      ?" of type     "+aTypes[nSelect]
³      ?" of length   "+aLens[nSelect]
³      ?" of decimals "+aDeci[nSelect]
³   endif
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function aflensx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[3])} )
return aReturn

//----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AFDECIX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AFDECIX() Returns an array of field DECIMALS for current dbf
³ 
³  Returns:
³  --------
³  <aFields> => an array of field DECIMALS for the
³  current dbf
³ 
³  Syntax:
³  -------
³  AFDECIX()
³ 
³  Description:
³  ------------
³  AFDECIX() creates and returns an array of field
³  DECIMALS from the current dbf. Unlike AFIELDS(), it does not
³  require an initialized array beforehand.
³ 
³  Examples:
³  ---------
³   aArray := AFIELDSX()
³   aDeci  := AFDECIX()
³   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) > 0
³      ?"Field "+aArray[nSelect]+" was selected"
³      ?" with  decimals "+aDeci[nSelect]
³   endif
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function afdecix
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[4])} )
return aReturn

//----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION A2TOSING()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  A2TOSING() Copies a given element from an array of arrays
³ 
³  Returns:
³  --------
³  <aSingle> => a single dimensioned array
³ 
³  Syntax:
³  -------
³  A2TOSING(a2Dim,nElement)
³ 
³  Description:
³  ------------
³  Copies a given element position from a 2 dimensioned
³  array of arrays into a single dimensioned array. <a2dim> is the
³  source 2 dimensioned array. <nElement> is the element position
³  within each sub-array to copy.
³ 
³  Examples:
³  ---------
³  Both DBSTRUCT() and DIRECTORY() are good examples.
³  Each return an array of arrays. DBSTRUCT() for instance, returns
³  the structure of the current database file in an array whose
³  length is equal to the number of fields in the database file.
³  Each element of the array is a subarray containing information
³  for one field.  The subarrays have the following format:
³ 
³        { fieldname, fieldtype, fieldlength,fielddecimals}
³ 
³  To extract a single dimensioned array of, say, the
³  field names, you could use A2TOSING() with
³  A2TOSING(DBSTRUCT(),1). For the field types you would use
³  A2TOSING(DBSTRUCT(),2), etc.
³ 
³  Here is an example with DIRECTORY()
³ 
³   aDir         := DIRECTORY()
³   aNames       := A2TOSING(adir,1)
³   nWhichFile   := mchoice(aNames,10,10,20,20,"Which File?")
³ 
³  Source:
³  -------
³  S_AFTYPE.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function a2tosing(aMult,nElement)
local aSing := {}
nElement := iif(nElement==nil,1,nElement)
AEVAL(aMult,{|e|iif(valtype(e[nElement])#nil,aadd(aSing,e[nElement]),nil)})
return aSing

