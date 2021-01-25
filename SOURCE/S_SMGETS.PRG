#include "Inkey.ch"
#include "Getexit.ch"


//------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SMALLWHEN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SMALLWHEN() Uses SMALLS() in a WHEN condition for a GET
ณ 
ณ  Returns:
ณ  --------
ณ  lValid  => logical value
ณ 
ณ  Syntax:
ณ  -------
ณ  SMALLWHEN([lShowOnUp],[lReturn],expDisplayString,[cTitle],;
ณ       [expAlias],expReturn,[expStartRange,expEndRange],[bException])
ณ 
ณ  Description:
ณ  ------------
ณ  Uses SMALLS() in a WHEN condition for a GET. See
ณ  SMALLS() for description of parameters <expDisplayString>
ณ  through [bException]
ณ 
ณ  [lShowOnUp] If False (the default), smalls is not
ณ  called when going backwards through the read (up arrow, etc), only when
ณ  going forward.
ณ 
ณ  [lReturn]   This is simply the value to return. The
ณ  default is False, which means the get is never 'edited'. A value
ณ  of True means the smalls() lookup is done, and then the get is edited.
ณ 
ณ  Examples:
ณ  ---------
ณ   @3,0 GET V3 WHEN ;
ณ       SMALLWHEN(.f.,.f.,"LASTNAME",nil,5,"LASTNAME")
ณ 
ณ   // This will pop up a smalls() lookup table when going forward
ณ   // through the gets. If RETURN is pressed, the current GET is fed
ณ   // or assigned the lookup value. (depends on value of <expReturn>)
ณ   // A False is returned, so the GET is not actually edited. The new
ณ   // value is displayed, and the next get is made active.
ณ 
ณ  Notes:
ณ  -------
ณ  See Smalls() for a complete parameter description.
ณ 
ณ  Source:
ณ  -------
ณ  S_SMGETS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SMALLWHEN(lShowOnUp,lReturn,expDisplayString,cTitle,;
                   expAlias,expReturn,expStartRange,expEndRange,bException)
local get  := getactive()
lReturn   := iif(lReturn#nil,lReturn,.f.)
lShowOnUp := iif(lShowOnUp#nil,lShowOnUp,.f.)
if !(lastkey()==K_UP .and. !lShowOnUp)
   smalls(expDisplayString,cTitle,expAlias,expReturn,;
                   expStartRange,expEndRange,bException)
   if valtype(expReturn)=="C" // must be a KEYBOARD, need to stuff the get
     smfeedk(get)
   endif
   get:updatebuffer()
   get:display()
endif
return lReturn

//-------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SMALLVALID()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SMALLVALID() Uses SMALLS() lookups in a VALID condition for a GET
ณ 
ณ  Returns:
ณ  --------
ณ  lValid  => logical value
ณ 
ณ  Syntax:
ณ  -------
ณ  SMALLVALID([bValid],expDisplayString,[cTitle],;
ณ     [expAlias],expReturn,[expStartRange,expEndRange],[bException])
ณ 
ณ  Description:
ณ  ------------
ณ  Uses SMALLS() in a VALID condition for a GET. See
ณ  SMALLS() for description of parameters <expDisplayString>
ณ  through [bException]
ณ 
ณ  If the user selects a value from the SMALLS() lookup,
ณ  a value of True is returned, allowing the next GET to be made
ณ  active. Otherwise, a False is returned. The return value is also
ณ  determined by [bValid]
ณ 
ณ  [bValid]  -  This is a code block that determines if
ณ  the current get is already valid. If this is passed, it is first
ณ  evaluated, and, only if the current get is NOT ALREADY VALID,
ณ  SMALLS() is called with the SMALLS() parameters given. If this
ณ  is not passed, SMALLS() is called automatically. IF this is
ณ  passed and the GET is valid, a True is returned, allowing the
ณ  next GET to be 'gotten'.
ณ 
ณ  Examples:
ณ  ---------
ณ   @3,0 GET V3 VALID  ;
ณ       SMALLVALID({||!EMPTY(V3)},"LASTNAME",nil,5,"LASTNAME")
ณ 
ณ   // This will pop up a smalls() lookup table when attempting to exit
ณ   // the get 'V3' where 'V3' is empty. A SMALLS() lookup is  called, with
ณ   // smalls() parameters provided, and, if CR is pressed, the GET is fed
ณ   // or assigned the lookup value. (depends on value of <expReturn>)
ณ   // If 'V3' is already valid, a True is returned, and the next GET is made
ณ   // active. If SMALLS() is called and CR is pressed while in SMALLS(),
ณ   // a True is returned. Otherwise a False is returned.
ณ 
ณ  Notes:
ณ  -------
ณ  See Smalls() for a complete parameter description.
ณ 
ณ  Source:
ณ  -------
ณ  S_SMGETS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SMALLVALID(bValid,expDisplayString,cTitle,;
                   expAlias,expReturn,expStartRange,expEndRange,bException)
local get  := getactive()
local lReturn := .f.
if bValid==nil .or. !eval(bValid)
   smalls(expDisplayString,cTitle,expAlias,expReturn,;
                   expStartRange,expEndRange,bException)
   if lastkey()==K_ENTER
     if valtype(expReturn)=="C" // must be a KEYBOARD, need to stuff the get
       smfeedk(get)
     endif
     get:updatebuffer()
     get:display()
     lReturn := .t.
   endif
else
  lReturn := .t.
endif
return lReturn



//---------------------------------------------------------------
static FUNCTION smfeedk(get)
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

