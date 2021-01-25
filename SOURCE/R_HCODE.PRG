#include "inkey.ch"
//----------------------------------------------------------------------
//-- these defines are the element positions within the aValues array
//-- which correspond to various report elements
#DEFINE M_DBF           1        // dbf name
#DEFINE M_TITLE         2        // report title (name)
#DEFINE M_NDXKEY        3        // index key
#DEFINE M_MAJKEY        4        // major group portion of index key
#DEFINE M_MINKEY        5        // minor group portion of index key
#DEFINE M_MAJTEXT       6        // major group header text
#DEFINE M_MINTEXT       7        // minor group header text
#DEFINE M_WIDTH         8        // page width in characters
#DEFINE M_LENGTH        9        // page length in lines
#DEFINE M_LEFTM        10        // left margin in columns (#blank columns)
#DEFINE M_TOPM         11        // top margin in rows (#blank rows)
#DEFINE M_SPACE        12        // line spacing 0 = single, 1 = double
#DEFINE M_PAUSE        13        // pause between pages ? Y/N
#DEFINE M_NPLINES      14        // page eject if (n) lines left on group change
#DEFINE M_EJB4         15        // page eject before report
#DEFINE M_EJAFT        16        // page eject after report
#DEFINE M_EJMAJOR      17        // page eject on new major group
#DEFINE M_EJMINOR      18        // page eject on new minor group
#DEFINE M_EJGRAND      19        // page eject before grand totals page
#DEFINE M_UNTOTAL      20        // underline totals ? Y/N
#DEFINE M_MAJCHR       21        // major totals underline character
#DEFINE M_MINCHR       22        // minor totals underline character
#DEFINE M_NHEAD        23        // number of header lines (1-9)
#DEFINE M_NFOOT        24        // number of footer lines (1-9)
#DEFINE M_NTITL        25        // number of title lines (1 or 2)
#DEFINE M_TSEP         26        // character for title seperator line
#DEFINE M_COLSEP       27        // character for column seperator line
#DEFINE M_CSEPWID      28        // width of column seperator
#DEFINE M_LINESEP      29        // detail line seperator character
#DEFINE M_NCOLS        30        // number of report columns defined
#DEFINE M_STDHEAD      33        // use standard 2 line header (page#, date, time)
#DEFINE M_QUERY        35        // last used query filter
#DEFINE M_FULLSUM      36        // full or sumary only report
#DEFINE M_PRNCODE      37        // printer code for before report
#DEFINE M_AFTCODE      38        // printer code for after report

//-------------------------------------------------------------------
//--various EXTERNAL functions that may be needed (mostly SuperLib functions)
EXTERNAL Stuff, Ljust, Rjust, allbut, subplus, startsw, Stod, crunch, strtran
EXTERNAL centr, proper, doyear, womonth, woyear, trueval, dtow
EXTERNAL endswith, dtdiff, daysin, datecalc, begend, nozdiv, stretch, arrange
//-------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SFRR_HCODE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SFRR_HCODE() Output report definition to .PRG code
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SFRR_HCODE()
ณ 
ณ  Description:
ณ  ------------
ณ  SFRR_HCODE will present you with a menu-driven
ณ  interface to allow selection of output options for a hard-coded
ณ  .PRG file for a given saved report.
ณ 
ณ  You will be presented options for :
ณ     SOURCE Report Definition and
ณ     OUTPUT .PRG file name (you choose)
ณ 
ณ  Once these are selected, you may do a translation
ณ  into .PRG code. The .PRG will do all of the setup needed to call
ณ  SFRR_PMAIN() - the main print routine called by both REPORT()
ณ  and QUICKREPORT().
ณ 
ณ  The .PRG will no longer require the SFREPORT.DBF in
ณ  order to produce the report.
ณ 
ณ  This has been written as a function, so you may
ณ  incorporate it easily.
ณ 
ณ  To produce a stand-alone .EXE to generate report
ณ  .PRGs, you could do the following:
ณ 
ณ     initsup()
ณ 
ณ     USE SFREPORT
ณ 
ณ     sfrr_hcode()
ณ 
ณ  The resulting .PRGs must be called with DO <prgname>
ณ  If you like, you could make them into a function by issuing a
ณ  by issuing a FUNCTION <function name> at the top.
ณ 
ณ 
ณ  Examples:
ณ  ---------
ณ   initsup()
ณ   USE SFREPORT
ณ   sfrr_hcode()
ณ 
ณ  Source:
ณ  -------
ณ  R_HCODE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION sfrr_hcode

LOCAL cInscreen     := savescreen(0,0,24,79)   // save screen
local nOldArea      := select(0)               // save work area
local cReportDesc   := ""                      // var for report description
local cPrgName      := space(50)               // variabl for out .prg name
local cReportFile   := slsf_report()           // get report file name
                                               // from slsf_report()
local cOldColor                                // var to hold prior color
local nChoice                                  // var to hold selection #
local cShowBox                                 // variable to hold makebox()
                                               // screen

if !file(cReportFile+".DBF")                  // if no report file, exit
	MSG("No Report file present")
	return ''
endif

if !SNET_USE(cReportFile,"__REPORTS",;       // if unable to open report file
        .F.,5,.T.,"Network error opening REPORT file. Keep trying?")
   select (nOldArea)                        // select in work area
   return ''                                // hit the road, jack
endif

*-- draw screen
cOldColor           := setcolor(sls_normcol())   // store and set the color
                                                 // to sls_normcol()
@0,0,24,79 BOX sls_frame()                       // draw a box around the
                                                 // screen using default
                                                 // frame values in sls_frame()
Setcolor(sls_popcol())                           // set the color to sls_popcol()
@1,1,09,50 BOX sls_frame()                       // draw a box for the menu
@1,5 SAY '[Report to PRG Translator]'            // draw the title
@20,1,23,78 BOX sls_frame()                      // draw a box for info
@21,2 say "Using source report   :"              // write to info box
@22,2 say "Writing as (*.PRG)    :"              // write to info box

//-- defines for menu selections
#define CHOICE_REPORT       1
#define CHOICE_OUTPRG       2
#define CHOICE_TRANSLATE    3
#define CHOICE_LIST         4
#define CHOICE_QUIT         5

//-- Main Loop of this function
do while .t.
  @21,27 say cReportDesc                         // update info box with
  @22,27 say cPrgName                            // report description and
                                                 // out .prg name
  Setcolor(sls_popmenu())                        // set color back to
                                                 // sls_popmenu()

  //-- do a menu using rat_menu2()
  nChoice := RAT_MENU2({;
                {02,3 ,"Select Report Definition"},;
                {03,3 ,"Name of .prg file"},;
                {04,3 ,"Do translation"},;
                {05,3 ,"List .prg file"},;
                {06,3 ,"Quit"}},nChoice)


  do case
  case nChoice = CHOICE_REPORT  // select source report
     smalls( ;
        {||[Title->]+__reports->sf_title+[  Using DBF->]+__reports->sf_dbf} )
     if Lastkey()=K_ENTER
       cReportDesc :=__reports->sf_title
     endif

  case nChoice = CHOICE_OUTPRG  // output prg name
     POPREAD(.F.,"PRG file to translate report to:",@cPrgName,"@S35")

  case nChoice = CHOICE_TRANSLATE  .and. ;
        !empty(cPrgName) .and. !empty(cReportDesc)
     cShowBox := makebox(5,5,20,75)    // make a box for translation display
     TRANSLATE(cPrgName)               // do translation
     unbox(cShowbox)                   // close the box

  case nChoice = CHOICE_LIST  .and. !empty(cPrgName) .and. file(cPrgName)
     fileread(1,1,23,78,cPrgName)      // list the file

  case nChoice = CHOICE_QUIT
     setcolor(cOldColor)              // restore in color
     restscreen(0,0,24,79,cInScreen)  // restore in screen
     USE                              // close reports dbf
     select (nOldArea)                // select previous work area
     exit                             // "..return to sender..."
  endcase
enddo
return ''


//-- this is the actual translation procedure

static PROC TRANSLATE(cPrgName)

local nPrgHandle := fcreate(alltrim(cPrgName),0)     // create the .PRG
local lUseQuery                                      // variable for
                                                     // use stored query?

//-- note: fwriteline() simply FWRITE()'s the string passed
//-- allong with a chr(13)+chr(10)

//-- write the header info
fwriteline(nPrgHandle,"// assumes DBF/Indexes open")
fwriteline(nPrgHandle,"// link with SUPER.LIB or SUPER5.LIB")
fwriteline(nPrgHandle,"// call with DO "+upper(cPrgName)+"  ")
fwriteline(nPrgHandle,"")

//-- write the declarations
fwriteline(nPrgHandle,"//---- here we write the declares ")
writedecl(nPrgHandle)

//-- write the initializations
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the inits")
writeinit(nPrgHandle)

//-- write the header initializations
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the header inits")
writehead(nPrgHandle)


//-- write the footer initializations
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the footer inits")
writefoot(nPrgHandle)


//-- write the column initializations
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the column inits")
writecolumns(nPrgHandle)


//-- determine if we will use the query
if empty(__reports->sf_query)
   luseQuery := .f.
else
   if messyn("Use stored query? ")
     lUseQuery := .t.
   else
     lUseQuery := .f.
   endif
endif

//-- call the print engine RPRINTREP()  (in R_PRINTR.PRG)
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---and finally, a call to the print engine...")
fwriteline(nPrgHAndle,;
 "rPrintRep({aValues,aHeader,aFooter,aColumns,aTitles,aWidths,aTotalYN,aPictures},"+logc(lUseQuery)+")" )
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---end---")

//- wrap it up
fclose(nPrgHandle)
msg("Done!")
return


//-- write the defines, declares etc
//----------------------------------------------------------------------
STATIC PROC WRITEDECL(nHandle)

fwriteline(nHandle,[#DEFINE M_DBF           1      // dbf name                                      ])
fwriteline(nHandle,[#DEFINE M_TITLE         2      // report title (name)                           ])
fwriteline(nHandle,[#DEFINE M_NDXKEY        3      // index key                                     ])
fwriteline(nHandle,[#DEFINE M_MAJKEY        4      // major group portion of index key              ])
fwriteline(nHandle,[#DEFINE M_MINKEY        5      // minor group portion of index key              ])
fwriteline(nHandle,[#DEFINE M_MAJTEXT       6      // major group header text                       ])
fwriteline(nHandle,[#DEFINE M_MINTEXT       7      // minor group header text                       ])
fwriteline(nHandle,[#DEFINE M_WIDTH         8      // page width in characters                      ])
fwriteline(nHandle,[#DEFINE M_LENGTH        9      // page length in lines                          ])
fwriteline(nHandle,[#DEFINE M_LEFTM        10      // left margin in columns (#blank columns)       ])
fwriteline(nHandle,[#DEFINE M_TOPM         11      // top margin in rows (#blank rows)              ])
fwriteline(nHandle,[#DEFINE M_SPACE        12      // line spacing 0 = single, 1 = double           ])
fwriteline(nHandle,[#DEFINE M_PAUSE        13      // pause between pages ? Y/N                     ])
fwriteline(nHandle,[#DEFINE M_NPLINES      14      // page eject if (n) lines left on group change  ])
fwriteline(nHandle,[#DEFINE M_EJB4         15      // page eject before report                      ])
fwriteline(nHandle,[#DEFINE M_EJAFT        16      // page eject after report                       ])
fwriteline(nHandle,[#DEFINE M_EJMAJOR      17      // page eject on new major group                 ])
fwriteline(nHandle,[#DEFINE M_EJMINOR      18      // page eject on new minor group                 ])
fwriteline(nHandle,[#DEFINE M_EJGRAND      19      // page eject before grand totals page           ])
fwriteline(nHandle,[#DEFINE M_UNTOTAL      20      // underline totals ? Y/N                        ])
fwriteline(nHandle,[#DEFINE M_MAJCHR       21      // major totals underline character              ])
fwriteline(nHandle,[#DEFINE M_MINCHR       22      // minor totals underline character              ])
fwriteline(nHandle,[#DEFINE M_NHEAD        23      // number of header lines (1-9)                  ])
fwriteline(nHandle,[#DEFINE M_NFOOT        24      // number of footer lines (1-9)                  ])
fwriteline(nHandle,[#DEFINE M_NTITL        25      // number of title lines (1 or 2)                ])
fwriteline(nHandle,[#DEFINE M_TSEP         26      // character for title seperator line            ])
fwriteline(nHandle,[#DEFINE M_COLSEP       27      // character for column seperator line           ])
fwriteline(nHandle,[#DEFINE M_CSEPWID      28      // width of column seperator                     ])
fwriteline(nHandle,[#DEFINE M_LINESEP      29      // detail line seperator character               ])
fwriteline(nHandle,[#DEFINE M_NCOLS        30      // number of report columns defined              ])
fwriteline(nHandle,[#DEFINE M_STDHEAD      33      // use standard 2 line header (page#, date, time)])
fwriteline(nHandle,[#DEFINE M_QUERY        35      // last used query filter                        ])
fwriteline(nHandle,[#DEFINE M_FULLSUM      36      // full or sumary only report                    ])
fwriteline(nHandle,[#DEFINE M_PRNCODE      37      // printer code for before report                ])
fwriteline(nHandle,[#DEFINE M_AFTCODE      38      // printer code for after report                 ])
fwriteline(nHandle,[])
fwriteline(nHandle,[//-------------------------------------------------------------------])
fwriteline(nHandle,[EXTERNAL Stuff, Ljust, Rjust, allbut, subplus, startsw, Stod, crunch, strtran])
fwriteline(nHandle,[EXTERNAL centr, proper, doyear, womonth, woyear, trueval, dtow])
fwriteline(nHandle,[EXTERNAL endswith, dtdiff, daysin, datecalc, begend, nozdiv, stretch, arrange])
fwriteline(nHandle,[//-------------------------------------------------------------------])
fwriteline(nHandle,[])
fwriteline(nHandle,[local cBuffer,i])
fwriteline(nHandle,"LOCAL aValues[38]")
fwriteline(nHandle,"")
fwriteline(nHandle,"LOCAL aHeader := array("+trans(__reports->sf_nhead,"9")+")" )
fwriteline(nHandle,"LOCAL aFooter := array("+trans(__reports->sf_nfoot,"9")+")")
fwriteline(nHandle,"")
fwriteline(nHandle,"*- column descriptions")
fwriteline(nHandle,"LOCAL aColumns := array("+trans(__reports->sf_ncols,"99")+")")
fwriteline(nHandle,"LOCAL aTitles  := array("+trans(__reports->sf_ncols,"99")+")" )
fwriteline(nHandle,"LOCAL aWidths  := array("+trans(__reports->sf_ncols,"99")+")")
fwriteline(nHandle,"LOCAL aTotalYN := array("+trans(__reports->sf_ncols,"99")+")")
fwriteline(nHandle,"LOCAL aPictures := array("+trans(__reports->sf_ncols,"99")+")")
return

//- write the variable assigns
//----------------------------------------------------------
STATIC PROC WRITEINIT(nHandle)
fwriteline(nHandle,[// Here are the report layout and other values-----------------------])
fwriteline(nHandle,[])
fwriteline(nHandle,"aValues[M_TITLE]    := ["+__reports->sf_title+"]")
fwriteline(nHandle,"aValues[M_NDXKEY]   := ["+trim(__reports->sf_ndxkey)+"]")
fwriteline(nHandle,"aValues[M_MAJKEY]   := ["+trim(__reports->sf_majkey)+"]")
fwriteline(nHandle,"aValues[M_MINKEY]   := ["+trim(__reports->sf_minkey)+"]")
fwriteline(nHandle,"aValues[M_WIDTH]    := "+trans(__reports->sf_width,'999'))
fwriteline(nHandle,"aValues[M_LENGTH]   := "+trans(__reports->sf_length,'999'))
fwriteline(nHandle,"aValues[M_LEFTM]    := "+trans(__reports->sf_leftm,'99'))
fwriteline(nHandle,"aValues[M_TOPM]     := "+trans(__reports->sf_topm,'99'))
fwriteline(nHandle,"aValues[M_SPACE]    := "+trans(__reports->sf_space,'9'))
fwriteline(nHandle,"aValues[M_PAUSE]    := "+logc(__reports->sf_pause))
fwriteline(nHandle,"aValues[M_EJB4]     := "+logc(__reports->sf_ejb4))
fwriteline(nHandle,"aValues[M_EJAFT]    := "+logc(__reports->sf_ejaft))
fwriteline(nHandle,"aValues[M_EJMAJOR]  := "+logc(__reports->sf_ejmajor))
fwriteline(nHandle,"aValues[M_EJMINOR]  := "+logc(__reports->sf_ejminor))
fwriteline(nHandle,"aValues[M_EJGRAND]  := "+logc(__reports->sf_ejgrand))
fwriteline(nHandle,"aValues[M_NHEAD]    := "+trans(__reports->sf_nhead,'9'))
fwriteline(nHandle,"aValues[M_NFOOT]    := "+trans(__reports->sf_nfoot,'9'))
fwriteline(nHandle,"aValues[M_NTITL]    := "+trans(__reports->sf_ntitl,'9'))
fwriteline(nHandle,"aValues[M_TSEP]     := ["+__reports->sf_tsep+"]")
fwriteline(nHandle,"aValues[M_COLSEP]   := ["+__reports->sf_colsep+"]")
fwriteline(nHandle,"aValues[M_CSEPWID]  := "+trans(__reports->sf_csepwid,'9'))
fwriteline(nHandle,"aValues[M_LINESEP]  := ["+__reports->sf_linesep+"]")
fwriteline(nHandle,"aValues[M_NCOLS]    := "+trans(__reports->sf_ncols,'99'))
fwriteline(nHandle,"aValues[M_STDHEAD]  := "+logc(__reports->sf_stdhead))
fwriteline(nHandle,"aValues[M_MAJTEXT]  := ["+__reports->sf_majtext+"]")
fwriteline(nHandle,"aValues[M_MINTEXT]  := ["+__reports->sf_mintext+"]")
fwriteline(nHandle,"aValues[M_NPLINES]  := "+trans(__reports->sf_nplines,'9'))
fwriteline(nHandle,"aValues[M_UNTOTAL]  := "+logc(__reports->sf_untotal))
fwriteline(nHandle,"aValues[M_MAJCHR]   := ["+__reports->sf_majchr+"]")
fwriteline(nHandle,"aValues[M_MINCHR]   := ["+__reports->sf_minchr+"]")
fwriteline(nHandle,"aValues[M_FULLSUM]  := ["+__reports->sf_fullsum+"]")
fwriteline(nHandle,"aValues[M_PRNCODE]  := ["+__reports->sf_prncode+"]")
fwriteline(nHandle,"aValues[M_AFTCODE]  := ["+__reports->sf_aftcode+"]")
fwriteline(nHandle,"aValues[M_QUERY]    := ["+__reports->sf_query+"]")
return


//-- write the header values
//---------------------------------------------------------------
STATIC PROC writehead(nHandle)
local i,cBuffer
cBuffer = __reports->sf_heads           // sf_heads stores the headers
                                        // as a memo
for i = 1 TO __reports->sf_nhead        // sf_nhead stores # of header lines
  fwriteline(nHandle,"aHeader["+alltrim(trans(i,"99"))+"] := ["+ ;
             hunsquish(Takeout(cBuffer,"þ",i))+"]" )
             //- hunsquish() retrieves the data from compressed format
             //- each header is delimited by "þ" chr(254), and takeout()
             //- is used to extract each header
next
return

//- write the footer values
//---------------------------------------------------------------
STATIC PROC WRITEFOOT(nHandle)
local i,cBuffer
cBuffer = __reports->sf_feet            // sf_feet stores the footers as a
                                        // memo
for i = 1 TO __reports->sf_nfoot        // sf_nfoot stores # of footer lines
  fwriteline(nHandle,"aFooter["+alltrim(trans(i,"99"))+"] := ["+ ;
             hunsquish(Takeout(cBuffer,"þ",i))+"]" )
             //- hunsquish() retrieves the data from compressed format
             //- each footer is delimited by "þ" chr(254), and takeout()
             //- is used to extract each footer
next
return


//- write the column information
//---------------------------------------------------------------
STATIC PROC WRITECOLUMNS(nHandle)
local cBuffer,i
*- column descriptions
for i = 1 TO __reports->sf_ncols        // sf_ncols stores the # of
                                        // detail columns
  cBuffer      := TRIM(MEMOLINE(__reports->sf_details,150,i))
                                        // each detail column is stored
                                        // as a CRLF delimited line
                                        // in sf_details. So get the
                                        // next column definition

                                        // the column definition has
                                        // 5 parts, delimited by
                                        // chr(254) "þ", which takeout
                                        // is used to extract one at a
                                        // time
  fwriteline(nHandle,"aColumns["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",1)+"]" )
                                       // this gets the actual expression

  fwriteline(nHandle,"aTitles["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",2)+"]" )
                                      // this gets the column title

  fwriteline(nHandle,"aWidths["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",3)+"]" )
                                     // this gets the column width

  fwriteline(nHandle,"aTotalYN["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",4)+"]" )
                                    // this gets the Total Y/N setting

  fwriteline(nHandle,"aPictures["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",5)+"]" )
                                   // this gets the column picture

NEXT
RETURN

//-- this proc writes a line to a file with a chr(13)+chr(10) attached
//-- it also displays the output in the translation window, and scrolls
//-- the window up one line
//---------------------------------------------------------------
STATIC PROC FWRITELINE(nHandle,c)
fwrite(nHandle,c+chr(13)+chr(10) )
scroll(6,6,19,74,1)
@19,6 say left(c,68)
return

//-- return a logical as a string
//---------------------------------------------------------------
static function logc(lVal)
return iif(lVal,".t.",".f.")


//-- unsquish a string which has been squished with a simple
//-- algorithm to reduce redundant spaces
//------------------------------------------------------------------
STATIC FUNCTION hunsquish(cInstring)
cInstring = Strtran(cInstring,CHR(01),SPACE(80) )
cInstring = Strtran(cInstring,CHR(02),SPACE(70) )
cInstring = Strtran(cInstring,CHR(03),SPACE(60) )
cInstring = Strtran(cInstring,CHR(04),SPACE(50) )
cInstring = Strtran(cInstring,CHR(05),SPACE(40) )
cInstring = Strtran(cInstring,CHR(06),SPACE(30) )
cInstring = Strtran(cInstring,CHR(07),SPACE(20) )
cInstring = Strtran(cInstring,CHR(08),SPACE(10) )
cInstring = Strtran(cInstring,CHR(09),SPACE(05) )
cInstring = Strtran(cInstring,CHR(10),SPACE(02) )
RETURN cInstring


