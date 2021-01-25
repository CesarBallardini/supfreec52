/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PURGEM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PURGEM() Deletes records
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  PURGEM()
ณ 
ณ  Description:
ณ  ------------
ณ  Deletes records of the currently opened DBF.
ณ 
ณ  Examples:
ณ  ---------
ณ   if lClean_em_up
ณ       select 0
ณ       use QUERIES
ณ       PURGEM()
ณ   endif
ณ 
ณ  Notes:
ณ  -------
ณ  This is intended for those small system files created
ณ  by QUERY(), FORMLETR(), LISTER() etc.
ณ 
ณ  No PACKING is done.
ณ 
ณ  Source:
ณ  -------
ณ  S_PURGEM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
