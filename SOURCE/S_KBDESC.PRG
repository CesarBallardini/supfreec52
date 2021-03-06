/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION KBDESC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  KBDESC() Keyboards character 27 (escape) when key pressed
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SET KEY xxx TO KBDESC
³ 
³  Description:
³  ------------
³  Allows setting an alternate key to the ESCAPE key.
³  ESCAPE normally means 'get me outta here', but sometimes is the
³  key you need to indicate the user is done selecting or some
³  such. This function allows setting another key (e.g. F10) to act
³  as the ESCAPE key.
³ 
³  Examples:
³  ---------
³   SET KEY -9 TO KBDESC
³ 
³  Warnings:
³  ----------
³  Be sure to issue a   SET KEY xxx TO   command to
³  un-map this function when done
³ 
³  Notes:
³  -------
³  Declare as EXTERNAL i.e.
³ 
³  EXTERNAL KBDESC
³ 
³  Source:
³  -------
³  S_KBDESC.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION kbdesc
KEYBOARD CHR(27)
RETURN ''
