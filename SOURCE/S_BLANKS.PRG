//---------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BLANKFIELD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BLANKFIELD() Returns a blank value corresponding to a field
ณ 
ณ  Returns:
ณ  --------
ณ  <expBlank> => blank value, corresponding to a field
ณ 
ณ  Syntax:
ณ  -------
ณ  BLANKFIELD(cField)
ณ 
ณ  Description:
ณ  ------------
ณ  <cField> is the name of the field. Can also include
ณ  the alias
ณ 
ณ  A blank value is returned:
ณ 
ณ  For: Character           Spaces the length of the field
ณ       Numeric             Zero
ณ       Logical             .f.
ณ       Date                Blank date
ณ       Memo                ""
ณ 
ณ  Examples:
ณ  ---------
ณ   // fill an array with matching blanks for the record - good
ณ   // for an ADD routine
ณ 
ณ   aAdds := array(fcount())
ณ   for i = 1 to fcount()
ณ     aAdds[i] := BLANKFIELD(field(i))
ณ   next
ณ 
ณ  Source:
ณ  -------
ณ  S_BLANKS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BLANKREC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BLANKREC() Blanks out a record
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => success, or not
ณ 
ณ  Syntax:
ณ  -------
ณ  BLANKREC([nTries,lInteractive,cMessage])
ณ 
ณ  Description:
ณ  ------------
ณ  Attempts to lock the record <nTries> (default 5), and
ณ  if no luck and <lInteractive> (default False), prompts
ณ  the user with <cMessage> (default "Unable to lock record. Keep
ณ  trying?")
ณ 
ณ  If a lock is gotten, the record is replaced with
ณ  blank values.
ณ 
ณ  See BLANKFIELD()
ณ 
ณ  Examples:
ณ  ---------
ณ   DELETE
ณ   BLANKREC()
ณ 
ณ  Notes:
ณ  -------
ณ  Use ISBLANKREC() to locate blank records. This is a
ณ  good way to re-use records, rather than using PACK.
ณ 
ณ  Source:
ณ  -------
ณ  S_BLANK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISBLANKREC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISBLANKREC() Determines if a record is blank
ณ 
ณ  Returns:
ณ  --------
ณ  <lIsblank> => is the record blank
ณ 
ณ  Syntax:
ณ  -------
ณ  ISBLANKREC()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns True if the record is all blanks
ณ 
ณ  Examples:
ณ  ---------
ณ   LOCATE for ISBLANKREC()
ณ 
ณ   if found()
ณ     // re-use
ณ   else
ณ     APPEND BLANK
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_BLANK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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


