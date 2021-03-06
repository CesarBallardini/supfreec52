#include "Inkey.ch"
#include "Getexit.ch"


//------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SMALLWHEN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SMALLWHEN() Uses SMALLS() in a WHEN condition for a GET
³ 
³  Returns:
³  --------
³  lValid  => logical value
³ 
³  Syntax:
³  -------
³  SMALLWHEN([lShowOnUp],[lReturn],expDisplayString,[cTitle],;
³       [expAlias],expReturn,[expStartRange,expEndRange],[bException])
³ 
³  Description:
³  ------------
³  Uses SMALLS() in a WHEN condition for a GET. See
³  SMALLS() for description of parameters <expDisplayString>
³  through [bException]
³ 
³  [lShowOnUp] If False (the default), smalls is not
³  called when going backwards through the read (up arrow, etc), only when
³  going forward.
³ 
³  [lReturn]   This is simply the value to return. The
³  default is False, which means the get is never 'edited'. A value
³  of True means the smalls() lookup is done, and then the get is edited.
³ 
³  Examples:
³  ---------
³   @3,0 GET V3 WHEN ;
³       SMALLWHEN(.f.,.f.,"LASTNAME",nil,5,"LASTNAME")
³ 
³   // This will pop up a smalls() lookup table when going forward
³   // through the gets. If RETURN is pressed, the current GET is fed
³   // or assigned the lookup value. (depends on value of <expReturn>)
³   // A False is returned, so the GET is not actually edited. The new
³   // value is displayed, and the next get is made active.
³ 
³  Notes:
³  -------
³  See Smalls() for a complete parameter description.
³ 
³  Source:
³  -------
³  S_SMGETS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SMALLVALID()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SMALLVALID() Uses SMALLS() lookups in a VALID condition for a GET
³ 
³  Returns:
³  --------
³  lValid  => logical value
³ 
³  Syntax:
³  -------
³  SMALLVALID([bValid],expDisplayString,[cTitle],;
³     [expAlias],expReturn,[expStartRange,expEndRange],[bException])
³ 
³  Description:
³  ------------
³  Uses SMALLS() in a VALID condition for a GET. See
³  SMALLS() for description of parameters <expDisplayString>
³  through [bException]
³ 
³  If the user selects a value from the SMALLS() lookup,
³  a value of True is returned, allowing the next GET to be made
³  active. Otherwise, a False is returned. The return value is also
³  determined by [bValid]
³ 
³  [bValid]  -  This is a code block that determines if
³  the current get is already valid. If this is passed, it is first
³  evaluated, and, only if the current get is NOT ALREADY VALID,
³  SMALLS() is called with the SMALLS() parameters given. If this
³  is not passed, SMALLS() is called automatically. IF this is
³  passed and the GET is valid, a True is returned, allowing the
³  next GET to be 'gotten'.
³ 
³  Examples:
³  ---------
³   @3,0 GET V3 VALID  ;
³       SMALLVALID({||!EMPTY(V3)},"LASTNAME",nil,5,"LASTNAME")
³ 
³   // This will pop up a smalls() lookup table when attempting to exit
³   // the get 'V3' where 'V3' is empty. A SMALLS() lookup is  called, with
³   // smalls() parameters provided, and, if CR is pressed, the GET is fed
³   // or assigned the lookup value. (depends on value of <expReturn>)
³   // If 'V3' is already valid, a True is returned, and the next GET is made
³   // active. If SMALLS() is called and CR is pressed while in SMALLS(),
³   // a True is returned. Otherwise a False is returned.
³ 
³  Notes:
³  -------
³  See Smalls() for a complete parameter description.
³ 
³  Source:
³  -------
³  S_SMGETS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

