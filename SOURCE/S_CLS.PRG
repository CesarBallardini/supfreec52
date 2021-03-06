/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CLS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CLS() Clear the screen with optional color,character
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  CLS([nAttribute],[cChar])
³ 
³  Description:
³  ------------
³  Clear the screen.
³
³  Optional color [nAttribute] and character [cChar].
³ 
³  Examples:
³  ---------
³   CLS()   // clears screen with current color
³ 
³   CLS(48) // clears screen with black on cyan
³ 
³   CLS(8,chr(177))  // clears screen grey on black
³                    // with character 177
³ 
³  Notes:
³  -------
³  Of course in Clipper 5.01 you can also do:
³  dispbox(0,0,24,79,repl(chr(177),9),"+N/N") and get the same
³  result.
³
³
³  Source:
³  -------
³  S_CLS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION cls(ncColorAtt,cFillCharacter)
local cColorString
cColorString   := iif(valtype(ncColorAtt)=="N",at2char(ncColorAtt),ncColorAtt)
cFillCharacter := repl( iif(cFillCharacter#nil,cFillCharacter," "),9 )
dispbox(0,0,maxrow(),maxcol(),cFillCharacter,cColorString)
RETURN ''

