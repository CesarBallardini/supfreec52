
static cProgressBox



//---------------------------------------------------------------------------
/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION PROGEVAL()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  PROGEVAL() Perform a Database DBEVAL() with a progress box
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  PROGEVAL(bBlock,expCondit,[cMessage],[bMessage],[lPause])
� 
�  Description:
�  ------------
�  Pops up a progress bar box with PROGON().
� 
�  Performs a DBEVAL() using <bBlock> as the first
�  parameter, and <expCondit> as the FOR condition. (can be
�  passed as a codeblock or a string).
� 
�  [cMessage] is an optional box title for the progress
�  box
� 
�  [bMessage] is a codeblock which returns a string
�  which will be displayed on the bottom inside line of the progress
�  box for each record processed.
� 
�  [lPause] if True will pause before removing the box
�  with PROGOFF()- default is False.
� 
�  Examples:
�  ---------
� 
�   // here is a counting example
�   nCount   := 0
�   nScanned := 0
�   bDisplay := {||alltrim(str(nCount))+" matches of "+;
�                  alltrim(str(nScanned++))+" scanned"}
�   ProgEval({||++nCount},"[S]$LNAME","Counting",bDisplay,.t.)
� 
�   // OR
�   ProgEval({||++nCount},{||"S"$LNAME},"Counting",bDisplay,.t.)
� 
�  Notes:
�  -------
�  Look up on DBEVAL() and note that this function is
�  the same, except it uses only the first two parameters.
� 
�  Source:
�  -------
�  S_PROG.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION PROGCOUNT()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  PROGCOUNT() Perform a count with a progress box
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  PROGCOUNT(expCondit,[cMessage],[lPause])
� 
�  Description:
�  ------------
�  Pops up a progress bar box with PROGON().
�  Performs a COUNT on the current DBF using
�  <expCondit> as the FOR condition. (can be passed as a
�  codeblock or a string).
� 
�  [cMessage] is an optional box title for the progress
�  box
� 
�  [lPause] if True will pause before removing the box
�  with PROGOFF()- default is False.
� 
�  Examples:
�  ---------
� 
�   use customer
� 
�   ProgCount("[S]$LNAME")
�   ProgCount({||"S"$LNAME},"Counting",.t.)
� 
�  Source:
�  -------
�  S_PROG.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION PROGINDEX()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  PROGINDEX() Perform an index with a progress box
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  PROGINDEX(cName,cKey,[lUnique],[lShowCount],[lPause])
� 
�  Description:
�  ------------
�  Pops up a progress bar box with PROGON().
� 
�  Performs an index using <cName> as the index name,
�  and <cKey> as the index key.
� 
�  [lUnique] for index UNIQUE (default False)
� 
�  [lShowCount] to show an index count as well as the
�  progress bar - default False
� 
�  [lPause] if True will pause before removing the box
�  with PROGOFF()- default is False.
� 
�  Examples:
�  ---------
� 
�   use customer
�   ProgIndex("Eraseme","LNAME",.f.,.t.,.t.)
� 
�  Source:
�  -------
�  S_PROG.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION PROGON()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  PROGON() Initialize and display a progress bar box
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  PROGON([cMessage])
� 
�  Description:
�  ------------
�  Places a progress box on the screen for use by
�  PROGDISP()
� 
�  [cMessage] is an optional box title
� 
�  Examples:
�  ---------
� 
�   //--------- this just shows progress from 1 - 1000
�   initsup()
�   ProgOn("Test")
�   for i = 1 to 1000
�     ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"} )
�   next
�   ProgOff()
� 
�   //-------- this show indexing progress
�   use Customer
�   ProgOn("Index")
�   dbcreateindex("Eraseme","(LNAME)",  ;
�    {||ProgDisp( recno(),recc() ),LNAME},.f.)
�   ProgOff()
� 
�  Source:
�  -------
�  S_PROG.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
*/
FUNCTION ProgOn(cMessage)
cProgressBox := makebox(9,7,17,70,sls_popcol())
cMessage := iif(cMessage#nil,cMessage,"")
@ 9,9 SAY cMessage
@ 11,12 SAY "0%   10%  20%  30%  40%  50%  60%  70%  80%  90% 100%"
@ 12,12 SAY "団陳津陳陳田陳津陳陳田陳津陳陳田陳津陳陳田陳津陳陳調"
@ 14,13 SAY "臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼"
return nil

//-------------------------------------------------------------------
/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION PROGOFF()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  PROGOFF() Removes a progress bar box created by PROGON()
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  PROGOFF()
� 
�  Description:
�  ------------
�  Removes the progress box placed on the screen by
�  PROGON()
� 
�  Examples:
�  ---------
� 
�   //---------- this just shows progress from 1 - 1000
�   initsup()
�   ProgOn("Test")
�   for i = 1 to 1000
�     ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"} )
�   next
�   ProgOff()
� 
�   //---------- this shows indexing progress
�   use Customer
�   ProgOn("Index")
�   dbcreateindex("Eraseme","(LNAME)",  ;
�    {||ProgDisp( recno(),recc() ),LNAME},.f.)
�   ProgOff()
� 
�  Source:
�  -------
�  S_PROG.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
*/
FUNCTION ProgOff()
if cProgressBox#nil
  unbox(cProgressBox)
endif
cProgressBox := nil
return nil

//-------------------------------------------------------------------
/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION PROGDISP()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  PROGDISP() Displays progress bar in box created with PROGON()
� 
�  <quick descrip>
� 
�  Returns:
�  --------
�  <expReturn> => determined by several things
� 
�  Syntax:
�  -------
�  PROGDISP(nCurrent,nTotal,[bMessage],[bReturn])
� 
�  Description:
�  ------------
�  Updates a progress bar created with PROGON().
� 
�  <nCurrent> is the current item/position. <nTotal> is
�  the total items. What is displayed is the percentage <nCurrent>
�  is of <nTotal>.
� 
�  [bMessage] is an optional message line block, which
�  is displayed
� 
�  on the bottom inside line of the box [bReturn] is an
�  optional return value, with the default being  True
� 
�  Examples:
�  ---------
�   //---------- this just shows progress from 1 - 1000
�   initsup()
�   ProgOn("Test")
�   for i = 1 to 1000
�     IF !ProgDisp(i,1000,{||alltrim(str(i))+" of 1000"},;
�            {||inkey()#27} )
�       exit
�     endif
�   next
�   ProgOff()
� 
�   //--------- this show indexing progress
�   use Customer
�   ProgOn("Index")
�   dbcreateindex("Eraseme","(LNAME)", ;
�    {||ProgDisp( recno(),recc() ),LNAME},.f.)
�   ProgOff()
�   // note the use of parentheses around LNAME.
�   // see also PROGINDEX()
� 
�   //--------- this shows a count progress
�   nCounted := 0
�   nMatches := 0
�   bDisplay := {||alltrim(str(nMatches))+" matches of "+;
�             alltrim(str(nCounted)) }
�   ProgOn("Counting")
�   count for "S"$LNAME to ;
�      nMatches while ProgDisp(++nCounted,recc(),bDisplay )
�   ProgOff()
�   // see also PROGCOUNT()
� 
�  Source:
�  -------
�  S_PROG.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
*/
Function ProgDisp(nCurrent,nTotal,bMessage,bReturn)
local nPercent
if nCurrent#nil .and. nTotal#nil
  nTotal   = iif(nTotal  =0,1,nTotal)
  nPercent := (nCurrent/nTotal)*100
  @14,13 say padr(repl(chr(219), INT(nPercent/2)  ),50,"�")
endif
if bMessage#nil
  @16,8 say padc(eval(bMessage),62)
endif
if bReturn#nil
  return eval(bReturn)
endif
return .t.
