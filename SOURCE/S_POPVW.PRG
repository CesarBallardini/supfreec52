#include "getexit.ch"



/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION POPUPWHEN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  POPUPWHEN() Allows use of a popup for a GET WHEN clause
ณ 
ณ  Returns:
ณ  --------
ณ  <lWhen> => when condition, get pre-validation
ณ 
ณ  Syntax:
ณ  -------
ณ  POPUPWHEN(bPopup,[lShowonUp],[lReturn])
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up a popup in <bPopup> for use in a GET
ณ  WHEN clause. (the pre validation block). If a value is returned
ณ  from the popup, it is assigned to the get.
ณ 
ณ  <bPopup> is a codeblock that is evaluated. It is
ณ  passed the current value in the get as a parameter.
ณ 
ณ  The popup function will pop up upon entry into a GET
ณ  field.
ณ 
ณ  [lShowOnUp] Normally you wouldn't want this WHEN to
ณ  occur if the user is using the up arrow, and if <lShowOnUp> is
ณ  .f. (the default) it does not occur (the GET is just skipped)
ณ 
ณ  [lReturn] If set to False (the default) the GET is
ณ  never actually edited, as the WHEN will always return .f., but it is
ณ  assigned the value returned by the popup. By setting it to True,
ณ  the Calendar will pop up, and then the GET will also be put
ณ  through the normal get editor.
ณ 
ณ  Examples:
ณ  ---------
ณ   // these are codeblocks that do a popup (in this case, a  simple
ณ   //call to msg, and a return of a value)
ณ 
ณ   b1 := {||msg("Character value"),"Bert"}
ณ   b2 := {||msg("Logical value"),.t.}
ณ   b3 := {||msg("Date value"),date()+100}
ณ 
ณ   v1 := space(10)
ณ   v2 := .f.
ณ   v3 := ctod("  /  /  ")
ณ 
ณ   @10,10 get v1 when POPUPWHEN(b1,.f.,.t.)
ณ   @11,10 get v2 when POPUPWHEN(b2,.f.,.t.)
ณ   @12,10 get v3 when POPUPWHEN(b3,.f.,.t.)
ณ 
ณ   READ
ณ 
ณ  Source:
ณ  -------
ณ  S_POPVW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION POPUPVALID()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  POPUPVALID() Allows use of a popup for a GET VALID clause
ณ 
ณ  Returns:
ณ  --------
ณ  <lValid> => valid condition, get post-validation
ณ 
ณ  Syntax:
ณ  -------
ณ  POPUPVALID(bPopup,[bValid])
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up a popup in <bPopup> for use in a GET
ณ  VALID clause. (the post validation block). If a value is returned
ณ  from the popup, it is assigned to the get.The popup function will pop
ณ  up upon exit from the GET field.
ณ 
ณ  <bPopup> is a codeblock that is evaluated. It is
ณ  passed the current value in the get as a parameter.
ณ 
ณ  [bValid]  - If you pass a validation codeblock, it
ณ  will be checked first. If the GET is already valid, according to
ณ  the codeblock, the popup will not be popped up. The codeblock
ณ  must return a logical value.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   // these are codeblocks that do a popup (in this case, a  simple
ณ   //call to msg, and a return of a value)
ณ 
ณ   b1 := {||msg("Character value"),"Bert"}
ณ   b2 := {||msg("Logical value"),.t.}
ณ   b3 := {||msg("Date value"),date()+100}
ณ   b4 := {||msg("Number value"),123}
ณ 
ณ   v1 := space(10)
ณ   v2 := .f.
ณ   v3 := ctod("  /  /  ")
ณ   v4 := 0
ณ 
ณ   // these are added in as valid clauses to the gets. The <bValid>
ณ   // param is a codeblock that checks for the value being empty.
ณ 
ณ   @14,10 get v1 valid POPUPVALID(b1,{||!empty(v1)})
ณ   @15,10 get v2 valid POPUPVALID(b2,{||!empty(v2)})
ณ   @16,10 get v3 valid POPUPVALID(b3,{||!empty(v3)})
ณ   @17,10 get v4 valid POPUPVALID(b4,{||!empty(v4)})
ณ 
ณ   read
ณ 
ณ  Source:
ณ  -------
ณ  S_POPVW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

