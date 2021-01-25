
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

static aFieldNames,aStructure
static aFreqFields,aSumFields
static cFreqString,cNumbString
static cFreqdbf
static nOldArea,cOldAlias
static cIndExp


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FREQANAL()                           *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FREQANAL() Performs a frequency analysis on a DBF
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  FREQANAL()
ณ 
ณ  Description:
ณ  ------------
ณ  Performs a point&shoot frequency analysis on selected
ณ  fields of the DBF.
ณ 
ณ  Allows for tallying of additional numeric fields.
ณ 
ณ  New to 3.5 - now allows fields of type C D and N to be added
ณ  to the frequency string. Additional Summary fields are now named
ณ  SUM_1, SUM_2...etc in the output results. (previously they retained
ณ  their original name)
ณ 
ณ  Examples:
ณ  ---------
ณ   USE (cDbfName)
ณ 
ณ   FREQANAL()
ณ 
ณ  Source:
ณ  -------
ณ  S_FREQ.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION freqanal

local cInscreen
local lOldExact,cOldColor,nOldOrder,nOldCursor,bOldF10
local nMainChoice
local nbrflds


nbrflds         := fcount()
aFieldNames         := array(nbrflds)
aStructure          := dbstruct()
Afields(aFieldNames)

aFreqFields       := {}
aSumFields       := {}


lOldExact       := SETEXACT(.T.)
cInscreen       := savescreen(0,0,24,79)
cOldColor       := setcolor(sls_normcol())
nOldCursor       := setcursor(0)
bOldF10           := SETKEY(-9)
nOldArea         := select()
cOldAlias        := alias()
nOldOrder        := indexord()
set order to 0

cFreqDbf        := ''
cIndExp         := ''
cFreqString     := ""
cNumbString      := ""

*-- draw screen
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,09,50 BOX sls_frame()
@1,5 SAY '[Frequency Analysis]'
@20,1,23,78 BOX sls_frame()
@21,2 say "Frequency fields      :"
@22,2 say "Sum additional fields :"

*-- Main Loop
do while .t.
  @21,27 say cFreqString
  @22,27 say cNumbString
  *- indicate if query is active
  @2,60 SAY IIF(EMPTY(sls_query()),"[No Query    ]","[Query Active]")
  
  *- do a menu
  Setcolor(sls_popmenu())
  nMainChoice := RAT_MENU2({;
                {02,3 ,"Frequency field selection"},;
                {03,3 ,"Additional SUM fields selection"},;
                {04,3 ,"Build Query"},;
                {05,3 ,"Perform Analysis"},;
                {06,3 ,"Quit"}})
  do case
  case nMainChoice = 1  && field selection
        aFreqFields := fa_fselect()
        scroll(21,2,22,77,0)
        @21,2 say "Frequency fields      :"
        @22,2 say "Sum additional fields :"
  case nMainChoice = 2  && additional numeric field selection
        aSumFields := fa_aselect()
        scroll(21,2,22,77,0)
        @21,2 say "Frequency fields      :"
        @22,2 say "Sum additional fields :"
  case nMainChoice = 3  && build query
        query()
  case nMainChoice = 4  && do analysis
       if empty(cIndExp)
        msg("Select frequency field(s) first")
       else
        fa_perform()
       endif
  case nMainChoice = 5 .or. nMainChoice = 0
     setcolor(cOldColor)
     restscreen(0,0,24,79,cInscreen)
     SETEXACT(lOldExact)
     setcursor(nOldCursor)
     SETKEY(-9,bOldF10)
     set order to (nOldOrder)
     return ''
  endcase
enddo
aFieldNames :=nil; aStructure := nil
aFreqFields := nil; aSumFields := nil
cFreqString := nil ;cNumbString := nil
cFreqdbf := nil   ; nOldArea := nil
cOldAlias := nil  ; cIndExp   := nil

return ''

//-----------------
static function fa_fselect
local i
local aPicked
local aChrAll    := {}
local aChrFields := {}
local aRetFields := {}
cFreqString      := ""
cIndExp          := ""
for i = 1 TO len(aStructure)
    IF aStructure[i,2]$"CDN"
      aadd(aChrFields,aStructure[i,1])
      aadd(aChrAll,aStructure[i])
    ENDIF
NEXT
aPicked    := tagarray(aChrFields,"Select Frequency Fields")
for i = 1 to len(aPicked)
     DO CASE
     CASE aChrAll[  aPicked[i],2  ]=="C"
       aadd(aRetFields,aChrAll[aPicked[i]])
       cFreqString = cFreqString+aChrAll[aPicked[i],1]+' '
       cIndExp = cIndExp+aChrAll[aPicked[i],1]+'+" "+'
     CASE aChrAll[  aPicked[i],2  ]=="D"
       aadd(aRetFields,aChrAll[aPicked[i]])
       cFreqString = cFreqString+aChrAll[aPicked[i],1]+' '
       cIndExp = cIndExp+"DTOS("+aChrAll[aPicked[i],1]+')+" "+'
     CASE aChrAll[  aPicked[i],2  ]=="N"
       aadd(aRetFields,aChrAll[aPicked[i]])
       cFreqString = cFreqString+aChrAll[aPicked[i],1]+' '
       cIndExp = cIndExp+"STRTRAN(STR("+aChrAll[aPicked[i],1]+","+;
        alltrim(str(aChrAll[aPicked[i],3]))+",";
        +alltrim(str(aChrAll[aPicked[i],4]))+'),space(1),"A")+" "+'
     ENDCASE
next
cIndExp = LEFT(cIndExp,LEN(cIndExp)-1)
return aRetFields

//-----------------------------------------------------------
static function fa_aselect
local aPicked
local aNumAll    := {}
local aNumFields := {}
local aRetFields := {}
local i
cNumbString       := ""
* fill numeric array with numeric fields
for i = 1 TO len(aStructure)
    IF aStructure[i,2]=="N"
      aadd(aNumFields,aStructure[i,1])
      aadd(aNumAll,aStructure[i])
    ENDIF
NEXT
if len(aNumFields)>0
  aPicked    := tagarray(aNumFields,"Select Numeric Fields")
  for i = 1 to len(aPicked)
       aadd(aRetFields,aNumAll[aPicked[i]])
       cNumbString := cNumbString+aNumAll[aPicked[i],1]+' '
  next
else
  msg("No Numeric Fields")
endif
return aRetFields

//-----------------------------------------------------------

static function fa_perform
local bQuery,_ninja,cPermDbf,lUseQuery,lAbandoned,cFreqNtx,cFOrder
local cPopBox
local bExpress := &("{||"+cIndExp+"}")
local cLocator
local expFieldVal
local nIter,nFieldPos

cFOrder    := ""
bQuery     := {||.t.}
lUseQuery  := .f.
lAbandoned := .f.
if !empty(sls_query())
  if !messyn("Limit frequency list to Query ?","No","Yes")
      bQuery      := sls_bquery()
      lUseQuery   := .t.
  endif
endif

cPopBox   := makebox(7,28,14,53)
@7,29 SAY '[Work in progress...]'
@10,30 SAY "Preparing output dbf.."
*- prepare temp dbf for use, building if needed
IF !fa_makedb(cFreqDbf)
  msg("Error building frequency DBF.")
  RETURN ''
ENDIF

select 0
if !SNET_USE(cFreqDbf,"HOUNDOG",.T.,5,.F.,'')
  SELE (nOldArea)
  msg("Error opening frequency DBF.")
  return ''
endif

cFreqNtx := UNIQFNAME(RIGHT(INDEXEXT(),3),getdfp())

@10,30 SAY "Indexing.............."
DBCREATEINDEX(cFreqNtx,cIndExp,bExpress)
*INDEX ON &cIndExp TO (cFreqNtx)

@10,30 SAY "Working record........"
SELE (nOldArea)

*- fill temp dbf with occurance count
go top
if lUseQuery
  locate for eval(bQuery)
endif

do while !eof()

  @12,29 SAY TRANS(recno(),"999999")
  ??' of '
  ??RECC()
  cLocator     := eval(bExpress)
  SELE houndog
  SEEK cLocator

  IF FOUND()
    SET ORDER TO 0
    REPLACE frequency_ WITH houndog->frequency_+1
  ELSE
    SET ORDER TO 0
    APPEND BLANK
    FOR nIter= 1 TO len(aFreqFields)
      expFieldVal := (cOldAlias)->(fieldget(fieldpos(aFreqFields[nIter,1])))
      fieldput(nIter,expFieldVal)
    NEXT
    REPLACE frequency_ WITH 1
  ENDIF
  FOR nIter = 1 TO len(aSumFields)
    expFieldVal := (cOldAlias)->(fieldget(fieldpos(aSumFields[nIter,1])))
    nFieldPos := fieldpos(aSumFields[nIter,5])
    fieldput(nFieldPos,expFieldVal+fieldget(nFieldPos) )
  NEXT
  SET ORDER TO 1
  SELE (nOldArea)
  if lUseQuery
    CONTINUE
  else
    skip
  endif
  //IF INKEY() = 27 .or. rat_rightb()
  IF RAT_CHECKESC()
        IF MESSYN("Abandon analysis?")
          lAbandoned = .t.
          exit
        ENDIF
  ENDIF
enddo

SELE houndog
SET INDEX TO
erase (getdfp()+cFreqNtx)
unbox(cPopBox)

if !lAbandoned
   *- create a descending index
    cFOrder = UNIQFNAME(RIGHT(INDEXEXT(),3),getdfp())
    INDEX ON 100-houndog->frequency_ TO (cFOrder)

   *- show the results
   cPopBox = makebox(1,1,23,79)
   @1,2 SAY '[Frequency Analysis Results]'
   @23,2 SAY '[][][][]   [Press ESCAPE when done browsing]'
   fa_browse()
   unbox(cPopBox)
   DO WHILE .T.
     IF messyn("Send results to a permanent DBF file ?")
       cPermDbf = SPACE(8)
       popread(.F.,"Name of DBF to send this to:",@cPermDbf,"@N")
       cPermDbf = Alltrim(cPermDbf)
       IF !(LASTKEY() = 27 .OR. EMPTY(cPermDbf))
         cPermDbf = Alltrim(cPermDbf)
         cPermDbf =UPPER(cPermDbf)+".DBF"
         IF FILE(cPermDbf)
           msg("Database "+cPermDbf+" already exists - ","Use another name")
             cPermDbf = ''
             LOOP
         ENDIF
         COPY TO (cPermDbf)
         EXIT
       ENDIF
     ELSE
       EXIT
     ENDIF
   ENDDO
endif
USE
erase (getdfp()+cFreqDbf)
IF !EMPTY(cFOrder)
  erase (getdfp()+cFOrder)
endif
SELE (nOldArea)
RETURN ''


//-----------------------------------------------------------


static function fa_makedb()
local aDbfStruc := aclone(aFreqFields)
local nIter, nMaxVal, aThis
for nIter := 1 to len(aSumFields)
  IF aSumFields[nIter,4] > 0
    nMaxVal := recc()*VAL(STUFF( REPL("9",aSumFields[nIter,3]),;
                      aSumFields[nIter,3]-aSumFields[nIter,4],1,"."))
  ELSE
    nMaxVal := recc()*VAL(REPL("9",aSumFields[nIter,3]))
  ENDIF

  aThis := aclone(aSumFields[nIter])
  aThis[1] := PADR("SUM_"+alltrim(str(nIter)),10)
  while ASCAN(aDbfStruc,{|e|e[1]==aThis[1]})>0
    aThis[1] := PADR(alltrim(aThis[1])+"_",10)
  end
  aadd(aDBFStruc,aThis)
  aadd(aSumfields[nIter],aThis[1])
  ATAIL(aDbfStruc)[3] := MIN( len(alltrim(str(nMaxVal))), 19)
next
aadd(aDbfStruc,{"FREQUENCY_","N",LEN(ALLTRIM(STR(RECC()))),0})
cFreqDbf   := uniqfname("DBF",getdfp())
sele 0
DBCREATE(cFreqDbf,aDbfStruc)
USE
select (nOldArea)
return file(cFreqDbf)


//------------------------------------------------------------

static function fa_browse()
*   DBEDIT(2,2,22,78)
local oTb
local nIter
local nLastkey
local nMouseR, nMouseC

oTb := TBROWSEDB(2,2,22,78)
for nIter := 1 to fcount()
   oTb:addColumn(TBColumnNew( field(nIter),fieldblock(field(nIter))  )  )
next



oTb:COLSEP := "ณ"
DO WHILE .T.
   WHILE !oTb:STABILIZE()
   END
   nLastKey := rat_event(0,.f.)
   nMouseR := rat_eqmrow()
   nMouseC := rat_eqmcol()
   do case
   CASE nLastKey = K_LEFT
     oTb:left()
   CASE nLastKey = K_RIGHT
     oTb:right()
   CASE nLastKey = K_UP
     oTb:UP()
   CASE nLastKey = K_PGUP
     oTb:PAGEUP()
   CASE nLastKey = K_HOME
     oTb:GOTOP()
   CASE nLastKey = K_DOWN
     oTb:DOWN()
   CASE nLastKey = K_PGDN
     oTb:PAGEdOWN()
   CASE nLastKey = K_END
     oTb:GOBOTTOM()
   case nLastKey = K_F10  .OR. nLastKey == K_ESC
     EXIT
   case nLastKey==K_MOUSELEFT  // mouse
     do case
     case nMouseR==23 .and. nMouseC>=2 .and. nMouseC<=4  // up
       oTb:up()
       tbgo(oTb,{||oTb:up()})
     case nMouseR==23 .and. nMouseC>=5 .and. nMouseC<=7  // down
       oTb:down()
       tbgo(oTb,{||oTb:down()})
     case nMouseR==23 .and. nMouseC>=8 .and. nMouseC<=10 // right
       oTb:right()
       tbgo(oTb,{||oTb:right()})
     case nMouseR==23 .and. nMouseC>=11.and. nMouseC<=13 // left
       oTb:left()
       tbgo(oTb,{||oTb:left()})
     case nMouseR==23 .and. nMouseC>=17.and. nMouseC<=49 // escape
       keyboard chr(K_ESC)
     case  MBRZMOVE(oTb,nMouseR,nMouseC,2,2,22,78)
     case  MBRZCLICK(oTb,nMouseR,nMouseC)
       keyboard " "
     endcase
   endcase
ENDDO
return nil


static function tbgo(oTb,bBlock)
if rat_elbhd(.2)
    while rat_elbhd(.01)
        EVAL(bBlock)
        while !oTb:stabilize()
        end
    end
endif
return nil





