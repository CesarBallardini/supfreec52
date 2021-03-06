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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SCROLLER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SCROLLER() Hotkey lookup tables with dbf storage
³ 
³  Returns:
³  --------
³  nothing
³ 
³  Syntax:
³  -------
³  SET KEY xxx TO SCROLLER
³ 
³  Description:
³  ------------
³  Scroller is a hotkey lookup table engine.
³ 
³  Scroller is data-driven , meaning it operates on data
³  stored external to
³ 
³  the EXE in SCROLLER.DBF.
³ 
³  SCROLLER() is called via a SET KEY. When called, it
³  receives the parameters <cProc> and <cVar> from Clipper, telling
³  it the proc and variable the user was sitting on when he pressed
³  the hotkey.
³ 
³  The actual parameters rec'd are <cProc> (proc name),
³  <cLine> (line #) and <cVar> (variable name) .<cLine> is ignored,
³  but it is included as the 2nd parameter because it is passed by
³  Clipper's setkey routines.
³ 
³  SCROLLER() attempts to find a corresponding record in
³  SCROLLER.DBF (which contains fields for proc name and variable).
³  SCROLLER.DBF is a storage place for lookup definitions.
³ 
³  If SCROLLER does not find a matching record, it
³  simply closes SCROLLER.DBF and returns to the previous area. It
³  then displays a 'lookup table not found' message.
³ 
³  If SCROLLER finds a matching record, it loads the
³  values into memory and closes SCROLLER.DBF. It then opens the
³  DBF [and index] of the lookup dbf in the next available area. If
³  it is unable to open the dbf, it displays an error message and
³  goes back to the previously selected area.
³ 
³  SCROLLER then draws a box, using the DESCRIPTION
³  field as the title, initializes a 1 element array composed of
³  the SSTRING (see structure)  expression and calls SMALLS() .
³ 
³  While in the SMALLS(), first letter searches can be
³  done if the dbf is indexed  with a character index. Pressing
³  ENTER will KEYBOARD the expression in SRETURN (unless its
³  empty), close up the current area and return to the old area.
³  Pressing escape just closes things up and returns to the old
³  area.
³ 
³  The KEYBOARD then takes over, feeding the SRETURN
³  expression into the keyboard and into the current GET or GETS.
³ 
³  Examples:
³  ---------
³   EXTERNAL SCROLLER
³ 
³   SET KEY -1 TO SCROLLER  && F2
³ 
³  Notes:
³  -------
³  BIG NOTE:
³ 
³  This is really for managing dynamic lookup tables
³  that will change frequently as to lookup params. Because of this, it
³  is quite complex in nature.
³ 
³  If you know what the lookup is going to be, and it
³  will not change between compiles, look at SMALLS(), SMALLKSET(),
³  SMALLVALID() and SMALLWHEN() and use one of these as
³  appropriate, instead of SCROLLER().
³ 
³  Source:
³  -------
³  S_SCROLL.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

       cDisplay := "IF(DELE(),'π',' ')+"+RTRIM(__SCROLL->sstring)
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


