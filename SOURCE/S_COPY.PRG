/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION COPYITOUT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  COPYITOUT() Copies records to a new DBF
ณ 
ณ  Returns:
ณ  --------
ณ  nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  COPYITOUT()
ณ 
ณ  Description:
ณ  ------------
ณ  Copies records to a new DBF, with query and tagging
ณ  options.
ณ 
ณ  Examples:
ณ  ---------
ณ   Use (dbf_file)
ณ 
ณ   COPYITOUT()
ณ 
ณ  Notes:
ณ  -------
ณ  For more control, see COPYFIELDS(). If field
ณ  selection is not needed, use COPYITOUT(), which is smaller and
ณ  faster.
ณ 
ณ  Source:
ณ  -------
ณ  S_COPY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION copyitout()
local aTagged := {}
local nOldCursor     := setcursor(0)
local cInScreen      := Savescreen(0,0,24,79)
local cOldColor      := Setcolor()
local nMenuChoice
local cTarget        := ""
local bCondition     := {||.t.}
local i
local cWhich         := "ALL RECORDS     "
local nOrder         := indexord()
local cProgress,nCopied

*- draw boxes
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,8,40 BOX sls_frame()
@1,5 SAY '[Copy Selected Records]'

*- main loop
DO WHILE .T.
  
  *- do a menu
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
                    {02,3 ,"Record Criteria "+cWhich},;
                    {03,3 ,"Target File     "+padr(cTarget,12)},;
                    {04,3 ,"Do Copy         "},;
                    {06,3 ,"Quit            "}},nMenuChoice)

  Setcolor(sls_popcol())
  DO CASE
  CASE nMenuChoice = 1  // filter
    bCondition := cpyfilter(bCondition,aTagged,@cWhich)
  CASE nMenuChoice = 2  // dbfname
    cTarget    := dbftarget(cTarget)
  CASE nMenuChoice = 3   // do the copy
    if !empty(cTarget)
       plswait(.T.,"Copying....")
       set order to 0
       nCopied   := copy2file(bCondition,cTarget)
       set order to (nOrder)
       plswait(.F.)
       msg("Done!",alltrim(str(nCopied))+" records copied to",cTarget)
    else
      msg("Need a target DBF name")
    endif
  CASE nMenuChoice = 4 .OR. nMenuChoice = 0
    Restscreen(0,0,24,79,cInScreen)
    Setcolor(cOldColor)
    setcursor(nOldCursor)
    exit
  ENDCASE
END
RETURN nil


static function copy2file(bCondition,cTarget)
local nMatches := 0
local nCounted := 0
local bDisplay := {||alltrim(str(nMatches))+" copied of "+alltrim(str(recc()))+" with "+alltrim(str(recc()-nCounted))+" to check" }
 dbgotop()
 ProgOn("Copying")
 copy to (cTarget) for eval(bCondition).and.(nMatches++,.t.) while (nCounted++,ProgDisp(nCounted,recc(),bDisplay ))
 ProgOff()
return nMatches

//-------------------------------------------------------------
static FUNCTION dbftarget(cDbfName)

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
    msg("Database "+cDbfName+" already exists - ","Use another name")
    cDbfName := ''
    LOOP
  ENDIF
  EXIT
ENDDO
return cDbfName

//------------------------------------------------------------
static function cpyfilter(bCondition,aTagged,cWhich)
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


