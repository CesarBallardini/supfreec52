#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#define LIST_NAME   1
#define LIST_TITLE  2
#define LIST_LENGTH 3
#define LIST_BLOCK  4
#define LIST_TYPE   5
#define LIST_POSIT  6

static aList
static nSpaceBetween,nCharsLine,nLinesPP
static aFieldNames,aFieldDesc,aColumns,aFieldTypes,aFieldLens,aFieldDeci

/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION LISTER()
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
³ 
³  Short:
³  ------
³  LISTER() Build, format,print SIMPLE lists to
³  printer,screen,file
³
³  Returns:
³  --------
³  Nothing
³
³  Syntax:
³  -------
³  LISTER([aNames,aDesc])
³ 
³  Description:
³  ------------
³  A menu driven utility for creation, printing and
³  storage of list definitions.
³ 
³  The user is asked to pick the fields to be included
³  on the list. The selected fields, in the order in which
³  they will be listed, are shown in the bottom information box.
³  The user may select which records are to be included in the list -
³  all records, query matches or tagged records.
³ 
³  The user may select output as PRINTER, SCREEN or
³  FILE, and choose the maximum line length to avoid printer
³  wraparound.
³ 
³  The user may save list definitions to PLIST.DBF and
³  later restore them.
³ 
³  Two arrays may be passed - fieldnames [aNames], and
³  field descriptions [aDesc] Pass both or none. Normally, field
³  names are used as the column headings for the list, but if
³  [aDesc] is passed, these descriptions are used in the column
³  headings of corresponding fields.
³ 
³  By default, all fields are used, field names are used
³  for descriptions.
³ 
³  Examples:
³  ---------
³   USE CUSTOMER
³ 
³   LISTER()
³ 
³  Source:
³  -------
³  S_LIST.PRG
³
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
*/
function lister(aInFields,aInDesc)
local cInScreen,cOldColor,lOldExact,bOldF10,nStartRec
local nMainSelect,nOldArea
local cListDesc := space(45)
local nOldCursor := setcursor(0)

IF !Used()
  RETURN ''
ENDIF
aFieldNames := aInFields
aFieldDesc  := aInDesc
if aFieldNames==nil
  aFieldNames := array(fcount())
  afields(aFieldNames)
endif
if aFieldDesc==nil
  aFieldDesc := array(fcount())
  afields(aFieldDesc)
endif
aFieldTypes := array(len(aFieldNames))
aFieldLens  := array(len(aFieldNames))
aFieldDeci  := array(len(aFieldNames))

fillarr(aFieldnames,aFieldtypes,aFieldLens,aFieldDeci)
aList       := {}
nSpaceBetween := 1
nCharsLine    := 79
nLinesPP      := 60

aColumns := buildcolumns()


*- save the environment
cInScreen := savescreen(0,0,24,79)
cOldColor := Setcolor(sls_normcol())
lOldExact := setexact()
bOldF10   := setkey(-9)
nStartRec := RECNO()
SET PRINTER TO (sls_prn())

*-- draw screen
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,12,50 BOX sls_frame()
@1,5 SAY '[List Builder]'
@21,1,23,78 BOX sls_frame()
*-- Main Loop
DO WHILE .T.
  DISPBEGIN()
  *- do a menu
  Setcolor(sls_popmenu())
  scroll(22,2,22,77,0)
  if aListLen(aList) > 0
    @22,2 SAY "LIST ACTIVE (Using: "
    ??alltrim(str(aListLen(aList)))
    ??' printer columns )'
  else
    @22,2 say "NO LIST ACTIVE"
  endif
  devpos(9,24)
  devout(IIF(EMPTY(sls_query()),"(No Query    )","(Query Active)"))
  devpos(8,24)
  devout("(now "+sls_prn()+")" )
  DISPEND()

  nMainSelect := RAT_MENU2({;
                        {02,3 ,"Pick fields to list"},;
                        {03,3 ,"Modify fields to list"},;
                        {04,3 ,"Output list "},;
                        {05,3 ,"Save list definition to disk"},;
                        {06,3 ,"Restore list definition from disk"},;
                        {07,3 ,"Delete stored definitions"},;
                        {08,3 ,"Choose Printer Port  "},;
                        {9 ,3 ,"Build Query          "},;
                        {10,3 ,"Layout Options"},;
                        {11,3 ,"Quit"}},nMainSelect)

  Setcolor(sls_popcol())
  
  DO CASE

  CASE nMainSelect = 1 .OR. nMainSelect = 2
    if nMainSelect = 1
      aList := {}
    endif
    buildlist()
  CASE nMainSelect = 3  .AND. len(aList) > 0
    printlist()
  CASE nMainSelect = 4 .AND. len(aList) > 0
    putlist(cListDesc)
  CASE nMainSelect = 5
    aList     := {}
    cListDesc := getlist()
  CASE nMainSelect =  6
    IF FILE(slsf_list()+".DBF")
      nOldarea = SELECT()
      SELECT 0
      IF SNET_USE(slsf_list(),"",.T.,5,.T.,"Network error opening LIST file. Keep trying?")
        IF USED()
          purgem()
          USE
        ENDIF
      ENDIF
      SELECT (nOldarea)
    ELSE
      MSG("No list file found.")
    ENDIF
  CASE nMainSelect =  7
    sls_prn(prnport())
  CASE nMainSelect =  8
    QUERY(aFieldNames,aFieldDesc,aFieldTypes,"To Lister")
  CASE nMainSelect =  9  // layout options
    popread(.F.,"Maximum line length to print:   ",@nCharsLine,"999",;
                "Spaces between columns (fields)   ",@nSpaceBetween,"9",;
                "Lines per page to print          ",@nLinesPP,"99")
  CASE nMainSelect =  10 .OR. nMainSelect = 0
    GO nStartRec
    SETEXACT(lOldExact)
    SETKEY(-9,bOldF10)
    restscreen(0,0,24,79,cInScreen)
    Setcolor(cOldColor)
    setcursor(nOldCursor)
    exit
  ENDC
ENDD
aList:=nSpaceBetween:=nCharsLine:=nLinesPP:=nil
aFieldNames:=aFieldDesc:=aColumns:=aFieldTypes:=aFieldLens:=aFieldDeci:=nil
return nil
//-------------------------------------------------------------
static function aListLen(aList)
local nLen := 0
local i
for i = 1 to len(aList)
  nLen+= aList[i,LIST_LENGTH]+nSpaceBetween
next
nLen := max(0,nLen-nSpaceBetween)
return nLen

//-------------------------------------------------------------
#DEFINE K_PLUS 43

static function buildlist

local aLocalList := aclone(aList)
local cPopBox    := makebox(0,0,24,79,sls_normcol(),0)
local nChoice
local nElement   := 1
local nLastKey, nMouseR, nMouseC, aButtons
local nFieldPos := 0
local nColPos, nButton
local oTb        := tbrowseDB(3,1,14,min(78,aListLen(aList)+1))
local i

for i = 1 to len(aLocalList)
  oTb:addcolumn( aLocalList[i,LIST_BLOCK] )
next
oTb:colsep := "³"
oTb:headsep := "Ä"
oTb:colorspec := sls_popcol()
@ 2,0 SAY 'Ã'
@ 2,79  SAY '´'
@ 15,0  SAY 'Ã'
@ 15,79 SAY '´'
@ 21,0  SAY 'Ã'
@ 21,79 SAY '´'
@ 21,1  SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 16,30 SAY "³                  ³"
@ 17,30 SAY "³                  ³"
@ 18,30 SAY "³                  ³"
@ 19,30 SAY "³                  ³"
@ 20,30 SAY "³                  ³"
@ 2,1   SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 15,1  SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"

@ 1,31 SAY  "Field List Builder"
@ 17,7 SAY  "[INS=InsertField]"
@ 17,33 say "[F10=Done     ]"
@ 17,53 say "[DEL=Delete Field]"
@ 19,7 SAY  "[PLUS=Add Field ]"
@ 19,53 say "[ESC=Cancel      ]"
@ 19,33 say "[] [] [] []"

abuttons := {;
            {17,7,17,23,K_INS},;
            {17,33,17,47,K_F10},;
            {17,53,17,70,K_DEL},;
            {19,7,19,23,K_PLUS},;
            {19,53,19,70,K_ESC} }


@ 22,23 SAY "Selected Fields       Report Width"
dispbox(3,1,14,78,space(9),sls_popcol())

while .t.
  dispbegin()
  @ 23,29 SAY trans(len(aLocalList),"99") color sls_popcol()
  @ 23,48 SAY trans(aListLen(aLocalList),"999") color sls_popcol()
  if len(aLocalList) > 0
    while !oTb:stabilize()
    end
    @ 15,1 say iif(oTb:leftvisible>1,repl(chr(17),4),repl(chr(196),4)) color sls_normcol()
    @ 15,75 say iif(oTb:rightvisible<oTb:colcount,repl(chr(16),4),repl(chr(196),4)) color sls_normcol()
  endif
  dispend()
  nLastKey := rat_event(0,.f.)
  nMouseR  := rat_eqmrow()
  nMouseC  := rat_eqmcol()
  nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  do case
  case nLastKey = K_F10 .or. nbutton == K_F10
     aList := aLocalList
     exit
  case (nLastKey = K_INS .or. nLastKey == K_PLUS .OR. ;
                   nButton = K_INS .or. nButton==K_PLUS)
     if len(aList) < 18
       if (nFieldPos := getlfield(nFieldPos) ) > 0
          aadd(aLocalList,"")
          if nLastKey = K_INS .or. nButton==K_INS
            ncolPos := max(1,oTb:colpos)
          else
            ncolPos := iif(oTb:colcount>0,oTb:colpos+1,1)
            oTb:right()
          endif
          oTb:inscolumn(nColPos,aColumns[nFieldPos] )
          ains(aLocalList,nColPos)
          aLocalList[nColPos] := {aFieldNames[nFieldPos],;
                 aFieldDesc[nFieldPos],;
                 max(aFieldLens[nFieldPos],len(aFieldDesc[nFieldPos])),;
                 aColumns[nFieldPos],;
                 aFieldTypes[nFieldPos],;
                 nFieldPos}
           dispbox(3,1,14,78,space(9),sls_popcol())
           oTb:nright := min(78,aListLen(aLocalList)+1)
           oTb:configure()
           oTb:refreshall()
       endif
     else
       msg("Maximum fields added")
     endif
  case (nLastKey = K_DEL .or. nButton==K_DEL).and. len(aLocalList) > 0
     oTb:delcolumn(oTb:colpos)
     adel(aLocalList,oTb:colpos)
     asize(aLocalList,len(aLocalList)-1)
     oTb:nright := min(78,aListLen(aLocalList)+1)
     oTb:configure()
     oTb:refreshall()
     dispbox(3,1,14,78,space(9),sls_popcol())
  case nLastKey = K_ESC .or. nButton==K_ESC
     exit
  case nLastKey = K_LEFT
     oTb:left()
  case nLastKey = K_RIGHT
     oTb:right()
  case nLastKey = K_UP
     oTb:up()
  case nLastKey = K_DOWN
     oTb:down()
  case nLastKey = K_PGUP
     oTb:pageup()
  case nLastKey = K_PGDN
     oTb:pagedown()
  case nLastKey = K_HOME
     oTb:gotop()
  case nLastKey = K_END
     oTb:gobottom()
  case ISMOUSEAT(nMouseR, nMouseC, 19,33,19,35)
     oTb:up()
     IFMOUSEHD({||oTb:up()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC, 19,37,19,39)
     oTb:down()
     IFMOUSEHD({||oTb:down()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC, 19,41,19,43)
     oTb:right()
     IFMOUSEHD({||oTb:right()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC, 19,45,19,47)
     oTb:left()
     IFMOUSEHD({||oTb:left()},oTb)
  endcase
end
unbox(cPopBox)
return nil

//---------------------------------------------------------
static function getlfield(nFieldPos)
local nField := nFieldPos
local cBox   := makebox(2,21,16,49,sls_popcol())
nField       := Sachoice(3,22,15,48,aFieldDesc,nil,nField,nil,16,40,{||KBDESC()})
unbox(cBox)
if nField > 0 .and. FIELDTYPEX(aFieldNames[nField])=="M"
    msg("MEMO fields not allowed.")
    nField := 0
endif
return nField
//---------------------------------------------------------
static function buildcolumns
local aColumns := {}
local i
for i = 1 to len(aFieldNames)
  // aadd(aColumns,tbColumnNew(aFieldDesc[i],fieldblock(field(i))) )
  aadd(aColumns,tbColumnNew(aFieldDesc[i],expblock(aFieldNames[i] )) )
next
return aColumns
//---------------------------------------------------------
static function getcolumn(cFieldName)
local nPosition := ascan(aFieldNames,cFieldName)
if nPosition > 0
   return aColumns[nPosition]
endif
return nil
//---------------------------------------------------------
static function printlist
local nPrintQuant,cInScreen
local nDestination,nQueryType
local nQueryBlock,cOutFile
local aTags := {}

*- default number to print
nPrintQuant := RECC()

cInscreen := savescreen(0,0,24,79)
DO WHILE .T.

  nDestination := menu_v("[Send to: ]",;
                         "Printer",;
                         "Text File",;
                         "Screen",;
                         "Quit")

  IF nDestination < 4 .and. nDestination > 0
    GO TOP
    nQueryType := menu_v("[Record Selection]",;
                         "All Records           ",;
                         "Query Matches      ",;
                         "Tagged Records         ")

    DO CASE
    CASE nQueryType = 2 .AND. !EMPTY(sls_query())
      IF messyn("Modify current Query ?")
        QUERY(aFieldNames,aFieldDesc ,aFieldTypes,"To Lister")
      ENDIF
      nQueryBlock := IIF(empty(sls_query()),{||.t.},sls_bquery())
    CASE nQueryType = 2
      QUERY(aFieldNames,aFieldDesc,aFieldTypes)
      nQueryBlock := IIF(empty(sls_query()),{||.t.},sls_bquery())
    CASE nQueryType = 3
      tagit(aTags,aFieldNames,aFieldDesc)
      nQueryBlock := IIF(len(aTags)=0,{||.t.},{||ascan(aTags,recno())>0 })
    OTHERWISE
      nQueryBlock := {||.t.}
    ENDCASE

    nPrintQuant   := RECC()
    nPrintQuant   := INT(nPrintQuant)

    popread(.F.,"Maximum records to print (default = ALL) ",;
                @nPrintQuant,REPL("9",LEN(LTRIM(STR(nPrintQuant)))))
    IF !messyn("Print this list now ?")
      EXIT
    ENDIF
  ENDIF

  DO CASE
  CASE nDestination = 1
    *- test for printer ready
    IF !p_ready(sls_prn())
      EXIT
    ENDIF
    SET PRINT ON
    printit(nDestination,nPrintQuant,nQueryBlock)
    SET PRINT OFF
    SET PRINTER TO
    SET PRINTER TO (sls_prn())
  CASE nDestination = 2
    cOutFile := SPACE(12)
    popread(.F.,'File name to write to: ',@cOutFile,'@!')
    cOutFile := upper(trim(cOutFile))
    IF EMPTY(cOutFile)
      EXIT
    ENDIF
    IF !"."$cOutFile
       cOutFile := cOutFile+".TXT"
       msg("File will be sent to disk as "+cOutFile)
    endif
    ERASE (getdfp()+cOutFile)
    SET ALTERNATE TO (cOutFile)
    SET ALTERNATE ON
    printit(nDestination,nPrintQuant,nQueryBlock)
    SET ALTERNATE OFF
    CLOSE ALTERNATE
    if messyn("Would you like to view the file now?")
      Fileread(1,1,23,79,getdfp()+cOutFile,"List Results")
    endif
  CASE nDestination = 3
    *- send it to our own file
    cOutFile := UNIQFNAME("LST",getdfp())
    SET ALTERNATE TO (cOutFile)
    SET ALTERNATE ON
    printit(nDestination,nPrintQuant,nQueryBlock)
    SET ALTERNATE OFF
    CLOSE ALTERNATE
    Fileread(1,1,23,79,getdfp()+cOutFile,"List Results")
    ERASE (getdfp()+cOutFile)
  ENDCASE
  EXIT
ENDDO
restscreen(0,0,24,79,cInScreen)
return nil


static FUNCTION printit(nDestination,nPrintQuant,nQueryBlock)
local lFirstPage := .t.
local cDate := CMONTH(DATE())+' '+LTRIM(STR(DAY(DATE())))+', '+;
               TRANS(YEAR(DATE()),"9999")
local ncurrentLine := 1
local nCharsDone   := 0
local nRecordsDone := 0
local nPageNumber  := 1
local nQuant       := 0
local cHeader      := buildheader(@nQuant)
SET EXACT OFF
LOCATE FOR eval(nQueryBlock)

plswait(.T.,"Building Report - ESCAPE to cancel")

SET CONSOLE OFF
CLEAR TYPEAHEAD
WHILE FOUND() .AND. nRecordsDone <= nPrintQuant
  nCharsDone      := 0
  IF ncurrentLine = 1
    IF nDestination = 1
      IF !lFirstPAge
        EJECT
      ENDIF
      lFirstPAge  := .F.
    ELSE
      ?
      ?
    ENDIF
    ??cDate
    ??SPACE(nCharsLine-LEN(cDate)-9)+'Page #'+TRANS(nPageNumber,"999")
    ?REPL('-',nCharsLine)
    ?cHeader
    ?REPL('-',nCharsLine)
    nPageNumber++
    nCurrentLine := 5
  ENDIF
  ?
  printline(nQuant)
  nRecordsDone++
  nCurrentLine = IIF(ncurrentLine >=nLinesPP,1,ncurrentLine+1)
  //IF inkey() = 27 .or. rat_rightb()
  IF RAT_CHECKESC()
    CLEAR TYPEAHEAD
    EXIT
  ENDIF
  CONTINUE
END
SET CONSOLE ON
IF nDestination = 1
  EJECT
ENDIF
SET EXACT OFF
plswait(.F.)
RETURN ''

//-------------------------------------------------------------------
static function buildheader(nQuant)
local i
local cHeader := ""
local cThisType
local cThisTitle
local nThisWidth
for i = 1 TO len(aList)
  nThisWidth := aList[i,LIST_LENGTH]
  if len(cHeader)+nThisWidth > nCharsLine
    exit
  endif
  nQuant := i
  cThisTitle := ALLTRIM(aList[i,LIST_TITLE])
  cThisType  := aFieldTypes[ascan(aFieldNames,aList[i,LIST_NAME]) ]
  cHeader+= iif(cThisType=="N",padl(cThisTitle,nThisWidth),padr(cThisTitle,nThisWidth) )
  if len(cHeader)+nSpaceBetween <= nCharsLine .and. i < len(aList)
    cHeader += space(nSpaceBetween)
  endif
NEXT
return (cHeader)

//-------------------------------------------------------------------
static function PrintLine(nQuant)
local i
for i = 1 to nQuant
   DO CASE
   CASE aList[i,LIST_TYPE]$"CD"
     ??PADR( eval(aList[i,LIST_BLOCK]:block),aList[i,LIST_LENGTH])
   CASE aList[i,LIST_TYPE]=="L"
     ??PADR(IIF(EVAL(aList[i,LIST_BLOCK]:block),".T.",".F."),aList[i,LIST_LENGTH])
   CASE aList[i,LIST_TYPE]=="N"
     ??PADL(ALLTRIM(STR(EVAL(aList[i,LIST_BLOCK]:block))),aList[i,LIST_LENGTH])
   ENDCASE
   if i<nQuant
     ??space(nSpaceBetween)
   endif
next
return nil


//-------------------------------------------------------------------
static function putlist(cDescript)
local cNewDesc   := cDescript
local nOldArea   := SELE()
local cListFile  := slsf_list()
local cListList  := parselist()

SELE 0
IF !FILE(cListFile+".DBF")
   DBCREATE(cListFile,{{"DESC","C",45,0},{"LIST","C",200,0}})
ENDIF
IF SNET_USE(cListFile,"__LIST",.F.,5,.T.,"Network error opening LIST file. Keep trying?")
   popread(.T.,"Enter a description for this List ",@cNewDesc,"@!")
   IF !EMPTY(cNewDesc)
     locate for __LIST->DESC==cNewDesc .and. !deleted()
     if found()
       if messyn("Overwrite existing record by that name?") .AND. ;
            SREC_LOCK(5,.T.,"Unable to lock record to save. Keep trying?")
         REPLACE __list->DESC WITH cNewDesc,__list->list WITH parselist()
         cDescript := cNewDesc
         UNLOCK
       endif
     ELSE
       locate for deleted() // attempt to re-use deleted records
       if found() .and. SREC_LOCK(5,.T.,"Unable to lock record to save. Keep trying?")
         REPLACE __list->DESC WITH cNewDesc,__list->list WITH parselist()
         cDescript := cNewDesc
         DBRECALL()
         UNLOCK
       ELSEIF SADD_REC(5,.T.,"Network error adding record. Keep trying?")
         REPLACE __list->DESC WITH cNewDesc,__list->list WITH parselist()
         cDescript := cNewDesc
         UNLOCK
       endif
     endif
   ENDIF
ENDIF
USE
SELE (nOldArea)
return cDescript
//-----------------------------------------------------------------
static function parselist()
local cList := ""
local i
for i = 1 to len(aList)
 if i = len(aList)
   cList += aList[I,LIST_NAME]
 else
   cList += aList[I,LIST_NAME]+","
 endif
next
return cList

//-----------------------------------------------------
static function list2array
local aListFields
local cList  := alltrim(__LIST->list)
altd()
cList        := [{"]+strtran(cList,",",[","])+["}]
aListFields  := &(cList)    // build an array
return aListFields

//-----------------------------------------------------
static function checklist(aFieldList)
local lValid := .t.
local i
for i = 1 to len(aFieldList)
  if aScan(aFieldNames,aFieldList[i])=0
    lValid := .f.
    exit
  endif
next
return lValid

//-------------------------------------------------------------------
static function getlist
local cListDesc := ""
local nOldArea  := SELECT()
local nKounter,nPicker
local aDesc     := {}
local aRecNo    := {}
local cListFile := slsf_list()
local aFieldList
local nAtPosit
local i
SELE 0
*- check for file
IF !FILE(cListFile+".DBF")
  msg("No lists stored in this directory")
elseif SNET_USE(cListFile,"__LIST",.F.,5,.T.,;
       "Network error opening LIST file. Keep trying?")
    *- store the values in the arrays
    FOR nKounter = 1 TO RECC()
      GO nKounter
      IF !DELETED()
        AADD(aDesc, __LIST->DESC)
        AADD(aRecNo,RECNO())
      ENDIF
    NEXT
    if len(aDesc) = 0
      msg("No matching lists found")
    endif
    WHILE len(aDesc) > 0
      *- get a selection
      nPicker := mchoice(aDesc,5,20,MIN(6+LEN(aDesc),20),70,'[Pick List]')
      *- if one was selected
      IF !nPicker=0

        *- go there, and pick up the field list as stored
        GOTO (aRecNo[nPicker])
        aFieldList := list2array()
        if checklist(aFieldList)
          cListDesc := __LIST->desc
          aList     := {}
          for i = 1 to len(aFieldList)
            nAtPosit := aScan(aFieldNames,aFieldList[i])
            aadd(aList,{nil,nil,nil,nil,nil,nil})
            aList[i,LIST_NAME]   := aFieldNames[nAtPosit]
            aList[i,LIST_TITLE]  := aFieldDesc[nAtPosit]
            aList[i,LIST_LENGTH] := max(aFieldLens[nAtPosit],;
                                    len(aList[i,LIST_TITLE]))
            aList[i,LIST_BLOCK]  := aColumns[nAtPosit]
            aList[i,LIST_TYPE]   := aFieldTypes[nAtPosit]
            aList[i,LIST_POSIT]  := nAtPosit
          next
          exit
        ELSE
          *- if not successful
          if !messyn("Invalid list for current datafile","Try Again","Cancel")
            EXIT
          ENDIF
        ENDIF
      else    // nPicker = 0
        exit
      ENDIF
    END       // enddo
endif
USE
SELE (nOldArea)
return (cListDesc)



