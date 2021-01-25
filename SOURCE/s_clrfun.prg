static dbfstruc := {;
                     { "SETNAME",  "C", 40, 0 },;
                     { "DMAINCOL",  "C", 40, 0 },;
                     { "DMAINMENU", "C", 40, 0 },;
                     { "DPOPCOL", "C", 40, 0 },;
                     { "DPOPMENU", "C", 40, 0 },;
                     { "DFRAME", "C", 40, 0 },;
                     { "DSHADATT", "N", 3, 0 },;
                     { "DSHADPOS", "N", 1, 0 },;
                     { "DEXPLODE", "L", 1, 0 }       }
static aStacks                  := {}
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTCOLOR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTCOLOR() Sets up color vars for color monitor
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTCOLOR()
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the system color and interface variables
ณ  described in SLS_*() for color monitor defaults.
ณ 
ณ  If  COLORS.DBF is present, the color set named
ณ  "DEFAULT" is retrieved, otherwise a default set is used.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF ISCOLOR()
ณ     SATTCOLOR()
ณ   ELSE
ณ     SATTMONO()
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattColor()
     IF FILE(slsf_color()+".DBF")
       SattGet("DEFAULT")
     ELSE
       sls_normcol('W/B,GR+/R,,,W/N')
       sls_normmenu('W/B,N/R,,,W/N')
       sls_popcol('N/BG,N/W,,,BG+/N')
       sls_popmenu('N/BG,W+/N,,,BG+/N')
       sls_frame("ฺฤฟณูฤภณ ")
       sls_shadatt(7)
       sls_shadpos(1)
       sls_xplode(.T.)
     ENDIF
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTMONO()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTMONO() Sets up color vars for mono monitor
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTMONO()
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the system color and interface variables
ณ  described in SLS_*() for MONOCHROME monitor defaults.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF ISCOLOR()
ณ     SATTCOLOR()
ณ   ELSE
ณ     SATTMONO()
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattMono()
     sls_normcol('W/N,N/W,,,+W/N')
     sls_normmenu('W/N,N/W,,,+W/N')
     sls_popcol(  'N/W,+W/N,,,W/N')
     sls_popmenu('N/W,W/N,,,+W/N')
     sls_frame( "ฺฤฟณูฤภณ ")
     sls_shadatt(8)
     sls_shadpos(1)
     sls_xplode(.T.)
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTDIRECT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTDIRECT() Sets up the the color vars directly
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTDIRECT([cNormCol],[cNormMenu],[cPopCol],[cPopMenu],[cFrame],;
ณ        [nShadAtt],[nShadPos],[lExplode])
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the system color and interface variables
ณ  described in SLS_*() all in one shot, rather than with individual
ณ  calls.
ณ 
ณ  Examples:
ณ  ---------
ณ   To restore from an old COLORS.MEM:
ณ 
ณ   restore from colors.mem additive
ณ   SATTDIRECT(c_normcol,c_normmenu,c_popcol , ;
ณ                  c_popmenu,c_frame,c_shadatt,;
ณ                         c_shadpos, c_xplode)
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattDirect(cpMainColor,cpMainMenuColor,cpPopupColor,cpPopupMenuColor,;
                    cpFrameString,npShadowAtt,npShadowPos,lpExplodeBoxes)
     sls_normcol(  iif(cpMainColor#nil,cpMainColor,)          )
     sls_normmenu( iif(cpMainMenuColor#nil,cpMainMenuColor,))
     sls_popcol(   iif(cpPopupColor#nil,cpPopupColor,))
     sls_popmenu(  iif(cpPopupMenuColor#nil,cpPopupMenuColor,))
     sls_frame(    iif(cpFrameString#nil,cpFrameString,))
     sls_shadatt(  iif(npShadowAtt#nil,npShadowAtt,))
     sls_shadpos(  iif(npShadowPos#nil,npShadowPos,))
     sls_xplode(   iif(lpExplodeBoxes#nil,lpExplodeBoxes,))
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTGETMEM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTGETMEM() Sets up SuperLib color vars from old COLORS.MEM
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTGETMEM(cFileName)
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the system color and interface variables
ณ  described in SLS_*() by restoring from an old stype COLORS.MEM
ณ 
ณ  <cFileName> is the name (and path) of the file.
ณ 
ณ  The COLORS.MEM vars are NOT made public.
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTGETMEM("COLORS.MEM")
ณ    // GRAB FROM OLD COLORS.MEM
ณ 
ณ   SATTPUT("OLD COLORS.MEM SETTINGS")
ณ   // store them in COLORS.DBF
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattGetMem(cFileName)   // get from old COLORS.MEM
memvar c_normcol,c_normmenu,c_popcol,c_popmenu,c_frame
memvar c_shadatt,c_shadpos,c_xplode
if file(cFileName)
  restore from (cFileName) additive
  sls_normcol( iif(c_normcol#nil,c_normcol, ) )
  sls_normmenu(iif(c_normmenu#nil,c_normmenu,) )
  sls_popcol(  iif(c_popcol#nil,c_popcol,) )
  sls_popmenu( iif(c_popmenu#nil,c_popmenu,) )
  sls_frame(   iif(c_frame#nil,c_frame,) )
  sls_shadatt( iif(c_shadatt#nil,c_shadatt,) )
  sls_shadpos( iif(c_shadpos#nil,c_shadpos,) )
  sls_xplode(  iif(c_xplode#nil,c_xplode,) )
endif
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTGET()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTGET() Sets up SuperLib color vars from COLORS.DBF
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => Success, True of False
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTGET([cSetName])
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the system color and interface variables
ณ  described in SLS_*() by grabbing them from the COLORS.DBF file, as
ณ  described in SLSF_COLOR().
ณ 
ณ  [cSetName] is an optional name of a previously saved
ณ  color set.
ณ 
ณ  If none is passed, the color set named "DEFAULT" is
ณ  used.
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTGET("THE BLUE SET")
ณ 
ณ  Notes:
ณ  -------
ณ  SATTPUT() and SETCOLORS() allow store of color sets.
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattGet(cSetName)   // get from DBF
field SETNAME,DMAINCOL,DMAINMENU,DPOPCOL,DPOPMENU,DFRAME
field DSHADATT,DSHADPOS,DEXPLODE
local lSuccess := .f.
local nOldarea := select()
local cFileName := slsf_color()+".DBF"
cSetName := iif(cSetName==nil,"DEFAULT",cSetName)
select 0
IF file(cFileName) .and. SNET_USE(cFileName,,.F.,5,.F.)
  locate for trim(SETNAME)==cSetName
  if found()
   sls_normcol(    DMAINCOL  )
   sls_normmenu(   DMAINMENU )
   sls_popcol(     DPOPCOL   )
   sls_popmenu(    DPOPMENU  )
   sls_frame(      DFRAME    )
   sls_shadatt(    DSHADATT  )
   sls_shadpos(    DSHADPOS  )
   sls_xplode(     DEXPLODE  )

   lSuccess    := .t.

  endif
  USE
endif
select (nOldarea)
return (lSuccess)

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTPUT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTPUT() Stores current SuperLib color vars to COLORS.DBF
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => Success, True of False
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTPUT([cSetName])
ณ 
ณ  Description:
ณ  ------------
ณ  This stores the system color and interface variables
ณ  described in SLS_*() in the colors dbf defined by SLSF_COLOR().
ณ 
ณ  [cSetName] is an optional name of a previously saved
ณ  color set.
ณ 
ณ  If none is passed, the color set named "DEFAULT" is
ณ  used.
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTGET("THE BLUE SET")        // restore a previous definition
ณ   SLS_POPCOL("+GR/N,+W/R,,,W/R")
ณ                              // changes the sls_popcol() setting
ณ   SATTPUT("THE BLUE SET # 2")    // stores the revised set in the dbf
ณ 
ณ  Notes:
ณ  -------
ณ  SETCOLORS() also allows storage of color sets.
ณ 
ณ  SATTPUT() attempts to re-used deleted records.
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattPut(cSetName)   // write to DBF
field SETNAME,DMAINCOL,DMAINMENU,DPOPCOL,DPOPMENU,DFRAME
field DSHADATT,DSHADPOS,DEXPLODE
local lSuccess := .f.
local nOldarea := select()
local cFileName := slsf_color()+".DBF"
cSetName := padr(iif(cSetName==nil,"DEFAULT",cSetName),40)

if !file(cFileName)
   dbcreate(cFileName,dbfstruc)
endif
select 0
IF SNET_USE(cFileName,,.F.,5,.F.)
  locate for SETNAME==cSetName
  IF (!found().and.SADD_REC(5,.F.)) .or. (found() .and. SREC_LOCK(5,.F.) )
     SETNAME     := cSetName
     DMAINCOL    := sls_normcol()
     DMAINMENU   := sls_normmenu()
     DPOPCOL     := sls_popcol()
     DPOPMENU    := sls_popmenu()
     DFRAME      := sls_frame()
     DSHADATT    := sls_shadatt()
     DSHADPOS    := sls_shadpos()
     DEXPLODE    := sls_xplode()

     lSuccess    := .t.
  ENDIF
  UNLOCK
  USE
ENDIF
select (nOldarea)
return (lSuccess)

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTPICK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTPICK() Sets up SuperLib color vars by selecting from DBF
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTPICK()
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the system color and interface variables
ณ  described in SLS_*() by allowing a picklist of them from the
ณ  colors dbf defined in SLSF_COLOR().
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTPICK()
ณ 
ณ  Notes:
ณ  -------
ณ  SATTPUT() and SETCOLORS() allow storage of color sets
ณ  to disk. SETCOLORS() makes use of SATTPICK().
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattPick()   // get from DBF
field SETNAME,DMAINCOL,DMAINMENU,DPOPCOL,DPOPMENU,DFRAME
field DSHADATT,DSHADPOS,DEXPLODE
local nOldarea := select()
local nSelection,aSelections,i
local cFileName := slsf_color()+".DBF"

select 0
IF file(cFileName) .and. SNET_USE(cFileName,,.F.,5,.F.) .and. recc() > 0
  aSelections := array(recc())
  for i = 1 to recc()
    go i
    aSelections[i] := SETNAME
  next
  nSelection := mchoice(aSelections,5,15,19,65,"Select Color Set")
  if nSelection > 0
   go (nSelection)
   sls_normcol(    DMAINCOL )
   sls_normmenu(    DMAINMENU )
   sls_popcol(    DPOPCOL )
   sls_popmenu(    DPOPMENU )
   sls_frame(    DFRAME )
   sls_shadatt(    DSHADATT )
   sls_shadpos(    DSHADPOS )
   sls_xplode(    DEXPLODE )
  endif
else
  msg("No Store color sets here")
endif
use
select (nOldarea)
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTPICKPUT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTPICKPUT() Stores SuperLib color vars to selected record
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTPICKPUT()
ณ 
ณ  Description:
ณ  ------------
ณ  This writes the current system color and interface
ณ  variables described in SLS_*() by selecting either an existing
ณ  set name (contained in the colors dbf file described in
ณ  SLSF_COLOR() ) to overwrite, or allowing a new set to be stored.
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTPICKPUT()
ณ 
ณ  Notes:
ณ  -------
ณ  SATTPUT() and SETCOLORS() allow storage of color sets
ณ  to disk.
ณ 
ณ  SATTPICKPUT() attempts to re-use deleted records.
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SattPickPut()   // write to DBF
field SETNAME,DMAINCOL,DMAINMENU,DPOPCOL,DPOPMENU,DFRAME
field DSHADATT,DSHADPOS,DEXPLODE
local nOldarea := select()
local nSelection,aSelections,i
local cFileName := slsf_color()+".DBF"
local cSetName := padr(iif(cSetName==nil,"DEFAULT",cSetName),40)
if !file(cFileName)
   dbcreate(cFileName,dbfstruc)
   sAttPut(cSetNAme)
endif

select 0
IF SNET_USE(cFileName,,.F.,5,.F.) .and. recc() > 0
  aSelections := {"<new>"}
  for i = 1 to recc()
    go i
    aadd(aSelections,SETNAME)
  next
  use
  nSelection := mchoice(aSelections,5,15,19,65,"Select Color Set Name")
  if nSelection > 1
    sAttPut(aSelections[nSelection] )
  elseif nSelection = 1
    popread(.t.,"Enter a description for this color set:",@cSetName,"")
    sAttPut(cSetName)
  endif
else
  msg("No stored color sets here")
endif
select (nOldarea)
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTPICKDEL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTPICKDEL() Picklist deletion of stored color var sets
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTPICKDEL()
ณ 
ณ  Description:
ณ  ------------
ณ  A Picklist of color sets, stored in the colors dbf
ณ  file described in SLSF_COLOR(), is presented. Selected color set is
ณ  deleted.
ณ 
ณ  Examples:
ณ  ---------
ณ   If MESSYN("Want to delete a stored color set?")
ณ     SATTPICKDEL()
ณ   Endif
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/

Function SattPickDel()   // pick delete color sets
field SETNAME,DMAINCOL,DMAINMENU,DPOPCOL,DPOPMENU,DFRAME
field DSHADATT,DSHADPOS,DEXPLODE
local nOldarea := select()
local nSelection,aSelections,aRecnos,i
local cFileName := slsf_color()+".DBF"
local cSetName := padr(iif(cSetName==nil,"DEFAULT",cSetName),40)
aSelections := {}
aRecnos     := {}
if !file(cFileName)
   msg("No color sets stored")
else
  select 0
  IF SNET_USE(cFileName,,.F.,5,.F.) .and. recc() > 0
    for i = 1 to recc()
      go i
      if !deleted()
        aadd(aSelections,SETNAME)
        aadd(aRecnos,recno())
      endif
    next
    nSelection := mchoice(aSelections,5,15,19,65,"Select color set to delete")
    if nSelection > 0
      go (aRecnos[nSelection])
      if srec_lock(5,.t.,"Unable to lock record, keep trying?")
        DBDELETE()
      endif
    endif
  else
    msg("No Store color sets here")
  endif
  use
endif
select (nOldarea)
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTPUSH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTPUSH() Pushes the current SuperLib color vars
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTPUSH()
ณ 
ณ  Description:
ณ  ------------
ณ  This pushes the current system color and interface
ณ  variables described in SLS_*() onto a stack, for later retrieval
ณ  with SATTPOP().
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTPUSH()
ณ   SATTGET("THE BLUE SET")
ณ   //...some code
ณ   SATTPOP()  // restore the prior color set
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION sAttPush
aadd(aStacks, {;
                 sls_normcol(),;
                 sls_normmenu(),;
                 sls_popcol(),;
                 sls_popmenu(),;
                 sls_shadatt(),;
                 sls_shadpos(),;
                 sls_xplode() } )
RETURN nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SATTPOP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SATTPOP() Pops previously pushed SuperLib color vars
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SATTPOP()
ณ 
ณ  Description:
ณ  ------------
ณ  This pops a previously pushed set of SuperLib system
ณ  interface
ณ 
ณ  variables described in SLS_*().
ณ 
ณ  Examples:
ณ  ---------
ณ   SATTPUSH()
ณ   SATTGET("THE BLUE SET")
ณ   //...some code
ณ   SATTPOP()  // restore the prior color set
ณ 
ณ  Source:
ณ  -------
ณ  S_CLRFUN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION sAttPop
local aOldSet
if len(aStacks) > 0
  aOldSet := atail(aStacks)
  sls_normcol(aOldSet[1])
  sls_normmenu(aOldSet[2])
  sls_popcol(aOldSet[3])
  sls_popmenu(aOldSet[4])
  sls_shadatt(aOldSet[5])
  sls_shadpos(aOldSet[6])
  sls_xplode(aOldSet[7])
  asize(aStacks,len(aStacks)-1)
endif
RETURN ''

