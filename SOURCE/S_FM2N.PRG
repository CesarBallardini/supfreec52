//--------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FMOVE2NEXT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FMOVE2NEXT() Move to beginning of next line in a text file
³ 
³  Returns:
³  --------
³  <lSuccess> => success in doing so
³ 
³  Syntax:
³  -------
³  FMOVE2NEXT(nHandle)
³ 
³  Description:
³  ------------
³  Moves pointer in text file <nHandle> to beginning of
³  next line.
³ 
³  Presuming lines end in CRLF. Returns <expL> for
³  success. End of file would return .f.
³ 
³  Examples:
³  ---------
³ 
³   // this will list off the text file REPORT.LST to the  screen
³ 
³   h := fopen("report.lst")
³   ?SFREADLINE(h)
³   while  FMOVE2NEXT(h)
³    ?SFREADLINE(h)
³   end
³ 
³  Source:
³  -------
³  S_FM2N.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
