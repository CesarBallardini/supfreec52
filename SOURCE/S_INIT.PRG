
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION INITSUP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  INITSUP() Sets SuperLib system interface vars for MONO or COLOR
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  INITSUP([lMakePublic])
³ 
³  Description:
³  ------------
³  Checks SLS_ISCOLOR(), and calls SATTCOLOR() or
³  SATTMONO() appropriately, to set to default color or mono color
³  sets. This is only done the first time INITSUP() is called.
³ 
³  If [lMakePublic] is True (default), the old style
³  SuperLib PUBLIC variables are declared and set to their
³  corresponding values based on the new SLS_*() and SLSF_*()
³  functions. This is to help with conversion, but be sure to
³  change any reference to the old style PUBLIC variables to the
³  new function calls, as the PUBLICs will not be an option in the
³  next SuperLib.
³ 
³  Each time INITSUP() is called with (True), the values
³  in the PUBLIC variables are reset from their SLS_*() and
³  SLSF_*() counterparts. The PUBLIC declaration is only done
³  once.
³ 
³  Examples:
³  ---------
³   INITSUP(.f.)  // do not initialize publics
³ 
³  Notes:
³  -------
³  This is mainly here for compatibility with older
³  versions, where INITSUP() was everywhere. INITSUP() previously
³  set up the PUBLIC variables for use by SuperLib. The PUBLIC
³  variable set have now been replaced by the SET/ACCESS function
³  scheme in S_ATTRIB.PRG. INITSUP()'s previous duties have been
³  replaced by the functions:
³ 
³    SLSF_*()
³    SLS_*()
³    SATT*()
³ 
³  See the APPENDIX for upgrading guidance.
³ 
³  Source:
³  -------
³  S_INIT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION initsup(lMakePublic)
static lPublicized := .f.
static lDetermineColor := .f.
MEMVAR _reports, _forms, _queries, _help, _lister, _scroller, _colors
MEMVAR _tododbf, _todontx1, _todontx2, _todontx3
MEMVAR c_normcol, c_normmenu, c_popcol, c_popmenu
MEMVAR c_frame, c_shadatt, c_shadpos, c_xplode
MEMVAR _superprn,query_exp, _checkprn,_supiscolor
lMakepublic := iif(lMakePublic#nil,lMakePublic,.t.)

if !lDetermineColor
  if SLS_ISCOLOR()
    SATTCOLOR()
  ELSE
    SATTMONO()
  endif
  lDetermineColor := .t.
endif

if lMakePublic
  if !lPublicized
    PUBLIC _reports, _forms, _queries, _help, _lister, _scroller, _colors
    PUBLIC _tododbf, _todontx1, _todontx2, _todontx3
    PUBLIC c_normcol, c_normmenu, c_popcol, c_popmenu
    PUBLIC c_frame, c_shadatt, c_shadpos, c_xplode
    PUBLIC _superprn,query_exp, _checkprn,_supiscolor
    lPublicized := .t.
  endif
  C_NORMCOL     := sls_normcol()        // Normal colors
  C_NORMMENU    := sls_normmenu()       // Normal colors - menu
  C_POPCOL      := sls_popcol()         // Popup colors
  C_POPMENU     := sls_popmenu()        // Popup colors - menu
  C_FRAME       := sls_frame()          // Popup box frames
  C_SHADATT     := sls_shadatt()        // Shadow attribute
  C_SHADPOS     := sls_shadpos()        // Shadow position
  C_XPLODE      := sls_xplode()         // Popup boxes explode/implode

  QUERY_EXP     := sls_query()          // Last stored query expression
  _SUPERPRN     := sls_prn()            // Default printer
  _CHECKPRN     := sls_prnc()           // Check the printer
  _SUPISCOLOR   := sls_iscolor()        // Is this a color monitor

  _REPORTS      := slsf_report()        // Name/location of REPORTS file
  _FORMS        := slsf_form()          // Name/location of FORMS file
  _QUERIES      := slsf_query()         // Name/location of QUERIES file
  _LISTER       := slsf_list()          // Name/location of LISTS file
  _TODODBF      := slsf_todo()          // Name/location of TODO file
  _TODONTX1     := slsf_tdn1()          // Name/location of TODO index 1
  _TODONTX2     := slsf_tdn2()          // Name/location of TODO index 2
  _TODONTX3     := slsf_tdn3()          // Name/location of TODO index 3
  _HELP         := slsf_help()          // Name/location of HELP file
  _SCROLLER     := slsf_scroll()        // Name/location of SCROLLER file
  _COLORS       := slsf_color()         // Name/location of COLORS file

endif
return nil

