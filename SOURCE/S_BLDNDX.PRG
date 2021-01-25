
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

static aFields,aFieldDesc,aFieldTypes
static lIsBuild,cNTXname

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BLDNDX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BLDNDX() Interactively create a new index
ณ 
ณ  Returns:
ณ  --------
ณ  <cIndexName> => New index name less extension
ณ 
ณ  Syntax:
ณ  -------
ณ  BLDNDX([aFields,aDescriptions],[aIndexfiles],[Buildex])
ณ 
ณ  Description:
ณ  ------------
ณ  Allows point and shoot building of a new index.
ณ 
ณ  [aFields] - an array of legal field names. If not
ณ  passed, all fields  in current DBF will be used.
ณ 
ณ  [aDescriptions] - an array of field descriptions. If
ณ  not passed,field names  in current DBF will be used.
ณ 
ณ  Pass both or neither of  [aFields] and
ณ  [aDescriptions].
ณ 
ณ  [aIndexFiles]   - an array of currently open index
ณ  files to be reopened on exit from bldndx() (up to 10).
ณ  Otherwise, only the newly created index file will be left open.
ณ 
ณ  [lBuildex]  - allow use of Buildex() to build complex
ณ  expressions. Default is False.
ณ 
ณ  Examples:
ณ  ---------
ณ   BLDNDX()
ณ 
ณ    -- or --
ณ 
ณ   aNdxFlds  := {"LASTNAME","FIRSTNAME","CITY"}
ณ   aNdxDesc  := {"Last Name","First Name","City"}
ณ   aNdxOpen  := {"CUSTOMER","STATE","ZIPCODE"}
ณ   BLDNDX(aNdxFlds,aNdxDesc,aNdxOpen)
ณ   BLDNDX(nil,nil,aNdxOpen,.t.)   // use buildex()
ณ 
ณ  Warnings:
ณ  ----------
ณ  Indexes created with this function will require the
ณ  functions DTOS() and NBR2STR() be loaded prior to use if a date
ณ  or numeric field is part of the index. You can do this with the
ณ  EXTERNAL statement.
ณ 
ณ  EXTERNAL DTOS, NBR2STR
ณ 
ณ  Notes:
ณ  -------
ณ  All fields are converted to type Character. The
ณ  function NBR2STR() is used to create a usable character
ณ  expression from a numeric field by first adding 1,000,000 to the
ณ  number.
ณ 
ณ  Source:
ณ  -------
ณ  S_BLDNDX.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION bldndx( aInFields,aInFieldDesc,aOpenNTXs,lBuildex)

EXTERNAL DESCEND

LOCAL cIndexExpr,lDescend
LOCAL cInScreen,nCurrentRecord,cOldColor,nMenuChoice
LOCAL nOldCursor,cNewName
local aOldNtxs[10]
AFILL(aOldNtxs,"")
if VALTYPE(aOpenNTXs)=="A"
  acopy(aOpenNTXs,aOldNtxs)
endif

lIsBuild := iif(lBuildex#nil,lBuildex,.f.)

*- no dbf, no index
IF !Used()
  RETURN ''
ENDIF

nCurrentRecord := RECNO()
nOldCursor     := setcursor(0)
cInScreen      := Savescreen(0,0,24,79)
cOldColor      := Setcolor()

*- if no field array, make one
IF VALTYPE(aInFields)+VALTYPE(aInFieldDesc) <> "AA"
  aFields    := array(fcount())
  aFieldDesc := array(fcount())
  Afields(aFields)
  Afields(aFieldDesc)
else
  aFields    := array(len(aInFields) )
  aFieldDesc := array(len(aInFieldDesc) )
  acopy(aInfields,aFields)
  acopy(aInfieldDesc,aFieldDesc)
ENDIF
aFieldTypes := array(len(aFields))
fillarr(aFields,aFieldTypes)

*- draw boxes
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,8,40 BOX sls_frame()
@1,5 SAY '[Index Builder]'
@18,1,23,78 BOX sls_frame()
@18,2 SAY "Current Index Key Expression:"

*- init vars
cIndexExpr := ''
cNTXname   := ''
lDescend   := .F.

*- main loop
DO WHILE .T.
  
  *- say expression
  @19,3 SAY addspace(SUBST(cIndexExpr,1,70),70)
  @20,3 SAY addspace(SUBST(cIndexExpr,71,70),70)
  if lDescend
    @5, 17 say "DESCENDING/ascending"
  else
    @5, 17 say "descending/ASCENDING"
  endif
  *- do a menu
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
                {02,3 ,"Define Index Expression"},;
                {03,3 ,"Create Index File from Expression"},;
                {04,3 ,"View records against Expression"},;
                {05,3 ,"Toggle order: "},;
                {06,3 ,"Quit"}},nMenuChoice)

  Setcolor(sls_popcol())
  DO CASE
  CASE nMenuChoice = 1
    cIndexExpr := sfix_express()
  CASE nMenuChoice = 2 .AND. !EMPTY(cIndexExpr)
    sfix_create(cIndexExpr,aOldNtxs,lDescend)
  CASE nMenuChoice = 3 .AND. !EMPTY(cIndexExpr)
    if valtype(&cIndexExpr)=="C"
            smalls(cIndexExpr)
    elseif valtype(&cIndexExpr)=="D"
            smalls("DTOS("+cIndexExpr+")")
    elseif valtype(&cIndexExpr)=="N"
            smalls("STR("+cIndexExpr+")")
    elseif valtype(&cIndexExpr)=="L"
            smalls("IIF("+cIndexExpr+",[T],[F])")
    ENDIF
    IF !EMPTY(nCurrentRecord)
      GO nCurrentRecord
    ENDIF
  CASE nMenuChoice = 4
    lDescend := !(lDescend)
  CASE nMenuChoice = 5 .OR. nMenuChoice = 0
    Restscreen(0,0,24,79,cInScreen)
    Setcolor(cOldColor)
    setcursor(nOldCursor)
    IF !EMPTY(nCurrentRecord)
      GO nCurrentRecord
    ENDIF
    exit
  ENDCASE
END
cNewName := cNTXName
aFields:=aFieldDesc:=aFieldTypes:=lIsBuild:=cNTXname:=nil
RETURN cNewName

//==============================================================

static FUNCTION sfix_express
local   cExprBox,nElement,cNtxExpression
local   nPartsAdded,nIter,cfieldName
local   aExprParts[100]
local   oTb
local   nLastKey, nMouseR, nMouseC, aButtons, nButton, lClick
local   expBuild, nExist
local   lDone := .f.
nElement := 1

cExprBox = makebox(2,42,17,78,sls_popcol(),0,0)
@2,43 SAY "[Index Expression Builder]"

oTb  := tbrowseNew(3,43,13,77)
oTb:addcolumn(tbColumnNew("Field",{||PADR(aFieldDesc[nElement],32)}  ))
oTb:skipblock     := {|n|askip(n,@nElement)}
oTb:gobottomblock := {||nElement := len(aFields)}
oTb:gotopblock    := {||nElement := 1}
oTb:headsep        := "ฤ"

@14,43 TO 14,77
@15,43 SAY   "[][]  [ENTER=select]  [F10=quit]"
IF lIsBuild
  @16,43 SAY "[Alt-E=expression builder        ]"
endif
aButtons := {{15,51,15,64,K_ENTER},{15,67,15,76,K_F10},{16,43,16,76,K_ALT_E}}
nElement       := 1
nPartsAdded    := 0
cNtxExpression := ""

DO WHILE .T.
  while !oTb:stabilize()
  end
  @19,3 SAY addspace(SUBST(cNtxExpression,1,70),70)
  @20,3 SAY addspace(SUBST(cNtxExpression,71,70),70)

  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

  nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  lClick  := MBRZCLICK(oTb,nMouseR, nMouseC)

  do case
  case nLastKey == K_ESC .or. nLastKey==K_F10 .or. nButton==K_F10
     exit
  case nLastKey == K_DOWN
     oTb:down()
  case nLastKey == K_UP
     oTb:up()
  case ISMOUSEAT(nMouseR, nMouseC, 15,43,15,45)
      oTb:up()
      IFMOUSEHD({||oTb:up()},oTb)
  case ISMOUSEAT(nMouseR, nMouseC, 15,46,15,48)
      oTb:down()
      IFMOUSEHD({||oTb:down()},oTb)
  case nLastKey == K_ENTER .or. nButton== K_ENTER .or. lClick .or. ;
                 (lIsBuild .and. (nLastKey == K_ALT_E .or. nButton==K_ALT_E))
     IF aFieldTypes[nElement]=="M"
       msg("Sorry - no memo fields in the index")
       LOOP
     ENDIF
     nPartsAdded++
     *- field name and type
     cfieldName := aFields[nElement]
     IF (nLastKey==K_ALT_E .or. nbutton==K_ALT_E).and. lIsBuild
       cFieldName := buildex("Complex Index Expression",cFieldName,.F.,aFields,aFieldDesc)
     ENDIF
     *- add to string as a character expression
     DO CASE
     CASE (nExist := ASCAN(aExprParts,cFieldName) )> 0
       adel(aExprParts,nExist)
      nPartsAdded--
      nPartsAdded--
     CASE aFieldTypes[nElement]== 'C'
       aExprParts[nPartsAdded]= cfieldName
     CASE aFieldTypes[nElement]== 'D'
       if !messyn("Convert date to character?","No","Yes")
               aExprParts[nPartsAdded] := 'dtos('+cfieldName+')'
       else
           nPartsAdded := 1
           aExprParts[1] := cFieldName
           lDone := .t.
       endif
     CASE aFieldTypes[nElement]== 'N'
       if !messyn("Convert numeric to character?","No","Yes")
         aExprParts[nPartsAdded]= 'TRANS(1000000000000+('+cfieldName+'),"")'
       else
           nPartsAdded := 1
           aExprParts[1] := cFieldName
           lDone := .t.
       endif

     CASE aFieldTypes[nElement]== 'L'
       if  !messyn("Convert logical to character?","No","Yes")
               aExprParts[nPartsAdded]= 'iif('+cfieldName+',"T","F")'
       else
           nPartsAdded := 1
           aExprParts[1] := cFieldName
           lDone := .t.
       endif
     ENDCASE
     cNtxExpression := ""
     if nPartsAdded > 0
       for nIter = 1 TO nPartsAdded-1
         cNtxExpression +=aExprParts[nIter]+'+'
       NEXT
       cNtxExpression +=aExprParts[nPartsAdded]
     endif
  CASE MBRZMOVE(oTb,nMouseR,nMouseC,5,43,13,77)
  endcase
  if lDone
    exit
  endif
ENDDO
SETKEY(K_ALT_E)
unbox(cExprBox)
RETURN cNtxExpression

//==============================================================

static FUNCTION sfix_create(cIndexExpr,aOldNtxs,lDescend)
local cExpress := iif(lDescend,'DESCEND('+cIndexExpr+')',cIndexExpr)
local bExpress := &("{||"+cExpress+"}" )
SET ORDER TO 0

IF  messyn("Create this index now ? ",10,27)
  cNTXname = SPACE(8)
  DO WHILE .T.
    cNTXname = PADR(cNTXName,8)
    popread(.F.,"Name of index: ",@cNTXname,'@!')
    IF AT(".",cNTXname) > 0
      cNTXname := TRIM(takeout(cNTXname,'.',1))
    ENDIF
    cNTXname := TRIM(STRTRAN(cNTXname," ","")+"")
    IF FILE(cNTXname+INDEXEXT())
       msg("That index exists already - can't overwrite")
       cNTXname := SPACE(8)
       loop
    ELSEIF EMPTY(cNTXname)
      IF messyn("You've left the name blank - abort ?")
        EXIT
      ENDIF
    ELSE
      EXIT
    ENDIF
  ENDDO
  IF !EMPTY(cNTXname)
    Scroll(19,2,22,77,0)
    @19,3 SAY "Creating Index      :"+cNTXname+IIF(lDescend,"           (DESCENDING ORDER)","           (ASCENDING ORDER )")

     ProgOn("Indexing")
     dbcreateindex(cNtxName,"("+cExpress+")",{||ProgDisp( recno(),recc() ),eval(bExpress) },.f.)
     ProgOff()

    Scroll(19,2,22,77,0)
    SET INDEX TO (cNTXname),(aOldNtxs[1]),(aOldNtxs[2]),;
                 (aOldNtxs[3]),(aOldNtxs[4]),(aOldNtxs[5]),;
                 (aOldNtxs[6]),(aOldNtxs[7]),(aOldNtxs[8]),;
                 (aOldNtxs[9]),(aOldNtxs[10])
    Scroll(19,2,22,77,0)
  ENDIF
ENDIF
return ''

//============================================================
static function askip(n,curr_row)
  local skipcount := 0
  do case
  case n > 0
    do while curr_row+skipcount < fcount()  .and. skipcount < n
      skipcount++
    enddo
  case n < 0
    do while curr_row+skipcount > 1 .and. skipcount > n
      skipcount--
    enddo
  endcase
  curr_row += skipcount
return skipcount






