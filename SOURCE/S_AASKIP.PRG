// Must pass nElement by reference!
// i.e. aaskip(n,@nElement,10)

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION AASKIP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  AASKIP() Use for skipblock for arrays in Tbrowse
³ 
³  Returns:
³  --------
³  <nSkipcount> => number skipped, forward or backward
³ 
³  Syntax:
³  -------
³  AASKIP(nSkip,@nElement,nMaxRows)
³ 
³  Description:
³  ------------
³  Use this to create the SKIPBLOCK for a tbrowse that browses
³  an array, as in :
³ 
³    aTbrowseObject:SKIPBLOCK := {|n|aaskip(n,@nElement,len(aArray)}
³ 
³  <nSkip>      is passed in by Tbrowse as a +- value, or
³               as zero.
³ 
³  <nElement>   is the current array element number.
³               PASSED IN BY REFERENCE!
³ 
³  <nMaxrows>   refers to the length of the array being
³               browsed
³ 
³  Examples:
³  ---------
³  // this example browses the fields in a database
³ 
³   local nLastKey,  nElement    := 1
³   local aArray := dbstruct()
³   local oTb        := tBrowseNew(2,2,20,78)
³   oTb:addcolumn(tbcolumnew("Name",{||aArray[nElement,1]}))
³   oTb:addcolumn(tbcolumnew("Type", {||aArray[nElement,2]}))
³   oTb:addcolumn(tbcolumnew("Len " , {||aArray[nElement,3]}))
³   oTb:addcolumn(tbcolumnew("Deci",  {||aArray[nElement,4]}))
³   oTb:Skipblock        := {|n|aaskip(n,@nElement,len(aArray)}
³   oTb:goTopBlock       := {||nElement := 1}
³   oTb:goBottomBlock    := {||nElement := len(aArray)}
³ 
³   while .t.
³     while !oTb:stabilize()
³     end
³     nLastKey := inkey(0)
³     do case
³        /// various actions.....
³     endcase
³   end
³ 
³  Notes:
³  -------
³  Aaskip() is used by a lot of SuperLib functions, but
³  is very useful by itself for creating array tbrowses.
³ 
³  Source:
³  -------
³  S_AASKIP.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


