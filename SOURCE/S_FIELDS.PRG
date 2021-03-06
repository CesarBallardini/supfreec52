/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISFIELD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISFIELD() Determines if an expression is the name of a field
³ 
³  Returns:
³  --------
³  <lIsfield> => Is the expression a field
³ 
³  Syntax:
³  -------
³  ISFIELD(cExpress)
³ 
³  Description:
³  ------------
³  Determines if <cExpress> contains the name of a
³  field. If <cExpress> contains an alias, the area of the alias
³  will be checked.
³ 
³  Examples:
³  ---------
³   isfield( "LASTNAME" )            // actual field, returns  .t.
³ 
³   isfield( "CUSTOMER->LASTNAME")   // actual field, returns  .t.
³ 
³   isfield( "LEFT(LNAME,5)" )       // expression, returns .f.
³ 
³  Notes:
³  -------
³  Companion functions are ISTHISAREA(), ISEDITABLE(),
³  PARSFIELD(), PARSALIAS(), EXPBLOCK(), WORKBLOCK()
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function isfield(f)
local lAliased := "->"$f
local cFieldName,cAliasNAme
local lIsField, nFieldPos
if lAliased
  cFieldName    := parsfield(f)
  cAliasNAme    := parsalias(f)
else
  cFieldName     := f
  cAliasNAme := alias()
endif
if select(cAliasName)==0
  lIsField := .f.
else
  nFieldPos := (cAliasNAme)->(fieldpos(alltrim(cFieldName)))
  lIsField := nFieldPos > 0 .and. ;
              upper(fieldname(nFieldPos))==upper(cFieldName)
endif
return lIsField

//------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISTHISAREA()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISTHISAREA() Determines if expression is the name of a field
³  in this area
³ 
³  Returns:
³  --------
³  <lIsThisArea> => Is the expression a field in this
³  area
³ 
³  Syntax:
³  -------
³  ISTHISAREA(cExpress)
³ 
³  Description:
³  ------------
³  Determines if <cExpress> contains the name of a field
³  in this area.
³ 
³  If <cExpress> contains an alias, the area of the
³  alias will be checked.
³ 
³  ISTHISAREA() first calls ISFIELD() to ensure the
³  expression is a field name.
³ 
³  If a field in another area is passed, and no alias is
³  used, False will be returned.
³ 
³  Examples:
³  ---------
³   ISTHISAREA("LASTNAME")             // actual field,  returns .t.
³ 
³   ISTHISAREA("CUSTOMER->LASTNAME")  // actual field, returns .t.
³ 
³   ISTHISAREA("LEFT(LNAME,5)")        // expression, returns  .f.
³ 
³   ISTHISAREA("AGENT")                //field, but in another area. Returns .f.
³ 
³  Notes:
³  -------
³  Companion functions are ISFIELD(), ISEDITABLE(),
³  PARSFIELD(), PARSALIAS(), EXPBLOCK(), WORKBLOCK()
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function isthisarea(f)
local lAliased := "->"$f
local cFieldName,cAliasNAme
local lIsThisArea := .f.
if isfield(f)
  lIsThisArea := .t.
  if lAliased
    cAliasNAme    := parsalias(f)
    lIsThisArea   := ALLTRIM(UPPER(cAliasName))==ALLTRIM(UPPER(alias()))
  endif
endif
return lIsThisArea

//------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION EXPBLOCK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  EXPBLOCK() Returns a codeblock to evaluate an expresson
³ 
³  Returns:
³  --------
³  <bBlock> => codeblock to evaluate an expression
³ 
³  Syntax:
³  -------
³  EXPBLOCK(cExpress)
³ 
³  Description:
³  ------------
³  Returns a codeblock built around the expression in
³  cExpress.
³ 
³  Using EVAL() on the codeblock will return the current
³  value of the expression.
³ 
³  Examples:
³  ---------
³   cExp := "UPPER(LEFT(CUSTOMER->LNAME,5))"
³   bExp := EXPBLOCK(cExp)
³ 
³   ?eval(bExp)
³     // displays current value of customer->lname, upper,left 5
³ 
³  Notes:
³  -------
³  See also WORKBLOCK()
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function expblock(cExpress)
local bBlock
bBlock := &("{||"+cExpress+"}")
return bBlock

//------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION WORKBLOCK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  WORKBLOCK() Returns a set-get block for field named in an
³  expression
³ 
³  Returns:
³  --------
³  <bBlock> => a set-get block
³ 
³  Syntax:
³  -------
³  WORKBLOCK(cExpress)
³ 
³  Description:
³  ------------
³  Determines the work area and field name in <cExpress>
³  and returns a FIELDWBLOCK() created block for it.
³ 
³  Examples:
³  ---------
³   cExpr := "CUSTOMER->LNAME"
³ 
³   bExpr := WORKBLOCK(cExpr)
³ 
³   ?eval(bExpr)              // displays value
³ 
³   ?eval(bExpr,"SMITH")    // sets new value
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function workblock(cExpress)
local workarea
if isfield(cExpress)
  if "->"$cExpress
    workarea := select( parsalias(cExpress) )
  else
    workarea := select()
  endif
  return fieldwblock(parsfield(cExpress),workarea)
endif
return nil

//------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PARSALIAS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PARSALIAS() Extracts the name of the alias from an expression
³ 
³  Returns:
³  --------
³  <cAlias> => name of the alias
³ 
³  Syntax:
³  -------
³  PARSALIAS(cExpress)
³ 
³  Description:
³  ------------
³  Returns the ALIAS part of cExpress. If <cExpress> is
³  not prefaced
³ 
³  with an alias ( XXXX-> ) the current ALIAS() is
³  returned.
³ 
³  Examples:
³  ---------
³   cExpr := "CUSTOMER->LASTNAME"
³ 
³   IF ISFIELD(cExpr)
³     ?PARSALIAS(cExpr)  // displays CUSTOMER
³     ?PARSFIELD(cExpr)  // displays LASTNAME
³   ENDIF
³ 
³  Warnings:
³  ----------
³  Does not verify if this is a valid field. Use
³  ISFIELD().
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function parsalias(cExpress)
if "->"$cExpress
  return left(cExpress,at("-",cExpress)-1)
else
  return alias()
endif
return ""

//------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PARSFIELD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PARSFIELD() Extracts the name of the field from an expression
³ 
³  Returns:
³  --------
³  <cField> => name of the field
³ 
³  Syntax:
³  -------
³  PARSFIELD(cExpress)
³ 
³  Description:
³  ------------
³  Returns the field name part of cExpress
³ 
³  Examples:
³  ---------
³   cExpr := "CUSTOMER->LASTNAME"
³ 
³   IF ISFIELD(cExpr)
³     ?PARSALIAS(cExpr)  // displays CUSTOMER
³     ?PARSFIELD(cExpr)  // displays LASTNAME
³   ENDIF
³ 
³  Warnings:
³  ----------
³  Does not verify if this is a valid field. Use
³  ISFIELD().
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function parsfield(cExpress)
if "->"$cExpress
  return subst(cExpress,at(">",cExpress)+1)
else
  return cExpress
endif
return ''


//--------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FIELDTYPEX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FIELDTYPEX() Returns type of field
³ 
³ 
³  Returns:
³  --------
³  <cType> => field TYPE
³ 
³  Syntax:
³  -------
³  FIELDTYPEX(expField)
³ 
³  Description:
³  ------------
³  <expField> is either the numeric position of the
³  field in the database, or the name of the field.
³ 
³  Examples:
³  ---------
³   IF FIELDTYPEX(i) =="N"
³     nSum += fieldget(i)
³   ENDIF
³ 
³  Notes:
³  -------
³  Just using VALTYPE(FIELDGET(n)) is fine, except that
³  memo fields then show as type "C". Not always wanted.
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function fieldtypex(expField)
local aStruc    := dbstructx(expField)
local nFieldPos := iif(valtype(expField)=="N",expField,fieldposx(expField))
local cType     := "U"
if nFieldPos > 0 .and. nFieldPos <= len(aStruc)
   cType := aStruc[nFieldPos,2]
endif
return cType

//--------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FIELDLENX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FIELDLENX() Returns length of field
³ 
³  Returns:
³  --------
³  <nLength> => field LENGTH
³ 
³  Syntax:
³  -------
³  FIELDLENX(expField)
³ 
³  Description:
³  ------------
³  <expField> is either the numeric position of the
³  field in the database, or the name of the field.
³ 
³  Examples:
³  ---------
³   FOR i = 1 to fcount()
³     nSumLengths += FIELDLENX(i)
³   ENDIF
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function fieldlenx(expField)
local aStruc    := dbstructx(expField)
local nFieldPos := iif(valtype(expField)=="N",expField,fieldposx(expField))
local cLen      := 0
if nFieldPos > 0 .and. nFieldPos <= len(aStruc)
   cLen  := aStruc[nFieldPos,3]
endif
return cLen

//--------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FIELDDECX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FIELDDECX() Returns decimals of field
³ 
³  Returns:
³  --------
³  <nDec> => field DECIMALS
³ 
³  Syntax:
³  -------
³  FIELDDECX(expField)
³ 
³  Description:
³  ------------
³  <expField> is either the numeric position of the
³  field in the database, or the name of the field.
³ 
³  Examples:
³  ---------
³   FOR i = 1 to fcount()
³     nSumDecs += FIELDDECX(i)
³     // could also be:  nSumDecs += FIELDDECX(FIELD(i))
³   ENDIF
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function fielddecx(expField)
local aStruc    := dbstructx(expField)
local nFieldPos := iif(valtype(expField)=="N",expField,fieldposx(expField))
local cDec      := 0
if nFieldPos > 0 .and. nFieldPos <= len(aStruc)
   cDec  := aStruc[nFieldPos,4]
endif
return cDec

//--------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FIELDPOSX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FIELDPOSX() Returns position of field named in expression
³ 
³  Returns:
³  --------
³  <nPosition> => natuaral position of field (0 if not found)
³ 
³  Syntax:
³  -------
³  FIELDPOSX(cField)
³ 
³  Description:
³  ------------
³  <cField> is an expression containing the name of a  field. Can
³  also include the alias.
³ 
³  Examples:
³  ---------
³   ?FIELDPOSX("CUSTOMER->LNAME")
³   ?FIELDPOSX("LNAME")
³ 
³  Notes:
³  -------
³  FIELDPOS() (a Clipper function) works with field
³  names, but will not allow the ALIAS.
³ 
³  Source:
³  -------
³  S_FIELDS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function fieldposx(cField)
local nPosit := 0
if isfield(cField)
  nPosit := (parsalias(cField))->(fieldpos(alltrim(parsfield(cField)) ))
endif
return nPosit


//--------------------------------------------------------------
static function dbstructx(expField)
local aStruc,cAlias
if valtype(expField)=="N"
  cAlias := alias()
else
  cAlias := parsalias(expField)
endif
if !empty(cAlias) .and. SELECT(cAlias)<>0
  aStruc := (cAlias)->(dbstruct() )
else
  aStruc := dbstruct()
endif
return aStruc

