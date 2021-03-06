//-------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISINLOOK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISINLOOK() Checks for existence of a value in a lookup dbf
³ 
³  Returns:
³  --------
³  lFound  => value was found
³ 
³  Syntax:
³  -------
³  ISINLOOK(expCurrent,nArea,[bCompare],[lBlankOk],[cMsg])
³ 
³  Description:
³  ------------
³  Looks for <expCurrent>, and expression of any type,
³  in the workarea indicated in <nArea>.
³ 
³  [bCompare]  - Normally a SEEK would be done, but if
³  [bCompare] (a codeblock ) is passed, this acts as a LOCATE FOR ,
³  as in LOCATE FOR eval(bCompare)
³ 
³  [lBlankOk] - If this is false (the default), and
³  <expCurrent> is empty, an automatic false is returned.
³ 
³  [cMsg] - If this is passed, and the value is not
³  found ,or is blank and <lBlankOk> is false, this message is
³  displayed. Default is no message
³ 
³  Examples:
³  ---------
³   @3,0 GET V3 WHEN  !ISINLOOK(v3,5,nil,.f.,"Not Valid or is blank")
³ 
³   @4,0 GET V4 VALID ;
³     ISINLOOK(v4,5,{||adbf->company},.f.,"Not Valid or is  blank")
³ 
³  Source:
³  -------
³  S_INLOOK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
