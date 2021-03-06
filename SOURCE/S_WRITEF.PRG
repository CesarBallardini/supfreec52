/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION WRITEFILE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  WRITEFILE() Writes a line or lines  to a text file
³ 
³  Returns:
³  --------
³  nothing
³ 
³  Syntax:
³  -------
³  Writefile(cFileName|n|FileHandle,cText|aText)
³ 
³  Description:
³  ------------
³  Writes line(s) of text with CR LF to a file
³  referenced either as a file handle <nFileHandle> or a file
³  name <cFileName>.
³ 
³  Writes either a single line contained in <cText> or all of the
³  contents of array <aText> to the file.
³ 
³  Examples:
³  ---------
³   1. WRITEFILE('ERROR.TXT','THERE WAS AN ERROR')
³ 
³   2. aErrors := array(3)
³      aErrors[1] = 'There was an error'
³      aErrors[2] = 'Error # 61765  '
³      aErrors[3] = dtoc(date)
³      writefile('ERROR.TXT',aErrors)
³ 
³   3. nHandle := fopen("error.txt",1)
³      aErrors := array(3)
³      aErrors[1] = 'There was an error'
³      aErrors[2] = 'Error # 61765  '
³      aErrors[3] = dtoc(date)
³      writefile(nHandle,aErrors)
³ 
³  Notes:
³  -------
³  If a filename is passed, the file is opened and
³  closed by the function.
³ 
³  If a file handle is passed, the file is left open. If
³  the file does not exist, it is created.
³ 
³  PREVIOUSLY AN ARRAY NAME WAS PASSED. THIS MUST NOW BE
³  AN ARRAY.
³ 
³  Source:
³  -------
³  S_WRITEF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION writefile(cnFile,caWrite)
local nFileHandle,nIter,nArrayLen


* open file and position pointer at the end of file
IF VALTYPE(cnFile)=="C"
  nFileHandle := FOPEN(cnFile,2)
  *- if not joy opening file, create one
  IF Ferror() <> 0
    nFileHandle := Fcreate(cnFile,0)
  ENDIF
  FSEEK(nFileHandle,0,2)
ELSE
  nFileHandle := cnFile
  FSEEK(nFileHandle,0,2)
ENDIF

IF VALTYPE(caWrite) == "A"
  nArrayLen = aleng(caWrite)
  * if its an array, do a loop to write it out
  FOR nIter = 1 TO nArrayLen
    *- append a CR/LF
    FWRITE(nFileHandle,caWrite[nIter]+CHR(13)+CHR(10) )
  NEXT
ELSE
  * must be a character string - just write it
  FWRITE(nFileHandle,caWrite+CHR(13)+CHR(10) )
ENDIF

* close the file
IF VALTYPE(cnFile)=="C"
  Fclose(nFileHandle)
ENDIF
RETURN .T.
