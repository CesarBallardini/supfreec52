
static lImport,lExport,lChanged,lDone
static nBoxTop,nBoxLeft, lDoEdit, nBoxBot

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#include "memoedit.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION EDITMEMO()                           *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ 
ณ  Short:
ณ  ------
ณ  EDITMEMO() Performs a windowed memoedit() on a memo field
ณ 
ณ  Returns:
ณ  --------
ณ  <lChanged> -> Was the memo field changed
ณ 
ณ  Syntax:
ณ  -------
ณ  EDITMEMO([cMemoName],[nTop,nLeft,nBottom,nRight],;
ณ        [lModify],[nLineLength],[cTitle])
ณ
ณ  Description:
ณ  ------------
ณ  Pops up a box allowing editing of a memo field.
ณ  Escape exits, F10 saves.
ณ
ณ  Options for import and export as well.
ณ
ณ  Edits field named MEMO by default, otherwise edits
ณ  fieldname passed as [cMemoName]. Uses coordinates 2,10,20,69
ณ  unless passed coordinates as [nTop, nLeft, nBottom, nRight]
ณ
ณ  [lModify] - True = allow edit (default), False = view only
ณ
ณ  [nLineLength] - line length - default is window width-1
ณ
ณ  [cTitle]  Title (max 25 characters) Default is MEMO PAD (new to 3.5)
ณ
ณ  Examples:
ณ  ---------
ณ   editmemo()
ณ   editmemo("NOTES")
ณ   editmemo("NOTES",2,2,22,78)
ณ   editmemo("NOTES",2,2,22,78,.f.)
ณ 
ณ  Notes:
ณ  -------
ณ  If editing, must have a box width of at least 50
ณ  Requires a memo FIELD - will not work on a memvar.
ณ 
ณ  See EDITMEMOV() to edit memvars.
ณ 
ณ  Source:
ณ  -------
ณ  S_EDITM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION editmemo(cMemoName,nTop,nLeft,nBottom,nRight,lEdit,nLineWidth,;
                  cTitle)
local nCursor,nOption,lDidChange
local cMemoBox,nWidth,cHoldit,cFileName,nShadPos

*- default memo field name = MEMO
IF Pcount() < 1
  cMemoName := "MEMO"
ENDIF

*- edit or view
IF VALTYPE(lEdit)<>"L"
  lEdit := .T.
ENDIF
lDoEdit := lEdit
*- if we don't see that field, or there's no DBF, get outa here
IF TYPE(cMemoName) <> "M"  .OR. (!USED())
  RETURN ''
ENDIF

nCursor := setcursor(1)

*- if we didn't get box coordinates, assign some
IF nTop==nil .or. nLeft==nil.or. nRight==nil .or. nBottom==nil
  nTop    := 2
  nLeft   := 1
  nBottom := 20
  nRight  := 78
ELSEIF nRight-nLeft < 63
  nLeft   := 1
  nRight  := 78
ENDIF
nBoxTop  := nTop
nBoxLeft := nLeft
nBoxBot := nBottom

if valtype(nLineWidth)<>"N"
  nLineWidth := (nRight-nLeft)-1
endif
nShadPos := sls_shadpos()
IF nTop=0 .or. nBottom = 24 .or. nLeft = 0 .or. nRight = 79
        nShadPos = 0
ENDIF
*- draw the box
cMemoBox :=makebox(nTop,nLeft,nBottom,nRight,sls_popcol(),nShadPos)
cTitle := iif(cTitle#nil,alltrim(left(cTitle,25)),"MEMO PAD")
@nTop,nLeft+1 SAY "["+cTitle+"]"
IF lDoEdit
  @nBottom,nLeft+1 SAY "[ESC=EXIT] [F10=SAVE] [F5=Import] [F6:Export]  "
ELSE
  @nBottom,nLeft+1 SAY "[ESC=EXIT]"
ENDIF


*- do the MEMOEDIT
lChanged := .f.
lDone    := .F.
lImport  := .F.
lExport  := .F.
DO WHILE !lDone
  lDone  := .T.
  IF lEdit
    if SREC_LOCK(5,.T.,"Network error - Unable to lock record. Keep trying?")
      setcolor(sls_popcol() )
      cHoldit := mMemoedit(&cMemoName,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit,;
           {|m,r,c,l,mr,mc,a|meemudf(m,r,c,l,mr,mc,a)},nLineWidth,;
            nil,nil,nil,nil,nil,nBottom,nLeft+48)
      setcolor(sls_normcol() )
      IF !LASTKEY()==27
        REPLACE &cMemoName WITH cHoldit
      ENDIF
      IF lImport
        cFileName := SPACE(40)
        popread(.T.,"Text file to Import: (wildcards OK, blank for all) ",@cFileName,"")
        cFileName := Alltrim(UPPER(cFileName))
        IF !LASTKEY() == 27
         IF EMPTY(cFileName) .OR. AT('*',cFileName) > 0
           IF EMPTY(cFileName)
             cFileName = "*.*"
           ENDIF
           cFileName := popex(cFileName)
         ENDIF
        ENDIF
        IF EMPTY(cFileName)
        ELSEIF FILE(cFileName)
          IF fileinfo(cFileName,1) > (MEMORY(0)*1000)
            msg("File too big for existing memory")
          ELSE
            nOption = menu_v("Options: (CHANGES ARE PERMANENT!)",;
                              "Replace existing contents",;
                              "Append to Existing contents","Cancel")
            DO CASE
            CASE nOption = 1
              if "\"$cFileName .or. ":"$cFileName
                REPLACE &cMemoName WITH MEMOREAD(cFileName)
              else
                REPLACE &cMemoName WITH MEMOREAD(getdfp()+cFileName)
              endif
            CASE nOption = 2
              if "\"$cFileName .or. ":"$cFileName
                REPLACE &cMemoName WITH &cMemoName+CHR(13)+CHR(10)+MEMOREAD(cFileName)
              else
                REPLACE &cMemoName WITH &cMemoName+CHR(13)+CHR(10)+MEMOREAD(getdfp()+cFileName)
              endif
            ENDCASE
          ENDIF
        ELSE
          msg("File not found")
        ENDIF
      ELSEIF lExport
        cFileName := SPACE(40)
        popread(.T.,"Text file to lExport to :",@cFileName,"")
        cFileName := Alltrim(UPPER(cFileName))
        IF FILE(cFileName)
          IF messyn("File exists - Overwrite?")
          if "\"$cFileName .or. ":"$cFileName
            Memowrit(cFileName,cHoldit)
          else
            Memowrit(getdfp()+cFileName,cHoldit)
          endif
          ENDIF
        ELSE
          if "\"$cFileName .or. ":"$cFileName
            Memowrit(cFileName,cHoldit)
          else
            Memowrit(getdfp()+cFileName,cHoldit)
          endif
        ENDIF
      ENDIF
    ENDIF
  ELSE
      cHoldit := mMemoedit(&cMemoName,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit,;
           {|m,r,c,l,mr,mc,a|meemudf(m,r,c,l,mr,mc,a)},nLineWidth,;
            nil,nil,nil,nil,nil,nBottom,nLeft+48)
    *#10-29-1990 Removed 7th param (.f.) so memo will stay on screen
    *cHoldit = Memoedit(&cMemoName,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit)
  ENDIF
  lImport = .F.
  lExport = .F.
ENDDO
*- clean up
unbox(cMemoBox)
setcursor(nCursor)
lDidChange := lChanged
lImport:=lExport:=lChanged:=lDone:=nBoxTop:=nBoxLeft:=nil
RETURN lDidChange


*=====================================================================
static FUNCTION meemudf( nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)
local nReturnVal
local nRow := row(), nCol := col()

nReturnVal := 0

*- show row/column
@nBoxTop,nBoxLeft+15 SAY "[Line: " + TRANS(nLine, "9999")+"]"
@ROW(),COL()+2 SAY "[Col: " + TRANS(nColumn, "9999")+"]"
nReturnVal = 0
IF nMode # ME_INIT

  if nNextKey== K_MOUSELEFT .and. nMouseR==nBoxBot
     do case
     case nMouseC >=nBoxLeft+23 .and. nMouseC<=nBoxLeft+33 .and. lDoEdit
       nNextKey := K_F5
     case nMouseC >=nBoxLeft+35 .and. nMouseC<=nBoxLeft+45 .and. lDoEdit
       nNextKey := K_F6
     case nMouseC >=nBoxLeft+12 .and. nMouseC<=nBoxLeft+21
       nNextKey := K_F10
     case nMouseC >=nBoxLeft+1  .and. nMouseC<=nBoxLeft+10
       KEYBOARD CHR(K_ESC)
     endcase
  endif

  DO CASE
  CASE nNextKey ==K_F5 .and. lDoEdit
    inkey()
    lImport = .T.
    lDone = .F.
    KEYBOARD CHR(23)
  CASE nNextKey ==K_F6 .and. lDoEdit
    inkey()
    lExport = .T.
    lDone = .F.
    KEYBOARD CHR(23)
  CASE nNextKey == K_ESC
    inkey()
    if lChanged .and. lDoEdit
      if messyn("Exit without saving changes?")
         KEYBOARD CHR(K_ESC)
         lChanged := .f.
      endif
    else
         KEYBOARD CHR(K_ESC)
    endif
  CASE nNextKey == K_F10
    inkey()
    if lDoEdit
      if messyn("Save and exit?","Save/Exit","Don't Exit")
       KEYBOARD CHR(23)
      endif
    endif
  CASE nNextKey > 0 .and. nNextKey< 256 .and. lDoEdit
    lChanged := .t.
  ENDCASE
ENDIF
devpos(nRow,nCol)
RETURN nReturnVal




