/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_REPORT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_REPORT() Sets and retrieves the file name and path for the
ณ REPORTER() DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_REPORT([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_REPORT() )                    // open the file
ณ
ณ  SLSF_REPORT("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_REPORT(cNew)
static cReportDbf               := 'SFREPORT'
return (cReportDbf := iif(cNew#nil,cNew,cReportDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_FORM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_FORM() Sets and retrieves the file name and path for the
ณ FORMLETR() DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_FORM([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_FORM() )                    // open the file
ณ
ณ  SLSF_FORM("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_FORM(cNew)
static cFormDbf                 := 'FORM'
return (cFormDbf := iif(cNew#nil,cNew,cFormDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_QUERY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_QUERY() Sets and retrieves the file name and path for the
ณ QUERY() DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_QUERY([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_QUERY() )                    // open the file
ณ
ณ  SLSF_QUERY("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_QUERY(cNew)
static cQueryDbf                := 'QUERIES'
return (cQueryDbf := iif(cNew#nil,cNew,cQueryDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_HELP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_HELP() Sets and retrieves the file name and path for the
ณ HELP() DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_HELP([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_HELP() )                    // open the file
ณ
ณ  SLSF_HELP("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_HELP(cNew)
static cHelpDbf                 := 'HELP'
return (cHelpDbf := iif(cNew#nil,cNew,cHelpDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_LIST()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_LIST() Sets and retrieves the file name and path for the
ณ LISTER() DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_LIST([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_LIST() )                    // open the file
ณ
ณ  SLSF_LIST("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_LIST(cNew)
static cListDbf                 := 'PLIST'
return (cListDbf := iif(cNew#nil,cNew,cListDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_SCROLL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_SCROLL() Sets and retrieves the file name and path for the
ณ SCROLLER() DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_SCROLL([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_SCROLL() )                    // open the file
ณ
ณ  SLSF_SCROLL("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_SCROLL(cNew)
static cScrollDbf               := 'SCROLLER'
return (cScrollDbf := iif(cNew#nil,cNew,cScrollDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_COLOR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_COLOR() Sets and retrieves the file name and path for the
ณ COLOR SET DBF file
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_COLOR([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_COLOR() )                    // open the file
ณ
ณ  SLSF_COLOR("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_COLOR(cNew)
static cColorDbf                := 'COLORS'
return (cColorDbf := iif(cNew#nil,cNew,cColorDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_TODO()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_TODO() Sets and retrieves the file name and path for the
ณ TODOLIST() DBF files
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_TODO([cNew])
ณ SLSF_TDN1([cNew])
ณ SLSF_TDN2([cNew])
ณ SLSF_TDN3([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_TODO() ) index SLSF_TDN1(),SLSF_TDN2(),SLSF_TDN3()
ณ                                          // open the files
ณ
ณ  SLSF_TODO("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_APPT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_APPT() Sets and retrieves the file name and path for the
ณ SAPPOINT() DBF files
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_APPT([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as well.
ณ
ณ Examples
ณ  USE (SLSF_APPT() )                    // open the file
ณ
ณ  SLSF_APPT("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_APPT(cNew)
static cAppt                    := 'APPOINT'
return (cAppt := iif(cNew#nil,cNew,cAppt) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_LABEL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_LABEL() Sets and retrieves the file name and path for the
ณ CLABEL() label files
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_LABEL([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as
ณ well.
ณ
ณ Examples
ณ  USE (slsf_label() )                    // open the file
ณ
ณ  SLSF_LABEL("c:\hidden\XYZ123")         // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_LABEL(cNew)
static cLabelDbf                := 'CLABELS'
return (cLabelDbf := iif(cNew#nil,cNew,cLabelDbf) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLSF_OLD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ SLSF_OLD() Sets and retrieves the file name and path for the
ณ OLD() help files
ณ
ณ Returns
ณ <cFileSpec>  => File path and name less extension
ณ
ณ Syntax
ณ SLSF_OLD([cNew])
ณ
ณ Description
ณ
ณ [cNew] optionally sets the path and/or filename.
ณ
ณ If [cNew] is passed, this is the value returned as
ณ well.
ณ
ณ Examples
ณ  USE (SLSF_OLD() )                    // open the file
ณ
ณ  SLSF_OLD("c:\hidden\XYZ123")            // sets the filespec
ณ                                          // to XYZ123.DBF in
ณ                                          // c:\HIDDEN
ณ
ณ Source: S_PATHS.PRG
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLSF_OLD(cNew)
static cOldDocDbf               := 'SLOLDS'
return (cOldDocDbf := iif(cNew#nil,cNew,cOldDocDbf) )

