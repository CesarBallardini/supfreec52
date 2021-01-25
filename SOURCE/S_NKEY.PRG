/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION NKEY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  NKEY() Gets key of an index file
ณ 
ณ  Returns:
ณ  --------
ณ  <cKey> => index key expression
ณ 
ณ  Syntax:
ณ  -------
ณ  NKEY(cIndex)
ณ 
ณ  Description:
ณ  ------------
ณ  Gets key expression of index <cIndex>. <cIndex> is
ณ  the name of the index including extension. The function operates
ณ  differently from .ntx to .ndx.
ณ 
ณ  Examples:
ณ  ---------
ณ   for i = 1 to nIndexes
ณ 
ณ       ?"Key for index: "+aInd[i]+" is "+NKEY(aInd[i])
ณ 
ณ   next
ณ 
ณ  Warnings:
ณ  ----------
ณ  Uses up a file handle temporarily. Opens up the index
ณ  with low level file functions.
ณ 
ณ  Notes:
ณ  -------
ณ  NKEY() expects the full path of the index file and if
ณ  no path is passed, will use SET DEFAULT setting
ณ 
ณ  Source:
ณ  -------
ณ  S_NKEY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION nkey(cIndexName)
local nFileHandle,cNextByte
local cIndexKey := ''

* adjust for no path specified
if !("\"$cIndexName .or. ":"$cIndexName)
   cIndexName := getdfp()+cIndexName
endif
IF FILE(cIndexName)
  
  *- open the file in shared mode
  nFileHandle = FOPEN(cIndexName,64)
  IF Ferror() = 0
    
    *- what kind of index ? (key description starts at different bytes)
    IF UPPER(RIGHT(cIndexName,2)) = "DX"
      FSEEK(nFileHandle,24)
    ELSE
      FSEEK(nFileHandle,22)
    ENDIF
    
    *- get the next byte
    cNextByte := Freadstr(nFileHandle,1)
    cIndexKey := ''
    
    *- keep doing until chr(0) reached
    DO WHILE !ASC(cNextByte)=0
      *- add value to cIndexKey
      cIndexKey += cNextByte
      *- get the next byte
      cNextByte := Freadstr(nFileHandle,1)
    ENDDO
    
  ENDIF
  Fclose(nFileHandle)
ENDIF
RETURN cIndexKey


