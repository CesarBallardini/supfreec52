#include "inkey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
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

#DEFINE CRLF            CHR(13)+CHR(10)

//-------------------------------------------------------------------
memvar getlist        // lets the compiler know that getist is a memvar

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

static nElement       // this is for tBrowse element referal

EXTERNAL CRUNCH


//-------------------------------------------------------------------------
/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION REPORTER()
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
³ 
³  Short:
³  ------
³  REPORTER() Create, modify, execute reports
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  REPORTER([aFieldNames,aFieldTypes,aFieldLengths])
³ 
³  Description:
³  ------------
³  Build/modify reports based on fields in database.
³  Fields in database may be specified in arrays 1-3 which are
³  [aFieldNames] field names [aFieldTypes] field types and
³  [aFieldLengths] field lengths. All fields are used by default.
³ 
³  Reporter allows a MAJOR and MINOR group, using the
³  indexes currently available and open.
³ 
³  Examples:
³  ---------
³   example 1:
³ 
³   Use Customer
³   REPORTER()
³ 
³   example 2:
³   USE Customer
³   aFieldNames := {"fname","lname","mi"}
³   aFieldTypes := {"C","C","C"}
³   aFieldLens  := {15,35,1}
³   REPORTER(aFieldNames,aFieldTypes,aFieldLens)
³ 
³  Notes:
³  -------
³  Reporter() reports are stored in a DBF file. See the
³  index for file structures. See SLSF_REPORT() for further info on
³  the name and location of this file.
³ 
³  Upgrade note:
³  The look and feel have changed to one more uniform
³  with other SuperLib functions.
³ 
³  Source:
³  -------
³  R_REPORT.PRG
³ 
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
*/
FUNCTION REPORTER(aInFields,aInTypes,aInLens)
local aTagged   := {}
local lUseQuery := .f.
local lUseTag   := .f.
LOCAL nSelection,nSubChoice
LOCAL nOldArea,nReportArea
LOCAL lDone
LOCAL cInScreen,cOldColor,cBox,lReadExit,nOldOrder,lExact
LOCAL bOldF2,nOldCursor,i
LOCAL cMenuBox,cReport,cPrintBox
LOCAL nHead, nFeet
LOCAL aLoaded

LOCAL X

IF !USED()
  msg("No datafile in use")
  RETURN ""
ENDIF

//aDbfFields,aDbfTypes,aDbfLens,aValues
aHeader:= {}
aFooter:= {}
aColumns:={}
aTitles:={}
aWidths:={}
aTotalYN:={}
aPictures:={}
aNdxKeys := {}
nElement := 1



GO TOP
IF !( VALTYPE(aInFields)+VALTYPE(aInTypes)+VALTYPE(aInLens))=="AAA"
  aDbfFields := array(fcount())
  aDbfTypes  := array(fcount())
  aDbfLens   := array(fcount())
  aFields(aDbfFields,aDbfTypes,aDbfLens)
ELSE
  aDbfFields := aInFields
  aDbfTypes  := aIntypes
  aDbfLens   := aInLens
ENDIF
aValues := array(38)


*- save environment
nOldArea    := SELECT()
cInScreen   := savescreen(0,0,24,79)
lReadExit   := RATEXIT(.T.)
nOldOrder   := indexord()
lExact      := setexact(.t.)
nOldCursor  := setcursor(0)
cOldColor   := setcolor(sls_normcol())
bOldF2      := SETKEY(-1)
lDone       := .f.
*- load index keys
for i = 1 to 15
   if !empty(indexkey(i))
     aadd(aNdxKeys, indexkey(i) )
   endif
next

SELECT 0
IF !FILE(slsf_report()+".DBF")
     rMakeDbf()
ENDIF
if !SNET_USE(slsf_report(),"__REPORTS",.F.,5,.T.,"Network error opening REPORT file. Keep trying?")
   SELECT (nOldArea)
   RATEXIT(lReadExit)
   setexact(lExact)
   setcolor(cOldColor)
   SETKEY(-1,bOldF2)
   setcursor(nOldCursor)
   return ''
ENDIF
nReportArea := SELECT()
SELECT (nOldArea)


*- fill arrays and variables with default values
rLoadBlank()

*- draw screen
rDrawit()


aLoaded := {aclone(aValues),aclone(aHeader),aclone(aFooter),aclone(aColumns),aclone(aTitles),aclone(aWidths),aclone(aTotalYN),aclone(aPictures)}

*- take the plunge
DO WHILE !lDone
  SELECT (nOldArea)
  SETKEY( -1 )
  Setcolor(sls_popmenu())
  scroll(22,2,22,77,0)
  SETCURSOR(0)

  @22,2 SAY "REPORT :"+IIF(EMPTY(aValues[M_TITLE]),"None ",upper(aValues[M_TITLE]))
  @22,55 SAY "USING  "+ALIAS()+".DBF"

  nSelection := RAT_MENU2({;
                {2,3 ,'Load REPORT    '},;
                {3,3 ,'Create REPORT  '},;
                {4,3 ,'Save REPORT    '},;
                {5,3 ,'Edit Report    '},;
                {6,3 ,'Delete Reports '},;
                {07,3 ,'Headers/Footers'},;
                {08,3 ,'Filtering      '},;
                {09,3 ,'Grouping Order '},;
                {10,3 ,'Other Options  '},;
                {12,3 ,'Print Report   '},;
                {14,3 ,'Report Status  '},;
                {15,3 ,'Quit           '}},nSelection)

  SETCURSOR(1)

  DO CASE
  CASE nSelection == 1     // load report
    rLoadBlank()
    rLoadReport()
    aLoaded := {aclone(aValues),aclone(aHeader),aclone(aFooter),aclone(aColumns),aclone(aTitles),aclone(aWidths),aclone(aTotalYN),aclone(aPictures)}
  CASE nSelection == 2     // create report
    rLoadBlank()
    cReport     := aValues[M_TITLE]
    popread(.t.,"Report title",@cReport,"@K")
    aValues[M_TITLE] := cReport
    aLoaded := {aclone(aValues),aclone(aHeader),aclone(aFooter),aclone(aColumns),aclone(aTitles),aclone(aWidths),aclone(aTotalYN),aclone(aPictures)}
  CASE nSelection = 3  .and. (aValues[M_NCOLS]> 0)   // save report
    rSaveReport()
  CASE nSelection = 4  .AND. rLoaded()              // define columns
    rBrowseEdit()
  CASE nSelection = 5   && purge reports
    SELECT (nReportArea)
    if USED()
       PURGEM()
    endif
    SELECT (nOldArea)
  CASE nSelection = 6 .AND. rLoaded()  && headers and footers
    nHead := aValues[M_NHEAD]
    nFeet := aValues[M_NFOOT]
    popread(.t.,"Number of Header lines (1-9)   ",@nHead,"9",;
                "Number of Footer lines (1-9)   ",@nFeet,"9")
    aValues[M_NHEAD] := nHead
    aValues[M_NFOOT] := nFeet

    while len(aHeader) < aValues[M_NHEAD]
      aadd(aHeader,"")
    end
    while len(aFooter) < aValues[M_NFOOT]
      aadd(aFooter,"")
    end
    asize(aHeader,aValues[M_NHEAD])
    asize(aFooter,aValues[M_NFOOT])
    rHeadsFeet()
  CASE nSelection = 7 .AND. rLoaded()    && record selection
    cBox   := Makebox(13,25,18,52,sls_popcol())

    if empty(aValues[M_QUERY])
       nSubChoice := RAT_MENU2({;
                {14,28 ,"No Filter "},;
                {15,28 ,"Tag Selected Records"},;
                {16,28 ,"Build New Query Filter"}},nSubChoice)
    ELSE
       nSubChoice := RAT_MENU2({;
                {14,28 ,"No Filter "},;
                {15,28 ,"Tag Selected Records"},;
                {16,28 ,"Build New Query Filter"},;
                {17,28 ,"Use last Query Filter"}},nSubChoice)
    endif

    Unbox(cBox)
    lUseTag     := .F.
    lUseQuery   := .F.
    IF nSubChoice <=1
    ELSEIF nSubChoice = 2
      Tagit(aTagged)
      lUseTag := (len(aTagged) > 0)
    ELSE
      IF nSubChoice = 3
        do while .t.
          * use new Query parameters
          QUERY("","","","To Reporter",.T.)
          if len(sls_query()) > 100
             if messyn("Query too long - must be 100 chars or less","Rebuild","Cancel")
                loop
             else
                sls_query("")   
             endif
          endif
          exit
        enddo
        aValues[M_QUERY] := sls_query()
      ENDIF
      lUseQuery := (!EMPTY(aValues[M_QUERY]))
    ENDIF
  CASE nSelection = 8  .AND. rLoaded()   && sort order - select index for report
    rSetORder()
  CASE nSelection = 9  .AND. rLoaded()   && page layout
    rLayout()
  CASE nSelection = 10 .and. (aValues[M_NCOLS]> 0) .AND. rLoaded()
    cPrintBox := makebox(20,0,24,79,sls_normcol())
    rPrintRep({aValues,aHeader,aFooter,aColumns,aTitles,aWidths,aTotalYN,;
               aPictures},lUseQuery,lUseTag,aTagged)
    unbox(cPrintBox)

  CASE nSelection = 11 .AND. rLoaded()
    rShowLayout()
  CASE nSelection = 12  .or. lastkey()=K_ESC   // quitting time
    SETKEY(-1,bOldF2)
    if !empty(aValues[M_TITLE])
      if radiff(aLoaded,{aValues,aHeader,aFooter,aColumns,aTitles,aWidths,aTotalYN,aPictures})
        if messyn("Save Report:"+trim(aValues[M_TITLE])+" before quitting?")
          rSaveReport()
        endif
      endif
    endif
    SELECT (nReportArea)
    use
    SELECT (nOldArea)
    RESTSCREEN(0,0,24,79,cInScreen)
    RATEXIT(lReadExit)
    set order to nOldOrder
    setexact(lExact)
    SETCOLOR(cOldColor)
    setcursor(nOldCursor)
    lDone := .t.
  otherwise
     Msg("No Report Currently Defined. Load or Create Report")
  ENDCASE
  CLEAR TYPEAHEAD
ENDDO
aDbfFields := NIL
aDbfTypes  := NIL
aDbfLens   := NIL
aValues    := NIL
aHeader    := NIL
aFooter    := NIL
aColumns   := NIL
aTitles    := NIL
aWidths    := NIL
aTotalYN   := NIL
aPictures  := NIL
aNdxKeys   := NIL
nElement   := NIL
return ''

//-------------------------------------------------------------------------
static FUNCTION rAddColumn(nWhich)
asize(aColumns,len(aColumns)+1)
asize(aTitles,len(aTitles)+1)
asize(aWidths,len(aWidths)+1)
asize(aTotalYN,len(aTotalYN)+1)
asize(aPictures,len(aPictures)+1)
nWhich++
Ains(aColumns,nWhich)
Ains(aTitles,nWhich)
Ains(aWidths,nWhich)
Ains(aPictures,nWhich)
Ains(aTotalYN,nWhich)
aColumns[nWhich] := ""
aTitles[nWhich]  := SPACE(35)
aWidths[nWhich]  := "  "
aPictures[nWhich] := ""
aTotalYN[nWhich]  := " "
RETURN ''

//-------------------------------------------------------------------------
static FUNCTION rDelColumn(nWhich)
Adel(aColumns,nWhich)
Adel(aTitles,nWhich)
Adel(aWidths,nWhich)
Adel(aPictures,nWhich)
Adel(aTotalYN,nWhich)
asize(aColumns,len(aColumns)-1)
asize(aTitles,len(aTitles)-1)
asize(aWidths,len(aWidths)-1)
asize(aTotalYN,len(aTotalYN)-1)
asize(aPictures,len(aPictures)-1)
RETURN ''

//-------------------------------------------------------------------------
STATIC FUNCTION rGetTypeOf(cGetType)
local expValue := &(cGetType)
RETURN valtype(expValue)


//-------------------------------------------------------------------------
STATIC FUNCTION rSetORder
local nOpen,nOrder
local nSelect,cBox
local lIndex
set key 27 to

lIndex = !EMPTY(INDEXKEY(1))
cBox= Makebox(10,10,20,50,sls_popcol())
@10,12 SAY "[Select processing order]"
nSelect := RAT_MENU2({;
                {13,12 ,"Select an open index "},;
                {14,12 ,"View current sort selection"},;
                {15,12 ,"Deactivate current order"},;
                {17,12 ,"Quit"}},nSelect)
Unbox(cBox)

DO CASE
CASE nSelect = 1 .AND. lIndex  && select from open indexes
  STORE "" TO aValues[M_MAJKEY],aValues[M_MINKEY]
  cBox  := Makebox(10,19,17,71,sls_popcol())
  @10,21 SAY "[Select Index Key to Use]"
  nOrder = SACHOICE(11,20,16,70,aNdxKeys)
  Unbox(cBox)
  IF nOrder > 0 .and. len(aNdxKeys[nOrder]) < 60
    SET ORDER TO nOrder
    rParsKey(aNdxKeys[nOrder])
    aValues[M_NDXKEY] = aNdxKeys[nOrder]
  ELSEIF nOrder > 0
    msg("That index key is too long to store. Must be 60 chars or less")
  ENDIF
CASE nSelect = 2    && view selection
  Msg("Database order is   :  ",IIF(EMPTY(INDEXKEY(0)),"None Set",left(indexkey(0),50) ),;
    "Major group is      :  ",IIF(EMPTY(aValues[M_MAJKEY]),"None Selected",left(aValues[M_MAJKEY],50)),;
    "Secondary group is  :  ",IIF(EMPTY(aValues[M_MINKEY]),"None Selected",left(aValues[M_MINKEY],50)) )

CASE nSelect = 3    && deactivate
  STORE "" TO aValues[M_MAJKEY],aValues[M_MINKEY],aValues[M_NDXKEY]
ENDCASE
Unbox(cBox)
RETURN ''




//-------------------------------------------------------------------------
STATIC FUNCTION rSaveReport
LOCAL nIter,nOverWrite,cBuffer
LOCAL nOldarea := select()
local cTitle := aValues[M_TITLE]

SELECT __REPORTS
WHILE .T.
  IF aValues[M_NCOLS] = 0
    Msg("No Report Currently Defined")
    EXIT
  ENDIF
  DO WHILE .T.
    popread(.t.,"Report Title",@cTitle,"@K")
    IF LASTKEY()=27
      EXIT
    ENDIF

    LOCATE FOR TRIM(UPPER(cTitle))==TRIM(UPPER(__reports->SF_TITLE)) ;
         .AND. !DELETED()
    IF FOUND()
      if messyn("Record Exists:","Don't Overwrite","Overwrite")
        EXIT
      endif
    ELSE
      LOCATE FOR DELETED()   // if there's a deleted record, re-use it
      if found() .AND. SREC_LOCK(5,.F.)
      ELSEIF !SADD_REC(5,.T.,"Network error adding record. Keep trying?")
          EXIT
      endif
    ENDIF
    aValues[M_TITLE] := cTitle

    IF SREC_LOCK(5,.T.,"Network error saving data. Keep trying?")
        __reports->SF_DBF := aValues[M_DBF]
        __reports->SF_TITLE := aValues[M_TITLE]
        __reports->SF_NdxKey := aValues[M_NDXKEY]
        __reports->SF_MAJKEY := aValues[M_MAJKEY]
        __reports->SF_MINKEY := aValues[M_MINKEY]
        __reports->SF_MAJTEXT := aValues[M_MAJTEXT]
        __reports->SF_MINTEXT := aValues[M_MINTEXT]
        __reports->SF_WIDTH := aValues[M_WIDTH]
        __reports->SF_LENGTH := aValues[M_LENGTH]
        __reports->SF_LEFTM := aValues[M_LEFTM]
        __reports->SF_TOPM := aValues[M_TOPM]
        __reports->SF_SPACE := aValues[M_SPACE]
        __reports->SF_PAUSE := aValues[M_PAUSE]
        __reports->SF_NPLINES := aValues[M_NPLINES]
        __reports->SF_EJB4 := aValues[M_EJB4]
        __reports->SF_EJAFT := aValues[M_EJAFT]
        __reports->SF_EJMAJOR := aValues[M_EJMAJOR]
        __reports->SF_EJMINOR := aValues[M_EJMINOR]
        __reports->SF_EJGRAND := aValues[M_EJGRAND]
        __reports->SF_UNTOTAL := aValues[M_UNTOTAL]
        __reports->SF_MAJCHR := aValues[M_MAJCHR]
        __reports->SF_MINCHR := aValues[M_MINCHR]
        __reports->SF_NHEAD := aValues[M_NHEAD]
        __reports->SF_NFOOT := aValues[M_NFOOT]
        __reports->SF_NTITL := aValues[M_NTITL]
        __reports->SF_TSEP := aValues[M_TSEP]
        __reports->SF_COLSEP := aValues[M_COLSEP]
        __reports->SF_CSEPWID := aValues[M_CSEPWID]
        __reports->SF_LINESEP := aValues[M_LINESEP]
        __reports->SF_NCOLS := aValues[M_NCOLS]
        __reports->SF_STDHEAD := aValues[M_STDHEAD]
        __reports->SF_QUERY := aValues[M_QUERY]
        __reports->SF_FULLSUM := aValues[M_FULLSUM]
        __reports->SF_PRNCODE := aValues[M_PRNCODE]
        __reports->SF_AFTCODE := aValues[M_AFTCODE]

        cBuffer := ""
        for nIter = 1 TO aValues[M_NHEAD]
          cBuffer += rSquish(aHeader[nIter])+"þ"   && report headers
        NEXT (nIter)
        __reports->sf_heads :=  cBuffer

        cBuffer := ""
        for nIter = 1 TO aValues[M_NFOOT]
          cBuffer += rSquish(aFooter[nIter])+"þ"   && report footers
        NEXT (nIter)
        __reports->sf_feet := cBuffer

        cBuffer := ""
        for nIter = 1 TO aValues[M_NCOLS]
          cBuffer += aColumns[nIter]+ "þ"    && column contents
          cBuffer += aTitles[nIter]+  "þ"       && column titles (delimited with ; for multiple)
          cBuffer += aWidths[nIter]+  "þ"   && column widths
          cBuffer += aTotalYN[nIter]+  "þ"   && column totals Y/N
          cBuffer += aPictures[nIter]+CRLF    && column pictures
        NEXT (nIter)
        __reports->sf_details := cBuffer
        DBRECALL()      // undelete it, in case it was re-used
    endif
    unlock
    goto recno()
    EXIT
  ENDDO
  EXIT
END
SELECT (nOldArea)
RETURN ''


//-------------------------------------------------------------------------
STATIC FUNCTION rSquish(cInstring)
cInString := Strtran(cInString,SPACE(80),CHR(01))
cInString := Strtran(cInString,SPACE(70),CHR(02))
cInString := Strtran(cInString,SPACE(60),CHR(03))
cInString := Strtran(cInString,SPACE(50),CHR(04))
cInString := Strtran(cInString,SPACE(40),CHR(05))
cInString := Strtran(cInString,SPACE(30),CHR(06))
cInString := Strtran(cInString,SPACE(20),CHR(07))
cInString := Strtran(cInString,SPACE(10),CHR(08))
cInString := Strtran(cInString,SPACE(05),CHR(09))
cInString := Strtran(cInString,SPACE(02),CHR(10))
RETURN cInString


//-------------------------------------------------------------------------
STATIC FUNCTION rUnSquish(cInstring)
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

//-------------------------------------------------------------------------
static FUNCTION rLoadReport()

local nCountMatch,cBuffer,nMatches,nIndexOrd
local newkey,oldarea,cDbfNAme
local aMatchRec
local aRepTitles,i
local nFoundkey,cStoredKey
local cReportName

cDbfNAme    := alias()
oldarea     := select()
nIndexOrd   := indexord()
aHeader:= {}
aFooter:= {}
aColumns:={}
aTitles:={}
aWidths:={}
aTotalYN:={}
aPictures:={}

SELECT __REPORTS

LOCATE FOR __reports->sf_dbf=cDbfName .and. !deleted()
IF EOF()
  Msg("No reports found matching "+cDbfName)
ENDIF

DO WHILE !EOF()
  aValues[M_NDXKEY] = ""
  aValues[M_MAJKEY] = ""
  aValues[M_MINKEY] = ""
  IF cReportName==nil
     COUNT FOR __reports->sf_dbf=aValues[M_DBF] .and. !deleted() TO nCountMatch
     aMatchRec  := array(nCountMatch)
     aRepTitles := array(nCountMatch)
     GO TOP
     nMatches   := 0
     LOCATE FOR __reports->sf_dbf=cDbfNAme .and. !deleted()
     DO WHILE !EOF()
       nMatches++
       aMatchRec[nMatches]  := RECNO()
       aRepTitles[nMatches] := __reports->sf_title
       CONTINUE
     ENDDO

     nCountMatch := Mchoice(aRepTitles,10,20,20,70,"Stored Reports")
     IF nCountMatch = 0
       rLoadBlank()
       EXIT
     ENDIF
     GO (aMatchRec[nCountMatch])
  endif
  cStoredKey  := trim(__reports->sf_NdxKey)
  if !empty(cStoredKey)
    nFoundKey  := ascan(aNdxKeys,cStoredKey)
    if nFoundKey > 0
        nIndexOrd := nFoundKey
        aValues[M_NDXKEY] := cStoredKey
        aValues[M_MAJKEY] = trim(__reports->sf_majkey)
        aValues[M_MINKEY] = trim(__reports->sf_minkey)
        msg("Using index key =>"+aValues[M_NDXKEY])
    else
        aValues[M_NDXKEY] := ""
        aValues[M_MAJKEY] := ""
        aValues[M_MINKEY] := ""
    endif
  endif

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

  cBuffer := __reports->sf_heads
  for i = 1 TO aValues[M_NHEAD]
    aadd(aHeader,rUnSquish(Takeout(cBuffer,"þ",i)) )
  NEXT (I)

  cBuffer = __reports->sf_feet
  for i = 1 TO aValues[M_NFOOT]
    aadd(aFooter,rUnSquish(Takeout(cBuffer,"þ",i)) )
  NEXT (I)

  *- column descriptions
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
SELECT (oldarea)
set order to nIndexOrd
if len(aColumns)=0
  rLoadBlank()
endif
RETURN ''


//-------------------------------------------------------------------------
static FUNCTION rParsKey(cNdxKey)
local nFiguring,nStartSeg,nKeyLength,nSegments,cThisChar
local cBox,nChoice,nAtPos,nCounter
local aMajorKeys := {}
local aMinorKeys := {}
nFiguring   := 0
nStartSeg   := 1
nKeyLength  := LEN(cNdxKey)
nSegments   := 0
cThisChar   := ""
while  left(cNdxKey,1)=="(" .and. right(cNdxKey,1)==")"
    cNdxKey := subst(cNdxKey,2,len(cNdxKey)-2)
end

for nAtPos = 1 TO nKeyLength
  cThisChar := SUBST(cNdxKey,nAtPos,1)
  IF cThisChar=="("
    nFiguring++
  ELSEIF cThisChar==")"
    nFiguring--
  ELSEIF (nFiguring=0) .AND. (cThisChar=="+")
    nSegments++
    aadd(aMinorKeys,SUBST(cNdxKey,nStartSeg,(nAtPos-nStartSeg)) )
    aadd(aMajorKeys,SUBST(cNdxKey,1,nAtPos-1) )
    nStartSeg := nAtPos+1
  ENDIF
NEXT
nSegments = nSegments+1
aadd(aMinorKeys,SUBST(cNdxKey,nStartSeg) )
aadd(aMajorKeys,cNdxKey)


cBox := Makebox(8,5,18,75,sls_popcol())
@11,8  SAY "You can now use GROUPS in your report."
@12,8  SAY "A GROUP CHANGE is a point where a change takes place"
@13,8  SAY "in one of the keys in an INDEXED database. Report SUBTOTALS"
@14,8  SAY "will be printed at a GROUP change."
@15,8  SAY "This reportwriter supports a MAJOR group and a SECONDARY"
@16,8  SAY "GROUP. You will now be asked to select GROUPS for this report"
@18,8 SAY "[Press a key ....]"
rat_event(0)
Unbox(cBox)

IF Messyn("Select Major Group from index key?")
  nChoice := Mchoice(aMajorKeys,10,10,20,60,"Select MAJOR group")
  IF nChoice > 0
    aValues[M_MAJKEY] := aMajorKeys[nChoice]
  ENDIF

  IF nSegments > 1 .AND. nChoice > 0 .AND. nChoice < nSegments
    IF Messyn("Select secondary group from index key?")
      for nCounter = 1 TO nChoice
        Adel(aMinorKeys,1)
      NEXT
      asize(aMinorKeys,len(aMinorKeys)-nChoice)
      nChoice := Mchoice(aMinorKeys,10,10,20,60,"Select MINOR group")
      IF nChoice > 0
        aValues[M_MINKEY] := aMinorKeys[nChoice]
      ENDIF (nChoice > 0)
    ENDIF
  ENDIF
ENDIF
return nil


//-------------------------------------------------------------------------
static FUNCTION rDrawit
DISPBEGIN()
setcolor(sls_normcol())
@0,0,24,79 BOX "ÚÄ¿³ÙÄÀ³ "

setcolor(sls_popmenu())
@1,1,17,25 BOX "ÚÄ¿³ÙÄÀ³ "
@1,5 SAY '[Report Writer]'
@20,1,23,78 BOX "ÚÄ¿³ÙÄÀ³ "
DISPEND()
RETURN ''


//------------------------------------------------------------------
static function r_aaskip(n)
  local skipcount := 0
  do case
  case n > 0
    do while nElement+skipcount < len(aColumns)  .and. skipcount < n
      skipcount++
    enddo
  case n < 0
    do while nElement+skipcount > 1 .and. skipcount > n
      skipcount--
    enddo
  endcase
  nElement += skipcount
return skipcount


//-------------------------------------------------------------------------
static FUNCTION rMakeDbf
LOCAL RSTRUC[38]

RSTRUC[1]="sf_DBF,C,8"
RSTRUC[2]="sf_TITLE,C,35"
RSTRUC[3]="sf_NDXKEY,C,60"
RSTRUC[4]="sf_MAJKEY,C,60"
RSTRUC[5]="sf_MINKEY,C,60"
RSTRUC[6]="sf_MAJTEXT,C,25"
RSTRUC[7]="sf_MINTEXT,C,25"
RSTRUC[8]="sf_WIDTH,N,3,0"
RSTRUC[9]="sf_LENGTH,N,3,0"
RSTRUC[10]="sf_LEFTM,N,2,0"
RSTRUC[11]="sf_TOPM,N,2,0"
RSTRUC[12]="sf_SPACE,N,1,0"
RSTRUC[13]="sf_PAUSE,L"
RSTRUC[14]="sf_NPLINES,N,1,0"
RSTRUC[15]="sf_EJB4,L"
RSTRUC[16]="sf_EJAFT,L"
RSTRUC[17]="sf_EJMAJOR,L"
RSTRUC[18]="sf_EJMINOR,L"
RSTRUC[19]="sf_EJGRAND,L"
RSTRUC[20]="sf_UNTOTAL,L"
RSTRUC[21]="sf_MAJCHR,C,1"
RSTRUC[22]="sf_MINCHR,C,1"
RSTRUC[23]="sf_NHEAD,N,1,0"
RSTRUC[24]="sf_NFOOT,N,1,0"
RSTRUC[25]="sf_NTITL,N,1,0"
RSTRUC[26]="sf_TSEP,C,1"
RSTRUC[27]="sf_COLSEP,C,1"
RSTRUC[28]="sf_CSEPWID,N,1,0"
RSTRUC[29]="sf_LINESEP,C,1"
RSTRUC[30]="sf_NCOLS,N,2,0"
RSTRUC[31]="sf_FEET,M"
RSTRUC[32]="sf_HEADS,M"
RSTRUC[33]="sf_STDHEAD,L"
RSTRUC[34]="sf_DETAILS,M"
RSTRUC[35]="sf_QUERY,C,100"
RSTRUC[36]="sf_FULLSUM,C,1"
RSTRUC[37]="sf_PRNCODE,C,50"
RSTRUC[38]="sf_AFTCODE,C,50"
BLDDBF(slsf_report(),rstruc)
return nil

//-------------------------------------------------------------------------
static FUNCTION rLayout

local nPage,bOldf2,cBox
cBox = Makebox(1,18,24,79,sls_popcol(),0)
nPage = 1
bOldf2 = SETKEY(-1,{||rEditThis()})

DO WHILE .T.
  DO CASE
  CASE nPage = 1
    @23,55 say  "[PGDN]        [EXIT]"
    getlist := {}
    @ 1,20 SAY "[Page Layout Options  1"
    @ 3,20 SAY "Page Dimensions"
    @ 4,20 SAY "----------------"
    @ 5,20 SAY "Page length.....................    (lines per page)"
    @ 6,20 SAY "Page width......................    (characters across)"
    @ 7,20 SAY "Top margin......................"
    @ 8,20 SAY "Left Margin....................."
    @ 10,20 SAY "Group Headers and Totals"
    @ 11,20 SAY "------------------------"
    @ 12,20 SAY "Text of Major group header......"
    @ 13,20 SAY "(enter NONE to suppress Major group header)"

    @ 14,20 SAY "Text of Minor group header......"
    @ 15,20 SAY "(enter NONE to suppress Minor group header)"
    @ 16,20 SAY "Major underline character.......    [F2=options]"
    @ 17,20 SAY "Minor underline character.......    [F2=options]"
    @ 18,20 SAY "Underline totals................    (Y/N)"
    @5,53 GET aValues[M_LENGTH]  PICT "999"
    @6,53 GET aValues[M_WIDTH]   PICT "999"
    @7,53 GET aValues[M_TOPM]    PICT "99"
    @8,53 GET aValues[M_LEFTM]   PICT "99"

    @12,53 GET aValues[M_MAJTEXT]
    @14,53 GET aValues[M_MINTEXT]
    @16,53 GET aValues[M_MAJCHR]
    @17,53 GET aValues[M_MINCHR]
    @18,53 GET aValues[M_UNTOTAL]  PICT "Y"
    Rat_read(getlist,1,.f.,27,{|r,c|chkpage(.t.,.f.,r,c,{16,17} )})
    Scroll(2,19,23,78,0)
  CASE nPage = 2
    @23,55 say  "[PGDN] [PGUP] [EXIT]"
    getlist := {}
    @ 1,20 SAY  "[Page Layout Options  2 "
    @ 3,20 SAY  "Eject (new page) Options"
    @ 4,20 SAY  "--------------------------"
    @ 5,20 SAY  "Eject before report.............    (Y/N)"
    @ 6,20 SAY  "Eject after report..............    (Y/N)"
    @ 7,20 SAY  "Eject on Major change...........    (Y/N)"
    @ 8,20 SAY  "Eject on Minor change...........    (Y/N)"
    @ 9,20 SAY  "Eject before grand totals.......    (Y/N)"
    @ 10,20 SAY "Eject if # lines left...........    (after group change)"
    @ 11,20 SAY "Pause between pages ............    (Y/N)"
    @ 13,20 SAY "Separator Characters"
    @ 14,20 SAY "---------------------"
    @ 15,20 SAY "Number of title lines...........    (1 or 2)"
    @ 16,20 SAY "Detail line separator...........    [F2=options]"
    @ 17,20 SAY "# lines between detail lines.....   (0 or 1)"
    @ 18,20 SAY "Column separator................    [F2=options]"
    @ 19,20 SAY "Column separator width.........."
    @ 20,20 SAY "Title/body/footer separator.....    [F2=options]"
    @5,53 GET aValues[M_EJB4]   PICT "Y"
    @6,53 GET aValues[M_EJAFT]  PICT "Y"
    @7,53 GET aValues[M_EJMAJOR] PICT "Y"
    @8,53 GET aValues[M_EJMINOR] PICT "Y"
    @9,53 GET aValues[M_EJGRAND] PICT "Y"
    @10,53 GET aValues[M_NPLINES] PICT "9"
    @11,53 GET aValues[M_PAUSE]  PICT "Y"
    @15,53 GET aValues[M_NTITL]  PICT "9" ;
       VALID iif(aValues[M_NTITL]> 0 .and. aValues[M_NTITL] < 3,.t.,(msg("Must be 1 or 2"),.f.) )
    @16,53 GET aValues[M_LINESEP]
    @17,53 GET aValues[M_SPACE]  PICT "9" ;
       VALID iif(aValues[M_SPACE]<2,.t.,(msg("Must be 0 or 1"),.f.) )
    @18,53 GET aValues[M_COLSEP]
    @19,53 GET aValues[M_CSEPWID] PICT "9"
    @20,53 GET aValues[M_TSEP]
    Rat_read(getlist,1,.f.,27,{|r,c|chkpage(.t.,.t.,r,c,{16,18,20})})
    Scroll(2,19,23,78,0)
  CASE nPage = 3
    @23,55 say   "       [PGUP] [EXIT]"
    getlist := {}
    @ 1,20 SAY "[Page Layout Options  3 "
    @ 3,20 SAY "Miscellaneous Options"
    @ 4,20 SAY "--------------------------"
    @ 6,20 SAY "Include standard 2-line header ?"
    @ 7,20 SAY "(page#, date, time)"
    @ 9,20 SAY "Full or summary report..........    (F/S)"
    @ 10,20 SAY "Printer setup code..(decimal)..."
    @ 11,20 SAY "Printer exit code..(decimal)...    (when done)"

    @ 13,20 SAY "PRINTER CODES NOTE:"
    @ 14,20 SAY "For printer codes, use either DECIMAL printer codes"
    @ 15,20 SAY "separated by commas, or type in the characters as they "
    @ 16,20 SAY "appear in your printer manual, using the @ charac-"
    @ 17,20 SAY "ter in place of ESCAPE. Example: "
    @ 18,20 SAY "(using HP Laserjet codes to set the type to ITALIC)"
    @ 19,20 SAY "   1.DECIMAL       27,40,115,49,83"
    @ 20,20 SAY "   1.CHARACTERS    @(s1S"

    @6,53 GET aValues[M_STDHEAD]  PICT "Y"
    @9,53 GET aValues[M_FULLSUM]  PICT "!" ;
       VALID iif(aValues[M_FULLSUM]$'SF',.t.,;
            (msg("Must be S)ummary or F)ull")=="X") )
    @10,53 GET aValues[M_PRNCODE] PICT "@S25"
    @11,53 GET aValues[M_AFTCODE] PICT "@S25"
    Rat_read(getlist,1,.f.,27,{|r,c|chkpage(.f.,.t.,r,c)})
    Scroll(2,19,23,78,0)
  ENDCASE
  DO CASE
  CASE LASTKEY() = K_UP  .OR. LASTKEY() = K_PGUP
    nPage = MAX(1,nPage-1)
  CASE LASTKEY() = K_ESC
    EXIT
  CASE LASTKEY() = K_CTRL_END
    EXIT
  OTHERWISE
    nPage++
  ENDCASE
  IF nPage > 3
    EXIT
  ENDIF
ENDDO
bOldf2 := SETKEY(-1,bOldf2)
Unbox(cBox)
RETURN ''


static function chkpage(lDown, lUp, nMouseR, nMouseC,aF2s)
local i
if nMouseR==23
  do case
  case lDown .and. nMouseC>=55 .and. nMouseC<=60
    keyboard chr(K_PGDN)
  case lUp .and. nMouseC>=62 .and. nMouseC<=67
    keyboard chr(K_PGUP)
  case nMouseC>=69 .and. nMouseC<=74
    keyboard chr(K_CTRL_END)
  endcase
elseif !empty(aF2s)
  for i = 1 to len(aF2s)
     if nMouseR==aF2s[i]
       if nMouseC>=46 .and. nMouseR<=57
         rEditThis()
         exit
       endif
     endif
  next
endif
return nil
//-------------------------------------------------------------------------
STATIC function rEditThis   && line draw chars
LOCAL aLineChars := {"=","Í","_","Ä","|","³","º"}
local cBox,nSelection,i,nRow,nColumn
local nSubscript
local aPrompts := {}
nSubscript := ratactive():subscript[1]

IF (nSubscript=M_MAJCHR .OR. nSubscript=M_MINCHR .OR. nSubscript=M_LINESEP ;
      .OR. nSubscript=M_COLSEP .OR. nSubscript=M_TSEP)

     SETKEY(-1)

     nRow    := row()
     nColumn := col()
     cBox    := makebox(nRow-1,nColumn+1,nRow+1,nColumn+25)
     @nRow-1,nColumn+2 say "[Separator Characters]"
     @nRow,nColumn say ""
     for i = 1 to 7
       aadd(aPrompts,{nRow,nColumn+(2*i),aLineChars[i]})
     next
     nSelection := RAT_MENU2(aPrompts)

     unbox(cBox)
     if nSelection > 0
        keyboard aLineChars[nSelection]
     endif
     SETKEY(-1,{||rEditThis()})
ENDIF
return ''


//-------------------------------------------------------------------------
static FUNCTION rHeadsFeet
local cBox, i:=0
local nTop,nBot,nHeadJust,nFootJust

IF aValues[M_NHEAD]+aValues[M_NFOOT] =0
  RETURN ''
ENDIF


nTop := MIN(23-(aValues[M_NHEAD]+aValues[M_NFOOT]+4),6)
nBot := nTop+(aValues[M_NHEAD]+aValues[M_NFOOT]+5)
cBox := Makebox(nTop,3,nBot,76,sls_popcol())
@nTop,4 SAY "[Headers and Footers]"

IF aValues[M_NHEAD] > 0
  @nTop+1,5 SAY "Headers:"
  for i = 1 TO aValues[M_NHEAD]
    aHeader[i] := padr(aHeader[i],(aValues[M_WIDTH]-aValues[M_LEFTM]))
    @row()+1,5 GET aHeader[i] PICT "@S70"
  NEXT
ENDIF

IF aValues[M_NFOOT] > 0
  @nTop+1+i,5 SAY "Footers:"
  for i = 1 TO aValues[M_NFOOT]
    aFooter[i] := padr(aFooter[i],(aValues[M_WIDTH]-aValues[M_LEFTM]))
    @row()+1,5 GET aFooter[i] PICT "@S70"
  NEXT (I)
ENDIF
RAT_READ(getlist)

@nBot-2,5 CLEAR TO nBot-1,70

i := 0
IF aValues[M_NHEAD] > 0
  @ nBot-2,5 SAY "Headers: "
  @ nBot-2,16 PROMPT      "Leave as-is"
  @ nBot-2,col()+3 PROMPT "Center"
  @ nBot-2,col()+3 PROMPT "Left Justify"
  @ nBot-2,col()+3 PROMPT "Right Justify"
  MENU TO nHeadJust
  @nTop+1,5 SAY ""
  for i = 1 TO aValues[M_NHEAD]
    DO CASE
    CASE nHeadJust = 2
      aHeader[i] :=padc(alltrim(aHeader[i]),len(aHeader[i]))
    CASE nHeadJust = 3
      aHeader[i] :=Ljust(aHeader[i])
    CASE nHeadJust = 4
      aHeader[i] :=Rjust(aHeader[i])
    ENDCASE
    @row()+1,5 get aHeader[i] pict "@S70"
  NEXT
  clear gets
ENDIF
IF aValues[M_NFOOT] > 0
  @ nBot-1,5 SAY "Footers: "
  @ nBot-1,16 PROMPT      "Leave as-is"
  @ nBot-1,col()+3 PROMPT "Center"
  @ nBot-1,col()+3 PROMPT "Left Justify"
  @ nBot-1,col()+3 PROMPT "Right Justify"
  MENU TO nHeadJust
  @nTop+1+i,5 SAY ""
  for i = 1 TO aValues[M_NFOOT]
    DO CASE
    CASE nHeadJust = 2
      aFooter[i] :=padc(alltrim(aFooter[i]),len(aFooter[i]))
    CASE nHeadJust = 3
      aFooter[i] :=Ljust(aFooter[i])
    CASE nHeadJust = 4
      aFooter[i] :=Rjust(aFooter[i])
    ENDCASE
    @row()+1,5 get aFooter[i] pict "@S70"
  NEXT (I)
  clear gets
ENDIF
@nBot-2,5 CLEAR TO nBot-1,70
@ nBot-1,5 SAY "Press a key...."
rat_event(0)
Unbox(cBox)
RETURN ''

//-------------------------------------------------------------------------
static FUNCTION rCurrWidth
local nWidth,i
nWidth := aValues[M_LEFTM]+((aValues[M_NCOLS]-1)*aValues[M_CSEPWID])
for i = 1 TO aValues[M_NCOLS]
  nWidth := nWidth+VAL(aWidths[i])
NEXT
RETURN nWidth

//-------------------------------------------------------------------------
static FUNCTION rShowLayout
local cBox
local getlist := {}
local nOldCursor := setcursor(0)
cBox  := makebox(0,0,24,79,setcolor(),0,0)
@ 11,0 SAY 'Ã'
@ 11,79 SAY '´'
@ 20,0 SAY 'Ã'
@ 20,79 SAY '´'
@24,2 say "[  OK  ]"
@ 1,2 SAY "Report Title"
@ 2,2 SAY "DBF Name"
@ 3,2 SAY "Index Key"
@ 4,2 SAY "Key of Major Group"
@ 5,2 SAY "Key of Minor Group"
@ 6,2 SAY "Major Group Text"
@ 7,2 SAY "Minor Group Text"
@ 8,2 SAY "Last Used Query"
@ 9,2 SAY "Before Print Code"
@ 10,2 SAY "After Print Code"
@ 11,1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 12,2 SAY "Page Width               Page Length"
@ 13,2 SAY "Left Margin              Top Margin                 Line Spacing"
@ 14,2 SAY "# of Header Lines        # Footer Lines        Use standard header ?"
@ 15,2 SAY "Underline Totals ?      Major Underline             Minor Underline"
@ 16,2 SAY "Pause Between Pages"
@ 17,2 SAY "Full or Summary         # of Columns                # of title lines"
@ 18,2 SAY "Title Separator         Column Separator         Width of Column Sep"
@ 19,2 SAY "Line Separator"
@ 20,1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 21,2 SAY "Eject:Before Report         After Report     If # line left on group"
@ 22,8 SAY "B4 Grand Ttls      On Major change              On Minor Change"
@1,22 GET aValues[M_TITLE]
@2,22 GET aValues[M_DBF]
@3,22 GET aValues[M_NDXKEY] PICT "@S50"
@4,22 GET aValues[M_MAJKEY] PICT "@S50"
@5,22 GET aValues[M_MINKEY] PICT "@S50"
@6,22 GET aValues[M_MAJTEXT]
@7,22 GET aValues[M_MINTEXT]
@8,22 GET aValues[M_QUERY] PICT "@s40"
@9,22 GET aValues[M_PRNCODE]
@10,22 GET aValues[M_AFTCODE]
@12,22 GET aValues[M_WIDTH]  pict "999"
@12,43 GET aValues[M_LENGTH] pict "999"
@13,22 GET aValues[M_LEFTM]  pict "999"
@13,43 GET aValues[M_TOPM]   pict "999"
@13,72 GET aValues[M_SPACE]  pict "999"
@14,22 GET aValues[M_NHEAD]  pict "999"
@14,43 GET aValues[M_NFOOT]  pict "999"
@14,72 GET aValues[M_STDHEAD] pict "Y"
@15,22 GET aValues[M_UNTOTAL] pict "Y"
@15,43 GET aValues[M_MAJCHR]
@15,72 GET aValues[M_MINCHR]
@16,22 GET aValues[M_PAUSE]   pict "Y"
@17,22 GET aValues[M_FULLSUM]
@17,43 GET aValues[M_NCOLS]  pict "999"
@17,72 GET aValues[M_NTITL]  pict "999"
@18,22 GET aValues[M_TSEP]
@18,43 GET aValues[M_COLSEP]
@18,72 GET aValues[M_CSEPWID] pict "999"
@19,22 GET aValues[M_LINESEP]
@21,22 GET aValues[M_EJB4]    pict "Y"
@21,43 GET aValues[M_EJAFT]   pict "Y"
@21,72 GET aValues[M_NPLINES] pict "9"
@22,22 GET aValues[M_EJGRAND] pict "Y"
@22,43 GET aValues[M_EJMAJOR] pict "Y"
@22,72 GET aValues[M_EJMINOR] pict "Y"
clear gets
rat_event(0)
UNBOX(cBox)
setcursor(nOldCursor)
return ''

//-------------------------------------------------------------------------
STATIC FUNCTION rLoaded
return !EMPTY(aValues[M_TITLE])

//-------------------------------------------------------------------------
STATIC FUNCTION rLoadBlank

STORE "" TO aValues[M_NDXKEY],aValues[M_MAJKEY], aValues[M_MINKEY],aValues[M_QUERY]
STORE ALIAS()   TO aValues[M_DBF]
STORE SPACE(35) TO aValues[M_TITLE]
STORE 0 TO aValues[M_TOPM],aValues[M_LEFTM]
STORE 0 TO aValues[M_NHEAD],aValues[M_NFOOT],aValues[M_NCOLS],aValues[M_SPACE]
STORE 1 TO aValues[M_NTITL],aValues[M_CSEPWID]
STORE 4 TO aValues[M_NPLINES]
STORE 80 TO aValues[M_WIDTH]
STORE 66 TO aValues[M_LENGTH]
STORE .F. TO aValues[M_PAUSE],aValues[M_EJB4]
STORE .T. TO aValues[M_EJAFT]
STORE .F. TO aValues[M_EJMAJOR],aValues[M_EJMINOR],aValues[M_EJGRAND]
STORE .F. TO aValues[M_UNTOTAL]
STORE .F. TO aValues[M_STDHEAD]

STORE "-" TO aValues[M_TSEP], aValues[M_MAJCHR]
STORE "=" TO aValues[M_MINCHR]
STORE "|" TO aValues[M_COLSEP]
STORE " " TO aValues[M_LINESEP]
STORE "F" TO aValues[M_FULLSUM]
STORE SPACE(50) TO aValues[M_PRNCODE],aValues[M_AFTCODE]
STORE padr("Major Group :",25) TO aValues[M_MAJTEXT]
STORE padr("Minor Group :",25) TO aValues[M_MINTEXT]

aHeader := {}
aFooter := {}
aColumns := {""}
aTitles  := {space(10)}
aWidths  := {"  "}
aTotalYN := {" "}
aPictures:= {" "}
RETURN ''


//--------------------------------------------------------------------
static function rMaketb
local oTb
nElement := 1
oTb := tbrowseNew(3,18,18,76)
oTb:addcolumn(tbcolumnnew("#",{||trans(nElement,"99")}   )  )
oTb:addcolumn(tbcolumnnew("Column Contents",{||padr(aColumns[nElement],17)}   )  )
oTb:addcolumn(tbcolumnnew("Column Title",{||padr(aTitles[nElement],19)}   )  )
oTb:addcolumn(tbcolumnnew("Width",{||padc(aWidths[nElement],5)}  ))
oTb:addcolumn(tbcolumnnew("Pict" ,{||padc(aPictures[nElement],5)}  ))
oTb:addcolumn(tbcolumnnew("Total" ,{||padc(aTotalYN[nElement],5)}  )  )
oTb:skipblock      :=  {|n|r_aaskip(n)}
oTb:colsep         :=  "³"
oTb:headsep        :=  "Ä"
oTb:colorspec := sls_normcol()
oTb:gotopblock      := {||nElement := 1}
oTb:gobottomblock   := {||nElement := len(aColumns)}
return oTb

//-------------------------------------------------------------------------
static FUNCTION rBrowseEdit()
local nLastkey, nMouseR, nMouseC, nButton,aButtons
local cInscreen := savescreen(0,0,24,79)
LOCAL oTb       := rMaketb() // tbrowse

DISPBEGIN()
@ 0,0,24,79 BOX "±±±±±±±±±" color sls_normcol()

@ 1,1,19,78 BOX "ÚÄ¿³ÙÄÀ³ "
@ 1,2 SAY "-= Editing Report: "+alltrim(aValues[M_TITLE])+"=-"
@ 21,0,24,79 BOX "ÚÄ¿³ÙÄÀ³ "
//@ 3,17 to 18,17
@ 3,3 SAY  "[KEYS]"
@ 5,3 SAY  "[][][][]"
@ 7,3 SAY  "ÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 8,3 SAY  "[ENTER=change]"
@ 9,3 SAY  " column"
@ 10,3 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 11,3 SAY "[INSERT=add  ]"
@ 12,3 SAY " column"
@ 13,3 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 14,3 SAY "[DEL=delete  ]"
@ 15,3 SAY " column"
@ 16,3 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 17,3 SAY "[F10=done    ]"

aButtons := {;
            {8,3,8,16,K_ENTER},;
            {11,3,11,16,K_INS},;
            {14,3,15,16,K_DEL},;
            {17,3,17,16,K_F10}  }

oTb:colpos := 2
oTb:refreshall()
while !oTb:stabilize()
end
DISPEND()

DO WHILE .T.
  while !oTb:stabilize()
  end
  setcolor(sls_popcol())
  SCROLL(22,1,23,78,0)
  if aValues[M_NCOLS] > 0
    DO CASE
    CASE oTb:colpos=2
      @ 23,6 SAY LEFT(aColumns[nElement],60)
    CASE oTb:colpos=3
      @ 23,6 SAY LEFT(aTitles[nElement],60)
    CASE oTb:colpos=4
      @ 23,6 SAY "Column Width: "+aWidths[nElement]
    CASE oTb:colpos=5.AND. !EMPTY(aPictures[nElement])
      @ 23,6 SAY "Picture     : "+aPictures[nElement]
    CASE oTb:colpos=6 .AND. aTotalYN[nElement]=="Y"
      @ 23,6 SAY "Total this column"
    ENDCASE
  endif

  SET CURSOR OFF

  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
  nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)

  SET CURSOR ON

  DO CASE
  CASE nLastkey == K_ESC .or. nLastkey==K_F10 .or. nbutton==K_F10
    EXIT
  CASE nLastkey = K_ENTER .OR. nButton==K_ENTER
    if aValues[M_NCOLS]=0
      rColEdit(2)
      if !empty(aColumns[1])
        aValues[M_NCOLS] = 1
      endif
    else
      rColEdit(oTb:colpos)
    endif

  CASE (nLastkey = K_INS .OR. nButton==K_INS  ) ;
        .AND. aValues[M_NCOLS] < 34
    if aValues[M_NCOLS] > 0
      //09-23-1992 changed
      //rAddColumn(oTb:rowpos)
      rAddColumn(nElement)
    endif
    aValues[M_NCOLS] := aValues[M_NCOLS]+1
    oTb:down()
    oTb:refreshall()
    while !oTb:stabilize()
    end
    setcolor(sls_popcol())
    rColEdit(2)
    IF EMPTY(aColumns[nElement])
      //09-23-1992
      rDelColumn(nElement)
      aValues[M_NCOLS] = aValues[M_NCOLS]-1
      if aValues[M_NCOLS]==0
        rLoadBlank()
        nElement := 1
      else
        nElement--
        if oTb:rowpos<>14
          oTb:up()
        endif
      endif
      //oTb:up()
      //rDelColumn(nElement)
      //nElement--
      //aValues[M_NCOLS] = aValues[M_NCOLS]-1
    ENDIF
    oTb:refreshall()
    while !oTb:stabilize()
    end
    setcolor(sls_popcol())
    *- check width
    IF rCurrWidth() > aValues[M_WIDTH]
      Msg("WARNING!",;
        " Page width has been exceeded:",;
        " Page width                  = "+TRANS(aValues[M_WIDTH],"999"),;
        " Length of defined columns   = "+TRANS(rCurrWidth(),"999"))
    ENDIF

  CASE (nLastkey = K_INS .OR. nButton==K_INS).AND. aValues[M_NCOLS] = 34
    Msg("Maximum columns defined (34)")
  CASE (nLastkey = K_DEL .OR. nButton==K_DEL).and. aValues[M_NCOLS] > 0  && delete
    //09-23-1992 changed
    rDelColumn(nElement)
    //rDelColumn(oTb:rowpos)
    aValues[M_NCOLS] = aValues[M_NCOLS]-1
    //09-23-1992
    if aValues[M_NCOLS]==0
      rLoadBlank()
      nElement := 1
    elseif nElement > aValues[M_NCOLS]
      nElement--
    endif
    oTb:refreshall()
  CASE nLastkey = K_RIGHT
    oTb:right()
  CASE nLastkey = K_LEFT  .and. oTb:colpos > 2
    oTb:left()
  CASE nLastkey = K_UP  && up
    oTb:up()
  CASE nLastkey = K_DOWN .AND. oTb:rowpos < aValues[M_NCOLS]
    oTb:down()
  CASE nLastkey == K_PGUP
    oTb:pageup()
  CASE nLastkey == K_PGDN
    oTb:pagedown()
  CASE nLastkey == K_HOME
    oTb:gotop()
  CASE nLastkey == K_END
    oTb:gobottom()
  case nLastKey == K_MOUSELEFT // mouse
    DO CASE
    CASE ISMOUSEAT(nMouseR, nMouseC, 5,3,5,3)
        oTb:up()
        IFMOUSEHD({||oTb:up()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC, 5,6,5,8)
        oTb:down()
        IFMOUSEHD({||oTb:down()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC, 5,9,5,11)
        oTb:right()
        IFMOUSEHD({||oTb:right()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC, 5,12,5,14)
        oTb:left()
        IFMOUSEHD({||oTb:left()},oTb)
    OTHERWISE
      MBRZMOVE(oTb,nMouseR,nMouseC,4,18,18,76)
    ENDCASE
  ENDCASE
  oTb:refreshcurrent()
ENDDO (.T.)
restscreen(0,0,24,79,cInscreen)
return nil


//-------------------------------------------------------------------------
static FUNCTION rColEdit(nWhichColumn)
local nDoTotal,cTitleLen,cBox
local cTitle1,cTitle2

SCROLL(22,2,23,77,0)
DO CASE
CASE nWhichColumn = 2   && contents
  rExprEdit()

CASE nWhichColumn = 3   && title
  SCROLL(22,2,23,77,0)
  cTitleLen = VAL(aWidths[nElement])
  @22,5 SAY "Enter a new title width " GET cTitleLen PICT "99"
  RAT_READ(getlist)
  getlist := {}
  scroll(22,2,23,77,0)
  cTitle1 = padr(Takeout(aTitles[nElement],';',1),cTitleLen)
  cTitle2 = padr(Takeout(aTitles[nElement],';',2),cTitleLen)
  @22,5 SAY "Title: "
  @22,14 GET cTitle1 PICT "@S70"
  IF aValues[M_NTITL]=2
    @23,14 GET cTitle2 PICT "@S70"
  ENDIF (aValues[M_NTITL]=2)
  RAT_READ(getlist)
  getlist := {}
  aTitles[nElement]=cTitle1
  IF aValues[M_NTITL]=2
    aTitles[nElement] = aTitles[nElement]+';'+cTitle2
  ENDIF (aValues[M_NTITL]=2)
  IF Ascan(aDbfFields,TRIM(aColumns[nElement])) > 0
    aWidths[nElement]= TRANS(MAX(aDbfLens[ascan(aDbfFields,trim(aColumns[nElement]))],cTitleLen),"99")
  ENDIF
CASE nWhichColumn = 4   && width
  scroll(22,2,23,77,0)
  @22,5 SAY "Enter a new column width " GET aWidths[nElement] PICT "99"
  RAT_READ(getlist)
  getlist := {}
CASE nWhichColumn = 5  .AND.  rGetTypeOf(aColumns[nElement])=="N" && picture
  cBox = Makebox(05,20,20,70,sls_popcol())
  aPictures[nElement]=padr(aPictures[nElement],20)
  @06,22 SAY "Picture: " GET aPictures[nElement]
  @row()+2,22 SAY "  9   A number"
  @row()+1,22 SAY "  .   Position of the decimal point."
  @row()+1,22 SAY "  ,   Inserts a comma "
  @row()+1,22 SAY "  *   Inserts asterisks for leading blanks."
  @row()+1,22 SAY "  $   Inserts $ signs for leading blanks."
  @row()+1,22 SAY "  @(  Encloses negatives in parentheses."
  @row()+1,22 SAY "  @B  Left justifies numbers."
  @row()+1,22 SAY "  @C  Displays CR after a positive number."
  @row()+1,22 SAY "  @X  Displays DB after a negative number."
  @row()+1,22 SAY "  @Z  Displays spaces instead of zeros if =0"
  RAT_READ(getlist)
  getlist := {}
  aPictures[nElement]=Alltrim(aPictures[nElement])
  Unbox(cBox)
CASE nWhichColumn = 5
  Msg("Numeric fields only","Use expression builder")
CASE nWhichColumn = 6  && total
  IF (rGetTypeOf(aColumns[nElement])=="N")
    nDoTotal := RAT_MENU2({;
            {22,5 ,"Total this Column"},{23,5 ,"Don't Total this Column"}})
    aTotalYN[nElement]=IIF(nDoTotal=1,"Y","N")
  ELSE
    Msg("Can't total a non-numeric column")
  ENDIF
ENDCASE

scroll(22,2,23,77,0)
RETURN ''

//-------------------------------------------------------------------------
static FUNCTION rExprEdit
local lIsNew,nTypeOf,nSpaces,cString,expWhatever
local nFieldorSpace,nWhichField,nFieldorEx

lIsNew := .T.
DO WHILE .T.
   IF !EMPTY(aColumns[nElement])
     nTypeOf := RAT_MENU2({;
            {22,5 ,"Pick New Value for this column"},;
            {23,5 ,"Extend with Expression Builder"}} )
     scroll(22,2,23,77,0)
     lIsNew := (nTypeOf=1)
   ENDIF
   scroll(22,2,23,77,0)
   IF LASTKEY()=27
     EXIT
   ENDIF

   IF lIsNew
     nFieldOrSpace := RAT_MENU2({;
            {22,5 ,"Pick Database Field for this column"},;
            {23,5 ,"Use Spaces (for filler)"}})
     scroll(22,2,23,77,0)
     DO CASE
     CASE nFieldorSpace = 1
       nWhichField= Mchoice(aDbfFields,10,50,20,70,"Select Field")
       IF nWhichField > 0
         IF aDbfTypes[nWhichField]=="M"
           Msg("Sorry...MEMO fields not reportable..")
         ELSE
           nFieldOrEx := RAT_MENU2({;
                {22,5 ,"Use value contained in database field: "+;
                        aDbfFields[nWhichField]},;
                {23,5 ,"Build extended expression from field : "+;
                        aDbfFields[nWhichField]}})

           scroll(22,2,23,77,0)
           IF !nFieldorEx=2
             aColumns[nElement] = aDbfFields[nWhichField]
             aTitles[nElement]= aDbfFields[nWhichField]
             aWidths[nElement]= TRANS(MAX(aDbfLens[nWhichField],LEN(aTitles[nElement])),"99")
             aTotalYN[nElement]="N"
           ELSE
             aColumns[nElement]= buildex("Report Column Contents",aDbfFields[nWhichField],.T.,aDbfFields,aDbfFields)
             aTitles[nElement]= aDbfFields[nWhichField]
             aWidths[nElement]= TRANS( LEN( TRANS(aColumns[nElement],"") )  ,"99")
             aTotalYN[nElement]="N"
             aPictures[nElement]=""
           ENDIF
         ENDIF
       ENDIF

     CASE nFieldorSpace = 2    && must be 'use spaces'
       getlist := {}
       nSpaces="1"
       @22,5 SAY "Enter # of spaces 1-9 (0 = none) " GET nSpaces PICT "9"
       RAT_READ(getlist)
       IF VAL(nSpaces) >0
         aColumns[nElement] = "SPACE("+Alltrim(nSpaces)+")"
         aTitles[nElement]= " "
         aWidths[nElement]= " "+nSpaces
         aTotalYN[nElement]="N"
         aPictures[nElement]=""
       ENDIF
     ENDCASE

   ELSE   // extend current expression
     aColumns[nElement] := buildex("Report Column Contents",;
                  aColumns[nElement],.T.,aDbfFields,aDbfFields)
     aWidths[nElement]  := TRANS( LEN( TRANS(aColumns[nElement],"") )  ,"99")
     aTotalYN[nElement] :="N"
   ENDIF
   if !empty(aColumns[nElement])
      aPictures[nElement]=IIF(rGetTypeOf(aColumns[nElement])=="N",;
              aPictures[nElement],"")
      if rGetTypeOf(aColumns[nElement])=="N" .and. empty(aPictures[nElement])
          cString := STR(&(aColumns[nElement]))
          *- look for a decimal point
          IF "." $ cString
            expWhatever := len(cString)-AT(".",cString)
            aPictures[nElement] := REPLICATE("9", val(aWidths[nElement])-(expWhatever+1))
            aPictures[nElement] := aPictures[nElement]+'.'+REPL("9",expWhatever)
          ELSE
            aPictures[nElement] := REPLICATE("9", val(aWidths[nElement]))
          ENDIF
      endif
   endif
   EXIT
ENDDO
return nil

// check for difference between two arrays
// return .t. if there is a difference. calls itself recursivley.
static function RADIFF(a1,a2)
local lDiff := .f.
local i
if !(len(a1)==len(a2))
  lDiff := .t.
else
  for i = 1 to len(a1)
    if valtype(a1[i])==valtype(a2[i])
      if valtype(a1[i])=="A"
        lDiff := RADIFF( a1[i], a2[i] )
      else
        lDiff := ( a1[i]<>a2[i] )
      endif
    else
      lDiff = .t.
      exit
    endif
    if lDiff
        exit
    endif
  next
endif
return lDiff












