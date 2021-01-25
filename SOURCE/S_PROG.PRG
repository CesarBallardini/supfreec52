
static cProgressBox



//---------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROGEVAL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROGEVAL() Perform a Database DBEVAL() with a progress box
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  PROGEVAL(bBlock,expCondit,[cMessage],[bMessage],[lPause])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a progress bar box with PROGON().
ณ 
ณ  Performs a DBEVAL() using <bBlock> as the first
ณ  parameter, and <expCondit> as the FOR condition. (can be
ณ  passed as a codeblock or a string).
ณ 
ณ  [cMessage] is an optional box title for the progress
ณ  box
ณ 
ณ  [bMessage] is a codeblock which returns a string
ณ  which will be displayed on the bottom inside line of the progress
ณ  box for each record processed.
ณ 
ณ  [lPause] if True will pause before removing the box
ณ  with PROGOFF()- default is False.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   // here is a counting example
ณ   nCount   := 0
ณ   nScanned := 0
ณ   bDisplay := {||alltrim(str(nCount))+" matches of "+;
ณ                  alltrim(str(nScanned++))+" scanned"}
ณ   ProgEval({||++nCount},"[S]$LNAME","Counting",bDisplay,.t.)
ณ 
ณ   // OR
ณ   ProgEval({||++nCount},{||"S"$LNAME},"Counting",bDisplay,.t.)
ณ 
ณ  Notes:
ณ  -------
ณ  Look up on DBEVAL() and note that this function is
ณ  the same, except it uses only the first two parameters.
ณ 
ณ  Source:
ณ  -------
ณ  S_PROG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ProgEval(bBlock,expCondit,cMessage,bMessage,lPause)
local bCondit := iif(valtype(expCondit)=="B",expCondit,&("{||"+iif(empty(expCondit),".t.",expCondit)+"}" ) )
local nOldOrder := indexord()
set order to 0
ProgOn(cMessage)
dbgotop()
DBEVAL(bBlock,bCondit,{||ProgDisp(recno(),recc(),bMessage)} )
ProgDisp(recc(),recc(),bMessage)
if lPause#nil .and. lPause
  @ 17,9 SAY "Done - press a key"
  rat_event(0)
endif
ProgOff()
set order to (nOldOrder)
return nil


//---------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROGCOUNT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROGCOUNT() Perform a count with a progress box
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  PROGCOUNT(expCondit,[cMessage],[lPause])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a progress bar box with PROGON().
ณ  Performs a COUNT on the current DBF using
ณ  <expCondit> as the FOR condition. (can be passed as a
ณ  codeblock or a string).
ณ 
ณ  [cMessage] is an optional box title for the progress
ณ  box
ณ 
ณ  [lPause] if True will pause before removing the box
ณ  with PROGOFF()- default is False.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   use customer
ณ 
ณ   ProgCount("[S]$LNAME")
ณ   ProgCount({||"S"$LNAME},"Counting",.t.)
ณ 
ณ  Source:
ณ  -------
ณ  S_PROG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ProgCount(expCondit,cMessage,lPause)
local nMatches := 0
local nScanned := 0
local bCondit := iif(valtype(expCondit)=="B",expCondit,&("{||"+iif(empty(expCondit),".t.",expCondit)+"}" ) )
local bMsg := {||alltrim(str(nMatches))+" matches of "+alltrim(str(nScanned++))+" scanned"}
local nOldOrder := indexord()
set order to 0
ProgOn(cMessage)
dbgotop()
DBEVAL({||++nMatches},bCondit,{||ProgDisp(nScanned,recc(),bMsg)} )
ProgDisp(recc(),recc(),bMsg)
if lPause#nil .and. lPause
  @ 17,9 SAY "Done - press a key"
  rat_event(0)
endif
ProgOff()
set order to (nOldOrder)
return nMatches

//---------------------------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROGINDEX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROGINDEX() Perform an index with a progress box
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  PROGINDEX(cName,cKey,[lUnique],[lShowCount],[lPause])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a progress bar box with PROGON().
ณ 
ณ  Performs an index using <cName> as the index name,
ณ  and <cKey> as the index key.
ณ 
ณ  [lUnique] for index UNIQUE (default False)
ณ 
ณ  [lShowCount] to show an index count as well as the
ณ  progress bar - default False
ณ 
ณ  [lPause] if True will pause before removing the box
ณ  with PROGOFF()- default is False.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   use customer
ณ   ProgIndex("Eraseme","LNAME",.f.,.t.,.t.)
ณ 
ณ  Source:
ณ  -------
ณ  S_PROG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ProgIndex(cName,cKey,lUnique,lShowCount,lPause)
local bKey := &("{||"+cKey+"}" )
local bMsg := {||alltrim(str(recno()))+" of "+alltrim(str(recc()))}
lUnique    := iif(lUnique#nil,lUnique,.f.)
lShowCount := iif(lShowCount#nil,lShowCount,.f.)
cKey := iif(!isfield(cKey),cKey,"("+cKey+")")
ProgOn("Creating index - "+cName)
if lShowCount
  dbcreateindex(cName,cKey,{||ProgDisp(recno(),recc(),bMsg),eval(bKey)},lUnique)
else
  dbcreateindex(cName,cKey,{||ProgDisp(recno(),recc()),eval(bKey)},lUnique)
endif
if lPause#nil .and. lPause
  @ 17,9 SAY "Done - press a key"
  rat_event(0)
endif
ProgOff()
set index to
set index to (cName)
return nil


//-------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROGON()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROGON() Initialize and display a progress bar box
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  PROGON([cMessage])
ณ 
ณ  Description:
ณ  ------------
ณ  Places a progress box on the screen for use by
ณ  PROGDISP()
ณ 
ณ  [cMessage] is an optional box title
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   //--------- this just shows progress from 1 - 1000
ณ   initsup()
ณ   ProgOn("Test")
ณ   for i = 1 to 1000
ณ     ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"} )
ณ   next
ณ   ProgOff()
ณ 
ณ   //-------- this show indexing progress
ณ   use Customer
ณ   ProgOn("Index")
ณ   dbcreateindex("Eraseme","(LNAME)",  ;
ณ    {||ProgDisp( recno(),recc() ),LNAME},.f.)
ณ   ProgOff()
ณ 
ณ  Source:
ณ  -------
ณ  S_PROG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ProgOn(cMessage)
cProgressBox := makebox(9,7,17,70,sls_popcol())
cMessage := iif(cMessage#nil,cMessage,"")
@ 9,9 SAY cMessage
@ 11,12 SAY "0%   10%  20%  30%  40%  50%  60%  70%  80%  90% 100%"
@ 12,12 SAY "รฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤฤด"
@ 14,13 SAY "ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ"
return nil

//-------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROGOFF()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROGOFF() Removes a progress bar box created by PROGON()
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  PROGOFF()
ณ 
ณ  Description:
ณ  ------------
ณ  Removes the progress box placed on the screen by
ณ  PROGON()
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   //---------- this just shows progress from 1 - 1000
ณ   initsup()
ณ   ProgOn("Test")
ณ   for i = 1 to 1000
ณ     ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"} )
ณ   next
ณ   ProgOff()
ณ 
ณ   //---------- this shows indexing progress
ณ   use Customer
ณ   ProgOn("Index")
ณ   dbcreateindex("Eraseme","(LNAME)",  ;
ณ    {||ProgDisp( recno(),recc() ),LNAME},.f.)
ณ   ProgOff()
ณ 
ณ  Source:
ณ  -------
ณ  S_PROG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ProgOff()
if cProgressBox#nil
  unbox(cProgressBox)
endif
cProgressBox := nil
return nil

//-------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PROGDISP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PROGDISP() Displays progress bar in box created with PROGON()
ณ 
ณ  <quick descrip>
ณ 
ณ  Returns:
ณ  --------
ณ  <expReturn> => determined by several things
ณ 
ณ  Syntax:
ณ  -------
ณ  PROGDISP(nCurrent,nTotal,[bMessage],[bReturn])
ณ 
ณ  Description:
ณ  ------------
ณ  Updates a progress bar created with PROGON().
ณ 
ณ  <nCurrent> is the current item/position. <nTotal> is
ณ  the total items. What is displayed is the percentage <nCurrent>
ณ  is of <nTotal>.
ณ 
ณ  [bMessage] is an optional message line block, which
ณ  is displayed
ณ 
ณ  on the bottom inside line of the box [bReturn] is an
ณ  optional return value, with the default being  True
ณ 
ณ  Examples:
ณ  ---------
ณ   //---------- this just shows progress from 1 - 1000
ณ   initsup()
ณ   ProgOn("Test")
ณ   for i = 1 to 1000
ณ     IF !ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"},;
ณ            {||inkey()#27} )
ณ       exit
ณ     endif
ณ   next
ณ   ProgOff()
ณ 
ณ   //--------- this show indexing progress
ณ   use Customer
ณ   ProgOn("Index")
ณ   dbcreateindex("Eraseme","(LNAME)", ;
ณ    {||ProgDisp( recno(),recc() ),LNAME},.f.)
ณ   ProgOff()
ณ   // note the use of parentheses around LNAME.
ณ   // see also PROGINDEX()
ณ 
ณ   //--------- this shows a count progress
ณ   nCounted := 0
ณ   nMatches := 0
ณ   bDisplay := {||alltrim(str(nMatches))+" matches of "+;
ณ             alltrim(str(nCounted)) }
ณ   ProgOn("Counting")
ณ   count for "S"$LNAME to ;
ณ      nMatches while ProgDisp(++nCounted,recc(),bDisplay )
ณ   ProgOff()
ณ   // see also PROGCOUNT()
ณ 
ณ  Source:
ณ  -------
ณ  S_PROG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function ProgDisp(nCurrent,nTotal,bMessage,bReturn)
local nPercent
if nCurrent#nil .and. nTotal#nil
  nTotal   = iif(nTotal  =0,1,nTotal)
  nPercent := (nCurrent/nTotal)*100
  @14,13 say padr(repl(chr(219), INT(nPercent/2)  ),50,"ฑ")
endif
if bMessage#nil
  @16,8 say padc(eval(bMessage),62)
endif
if bReturn#nil
  return eval(bReturn)
endif
return .t.
