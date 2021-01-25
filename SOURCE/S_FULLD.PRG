
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#include "Directry.ch"

memvar getlist


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FULLDIR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FULLDIR() Interactively navigate directories
ณ 
ณ  Returns:
ณ  --------
ณ  <lSelected> => Directory was selected
ณ 
ณ  Syntax:
ณ  -------
ณ  FULLDIR([lChange],[@cDirName])
ณ 
ณ  Description:
ณ  ------------
ณ  Interactively navigates directories on the current
ณ  drive.
ณ 
ณ  Allows reading of a file ( with FILEREAD() ) in a
ณ  directory.
ณ 
ณ  If file is DBF, does a DBEDIT browse (watch your
ณ  memory..)
ณ 
ณ  [lChange]    True - change to selected directory
ณ               False - don't change to selected directory
ณ               Default is True - change
ณ 
ณ  [@cDirName] Char string passed by reference, will
ณ  contain name of selected directory on return.
ณ 
ณ  Examples:
ณ  ---------
ณ   cNewDir := ""
ณ 
ณ   if FULLDIR(.F.,@cNewDir)
ณ       SET DEFAULT TO (cNewDir)
ณ       ?"New directory is:"
ณ       ?Curdir()
ณ   endif
ณ 
ณ   if FULLDIR(.t.)
ณ       ?"New directory is:"
ณ       ?Curdir()
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_FULLD.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION fulldir(lChange,cDirName)
local cToTb,nOldArea
local cDirBox,nOldCursor

nOldArea = SELECT()
SELECT 0

*****
nOldCursor = setcursor(1)

IF VALTYPE(lChange)<>"L"
  lChange = .t.
ENDIF


*- draw the box
*- get the directory to change to
cDirBox=makebox(10,10,15,70,SLS_POPCOL())
cToTb = SPACE(50)
@11,12 SAY "Directory to change to :"
@12,12 GET cToTb
@14,12 SAY "[ENTER=selection box]   [ESC=cancel]"
RAT_READ(getlist,1,.f.,K_ESC,{|r,c|enteresc(r,c)})
unbox(cDirBox)

*- if escape - get outa here
IF LASTKEY() = 27
  *- set cursor on
  SETCURSOR(nOldCursor)
  SELECT (nOldArea)
  RETURN .F.
ENDIF

*- if left blank, user wants a choice
IF EMPTY(cToTb)
  cToTb = TRIM(floater())
  IF !cToTb == "\"
    cToTb = LEFT(cToTb,LEN(cToTb)-1)
  ENDIF
ENDIF

*- so where are we going
cToTb = Alltrim(cToTb)

*- if its not empty
IF !EMPTY(cToTb) .AND. lChange
  *- double check if that's what the user wants
  IF messyn("Change directory to: "+cToTb)
    *- attempt to change
    IF !cdir(cToTb)
      *- if unsuccesful - notify user
      msg("Unable to change to "+cToTb)
      cToTb := ""
    ENDIF
  ELSE
    cToTb := ""
  ENDIF
ENDIF
cDirName := cToTb          // PASSED BY REFERENCE
SETCURSOR(nOldCursor)
SELECT (nOldArea)
RETURN !empty(cToTb)

static function enteresc(r,c)
if r==14
   if c>=12 .and. c<=32
     keyboard chr(K_ENTER)
   elseif c>=36 .and. c<=47
     keyboard chr(K_ESC)
   endif
endif
RETURN nil


STATIC FUNCTION floater

local aDirectory
// this is to handle Funcky's funky curdir()
local cCurrdir  := iif(":\"$curdir(),subst(curdir(),at(":\",curdir())+2),curdir())
local cFullPath := iif(empty(cCurrDir),"\","\"+cCurrDir+"\")
local nElement := 1
local nLastkey,cLastkey,nMouser, nMouseC, nButton,aButtons,lClick, nFound
local cBox     := makebox(2,2,23,78,SLS_NORMCOL())
local oTb     := tbrowseNew(3,3,19,77)
@20,3 to 20,77

oTb:addcolumn(tbColumnNew("File",{||padr(aDirectory[nElement,1],13)}  ))
oTb:addcolumn(tbColumnNew("",{||iif("D"$aDirectory[nElement,5],"<DIR>","     ")}  ))
oTb:addcolumn(tbColumnNew("Size",{||iif("D"$aDirectory[nElement,5],space(10),padl(aDirectory[nElement,2],10))}  ))
oTb:addcolumn(tbColumnNew("Date",{||aDirectory[nElement,3]}  ))
oTb:addcolumn(tbColumnNew("Time",{||aDirectory[nElement,4]}  ))
oTb:SKIPBLOCK := {|n|AASKIP(n,@nElement,LEN(aDirectory))}
oTb:gobottomblock := {||nElement := len(aDirectory)}
oTb:gotopblock    := {||nElement := 1}
oTb:headsep       := chr(196)
oTb:colorspec := sls_popmenu()

aDirectory := directory(cFullPath+"*.*","D")
if aDirectory[1,1]=="."
  ADEL(aDirectory,1)
  ASIZE(aDirectory,len(aDirectory)-1)
endif
aDirectory := dsort(aDirectory)


@22,3 SAY "[ENTER=dir  ]  [F10=accept]  [ESC=cancel]  [ALT-V=view file]  [][][][]"
aButtons :=  {  {22,3,22,16,K_ENTER},;
                {22,18,22,29,K_F10},;
                {22,32,22,43,K_ESC},;
                {22,46,22,62,K_ALT_V}}
while .t.
  @21,3 say padr("DIRECTORY:"+cFullPath,75) color sls_normcol()
  while !oTb:stabilize()
  end
  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
  cLastKey := upper(chr(nLastkey))
  nButton  := MOUSEHOTAT(nMouseR, nMouseC,aButtons)
  lClick   := MBRZCLICK(oTb,nMouseR, nMouseC)
  do case
  CASE nLastKey = K_UP          && UP ONE ROW
    oTb:UP()
  CASE nLastKey = K_PGUP        && UP ONE PAGE
    oTb:PAGEUP()
  CASE nLastKey = K_LEFT        && UP ONE ROW
    oTb:left()
  CASE nLastKey = K_RIGHT       && UP ONE PAGE
    oTb:right()
  CASE nLastKey = K_HOME        && HOME
    oTb:GOTOP()
  CASE nLastKey = K_DOWN        && DOWN ONE ROW
    oTb:DOWN()
  CASE nLastKey = K_PGDN        && DOWN ONE PAGE
    oTb:PAGEdOWN()
  CASE nLastKey = K_END         && END
    oTb:GOBOTTOM()
  case cLastKey$"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    nFound := ASCAN(aDirectory,{|e|LEFT(e[1],1)==cLastKey},nElement+1)
    if nFound==0 .and. nElement > 1
      nFound := ASCAN(aDirectory,{|e|LEFT(e[1],1)==cLastKey})
    endif
    if nFound > 0
      fd_goto(nFound,nElement,oTb)
    endif
  case nLastkey == K_ENTER .OR. nButton==K_ENTER .or. lClick
    if "D"$aDirectory[nElement,5]
      do case
      case aDirectory[nElement,1]=="."   // this - do nothing
         if multimsgyn({"Change to ",cFullPath})
           exit
         endif
      case aDirectory[nElement,1]==".."  // prior
         cFullPath := priordir(cFullPath)
         aDirectory := directory(cFullPath+"*.*","D")
         if aDirectory[1,1]=="."
           ADEL(aDirectory,1)
           ASIZE(aDirectory,len(aDirectory)-1)
         endif
         aDirectory := dsort(aDirectory)
         oTb:rowpos := 1
         nElement    := 1
         oTb:refreshall()
      otherwise
         cFullPath += aDirectory[nElement,1]+"\"
         aDirectory := directory(cFullPath+"*.*","D")
         if aDirectory[1,1]=="."
           ADEL(aDirectory,1)
           ASIZE(aDirectory,len(aDirectory)-1)
         endif
         aDirectory := dsort(aDirectory)
         oTb:rowpos := 1
         nElement    := 1
         oTb:refreshall()
      endcase
    else
    endif
  case nLastkey == K_ESC .OR. nButton==K_ESC
    cFullPath := ""
    EXIT
  case nLastkey == K_F10 .OR. nButton==K_F10
    EXIT
  case nLastkey == K_ALT_V  .OR. nButton==K_ALT_V    // view
    viewit(cFullpath+aDirectory[nElement,1] )
  case nLastKey == K_MOUSELEFT // mouse
    DO CASE
    CASE ISMOUSEAT(nMouseR, nMouseC,22,65,22,67)
          oTb:up()
          IFMOUSEHD( {||oTb:up()} , oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,22,68,22,70)
          oTb:down()
          IFMOUSEHD( {||oTb:down()} , oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,22,71,22,73)
          oTb:right()
          IFMOUSEHD( {||oTb:right()} , oTb)
    CASE ISMOUSEAT(nMouseR, nMouseC,22,74,22,76)
          oTb:left()
          IFMOUSEHD( {||oTb:left()} , oTb)
    CASE MBRZMOVE(oTB,nMouseR,nMouseC,5,3,19,77)
        if "D"$aDirectory[nElement,5]
          keyboard chr( K_ENTER)
        endif
    ENDCASE
  endcase
end
unbox(cBox)
return cFullPath



static function priordir(cCurrent)
cCurrent := left(cCurrent,len(cCurrent)-1)
return left(cCurrent,rat("\",cCurrent))

//===============================================================
static function fd_goto(nNew,nCurrent,oStruc)
local nIter
local nDiff := ABS(nNew-nCurrent)
if nNew > nCurrent
  for nIter := 1 to nDiff
    oStruc:down()
    while !oStruc:stabilize()
    end
  next
else
  for nIter := 1 to nDiff
    oStruc:up()
    while !oStruc:stabilize()
    end
  next
endif
return nil

static function viewit(cFileName)
local cBox
IF ('.DBF' $ cFileName)
  *- check for arbitrary amount of available memory
  *- change this higher or lower, based on your own best guess <g>
  IF MEMORY(0) > 20
    IF SELECT( strip_path(cFilename,.t.) ) > 0  // check for already open
        msg("That file is in use , cannot re-open")
    ELSEIF SNET_USE(cFileName,"ADBF",.f.,5,.t.,"Unable to open file . Try again?")
        editdb(.f.,nil,nil,.t.,.t.)
        USE
    endif
  ELSE
    MSG("Insufficient memory to read the dbf file")
  ENDIF
ELSEIF ('.NTX' $ cFileName) .OR. ('.NDX' $ cFileName)
  msg("Index key for "+cFileName+" is :",nkey(cFileName))
ELSEIF !(('.EXE' $ cFileName) .OR. ('.COM' $ cFileName).OR.('.SYS' $ cFileName)  )
  Fileread(2,2,23,78,cFileName)
ENDIF
RETURN nil


static func dsort(aDir)
local nNow := 0
local nLen := len(adir)
local aReturn := array( nLen )
local i
local aSave
for i = 1 to nLen
  if aDir[i,1]==".."
    aSave := aDir[i]
  elseif aDir[i,5]=="D"
    nNow++
    AINS(aReturn,1)
    aReturn[1] := aDir[i]
  else
    nNow++
    aReturn[nNow] := aDir[i]
  endif
next
if aSave#nil
  AINS(aReturn,1)
  aReturn[1] := aSave
endif
return aReturn

