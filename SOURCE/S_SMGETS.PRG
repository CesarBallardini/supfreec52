#include "Inkey.ch"
#include "Getexit.ch"


//------------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SMALLWHEN()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SMALLWHEN() Uses SMALLS() in a WHEN condition for a GET
� 
�  Returns:
�  --------
�  lValid  => logical value
� 
�  Syntax:
�  -------
�  SMALLWHEN([lShowOnUp],[lReturn],expDisplayString,[cTitle],;
�       [expAlias],expReturn,[expStartRange,expEndRange],[bException])
� 
�  Description:
�  ------------
�  Uses SMALLS() in a WHEN condition for a GET. See
�  SMALLS() for description of parameters <expDisplayString>
�  through [bException]
� 
�  [lShowOnUp] If False (the default), smalls is not
�  called when going backwards through the read (up arrow, etc), only when
�  going forward.
� 
�  [lReturn]   This is simply the value to return. The
�  default is False, which means the get is never 'edited'. A value
�  of True means the smalls() lookup is done, and then the get is edited.
� 
�  Examples:
�  ---------
�   @3,0 GET V3 WHEN ;
�       SMALLWHEN(.f.,.f.,"LASTNAME",nil,5,"LASTNAME")
� 
�   // This will pop up a smalls() lookup table when going forward
�   // through the gets. If RETURN is pressed, the current GET is fed
�   // or assigned the lookup value. (depends on value of <expReturn>)
�   // A False is returned, so the GET is not actually edited. The new
�   // value is displayed, and the next get is made active.
� 
�  Notes:
�  -------
�  See Smalls() for a complete parameter description.
� 
�  Source:
�  -------
�  S_SMGETS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SMALLVALID()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SMALLVALID() Uses SMALLS() lookups in a VALID condition for a GET
� 
�  Returns:
�  --------
�  lValid  => logical value
� 
�  Syntax:
�  -------
�  SMALLVALID([bValid],expDisplayString,[cTitle],;
�     [expAlias],expReturn,[expStartRange,expEndRange],[bException])
� 
�  Description:
�  ------------
�  Uses SMALLS() in a VALID condition for a GET. See
�  SMALLS() for description of parameters <expDisplayString>
�  through [bException]
� 
�  If the user selects a value from the SMALLS() lookup,
�  a value of True is returned, allowing the next GET to be made
�  active. Otherwise, a False is returned. The return value is also
�  determined by [bValid]
� 
�  [bValid]  -  This is a code block that determines if
�  the current get is already valid. If this is passed, it is first
�  evaluated, and, only if the current get is NOT ALREADY VALID,
�  SMALLS() is called with the SMALLS() parameters given. If this
�  is not passed, SMALLS() is called automatically. IF this is
�  passed and the GET is valid, a True is returned, allowing the
�  next GET to be 'gotten'.
� 
�  Examples:
�  ---------
�   @3,0 GET V3 VALID  ;
�       SMALLVALID({||!EMPTY(V3)},"LASTNAME",nil,5,"LASTNAME")
� 
�   // This will pop up a smalls() lookup table when attempting to exit
�   // the get 'V3' where 'V3' is empty. A SMALLS() lookup is  called, with
�   // smalls() parameters provided, and, if CR is pressed, the GET is fed
�   // or assigned the lookup value. (depends on value of <expReturn>)
�   // If 'V3' is already valid, a True is returned, and the next GET is made
�   // active. If SMALLS() is called and CR is pressed while in SMALLS(),
�   // a True is returned. Otherwise a False is returned.
� 
�  Notes:
�  -------
�  See Smalls() for a complete parameter description.
� 
�  Source:
�  -------
�  S_SMGETS.PRG
� 
����������������������������������������������������������������� 
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
