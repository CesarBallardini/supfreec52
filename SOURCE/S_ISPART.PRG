/*
�����������������������������������������������������������������
� FUNCTION ISPART()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISPART() Determines if a value is part of a set
� 
�  Returns:
�  --------
�  <lIsPart> => if value is part of set
� 
�  Syntax:
�  -------
�  ISPART(expX1,expX2,[expX3],...[expX10])
� 
�  Description:
�  ------------
�  Compares a value <expX1> to a set of values of same
�  type <expX2..expX10> to determine if it is equal to any of
�  them. Returns True if it is, False otherwise. Up to 9 values to
�  compare.
� 
�  Examples:
�  ---------
�   If ISPART(nChoice,5,6,7,12)
�     MSG("Need a DBF open")
�     loop
�   endif
� 
�   If ISPART(cChars,"A","B","C","D")
� 
�   endif
� 
�  Source:
�  -------
�  S_ISPART.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION ispart(expTest,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16)
local aExpr := {x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16}
asize(aExpr,pcount()-1)
return (ascan(aExpr,expTest)>0)