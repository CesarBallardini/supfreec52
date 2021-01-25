/*
�����������������������������������������������������������������
� FUNCTION GENVAL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  GENVAL() Generic VALID clause validation with message
� 
�  Returns:
�  --------
�  <lValid> => logical result of passed condition
� 
�  Syntax:
�  -------
�  GENVAL(expValid,expMessage)
� 
�  Description:
�  ------------
�  Evaluates <expValid>, which is either a bode block or
�  a string to be macro expanded, as a logical value. If result is
�  False, displays message <expMessage> and waits for a keypress.
�  <expMessage> can be a single string, or an array of strings (see
�  aMsg() ).
� 
�  Examples:
�  ---------
�   if genval("fcount() < 60",'Too many fields')
�       COPY TO TEMP
�   endif
� 
�   * ...or as a VALID CLAUSE macro'd
� 
�   @10,10 get lname VALID ;
�     GENVAL("!empty(lname)","Need a last name")
� 
�   * ...or as a VALID CLAUSE eval'd
� 
�   @10,10 get fname VALID ;
�     GENVAL( { || !empty(fname) },"Need a last name")
� 
�  Source:
�  -------
�  S_GENVA.PRG
� 
����������������������������������������������������������������� 
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
