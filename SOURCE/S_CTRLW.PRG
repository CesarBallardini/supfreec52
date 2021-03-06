/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CTRLW()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CTRLW() Sends chr(23) (Control-W) to the keyboard
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SET KEY XXX to CTRLW
³ 
³  Description:
³  ------------
³  Allows remapping a key to Ctrl-W - a common Clipper
³  EXIT key. CTRL-W is not a really intuitive key, but is often
³  required by Clipper. I'll often set F10 to act as Ctrl-W.
³ 
³  Examples:
³  ---------
³   EXTERNAL CTRLW
³ 
³   SET KEY 27 to CTRLW  // remaps ESCAPE to CTRL-W
³   also
³   SETKEY(K_F10,{||ctrlw()})
³ 
³  Notes:
³  -------
³  Declare as EXTERNAL i.e. EXTERNAL CTRLW
³ 
³  Source:
³  -------
³  S_CTRLW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION ctrlw
KEYBOARD CHR(23)
RETURN ''
