/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISLOADED()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISLOADED() Determines  function is loaded or not
ณ 
ณ  Returns:
ณ  --------
ณ  <lIsLoaded> => is function loaded
ณ 
ณ  Syntax:
ณ  -------
ณ  ISLOADED(cFunction)
ณ 
ณ  Description:
ณ  ------------
ณ  This function will test for <cFunction> being loaded
ณ  into memory. <cFunction > can be any function in the
ณ  form "FUNCTION()" but must refer to a function NOT in
ณ  CLIPPER.LIB.
ณ 
ณ  Examples:
ณ  ---------
ณ   if ISLOADED("QUERY()")
ณ       @row()+1,3 prompt "Build Query"
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_ISLOAD.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION isloaded(cFuncName)
RETURN (TYPE(cFuncName)=="UI")
