/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION UNSELECTED()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  UNSELECTED() Returns color integer for UNSELECTED setting
ณ 
ณ  Returns:
ณ  --------
ณ  <nColor> => numeric color integer for unselected
ณ  color setting
ณ 
ณ  Syntax:
ณ  -------
ณ  UNSELECTED()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns numeric color integer for use with functions
ณ  which require it
ณ
ณ  like ATT(), PRNT().
ณ
ณ  Examples:
ณ  ---------
ณ   nUnsel = UNSELECTED()
ณ
ณ   PRNT(10,10,"Waiting...",nUnsel)
ณ
ณ  Notes:
ณ  -------
ณ
ณ  Source:
ณ  -------
ณ  S_UNSEL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION unselected
local cColorsFore := "N...B...G...BG..R...BR..GR..W...N+..B+..G+..BG+.R+..BR+.GR+.W+.."
local cColorsBack := "N...B...G...BG..R...BR..GR..W...N*..B*..G*..BG*.R*..BR*.GR*.W*.."
local cSetcolor   := takeout(Setcolor(),",",5)
local cForeGround := takeout(cSetcolor,"/",1)
local cBackGround := takeout(cSetcolor,"/",2)
local nForeGround := int((AT(cForeGround,cColorsFore)-1)/4)
local nBackGround := int(((AT(cBackGround,cColorsBack)-1)/4)*16)
RETURN INT((nBackGround+nForeGround))

