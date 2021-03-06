//-------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISNOTDUP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISNOTDUP() Checks for a duplicate field
³ 
³  Returns:
³  --------
³  <lDup>  => is duplicate field
³ 
³  Syntax:
³  -------
³  ISNOTDUP(expCurrent,[nOrder],[bCompare],;
³        [lBlankOk],[nExceptRec],[cMsg])
³ 
³  Description:
³  ------------
³  Looks in the current DBF for <expCurrent> - an
³  expression of any type. [nOrder]  is the index order to SEEK on.
³  Default is INDEXORD(). [bCompare]  - in lieu of an index key,
³  this block is used in a locate compare of <expCurrent> as in
³ 
³  LOCATE FOR eval(bCompare)==expCurrent.
³ 
³  [lBlankOk]    if <expCurrent> is blank, and this is
³  .f. (the default), then and automatic .f. is returned.
³ 
³  [nExceptRec]  if this is passed, will check all BUT
³  this record number. Useful for editing routine, where you don't
³  wish to check for a duplicate of the existing record.
³ 
³  [cMsg]  the message displayed if a duplicate is
³  found. Default is none.
³ 
³  Examples:
³  ---------
³ 
³   @6,0 GET V6 valid   ;
³    ISNOTDUP(v6,nil,nil,nil,nil,"Duplicate found")
³ 
³   @6,0 GET V6 valid   ;
³    ISNOTDUP(v6,3,nil,nil,recno(),"Duplicate found")
³ 
³   @6,0 GET V6 valid  ;
³     ISNOTDUP(v6,nil,{||afile->v6},nil,recno(),"Duplicate found")
³ 
³  Notes:
³  -------
³  Normally for use in making sure a duplicate record is
³  not entered.
³ 
³  Source:
³  -------
³  S_NOTDUP.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
