//--------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SFREADLINE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SFREADLINE() Reads in text up to the next CRLF in a text file
³ 
³  Returns:
³  --------
³  <cLine> => line read in
³ 
³  Syntax:
³  -------
³  SFREADLINE(nHandle)
³ 
³  Description:
³  ------------
³  Reads in text up to the next CRLF in a text file. The
³  pointer is moved back to the starting position when done. To move to a
³  new line, use  FMOVE2PRIOR() or FMOVE2NEXT().
³ 
³  Examples:
³  ---------
³   nHandle := fopen("Report.doc")
³ 
³   ?sfreadline(handle)
³   while fmove2next(handle)
³     ?sfreadline(handle)
³   end
³ 
³  Source:
³  -------
³  S_FREADL.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION sfreadline(nHandle)

local cReturnLine,cChunk,cBigChunk,nOldOffset,nAtChr13

cReturnLine := ''
cBigChunk   := ''
nOldOffset  := FSEEK(nHandle,0,1)
DO WHILE .T.
  
  *- read in a cChunk of the file
  cChunk := ''
  cChunk := Freadstr(nHandle,100)
  
  IF LEN(cChunk)=0
    cReturnLine := cBigChunk
    exit
  ENDIF
  
  *- add this cChunk to the big cChunk
  cBigChunk += cChunk
  
  *- if we've got a CR , we've read in a line
  *- otherwise we'll loop again and read in another cChunk
  IF (nAtChr13 := AT(CHR(13),cBigChunk)) > 0
    
    *- go back to beginning of line
    FSEEK(nHandle,nOldOffset)
    
    *- read in from here to next CR (-1)
    cReturnLine := Freadstr(nHandle,nAtChr13-1)
    
    *- move the pointer 1 byte
    FSEEK(nHandle,1,1)
    
    EXIT
  ENDIF
ENDDO
fseek(nHandle,nOldOffset)
RETURN cReturnLine  // if len(cReturnline)==0, is EOF!
