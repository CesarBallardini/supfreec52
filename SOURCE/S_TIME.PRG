//---------------------------------------------------------------------

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#include "Dbstruct.ch"

#define BY_WEEK    1
#define BY_WEEKTD  2
#define BY_MONTH   3
#define BY_MONTHTD 4
#define BY_YEAR    5
#define BY_YEARTD  6
#define BY_USERDEF 7

#define ASTRUC_START 1
#define ASTRUC_END   2
#define ASTRUC_COUNT 3
#define ASTRUC_SUM   4
#define ASTRUC_AVG   5



//---------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION TIMEPER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  TIMEPER() Time Period (date sensitive) DBF analysis
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  TIMEPER([aFields,aDescript],[aIndexes])
ณ 
ณ  Description:
ณ  ------------
ณ  Does a menu-driven time/date sensitive analysis of a
ณ  DBF based on DATE type fields in the DBF, by sorting data into
ณ  time periods
ณ 
ณ  Time periods can be:
ณ 
ณ       A By Week
ณ       B Week to Date
ณ       C By Month
ณ       D Month to Date
ณ       E By Year
ณ       F Year to date
ณ       G User defined
ณ 
ณ  Additional numeric fields may be tallied within each
ณ  time period.
ณ 
ณ  [aFields]   array of field names
ณ 
ณ  [aDescript] array of field descriptions
ณ 
ณ  [aIndexes]  array of currently open indexes for
ณ  re-opening on exit
ณ 
ณ  Examples:
ณ  ---------
ณ   TIMEPER(aFields,aDesc,aIndexes)
ณ 
ณ  Warnings:
ณ  ----------
ณ  Restore your indexes after using this function, as it
ณ  creates a new index and you will lose the SET INDEX...unless you
ณ  pass the third param as an array of open indexes
ณ 
ณ  Source:
ณ  -------
ณ  S_TIME.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION timeper( aFieldNames,aFieldDesc)

local aRanges
local nRangeType := 0
local nWeekStart
local expAsOf
local dStartingDate
local dEndingDate
local cRangeTxt  := "NONE SELECTED"

local cNumbFieldName := "", cNumbDesc := ""
local cDateFieldName := "", cDateDesc := ""
local nNumfLen,nNumfDec

local nOldCursor
local lOldExact
local aFieldTypes,aFieldLens, aFieldDeci
local aDateFields := {}, aDateDesc := {}
local aNumbFields := {}, aNumbDesc := {}
local nFields,nDateFields
local cInScreen,cOldColor
local nIndexOrd := indexord()
local nOldArea  := select()
local nMenuChoice
local nSelection
local i

nNumfLen      := 0
nNumfDec      := 0
cNumbFieldName := ""

IF VALTYPE(aFieldNames)+VALTYPE(aFieldDesc)<>"AA"
   nFields     := Fcount()
   aFieldNames := array(nFields)
   aFieldTypes := array(nFields)
   aFieldLens  := array(nFields)
   aFieldDeci  := array(nFields)
   aFieldDesc  := array(nFields)

   Afields(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
   Afields(aFieldDesc)
else
   nFields     := len(aFieldNames)
   aFieldTypes := array(nFields)
   aFieldLens  := array(nFields)
   aFieldDeci  := array(nFields)
   FILLARR(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)
endif

for i = 1 to nFields
  if aFieldTypes[i]=="D"
    aadd(aDateFields,aFieldNames[i])
    aadd(aDateDesc,aFieldDesc[i])
  elseif aFieldTypes[i]=="N"
    aadd(aNumbFields,aFieldNames[i])
    aadd(aNumbDesc,aFieldDesc[i])
  endif
next
if len(aDateFields) = 0
  msg("No DATE type fields in this datafile")
  RETURN ''
endif

* save screen,color
cOldColor  := setcolor(sls_normcol())
cInScreen  := savescreen(0,0,24,79)
lOldExact  := setexact(.t.)

*-- draw screen
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,09,50 BOX sls_frame()
@1,5 SAY '[Time Period Analysis]'
@20,1,23,78 BOX sls_frame()
@21,2 say "Analysis on dates contained in field  :"
@22,2 say "Sum/average values in numeric field   :"

SET INDEX TO
nOldCursor := iif(set(16)=0,.f.,.t.)
lOldExact  := setexact()

*-- Main Loop
DO WHILE .T.
  @21,43 say cDateDesc
  @22,43 say cNumbDesc
  *- indicate if query is active
  @2,60 SAY IIF(EMPTY(sls_query()),"[No Query    ]","[Query Active]")
  
  *- do a menu
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
                {02,3 ,"Range type =>"+"    "+padr(cRangeTxt,20)},;
                {03,3 ,"DATE field selection"},;
                {04,3 ,"NUMERIC field selection"},;
                {05,3 ,"Build Query"},;
                {06,3 ,"Perform Analysis"},;
                {07,3 ,"Quit"}},nMenuChoice)

  do case
  case nMenuChoice = 1  // range type
       aRanges := getrange(@nRangeType,@nWeekStart,@expAsof,;
                         @dStartingDate,@dEndingDate,@cRangeTxt)

       if aRanges==nil
         nRangetype := 0
         cRangeTxt := 'NONE SELECTED'
       endif
       cRangeTxt := padr(cRangetxt,13)
  case nMenuChoice = 2      // select date field
      nSelection := mchoice(aDateDesc,06,23,16,59,;
                    "[Select Date field to group on]")
      IF nSelection > 0
        cDateFieldName := aDateFields[nSelection]
        cDateDesc      := aDateDesc[nSelection]
        scroll(21,2,22,77,0)
        @21,2 say "Analysis on dates contained in field  :"
        @22,2 say "Sum/average values in numeric field   :"
      endif
  case nMenuChoice = 3
     nNumfLen      := 0
     nNumfDec      := 0
     cNumbFieldName := ""
     cNumbDesc      := ""
     if len(aNumbfields) > 0
          *- get numeric field for summing and averaging within periods
          *- ask for the numeric field to sum/average
          nSelection := mchoice(aNumbDesc,06,14,16,65,;
                      "Select Numeric Field for Time Period Analysis")
          IF nSelection > 0
            cNumbFieldName := aNumbFields[nSelection]
            cNumbDesc      := aNumbDesc[nSelection]
            scroll(21,2,22,77,0)
            @21,2 say "Analysis on dates contained in field  :"
            @22,2 say "Sum/average values in numeric field   :"
            nSelection := ascan(aFieldNames,cNumbFieldName)
            nNumfLen   := aFieldLens[nSelection]
            nNumfDec   := aFieldDeci[nSelection]
          ENDIF
     else
         msg("No numeric fields in this database")
     endif
  case nMenuChoice = 4     // build query
        QUERY(aFieldNames,aFieldDesc,aFieldTypes)
  case nMenuChoice = 5   .and. empty(cDateFieldName)
        msg("Select a DATE field for the analysis")
  case nMenuChoice = 5  .and.  nRangetype = 0
        msg("Select a Range Type for the analysis")
  case nMenuChoice = 5     // do the analysis
       doanalysis(aRanges,cDateFieldName,dStartingDate,dEndingDate,cNumbFieldName,nNumFDec,nWeekStart,nNumFLen)
       SET INDEX TO
       for i = 1 to len(aRanges)
         aRanges[i,ASTRUC_COUNT] := 0
         aRanges[i,ASTRUC_SUM  ] := 0
         aRanges[i,ASTRUC_AVG  ] := 0
       next
  case nMenuChoice = 6 .or. nMenuChoice = 0
       setcolor(cOldColor)
       setcursor(nOldCursor)
       setexact(lOldExact)
       restscreen(0,0,24,79,cInScreen)
       exit
  endcase
enddo
return nil


//---------------------------------------------------------------------
static function doanalysis(aRanges,cDateFieldName,dStartingDate,dEndingDate,;
                           cNumbFieldName,nNumfDec,nWeekStart,nNumFLen)
local bRangeQuery
local bQuery, bDateValue, bNumbValue
local cBox
local nCount  := 0
local i
local nElement

* Use Query ?
if !empty(sls_query())
  IF !messyn("Use query when selecting records ?","No","Yes")
    bQuery := sls_bquery()
  ENDIF
endif

bDateValue    := fieldblock(cDateFieldName)
if bQuery#nil
  bRangeQuery := {||eval(bDateValue)>=dStartingDate.AND.eval(bDateValue)<=dEndingDate.and. eval(bQuery) }
else
  bRangeQuery := {||eval(bDateValue)>=dStartingDate.AND.eval(bDateValue)<=dEndingDate}
endif
if !empty(cNumbfieldName)
  bNumbValue  := fieldblock(cNumbFieldName)
else
  bNumbValue  := {||0}
endif

GO TOP
cBox   := makebox(7,28,14,53)
@7,29 SAY '[Work in progress...]'

@9,30 SAY  "Filling target ranges.."
@10,30 SAY  "Working on record:"
@12,32 say ""
for i = 1 to recc()
  go i
  @12,30 SAY RECNO()
  ??' of '
  ??RECC()
  if eval(bRangeQuery)
    if (nElement := inrange( eval(bDateValue), aRanges )) > 0
      aRanges[nElement,ASTRUC_COUNT]++
      aRanges[nElement,ASTRUC_SUM]+=eval(bNumbValue)
    endif
  endif
  if inkey()=K_ESC
   EXIT
  endif
next
unbox(cBox)
IF !LASTKEY()=K_ESC
   IF !empty(cNumbfieldName)
     for i = 1 to len(aRanges)
       aRanges[i,5] := iif(aRanges[i,4]==0,0,;
                ROUND(aRanges[i,4]/aRanges[i,3],nNumfDec ) )
       //AEVAL(aRanges,{|e|e[5]:=iif(e[4]==0,0,ROUND(e[4]/e[3],nNumfDec ))} )
     next
   ENDIF

   showit(aRanges,nNumfDec,nNumFLen)
   IF !messyn("Send results to a permanent DBF file ?","No","Yes")
       sendtodbf(aRanges,cNumbFieldName,nNumfDec)
   endif
ELSE
   msg("Process aborted by user...")
   UNBOX(cBox)
endif
return nil


//-------------------------------------------------------
static function inrange(dValue,aRanges)
return ascan(aRanges,{|e|dValue>=e[1].and.dValue<=e[2]})


//---------------------------------------------------------------------
static function viewprog(nRecc, nRecno)
IF !EOF()
  @10,30 SAY INT(100*(nRecno/nRecc))
  ??"% done"
ENDIF
RETURN ''

//---------------------------------------------------------------------
static function getrange(nRangeType,nWeekStart,expAsof,;
                         dStartingDate,dEndingDate,cRangeTxt)
LOCAL lAborted   := .f.
LOCAL aRanges

LOCAL aDays := { "Sunday",;
                 "Monday",;
                 "Tuesday",;
                 "Wednesday",;
                 "Thursday",;
                 "Friday",;
                 "Saturday"}

* get type of range to work with
nRangeType  := menu_v("[Date range type:]",;
                "A By Week","B Week to Date","C By Month","D Month to Date",;
                "E By Year","F Year to date","G User defined","Q Quit                     ")
if nRangeType > 0 .and. nRangeType#8
   cRangeTxt := {"BY WEEK","WEEK TO DATE","BY MONTH","MONTH TO DATE",;
                "BY YEAR","YEAR TO DATE","USER DEFINED"}[nRangeType]

   IF nRangeType = BY_WEEK
       nWeekStart = mchoice(aDays,5,31,15,50,"[Week Starts On :]")
       IF nWeekStart = 0
         lAborted = .t.
       ENDIF
   ELSEIF nRangeType = BY_WEEKTD
     WHILE !lAborted
       nWeekStart := mchoice(aDays,5,31,15,50,"[Week Starts On :]")
       expAsOf    := DOW(DATE())
       expAsOf    := mchoice(aDays,5,31,15,55,"[Week to date as of :]")
       IF expAsOf = 0
         lAborted = .t.
       ELSEIF expAsOf < nWeekStart
         msg("As-of day is less than starting day")
         LOOP
       ELSE
         EXIT
       ENDIF
     END
   ELSEIF nRangeType = BY_MONTH
   ELSEIF nRangeType = BY_MONTHTD
       expAsOf := DAY(DATE())
       IF !asof("Month to date as of: ( 1-31 )","Invalid day",;
                @expAsOf,"",;
                {|d|!(d< 0 .OR. d> 31) } )
          lAborted := .t.
       ENDIF
   ELSEIF nRangeType = BY_YEAR
   ELSEIF nRangeType = BY_YEARTD
       expAsOf := DATE()
       IF !asof("Year to date as of:","Year is out of range for system",;
                @expAsOf,"",;
                {|d|!(YEAR(d)<1900 .OR. YEAR(d)>1999) } )
          lAborted := .t.
       ENDIF
   ELSEIF nRangeType = BY_USERDEF
     aRanges := userdates()
     if aRanges #nil
      // sort date range array by starting date element
      aRanges := asort(aRanges,,,{|x,y|x[1] < y[1]})
      dStartingDate := aRanges[1,1]
      dEndingDate   := atail(aRanges)[2]
     endif
   ENDIF
else
   lAborted := .t.
endif

* determine starting and ending range
WHILE !lAborted .and. nRangeType#BY_USERDEF .and. nRangeType#8
  dStartingDate := BOYEAR(DATE())
  dEndingDate   := DATE()
  popread(.F.,"Start Analysis on Date:",@dStartingDate,"",;
              "End Analysis on Date:  ",@dEndingDate,"")
  IF LASTKEY() = K_ESC
    lAborted = .t.
    exit
  ELSEIF EMPTY(dStartingDate) .OR. EMPTY(dEndingDate)
    msg("Need values in these fields")
  ELSEIF dStartingDate >= dEndingDate
    msg("Start date is greater than or equal to end date")
  ELSE
    aRanges := fillranges(nRangeType,@dStartingdDate,dEndingDate,nWeekStart,expAsOf)
    EXIT
  ENDIF
END
return aRanges

//-------------------------------------------------------
static function asof(cMsg,cErrMsg,expAsOf,cPict,bValid)
local lValid := .f.
WHILE .T.
  popread(.F.,cMsg,@expAsOf,cPict)
  IF LASTKEY() = K_ESC
    EXIT
  ELSEIF !EVAL(bValid,expAsof)
    msg(cErrMsg)
  ELSE
    lValid := .t.
    EXIT
  ENDIF
END
return lValid

//-------------------------------------------------------
static function fillranges(nRangeType,dStartingdDate,dEndingDate,nWeekStart,expAsof)
local aRanges := {}
LOCAL dThisStart,dThisEnd,dNextStart
local cBox := makebox(9,20,14,60)

* adjust beginning date to earlier first date in period in which it falls
DO CASE
CASE nRangetype = BY_WEEK .or. nRangetype = BY_WEEKTD
  IF DOW(dStartingDate) <> nWeekStart
    dStartingDate := dStartingDate-(DOW(dStartingDate)-nWeekStart)
  ENDIF
CASE nRangetype = BY_MONTH .or. nRangetype = BY_MONTHTD
  IF DAY(dStartingDate) <> 1
    dStartingDate := dStartingDate - (dStartingDate-1)
  ENDIF
CASE nRangetype = BY_YEAR .or. nRangetype = BY_YEARTD
  dStartingDate := BOYEAR(dStartingDate)
ENDCASE

* loop by periods, add elements till >= date()
dThisStart := dStartingDate
@10,30 say "For dates from "+dtoc(dStartingDate)
@11,30 say "            to "+dtoc(dEndingDate)
WHILE !(dThisStart > dEndingDate)
  DO CASE
  CASE nRangetype = BY_WEEK
    dThisEnd   := dThisStart+6
    dNextStart := dThisStart+7
  CASE nRangetype = BY_WEEKTD
    dThisEnd   := dThisStart+(expAsOf-DOW(dThisStart))
    dNextStart := dThisStart+7
  CASE nRangetype = BY_MONTH
    dThisEnd   := dThisStart+daysin(dThisStart)-1
    dNextStart := dThisEnd+1
  CASE nRangetype = BY_MONTHTD
    dThisEnd   := dThisStart+expAsOf-1
    dNextStart := dThisStart+daysin(dThisStart)
  CASE nRangetype = BY_YEAR
    dThisEnd   := DATECALC(dThisStart,1,4)-1
    dNextStart := dThisEnd+1
  CASE nRangetype = BY_YEARTD
    dThisEnd   := LEFT(DTOC(dThisStart),6)+;
                  RIGHT(TRANS(YEAR(dThisStart)+1,"9999"),2)
    dThisEnd   := CTOD(dThisEnd)-1
    dNextStart := DATECALC(BOYEAR(dThisStart),1,4)   // GET BEGINNING OF NEXT YEAR
    dNextStart := DATECALC(dNextStart,1,4)
  ENDCASE

  @12,30 say "Created range  "+dtoc(dThisStart)
  @13,30 say "           to  "+dtoc(dThisEnd)

  aadd(aRanges,{dThisStart,dThisEnd,0,0,0} )
  dThisStart = dNextStart
END
unbox(cBox)
RETURN aRanges


//----------------------------------------------------------

static FUNCTION userdates
local cPopBox := makebox(2,9,23,57)
local nChoice,dThisStart,dThisEnd
local aRanges  := {}
local nElement := 1
local nLastKey, nMouseR, nMouseC, nbutton,aButtons
local oTb      := tbrowsenew(5,28,18,54)
oTb:addcolumn(tbcolumnnew("Start Date  ",{||iif(len(aRanges)>0,aRanges[nElement,1],"(  none  )")}  ))
oTb:addcolumn(tbcolumnnew("End Date    ",{||iif(len(aRanges)>0,aRanges[nElement,2],"(  none  )")}  ))
oTb:skipblock := {|n|aaskip(n,@nElement,len(aRanges))}

@ 3,28 SAY "USER DEFINED RANGES"
@ 6,11 SAY  "[INS=add   ]  "
@ 8,11 SAY  "[DEL=delete]  "
@ 10,11 SAY "[ENTER=edit]"
@ 12,11 SAY "[F10=done  ]"
@ 14,11 SAY "[][][][]"
@ 16,11 SAY "[ESC=cancel]"
aButtons := {;
            {6,11,6,22,K_INS},;
            {8,11,8,22,K_DEL},;
            {10,11,10,22,K_ENTER},;
            {12,11,12,22,K_F10},;
            {16,11,16,22,K_ESC}}

@ 20,15 SAY "Add as many User Defined date ranges"
@ 21,21 SAY "as you like. Ranges will"
@ 22,15 SAY "be sorted by date before processing."

while .t.
  oTb:refreshall()
  while !oTb:stabilize()
  end
  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
  nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  do case
  case nLastKey = K_F10 .or. nButton==K_F10
     exit
  case (nLastKey = K_ENTER .or. nButton==K_ENTER ).and. len(aRanges) > 0
    popread(.t.,"Start Date",@dThisStart,"","End Date  ",@dThisEnd,"")
    IF EMPTY(dThisStart).OR.EMPTY(dThisEnd)
      msg("Need both dates filled in")
    ELSEIF (dThisStart) > (dThisEnd)
      msg("Starting date comes before ending date")
    ELSE
      aRanges[nElement] := {dThisStart,dThisEnd,0,0,0}
    ENDIF
  case nLastKey = K_INS  .or. nButton==K_INS
    dThisStart = CTOD('  /  /  ')
    dThisEnd = CTOD('  /  /  ')
    popread(.t.,"Start Date",@dThisStart,"","End Date  ",@dThisEnd,"")
    IF EMPTY(dThisStart).OR.EMPTY(dThisEnd)
      msg("Need both dates filled in")
    ELSEIF (dThisStart) > (dThisEnd)
      msg("Starting date comes before ending date")
    ELSE
      nElement := max(nElement,1)
      aadd(aRanges,"")
      ains(aRanges,nElement)
      aRanges[nElement] := {dThisStart,dThisEnd,0,0,0}
    ENDIF
  case (nLastKey = K_DEL .or. nButton==K_DEL ).and. len(aRanges) > 0
     adel(aRanges,nElement)
     nElement--
     oTb:rowpos := max(1,oTb:rowpos-1)
     asize(aRanges,len(aRanges)-1)
  case nLastKey = K_ESC .or. nButton==K_ESC
    aRanges := {}
    exit
  case nLastKey = K_UP
    oTb:up()
  case nLastKey = K_DOWN
    oTb:down()
  case nLastKey = K_LEFT
    oTb:left()
  case nLastKey = K_RIGHT
    oTb:right()
  case nLastKey == K_MOUSELEFT // mouse
    DO CASE
    CASE ISMOUSEAT(nMouseR, nMouseC, 14,11,14,13)
        oTb:up()
        IFMOUSEHD({||oTb:up()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC, 14,14,14,16)
        oTb:down()
        IFMOUSEHD({||oTb:down()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC, 14,17,14,19)
        oTb:right()
        IFMOUSEHD({||oTb:right()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC, 14,20,14,22)
        oTb:left()
        IFMOUSEHD({||oTb:left()},oTb)
    CASE MBRZCLICK(oTb,nMouseR, nMouseC)
      keyboard chr(K_ENTER)
    OTHERWISE
      MBRZMOVE(oTb,nMouseR,nMouseC,6,28,18,54)
    ENDCASE
  endcase
end
if empty(aRanges)
 aRanges := nil
endif
unbox(cPopBox)
return aRanges

//-----------------------------------------------
static function showit(aRanges,nNumfDec,nNumFLen)
local cBox := makebox(0,0,24,79,setcolor(),0,0)
local oTb      := tbrowsenew(1,1,23,78)
local nElement := 1
local nLastKey, nMouseR, nMouseC
local nWidth   := MAX(aLenMulti(aRanges,4), aLenMulti(aRanges,5) )
local cNumPict
@ 24,11 SAY "[][][][]"
nNumFLen := max(nNumFlen,nWidth)

cNumPict := iif(nNumFDec==0,repl("9",nNumFLen),;
                      stuff( repl("9",nNumFLen),nNumFlen-nNumFdec,1,"." ) )
if len(aRanges)> 0
    oTb:addcolumn(tbcolumnnew("Start Date  ",{||aRanges[nElement,1]}  ))
    oTb:addcolumn(tbcolumnnew("End Date    ",{||aRanges[nElement,2]}  ))
    oTb:addcolumn(tbcolumnnew(padl("Count",10),{||aRanges[nElement,3]}  ))
    oTb:addcolumn(tbcolumnnew(padl("Sum",nNumFlen),{||trans(aRanges[nElement,4],cNumPict)}  ))
    oTb:addcolumn(tbcolumnnew(padl("Average",nNumFlen),{||trans(aRanges[nElement,5],cNumPict)}  ))
    oTb:skipblock := {|n|aaskip(n,@nElement,len(aRanges))}
    oTb:headsep := "ฤ"



    @0,2 SAY '[Time Period Analysis Results]'
    @24,60 SAY '[ESCAPE=done]'
    while .t.
      while !oTb:stabilize()
      end
      nMouseR := 0; nMouseC := 0
      nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

      do case
      case nLastKey = K_F10 .or. nLastKey = K_ESC
         exit
      case nLastKey = K_UP
        oTb:up()
      case nLastKey = K_DOWN
        oTb:down()
      case nLastKey = K_LEFT
        oTb:left()
      case nLastKey = K_RIGHT
        oTb:right()
      case nLastKey = K_PGUP
        oTb:pageup()
      case nLastKey = K_PGDN
        oTb:pagedown()
      case nLastKey == K_MOUSELEFT // mouse
        DO CASE
        CASE ISMOUSEAT(nMouseR, nMouseC, 24,11,24,13)
            oTb:up()
            IFMOUSEHD({||oTb:up()},oTb)
        CASE ISMOUSEAT(nMouseR, nMouseC, 24,14,24,16)
            oTb:down()
            IFMOUSEHD({||oTb:down()},oTb)
        CASE ISMOUSEAT(nMouseR, nMouseC, 24,17,24,19)
            oTb:right()
            IFMOUSEHD({||oTb:right()},oTb)
        CASE ISMOUSEAT(nMouseR, nMouseC, 24,20,24,22)
            oTb:left()
            IFMOUSEHD({||oTb:left()},oTb)
        CASE ISMOUSEAT(nMouseR, nMouseC, 24,60,24,72)
            keyboard chr(K_ESC)
        OTHERWISE
          MBRZMOVE(oTb,nMouseR,nMouseC,6,28,18,54)
        ENDCASE
      endcase
    end
else
    msg("Nothing to show - no matches")
endif
unbox(cBox)
return nil

static function aLenMulti(aArray,nElement)
local i
local nSum := 0
for i = 1 to len(aArray)
  nsum+=aArray[i,nElement]
next
return len(alltrim(str(nSum)))
//-----------------------------------------------
static function sendtodbf(aRanges,cNumbFieldName,nNumfDec)
local i
local cDbfName
local lDone := .f.
local aStruc := { {"STARTDATE","D",8,0},;
                  {"ENDDATE  ","D",8,0},;
                  {"COUNT","N",aLenMulti(aRanges,3),0} }
local nOldArea := select()
select 0

IF !empty(cNumbfieldName)
     aadd(aStruc,{"SUM  ","N",aLenMulti(aRanges,4),nNumfDec} )
     aadd(aStruc,{"AVERAGE","N",aLenMulti(aRanges,5),nNumfDec} )
ENDIF
WHILE !lDone .and. len(aRanges) > 0
 cDbfName := space(8)
 popread(.F.,"Name of DBF to send this to:",@cDbfName,"@N")
 IF !(LASTKEY() = K_ESC .OR. EMPTY(cDbfName))
    cDbfName := Alltrim(cDbfName)
    cDbfName := UPPER(cDbfName)+".DBF"
    IF !FILE(cDbfName)
      DBCREATE(cDbfName,aStruc)
      USE (cDbfName)
      for i = 1 to len(aRanges)
         append blank
         field->startdate := aRanges[i,1]
         field->enddate   := aRanges[i,2]
         field->count     := aRanges[i,3]
         IF !empty(cNumbfieldName)
           field->sum       := aRanges[i,4]
           field->average   := aRanges[i,5]
         ENDIF
      next
      msg("Time Period Analysis copied to: "+cDbfName)
      lDone := .t.
    ELSE
      msg("Database "+cDbfName+" already exists - ","Use another name")
    ENDIF
 ELSEIF empty(cDbfName) .and. messyn("Name left blank - abandon process?")
    lDone := .t.
 ELSEIF lastkey()=K_ESC
    lDone := .t.
 ENDIF
END
USE
select (nOldArea)
return nil





