// Must pass nElement by reference!
// i.e. aaskip(n,@nElement,10)

/*
�����������������������������������������������������������������
� FUNCTION AASKIP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  AASKIP() Use for skipblock for arrays in Tbrowse
� 
�  Returns:
�  --------
�  <nSkipcount> => number skipped, forward or backward
� 
�  Syntax:
�  -------
�  AASKIP(nSkip,@nElement,nMaxRows)
� 
�  Description:
�  ------------
�  Use this to create the SKIPBLOCK for a tbrowse that browses
�  an array, as in :
� 
�    aTbrowseObject:SKIPBLOCK := {|n|aaskip(n,@nElement,len(aArray)}
� 
�  <nSkip>      is passed in by Tbrowse as a +- value, or
�               as zero.
� 
�  <nElement>   is the current array element number.
�               PASSED IN BY REFERENCE!
� 
�  <nMaxrows>   refers to the length of the array being
�               browsed
� 
�  Examples:
�  ---------
�  // this example browses the fields in a database
� 
�   local nLastKey,  nElement    := 1
�   local aArray := dbstruct()
�   local oTb        := tBrowseNew(2,2,20,78)
�   oTb:addcolumn(tbcolumnew("Name",{||aArray[nElement,1]}))
�   oTb:addcolumn(tbcolumnew("Type", {||aArray[nElement,2]}))
�   oTb:addcolumn(tbcolumnew("Len " , {||aArray[nElement,3]}))
�   oTb:addcolumn(tbcolumnew("Deci",  {||aArray[nElement,4]}))
�   oTb:Skipblock        := {|n|aaskip(n,@nElement,len(aArray)}
�   oTb:goTopBlock       := {||nElement := 1}
�   oTb:goBottomBlock    := {||nElement := len(aArray)}
� 
�   while .t.
�     while !oTb:stabilize()
�     end
�     nLastKey := inkey(0)
�     do case
�        /// various actions.....
�     endcase
�   end
� 
�  Notes:
�  -------
�  Aaskip() is used by a lot of SuperLib functions, but
�  is very useful by itself for creating array tbrowses.
� 
�  Source:
�  -------
�  S_AASKIP.PRG
� 
����������������������������������������������������������������� 
*/
function aaskip(n,nelement,nrows)
  local skipcount := 0
  do case
  case n > 0
    do while nelement+skipcount < nrows  .and. skipcount < n
      skipcount++
    enddo
  case n < 0
    do while nelement+skipcount > 1 .and. skipcount > n
      skipcount--
    enddo
  endcase
  nelement += skipcount
return skipcount

