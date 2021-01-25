/*
�����������������������������������������������������������������
� FUNCTION AFIELDSTYPE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AFIELDSTYPE() Returns an array of field names of particular type
� 
�  Returns:
�  --------
�  <aFields> => an array of field names of the selected type(s)
� 
�  Syntax:
�  -------
�  AFIELDSTYPE(cTypes)
� 
�  Description:
�  ------------
�  <cTypes> is a string containing one or more field
�  type symbols
� 
�  Valid symbols are:
� 
�       C   character    N   numeric
�       L   logical      D    date          M   memo
� 
�  If no fields of the specified type(s) exist, an empty
�  array will be returned.
� 
�  Examples:
�  ---------
�   aMemos := AFIELDSTYPE("M")  // an array of memo fields
�   aNums  := AFIELDSTYPE("N")  // an array of numeric fields
�   aNums  := AFIELDSTYPE("LD")  // an array of date &logical fields
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION QFLDSTYPE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  QFLDSTYPE() Count # of fields of a given type or types
� 
�  Returns:
�  --------
�  <nCount> => number of fields of the specified type(s)
� 
�  Syntax:
�  -------
�  QFLDSTYPE(cTypes)
� 
�  Description:
�  ------------
�  <cTypes> is a string containing one or more field
�  type symbols
� 
�  Valid symbols are:
� 
�           C   character
�           N   numeric
�           L   logical
�           D   date
�           M   memo
� 
�  If no fields of the specified type(s) exist, 0 will
�  be returned
� 
�  Examples:
�  ---------
�   nMemos := AFIELDSTYPE("M")   // number of memo fields
�   nNums  := AFIELDSTYPE("N")   // number of numeric fields
�   nNums  := AFIELDSTYPE("LD")  // number of date and logical fields
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION AFIELDSX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AFIELDSX() Returns an array of field names for current dbf
� 
�  Returns:
�  --------
�  <aFields> => an array of fields for the current dbf
� 
�  Syntax:
�  -------
�  AFIELDSX()
� 
�  Description:
�  ------------
�  AFIELDSX() creates and returns an array of field names
�  from the current dbf. Unlike AFIELDS(), it does not
�  require an initialized array beforehand.
� 
�  Examples:
�  ---------
� 
�   aArray := AFIELDSX()
�   nSelect :=   mchoice( aArray ,10,10,20,20,"Pick Field")
�   if  nSelect > 0
�     ?"Field "+aArray[nSelect]+" was selected"
�   endif
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
*/
function afieldsx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[1])} )
return aReturn

//----------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AFTYPESX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AFTYPESX() Returns an array of field types for current dbf
� 
�  Returns:
�  --------
�  <aFields> => an array of field types for the current
�  dbf
� 
�  Syntax:
�  -------
�  AFTYPESX()
� 
�  Description:
�  ------------
�  AFTYPESX() creates and returns an array of field types
�  from the current dbf. Unlike AFIELDS(), it does not
�  require an initialized array beforehand.
� 
�  Examples:
�  ---------
�   aArray := AFIELDSX()
�   aTypes := AFTYPESX()
� 
�   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) >  0
� 
�      ?"Field "+aArray[nSelect]+" was selected"
�      ?" of type     "+aTypes[nSelect]
� 
�   endif
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
*/
function aftypesx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[2])} )
return aReturn

//----------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AFLENSX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AFLENSX() Returns an array of field LENGTHS for current dbf
� 
�  Returns:
�  --------
�  <aFields> => an array of field LENGTHS for the
�  current dbf
� 
�  Syntax:
�  -------
�  AFLENSX()
� 
�  Description:
�  ------------
�  AFLENSX() creates and returns an array of field
�  lengths from the current dbf. Unlike AFIELDS(), it does not
�  require an initialized array beforehand.
� 
�  Examples:
�  ---------
�   aArray := AFIELDSX()
�   aTypes := AFTYPESX()
�   aLens  := AFLENSX()
�   aDeci  := AFDECIX()
� 
�   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) >  0
�      ?"Field "+aArray[nSelect]+" was selected"
�      ?" of type     "+aTypes[nSelect]
�      ?" of length   "+aLens[nSelect]
�      ?" of decimals "+aDeci[nSelect]
�   endif
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
*/
function aflensx
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[3])} )
return aReturn

//----------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION AFDECIX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AFDECIX() Returns an array of field DECIMALS for current dbf
� 
�  Returns:
�  --------
�  <aFields> => an array of field DECIMALS for the
�  current dbf
� 
�  Syntax:
�  -------
�  AFDECIX()
� 
�  Description:
�  ------------
�  AFDECIX() creates and returns an array of field
�  DECIMALS from the current dbf. Unlike AFIELDS(), it does not
�  require an initialized array beforehand.
� 
�  Examples:
�  ---------
�   aArray := AFIELDSX()
�   aDeci  := AFDECIX()
�   if (nSelect := mchoice(aArray,10,10,20,20,"Pick Field")) > 0
�      ?"Field "+aArray[nSelect]+" was selected"
�      ?" with  decimals "+aDeci[nSelect]
�   endif
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
*/
function afdecix
local aStruct := dbstruct()
local aReturn := {}
AEVAL(aStruct,{|e|aadd(aReturn,e[4])} )
return aReturn

//----------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION A2TOSING()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  A2TOSING() Copies a given element from an array of arrays
� 
�  Returns:
�  --------
�  <aSingle> => a single dimensioned array
� 
�  Syntax:
�  -------
�  A2TOSING(a2Dim,nElement)
� 
�  Description:
�  ------------
�  Copies a given element position from a 2 dimensioned
�  array of arrays into a single dimensioned array. <a2dim> is the
�  source 2 dimensioned array. <nElement> is the element position
�  within each sub-array to copy.
� 
�  Examples:
�  ---------
�  Both DBSTRUCT() and DIRECTORY() are good examples.
�  Each return an array of arrays. DBSTRUCT() for instance, returns
�  the structure of the current database file in an array whose
�  length is equal to the number of fields in the database file.
�  Each element of the array is a subarray containing information
�  for one field.  The subarrays have the following format:
� 
�        { fieldname, fieldtype, fieldlength,fielddecimals}
� 
�  To extract a single dimensioned array of, say, the
�  field names, you could use A2TOSING() with
�  A2TOSING(DBSTRUCT(),1). For the field types you would use
�  A2TOSING(DBSTRUCT(),2), etc.
� 
�  Here is an example with DIRECTORY()
� 
�   aDir         := DIRECTORY()
�   aNames       := A2TOSING(adir,1)
�   nWhichFile   := mchoice(aNames,10,10,20,20,"Which File?")
� 
�  Source:
�  -------
�  S_AFTYPE.PRG
� 
����������������������������������������������������������������� 
*/
function a2tosing(aMult,nElement)
local aSing := {}
nElement := iif(nElement==nil,1,nElement)
AEVAL(aMult,{|e|iif(valtype(e[nElement])#nil,aadd(aSing,e[nElement]),nil)})
return aSing
