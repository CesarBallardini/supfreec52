/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION NKEY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  NKEY() Gets key of an index file
³ 
³  Returns:
³  --------
³  <cKey> => index key expression
³ 
³  Syntax:
³  -------
³  NKEY(cIndex)
³ 
³  Description:
³  ------------
³  Gets key expression of index <cIndex>. <cIndex> is
³  the name of the index including extension. The function operates
³  differently from .ntx to .ndx.
³ 
³  Examples:
³  ---------
³   for i = 1 to nIndexes
³ 
³       ?"Key for index: "+aInd[i]+" is "+NKEY(aInd[i])
³ 
³   next
³ 
³  Warnings:
³  ----------
³  Uses up a file handle temporarily. Opens up the index
³  with low level file functions.
³ 
³  Notes:
³  -------
³  NKEY() expects the full path of the index file and if
³  no path is passed, will use SET DEFAULT setting
³ 
³  Source:
³  -------
³  S_NKEY.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


