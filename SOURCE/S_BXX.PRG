#define SHADOW_LOWER_LEFT 1
#define SHADOW_LOWER_RIGHT 3
#define SHADOW_UPPER_LEFT  7
#define SHADOW_UPPER_RIGHT 9

/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION BXX()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  BXX() Draws a box on the screen of a given color
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  Bxx(nTop,nLeft,nBottom,nRight,[nColor],[nShadow],;
�                      [nShadowColor],[cFrame])
� 
�  Description:
�  ------------
�  <nTop >      - top row
�  <nLeft>      - left col
�  <nBottom>    - bottom row
�  <nRight>     - right column
�  [nColor]     - attribute to box default setcolor()
�  [nShadow]    - numeric shadow type  (default 0)
�                        follow numeric keypad
�                            7 = upper left
�                            1 = lower left
�                            3 = lower right
�                            9 = upper right
�                            0 = no shadow
�
�  [nShadowColor] - shadow attribute (default 7 - grey
�  on black)
�
�  [cFrame ] - frame string - MUST be 9 characters -
�  default single line
�
�  Examples:
�  ---------
�   BXX(10,10,20,20,47,9,8,"敖審拂棲 ")
�
�  Source:
�  -------
�  S_BXX.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
function bxx(nTop,nLeft,nBottom,nRight,nAttribute,;
             nShadowPosition,nShadowAttribute,cFrame)

local cColorString
if valtype(nAttribute)=="C"
   cColorString := nAttribute
elseif valtype(nAttribute)=="N"
   cColorString := at2char(nAttribute)
else
   cColorString := setcolor()
endif

if valtype(cFrame)#"C"
  cFrame="敖審拂棲 "
elseif empty(cFrame)
  cFrame="         "
endif
if valtype(nShadowPosition)#"N"
  nShadowPosition = 0
endif
if valtype(nShadowAttribute)#"N"
  nShadowAttribute = 8
endif

dispbox(nTop,nLeft,nBottom,nRight,cFrame,cColorString)

DO CASE
CASE nShadowPos = SHADOW_LOWER_LEFT .and. nBottom <Maxrow() .and. nLeft > 0
   att(nTop+1,nLeft-1,nBottom+1,nLeft-1,nShadowAtt)
   att(nBottom+1,nLeft-1,nBottom+1,nRight-1,nShadowAtt)
CASE nShadowPos = SHADOW_LOWER_RIGHT .and. nBottom <Maxrow() .and. nRight < Maxcol()
   att(nBottom+1,nLeft+1,nBottom+1,nRight+1,nShadowAtt)
   att(nTop+1,nRight+1,nBottom+1,nRight+1,nShadowAtt)
CASE nShadowPos = SHADOW_UPPER_RIGHT .and. nTop > 0 .and. nRight < Maxcol()
   att(nTop-1,nLeft+1,nTop-1,nRight+1,nShadowAtt)
   att(nTop,nRight+1,nBottom-1,nRight+1,nShadowAtt)
CASE nShadowPos = SHADOW_UPPER_LEFT .and. nTop > 0 .and. nLeft > 0
   att(nTop-1,nLeft-1,nTop-1,nRight-1,nShadowAtt)
   att(nTop,nLeft-1,nBottom-1,nLeft-1,nShadowAtt)
ENDCASE
return ''
