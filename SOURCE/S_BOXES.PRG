
//----------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SBCENTER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SBCENTER() Centers box coordinates
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
³ 
³  Description:
³  ------------
³  Dimensions nTop,nLeft,nBottom,nRight are passed by
³  reference.
³ 
³  They are changed by SBCENTER to dimensions that are
³  centered on the screen.
³ 
³  Examples:
³  ---------
³ 
³   nTop    := 0
³   nLeft   := 0
³   nBottom := nRows+2
³   nRight  := nMaxwidth+2
³ 
³   SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
³                  // center the coordinates
³ 
³   cBox := makebox(nTop,nLeft,nBottom,nRight)
³ 
³  Source:
³  -------
³  S_BOXES.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SBROWS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SBROWS() Determine number of rows in a box
³ 
³  Returns:
³  --------
³  <nRows> => rows in the box
³ 
³  Syntax:
³  -------
³  SBROWS(nTop,nBottom,[lIncludeFrame])
³ 
³  Description:
³  ------------
³  The number of rows of a box with top of <nTop> and
³  bottom of <nBottom> is returned. By default, the frame is
³  included (the top and the bottom)
³ 
³  [lIncludeFrame] by default is True - and all rows are
³  counted. If passed as False, only the inside rows are counted.
³ 
³  Examples:
³  ---------
³   nRows := SBROWS(nTop,nBottom,.f.)
³   for i = nTop to nRows
³     @nTop+i,nLeft say i
³   next
³ 
³  Source:
³  -------
³  S_BOXES.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function sbRows(nTop,nBottom,lFrame)
lFrame := iif(lFrame#nil,lFrame,.t.)
return nBottom-nTop+iif(lFrame,1,-1)

//----------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SBCOLS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SBCOLS() Determine number of columns in a box
³ 
³  Returns:
³  --------
³  <nCols> => columns in the box
³ 
³  Syntax:
³  -------
³  SBCOLS(nLeft,nRight,[lIncludeFrame])
³ 
³  Description:
³  ------------
³  The number of columns of a box with left of <nLeft>
³  and right of <nRight> is returned. By default, the frame is
³  included (the left and the right)
³ 
³  [lIncludeFrame] by default is True - and all columns
³  are counted. If passed as False, only the inside columns are
³  counted.
³ 
³  Examples:
³  ---------
³   // this example fills a box with "X"'s
³ 
³   nRows := SBROWS(nTop,nBottom,.f.)
³   nCols := SBCOLS(nLeft,nRight,.f.)
³   for i = nTop to nRows
³     @nTop+i,nLeft say repl("X",nCols)
³   next
³ 
³  Source:
³  -------
³  S_BOXES.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SBSHADOW()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SBSHADOW() Draw a shadow around a box
³ 
³  Returns:
³  --------
³  <aSaved> => an array containing the two saved screen
³  sections
³ 
³  Syntax:
³  -------
³  SBSHADOW(nTop,nLeft,nBottom,nRight,nShadowPos,nShadowAtt)
³ 
³  Description:
³  ------------
³  Draws a shadow for box described in coordinates
³  <nTop,nLeft,nBotton,nRight>
³ 
³  The shadow is of color <nShadowAtt> and is at
³  position <nShadowPos>, which is one of the following:
³ 
³      LOWER LEFT    1
³      LOWER RIGHT   3
³      UPPER LEFT    7
³      UPPER RIGHT   9
³ 
³  Returns an array with the saved screens for each side
³  of the shadow.
³ 
³  This array can be passed to SBUNSHADOW() for
³  restoring the previous screen.
³ 
³  Examples:
³  ---------
³   Dispbox(10,10,20,20)
³   aSaved := sbshadow(10,10,20,20,3,8)
³              // draws a shadow in the lower right
³              // of color gray on black
³   sbunshadow(aSaved)         // restore old screen
³ 
³  ^Notes
³ 
³ 
³  Source:
³  -------
³  S_BOXES.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SBUNSHADOW()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SBUNSHADOW() Removes shadow drawn with SBSHADOW()
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  SBUNSHADOW(aSaved)
³ 
³  Description:
³  ------------
³  Removes a shadow around a box created with
³  SBSHADOW(). SBSHADOW() returns an array containing the
³  coordinates and saved screens for each side of the shadow.
³  SBUNSHADOW uses this array to restore the previous screens.
³ 
³  Examples:
³  ---------
³   Dispbox(10,10,20,20)
³   aSaved := sbshadow(10,10,20,20,3,8)
³             // draws a shadow in the lower right
³                              // of color gray on black
³   sbunshadow(aSaved)         // restore old screen
³ 
³  Source:
³  -------
³  S_BOXES.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function sbunshadow(aSaved)
if aSaved#nil
  restscreen(aSaved[1,1],aSaved[1,2],aSaved[1,3],aSaved[1,4],aSaved[1,5])
  restscreen(aSaved[2,1],aSaved[2,2],aSaved[2,3],aSaved[2,4],aSaved[2,5])
endif
return nil

