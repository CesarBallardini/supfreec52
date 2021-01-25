/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_HBLINDS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_HBLINDS() Restores screen in a horizontal blind fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_HBLINDS(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a horizontal blind
ณ  fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 100. Higher number
ณ  makes a slower
ณ 
ณ  screen restore. Lower number makes a faster screen
ณ  restore. Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   ss_hblinds(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_hblinds(nTop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nRows := nBottom-nTop+1
local nRowCounter
local nCounter
local x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,100)
for nRowCounter = 1 to nRows step 2
  restscreen(nTop+nRowCounter-1,nLeft,ntop+nRowCounter-1,nright,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowCounter))
  for nCounter =1 to nDelay
    x=1
  next
next
for nRowCounter = 2 to nRows step 2
  restscreen(nTop+nRowCounter-1,nLeft,ntop+nRowCounter-1,nright,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowCounter))
  for nCounter =1 to nDelay
    x=1
  next
next
return nil

//--------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_VBLINDS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_VBLINDS() Restores screen in a vertical blind fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_VBLINDS(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a horizontal blind
ณ  fashion.
ณ 
ณ  <cInscreen>is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 100. Higher number
ณ  makes a slower
ณ 
ณ  screen restore. Lower number makes a faster screen
ณ  restore. Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   ss_vblinds(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_vblinds(nTop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nCols := nright-nleft+1
local nColCounter
local nCounter
local x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,50)
for nColCounter = 1 to nCols step 2
  restscreen(nTop,nLeft+nColCounter-1,nBottom,nleft+nColCounter-1,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColCounter))
  for nCounter =1 to nDelay
    x=1
  next
next
for nColCounter = 2 to nCols step 2
  restscreen(nTop,nLeft+nColCounter-1,nBottom,nleft+nColCounter-1,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColCounter))
  for nCounter =1 to nDelay
    x=1
  next
next
return nil

//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_SLICE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_SLICE() Restores screen in a slicing fashion. Alternative
ณ  to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_SLICE(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a slicing fashion.
ณ  <cInscreen>
ณ 
ณ  is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  is a delay factor. Default is 8. (Larger #
ณ  is faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_SLICE(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_slice(nTop,nLeft,nBottom,nRight,cInScreen,nSteps)
local nRows := nBottom-nTop+1
local nCols := nRight-nLeft+1
local nRowCounter
local aRows := array(nRows)
local cNowScreen := savescreen(nTop,nLeft,nBottom,nRight)
local nIter,nIter2
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif

nSteps := iif(nSteps#nil,nSteps,8)
for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cNowScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
next

for nIter = 0 to nCols-1 step nSteps
  dispbegin()
  restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
  for nIter2 = 1 to nRows step 2
    restscreen(nTop+nIter2-1,nLeft,ntop+nIter2-1,nright-nIter,aRows[nIter2])
    aRows[nIter2] := savescreen(nTop+nIter2-1,nLeft,nTop+nIter2-1,nRight-nIter-nSteps)
  next

  for nIter2 = 2 to nRows step 2
    restscreen(nTop+nIter2-1,nLeft+nIter,ntop+nIter2-1,nright,aRows[nIter2])
    aRows[nIter2] := savescreen(nTop+nIter2-1,nLeft+nIter+nSteps,nTop+nIter2-1,nRight)
  next
  dispend()
next
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil

//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_SPLIT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_SPLIT() Restores screen in a split from middle fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_SPLIT(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a split from middle
ณ  fashion. <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  is a delay factor. Default is 5. (Larger #
ณ  is faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_SPLIT(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_split(nTop,nLeft,nBottom,nRight,cInScreen,nSteps)
local nRows := nBottom-nTop+1
local nCols := nRight-nLeft+1
local nRowCounter
local nCounter,nIter2
local aRows := array(nRows)
local nEachSide := int(nCols/2)
local cNowScreen := savescreen(nTop,nLeft,nBottom,nRight)

if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nSteps := iif(nSteps#nil,nSteps,5)
for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cNowScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
next

While nEachSide > 0
  dispbegin()
  restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
  for nIter2 = 1 to nRows
     restscreen(nTop+nIter2-1,nLeft,ntop+nIter2-1,nLeft+nEachSide-1,left(aRows[nIter2],nEachSide*2))
     restscreen(nTop+nIter2-1,nRight-nEachSide+1,ntop+nIter2-1,nRight,Right(aRows[nIter2],nEachSide*2))
  next
  dispend()
  nEachSide-=nSteps
end
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil
//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_FOLD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_FOLD() Restores screen in a fold to middle fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_FOLD(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a fold to middle
ณ  fashion. <cInscreen>
ณ 
ณ  is a screen saved with SAVESCREEN(). <nTop>,
ณ  <nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 3. (Larger # is
ณ  faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_FOLD(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_fold(nTop,nLeft,nBottom,nRight,cInScreen,nSteps)
local nRows := nBottom-nTop+1
local nCols := nRight-nLeft+1
local nRowCounter
local nCounter,nIter2
local aRows := array(nRows)
local nWidth  := nCols-2
local nOffset := 1
local cNowScreen := savescreen(nTop,nLeft,nBottom,nRight)

if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nSteps := iif(nSteps#nil,nSteps,3)
for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cNowScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
next

While nWidth > 2
  dispbegin()
  restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
  for nIter2 = 1 to nRows
     restscreen(nTop+nIter2-1,nLeft+nOffset,ntop+nIter2-1,nRight-nOffset,Subst(aRows[nIter2],(nOffset*2)+1,nWidth*2))
  next
  dispend()
  nOffset+=nSteps
  nWidth := nCols-(nOffset*2)
end
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil
//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_RISE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_RISE() Restores screen in a rise from bottom fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_RISE(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a rise from bottom
ณ  fashion. <cInscreen>
ณ 
ณ  is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  is a delay factor. Default is 100. (Smaller
ณ  # is faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_RISE(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_rise(nTop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nRows    := nBottom-nTop+1
local nCols    := nRight-nLeft+1
local aRows    := array(nRows)
local nRowCounter,nIter,nIter2,nCounter
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,100)
for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
next
for nIter = 1 to nRows
   for nIter2 = 1 to nIter
     restscreen(nBottom-nIter+nIter2,nLeft,nBottom-nIter+nIter2,nRight,aRows[nIter2])
   next
   for nCounter =1 to nDelay
     nIter2=1
   next
next
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil
//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_FALL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_FALL() Restores screen in a fall from top fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_FALL(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a fall from top
ณ  fashion. <cInscreen>
ณ 
ณ  is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 100. (Smaller # is
ณ  faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_FALL(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_fall(nTop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nRows    := nBottom-nTop+1
local nCols    := nRight-nLeft+1
local aRows    := array(nRows)
local nRowCounter,nIter,nCounter,nIter2

if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,100)
for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
next
for nIter = nrows to 1 step -1
   dispbegin()
   scroll(nTop,nLeft,nBottom,nright,-1)
   restscreen(nTop,nLeft,nTop,nRight,aRows[nIter])
   dispend()
   for nCounter =1 to nDelay
     nIter2=1
   next
next
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil

//------------------------------------------------------------------
//--this is provided for compatibility
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FADEAWAY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FADEAWAY() Fades screen away , alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  FADEAWAY(cInScreen,nTop,nLeft,nBottom,nRight)
ณ 
ณ  Description:
ณ  ------------
ณ  Fades <cInscreen>, a screen stored with SAVESCREEN(),
ณ  back onto the screen at <nTop>,<nLeft>,<nBottom>,<nRight>. Here
ณ  for compatibility. See SS_FADE().
ณ 
ณ  Examples:
ณ  ---------
ณ   See SS_FADE()
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREEN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function fadeaway(cInScreen,nTop,nLeft,nBottom,nRight)
ss_fade(nTop,nLeft,nBottom,nRight,cInScreen)
return nil
//------------------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_FADE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_FADE() Restores screen in a fadeaway fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_FADE(nTop,nLeft,nBottom,nRight,cInScreen)
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a fadeaway fashion.
ณ  <cInscreen>
ณ 
ณ  is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_FADE(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_fade(nTop,nLeft,nBottom,nRight,cInScreen)
local cCurrent := savescreen(nTop,nLeft,nBottom,nRight)
local nIter
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
for nIter = 10 to 1 step -1
  restscreen(nTop,nLeft,nBottom,nRight,ssprinkle(cInScreen,savescreen(nTop,nLeft,nBottom,nRight),nIter))
next
return nil


//---------------------------------------------------------------
function ss_slideright(nTop,nLeft,nBottom,nRight,cInScreen)
local nRows := nBottom-nTop+1
local nCols := nRight-nLeft+1
local nRowCounter
local nCounter,nIter2,nIter
local aRows := array(nRows)
local cNowScreen := savescreen(nTop,nLeft,nBottom,nRight)
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif

for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cInScreen,nTop,nLeft,nbottom,nright,nRowCounter)
  arows[nRowCounter] += getscrow(cNowScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
next

for nIter = nCols to 1 step -8
  dispbegin()
  for nIter2 = 1 to nRows
    restscreen(nTop+nIter2-1,nLeft,ntop+nIter2-1,nright,subst(aRows[nIter2],nIter*2+1,nCols*2))
  next
  dispend()
next
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil
//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_SLIDELEFT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_SLIDELEFT() Restores screen in a slide left fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_SLIDELEFT(nTop,nLeft,nBottom,nRight,cInScreen)
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a slide left fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_SLIDELEFT(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_slideleft(nTop,nLeft,nBottom,nRight,cInScreen)
local nRows := nBottom-nTop+1
local nCols := nRight-nLeft+1
local nRowCounter
local nCounter,nIter2,nIter
local aRows := array(nRows)
local cNowScreen := savescreen(nTop,nLeft,nBottom,nRight)
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif

for nRowCounter = 1 to nRows
  arows[nRowCounter] := getscrow(cNowScreen,nTop,nLeft,nBottom,nRight,nRowCounter)
  arows[nRowCounter] += getscrow(cInScreen,nTop,nLeft,nbottom,nright,nRowCounter)
next

for nIter = 1 to nCols step 8
  dispbegin()
  for nIter2 = 1 to nRows
    restscreen(nTop+nIter2-1,nLeft,ntop+nIter2-1,nright,subst(aRows[nIter2],nIter*2+1,nCols*2))
  next
  dispend()
next
restscreen(ntop,nLeft,nbottom,nRight,cInScreen)
return nil

//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_CLOSEH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_CLOSEH() Restores screen in a horizontal close fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_CLOSEH(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a close from top and
ณ  bottom fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  is a delay factor. Default is 100. (Smaller
ณ  # is faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ   DOSOMESCREENSTUFF()
ณ   DOMORESCREENSTUFF()
ณ   SS_CLOSEH(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_closeh(ntop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nRows := nBottom-nTop+1
local nRowTop   := nTop
local nRowBottom := nBottom
local nCounter,x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,100)

while nRowTop<nRowBottom

  restscreen(nRowTop,nLeft,nRowTop,nRight,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowTop-nTop+1))

  restscreen(nRowBottom,nLeft,nRowBottom,nRight,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowBottom-nTop+1))

  nRowTop++
  nrowBottom--
  for nCounter =1 to nDelay
    x=1
  next
end
restscreen(ntop,nLeft,nBottom,nRight,cInScreen)
return nil

//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_CLOSEV()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_CLOSEV() Restores screen in a vertical close fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_CLOSEV(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a close from left and
ณ  right fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 50. (Smaller # is
ณ  faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ   DOSOMESCREENSTUFF()
ณ   DOMORESCREENSTUFF()
ณ   SS_CLOSEV(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_closev(ntop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nCols := nright-nleft+1
local nColLeft  := nLeft
local nColRight := nRight
local nCounter,x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,50)

while  nColLeft < nColRight
  dispbegin()
  restscreen(nTop,nColLeft,nBottom,nColLeft,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColLeft-nLeft+1))

  restscreen(nTop,nColRight,nBottom,nColRight,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColRight-nLeft+1))

  dispend()
  nColLeft++
  ncolRight--

  for nCounter =1 to nDelay
    x=1
  next
end
restscreen(ntop,nLeft,nBottom,nRight,cInScreen)
return nil
//---------------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_IMPLODE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_IMPLODE() Restores screen in an imploding fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_IMPLODE(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in an imploding fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 100. (Smaller # is
ณ  faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_IMPLODE(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_implode(ntop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nRows := nBottom-nTop+1
local nCols := nright-nleft+1
local nColLeft  := nLeft
local nColRight := nRight
local nRowTop   := nTop
local nRowBottom := nBottom
local nCounter,x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,100)

while nRowTop<nRowBottom  .and. nColLeft < nColRight
  dispbegin()
  restscreen(nRowTop,nLeft,nRowTop,nRight,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowTop-nTop+1))

  restscreen(nRowBottom,nLeft,nRowBottom,nRight,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowBottom-nTop+1))

  restscreen(nTop,nColLeft,nBottom,nColLeft,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColLeft-nLeft+1))

  restscreen(nTop,nColRight,nBottom,nColRight,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColRight-nLeft+1))

  dispend()
  nRowTop++
  nRowBottom--
  nColLeft++
  ncolRight--
  for nCounter =1 to nDelay
    x=1
  next
end
restscreen(ntop,nLeft,nBottom,nRight,cInScreen)
return nil
//---------------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_WIPEH()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_WIPEH() Restores screen in a wipe from left fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_WIPEH(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a wipe fromleft
ณ  fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  delay factor. Default is 100. (Smaller # is
ณ  faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_WIPEH(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_wipeh(ntop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nRowTop   := nTop
local nCounter,x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,100)

for nRowTop = nTop to nBottom

  restscreen(nRowTop,nLeft,nRowTop,nRight,;
      getscrow(cInScreen,nTop,nLeft,nBottom,nRight,nRowTop-nTop+1))

  for nCounter =1 to nDelay
    x=1
  next
next
restscreen(ntop,nLeft,nBottom,nRight,cInScreen)
return nil

//---------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SS_WIPEV()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SS_WIPEV() Restores screen in a wipe from top fashion.
ณ  Alternative to restscreen()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SS_WIPEV(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
ณ 
ณ  Description:
ณ  ------------
ณ  Restores screen <cInScreen> in a wipe from top
ณ  fashion.
ณ 
ณ  <cInscreen> is a screen saved with SAVESCREEN().
ณ  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
ณ 
ณ  [nDelay]  is a delay factor. Default is 50. (Smaller
ณ  # is faster)
ณ 
ณ  Relative to the speed of the machine.
ณ 
ณ  Examples:
ณ  ---------
ณ   MainScreen := savescreen(0,0,24,79)
ณ 
ณ   DOSOMESCREENSTUFF()
ณ 
ณ   DOMORESCREENSTUFF()
ณ 
ณ   SS_WIPEV(0,0,24,79,MainScreen)
ณ 
ณ  Source:
ณ  -------
ณ  S_SCREENS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function ss_wipev(ntop,nLeft,nBottom,nRight,cInScreen,nDelay)
local nColLeft
local nCounter,x
if valtype(cInScreen)<>"C"  // MUST BE IN GRAPHICS MODE! Do
                            // regular restscreen()
        restscreen(nTop,nLeft,nBottom,nRight,cInScreen)
        return nil
endif
nDelay := iif(nDelay#nil,nDelay,50)

for nColLeft = nLeft to nRight
  dispbegin()
  restscreen(nTop,nColLeft,nBottom,nColLeft,;
         getsccol(cInScreen,nTop,nLeft,nBottom,nRight,nColLeft-nLeft+1))

  dispend()

  for nCounter =1 to nDelay
    x=1
  next
end
restscreen(ntop,nLeft,nBottom,nRight,cInScreen)
return nil

// here for compatibility, not documented
function shiftr(cInscreen,nTop,nLeft,nBottom,nright,nSpeed)
ss_slideright(nTop,nLeft,nBottom,nRight,cInscreen)
return nil
