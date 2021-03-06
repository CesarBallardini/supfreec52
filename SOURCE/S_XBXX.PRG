#define SHADOW_LOWER_LEFT 1
#define SHADOW_LOWER_RIGHT 3
#define SHADOW_UPPER_LEFT  7
#define SHADOW_UPPER_RIGHT 9

/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION XBXX()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  XBXX() Draws an exploding box on the screen of a given color
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  XBxx(nTop,nLeft,nBottom,nRight,[nColor],[nShadow];
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
�                    follow numeric keypad
�                        7 = upper left
�                        1 = lower left
�                        3 = lower right
�                        9 = upper right
�                        0 = no shadow
� 
�  [nShadowColor]   - shadow attribute (default 7 - grey on black)
� 
�  [cFrame ]    - frame string - MUST be 9 characters - default single line
� 
�  Examples:
�  ---------
�   XBXX(10,10,20,20,47,9,8)
� 
�  Notes:
�  -------
�  Previously a 'C' function, now Clipper 5.01.
� 
� 
� 
�  Source:
�  -------
�  S_XBXX.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
*/
Function Xbxx(nTop,nLeft,nBottom,nRight,nAttribute,nShadowPos,nShadowAtt,cFrame)
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
if valtype(nShadowPos)#"N"
  nShadowPos = 0
endif
if valtype(nShadowAtt)#"N"
  nShadowAtt = 8
endif

xbxxplode(nTop,nLeft,nBottom,nRight,cColorString)
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
return nil


static function xbxxplode(nTop,nLeft,nBottom,nRight,cColorString)

local nXTop,nXLeft,nXBottom,nXRight
nXTop    := int((nBottom-nTop)/2)
nXBottom := nXTop
nXRight  := int((nRight-nLeft)/2)
nXLeft   := nXRight

do while nXTop > nTop .and. nXBottom < nBottom .and. ;
         nXLeft > nLeft .and. nXRight < nRight
   dispbox(nXTop,nXLeft,nXBottom,nXRight,space(9),cColorString)
   nXTop    := nXTop-1
   nXBottom := nXBottom+1
   nXLeft   := nXLeft-1
   nXRight  := nXRight+1
enddo
return nil
