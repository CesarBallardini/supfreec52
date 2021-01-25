
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#define MAXNEST  3

static aFields,aFdesc,aFtypes

static nNested   := 0
static lMultiple := .f.
static cExpDesc
static aActions
static aStack := {}
static cThisExpress := ""
static cThisType   := "C"
static lTypeChange := .f.
static nLeft       := 0

static cDateSkel


//==========================================================

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BUILDEX()                           *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BUILDEX() Interactively builds and returns an expression string
ณ 
ณ  Returns:
ณ  --------
ณ  <cExpression> => An expandable expression string
ณ 
ณ  Syntax:
ณ  -------
ณ  BUILDEX(cDescript,cStart,lTypeChange,[aFields,aDesc])
ณ 
ณ  Description:
ณ  ------------
ณ  Interactively builds and returns an expression string.
ณ 
ณ  Pass parameters of <cDescript> - a descriptive name
ณ  for the expression, <cStart> an existing expression
ณ  (field,etc.),
ณ 
ณ  <lTypeChange> allow TYPE change by BUILDEX()
ณ 
ณ  Pass all or none of the following arrays
ณ 
ณ  [aFields]   An array of field names
ณ 
ณ  [aDesc]     An array of field descriptions
ณ 
ณ  Examples:
ณ  ---------
ณ   cExpress :=buildex("Index Expression",COMPANY,.F.)
ณ 
ณ  Notes:
ณ  ------
ณ  Release 3.5 adds the ability to directly edit the expression.
ณ 
ณ 
ณ  Source:
ณ  -------
ณ  S_BUILD.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION buildex( cExpname,cInExpress,lInTypeChange,aInFields,aInFdesc )

EXTERNAL STUFF, Ljust, Rjust, allbut, subplus, startsw, Stod, crunch, strtran
EXTERNAL centr, PROPER, doyear, womonth, woyear, trueval, dtow
EXTERNAL endswith, dtdiff, daysin, datecalc, begend, nozdiv, stretch, arrange

local nStackCount  := 0
local aExpStack    := {}
local aTypeStack   := {}
local cIntype
local cUnderbox
local nMainChoice
local nfieldCount
local lDone := .f.
local nOldCursor
local cReturn
local getlist := {}
local cUns, cSaveExp, cCheckType, bF2, bF3,bF4, aButtons

aadd(aStack,{cThisExpress,cThisType,lTypeChange,nLeft})

cExpDesc    := cExpName
ltypeChange := iif(lInTypeChange#nil,lInTypeChange,.t.)

if valtype(aInFields)<>"A"
     nfieldCount:= fcount()
     aFields := array(nfieldCount)
     aFdesc  := array(nfieldCount)
     afields(aFields)
     afields(aFdesc)
else
     nfieldCount:= aleng(aInfields)
     aFields := array(nfieldCount)
     aFdesc  := array(nfieldCount)
     acopy(aInFields,aFields)
     acopy(aInFdesc,aFdesc)
endif
aFtypes := array(nfieldCount)
fillarr(aFields,aFtypes)

if !empty(cInExpress)
   cInType := &cInExpress
   cInType := VALTYPE(cInType)
else
   cInType := "C"
endif

IF cInType=="L" .OR. (!USED())
  RETURN cInExpress
ENDIF

nNested         := MIN(nNested+1,MAXNEST)
lMultiple       := (nNested< MAXNEST)
cDateSkel       := set(_SET_DATEFORMAT)
nLeft           := 4+(nNested*2)
nOldCursor      := setcursor(1)
cThisExpress    := cInExpress
nStackCount     := 0
cThisType       := UPPER(cInType)
if nNested%2<>0
    cUnderBox       := makebox(2,nLeft,23,nLeft+50,sls_popcol())
else
    cUnderBox       := makebox(2,nLeft,23,nLeft+50,sls_normcol())
endif

cUns := takeout(setcolor(),",",5)

@3,nLeft+1 SAY centr(stretch("EXPRESSION BUILDER",'๙',1),49)
@3,nLeft+50-3 say "("+alltrim(str(nNested))+")"
@4,nLeft+1 TO 4,nLeft+49 DOUBLE
@20,nLeft+1 TO 20,nLeft+49 DOUBLE

DO WHILE !lDone
    cThisExpress := alltrim(cThisExpress)
    @21,nLeft+2 SAY "Working on ["+cExpDesc+"]"
    @22,nLeft+2 say padr(trim(cThisExpress),46) color cUns

    *- clear box and display expression name and type
    Scroll(5,nLeft+1,19,nLeft+49,0)


    *- fill arrays appropriately for TYPE
    aActions := MakeMainMenu(cthistype)

    *- get selection
    nMainChoice:= sachoice(5,nLeft+1,19,nLeft+49,aActions)
    if nMainChoice == 0
      loop
    endif
    Scroll(5,nLeft+1,18,nLeft+49,0)
    nMainChoice :=iif(nMainChoice==0,1,nMainChoice)   // handle ESC
    *- say the action to be done
    @5,nLeft+2 SAY aActions[nMainChoice]
    @6,nLeft+2 TO 6,nLeft+46

    DO CASE
    CASE nMainChoice == len(aActions)
      cThisExpress := alltrim(formulate(cThisExpress,aFields,aFDesc,"Edit Expression"))
    CASE nMainChoice < 2
      lDone:= .T.
    CASE nMainChoice = 2
      BrowseExpress()
    CASE nMainChoice = 3  .AND. nStackCount > 0
      nStackCount--
      asize(aExpStack,nStackCount)
      asize(aTypeStack,nStackCount)
      cThisExpress:= IIF(nStackCount> 0,aExpStack[nStackCount],cInExpress)
      cThisType:= IIF(nStackCount>0,aTypeStack[nStackCount],cInType)
    CASE nMainChoice = 4
      @7,nLeft+1 SAY " An EXPRESSION here is any combination of:"
      @ROW()+1,nLeft+1 SAY  ""
      @ROW()+1,nLeft+1 SAY  " - FIELDS     values from the current datafile"
      @ROW()+1,nLeft+1 SAY  " - OPERATORS  i.e. + - * /"
      @ROW()+1,nLeft+1 SAY  " - CONSTANTS  typed in by the user"
      @ROW()+1,nLeft+1 SAY  " - FUNCTIONS  a sort of 'extended' operator "
      @ROW()+1,nLeft+1 SAY  "              i.e. UPPER() makes uppercase       "
      @ROW()+1,nLeft+1 SAY  ""
      @ROW()+1,nLeft+1 SAY  " As an example, the database field LASTNAME may"
      @ROW()+1,nLeft+1 SAY  " be EXPRESSED as LEFT(LASTNAME,5) which takes the"
      @ROW()+1,nLeft+1 SAY  " left 5 characters, or as LASTNAME+FNAME which"
      @ROW()+1,nLeft+1 SAY  " combines the fields LASTNAME and FNAME."
      rat_event(0)
    CASE cThisType == "C"
      IF GetCharExpr(nMainChoice)
        nStackCount++
        aadd(aExpStack,cThisExpress)
        aadd(aTypeStack,cThisType)
      ENDIF
    CASE cThisType == "D"
      IF GetDateExpr(nMainChoice)
        nStackCount++
        aadd(aExpStack,cThisExpress)
        aadd(aTypeStack,cThisType)
      ENDIF
    CASE cThisType == "N"
      IF GetNumeExpr(nMainChoice)
        nStackCount++
        aadd(aExpStack,cThisExpress)
        aadd(aTypeStack,cThisType)
      ENDIF
    ENDCASE
    
  
ENDDO
SET KEY 27 TO
setcursor(nOldCursor)
cInType  := cThisType
nNested--

cReturn      := cThisExpress
cThisExpress := atail(aStack)[1]
cThisType    := atail(aStack)[2]
lTypeChange  := atail(aStack)[3]
nLeft        := atail(aStack)[4]
asize(aStack,len(aStack)-1)
lMultiple       := (nNested< MAXNEST)
unbox(cUnderBox)
RETURN cReturn


//===========================================================
static FUNCTION GetCharExpr(nChoice)

local lCool        := .f.
LOCAL nLenExp      := LEN(&cThisExpress)
LOCAL cLenExp      := Alltrim(STR(nLenExp))
local getlist      := {}
local aSubAction   := {}
local nSubchoice   := 0

local cLeftRight,nCharCount,cCharCount,nStartPos,cStartPos,nNewPos,;
      cNewPos,cExtractSay,cHoldParam,nExtractMore,nAddIns,cTypeIn
local cTypeIn2,n2ndfield,c2ndExp,cPicture,nIter



while .t.

   DO CASE
   CASE nChoice = 5
      aSubAction:={ "Left  <x> characters",;
                    "Right <x> characters",;
                    "Everything but right <x> characters"}

     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     endif

     DO CASE
     CASE nSubChoice = 1 .OR. nSubChoice = 2
       cLeftRight  := {"LEFT","RIGHT"}[nSubChoice]
       nCharCount  := (nLenExp-1)
       @8,nLeft+2 SAY "How many characters from the "+cLeftright+"? ";
         GET nCharCount PICT REPL("9",LEN(cLenExp))
       @10,nLeft+2 SAY "(Expression is "+cLenExp+" characters long.)"
       IF !BXREAD(getlist)
         exit
       ENDIF
       cCharCount  := Alltrim(STR(ABS(nCharCount)))
       cThisExpress:= cLeftRight+'('+cThisExpress+','+cCharCount+')'
     CASE nSubChoice = 3
       nCharCount:= (nLenExp-1)
       @9 ,nLeft+2 SAY "(Maximum "+cLenExp+")"
       @8,nLeft+2 SAY "How many characters from the right? ";
         GET nCharCount PICT REPL("9",LEN(cLenExp))
       IF !BXREAD(getlist)
         exit
       ENDIF
       *- check for > 0 and < full length
       IF nCharCount > 0 .AND. nCharCount < nLenExp
         cCharcount:= Alltrim(STR(nCharCount))
         cThisExpress:= 'ALLBUT('+cThisExpress+','+cCharCount+')'
       ENDIF
     ENDCASE
   CASE nChoice = 6
     aSubAction:={"Left justify","Right justify","Center in <x> spaces"}
     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     endif

     DO CASE
     CASE nSubChoice = 1
       cThisExpress:= 'LJUST('+cThisExpress+')'
     CASE nSubChoice = 2
       cThisExpress:= 'RJUST('+cThisExpress+')'
     CASE nSubChoice = 3
       nCharCount := nLenExp
       @8,nLeft+2 SAY  "Total width ? " ;
         GET nCharCount PICT REPL("9",LEN(cLenExp))
       @10,nLeft+2 SAY "(ENTER for current)"
       IF !BXREAD(getlist)
         exit
       ENDIF
       IF nCharCount > 0
         cCharcount  := Alltrim(STR(nCharCount))
         cThisExpress:= 'PADC('+cThisExpress+','+cCharCount+')'
       ELSE
         cThisExpress:= 'PADC('+cThisExpress+')'
       ENDIF
     ENDCASE
   CASE  nChoice = 7
     aSubAction := {"Uppercase","Lowercase","Proper (cap first)"}
     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     endif
     DO CASE
     CASE nSubChoice = 1
       cThisExpress:= 'UPPER('+cThisExpress+')'
     CASE nSubChoice = 2
       cThisExpress:= 'LOWER('+cThisExpress+')'
     CASE nSubChoice = 3
       cThisExpress:= 'PROPER('+cThisExpress+')'
     ENDCASE

   CASE  nChoice = 8
     aSubAction   := {"Move all spaces to right end of string",;
                      "Move all but single spaces to right end" }
     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     Endif
     DO CASE
     CASE nSubChoice = 1
       cThisExpress:= 'CRUNCH('+cThisExpress+',0)'
     CASE nSubChoice = 2
       cThisExpress:= 'CRUNCH('+cThisExpress+',1)'
     ENDCASE
   CASE  nChoice = 9
     aSubAction   := {"Add to Left side ","Add to Right side " }
     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     Endif
     nAddIns:= 1
     aSubAction  := {"Type in characters",;
                     "Use <x> copies of character <y>"}
     IF lMultiple
        asize(aSubAction,3)
            aSubAction[3]:= "Build a secondary expression"
     ENDIF

     IF (nAddIns := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     Endif

     DO CASE
     CASE nAddins = 1 .OR. nAddIns = 2
       IF nAddins = 1
         ctypeIn := SPACE(20)
         @8,nLeft+2 SAY "Type in characters to add: "
         @9,nLeft+2 GET cTypeIn
         IF !BXREAD(getlist)
           exit
         ENDIF
         cTypeIn:= IIF(EMPTY(TRIM(cTypeIn))," ",TRIM(cTypeIn))
       ELSE
         cTypeIn    := " "
         nCharCount := 1
         @8,nLeft+2 SAY "Character to use        " ;
           GET cTypeIn
         @9,nLeft+2 SAY "Number of characters    " ;
           GET nCharCount PICT "99"
           IF !BXREAD(getlist)
             exit
           ENDIF
          cTypeIn := REPL(cTypeIn,nCharCount)
       ENDIF
       DO CASE
       CASE nSubChoice = 1
         cThisExpress:= '("'+cTypeIn+'"+'+cThisExpress+')'
       CASE nSubChoice = 2
         cThisExpress:= '('+cThisExpress+'+"'+cTypeIn+'")'
       ENDCASE
     CASE nAddins = 3
       n2ndField  := GetFieldFromList("C")
       IF EMPTY(n2ndField)
         exit
       ELSE
         c2ndExp  := buildex(cExpDesc,aFields[n2ndField],.F.,aFields,aFdesc)
       ENDIF
       IF !EMPTY(c2ndExp)
         cThisExpress := '('+cThisExpress+'+'+c2ndExp+')'
       ENDIF
     ENDCASE
   CASE  nChoice = 10
     cTypeIn  := SPACE(30)
     ctypeIn2 := SPACE(30)
     @8,nLeft+2 SAY "(use ~ for spaces)"
     @9,nLeft+2 SAY   "Text to look for    :   " GET cTypeIn PICT "@S20"
     IF !BXREAD(getlist)
       exit
     ENDIF
     IF !EMPTY(cTypeIn)
       cTypeIn  := TRIM(cTypeIn)
       cTypeIn  := STRTRAN(cTypeIn,"~"," ")
       cTypeIn2 := SPACE(LEN(cTypeIn))
       cPicture := LTRIM(TRANS(LEN(cTypeIn2),"99"))

       @11,nLeft+2 SAY "(use ~ for spaces)"
       @12,nLeft+2 SAY "Text to replace with:" GET cTypeIn2 PICT "@S"+cPicture
       IF !BXREAD(getlist)
         exit
       ENDIF
       cTypeIn2    := STRTRAN(cTypeIn2,"~"," ")
       cThisExpress:= 'STRTRAN('+cThisExpress+',"'+cTypeIn+'","'+cTypeIn2+'")'
     ENDIF
   CASE  nChoice = 11
     aSubAction   := { "First set of numbers to NUMERIC result",;
                       "All numbers to NUMERIC result",;
                       "Convert to date from "+cDateSkel+" or YYYMMDD form" }

     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     Endif
     cThisType:= "N"
     DO CASE
     CASE nSubChoice = 1
       cThisExpress := 'VAL('+cThisExpress+')'
     CASE nSubChoice = 2
       cThisExpress := 'TRUEVAL('+cThisExpress+')'
     CASE nSubChoice = 3
       aSubAction   := {"Convert from form "+cDateSkel+" to date",;
                         "Convert from form YYYYMMDD to date"}
       IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
         exit
       Endif
       IF nSubChoice = 1
         cThisExpress:= 'CTOD('+cThisExpress+')'
       ELSEIF nSubChoice = 2
         cThisExpress:= 'STOD('+cThisExpress+')'
       ENDIF
       cThisType:= "D"
     ENDCASE
   ENDCASE

   lCool := .t.   // must be OK
   exit

enddo
RETURN lCool


//------------------------------------------------------------------
static FUNCTION GetDateExpr(nChoice)
local lCool := .f.
local aSubAction := {}
local nSubChoice, cPeriodType, nPlusOrMinus, cPlusOrMinus, nBegEnd
local cBegEnd, nWkMoQtr, nIter, nDayOfWeek,nDayWkMoYr,cDayWkMoYr
local dDate, nDateField, c2ndExp
local getlist := {}

while .t.
    DO CASE
    CASE nChoice = 5
      aSubAction   :={ "Days   plus or minus","Weeks  plus or minus",;
                      "Months plus or minus","Years  plus or minus" }
      IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif

      cPeriodType  := Alltrim(STR(nSubChoice))
      @9 ,nLeft+2 SAY "(enter a '-' for minus)"
      nPlusOrMinus := 0
      @8,nLeft+2 SAY "Plus or minus #"+LEFT(aSubAction[nSubChoice],6)+':' ;
        GET nPlusOrMinus PICT "99999"
      IF !BXREAD(getlist)
        exit
      ENDIF

      cPlusOrMinus := Alltrim(STR(nPlusOrMinus))
      DO CASE
      CASE nPlusOrMinus = 0
        exit
      OTHERWISE
        cThisExpress:= 'DATECALC('+cThisExpress+','+cPlusOrMinus+','+cPeriodType+')'
      ENDCASE

    CASE nChoice = 6
      nBegEnd := 1
      asize(aSubAction,2)
      aSubAction   := {"Beginning of ","End of "}

      IF (nBegEnd := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      cBegEnd  := aSubAction[nBegEnd]
      nWkMoQtr := 1
      aSubAction    := {"Week    - "+cBegEnd,;
                        "Month   - "+cBegEnd,;
                        "Quarter - "+cBegEnd }

      IF (nWkMoQtr := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif

      IF nWkMoQtr = 1
        aSubAction := array(7)
        FOR nIter = 1 TO 7
          aSubAction[nIter]:= CDOW( DATE()+(7-DOW(DATE()))  +nIter)
        NEXT
        @ 8,nLeft+2 SAY cBegEnd+" week falls on :"
        IF (nDayofWeek:= BXMENU2(aSubAction,10,nLeft+2) ) == 0
          exit
        Endif
        nDayOfWeek:= MAX(1,nDayOfWeek)
      ENDIF
      Scroll(7,nLeft+2,16,nLeft+49,0)
      cThisExpress:= 'BEGEND('+cThisExpress+','+Alltrim(STR(nBegEnd))+','+;
                     Alltrim(STR(nWkMoQtr))+;
                     IIF(nWkMoQtr=1,','+Alltrim(STR(nDayOfWeek))+')',')')

    CASE nChoice = 7
      asize(aSubAction,3)
      aSubAction   := {"Week  (1-7)  ","Month (1-31) ","Year  (1-356) "}
      IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      DO CASE
      CASE nSubChoice = 1
        cThisExpress:= 'DOW('+cThisExpress+')'
      CASE nSubChoice = 2
        cThisExpress:= 'DAY('+cThisExpress+')'
      CASE nSubChoice = 3
        cThisExpress:= 'DOYEAR('+cThisExpress+')'
      ENDCASE
      cThisType:= "N"
    CASE nChoice = 8
      aSubAction    := {"Month (1-5)", "Year  (1-52)"}
      IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      DO CASE
      CASE nSubChoice = 1
        cThisExpress:= 'WOMONTH('+cThisExpress+')'
      CASE nSubChoice = 2
        cThisExpress:= 'WOYEAR('+cThisExpress+')'
      ENDCASE
      cThisType:= "N"
    CASE nChoice = 9
      cThisExpress:= 'MONTH('+cThisExpress+')'
      cThisType:= "N"
    CASE nChoice = 10
      cThisExpress:= 'YEAR('+cThisExpress+')'
      cThisType:= "N"
    CASE nChoice = 11
      aSubAction   := {"Date  ie.    [Jan 1, 1989]",;
                       "Month  ie .  [January]",;
                       "Weekday  ie. [Thursday]" }
      IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      DO CASE
      CASE nSubChoice = 1
        cThisExpress:= 'DTOW('+cThisExpress+')'
      CASE nSubChoice = 2
        cThisExpress:= 'CMONTH('+cThisExpress+')'
      CASE nSubChoice = 3
        cThisExpress:= 'CDOW('+cThisExpress+')'
      ENDCASE
      cThisType:= "C"
    CASE nChoice = 12
      aSubAction   := {cDateSkel, "yyyymmdd"}
      IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      DO CASE
      CASE nSubChoice = 1
        cThisExpress:= 'DTOC('+cThisExpress+')'
      CASE nSubChoice = 2
        cThisExpress:= 'DTOS('+cThisExpress+')'
      ENDCASE
      cThisType:= "C"
    CASE nChoice = 13
      nDayWkMoYr := 1
      aSubAction   := {"DAYS   - number of whole days between",;
                       "WEEKS  - number of whole weeks between",;
                       "MONTHS - number of whole months between",;
                       "YEARS  - number of whole years between" }
      IF (nDayWkMoYr := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      cDayWkMoYr := Alltrim(STR(nDayWkMoYr))
      nSubChoice:= 1
      aSubAction   := {"Compare to Current date", "Type in a date"}
      IF lMultiple
        asize(aSubAction,3)
        aSubAction[3]:= "Use secondary date expression"
      ENDIF

      IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
        exit
      Endif
      DO CASE
      CASE nSubChoice = 1
        cThisExpress:= 'DTDIFF('+cThisExpress+',date(),'+cDayWkMoYr+')'
      CASE nSubChoice = 2
        dDate:= CTOD("  /  /  ")
        @8,nLeft+2 SAY "Date to compare =>" GET dDate
        IF !BXREAD(getlist)
          exit
        ENDIF
        cThisExpress:= 'DTDIFF('+cThisExpress+',CTOD("'+DTOC(dDate)+'"),'+cDayWkMoYr+')'
      CASE nSubChoice = 3
        nDateField:= GetFieldFromList("D")
        IF nDateField > 0
          c2ndExp =  buildex(cExpDesc,aFields[nDateField],.F.,aFields,aFdesc)
          IF !EMPTY(c2ndExp)
            cThisExpress:= 'DTDIFF('+cThisExpress+','+c2ndExp+','+cDayWkMoYr+')'
          ENDIF
        else
          exit
        ENDIF
      ENDCASE
      cThisType:= "N"
    ENDCASE
    lCool := .t.
    exit
enddo
RETURN lCool

//------------------------------------------------------------------
static function GetNumeExpr(nChoice)

local lCool := .f.
local aSubAction := {}
local nSubChoice, nAction, cTypeIn, nTypeIn, nField, cPicture
local getlist := {}

while .t.
   DO CASE
   CASE nChoice = 5
     aSubAction   := {"Plus a value ",;
                      "Minus a value",;
                      "Multiplied by a value",;
                      "Divided by a value",;
                      "Divided into value"}
     IF (nSubChoice := BXMENU2(aSubAction,8,nLeft+2) ) == 0
       exit
     Endif
     IF nSubChoice > 0
       @9,nLeft+2 SAY aSubAction[nSubChoice]
       nAction = 1
       IF lMultiple
         asize(aSubAction,2)
         aSubAction   := {"Type in a value","Build secondary expression"}
         IF (nAction    := BXMENU2(aSubAction,8,nLeft+2) ) == 0
           exit
         Endif
       ENDIF
       IF nAction = 1
         cTypeIn:= SPACE(15)
         @8 ,nLeft+2 SAY "Value: " ;
           GET cTypeIn PICT "###############"
         IF !BXREAD(getlist)
           exit
         ENDIF
         cTypeIn:= Alltrim(cTypeIn)
       ELSEIF nAction = 2
         nField := GetFieldFromList("N")
         IF nField > 0
           cTypeIn= buildex(cExpDesc,aFields[nField],.F.,aFields,aFdesc)
         else
           exit
         ENDIF
       ENDIF
       IF !EMPTY(cTypeIn)
         DO CASE
         CASE nSubChoice = 1
           cThisExpress:= '('+cThisExpress+'+'+cTypeIn+')'
         CASE nSubChoice = 2
           cThisExpress:= '('+cThisExpress+'-'+cTypeIn+')'
         CASE nSubChoice = 3
           cThisExpress:= '('+cThisExpress+'*'+cTypeIn+')'
         //CASE nSubChoice = 4 .AND. !(VAL(cTypeIn)=0)
         CASE nSubChoice = 4
           //cThisExpress:= '('+cThisExpress+'/'+cTypeIn+')'
           cThisExpress:= '('+cThisExpress+'/NOZDIV('+cTypeIn+'))'
         CASE nSubChoice = 5
           cThisExpress:= '(('+cTypeIn+')/NOZDIV('+cThisExpress+'))'
         ENDCASE
       ENDIF
     ENDIF
   CASE nChoice = 6
     nTypeIn:= 0
     @8,nLeft+2 SAY "Rounded to how many decimals (0-9) :" ;
       GET nTypeIn PICT "99"
     IF !BXREAD(getlist)
       exit
     ENDIF
     IF nTypeIn >= 0
       cTypeIn:= Alltrim(TRANS(nTypeIn,"99"))
       cThisExpress:= 'ROUND('+cThisExpress+','+cTypeIn+')'
     ENDIF

   CASE nChoice = 7
     cThisExpress:= 'INT('+cThisExpress+')'
   CASE nChoice = 8
     cThisExpress:= 'ABS('+cThisExpress+')'
   CASE nChoice = 9
     Scroll(5,nLeft+2,18,nLeft+49,0)
     cPicture:= SPACE(20)
     @6,nLeft+2 SAY "Picture: " ;
       GET cPicture
     @ROW()+2,nLeft+3 SAY "  9   A number"
     @ROW()+1,nLeft+3 SAY "  .   Position of the decimal point."
     @ROW()+1,nLeft+3 SAY "  ,   Inserts a comma "
     @ROW()+1,nLeft+3 SAY "  *   Inserts asterisks for leading blanks."
     @ROW()+1,nLeft+3 SAY "  $   Inserts $ signs for leading blanks."
     @ROW()+1,nLeft+3 SAY "  @(  Encloses negatives in parentheses."
     @ROW()+1,nLeft+3 SAY "  @B  Left justifies numbers."
     @ROW()+1,nLeft+3 SAY "  @C  Displays CR after a positive number."
     @ROW()+1,nLeft+3 SAY "  @X  Displays DB after a negative number."
     @ROW()+1,nLeft+3 SAY "  @Z  Displays spaces instead of zeros if =0"
     IF !BXREAD(getlist)
       exit
     ENDIF
     cThisExpress := 'TRANS('+cThisExpress+',"'+Alltrim(cPicture)+'")'
     cThisType  := "C"
   ENDCASE
   lCool := .t.
   exit
enddo
RETURN lCool

//------------------------------------------------------------------
static PROC BrowseExpress
local nCurrRec, expActual, cResult
local nLastKey, nMouseR, nMouseC
local getlist := {}
local oTb, bExpress

Scroll(5,nLeft+1,19,nLeft+49,0)
@5,nLeft+2 SAY  'Sample output from expression when '
@6,nLeft+2 SAY  'compared to current datafile record'
@7 ,nLeft+1 TO 7 ,nLeft+49
@17 ,nLeft+1 TO 17 ,nLeft+49
nCurrRec:= RECNO()
bExpress    := &("{||"+cThisExpress+"}")

oTb         := TbrowsedB(8 ,nLeft+2,16,nLeft+49)
oTb:addcolumn(tbcolumnNew(nil,bExpress))

devpos(19,nLeft+2)
devout("[][]  [ENTER=Done]")
while .t.

  while !oTb:stabilize()
  end

  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

  do case
  CASE nLastKey = K_UP          && UP ONE ROW
     oTb:UP()
  CASE nLastKey = K_DOWN        && DOWN ONE ROW
    oTb:DOWN()
  CASE nLastKey = K_PGUP        && UP ONE PAGE
    oTb:PAGEUP()
  CASE nLastKey = K_HOME        && HOME
    oTb:GOTOP()
  CASE nLastKey = K_PGDN        && DOWN ONE PAGE
    oTb:PAGEDOWN()
  CASE nLastKey = K_END         && END
    oTb:GOBOTTOM()
  CASE nLastKey = K_ENTER       && ENTER
    exit
  CASE nLastKey = K_ESC
    EXIT
  case nLastKey == K_MOUSELEFT
    DO CASE
    CASE ISMOUSEAT(nMouseR, nMouseC,19,nLeft+2,19,nLeft+4)
        oTb:Up()
        IFMOUSEHD({||oTb:up()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,19,nLeft+5,19,nLeft+7 )
        oTb:down()
        IFMOUSEHD({||oTb:down()},oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,19,nLeft+10,19,nLeft+21 )  // [Enter]
        exit
    OTHERWISE
        MBRZMOVE(oTb,nMouseR,nMouseC,8 ,nLeft+2,16,nLeft+49)
    ENDCASE
  endcase

ENDDO
RETURN


//------------------------------------------------------------------
static FUNCTION MakeMainMenu(cType)
local aAction := array(15)
local nSize, i

aAction[1]      :=  "QUIT         and return current expression"
aAction[2]      :=  "TEST         against database (WYSIWYG)"
aAction[3]      :=  "UNDO         last change"
aAction[4]      :=  "HELP         help with expression builder"
DO CASE
CASE cType  == "C"
  aAction[5]    :=  "EXTRACT      subset or rearrange"
  aAction[6]    :=  "JUSTIFY      left right centered"
  aAction[7]    :=  "CASE         uppercase lowercase proper"
  aAction[8]    :=  "MOVE         spaces to end of string"
  aAction[9]    :=  "ADD          or imbed characters"
  aAction[10]   := "SUBSTITUTE   one value for another"
  nSize         := 10
  IF lTypeChange
    aAction[11] := "DIFFERENT    change to date or numeric"
    nSize       := 11
  ENDIF
CASE cType  == "D"
  aAction[5]    := "PLUS         + or - days, weeks, months, years"
  aAction[6]    := "END          or start of week,month,quarter"
  nSize:= 6
  IF lTypeChange
    aAction[7]  :=  "DAY          of week-month-year as number"
    aAction[8]  :=  "WEEK         of month,year as number"
    aAction[9]  :=  "MONTH        of year as number"
    aAction[10] :=  "YEAR         as number"
    aAction[11] :=  "AS WORDS     day, month, full date"
    aAction[12] := "CHARACTER    as "+cDateSkel+" or yyyymmdd"
    aAction[13] := "BETWEEN      days/weeks/months/yrs between dates"
    nSize       := 13
  ENDIF
  
CASE cType  == "N"
  aAction[5]    :=  "CALCULATION  (plus minus multiply divide)"
  aAction[6]    :=  "ROUNDED      to <x> decimals"
  aAction[7]    :=  "WHOLE        decimals cut off, no rounding"
  aAction[8]    :=  "ABSOLUTE     absolute value ignoring sign (-+)"
  nSize         := 8
  IF lTypeChange
    aAction[9]  :=  "DIFFERENT    converted to character type"
    nSize       := 9
  ENDIF
OTHERWISE
  nSize        := 4
ENDCASE
nSize++
asize(aAction,nSize)
aAction[nSize] := "EDIT         directly edit the expression"
for i = 1 to len(aAction)
 aAction[i] := padr(aAction[i],46)
next
RETURN aAction

//------------------------------------------------------------------
static FUNCTION GetFieldFromList(cForcetype,lKeyboard)
LOCAL nFieldSel,cUnderBox, aJustF, i, aButtons, bMouse, nRow
LOCAL cScreen := MAKEBOX(5,nLeft,21,nLeft+50)
lKeyboard := iif(lKeyboard#nil,lKeyboard,.f.)
@7,nLeft+2 SAY "SELECT FIELD TO START"
@8,nLeft+2 to 8, nLeft+48
@18,nLeft+2 to 18, nLeft+48
aJustF := array(len(aFDesc) )
for i = 1 to len(aJustF)
  aJustF[i] := padr(aFDesc[i],48)
next
@19,nLeft+2  say "[ENTER=Done]"
@19,nLeft+16 say "[ESC=Cancel]"
aButtons := {{19,nLeft+2,19,nLeft+13,{||kbdkey(K_ENTER)}},;
             {19,nLeft+16,19,nLeft+27,{||kbdkey(K_ESC)}}}
bMouse := {|r,c|checkbtns(aButtons,r,c)}
nFieldSel := 1
nrow  := 1
DO WHILE .T.
  nFieldSel := sachoice(9,nLeft+1,17,nLeft+48,aJustf,nil,nFieldSel,@nRow,19,nLeft+31,bMouse)
  if nFieldSel > 0
    IF !aFtypes[nFieldSel]$cForcetype
      msg("Must be of type "+cForcetype)
    ELSE
      EXIT
    ENDIF
  else
    EXIt
  endif
ENDDO
if lKeyboard .and. nFieldSel > 0
  keyboard aFields[nFieldSel]
endif
UNBOX(cScreen)
RETURN nFieldSel




//------------------------------------------------------------------
STATIC PROC KBDKEY(nKey)
keyboard chr(nKey)

//------------------------------------------------------------------
static function checkbtns(aButtons,r,c)
local i
local nFound := 0
for i = 1 to len(aButtons)
  if r >= aButtons[i,1] .and. r<=aButtons[i,3] .and. ;
     c >= aButtons[i,2] .and. c<=aButtons[i,4] .and. valtype(aButtons[i,5])=="B"
     eval(aButtons[i,5])
  endif
next
return nil

//------------------------------------------------------------------
static function bxmenu2(aOptions,nRow,nCol)
local aRats := array(len(aOptions))
local i,nRowRowRow := nRow
local nReturn := 0
for i = 1 to len(aOptions)
  aRats[i] := {nRowRowRow,nCol,aOptions[i] }
  nRowRowRow++
next
aadd(aRats,{nRowRowRow,nCol,"Cancel"})
nReturn := RAT_MENU2(aRats)
nReturn := iif(nReturn=len(aRats),0,nReturn)
Scroll(5,nLeft+2,18,nLeft+49,0)
if nReturn > 0
   @5,nLeft+2 SAY padr(aOptions[nReturn],46)
   @6,nLeft+2 TO 6,nLeft+46
endif
return nReturn

//------------------------------------------------------------------
static function bxread(aGetList)
local aButtons
@19,nLeft+2  say "[ENTER=Done]"
@19,nLeft+16 say "[ESC=Cancel]"
aButtons := {{19,nLeft+2,19,nLeft+13,{||kbdkey(K_ENTER)}},;
             {19,nLeft+16,19,nLeft+27,{||kbdkey(K_ESC)}}}
rat_read(aGetlist,1,.f.,27,{|r,c|checkbtns(aButtons,r,c)} )
return (lastkey()#27)

//------------------------------------------------------------------
