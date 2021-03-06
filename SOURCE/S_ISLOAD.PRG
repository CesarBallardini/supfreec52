/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISLOADED()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISLOADED() Determines  function is loaded or not
³ 
³  Returns:
³  --------
³  <lIsLoaded> => is function loaded
³ 
³  Syntax:
³  -------
³  ISLOADED(cFunction)
³ 
³  Description:
³  ------------
³  This function will test for <cFunction> being loaded
³  into memory. <cFunction > can be any function in the
³  form "FUNCTION()" but must refer to a function NOT in
³  CLIPPER.LIB.
³ 
³  Examples:
³  ---------
³   if ISLOADED("QUERY()")
³       @row()+1,3 prompt "Build Query"
³   endif
³ 
³  Source:
³  -------
³  S_ISLOAD.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION isloaded(cFuncName)
RETURN (TYPE(cFuncName)=="UI")
