//-------------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION ISINLOOK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ISINLOOK() Checks for existence of a value in a lookup dbf
� 
�  Returns:
�  --------
�  lFound  => value was found
� 
�  Syntax:
�  -------
�  ISINLOOK(expCurrent,nArea,[bCompare],[lBlankOk],[cMsg])
� 
�  Description:
�  ------------
�  Looks for <expCurrent>, and expression of any type,
�  in the workarea indicated in <nArea>.
� 
�  [bCompare]  - Normally a SEEK would be done, but if
�  [bCompare] (a codeblock ) is passed, this acts as a LOCATE FOR ,
�  as in LOCATE FOR eval(bCompare)
� 
�  [lBlankOk] - If this is false (the default), and
�  <expCurrent> is empty, an automatic false is returned.
� 
�  [cMsg] - If this is passed, and the value is not
�  found ,or is blank and <lBlankOk> is false, this message is
�  displayed. Default is no message
� 
�  Examples:
�  ---------
�   @3,0 GET V3 WHEN  !ISINLOOK(v3,5,nil,.f.,"Not Valid or is blank")
� 
�   @4,0 GET V4 VALID ;
�     ISINLOOK(v4,5,{||adbf->company},.f.,"Not Valid or is  blank")
� 
�  Source:
�  -------
�  S_INLOOK.PRG
� 
����������������������������������������������������������������� 
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