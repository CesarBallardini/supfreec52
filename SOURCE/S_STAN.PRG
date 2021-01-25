/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION STANDARD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  STANDARD() Returns color integer for standard setting
ณ 
ณ  Returns:
ณ  --------
ณ  <nColor> => color integer for standard color setting
ณ 
ณ  Syntax:
ณ  -------
ณ  STANDARD()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns numeric color integer for use with functions
ณ  which require it like ATT(), PRNT().
ณ
ณ  Examples:
ณ  ---------
ณ   nStan := standard()+128   && blinking
ณ
ณ   PRNT(10,10,"Waiting...",nStan)
ณ
ณ
ณ  Source:
ณ  -------
ณ  S_STAN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION standard
local cColorsFore := "N...B...G...BG..R...BR..GR..W...N+..B+..G+..BG+.R+..BR+.GR+.W+.."
local cColorsBack := "N...B...G...BG..R...BR..GR..W...N*..B*..G*..BG*.R*..BR*.GR*.W*.."
local cSetcolor   := takeout(Setcolor(),",",1)
local cForeGround := takeout(cSetcolor,"/",1)
local cBackGround := takeout(cSetcolor,"/",2)
local nForeGround := int((AT(cForeGround,cColorsFore)-1)/4)
local nBackGround := int(((AT(cBackGround,cColorsBack)-1)/4)*16)
RETURN INT((nBackGround+nForeGround))
