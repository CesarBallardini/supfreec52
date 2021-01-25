//------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DBSTATS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DBSTATS() Statistical report on dbf, including
ณ  sum/avg/min/max/std/var/count
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  DBSTATS()
ณ 
ณ  Description:
ณ  ------------
ณ  This is a point & shoot metafunction which allows the
ณ  user to get statistical data on a dbf, particularly with
ณ  numeric fields.
ณ 
ณ  Statistics available are: count, sum, average,
ณ  minimum, maximum, variance and standard deviation. the analysis
ณ  may also be based on a conditional criteria.
ณ 
ณ  Examples:
ณ  ---------
ณ   use (cDbfName)
ณ 
ณ   DBSTATS()    // its a menu driven metafunction
ณ 
ณ  Source:
ณ  -------
ณ  S_DBSTAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function dbStats
local i,nLast := 0
LOCAL nOldCursor     := setcursor(0)
LOCAL cInScreen      := Savescreen(0,0,24,79)
LOCAL cOldColor      := Setcolor(sls_normcol())
local nMenuChoice
local cFieldName     := ""
local nSum,nCount,nAverage,nMin,nMax,nVariance,nStd
local nNumerics := Counttype("N")
local lGroup1 := .f.
local lGroup2 := .f.
local bfilter := {||.t.}
local lUseQbe := .f.
local bEvalBlock1
local cBox
local nRecord

nSum:=nCount:=nAverage:=nMin:=nMax:=nVariance:=nStd :=0

if !used()
    MSG("Requires a DBF file to be open")
else
    nRecord := recno()
    *- draw boxes
    @0,0,24,79 BOX sls_frame()
    Setcolor(sls_popcol())
    @1,1,12,40 BOX sls_frame()
    @20,1,23,78 BOX sls_frame()
    @1,5 SAY '[Database Statistics]'
endif
DO WHILE USED()
  @21,5 say "Numeric Field    :"+padr(iif(empty(cFieldName),"None",cFieldName),10)
  @22,5 say "Use Filter       :"+iif(lUseQbe,"YES","NO ")

  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
                    {03,3 ,"Numeric Field  "},;
                    {04,3 ,"Select Stats   "},;
                    {05,3 ,"Filter         "},;
                    {06,3 ,"Go             "},;
                    {07,3 ,"Quit"}},nMenuChoice)
  Setcolor(sls_popcol())

  DO CASE
  CASE nMenuChoice = 0 .or. nMenuChoice = 5
    exit
  CASE nMenuChoice = 1
    nSum:=nCount:=nAverage:=nMin:=nMax:=nVariance:=nStd :=0
    if nNumerics > 0
      lGroup2 := .f.
      lGroup1 := .f.
      cFieldName := mFieldsType("N","Numeric Field")
      if !empty(cFieldName)
        lGroup2 := .t.
        lGroup1 := .t.
      endif
    else
      msg("No NUMERIC fields in this DBF", "COUNT is the only available stat")
    endif
  CASE nMenuChoice = 2 .AND. !EMPTY(cFieldName) // select stats
    nSum:=nCount:=nAverage:=nMin:=nMax:=nVariance:=nStd :=0
    statsel(@lGroup1,@lGroup2)
  CASE nMenuChoice = 2
    msg("No field selected yet - only COUNT is active")
  CASE nMenuChoice = 3
    if messyn("Set Query?")
      QUERY()
      if !empty(sls_query())
        bFilter := sls_bquery()
        lUseQbe := .t.
      else
        bFilter := {||.t.}
        lUseQbe := .f.
      endif
    else
      bfilter := {||.t.}
      lUseQbe := .f.
    endif
  CASE nMenuChoice = 4 // go
     nMin :=  1000000000
     nMax := -1000000000
     lGroup2 := iif(empty(cFieldName),.f.,lGroup2)
     lGroup1 := iif(empty(cFieldName),.f.,lGroup1)
     go top
     if (lGroup1 .or. lGroup2)
       if MESSYN("Include where "+cFieldName+" is zero?")
         bEvalBlock1 := {||nCount++,nSum+=FIELDGET(FIELDPOS(cFieldName)),;
                         nMin:=Min(nMin,FIELDGET(FIELDPOS(cFieldName))),;
                         nMax:=Max(nMax,FIELDGET(FIELDPOS(cFieldName)))}
       else
         bEvalBlock1 := {||iif(FIELDGET(FIELDPOS(cFieldName))<>0,(nCount++,nSum+=FIELDGET(FIELDPOS(cFieldName)),;
                         nMin:=Min(nMin,FIELDGET(FIELDPOS(cFieldName))),;
                         nMax:=Max(nMax,FIELDGET(FIELDPOS(cFieldName)))),nil)}
       endif
     else
       bEvalBlock1 := {||nCount++}
     endif
     cBox := makebox(6,21,14,50)
     @ 7,23 SAY "First Pass"
     @ 10,23 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
     @ 11,23 SAY "ณ record                 ณ"
     @ 12,23 SAY "ณ of                     ณ"
     @ 13,23 SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
     @12,32 SAY TRANS(RECC(),"9999999999")
     DBEVAL(bEvalBlock,bFilter,{||showhile(11,32,"9999999999")})
     if lGroup1 .or. lGroup2  //----04-02-1993
       nAverage := nSum/nCount
     endif
     if lGroup2
       go top
       bEvalBlock  := {||nVariance += ;
                    ( (nAverage-FIELDGET(FIELDPOS(cFieldName)) )^2 )}
       @ 11,23 SAY "ณ record                 ณ"
       @ 7,23 SAY "Second Pass"
       DBEVAL(bEvalBlock,bFilter,{||showhile(11,32,"9999999999")})
       nVariance := nVariance/nCount
       nStd      := sqrt(nVariance)
     endif
     unbox(cBox)
     showstats(nCount,nSum,nAverage,nMin,nMax,nVariance,nStd,lGroup1,lGroup2)
     nSum:=nCount:=nAverage:=nMin:=nMax:=nVariance:=nStd :=0
  ENDCASE
END
if !empty(nRecord)
    dbgoto(nRecord)
endif
Restscreen(0,0,24,79,cInScreen)
Setcolor(cOldColor)
setcursor(nOldCursor)
return nil
//----------------------------------------------------
static function SHOWHILE(nrow,nCol,cPict)
@nrow,nCol say trans(recno(),cPict)
return .t.


//------------------------------------------------------
static FUNCTION CountType(cType)
local nMatches   := 0
local aFieldList := dbstruct()
local i
cType := upper(cType)
for i = 1 to len(aFieldList)
  if aFieldList[i,2]==cType
    nMatches++
  endif
next
RETURN nMatches

//------------------------------------------------------
static function statsel(lGroup1,lGroup2)
local cBox := makebox(4,22,16,53)
local getlist := {}
@ 5,24 SAY "Select Statistics"
@ 6,47 SAY "Y/N"
@ 8,24 SAY "Sum,Average    "
@ 9,24 SAY " Minimum,Maximum....."

@ 12,24 SAY "Variance,Standard"
@ 13,24 SAY " Deviation.........."

@9,47   get lGroup1 pict "Y"
@13,47  get lGroup2 pict "Y"
@16,24 say "[OK]"
set cursor on
rat_read(getlist,1,.f.,27,{|r,c|checkok(r,c)})
set cursor off
unbox(cBox)
return nil

//--------------------------------------------------------------
#INCLUDE "inkey.ch"
static proc checkok(r,c)
if r==16 .and. c>=24 .and.c<= 27
  keyboard chr(K_PGDN)
endif
return

//------------------------------------------------------
static function showstats(nCount,nSum,nAverage,nMin,nMax,nVariance,nStd,lGroup1,lGroup2)
local cBox := makebox(4,22,18,65)
@ 5,24 SAY "Selected Statistics"
@ 8,24 SAY "Count................"
IF lGroup1
   @ 9,24 SAY "Sum.................."
   @ 10,24 SAY "Average.............."
   @ 11,24 SAY "Minimum.............."
   @ 12,24 SAY "Maximum.............."
   @9,47  say PADL(STR(nSum),15)
   @10,47 say PADL(STR(nAverage),15)
   @11,47 say PADL(STR(nMin),15)
   @12,47 say PADL(STR(nMax),15)
endif
if lGroup2
   @ 13,24 SAY "Variance............."
   @ 14,24 SAY "Standard Deviation..."
   @13,47 say PADL(STR(nVariance),15)
   @14,47 say PADL(STR(nStd),15)
endif
@8,47  say padl(str(nCount),15)
@17,24 SAY "[press a key]"

rat_event(0)
unbox(cBox)
return nil


//------------------------------------------------------


