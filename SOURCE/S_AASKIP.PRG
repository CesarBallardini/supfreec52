// Must pass nElement by reference!
// i.e. aaskip(n,@nElement,10)

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION AASKIP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  AASKIP() Use for skipblock for arrays in Tbrowse
ณ 
ณ  Returns:
ณ  --------
ณ  <nSkipcount> => number skipped, forward or backward
ณ 
ณ  Syntax:
ณ  -------
ณ  AASKIP(nSkip,@nElement,nMaxRows)
ณ 
ณ  Description:
ณ  ------------
ณ  Use this to create the SKIPBLOCK for a tbrowse that browses
ณ  an array, as in :
ณ 
ณ    aTbrowseObject:SKIPBLOCK := {|n|aaskip(n,@nElement,len(aArray)}
ณ 
ณ  <nSkip>      is passed in by Tbrowse as a +- value, or
ณ               as zero.
ณ 
ณ  <nElement>   is the current array element number.
ณ               PASSED IN BY REFERENCE!
ณ 
ณ  <nMaxrows>   refers to the length of the array being
ณ               browsed
ณ 
ณ  Examples:
ณ  ---------
ณ  // this example browses the fields in a database
ณ 
ณ   local nLastKey,  nElement    := 1
ณ   local aArray := dbstruct()
ณ   local oTb        := tBrowseNew(2,2,20,78)
ณ   oTb:addcolumn(tbcolumnew("Name",{||aArray[nElement,1]}))
ณ   oTb:addcolumn(tbcolumnew("Type", {||aArray[nElement,2]}))
ณ   oTb:addcolumn(tbcolumnew("Len " , {||aArray[nElement,3]}))
ณ   oTb:addcolumn(tbcolumnew("Deci",  {||aArray[nElement,4]}))
ณ   oTb:Skipblock        := {|n|aaskip(n,@nElement,len(aArray)}
ณ   oTb:goTopBlock       := {||nElement := 1}
ณ   oTb:goBottomBlock    := {||nElement := len(aArray)}
ณ 
ณ   while .t.
ณ     while !oTb:stabilize()
ณ     end
ณ     nLastKey := inkey(0)
ณ     do case
ณ        /// various actions.....
ณ     endcase
ณ   end
ณ 
ณ  Notes:
ณ  -------
ณ  Aaskip() is used by a lot of SuperLib functions, but
ณ  is very useful by itself for creating array tbrowses.
ณ 
ณ  Source:
ณ  -------
ณ  S_AASKIP.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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


