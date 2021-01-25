
//----------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SBCENTER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SBCENTER() Centers box coordinates
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
ณ 
ณ  Description:
ณ  ------------
ณ  Dimensions nTop,nLeft,nBottom,nRight are passed by
ณ  reference.
ณ 
ณ  They are changed by SBCENTER to dimensions that are
ณ  centered on the screen.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   nTop    := 0
ณ   nLeft   := 0
ณ   nBottom := nRows+2
ณ   nRight  := nMaxwidth+2
ณ 
ณ   SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
ณ                  // center the coordinates
ณ 
ณ   cBox := makebox(nTop,nLeft,nBottom,nRight)
ณ 
ณ  Source:
ณ  -------
ณ  S_BOXES.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sbCenter(nTop,nLeft,nBottom,nRight)
local nRows,nCols
nRows := sbRows(nTop,nBottom)
nCols := sbCols(nLeft,nRight)
nTop  := int( (maxrow()-nRows)/2)
nBottom  := nTop+nRows-1
nLeft := int( (maxcol()-nCols)/2)
nRight := nLeft+nCols-1
return nil

//----------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SBROWS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SBROWS() Determine number of rows in a box
ณ 
ณ  Returns:
ณ  --------
ณ  <nRows> => rows in the box
ณ 
ณ  Syntax:
ณ  -------
ณ  SBROWS(nTop,nBottom,[lIncludeFrame])
ณ 
ณ  Description:
ณ  ------------
ณ  The number of rows of a box with top of <nTop> and
ณ  bottom of <nBottom> is returned. By default, the frame is
ณ  included (the top and the bottom)
ณ 
ณ  [lIncludeFrame] by default is True - and all rows are
ณ  counted. If passed as False, only the inside rows are counted.
ณ 
ณ  Examples:
ณ  ---------
ณ   nRows := SBROWS(nTop,nBottom,.f.)
ณ   for i = nTop to nRows
ณ     @nTop+i,nLeft say i
ณ   next
ณ 
ณ  Source:
ณ  -------
ณ  S_BOXES.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sbRows(nTop,nBottom,lFrame)
lFrame := iif(lFrame#nil,lFrame,.t.)
return nBottom-nTop+iif(lFrame,1,-1)

//----------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SBCOLS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SBCOLS() Determine number of columns in a box
ณ 
ณ  Returns:
ณ  --------
ณ  <nCols> => columns in the box
ณ 
ณ  Syntax:
ณ  -------
ณ  SBCOLS(nLeft,nRight,[lIncludeFrame])
ณ 
ณ  Description:
ณ  ------------
ณ  The number of columns of a box with left of <nLeft>
ณ  and right of <nRight> is returned. By default, the frame is
ณ  included (the left and the right)
ณ 
ณ  [lIncludeFrame] by default is True - and all columns
ณ  are counted. If passed as False, only the inside columns are
ณ  counted.
ณ 
ณ  Examples:
ณ  ---------
ณ   // this example fills a box with "X"'s
ณ 
ณ   nRows := SBROWS(nTop,nBottom,.f.)
ณ   nCols := SBCOLS(nLeft,nRight,.f.)
ณ   for i = nTop to nRows
ณ     @nTop+i,nLeft say repl("X",nCols)
ณ   next
ณ 
ณ  Source:
ณ  -------
ณ  S_BOXES.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sbCols(nLeft,nRight,lFrame)
lFrame := iif(lFrame#nil,lFrame,.t.)
return nRight-nLeft+iif(lFrame,1,-1)

//----------------------------------------------------------------
#define SHADOW_LOWER_LEFT 1
#define SHADOW_LOWER_RIGHT 3
#define SHADOW_UPPER_LEFT  7
#define SHADOW_UPPER_RIGHT 9

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SBSHADOW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SBSHADOW() Draw a shadow around a box
ณ 
ณ  Returns:
ณ  --------
ณ  <aSaved> => an array containing the two saved screen
ณ  sections
ณ 
ณ  Syntax:
ณ  -------
ณ  SBSHADOW(nTop,nLeft,nBottom,nRight,nShadowPos,nShadowAtt)
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a shadow for box described in coordinates
ณ  <nTop,nLeft,nBotton,nRight>
ณ 
ณ  The shadow is of color <nShadowAtt> and is at
ณ  position <nShadowPos>, which is one of the following:
ณ 
ณ      LOWER LEFT    1
ณ      LOWER RIGHT   3
ณ      UPPER LEFT    7
ณ      UPPER RIGHT   9
ณ 
ณ  Returns an array with the saved screens for each side
ณ  of the shadow.
ณ 
ณ  This array can be passed to SBUNSHADOW() for
ณ  restoring the previous screen.
ณ 
ณ  Examples:
ณ  ---------
ณ   Dispbox(10,10,20,20)
ณ   aSaved := sbshadow(10,10,20,20,3,8)
ณ              // draws a shadow in the lower right
ณ              // of color gray on black
ณ   sbunshadow(aSaved)         // restore old screen
ณ 
ณ  ^Notes
ณ 
ณ 
ณ  Source:
ณ  -------
ณ  S_BOXES.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sbshadow(nTop,nLeft,nBottom,nRight,nShadowPos,nShadowAtt)
local aSaved := array(2)
nShadowAtt := iif(nShadowAtt#nil,nShadowAtt,8)
nShadowPos := iif(nShadowPos#nil,nShadowPos,1)
DO CASE
CASE nShadowPos = SHADOW_LOWER_LEFT .and. nBottom <Maxrow() .and. nLeft > 0
   aSaved[1] := {nTop+1,nLeft-1,nBottom+1,nLeft-1,;
       att(nTop+1,nLeft-1,nBottom+1,nLeft-1,nShadowAtt)}
   aSaved[2] := {nBottom+1,nLeft,nBottom+1,nRight-1,;
       att(nBottom+1,nLeft,nBottom+1,nRight-1,nShadowAtt)}
CASE nShadowPos = SHADOW_LOWER_RIGHT .and. nBottom <Maxrow() .and. nRight < Maxcol()
   aSaved[1] := {nBottom+1,nLeft+1,nBottom+1,nRight+1,;
       att(nBottom+1,nLeft+1,nBottom+1,nRight+1,nShadowAtt)}
   aSaved[2] := {nTop+1,nRight+1,nBottom,nRight+1,;
       att(nTop+1,nRight+1,nBottom,nRight+1,nShadowAtt)}
CASE nShadowPos = SHADOW_UPPER_RIGHT .and. nTop > 0 .and. nRight < Maxcol()
   aSaved[1] := {nTop-1,nLeft+1,nTop-1,nRight+1,;
       att(nTop-1,nLeft+1,nTop-1,nRight+1,nShadowAtt)}
   aSaved[2] := {nTop,nRight+1,nBottom-1,nRight+1,;
       att(nTop,nRight+1,nBottom-1,nRight+1,nShadowAtt)}
CASE nShadowPos = SHADOW_UPPER_LEFT .and. nTop > 0 .and. nLeft > 0
   aSaved[1] := {nTop-1,nLeft-1,nTop-1,nRight-1,;
       att(nTop-1,nLeft-1,nTop-1,nRight-1,nShadowAtt)}
   aSaved[2] := {nTop,nLeft-1,nBottom-1,nLeft-1,;
       att(nTop,nLeft-1,nBottom-1,nLeft-1,nShadowAtt)}
otherwise
   aSaved := nil
ENDCASE
return aSaved

//----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SBUNSHADOW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SBUNSHADOW() Removes shadow drawn with SBSHADOW()
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SBUNSHADOW(aSaved)
ณ 
ณ  Description:
ณ  ------------
ณ  Removes a shadow around a box created with
ณ  SBSHADOW(). SBSHADOW() returns an array containing the
ณ  coordinates and saved screens for each side of the shadow.
ณ  SBUNSHADOW uses this array to restore the previous screens.
ณ 
ณ  Examples:
ณ  ---------
ณ   Dispbox(10,10,20,20)
ณ   aSaved := sbshadow(10,10,20,20,3,8)
ณ             // draws a shadow in the lower right
ณ                              // of color gray on black
ณ   sbunshadow(aSaved)         // restore old screen
ณ 
ณ  Source:
ณ  -------
ณ  S_BOXES.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sbunshadow(aSaved)
if aSaved#nil
  restscreen(aSaved[1,1],aSaved[1,2],aSaved[1,3],aSaved[1,4],aSaved[1,5])
  restscreen(aSaved[2,1],aSaved[2,2],aSaved[2,3],aSaved[2,4],aSaved[2,5])
endif
return nil

