
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION UNIQFNAME()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  UNIQFNAME() Creates a unique file name
ณ 
ณ  Returns:
ณ  --------
ณ  <cUniqueName> => unique file name
ณ 
ณ  Syntax:
ณ  -------
ณ  UNIQFNAME(cExtension,[cPath],[cPrefix])
ณ 
ณ  Description:
ณ  ------------
ณ  Attempts to create a unique file name using
ณ  <cExtension> extension for file.
ณ 
ณ  [cPath]     path to check
ณ 
ณ  [cPrefix]   prefix (first letter) of file name
ณ  (defaults to U)
ณ 
ณ  Examples:
ณ  ---------
ณ   cTempfile := UNIQFNAME("DBF")
ณ 
ณ   cTempfile := UNIQFNAME("NTX","C:\local\")
ณ 
ณ  Source:
ณ  -------
ณ  S_UNIQF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function uniqfname(cExtension,cPath,cPrefix)
local nCounter,cUniqName

if valtype(cPrefix)<>"C"
  cPrefix := "U"
endif
if valtype(cPath)<>"C"
  cPath  := getdfp()
endif
nCounter = 900000
if !empty(cExtension)
  cExtension = "."+cExtension
endif
cUniqName  := cPrefix+"_"+trans(nCounter,"999999")+cExtension
do while file(cPath+cUniqName)
  nCounter++
  cUniqName := cPrefix+"_"+trans(nCounter,"999999")+cExtension
enddo

return cUniqName


