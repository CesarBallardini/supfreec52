/*
�����������������������������������������������������������������
� FUNCTION FILLARR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  FILLARR() Fill type, length, decimal arrays
� 
�  Returns:
�  --------
�  Nothing - works on arrays passed
� 
�  Syntax:
�  -------
�  FILLARR(aNames,aTypes,[aLens],[aDeci])
� 
�  Description:
�  ------------
�  Fills in TYPE <aTypes> , LENGTH [aLens] and DECIMAL
�  [aDeci] arrays given a FIELDNAME array <aNames>.
� 
�  Arrays (3 and 4) are optional.
� 
�  Examples:
�  ---------
�   nFields   :=LEN(aFieldNames)
�   aFldtypes     := array(nFields)
�   aFldLens      := array(nFields)
�   aFldDeci      := array(nFields)
�   FILLAR(aFieldNames,aFldTypes,aFldLens,aFldDeci)
� 
�  Warnings:
�  ----------
�  Macro expands an expression to obtain type-could
�  crash if expression passed is invalid. Not really meant for
�  expressions, but people will pass them from time to time.
� 
�  Notes:
�  -------
�  In most circumstances you would fill all of these
�  arrays with one call to AFIELDS(), but there are exceptions.
� 
�  Source:
�  -------
�  S_FILLAR.PRG
� 
����������������������������������������������������������������� 
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
