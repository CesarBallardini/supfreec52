/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISFIELD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISFIELD() Determines if an expression is the name of a field
ณ 
ณ  Returns:
ณ  --------
ณ  <lIsfield> => Is the expression a field
ณ 
ณ  Syntax:
ณ  -------
ณ  ISFIELD(cExpress)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines if <cExpress> contains the name of a
ณ  field. If <cExpress> contains an alias, the area of the alias
ณ  will be checked.
ณ 
ณ  Examples:
ณ  ---------
ณ   isfield( "LASTNAME" )            // actual field, returns  .t.
ณ 
ณ   isfield( "CUSTOMER->LASTNAME")   // actual field, returns  .t.
ณ 
ณ   isfield( "LEFT(LNAME,5)" )       // expression, returns .f.
ณ 
ณ  Notes:
ณ  -------
ณ  Companion functions are ISTHISAREA(), ISEDITABLE(),
ณ  PARSFIELD(), PARSALIAS(), EXPBLOCK(), WORKBLOCK()
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISTHISAREA()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISTHISAREA() Determines if expression is the name of a field
ณ  in this area
ณ 
ณ  Returns:
ณ  --------
ณ  <lIsThisArea> => Is the expression a field in this
ณ  area
ณ 
ณ  Syntax:
ณ  -------
ณ  ISTHISAREA(cExpress)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines if <cExpress> contains the name of a field
ณ  in this area.
ณ 
ณ  If <cExpress> contains an alias, the area of the
ณ  alias will be checked.
ณ 
ณ  ISTHISAREA() first calls ISFIELD() to ensure the
ณ  expression is a field name.
ณ 
ณ  If a field in another area is passed, and no alias is
ณ  used, False will be returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   ISTHISAREA("LASTNAME")             // actual field,  returns .t.
ณ 
ณ   ISTHISAREA("CUSTOMER->LASTNAME")  // actual field, returns .t.
ณ 
ณ   ISTHISAREA("LEFT(LNAME,5)")        // expression, returns  .f.
ณ 
ณ   ISTHISAREA("AGENT")                //field, but in another area. Returns .f.
ณ 
ณ  Notes:
ณ  -------
ณ  Companion functions are ISFIELD(), ISEDITABLE(),
ณ  PARSFIELD(), PARSALIAS(), EXPBLOCK(), WORKBLOCK()
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION EXPBLOCK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  EXPBLOCK() Returns a codeblock to evaluate an expresson
ณ 
ณ  Returns:
ณ  --------
ณ  <bBlock> => codeblock to evaluate an expression
ณ 
ณ  Syntax:
ณ  -------
ณ  EXPBLOCK(cExpress)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns a codeblock built around the expression in
ณ  cExpress.
ณ 
ณ  Using EVAL() on the codeblock will return the current
ณ  value of the expression.
ณ 
ณ  Examples:
ณ  ---------
ณ   cExp := "UPPER(LEFT(CUSTOMER->LNAME,5))"
ณ   bExp := EXPBLOCK(cExp)
ณ 
ณ   ?eval(bExp)
ณ     // displays current value of customer->lname, upper,left 5
ณ 
ณ  Notes:
ณ  -------
ณ  See also WORKBLOCK()
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function expblock(cExpress)
local bBlock
bBlock := &("{||"+cExpress+"}")
return bBlock

//------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION WORKBLOCK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  WORKBLOCK() Returns a set-get block for field named in an
ณ  expression
ณ 
ณ  Returns:
ณ  --------
ณ  <bBlock> => a set-get block
ณ 
ณ  Syntax:
ณ  -------
ณ  WORKBLOCK(cExpress)
ณ 
ณ  Description:
ณ  ------------
ณ  Determines the work area and field name in <cExpress>
ณ  and returns a FIELDWBLOCK() created block for it.
ณ 
ณ  Examples:
ณ  ---------
ณ   cExpr := "CUSTOMER->LNAME"
ณ 
ณ   bExpr := WORKBLOCK(cExpr)
ณ 
ณ   ?eval(bExpr)              // displays value
ณ 
ณ   ?eval(bExpr,"SMITH")    // sets new value
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PARSALIAS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PARSALIAS() Extracts the name of the alias from an expression
ณ 
ณ  Returns:
ณ  --------
ณ  <cAlias> => name of the alias
ณ 
ณ  Syntax:
ณ  -------
ณ  PARSALIAS(cExpress)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns the ALIAS part of cExpress. If <cExpress> is
ณ  not prefaced
ณ 
ณ  with an alias ( XXXX-> ) the current ALIAS() is
ณ  returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   cExpr := "CUSTOMER->LASTNAME"
ณ 
ณ   IF ISFIELD(cExpr)
ณ     ?PARSALIAS(cExpr)  // displays CUSTOMER
ณ     ?PARSFIELD(cExpr)  // displays LASTNAME
ณ   ENDIF
ณ 
ณ  Warnings:
ณ  ----------
ณ  Does not verify if this is a valid field. Use
ณ  ISFIELD().
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PARSFIELD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PARSFIELD() Extracts the name of the field from an expression
ณ 
ณ  Returns:
ณ  --------
ณ  <cField> => name of the field
ณ 
ณ  Syntax:
ณ  -------
ณ  PARSFIELD(cExpress)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns the field name part of cExpress
ณ 
ณ  Examples:
ณ  ---------
ณ   cExpr := "CUSTOMER->LASTNAME"
ณ 
ณ   IF ISFIELD(cExpr)
ณ     ?PARSALIAS(cExpr)  // displays CUSTOMER
ณ     ?PARSFIELD(cExpr)  // displays LASTNAME
ณ   ENDIF
ณ 
ณ  Warnings:
ณ  ----------
ณ  Does not verify if this is a valid field. Use
ณ  ISFIELD().
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FIELDTYPEX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FIELDTYPEX() Returns type of field
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <cType> => field TYPE
ณ 
ณ  Syntax:
ณ  -------
ณ  FIELDTYPEX(expField)
ณ 
ณ  Description:
ณ  ------------
ณ  <expField> is either the numeric position of the
ณ  field in the database, or the name of the field.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF FIELDTYPEX(i) =="N"
ณ     nSum += fieldget(i)
ณ   ENDIF
ณ 
ณ  Notes:
ณ  -------
ณ  Just using VALTYPE(FIELDGET(n)) is fine, except that
ณ  memo fields then show as type "C". Not always wanted.
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FIELDLENX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FIELDLENX() Returns length of field
ณ 
ณ  Returns:
ณ  --------
ณ  <nLength> => field LENGTH
ณ 
ณ  Syntax:
ณ  -------
ณ  FIELDLENX(expField)
ณ 
ณ  Description:
ณ  ------------
ณ  <expField> is either the numeric position of the
ณ  field in the database, or the name of the field.
ณ 
ณ  Examples:
ณ  ---------
ณ   FOR i = 1 to fcount()
ณ     nSumLengths += FIELDLENX(i)
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FIELDDECX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FIELDDECX() Returns decimals of field
ณ 
ณ  Returns:
ณ  --------
ณ  <nDec> => field DECIMALS
ณ 
ณ  Syntax:
ณ  -------
ณ  FIELDDECX(expField)
ณ 
ณ  Description:
ณ  ------------
ณ  <expField> is either the numeric position of the
ณ  field in the database, or the name of the field.
ณ 
ณ  Examples:
ณ  ---------
ณ   FOR i = 1 to fcount()
ณ     nSumDecs += FIELDDECX(i)
ณ     // could also be:  nSumDecs += FIELDDECX(FIELD(i))
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FIELDPOSX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FIELDPOSX() Returns position of field named in expression
ณ 
ณ  Returns:
ณ  --------
ณ  <nPosition> => natuaral position of field (0 if not found)
ณ 
ณ  Syntax:
ณ  -------
ณ  FIELDPOSX(cField)
ณ 
ณ  Description:
ณ  ------------
ณ  <cField> is an expression containing the name of a  field. Can
ณ  also include the alias.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?FIELDPOSX("CUSTOMER->LNAME")
ณ   ?FIELDPOSX("LNAME")
ณ 
ณ  Notes:
ณ  -------
ณ  FIELDPOS() (a Clipper function) works with field
ณ  names, but will not allow the ALIAS.
ณ 
ณ  Source:
ณ  -------
ณ  S_FIELDS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

