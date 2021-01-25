//-------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISINLOOK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ISINLOOK() Checks for existence of a value in a lookup dbf
ณ 
ณ  Returns:
ณ  --------
ณ  lFound  => value was found
ณ 
ณ  Syntax:
ณ  -------
ณ  ISINLOOK(expCurrent,nArea,[bCompare],[lBlankOk],[cMsg])
ณ 
ณ  Description:
ณ  ------------
ณ  Looks for <expCurrent>, and expression of any type,
ณ  in the workarea indicated in <nArea>.
ณ 
ณ  [bCompare]  - Normally a SEEK would be done, but if
ณ  [bCompare] (a codeblock ) is passed, this acts as a LOCATE FOR ,
ณ  as in LOCATE FOR eval(bCompare)
ณ 
ณ  [lBlankOk] - If this is false (the default), and
ณ  <expCurrent> is empty, an automatic false is returned.
ณ 
ณ  [cMsg] - If this is passed, and the value is not
ณ  found ,or is blank and <lBlankOk> is false, this message is
ณ  displayed. Default is no message
ณ 
ณ  Examples:
ณ  ---------
ณ   @3,0 GET V3 WHEN  !ISINLOOK(v3,5,nil,.f.,"Not Valid or is blank")
ณ 
ณ   @4,0 GET V4 VALID ;
ณ     ISINLOOK(v4,5,{||adbf->company},.f.,"Not Valid or is  blank")
ณ 
ณ  Source:
ณ  -------
ณ  S_INLOOK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION ISINLOOK(expCurrent,nArea,bCompare,lBlankOk,cMsg)
local nThisArea := select()
local lFound := .f.
local expIndexKey
select (nArea)
expIndexKey := indexkey(0)
lBlankOk := iif(lBlankOk#nil,lBlankOk,.f.)
if empty(expCurrent) .and. !lBlankOk
  lFound := .f.
elseif bCompare#nil
  locate for expCurrent==eval(bCompare)
  lFound := found()
elseif INDEXORD() > 0
  if type(expIndexKey)==valtype(expCurrent)
    seek expCurrent
    lFound := found()
  endif
endif
select (nThisArea)
if !lFound .and. cMsg#nil
  msg(cMsg)
endif
return lFound
