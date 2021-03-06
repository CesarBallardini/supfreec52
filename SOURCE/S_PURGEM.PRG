/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PURGEM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PURGEM() Deletes records
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  PURGEM()
³ 
³  Description:
³  ------------
³  Deletes records of the currently opened DBF.
³ 
³  Examples:
³  ---------
³   if lClean_em_up
³       select 0
³       use QUERIES
³       PURGEM()
³   endif
³ 
³  Notes:
³  -------
³  This is intended for those small system files created
³  by QUERY(), FORMLETR(), LISTER() etc.
³ 
³  No PACKING is done.
³ 
³  Source:
³  -------
³  S_PURGEM.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION purgem
local i
local nLenTagged
local aTags := {}

IF !used()
  msg("Requires database")
  RETURN ''
ELSEIF RECC()=0
  msg("No records on file")
  RETURN ''
ENDIF
tagit(aTags,"","","Tag Records to Delete")

IF len(aTags) > 0
  nLenTagged = len(aTags)
  IF messyn("Delete tagged records now?")
    GO TOP
    plswait(.t.,"Deleting...")
    for i = 1 to nLenTagged
      go ( aTags[i] )
      if SREC_LOCK(5,.T.,"Network error - Unable to lock record. Keep trying?")
         DELETE
         unlock
      endif
    next
    plswait(.f.)
  ENDIF
ELSE
  msg("No records tagged for deletion")
ENDIF
RETURN ''
