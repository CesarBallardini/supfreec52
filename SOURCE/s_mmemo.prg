/*
ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ This is not an exported function. It is called by other SuperLib
ณ functions, and has been tested within that context. Do not call
ณ this function directly.
ณ 
ณ 
ณ FUNCTION MMEMOEDIT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  MMEMOEDIT() Mouse aware memoedit
ณ
ณ  Returns:
ณ  --------
ณ  <cReturn> => modified string
ณ
ณ  Syntax:
ณ  -------
ณ  MMEMOEDIT(cString,nTop,nLeft,nBottom,nRight,;
ณ            [lAllowChange],[bUDF],[nLineLen],[nTabSize],[nBuffRow],;
ณ            [nBuffCol], [nWindRow], [nWindCol],[nMRow], [nMCol])
ณ
ณ  Description:
ณ  ------------
ณ  Same as MEMOEDIT(), except:
ณ  [bUdf]
ณ          a block is passed instead of a function name in a string
ณ          [bUdf] is eval'd as :  EVAL(bUDF,nMode,nLine,nColumn)
ณ
ณ  [nMRow,nMCol]
ณ          these are row and column to place the mouse direction
ณ          hot spot string: "[] [] [] []". If passed, the
ณ          mouse responds to clicking and/or holding down one
ณ          of the direction arrows.
ณ          Screen underneath is not saved/restored
ณ
ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/


/*   INTERNAL USE ONLY - NOT AN EXPORTED FUNCTION
     This is a mouseized memoedit. Change one byte and you could
     ruin the whole thing.
*/


#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

#include "memoedit.ch"
#DEFINE MEMOARRAYSIZE    20
#define MEMOTOP          1
#define MEMOLEFT         2
#define MEMOBOTTOM       3
#define MEMORIGHT        4
#define MEMOAUP          5
#define MEMOADOWN        6
#define MEMOALEFT        7
#define MEMOARIGHT       8
#define MEMOBUFFERROW    9
#define MEMOBUFFERCOL   10
#define MEMOWINDOWROW   11
#define MEMOWINDOWCOL   12
#define MEMOLINELEN     14
#define MEMOTABSIZE     15
#define MEMOARROWROW    16
#define MEMOARROWCOL    17
#define MEMOUDFBLOCK    18

static aMemo
static aMemos:={}
static nMemos:=0


*===========================================================
function MMEMOEDIT(cString,nTop,nLeft,nBottom,nRight,;
               lAllowChange,bUDF,nLineLen,nTabSize,nBuffRow,;
               nBuffCol, nWindRow, nWindCol,nMRow, nMCol)

aMemo := ARRAY(MEMOARRAYSIZE)
aMemo[MEMOARROWROW   ] := nMRow
aMemo[MEMOARROWCOL   ] := nMCol
aMemo[MEMOTOP        ] := nTop
aMemo[MEMOLEFT       ] := nLeft
aMemo[MEMOBOTTOM     ] := nBottom
aMemo[MEMORIGHT      ] := nRight
if nMRow#nil .and. nMCol#nil
  devpos(nMRow,nMCol)
  devout("[] [] [] []")
  aMemo[MEMOAUP        ] := {nmRow,nmCol,nMrow,nMcol+2}
  aMemo[MEMOADOWN      ] := {nmRow,nmCol+4,nMrow,nMcol+6}
  aMemo[MEMOALEFT      ] := {nmRow,nmCol+8,nMrow,nMcol+10}
  aMemo[MEMOARIGHT     ] := {nmRow,nmCol+12,nMrow,nMcol+14}
endif
aMemo[MEMOBUFFERROW  ] := iif(nBuffRow#nil,nBuffRow,1)
aMemo[MEMOBUFFERCOL  ] := iif(nBuffCol#nil,nBuffCol,0)
aMemo[MEMOWINDOWROW  ] := iif(nWindrow#nil,nWindRow,1)
aMemo[MEMOWINDOWCOL  ] := iif(nWindCol#nil,nWindCol,0)
aMemo[MEMOLINELEN    ] := iif(nLineLen#nil,nLineLen,79)
aMemo[MEMOUDFBLOCK   ] := bUDF
aMemo[MEMOTABSIZE    ] := nTabSize

nMemos = nMemos+1
aadd(aMemos,aMemo)

lAllowChange := iif(lAllowChange#nil,lAllowChange,.t.)

cString := MEMOEDIT(cString,aMemo[MEMOTOP],aMemo[MEMOLEFT],;
                            aMemo[MEMOBOTTOM],aMemo[MEMORIGHT],lAllowChange,;
                            "__M34_GP",aMemo[MEMOLINELEN],aMemo[MEMOTABSIZE],;
                            aMemo[MEMOBUFFERROW],aMemo[MEMOBUFFERCOL],;
                            aMemo[MEMOWINDOWROW],aMemo[MEMOWINDOWCOL])
CLEAR TYPEAHEAD
nMemos = nMemos-1
asize(aMemos,nMemos)
if nMemos > 0
     aMemo = ATAIL(aMemos)
endif
return cString



FUNCTION __M34_GP(nMode, nLine,nColumn)
static lMouseDirect := .f.
static nMouseR, nMouseC, nKey2Handle

local  cStuff  := ""
local  lDone   := .f.
local  nReturn := ME_DEFAULT
local  bUdf    := aMemo[MEMOUDFBLOCK]

aMemo[MEMOBUFFERROW]   :=  nLine
aMemo[MEMOBUFFERCOL]   :=  nColumn
aMemo[MEMOWINDOWROW]   :=  row()-aMemo[MEMOTOP]
aMemo[MEMOWINDOWCOL]   :=  col()-aMemo[MEMOLEFT]

DO CASE
CASE nMode==ME_INIT
  if bUDF#nil
    EVAL(bUDF,nMode, nLine,nColumn)
  endif
CASE nMode==ME_IDLE
     nKey2Handle := 0
     nMouseR     := 0
     nMouseC     := 0
     if bUDF#nil
       EVAL(bUDF,nMode, nLine,nColumn,nKey2Handle, nMouseR, nMouseC,aMemo)
     endif
     while !lDone
        if lMouseDirect .and. rat_elbhd(.1)
           KEYBOARD CHR(lastkey())
           lMouseDirect := .f.
        else
           nKey2Handle := rat_event(0,.f.,.t.)
           nMouseR := rat_eqmrow()
           nMouseC := rat_eqmcol()
        endif
        if bUDF#nil
          EVAL(bUDF,nMode, nLine,nColumn,nKey2Handle, nMouseR, nMouseC,aMemo)
        endif

        if nKey2Handle#K_MOUSELEFT .and. nextkey()==0
        elseif nKey2Handle==K_MOUSELEFT
             DO CASE
             CASE nMouseR >= aMemo[MEMOTOP] .and. nMouseR <= aMemo[MEMOBOTTOM] .and. ;
               nMouseC >= aMemo[MEMOLEFT] .and. nMouseC <= aMemo[MEMORIGHT]
               if nMouseR > row()
                 cStuff+= repl(chr(K_DOWN),nMouseR-row() )
                 lDone := .t.
               elseif nMouseR < row()
                 cStuff+= repl(chr(K_UP),row()-nMouseR )
                 lDone := .t.
               endif
               if nMouseC > col()
                 cStuff+= repl(chr(K_RIGHT),nMouseC-col() )
                 lDone := .t.
               elseif nMouseC < col()
                 cStuff+= repl(chr(K_LEFT),col()-nMouseC )
                 lDone := .t.
               endif
               if !empty(cStuff)
                 KEYBOARD cStuff
               endif
             CASE aMemo[MEMOAUP]#nil .and. nMouseR >= aMemo[MEMOAUP][1] .and. ;
                                nMouseR <= aMemo[MEMOAUP][3] .and. ;
                                nMouseC >= aMemo[MEMOAUP][2] .and. ;
                                nMouseC <= aMemo[MEMOAUP][4]
                 keyboard chr(K_UP)
                 lDone := .t.
                 lMouseDirect := .t.
             CASE aMemo[MEMOADOWN]#nil .and. nMouseR >= aMemo[MEMOADOWN][1] .and. ;
                                nMouseR <= aMemo[MEMOADOWN][3] .and. ;
                                nMouseC >= aMemo[MEMOADOWN][2] .and. ;
                                nMouseC <= aMemo[MEMOADOWN][4]
                 keyboard chr(K_DOWN)
                 lDone := .t.
                 lMouseDirect := .t.
             CASE aMemo[MEMOALEFT]#nil .and. nMouseR >= aMemo[MEMOALEFT][1] .and. ;
                                nMouseR <= aMemo[MEMOALEFT][3] .and. ;
                                nMouseC >= aMemo[MEMOALEFT][2] .and. ;
                                nMouseC <= aMemo[MEMOALEFT][4]
                 keyboard chr(K_LEFT)
                 lDone := .t.
                 lMouseDirect := .t.
             CASE aMemo[MEMOARIGHT]#nil .and. nMouseR >= aMemo[MEMOARIGHT][1] .and. ;
                                nMouseR <= aMemo[MEMOARIGHT][3] .and. ;
                                nMouseC >= aMemo[MEMOARIGHT][2] .and. ;
                                nMouseC <= aMemo[MEMOARIGHT][4]
                 keyboard chr(K_RIGHT)
                 lDone := .t.
                 lMouseDirect := .t.
             ENDCASE
        elseif nKey2Handle==K_MOUSERIGHT .OR. nKey2Handle==K_ESC
             lDone := .t.
        elseIF nKey2Handle<>0
           lDone := .t.
        endif
     end
CASE nMode < ME_INIT   // key of some kind

     if aMemo[MEMOBUFFERCOL]==0 .or. aMemo[MEMOWINDOWCOL] == 0
        keyboard (CHR(K_RIGHT)+chr(K_LEFT))
     else
        keyboard (chr(K_LEFT )+CHR(K_RIGHT))
     endif
OTHERWISE
ENDCASE
RETURN nReturn



