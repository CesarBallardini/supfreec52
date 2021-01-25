/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AFIELDSTYPE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AFIELDSTYPE() Returns an array of field names of particular type
ณ 
ณ  Returns:
ณ  --------
ณ  <aFields> => an array of field names of the selected type(s)
ณ 
ณ  Syntax:
ณ  -------
ณ  AFIELDSTYPE(cTypes)
ณ 
ณ  Description:
ณ  ------------
ณ  <cTypes> is a string containing one or more field
ณ  type symbols
ณ 
ณ  Valid symbols are:
ณ 
ณ       C   character    N   numeric
ณ       L   logical      D    date          M   memo
ณ 
ณ  If no fields of the specified type(s) exist, an empty
ณ  array will be returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   aMemos := AFIELDSTYPE("M")  // an array of memo fields
ณ   aNums  := AFIELDSTYPE("N")  // an array of numeric fields
ณ   aNums  := AFIELDSTYPE("LD")  // an array of date &logical fields
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION QFLDSTYPE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  QFLDSTYPE() Count # of fields of a given type or types
ณ 
ณ  Returns:
ณ  --------
ณ  <nCount> => number of fields of the specified type(s)
ณ 
ณ  Syntax:
ณ  -------
ณ  QFLDSTYPE(cTypes)
ณ 
ณ  Description:
ณ  ------------
ณ  <cTypes> is a string containing one or more field
ณ  type symbols
ณ 
ณ  Valid symbols are:
ณ 
ณ           C   character
ณ           N   numeric
ณ           L   logical
ณ           D   date
ณ           M   memo
ณ 
ณ  If no fields of the specified type(s) exist, 0 will
ณ  be returned
ณ 
ณ  Examples:
ณ  ---------
ณ   nMemos := AFIELDSTYPE("M")   // number of memo fields
ณ   nNums  := AFIELDSTYPE("N")   // number of numeric fields
ณ   nNums  := AFIELDSTYPE("LD")  // number of date and logical fields
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AFIELDSX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AFIELDSX() Returns an array of field names for current dbf
ณ 
ณ  Returns:
ณ  --------
ณ  <aFields> => an array of fields for the current dbf
ณ 
ณ  Syntax:
ณ  -------
ณ  AFIELDSX()
ณ 
ณ  Description:
ณ  ------------
ณ  AFIELDSX() creates and returns an array of field names
ณ  from the current dbf. Unlike AFIELDS(), it does not
ณ  require an initialized array beforehand.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   aArray := AFIELDSX()
ณ   nSelect :=   mchoice( aArray ,10,10,20,20,"Pick Field")
ณ   if  nSelect > 0
ณ     ?"Field "+aArray[nSelect]+" was selected"
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function afieldsx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[1])} )
return aReturn

//----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AFTYPESX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AFTYPESX() Returns an array of field types for current dbf
ณ 
ณ  Returns:
ณ  --------
ณ  <aFields> => an array of field types for the current
ณ  dbf
ณ 
ณ  Syntax:
ณ  -------
ณ  AFTYPESX()
ณ 
ณ  Description:
ณ  ------------
ณ  AFTYPESX() creates and returns an array of field types
ณ  from the current dbf. Unlike AFIELDS(), it does not
ณ  require an initialized array beforehand.
ณ 
ณ  Examples:
ณ  ---------
ณ   aArray := AFIELDSX()
ณ   aTypes := AFTYPESX()
ณ 
ณ   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) >  0
ณ 
ณ      ?"Field "+aArray[nSelect]+" was selected"
ณ      ?" of type     "+aTypes[nSelect]
ณ 
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function aftypesx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[2])} )
return aReturn

//----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AFLENSX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AFLENSX() Returns an array of field LENGTHS for current dbf
ณ 
ณ  Returns:
ณ  --------
ณ  <aFields> => an array of field LENGTHS for the
ณ  current dbf
ณ 
ณ  Syntax:
ณ  -------
ณ  AFLENSX()
ณ 
ณ  Description:
ณ  ------------
ณ  AFLENSX() creates and returns an array of field
ณ  lengths from the current dbf. Unlike AFIELDS(), it does not
ณ  require an initialized array beforehand.
ณ 
ณ  Examples:
ณ  ---------
ณ   aArray := AFIELDSX()
ณ   aTypes := AFTYPESX()
ณ   aLens  := AFLENSX()
ณ   aDeci  := AFDECIX()
ณ 
ณ   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) >  0
ณ      ?"Field "+aArray[nSelect]+" was selected"
ณ      ?" of type     "+aTypes[nSelect]
ณ      ?" of length   "+aLens[nSelect]
ณ      ?" of decimals "+aDeci[nSelect]
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function aflensx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[3])} )
return aReturn

//----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AFDECIX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AFDECIX() Returns an array of field DECIMALS for current dbf
ณ 
ณ  Returns:
ณ  --------
ณ  <aFields> => an array of field DECIMALS for the
ณ  current dbf
ณ 
ณ  Syntax:
ณ  -------
ณ  AFDECIX()
ณ 
ณ  Description:
ณ  ------------
ณ  AFDECIX() creates and returns an array of field
ณ  DECIMALS from the current dbf. Unlike AFIELDS(), it does not
ณ  require an initialized array beforehand.
ณ 
ณ  Examples:
ณ  ---------
ณ   aArray := AFIELDSX()
ณ   aDeci  := AFDECIX()
ณ   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) > 0
ณ      ?"Field "+aArray[nSelect]+" was selected"
ณ      ?" with  decimals "+aDeci[nSelect]
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function afdecix
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[4])} )
return aReturn

//----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION A2TOSING()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  A2TOSING() Copies a given element from an array of arrays
ณ 
ณ  Returns:
ณ  --------
ณ  <aSingle> => a single dimensioned array
ณ 
ณ  Syntax:
ณ  -------
ณ  A2TOSING(a2Dim,nElement)
ณ 
ณ  Description:
ณ  ------------
ณ  Copies a given element position from a 2 dimensioned
ณ  array of arrays into a single dimensioned array. <a2dim> is the
ณ  source 2 dimensioned array. <nElement> is the element position
ณ  within each sub-array to copy.
ณ 
ณ  Examples:
ณ  ---------
ณ  Both DBSTRUCT() and DIRECTORY() are good examples.
ณ  Each return an array of arrays. DBSTRUCT() for instance, returns
ณ  the structure of the current database file in an array whose
ณ  length is equal to the number of fields in the database file.
ณ  Each element of the array is a subarray containing information
ณ  for one field.  The subarrays have the following format:
ณ 
ณ        { fieldname, fieldtype, fieldlength,fielddecimals}
ณ 
ณ  To extract a single dimensioned array of, say, the
ณ  field names, you could use A2TOSING() with
ณ  A2TOSING(DBSTRUCT(),1). For the field types you would use
ณ  A2TOSING(DBSTRUCT(),2), etc.
ณ 
ณ  Here is an example with DIRECTORY()
ณ 
ณ   aDir         := DIRECTORY()
ณ   aNames       := A2TOSING(adir,1)
ณ   nWhichFile   := mchoice(aNames,10,10,20,20,"Which File?")
ณ 
ณ  Source:
ณ  -------
ณ  S_AFTYPE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function a2tosing(aMult,nElement)
local aSing := {}
nElement := iif(nElement==nil,1,nElement)
AEVAL(aMult,{|e|iif(valtype(e[nElement])#nil,aadd(aSing,e[nElement]),nil)})
return aSing

