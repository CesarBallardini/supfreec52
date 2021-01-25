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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SCROLLER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SCROLLER() Hotkey lookup tables with dbf storage
ณ 
ณ  Returns:
ณ  --------
ณ  nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SET KEY xxx TO SCROLLER
ณ 
ณ  Description:
ณ  ------------
ณ  Scroller is a hotkey lookup table engine.
ณ 
ณ  Scroller is data-driven , meaning it operates on data
ณ  stored external to
ณ 
ณ  the EXE in SCROLLER.DBF.
ณ 
ณ  SCROLLER() is called via a SET KEY. When called, it
ณ  receives the parameters <cProc> and <cVar> from Clipper, telling
ณ  it the proc and variable the user was sitting on when he pressed
ณ  the hotkey.
ณ 
ณ  The actual parameters rec'd are <cProc> (proc name),
ณ  <cLine> (line #) and <cVar> (variable name) .<cLine> is ignored,
ณ  but it is included as the 2nd parameter because it is passed by
ณ  Clipper's setkey routines.
ณ 
ณ  SCROLLER() attempts to find a corresponding record in
ณ  SCROLLER.DBF (which contains fields for proc name and variable).
ณ  SCROLLER.DBF is a storage place for lookup definitions.
ณ 
ณ  If SCROLLER does not find a matching record, it
ณ  simply closes SCROLLER.DBF and returns to the previous area. It
ณ  then displays a 'lookup table not found' message.
ณ 
ณ  If SCROLLER finds a matching record, it loads the
ณ  values into memory and closes SCROLLER.DBF. It then opens the
ณ  DBF [and index] of the lookup dbf in the next available area. If
ณ  it is unable to open the dbf, it displays an error message and
ณ  goes back to the previously selected area.
ณ 
ณ  SCROLLER then draws a box, using the DESCRIPTION
ณ  field as the title, initializes a 1 element array composed of
ณ  the SSTRING (see structure)  expression and calls SMALLS() .
ณ 
ณ  While in the SMALLS(), first letter searches can be
ณ  done if the dbf is indexed  with a character index. Pressing
ณ  ENTER will KEYBOARD the expression in SRETURN (unless its
ณ  empty), close up the current area and return to the old area.
ณ  Pressing escape just closes things up and returns to the old
ณ  area.
ณ 
ณ  The KEYBOARD then takes over, feeding the SRETURN
ณ  expression into the keyboard and into the current GET or GETS.
ณ 
ณ  Examples:
ณ  ---------
ณ   EXTERNAL SCROLLER
ณ 
ณ   SET KEY -1 TO SCROLLER  && F2
ณ 
ณ  Notes:
ณ  -------
ณ  BIG NOTE:
ณ 
ณ  This is really for managing dynamic lookup tables
ณ  that will change frequently as to lookup params. Because of this, it
ณ  is quite complex in nature.
ณ 
ณ  If you know what the lookup is going to be, and it
ณ  will not change between compiles, look at SMALLS(), SMALLKSET(),
ณ  SMALLVALID() and SMALLWHEN() and use one of these as
ณ  appropriate, instead of SCROLLER().
ณ 
ณ  Source:
ณ  -------
ณ  S_SCROLL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

       cDisplay := "IF(DELE(),'๐',' ')+"+RTRIM(__SCROLL->sstring)
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


