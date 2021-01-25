#define SHADOW_LOWER_LEFT 1
#define SHADOW_LOWER_RIGHT 3
#define SHADOW_UPPER_LEFT  7
#define SHADOW_UPPER_RIGHT 9

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BXX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BXX() Draws a box on the screen of a given color
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  Bxx(nTop,nLeft,nBottom,nRight,[nColor],[nShadow],;
ณ                      [nShadowColor],[cFrame])
ณ 
ณ  Description:
ณ  ------------
ณ  <nTop >      - top row
ณ  <nLeft>      - left col
ณ  <nBottom>    - bottom row
ณ  <nRight>     - right column
ณ  [nColor]     - attribute to box default setcolor()
ณ  [nShadow]    - numeric shadow type  (default 0)
ณ                        follow numeric keypad
ณ                            7 = upper left
ณ                            1 = lower left
ณ                            3 = lower right
ณ                            9 = upper right
ณ                            0 = no shadow
ณ
ณ  [nShadowColor] - shadow attribute (default 7 - grey
ณ  on black)
ณ
ณ  [cFrame ] - frame string - MUST be 9 characters -
ณ  default single line
ณ
ณ  Examples:
ณ  ---------
ณ   BXX(10,10,20,20,47,9,8,"ฺฤฟณูฤภณ ")
ณ
ณ  Source:
ณ  -------
ณ  S_BXX.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
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
  cFrame="ฺฤฟณูฤภณ "
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
