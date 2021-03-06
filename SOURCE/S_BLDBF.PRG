//± CHANGED TO USE DBCREATE()
//± DOOMED IN NEXT VERSION

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BLDDBF()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BLDDBF() Create a DBF from a delimited string or an array
³ 
³ 
³  Returns:
³  --------
³  <lSuccess> => Success or failure
³ 
³  Syntax:
³  -------
³  BLDDBF(cDbfName,acDefinition)
³ 
³  Description:
³  ------------
³  Creates DBF file named <cDbfName> from delimited
³  strings in <acDefinition>.
³ 
³  <acDefinition>  is either:
³ 
³  1.  a Delimited string in the form
³      "name,type,[size],[decimals]:name,type..."
³      Fields delimited by colon, field elements delimited by commas
³ 
³  2.  an array of delimited strings in
³      the form "name,type,[size],[decimals]". One field
³      per array element, field elements delimited by
³      commas.
³ 
³  Examples:
³  ---------
³   1. Passing long delimited string
³ 
³       BLDDBF('CUSTOMER','LNAME,C,15:FNAME,;
³         C,10:AGE,N,2:PROSPECT,L:')
³ 
³   2. Passing array of short delimited strings
³ 
³       aNewdbf       := array(4)
³       aNewdbf[1]    :="LNAME,C,15"
³       aNwdbf[2]     :="FNAME,C,10"
³       aNewdbf[3]    :="AGE,N,2"
³       aNewdbf[4]    :="PROSPECT,L"
³       lSuccess      := BLDDBF('CUSTOMER',aNewdbf)
³ 
³  Notes:
³  -------
³  BLDDBF() expects an unused area to work in, and will
³  return .f. if it detects a DBF open in the current area. An
³  overwrite will not be allowed. BLDDBF() uses Clipper's low level
³  file functions to create the DBF file. You could also (and
³  should) use Clipper 5.01's DBCREATE() function. This function is
³  here mainly for compatibility with previous SuperLibs.
³ 
³  Source:
³  -------
³  S_BLDBF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION blddbf(cDbfName,aDefinition)

local cFieldDescription,cFieldName,cFieldType,nFieldLen,nFieldDec
local nIterator,cDefinitionType,nLenDefinition
local aWorkNames := {}
local aWorkTypes := {}
local aWorkLens  := {}
local aWorkDecs  := {}

IF USED()
  msg("BLDDBF()- Datafile in use - cannot create")
  RETURN .F.
ENDIF

if !(".DBF"$UPPER(cDbfName) )
  cDbfName = cDbfName+".DBF"
endif

if !("\"$cDbfName .or. ":"$cDbfName)
   cDbfName = getdfp()+cDbfName
endif

IF FILE(cDbfName)
  *- don't want to overwrite an existing dbf
  msg("BLDDBF()- Datafile "+cDbfName+" exists - cannot overwrite")
  RETURN .F.
ENDIF

cDefinitionType := VALTYPE(aDefinition)
nLenDefinition  := LEN(aDefinition)

nIterator = 0
DO WHILE .T.
  cFieldDescription  := ""
  nIterator++
  *- take out the next section between the ":"
  *- or if param 2 is an array, the next element
  IF cDefinitionType == "C"
    cFieldDescription = takeout(aDefinition,":",nIterator)
  ELSEIF nIterator <= nLenDefinition
    cFieldDescription = aDefinition[nIterator]
  ENDIF
  *- from that section, take out the sections between the ","
  *- as field name, field type, length and description
  IF !EMPTY(cFieldDescription)
    cFieldName := ''
    cFieldType := ''
    nFieldLen  := 0
    nFieldDec  := 0
    cFieldName := UPPER(takeout(cFieldDescription,",",1))
    cFieldType := UPPER(takeout(cFieldDescription,",",2))
    nFieldLen  := VAL(takeout(cFieldDescription,",",3))
    nFieldDec  := VAL(takeout(cFieldDescription,",",4))
    
    *- fill in length/decimals on LDM and C types
    DO CASE
    CASE cFieldType == "L"
      nFieldLen := 1
      nFieldDec := 0
    CASE cFieldType == "D"
      nFieldLen := 8
      nFieldDec := 0
    CASE cFieldType == "M"
      nFieldLen := 10
      nFieldDec := 0
    CASE cFieldType == "C"
      nFieldDec := 0
    ENDCASE
    
    *- if it looks like a valid field description, plug it in
    IF !EMPTY(cFieldName) .AND. (cFieldType $ "CNDLM")
      AADD(aWorkNames,cFieldName)
      AADD(aWorkTypes,cFieldType)
      AADD(aWorkLens,nFieldLen)
      AADD(aWorkDecs,nFieldDec)
    endif
  ELSE
    *- if no more fields
    nIterator := nIterator-1
    EXIT
  ENDIF
ENDDO

if nIterator > 0
 makemydbf(cDbfName,aWorkNames,aWorkTypes,aWorkLens,aWorkDecs)
 IF SNET_USE(cDbfName,"",.F.,5)
     RETURN .T.
 ELSE
     RETURN .F.
 ENDIF
else
 RETURN .F.
endif
return .f.

static function makemydbf(cDbfName,aFieldNames,aFieldTypes,;
                          aFieldLens,aFieldDec)
local nIter
local aStruc := {}
for nIter := 1 to len(aFieldNames)
  aadd(aStruc,{aFieldnames[nIter],aFieldTypes[nIter],;
               aFieldLens[nIter],aFieldDec[nIter] } )
next
DBCREATE(cDbfName, aStruc)
RETURN NIL
