
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION UNIQFNAME()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  UNIQFNAME() Creates a unique file name
³ 
³  Returns:
³  --------
³  <cUniqueName> => unique file name
³ 
³  Syntax:
³  -------
³  UNIQFNAME(cExtension,[cPath],[cPrefix])
³ 
³  Description:
³  ------------
³  Attempts to create a unique file name using
³  <cExtension> extension for file.
³ 
³  [cPath]     path to check
³ 
³  [cPrefix]   prefix (first letter) of file name
³  (defaults to U)
³ 
³  Examples:
³  ---------
³   cTempfile := UNIQFNAME("DBF")
³ 
³   cTempfile := UNIQFNAME("NTX","C:\local\")
³ 
³  Source:
³  -------
³  S_UNIQF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


