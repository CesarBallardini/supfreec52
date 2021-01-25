/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION COPYFIELDS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  COPYFIELDS() Copies selected fields of selected records to new dbf
ณ 
ณ  Returns:
ณ  --------
ณ  None
ณ 
ณ  Syntax:
ณ  -------
ณ  COPYFIELDS([aFields,[aDescript]])
ณ 
ณ  Description:
ณ  ------------
ณ  This metafunction allows selection of fields, and
ณ  selection of record criteria (filter) to be copied to a new DBF.
ณ 
ณ  [aFields]  is an array of valid field names. Default
ณ  is all fields. Fields not of the current area are not allowed.
ณ 
ณ  [aDescript] is an array of field descriptions, which
ณ  can only be passed if [aFields]  is passed, and which must
ณ  reflect the fields in [aFields]
ณ 
ณ  Examples:
ณ  ---------
ณ   use (cDbfName)
ณ 
ณ   COPYFIELDS()  // its a metafunction...
ณ 
ณ  Source:
ณ  -------
ณ  S_COPYF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function copyfields(aInFieldNames,aInFieldDesc)

local nOldCursor     := setcursor(0)
local cInScreen      := Savescreen(0,0,24,79)
local cOldColor      := Setcolor()
local nMenuChoice
local cTarget        := ""
local bCondition     := {||.t.}
local aFields        := {}
local aSelected,aTagged
local aFieldNames    := array(fcount())
local aFieldDesc     := array(fcount())
local i
local cWhich         := "ALL RECORDS     "
local nOrder         := indexord()
local cProgress,nCopied
if aInFieldNames#nil
  aFieldNames := aInFieldNames
  if aInFieldDesc#nil
    aFieldDesc := aInFieldDesc
  else
    afields(aFieldDesc)
  endif
else
  afields(aFieldNames)
  afields(aFieldDesc)
endif
aTagged := {}
*- draw boxes
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,8,40 BOX sls_frame()
@1,5 SAY '[Copy Selected Fields]'

*- main loop
DO WHILE .T.
  
  *- do a menu
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
                {02,3 ,"Fields to Copy  "+IIF(len(aFields)>0,"๛"," ")},;
                {03,3 ,"Record Criteria "+cWhich},;
                {04,3 ,"Target File     "+padr(cTarget,12)},;
                {05,3 ,"Do Copy         "},;
                {06,3 ,"Quit            "}},nMenuChoice)

  Setcolor(sls_popcol())
  DO CASE
  CASE nMenuChoice = 1  // fields
    aFields := {}
    aSelected := tagarray(aFieldDesc,"Select Fields to Copy")
    for i = 1 to len(aSelected)
      aadd(aFields,aFieldNames[aSelected[i]])
    next
  CASE nMenuChoice = 2  // filter
    bCondition := cpyquery(bCondition,aTagged,@cWhich)
  CASE nMenuChoice = 3  // dbfname
    cTarget    :=copy2dbf(cTarget)
  CASE nMenuChoice = 4   // do the copy
    if !empty(cTarget)
     if len(aFields) > 0
       set order to 0
       nCopied := copyf(aFields,bCondition,cTarget)
       set order to (nOrder)
       msg("Done!",alltrim(str(nCopied))+" records copied to",cTarget)
     else
       msg("Select fields")
     endif
    else
      msg("Need a target DBF name")
    endif
  CASE nMenuChoice = 5 .OR. nMenuChoice = 0
    Restscreen(0,0,24,79,cInScreen)
    Setcolor(cOldColor)
    setcursor(nOldCursor)
    exit
  ENDCASE
END
RETURN nil


static function copyf(aFields,bCondition,cTarget)
local nSource       := select()
local cSource       := alias()
local aGetblocks    := array(len(aFields))
local aNewStruc     := array(len(aFields))
local i,nTarget
local nCopied       := 0

IF !empty(cTarget)
   plswait(.T.,"Preparing copy....")
   for i = 1 to len(aFields)
     aGetBlocks[i] := fieldwblock(aFields[i],nSource)
     aNewStruc[i]  := {aFields[i],fieldtypex(aFields[i]),fieldlenx(aFields[i]),fielddecx(aFields[i])}
   next

   dbcreate(cTarget,aNewStruc)
   plswait(.F.)
   if file(cTarget)
     USE (cTarget) NEW EXCLUSIVE alias _TARGET_
     nTarget   := select()
     select (nSource)
     go top

     PROGEVAL({||_TARGET_->(putrec(aGetBlocks)),nCopied++},bCondition,"Copying",;
        {||alltrim(str(nCopied))+" copied of "+alltrim(str(recno()))+" records"} )

   endif
   select _TARGET_
   nCopied := recc()
   USE
   select (nSource)
ENDIF
return nCopied

//-------------------------------------------------------------
static function putrec(aGetBlocks)
local i
APPEND BLANK
for i = 1 to fcount()
  FIELDPUT(i,eval(aGetBlocks[i]))
next
//boxupdate(recc(),nil)
return nil

//-------------------------------------------------------------
static FUNCTION copy2dbf(cDbfName)

DO WHILE .T.
  cDbfName = PADR(cDbfName,35)
  popread(.F.,"Name of datafile to copy to : ",@cDbfName,"@!")
  IF EMPTY(cDbfName)
    EXIT
  ENDIF
  cDbfName := Alltrim(cDbfName)
  cDbfName := IIF(.NOT. ".DBF" $ cDbfName, cDbfName+".DBF",cDbfName)
  
  *- if it already exists, don't overwrite it
  *- loop around and get another filespec
  IF FILE(cDbfName)
    IF messyn("Database "+cDbfName+" already exists - ","Use another name","Overwrite")
      cDbfName := ''
      LOOP
    ENDIF
  ENDIF
  EXIT
ENDDO
return cDbfName

//------------------------------------------------------------
static function cpyquery(bCondition,aTagged,cWhich)
local nChoice
local bNew := bCondition
nChoice := menu_v("Copy Records:","Tag records to copy",;
                  "Copy records meeting Query",;
                  "All records")
cWhich := 'ALL RECORDS'
DO CASE
CASE lastkey()=27
CASE nChoice = 1
  tagit(aTagged)
  IF len(aTagged) > 0
    bNew := {||ascan(aTagged,recno())>0}
    cWhich := 'TAGGED RECORDS'
  endif
CASE nChoice = 2
  IF EMPTY(sls_query())
    IF !messyn("No Query set","Set one now?","Forget it")
      RETURN ''
    ENDIF
    QUERY()
    if !empty(sls_query())
      bNew := sls_bquery()
      cWhich := 'QUERY MATCHES'
    endif
  ELSE
    IF messyn("Modify current query expression?")
      QUERY()
    ENDIF
    if !empty(sls_query())
      bNew := sls_bquery()
      cWhich := 'QUERY MATCHES'
    endif
  ENDIF
CASE nCHOICE = 3
  bNew := {||.t.}
  cWhich := 'ALL RECORDS  '
ENDCASE
cWhich := padr(cWhich,16)
return bNew

