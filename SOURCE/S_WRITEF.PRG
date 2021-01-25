/*
�����������������������������������������������������������������
� FUNCTION WRITEFILE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  WRITEFILE() Writes a line or lines  to a text file
� 
�  Returns:
�  --------
�  nothing
� 
�  Syntax:
�  -------
�  Writefile(cFileName|n|FileHandle,cText|aText)
� 
�  Description:
�  ------------
�  Writes line(s) of text with CR LF to a file
�  referenced either as a file handle <nFileHandle> or a file
�  name <cFileName>.
� 
�  Writes either a single line contained in <cText> or all of the
�  contents of array <aText> to the file.
� 
�  Examples:
�  ---------
�   1. WRITEFILE('ERROR.TXT','THERE WAS AN ERROR')
� 
�   2. aErrors := array(3)
�      aErrors[1] = 'There was an error'
�      aErrors[2] = 'Error # 61765  '
�      aErrors[3] = dtoc(date)
�      writefile('ERROR.TXT',aErrors)
� 
�   3. nHandle := fopen("error.txt",1)
�      aErrors := array(3)
�      aErrors[1] = 'There was an error'
�      aErrors[2] = 'Error # 61765  '
�      aErrors[3] = dtoc(date)
�      writefile(nHandle,aErrors)
� 
�  Notes:
�  -------
�  If a filename is passed, the file is opened and
�  closed by the function.
� 
�  If a file handle is passed, the file is left open. If
�  the file does not exist, it is created.
� 
�  PREVIOUSLY AN ARRAY NAME WAS PASSED. THIS MUST NOW BE
�  AN ARRAY.
� 
�  Source:
�  -------
�  S_WRITEF.PRG
� 
����������������������������������������������������������������� 
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