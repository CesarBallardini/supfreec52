#include "inkey.ch"

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DUPLOOK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DUPLOOK() Locates possible duplicates based on user criteria
ณ 
ณ  Returns:
ณ  --------
ณ  nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  DUPLOOK([cInfo],[aIndexes])
ณ 
ณ  Description:
ณ  ------------
ณ  Searches current dbf for exact duplicates of field(s)
ณ  selected by user. User picks a field or fields, DUPLOOK()
ณ  creates an index and prepares a possible duplicates report.
ณ 
ณ  [cInfo] is a character expression as additional info
ณ  for each report line printed. (report normally only refers to
ณ  record# and the fields selected )
ณ 
ณ  [aIndexes] is an array of currently open index files
ณ  to be reopened on exit from duplook() (up to 10)
ณ 
ณ  Examples:
ณ  ---------
ณ   aIndexOpen := {"CUSTOMER","STATE","ZIPCODE"}
ณ   DUPLOOK("Lastname+'  '+Firstname",aIndexOpen)
ณ   * the fields the user picks to check duplicates
ณ   * on,the LASTNAME and FIRSTNAME fields are also
ณ   * printed on the report.
ณ   Sample Output:
ณ   Record #    FNAME
ณ       1   GARRY
ณ       2   GARRY
ณ 
ณ  Warnings:
ณ  ----------
ณ  THIS FUNCTION CLOSES ANY OPEN INDEXES YOU WILL NEED
ณ  TO RE-OPEN INDEXES ON EXIT. (UNLESS YOU PASS AN ARRAY OF OPEN
ณ  INDEXES AS ABOVE...)
ณ 
ณ  Source:
ณ  -------
ณ  S_DUP.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION duplook(cAlsoDisplay,aOpenIndexes,aInFields,aInFdesc)
EXTERNAL kbdesc

local aFields,aFdesc,aTypes,aPicked,cHeader
local cIndexExpr       := ''
local bIndexExpr
local nFieldCount,lMoreInfo
local nIter
local cDupList          := ''
local cTempNTX          := ''
local cTempTextFile     := ''
local lCheckDone        := .F.
local nStartRec,nOldArea,cDbfName
local cOldList,nElement,nSelection,nHandle
local nDupsFound,nCounter,cPercent,expMacroCurrent,nRecordNbr,nChoice,cInscreen
local cPrintScreen,cOutFileName,cOldColor
local nOldCursor,bOldf10
local cUnderPick
local cCheckBox
local cWhereBox
local cWriteString
local bAlsoDisplay

IF !USED()
  RETURN ''
ENDIF
aOpenIndexes  := iif(aOpenIndexes#nil,aOpenIndexes,{})
asize(aOpenIndexes,10)
for nIter = 1 to 10
  if aOpenIndexes[niter]==nil
    aOpenIndexes[niter] := ""
  endif
next


*- store environment
cInscreen := SAVESCREEN(0,0,24,79)
cOldColor := Setcolor()
nOldCursor:= setcursor(0)
bOldf10   := SETKEY(K_F10)

*- was a paramater passed (addt'l info string)
lMoreInfo := (cAlsoDisplay#nil)
if lMoreInfo
  bAlsodisplay := &("{||"+cAlsoDisplay+"}")
endif

*- declare arrays for fields, types, and picked
if aInfields==nil
   nFieldCount     := Fcount()
   aFields         := array(nFieldCount)
   aTypes          := array(nFieldCount)
   Afields(aFields,aTypes)
else
   nFieldCount     := len(aInFields)
   aFields         := aclone(aInFields)
   aTypes          := array(nFieldCount)
   Fillarr(aFields,aTypes)
endif
if aInFdesc==nil
  aFdesc    := array(nFieldCount)
  acopy(aFields,aFdesc)
else
  aFdesc    := aclone(aInFdesc)
endif

aPicked := {}


Setcolor(sls_normcol())
@0,0,24,79 BOX sls_frame()
*- draw the screen
Setcolor(sls_popcol())
@1,1,7,45 BOX sls_frame()
@18,1,23,78 BOX sls_frame()

@09,1,14,78 BOX sls_frame()
@09,2 SAY '[ Directions: ]'
@10,2 SAY "     First select the field or fields on which you wish to search "
@11,2 SAY "for duplicate occurances (menu item 1). Then have the computer execute"
@12,2 SAY "the search (menu item 2).  Finally, view or print a Duplicate Report "
@13,2 SAY "(menu item 3).                                           "

@1,2 SAY '[ Duplicate Finder ]'
@18,2 SAY "[ Fields to check: ]"
SET PRINTER TO (sls_prn())

*- main loop
DO WHILE .T.
  GO TOP
  
  *- save dups list
  cOldList := cDupList
  
  *- display duplist
  sfdu_sayl(aPicked,aFdesc)
  
  *- do the menu
  Setcolor(sls_popmenu())
  nSelection := RAT_MENU2({;
                {02,3 ,"Select field(s) to compare"},;
                {03,3 ,"Build duplicate list"},;
                {04,3 ,"Generate duplicate reports"},;
                {05,3 ,"Choose Printer Port  (now "+sls_prn()+")"},;
                {06,3 ,"Quit"}},nSelection)
  Setcolor(sls_popcol())
  
  
  DO CASE
  CASE nSelection = 1
    
    aPicked := TAGARRAY(aFDesc, "Select Fields to check for Duplicates")
    
  CASE nSelection = 2 .AND. len(aPicked)>0
    
    *- look for duplicates, write them to a file


    *- make a temp index
    cTempNTX := UNIQFNAME(RIGHT(INDEXEXT(),3),getdfp())

    *- build indexing expression and header
    sfdu_figgr(aPicked, aFields, aTypes, ;
                @cIndexExpr, @bIndexExpr,@cHeader,lMoreInfo)

    ProgOn("Indexing")
    dbcreateindex(cTempNtx,"("+cIndexExpr+")",{||ProgDisp( recno(),recc() ),eval(bIndexExpr) },.f.)
    ProgOff()

    *- instructions

    cCheckBox :=makebox(09,20,15,60,sls_popcol())

    @10,22 SAY "Press ESC to ABORT"

    if !empty(cTempTextFile)
       erase (getdfp()+cTempTextFile)
    endif
    
    cTempTextFile := UNIQFNAME("",getdfp())
    
    *- create the file
    nHandle := Fcreate(getdfp()+cTempTextFile)
    
    *- write the cHeader to the file
    writefile(nHandle,'Record #   '+cHeader)
    
    *- no dups found yet
    nDupsFound := 0
    @11,22 SAY "Duplicates found : "+TRAN(nDupsFound,'9999')
    
    *- start at top
    GO TOP
    
    *- init a counter
    nCounter = 1
    locate for !empty(eval(bIndexExpr))
    *- do while ESC not pressed, and not end of file
    //DO WHILE !EOF() .AND. (!inkey() = 27) .and.( !rat_rightb())
    DO WHILE !EOF() .AND. !RAT_CHECKESC()
      
      *- determine cPercent done and display it
      cPercent = STR(INT(nCounter/RECC()*100),3)+'% done'
      @12,22 SAY cPercent
      
      *- get the value for the current record re: the index expression
      expMacroCurrent := eval(bIndexExpr)
      
      *- store the record #
      nRecordNbr = RECNO()
      
      *- go to next record
      SKIP
      
      *- increment nCounter by 1
      nCounter = nCounter + 1

      *- check for dups
      *- if the index expression for this record matches that of our
      *- previous one, Vern found a duplicate
      IF (!EOF()) .AND. (eval(bIndexExpr) == expMacroCurrent)

        *- write out the data on the first record
        skip -1
        IF lMoreInfo
          *- if there is an additional info string (param 1)
          *- include it as part of the print string
          cWriteString = STR(nRecordNbr,5)+SPACE(6)+expMacroCurrent+' '+eval(bAlsoDisplay)

        ELSE
          *- otherwise, just the record number + the index key
          cWriteString = STR(nRecordNbr,5)+SPACE(6)+expMacroCurrent

        ENDIF

        *- write the line to file
        writefile(nHandle,cWriteString)
        skip

        *- do while duplicate(s) found and no ESC key pressed
        DO WHILE (!EOF()) .AND. (eval(bIndexExpr) == expMacroCurrent) ;
                .AND. !RAT_CHECKESC()
                //.AND.(! inkey() = 27) .and. (!rat_rightb())

          *- increment dups found counter
          nDupsFound = nDupsFound +1

          *- for each duplicate found, write out a line
          IF lMoreInfo
            cWriteString = STR(RECNO(),5)+SPACE(6)+&cIndexExpr.+' '+eval(bAlsoDisplay)
          ELSE
            cWriteString = STR(RECNO(),5)+SPACE(6)+eval(bIndexExpr)
          ENDIF
          writefile(nHandle,cWriteString)

          *- info user of progress
          @11,22 SAY "Duplicates found : "+TRAN(nDupsFound,'9999')

          *- next record
          SKIP

          *- increment counter
          nCounter = nCounter + 1

        ENDDO

        *- write a blank line between duplicate sets
        writefile(nHandle,'  ')
      ENDIF
      
      
    ENDDO
    
    *- we've done a duplicates check
    lCheckDone = .T.
    
    *- close the dups file
    Fclose(nHandle)
    SET INDEX TO
    if !empty(cTempNtx)
       erase (getdfp()+cTempNtx)
    endif

    *- notify user
    @12,22 SAY "Done with duplicate location"
    @13,22 SAY "[Press a key......]"
    RAT_EVENT(0)
    
    unbox(cCheckBox)
    
  CASE nSelection = 2
    msg("Select fields to check first")
  CASE nSelection = 3 .AND. !lCheckDone
    *- can't view without locating first              && no locate done
    msg("Locate duplicates first (option 2)" )
    
    
  CASE nSelection = 3 .AND. lCheckDone
    
    *- make a menu
    cWhereBox=makebox(09,21,14,61,sls_popmenu())
    DO WHILE .T.
      nchoice := RAT_MENU2({;
                      {10,23 ,"View Listing of Duplicates"},;
                      {11,23 ,"Print Listing of Duplicates"},;
                      {12,23 ,"Send Listing to a File"},;
                      {13,23 ,"Quit"}},nChoice)
      
      *- based on nSelection
      DO CASE
        
      CASE nChoice = 1
        *- read file
        Fileread(2,2,23,78,getdfp()+cTempTextFile,"Duplicates")
        
      CASE nChoice = 2
        
        IF !messyn("Print this list?")
          LOOP
        ENDIF
        IF p_ready(sls_prn())
          SAVE SCREEN TO cPrintScreen
          COPY FILE (cTempTextFile) TO (sls_prn())
          RESTORE SCREEN FROM cPrintScreen
        ENDIF
        

      CASE nChoice = 3
        
        *- get filename
        cOutFileName = SPACE(12)
        popread(.F.,"Filename to write to : ",@cOutFileName,"@!")
        
        *- write to the file
        IF !EMPTY(cOutFileName)
          SAVE SCREEN TO cPrintScreen
          COPY FILE (cTempTextFile) TO (cOutFileName)
          RESTORE SCREEN FROM cPrintScreen
        ENDIF
        
        
      CASE nChoice = 4
        EXIT
        
      ENDCASE
      
    ENDDO
    unbox(cWhereBox)
    
    
  CASE nSelection = 4
    sls_prn(prnport())   
  CASE nSelection = 5 .OR. nSelection = 0
    SET INDEX TO (aOpenIndexes[1]),(aOpenIndexes[2]),(aOpenIndexes[3]),(aOpenIndexes[4]),(aOpenIndexes[5]),(aOpenIndexes[6]),(aOpenIndexes[7]),(aOpenIndexes[8]),(aOpenIndexes[9]),(aOpenIndexes[10])
    if !empty(cTempNTX)
       erase (getdfp()+cTempNTX)
    endif
    if !empty(cTempTextFile)
       erase (getdfp()+cTempTextFile)
    endif
    RESTORE SCREEN FROM cInscreen
    Setcolor(cOldColor)
    setcursor(nOldCursor)
    SETKEY(-9,bOldf10)
    
    RETURN ''

  ENDCASE
ENDDO
return ''


static FUNCTION sfdu_sayl(aPicked,aFdesc)
local cDupList := ""
local nIter
for nIter = 1 to len(aPicked)
  cDuplist+= aFdesc[ aPicked[nIter] ]+' '
next
Scroll(19,2,22,77,0)
@19,3 SAY SUBST(cDupList,1,70)
@20,3 SAY SUBST(cDupList,71,70)
@21,3 SAY SUBST(cDupList,141,70)
@22,3 SAY SUBST(cDupList,211,70)
RETURN ''


static FUNCTION sfdu_figgr (aPicked, aFields, aTypes, ;
                cIndexExpr, bIndexExpr,cHeader,lMoreInfo)
local cFieldType,cFieldName,nCounter,cIndexPart,nExpLength
local nNameLength,cHeaderElem
local cFiller

cIndexExpr  := ''
cHeader     := ''

*- check all fields in the
FOR nCounter = 1 TO len(aPicked)
  

    *- determine name and type
    cFieldType := aTypes[aPicked[nCounter]]
    cFieldName := aFields[aPicked[nCounter]]
    
    *- if its not a memo field
    IF !cFieldType == "M"
      
      *- determine index key expression for that field (eval to character type)
      *- also determine length of the field expression
      DO CASE
        
      CASE cFieldType == "C"
        cIndexPart := aFields[aPicked[nCounter]]
        nExpLength := LEN(&cFieldName)
        
      CASE cFieldType == "N"
        cIndexPart := 'TRANS('+aFields[aPicked[nCounter]]+',"@Z")'
        nExpLength := LEN(TRANS(&cFieldName,"@Z"))
        
      CASE cFieldType == "D"
        cIndexPart := "DTOC("+aFields[aPicked[nCounter]]+')'
        nExpLength := 8
        
      CASE cFieldType == "L"
        cIndexPart := 'IIF('+aFields[aPicked[nCounter]]+',"T","F")'
        nExpLength := 1
        
      ENDCASE
      
      *- determine length of the field name
      nNameLength := LEN(aFields[aPicked[nCounter]])
      
      *- create appropriate cHeader, left justified for char
      *- right justified for numeric
      *- and with appropriate filler space to match expression length
      IF cFieldType == "N"
        cHeaderElem := SPACE(MAX(0,nExpLength-nNameLength))+aFields[aPicked[nCounter]]
      ELSE
        cHeaderElem := aFields[aPicked[nCounter]]+SPACE(MAX(0,nExpLength-nNameLength))
      ENDIF
      
      cFiller := ALLTRIM(STR(MAX(0,LEN(cHeaderElem)-nExpLength)))
      cFiller := iif(empty(cFiller),"0",cFiller)
      
      *- format expression to match cHeader
      cIndexExpr +=  cIndexPart+ '+space('+cFiller+')+" "+'
      
      *- prepare cHeader
      cHeader += cHeaderElem+' '
      
    ENDIF
NEXT

*- remove final '+' from expression
cIndexExpr  := LEFT(cIndexExpr,LEN(cIndexExpr)-1)
bIndexExpr  := &("{||"+cIndexExpr+"}")

cHeader     := iif(lMoreInfo,cHeader+" Other Information",cHeader)

RETURN nil



