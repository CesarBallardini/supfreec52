/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CLS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CLS() Clear the screen with optional color,character
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  CLS([nAttribute],[cChar])
ณ 
ณ  Description:
ณ  ------------
ณ  Clear the screen.
ณ
ณ  Optional color [nAttribute] and character [cChar].
ณ 
ณ  Examples:
ณ  ---------
ณ   CLS()   // clears screen with current color
ณ 
ณ   CLS(48) // clears screen with black on cyan
ณ 
ณ   CLS(8,chr(177))  // clears screen grey on black
ณ                    // with character 177
ณ 
ณ  Notes:
ณ  -------
ณ  Of course in Clipper 5.01 you can also do:
ณ  dispbox(0,0,24,79,repl(chr(177),9),"+N/N") and get the same
ณ  result.
ณ
ณ
ณ  Source:
ณ  -------
ณ  S_CLS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION cls(ncColorAtt,cFillCharacter)
local cColorString
cColorString   := iif(valtype(ncColorAtt)=="N",at2char(ncColorAtt),ncColorAtt)
cFillCharacter := repl( iif(cFillCharacter#nil,cFillCharacter," "),9 )
dispbox(0,0,maxrow(),maxcol(),cFillCharacter,cColorString)
RETURN ''

