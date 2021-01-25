
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
static aPrompts,nThisRow,aWidths

/*
proc test
local nREturn
nReturn :=pstabmenu(10,10,14,70,{"A","B","C","One","two","three","four",;
                        "five","six","seven","eight",;
                        "nine","ten","eleven","twelve",;
                        "thirteen","fourteen","fifteen","sixteen",;
                        "seventeen","eighteen","nineteen","twenty";
                        },"Select:",5)

nReturn := stabmenu(10,10,14,70,{"A","B","C","One","two","three","four",;
                        "five","six","seven","eight",;
                        "nine","ten","eleven","twelve",;
                        "thirteen","fourteen","fifteen","sixteen",;
                        "seventeen","eighteen","nineteen","twenty";
                        },nReturn)

*/

/*
�����������������������������������������������������������������
� FUNCTION PSTABMENU()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PSTABMENU() Popup tabular (grid style) )menu
� 
�  Returns:
�  --------
�  <nSelection> => Number of menu option selected
� 
�  Syntax:
�  -------
�  PSTABMENU(nTop,nLeft,nBottom,nRight,aPrompts,[cTitle],[nStart])
� 
�  Description:
�  ------------
�  Pops up a tabular (grid) menu based on an array of
�  prompts passed
� 
�  as <aPrompts>. Dimensions of the menu table will be
�  inside of the <nTop,nLeft,nBottom,nRight> dimensions for the popup
�  box. Number of menu rows is the number of rows inside the box.
�  Number of menu columns is determined based on number of rows.
�  Prompts are layed out in a snaking fashion :
� 
�     e.g. (for a 3 row table...)
�       column 1, row 1  = 1st prompt
�       column 1, row 2  = 2nd prompt
�       column 1, row 3  = 3rd prompt
�       column 2, row 1  = 4th prompt
� 
�  Pressing a character will move to the next matching
�  prompt with that first letter. Left-right and up-down perform a
�  snaking pattern
� 
�  Pressing ENTER causes selection to be made, and the
�  number of the selection to be returned.
� 
�  Pressing ESCAPE returns 0.
� 
�  [cTitle]  is a itle for the popup box
� 
�  [nStart]  is an optional starting option. Default is 1.
� 
�  Examples:
�  ---------
�   nChoice := pstabmenu(10,10,14,70,{"One","two","three","four",;
�                        "five","six","seven","eight",;
�                         "nine","ten","eleven","twelve"},"Select:")
� 
�  Source:
�  -------
�  S_TABMEN.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION PSTABMENU(nTop,nLeft,nBottom,nRight,aInPrompts,cTitle,nStart)
local cbox    := makebox(nTop,nLeft,nBottom,nRight,sls_popcol())
local nReturn
if cTitle#nil
  @nTop,nLeft+1 say "["+ctitle+"]"
endif
nReturn := STABMENU(nTop+1,nLeft+1,nBottom-1,nRight-1,aInPrompts,nStart)
UNBOX(cBox)
return nReturn


/*
�����������������������������������������������������������������
� FUNCTION STABMENU()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  STABMENU() Tabular (grid style) menu
� 
�  Returns:
�  --------
�  <nSelection> => Number of menu option selected
� 
�  Syntax:
�  -------
�  STABMENU(nTop,nLeft,nBottom,nRight,aPrompts,[nStart])
� 
�  Description:
�  ------------
�  Does a tabular (grid) menu based on an array of
�  prompts passed as <aPrompts>. Dimensions of the menu table will be
�  <nTop,nLeft,nBottom,nRight>. Number of menu rows is
�  the number of rows Number of menu columns is determined based on
�  number of rows. Prompts are layed out in a snaking fashion :
� 
�     e.g. (for a 3 row table...)
� 
�       column 1, row 1  = 1st prompt
�       column 1, row 2  = 2nd prompt
�       column 1, row 3  = 3rd prompt
�       column 2, row 1  = 4th prompt
� 
�  Pressing a character will move to the next matching
�  prompt with that first letter. Left-right and up-down perform a
�  snaking pattern
� 
�  Pressing ENTER causes selection to be made, and the
�  number of the selection to be returned.
� 
�  Pressing ESCAPE returns 0.
� 
�  [nStart] Optional starting options. Default is 1.
� 
�  Examples:
�  ---------
�   nChoice := ;
�          stabmenu(10,10,14,70,{"One","two","three","four",;
�                        "five","six","seven","eight",;
�                        "nine","ten","eleven","twelve"}, 5)
� 
�  Notes:
�  -------
�  This is a non-popup version of PSTABMENU(), and will
�  remain on the screen when done.
� 
�  Source:
�  -------
�  S_TABMEN.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION STABMENU(nTop,nLeft,nBottom,nRight,aInPrompts,nStart)
LOCAL nRows := nBottom-nTop+1
LOCAL nCols := INT(len(aInPrompts)/nRows)+iif(len(aInPrompts)%nRows#0,1,0)
LOCAL oTb   := tbrowsenew(nTop,nLeft,nBottom,nRight)
LOCAL nRowCount,nColCount,nAllCount
LOCAL nOptions := len(aInPrompts)
LOCAL nFirstLetter,nAtPos
local nLastKey,cLastKey, nMouseR, nMouseC
local nReturnval  := 0
local nLastRowpos := iif(len(aInPrompts)%nRows==0,nRows,len(aInPrompts)%nRows)
local nOldCursor := setcursor(0)
aWidths  := array(nCols)
nThisRow := 1
nStart   := iif(nStart==nil,1,iif(nStart>0.and.nStart<=nOptions,nStart,1))
aPrompts := ARRAY(nCols)
nAllcount := 1
for nColCount = 1 to nCols
 aPrompts[nColCount] := array(nRows)
 aWidths[nColCount]  := 2
 for nRowCount = 1 to nRows
    if nAllcount <= nOptions
     aPrompts[nColCount,nRowCount] := aInPrompts[nAllCount]
     aWidths[nColCount] := max(aWidths[nColCount],len(alltrim(trans(aPrompts[nColCount,nRowCount],""))))
    else
     aPrompts[nColCount,nRowCount] := ""
    endif
    nAllCount++
 next
next
for nColCount = 1 to nCols
  oTb:addcolumn(tbColumnNew(nil,tmblock(nColCount)))
next
oTB:SKIPBLOCK := {|n|AASKIP(n,@nThisRow,nRows)}
oTb:colpos  := int(nStart/nRows)+iif(nStart%nRows=0,0,1)
oTb:rowpos := iif(nStart%nRows==0,nRows,nStart%nRows)
oTb:refreshall()

do while .t.
  while !oTb:stabilize()
  end
  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
  do case
  case nLastKey == K_ENTER      // abort
    nReturnval := ((oTb:colpos-1)*nRows+nThisRow)
    exit
  case nLastKey == K_ESC .OR. nLastKey==K_MOUSERIGHT     // abort or right mouse
    exit
  case nLastKey == K_LEFT     // allow movement (left)
    if oTb:colpos > 1
      oTb:left()
    elseif nThisRow > 1
      if ((nCols-1)*nRows+(nThisRow-1)) <= nOptions
         oTb:colpos := nCols
         oTb:up()
         oTb:refreshall()
      else
         oTb:colpos := nCols-1
         oTb:up()
         oTb:refreshall()
      endif
    else
      if ((nCols-1)*nRows+(nRows)) <= nOptions
         oTb:colpos := nCols
         oTb:rowpos := nLastRowPos
         oTb:refreshall()
      else
         oTb:colpos := nCols-1
         oTb:rowpos := nRows
         oTb:refreshall()
      endif
    endif
  case nLastKey == K_RIGHT    // allow movement (right)
    if (oTb:colpos*nRows+nThisRow) <= nOptions
      oTb:right()
    elseif nThisRow < nRows
      oTb:colpos := 1
      oTb:down()
      oTb:refreshall()
    else
      oTb:colpos := 1
      nThisrow := 1
      oTb:rowpos := nThisRow
      oTb:refreshall()
    endif
  CASE nLastKey = K_UP          && UP ONE ROW
    if nThisRow > 1
      oTb:UP()
    elseif oTb:Colpos > 1
      oTb:colpos := oTb:colpos-1
      oTb:rowpos := nRows
      oTb:refreshall()
    else
      oTb:colpos := nCols
      oTb:rowpos := nLastRowPos
      oTb:refreshall()
    endif
  CASE nLastKey = K_DOWN        && DOWN ONE ROW
    if ((oTb:colpos-1)*nRows+nThisRow+1) <= nOptions
      if nThisrow < nRows
        oTb:down()
      elseif oTb:colpos < nCols
        oTb:colpos := oTb:colpos+1
        oTb:rowpos := 1
        oTb:refreshall()
      endif
    else
      oTb:colpos := 1
      oTb:rowpos := 1
      oTb:refreshall()
    endif
  CASE (cLastkey := upper(chr(nLastkey)))$"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
     nAtPos := ((oTb:colpos-1)*nRows+nThisRow)
     if (nFirstLetter := ascan(aInPrompts,{|e|e#nil.and.upper(left(e,1))==cLastKey },nAtPos+1)) > 0 ;
        .or. (nFirstLetter := ascan(aInPrompts,{|e|e#nil.and.upper(left(e,1))==cLastKey },1,nAtPos)) > 0
       oTb:colpos  := int(nFirstLetter/nRows)+iif(nFirstLetter%nRows=0,0,1)
       oTb:rowpos := iif(nFirstLetter%nRows==0,nRows,nFirstLetter%nRows)
       oTb:refreshall()
     endif
  case MBRZMOVE(oTb,nMouseR,nMouseC)
  case MBRZCLICK(oTb,nMouseR,nMouseC)
     keyboard chr(K_ENTER)
  endcase
ENDDO
aPrompts := nil
nThisRow := nil
aWidths := nil
setcursor(nOldCursor)
return nReturnval


static function tmblock(i)
return {||padr(aPrompts[i,nThisRow],aWidths[i])}


