#include "inkey.ch"
#include "memoedit.ch"

/*
�����������������������������������������������������������������
� FUNCTION HELP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  HELP() Provides context sensitive popup help
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  SET KEY xxx TO HELP
� 
�  Description:
�  ------------
�  By setting a key xxx to this function, the current
�  PROC and VARIABLE are passed to it when the key is pressed
�  during the program.
� 
�  By comparing the PROC and VARIABLE parameters against
�  entries in the HELP.DBF, HELP() can then provide the appropriate
�  help screen for the user. If no matching record is found, HELP()
�  displays a 'No Help Found' message to the user.
� 
�  HELP() works in conjunction with HELPMOD() which is
�  used to create help screen records for the HELP.DBF. HELPMOD()
�  allows online creation and modification of the size, location
�  and contents of the help screen for the current PROC,VARIABLE
�  combination.
� 
�  Examples:
�  ---------
�   EXTERNAL HELP
� 
�   SET KEY 28 to HELP
� 
�  Warnings:
�  ----------
�  The SET KEY that called this proc is still active
�  inside the proc. You may wish to modify the proc to turn off/on
�  the set key.
� 
�  i.e. if called with key 28 (F1)
� 
�  at start :  SET KEY 28 to
�  at end:     SET KEY 28 to HELP
� 
�  Notes:
�  -------
�  Will not be much use during ACHOICE or MENU TO
� 
�  Source:
�  -------
�  S_HELP.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION HELP(cProc,xGarbage,cVar)

local nCol,nRow,nOldArea,cKey,cHelpFile,cBox, nHotkey, bHotkey

cHelpFile := slsf_help()
nCol      := COL()
nRow      := ROW()
nHotkey   := lastkey()
if nHotkey#0
        bHotkey   := setkey(nHotkey,nil)
endif

*- figure out the calling PROC-VARIABLE
cProc := cProc+SPACE(10-LEN(cProc))
cVar  := iif("->"$cVar,SUBST(cVar,AT(">",cVar)+1),cVar)
cVar  := cVar+SPACE(10-LEN(cVar))

*- save the area we're in
nOldArea := SELE()
select 0

*- be sure there's a help DBF/DBT/NDX(NTX)
IF FILE(cHelpFile+".DBF") .AND. FILE(cHelpFile+".DBT") .AND.;
        ( FILE(cHelpFile+indexext())  )
  IF !SNET_USE(cHelpFile+".DBF","__HELP",;
     .F.,5,.T.,"Network error opening HELP file. Keep trying?")
  else
     set index to (cHelpFile)
  endif
ELSE
  msg("No HELP found")
ENDIF

IF USED()
    *- see if there's a matching HELP.DBF record
    cKey :=cProc+cVar
    SEEK cKey

    *- if found, display the help, otherwise display a no-help message.
    IF FOUND()
      cBox :=makebox( __HELP->hw_t, __HELP->hw_l, __HELP->hw_b, __HELP->hw_r,;
                      sls_popcol())
      @__HELP->hw_t,__HELP->hw_l+2 SAY "Help:"
      @__HELP->hw_b,__HELP->hw_l+2 SAY "[Press a key]"

     *MMEMOEDIT(__HELP->h_memo,__HELP->hw_t+1,__HELP->hw_l+1,__HELP->hw_b-1,;
     *          __HELP->hw_r-1,.F.,{|m,r,c,l|mehelpudf(m,r,c,l)},;
     *          nil,nil,nil,nil,nil,nil)
     MMEMOEDIT(__HELP->h_memo,__HELP->hw_t+1,__HELP->hw_l+1,__HELP->hw_b-1,;
               __HELP->hw_r-1,.F.,{|m,r,c,l|mehelpudf(m,r,c,l)},;
               (__HELP->hw_r-1)-(__HELP->hw_l+1),nil,nil,nil,nil,nil)
      *Memoedit(__HELP->h_memo,__HELP->hw_t+1,__HELP->hw_l+1,__HELP->hw_b-1,;
      *         __HELP->hw_r-1,.F.)
      unbox(cBox)
    ELSE
      msg("No HELP found")
    ENDIF (FOUND()

    *- USE the help DBF, and put things back as they were
ENDIF
USE
DEVPOS(nRow,nCol)
SELE (nOldArea)
if nHotkey#0 .and. bHotkey#nil
        setkey(nHotkey,bHotkey)
endif
RETURN ''


static FUNCTION mehelpudf(nMode, nLine, nColumn,nNextKey)
local nReturnVal
local nRow := row(), nCol := col()
nReturnVal := ME_DEFAULT
IF !(nMode= ME_INIT)
  if nNextKey<>0
     keyboard chr(K_ESC)
  endif
ENDIF
devpos(nRow,nCol)
RETURN nReturnval
