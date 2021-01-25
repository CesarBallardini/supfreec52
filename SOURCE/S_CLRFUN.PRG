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
�����������������������������������������������������������������
� FUNCTION SATTCOLOR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTCOLOR() Sets up color vars for color monitor
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTCOLOR()
� 
�  Description:
�  ------------
�  This sets up the system color and interface variables
�  described in SLS_*() for color monitor defaults.
� 
�  If  COLORS.DBF is present, the color set named
�  "DEFAULT" is retrieved, otherwise a default set is used.
� 
�  Examples:
�  ---------
�   IF ISCOLOR()
�     SATTCOLOR()
�   ELSE
�     SATTMONO()
�   ENDIF
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
*/
Function SattColor()
     IF FILE(slsf_color()+".DBF")
       SattGet("DEFAULT")
     ELSE
       sls_normcol('W/B,GR+/R,,,W/N')
       sls_normmenu('W/B,N/R,,,W/N')
       sls_popcol('N/BG,N/W,,,BG+/N')
       sls_popmenu('N/BG,W+/N,,,BG+/N')
       sls_frame("�Ŀ����� ")
       sls_shadatt(7)
       sls_shadpos(1)
       sls_xplode(.T.)
     ENDIF
return nil

/*
�����������������������������������������������������������������
� FUNCTION SATTMONO()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTMONO() Sets up color vars for mono monitor
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTMONO()
� 
�  Description:
�  ------------
�  This sets up the system color and interface variables
�  described in SLS_*() for MONOCHROME monitor defaults.
� 
�  Examples:
�  ---------
�   IF ISCOLOR()
�     SATTCOLOR()
�   ELSE
�     SATTMONO()
�   ENDIF
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
*/
Function SattMono()
     sls_normcol('W/N,N/W,,,+W/N')
     sls_normmenu('W/N,N/W,,,+W/N')
     sls_popcol(  'N/W,+W/N,,,W/N')
     sls_popmenu('N/W,W/N,,,+W/N')
     sls_frame( "�Ŀ����� ")
     sls_shadatt(8)
     sls_shadpos(1)
     sls_xplode(.T.)
return nil

/*
�����������������������������������������������������������������
� FUNCTION SATTDIRECT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTDIRECT() Sets up the the color vars directly
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTDIRECT([cNormCol],[cNormMenu],[cPopCol],[cPopMenu],[cFrame],;
�        [nShadAtt],[nShadPos],[lExplode])
� 
�  Description:
�  ------------
�  This sets up the system color and interface variables
�  described in SLS_*() all in one shot, rather than with individual
�  calls.
� 
�  Examples:
�  ---------
�   To restore from an old COLORS.MEM:
� 
�   restore from colors.mem additive
�   SATTDIRECT(c_normcol,c_normmenu,c_popcol , ;
�                  c_popmenu,c_frame,c_shadatt,;
�                         c_shadpos, c_xplode)
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTGETMEM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTGETMEM() Sets up SuperLib color vars from old COLORS.MEM
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTGETMEM(cFileName)
� 
�  Description:
�  ------------
�  This sets up the system color and interface variables
�  described in SLS_*() by restoring from an old stype COLORS.MEM
� 
�  <cFileName> is the name (and path) of the file.
� 
�  The COLORS.MEM vars are NOT made public.
� 
�  Examples:
�  ---------
�   SATTGETMEM("COLORS.MEM")
�    // GRAB FROM OLD COLORS.MEM
� 
�   SATTPUT("OLD COLORS.MEM SETTINGS")
�   // store them in COLORS.DBF
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTGET()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTGET() Sets up SuperLib color vars from COLORS.DBF
� 
�  Returns:
�  --------
�  <lSuccess> => Success, True of False
� 
�  Syntax:
�  -------
�  SATTGET([cSetName])
� 
�  Description:
�  ------------
�  This sets up the system color and interface variables
�  described in SLS_*() by grabbing them from the COLORS.DBF file, as
�  described in SLSF_COLOR().
� 
�  [cSetName] is an optional name of a previously saved
�  color set.
� 
�  If none is passed, the color set named "DEFAULT" is
�  used.
� 
�  Examples:
�  ---------
�   SATTGET("THE BLUE SET")
� 
�  Notes:
�  -------
�  SATTPUT() and SETCOLORS() allow store of color sets.
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTPUT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTPUT() Stores current SuperLib color vars to COLORS.DBF
� 
�  Returns:
�  --------
�  <lSuccess> => Success, True of False
� 
�  Syntax:
�  -------
�  SATTPUT([cSetName])
� 
�  Description:
�  ------------
�  This stores the system color and interface variables
�  described in SLS_*() in the colors dbf defined by SLSF_COLOR().
� 
�  [cSetName] is an optional name of a previously saved
�  color set.
� 
�  If none is passed, the color set named "DEFAULT" is
�  used.
� 
�  Examples:
�  ---------
�   SATTGET("THE BLUE SET")        // restore a previous definition
�   SLS_POPCOL("+GR/N,+W/R,,,W/R")
�                              // changes the sls_popcol() setting
�   SATTPUT("THE BLUE SET # 2")    // stores the revised set in the dbf
� 
�  Notes:
�  -------
�  SETCOLORS() also allows storage of color sets.
� 
�  SATTPUT() attempts to re-used deleted records.
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTPICK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTPICK() Sets up SuperLib color vars by selecting from DBF
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTPICK()
� 
�  Description:
�  ------------
�  This sets up the system color and interface variables
�  described in SLS_*() by allowing a picklist of them from the
�  colors dbf defined in SLSF_COLOR().
� 
�  Examples:
�  ---------
�   SATTPICK()
� 
�  Notes:
�  -------
�  SATTPUT() and SETCOLORS() allow storage of color sets
�  to disk. SETCOLORS() makes use of SATTPICK().
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTPICKPUT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTPICKPUT() Stores SuperLib color vars to selected record
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTPICKPUT()
� 
�  Description:
�  ------------
�  This writes the current system color and interface
�  variables described in SLS_*() by selecting either an existing
�  set name (contained in the colors dbf file described in
�  SLSF_COLOR() ) to overwrite, or allowing a new set to be stored.
� 
�  Examples:
�  ---------
�   SATTPICKPUT()
� 
�  Notes:
�  -------
�  SATTPUT() and SETCOLORS() allow storage of color sets
�  to disk.
� 
�  SATTPICKPUT() attempts to re-use deleted records.
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTPICKDEL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTPICKDEL() Picklist deletion of stored color var sets
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTPICKDEL()
� 
�  Description:
�  ------------
�  A Picklist of color sets, stored in the colors dbf
�  file described in SLSF_COLOR(), is presented. Selected color set is
�  deleted.
� 
�  Examples:
�  ---------
�   If MESSYN("Want to delete a stored color set?")
�     SATTPICKDEL()
�   Endif
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTPUSH()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTPUSH() Pushes the current SuperLib color vars
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTPUSH()
� 
�  Description:
�  ------------
�  This pushes the current system color and interface
�  variables described in SLS_*() onto a stack, for later retrieval
�  with SATTPOP().
� 
�  Examples:
�  ---------
�   SATTPUSH()
�   SATTGET("THE BLUE SET")
�   //...some code
�   SATTPOP()  // restore the prior color set
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SATTPOP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SATTPOP() Pops previously pushed SuperLib color vars
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SATTPOP()
� 
�  Description:
�  ------------
�  This pops a previously pushed set of SuperLib system
�  interface
� 
�  variables described in SLS_*().
� 
�  Examples:
�  ---------
�   SATTPUSH()
�   SATTGET("THE BLUE SET")
�   //...some code
�   SATTPOP()  // restore the prior color set
� 
�  Source:
�  -------
�  S_CLRFUN.PRG
� 
����������������������������������������������������������������� 
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

