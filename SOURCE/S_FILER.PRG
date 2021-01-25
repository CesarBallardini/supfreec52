#include "inkey.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FILEREAD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FILEREAD() Lists a text file of unlimited size
ณ 
ณ  Returns:
ณ  --------
ณ  nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  FILEREAD([nTop,nLeft,nBottom,nRight],[cFileName],[cTitle],;
ณ            [lSearch],[lMark])
ณ
ณ  Description:
ณ  ------------
ณ  Lists text file [cFileName] of unlimited size in a
ณ  programmer definable window of dimensions [nTop..nRight]
ณ 
ณ  Allows up down right left scrolling. Use this for
ณ  reports or output sent to a disk file.
ณ 
ณ  If [cFileName]  is not passed, a box asks for the
ณ  filespec and then allows a picklist of files of that spec. If
ณ  [cFileName] is passed as a wildcard (i.e. "*.DOC"). a picklist
ณ  of files of that spec is presented.
ณ 
ณ  If [nTop..nRight] are not passed, a default window of
ณ  dimensions 2,2,22,78 is used.
ณ 
ณ  [cTitle] is an optional title. This overrides the
ณ  default which is the file name.
ณ 
ณ  [lSearch] is a switch to allow text searches. Default
ณ  is True
ณ
ณ  [lMark] is a switch to allow block marking (with Copy
ณ  to File or Print) Default is True.
ณ 
ณ  Examples:
ณ  ---------
ณ   REPORT FORM summary TO summary.txt
ณ   FILEREAD(2,2,22,78,"SUMMARY.TXT","Summary File")
ณ 
ณ  Notes:
ณ  -------
ณ  Fileread() will use SET DEFAULT if no path is
ณ  specified.
ณ 
ณ  Source:
ณ  -------
ณ  S_FILER.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION Fileread( nBoxTop,nBoxLeft,nBoxBot,nBoxRight,cFileName,cTitle,lSearch,lMark )

local nLastKey,nCursor, cLastKey
local cReadBox
local nTopLine,nBottLine,nLeftEdge,nRightEdge,nLineLen
local nLineOffset,nFileOffset
local nHandle,oTb
local cSeek := ""
local lMarking   := .f.
local nMarkStart := 0, nMarkEnd := 0
local lMarked    := .f.
local lMarkOrSeach
local nTbottom
local cInstruct1, cInstruct2, nInstruct1, nInstruct2
local nAtArrows, nAtPgup, nAtPgdn, nAtHome, nAtEnd, nAtEsc, nAtSearch, nAtMark
local nMouseR, nMouseC, nCursRow, nInCreaseLR
local aButtons, nButton := 0
local nBrow1, nBRow2

lSearch := iif(lSearch#nil,lSearch,.t.)
lMark := iif(lMark#nil,lMark,.t.)
lMarkOrSearch := (lSearch .or. lMark)

*- if FileName not passed, get one
IF cFileName==nil .or. "*"$cFilename
  if cFileName==nil
    cFileName := SPACE(40)
    popread(.t.,"File to list - leave empty or use *? for picklist",@cFileName,"")
  endif
  IF LASTKEY() = 27
    RETURN .F.
  ENDIF
  IF EMPTY(cFileName) .OR. AT('*',cFileName) > 0
    IF EMPTY(cFileName)
      cFileName := getdfp()+"*.*"
    ELSE
     if !("\"$cFileName .or. ":"$cFileName)
        cFileName := getdfp()+cFileName
     endif
    ENDIF
    if adir(cFileName) > 0
      cFileName := popex(cFileName)
    endif
  ENDIF
  IF LASTKEY() = 27
    RETURN .F.
  ENDIF
else
  if !("\"$cFileName .or. ":"$cFileName)
     cFileName := getdfp()+cFileName
  endif
ENDIF

*- assign box dimensions if need be
IF nBoxTop==nil
  nBoxTop   := 2
  nBoxLeft  := 2
  nBoxBot   := 22
  nBoxRight := 78
ENDIF

*- check for file's existence
IF empty(cFileName) .or. !FILE(cFileName)
  RETURN .F.
ENDIF
cTitle := iif(cTitle#nil,cTitle,cFileName)
*- open the file, check for errors
nHandle := FOPEN(cFileName,64)
IF Ferror() <> 0
  msg("Error opening file : "+cFileName)
  RETURN ''
ENDIF

*- set cursor off
nCursor  := setcursor(0)


*- draw screen
cReadBox :=makebox(nBoxTop,nBoxLeft,nBoxBot,nBoxRight,sls_popcol(),0,0)
nTbottom := iif(lMarkOrSearch,3,2)
@nBoxBot-nTbottom,nBoxLeft TO nBoxBot-nTBottom,nBoxRight
@nBoxBot-nTBottom,nBoxLeft SAY CHR(195)
@nBoxBot-nTBottom,nBoxRight SAY CHR(180)

@nBoxTop,nBoxLeft+2 SAY '['+cTitle+']'

cInstruct1 := padc("[][][][]  [PGUP]  [PGDN]  [HOME]  [END]   [ESC=Quit] ",;
             SBCOLS(nBoxLeft,nboxRight,.f.))
@nBoxBot-(nTBottom)+1,nBoxLeft+1 SAY cInstruct1
nInstruct1 := nBoxBot-(nTBottom)+1

if lMarkOrSearch
  cInstruct2 :=    PADC(iif(lSearch," [S=Search]  ","")+iif(lMark,"[M=Mark/Endmark]",""),;
        SBCOLS(nBoxLeft,nboxRight,.f.) )
else
  cInstruct2 := ""
endif

@nBoxbot-1,nBoxLeft+1 say cInstruct2
nInstruct2 := nBoxBot-1

*-
nBrow1 := nBoxBot-(nTBottom)+1
nBrow2 := nBoxBot-1

nAtArrows := nBoxLeft+AT("[",cInstruct1)
nAtPgup   := nBoxLeft+AT("[PGUP",cInstruct1)
nAtPgdn   := nBoxLeft+AT("[PGDN",cInstruct1)
nAtHome   := nBoxLeft+AT("[HOME",cInstruct1)
nAtEnd    := nBoxLeft+AT("[END",cInstruct1)
nAtEsc    := nBoxLeft+AT("[ESC",cInstruct1)
nAtSearch := nBoxLeft+AT("[S=",cInstruct2)
nAtMark   := nBoxLeft+AT("[M=",cInstruct2)

aButtons := {;
       {nBrow1,nAtArrows  ,nBrow1,nAtArrows+2,K_UP},;
       {nBrow1,nAtArrows+3,nBrow1,nAtArrows+5,K_DOWN},;
       {nBrow1,nAtArrows+6,nBrow1,nAtArrows+8,K_RIGHT},;
       {nBrow1,nAtArrows+9,nBrow1,nAtArrows+11,K_LEFT},;
       {nBrow1,nAtPgUp,nBrow1,nAtPgUp+5,K_PGUP},;
       {nBrow1,nAtPgDn,nBrow1,nAtPgDn+5,K_PGDN},;
       {nBrow1,nAtHome,nBrow1,nAtHome+5,K_HOME},;
       {nBrow1,nAtEnd ,nBrow1,nAtEnd+3 ,K_END },;
       {nBrow1,nAtEsc ,nBrow1,nAtEsc+9 ,K_ESC };
            }
if lMark
       aadd(aButtons,;
           {nBrow2,nAtMark ,nBrow2,nAtMark+15 ,ASC("M") })
endif
if lSearch
       aadd(aButtons,;
           {nBrow2,nAtSearch ,nBrow2,nAtSearch+9 ,ASC("S") })
endif


*- initialize dimensions for screen output of file
nTopLine   := nBoxTop+1
nBottLine  := nBoxBot-(nTBottom)-1
nLeftEdge  := nBoxLeft+1
nRightEdge := nBoxRight-1

*- get line length, number of lines in box, and starting line offset
nLineLen    := nBoxRight-nBoxLeft-1
nLineOffset := 1

oTb := tbrowsenew(ntopLine,nLeftEdge,nBottLine,nRightEdge)
oTb:addcolumn(tbcolumnnew("",{||padr(subst(sfreadline(nHandle),nLineOffset),nLineLen)} ))
oTb:skipblock     := {|n|fi_tskip(n,nHandle)}
oTb:gotopblock    := {||fi_ftop(nHandle)}
oTb:gobottomblock := {||fi_fbot(nHandle)}
oTb:getcolumn(1):colorblock := {||iif(Marked(nMarkStart,nMarkEnd,lMarking,nHandle),{2,2},{1,2})}

while .t.
  DISPBEGIN()
  if lMarking
     @nBoxBot-1,nBoxLeft+1 SAY "Marking..." color "*"+setcolor()
  else
     @nBoxBot-1,nBoxLeft+1 SAY space(10)
  endif
  while !oTb:stabilize()
  end
  nCursRow := row()
  DISPEND()
  nFileOffset := fseek(nHandle,0,1)
  if lMarking .and. nextkey()=0
     if nFileOffset#nMarkEnd
       nMarkEnd   := nFileOffset
       if nMarkEnd < nMarkStart
         lMarking := .f.
       endif
       oTb:refreshall()
       DISPBEGIN()
       while !oTb:stabilize()
       end
       DISPEND()
     endif
  endif
  nLastKey := RAT_EVENT(0,.f.)
  cLastKey := upper(chr(nLastKey))
  nMouseR := rat_eqmrow()
  nMouseC := rat_eqmcol()
  nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  if nButton > 0
    cLastKey := upper(chr(nButton))
  endif

  do case
  case nLastKey == K_UP .or. nButton == K_UP
    oTb:UP()
    if nButton==K_UP
      IFMOUSEHD({||oTb:UP() },oTb)
    endif
  case nLastKey == K_DOWN .or. nButton == K_DOWN
    oTb:down()
    if nButton==K_DOWN
      IFMOUSEHD({||oTb:down() },oTb)
    endif
  case nLastKey == K_PGUP .or. nButton == K_PGUP
    oTb:PAGEUP()
  case nLastKey == K_PGDN .or. nButton == K_PGDN
    oTb:PAGEdown()
  case nLastKey == K_HOME .or. nButton == K_HOME
    oTb:gotop()
  case nLastKey == K_END .or. nButton == K_END
    oTb:gobottom()
  case (nLastKey == K_LEFT .or. nButton == K_LEFT ).and. nLineOffset > 5
    nLineOffset-=5
    oTb:refreshall()
    if nButton==K_LEFT
      IFMOUSEHD({||iif(nLineOffset>5,nLineOffset-=5,nLineOffset:=1),oTb:refreshall() },oTb)
    endif
  case (nLastKey == K_LEFT .or. nButton == K_LEFT ).and. nLineOffset > 1
    nLineOffset:=1
    oTb:refreshall()
  case nLastKey == K_RIGHT .or. nButton == K_RIGHT
    nLineOffset+=5
    oTb:refreshall()
    if nButton==K_RIGHT
      IFMOUSEHD({||nLineOffset+=5,oTb:refreshall() },oTb)
    endif
  case nLastkey == K_ESC .or. nButton == K_ESC
    if lMarking
      lMarking := .f.
      oTb:refreshall()
      DISPBEGIN()
      while !oTb:stabilize()
      end
      DISPEND()
    else
      exit
    endif
  case cLastKey=="M" .AND. lMark
   if !lMarking
     lMarking := .t.
     nMarkStart := nFileOffset
     nMarkEnd   := nFileOffset
   else
     lMarking := .f.
     docopy(nMarkStart,nMarkEnd,cFileName,nHandle)
     fseek(nHandle,0,nFileOffset)
     nMarkStart := 0
     nMarkEnd   := 0
     oTb:refreshall()
   endif

  case cLastKey=="S" .and. lSearch
    cSeek := padr(cSeek,30)
    popread(.t.,"Search for text:",@cSeek,"@K")
    if !empty(cSeek)
      cSeek := trim(cSeek)
      if frseek(nHandle,cSeek)
        oTb:refreshall()
      else
        msg("Not found")
        fseek(nHandle,nFileOffset,0)
      endif
    endif
  case MBRZMOVE(oTB, nMouseR, nMousec,ntopLine,nLeftEdge,nBottLine,nRightEdge)
  endcase
end
*- set cursor on
fclose(nHandle)
setcursor(nCursor)
unbox(cReadBox)
RETURN ''

*=======================================================
static FUNCTION fi_fbot(nHandle)
FSEEK(nHandle,0,2)
RETURN ''

*=======================================================
static FUNCTION fi_ftop(nHandle)
FSEEK(nHandle,0)
RETURN ''

//--------------------------------------------------------------
static function fi_tskip(n,nHandle)
local nMoved   := 0
if n > 0
  while nMoved < n
    if fmove2next(nHandle)
      nMoved++
    else
      exit
    endif
  end
elseif n < 0
  while nMoved > n
    if fmove2prev(nHandle)
      nMoved--
    else
      exit
    endif
  end
endif
return nMoved

//-------------------------------------------------------------
static function frseek(nHandle,cSeek)
local lFound := .f.
local cuSeek := upper(cSeek)
while fmove2next(nHandle)
  if cuSeek$upper(sfreadline(nHandle))
   lFound := .t.
   exit
  endif
end
return lFound

//-------------------------------------------------------------
static function Marked(nMarkStart,nMarkEnd,lMarking,nHandle)
local lMarked := .f.
local nOffset
if lMarking
  nOffset := fseek(nHandle,0,1)
  if nOffset >= nMarkStart .and. nOffset <= nMarkEnd
     lMarked := .t.
  endif
endif
return lMarked

//-------------------------------------------------------------
static function docopy(nMarkStart,nMarkEnd,cInFile,nHandle)
local nDevice
local cFileName := space(30)
local cPrinter
local cMessage  := ""
local nAppend
fseek(nHandle,nMarkEnd,0)
if fmove2next(nHandle)
        nMarkEnd := fseek(nHandle,0,1)
endif
if nMarkStart <= nMarkEnd
  while .t.
    cFileName := space(30)
    nDevice := menu_v("Copy Marked to","Printer","File","Cancel")
    do case
    case nDevice == 1 // printer
      cPrinter  := PRNPORT()
      toprint(cPrinter,nMarkStart,nMarkEnd,nHandle)
    case nDevice == 2 // file
      popread(.t.,"File Name",@cFileName,"@K")
      cFileName := upper(trim(cFileName))
      cInfile   := upper(cInFile)
      if !ISVALFILE(cFileName,.f.,@cMessage)
           msg("Invalid file name",cMessage)
      elseif cFileName==cInFile
           msg("Can't write to this file")
      elseif file(cFileName)
           nAppend := menu_v("File Exists","OverWrite","Append","Cancel")
           do case
           case nAppend==1
             tofile(cFileName,.f.,nMarkStart,nMarkEnd,nHandle)
           case nAppend==2
             tofile(cFileName,.t.,nMarkStart,nMarkEnd,nHandle)
           endcase
      else
           tofile(cFileName,.f.,nMarkStart,nMarkEnd,nHandle)
      endif
    otherwise
      exit
    endcase
  end
endif
return nil

//-------------------------------------------------------------
static function toprint(cPrinter,nMarkStart,nMarkEnd,nHandle)
local nLpp   := 60
local nLines := 0
popread(.t.,"Lines per page:",@nLpp,"99")
SET PRINTER TO (cPrinter)
fseek(nHandle,nMarkStart,0)
SET PRINTER ON
while fseek(nHandle,0,1) < nMarkEnd
   SET CONSOLE OFF
   if p_ready(cPrinter)
     ?sfreadline(nHandle)
     nLines++
   else
     exit
   endif
   if nLines >= nLpp
     EJECT
     nLines := 0
   endif
   fmove2next(nHandle)
   SET CONSOLE ON
end
EJECT
set printer to
SET PRINTER OFF
SET CONSOLE ON
MSG("Marked lines written")
RETURN NIL

//-------------------------------------------------------------
static function tofile(cFileName,lAppend,nMarkStart,nMarkEnd,nHandle)
if lAppend
  SET PRINTER TO  (cFileName) ADDITIVE
else
  SET PRINTER TO (cFileName)
ENDIF
fseek(nHandle,nMarkStart,0)

SET PRINTER ON
while fseek(nHandle,0,1) < nMarkEnd
   SET CONSOLE OFF
   ?sfreadline(nHandle)
   fmove2next(nHandle)
   SET CONSOLE ON
end
set printer to
SET PRINTER OFF
MSG("Marked lines written")
RETURN NIL







