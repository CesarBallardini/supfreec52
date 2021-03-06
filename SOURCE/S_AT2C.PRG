/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AT2CHAR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AT2CHAR() Returns the String color equivalent of a color number
³ 
³  Returns:
³  --------
³  <cColorString> => Color string
³ 
³  Syntax:
³  -------
³  AT2CHAR(nColorAttribute)
³ 
³  Description:
³  ------------
³  <nColorAttribute> the numeric color to be converted,
³  is changed to <cColorString>, a clipper color string.
³ 
³  Examples:
³  ---------
³   AT2CHAR(47)  // =>  "W/G"
³ 
³  Source:
³  -------
³  S_AT2C.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
