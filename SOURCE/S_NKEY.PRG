/*
�����������������������������������������������������������������
� FUNCTION NKEY()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  NKEY() Gets key of an index file
� 
�  Returns:
�  --------
�  <cKey> => index key expression
� 
�  Syntax:
�  -------
�  NKEY(cIndex)
� 
�  Description:
�  ------------
�  Gets key expression of index <cIndex>. <cIndex> is
�  the name of the index including extension. The function operates
�  differently from .ntx to .ndx.
� 
�  Examples:
�  ---------
�   for i = 1 to nIndexes
� 
�       ?"Key for index: "+aInd[i]+" is "+NKEY(aInd[i])
� 
�   next
� 
�  Warnings:
�  ----------
�  Uses up a file handle temporarily. Opens up the index
�  with low level file functions.
� 
�  Notes:
�  -------
�  NKEY() expects the full path of the index file and if
�  no path is passed, will use SET DEFAULT setting
� 
�  Source:
�  -------
�  S_NKEY.PRG
� 
����������������������������������������������������������������� 
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

