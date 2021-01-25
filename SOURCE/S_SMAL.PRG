#include "inkey.ch"

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SMALLS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SMALLS() Lookup tables on dbf with optional hotkeys, code block
ณ 
ณ  Returns:
ณ  --------
ณ  lReturn   => True if CR pressed, False otherwise
ณ 
ณ  Syntax:
ณ  -------
ณ  Smalls(expDisplayString,[cTitle],[expAlias],[expReturn],;
ณ      [expStartRange,expEndRange],[bException],[lForceCaps])
ณ 
ณ  Description:
ณ  ------------
ณ  Popup windowed lookup tables. Many options.
ณ 
ณ  The up/down/home/end/pgup/pgdn keys are active. If
ณ  there is an controlling index key and the user types alphanumeric
ณ  characters, it is assumed a keysearch is wanted. A read pops up
ณ  allowing the user to complete the search key, and a seek is then
ณ  done.
ณ 
ณ  Pressing ENTER or ESCAPE exits the lookup and closes
ณ  the window.
ณ 
ณ  Depending on values contained in the optional
ณ  parameters, values may be KEYBOARDED or ASSIGNED at that time.
ณ 
ณ  Other keys may be assigned actions, depending on the
ณ  last parameter, described below.
ณ 
ณ  <expDisplayString>  is what appears for each row in
ณ     the lookup table.
ณ 
ณ     Think of it as a column definition for Tbrowse.
ณ       It can be either:
ณ 
ณ       1. A Characters string like
ณ          "LAST+MI+LEFT(FIRST,1)"
ณ          In which case it is macro expanded and made
ณ          into a code block to display this expression
ณ 
ณ       2. A Codeblock like
ณ          {||LAST+MI+LEFT(FIRST,1)}
ณ 
ณ       The resulting codeblock is then used as a
ณ       Tbrowse column definition.
ณ 
ณ  [cTitle]    is an optional lookup box title string
ณ 
ณ  [expAlias]  Determines the area/dbf/ntx to use, can be
ณ     (expC) alias name             or
ณ     (expN) numeric work area      or
ณ     (expC) dbf/ndx in the format
ณ            "%dbfname%ndxname"
ณ 
ณ     If left as nil, the current DBF/NTX are
ณ     used and left open when done at the last record
ณ     pointer position.
ณ 
ณ  [expReturn] This determines what happens when CR is
ณ     pressed. It need not be anything, but it can be:
ณ 
ณ     (expC) a character expression which is
ณ            macro expanded and KEYBOARDed. Any valid character
ณ            expression will do.
ณ 
ณ            (Bear in mind that it must be
ณ              character. If you want to keyboard a value into a DATE
ณ              field, for instance, your keyboard expression could be
ณ              "DTOC(entrydate)"
ณ 
ณ     (expB) a code block which is simply
ณ            evaluated. this can do
ณ            anything you wish. It could assign
ณ            multiple values
ณ            from the lookup file into active
ณ            gets, for instance.
ณ 
ณ  [expStartRange-expEndRange]
ณ     These are valid for indexed files, and
ณ     determine the beginning and ending key ranges. The
ณ     values must match the type of the controlling index.
ณ 
ณ  [bException]
ณ     If this codeblock is passed, any keys
ณ     except up/down/enter/pgup/pgdn/home/end/escape  (and
ณ     alphanumeric keys if indexed )  will cause the block to be
ณ     evaluated like so:
ณ 
ณ       eval(block,lastkey())
ณ 
ณ     Some interesting ideas for this would be
ณ     to assign a key to an update routine for updating the
ณ     lookup dbf while doing a lookup. (yikes - you didn't hear
ณ     that from me!)
ณ 
ณ  [lForceCaps]
ณ 
ณ     Means force capital letters when user is typing in a
ณ     lookup key.  Allows case-insensitive search when index is on
ณ     upper(field)
ณ 
ณ  Examples:
ณ  ---------
ณ   // lookup on "LNAME+' '+FNAME" in current area
ณ   smalls("LNAME+' '+FNAME")
ณ 
ณ   // lookup on "LNAME+' '+FNAME" in current area
ณ   // use "Name" as box title
ณ   smalls("LNAME+' '+FNAME","Name")
ณ 
ณ   // lookup on "LNAME+' '+FNAME" in current area
ณ   // use "Name" as box title
ณ   // go to area 5 for the lookup
ณ   // send LNAME to the keyboard if CR pressed
ณ   smalls({||LNAME+''+FNAME},"Name",5,"LNAME")
ณ 
ณ   // lookup on "LNAME+' '+FNAME" in current area
ณ   // use "Name" as box title
ณ   // go to alias CUSTOMER for the lookup
ณ   smalls("LNAME+''+FNAME","Name","CUSTOMER")
ณ 
ณ   // open customer.dbf and do a lookup on it
ณ   // lookup on "LNAME+' '+FNAME"
ณ   // use "Name" as box title
ณ   smalls("LNAME+''+FNAME","Name","%CUSTOMER")
ณ 
ณ   // open customer.dbf and do a lookup on it
ณ   // lookup on "LNAME+' '+FNAME"
ณ   // use "Name" as box title
ณ   // limit lookup to between "SMITH" and "ZEBRA"
ณ   smalls("LNAME+''+FNAME","Name","%CUSTOMER%NAME",  ;
ณ         "SMITH","ZEBRA")
ณ 
ณ   // open CUSTOMER.DBF with ENTRYDATE.NDX and do a lookup
ณ   // lookup on "LNAME+' '+FNAME"
ณ   // use "Name" as box title
ณ   // limit lookup to the last year
ณ   smalls("LNAME+''+FNAME","Name",  ;
ณ         "%CUSTOMER%ENTRYDATE",date()365, date())
ณ 
ณ  Notes:
ณ  -------
ณ  see SMALLVALID(), SMALLWHEN() and SMALLKSET() for
ณ  various get system interfaces to SMALLS().
ณ 
ณ  Source:
ณ  -------
ณ  S_SMAL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION smalls(expDisplayString,cTitle,expAlias,expReturn,;
                expStartRange,expEndRange,bException,lForceCap)

local nDisplayColumn
local expFirstKey,expLastKey,nNbrRecs
local nTop,nBot,nLeft,nRight,nBoxWidth,lIndexed
local nLastkey,nCurrentRec,cScrollBox,cSearchFor
local bIndexKey,nFirstRec,nLastRec,nStartRec,bDisplayString
local cIndexType  := "U"
local oTb
local lReturn     := .f.
local nCursor     := setcursor(0)
local cOldColor   := Setcolor(sls_popcol())
local lExact      := setexact(.f.)
local lOldSoft    := SET(_SET_SOFTSEEK,.t.)
local lCloseWhenDone := .f.
local nOldArea    := select()
local cDbfName,cIndexName
local lContinue   := .t.
local lFirstDisplay := .t.
local nMouseR, nMouseC, aButtons, nButton, lClick

lContinue := setupdb(expAlias,nOldArea,@lCloseWhenDone)
lForceCap := iif(lForceCap#nil,lForceCap,.f.)
aButtons  := {}
if lContinue

    lIndexed    := !empty(indexkey(0))
    IF EOF()
      dbgobottom()
    elseif bof()
      dbgotop()
    endif
    nStartRec   := RECNO()

    if !empty(indexkey(0))
       bIndexKey  := &("{||"+indexkey(0)+"}")
       cIndexType := valtype( eval(bIndexKey) )
    endif

    *- check for record limits
    * start of range
    IF expStartRange#nil .AND. lIndexed
      SEEK expStartRange
      if found()                            //10-15-1992 added check for found
        expFirstKey   := eval(bIndexKey)
        nFirstRec     := recno()
      else
        go top
        expFirstKey   := eval(bIndexKey)
        nFirstRec     := recno()
      endif
    elseif lIndexed
      go top
      expFirstKey   := eval(bIndexKey)
      nFirstRec     := recno()
   else
      go top
      nFirstRec     := recno()
    ENDIF

    * end of range
    IF expEndRange#nil  .AND. lIndexed    && a key
      if expEndRange > expStartRange    // 10-15-1992 added check for identical
         SEEK expEndRange               // keys i.e. "smith"-"smith"
         IF EOF()   // no match at all
           go bottom                    // scompare is a function below
         ELSEIF scompare(expEndRange,eval(bIndexkey))   // exact match
           while scompare(expEndRange,eval(bIndexKey)) .and. !eof()
             nLastRec := recno()
             skip
           end
           go nLastRec
         ELSE  // must be a softseek near match (softseek is on - see above)
           skip -1
           while empty(eval(bIndexKey))   // test for and skip empty records
             skip -1
           end
         ENDIF
      else  // HANDLE IDENTICAL FIRST & LAST KEYS
         *while scompare(expFirstKey,eval(bIndexKey)) .and. !eof()
         while scompare(expStartRange,eval(bIndexKey)) .and. !eof()
           nLastRec := recno()
           skip
         end
         go nLastRec
      endif
      expLastKey  := eval(bIndexKey)
      nLastRec    := recno()
    elseif lIndexed
      go bottom
      expLastKey  := eval(bIndexKey)
      nLastRec     := recno()
    else
      go bottom
      nLastRec     := recno()
    ENDIF

    go nStartRec
    IF expFirstKey#nil .and. expLastKey#nil .AND. lIndexed
*    IF expStartRange#nil .and. expEndRange#nil .AND. lIndexed
      if eval(bIndexKey)>expLastKey .or. eval(bIndexKey)<expFirstKey
        nStartRec := nFirstRec
        go nStartRec
      endif
    endif

    go nFirstRec
    for nNbrRecs = 1 to 10
       if recno() = nLastRec
         exit
       endif
       skip
    next

    *- record starting record
    GO nStartRec

    DO WHILE .T.
      *- was a title passed ?
      IF cTitle==nil
        cTitle = 'Select'
      ENDIF

      *- what is the display string?
      if valtype(expDisplayString)=="B"
        bDisplayString := expDisplayString
      else    // assume character
        bDisplayString := &("{||"+expDisplayString+"}")
      endif

      *- how wide does our window need to be
      nBoxWidth  := LEN(eval(bDisplayString))+1

      *- get longest of display string/title as window width
      nBoxWidth := max(28,nBoxWidth)
      nBoxWidth := MAX(nBoxWidth,LEN(cTitle)+2)
      nBoxWidth := min(74,nBoxWidth)

      *- figure window parameters (centered on screen)
      nLeft     :=  INT((78-(nBoxWidth))/2)
      nRight    := nLeft+1+nBoxWidth+1
      nTop      :=7
      nBot      :=min(nNbrRecs+8,16)

      dispbegin()
      *- draw the box and the title
      cScrollBox  := makebox(nTop-1,nLeft-1,nBot+3,nRight+1,sls_popcol())
      @nBot+1,nLeft to nBot+1,nRight
      @nBot+2,nLeft say "[][] [ENTER=ok] [ESC=cancel]"
      aButtons := {{nBot+2,nLeft+7,nBot+2,nLeft+16},{nBot+2,nLeft+18,nBot+2,nLeft+29}}

      oTb:= tbrowsedb(nTop,nLeft,nBot,nRight)
      oTb:addcolumn(tbColumnNew(cTitle,bDisplayString))
      oTb:gobottomblock := {||dbgoto(nLastRec)}
      oTb:gotopblock := {||dbgoto(nFirstRec)}
      oTb:skipblock := {|n|smalskip(n,nFirstRec,nLastRec) }
      oTb:HeadSep := "ฤ"

      *- go to start record
      GO nStartRec


      *- main loop
      DO WHILE .T.
        dispbegin()
        while !oTb:stabilize()
        end
        dispend()

        if lFirstDisplay
          lFirstDisplay := .f.
          dispend()
        endif

        nMouseR  := 0; nMouseC := 0
        nLastkey := rat_event(0,.f.,.f.,@nMouseR, @nMouseC)
        nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
        lClick   := MBRZCLICK(oTb,nMouseR, nMouseC)

        *- do action based on keystroke
        DO CASE
        CASE  nLastkey = K_UP
          oTb:up()
        CASE nLastkey = K_DOWN
          oTb:down()
        CASE nLastkey = K_ENTER .or. lClick .or. nButton==1
          if valtype(expReturn)=="C"
            KEYBOARD &expReturn
          elseif valtype(expReturn)=="B"
            eval(expReturn)
          ENDIF
          lReturn := .t.
          EXIT
        CASE nLastkey = K_PGUP
          oTb:pageup()
        CASE nLastkey = K_PGDN
          oTb:pagedown()
        CASE nLastkey = K_HOME
          oTb:gotop()
        CASE nLastkey = K_END
          oTb:gobottom()
        CASE UPPER(CHR(nLastkey )) $;
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" .AND. lIndexed
            cSearchFor := eval(bIndexKey)
            keyboard chr(nLastkey)
            if lForceCap
              popread(.t.,"Search For:",@cSearchFor,"@K!")
            else
              popread(.t.,"Search For:",@cSearchFor,"@K")
            endif
            cSearchFor  := iif(valtype(cSearchfor)=="C",trim(cSearchFor),cSearchfor)
            nCurrentRec := RECNO()

            // check that the search string is in range of the expFirstKey and
            // expLastkey
            if ( VALTYPE(cSearchfor)=="C" .and. ;
                  cSearchFor >= left(expFirstKey,len(cSearchfor))  .and. ;
                  cSearchFor <= left(expLastKey,len(cSearchfor)) ) .or. ;
              ( VALTYPE(cSearchfor)#"C" .and. ;
                  cSearchFor >= expFirstKey .and. cSearchFor <= expLastKey )

                SEEK cSearchFor
                // IF !FOUND()  // 10-15-1992 CHANGED
                IF EOF()        // USE SOFTSEEK CAPABILITY TO FIND NEAR MATCH
                  GO nCurrentRec
                ELSE
                  oTb:rowpos := 1
                  oTb:configure()
                  oTb:refreshall()
                ENDIF
            endif
        CASE nLastkey = K_ESC .or. nButton==2
             lReturn := .f.
             EXIT
        case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft, nBot+2, nLeft+2)
            oTb:up()
            IFMOUSEHD({||oTb:up()},oTb)
        case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft+3, nBot+2, nLeft+5)
            oTb:down()
            IFMOUSEHD({||oTb:down()},oTb)
        CASE MBRZMOVE(oTb,nMouseR,nMouseC,nTop+2,nLeft,nBot,nRight)
        case bException#nil
             eval(bException,nLastkey)
             reconfig(bIndexKey,expStartRange,expEndRange,lIndexed,;
                      @expFirstKey,@nFirstRec,@expLastKey,@nLastRec)
             oTb:refreshall()
        ENDCASE
      ENDDO
      unbox(cScrollBox)
      EXIT
    ENDDO
endif
SETCURSOR(nCursor)
SET(_SET_SOFTSEEK,lOldSoft)
setcolor(cOldColor)
setexact(lExact)
if lCloseWhenDone
  USE
endif
select (nOldArea)
RETURN lReturn


//=================================================================
static function smalskip(n,nFirstRec,nLastRec)
  local skipcount := 0
  do case
  case n > 0
    do while recno()<>nLastRec .and. skipcount < n
      dbskip(1)
      skipcount++
    enddo
  case n < 0
    do while recno()<>nFirstRec .and. skipcount > n
      dbskip(-1)
      skipcount--
    enddo
  endcase
return skipcount

static function setupdb(expAlias,nOldArea,lCloseWhenDone)
local cDbfName,cIndexName
local lContinue := .t.
if expAlias#nil
  if !empty(expAlias)
    do case
    case valtype(expAlias)=="N"
       select (expAlias)
       if !used()
         lContinue := .f.
         select (nOldArea)
       endif
    case valtype(expAlias)=="C"
       if "%"$expAlias
         select 0
         cDbfName   := takeout(expAlias,'%',2)
         cIndexName := takeout(expAlias,'%',3)
         lContinue  := !empty(cDbfName)
         IF !EMPTY(cDbfName)
           if !SNET_USE(cDbfName,cDbfName,.f.,5,.t.,"Network error opening LOOKUP file. Keep trying?")
             select (nOldArea)
             lContinue := .f.
           else
             IF !EMPTY(cIndexName)
               SET INDEX TO (cIndexName)
             ENDIF
             lCloseWhenDone := .t.
           endif
         ENDIF
       else
        if select(expAlias) > 0
          SELECT (select(expAlias))
        endif
      endif
    endcase
  endif
endif
return lContinue




static proc reconfig(bIndexKey,expStartRange,expEndRange,lIndexed,;
                   expFirstKey,nFirstRec,expLastKey,nLastRec)
local nStartRec,nNbrRecs

nStartRec   := RECNO()

*- check for record limits
* start of range
go top // msb 07/26/94

IF expStartRange#nil .AND. lIndexed
  SEEK expStartRange
  if found()                            //10-15-1992 added check for found
    expFirstKey   := eval(bIndexKey)
    nFirstRec     := recno()
  else
    go top
    expFirstKey   := eval(bIndexKey)
    nFirstRec     := recno()
  endif
elseif lIndexed
  go top
  expFirstKey   := eval(bIndexKey)
  nFirstRec     := recno()
else
  go top
  nFirstRec     := recno()
ENDIF

* end of range
IF expEndRange#nil  .AND. lIndexed    && a key
  if expEndRange > expStartRange    // 10-15-1992 added check for identical
     SEEK expEndRange               // keys i.e. "smith"-"smith"
     IF EOF()   // no match at all
       go bottom                    // scompare is a function below
     ELSEIF scompare(expEndRange,eval(bIndexkey))   // exact match
       while scompare(expEndRange,eval(bIndexKey)) .and. !eof()
         nLastRec := recno()
         skip
       end
       go nLastRec
     ELSE  // must be a softseek near match (softseek is on - see above)
       skip -1
       while empty(eval(bIndexKey))   // test for and skip empty records
         skip -1
       end
     ENDIF
  else  // HANDLE IDENTICAL FIRST & LAST KEYS
     *while scompare(expFirstKey,eval(bIndexKey)) .and. !eof()
     while scompare(expStartRange,eval(bIndexKey)) .and. !eof()
       nLastRec := recno()
       skip
     end
     go nLastRec
  endif
  expLastKey  := eval(bIndexKey)
  nLastRec    := recno()
elseif lIndexed
  go bottom
  expLastKey  := eval(bIndexKey)
  nLastRec     := recno()
else
  go bottom
  nLastRec     := recno()
ENDIF

go nStartRec
IF expFirstKey#nil .and. expLastKey#nil .AND. lIndexed
  if eval(bIndexKey)>expLastKey .or. eval(bIndexKey)<expFirstKey
    nStartRec := nFirstRec
    go nStartRec
  endif
endif

go nFirstRec
for nNbrRecs = 1 to 10
   if recno() = nLastRec
     exit
   endif
   skip
next

*- record starting record
GO nStartRec

return


// This function is to compare a range value with an index key, where
// the index key may be longer than the range value given
// expRange is the range value, expIndexKey is the index key value
// i.e. "SM" should pick up "SMITH" as sell as "SMYTHE"

static function scompare(expRange,expIndexKey)
local lEqual, nLen
if valtype(expRange)=="C"
  nLen := len(expRange) // use the range key as the basis
  lEqual := (expRange==left(expIndexKey,nLen) )  // if character, adjust length
else
  lEqual := (expRange=expIndexKey)                 // otherwise,
endif
return lEqual








