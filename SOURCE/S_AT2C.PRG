/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AT2CHAR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AT2CHAR() Returns the String color equivalent of a color number
ณ 
ณ  Returns:
ณ  --------
ณ  <cColorString> => Color string
ณ 
ณ  Syntax:
ณ  -------
ณ  AT2CHAR(nColorAttribute)
ณ 
ณ  Description:
ณ  ------------
ณ  <nColorAttribute> the numeric color to be converted,
ณ  is changed to <cColorString>, a clipper color string.
ณ 
ณ  Examples:
ณ  ---------
ณ   AT2CHAR(47)  // =>  "W/G"
ณ 
ณ  Source:
ณ  -------
ณ  S_AT2C.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function At2char(nColor)
local aFore   := {"N","B","G","BG","R","RB","GR","W",;
                  "N+","B+","G+","BG+","R+","RB+","GR+","W+"}
local aBack   := {"N","B","G","BG","R","RB","GR","W",;
                  "N*","B*","G*","BG*","R*","RB*","GR*","W*"}
local nFore         := nColor%16
local nBack         := INT(nColor/16)
local cForeground   := aFore[nFore+1]
local cBackGround   := aBack[nBack+1]
return ( cForeground+'/'+cBackGround )
