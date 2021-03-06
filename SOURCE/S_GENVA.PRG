/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION GENVAL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  GENVAL() Generic VALID clause validation with message
³ 
³  Returns:
³  --------
³  <lValid> => logical result of passed condition
³ 
³  Syntax:
³  -------
³  GENVAL(expValid,expMessage)
³ 
³  Description:
³  ------------
³  Evaluates <expValid>, which is either a bode block or
³  a string to be macro expanded, as a logical value. If result is
³  False, displays message <expMessage> and waits for a keypress.
³  <expMessage> can be a single string, or an array of strings (see
³  aMsg() ).
³ 
³  Examples:
³  ---------
³   if genval("fcount() < 60",'Too many fields')
³       COPY TO TEMP
³   endif
³ 
³   * ...or as a VALID CLAUSE macro'd
³ 
³   @10,10 get lname VALID ;
³     GENVAL("!empty(lname)","Need a last name")
³ 
³   * ...or as a VALID CLAUSE eval'd
³ 
³   @10,10 get fname VALID ;
³     GENVAL( { || !empty(fname) },"Need a last name")
³ 
³  Source:
³  -------
³  S_GENVA.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

