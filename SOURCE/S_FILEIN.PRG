#define GETSIZE  1
#define GETDATE  2
#define GETTIME  3

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FILEINFO()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FILEINFO() Returns file date,time,size
ณ 
ณ  Returns:
ณ  --------
ณ  <expInfo> => Returns file date,time or size
ณ 
ณ  Syntax:
ณ  -------
ณ  FILEINFO(cFileName,nInfo)
ณ 
ณ  Description:
ณ  ------------
ณ  Returns info on file in <cFileName> based on param
ณ  passed as <nInfo>
ณ 
ณ     1  - returns file size (numeric)
ณ 
ณ     2  - returns file date (date)
ณ 
ณ     3  - returns file time (character)
ณ 
ณ  Examples:
ณ  ---------
ณ   nFilesize     := fileinfo("customer.dbf",1)
ณ   dFileDate     := fileinfo("customer.dbf",2)
ณ   dFileTime     := fileinfo("customer.dbf",3)
ณ 
ณ  Source:
ณ  -------
ณ  S_FILEIN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
