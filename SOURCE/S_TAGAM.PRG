
#include "inkey.ch"
#ifndef K_SPACE
  #define K_SPACE 32
#endif


static nElement := 1




/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION TAGMARRAY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  TAGMARRAY() Tag elements in muti-dimensioned array
ณ 
ณ  Returns:
ณ  --------
ณ  <aTagged> => an array of numbers representing the
ณ  tagged elements
ณ 
ณ  Syntax:
ณ  -------
ณ  TAGMARRAY(aArray,[cTitle],[cMark],[aTags],[aHeads])
ณ 
ณ  Description:
ณ  ------------
ณ  A popup which allows tagging/untagging of elements in
ณ  <aArray>, which is a multi-dimmed array of the format
ณ  {array(n),array(n)} such as is returned by DIRECTORY() or DBSTRUCT().
ณ 
ณ    SPACE   = Tag/Untag
ณ    F10     = Done
ณ    ESC     = Abort
ณ    ALT-A   = Tag All
ณ    ALT-U   = Untag All
ณ    ALT-S   = Swap Tagged/untagged
ณ 
ณ  The return value <aTagged> is an array of integer
ณ  values representing the offsets into the original array <aArray> which
ณ  were tagged.
ณ 
ณ  [cTitle] is a string to be used as the box title
ณ 
ณ  [cMark]  is the tag character. Default is chr(251) - checkmark
ณ 
ณ  [aTags]  is an array of logicals the same length as
ณ  <aArray>. This allows pre-tagging. You may also use this
ณ  array on return from the function. The (.T.) elements
ณ  correspond to the tagged elements in <aArray>.
ณ 
ณ  [aHeads] is an array for the column titles for each
ณ  subarray element in <aArray>, and needs to be the same length
ณ  as a subarray of <aArray>
ณ 
ณ  Examples:
ณ  ---------
ณ   aDir  := directory()
ณ 
ณ   aCols := {"File","Size","Date","Time","Attribute"}
ณ 
ณ   aCopy := tagmarray(aDir,"Select Files for copying",nil,nil,aCols)
ณ 
ณ   for i = 1 to len(aCopy)
ณ 
ณ     COPY FILE (aDir[aCopy[i],1 ]) TO (cDestination)
ณ 
ณ   next
ณ 
ณ  Notes:
ณ  -------
ณ  Coded by Matthew Maier - thanks.
ณ 
ณ  Source:
ณ  -------
ณ  S_TAGAM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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


  cMark    := IIF(cMark != NIL,cMark,"๛")
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
      @ nTop+2,nLeft say "ฦ"
      @ nTop+2,nRight say "ต"
      @ nTop+2,nLeft+1 to nTop+2,nRight-1 double
    endif
    @ nTop+iif(lHeaders,4,2),nLeft say "รฤ"
    @ nTop+iif(lHeaders,4,2),nRight-1 say "ฤด"
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
  oTB:headSep := "ฤยฤ"
  oTB:colSep  := " ณ "
  oTB:footSep := "ฤมฤ"

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



