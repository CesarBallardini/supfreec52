#include "inkey.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GETAKEY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  GETAKEY() Gets intent of last keystroke
ณ 
ณ  Returns:
ณ  --------
ณ  <cIntent> as key direction (FWD,BWD,ESC,CTW,UNK)
ณ 
ณ  Syntax:
ณ  -------
ณ  GETAKEY(nKeyVal)
ณ 
ณ  Description:
ณ  ------------
ณ  Gives key direction of last key, for evaluating what
ณ  direction in a read the user is heading.
ณ 
ณ  Examples:
ณ  ---------
ณ   If GETAKEY(LASTKEY())=="FWD"
ณ       nActive_field++
ณ   elseif GETAKEY(LASTKEY())=="BWD"
ณ       nActive_field--
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_GETKEY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION getakey(nLastKey)
DO CASE
CASE nLastKey = K_DOWN .OR. nLastKey = K_ENTER  .OR. nLastKey = K_PGDN
  RETURN "FWD"
CASE nLastKey = K_UP  .OR. nLastKey = K_PGUP
  RETURN "BWD"
CASE nLastKey = K_ESC
  RETURN "ESC"
CASE nLastKey = K_CTRL_END
  RETURN "CTW"
OTHERWISE
  RETURN "FWD"
ENDCASE
return ""

