#define GETSIZE  1
#define GETDATE  2
#define GETTIME  3

/*
�����������������������������������������������������������������
� FUNCTION FILEINFO()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  FILEINFO() Returns file date,time,size
� 
�  Returns:
�  --------
�  <expInfo> => Returns file date,time or size
� 
�  Syntax:
�  -------
�  FILEINFO(cFileName,nInfo)
� 
�  Description:
�  ------------
�  Returns info on file in <cFileName> based on param
�  passed as <nInfo>
� 
�     1  - returns file size (numeric)
� 
�     2  - returns file date (date)
� 
�     3  - returns file time (character)
� 
�  Examples:
�  ---------
�   nFilesize     := fileinfo("customer.dbf",1)
�   dFileDate     := fileinfo("customer.dbf",2)
�   dFileTime     := fileinfo("customer.dbf",3)
� 
�  Source:
�  -------
�  S_FILEIN.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION fileinfo(cFile,nWhichInfo)
local aFileInfo
if file(cFile)
  aFileInfo := DIRECTORY(cFile)
  DO CASE
  CASE nWhichInfo = GETSIZE
    RETURN aFileInfo[1,2]
  CASE nWhichInfo = GETDATE
    RETURN aFileInfo[1,3]
  CASE nWhichInfo = GETTIME
    RETURN aFileInfo[1,4]
  ENDCASE
elseif valtype(nWhichInfo)=="N"
  do case
  case nWhichInfo == 1
    return 0
  case nWhichInfo == 2
    return ctod("  /  /  ")
  case nWhichInfo == 3
    return ""
  endcase
endif
RETURN ""











*: EOF: S_FILEIN.PRG