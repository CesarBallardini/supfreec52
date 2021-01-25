/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION WRITEFILE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  WRITEFILE() Writes a line or lines  to a text file
ณ 
ณ  Returns:
ณ  --------
ณ  nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  Writefile(cFileName|n|FileHandle,cText|aText)
ณ 
ณ  Description:
ณ  ------------
ณ  Writes line(s) of text with CR LF to a file
ณ  referenced either as a file handle <nFileHandle> or a file
ณ  name <cFileName>.
ณ 
ณ  Writes either a single line contained in <cText> or all of the
ณ  contents of array <aText> to the file.
ณ 
ณ  Examples:
ณ  ---------
ณ   1. WRITEFILE('ERROR.TXT','THERE WAS AN ERROR')
ณ 
ณ   2. aErrors := array(3)
ณ      aErrors[1] = 'There was an error'
ณ      aErrors[2] = 'Error # 61765  '
ณ      aErrors[3] = dtoc(date)
ณ      writefile('ERROR.TXT',aErrors)
ณ 
ณ   3. nHandle := fopen("error.txt",1)
ณ      aErrors := array(3)
ณ      aErrors[1] = 'There was an error'
ณ      aErrors[2] = 'Error # 61765  '
ณ      aErrors[3] = dtoc(date)
ณ      writefile(nHandle,aErrors)
ณ 
ณ  Notes:
ณ  -------
ณ  If a filename is passed, the file is opened and
ณ  closed by the function.
ณ 
ณ  If a file handle is passed, the file is left open. If
ณ  the file does not exist, it is created.
ณ 
ณ  PREVIOUSLY AN ARRAY NAME WAS PASSED. THIS MUST NOW BE
ณ  AN ARRAY.
ณ 
ณ  Source:
ณ  -------
ณ  S_WRITEF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
