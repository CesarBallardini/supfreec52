//---------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BLANKFIELD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BLANKFIELD() Returns a blank value corresponding to a field
³ 
³  Returns:
³  --------
³  <expBlank> => blank value, corresponding to a field
³ 
³  Syntax:
³  -------
³  BLANKFIELD(cField)
³ 
³  Description:
³  ------------
³  <cField> is the name of the field. Can also include
³  the alias
³ 
³  A blank value is returned:
³ 
³  For: Character           Spaces the length of the field
³       Numeric             Zero
³       Logical             .f.
³       Date                Blank date
³       Memo                ""
³ 
³  Examples:
³  ---------
³   // fill an array with matching blanks for the record - good
³   // for an ADD routine
³ 
³   aAdds := array(fcount())
³   for i = 1 to fcount()
³     aAdds[i] := BLANKFIELD(field(i))
³   next
³ 
³  Source:
³  -------
³  S_BLANKS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function blankfield(cField)
local cType := fieldtypex(cField)
local cLen := fieldlenx(cField)
do case
case cType = "C"
  return space(cLen)
case cType = "M"
  return ""
case cType = "N"
  return 0
case ctype = "L"
  return .f.
case cType = "D"
  return CTOD("  /  /  ")
endcase
return nil

//---------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BLANKREC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BLANKREC() Blanks out a record
³ 
³ 
³  Returns:
³  --------
³  <lSuccess> => success, or not
³ 
³  Syntax:
³  -------
³  BLANKREC([nTries,lInteractive,cMessage])
³ 
³  Description:
³  ------------
³  Attempts to lock the record <nTries> (default 5), and
³  if no luck and <lInteractive> (default False), prompts
³  the user with <cMessage> (default "Unable to lock record. Keep
³  trying?")
³ 
³  If a lock is gotten, the record is replaced with
³  blank values.
³ 
³  See BLANKFIELD()
³ 
³  Examples:
³  ---------
³   DELETE
³   BLANKREC()
³ 
³  Notes:
³  -------
³  Use ISBLANKREC() to locate blank records. This is a
³  good way to re-use records, rather than using PACK.
³ 
³  Source:
³  -------
³  S_BLANK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function blankrec(nTries,lInteract,cMessage)
local i
local lSuccess := .f.
nTries      := iif(nTries#nil,nTries,5)
lInteract   := iif(lInteract#nil,lInteract,.f.)
cMessage    := iif(cMessage#nil,cMessage,"Unable to lock record. Keep trying?")
if SREC_LOCK(nTries,lInteract,cMessage)
  for i = 1 to fcount()
   fieldput(i,blankfield(field(i)))
  next
  lSuccess := .t.
  unlock
endif
return lSuccess

//---------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISBLANKREC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISBLANKREC() Determines if a record is blank
³ 
³  Returns:
³  --------
³  <lIsblank> => is the record blank
³ 
³  Syntax:
³  -------
³  ISBLANKREC()
³ 
³  Description:
³  ------------
³  Returns True if the record is all blanks
³ 
³  Examples:
³  ---------
³   LOCATE for ISBLANKREC()
³ 
³   if found()
³     // re-use
³   else
³     APPEND BLANK
³   endif
³ 
³  Source:
³  -------
³  S_BLANK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function isblankrec
local i
local lIsblank := .t.
for i = 1 to fcount()
  if !empty(fieldget(i))
    lIsblank := .f.
    exit
  endif
next
return lIsBlank


