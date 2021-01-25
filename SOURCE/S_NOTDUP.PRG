//-------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISNOTDUP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISNOTDUP() Checks for a duplicate field
ณ 
ณ  Returns:
ณ  --------
ณ  <lDup>  => is duplicate field
ณ 
ณ  Syntax:
ณ  -------
ณ  ISNOTDUP(expCurrent,[nOrder],[bCompare],;
ณ        [lBlankOk],[nExceptRec],[cMsg])
ณ 
ณ  Description:
ณ  ------------
ณ  Looks in the current DBF for <expCurrent> - an
ณ  expression of any type. [nOrder]  is the index order to SEEK on.
ณ  Default is INDEXORD(). [bCompare]  - in lieu of an index key,
ณ  this block is used in a locate compare of <expCurrent> as in
ณ 
ณ  LOCATE FOR eval(bCompare)==expCurrent.
ณ 
ณ  [lBlankOk]    if <expCurrent> is blank, and this is
ณ  .f. (the default), then and automatic .f. is returned.
ณ 
ณ  [nExceptRec]  if this is passed, will check all BUT
ณ  this record number. Useful for editing routine, where you don't
ณ  wish to check for a duplicate of the existing record.
ณ 
ณ  [cMsg]  the message displayed if a duplicate is
ณ  found. Default is none.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   @6,0 GET V6 valid   ;
ณ    ISNOTDUP(v6,nil,nil,nil,nil,"Duplicate found")
ณ 
ณ   @6,0 GET V6 valid   ;
ณ    ISNOTDUP(v6,3,nil,nil,recno(),"Duplicate found")
ณ 
ณ   @6,0 GET V6 valid  ;
ณ     ISNOTDUP(v6,nil,{||afile->v6},nil,recno(),"Duplicate found")
ณ 
ณ  Notes:
ณ  -------
ณ  Normally for use in making sure a duplicate record is
ณ  not entered.
ณ 
ณ  Source:
ณ  -------
ณ  S_NOTDUP.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ISNOTDUP(expCurrent,nOrder,bCompare,lBlankOk,nExceptRec,cMsg)
local nThisrecord := recno()
local lFound := .t.
local nOldOrder := INDEXORD(0)
local cOldFilter := DBFILTER()
local expIndexKey := indexkey(0)
if valtype(nExceptRec)=="N"
  SET FILTER TO RECNO()#nExceptRec
endif
if valtype(nOrder)=="N"
  set order to (nOrder)
endif
lBlankOk := iif(lBlankOk#nil,lBlankOk,.f.)
if empty(expCurrent) .and. !lBlankOk
  lFound := .f.
elseif bCompare#nil  // must be a locate
  set order to 0
  go top
  locate for expCurrent==eval(bCompare)
  lFound := found()
elseif INDEXORD() > 0
  if type(expIndexKey)==valtype(expCurrent)
    seek expCurrent
    lFound := found()
  endif
endif
if lFound .and. cMsg#nil
  msg(cMsg)
endif
SET ORDER TO (nOldOrder)
go (nThisRecord)
if !empty(cOldFilter)
  set filter to &cOldFilter
else
  set filter to
endif
return !(lFound)
