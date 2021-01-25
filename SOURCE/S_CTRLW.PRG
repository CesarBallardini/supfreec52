/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CTRLW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CTRLW() Sends chr(23) (Control-W) to the keyboard
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SET KEY XXX to CTRLW
ณ 
ณ  Description:
ณ  ------------
ณ  Allows remapping a key to Ctrl-W - a common Clipper
ณ  EXIT key. CTRL-W is not a really intuitive key, but is often
ณ  required by Clipper. I'll often set F10 to act as Ctrl-W.
ณ 
ณ  Examples:
ณ  ---------
ณ   EXTERNAL CTRLW
ณ 
ณ   SET KEY 27 to CTRLW  // remaps ESCAPE to CTRL-W
ณ   also
ณ   SETKEY(K_F10,{||ctrlw()})
ณ 
ณ  Notes:
ณ  -------
ณ  Declare as EXTERNAL i.e. EXTERNAL CTRLW
ณ 
ณ  Source:
ณ  -------
ณ  S_CTRLW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ctrlw
KEYBOARD CHR(23)
RETURN ''
