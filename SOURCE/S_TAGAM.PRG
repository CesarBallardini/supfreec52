
#include "inkey.ch"
#ifndef K_SPACE
  #define K_SPACE 32
#endif


static nElement := 1




/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION TAGMARRAY()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  TAGMARRAY() Tag elements in muti-dimensioned array
� 
�  Returns:
�  --------
�  <aTagged> => an array of numbers representing the
�  tagged elements
� 
�  Syntax:
�  -------
�  TAGMARRAY(aArray,[cTitle],[cMark],[aTags],[aHeads])
� 
�  Description:
�  ------------
�  A popup which allows tagging/untagging of elements in
�  <aArray>, which is a multi-dimmed array of the format
�  {array(n),array(n)} such as is returned by DIRECTORY() or DBSTRUCT().
� 
�    SPACE   = Tag/Untag
�    F10     = Done
�    ESC     = Abort
�    ALT-A   = Tag All
�    ALT-U   = Untag All
�    ALT-S   = Swap Tagged/untagged
� 
�  The return value <aTagged> is an array of integer
�  values representing the offsets into the original array <aArray> which
�  were tagged.
� 
�  [cTitle] is a string to be used as the box title
� 
�  [cMark]  is the tag character. Default is chr(251) - checkmark
� 
�  [aTags]  is an array of logicals the same length as
�  <aArray>. This allows pre-tagging. You may also use this
�  array on return from the function. The (.T.) elements
�  correspond to the tagged elements in <aArray>.
� 
�  [aHeads] is an array for the column titles for each
�  subarray element in <aArray>, and needs to be the same length
�  as a subarray of <aArray>
� 
�  Examples:
�  ---------
�   aDir  := directory()
� 
�   aCols := {"File","Size","Date","Time","Attribute"}
� 
�   aCopy := tagmarray(aDir,"Select Files for copying",nil,nil,aCols)
� 
�   for i = 1 to len(aCopy)
� 
�     COPY FILE (aDir[aCopy[i],1 ]) TO (cDestination)
� 
�   next
� 
�  Notes:
�  -------
�  Coded by Matthew Maier - thanks.
� 
�  Source:
�  -------
�  S_TAGAM.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
*/
FUNCTION TagMArray(aArray,cTitle,cMark,aTags,aHeads)
  local cScreen1, nSaveCursor
  local aRet, oTB, oTBC
  local nTop, nLeft, nBottom, nRight
  local nLastKey, cLastKey
  local i, aColInfo, nNoCols, nNoRows, lHeaders
  local lExit := .f.
  local aData, aButtons, nButton
  local cKeyMsg
  local nMouseR, nMouseC

  if (aArray == NIL)
    retu (NIL)
  else
    aData     := aArray
    nElement  := 1
    nNoRows   := len(aArray)
    nNoCols   := len(aArray[1])
  endif

  nSaveCursor := setcursor(0)

  if (aTags == NIL)
    aTags := array(nNoRows)
    afill(aTags,.f.)
  else
    if (len(aTags) != nNoRows)
      asize(aTags,len(aArray))
      tmfillnil(aTags,.f.)
    endif
  endif

  if (aHeads == NIL)
    aHeads    := array(nNoCols)
    lHeaders  := .f.
  else
    lHeaders := .t.
    if (len(aHeads) < nNoCols)
      aHeads := asize(aHeads,nNoCols)
    endif
  endif

  aColInfo := CalcMaxColLen(aArray,nNoRows,nNoCols)


  cMark    := IIF(cMark != NIL,cMark,"�")
  cKeyMsg  := "SPACE=Tag  F10=Save  ESC=Abort  ALT-A=TagAll  ALT-U=UntagAll  ALT-S=Switch"

  nTop    := 0
  nLeft   := 0
  nBottom := 16
  nRight  := len(cKeyMsg)+2
  sbCenter(@nTop,@nLeft,@nBottom,@nRight)

  *- DRAW THE BOX
  dispbegin()
  cScreen1 := MAKEBOX(nTop,nLeft,nBottom,nRight,SLS_POPCOL())
  if (cTitle != NIL)
    @ nTop+1,nLeft+2 say left(cTitle,(nRight-(nLeft+2)))
    @nTop+2,nLeft+1 to nTop+2,nRight-1
    if (lHeaders)
      @ nTop+2,nLeft say "�"
      @ nTop+2,nRight say "�"
      @ nTop+2,nLeft+1 to nTop+2,nRight-1 double
    endif
    @ nTop+iif(lHeaders,4,2),nLeft say "団"
    @ nTop+iif(lHeaders,4,2),nRight-1 say "調"
    @ nTop+iif(lHeaders,4,2),nLeft+1 to nTop+iif(lHeaders,4,2),nRight-1
  endif
  @nBottom-3,nLeft+1 to nBottom-3,nRight-1
  @ nBottom-2,nLeft+2 say "[][][][]"
  @ nBottom-1,nLeft+2 say cKeyMsg
  dispend()
  aButtons := {;
        {nBottom-1,nLeft+2, nBottom-1,nLeft+10,K_SPACE},;
        {nBottom-1,nLeft+13, nBottom-1,nLeft+20,K_F10},;
        {nBottom-1,nLeft+23, nBottom-1,nLeft+31,K_ESC},;
        {nBottom-1,nLeft+34, nBottom-1,nLeft+45,K_ALT_A},;
        {nBottom-1,nLeft+48, nBottom-1,nLeft+61,K_ALT_U},;
        {nBottom-1,nLeft+64, nBottom-1,nLeft+75,K_ALT_S},;
        {nBottom-2,nLeft+2 , nBottom-2,nLeft+4 ,K_UP   },;
        {nBottom-2,nLeft+5 , nBottom-2,nLeft+7 ,K_DOWN },;
        {nBottom-2,nLeft+8 , nBottom-2,nLeft+10,K_RIGHT},;
        {nBottom-2,nLeft+11, nBottom-2,nLeft+13,K_LEFT } }

  *- BUILD THE TBROWSE OBJECT
  oTB := TBrowseNew( ;
    nTop+iif(cTitle != NIL,2,0)+iif(lHeaders,1,0), ;
    nLeft+2,nBottom-3,nRight-2)
  oTB:headSep := "賃�"
  oTB:colSep  := " � "
  oTB:footSep := "珍�"

  *- ADD THE TBCOLUMNS
  oTB:addColumn(tbColumnNew( NIL, ;
    {||iif(aTags[nElement],cMark,space(len(cMark)))} ))
  for i := 1 to nNoCols
    oTBC := TBColumnNew( aHeads[i],GenBlock(i,aData))
    if (aColInfo[i] > 0)
      oTBC:width := iif(lHeaders, ;
        max(aColInfo[i],len(aHeads[i])), ;
        aColInfo[i])
    endif
    oTB:addColumn(oTBC)
  next
  oTB:skipBlock     := {|n|aaskip(n,@nElement,nNoRows)}
  oTB:goBottomBlock := {|| nElement := nNoRows}
  oTB:goTopBlock    := {|| nElement := 1}


  oTB:freeze := 1
  oTB:colPos := 2

  while (!lExit)
    dispbegin()
    WHILE (!oTB:stabilize())
    END
    dispend()
    nLastKey := RAT_EVENT()
    nMouseR := rat_eqmrow()
    nMouseC := rat_eqmcol()
    nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
    cLastKey=upper(chr(nLastKey))
      do case
      case nLastKey== K_SPACE .or. nButton==K_SPACE
        aTags[nElement] := (!aTags[nElement])
        oTB:refreshCurrent()
      case nLastKey== K_F10 .or. nLastKey=K_CTRL_END .or. nButton==K_F10
        lExit := .t.
      case nLastKey == K_ESC .or. nButton==K_ESC
        aTags := NIL
        lExit := .t.
      case nLastKey ==  K_ALT_A .or. cLastKey=="A" .or. nButton==K_ALT_A
        afill(aTags,.t.)
        oTB:refreshAll()
      case nLastKey == K_ALT_U  .or. cLastKey=="U" .or. nButton==K_ALT_U
        afill(aTags,.f.)
        oTB:refreshAll()
      case nLastKey == K_ALT_S   .or. cLastKey=="S" .or. nButton==K_ALT_S
        for i := 1 to len(aTags)
          aTags[i] := (!aTags[i])
        next
        oTB:refreshAll()
      case nLastKey == K_LEFT  .or. nButton==K_LEFT    // allow movement (left), not tag column
        if (oTB:colPos > 2)
          oTB:left()
          IF nButton==K_LEFT
            IFMOUSEHD({||iif(oTb:colpos>2,oTb:left(),nil)},oTb)
          ENDIF
        endif
      case nLastKey == K_RIGHT  .or. nButton==K_RIGHT   // allow movement (right)
        oTB:right()
       IFMOUSEHD({||oTb:right()},oTb)

      CASE nLastKey = K_UP   .or. nButton==K_UP       && UP ONE ROW
        oTB:up()
       IFMOUSEHD({||oTb:up()},oTb)

      CASE nLastKey = K_PGUP        && UP ONE PAGE
        oTB:pageUp()


      CASE nLastKey = K_DOWN   .or. nButton==K_DOWN     && DOWN ONE ROW
        oTB:down()
       IFMOUSEHD({||oTb:down()},oTb)

      CASE nLastKey = K_PGDN        && DOWN ONE PAGE
        oTB:pageDown()

      case nLastKey == K_HOME
        oTB:goTop()

      case nLastKey == K_END
        oTB:goBottom()
      case MBRZMOVE(oTb,nMouseR,nMouseC,;
               iif(cTitle#nil,nTop+3,nTop+1)+IIF(lHeaders,2,0),;
              nLeft+1,nBottom-4,nRight-1)
      case MBRZCLICK(oTb,nMouseR,nMouseC)
           keyboard " "
      endcase
  ENDDO
  aRet := {}
  if (aTags != NIL)
    for i := 1 to len(aTags)
      if (aTags[i])
        aadd(aRet,i)
      endif
    next
  endif
  unbox(cScreen1)
  setcursor(nSaveCursor)
  nElement := nil
return (aRet)

static function genBlock(nCol,aData)
return({||aData[nElement][nCol]})


static function CalcMaxColLen(a,nRows,nCols)
  local i, j
  local aRet := array(nCols)
  afill(aRet,0)
  for i := 1 to nRows
    for j := 1 to nCols
      if (valtype(a[i][j]) == 'C')
        if (len(a[i][j]) > aRet[j])
          aRet[j] := len(a[i][j])
        endif
      endif
    next
  next
return(aRet)


static function tmfillnil(aIn,expFill)
local i
for i = 1 to len(aIn)
  if aIn[i]==nil
    aIn[i] := expFill
  endif
next
return nil



