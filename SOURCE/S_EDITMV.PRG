
static lImport,lExport,lChanged,lDone
static nBoxTop,nBoxLeft, nBoxRight, lDoEdit, nBoxBot


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
ณ FUNCTION EDITMEMOV()                          *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  EDITMEMOV() Performs a windowed memoedit() on a string
ณ
ณ  Returns:
ณ  --------
ณ  <cBuffer> => changed string
ณ
ณ  Syntax:
ณ  -------
ณ  EDITMEMO(cBuffer,[nTop,nLeft,nBottom,nRight],[lModify],;
ณ            [nLineLength],[cTitle])
ณ
ณ  Description:
ณ  ------------
ณ  Pops up a box allowing memo editing of a string.
ณ  Edits string <cBuffer>. Options for import and export as well.
ณ
ณ  Escape exits, F10 saves [cBuffer]. Uses coordinates
ณ  2,10,20,69 unless passed coordinates as
ณ  [nTop,nLeft,nBottom,nRight]
ณ
ณ  [lModify] - True = allow edit (default), False = view
ณ  only
ณ
ณ  [nLineLength] - line length - default is window
ณ  width-1
ณ
ณ  [cTitle]  Title (max 25 characters) Default is MEMO PAD (new to 3.5)
ณ
ณ  Examples:
ณ  ---------
ณ   cNew := editmemov("Good golly miss molly!")
ณ   cNew := editmemov(memoread("DOCS.DOC"),2,2,22,78)
ณ   cNew := editmemov(memoread("DOCS.DOC"),2,2,22,78,.f.)
ณ
ณ  Notes:
ณ  -------
ณ  If editing, must have a box width of at least 50.
ณ  Unlike EDITMEMO, this works on a memvar and returns a memvar.
ณ
ณ  Source:
ณ  -------
ณ  S_EDITM.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION editmemoV(cMemoBuff,nTop,nLeft,nBottom,nRight,lEdit,;
                   nLineWidth,cTitle)
local nCursor,nOption
local cMemoBox,nWidth,cFileName,nShadPos

*- edit or view
IF VALTYPE(lEdit)<>"L"
  lEdit := .T.
ENDIF
lDoEdit := lEdit
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
nBoxRight := nRight

if valtype(nLineWidth)<>"N"
  nLineWidth := (nRight-nLeft)-1
endif
nShadPos := sls_shadpos()
IF nTop=0 .or. nBottom = 24 .or. nLeft = 0 .or. nRight = 79
  nShadPos := 0
ENDIF
*- draw the box
cMemoBox := makebox(nTop,nLeft,nBottom,nRight,sls_popcol(),nShadPos)
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
      *cMemoBuff := Memoedit(cMemoBuff,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit,"sfme_udfv",nLineWidth)
      setcolor(sls_popcol() )
      cMemoBuff := mMemoedit(cMemoBuff,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit,;
           {|m,r,c,l,mr,mc,a|meemvudf(m,r,c,l,mr,mc,a)},nLineWidth,;
            nil,nil,nil,nil,nil,nBottom,nLeft+48)
      setcolor(sls_normcol() )
      IF lImport
        cFileName := SPACE(40)
        popread(.T.,"Text file to lImport: (wildcards OK, blank for all) ",@cFileName,"")
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
            nOption := menu_v("Options: (CHANGES ARE PERMANENT!)",;
                              "Replace existing contents",;
                              "Append to Existing contents","Cancel")
            DO CASE
            CASE nOption = 1
              if "\"$cFileName .or. ":"$cFileName
                cMemoBuff := MEMOREAD(cFileName)
              else
                cMemoBuff := MEMOREAD(getdfp()+cFileName)
              endif
            CASE nOption = 2
              if "\"$cFileName .or. ":"$cFileName
                cMemoBuff += chr(13)+chr(10)+MEMOREAD(cFileName)
              else
                cMemoBuff += chr(13)+chr(10)+MEMOREAD(getdfp()+cFileName)
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
            Memowrit(cFileName,cMemoBuff)
          else
            Memowrit(getdfp()+cFileName,cMemoBuff)
          endif
          ENDIF
        ELSE
          if "\"$cFileName .or. ":"$cFileName
            Memowrit(cFileName,cMemoBuff)
          else
            Memowrit(getdfp()+cFileName,cMemoBuff)
          endif
        ENDIF
      ENDIF
  ELSE
    *#10-29-1990 Removed 7th param (.f.) so memo will stay on screen
    *cMemoBuff := Memoedit(cMemoBuff,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit)
    cMemoBuff := mMemoedit(cMemoBuff,nTop+1,nLeft+1,nBottom-1,nRight-1,lEdit,;
         {|m,r,c,l,mr,mc,a|meemvudf(m,r,c,l,mr,mc,a)},nLineWidth,;
          nil,nil,nil,nil,nil,nBottom,nLeft+48)
  ENDIF
  lImport = .F.
  lExport = .F.
ENDDO
*- clean up
unbox(cMemoBox)
setcursor(nCursor)
lImport:=lExport:=lChanged:=lDone:=nBoxTop:=nBoxLeft:=nil
RETURN cMemoBuff


*=====================================================================
static FUNCTION meemvudf( nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)
local nReturnVal
local nRow := row(), nCol := col()

nReturnVal := 0

*- show row/column
@nBoxTop,nBoxRight-26 SAY "[Line: " + TRANS(nLine, "9999")+"]"
@ROW(),COL()+2  SAY "[Col: " + TRANS(nColumn, "9999")+"]"
nReturnVal = 0
IF nMode # ME_INIT

  if nNextKey== K_MOUSELEFT .and. nMouseR==nBoxBot
     do case
     case nMouseC >=nBoxLeft+23 .and. nMouseC<=nBoxLeft+33 .and. lDoEdit
       nNextKey := K_F5
     case nMouseC >=nBoxLeft+35 .and. nMouseC<=nBoxLeft+45 .and. lDoEdit
       nNextKey := K_F6
     case nMouseC >=nBoxLeft+12 .and. nMouseC<=nBoxLeft+21 .and. lDoEdit
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





