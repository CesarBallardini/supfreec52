
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ENHANCED()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ENHANCED() Returns color integer for ENHANCED setting
ณ 
ณ  Returns:
ณ  --------
ณ  <nColor> => color integer for ENHANCED setting
ณ 
ณ  Syntax:
ณ  -------
ณ  ENHANCED()
ณ 
ณ  Description:
ณ  ------------
ณ  Gets the 2nd part of the color string and converts it
ณ  to color INTEGER
ณ
ณ  Examples:
ณ  ---------
ณ   nEnh := ENHANCED()
ณ   ATT(10,10,10,20,nEnh)
ณ
ณ  Notes:
ณ  -------
ณ  See appendix for more info on Super.Lib color usage
ณ
ณ
ณ  Source:
ณ  -------
ณ  S_ENHAN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION enhanced
local cColorsFore := "N...B...G...BG..R...BR..GR..W...N+..B+..G+..BG+.R+..BR+.GR+.W+.."
local cColorsBack := "N...B...G...BG..R...BR..GR..W...N*..B*..G*..BG*.R*..BR*.GR*.W*.."
local cSetcolor   := takeout(Setcolor(),",",2)
local cForeGround := takeout(cSetcolor,"/",1)
local cBackGround := takeout(cSetcolor,"/",2)
local nForeGround := int((AT(cForeGround,cColorsFore)-1)/4)
local nBackGround := int(((AT(cBackGround,cColorsBack)-1)/4)*16)

RETURN (nBackGround+nForeGround)

