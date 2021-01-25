
//----------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SBCENTER()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SBCENTER() Centers box coordinates
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
� 
�  Description:
�  ------------
�  Dimensions nTop,nLeft,nBottom,nRight are passed by
�  reference.
� 
�  They are changed by SBCENTER to dimensions that are
�  centered on the screen.
� 
�  Examples:
�  ---------
� 
�   nTop    := 0
�   nLeft   := 0
�   nBottom := nRows+2
�   nRight  := nMaxwidth+2
� 
�   SBCENTER(@nTop,@nLeft,@nBottom,@nRight)
�                  // center the coordinates
� 
�   cBox := makebox(nTop,nLeft,nBottom,nRight)
� 
�  Source:
�  -------
�  S_BOXES.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SBROWS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SBROWS() Determine number of rows in a box
� 
�  Returns:
�  --------
�  <nRows> => rows in the box
� 
�  Syntax:
�  -------
�  SBROWS(nTop,nBottom,[lIncludeFrame])
� 
�  Description:
�  ------------
�  The number of rows of a box with top of <nTop> and
�  bottom of <nBottom> is returned. By default, the frame is
�  included (the top and the bottom)
� 
�  [lIncludeFrame] by default is True - and all rows are
�  counted. If passed as False, only the inside rows are counted.
� 
�  Examples:
�  ---------
�   nRows := SBROWS(nTop,nBottom,.f.)
�   for i = nTop to nRows
�     @nTop+i,nLeft say i
�   next
� 
�  Source:
�  -------
�  S_BOXES.PRG
� 
����������������������������������������������������������������� 
*/
function sbRows(nTop,nBottom,lFrame)
lFrame := iif(lFrame#nil,lFrame,.t.)
return nBottom-nTop+iif(lFrame,1,-1)

//----------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SBCOLS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SBCOLS() Determine number of columns in a box
� 
�  Returns:
�  --------
�  <nCols> => columns in the box
� 
�  Syntax:
�  -------
�  SBCOLS(nLeft,nRight,[lIncludeFrame])
� 
�  Description:
�  ------------
�  The number of columns of a box with left of <nLeft>
�  and right of <nRight> is returned. By default, the frame is
�  included (the left and the right)
� 
�  [lIncludeFrame] by default is True - and all columns
�  are counted. If passed as False, only the inside columns are
�  counted.
� 
�  Examples:
�  ---------
�   // this example fills a box with "X"'s
� 
�   nRows := SBROWS(nTop,nBottom,.f.)
�   nCols := SBCOLS(nLeft,nRight,.f.)
�   for i = nTop to nRows
�     @nTop+i,nLeft say repl("X",nCols)
�   next
� 
�  Source:
�  -------
�  S_BOXES.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SBSHADOW()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SBSHADOW() Draw a shadow around a box
� 
�  Returns:
�  --------
�  <aSaved> => an array containing the two saved screen
�  sections
� 
�  Syntax:
�  -------
�  SBSHADOW(nTop,nLeft,nBottom,nRight,nShadowPos,nShadowAtt)
� 
�  Description:
�  ------------
�  Draws a shadow for box described in coordinates
�  <nTop,nLeft,nBotton,nRight>
� 
�  The shadow is of color <nShadowAtt> and is at
�  position <nShadowPos>, which is one of the following:
� 
�      LOWER LEFT    1
�      LOWER RIGHT   3
�      UPPER LEFT    7
�      UPPER RIGHT   9
� 
�  Returns an array with the saved screens for each side
�  of the shadow.
� 
�  This array can be passed to SBUNSHADOW() for
�  restoring the previous screen.
� 
�  Examples:
�  ---------
�   Dispbox(10,10,20,20)
�   aSaved := sbshadow(10,10,20,20,3,8)
�              // draws a shadow in the lower right
�              // of color gray on black
�   sbunshadow(aSaved)         // restore old screen
� 
�  ^Notes
� 
� 
�  Source:
�  -------
�  S_BOXES.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SBUNSHADOW()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SBUNSHADOW() Removes shadow drawn with SBSHADOW()
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  SBUNSHADOW(aSaved)
� 
�  Description:
�  ------------
�  Removes a shadow around a box created with
�  SBSHADOW(). SBSHADOW() returns an array containing the
�  coordinates and saved screens for each side of the shadow.
�  SBUNSHADOW uses this array to restore the previous screens.
� 
�  Examples:
�  ---------
�   Dispbox(10,10,20,20)
�   aSaved := sbshadow(10,10,20,20,3,8)
�             // draws a shadow in the lower right
�                              // of color gray on black
�   sbunshadow(aSaved)         // restore old screen
� 
�  Source:
�  -------
�  S_BOXES.PRG
� 
����������������������������������������������������������������� 
*/
function sbunshadow(aSaved)
if aSaved#nil
  restscreen(aSaved[1,1],aSaved[1,2],aSaved[1,3],aSaved[1,4],aSaved[1,5])
  restscreen(aSaved[2,1],aSaved[2,2],aSaved[2,3],aSaved[2,4],aSaved[2,5])
endif
return nil
