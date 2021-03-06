#include "inkey.ch"
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION GETAKEY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  GETAKEY() Gets intent of last keystroke
³ 
³  Returns:
³  --------
³  <cIntent> as key direction (FWD,BWD,ESC,CTW,UNK)
³ 
³  Syntax:
³  -------
³  GETAKEY(nKeyVal)
³ 
³  Description:
³  ------------
³  Gives key direction of last key, for evaluating what
³  direction in a read the user is heading.
³ 
³  Examples:
³  ---------
³   If GETAKEY(LASTKEY())=="FWD"
³       nActive_field++
³   elseif GETAKEY(LASTKEY())=="BWD"
³       nActive_field--
³   endif
³ 
³  Source:
³  -------
³  S_GETKEY.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

