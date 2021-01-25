static nLeftMargin,nTopMargin,lPauseFirst,nFormWidth
static bLocater,cDestination
static nSelectedArea,cWorkForm
static aFields,aFdesc,aFtype,aUexpress,aUkeys
static aTagged,aHelp,nUserDef

#define MAXFORMSIZE 4000

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FORMLETR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FORMLETR() Interactive formletter and mailmerge utility
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  FORMLETTER([aNames,aDesc,aTypes];
ณ        [aMoreFuncs,aMoreDesc,aMoreHot])
ณ 
ณ  Description:
ณ  ------------
ณ  Provides a menu driven interface to the creation,
ณ  modification and merging/printing of form letters with DBFs.
ณ 
ณ  Three field arrays may be passed - [aNames] is an
ณ  array of allowable field names, [aDesc] is an array of
ณ  field descriptions, and [aTypes] is an array of field types. All
ณ  fields are used as a default, with field names being the default
ณ  field descriptions. Pass all or none of the first three arrays.
ณ 
ณ  Three additional arrays may be passed for up to 30
ณ  additional hotkeys.
ณ 
ณ  [aMoreFuncs] is an array of functions which will be
ณ  placed between ฎฏ delimiters. [aMoreDesc] is a corresponding
ณ  descriptive array of these functions, to be shown when the user
ณ  presses F1. Format:
ณ 
ณ       "hotkey     description "
ณ        | column 1 |column 17
ณ 
ณ  [aMoreHot] is the corresponding hotkeys as their
ณ  numeric ascii values.
ณ 
ณ  All three arrays must be passed, if any, and all must
ณ  be of same length with no null or undefined elements.
ณ 
ณ  You could use these for Printer control, special
ณ  combined fields, etc. Be sure the functions you wish to call are
ณ  available to the linker, usually by declaring them EXTERNAL.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  USE CUSTOMER
ณ 
ณ  aFields := {"Fname","lname","mi"}
ณ  aDesc   := {"First","Last","Middle"}
ณ  aTypes  := {"C","C","C"}
ณ 
ณ  * hotkey arrays
ณ  aMoreFuncs := {"BOLD_ON()","BOLD_OFF"}
ณ 
ณ  aMoreDesc  := {"F5    BOLD PRINT ON", "F6    BOLD PRINT OFF"}
ณ  aMoreKeys  := {K_F5,K_F6}
ณ 
ณ  FORMLETR(aFields,aDesc,aTypes,  ;
ณ             aMoreFuncs,aMoreDesc,aMoreKeys)
ณ 
ณ  //or...
ณ 
ณ  USE CUSTOMER
ณ  FORMLETR()
ณ 
ณ  Notes:
ณ  -------
ณ  See index for notes on using a different file name
ณ  for FORM.DBF
ณ 
ณ  Source:
ณ  -------
ณ  S_FORML.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION formletr(aInField,aInfdescr,aInftype,aInUexpress,aInUdescrip,aInUkeys)


LOCAL nFieldCount,cCurrFormDes,nMainSelect
LOCAL nSelection,cDescription
local lUseQuery,nCount,cImpFile,lUseTag,cMainScreen,cOldColor
local cShowFilter,nFilterType,cFormsFile
local nCursor, bOldF1,bOldF2,bOldF10
local nSinglerec := 0

nUserDef  := iif(aInUexpress#nil,min(30,len(aInUexpress)),0)
aHelp := sfll_makeh(aInUexpress,aInUdescrip,aInUkeys)

cFormsFile      := SLSF_FORM()

* assumes dbf is open
IF !USED()
  RETURN ''
  msg("No DBF file open currently")
ENDIF

nSelectedArea   := SELECT()

*- save environment
cMainScreen     := SAVESCREEN(0,0,24,79)
cOldCOlor       := Setcolor()
nCursor         := SETCURSOR(0)
bOldF1          := SETKEY(28)
bOldF2          := SETKEY(-1)
bOldF10         := SETKEY(-9)

*- select a new area for forms.dbf
SELE 0


* create form if it doesn't exist
IF !FILE(cFormsFile+".DBF")
    blddbf(cFormsFile,"DESCRIPT,C,50:MEMO_ORIG,M:")
ENDIF
*- open forms.dbf

IF !SNET_USE(cFormsFile,"__FORM",.F.,5,.F.,"Unable to open "+cFormsFile+". Keep trying?")
   sele (nSelectedArea)
   return ''
endif

*- go back to first area
select (nSelectedArea)

SET CURSOR ON
plswait(.T.)
*- make field arrays
if valtype(aInField)+valtype(aInfdescr)+valtype(aInftype)=="AAA"
  aFields := aInField
  aFdesc  := aInFdescr
  aFtype  := aInftype
else
  aFields := array(fcount())
  aFdesc  := array(fcount())
  aFtype  := array(fcount())
  Afields(aFields,aFtype)
  Afields(aFdesc)
ENDIF
aUExpress := aInUexpress
aUKeys    := aInUkeys


*- get nFieldCount
nFieldCount = Fcount()
plswait(.F.)

*- draw the screen
Setcolor(sls_normcol())

@0,0,24,79 BOX "ฺฤฟณูฤภณ "
Setcolor(sls_popcol())
@1,1,13,32 BOX "ฺฤฟณูฤภณ "
@20,1,23,78 BOX "ฺฤฟณูฤภณ "
@1,2 SAY '[Form Letters Utility]'


*- no current form
cCurrFormDes := SPACE(50)
*- default form width
nFormWidth   := 79

*- default output
cDestination := "PRINTER"

*- default device (_SUPERPRN is initialized by INITSUP)
SET PRINTER TO (sls_prn())

nLeftMargin := 0
nTopMargin  := 0
cShowFilter := "ALL RECORDS   "
bLocater    := {||.t.}
lPauseFirst := .F.
*- set keys
SET KEY -1 TO
SET KEY 28 TO
DO WHILE .T.
  Setcolor(sls_popmenu())
  
  *- display  - is query active
  @1,65 SAY IIF(EMPTY(sls_query()),"[No Query    ]","[Query Active]")
  *- display current form
  @21,4  SAY "CURRENT FORM ->"+cCurrFormDes
  *- display current datafile
  @22,4  SAY "DATAFILE     ->"+ALIAS()

  *- do the menu
  *GO TOP
  nMainSelect := RAT_MENU2({;
            {02,4 ,"Select form"},;
            {03,4 ,"Create new Form"},;
            {04,4 ,"Delete Forms"},;
            {05,4 ,"Edit current form"},;
            {06,4 ,"Print form letters"},;
            {07,4 ,"Width of Form :"+TRANS(nFormWidth,"999")},;
            {08,4 ,"Output to :"+cDestination},;
            {09,4 ,"Assign Printer Port"},;
            {10,4 ,"Filter :"+cShowFilter},;
            {12,4 ,"Quit"}},nMainSelect)
  Setcolor(sls_popcol())
  
  
  *- do action based on request
  DO CASE
  CASE nMainSelect = 1
    *- select a predefined formletter to work with
    SELE __FORM
    IF RECC() > 0
      nSelection := sffl_pick()
      IF nSelection > 0
        GO nSelection
        cCurrFormDes := __FORM->descript
      ELSE
        GO TOP
        cCurrFormDes := ""
      ENDIF
    ELSE
      msg("No forms on file")
    ENDIF
    select (nSelectedArea)
    
  CASE nMainSelect = 2
    
    *- create a new form letter
    cDescription := SPACE(50)
    do while empty(cDescription)
      popread(.T.,"Enter a description for the form letter",@cDescription,"@!")
      if empty(cDescription)
        if messyn("You've left the name blank - abandon the process?")
            exit
        endif
      endif
    enddo
    if empty(cDescription)
      loop
    endif
    cWorkForm := ""
    IF !messyn("Use another form letter as a shell ?","No","Yes")
      SELE __FORM
      IF RECC() > 0
        nSelection := sffl_pick()
        IF nSelection > 0
          GO nSelection
        ENDIF
        cWorkForm := __FORM->memo_orig
      ELSE
        msg("No forms on file")
      ENDIF
      select (nSelectedArea)
    ELSE
      IF !messyn("Import a text file as a shell ?","No","Yes")
        cImpFile := SPACE(12)
        popread(.T.,"File to import (ENTER or *Wildcards for picklist - ESC to exit)",@cImpFile,"")
        IF !LASTKEY() = 27
          IF EMPTY(cImpFile) .OR. AT('*',cImpFile) > 0
            IF EMPTY(cImpFile)
              cImpFile := "*.*"
            ENDIF
            cImpFile := popex(cImpFile)
          ENDIF
          IF !LASTKEY() = 27
            IF FILE(cImpFile)
              IF MEMORY(0)*1000 < FILEINFO(cImpFile,1)
                msg("File is too big to import")
              ELSE
                cWorkForm := MEMOREAD(getdfp()+cImpFile)
                *- limit the size of it to 2 pages
                cWorkForm := LEFT(cWorkForm,MAXFORMSIZE)
              ENDIF
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ENDIF
    
    *- edit the form letter
    *- SFFL_EDIT returns .t. if user wants to save
    IF sffl_edit()
      SELE __FORM
      locate for deleted()   // re-use deleted records
      if (found() .AND. SREC_LOCK(5,.F.) ) .OR. ;
         SADD_REC(5,.T.,"Unable to lock record to save. Keep trying?")
          REPLACE memo_orig WITH cWorkForm
          REPLACE __FORM->descript WITH cDescription
          cCurrFormDes := __FORM->descript
          DBRECALL()
          unlock
          goto recno()
      endif
    ENDIF
    select (nSelectedArea)
    
    
  CASE nMainSelect = 3
    SELECT __FORM
    purgem()
    select (nSelectedArea)
    
  CASE nMainSelect = 4 .AND. !EMPTY(cCurrFormDes)
    
    *- edit the current form
    SELE __FORM
    cWorkForm := __FORM->memo_orig
    
    *- call SFFL_EDIT()
    *- returns .t. if user wants to save changes
    IF sffl_edit()
      if SREC_LOCK(5,.T.,"Unable to lock record to save. Keep trying?")
        REPLACE memo_orig WITH cWorkForm
        unlock
        goto recno()
      ENDIF
    ENDIF
    select (nSelectedArea)
    
  CASE nMainSelect = 5 .AND. !EMPTY(cCurrFormDes)

    if cShowFilter == "SINGLE RECORD   "
      sffl_print(cDestination,bLocater,.t.)
    else
      sffl_print(cDestination,bLocater,.f.)
    endif
  CASE nMainSelect = 6
    popread(.F.,"Form width ",@nFormWidth,"999")
    
  CASE nMainSelect = 7
    cDestination = IIF(cDestination == "PRINTER","FILE   ","PRINTER")
    
  CASE nMainSelect = 8
    sls_prn(prnport())   
    
  CASE nMainSelect = 9
    nFilterType := MAX(1,menu_v("Filter type",;
                                "None - All records",;
                                "Query Matches",;
                                "Tagged Records",;
                                "Single Record"))
    DO CASE
    CASE nFilterType = 1
      cShowFilter := "ALL RECORDS    "
      lUseTag     := .F.
      lUseQuery   := .F.
      bLocater    := {||.t.}
    CASE nFilterType = 2
      cShowFilter := "QUERY MATCHES   "
      IF messyn("Modify query now?")
        QUERY(aFields,aFdesc,aFtype,"To Form Letters")
      ENDIF
      lUseTag     := .F.
      lUseQuery   := .T.
      bLocater    := IIF(VALTYPE(sls_bquery())=="B",sls_bquery(),{||.t.})
    CASE nFilterType = 3
      cShowFilter := "TAGGED RECORDS  "
      IF messyn("Tag records now?")
        aTagged := {}
        tagit(aTagged,aFields,aFdesc)
      ENDIF
      lUseTag   := .T.
      lUseQuery := .F.
      bLocater  := {|| (Ascan(aTagged,RECNO())> 0)}
    CASE nFilterType = 4
      cShowFilter := "SINGLE RECORD   "
      IF messyn("Select record?","Browse","Use current")
        editdb(.f.,aFields,aFDesc,.t.,.t.)
      ENDIF
      nSingleRec := recno()
      bLocater  := {||recno()==nSingleRec}
    ENDCASE
  CASE nMainSelect = 10 .OR. nMainSelect = 0
    SELE __FORM
    USE
    select (nSelectedArea)
    RESTSCREEN(0,0,24,79,cMainScreen)
    Setcolor(cOldCOlor)
    setcursor(nCursor)
    SETKEY(28,bOldF1)
    SETKEY(-1,bOldF2)
    SETKEY(-9,bOldF10)
    RETURN ''
    
  ENDCASE
ENDDO

nLeftMargin :=nTopMargin:=lPauseFirst:=nFormWidth:=nil
bLocater:=cDestination:=nil
nSelectedArea:=cWorkForm:=nil
aFields:=aFdesc:=aFtype:=aUexpress:=aUkeys:=nil
aTagged:=aHelp:=nUserDef:=nil

RETURN ''


*==================================================================

static FUNCTION sffl_edit
local cScreen
local bF9 := SETKEY(K_F9,NIL)
* Force initial insert mode
Ratinsert(.T.)
cScreen := SAVESCREEN(0,0,24,79)
SET SCOREBOARD OFF

*- draw screen
@0, 0 ,24, 79 BOX "ฺฤฟณูฤภณ "
@2,1 to 2,78
@22,1 to 22,78
@1,2  say "[F1=HELP]"
@1,13 say "[F2=Field picklist]"
@1,34 say "[F9=Create Formula]"
@1,55 say "[F10=SAVE]"
@1,67 say "[ESC=CANCEL]"

*- call memoedit, get returned string into cWorkForm
SET CURSOR ON
cWorkForm := MMemoedit(cWorkForm, 3, 1, 21, 78,.T.,;
         {|m,r,c,l,mr,mc,a|formudf(m,r,c,l,mr,mc,a)},nFormWidth,;
            nil,nil,nil,nil,nil,23,60)
SET CURSOR OFF

RESTSCREEN(0,0,24,79,cScreen)
SETKEY(K_F9,bF9)
*- if escape was pressed, return .f. (don't save)
IF LASTKEY() = K_ESC
  RETURN .F.
ELSE
  RETURN .T.
ENDIF
return .f.


#include "memoedit.ch"
/*
    MODES
    -----------
    0            ME_IDLE              Idle, all keys processed
    1            ME_UNKEY             Unknown key, memo unaltered
    2            ME_UNKEYX            Unknown key, memo altered
    3            ME_INIT              Initialization mode

    RETURN VALUES
    -------------
    0            ME_DEFAULT           Perform default action
    1-31         ME_UNKEY             Process requested action
                                      corresponding to key value
    32           ME_IGNORE            Ignore unknown key
    33           ME_DATA              Treat unknown key as data
    34           ME_TOGGLEWRAP        Toggle word-wrap mode
    35           ME_TOGGLESCROLL      Toggle scroll mode
    100          ME_WORDRIGHT         Perform word-right operation
    101          ME_BOTTOMRIGHT       Perform bottom-right operation
*/

*============================================================
static FUNCTION formudf(nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)

local nMassage
local nReturnVal, nFieldNumber, cYesNo, cFieldBox, cExpress, aButtons
local getlist := {}
local cReturn
local nRow := row(), nCol := col()
*- show row/column
@23,6  SAY " [Line: " + TRANS(nLine, "9999")+"]"
@23,20 SAY " [Col : " + TRANS(nColumn, "9999")+"]"

setcolor(sls_normcol() )
nReturnVal := ME_DEFAULT

IF !(nMode= ME_INIT)

  if nNextKey== K_MOUSELEFT .and. nMouseR==1
     do case
     case nMouseC >=2  .and. nMouseC<=10
       nNextKey := K_F1
     case nMouseC >=13 .and. nMouseC<=31
       nNextKey := K_F2
     case nMouseC >=34 .and. nMouseC<=52
       nNextKey := K_F9
     case nMouseC >=55 .and. nMouseC<=64
       nNextKey := K_F10
     case nMouseC >=67 .and. nMouseC<=78
       KEYBOARD CHR(K_ESC)
     endcase
  endif

  DO CASE

  CASE nNextKey =K_F1
    inkey()
    mchoice(aHelp,2,5,23,75,"[Help:]")

  CASE nNextKey = K_F10
    inkey()
    if messyn("Save changes and exit?","Save and Exit","Don't Exit")
       keyboard chr(23)
    endif

  CASE nNextKey = K_ESC
    inkey()
    if messyn("Exit without saving?")
       KEYBOARD CHR(K_ESC)
    endif

  CASE nNextKey = K_F3
    inkey()
    KEYBOARD CHR(174) + "DTOW(DATE())" +  CHR(175)

  CASE nNextKey = K_F4
    inkey()
    KEYBOARD CHR(174) +"CHR(12)"  +  CHR(175) + chr(13)

  CASE nNextKey = K_F9
    inkey()
    sele (nSelectedArea)
    cExpress := FORMULATE("",aFields,aFDesc,;
         "Create Formula/User Defined field (must result in type CHARACTER):",;
         "C")

    SELE __FORM
    if !empty(cExpress)
            KEYBOARD CHR(174) + cExpress + CHR(175)
    endif

    
  CASE nNextKey = K_F2
    inkey()
    *- draw a box
    nFieldNumber := MCHOICE(aFdesc,3,45,22,75,"Select Field")

    *- if a nSelection was made
    IF nFieldNumber != 0
      cReturn := trim(aFields[nFieldNumber])

      IF aFtype[nFieldNumber] = "C"
       while (nMassage := ;
         menu_v("Using: "+cReturn,"OK","Trimmed","Uppercase","Lowercase","Proper") ) > 1
         cReturn := {"Trim(","Upper(","Lower(","Proper("}[nMassage-1]+cReturn+")"
       end
      endif

      KEYBOARD CHR(174) + cReturn + CHR(175)
      
    ENDIF
    
    
  CASE nUserDef > 0
    if ascan(aUkeys,nNextKey) > 0
        inkey()
        KEYBOARD CHR(174) + TRIM(aUexpress[ascan(aUkeys,nNextKey)]) + ;
          CHR(175)
    endif
  ENDCASE
  
ENDIF
setcolor(sls_popcol() )
devpos(nRow,nCol)
RETURN nReturnval

*===============================================
static FUNCTION sffl_pick
LOCAL i, nSelected
local  aForms := {}, aRecs := {}
*- fill aForms[] with descriptions from FORMS.DBF
FOR i = 1 TO RECC()
  GO i
  IF !deleted()
    aadd(aForms,__FORM->descript)
    aadd(aRecs,recno())
  ENDIF
NEXT
*- do an achoice and return nSelection
nSelected := 0
if len(aForms) > 0
        nSelected := MCHOICE(aForms,6,10,16,65)
        IF nSelected > 0
          return aRecs[nSelected]
        ENDIF
ELSE
  msg("No forms on file")
endif
RETURN 0

*========================================================

static FUNCTION sffl_print(cDestination,bLocater,lSingle)
local cBox1,cBox2
local nNextAction,lIsDone,nOutHandle,cLookingBox,cOutFile
local nCounter
local cUnderScreen := savescreen(0,0,24,79)
local lEditFirst,lOk2Print
local cThisForm,cReview
local cAltFile
local nIter

EXTERNAL CTRLW
setkey(-9,{||ctrlw()})

SELE __FORM
cThisForm = __FORM->memo_orig
select (nSelectedArea)

DO WHILE .T.
  if !lSingle
          GO TOP
  endif
  *- determine output
  IF cDestination == "PRINTER"
    if !(sls_prn()=='COM1')
      IF !p_ready(sls_prn())
        EXIT
      ENDIF
    endif
  ELSE
    cOutFile := "FORMLETR.PRN"
    popread(.F.,"Output to file:",@cOutFile,"@K")
    cOutFile := Alltrim(cOutFile)
    IF EMPTY(cOutFile)
      EXIT
    ENDIF
    nOutHandle=FCREATE(getdfp()+cOutFile)
  ENDIF
  popread(.F.,"Left Margin ",@nLeftMargin,"99","Top Margin  ",@nTopMargin,"99")
  IF LASTKEY()=27
    EXIT
  ENDIF
  lPauseFirst := messyn("Pause at each letter for review ?")
  IF LASTKEY()=27
    EXIT
  ENDIF
  cLookingBox := makebox(10,30,13,50)
  @11,35 say "Looking..."
  IF lSingle
        LOCATE while .t.
  else
        LOCATE WHILE !RAT_CHECKESC() FOR EVAL(bLocater)
        //LOCATE WHILE (inkey()#27 .and. !rat_rightb()) FOR EVAL(bLocater)
  endif
  nCounter      := 0
  lIsDone       := .f.
  lEditFirst    := .f.
  *- print all matching
  DO WHILE FOUND() .AND. !lIsDone
      nCounter++

      * print to temp file
      SET CONSOLE OFF
      SET PRINT OFF
      cAltFile := uniqfname("PRN")
      SET ALTERNATE TO (cAltFile)
      SET ALTERNATE ON
      for nIter = 1 TO nTopMargin
        ?
      NEXT
      prntfrml(cThisForm,nFormWidth-nLeftMargin,nLeftMargin)
      IF cDestination == "PRINTER"
        ?""  && EJECT
      endif
      SET CONSOLE ON
      SET ALTERNATE OFF
      CLOSE ALTERNATE
      cReview   := memoread(getdfp()+cAltFile)
      ERASE (getdfp()+cAltFile)
      lOk2Print := .t.


      IF lPauseFirst
        cBox1 :=makebox(1,1,23,79)
        do while .t.
          if "5.2"$version()
            memoedit(cReview,2,2,22,78,.f.,.f.,nFormWidth+1)
          else
            memoedit(cReview,2,2,22,78,.f.,.f.,nFormWidth)
          endif
          cBox2 := makebox(17,55,24,78,sls_popcol(),0)
          nNextAction := RAT_MENU2({;
                    {18,56 ,"Print this letter"},;
                    {19,56 ,"Edit this letter"},;
                    {20,56 ,"Skip this letter"},;
                    {21,56 ,"No more pausing"},;
                    {22,56 ,"Quit printing  "}},nNextAction)
          unbox(cBox2)
          do case
            case nNextAction = 1
            case nNextAction = 2
              setkey(-9,{||ctrlw()} )
              @1,4 SAY "[F10=save changes]   [ESC=keep original]"
              SET CURSOR ON
              if "5.2"$version()
                cReview := mMemoedit(cReview,2,2,22,78,.T.,;
                    {|m,r,c,l,mr,mc,a|reviewudf(m,r,c,l,mr,mc,a)},nFormWidth+1,;
                     nil,nil,nil,nil,nil,22,60)
              else
                cReview := mMemoedit(cReview,2,2,22,78,.T.,;
                    {|m,r,c,l,mr,mc,a|reviewudf(m,r,c,l,mr,mc,a)},nFormWidth,;
                     nil,nil,nil,nil,nil,22,60)
              endif
              SET CURSOR OFF
              cReview := STRTRAN(cReview,CHR(141)+chr(10))+""
              cReview := STRTRAN(cReview,CHR(141))+""
              @1,2 to 1,78
              @23,2 to 23,78
              LOOP
            case nNextAction = 3
              lOk2Print := .f.
            case nNextAction = 4
              lPauseFirst := .f.
            case nNextAction = 5 .or. nNextAction = 0
              lOk2Print := .f.
              lIsDone   := .t.
          endcase
          exit
        enddo
        unbox(cBox1)
      ENDIF
      if lOk2Print
        @11,35 say "          "
        @12,35 say "Printing.."
        SET CONSOLE OFF
        IF cDestination == "PRINTER"
          SET PRINT ON
          ?cReview
          SET PRINT OFF
          SET PRINTER TO
          SET PRINTER TO (sls_prn())
        ELSE
          FWRITE(nOutHandle,cReview+chr(13)+chr(10))
        ENDIF
        SET CONSOLE ON
        @12,35 say "          "
        @11,35 say "Looking..."
      ENDIF
      //if inkey()= 27 .or. rat_rightb()
      if RAT_CHECKESC()
         exit
      else
         clear typeahead
      endif
      if !lSingle
        skip
        //LOCATE WHILE (inkey()#27 .and. !rat_rightb()) FOR EVAL(bLocater)
        LOCATE WHILE !RAT_CHECKESC() FOR EVAL(bLocater)
      else
        exit
      endif
  ENDDO
  unbox(cLookingBox)
  IF cDestination == "PRINTER"
    SET PRINT OFF
    SET PRINTER TO
    SET PRINTER TO (sls_prn())
  ELSE
    FCLOSE(nOutHandle)
  ENDIF
  if !empty(cAltFile)
    ERASE (getdfp()+cAltFile)
  else
    msg("No matching records")
  ENDIF
  EXIT
ENDDO
setkey(-9)
CLEAR TYPEAHEAD
RESTSCREEN(0,0,24,79,cUnderScreen)
return nil

*========================================================
static function sfll_makeh(u_express,u_descrip,u_keys)
local nCount
local nUserDef  := iif(u_express#nil,min(30,len(u_express)),0)
LOCAL aHelp     := array(20+nUserDef)

aHelp[1] := "Help with Creating a Form Letter"
aHelp[2] := "   "
aHelp[3] := "Type in the text of the letter as you would like it to appear."
aHelp[4] := "Press F2 to insert fields from the database (i.e NAME,ADDRESS)"
aHelp[5] := "where you would like these to appear. At print time, the fields"
aHelp[6] := "will be replaced by the actual database contents. "
aHelp[7] := "(inserted values are surrounded by ฎ ฏ )   "
aHelp[8] := "   "
aHelp[9] := "Keys which may be used for editing:"
aHelp[10] := "Ctrl-Y          Delete to end of line"
aHelp[11] := "Ctrl-T          Delete one word to the right"
aHelp[12] := "Ctrl-B          Reformat current paragraph"
aHelp[13] := "F10             Save work and exit"
aHelp[14] := "Escape          Exit - do not save work"
aHelp[15] := "F2              Insert a field from a list"
aHelp[16] := "F3              Insert the current date"
aHelp[17] := "F4              Insert a page break    "
for nCount = 1 to nUserDef
  aHelp[17+nCount] := u_descrip[nCount]
next
aHelp[17+nUserDef+1] := "As well as the normal cursor movement keys."
aHelp[17+nUserDef+2] := "  "
aHelp[17+nUserDef+3] := "  ........press ENTER when done"
return aHelp



*1"[F10=save changes]   [ESC=keep original]"
static FUNCTION reviewudf(nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)

local nMassage
local nReturnVal
local cReturn
local nRow := row(), nCol := col()

*- show row/column
@23,6  SAY " [Line: " + TRANS(nLine, "9999")+"]"
@23,20 SAY " [Col : " + TRANS(nColumn, "9999")+"]"

nReturnVal := ME_DEFAULT

IF !(nMode= ME_INIT)

  if nNextKey== K_MOUSELEFT .and. nMouseR==1
     do case
     case nMouseC >=4  .and. nMouseC<=21
       nNextKey := K_F10
     case nMouseC >=25 .and. nMouseC<=43
       KEYBOARD CHR(K_ESC)
     endcase
  endif

  DO CASE

  CASE nNextKey = K_F10
    inkey()
    if messyn("Save changes and exit?","Save and Exit","Don't Exit")
       keyboard chr(23)
    endif

  CASE nNextKey = K_ESC
    inkey()
    if messyn("Exit without saving?")
       KEYBOARD CHR(K_ESC)
    endif
  ENDCASE
  
ENDIF
devpos(nRow,nCol)
RETURN nReturnval




