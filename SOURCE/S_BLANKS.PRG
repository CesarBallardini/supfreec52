//---------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION BLANKFIELD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BLANKFIELD() Returns a blank value corresponding to a field
� 
�  Returns:
�  --------
�  <expBlank> => blank value, corresponding to a field
� 
�  Syntax:
�  -------
�  BLANKFIELD(cField)
� 
�  Description:
�  ------------
�  <cField> is the name of the field. Can also include
�  the alias
� 
�  A blank value is returned:
� 
�  For: Character           Spaces the length of the field
�       Numeric             Zero
�       Logical             .f.
�       Date                Blank date
�       Memo                ""
� 
�  Examples:
�  ---------
�   // fill an array with matching blanks for the record - good
�   // for an ADD routine
� 
�   aAdds := array(fcount())
�   for i = 1 to fcount()
�     aAdds[i] := BLANKFIELD(field(i))
�   next
� 
�  Source:
�  -------
�  S_BLANKS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION BLANKREC()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BLANKREC() Blanks out a record
� 
� 
�  Returns:
�  --------
�  <lSuccess> => success, or not
� 
�  Syntax:
�  -------
�  BLANKREC([nTries,lInteractive,cMessage])
� 
�  Description:
�  ------------
�  Attempts to lock the record <nTries> (default 5), and
�  if no luck and <lInteractive> (default False), prompts
�  the user with <cMessage> (default "Unable to lock record. Keep
�  trying?")
� 
�  If a lock is gotten, the record is replaced with
�  blank values.
� 
�  See BLANKFIELD()
� 
�  Examples:
�  ---------
�   DELETE
�   BLANKREC()
� 
�  Notes:
�  -------
�  Use ISBLANKREC() to locate blank records. This is a
�  good way to re-use records, rather than using PACK.
� 
�  Source:
�  -------
�  S_BLANK.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION ISBLANKREC()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISBLANKREC() Determines if a record is blank
� 
�  Returns:
�  --------
�  <lIsblank> => is the record blank
� 
�  Syntax:
�  -------
�  ISBLANKREC()
� 
�  Description:
�  ------------
�  Returns True if the record is all blanks
� 
�  Examples:
�  ---------
�   LOCATE for ISBLANKREC()
� 
�   if found()
�     // re-use
�   else
�     APPEND BLANK
�   endif
� 
�  Source:
�  -------
�  S_BLANK.PRG
� 
����������������������������������������������������������������� 
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

