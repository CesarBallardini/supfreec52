/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FILLARR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FILLARR() Fill type, length, decimal arrays
³ 
³  Returns:
³  --------
³  Nothing - works on arrays passed
³ 
³  Syntax:
³  -------
³  FILLARR(aNames,aTypes,[aLens],[aDeci])
³ 
³  Description:
³  ------------
³  Fills in TYPE <aTypes> , LENGTH [aLens] and DECIMAL
³  [aDeci] arrays given a FIELDNAME array <aNames>.
³ 
³  Arrays (3 and 4) are optional.
³ 
³  Examples:
³  ---------
³   nFields   :=LEN(aFieldNames)
³   aFldtypes     := array(nFields)
³   aFldLens      := array(nFields)
³   aFldDeci      := array(nFields)
³   FILLAR(aFieldNames,aFldTypes,aFldLens,aFldDeci)
³ 
³  Warnings:
³  ----------
³  Macro expands an expression to obtain type-could
³  crash if expression passed is invalid. Not really meant for
³  expressions, but people will pass them from time to time.
³ 
³  Notes:
³  -------
³  In most circumstances you would fill all of these
³  arrays with one call to AFIELDS(), but there are exceptions.
³ 
³  Source:
³  -------
³  S_FILLAR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION fillarr(aFieldNames, aFieldTypes, aFieldLens, aFieldDecs)
local nFieldCount,nIterator,expWhoKnows
local cType,nLen,nDec

nFieldCount     := aleng(aFieldNames)
IF Valtype(aFieldDecs)=="A"
  Afill(aFieldDecs,0)
ENDIF
for nIterator = 1 TO nFieldCount
  cType := " "
  nLen  := 0
  nDec  := 0
  aFieldNames[nIterator] := upper(aFieldNames[nIterator])
  checkfield(aFieldnames[nIterator],@cType,@nLen,@nDec)
  aFieldTypes[nIterator] := cType
  if aFieldLens#nil
    aFieldLens[nIterator] := nLen
  endif
  if aFieldDecs#nil
    aFieldDecs[nIterator] := nDec
  endif
NEXT
RETURN ''

//-------------------------------------------------------------------
static function checkfield(f,crFieldType,crFieldLen,crFieldDec)
local lAliased := "->"$f
local cFieldName,cAliasNAme,cType,nLen,nDec
local lIsField,expFieldVal
local aStruct,nFieldPos
if lAliased
  cFieldName    := subst(f,at("->",f)+2)
  cAliasNAme    := left(f,at("->",f)-1)
else
  cFieldName    := f
  cAliasNAme    := alias()
endif
if select(cAliasNAme)==0
  lIsField := .f.
else
  lIsField := ( (cAliasNAme)->(fieldpos(cFieldName)) ) > 0
endif
if lIsfield
  aStruct      := (cAliasName)->( dbstruct() )
  expFieldVal := (cAliasNAme)->(fieldget(fieldpos(cFieldName)) )

  if (nFieldPos := ascan(aStruct,{|e|trim(e[1])==trim(cFieldName)}) ) > 0
    crFieldType := aStruct[nFieldPos,2]
    crFieldLen  := aStruct[nFieldPos,3]
    crFieldDec  := aStruct[nFieldPos,4]
  else
    crFieldType := valtype(expFieldVal)
    crFieldLen  := len(trans(expFieldVal,""))
    crFieldDec  := rat(".",trans(expFieldVal,""))
    crFieldDec  := iif(crFieldDec>0,crFieldLen-crFieldDec,0)
  endif
else   // some kind of expression, must macro expand it
  expFieldVal := &f
  crFieldType := valtype(expFieldVal)
  crFieldLen  := len(trans(expFieldVal,""))
  crFieldDec  := rat(".",trans(expFieldVal,""))
  crFieldDec  := iif(crFieldDec>0,crFieldLen-crFieldDec,0)
endif
return nil

