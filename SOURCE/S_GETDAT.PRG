
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GETDATE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  GETDATE() Point and shoot calendar
ณ 
ณ  Returns:
ณ  --------
ณ  <dSelect> => date selected
ณ 
ณ  Syntax:
ณ  -------
ณ  GETDATE([dStart])
ณ 
ณ  Description:
ณ  ------------
ณ  Allows user to point to and select a date [dStart]
ณ  optional date parameter to start with. If no date passed, system
ณ  date is used.
ณ 
ณ  Examples:
ณ  ---------
ณ   set key -1 to GETDATE
ณ 
ณ  NOTES:
ณ  -------
ณ  See also CALENDWHEN(), CALENDVALID(), CALENDKSET()
ณ 
ณ  Source:
ณ  -------
ณ  S_GETDAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION getdate(dStartDate)

local cInfoBox,cCalBox,dCalcDate,dGlobDate,nLastkey,dOldDate
local nOldRow,nOldCol,nOldCursor, dTest, lSkipCase
local nMouseR, nMouseC, aButtons, nButton
local aColumns := {12,16,20,24,28,32,36}

dispbegin()
dOldDate := SET_DATE(1)
nOldRow  := row()
nOldCol    := col()
nOldCursor := SETCURSOR(0)

cInfoBox   := makebox( 3,48,19,76,sls_popcol())
@  4,53 SAY  "  AVAILABLE KEYS  "
@  5,50 SAY "[      Next Day      ]"
@  6,50 SAY "[      Previous Day  ]"
@  8,50 SAY "[ HOME   First of Month]"
@  9,50 SAY "[ END    End of Month  ]"
@ 11,50 SAY "[      Next Week     ]"
@ 12,50 SAY "[      Previous Week ]"
@ 14,50 SAY "[ PGDN   Next Month    ]"
@ 15,50 SAY "[ PGUP   Previous Month]"
@ 16,50 SAY "[ ENTER  Select Date   ]"
@ 17,50 SAY "[ ESC    Quit Calendar ]"
aButtons := {;
            {  5,50,5,73,K_RIGHT},;
            {  6,50,6,73,K_LEFT},;
            {  8,50,8,73,K_HOME},;
            {  9,50,9,73,K_END},;
            { 11,50,11,73,K_DOWN},;
            { 12,50,12,73,K_UP},;
            { 14,50,14,73,K_PGDN},;
            { 15,50,15,73,K_PGUP},;
            { 16,50,16,73,K_ENTER},;
            { 17,50,17,73,K_ESC} }



cCalBox  := makebox( 2, 8,20,40,sls_popcol())
@  3,10 TO 19, 38 DOUBLE
@  5,10 SAY 'วฤฤฤยฤฤฤยฤฤฤยฤฤฤยฤฤฤยฤฤฤยฤฤฤถ'
@  7,10 SAY 'วฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤถ'
@  8,11 SAY  '   ณ   ณ   ณ   ณ   ณ   ณ'
@  9,10 SAY 'วฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤถ'
@ 10,11 SAY  '   ณ   ณ   ณ   ณ   ณ   ณ'
@ 11,10 SAY 'วฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤถ'
@ 12,11 SAY  '   ณ   ณ   ณ   ณ   ณ   ณ'
@ 13,10 SAY 'วฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤถ'
@ 14,11 SAY  '   ณ   ณ   ณ   ณ   ณ   ณ'
@ 15,10 SAY 'วฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤถ'
@ 16,11 SAY  '   ณ   ณ   ณ   ณ   ณ   ณ'
@ 17,10 SAY 'วฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤถ'
@ 18,11 SAY  '   ณ   ณ   ณ   ณ   ณ   ณ'
@ 19,10 SAY 'ศอออฯอออฯอออฯอออฯอออฯอออฯอออผ'

Setcolor(sls_popcol())
@  6,11 SAY  'SUNณMONณTUEณWEDณTHUณFRIณSAT'

IF VALTYPE(dStartDate)<>"D"
  dStartDate := DATE()
ELSE
  IF EMPTY(dStartDate)
    dStartDate := DATE()
  ENDIF
ENDIF
dCalcDate := dStartDate
dGlobDate := CTOD("  /  /  ")
dGlobDate := drawmonth(dCalcDate,dGlobDate,aColumns)

dispend()

DO WHILE .T.
  lSkipCase := .f.
  nLastKey := rat_event(0,.f.)
  nMouseR  := rat_eqmrow()
  nMouseC  := rat_eqmcol()
  nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  IF nButton # 0
     nLastKey := nButton
  ELSEIF nLastKey == K_MOUSELEFT
    if (dTest := clickto(dCalcDate,nMouseR, nMouseC))#dCalcDate
       dCalcDate := dTest
       lSkipCase := .t.
    elseif nMouseR== ( 6+(2*((DAY(dCalcDate)+;
                   (7-DOW(dCalcDate))+(DOW(bom(dCalcDate))-1)) /7)))
      if nMouseC>= aColumns[DOW(dCalcDate)]-1 .and. ;
                nMouseC <= aColumns[DOW(dCalcDate)]+1
         nLastKey := K_ENTER
      endif
    endif
  ENDIF
  DO CASE
  CASE lSkipCase
  CASE nLastkey = K_ESC
    dCalcDate := dStartDate
    EXIT
  CASE nLastkey = K_ENTER
    EXIT
  CASE nLastkey = K_RIGHT
    dCalcDate := datecalc(dCalcDate,1,1)
  CASE nLastkey = K_LEFT
    dCalcDate := datecalc(dCalcDate,-1,1)
  CASE nLastkey = K_PGDN
    dCalcDate := datecalc(dCalcDate,1,3)
  CASE nLastkey = K_PGUP
    dCalcDate := datecalc(dCalcDate,-1,3)
  CASE nLastkey = K_UP
    dCalcDate := datecalc(dCalcDate,-1,2)
  CASE nLastkey = K_DOWN
    dCalcDate := datecalc(dCalcDate,1,2)
  CASE nLastkey = K_HOME
    dCalcDate := bom(dCalcDate)
  CASE nLastkey = K_END
    dCalcDate := bom(datecalc(dCalcDate,1,3))- 1
  OTHERWISE
    tone(100,2)
  ENDCASE
  dGlobDate := drawmonth(dCalcDate,dGlobDate,aColumns)
ENDDO

unbox(cCalBox)
unbox(cInfoBox)
DEVPOS(nOldRow,nOldCol)
SETCURSOR(nOldCursor)
SET_DATE(dOldDate)
RETURN(dCalcDate)

static function clickto(dOldDate,nMouseR, nMouseC)
local nColumn, nColDiff, nRowDiff, nThisrow, nThisCol
local dTestDate, dReturnDate
local aColumns := {{11,12,13},{15,16,17},{19,20,21},;
                   {23,24,25},{27,28,29},{31,32,33},{35,36,37} }
dReturnDate := dOldDate
if ISPART(nMouseR,8,10,12,14,16,18)
  if (nColumn := ;
     ASCAN(aColumns, {|e|e[1]==nMouseC.or.e[2]==nMouseC.or.;
         e[3]==nMouseC} ) ) > 0

    nThisRow := row()
    nThisCol := {12,16,20,24,28,32,36}[DOW(dOldDate)]
    nThisCol := ASCAN({12,16,20,24,28,32,36},nThisCol)

    nColDiff := nColumn-nThisCol
    nRowDiff := nMouseR-nThisRow
    nRowDiff := iif(nRowDiff#0,nRowDiff/2,0)

    dTestDate := DATECALC(dOldDate,(nRowDiff*7)+nColDiff,1)

    if MONTH(dTestDate)==MONTH(dOldDate)
      dReturnDate := dTestDate
    endif
  endif
endif
return dReturnDate

//====================================================
static FUNCTION drawmonth(dWorkDate,dOldDate,aColumns)
local nIter,nCurrentRow,nDayOfWeek,nWeek
local nDaysin
local getlist := {}
local nDayOfMonth

DISPBEGIN()

IF (MONTH(dOldDate) # MONTH(dWorkDate))     // if we have changed months

  @4,11 SAY padc(CMONTH(dWorkDate)+;
        "  "+STR(YEAR(dWorkDate),4) ,25)

  IF !EMPTY(dOldDate)                      // this clears out the
                                           // columns, if there was
                                           // a prior date month drawn
    FOR nWeek = 8 TO 18 STEP 2
      for nIter = 1 TO 7
        @  nWeek, aColumns[nIter] SAY '  '
      NEXT
    NEXT
  ENDIF
  

  nDaysin     := daysin(dWorkDate)        // # days in the month
  nDayOfWeek  := DOW(bom(dWorkDate))      // day of week which first
                                          // day of the month is on

  nCurrentRow := 8                        // start at row 8

  FOR nIter = 1 TO nDaysin                // display the days of
                                          // the month, starting with
                                          // nDayofWeek as figured above
                                          // and using the aColumns
                                          // column values to determine
                                          // the column

    @ nCurrentRow,aColumns[nDayOfWeek] SAY TRANS(nIter,"99")


    // if last day draw was a
    // Saturday (7), increase
    // to next row, and wrap
    // day around to 1 (Sunday)
    IF nDayOfWeek=7
      nCurrentRow := nCurrentRow+2
      nDayOfWeek  := 1
    ELSE
      nDayOfWeek++
    ENDIF


  NEXT
ELSE
  // same month, just draw old date unhilited
  nDayOfWeek   := DOW(dOldDate)                 // get day of the week
  nCurrentRow  :=  6+(2*((DAY(dOldDate)+;       // figure row
                    (7-DOW(dOldDate))+(DOW(bom(dOldDate))-1)) /7))
  @ nCurrentRow,aColumns[nDayOfWeek] SAY TRANS(day(dOldDate) ,"99")
ENDIF

nDayOfWeek = DOW(dWorkDate)                     // new date day of week
nCurrentRow =  6+(2*((DAY(dWorkDate)+;          // new date row
               (7-DOW(dWorkDate))+(DOW(bom(dWorkDate))-1)) /7))
nDayOfMonth := day(dWorkDate)                   // day of the month
@ nCurrentRow,aColumns[nDayOfWeek] ;            // draw new date hilited
    say trans(nDayOfMonth,"99") color subst(setcolor(),rat(",",setcolor())+1)
getlist := {}
DISPEND()
RETURN dWorkDate



*: EOF: S_GETDAT.PRG

