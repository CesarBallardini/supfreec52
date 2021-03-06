#include "inkey.ch"

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SMALLS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SMALLS() Lookup tables on dbf with optional hotkeys, code block
³ 
³  Returns:
³  --------
³  lReturn   => True if CR pressed, False otherwise
³ 
³  Syntax:
³  -------
³  Smalls(expDisplayString,[cTitle],[expAlias],[expReturn],;
³      [expStartRange,expEndRange],[bException],[lForceCaps])
³ 
³  Description:
³  ------------
³  Popup windowed lookup tables. Many options.
³ 
³  The up/down/home/end/pgup/pgdn keys are active. If
³  there is an controlling index key and the user types alphanumeric
³  characters, it is assumed a keysearch is wanted. A read pops up
³  allowing the user to complete the search key, and a seek is then
³  done.
³ 
³  Pressing ENTER or ESCAPE exits the lookup and closes
³  the window.
³ 
³  Depending on values contained in the optional
³  parameters, values may be KEYBOARDED or ASSIGNED at that time.
³ 
³  Other keys may be assigned actions, depending on the
³  last parameter, described below.
³ 
³  <expDisplayString>  is what appears for each row in
³     the lookup table.
³ 
³     Think of it as a column definition for Tbrowse.
³       It can be either:
³ 
³       1. A Characters string like
³          "LAST+MI+LEFT(FIRST,1)"
³          In which case it is macro expanded and made
³          into a code block to display this expression
³ 
³       2. A Codeblock like
³          {||LAST+MI+LEFT(FIRST,1)}
³ 
³       The resulting codeblock is then used as a
³       Tbrowse column definition.
³ 
³  [cTitle]    is an optional lookup box title string
³ 
³  [expAlias]  Determines the area/dbf/ntx to use, can be
³     (expC) alias name             or
³     (expN) numeric work area      or
³     (expC) dbf/ndx in the format
³            "%dbfname%ndxname"
³ 
³     If left as nil, the current DBF/NTX are
³     used and left open when done at the last record
³     pointer position.
³ 
³  [expReturn] This determines what happens when CR is
³     pressed. It need not be anything, but it can be:
³ 
³     (expC) a character expression which is
³            macro expanded and KEYBOARDed. Any valid character
³            expression will do.
³ 
³            (Bear in mind that it must be
³              character. If you want to keyboard a value into a DATE
³              field, for instance, your keyboard expression could be
³              "DTOC(entrydate)"
³ 
³     (expB) a code block which is simply
³            evaluated. this can do
³            anything you wish. It could assign
³            multiple values
³            from the lookup file into active
³            gets, for instance.
³ 
³  [expStartRange-expEndRange]
³     These are valid for indexed files, and
³     determine the beginning and ending key ranges. The
³     values must match the type of the controlling index.
³ 
³  [bException]
³     If this codeblock is passed, any keys
³     except up/down/enter/pgup/pgdn/home/end/escape  (and
³     alphanumeric keys if indexed )  will cause the block to be
³     evaluated like so:
³ 
³       eval(block,lastkey())
³ 
³     Some interesting ideas for this would be
³     to assign a key to an update routine for updating the
³     lookup dbf while doing a lookup. (yikes - you didn't hear
³     that from me!)
³ 
³  [lForceCaps]
³ 
³     Means force capital letters when user is typing in a
³     lookup key.  Allows case-insensitive search when index is on
³     upper(field)
³ 
³  Examples:
³  ---------
³   // lookup on "LNAME+' '+FNAME" in current area
³   smalls("LNAME+' '+FNAME")
³ 
³   // lookup on "LNAME+' '+FNAME" in current area
³   // use "Name" as box title
³   smalls("LNAME+' '+FNAME","Name")
³ 
³   // lookup on "LNAME+' '+FNAME" in current area
³   // use "Name" as box title
³   // go to area 5 for the lookup
³   // send LNAME to the keyboard if CR pressed
³   smalls({||LNAME+''+FNAME},"Name",5,"LNAME")
³ 
³   // lookup on "LNAME+' '+FNAME" in current area
³   // use "Name" as box title
³   // go to alias CUSTOMER for the lookup
³   smalls("LNAME+''+FNAME","Name","CUSTOMER")
³ 
³   // open customer.dbf and do a lookup on it
³   // lookup on "LNAME+' '+FNAME"
³   // use "Name" as box title
³   smalls("LNAME+''+FNAME","Name","%CUSTOMER")
³ 
³   // open customer.dbf and do a lookup on it
³   // lookup on "LNAME+' '+FNAME"
³   // use "Name" as box title
³   // limit lookup to between "SMITH" and "ZEBRA"
³   smalls("LNAME+''+FNAME","Name","%CUSTOMER%NAME",  ;
³         "SMITH","ZEBRA")
³ 
³   // open CUSTOMER.DBF with ENTRYDATE.NDX and do a lookup
³   // lookup on "LNAME+' '+FNAME"
³   // use "Name" as box title
³   // limit lookup to the last year
³   smalls("LNAME+''+FNAME","Name",  ;
³         "%CUSTOMER%ENTRYDATE",date()365, date())
³ 
³  Notes:
³  -------
³  see SMALLVALID(), SMALLWHEN() and SMALLKSET() for
³  various get system interfaces to SMALLS().
³ 
³  Source:
³  -------
³  S_SMAL.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
      oTb:HeadSep := "Δ"

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








