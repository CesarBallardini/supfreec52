/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MAKEBOX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MAKEBOX() Draws a box on the screen and returns saved screen
ณ 
ณ  Returns:
ณ  --------
ณ  <cScreen> => string containing underlying screen &
ณ  colors
ณ 
ณ  Syntax:
ณ  -------
ณ  MAKEBOX(nTop,nLeft,nbottom,nRight,[cColor],[nShadowPos])
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a box at screen coordinates <nTop..nRight> and
ณ  returns a string containing the underlying screen and previous color.
ณ  Box will explode or not based on the setting of SLS_XPLODE().
ณ 
ณ  Default color is setcolor(). Default shadow position
ณ  is the setting in SLS_SHADPOS(). These may be passed as
ณ  options . Shadow position [nShadowPos] has allowable values of
ณ  (1,3,7,9,0) to match the corner positions on the numeric keypad.
ณ  0 is no shadow. [cColor] is a valid color string or variable.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   cBox := MAKEBOX(5,5,10,10)
ณ   //draws a box at 5,5,10,10. Color is SETCOLOR().
ณ   //shadow position is based on SLS_SHADPOS().
ณ 
ณ   cBox: = MAKEBOX(5,5,10,10,SLS_POPCOL())
ณ   //draws a box at 5,5,10,10. Color is SLS_POPCOL().
ณ   //shadow position is based on SLS_SHADPOS().
ณ 
ณ   cBox: = MAKEBOX(5,5,10,10,SLS_POPCOL(),9)
ณ   //draws a box at 5,5,10,10. Color is SLS_POPCOL().
ณ   //shadow position is 9 (upper right hand corner)
ณ 
ณ  Warnings:
ณ  ----------
ณ  Use only UNBOX() to remove screens stored with
ณ  MAKEBOX().
ณ 
ณ  Notes:
ณ  -------
ณ  UNBOX() removes the box and restores the underlying
ณ  screen and prior colors.
ณ 
ณ  The shadow will not be drawn if it would go off the
ณ  edge of the screen.
ณ 
ณ  Source:
ณ  -------
ณ  S_MAKEB.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
#ifdef CLIPPER53        // in 5.3, makebox returns an array
  FUNCTION makebox(nTop,nLeft,nBottom,nRight,cColorString,nShadowPos)
  local aSaveUnder
  local nRealTop,nRealLeft,nRealBottom,nRealRight
  local xSave
  IF valtype(nShadowPos)<>"N"
    *- use default shadow nShadowPos
    nShadowPos = sls_shadpos()
  ENDIF (Pcount() > 5

  *- find out what area to savescreen, taking shadow into account
  nRealTop    := nTop
  nRealLeft   := nLeft
  nRealBottom := nBottom
  nRealRight  := nRight
  DO CASE
  CASE nShadowPos = 1 .and. nBottom <Maxrow() .and. nLeft > 0
    nRealLeft   := MAX(0,nLeft-1)
    nRealBottom := MIN(maxrow(),nBottom+1)
  CASE nShadowPos = 3 .and. nBottom <Maxrow() .and. nRight < Maxcol()
    nRealBottom = MIN(maxrow(),nBottom+1)
    nRealRight = MIN(maxcol(),nRight+1)
  CASE nShadowPos = 9 .and. nTop > 0 .and. nRight < Maxcol()
    nRealTop = MAX(0,nTop-1)
    nRealRight = MIN(maxcol(),nRight+1)
  CASE nShadowPos = 7 .and. nTop > 0 .and. nLeft > 0
    nRealTop = MAX(0,nTop-1)
    nRealLeft = MAX(0,nLeft-1)
  ENDCASE

  *- determine colors
  IF valtype(cColorString) <> "C"
    cColorString = Setcolor()
  ENDIF
  *- set color and store old setting to aSaveUnder
  aSaveUnder := padr(Setcolor(cColorString),30)

  *- store the screen, plus the dimensions to a aSaveUnder

  aSaveUnder += str(nRealTop,2,0)+str(nRealLeft,2,0)+str(nRealBottom,2,0)+str(nRealRight,2,0)
  xSave := Savescreen(nRealTop,nRealLeft,nRealBottom,nRealRight)
  aSaveUnder := {aSaveUnder,xSave}

  *- explode it?
  IF sls_xplode()
    xbxx(nTop,nLeft,nBottom,nRight,cColorString,nShadowPos,sls_shadatt(),sls_frame(),50)
  ELSE
    bxx(nTop,nLeft,nBottom,nRight,cColorString,nShadowPos,sls_shadatt(),sls_frame())
  ENDIF

  *- return the aSaveUnder containing the screen, dimensions, and colors
  *- which will be used by unbox to restore the screen and colors
  RETURN aSaveUnder


#else

  FUNCTION makebox(nTop,nLeft,nBottom,nRight,cColorString,nShadowPos)
  local cSaveUnder
  local nRealTop,nRealLeft,nRealBottom,nRealRight


  IF valtype(nShadowPos)<>"N"
    *- use default shadow nShadowPos
    nShadowPos = sls_shadpos()
  ENDIF (Pcount() > 5

  *- find out what area to savescreen, taking shadow into account
  nRealTop    := nTop
  nRealLeft   := nLeft
  nRealBottom := nBottom
  nRealRight  := nRight
  DO CASE
  CASE nShadowPos = 1 .and. nBottom <Maxrow() .and. nLeft > 0
    nRealLeft   := MAX(0,nLeft-1)
    nRealBottom := MIN(maxrow(),nBottom+1)
  CASE nShadowPos = 3 .and. nBottom <Maxrow() .and. nRight < Maxcol()
    nRealBottom = MIN(maxrow(),nBottom+1)
    nRealRight = MIN(maxcol(),nRight+1)
  CASE nShadowPos = 9 .and. nTop > 0 .and. nRight < Maxcol()
    nRealTop = MAX(0,nTop-1)
    nRealRight = MIN(maxcol(),nRight+1)
  CASE nShadowPos = 7 .and. nTop > 0 .and. nLeft > 0
    nRealTop = MAX(0,nTop-1)
    nRealLeft = MAX(0,nLeft-1)
  ENDCASE

  *- determine colors
  IF valtype(cColorString) <> "C"
    cColorString = Setcolor()
  ENDIF
  *- set color and store old setting to cSaveUnder
  cSaveunder := padr(Setcolor(cColorString),30)

  *- store the screen, plus the dimensions to a cSaveUnder

  cSaveUnder += str(nRealTop,2,0)+str(nRealLeft,2,0)+str(nRealBottom,2,0)+str(nRealRight,2,0)
  cSaveunder += Savescreen(nRealTop,nRealLeft,nRealBottom,nRealRight)

  *- explode it?
  IF sls_xplode()
    xbxx(nTop,nLeft,nBottom,nRight,cColorString,nShadowPos,sls_shadatt(),sls_frame(),50)
  ELSE
    bxx(nTop,nLeft,nBottom,nRight,cColorString,nShadowPos,sls_shadatt(),sls_frame())
  ENDIF

  *- return the cSaveUnder containing the screen, dimensions, and colors
  *- which will be used by unbox to restore the screen and colors
  RETURN cSaveUnder
#endif
*: EOF: S_MAKEB.PRG
