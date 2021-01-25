static aThisLabel
static nDimHeight
static nDimWidth
static nDimMargin
static nNumberofEach
static nDimLinesBetween

#include "memoedit.ch"
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION S1LABEL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  S1LABEL() Prints a single label
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  S1LABEL(cLblfile)
ณ 
ณ  Description:
ณ  ------------
ณ  Prints a single label (1 or more copies) for the
ณ  current record, based on the dimensions and contents definitions in
ณ  .LBL file name <cLblfile>. The dimensions and contents are
ณ  figured, and then presented for printing and/or editing.
ณ 
ณ  Examples:
ณ  ---------
ณ   setkey(K_F10,{||S1LABEL("MAILING.LBL")} )
ณ                      // sets key F10 to call this
ณ                     // as a popup
ณ 
ณ  Source:
ณ  -------
ณ  S_1LABEL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function s1label(cLblfile)
local nChoice,cBox,i
local aContents
local nRow := row()
local nCol := col()
aThisLabel := array(17)
nDimHeight := 5
nDimWidth  := 35
nDimMargin := 0
AFILL(aThisLabel,SPACE(60))
if cLblFile#nil .and. file(cLblFile) .and. openlabel(cLblFile)
   aContents := fill_label()
   cBox      := makebox(3,0,23,79,SLS_POPCOL())
   @ 3,3 SAY "[Single Label Print]"
   @ 21,1 to 21,78
   @ 21,0 SAY "ร"
   @ 21,79 SAY "ด"
   for i = 1 to nDimHeight
     @3+i,2 say aContents[i] color sls_normcol()
   next

   do while .t.
        nChoice := RAT_MENU2({;
            {22,2  ,'Print  '},;
            {22,13 ,'Edit   '},;
            {22,24 ,'Quit   '}},nChoice)
        do case
           CASE nChoice = 1
              print(aContents)
           CASE nChoice = 2
             aContents := ledit(aContents)
           CASE nChoice = 3
               exit
        endcase
   enddo
   unbox(cBox)
endif
devpos(nRow,nCol)
aThisLabel:=nDimHeight:=nDimWidth:=nDimMargin:=nil
nNumberofEach:=nDimLinesBetween:=nil
return nil


static proc print(aContents)
LOCAL I
PRNPORT()
IF p_ready(sls_prn())
  set printer to (sls_prn())
  SET console off
  SET PRINT ON
  FOR I = 1 TO nDimHeight
    ?space(nDimMargin)+aContents[i]
  NEXT
  FOR I = 1 TO nDimLinesBetween
    ?
  NEXT
  SET PRINT OFF
  SET CONSOLE ON
  set printer to
ENDIF
return

//----------------------------------------------
STATIC FUNCTION OPENLABEL(cFileName)
local lValidFile := .t.
local nIter
local cLine
IF disklabel(getdfp()+cFileName)

   *- for 1 to # of lines
   FOR nIter = 1 TO nDimHeight

     *- get the next line into a test var
     cLine := aThisLabel[nIter]

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
ELSE
   Msg("Unable to read contents of Label file")
ENDIF
RETURN lValidFile


//----------------------------------------------
STATIC FUNCTION disklabel(cLabelFile)
local cBuffer,nHandle,nIter,nOffset,lSuccess
LOCAL nDimAcross,nDimSpaceBetween
lSuccess = .f.

*- ensure the file exists, and open it
IF FILE(cLabelFile)
  nHandle = FOPEN(cLabelFile,16)  && exclusive, read
  IF Ferror()== 0
        AFILL(aThisLabel,SPACE(60))
        cBuffer = SPACE(1)
        FSEEK(nHandle,61)
        Fread(nHandle,@cBuffer,1)
        nDimHeight := ASC(cBuffer)
        FSEEK(nHandle,63)
        Fread(nHandle,@cBuffer,1)
        nDimWidth := ASC(cBuffer)
        FSEEK(nHandle,65)
        Fread(nHandle,@cBuffer,1)
        nDimMargin := ASC(cBuffer)
        FSEEK(nHandle,67)
        Fread(nHandle,@cBuffer,1)
        nDimLinesBetween := ASC(cBuffer)
        FSEEK(nHandle,69)
        Fread(nHandle,@cBuffer,1)
        nDimSpaceBetween := ASC(cBuffer)
        FSEEK(nHandle,71)
        Fread(nHandle,@cBuffer,1)
        nDimAcross := ASC(cBuffer)

        *- read in the contents line by line
        cBuffer := SPACE(60)
        nIter   := 1
        FOR nIter = 1 TO nDimHeight
          nOffset := 13+(60*nIter)
          FSEEK(nHandle,nOffset)
          Fread(nHandle,@cBuffer,60)
          aThisLabel[nIter] := IIF(EMPTY(cBuffer),SPACE(60),subst(cBuffer,1))
        NEXT

        *- close the file
        Fclose(nHandle)
        lSuccess = .t.
  endif
endif
RETURN lSuccess
//-------------------------------------------------------------
static function fill_label
local nLabelLine
local cMacro,cThisLine
local aValues := array(nDimHeight)
local aReturn := array(nDimHeight)
local nCounter:= 0
for nLabelLine = 1 TO nDimHeight
  *- macro expand the line stored in the .lbl file
  cMacro := aThisLabel[nLabelLine]
  IF !EMPTY(TRIM(cMacro))
    cThisLine := crunch(&cMacro,1)
    aValues[nLabelLine] := PADR(cThisLine,nDimWidth)
  else
    aValues[nLabelLine] := SPACE(nDimWidth)
  ENDIF
NEXT
afill(aReturn,space(nDimWidth))
for nLabelLine = 1 TO nDimHeight
  IF !EMPTY(aValues[nLabelLine])
     nCounter++
     aReturn[nCounter] := aValues[nLabelLine]
  ENDIF
NEXT
return aREturn

//---------------------------------------------
static function ledit(aContents)
local cMemo := ""
local i
scroll(22,2,22,78,0)
@22,2 say "[F10=Save]  [ESC=Cancel] "
for i = 1 to nDimHeight
  cMemo += trim(aContents[i])+chr(13)+chr(10)
Next
setcolor(sls_normcol())
cMemo := mMemoedit(cMemo,4,2,4+nDimHeight-1,2+nDimWidth-1,.T.,;
    {|m,r,c,l,mr,mc,a|me1ludf(m,r,c,l,mr,mc,a)},nil,;
     nil,nil,nil,nil,nil,22,60)
setcolor(sls_popcol())
for i = 1 to nDimHeight
  aContents[i] := PADR(memoline(cMemo,100,i),nDimWidth)
  @3+i,2 say aContents[i] color sls_normcol()
next
scroll(22,2,22,78,0)
return aContents


static FUNCTION me1ludf(nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)

local nMassage
local nReturnVal
local cReturn
local nRow := row(), nCol := col()

nReturnVal := ME_DEFAULT

IF !(nMode= ME_INIT)

  if nNextKey== K_MOUSELEFT .and. nMouseR==22
     do case
     case nMouseC >=2  .and. nMouseC<=11
       nNextKey := K_F10
     case nMouseC >=14 .and. nMouseC<=25
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

