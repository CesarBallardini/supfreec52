//-------------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION ISNOTDUP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISNOTDUP() Checks for a duplicate field
� 
�  Returns:
�  --------
�  <lDup>  => is duplicate field
� 
�  Syntax:
�  -------
�  ISNOTDUP(expCurrent,[nOrder],[bCompare],;
�        [lBlankOk],[nExceptRec],[cMsg])
� 
�  Description:
�  ------------
�  Looks in the current DBF for <expCurrent> - an
�  expression of any type. [nOrder]  is the index order to SEEK on.
�  Default is INDEXORD(). [bCompare]  - in lieu of an index key,
�  this block is used in a locate compare of <expCurrent> as in
� 
�  LOCATE FOR eval(bCompare)==expCurrent.
� 
�  [lBlankOk]    if <expCurrent> is blank, and this is
�  .f. (the default), then and automatic .f. is returned.
� 
�  [nExceptRec]  if this is passed, will check all BUT
�  this record number. Useful for editing routine, where you don't
�  wish to check for a duplicate of the existing record.
� 
�  [cMsg]  the message displayed if a duplicate is
�  found. Default is none.
� 
�  Examples:
�  ---------
� 
�   @6,0 GET V6 valid   ;
�    ISNOTDUP(v6,nil,nil,nil,nil,"Duplicate found")
� 
�   @6,0 GET V6 valid   ;
�    ISNOTDUP(v6,3,nil,nil,recno(),"Duplicate found")
� 
�   @6,0 GET V6 valid  ;
�     ISNOTDUP(v6,nil,{||afile->v6},nil,recno(),"Duplicate found")
� 
�  Notes:
�  -------
�  Normally for use in making sure a duplicate record is
�  not entered.
� 
�  Source:
�  -------
�  S_NOTDUP.PRG
� 
����������������������������������������������������������������� 
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