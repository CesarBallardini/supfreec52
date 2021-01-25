/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION KBDESC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  KBDESC() Keyboards character 27 (escape) when key pressed
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SET KEY xxx TO KBDESC
ณ 
ณ  Description:
ณ  ------------
ณ  Allows setting an alternate key to the ESCAPE key.
ณ  ESCAPE normally means 'get me outta here', but sometimes is the
ณ  key you need to indicate the user is done selecting or some
ณ  such. This function allows setting another key (e.g. F10) to act
ณ  as the ESCAPE key.
ณ 
ณ  Examples:
ณ  ---------
ณ   SET KEY -9 TO KBDESC
ณ 
ณ  Warnings:
ณ  ----------
ณ  Be sure to issue a   SET KEY xxx TO   command to
ณ  un-map this function when done
ณ 
ณ  Notes:
ณ  -------
ณ  Declare as EXTERNAL i.e.
ณ 
ณ  EXTERNAL KBDESC
ณ 
ณ  Source:
ณ  -------
ณ  S_KBDESC.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION kbdesc
KEYBOARD CHR(27)
RETURN ''
