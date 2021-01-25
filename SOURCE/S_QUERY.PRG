
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
static aFieldNames,aFieldDesc,aFieldTypes
static aCharFields,aNumFields,aDateFields,aLogFields
static nFieldCount
static cThisExpression  := ""
static cThisFldType  := ""
static cThisOperator := ""
static cThisAndOr    := ""
static cThisCompare  := ""
static nLongestDesc  := 0
static lUseBuildex


/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION QUERY()
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
³ 
³  Short:
³  ------
³  QUERY() Popup Interactive query by example condition
³  builder
³ 
³  Returns:
³  --------
³  <cQuery> => macro expandable logical condition
³  expression
³ 
³  Syntax:
³  -------
³  QUERY([aFields,aDesc,aTypes],[cQuitTo],[lUseBuildex])
³ 
³  Description:
³  ------------
³  A point and shoot condition builder. Complex
³  conditions are allowed with multiple .and./.or. Called without
³  parameters, all fields in the current dbf are presented for condition
³  building.
³ 
³  [aFields,aDesc,aTypes] give field array, field
³  description and field types.These, if passed will be used in
³  place of the default of all dbf fields. (pass all or none)
³ 
³  [cQuitTo] is a 'quit to' phrase. Default exit option
³  is 'Quit'. 'Quit to' phrase will be tacked to the end of this .
³  i.e. "Quit"+quit_to  [ Quit to Report Writer ]
³ 
³  [lUseBuildex] determines whether BUILDEX() expression
³  builder will be available from QUERY(). Default is not.
³ 
³  Examples:
³  ---------
³   USE CUSTOMER
³ 
³   aFields := {"fname", "lname",  "mi" }
³   aFdesc  := {"First", "Last",  "Middle" }
³   aTypes  := {"C","C","C"}
³   cFilt   := QUERY(aFields,aFdesc,aTypes,nil,.t.)
³ 
³   count for &cFilt  to nCount
³ 
³   // or (preferably)
³   count for eval( sls_bquery() ) to nCount
³ 
³  Notes:
³  -------
³  Query always stores the current query with the
³  function SLS_QUERY(). Calling SLS_QUERY() will return the
³  currently stored query string. SLS_BQUERY() returns the query as
³  a codeblock. Remember to clear sls_query()/sls_bquery() when
³  changing DBFs.
³ 
³  Source:
³  -------
³  S_QUERY.PRG
³ 
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
*/
FUNCTION QUERY(cInFieldNames,cInFieldDesc,cInFieldTypes,cQuitPhrase,lUseBx)

local cOldQuery   := sls_query()
local nMainSelect := 1
local cOldcolor   := setcolor(sls_normcol())
local cUnder      := savescreen(0,0,maxrow(),maxcol())
local nOldcursor  := setcursor()
local lOldexact   := setexact()
local nOldarea    := SELECT()
local nAtRecord   := RECNO()
local cQueryFile  := slsf_query()+".DBF"
local cQDescription := ""

lUseBuildex := iif(lUseBx#nil,lUseBx,.f.)

EXTERNAL _wildcard
CTOD("")

IF !( VALTYPE(cInFieldNames)+VALTYPE(cInFieldDesc)+VALTYPE(cInFieldTypes))=="AAA"
  nFieldCount := Fcount()+1
  aFieldNames := array(nFieldCount)
  aFieldDesc  := array(nFieldCount)
  aFieldTypes := array(nFieldCount)
  Afields(aFieldNames,aFieldTypes)
  Afields(aFieldDesc)
ELSE
  nFieldCount := aleng(cInFieldNames)+1
  aFieldNames := array(nFieldCount)
  aFieldDesc  := array(nFieldCount)
  aFieldTypes := array(nFieldCount)
  Acopy(cInFieldNames,aFieldNames)
  Acopy(cInFieldDesc,aFieldDesc)
  Acopy(cInFieldTypes,aFieldTypes)
ENDIF
AINS(aFieldNames,1)
AINS(aFieldDesc,1)
AINS(aFieldTypes,1)
aFieldNames[1] :="DELETED()"
aFieldDesc[1]  :="< Deleted? >"
aFieldTypes[1] :="L"
nLongestDesc   := bigelem(aFieldDesc)

IF !(VALTYPE(cQuitPhrase)=="C")
  cQuitPhrase := ""
ENDIF
SET EXACT ON

*- build field-type arrays
buildtypes()


*- draw the screen
Setcolor(sls_popcol())
@3,15,18,50 BOX sls_frame()
@3,16 SAY '[Online Query Builder]'
*- main loop
DO WHILE .T.
  *- go to the beg of file each loop
  GO TOP
  
  *- save the query each loop
  cOldQuery := sls_query()
  IF !EMPTY(sls_query())
    @17,18 say 'Query Active    '
  ELSE
    @17,18 say 'No Query Active '
  ENDIF
  *- do the menu
  Setcolor(sls_popmenu())
  nMainSelect := RAT_MENU2({;
                            {5,18 ,"Build a new Query"},;
                            {6,18 ,"Add to current query"},;
                            {7,18 ,"Count matching records"},;
                            {8,18 ,"Zap (remove) existing Query"},;
                            {9,18 ,"Save current Query to disk"},;
                            {10,18,"Restore Query from disk"},;
                            {11,18,"Delete stored queries"},;
                            {12,18,"What is current Query"},;
                            {13,18,"Edit current Query"},;
                            {14,18,"View records matching Query"},;
                            {15,18,"Quit "+cQuitPhrase}},nMainSelect)
  Setcolor(sls_popcol())
  
  *- do the selected action
  DO CASE
  CASE nMainSelect == 1 .OR. (nMainSelect == 2 .AND. !EMPTY(sls_query()) )
      *- build or add to query
      IF nMainSelect == 1
        *- clear query expr, and/or var
        cThisAndOr:= ""
        sls_query("")
        BUILDQUERY()
      ELSEIF GETANDOR()
        BUILDQUERY()
      ENDIF
      *- if after all that the query_exp is empty, restore the old query
      IF EMPTY(Alltrim(sls_query()))
        sls_query(cOldQuery)
      ELSE
        sls_bquery( &("{||"+sls_query()+"}")  )
      ENDIF
  CASE nMainSelect = 3  .AND. !EMPTY(sls_query())
      COUNTQUERY()
  CASE nMainSelect = 4
      *- init the query string to ''
      sls_query("")
      sls_bqzap()
  CASE nMainSelect = 5 .AND. !EMPTY(sls_query())
      cQDescription := PUTQUERY(cQDescription)
  CASE nMainSelect = 6
      cQDescription := GETQUERY()
      if !empty(sls_query())
        sls_bqzap()
        sls_bquery( &("{||"+sls_query()+"}")  )
      endif
  CASE nMainSelect = 7
      PURGEQ()
  CASE nMainSelect = 8
      msg("Current QUERY ",SUBST(sls_query(),1,60), ;
                           SUBST(sls_query(),61,60),;
                           SUBST(sls_query(),121,60),;
                           SUBST(sls_query(),181,60))
  CASE nMainSelect = 9
      EDITQUERY()
      if !empty(sls_query())
        sls_bqzap()
        sls_bquery( &("{||"+sls_query()+"}")  )
      endif
  CASE nMainSelect = 10 .AND. !EMPTY(sls_query())
      VIEWQUERY()
  CASE nMainSelect = 11  .OR. nMainSelect = 0
      *- restore the various environment elements as found
      SELE (nOldarea)
      IF nAtRecord > 0
        GO nAtRecord
      ENDIF
      Restscreen(0,0,maxrow(),maxcol(),cUnder)
      Setcolor(cOldColor)
      setexact(lOldexact)
      setcursor(nOldcursor)
      if !empty(sls_query())
        sls_bqzap()
        sls_bquery( &("{||"+sls_query()+"}")  )
      endif
      *- pass back the query string
      RETURN sls_query()
  ENDCASE
ENDDO

aFieldNames := nil
aFieldDesc  := nil
aFieldTypes := nil
aCharFields := nil
aNumFields  :=  nil
aDateFields := nil
aLogFields  := nil
nFieldCount := nil
cThisExpression  := nil
cThisFldType  := nil
cThisOperator := nil
cThisAndOr    := nil
cThisCompare  := nil
nLongestDesc  := nil
lUseBuildex   := nil

return nil

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION GETAFIELD
local cUnder,nRight
local nSelection,expActual

nRight := MAX(45+MAX(23,MIN(31,nLongestDesc))+1,65)
cUnder := makebox(7,45,22,nRight,sls_popmenu())
devpos(22,nRight - 6)
devout("[][]")
@7,46 SAY '[Database Field List]'
@20,46 TO 20,nRight-1
@21,47 SAY "ENTER to select "
AADD(aFieldDesc,"<Create Formula>")
nSelection := SACHOICE(8,47,19,nRight-1,aFieldDesc,;
                        nil,nil,nil,22,nRight-6,{||KBDESC()})
ASIZE(aFieldDesc,len(aFieldNames))
unbox(cUnder)

*- determine the return value
if nSelection = len(aFieldDesc)+1
  cThisExpression := FORMULATE("",aFieldNames,aFieldDesc,;
         "Create Formula/User Defined field for query ")
  if empty(cThisExpression)
    nSelection := 0
  else
    cThisExpression := "("+cThisExpression+")"
    cThisFldType    := realtype(cThisExpression)
  endif
else
  cThisExpression := IIF(nSelection > 0,aFieldNames[nSelection],'')
  cThisFldType    := IIF(nSelection > 0,aFieldTypes[nSelection],'')
endif
IF lUseBuildex .AND. nSelection > 0 .AND. (!cThisFldType$"ML")
  IF !messyn("Extend field "+cThisExpression+" with EXPRESSION BUILDER ?","No","Yes")
    cThisExpression := BUILDEX("Complex Expression for QUERY",;
                       cThisExpression,.t.,;
                       ACOPY(aFieldNames,ARRAY(nFieldCount),2),;
                       ACOPY(aFieldDesc,ARRAY(nFieldCount),2))
    expActual       := &cThisExpression
    cThisFldType    := VALTYPE(expActual)
  ENDIF
ENDIF
*- return a value
RETURN !(EMPTY(cThisExpression))


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION GetOperator
local aOperators := BUILDOP()
local nLongest   := bigelem(aOperators[1])
local nRight,nBottom
local cUnder,nSelection

nRight  := MAX(45+nLongest+2,63)
nBottom := 6+len(aOperators[1])+2
cUnder  := makebox(6,45,nBottom,nRight,sls_popmenu())
devpos(nBottom,nright - 6)
devout("[][]")
@8,46 SAY '[Pick Operation]'
nSelection := SACHOICE(7,46,nBottom-1,nRight-1,aOperators[1],;
                       nil,nil,nil,nBottom,nRight-6,{||KBDESC()})
unbox(cUnder)
cThisOperator = IIF(nSelection > 0, Alltrim(aOperators[2,nSelection]),'')
RETURN !EMPTY(cThisOperator)


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
static FUNCTION BUILDOP
IF cThisFldType=="M"
  RETURN { {"$   (CONTAINS)","E   (IS EMPTY)","N   (IS NOT EMPTY)"},;
           {"$","E","N"} }
ELSEIF cThisFldType == "L"
  RETURN { {"T   True/Yes","F   False/No"},{"=","#"} }
ELSEIF cThisFldType == "N"
  RETURN { {;
            "=   (EXACTLY EQUAL TO)",;
            "<>  (NOT EQUAL TO)",;
            "<   (LESS THAN)",;
            ">   (GREATER THAN)",;
            "<=  (LESS THAN OR EQUAL TO)",;
            ">=  (GREATER OR EQUAL TO)";
           },{"=","<>","<",">","<=",">="} }
ELSEIF cThisFldType == "D"
  RETURN { {;
            "=   (EXACTLY EQUAL TO)",;
            "<>  (NOT EQUAL TO)",;
            "<   (LESS THAN)",;
            ">   (GREATER THAN)",;
            "<=  (LESS THAN OR EQUAL TO)",;
            ">=  (GREATER OR EQUAL TO)";
           },{"=","<>","<",">","<=",">="} }
ELSEIF cThisFldType == "C"
  RETURN { {;
            "=   (EXACTLY EQUAL TO)",;
            "<>  (NOT EQUAL TO)",;
            "<   (LESS THAN)",;
            ">   (GREATER THAN)",;
            "<=  (LESS THAN OR EQUAL TO)",;
            ">=  (GREATER OR EQUAL TO)",;
            "$   (CONTAINS)",;
            "!$  (DOES NOT CONTAIN)",;
            "?*  (WILDCARD MATCH)",;
            "S   (IS SIMILAR TO)",;
            "B   (BEGINS WITH)",;
            "E   (ENDS WITH)";
           },{"==","<>","<",">","<=",">=","$","!$","?","QL","B","E"}}
ENDIF
RETURN ''



//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
static FUNCTION buildtypes
local nCounter
aCharFields := {}
aNumFields  := {}
aDateFields := {}
aLogFields  := {}
FOR nCounter = 1 TO nFieldCount
  DO CASE
  CASE aFieldTypes[nCounter] == "C"
    AADD(aCharFields,aFieldNames[nCounter])
  CASE aFieldTypes[nCounter] == "N"
    AADD(aNumfields,aFieldNames[nCounter])
  CASE aFieldTypes[nCounter] == "D"
    AADD(aDatefields,aFieldNames[nCounter])
  CASE aFieldTypes[nCounter] == "L"
    AADD(aLogfields,aFieldNames[nCounter])
  ENDCASE
NEXT
return nil



//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION OTHERFIELD
local aThis,nSelection
DO CASE
CASE cThisFldType == "C"
  nSelection   := mchoice(aCharFields,5,30,15,60,'[Pick Field]')
  cThisCompare := IIF(nSelection = 0, '',aCharFields[nSelection])
CASE cThisFldType == "N"
  nSelection   := mchoice(aNumfields,5,30,15,60,'[Pick Field]')
  cThisCompare := IIF(nSelection = 0, '',aNumfields[nSelection])
CASE cThisFldType == "D"
  nSelection   := mchoice(aDatefields,5,30,15,60,'[Pick Field]')
  cThisCompare := IIF(nSelection = 0, '',aDatefields[nSelection])
CASE cThisFldType == "L"
  nSelection   := mchoice(aLogfields,5,30,15,60,'[Pick Field]')
  cThisCompare := IIF(nSelection = 0, '',aLogfields[nSelection])
ENDCASE
RETURN !EMPTY(cThisCompare)

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STATIC FUNCTION GETANDOR
local cUnder
local nSelection := 1

*- draw the box, do the menu, close the box
cUnder = makebox(8,45,14,58,sls_popmenu())
nSelection := RAT_MENU2({;
                        {09,47 ,'DONE'},;
                        {10,47 ,'AND'},;
                        {11,47 ,'OR '},;
                        {12,47 ,'AND NOT'},;
                        {13,47 ,'OR NOT'}},1,.t.,{||KBDESC()})
nSelection := max(nSelection,1)
unbox(cUnder)

cThisAndOr := {"",".AND.",".OR.",".AND.!",".OR.!"}[nSelection]

RETURN  !(EMPTY(cThisAndOr))


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION FROMLIST
local cToSmalls

DO CASE
CASE cThisFldType == 'C'
  cToSmalls := cThisExpression
CASE cThisFldType == 'D'
  cToSmalls := 'dtoc('+cThisExpression+')'
CASE cThisFldType == 'N'
  cToSmalls := 'str('+cThisExpression+')'
CASE cThisFldType == 'L'
  cToSmalls := 'iif('+cThisExpression+',"True","False")'
OTHERWISE
  RETURN .F.
ENDCASE
if smalls(cToSmalls)
//IF LASTKEY() = 13
  cThisCompare = &cThisExpression
  RETURN .T.
ELSE
  cThisCompare = ""
  RETURN .F.
ENDIF
RETURN .F.


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION sfq_like(cInString1,cInString2)
IF (SOUNDEX(cInString1) == SOUNDEX(cInString2))
  RETURN .T.
ELSE
  RETURN .F.
ENDIF
return .f.

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION VIEWQUERY
local nIndexOrd := INDEXORD()
local cUnder
local aPriorStack := {}
local nMaxInBox   := 0
local nFirstField := 1
local nCurrRow
local nCounter
local cFieldName,cFieldDesc
local nMemos
local aMemos
local cThisMemo, cContents
local nIter
local nSelection
local cUnder2
local cOldColor
local nLastKey, nMouseR, nMouseC, cLastKey

set order to 0
go top
plswait(.T.,"Looking....")
CLEAR TYPEAHEAD
//LOCATE WHILE (inkey()#27 .and. !rat_rightb()) FOR eval(sls_bquery())
LOCATE WHILE !RAT_CHECKESC() FOR eval(sls_bquery())
plswait(.F.)

*- if no matches, back to the main routine
IF !FOUND()
  IF EOF()
    msg("No matches")
  ELSE
    msg("User aborted process")
  ENDIF
  RETURN ''
ENDIF

cUnder := makebox(3,5,20,75,sls_popcol())
nMemos = akount(aFieldTypes,"M")
IF nMemos > 0
  aMemos := array(nMemos)
  nCounter := 0
  FOR nIter = 1 TO nFieldCount
    IF aFieldTypes[nIter] = "M"
      nCounter++
      aMemos[nCounter] := aFieldNames[nIter]
    ENDIF
  NEXT
  @20,7 SAY '[N]ext    [P]rior    [Q]uit    [V]iew Memo    [][]]'
else
  @20,7 SAY '[N]ext    [P]rior    [Q]uit                   [][]]'
ENDIF

DO WHILE .T.
  
  *- display the record #, clear the box
  @ 3,12 SAY  "RECORD "+STR(RECNO())+" ]"
  Scroll(4,11,19,69,0)
  
  *- determine last field to be displayed from field subscript
  *- and box size
  nMaxInBox := MIN(nFirstField+14,nFieldCount)
  
  *- current row starts at 1
  nCurrRow := 4
  
  *- draw each of the field/field descriptions that fit in the box
  FOR nCounter = nFirstField TO nMaxInBox
    *- get field description, make it a uniform length
    cFieldDesc := aFieldDesc[nCounter]+REPL(' ',20-LEN(aFieldDesc[nCounter]))
    cFieldName := aFieldNames[nCounter]
    IF aFieldTypes[nCounter]="M"
      @nCurrRow,12 SAY cFieldDesc+ ' (MEMO FIELD)'
    ELSE
      *- get a piece of the value to show
      @nCurrRow,12 SAY cFieldDesc+' '+left(trans(&cFieldName,""),35)
    ENDIF
    *- increment the current row
    nCurrRow++
  NEXT
  
  *- wait for Vern to press a key
  nLastKey := rat_event(0)
  nMouseR := rat_eqmrow()
  nMouseC := rat_eqmcol()
  cLastKey := UPPER(CHR(nLastKey))
  
  *- do the appropriate
  DO CASE
    
  CASE cLastKey = "N"
    aadd(aPriorStack,recno())

    *- blinking message while searching for next record
    cOldColor = Setcolor('*'+Setcolor())
    @3,50 SAY '[ Searching... ]'
    SKIP
    //LOCATE WHILE (inkey()#27 .and. !rat_rightb()) FOR eval(sls_bquery())
    LOCATE WHILE !RAT_CHECKESC() FOR eval(sls_bquery())
    
    *- put the box back as it was
    Setcolor(cOldColor)
    @3,50 SAY 'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'
    
    *- if no go, we're outa here
    IF !FOUND()
      IF EOF()
        msg("No more matches")
      ELSE
        msg("User aborted process")
      ENDIF
      EXIT
    ENDIF
  CASE cLastkey = "P"
     if len(aPriorStack) > 0
       go ATAIL(aPriorStack)
       asize(aPriorStack,len(aPriorStack)-1)
     endif
    
  CASE cLastkey = "Q"
    EXIT

  *#06-19-1990 Added this for View Memo capability
  CASE cLastkey = "V".and. nMemos > 0 && V view memos
      nSelection := 1
      IF nMemos > 1
        nSelection := mchoice(aMemos,2,15,3+nMemos,26,"Which Memo:")
      ENDIF
      IF nSelection > 0
        cThisMemo := FIELDGET(FIELDPOS(aMemos[nSelection]))
        EDITMEMOV(cThisMemo,1,16,23,78,.f.,200)
      ENDIF
  CASE nLastkey = K_UP
    *- decrease starting field #
    nFirstField = IIF(nFirstField=1,1,MAX(nFirstField-20,1) )
    
    
  CASE nLastkey = K_DOWN
    *- increase starging field #
    nFirstField = IIF(nMaxInBox+1 > nFieldCount,1,MIN(nMaxInBox+1,nFieldCount) )
  CASE nLastKey==K_MOUSELEFT .and. nMouseR==20
    do case
    case nMouseC>=53 .and. nMouseC<=55   // up
       keyboard chr(K_UP)
    case nMouseC>=56 .and. nMouseC<=58  //down
       keyboard chr(K_DOWN)
    case nMouseC>=7  .and. nMouseC<=12  //next
       keyboard "N"
    case nMouseC>=17 .and. nMouseC<=23  //prior
       keyboard "P"
    case nMouseC>=28 .and. nMouseC<=33  //quit
       keyboard "Q"
    case nMouseC>=38 .and. nMouseC<=48  .and. nMemos > 0  //view memo
       keyboard "V"
    endcase
  ENDCASE
  
ENDDO
*- back to the beg of file
GO TOP
*- and back to the main proc
unbox(cUnder)
SET ORDER TO (nIndexOrd)
RETURN ''


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FUNCTION sfq_cntain(cInstring,cDelimstr)
local nIter,cPartOf
nIter := 1
cPartOf = takeout(cDelimStr,';',nIter)
DO WHILE !EMPTY(cPartOf)
  IF cPartOf$cInstring
    RETURN .T.
  ENDIF
  nIter++
  cPartOf = takeout(cDelimStr,';',nIter)
ENDDO
RETURN .F.

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
static function putquery(cQDescription)
local cQueryfile := slsf_query()+".DBF"
local nOldArea   := select()
local cQueryDesc := padr(cQDescription,30)
local lOverWrite := .t.
local lSaved     := .f.

*- open up the next available area
SELE 0

while .t.
 *- check for /build the dbf to hold the queries
 IF !FILE(cQueryFile)
    DBCREATE(cQueryFile,{  {"DBF","C",12,0},;
                           {"DES","C",30,0},;
                           {"FQUERY","C",220,0} } )
 ENDIF

 *- open the QUERIES.DBF file
 IF !SNET_USE(cQueryFile,"__QUERIES",.F.,5,.F.,"Unable to open queries file. Keep trying?")
    USE
    EXIT
 ENDIF

 *- init a value for a description and get it
 popread(.F.,"Enter a description for this query    ",@cQueryDesc,"@K!")

 *- if a description was given, store the record
 IF !EMPTY(cQueryDesc) .AND.!LASTKEY()=27
   locate for alltrim(__QUERIES->DBF)==ALIAS(nOldarea) ;
        .and. __QUERIES->des == cQueryDesc .and. !deleted()
   if !found()
      locate for deleted()     // if there's a deleted record, re-use it
      if found() .and. SREC_LOCK(5,.f.)
      ELSEIF !SADD_REC(5,.T.,"Network error adding record. Keep trying?")
            USE
            SELE (nOldarea)
            EXIT
      endif
   else
      lOverWrite := messyn("Overwrite ?")
   endif

   if lOverWrite
      IF SREC_LOCK(5,.T.,"Network error locking record for saving. Keep trying?")
          *- store the dbf alias too
          lSaved := .t.
          REPLACE DBF WITH ALIAS(nOldarea)
          REPLACE des WITH cQueryDesc
          REPLACE fquery WITH sls_query()
          DBRECALL()
      endif
   endif
 ENDIF
 USE
 exit
END
SELE (nOldarea)
if lSaved
 return cQueryDesc
endif
return cQDescription
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC FUNCTION GetQuery
local cQueryfile := slsf_query()+".DBF"
local nOldArea   := select()
local cAlias     := ALIAS()
local nSelection := 0
local cStoredQuery
local cQDescription := ""

local aDescript := {}

while .t.
    IF FILE(cQueryFile)
      *- open the next available area and use the queries dbf
      SELE 0
      IF !SNET_USE(cQueryFile,"__QUERIES",.F.,5,.F.,"Unable to open query file. Keep trying?")
         EXIT
      ENDIF
      
      *- see if anything in the dbf matches the current alias
      *- (I realize ALIAS() will not always return current DBF name)
      
      LOCATE FOR UPPER(Alltrim(__QUERIES->dbf))==TRIM(cAlias) ;
                       .and. !deleted()
      
      IF !FOUND()
        USE
        msg("No stored queries match this database")
      ELSE
        WHILE FOUND()
          *- while matching records found, load them into array
          AADD(aDescript, __QUERIES->des)
          CONTINUE
        END
      ENDIF
      
      *- if nCounter is more than 1, we found at least one match
      IF len(aDescript) > 0
        
        *- have the user select the query to restore
        Asort(aDescript)
        nSelection = mchoice(aDescript,5,22,16,55,"[Select Query]")
        
        *- if the selects one, locate the record
        IF nSelection > 0
          
          LOCATE for aDescript[nSelection]==__QUERIES->des ;
                        .and. alltrim(__QUERIES->DBF)==ALIAS(nOldarea)
          cStoredQuery := __QUERIES->fquery
          USE
          SELE (nOldarea)
          *- test the query against TYPE() to ensure its a valid
          *- expression in the current environment
          *- notify the user if it is not
          *- ignoring indeterminate error UI , which is given
          *- for functions not in CLIPPER.LIB mostly
          
          IF !(TYPE(cStoredQuery) == "U" .OR. TYPE(cStoredQuery) == "UE")
            sls_query(Alltrim(cStoredQuery))
            sls_bquery( &("{||"+sls_query()+"}")  )
            cQDescription := aDescript[nSelection]
          ELSE
            msg("That query doesn't seem to match this database")
          ENDIF
        ELSE
          USE
        ENDIF
      ELSE
        USE
      ENDIF
    ELSE
      *- if no query dbf found, notify the user
      msg("No saved queries found in this directory" )
    ENDIF
    EXIT
end
select (nOldArea)
return cQDescription

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC PROC EDITQUERY
local cUnder,cEdit
local getlist := {}

 Ratinsert(.T.)
 *- draw boxes
 cUnder  := makebox(2,1,20,78,sls_popcol())
 @2,3 SAY "[Evaluation of Query Expressions]"
 @4,3 SAY "    A query expression may contain several different operators."
 @ROW()+1,3 SAY "    Each operation is performed by the computer in a particular order,"
 @ROW()+1,3 SAY "    with precedence being as follows:"
 @ROW()+1,3 SAY ""
 @ROW()+1,3 SAY "    1. Operations within parentheses                ()"
 @ROW()+1,3 SAY "    2. Concatenation of character expressions       + -"
 @ROW()+1,3 SAY "    3. Mathematical operations (in this order)      ^*/%-+"
 @ROW()+1,3 SAY "    4. Comparison operations                        = < > != $ =="
 @ROW()+1,3 SAY "    5. Logical operations (in this order)           .NOT. .AND. .OR."
 @ROW()+1,3 SAY ""
 @ROW()+1,3 SAY "    To ensure an operation is performed first, enclose it in parentheses."

 @17,2 TO 17,77

 @17,2 SAY '[Edit Query]'

 *- fill out the query exp with spaces, store it to the temp var
 cEdit := sls_query()+REPL(' ',220-LEN(sls_query()))

 *- allow the user to edit the temp var - scroll within 65 characters
 @18,3 SAY "Query:"
 @19,3 GET cEdit PICT "@S65"
 @20,2 say "[OK]  [CANCEL]"
 SET CURSOR ON
 RAT_READ(getlist,1,.f.,27,;
    {|r,c| iif(r==20 .and. c>=2 .and. c<=5 ,CTRLW(),IIF(r==20.and. c>=8  .and. c<=15,KBDESC(),Nil))})
 SET CURSOR OFF

 *- save this thing ?
 IF !EMPTY(cEdit) .AND. !(TRIM(cEdit)==TRIM(sls_query()))
   IF messyn("Save ?")
     *- test it against TYPE() for valid expression
     IF !(TYPE(cEdit) == "U" .OR. TYPE(cEdit) == "UE")
       *- if valid, store it back to query_exp
       sls_query(Alltrim(cEdit))
       sls_bquery( &("{||"+sls_query()+"}")  )
     ELSE
       msg("That query doesn't seem to match this database", "Or an invalid expression has been used")
     ENDIF
   ENDIF
 ENDIF

 *-
 unbox(cUnder)
return

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
STATIC PROC COUNTQUERY
local nIndexOrd := INDEXORD()
*- save the index order and set it to 0 for rapid count
SET ORDER TO 0
GO TOP

ProgCount(SLS_BQUERY(),"Counting matches",.t.)
SET ORDER TO (nIndexOrd)
return

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
static PROC BUILDQUERY
local nCompareType
local cUnder,cCurrQuery
local nSpaces
local nLengthCompare
local getlist := {}
DO WHILE GETAFIELD()   // getafield() sets cThisExpression and cThisFldType
  IF !(GetOperator())  // getoperator sets cThisOperator
    EXIT
  ENDIF
  *- get the comparison value now
  nCompareType  := 1
  IF !cThisFldType $ "LM"
    nCompareType := menu_v("Compare to ",;
      "Type in a value to compare ", ;
      "Select a single value from the database (scroll) ",;
      "Compare to another field in the same record",;
      "Create Formula for comparison",;
      "Cancel")
  ENDIF

  DO CASE
  CASE nCompareType == 0 .or. nCompareType== 5   // pressed escape
    LOOP
  CASE nCompareType==4  // formula
    cThisCompare := FORMULATE("",aFieldNames,aFieldDesc,;
         "Create Formula/User Defined field for comparison (must be type:"+;
          cThisFldType+")",cThisFldType)
      if empty(cThisCompare)
        if cUnder#nil
          unbox(cUnder)
        endif
        loop
      else
        cThisCompare := "("+cThisCompare+")"
      endif
  CASE nCompareType == 1 // type it in
    IF !(cThisFldType == "L" .OR. (cThisFldType=="M".AND. cThisOperator $"EN"))
      cUnder = makebox(18,9,23,70,sls_popcol())
      @23,10 say "[OK] [CANCEL]"
    ENDIF
    SET CURSOR ON
    DO CASE
    CASE cThisFldType == "M" .AND. cThisOperator=="$"
      cThisCompare= SPACE(60)
      @19,10 SAY "Where "+LEFT(cThisExpression,60)+" Contains "
      @20,10 GET cThisCompare
      @21,10 SAY "Use ; to seperate multiple items to check"
      @22,10 SAY "i.e. Ralph;Fred;Joe;Eddie   - up to 10 items"
      RAT_READ(getlist,1,.f.,27,;
         {|r,c| iif(r==23 .and. c>=10.and. c<=13,CTRLW(),IIF(r==23.and. c>=15 .and. c<=22,KBDESC(),Nil))})
      if lastkey()==27
        if cUnder#nil
          unbox(cUnder)
        endif
        loop
      endif
      IF EMPTY(cThisCompare)
        cThisCompare = 'EMPTY('+cThisExpression+')'
      ELSE
        cThisCompare = TRIM(cThisCompare)
        cThisCompare = '"'+cThisCompare+'"'
      ENDIF
    CASE cThisFldType =="M" .AND. cThisOperator=="E"
      cThisCompare = 'EMPTY('+cThisExpression+')'
    CASE cThisFldType =="M" .AND. cThisOperator=="N"
      cThisCompare = '!EMPTY('+cThisExpression+')'
    CASE cThisFldType = "C"
      *- figure the size if its a character field - max 40
      cThisCompare = SPACE(MIN(LEN(&cThisExpression),40))
      IF cThisOperator$"$"
        cThisCompare = SPACE(60)
      ENDIF
      *- get the comparison value
      @19,10 SAY "VALUE TO COMPARE     (TYPE CHARACTER)"
      @20,10 GET cThisCompare
      IF cThisOperator $ "$"
        @21,10 SAY "Use ; to seperate multiple items to check"
        @22,10 SAY "i.e. Ralph;Fred;Joe;Eddie   - up to 10 items"
      ELSEIF cThisOperator $"?"
        @21,10 SAY "Wildcard match. Use ? to represent any single"
        @22,10 SAY "character, * to represent any group of characters"
      ENDIF
      RAT_READ(getlist,1,.f.,27,;
         {|r,c| iif(r==23 .and. c>=10.and. c<=13,CTRLW(),IIF(r==23.and. c>=15 .and. c<=22,KBDESC(),Nil))})
      *- if its empty, use the EMPTY() function to compare it
      if lastkey()==27
        if cUnder#nil
          unbox(cUnder)
        endif
        loop
      endif
      IF EMPTY(cThisCompare)
        IF !(messyn("Value to compare left blank","Test for empty (null)","Test for space(s)"))
          nSpaces := 1
          popread(.F.,"Number of spaces to look for",@nSpaces,"99")
          cThisCompare = 'SPACE('+TRANS(nSpaces,"99")+')'
        ENDIF
      ENDIF
      IF EMPTY(cThisCompare) .AND. cThisOperator == '=='
        cThisCompare = 'EMPTY('+cThisExpression+')'
      ELSEIF EMPTY(cThisCompare) .AND. cThisOperator == '<>'
        cThisCompare = '!EMPTY('+cThisExpression+')'
      ELSEIF !("SPACE(" $ cThisCompare)
         *- 05-07-1993 Some things need to be trimmed
         IF ISPART(cThisOperator,"$","!$","?","QL","B","E")
           cThisCompare := TRIM(cThisCompare)
         ENDIF
        *cThisCompare = TRIM(cThisCompare)
        cThisCompare = '"'+cThisCompare+'"'
      ENDIF


    CASE cThisFldType = "N"
      *- start with 0
      cThisCompare := 0

      *- get the comparison number - (expand the picture for larger numbers)
      @19,10 SAY "VALUE TO COMPARE " GET cThisCompare PICTURE ed_g_pic(cThisExpression)
      @20,10 SAY "(NUMBER)"
      RAT_READ(getlist,1,.f.,27,;
         {|r,c| iif(r==23 .and. c>=10.and. c<=13,CTRLW(),IIF(r==23.and. c>=15 .and. c<=22,KBDESC(),Nil))})
      if lastkey()==27
        if cUnder#nil
          unbox(cUnder)
        endif
        loop
      endif
      cThisCompare := Alltrim(STR(cThisCompare))

    CASE cThisFldType == "D"

      *- store no-date, and get the comparison value
      cThisCompare := DATE()
      @19,10 SAY "VALUE TO COMPARE " GET cThisCompare
      @20,10 SAY "(DATE)"
      RAT_READ(getlist,1,.f.,27,;
         {|r,c| iif(r==23 .and. c>=10.and. c<=13,CTRLW(),IIF(r==23.and. c>=15 .and. c<=22,KBDESC(),Nil))})
      if lastkey()==27
        if cUnder#nil
          unbox(cUnder)
        endif
        loop
      endif
      cThisCompare := DTOC(cThisCompare)
      cThisCompare := 'CTOD("'+cThisCompare+'")'

    CASE cThisFldType == "L"
      cThisCompare := IIF(cThisOperator=="=",cThisExpression,'!'+cThisExpression)
    ENDCASE
    SET CURSOR OFF
    IF !(cThisFldType == "L" .OR. (cThisFldType=="M".AND. cThisOperator $"EN"))
      unbox(cUnder)
    ENDIF
  CASE nCompareType = 2 //select by scrolling
    IF !(FROMLIST())
      LOOP
    ENDIF
    DO CASE
    CASE cThisFldType == "C"
      cThisCompare := '"'+cThisCompare+'"'
    CASE cThisFldType == "N"
      cThisCompare = Alltrim(STR(cThisCompare))
    CASE cThisFldType == "D"
      cThisCompare := DTOC(cThisCompare)
      cThisCompare := 'CTOD("'+cThisCompare+'")'
    CASE cThisFldType == "L"
      cThisCompare := IIF(cThisCompare,cThisExpression,'!'+cThisExpression)
    ENDCASE

  CASE nCompareType == 3 //compare to another field
    IF !(OTHERFIELD())
      LOOP
    ENDIF
  ENDCASE

  *- store the query to a temp variable
  cCurrQuery = sls_query()

  *- here we finish building this portion of the query string
  DO CASE
  CASE cThisFldType $ "CM"
    *- field of type Character
    IF cThisFldType =="C"
      IF !("SPACE(" $ cThisCompare)
        nLengthCompare = LTRIM(TRANS(LEN(cThisCompare)-2,"999"))
      ELSE
        nLengthCompare = LTRIM(TRANS(nSpaces,"999"))
      ENDIF
    ENDIF

    IF LEFT(cThisCompare,5)="EMPTY"
      *- if comparing EMPTY()
      sls_query(sls_query()+ cThisAndOr+'('+cThisCompare+')')
    ELSEIF LEFT(cThisCompare,6)="!EMPTY"
      *- if comparing NOT EMPTY()
      sls_query(sls_query()+ cThisAndOr+'('+cThisCompare+')')
    ELSEIF "$"$cThisOperator
      *- if comparing substring
      IF "!"$cThisOperator
        cThisAndOr := cThisAndOr+"!"
      ENDIF
      IF ";"$cThisCompare
       sls_query(sls_query()+cThisAndOr+'SFQ_CNTAIN('+cThisExpression+','+;
                 cThisCompare+')' )
      ELSE
        sls_query(sls_query()+ cThisAndOr+'('+cThisCompare+"$"+;
                 cThisExpression+')')
      ENDIF
    ELSEIF cThisOperator =="?"
      sls_query(sls_query()+ cThisAndOr+'(_WILDCARD('+;
             cThisCompare+','+cThisExpression+'))' )
    ELSEIF cThisOperator = "QL"
      *- if comparing SIMILAR SOUNDING
      sls_query(sls_query()+ cThisAndOr+'(SFQ_LIKE('+cThisExpression+','+;
                cThisCompare+'))')
    ELSEIF cThisOperator = "B"
      sls_query(sls_query()+ cThisAndOr+'(left('+cThisExpression+','+;
                nLengthCompare+')=='+cThisCompare+')')
    ELSEIF cThisOperator = "E"
      IF !("SPACE(" $ cThisCompare)
        sls_query(sls_query()+ cThisAndOr+'(right(trim('+cThisExpression+'),'+;
                  nLengthCompare+')=='+cThisCompare+')')
      ELSE
        sls_query(sls_query()+ cThisAndOr+'(right('+cThisExpression+','+;
                  nLengthCompare+')=='+cThisCompare+')')
      ENDIF
    ELSE
      *- otherwise, must just be a string
      sls_query(sls_query()+ cThisAndOr+'('+cThisExpression+cThisOperator+;
                cThisCompare+')')
    ENDIF


  CASE cThisFldType = "N"
    *- numeric field type
    sls_query(sls_query() + cThisAndOr+'('+cThisExpression+cThisOperator+;
              cThisCompare+')')


  CASE cThisFldType = "D"
    *- date field type
    sls_query(sls_query() + cThisAndOr+'('+cThisExpression+cThisOperator+;
             cThisCompare+')')

  CASE cThisFldType = "L"
    sls_query(sls_query() + cThisAndOr+'('+cThisCompare+')')
  ENDCASE

  *- check for line-length boundary (actual boundary is 255, but to be
  *-  safe...)
  IF LEN(sls_query()) > 220
    *- if its too long, restore old query string
    sls_query(cCurrQuery)
    msg('QUERY HAS REACHED LENGTH LIMIT')
  ENDIF

  *- get AND/OR/NOT etc
  IF !(GETANDOR())
    EXIT
  ENDIF
ENDDO
RETURN

STATIC PROC PURGEQ
local cQueryFile  := slsf_query()+".DBF"
local nOldarea    := SELECT()
IF FILE(cQueryFile)
  SELECT 0
  IF !SNET_USE(cQueryFile,"",.f.,5,.F.,;
     "Unable to open query file. Keep trying?")
  else
     purgem()
     USE
  ENDIF
ELSE
  MSG("No queries file found.")
ENDIF
SELECT (nOldarea)
return

*------------returns actual TYPE, including UDF type, and handles errors
*------------in expressions by returning U. Uses temporary error object.
static function realtype(cInExpress)
local cExpress := alltrim(cInExpress)
local cType := TYPE(cExpress)
local xValue
local bError
local bErrorBlock := ERRORBLOCK( {|bError|qqrecover(bError)}  )
BEGIN SEQUENCE
   * check type here
   if cType=="UI"
        xValue = &cExpress
        cType = valtype(xValue)
   endif
RECOVER USING bError
   cType = "U"
END SEQUENCE
ERRORBLOCK(bErrorBlock)
cType:=iif(cType=="M","C",cType)
return cType


static function qqrecover(eObj)
BREAK eObj
return nil

*: EOF: S_QUERY.PRG










