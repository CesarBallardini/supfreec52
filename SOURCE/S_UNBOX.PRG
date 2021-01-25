/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION UNBOX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  UNBOX() Removes a box created by makebox()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  Unbox([cMakeBox],[nTop,nLeft,nBottom,nRight],[expRestScreen] )
ณ 
ณ  Description:
ณ  ------------
ณ  UNBOX restores the screen <cMakeBox> saved by
ณ  MAKEBOX(). MAKEBOX() stores the dimensions and color in the
ณ  returned string, so it is not necessary to pass these to
ณ  UNBOX(). If the dimensions are passed, UNBOX() assumes these are
ณ  not part of the saved string, and assumes the string is a
ณ  savescreen() string. If the string and any other single param
ณ  are passed, UNBOX() assumes it is a full screen (0,0,24,79)
ณ  restore and does so.
ณ 
ณ  [nTop,nLeft,nBottom,nRight] - the dimensions of the box.
ณ 
ณ  Use these to UNBOX() a screen saved with SAVESCREEN().
ณ 
ณ  [bcRestScreen] This is a block which can override the
ณ  default screen restore mechanism. If passed, this screen restore
ณ  is used instead of the default. To set back to default, pass
ณ  this parameter as an empty string "". If passing this parameter,
ณ  pass all other parameters as NIL. What this does, basically, is
ณ  set up a static variable which holds the screen restore block.
ณ  Default is {|t,l,b,r,s|restscreen(t,l,b,r,s)} or if sls_xplode()
ณ  is (.t.), {|t,l,b,r,s|bxx_imbox(t,l,b,r,s)} (an internal
ณ  function within S_UNBOX.PRG) .
ณ 
ณ  Examples:
ณ  ---------
ณ   cMsgBox := MAKEBOX(10,40,12,60,'W/R,+GR/R')
ณ 
ณ   @11,42 SAY "What's up, Doc ?"
ณ 
ณ   inkey(0)
ณ 
ณ   UNBOX(cMsgBox)
ณ 
ณ   // to set up the alternate screen restore method:
ณ  unbox(nil,nil,nil,nil,nil,{|t,l,b,r,s| ss_fade(t,l,b,r,s)})
ณ  unbox(nil,nil,nil,nil,nil,{|t,l,b,r,s| ss_fall(t,l,b,r,s,100)} )
ณ 
ณ   // to set screen restore back to the default
ณ  unbox(nil,nil,nil,nil,nil,"")
ณ 
ณ  Source:
ณ  -------
ณ  S_UNBOX.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/

#ifdef CLIPPER53        // in 5.3, makebox returns an array
   FUNCTION UNBOX(cSavedScreen,nTop,nLeft,nBottom,nRight,bRest)

   local nBoxTop,nBoxRight,nBoxBottom,nBoxLeft,cBoxDimChunk
   local cActualScreen,cColorChunk
   local bRestScreen, aScreenFromArray

   static bSRestScreen

   if bSRestScreen#nil
      bRestScreen :=  bSRestscreen
   elseif sls_xplode()
      bRestScreen := {|t,l,b,r,s|bxx_imbox(t,l,b,r,s)}
   else
      bRestScreen := {|t,l,b,r,s|restscreen(t,l,b,r,s)}
   endif


   *- if 5 params passed,
   IF VALTYPE(bRest)=="B"  // block passed, no processing done
      bSRestscreen := bRest
   ELSEIF VALTYPE(bRest)=="C" // cancel block, no processing
      bSRestscreen := NIL
   ELSEIF Pcount() == 5    // screen + dimensions
      aScreenFromArray  := cSavedScreen[2]
      EVAL(bRestscreen,nTop,nLeft,nBottom,nRight,aScreenFromArray )
   ELSEIF Pcount() = 2     // full screen
      aScreenFromArray  := cSavedScreen[2]
      EVAL(bRestscreen,0,0,maxrow(),maxcol(),aScreenFromArray)
   ELSE                   // just the screen passed
      aScreenFromArray  := cSavedScreen[2]
      cBoxDimChunk    := SUBST(cSavedScreen[1],31,8)
      cColorChunk     := TRIM(SUBST(cSavedScreen[1],1,30))
      nBoxTop         := VAL(SUBST(cBoxDimChunk,1,2))
      nBoxLeft        := VAL(SUBST(cBoxDimChunk,3,2))
      nBoxBottom      := VAL(SUBST(cBoxDimChunk,5,2))
      nBoxRight       := VAL(SUBST(cBoxDimChunk,7,2))
      EVAL(bRestscreen,nBoxTop,nBoxLeft,nBoxBottom,nBoxRight,aScreenFromArray)
      Setcolor(cColorChunk)
   ENDIF
   RETURN nil
#else
   FUNCTION UNBOX(cSavedScreen,nTop,nLeft,nBottom,nRight,bRest)

   local nBoxTop,nBoxRight,nBoxBottom,nBoxLeft,cBoxDimChunk
   local cActualScreen,cColorChunk
   local bRestScreen

   static bSRestScreen

   if bSRestScreen#nil
      bRestScreen :=  bSRestscreen
   elseif sls_xplode()
      bRestScreen := {|t,l,b,r,s|bxx_imbox(t,l,b,r,s)}
   else
      bRestScreen := {|t,l,b,r,s|restscreen(t,l,b,r,s)}
   endif


   *- if 5 params passed,
   IF VALTYPE(bRest)=="B"  // block passed
      bSRestscreen := bRest
   ELSEIF VALTYPE(bRest)=="C"
      bSRestscreen := NIL
   ELSEIF Pcount() == 5
      EVAL(bRestscreen,nTop,nLeft,nBottom,nRight,cSavedScreen)
      *- assume a full screen restore
   ELSEIF Pcount() = 2
      nBoxTop      :=  0
      nBoxLeft     :=  0
      nBoxBottom   :=  maxrow()
      nBoxRight    :=  maxcol()
      EVAL(bRestscreen,0,0,maxrow(),maxcol(),cSavedScreen)
      *- extract color, dimensions and screen from the string.
   ELSE
      cBoxDimChunk    := SUBST(cSavedScreen,31,8)
      cColorChunk     := TRIM(SUBST(cSavedScreen,1,30))
      cActualScreen   := SUBST(cSavedScreen,39)
      nBoxTop         := VAL(SUBST(cBoxDimChunk,1,2))
      nBoxLeft        := VAL(SUBST(cBoxDimChunk,3,2))
      nBoxBottom      := VAL(SUBST(cBoxDimChunk,5,2))
      nBoxRight       := VAL(SUBST(cBoxDimChunk,7,2))
      EVAL(bRestscreen,nBoxTop,nBoxLeft,nBoxBottom,nBoxRight,cActualScreen)
      Setcolor(cColorChunk)
   ENDIF
   RETURN nil

#endif


static function bxx_imbox(nTop,nLeft,nBottom,nRight,cScreen)
local nRows,nColumns,cScreen2

nRows    := nBottom-nTop+1
nColumns := nRight-nLeft+1

do while nRows > 5 .and. nColumns > 9
*   dispbegin()
   cScreen2  := savescreen(nTop+2,nLeft+2,nBottom-2,nRight-2)
   restscreen(nTop,nLeft,nBottom,nRight,cScreen)
   nTop      += 2
   nBottom   -= 2
   nLeft     += 2
   nRight    -= 2
   cScreen   := savescreen(nTop,nLeft,nBottom,nRight)
   restscreen(nTop,nLeft,nBottom,nRight,cScreen2)
*   dispend()
   nRows    := nBottom-nTop+1
   nColumns := nRight-nLeft+1
enddo
restscreen(nTop,nLeft,nBottom,nRight,cScreen)
return nil
