/*
�����������������������������������������������������������������
� FUNCTION SLSF_REPORT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_REPORT() Sets and retrieves the file name and path for the
� REPORTER() DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_REPORT([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_REPORT() )                    // open the file
�
�  SLSF_REPORT("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_REPORT(cNew)
static cReportDbf               := 'SFREPORT'
return (cReportDbf := iif(cNew#nil,cNew,cReportDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_FORM()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_FORM() Sets and retrieves the file name and path for the
� FORMLETR() DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_FORM([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_FORM() )                    // open the file
�
�  SLSF_FORM("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_FORM(cNew)
static cFormDbf                 := 'FORM'
return (cFormDbf := iif(cNew#nil,cNew,cFormDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_QUERY()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_QUERY() Sets and retrieves the file name and path for the
� QUERY() DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_QUERY([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_QUERY() )                    // open the file
�
�  SLSF_QUERY("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_QUERY(cNew)
static cQueryDbf                := 'QUERIES'
return (cQueryDbf := iif(cNew#nil,cNew,cQueryDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_HELP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_HELP() Sets and retrieves the file name and path for the
� HELP() DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_HELP([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_HELP() )                    // open the file
�
�  SLSF_HELP("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_HELP(cNew)
static cHelpDbf                 := 'HELP'
return (cHelpDbf := iif(cNew#nil,cNew,cHelpDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_LIST()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_LIST() Sets and retrieves the file name and path for the
� LISTER() DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_LIST([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_LIST() )                    // open the file
�
�  SLSF_LIST("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_LIST(cNew)
static cListDbf                 := 'PLIST'
return (cListDbf := iif(cNew#nil,cNew,cListDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_SCROLL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_SCROLL() Sets and retrieves the file name and path for the
� SCROLLER() DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_SCROLL([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_SCROLL() )                    // open the file
�
�  SLSF_SCROLL("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_SCROLL(cNew)
static cScrollDbf               := 'SCROLLER'
return (cScrollDbf := iif(cNew#nil,cNew,cScrollDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_COLOR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_COLOR() Sets and retrieves the file name and path for the
� COLOR SET DBF file
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_COLOR([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_COLOR() )                    // open the file
�
�  SLSF_COLOR("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_COLOR(cNew)
static cColorDbf                := 'COLORS'
return (cColorDbf := iif(cNew#nil,cNew,cColorDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_TODO()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_TODO() Sets and retrieves the file name and path for the
� TODOLIST() DBF files
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_TODO([cNew])
� SLSF_TDN1([cNew])
� SLSF_TDN2([cNew])
� SLSF_TDN3([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_TODO() ) index SLSF_TDN1(),SLSF_TDN2(),SLSF_TDN3()
�                                          // open the files
�
�  SLSF_TODO("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SLSF_APPT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_APPT() Sets and retrieves the file name and path for the
� SAPPOINT() DBF files
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_APPT([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as well.
�
� Examples
�  USE (SLSF_APPT() )                    // open the file
�
�  SLSF_APPT("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_APPT(cNew)
static cAppt                    := 'APPOINT'
return (cAppt := iif(cNew#nil,cNew,cAppt) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_LABEL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_LABEL() Sets and retrieves the file name and path for the
� CLABEL() label files
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_LABEL([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as
� well.
�
� Examples
�  USE (slsf_label() )                    // open the file
�
�  SLSF_LABEL("c:\hidden\XYZ123")         // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_LABEL(cNew)
static cLabelDbf                := 'CLABELS'
return (cLabelDbf := iif(cNew#nil,cNew,cLabelDbf) )

/*
�����������������������������������������������������������������
� FUNCTION SLSF_OLD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
� SLSF_OLD() Sets and retrieves the file name and path for the
� OLD() help files
�
� Returns
� <cFileSpec>  => File path and name less extension
�
� Syntax
� SLSF_OLD([cNew])
�
� Description
�
� [cNew] optionally sets the path and/or filename.
�
� If [cNew] is passed, this is the value returned as
� well.
�
� Examples
�  USE (SLSF_OLD() )                    // open the file
�
�  SLSF_OLD("c:\hidden\XYZ123")            // sets the filespec
�                                          // to XYZ123.DBF in
�                                          // c:\HIDDEN
�
� Source: S_PATHS.PRG
����������������������������������������������������������������� 
*/
FUNCTION SLSF_OLD(cNew)
static cOldDocDbf               := 'SLOLDS'
return (cOldDocDbf := iif(cNew#nil,cNew,cOldDocDbf) )

