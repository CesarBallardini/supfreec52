/*
�����������������������������������������������������������������
� FUNCTION PURGEM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PURGEM() Deletes records
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  PURGEM()
� 
�  Description:
�  ------------
�  Deletes records of the currently opened DBF.
� 
�  Examples:
�  ---------
�   if lClean_em_up
�       select 0
�       use QUERIES
�       PURGEM()
�   endif
� 
�  Notes:
�  -------
�  This is intended for those small system files created
�  by QUERY(), FORMLETR(), LISTER() etc.
� 
�  No PACKING is done.
� 
�  Source:
�  -------
�  S_PURGEM.PRG
� 
����������������������������������������������������������������� 
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