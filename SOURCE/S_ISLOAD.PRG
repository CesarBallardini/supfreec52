/*
�����������������������������������������������������������������
� FUNCTION ISLOADED()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISLOADED() Determines  function is loaded or not
� 
�  Returns:
�  --------
�  <lIsLoaded> => is function loaded
� 
�  Syntax:
�  -------
�  ISLOADED(cFunction)
� 
�  Description:
�  ------------
�  This function will test for <cFunction> being loaded
�  into memory. <cFunction > can be any function in the
�  form "FUNCTION()" but must refer to a function NOT in
�  CLIPPER.LIB.
� 
�  Examples:
�  ---------
�   if ISLOADED("QUERY()")
�       @row()+1,3 prompt "Build Query"
�   endif
� 
�  Source:
�  -------
�  S_ISLOAD.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION isloaded(cFuncName)
RETURN (TYPE(cFuncName)=="UI")