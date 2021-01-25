
/*
�����������������������������������������������������������������
� FUNCTION UNIQFNAME()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  UNIQFNAME() Creates a unique file name
� 
�  Returns:
�  --------
�  <cUniqueName> => unique file name
� 
�  Syntax:
�  -------
�  UNIQFNAME(cExtension,[cPath],[cPrefix])
� 
�  Description:
�  ------------
�  Attempts to create a unique file name using
�  <cExtension> extension for file.
� 
�  [cPath]     path to check
� 
�  [cPrefix]   prefix (first letter) of file name
�  (defaults to U)
� 
�  Examples:
�  ---------
�   cTempfile := UNIQFNAME("DBF")
� 
�   cTempfile := UNIQFNAME("NTX","C:\local\")
� 
�  Source:
�  -------
�  S_UNIQF.PRG
� 
����������������������������������������������������������������� 
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

