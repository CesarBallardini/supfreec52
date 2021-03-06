/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_REPORT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_REPORT() Sets and retrieves the file name and path for the
³ REPORTER() DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_REPORT([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_REPORT() )                    // open the file
³
³  SLSF_REPORT("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_REPORT(cNew)
static cReportDbf               := 'SFREPORT'
return (cReportDbf := iif(cNew#nil,cNew,cReportDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_FORM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_FORM() Sets and retrieves the file name and path for the
³ FORMLETR() DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_FORM([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_FORM() )                    // open the file
³
³  SLSF_FORM("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_FORM(cNew)
static cFormDbf                 := 'FORM'
return (cFormDbf := iif(cNew#nil,cNew,cFormDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_QUERY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_QUERY() Sets and retrieves the file name and path for the
³ QUERY() DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_QUERY([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_QUERY() )                    // open the file
³
³  SLSF_QUERY("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_QUERY(cNew)
static cQueryDbf                := 'QUERIES'
return (cQueryDbf := iif(cNew#nil,cNew,cQueryDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_HELP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_HELP() Sets and retrieves the file name and path for the
³ HELP() DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_HELP([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_HELP() )                    // open the file
³
³  SLSF_HELP("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_HELP(cNew)
static cHelpDbf                 := 'HELP'
return (cHelpDbf := iif(cNew#nil,cNew,cHelpDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_LIST()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_LIST() Sets and retrieves the file name and path for the
³ LISTER() DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_LIST([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_LIST() )                    // open the file
³
³  SLSF_LIST("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_LIST(cNew)
static cListDbf                 := 'PLIST'
return (cListDbf := iif(cNew#nil,cNew,cListDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_SCROLL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_SCROLL() Sets and retrieves the file name and path for the
³ SCROLLER() DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_SCROLL([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_SCROLL() )                    // open the file
³
³  SLSF_SCROLL("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_SCROLL(cNew)
static cScrollDbf               := 'SCROLLER'
return (cScrollDbf := iif(cNew#nil,cNew,cScrollDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_COLOR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_COLOR() Sets and retrieves the file name and path for the
³ COLOR SET DBF file
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_COLOR([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_COLOR() )                    // open the file
³
³  SLSF_COLOR("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_COLOR(cNew)
static cColorDbf                := 'COLORS'
return (cColorDbf := iif(cNew#nil,cNew,cColorDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_TODO()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_TODO() Sets and retrieves the file name and path for the
³ TODOLIST() DBF files
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_TODO([cNew])
³ SLSF_TDN1([cNew])
³ SLSF_TDN2([cNew])
³ SLSF_TDN3([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_TODO() ) index SLSF_TDN1(),SLSF_TDN2(),SLSF_TDN3()
³                                          // open the files
³
³  SLSF_TODO("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_TODO(cNew)
static cTodoDbf                 := 'TODO'
return (cTodoDbf := iif(cNew#nil,cNew,cTodoDbf) )

FUNCTION SLSF_TDN1(cNew)
static cTodoNtx1                := 'TODO'
return (cTodoNtx1 := iif(cNew#nil,cNew,cTodoNtx1) )

FUNCTION SLSF_TDN2(cNew)
static cTodoNtx2                := 'TODOP'
return (cTodoNtx2 := iif(cNew#nil,cNew,cTodoNtx2) )

FUNCTION SLSF_TDN3(cNew)
static cTodoNtx3                := 'TODOD'
return (cTodoNtx3 := iif(cNew#nil,cNew,cTodoNtx3) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_APPT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_APPT() Sets and retrieves the file name and path for the
³ SAPPOINT() DBF files
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_APPT([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as well.
³
³ Examples
³  USE (SLSF_APPT() )                    // open the file
³
³  SLSF_APPT("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_APPT(cNew)
static cAppt                    := 'APPOINT'
return (cAppt := iif(cNew#nil,cNew,cAppt) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_LABEL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_LABEL() Sets and retrieves the file name and path for the
³ CLABEL() label files
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_LABEL([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as
³ well.
³
³ Examples
³  USE (slsf_label() )                    // open the file
³
³  SLSF_LABEL("c:\hidden\XYZ123")         // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_LABEL(cNew)
static cLabelDbf                := 'CLABELS'
return (cLabelDbf := iif(cNew#nil,cNew,cLabelDbf) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLSF_OLD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³ SLSF_OLD() Sets and retrieves the file name and path for the
³ OLD() help files
³
³ Returns
³ <cFileSpec>  => File path and name less extension
³
³ Syntax
³ SLSF_OLD([cNew])
³
³ Description
³
³ [cNew] optionally sets the path and/or filename.
³
³ If [cNew] is passed, this is the value returned as
³ well.
³
³ Examples
³  USE (SLSF_OLD() )                    // open the file
³
³  SLSF_OLD("c:\hidden\XYZ123")            // sets the filespec
³                                          // to XYZ123.DBF in
³                                          // c:\HIDDEN
³
³ Source: S_PATHS.PRG
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLSF_OLD(cNew)
static cOldDocDbf               := 'SLOLDS'
return (cOldDocDbf := iif(cNew#nil,cNew,cOldDocDbf) )

