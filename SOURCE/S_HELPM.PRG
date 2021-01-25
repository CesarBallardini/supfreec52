#include "memoedit.ch"

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION HELPMOD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  HELPMOD() Interactively build and modify help screens
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SET KEY xxx TO HELPMOD
ณ 
ณ  Description:
ณ  ------------
ณ  HELPMOD() creates and modifies help screens for
ณ  HELP() which are stored in HELP.DBF.
ณ 
ณ  HELPMOD() allows online creation and modification of
ณ  the size, location and contents of the help screen for the
ณ  current PROC,VARIABLE combination, and stores the results in
ณ  HELP.DBF.
ณ 
ณ  HELPMOD() is intended to be used online, during
ณ  program execution, by the developer/programmer. It can be
ณ  removed after development.
ณ 
ณ  By setting a key xxx to this function, the current
ณ  PROC and VARIABLE are passed to it when the key is pressed
ณ  during the program.
ณ 
ณ  By comparing the PROC and VARIABLE parameters against
ณ  entries in the HELP.DBF, HELPMOD() can then provide the
ณ  appropriate help screen for modification, or, if no matching
ณ  record is found, allow creation of a new help screen record.
ณ 
ณ  HELP.DBF is created if not present.
ณ 
ณ  Examples:
ณ  ---------
ณ   EXTERNAL HELPMOD
ณ 
ณ   SET KEY -30 TO HELPMOD  && alt-F1
ณ 
ณ  Notes:
ณ  -------
ณ  Will not be much use during ACHOICE or MENU TO
ณ 
ณ  Source:
ณ  -------
ณ  S_HELPM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION helpmod(cCallProc,xGarbage,cCallVar)

*- privates
local cOldProc,cOldVar,cOldColor,cScreen
local cKey,nTop,nLeft,nBott,nRight,cMemo,cFound
local nAction,cScreen2,nRow,nColumn,nOldArea,cHelpFile
local nOldCursor,bOldF10,lUsedOk
local cActionBox,nHotkey, bHotkey
local aActions :=  {;
                     "Edit Current Help Record",;
                     "Add New Help Record ",;
                     "Quit";
                   }

nRow            := ROW()
nColumn         := COL()
cScreen         := SAVESCREEN(0,0,24,79)
cOldColor       := Setcolor(sls_popcol())
nOldArea        := SELE()
nOldCursor      := setcursor(1)
bOldF10         := setkey(K_F10)
cHelpFile       := slsf_help()
lUsedOk         := .f.
nHotkey         := lastkey()
if nHotkey#0
        bHotkey   := setkey(nHotkey,nil)
endif

*- make F10 be ctrl-w
SETKEY(K_F10,{||ctrlw()} )


*- figure out what PROC and VAR we're calling this from
cCallProc       := cCallProc+SPACE(10-LEN(cCallProc))
cCallVar        := iif("->"$cCallVar,SUBST(cCallVar,AT(">",cCallVar)+1),cCallVar)
cCallVar        := cCallVar+SPACE(10-LEN(cCallVar))

*- save them to holding variables
cOldPRoc        := cCallProc
cOldVar         := cCallVar

IF ISCOLOR()
  *- dim the background screen
  att(0,0,24,79,8)
ENDIF

sele 0
lUsedOk := opendbf(cHelpFile)

if lUsedOk
   *- look for a record matching the current PROC+VAR
   cKey := cCallProc+cCallVar
   SEEK cKey

   *- set cFound to the value of found()
   cFound := IIF(FOUND(),"FOUND","NOT FOUND")

   *- draw the screen
   Scroll(23,0,24,79,0)

   *- note calling PROC and VAR; and results of SEEK
   @23,0 SAY padc("* Help called from Module->"+RTRIM(cCallProc)+" , Variable->"+RTRIM(cCallVar),79)
   @24,0 SAY padc("* Help database matching record was: "+cFound,79)

endif

DO WHILE lUsedOk
  
  *- assign values in dbf to memvars
  cCallProc := __HELP->h_mod
  cCallVar  := __HELP->h_var
  nTop      := __HELP->hw_t
  nLeft     := __HELP->hw_l
  nBott     := __HELP->hw_b
  nRight    := __HELP->hw_r
  cMemo     := __HELP->h_memo
  
  *- draw the menu screen
  cActionBox :=makebox(5,25,17,55,sls_popcol())
  
  *- note what help record we are sitting on top of
  @6,26 SAY "Current HELP record:"
  if recc() > 0
    @7,26 SAY "[Module  :"+RTRIM(__HELP->h_mod)+"]"
    @8,26 SAY "[Variable:"+RTRIM(__HELP->h_var)+"]"
  else
    @7,26 SAY "[Module  : None]"
    @8,26 SAY "[Variable: None]"
  endif
  

  *- achoice menu
  nAction := SACHOICE(11,26,16,53,aActions)

  unbox(cActionBox)
  
  
  *- do actions based on the choice
  DO CASE
  CASE nAction = 1 .AND. !EOF()
    *- edit help screen
    IF messyn("Edit "+RTRIM(__HELP->h_mod)+' '+RTRIM(__HELP->h_var))
      cScreen2 := savescreen(0,0,24,79)
      winloop(1,@cMemo,@nTop,@nLeft,@nBott,@nRight,cCallProc,cCallVar)
      RESTSCREEN(0,0,24,79,cScreen2)
    ENDIF
  CASE nAction = 2
    *- add a new help screen
    IF messyn("Add HELP record for "+RTRIM(cOldPRoc)+' '+RTRIM(cOldVar))
      
      *- default values
      cCallProc := cOldPRoc
      cCallVar  := cOldVar
      nTop      := 10
      nLeft     := 10
      nBott     := 15
      nRight    := 40
      cMemo     := ''

      cScreen2  := savescreen(0,0,24,79)
      winloop(0,@cMemo,@nTop,@nLeft,@nBott,@nRight,cCallProc,cCallVar)
      RESTSCREEN(0,0,24,79,cScreen2)

    ENDIF
  CASE nAction == 3
    EXIT
  ENDCASE
ENDDO
USE
SELE (nOldArea)
if nHotkey#0 .and. bHotkey#nil
        setkey(nHotkey,bHotkey)
endif
SETKEY(-9,bOldF10)
Setcolor(cOldColor)
RESTSCREEN(0,0,24,79,cScreen)
DEVPOS(nRow,nColumn)
SETCURSOR(nOldCursor)
RETURN ''

//=====================================================
STATIC FUNCTION winloop(nAddEdit,cMemo,nTop,nLeft,nBott,nRight,cCallProc,cCallVar)

local cScreen3,nLastKey, cLastKey
local   nMouseR, nMouseC
local   aButtons, nButton

*- draw the elements of this screen
Setcolor(sls_popcol())
Scroll(23,0,24,79,0)
@23,0 TO 23,79
@24,0 say '[C=change size or position]       [E=edit window contents]      [Q=quit]'

*- and then save this screen
cScreen3 := savescreen(0,0,24,79)

*- main loop
DO WHILE .T.
  
  *- disp_mem is a function below - displays the memo
  disp_mem(@cMemo,nTop,nLeft,nBott,nRight)
  
  *- wait for a keystroke
  nLastkey := rat_event(0,.f.)
  cLastkey := upper(chr(nLastkey))
  nMouseR := rat_eqmrow()
  nMouseC := rat_eqmcol()
  
  
  DO CASE
  CASE cLastKey =="C" .or. (nLastKey==K_MOUSELEFT .and. nMouseR=24.and.;
                nMouseC>=0 .and. nMouseC<=27 )
    *- change the window size/position
    RESTORE SCREEN FROM cScreen3
    *- movewin is a function below
    movewin(cMemo,@nTop,@nLeft,@nBott,@nRight)

  CASE cLastKey =="E" .or. (nLastKey==K_MOUSELEFT .and. nMouseR=24.and.;
                nMouseC>=35 .and. nMouseC<=58 )

    *- edit the help cMemo
    @23,0 CLEAR
    @23,0 TO 23,79
    @24,18 SAY "[F10=save]  [ESCAPE=cancel]"
    *cMemo := MMEMOEDIT(cMemo,nTop+1,nLeft+1,nBott-1,nRight-1,.t.,;
    *        {|m,r,c,l,mr,mc|hmemudf(m,r,c,l,mr,mc)},;
    *         nil,nil,nil,nil,nil,nil,24,1)
    cMemo := MMEMOEDIT(cMemo,nTop+1,nLeft+1,nBott-1,nRight-1,.t.,;
            {|m,r,c,l,mr,mc|hmemudf(m,r,c,l,mr,mc)},;
             (nRight-1)-(nLeft+1),nil,nil,nil,nil,nil,24,1)

  CASE cLastKey =="Q" .or. (nLastKey==K_MOUSELEFT .and. nMouseR=24.and.;
                nMouseC>=65 .and. nMouseC<=72 )

    *- quit
    IF messyn("Save this record ?")
      IF nAddEdit = 0
        *- if add
        IF !SADD_REC(5,.T.,"Unable to lock record to save. Keep trying?")
           EXIT
        ENDIF
      ENDIF
      *- place the memvars into the fields
      IF SREC_LOCK(5,.T.,"Unable to lock record for REPLACE. Keep trying?")
        REPLACE  __HELP->h_memo WITH cMemo,__HELP->hw_t WITH nTop,__HELP->hw_l WITH nLeft,;
          __HELP->hw_b WITH nBott,__HELP->hw_r WITH nRight,__HELP->h_mod WITH cCallProc,;
          __HELP->h_var WITH cCallVar
      endif
      unlock
    ENDIF
    EXIT
  ENDCASE
  RESTSCREEN(0,0,24,79,cScreen3)
ENDDO
RETURN ''


STATIC FUNCTION movewin(cMemo,nTop,nLeft,nBott,nRight)  // dims by reference

local nLastKey,cMoveWinScreen
local nMouseR, nMouseC

*- put new instructions at the bottom
@23,0 CLEAR
@23,0 TO 23,79
@24,0  say '[][][][]  [PGUP=shorter] [PGDN=longer] [HOME=thinner] [END=wider] [ESC=done]'

nLastKey := 0

*- save the underlying screen
cMoveWinScreen := savescreen(0,0,24,79)


DO WHILE .T.
  dispbegin()

  *- each time through, restore the underlying screen
  restscreen(0,0,24,79,cMoveWinScreen)
  
  disp_mem(cMemo,nTop,nLeft,nBott,nRight)

  dispend()
  
  *- wait for another key
  nLastkey := rat_event(0,.f.)
  nMouseR  := rat_eqmrow()
  nMouseC  := rat_eqmcol()
  
  DO CASE
  CASE nLastKey = K_ESC .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=70 .and. nMouseC<=79)

    EXIT
  CASE nLastKey = K_UP .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=0 .and. nMouseC<=2)

    IF nTop >=2
      nTop--
      nBott--
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||(nTop >=2)},{||nTop--,nBott--}, cMemo,cMoveWinScreen)
  CASE nLastKey = K_DOWN  .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=3 .and. nMouseC<=5)

    IF nBott <= 22
      nBott++
      nTop++
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||(nBott<=22)},{||(nBott++,nTop++)}, cMemo,cMoveWinScreen)

  CASE nLastKey = K_RIGHT .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=6 .and. nMouseC<=8)
    IF nRight <= 78
      nRight++
      nLeft++
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||(nRight<=78)},{||nRight++,nLEft++}, cMemo,cMoveWinScreen)
  CASE nLastKey = K_LEFT  .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=9 .and. nMouseC<=11)

    IF nLeft >= 2
      nLeft--
      nRight--
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||(nLeft>=2)},{||nLeft--,nRight--}, cMemo,cMoveWinScreen)
  CASE nLastKey = K_PGUP  .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=14 .and. nMouseC<=27)

    IF (nTop+3) <= nBott
      nBott--
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||(nTop+3)<=nBott},{||nBott--}, cMemo,cMoveWinScreen)
  CASE nLastKey = K_PGDN .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=29 .and. nMouseC<=41)

    IF ! nBott > 22
      nBott++
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||nTop<=22},{||nBott++}, cMemo,cMoveWinScreen)
  CASE nLastKey = K_HOME .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=43 .and. nMouseC<=56)

    IF nRight >  (nLeft+30)
      nRight--
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||nRight> (nLeft+30)},{||nRight--}, cMemo,cMoveWinScreen)
  CASE nLastKey = K_END .or. ;
                (nLastKey==K_MOUSELEFT .and. nMouseR== 24 .and. ;
                    nMouseC>=58 .and. nMouseC<=68)

    IF nRight <= 78
      nRight++
    ENDIF
    REPEAT(nLastKey,@nTop, @nLeft,@nBott,@nRight,;
           {||nRight<= 78},{||nRight++}, cMemo,cMoveWinScreen)
  ENDCASE
ENDDO
return nil

STATIC PROC REPEAT(nLastKey,nTop, nLeft,nBott,nRight,bMore, bDo,cMemo,cMoveWinScreen)

if nLastKey#K_MOUSELEFT
  while NextKey()==nLastkey .and. eval(bMore)
    eval(bDo)
    inkey()
    dispbegin()
    restscreen(0,0,24,79,cMoveWinScreen)
    disp_mem(cMemo,nTop,nLeft,nBott,nRight)
    dispend()
  end
else
   if rat_elbhd(.2)
     while rat_elbhd(.01) .and. eval(bMore)
       eval(bDo)
       dispbegin()
       restscreen(0,0,24,79,cMoveWinScreen)
       disp_mem(cMemo,nTop,nLeft,nBott,nRight)
       dispend()
     end
   endif

endif



///===================================================================
static PROC disp_mem(cMemo,nTop,nLeft,nBott,nRight)
dispbegin()
dispbox(nTop,nLeft,nBott,nRight)
Memoedit(cMemo,nTop+1,nLeft+1,nBott-1,nRight-1,.F.,.F.)
dispend()
RETURN

///===================================================================
///===================================================================
STATIC FUNCTION opendbf(cHelpFile)
IF !( FILE(cHelpFile+".DBF") .AND. FILE(cHelpFile+".DBT") )
  blddbf(cHelpFile,"h_mod,C,10:h_var,C,10:h_memo,M,10:hw_t,N,2:hw_l,N,2:hw_b,N,2:hw_r,N,2:")
ENDIF

IF ( FILE(cHelpFile+".DBF") .AND. FILE(cHelpFile+".DBT") )
  IF SNET_USE(cHelpFile,"__HELP",.F.,5,.T.,"Network error opening HELP file. Keep trying?")
    if !FILE( cHelpFile+INDEXEXT() )
      INDEX ON __HELP->h_mod+__HELP->h_var TO (cHelpFile)
    ENDIF
    SET INDEX TO (cHelpFile)
  endif
ENDIF
RETURN ( USED() )


static FUNCTION hmemudf(nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)
local nReturnVal
local nRow := row(), nCol := col()
nReturnVal := ME_DEFAULT
IF !(nMode= ME_INIT)
  if nNextKey== K_MOUSELEFT .and. nMouseR==24
     do case
     case nMouseC >=18 .and. nMouseC<=27
       KEYBOARD CHR(K_CTRL_END)
     case nMouseC >=30 .and. nMouseC<=44
       KEYBOARD CHR(K_ESC)
     endcase
  endif
ENDIF
devpos(nRow,nCol)
RETURN nReturnval

