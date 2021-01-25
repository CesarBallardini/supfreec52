/*
�����������������������������������������������������������������
� FUNCTION ISFIELD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISFIELD() Determines if an expression is the name of a field
� 
�  Returns:
�  --------
�  <lIsfield> => Is the expression a field
� 
�  Syntax:
�  -------
�  ISFIELD(cExpress)
� 
�  Description:
�  ------------
�  Determines if <cExpress> contains the name of a
�  field. If <cExpress> contains an alias, the area of the alias
�  will be checked.
� 
�  Examples:
�  ---------
�   isfield( "LASTNAME" )            // actual field, returns  .t.
� 
�   isfield( "CUSTOMER->LASTNAME")   // actual field, returns  .t.
� 
�   isfield( "LEFT(LNAME,5)" )       // expression, returns .f.
� 
�  Notes:
�  -------
�  Companion functions are ISTHISAREA(), ISEDITABLE(),
�  PARSFIELD(), PARSALIAS(), EXPBLOCK(), WORKBLOCK()
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION ISTHISAREA()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISTHISAREA() Determines if expression is the name of a field
�  in this area
� 
�  Returns:
�  --------
�  <lIsThisArea> => Is the expression a field in this
�  area
� 
�  Syntax:
�  -------
�  ISTHISAREA(cExpress)
� 
�  Description:
�  ------------
�  Determines if <cExpress> contains the name of a field
�  in this area.
� 
�  If <cExpress> contains an alias, the area of the
�  alias will be checked.
� 
�  ISTHISAREA() first calls ISFIELD() to ensure the
�  expression is a field name.
� 
�  If a field in another area is passed, and no alias is
�  used, False will be returned.
� 
�  Examples:
�  ---------
�   ISTHISAREA("LASTNAME")             // actual field,  returns .t.
� 
�   ISTHISAREA("CUSTOMER->LASTNAME")  // actual field, returns .t.
� 
�   ISTHISAREA("LEFT(LNAME,5)")        // expression, returns  .f.
� 
�   ISTHISAREA("AGENT")                //field, but in another area. Returns .f.
� 
�  Notes:
�  -------
�  Companion functions are ISFIELD(), ISEDITABLE(),
�  PARSFIELD(), PARSALIAS(), EXPBLOCK(), WORKBLOCK()
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION EXPBLOCK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  EXPBLOCK() Returns a codeblock to evaluate an expresson
� 
�  Returns:
�  --------
�  <bBlock> => codeblock to evaluate an expression
� 
�  Syntax:
�  -------
�  EXPBLOCK(cExpress)
� 
�  Description:
�  ------------
�  Returns a codeblock built around the expression in
�  cExpress.
� 
�  Using EVAL() on the codeblock will return the current
�  value of the expression.
� 
�  Examples:
�  ---------
�   cExp := "UPPER(LEFT(CUSTOMER->LNAME,5))"
�   bExp := EXPBLOCK(cExp)
� 
�   ?eval(bExp)
�     // displays current value of customer->lname, upper,left 5
� 
�  Notes:
�  -------
�  See also WORKBLOCK()
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
*/
function expblock(cExpress)
local bBlock
bBlock := &("{||"+cExpress+"}")
return bBlock

//------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION WORKBLOCK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  WORKBLOCK() Returns a set-get block for field named in an
�  expression
� 
�  Returns:
�  --------
�  <bBlock> => a set-get block
� 
�  Syntax:
�  -------
�  WORKBLOCK(cExpress)
� 
�  Description:
�  ------------
�  Determines the work area and field name in <cExpress>
�  and returns a FIELDWBLOCK() created block for it.
� 
�  Examples:
�  ---------
�   cExpr := "CUSTOMER->LNAME"
� 
�   bExpr := WORKBLOCK(cExpr)
� 
�   ?eval(bExpr)              // displays value
� 
�   ?eval(bExpr,"SMITH")    // sets new value
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION PARSALIAS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PARSALIAS() Extracts the name of the alias from an expression
� 
�  Returns:
�  --------
�  <cAlias> => name of the alias
� 
�  Syntax:
�  -------
�  PARSALIAS(cExpress)
� 
�  Description:
�  ------------
�  Returns the ALIAS part of cExpress. If <cExpress> is
�  not prefaced
� 
�  with an alias ( XXXX-> ) the current ALIAS() is
�  returned.
� 
�  Examples:
�  ---------
�   cExpr := "CUSTOMER->LASTNAME"
� 
�   IF ISFIELD(cExpr)
�     ?PARSALIAS(cExpr)  // displays CUSTOMER
�     ?PARSFIELD(cExpr)  // displays LASTNAME
�   ENDIF
� 
�  Warnings:
�  ----------
�  Does not verify if this is a valid field. Use
�  ISFIELD().
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION PARSFIELD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PARSFIELD() Extracts the name of the field from an expression
� 
�  Returns:
�  --------
�  <cField> => name of the field
� 
�  Syntax:
�  -------
�  PARSFIELD(cExpress)
� 
�  Description:
�  ------------
�  Returns the field name part of cExpress
� 
�  Examples:
�  ---------
�   cExpr := "CUSTOMER->LASTNAME"
� 
�   IF ISFIELD(cExpr)
�     ?PARSALIAS(cExpr)  // displays CUSTOMER
�     ?PARSFIELD(cExpr)  // displays LASTNAME
�   ENDIF
� 
�  Warnings:
�  ----------
�  Does not verify if this is a valid field. Use
�  ISFIELD().
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION FIELDTYPEX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  FIELDTYPEX() Returns type of field
� 
� 
�  Returns:
�  --------
�  <cType> => field TYPE
� 
�  Syntax:
�  -------
�  FIELDTYPEX(expField)
� 
�  Description:
�  ------------
�  <expField> is either the numeric position of the
�  field in the database, or the name of the field.
� 
�  Examples:
�  ---------
�   IF FIELDTYPEX(i) =="N"
�     nSum += fieldget(i)
�   ENDIF
� 
�  Notes:
�  -------
�  Just using VALTYPE(FIELDGET(n)) is fine, except that
�  memo fields then show as type "C". Not always wanted.
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION FIELDLENX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  FIELDLENX() Returns length of field
� 
�  Returns:
�  --------
�  <nLength> => field LENGTH
� 
�  Syntax:
�  -------
�  FIELDLENX(expField)
� 
�  Description:
�  ------------
�  <expField> is either the numeric position of the
�  field in the database, or the name of the field.
� 
�  Examples:
�  ---------
�   FOR i = 1 to fcount()
�     nSumLengths += FIELDLENX(i)
�   ENDIF
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION FIELDDECX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  FIELDDECX() Returns decimals of field
� 
�  Returns:
�  --------
�  <nDec> => field DECIMALS
� 
�  Syntax:
�  -------
�  FIELDDECX(expField)
� 
�  Description:
�  ------------
�  <expField> is either the numeric position of the
�  field in the database, or the name of the field.
� 
�  Examples:
�  ---------
�   FOR i = 1 to fcount()
�     nSumDecs += FIELDDECX(i)
�     // could also be:  nSumDecs += FIELDDECX(FIELD(i))
�   ENDIF
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION FIELDPOSX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  FIELDPOSX() Returns position of field named in expression
� 
�  Returns:
�  --------
�  <nPosition> => natuaral position of field (0 if not found)
� 
�  Syntax:
�  -------
�  FIELDPOSX(cField)
� 
�  Description:
�  ------------
�  <cField> is an expression containing the name of a  field. Can
�  also include the alias.
� 
�  Examples:
�  ---------
�   ?FIELDPOSX("CUSTOMER->LNAME")
�   ?FIELDPOSX("LNAME")
� 
�  Notes:
�  -------
�  FIELDPOS() (a Clipper function) works with field
�  names, but will not allow the ALIAS.
� 
�  Source:
�  -------
�  S_FIELDS.PRG
� 
����������������������������������������������������������������� 
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
