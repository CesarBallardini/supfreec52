#define GETSIZE  1
#define GETDATE  2
#define GETTIME  3

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FILEINFO()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FILEINFO() Returns file date,time,size
³ 
³  Returns:
³  --------
³  <expInfo> => Returns file date,time or size
³ 
³  Syntax:
³  -------
³  FILEINFO(cFileName,nInfo)
³ 
³  Description:
³  ------------
³  Returns info on file in <cFileName> based on param
³  passed as <nInfo>
³ 
³     1  - returns file size (numeric)
³ 
³     2  - returns file date (date)
³ 
³     3  - returns file time (character)
³ 
³  Examples:
³  ---------
³   nFilesize     := fileinfo("customer.dbf",1)
³   dFileDate     := fileinfo("customer.dbf",2)
³   dFileTime     := fileinfo("customer.dbf",3)
³ 
³  Source:
³  -------
³  S_FILEIN.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
