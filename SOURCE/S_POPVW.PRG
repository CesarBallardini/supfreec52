#include "getexit.ch"



/*
�����������������������������������������������������������������
� FUNCTION POPUPWHEN()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  POPUPWHEN() Allows use of a popup for a GET WHEN clause
� 
�  Returns:
�  --------
�  <lWhen> => when condition, get pre-validation
� 
�  Syntax:
�  -------
�  POPUPWHEN(bPopup,[lShowonUp],[lReturn])
� 
�  Description:
�  ------------
�  This sets up a popup in <bPopup> for use in a GET
�  WHEN clause. (the pre validation block). If a value is returned
�  from the popup, it is assigned to the get.
� 
�  <bPopup> is a codeblock that is evaluated. It is
�  passed the current value in the get as a parameter.
� 
�  The popup function will pop up upon entry into a GET
�  field.
� 
�  [lShowOnUp] Normally you wouldn't want this WHEN to
�  occur if the user is using the up arrow, and if <lShowOnUp> is
�  .f. (the default) it does not occur (the GET is just skipped)
� 
�  [lReturn] If set to False (the default) the GET is
�  never actually edited, as the WHEN will always return .f., but it is
�  assigned the value returned by the popup. By setting it to True,
�  the Calendar will pop up, and then the GET will also be put
�  through the normal get editor.
� 
�  Examples:
�  ---------
�   // these are codeblocks that do a popup (in this case, a  simple
�   //call to msg, and a return of a value)
� 
�   b1 := {||msg("Character value"),"Bert"}
�   b2 := {||msg("Logical value"),.t.}
�   b3 := {||msg("Date value"),date()+100}
� 
�   v1 := space(10)
�   v2 := .f.
�   v3 := ctod("  /  /  ")
� 
�   @10,10 get v1 when POPUPWHEN(b1,.f.,.t.)
�   @11,10 get v2 when POPUPWHEN(b2,.f.,.t.)
�   @12,10 get v3 when POPUPWHEN(b3,.f.,.t.)
� 
�   READ
� 
�  Source:
�  -------
�  S_POPVW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION POPUPWHEN(bPopup,lShowOnUp,lReturn)
local get  := getactive()
local expValue := get:varget()
lReturn   := iif(lReturn#nil,lReturn,.f.)
lShowOnUp := iif(lShowOnUp#nil,lShowOnUp,.f.)
if !(get:exitstate==GE_UP .and. !lShowOnUp)
   expValue := eval(bPopup,expValue)
   if expValue#nil
    if valtype(expValue)=="N"
     keyboard alltrim(str(expValue))
     popvfeedk(get)
    else
     GET:varput(expValue)
     GET:updatebuffer()
    endif
   ENDIF
endif
return lReturn


//-------------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION POPUPVALID()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  POPUPVALID() Allows use of a popup for a GET VALID clause
� 
�  Returns:
�  --------
�  <lValid> => valid condition, get post-validation
� 
�  Syntax:
�  -------
�  POPUPVALID(bPopup,[bValid])
� 
�  Description:
�  ------------
�  This sets up a popup in <bPopup> for use in a GET
�  VALID clause. (the post validation block). If a value is returned
�  from the popup, it is assigned to the get.The popup function will pop
�  up upon exit from the GET field.
� 
�  <bPopup> is a codeblock that is evaluated. It is
�  passed the current value in the get as a parameter.
� 
�  [bValid]  - If you pass a validation codeblock, it
�  will be checked first. If the GET is already valid, according to
�  the codeblock, the popup will not be popped up. The codeblock
�  must return a logical value.
� 
�  Examples:
�  ---------
� 
�   // these are codeblocks that do a popup (in this case, a  simple
�   //call to msg, and a return of a value)
� 
�   b1 := {||msg("Character value"),"Bert"}
�   b2 := {||msg("Logical value"),.t.}
�   b3 := {||msg("Date value"),date()+100}
�   b4 := {||msg("Number value"),123}
� 
�   v1 := space(10)
�   v2 := .f.
�   v3 := ctod("  /  /  ")
�   v4 := 0
� 
�   // these are added in as valid clauses to the gets. The <bValid>
�   // param is a codeblock that checks for the value being empty.
� 
�   @14,10 get v1 valid POPUPVALID(b1,{||!empty(v1)})
�   @15,10 get v2 valid POPUPVALID(b2,{||!empty(v2)})
�   @16,10 get v3 valid POPUPVALID(b3,{||!empty(v3)})
�   @17,10 get v4 valid POPUPVALID(b4,{||!empty(v4)})
� 
�   read
� 
�  Source:
�  -------
�  S_POPVW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION POPUPVALID(bPopup,bValid)
local get  := getactive()
local lReturn := .f.
local expValue := get:varget()
if bValid==nil .or. !eval(bValid)
   expValue := eval(bPopup,expValue)
   if expValue#nil
     if valtype(expValue)=="N"
      keyboard alltrim(str(expValue))
      popvfeedk(get)
     else
      get:varput(expValue)
      get:updatebuffer()
     endif
     lReturn := iif(bValid#nil,eval(bValid),.t.)
   endif
else
  lReturn := .t.
endif
return lReturn

//---------------------------------------------------------------
static FUNCTION popvfeedk(get)
local nKey,cKey
get:setfocus()
while (nKey := inkey()) > 0
  cKey := Chr(nKey)
  if (get:type == "N" .and. (cKey == "." .or. cKey == ","))
     get:ToDecPos()
  else
     get:Insert(cKey)
     if (get:typeOut)
        while inkey()<>0
        end
     endif
  endif
end
get:assign()
get:killfocus()
return nil
