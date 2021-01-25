//----------------------------------------------------------------------
#DEFINE M_DBF           1         // dbf name
#DEFINE M_TITLE         2         // report title (name)
#DEFINE M_NDXKEY        3         // index key
#DEFINE M_MAJKEY        4         // major group portion of index key
#DEFINE M_MINKEY        5         // minor group portion of index key
#DEFINE M_MAJTEXT       6         // major group header text
#DEFINE M_MINTEXT       7         // minor group header text
#DEFINE M_WIDTH         8         // page width in characters
#DEFINE M_LENGTH        9         // page length in lines
#DEFINE M_LEFTM        10         // left margin in columns (#blank columns)
#DEFINE M_TOPM         11         // top margin in rows (#blank rows)
#DEFINE M_SPACE        12         // line spacing 0 = single, 1 = double
#DEFINE M_PAUSE        13         // pause between pages ? Y/N
#DEFINE M_NPLINES      14         // page eject if (n) lines left on group change
#DEFINE M_EJB4         15         // page eject before report
#DEFINE M_EJAFT        16         // page eject after report
#DEFINE M_EJMAJOR      17         // page eject on new major group
#DEFINE M_EJMINOR      18         // page eject on new minor group
#DEFINE M_EJGRAND      19         // page eject before grand totals page
#DEFINE M_UNTOTAL      20         // underline totals ? Y/N
#DEFINE M_MAJCHR       21         // major totals underline character
#DEFINE M_MINCHR       22         // minor totals underline character
#DEFINE M_NHEAD        23         // number of header lines (1-9)
#DEFINE M_NFOOT        24         // number of footer lines (1-9)
#DEFINE M_NTITL        25         // number of title lines (1 or 2)
#DEFINE M_TSEP         26         // character for title seperator line
#DEFINE M_COLSEP       27         // character for column seperator line
#DEFINE M_CSEPWID      28         // width of column seperator
#DEFINE M_LINESEP      29         // detail line seperator character
#DEFINE M_NCOLS        30         // number of report columns defined
#DEFINE M_STDHEAD      33         // use standard 2 line header (page#, date, time)
#DEFINE M_QUERY        35         // last used query filter
#DEFINE M_FULLSUM      36         // full or sumary only report
#DEFINE M_PRNCODE      37         // printer code for before report
#DEFINE M_AFTCODE      38         // printer code for after report

#DEFINE Q_NOFILTER     1
#DEFINE Q_TAG          2
#DEFINE Q_BUILD        3
#DEFINE Q_USELAST      4

//-------------------------------------------------------------------
EXTERNAL Stuff, Ljust, Rjust, allbut, subplus, startsw, Stod, crunch, strtran
EXTERNAL centr, proper, doyear, womonth, woyear, trueval, dtow
EXTERNAL endswith, dtdiff, daysin, datecalc, begend, nozdiv, stretch, arrange
//-------------------------------------------------------------------

static aDbfFields     // array of fields/expressions
static aDbfTypes      // array of types of aDbfFields
static aDbfLens       // array of lengths of aDbfFields

static aNdxKeys       // array of index keys

static aValues        // this array holds various report elements
                      // like page width, page length etc. that
                      // relate to the report as a whole

static  aHeader       // this array holds the page header(s)
static  aFooter       // this array holds the page footer(s)

static  aColumns      // this array holds column expressions
static  aTitles       // .................column titles
static  aWidths       // .................column widths
static  aTotalYN      // .................column total y/n settings
static  aPictures     // .................column pictures



/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION QUIKREPORT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  QUIKREPORT() Runtime pre-defined report printing module
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  QUIKREPORT([cReportName])
ณ 
ณ  Description:
ณ  ------------
ณ  Presents a picklist of pre-defined reports and prints
ณ  the selected one.
ณ 
ณ  [cReportName] name of the report to run - picklist is
ณ  bypassed. For batches.
ณ 
ณ  Examples:
ณ  ---------
ณ   QUIKREPORT('Quarterly Hog Count')
ณ 
ณ  Warnings:
ณ  ----------
ณ  Requires DBF and indexes to be open
ณ 
ณ  Source:
ณ  -------
ณ  R_QUIKR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION QUIKREPORT(cReportName)

local   cReportFile := slsf_report()     // name of SuperLib reports file
local   aTagged     := {}                // holds tagged records
local   nChoice,;                        // number of selection
        nOldArea,;                       // incoming work area
        cInScreen,;                      // holds prior screen
        cOldCOlor,;                      // holds prior color
        nOldOrder,;                      // holds current index order
        lUseTag,;                        // print tagged records?
        lUseQuery,;                      // print query matches?
        i, ;                             // loop variable
        aChoices                         // array of choices

//- initialize these global arrays
aValues         := array(38)
aHeader         := array(9)
aFooter         := array(9)
aColumns        := array(34)
aTitles         := array(34)
aWidths         := array(34)
aTotalYN        := array(34)
aPictures       := array(34)

aNdxKeys        := array(15)


// must have the report file available, and a dbf open
if !file(cReportFile+".DBF")
    MSG("No Report file present")
    return ''
elseif!used()
    MSG("No DBF open")
    return ""
endif

// load index keys for current dbf
for i = 1 to 15
    aNdxKeys[i] = indexkey(i)
next

// save current work area, index order
nOldArea  := select()
nOldOrder := indexord(0)

// save current color and screen
cOldCOlor := setcolor(sls_popcol())
cInScreen := savescreen(0,0,24,79)


// open reports datafile
SELECT 0
if !SNET_USE(cReportFile,"__REPORTS",.F.,5,.T.,"Network error opening REPORT file. Keep trying?")
  // if no go, return (quit)
  select (nOldArea)
  return ''
ENDIF


// draw the quick report interaction box
makebox(21,0,24,79,setcolor(),0,0)
@21,2 say "[QuikReport]"

// select the original work area
SELECT (nOldArea)

// load a report, may be based on passed param cReportName
// (qloadreport loads values into the global report definition
// arrays
qloadreport(cReportName)

// close the reports file - no longer needed
select __REPORTS
use

// select original work area
select (nOldArea)

// check for a report being loaded - the report title is not blank
if aValues[M_TITLE]  <>nil
   // fill an array with choices for rat_menu2()
   aChoices := {;
            {22,2  ,"No Filter "},;
            {23,2  ,"Tag Selected Records"},;
            {22,35 ,"Build New Query Filter"}}

   // if there is a stored query, offer it as a choice too
   IF !EMPTY(aValues[M_QUERY])
     aadd(aChoices,{23,35 ,"Use last Query Filter"})
   ENDIF

   // get the selection
   nChoice := RAT_MENU2(aChoices)

   // clear the q&a area
   SCROLL(22,1,23,78,0)

   // set these values to false as default
   lUseTag   := .F.
   lUseQuery := .F.

   IF nChoice == Q_TAG
     Tagit(aTagged)                    // tag some records
     lUseTag := (LEN(aTagged) > 0)     // set use tag flag to true only if
                                       // some records were tagged
   ELSEIF nChoice == Q_BUILD
     QUERY("","","","To Reporter")     // build a query
     aValues[M_QUERY] := sls_query()
     lUseQuery := !empty(sls_query())  // set use query flag to true only
                                       // if a query was built
   ELSEIF nChoice == Q_USELAST
     lUseQuery := .t.                  // set use query flag to true
   ENDIF


   if nChoice > 0                      // some choice was made
     @22,2 say "Print now?"
     nChoice := RAT_MENU2({;
            { 23,2,"Yes"},;
            { 23,10, "No"}})
     SCROLL(22,1,23,78,0)            // clear the q&a area
     if nChoice = 1                  // YES
         // call RPRINTREP() to print the report
         rPrintRep({aValues,aHeader,aFooter,aColumns,aTitles,aWidths,aTotalYN,;
                    aPictures},lUseQuery,lUseTag,aTagged)
     endif
   endif
endif

unbox(cInScreen,0,0,24,79)              // restore the screen,
setcolor(cOldCOlor)                     // the color, and the
set order to (nOldOrder)                // index order

// set these statics to NIL
aDbfFields:=aDbfTypes:=aDbfLens:=aValues:=nil
aHeader:=aFooter:=aColumns:=aTitles:=aWidths:=nil
aTotalYN:=aPictures:=aNdxKeys:=nil
return ''


//-------------------------------------------------------------------------
static FUNCTION qloadreport(cReportName)

local   nCountMatch,;      // number of matching reports stored
        nRepChosen,;       // the number of the report the user chose
        cBuffer,;          // holds dbf string values temporarily
        nMatches,;         // used to increment and fill array with matches
        nIndexOrd,;        // old index order
        nOldArea,;         // old work area
        cDbfNAme,;         // dbf name
        aRepTitles,;       // array of report titles to choose from
        aMatchRec,;        // an array of record #'s to match aRepTitles
        i,;                // a loop variable
        cStoredKey,;       // the index key stored in the report
        nFoundkey          // number of the current indexes open that matches
                           // cStoredKey

// save alias, work area and index order
cDbfNAme     := alias()
nOldArea     := select()
nIndexOrd    := indexord()

// set these global arrays to empty
aHeader:= {}
aFooter:= {}
aColumns:={}
aTitles:={}
aWidths:={}
aTotalYN:={}
aPictures:={}

// select the reports dbf
SELECT __REPORTS
IF cReportName#nil
   // if a report name was passed, ensure it can be found
   // and that it matches the current dbf and it is not
   // deleted
   LOCATE FOR STARTSW(__reports->sf_title,cReportName) .AND. ;
            (__reports->sf_dbf=cDbfName) .and. !deleted()
   IF EOF()
     Msg("No reports found matching:",cReportName)
   ENDIF
ELSE
   // if no report name passed, ensure that there are some reports
   // which match this dbf which are not deleted
   LOCATE FOR __reports->sf_dbf=cDbfName .and. !deleted()
   IF EOF()
     Msg("No reports found matching "+cDbfName)
   ENDIF
ENDIF

DO WHILE !EOF()     // if EOF(), don't do at all

  // blank these global values
  aValues[M_NDXKEY] = ""
  aValues[M_MAJKEY] = ""
  aValues[M_MINKEY] = ""


  // if we don't already have a report name, have the user (if they would
  // be so kind) select a report to use...
  IF cReportName==nil

     // count the matching reports that are not deleted
     COUNT FOR __reports->sf_dbf=cDbfName .and. !deleted() TO nCountMatch

     // size the arrays for report names and matching record numbers
     // according to the count
     aMatchRec  := array(nCountMatch)
     aRepTitles := array(nCountMatch)

     GO TOP
     nMatches   := 0

     // issue the locate
     LOCATE FOR __reports->sf_dbf=cDbfNAme .and. !deleted()
     DO WHILE !EOF()
       // while found(), increment nMAtches, assign the recno() to
       // aMatchRec and the report title to aRepTitles
       nMatches++
       aMatchRec[nMatches]  := RECNO()
       aRepTitles[nMatches] := __reports->sf_title

       // then issue a continue, to find the next matching report
       CONTINUE
     ENDDO


     nRepChosen  := Mchoice(aRepTitles,10,20,20,70,"Stored Reports")
     IF nRepChosen  = 0     // no choice, no report
       EXIT                // this takes us right out of the loop
                           // (kinda makes you government guys feel
                           // at home, right?)
     ENDIF

     // go to the corresponding record in the reports dbf
     GO (aMatchRec[nRepChosen])

  endif

  // grab the stored index key from the reports dbf
  cStoredKey  := trim(__reports->sf_NdxKey)

  // if the key isn't empty, see if we can find it among the
  // indexes currently loaded
  if !empty(cStoredKey)
    // scan the currently loaded index keys for amatch
    nFoundKey  := ascan(aNdxKeys,cStoredKey)

    if nFoundKey > 0
        // if found, go ahead and store it in aValues, as well
        // as any major key and minor key saved in the report
        nIndexOrd := nFoundKey
        aValues[M_NDXKEY] := cStoredKey
        aValues[M_MAJKEY] = trim(__reports->sf_majkey)
        aValues[M_MINKEY] = trim(__reports->sf_minkey)

        // let the user know what we're doing
        msg("Using index key =>"+aValues[M_NDXKEY])

        // set the index order to whatever the matching current
        // key is
        set order to (nFoundKey)
    else
        // no index match found, ask the user if they wish to
        // proceed anyways...
        if multimsgyn({"The index stored with the report with the key:",;
                       padc(cStoredKey,40),;
                      "does not appear to be loaded now",;
                      "Continue with the report without the index?"})
                aValues[M_NDXKEY] := ""
                aValues[M_MAJKEY] := ""
                aValues[M_MINKEY] := ""
        else
                exit             // out of the big loop
        endif
    endif
  endif

  // if we made it this far, go ahead and load up the values
  // from the stored report
  aValues[M_TITLE]  := __reports->sf_title
  aValues[M_WIDTH]  := __reports->sf_width
  aValues[M_LENGTH] := __reports->sf_length
  aValues[M_LEFTM]  := __reports->sf_leftm
  aValues[M_TOPM]   := __reports->sf_topm
  aValues[M_SPACE]  := __reports->sf_space
  aValues[M_PAUSE]  := __reports->sf_pause
  aValues[M_EJB4]   := __reports->sf_ejb4
  aValues[M_EJAFT]  := __reports->sf_ejaft
  aValues[M_EJMAJOR]:= __reports->sf_ejmajor
  aValues[M_EJMINOR]:= __reports->sf_ejminor
  aValues[M_EJGRAND]:= __reports->sf_ejgrand
  aValues[M_NHEAD]  := __reports->sf_nhead
  aValues[M_NFOOT]  := __reports->sf_nfoot
  aValues[M_NTITL]  := __reports->sf_ntitl
  aValues[M_TSEP]   := __reports->sf_tsep
  aValues[M_COLSEP] := __reports->sf_colsep
  aValues[M_CSEPWID]:= __reports->sf_csepwid
  aValues[M_LINESEP] := __reports->sf_linesep
  aValues[M_NCOLS]  := __reports->sf_ncols
  aValues[M_STDHEAD] := __reports->sf_stdhead
  aValues[M_MAJTEXT] := __reports->sf_majtext
  aValues[M_MINTEXT] := __reports->sf_mintext
  aValues[M_NPLINES] := __reports->sf_nplines
  aValues[M_UNTOTAL] := __reports->sf_untotal
  aValues[M_MAJCHR] := __reports->sf_majchr
  aValues[M_MINCHR] := __reports->sf_minchr
  aValues[M_FULLSUM] := __reports->sf_fullsum
  aValues[M_PRNCODE] := __reports->sf_prncode
  aValues[M_AFTCODE] := __reports->sf_aftcode
  aValues[M_QUERY] := __reports->sf_query

  // load the store header values
  //- qunsquish() retrieves the data from compressed format
  //- each header is delimited by "þ" chr(254), and takeout()
  //- is used to extract each header
  cBuffer := __reports->sf_heads
  for i = 1 TO aValues[M_NHEAD]
    aadd(aHeader,qunsquish(Takeout(cBuffer,"þ",i)) )
  NEXT (I)

  //- load the stored footer values
  //- qunsquish() retrieves the data from compressed format
  //- each footer is delimited by "þ" chr(254), and takeout()
  //- is used to extract each footer
  cBuffer = __reports->sf_feet
  for i = 1 TO aValues[M_NFOOT]
    aadd(aFooter,qunsquish(Takeout(cBuffer,"þ",i)) )
  NEXT (I)

  // aValues[M_NCOLS] stores the # of detail columns
  // each detail column is stored  as a CRLF delimited line
  // in sf_details.
  // Each column definition has 5 parts, delimited by
  // chr(254) "þ", which takeout is used to extract one at a
  // time

  for i = 1 TO aValues[M_NCOLS]
    cBuffer     := TRIM(MEMOLINE(__reports->sf_details,150,i))
    aadd(aColumns,Takeout(cBuffer,"þ",1))
    aadd(aTitles,Takeout(cBuffer,"þ",2))
    aadd(aWidths, Takeout(cBuffer,"þ",3))
    aadd(aTotalYN,Takeout(cBuffer,"þ",4))
    aadd(aPictures,Takeout(cBuffer,"þ",5))
  NEXT
  EXIT
ENDDO

SELECT (nOldArea)                // back to the old area
set order to nIndexOrd           // back to the prior index order
RETURN ''



//-- unsquish a string which has been squished with a simple
//-- algorithm to reduce redundant spaces
STATIC FUNCTION qunsquish(cInstring)
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


