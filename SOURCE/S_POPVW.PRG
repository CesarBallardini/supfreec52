#include "getexit.ch"



/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPUPWHEN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPUPWHEN() Allows use of a popup for a GET WHEN clause
³ 
³  Returns:
³  --------
³  <lWhen> => when condition, get pre-validation
³ 
³  Syntax:
³  -------
³  POPUPWHEN(bPopup,[lShowonUp],[lReturn])
³ 
³  Description:
³  ------------
³  This sets up a popup in <bPopup> for use in a GET
³  WHEN clause. (the pre validation block). If a value is returned
³  from the popup, it is assigned to the get.
³ 
³  <bPopup> is a codeblock that is evaluated. It is
³  passed the current value in the get as a parameter.
³ 
³  The popup function will pop up upon entry into a GET
³  field.
³ 
³  [lShowOnUp] Normally you wouldn't want this WHEN to
³  occur if the user is using the up arrow, and if <lShowOnUp> is
³  .f. (the default) it does not occur (the GET is just skipped)
³ 
³  [lReturn] If set to False (the default) the GET is
³  never actually edited, as the WHEN will always return .f., but it is
³  assigned the value returned by the popup. By setting it to True,
³  the Calendar will pop up, and then the GET will also be put
³  through the normal get editor.
³ 
³  Examples:
³  ---------
³   // these are codeblocks that do a popup (in this case, a  simple
³   //call to msg, and a return of a value)
³ 
³   b1 := {||msg("Character value"),"Bert"}
³   b2 := {||msg("Logical value"),.t.}
³   b3 := {||msg("Date value"),date()+100}
³ 
³   v1 := space(10)
³   v2 := .f.
³   v3 := ctod("  /  /  ")
³ 
³   @10,10 get v1 when POPUPWHEN(b1,.f.,.t.)
³   @11,10 get v2 when POPUPWHEN(b2,.f.,.t.)
³   @12,10 get v3 when POPUPWHEN(b3,.f.,.t.)
³ 
³   READ
³ 
³  Source:
³  -------
³  S_POPVW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPUPVALID()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPUPVALID() Allows use of a popup for a GET VALID clause
³ 
³  Returns:
³  --------
³  <lValid> => valid condition, get post-validation
³ 
³  Syntax:
³  -------
³  POPUPVALID(bPopup,[bValid])
³ 
³  Description:
³  ------------
³  This sets up a popup in <bPopup> for use in a GET
³  VALID clause. (the post validation block). If a value is returned
³  from the popup, it is assigned to the get.The popup function will pop
³  up upon exit from the GET field.
³ 
³  <bPopup> is a codeblock that is evaluated. It is
³  passed the current value in the get as a parameter.
³ 
³  [bValid]  - If you pass a validation codeblock, it
³  will be checked first. If the GET is already valid, according to
³  the codeblock, the popup will not be popped up. The codeblock
³  must return a logical value.
³ 
³  Examples:
³  ---------
³ 
³   // these are codeblocks that do a popup (in this case, a  simple
³   //call to msg, and a return of a value)
³ 
³   b1 := {||msg("Character value"),"Bert"}
³   b2 := {||msg("Logical value"),.t.}
³   b3 := {||msg("Date value"),date()+100}
³   b4 := {||msg("Number value"),123}
³ 
³   v1 := space(10)
³   v2 := .f.
³   v3 := ctod("  /  /  ")
³   v4 := 0
³ 
³   // these are added in as valid clauses to the gets. The <bValid>
³   // param is a codeblock that checks for the value being empty.
³ 
³   @14,10 get v1 valid POPUPVALID(b1,{||!empty(v1)})
³   @15,10 get v2 valid POPUPVALID(b2,{||!empty(v2)})
³   @16,10 get v3 valid POPUPVALID(b3,{||!empty(v3)})
³   @17,10 get v4 valid POPUPVALID(b4,{||!empty(v4)})
³ 
³   read
³ 
³  Source:
³  -------
³  S_POPVW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

