/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_HBLINDS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_HBLINDS() Restores screen in a horizontal blind fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_HBLINDS(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a horizontal blind
³  fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 100. Higher number
³  makes a slower
³ 
³  screen restore. Lower number makes a faster screen
³  restore. Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   ss_hblinds(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_VBLINDS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_VBLINDS() Restores screen in a vertical blind fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_VBLINDS(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a horizontal blind
³  fashion.
³ 
³  <cInscreen>is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 100. Higher number
³  makes a slower
³ 
³  screen restore. Lower number makes a faster screen
³  restore. Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   ss_vblinds(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_SLICE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_SLICE() Restores screen in a slicing fashion. Alternative
³  to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_SLICE(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a slicing fashion.
³  <cInscreen>
³ 
³  is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  is a delay factor. Default is 8. (Larger #
³  is faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_SLICE(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_SPLIT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_SPLIT() Restores screen in a split from middle fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_SPLIT(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a split from middle
³  fashion. <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  is a delay factor. Default is 5. (Larger #
³  is faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_SPLIT(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_FOLD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_FOLD() Restores screen in a fold to middle fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_FOLD(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a fold to middle
³  fashion. <cInscreen>
³ 
³  is a screen saved with SAVESCREEN(). <nTop>,
³  <nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 3. (Larger # is
³  faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_FOLD(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_RISE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_RISE() Restores screen in a rise from bottom fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_RISE(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a rise from bottom
³  fashion. <cInscreen>
³ 
³  is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  is a delay factor. Default is 100. (Smaller
³  # is faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_RISE(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_FALL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_FALL() Restores screen in a fall from top fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_FALL(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a fall from top
³  fashion. <cInscreen>
³ 
³  is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 100. (Smaller # is
³  faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_FALL(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FADEAWAY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FADEAWAY() Fades screen away , alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  FADEAWAY(cInScreen,nTop,nLeft,nBottom,nRight)
³ 
³  Description:
³  ------------
³  Fades <cInscreen>, a screen stored with SAVESCREEN(),
³  back onto the screen at <nTop>,<nLeft>,<nBottom>,<nRight>. Here
³  for compatibility. See SS_FADE().
³ 
³  Examples:
³  ---------
³   See SS_FADE()
³ 
³  Source:
³  -------
³  S_SCREEN.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function fadeaway(cInScreen,nTop,nLeft,nBottom,nRight)
ss_fade(nTop,nLeft,nBottom,nRight,cInScreen)
return nil
//------------------------------------------------------------------

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_FADE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_FADE() Restores screen in a fadeaway fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_FADE(nTop,nLeft,nBottom,nRight,cInScreen)
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a fadeaway fashion.
³  <cInscreen>
³ 
³  is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_FADE(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_SLIDELEFT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_SLIDELEFT() Restores screen in a slide left fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_SLIDELEFT(nTop,nLeft,nBottom,nRight,cInScreen)
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a slide left fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>,<nRight> are the screen coordinates.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_SLIDELEFT(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_CLOSEH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_CLOSEH() Restores screen in a horizontal close fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_CLOSEH(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a close from top and
³  bottom fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
³ 
³  [nDelay]  is a delay factor. Default is 100. (Smaller
³  # is faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³   DOSOMESCREENSTUFF()
³   DOMORESCREENSTUFF()
³   SS_CLOSEH(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_CLOSEV()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_CLOSEV() Restores screen in a vertical close fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_CLOSEV(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a close from left and
³  right fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 50. (Smaller # is
³  faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³   DOSOMESCREENSTUFF()
³   DOMORESCREENSTUFF()
³   SS_CLOSEV(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_IMPLODE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_IMPLODE() Restores screen in an imploding fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_IMPLODE(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in an imploding fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 100. (Smaller # is
³  faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_IMPLODE(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_WIPEH()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_WIPEH() Restores screen in a wipe from left fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_WIPEH(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a wipe fromleft
³  fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
³ 
³  [nDelay]  delay factor. Default is 100. (Smaller # is
³  faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_WIPEH(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SS_WIPEV()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SS_WIPEV() Restores screen in a wipe from top fashion.
³  Alternative to restscreen()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SS_WIPEV(nTop,nLeft,nBottom,nRight,cInScreen,[nDelay])
³ 
³  Description:
³  ------------
³  Restores screen <cInScreen> in a wipe from top
³  fashion.
³ 
³  <cInscreen> is a screen saved with SAVESCREEN().
³  <nTop>,<nLeft>,<nBottom>, <nRight> are the screen coordinates.
³ 
³  [nDelay]  is a delay factor. Default is 50. (Smaller
³  # is faster)
³ 
³  Relative to the speed of the machine.
³ 
³  Examples:
³  ---------
³   MainScreen := savescreen(0,0,24,79)
³ 
³   DOSOMESCREENSTUFF()
³ 
³   DOMORESCREENSTUFF()
³ 
³   SS_WIPEV(0,0,24,79,MainScreen)
³ 
³  Source:
³  -------
³  S_SCREENS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
