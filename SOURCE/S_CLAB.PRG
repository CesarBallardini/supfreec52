#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#define LBL_DESC      1
#define LBL_WIDTH     2
#define LBL_HEIGHT    3
#define LBL_ACROSS    4
#define LBL_LBETWEEN  5
#define LBL_SBETWEEN  6
#define LBL_LMARGIN   7
#define LBL_PRESETUP  8
#define LBL_POSTSETUP 9

#define LBL_SINGLE    10
#define LBL_LBLSPAGE  11
#define LBL_TOPMARG   12
#define LBL_PAUSE     13
#define LBL_EJECT     14

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CLABEL()                     *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  CLABEL() Menu driven module for label management
ณ
ณ  Returns:
ณ  --------
ณ  Nothing
ณ
ณ  Syntax:
ณ  -------
ณ  CLABEL([aInFieldNames,aInFieldDesc,aInFieldTypes],[lUseBuildex],[lRelease])
ณ
ณ  Description:
ณ  ------------
ณ  This function requires no parameters and is entirely
ณ  menu driven. Clipper compatible LBL files can be imported from.
ณ  Definitions are stored in a DBF format. Labels may be printed by
ณ  Query matches, by Tagging, or all records.
ณ 
ณ  Three arrays may be passed - <aInFieldNames> is an
ณ  array of allowable field names. <aInFieldDesc>  is an array of
ณ  field descriptions. <aInFieldTypes> is an array of field types.
ณ  All three must be passed, or none. All fields are used as
ณ  default, with field names being the default field descriptions.
ณ 
ณ  [lUseBuildex] if True, allows calling BUILDEX() to
ณ  build complex expressions.
ณ
ณ  [lRelease] if this is TRUE, CLABEL() will release the printer every
ณ  50 labels. If on a network, this will allow the queue to empty out.
ณ  If you are printing a bunch of labels, this can be important. Default
ณ  is False. 
ณ
ณ  Examples:
ณ  ---------
ณ   use CUSTOMER
ณ
ณ   CLABEL()
ณ 
ณ       or
ณ 
ณ   USE CUSTOMER
ณ   aFlds := {"FNAME","LNAME","MI"}
ณ   aFdes := {"First","Last","Middle"}
ณ   aType := {"C","C","C"}
ณ   CLABEL(aFlds,aFdes,aType,.t.)
ณ
ณ  Notes:
ณ  -------
ณ  Requires datafile to be open.
ณ
ณ  Reads Clipper compatible LBL files. Writes to a DBF.
ณ  Does not call LABEL FORM. instead, uses its own label printing
ณ  routine. Label printing routine optionally compresses blank
ณ  lines (i.e. a 2nd address), as well as removing all but single
ณ  space in a line (i.e. FIRSTNAME+ LASTNAME) See SLSF_LABEL() for
ณ  notes on the storage DBF.
ณ
ณ  Source:
ณ  -------
ณ  S_CLAB.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION clabel( aInFieldNames,aInFieldDesc,aInFieldTypes,lUseBuildex,lRelease)
local nOldCursor := setcursor()
local cOldColor  := setcolor()
local bOldKF10   := SETKEY(K_F10,{||CTRLW()})
local bOldKF2    := SETKEY(K_F2)
local bOldKF3    := SETKEY(K_F3)
local bOldKF4    := SETKEY(K_F4)
local nMainSelection := 1
local cUnder := Savescreen(0,0,24,79)
local aFieldNames,aFieldDesc,aFieldTypes
local aContents   := array(30)
local aDimensions := ARRAY(14)
local cThisLabelName := space(30)
local aTagged    := {}
local lUsingSheets := .f.
local nLabelsOnPage := 0
local nTopMargin := 0
local lPauseBetween := .f.
local lEjectEach    := .f.
memvar getlist
lRelease := iif(lRelease#nil,lRelease,.f.)   // release printer every 50 labels
lUseBuildex := iif(lUseBuildex#nil,lUseBuildex,.f.)
AFILL(aContents,SPACE(60))
aDimensions[LBL_DESC]     := ""
aDimensions[LBL_HEIGHT]   := 5
aDimensions[LBL_WIDTH]    := 35
aDimensions[LBL_LMARGIN]  := 0
aDimensions[LBL_LBETWEEN] := 1
aDimensions[LBL_SBETWEEN] := 0
aDimensions[LBL_ACROSS]    := 1
aDimensions[LBL_PRESETUP]  := SPACE(60)
aDimensions[LBL_POSTSETUP] := SPACE(60)
aDimensions[LBL_SINGLE   ] := .F.
aDimensions[LBL_LBLSPAGE ] := 0
aDimensions[LBL_TOPMARG  ] := 0
aDimensions[LBL_PAUSE    ] := .F.
aDimensions[LBL_EJECT    ] := .F.

IF !(VALTYPE(aInFieldNames)+VALTYPE(aInFieldDesc)+VALTYPE(aInFieldTypes))=="AAA"
  aFieldNames:=array(fcount())
  aFieldDesc:=array(fcount())
  aFieldTypes := array(fcount())
  Afields(aFieldNames,aFieldTypes)
  Afields(aFieldDesc)
ELSE
  aFieldNames := aInFieldNames
  aFieldDesc  := aInFieldDesc
  aFieldTypes := aInFieldTypes
ENDIF

DRAWMAIN()

SET PRINTER TO (sls_prn())
SET WRAP ON
*- main loop
DO WHILE .T.
  Setcolor(sls_popmenu())
  
  *- show what .lbl file we're using
  @21,2 SAY "Label in use       : "+padr(cThisLabelName,45)
  @22,2 SAY "Dbf file in use    : "+ALIAS()
  *- do the menu
  nMainSelection := RAT_MENU2({;
            {02,3 ,"Load Label from disk   "},;
            {03,3 ,"Save Label to disk     "},;
            {04,3 ,"Erase Label definition "},;
            {05,3 ,"Import from .LBL format"},;
            {06,3 ,"Dimensions of Label    "},;
            {07,3 ,"Contents of Label      "},;
            {08,3 ,"Output Test Pattern    "},;
            {09,3 ,"Print Mailing Labels   "},;
            {10,3 ,"Reset Printer Port. Now:"+sls_prn()},;
            {11,3 ,"Tag Records to Print   "},;
            {12,3 ,"Build or Modify Query  "},;
            {13,3 ,"About Using Laser Printers * "},;
            {14,3 ,"Use Single Sheet Options   "},;
            {15,3 ,"Quit                   "}},nMainSelection)
  Setcolor(sls_normcol())
  
  DO CASE
  CASE nMainSelection = 1  // load definition from DBF
    cThisLabelName := LOADLABEL(aContents,aDimensions)
  CASE nMainSelection = 2  // write
    if ascan(aContents,{|e|!empty(e)}) > 0
      cThisLabelName := PUTLABEL(aContents,aDimensions,cThisLabelName)
    else
      msg("No contents defined!")
    endif
  CASE nMainSelection = 3  // erase
    ERASELABEL()
  CASE nMainSelection = 4  // import from .LBL file
    cThisLabelName := IMPORTLBL(aContents,aDimensions)
  CASE nMainSelection = 5  // dimensions
    EDITDIMS(aDimensions)
  CASE nMainSelection = 6  // contents
    GETCONTENTS(aFieldNames,aFieldDesc,aFieldTypes,aContents,aDimensions,lUseBuildex)
  CASE nMainSelection = 7  // print sample
    GO TOP
    *- ensure printer is ready
    IF p_ready(sls_prn())
      PRINTSAMPLE(aDimensions)
    ENDIF
  CASE nMainSelection = 8   // print for real
    if ascan(aContents,{|e|!empty(e)}) > 0
     if messyn("Print labels now?")
        PRINTLABELS(aTagged,aContents,aDimensions,lRelease )
        msg('Process Complete')
     endif
    else
      msg("No label contents defined!")
    endif

  CASE nMainSelection = 9
    sls_prn(prnport())
  CASE nMainSelection = 10
    tagit(aTagged,aFieldNames,aFieldDesc)
  CASE nMainSelection = 11
    QUERY(aFieldNames,aFieldDesc,aFieldTypes," to Labels ")
  case nMainSelection = 12
       msg("  If you are using an HP Laser Printer or equivalent",;
           "you should use Laser Labels (from Avery and others)",;
           "and NOT regular Copy Machine labels. Laser labels have",;
           "a ซ inch space at the top and bottom of the sheet to ",;
           "allow for the HP margins. If you are using regular Copy",;
           "Machine labels (not recommended), try the Single Sheet ",;
           "options.")
  CASE nMainSelection = 13   // single sheet options
     lUsingSheets  := aDimensions[LBL_SINGLE]
     nLabelsOnPage := aDimensions[LBL_LBLSPAGE]
     nTopMargin    := aDimensions[LBL_TOPMARG]
     lPauseBetween := aDimensions[LBL_PAUSE]
     lEjectEach    := aDimensions[LBL_EJECT]
     if (lUsingSheets:= !(messyn("Are you using Individual Sheets ?","No","Yes")) )
          popread(.T.,"Number of labels per sheet?",@nLabelsOnPage,"99",;
          "Top Margin (lines) ",@nTopMargin,"99",;
          "Pause between Sheets",@lPauseBetween,"Y",;
          "Eject each sheet",@lEjectEach,"Y")
     endif
     aDimensions[LBL_SINGLE]     := lUsingSheets
     aDimensions[LBL_LBLSPAGE]   := nLabelsOnPage
     aDimensions[LBL_TOPMARG]    := nTopMargin
     aDimensions[LBL_PAUSE]      := lPauseBetween
     aDimensions[LBL_EJECT]      := lEjectEach
  CASE nMainSelection = 14 .OR. nMainSelection = 0
    EXIT
  ENDCASE
ENDDO
setcursor(nOldcursor)
SETKEY(K_F10,bOldKF10)
SETKEY(K_F2,bOldKF2)
SETKEY(K_F3,bOldKF3)
SETKEY(K_F4,bOldKF4)
RESTSCREEN(0,0,24,79,cUnder)
SETCOLOR(cOldcolor)

RETURN ''




//----------------------------------------------
STATIC FUNCTION READLABEL(cLabelFile,aContents,aDimensions)
local cBuffer,nHandle,nIter,nOffset,lSuccess
lSuccess = .f.

*- ensure the file exists, and open it
IF FILE(cLabelFile)
  nHandle = FOPEN(cLabelFile,16)  && exclusive, read
  IF Ferror()== 0
        AFILL(aContents,SPACE(60))
        cBuffer := SPACE(60)
        FSEEK(nHandle,1)
        Fread(nHandle,@cBuffer,60)
        if left(cBuffer,1)=="þ"
           aDimensions[LBL_PRESETUP]    := padr(subst(cBuffer,2,30),30)
           aDimensions[LBL_POSTSETUP]   := padr(subst(cBuffer,32),30)
        else
           aDimensions[LBL_PRESETUP]    := SPACE(60)
           aDimensions[LBL_POSTSETUP]   := SPACE(60)
        endif
        cBuffer = SPACE(1)
        FSEEK(nHandle,61)
        Fread(nHandle,@cBuffer,1)
        aDimensions[LBL_HEIGHT] := ASC(cBuffer)
        FSEEK(nHandle,63)
        Fread(nHandle,@cBuffer,1)
        aDimensions[LBL_WIDTH] := ASC(cBuffer)
        FSEEK(nHandle,65)
        Fread(nHandle,@cBuffer,1)
        aDimensions[LBL_LMARGIN] := ASC(cBuffer)
        FSEEK(nHandle,67)
        Fread(nHandle,@cBuffer,1)
        aDimensions[LBL_LBETWEEN] := ASC(cBuffer)
        FSEEK(nHandle,69)
        Fread(nHandle,@cBuffer,1)
        aDimensions[LBL_SBETWEEN] := ASC(cBuffer)
        FSEEK(nHandle,71)
        Fread(nHandle,@cBuffer,1)
        aDimensions[LBL_ACROSS] := ASC(cBuffer)

        *- read in the contents line by line
        cBuffer := SPACE(60)
        nIter   := 1
        FOR nIter = 1 TO aDimensions[LBL_HEIGHT]
          nOffset := 13+(60*nIter)
          FSEEK(nHandle,nOffset)
          Fread(nHandle,@cBuffer,60)
          //--03-18-1993-- using subst(cbuffer,1) to handle a bug in
          //--clipper 5.2. see fixes.doc
          aContents[nIter] := iif(empty(cBuffer),space(60),subst(cBuffer,1))
        NEXT

        *- close the file
        Fclose(nHandle)
        lSuccess = .t.
  endif
endif
RETURN lSuccess

//----------------------------------------------
STATIC PROC PRINTSAMPLE(aDimensions)
local nIter,x
local aSample := array(aDimensions[LBL_HEIGHT])
if messyn("Print Sample to printer?")
  SET PRINT ON
  SET CONSOLE OFF
  *- for each line
  for nIter = 1 TO aDimensions[LBL_HEIGHT]
    *- build first label
    aSample[nIter] = SPACE(aDimensions[LBL_LMARGIN])+REPL('X',aDimensions[LBL_WIDTH])
    *- account for rest of labels accross
    FOR X = 2 TO aDimensions[LBL_ACROSS]
      aSample[nIter]= aSample[nIter]+SPACE(aDimensions[LBL_SBETWEEN])+REPL('X',aDimensions[LBL_WIDTH])
    NEXT
    ?aSample[nIter]
  NEXT
  *- account for lines between labels
  for nIter = 1 TO aDimensions[LBL_LBETWEEN]
    ?
  NEXT
  SET CONSOLE ON
  IF MESSYN("Do you need an EJECT?")
    SET CONSOLE OFF
    qqout(chr(12))
    SET CONSOLE ON
  ENDIF
  SET PRINT OFF
  SET PRINTER TO
  SET PRINTER TO (sls_prn())
endif
RETURN


//----------------------------------------------
STATIC PROC DRAWMAIN
Setcolor(sls_normcol())
@ 0,0,24,79 BOX sls_frame()
Setcolor(sls_popmenu())
@1,1,16,50 BOX sls_frame()
@20,1,23,78 BOX sls_frame()
@1,5 SAY '[Mailing Labels]'
RETURN

//----------------------------------------------
STATIC FUNCTION IMPORTLBL(aContents,aDimensions)
local aLabelFiles
local nLabelCount
local nSelection
local cFileName
local lValidFile := .t.
local nIter
local cLine
local cThisLabelName := ""
*- if there are .lbl files
IF (nLabelCount := Adir('*.lbl')  )  > 0

  *- make an array of lbl file names
  aLabelfiles := ARRAY(nLabelCount)
  Adir('*.LBL',aLabelFiles)

  *- get user selection of lbl file
  nSelection = mchoice(aLabelFiles,5,30,10,45,'Label Files')

  *- if one was selected
  IF nSelection > 0

    *- figure out which one it was
    cFileName = aLabelFiles[nSelection]

    *- read it in
    IF READLABEL(getdfp()+cFileName,aContents,aDimensions)

        *- for 1 to # of lines
        FOR nIter = 1 TO aDimensions[LBL_HEIGHT]

          *- get the next line into a test var
          cLine = aContents[nIter]

          *- test the var
          IF !EMPTY(cLine)
            IF (TYPE(cLine) == "U" .OR. TYPE(cLine) == "UE")
              msg("That label file doesn't match this Database")

              *- if no match, set ok indicator off
              lValidFile := .F.
              *- and exit loop
              EXIT
            ENDIF
          ENDIF
        NEXT

        *- if its ok, current file is file just read
        IF lValidFile
          cThisLabelName := cFileName
        ENDIF
    ELSE
        Msg("Unable to read contents of Label file")
    ENDIF
  ENDIF
ELSE
  msg("No label files (.LBL) found in this directory.")
ENDIF
RETURN cThisLabelName

//-----------------------------------------------------------------------
STATIC FUNCTION PUTLABEL(aContents,aDimensions,cLblDescript)
local cLabelfile := slsf_label()+".DBF"
local nOldArea   := select()
local cLabelDesc := padr(cLblDescript,30)
local lOverWrite := .t.
local nIter
local cContents := ""

*- open up the next available area
SELE 0

while .t.
 *- check for /build the dbf to hold the queries
 IF !FILE(cLabelFile)
    MAKEDBF()
 ENDIF

 *- open the LABELS.DBF file
 IF !SNET_USE(cLabelFile,"__LABELS",.F.,5,.F.,"Unable to open labels file. Keep trying?")
    USE
    EXIT
 ENDIF

 *- init a value for a description and get it
 popread(.F.,"Enter a description for this label    ",@cLabelDesc,"@K!")

 *- if a description was given, store the record
 IF !EMPTY(cLabelDesc) .AND.!LASTKEY()=27
   locate for alltrim(__LABELS->dbfname)==ALIAS(nOldarea) ;
        .and. trim(__LABELS->descript) == trim(cLabelDesc) .and. !deleted()
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
          REPLACE __LABELS->DBFNAME WITH ALIAS(nOldarea)
          REPLACE __LABELS->descript WITH PADR(cLabelDesc,30)
          REPLACE __LABELS->prnport with SLS_PRN()
          REPLACE __LABELS->width with aDimensions[LBL_WIDTH]
          REPLACE __LABELS->spacesbetw with aDimensions[LBL_SBETWEEN]
          REPLACE __LABELS->linesbetw with aDimensions[LBL_LBETWEEN]
          REPLACE __LABELS->across    with aDimensions[LBL_ACROSS  ]
          REPLACE __LABELS->lmargin   with aDimensions[LBL_LMARGIN ]
          REPLACE __LABELS->height    with aDimensions[LBL_HEIGHT  ]
          FOR nIter = 1 TO aDimensions[LBL_HEIGHT]
              cContents += trim(aContents[nIter])+chr(13)+chr(10)
          NEXT
          replace __LABELS->contents with cContents
          replace __LABELS->setupcode with padr(aDimensions[LBL_PRESETUP],60)
          replace __LABELS->exitcode with padr(aDimensions[LBL_POSTSETUP],60)
          replace __LABELS->sheets with aDimensions[LBL_SINGLE]
          replace __LABELS->lblspage with aDimensions[LBL_LBLSPAGE]
          replace __LABELS->topmarg with aDimensions[LBL_TOPMARG]
          replace __LABELS->pause with aDimensions[LBL_PAUSE]
          replace __LABELS->eject with aDimensions[LBL_EJECT]
          DBRECALL()
      endif
   endif
 ENDIF
 USE
 exit
END
SELE (nOldarea)
return cLabelDesc


//----------------------------------------------------------------
Static function PreDefined
local aLabels := {;
  {"User Defined                            ",35, 5, 1, 1, 0, 0,"","",.f.,0,0,.f.,.f. },;
  {"3(ซ)    x (15/16)   - 1 Across          ",35, 5, 1, 1, 0, 0,"","",.f.,0,0,.f.,.f. },;
  {"3(ซ)    x (15/16)   - 2 Across          ",35, 5, 2, 1, 2, 0,"","",.f.,0,0,.f.,.f. },;
  {"3(ซ)    x (15/16)   - 3 Across          ",35, 5, 3, 1, 2, 0,"","",.f.,0,0,.f.,.f. },;
  {"3(2/10) x (11/12)   - 3 Across Cheshire ",32, 5, 3, 1, 2, 0,"","",.f.,0,0,.f.,.f. },;
  {"4       x 1(7/16)   - 1 Across          ",40, 8, 1, 1, 0, 0,"","",.f.,0,0,.f.,.f. },;
  {"4       x 2(ฌ)      - (Rolodex)         ",40,10, 1, 1, 0, 0,"","",.f.,0,0,.f.,.f. },;
  {"3       x 5         - (Rolodex)         ",50,14, 1, 4, 0, 0,"","",.f.,0,0,.f.,.f. },;
  {"Avery 5160,5260,5660  (Laserjet)        ",25, 5, 3, 1, 3, 0, "!E!&l12d5e6d60F"  ,"!E",.f.,0,0,.f.,.f.  },;
  {"Avery 5161,5261       (Laserjet)        ",25, 5, 3, 1, 3, 0, "!E!&l12d5e6d60F"  ,"!E",.f.,0,0,.f.,.f.  },;
  {"Avery 5162,5262,5662  (Laserjet)        ",38, 7, 2, 1, 4, 0, "!E!&l12d9e6d56F"  ,"!E",.f.,0,0,.f.,.f. },;
  {"Avery 5163,5663       (Laserjet)        ",38,11, 2, 1, 4, 0, "!E!&l12d5e6d60F"  ,"!E",.f.,0,0,.f.,.f.  },;
  {"Avery 5164            (Laserjet)        ",38,16, 2, 4, 4, 0, "!E!&l12d5e6d60F"  ,"!E",.f.,0,0,.f.,.f.  },;
  {"Avery 5266            (Laserjet)        ",34, 3, 2, 1, 6, 3, "!E!&l12d6e6d60F"  ,"!E",.f.,0,0,.f.,.f.  },;
  {"Avery 5196,5296       (Laserjet 3ซ disk)",24,16, 3, 2, 3, 0, "!E!&l12d5e6d54F"  ,"!E",.f.,0,0,.f.,.f.  },;
  {"Avery 5197,5297       (Laserjet 5ฌ disk)",38, 8, 2, 1, 4, 0, "!E!&l12d11e6d54F" ,"!E",.f.,0,0,.f.,.f.  };
            }
//  these are untested, but should work (I just don't hve label samples to compare!)
//  {"Avery 5267            (Laserjet)        ",16, 2, 4, 1, 5, 1, "!E!&l12d7e6d60F"  ,"!E",.f.,0,0,.f.,.f.  },;
//  {"Avery 5095,5395,5895  (Laserjet)        ",29,11, 2, 4, 8, 7, "!E!&l5e60F"       ,"!E",.f.,0,0,.f.,.f.  },;
//  {"Avery 5198            (Laserjet)        ",33, 9, 2, 1, 7, 3, "!E!&l12d7e6d60F"  ,"!E",.f.,0,0,.f.,.f.  } ;

local nLastkey,cLastkey, nMouseR, nMouseC, nButton, aButtons
local nSelection := 0
local cLblScreen :=MAKEBOX(5,14,20,66,SLS_NORMCOL())
local nElement := 1
local oTb      := tbrowsenew(6,15,18,65)
@19,20 say "[] [] [ OK ] [Cancel]"
aButtons := { {19,20,19,22,K_UP},;
              {19,24,19,26,K_DOWN},;
              {19,28,19,33,K_ENTER},;
              {19,35,19,42,K_ESC}}
oTb:addcolumn(tbcolumnNew("Label Description - ENTER to Select",{||aLabels[nElement,1]}))
oTb:SKIPBLOCK  := {|N|aaskip(N,@nElement,LEN(aLabels))}
oTb:gotopblock := {||nElement := 1}
oTb:gobottomblock := {||nElement := len(aLabels)}
oTb:headsep := "ฤ"
oTb:footsep := "ฤ"
DO WHILE .T.
   WHILE !oTb:STABILIZE()
   END
   nMouseR := 0; nMouseC := 0
   nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

   nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)

   do case
   CASE nLastKey = K_UP .OR. nButton==K_UP         && UP ONE ROW
     oTb:UP()
     if nButton==K_UP
      IFMOUSEHD({||oTb:up()},oTb)
     endif
   CASE nLastKey = K_DOWN .or. nButton==K_DOWN        && DOWN ONE ROW
     oTb:DOWN()
     if nButton==K_DOWN
      IFMOUSEHD({||oTb:down()},oTb)
     endif
   CASE nLastKey = K_PGUP      && UP ONE PAGE
     oTb:PAGEUP()
   CASE nLastKey = K_HOME        && HOME
     oTb:GOTOP()
   CASE nLastKey = K_PGDN        && DOWN ONE PAGE
     oTb:PAGEdOWN()
   CASE nLastKey = K_END         && END
     oTb:GOBOTTOM()
   case nLastKey = K_ENTER .or. nButton==K_ENTER .or. ;
        MBRZCLICK(oTb,nMouseR,nMouseC)
     nSelection := nElement
     exit
   case nLastKey = K_ESC .or. nButton==K_ESC .or. nLastkey==K_MOUSERIGHT
     exit
   case MBRZMOVE(oTb,nMouseR,nMouseC,8,15,17,65)
   endcase
ENDDO
unbox(cLblScreen)
if nElement > 0
  return aLabels[nElement]
else
  return nil
endif
return nil


//---------------------------------------------------------------
static function editdims(aLblDims)
local cbox := makebox(1,10,23,69,sls_popcol())
local aTemp := aclone(aLblDims)
local lReturn := .f.
local nSelection
local lChanged := .f.
MEMVAR GETLIST

@ 3,15 SAY "---Label Dimensions---"
@ 4,12 SAY "Width"
@ 5,12 SAY "Height"
@ 6,12 SAY "Labels across"
@ 7 ,12 SAY "Lines between labels"
@ 8 ,12 SAY "Spaces between labels"
@ 9 ,12 SAY "Left Margin (indent)"
@ 10,12 SAY "Pre-setup code"
@ 11,37 say "(use ! for Escape)"
@ 12,12 SAY "Post-setup code"
@ 13,37 say "(use ! for Escape)"

@ 15,12 SAY "---Individual Sheet Options---"
@ 16,12 SAY "Use individual sheets?"
@ 17,12 SAY "# Labels per sheet"
@ 18,12 SAY "Top margin (lines)"
@ 19,12 SAY "Pause between sheets?"
@ 20,12 SAY "Eject each sheet?"
@ 21,11 to 21,68
while .t.
     aTemp[LBL_PRESETUP]  := PADR(aTemp[LBL_PRESETUP],60)
     aTemp[LBL_POSTSETUP] := PADR(aTemp[LBL_POSTSETUP],60)
     @4,37  GET aTemp[LBL_WIDTH]  pict "99"
     @5,37  GET aTemp[LBL_HEIGHT] pict "99"
     @6,37  GET aTemp[LBL_ACROSS] pict "9"
     @7,37  GET aTemp[LBL_LBETWEEN] pict "9"
     @8,37 GET aTemp[LBL_SBETWEEN] pict "9"
     @9,37 GET aTemp[LBL_LMARGIN] pict "99"
     @10,37 GET aTemp[LBL_PRESETUP]   pict "@S25"
     @12,37 GET aTemp[LBL_POSTSETUP]  pict "@S25"
     @16,37 GET aTemp[LBL_SINGLE   ]  pict "Y"
     @17,37 GET aTemp[LBL_LBLSPAGE ]  pict "999"
     @18,37 GET aTemp[LBL_TOPMARG  ]  pict "99"
     @19,37 GET aTemp[LBL_PAUSE    ]  pict "Y"
     @20,37 GET aTemp[LBL_EJECT    ]  pict "Y"
     CLEAR GETS
     nSelection := RAT_MENU2({;
        {22,12 ,"Edit"},{22,20 ,"Load Predefined Dimensions"},;
        {22,50 ,"Quit"}},nSelection)
     do case
     case nSelection == 1
       @4,37  GET aTemp[LBL_WIDTH]  pict "99"
       @5,37  GET aTemp[LBL_HEIGHT] pict "99" valid ;
                  iif(aTemp[LBL_HEIGHT]>30,(msg("Must be 30 or less"),.f.),.t.)
       @6,37  GET aTemp[LBL_ACROSS] pict "9"
       @7,37  GET aTemp[LBL_LBETWEEN] pict "9"
       @8,37 GET aTemp[LBL_SBETWEEN] pict "9"
       @9,37 GET aTemp[LBL_LMARGIN] pict "99"
       @10,37 GET aTemp[LBL_PRESETUP]   pict "@S25"
       @12,37 GET aTemp[LBL_POSTSETUP]  pict "@S25"
       @16,37 GET aTemp[LBL_SINGLE   ]  pict "Y"
       @17,37 GET aTemp[LBL_LBLSPAGE ]  pict "999" when aTemp[LBL_SINGLE   ]
       @18,37 GET aTemp[LBL_TOPMARG  ]  pict "99"  when aTemp[LBL_SINGLE   ]
       @19,37 GET aTemp[LBL_PAUSE    ]  pict "Y"   when aTemp[LBL_SINGLE   ]
       @20,37 GET aTemp[LBL_EJECT    ]  pict "Y"   when aTemp[LBL_SINGLE   ]
       SET CURSOR ON
       rat_read(getlist,1,.f.,27,{||KBD(K_ENTER)} )
       SET CURSOR OFF
       lChanged := .t.
     case nSelection == 2
       aTemp := predefined()
       if aTemp==nil
         aTemp := aclone(aLblDims)
       endif
       lChanged := .t.
     case nSelection == 3 .or. nSelection = 0
       if !lastkey()=K_ESC
        if lChanged .and. messyn("Save?")
          acopy(aTemp,aLbldims)
          lReturn := .t.
        endif
       endif
       EXIT
     endcase
end
UNBOX(cBox)
return lReturn

//-------------------------------------------------------------------
STATIC FUNCTION PRESET(aDimensions)
local lAborted := .f.
if !empty(aDimensions[LBL_PRESETUP])
  IF p_ready(sls_prn())
      SET CONSOLE OFF
      qqout(STRTRAN(aDimensions[LBL_PRESETUP],"!",CHR(27)))
      SET CONSOLE ON
  else
      lAborted := .t.
  ENDIF
endif
return lAborted

//-------------------------------------------------------------------
STATIC FUNCTION POSTSET(aDimensions)
local lAborted := .f.
if !empty(aDimensions[LBL_PRESETUP])
  IF p_ready(sls_prn())
      SET CONSOLE OFF
      qqout(STRTRAN(aDimensions[LBL_POSTSETUP],"!",CHR(27)))
*      qqout(STRTRAN(aDimensions[LBL_PRESETUP],"!",CHR(27)))
      SET CONSOLE ON
  else
      lAborted := .t.
  ENDIF
endif
return lAborted

#define PROMPT_QUIT          1
#define PROMPT_CLEAR         2
#define PROMPT_FIELD         3
#define PROMPT_TEXT          4
#define PROMPT_BLANK         5
#define PROMPT_MODIFY        6
#define PROMPT_PREVIEW       7
#define PROMPT_EXPRESSION    8
//----------------------------------------------
STATIC PROC GETCONTENTS(aFieldNames,aFieldDesc,aFieldTypes,;
            aContents,aDimensions,lUseBuildex)
local cUnder := makebox(4,0,20,79,sls_popcol(),0)
local nThisLine := 1
local aEdit := aclone(aContents)
local oTb
local aPrompts := {;
                   {19,3 ,19,8 ,asc("Q"),'[Quit]'},;
                   {19,11,19,17,asc("C"),'[Clear]'},;
                   {19,19,19,25,asc("F"),'[Field]'},;
                   {19,28,19,33,asc("T"),'[Text]'},;
                   {19,36,19,42,asc("B"),'[Blank]'},;
                   {19,45,19,52,asc("M"),'[Modify]'},;
                   {19,55,19,63,asc("P"),'[Preview]'}}

local cFirst     := "QCFTBMP"
local nPrompt    := 1
local nOldPrompt := 1
local cNormcolor,cEnhcolor,nLastKey,cLastKey, nMouseR, nMouseC, nButton
local cAddExpress, cEdBox
local nBlanks := 1
local bOldKF2, bOldKF3, bOldKF4
local aButtons
memvar getlist
if lUseBuildex
   aadd(aPrompts,{19,66,19,77,asc("E"),'[Expression]'})
   cFirst+="E"
endif

cNormcolor   := takeout(Setcolor(),",",1)
cEnhcolor    := takeout(Setcolor(),",",2)
@ 4,2 SAY "[Label Contents]"
@ 5,2,18,77 BOX "ฺฤฟณูฤภณ "

oTb := tbrowseNew(6,3,min(5+aDimensions[LBL_HEIGHT],17),76)
oTb:colsep := "ณ"
//oTb:addcolumn(tbcolumnNew(nil,{|| "Line "+trans(nThisLine,"99")}))
oTb:addcolumn(tbcolumnNew(nil,{|| padr(aEdit[nThisLine],74) }))
oTb:SKIPBLOCK := {|n|aaskip(n,@nThisLine,aDimensions[LBL_HEIGHT])}
oTb:COLORSPEC := sls_normcol()

AEVAL(aPrompts,{|e|devpos(e[1],e[2]),devout(e[6],cNormColor)})

do while .t.
     @aPrompts[nOldPrompt,1],aPrompts[nOldPrompt,2] say aPrompts[nOldPrompt,6] color cNormColor
     nOldPrompt := nPrompt
     while !oTb:stabilize()
     end
     @aPrompts[nPrompt,1],aPrompts[nPrompt,2] say aPrompts[nPrompt,6] color cEnhColor
     nMouseR := 0; nMouseC := 0
     nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

     nButton  := MOUSEHOTAT(nMouseR, nMouseC, aPrompts)
     if nButton > 0
       nLastKey := nButton
     endif
     cLastKey := upper(chr(nLastKey))
     do case
     case MBRZMOVE(oTb,nMouseR,nMouseC,6,3,min(5+aDimensions[LBL_HEIGHT],17),76)
     case nLastKey == K_UP
       oTb:up()
     case nLastKey == K_DOWN
       oTb:down()
     case nLastKey == K_RIGHT
       nPrompt := iif(nPrompt=len(aPrompts),1,nPrompt+1)
     case nLastKey == K_LEFT
       nPrompt := iif(nPrompt=1,len(aPrompts),nPrompt-1)
     case cLastkey$cFirst
       nPrompt := AT(cLastkey,cFirst)
       keyboard chr(13)
     case nLastKey == K_ENTER
       DO CASE
       CASE nPrompt==PROMPT_QUIT
         if messyn("Keep changes?")
           acopy(aEdit,aContents)
           msg("Note:To make changes permanent, Save to Disk")
         endif
         exit
       CASE nPrompt == PROMPT_CLEAR
         aEdit[nThisLine] := space(6)
         oTb:refreshcurrent()
       CASE nPrompt == PROMPT_FIELD
         cAddExpress := PICKFIELDS(aFieldNames,aFieldDesc,aFieldTypes)
         if !empty(cAddExpress)
            if empty(aEdit[nthisLine])
              aEdit[nThisline]:= trim(aEdit[nThisLine])+cAddExpress
            else
              aEdit[nThisline]:= trim(aEdit[nThisLine])+ ("+"+cAddExpress)
            endif
         endif
         oTb:refreshcurrent()
       CASE nPrompt == PROMPT_TEXT
         cAddExpress := space(60)
         DO WHILE .T.
           popread(.t.,'Add text (do not use quote characters: [""])',;
                   @cAddExpress,"")
           cAddExpress := trim(cAddExpress)
           if LASTKEY()=27
              exit
           ELSEIF ["]$cAddExpress
               msg("Quotes used - invalid input")
               cAddExpress := PADR(cAddExpress,60)
           elseif !empty(cAddExpress)
              if empty(aEdit[nthisLine])
                aEdit[nThisline]:= trim(aEdit[nThisLine])+["]+cAddExpress+["]
              else
                aEdit[nThisline]:= trim(aEdit[nThisLine])+ ([+"]+cAddExpress+["])
              endif
              exit
           else
              exit
           endif
         ENDDO
         oTb:refreshcurrent()

       CASE nPrompt == PROMPT_MODIFY
         setcolor(sls_normcol() )
         cAddExpress := FORMULATE(aEdit[nThisLine],aFieldNames,aFieldDesc,;
              "Modify Label Contents (must result in type CHARACTER):",;
              "C")
         setcolor(sls_popcol() )
         if !empty(cAddExpress)
              aEdit[nThisline]:= cAddExpress
         endif
         oTb:refreshcurrent()
       CASE nPrompt == PROMPT_BLANK
        popread(.t.,"Number of blanks",@nBlanks,"99")
        if empty(aEdit[nthisLine])
          aEdit[nThisline]:= trim(aEdit[nThisLine])+["]+repl(" ",nBlanks)+ ["]
        else
          aEdit[nThisline]:= trim(aEdit[nThisLine])+ ("+"+["]+repl(" ",nBlanks)+ ["] )
        endif
        oTb:refreshcurrent()
       CASE nPrompt == PROMPT_PREVIEW
         LPREVIEW(aEdit,aDimensions)
       CASE nPrompt == PROMPT_EXPRESSION
         cAddExpress := PICKEXPR(aFieldNames,aFieldDesc,aFieldTypes)
         if !empty(cAddExpress)
            if empty(aEdit[nthisLine])
              aEdit[nThisline]:= trim(aEdit[nThisLine])+cAddExpress
            else
              aEdit[nThisline]:= trim(aEdit[nThisLine])+ ("+"+cAddExpress)
            endif
         endif
         oTb:refreshcurrent()
       ENDCASE
     endcase
enddo
unbox(cUnder)
RETURN



//----------------------------------------------
STATIC FUNCTION PICKFIELDS(aFieldNames,aFieldDesc,aFieldTypes)
local cReturn
local nSelection := mchoice(aFieldDesc,5,40,18,77,"Select Field")
local nMassage
external proper
if nSelection > 0
  DO CASE
  CASE aFieldTypes[nSelection]== "C"
    cReturn := aFieldNames[nSelection]
    while (nMassage := ;
      menu_v("Using: "+cReturn,"OK","Trimmed","Uppercase","Lowercase","Proper") ) > 1
      cReturn := {"Trim(","Upper(","Lower(","Proper("}[nMassage-1]+cReturn+")"
    end
  CASE aFieldTypes[nSelection]== "N"
    cReturn := 'STR('+aFieldNames[nSelection]+')'
  CASE aFieldTypes[nSelection]=="D"
    cReturn := 'DTOC('+aFieldNames[nSelection]+')'
  CASE aFieldTypes[nSelection]== "L"
    cReturn := 'IIF('+aFieldNames[nSelection]+',"YES","NO ")'
  CASE aFieldTypes[nSelection]== "M"
    msg("Field is type MEMO, can't include in label")
  ENDCASE
ENDIF
RETURN cReturn

//----------------------------------------------
STATIC FUNCTION PICKEXPR(aFieldNames,aFieldDesc,aFieldTypes)
local cReturn,cType
local nSelection := mchoice(aFieldDesc,5,40,18,77,"Select Field for Expression")
if nSelection > 0 .and. !(aFieldTypes[nSelection]$"ML")
  cReturn         := BUILDEX("Complex Expression for LABEL",;
                     aFieldNames[nSelection],.t.,aFieldNames,aFieldDesc)
  cType := type(cReturn)
  DO CASE
  CASE cType== "C"
  CASE cType== "N"
    cReturn := 'STR('+cReturn+')'
  CASE cType=="D"
    cReturn := 'DTOC('+cReturn+')'
  ENDCASE
ENDIF
RETURN cReturn

//----------------------------------------------------------
STATIC PROC MAKEDBF
local cLabelFile := slsf_label()+".DBF"
local nOldArea   := select()
SELE 0
DBCREATE(cLabelFile,{ ;
        {"DESCRIPT","C",60,0},;
        {"WIDTH","N",2,0},;
        {"SPACESBETW","N",2,0},;
        {"LINESBETW","N",2,0},;
        {"ACROSS","N",2,0},;
        {"LMARGIN","N",2,0},;
        {"HEIGHT","N",2,0},;
        {"SETUPCODE","C",60,0},;
        {"EXITCODE","C",60,0},;
        {"CONTENTS","M",10,0},;
        {"PRNPORT","C",10,0},;
        {"SHEETS","L",1,0},;
        {"LBLSPAGE","N",3,0},;
        {"TOPMARG","N",2,0},;
        {"PAUSE","L",1,0},;
        {"EJECT","L",1,0},;
        {"DBFNAME","C",8,0}   }     )
select (nOldArea)
return


//----------------------------------------------
STATIC PROC LPREVIEW(aContents,aDimensions)
local cUnder    := makebox(4,0,20,79)
local nThisLine := 1
local oTb
local aPrompts := {;
                   {19,3 ,19,8 ,asc("Q"),'[Quit]'},;
                   {19,11,19,16,asc("N"),'[Next]'},;
                   {19,19,19,25,asc("P"),'[Prior]'} }

local cFirst     := "QNP"
local nPrompt    := 1
local nOldPrompt := 1
local cNormcolor,cEnhcolor,nLastKey,cLastKey, nMouseR, nMouseC, nButton
local cAddExpress
cNormcolor   := takeout(Setcolor(),",",1)
cEnhcolor    := takeout(Setcolor(),",",2)
@ 4,2 SAY "[Preview Label]"
@ 5,2,18,77 BOX "ฺฤฟณูฤภณ "

oTb := tbrowseNew(6,3,min(5+aDimensions[LBL_HEIGHT],17),76)
oTb:colsep := "ณ"
oTb:addcolumn(tbcolumnNew(nil,{|| padr(lmacro(aContents[nThisLine]),60) }))
oTb:SKIPBLOCK := {|n|aaskip(n,@nThisLine,aDimensions[LBL_HEIGHT])}

AEVAL(aPrompts,{|e|devpos(e[1],e[2]),devout(e[6],cNormColor)})

do while .t.
     @aPrompts[nOldPrompt,1],aPrompts[nOldPrompt,2] say aPrompts[nOldPrompt,6] color cNormColor
     nOldPrompt := nPrompt
     while !oTb:stabilize()
     end
     @aPrompts[nPrompt,1],aPrompts[nPrompt,2] say aPrompts[nPrompt,6] color cEnhColor
     nMouseR := 0; nMouseC := 0
     nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

     nButton  := MOUSEHOTAT(nMouseR, nMouseC, aPrompts)
     if nButton > 0
       nLastKey := nButton
     endif
     cLastKey := upper(chr(nLastKey))
     do case
     case MBRZMOVE(oTb,nMouseR,nMouseC,6,3,min(5+aDimensions[LBL_HEIGHT],17),76)
     case nLastKey == K_UP
       oTb:up()
     case nLastKey == K_DOWN
       oTb:down()
     case nLastKey == K_RIGHT
       nPrompt := iif(nPrompt=len(aPrompts),1,nPrompt+1)
     case nLastKey == K_LEFT
       nPrompt := iif(nPrompt=1,len(aPrompts),nPrompt-1)
     case cLastkey$cFirst
       nPrompt := AT(cLastkey,cFirst)
       keyboard chr(13)
     case nLastKey == K_ENTER
       DO CASE
       CASE nPrompt==1    // QUIT
         exit
       CASE nPrompt==2    // NEXT
         skip
         if eof()
           go bottom
         endif
         oTb:refreshall()
       CASE nPrompt==3  // PRIOR
         skip -1
         if bof()
           go top
         endif
         oTb:refreshall()
       ENDCASE
     endcase
enddo
unbox(cUnder)
RETURN

//-------------------------------------------------------------------
static function lmacro(cContents)
IF !EMPTY(cContents)
  return &cContents
endif
return ""

//-------------------------------------------------------------------
STATIC FUNCTION LOADLABEL(aContents,aDimensions)
local cLabelFile := slsf_label()+".DBF"
local nOldArea   := select()
local cAlias     := ALIAS()
local nSelection := 0
local cLabelDesc := ""
local nIter

local aDescript := {}
local lOkLabel  := .t.

while .t.
    IF FILE(cLabelFile)
      *- open the next available area and use the queries dbf
      SELE 0
      IF !SNET_USE(cLabelFile,"__LABELS",.F.,5,.F.,"Unable to open label file. Keep trying?")
         EXIT
      ENDIF
      
      LOCATE FOR UPPER(Alltrim(__LABELS->dbfname))==TRIM(cAlias) ;
                       .and. !deleted()
      
      IF !FOUND()
        USE
        msg("No stored labels match this database")
      ELSE
        WHILE FOUND()
          *- while matching records found, load them into array
          AADD(aDescript, __LABELS->descript)
          CONTINUE
        END
      ENDIF
      
      *- if nCounter is more than 1, we found at least one match
      IF len(aDescript) > 0
        
        *- have the user select the query to restore
        Asort(aDescript)
        nSelection = mchoice(aDescript,5,22,16,55,"[Select Label]")
        
        *- if the selects one, locate the record
        IF nSelection > 0
          PLSWAIT(.t.,"Loading...")
          LOCATE for (aDescript[nSelection]==__LABELS->descript ;
                      .and. trim(cAlias)==alltrim(__LABELS->dbfname)  )
          cLabelDesc := __LABELS->descript
          // sls_prn(__LABELS->prnport)

          aDimensions[LBL_WIDTH]    := __LABELS->width
          aDimensions[LBL_SBETWEEN] := __LABELS->spacesbetw
          aDimensions[LBL_LBETWEEN] := __LABELS->linesbetw
          aDimensions[LBL_ACROSS  ] := __LABELS->across
          aDimensions[LBL_LMARGIN ] := __LABELS->lmargin
          aDimensions[LBL_HEIGHT  ] := __LABELS->height
          aDimensions[LBL_PRESETUP]  := __LABELS->setupcode
          aDimensions[LBL_POSTSETUP] := __LABELS->exitcode
          aDimensions[LBL_SINGLE]   :=__LABELS->sheets
          aDimensions[LBL_LBLSPAGE] :=__LABELS->lblspage
          aDimensions[LBL_TOPMARG]  :=__LABELS->topmarg
          aDimensions[LBL_PAUSE]    :=__LABELS->pause
          aDimensions[LBL_EJECT]    :=__LABELS->eject

          FOR nIter = 1 TO aDimensions[LBL_HEIGHT]
              aContents[nIter] := trim(memoline(__LABELS->contents,250,nIter))
          NEXT
          USE
          SELE (nOldarea)
          FOR nIter = 1 TO aDimensions[LBL_HEIGHT]
              if (!empty(aContents[nIter])) .and. (TYPE(aContents[nIter]) == "U" ;
                .OR. TYPE(aContents[nIter]) == "UE")
                lOkLabel := .f.
                msg("That label does not seem to match this database")
                cLabelDesc := ""
                exit
              endif
          NEXT
          if !lOkLabel
           asize(aContents,0)
           asize(aContents,17)
           asize(aDimensions,0)
           asize(aDimensions,14)
          endif
          PLSWAIT(.f.,"Loading...")
        ELSE
          USE
        ENDIF
      ELSE
        USE
      ENDIF
    ELSE
      msg("No saved labels found in this directory" )
    ENDIF
    EXIT
end
select (nOldArea)
return cLabelDesc


//----------------------------------------------
STATIC PROC PRINTLABELS(aTagged,aContents,aDimensions,lRelease)
local lCondBlock
local nNextTagged := 1
local nTagged   := 1
local aRecords,bCondition
local aLabelSet       := ARRAY(aDimensions[LBL_HEIGHT]+1)
local nThisPageCount  := 0
local nPrinted  := 0
local nPosition := 0
local cUnder
local cCRLF     := chr(13)+chr(10)
local nThisSet  := 0
local nLabelLine:= 0
local nIter
local lContinue := .f.
local cMacro
local nActualLines
local cThisLine
local lUseTag    :=.f.
local lUseFilt   := .f.
local nNumber2Print
local nNumberofEach
local lCrunch       := .t.
local lSquish       := .t.
local lProceed      := .f.
local lUsingSheets  := aDimensions[LBL_SINGLE]
local nLabelsOnPage := aDimensions[LBL_LBLSPAGE]
local nTopMargin    := aDimensions[LBL_TOPMARG]
local lPauseBetween := aDimensions[LBL_PAUSE]
local lEjectEach    := aDimensions[LBL_EJECT]
local lAborted      := .f.

DO WHILE .T.
  GO TOP
  *- get number of records
  nNumber2Print := RECC()
  nNumberOfEach := 1

  *- use filter indicator is off
  lUseFilt := .F.

  *- use tagged indicator is off
  lUseTag = .F.

  *- find out if user wants to use tagged records only
  IF valtype(aTagged)=="A" .and. len(aTagged)> 0
    lUseTag := messyn('Print only tagged records ?')
  ENDIF

  *- if there's a query_exp, and user did not select tagged records
  IF !EMPTY(sls_query()) .and. !lUseTag
    popread(.F.,'Use Query Condition to filter records ? ',@lUseFilt,"Y")
  ENDIF

  *- get maximum labels to print
  popread(.T.,"Maximum labels to Print (ENTER for rest) :",;
              @nNumber2Print,"@K 999999999",;
              "Number of EACH to print :",@nNumberOfEach,"99",;
              "Compress all but Single spaces:",@lCrunch,"Y",;
              "Remove blank lines:",@lSquish,"Y";
              )

  IF nNumber2Print <= 0 .or. lastkey()==K_ESC .OR. nNumberOfEach <=0
    EXIT
  ENDIF
  if lUsingSheets
     if (lUsingSheets:= !(messyn("Are you using Individual Sheets ?","No","Yes")) )
          popread(.T.,"Number of labels per sheet?",@nLabelsOnPage,"99",;
          "Top Margin (lines) ",@nTopMargin,"99",;
          "Pause between Sheets",@lPauseBetween,"Y",;
          "Eject each sheet",@lEjectEach,"Y")
     endif
  endif
  *- ensure printer is ready
  IF !p_ready(sls_prn())
    EXIT
    lAborted := .t.
  ENDIF
  lProceed := .t.
  EXIT
ENDDO

if lProceed
    cUnder :=  makebox(10,40,13,60,sls_popcol())
    if lUseTag
      lCondBlock := .f.
      aRecords  := ASORT(aTagged)
      nTagged := len(aRecords)
    elseif lUseFilt
      lCondBlock := .t.
      bCondition := sls_bquery()
    else
      lCondBlock := .t.
      bCondition := {||.t.}
    endif

    //------------ find first match of condition
    @11,42 say "Looking..."
    if lCondBlock
      LOCATE WHILE .T. FOR eval(bCondition)
      lContinue := found()
    elseif nNextTagged <= nTagged
      DBGOTO( aRecords[nNextTagged] )
      nNextTagged++
      lContinue := .t.
    endif

    //-------------Adjust for top margin-------------
    SET PRINT ON
    lAborted := preset(aDimensions)
    IF nTopMargin > 0 .and. !lAborted
       lAborted := lbloutput( REPL(CHR(13)+CHR(10),nTopMargin)  )
    ENDIF
endif
//------------- while condition met and max labels not reached
inkey()
DO WHILE lContinue .AND. (nPrinted < nNumber2Print) .and. !lAborted
  //if inkey()==27 .or. rat_rightb()
  if RAT_CHECKESC()
    if ( lAborted := messyn("Abort ?") )
      exit
    endif
  endif
  IF lUsingSheets
    IF nThisPageCount=nLabelsOnPage    // is page done
      IF lEjectEach
        lAborted := lbloutput( chr(12) )
        if lAborted
          exit
        endif
      ENDIF
      IF nTopMargin > 0
        lAborted := lbloutput(  REPL(cCRLF,nTopMargin)  )
        if lAborted
          exit
        endif
      ENDIF
      nThisPageCount := 0
      IF lPauseBetween
        msg("Ready to print next sheet","Press ESCAPE to abandon")
        IF LASTKEY()=27
          EXIT
        ENDIF
      ENDIF
    ELSE
      nThisPageCount++
    ENDIF
  ENDIF

  nPrinted++
  nPosition++

  *- for each label line
  nActualLines   := 0
  for nLabelLine = 1 TO aDimensions[LBL_HEIGHT]

    *- macro expand the line stored in the .lbl file
    cMacro := aContents[nLabelLine]

    *- if not empty, macro expand it
    IF !EMPTY(TRIM(cMacro))
      if lCrunch
         cThisLine := crunch(&cMacro,1)
      else
         cThisLine := &cMacro
      endif
      if !empty(cThisLine) .or. !lSquish
         nActualLines++
         *- if this is the first label accross, just build it
         *- otherwise, add it to what's already been built
         IF nPosition == 1
           aLabelSet[nActualLines] := SPACE(aDimensions[LBL_LMARGIN])+;
             PADR(cThisLine,aDimensions[LBL_WIDTH])
         ELSE
           aLabelSet[nActualLines] := aLabelSet[nActualLines]+;
            SPACE(aDimensions[LBL_SBETWEEN])+PADR(cThisLine,aDimensions[LBL_WIDTH])
         ENDIF
      endif
    ENDIF
  NEXT
  //-------------fill in rest of lines for this label
  for nLabelLine = nActualLines+1 TO aDimensions[LBL_HEIGHT]
    IF nPosition == 1
      aLabelSet[nLabelLine] = SPACE(aDimensions[LBL_LMARGIN])+SPACE(aDimensions[LBL_WIDTH])
    ELSE
      aLabelSet[nLabelLine]= aLabelSet[nLabelLine]+;
          SPACE(aDimensions[LBL_SBETWEEN])+SPACE(aDimensions[LBL_WIDTH])
    ENDIF
  NEXT

  //------------ increment # of this label kounter
  nThisSet++

  IF nThisSet=nNumberofEach
    *- find next condition match
    @11,42 say "Looking..."
    @12,42 SAY TRANS(nPrinted,"99999")+" printed."
    lContinue := .f.
    if lCondBlock   // a block was passed
      SKIP
      LOCATE WHILE .T. FOR eval(bCondition)
      lContinue := found()
    elseif nNextTagged <= nTagged  // an array of record numbers
      DBGOTO( aRecords[nNextTagged] )
      nNextTagged++
      lContinue := .t.
    endif
    nThisSet  := 0
  ENDIF
  SET CONSOLE OFF
  *- if we've reached labels accross size, or if this is EOF(), or
  *- if we have the number of labels we need, or if we've printed
  *- all tagged labels, print the array
*  IF (nPosition == aDimensions[LBL_ACROSS]) .OR. EOF() ;
*      .OR. (nPrinted >= nNumber2Print) .or. (lUseTag .and. nPrinted >= nTagged)
  IF (nPosition == aDimensions[LBL_ACROSS]) .OR. EOF() ;
      .OR. (nPrinted >= nNumber2Print) .or. ;
      (lUseTag .and. nPrinted >= (nTagged*nNumberofEach))
    FOR nIter = 1 TO aDimensions[LBL_HEIGHT]
      lAborted := lbloutput(  aLabelSet[nIter]  )
      if lAborted
        exit
      endif
    NEXT
    if lAborted
      exit
    endif
    *- account for lines between labels
    FOR nIter = 1 TO aDimensions[LBL_LBETWEEN]
      lAborted := lbloutput(" ")
      if lAborted
        exit
      endif
    NEXT
    *- reset position to 0
    nPosition  := 0
  ENDIF
  if lRelease .and. nPrinted%50 ==0  // every 50 labels, if lRelease
    SET PRINTER TO  // for network printers, releases handle
    SET PRINTER TO (sls_prn())  // set back to current printer
  endif
ENDDO

IF lUsingSheets
  IF nThisPageCount > 0
    IF lEjectEach .and. !lAborted
      lbloutput( chr(12) )
    ENDIF
  ENDIF
ENDIF

IF cUnder#nil
    UNBOX(cUnder)
endif
postset(aDimensions)
SET PRINT OFF
SET PRINTER TO  // for network printers
SET PRINTER TO (sls_prn())
SET CONSOLE ON
RETURN


STATIC FUNCTION ERASELABEL()
local cLabelFile := slsf_label()+".DBF"
local nOldArea   := select()
local cAlias     := ALIAS()
local nSelection := 0
local cLabelDesc := ""
local nIter
local aTagged    := {}
local aDescript  := {}
local aRecnos    := {}

while .t.
    IF FILE(cLabelFile)
      *- open the next available area and use the queries dbf
      SELE 0
      IF !SNET_USE(cLabelFile,"__LABELS",.F.,5,.F.,"Unable to open label file. Keep trying?")
         EXIT
      ENDIF
      
      LOCATE FOR UPPER(Alltrim(__LABELS->dbfname))==TRIM(cAlias) ;
                       .and. !deleted()
      
      IF !FOUND()
        USE
        msg("No stored labels match this database")
      ELSE
        WHILE FOUND()
          *- while matching records found, load them into array
          AADD(aDescript, __LABELS->descript)
          AADD(aRecnos, recno())
          CONTINUE
        END
      ENDIF
      
      *- if nCounter is more than 1, we found at least one match
      IF len(aDescript) > 0

        aTagged := tagarray(aDescript,"Tag Label descriptions to Delete")
        IF len(aTagged) > 0
          for nIter = 1 to len(aTagged)
            go (aRecnos[ aTagged[nIter] ] )
            if SREC_LOCK(5,.t.,"Unable to lock record to delete. Keep trying?")
              delete
              unlock
            endif
          next
        ENDIF
        USE
      ELSE
        USE
      ENDIF
    ELSE
      msg("No saved labels found in this directory" )
    ENDIF
    EXIT
end
select (nOldArea)
return nil


static function lbloutput(cLine)
local lAborted := .f.
local i, nOffset := 1
local lFirst  := .f.
local nLen    := len(cLine)
local bError
local bErrorBlock := ERRORBLOCK( {|bError|p_recover(bError)}  )
if p_ready(sls_prn())
  SET CONSOLE OFF
  ?
  while nOffset <= nLen .and. !lAborted
     BEGIN SEQUENCE
        ??subst(cLine,nOffset,1)
     RECOVER USING bError
        SET CONSOLE ON
        lAborted := !( MESSYN("Printer not ready. Try again?") )
        SET CONSOLE OFF
        LOOP
     END SEQUENCE
     nOffset++
  end
  SET CONSOLE ON
else
  lAborted := .t.
endif
ERRORBLOCK(bErrorBlock)
return lAborted


static function p_recover(eObj)
BREAK eObj
return nil

static proc kbd(nKey)
KEYBOARD CHR(nKey)
return




