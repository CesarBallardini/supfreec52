#include "inkey.ch"
#include "memoedit.ch"

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION HELP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  HELP() Provides context sensitive popup help
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SET KEY xxx TO HELP
³ 
³  Description:
³  ------------
³  By setting a key xxx to this function, the current
³  PROC and VARIABLE are passed to it when the key is pressed
³  during the program.
³ 
³  By comparing the PROC and VARIABLE parameters against
³  entries in the HELP.DBF, HELP() can then provide the appropriate
³  help screen for the user. If no matching record is found, HELP()
³  displays a 'No Help Found' message to the user.
³ 
³  HELP() works in conjunction with HELPMOD() which is
³  used to create help screen records for the HELP.DBF. HELPMOD()
³  allows online creation and modification of the size, location
³  and contents of the help screen for the current PROC,VARIABLE
³  combination.
³ 
³  Examples:
³  ---------
³   EXTERNAL HELP
³ 
³   SET KEY 28 to HELP
³ 
³  Warnings:
³  ----------
³  The SET KEY that called this proc is still active
³  inside the proc. You may wish to modify the proc to turn off/on
³  the set key.
³ 
³  i.e. if called with key 28 (F1)
³ 
³  at start :  SET KEY 28 to
³  at end:     SET KEY 28 to HELP
³ 
³  Notes:
³  -------
³  Will not be much use during ACHOICE or MENU TO
³ 
³  Source:
³  -------
³  S_HELP.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

