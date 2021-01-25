
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#ifndef K_SPACE
  #define K_SPACE 32
#endif

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION DUPHANDLE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  DUPHANDLE() Duplicate record finder with delete/copy options
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  DUPHANDLE([aFields,aDesc],[aOpenIndexes])
ณ 
ณ  Description:
ณ  ------------
ณ  DUPHANDLE() is similiar to DUPLOOK(), but takes a
ณ  different approach The user is asked to select fields (only
ณ  Character fields are presented) to check for duplication. The
ณ  fields selected are combined into an index key, and an index is
ณ  created. The database is then scanned for duplicates. If a
ณ  duplicate set is found, a Tbrowse/tag window is popped up, and
ณ  the user is asked to tag records. This continues until all
ณ  duplicate sets are found, or the user chooses to quit the
ณ  process. The user is then allowed to Process the tagged
ณ  duplicate records. There are 4 possible options:
ณ 
ณ         Delete all tagged records
ณ         Delete all NOT tagged records
ณ         Copy all tagged records
ณ         Copy all NOT tagged records
ณ 
ณ  The options are not mutually exclusive. For instance,
ณ  you could copy all tagged records to a history file, and then
ณ  delete them.
ณ 
ณ  As with all SuperLib deletions, the PACKING is left
ณ  to you.
ณ 
ณ  [aFields,aDesc] are optional arrays of fieldnames and
ณ  field descriptions
ณ 
ณ  [aOpenIndexes] is an optional array of currently open
ณ  index names. Clipper has no way to determine the names of
ณ  currently open indexes and, since this function creates
ณ  temporary indexes, the current indexes will be closed. Only by
ณ  having a list [aOpenIndexes] can we re-open the indexes on exit.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  USE customer
ณ 
ณ  duphandle()
ณ 
ณ  Warnings:
ณ  ----------
ณ  Closes all indexes.
ณ 
ณ  Source:
ณ  -------
ณ  S_DUPH.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION DUPHANDLE(aFields,aDesc,aOpenIndexes)
local aCharFields := {}
local aCharDesc   := {}
local aTagged     := {}
local aLogical
local cInscreen := SAVESCREEN(0,0,24,79)
local cOldColor := Setcolor()
local nOldCursor:= setcursor(0)
local bOldf10   := SETKEY(K_F10)
local nFieldCount,nSelection
local cTempNTX,cIndexExpr,bIndexExpr
local aTagAction := {}
local cEmpty,i

IF !USED()
  RETURN ''
ENDIF

aOpenIndexes  := iif(aOpenIndexes#nil,aOpenIndexes,{})
asize(aOpenIndexes,10)
for i = 1 to 10
  if aOpenIndexes[i]==nil
    aOpenIndexes[i] := ""
  endif
next



if aFields==nil .or. aDesc==nil
  aFields := afieldSx()
  aDesc   := aclone(aFields)
endif
for i = 1 to len(aFields)
  if type(aFields[i])=="C"
    aadd(aCharFields,aFields[i])
    aadd(aCharDesc,aDesc[i])
  endif
next

nFieldCount     := len(aCharFields)
aLogical        := array(nFieldCount)
Afill(aLogical,.F.)

Setcolor(sls_normcol())
@0,0,24,79 BOX sls_frame()
*- draw the screen
Setcolor(sls_popcol())
@1,1,9,45 BOX sls_frame()
@21,1,23,78 BOX sls_frame()
@1,2 SAY '[ Duplicate Handler ]'

SET PRINTER TO (sls_prn())

*- main loop
DO WHILE .T.
  @22,2 say padc(alltrim(str(len(aTagAction)))+" duplicate records tagged",SBCOLS(2,78,.f.))
  @02,30 SAY iif(len(aTagged)>0,"[Done]","      ")
  @03,30 SAY iif(!empty(cTempNtx),"[Done]","      ")
  @04,30 SAY iif(len(aTagAction)>0,"[Done]","      ")
  GO TOP
  *- do the menu
  Setcolor(sls_popmenu())
  nSelection := RAT_MENU2({;
                {02,3 ,"Select Duplicate Field Set "},;
                {03,3 ,"Build Duplicate Index      "},;
                {04,3 ,"Scan/Tag Duplicate Sets    "},;
                {05,3 ,"Process Tagged Duplicates  "},;
                {06,3 ,"Clear Tagged Duplicates    "},;
                {07,3 ,"Quit"}},nSelection)
  Setcolor(sls_popcol())
  
  DO CASE
  CASE nSelection = 1
    set index to
    if !empty(cTempNTX)
       erase (getdfp()+cTempNTX)
    endif
    cTempNtx := ""
    aTagged := tagarray(aCharDesc,nil,nil,aLogical)
    
  CASE nSelection = 2 .AND. len(aTagged) > 0

    *- look for duplicates, write them to a file
    
    PROGON("Indexing")

    *- make a temp index
    set index to
    if !empty(cTempNTX)
       erase (getdfp()+cTempNTX)
    endif
    cTempNTX := UNIQFNAME(RIGHT(INDEXEXT(),3),getdfp())
    cIndexExpr := ""
    aeval(aTagged,{|e|cIndexExpr+=[+]+aCharFields[e]})
    cEmpty := repl(chr(254),len(&cIndexExpr) )
    bIndexExpr  := &("{||iif(!empty("+cIndexExpr+"),"+cIndexExpr+",["+cEmpty+"])}" )

    dbcreateindex(cTempNtx,"("+cIndexExpr+")",{||ProgDisp( recno(),recc() ),eval(bIndexExpr) },.f.)
    ProgOff()

    set index to     // this is needed to detach the hairy codeblock above


  CASE nSelection = 3 .and. !empty(cTempNtx)
    set index to (cTempNtx)
    aTagAction := perform(aFields,aDesc,bIndexExpr)
    
  CASE nSelection = 4 .and. len(aTagAction) > 0
    process(aTagaction)

  CASE nSelection = 5
    aTagaction := {}
  CASE nSelection = 6 .OR. nSelection = 0
    set index to
    if !empty(cTempNTX)
       erase (getdfp()+cTempNTX)
    endif
    SET INDEX TO (aOpenIndexes[1]),(aOpenIndexes[2]),(aOpenIndexes[3]),(aOpenIndexes[4]),(aOpenIndexes[5]),(aOpenIndexes[6]),(aOpenIndexes[7]),(aOpenIndexes[8]),(aOpenIndexes[9]),(aOpenIndexes[10])
    RESTSCREEN(0,0,24,79,cInscreen)
    Setcolor(cOldColor)
    setcursor(nOldCursor)
    SETKEY(-9,bOldf10)
    exit
  ENDCASE
ENDDO
return ''


//-------------------------------------------------------------------
static function perform(aFields,aDesc,bIndexExpr)
local nLogBeg := 1
local nLogEnd := 1
local oTb
local i,lEndofFile := .f.
local cBox
local aTagged := {}
local nLastKey,nFoundTagged
local nMouseR, nMouseC, aButtons, nbutton
local cKeyCurrent

oTb := tbrowsenew(5,5,18,75)
oTb:addcolumn(TBColumnNew('Tag',{||iif((Ascan(aTagged,recno())> 0) ,'๛',' ')} ))
for i = 1 to len(aFields)
  oTb:addcolumn(tbColumnNew(aDesc[i],expblock( aFields[i] )))
next
oTb:skipblock     := {|n|dupskip(n,nLogBeg,nLogEnd)}
oTb:gotopblock    := {||dbgoto(nLogBeg)}
oTb:gobottomblock := {||dbgoto(nLogEnd)}
oTb:headsep := "ฤ"


oTb:freeze  := 1
cKeyCurrent := ""
cBox := makebox(4,4,21,76)
scroll(5,5,20,75,0)
@5,5 say "Searching for next set of duplicates..."
DO WHILE !lEndOfFile
  cKeyCurrent := eval(bIndexExpr)
  if chr(254)$cKeyCurrent
     exit
  endif

  *- store the record #
  nLogBeg    := RECNO()
  nLogEnd    := 0

  *- go to next record
  SKIP
  While (!EOF()) .AND. (eval(bIndexExpr) == cKeyCurrent)
      nLogEnd := recno()
      skip
      lEndOfFile := EOF()
  end
  if nLogEnd > 0
     @19,6 to 19,74
     @20,6 SAY "[][][][]   [SPACE=tag]   [ENTER=next set]   [F10=done]"
     aButtons := {{20,21,20,31,K_SPACE},;
                  {20,35,20,50,K_ENTER},;
                  {20,54,20,63,K_F10}}
     go nLogBeg
     oTb:refreshall()
     oTb:rowpos := 1
     while .t.
       while !oTb:Stabilize()
       end
       nMouseR := 0; nMouseC := 0
       nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

       nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)

       do case
       case nLastkey == K_F10 .or. nButton == K_F10
         exit
       case nLastKey == K_ENTER .or. nButton == K_ENTER
         exit
       case nLastKey == K_UP
         oTb:up()
       case nLastKey == K_DOWN
         oTb:down()
       case nLastKey == K_HOME
         oTb:gotop()
       case nLastKey == K_END
         oTb:gobottom()
       case nLastKey == K_RIGHT
         oTb:right()
       case nLastKey == K_LEFT
         oTb:left()
       case nLastKey == K_SPACE .or. nButton == K_SPACE .or. ;
                        MBRZCLICK(oTb,nMouseR, nMouseC)
         *- LOOK FOR RECORD # IN ARRAY
         nFoundTagged = aSCAN(aTagged,recno())
         if nFoundTagged > 0
           aDEL(aTagged,nFoundTagged)
           ASIZE(aTagged,len(aTagged)-1)
         else
           aadd(aTagged,recno())
         endif
         oTb:REFRESHCURRENT()
       case ISMOUSEAT(nMouseR, nMouseC,20,6,20,8)
         oTb:up()
         IFMOUSEHD({||oTb:up()},oTB)
       case ISMOUSEAT(nMouseR, nMouseC,20,9,20,11)
         oTb:down()
         IFMOUSEHD({||oTb:down()},oTB)
       case ISMOUSEAT(nMouseR, nMouseC,20,12,20,14)
         oTb:right()
         IFMOUSEHD({||oTb:right()},oTB)
       case ISMOUSEAT(nMouseR, nMouseC,20,15,20,17)
         oTb:left()
         IFMOUSEHD({||oTb:left()},oTB)
       case MBRZMOVE(oTb, nMouseR, nMouseC, 7,5,18,75)
       endcase
     end
     scroll(5,5,20,75,0)
     if nLastKey==K_F10 .or. nButton == K_F10
       if messyn("End search?")
         exit
       endif
     endif
     @5,5 say "Searching for next set of duplicates..."
     go nLogEnd
     skip
     lEndOfFile := EOF()
  endif
ENDDO
unbox(cBox)
return aTagged

//-------------------------------------------------------------------
static function dupskip(n,nLogBeg,nLogEnd)
  local skipcount := 0
  do case
  case n > 0
    do while recno()#nLogEnd .and. skipcount < n
      skip
      skipcount++
    enddo
  case n < 0
    do while recno()#nLogBeg .and. skipcount > n
      skip -1
      skipcount--
    enddo
  endcase
return skipcount



//-------------------------------------------------------------------
static function process(aTagged)
local cBox    := makebox(4,13,17,47)
local nTagged := len(aTagged)
local nChoice,cDbfName
local lContinue := .t.
local nProcessed
@ 6,16 SAY "["+alltrim(str(nTagged))+" Records Tagged]"
do while .t.
    nChoice := RAT_MENU2({;
            {8,16 ,'Delete all tagged records    '},;
            {9,16 ,'Delete all NOT tagged records'},;
            {11,16,'Copy all tagged records      '},;
            {12,16,'Copy all NOT tagged records  '},;
            {14,16,'Quit to Main Menu            '}},nChoice)

     do case
        CASE nChoice = 1
           if messyn("Delete all tagged records?")
              lContinue  := .t.
              nProcessed := 0
              PROGON("Deleting tagged records")
              set order to 0
              dbgotop()
              DBEVAL({||lContinue := dhdelete()},;
                     {||ascan(aTagged,recno())>0},;
                     {||progdisp(nProcessed++,recc() ),lContinue}  )

              PROGOFF()
              set order to 1
           endif
        CASE nChoice = 2
           if messyn("Delete all NOT tagged records?")
              lContinue  := .t.
              nProcessed := 0
              PROGON("Deleting all NOT tagged records")
              set order to 0
              dbgotop()
              DBEVAL({||lContinue := dhdelete()},;
                     {||ascan(aTagged,recno())=0},;
                     {||progdisp(nProcessed++,recc() ),lContinue}  )

              PROGOFF()
              set order to 1
           endif
        CASE nChoice = 3
           if messyn("Copy all tagged records?")
              cDbfName := getdbfname("")
              IF !EMPTY(cDbfName) .and. messyn("Go ahead with copy?")
                dbgotop()
                nProcessed := 0
                ProgOn("Copying tagged records")
                copy to (cDbfNAme) for (ascan(aTagged,recno())>0) ;
                    while ProgDisp(nProcessed++,recc())
                ProgOff()
              ENDIF
           endif
        CASE nChoice = 4
          if messyn("Copy all NOT tagged records?")
             cDbfName := getdbfname("")
            IF !EMPTY(cDbfName) .and. messyn("Go ahead with copy?")
              dbgotop()
              nProcessed := 0
              ProgOn("Copying NOT tagged records")
              copy to (cDbfName) for (ascan(aTagged,recno())=0)  ;
                   while ProgDisp(nProcessed++,recc())
              ProgOff()
            ENDIF
         endif
        CASE nChoice = 5
          exit
     endcase
enddo
unbox(cBox)
return nil



static function dhdelete()
local lReturn := .t.
if rlock()
  dbdelete()
  unlock
else
  IF SREC_LOCK(5,.T.,"Unable to lock record to delete. Try again?")
    dbdelete()
    unlock
  ELSE
    if !messyn("Abandon operation?","No","Yes")
      lReturn := .f.
    endif
  ENDIF
endif
return lReturn


//-------------------------------------------------------------
static FUNCTION getdbfname(cDbfName)

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
      MSG("Database "+cDbfName+" already exists - ","Use another name")
      cDbfName := ''
      LOOP
  ENDIF
  EXIT
ENDDO
return cDbfName
