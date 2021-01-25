*                      SMODULE C   8   proc_nam from SET KEY
*                      SFIELD  C  10   Variable name from SET KEY
*                      SDESCR  C  25   Description field used as title
*                      SSTRING C 160   Say string - what is displayed
*                                      in the lookup box
*                      SRETURN C  75   Return string - what is sent to
*                                      the keyboard via KEYBOARD
*                      SDBFILE C   8   Lookup DBF file name
*                      SIND    C   8   Lookup Index file name

/*
�����������������������������������������������������������������
� FUNCTION SCROLLER()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SCROLLER() Hotkey lookup tables with dbf storage
� 
�  Returns:
�  --------
�  nothing
� 
�  Syntax:
�  -------
�  SET KEY xxx TO SCROLLER
� 
�  Description:
�  ------------
�  Scroller is a hotkey lookup table engine.
� 
�  Scroller is data-driven , meaning it operates on data
�  stored external to
� 
�  the EXE in SCROLLER.DBF.
� 
�  SCROLLER() is called via a SET KEY. When called, it
�  receives the parameters <cProc> and <cVar> from Clipper, telling
�  it the proc and variable the user was sitting on when he pressed
�  the hotkey.
� 
�  The actual parameters rec'd are <cProc> (proc name),
�  <cLine> (line #) and <cVar> (variable name) .<cLine> is ignored,
�  but it is included as the 2nd parameter because it is passed by
�  Clipper's setkey routines.
� 
�  SCROLLER() attempts to find a corresponding record in
�  SCROLLER.DBF (which contains fields for proc name and variable).
�  SCROLLER.DBF is a storage place for lookup definitions.
� 
�  If SCROLLER does not find a matching record, it
�  simply closes SCROLLER.DBF and returns to the previous area. It
�  then displays a 'lookup table not found' message.
� 
�  If SCROLLER finds a matching record, it loads the
�  values into memory and closes SCROLLER.DBF. It then opens the
�  DBF [and index] of the lookup dbf in the next available area. If
�  it is unable to open the dbf, it displays an error message and
�  goes back to the previously selected area.
� 
�  SCROLLER then draws a box, using the DESCRIPTION
�  field as the title, initializes a 1 element array composed of
�  the SSTRING (see structure)  expression and calls SMALLS() .
� 
�  While in the SMALLS(), first letter searches can be
�  done if the dbf is indexed  with a character index. Pressing
�  ENTER will KEYBOARD the expression in SRETURN (unless its
�  empty), close up the current area and return to the old area.
�  Pressing escape just closes things up and returns to the old
�  area.
� 
�  The KEYBOARD then takes over, feeding the SRETURN
�  expression into the keyboard and into the current GET or GETS.
� 
�  Examples:
�  ---------
�   EXTERNAL SCROLLER
� 
�   SET KEY -1 TO SCROLLER  && F2
� 
�  Notes:
�  -------
�  BIG NOTE:
� 
�  This is really for managing dynamic lookup tables
�  that will change frequently as to lookup params. Because of this, it
�  is quite complex in nature.
� 
�  If you know what the lookup is going to be, and it
�  will not change between compiles, look at SMALLS(), SMALLKSET(),
�  SMALLVALID() and SMALLWHEN() and use one of these as
�  appropriate, instead of SCROLLER().
� 
�  Source:
�  -------
�  S_SCROLL.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION scroller(cProcName,xGarbage,cProcVar)
local cDisplay   := ""
local cReturn    := ""
local cDbfName   := ""
local cTitle     := ""
local nRecNumber := recno()
local nOldArea   := select()

cProcVar := iif("->"$cProcVar,SUBST(cProcVar,AT(">",cProcVar)+1),cProcVar)

IF !FILE(slsf_scroll()+".DBF")
   msg("Lookup definition file missing - "+slsf_scroll())
   RETURN ''
ENDIF

DO WHILE .T.
    *- FIND THE APPROPRIATE RECORD IN SCROLLER.DBF
    SELECT 0
    IF SNET_USE(slsf_scroll(),"__SCROLL",.F.,5,.F.,"Unable to open "+;
                 slsf_scroll()+". Keep trying?")
       LOCATE FOR __scroll->smodule=cProcName .AND. ;
                  __scroll->sfield=cProcVar .and. !deleted()
       IF .NOT. FOUND()
          msg("No lookup table found.")
          USE
          EXIT
       ENDI

       cDisplay := "IF(DELE(),'�',' ')+"+RTRIM(__SCROLL->sstring)
       cTitle   := RTRIM(__SCROLL->sdescr)
       IF EMPTY(TRIM(cTitle))
          cTitle := ""
       ENDIF
       cDbfName := UPPER(Alltrim(__SCROLL->sdbfile))
       if !empty(cDbfName)
         cDbfName := "%"+cDbfName+"%"
         if !empty(__SCROLL->sind)
            cDbfName := cDbfName+ALLTRIM(__SCROLL->sind)
         endif
       else
         cDbfName := nil
       endif
       cReturn := __SCROLL->sreturn
       USE

       select (nOldArea)
       IF nRecNumber > 0
         go (nRecNumber)
       ENDIF

       * CALL SMALLS
       if !empty(cReturn)
         SMALLS(cDisplay,cTitle,cDbfName,cReturn)
       else
         SMALLS(cDisplay,cTitle,cDbfName)
       endif
    endif
    EXIT
ENDDO
SELECT (nOldArea)
RETURN 0

