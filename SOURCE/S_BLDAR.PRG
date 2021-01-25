*- first param MUST be an array now
/*
�����������������������������������������������������������������
� FUNCTION BLDARR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BLDARR() Builds an array from a delimited string
� 
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  BLDARR(aTarget,nCount,cDelimited)
� 
�  Description:
�  ------------
�  Fills in the elements of an existing array <aTarget>
�  with <nCount> character values extracted from a delimited string
�  <cDelimited> of the form "Garry:Wyn:Ralph:Ed". The colon [:] is
�  the delimiter. The first parameter is an array of any length. It
�  will be sized to fit.
� 
�  Examples:
�  ---------
�   aLunch := array(3)
�   BLDARR(aLunch,3,"Pizza:Chicken:Burgers")
�       // =>  {"Pizza","Chicken","Burgers"}
� 
�  Notes:
�  -------
�  Array must be declared prior to calling.
�  Of course, in Clipper 5.01 you can also use:
�  myarray := {"Pizza","Chicken","Burgers"},
�  and this function is mainly here for compatibility.
� 
�  Source:
�  -------
�  S_BLDAR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION bldarr(aArray,nArrayLength,cInString)
local cNextElement,nIterator
asize(aArray,nArrayLength)
FOR nIterator = 1 TO nArrayLength
  cNextElement      := takeout(cInString,":",nIterator)
  aArray[nIterator] := cNextElement
NEXT
return nil