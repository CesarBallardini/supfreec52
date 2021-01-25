/*
�����������������������������������������������������������������
� FUNCTION AKOUNT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AKOUNT() Counts exact matches of value in array
� 
�  Returns:
�  --------
�  <nMatches>  => Number of matches
� 
�  Syntax:
�  -------
�  AKOUNT(aTarget,expWhatever)
� 
�  Description:
�  ------------
�  Counts # of exact matches of <expWhatever> in
�  <aTarget>. <expWhatever> can be of any type.
� 
�  Examples:
�  ---------
� 
�   AFIELDS(aFields,aTypes)
�   nChar  := AKOUNT(aTypes,"C")  // count C fields
�   nNum   := AKOUNT(aTypes,"N")  // count N fields
�   nDate  := AKOUNT(aTypes,"D")  // count D fields
� 
�  Notes:
�  -------
�  See also AMATCHES() which allows a code block.
� 
�  Source:
�  -------
�  S_AKOUNT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION akount(aArray,expValue)
local nIterator
local nMatchKount  := 0
local cTypeNeeded  := VALTYPE(expValue)
local narrayLength := aleng(aArray)
for nIterator = 1 TO narrayLength
  IF VALTYPE(aArray[nIterator])==cTypeNeeded
    IF aArray[nIterator] == expValue
      nMatchKount++
    ENDIF
  ENDIF
NEXT
RETURN nMatchKount