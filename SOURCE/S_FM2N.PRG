//--------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FMOVE2NEXT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FMOVE2NEXT() Move to beginning of next line in a text file
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => success in doing so
ณ 
ณ  Syntax:
ณ  -------
ณ  FMOVE2NEXT(nHandle)
ณ 
ณ  Description:
ณ  ------------
ณ  Moves pointer in text file <nHandle> to beginning of
ณ  next line.
ณ 
ณ  Presuming lines end in CRLF. Returns <expL> for
ณ  success. End of file would return .f.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   // this will list off the text file REPORT.LST to the  screen
ณ 
ณ   h := fopen("report.lst")
ณ   ?SFREADLINE(h)
ณ   while  FMOVE2NEXT(h)
ณ    ?SFREADLINE(h)
ณ   end
ณ 
ณ  Source:
ณ  -------
ณ  S_FM2N.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION fmove2next(nHandle)

local cChunk
local nOldOffset := FSEEK(nHandle,0,1)
local nNewOffset
local nAtChr10
local lSuccess := .f.
DO WHILE .T.

  nNewOffset := FSEEK(nHandle,0,1)
  
  *- read in a cChunk of the file
  cChunk := ''
  cChunk := Freadstr(nHandle,100)
  
  IF LEN(cChunk)=0   // eof()
    lSuccess := .f.
    exit
  ENDIF
  
  *- if we've got a CR , we've read in a line
  *- otherwise we'll loop again and read in another cChunk
  IF (nAtChr10 := AT(CHR(10),cChunk)) > 0
    lSuccess := .t.
    *- go back to beginning of line
    FSEEK(nHandle,nNewOffset)
    FSEEK(nHandle,nAtChr10,1)
    EXIT
  ENDIF
ENDDO
if !lSuccess
  fseek(nHandle,nOldOffset)
endif
RETURN lSuccess
