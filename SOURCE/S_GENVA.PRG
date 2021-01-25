/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GENVAL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  GENVAL() Generic VALID clause validation with message
ณ 
ณ  Returns:
ณ  --------
ณ  <lValid> => logical result of passed condition
ณ 
ณ  Syntax:
ณ  -------
ณ  GENVAL(expValid,expMessage)
ณ 
ณ  Description:
ณ  ------------
ณ  Evaluates <expValid>, which is either a bode block or
ณ  a string to be macro expanded, as a logical value. If result is
ณ  False, displays message <expMessage> and waits for a keypress.
ณ  <expMessage> can be a single string, or an array of strings (see
ณ  aMsg() ).
ณ 
ณ  Examples:
ณ  ---------
ณ   if genval("fcount() < 60",'Too many fields')
ณ       COPY TO TEMP
ณ   endif
ณ 
ณ   * ...or as a VALID CLAUSE macro'd
ณ 
ณ   @10,10 get lname VALID ;
ณ     GENVAL("!empty(lname)","Need a last name")
ณ 
ณ   * ...or as a VALID CLAUSE eval'd
ณ 
ณ   @10,10 get fname VALID ;
ณ     GENVAL( { || !empty(fname) },"Need a last name")
ณ 
ณ  Source:
ณ  -------
ณ  S_GENVA.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION genval(_beetljoos_,expWhatSay)
local  lReturnval := .t.
*- test the condition. If its false, set returnval to .f., display the message

if valtype(_beetljoos_)=="C"
  IF .NOT. (&_beetljoos_)
    lReturnval :=.F.
    if valtype(expWhatSay)=="C"
      msg(expWhatSay)
    elseif valtype(expWhatSay)=="A"
      amsg(expWhatsay)
    endif
  ENDIF
elseif valtype(_beetljoos_)=="B"
  IF .NOT. eval(_beetljoos_)
    lReturnval :=.F.
    if valtype(expWhatSay)=="C"
      msg(expWhatSay)
    elseif valtype(expWhatSay)=="A"
      amsg(expWhatsay)
    endif
  ENDIF
endif

RETURN(lReturnval)
* EOF: S_GENVA.PRG

