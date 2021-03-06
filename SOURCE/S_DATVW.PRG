#include "Inkey.ch"
#include "Getexit.ch"

//------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALENDWHEN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CALENDWHEN() Uses GETDATE() function as a GET WHEN clause
³ 
³ 
³  Returns:
³  --------
³  <lWhen> => when condition
³ 
³  Syntax:
³  -------
³  CALENDWHEN([lShowonUp],[lReturn])
³ 
³  Description:
³  ------------
³  This sets up the popup GETDATE() function for use in
³  a GET WHEN clause. (the pre validation block). If a date is
³  selected, it is assigned to the get. The Calendar function will
³  pop up upon entry into a GET field.
³ 
³  [lShowOnUp] Normally you wouldn't want this WHEN to
³  occur if the user is using the up arrow, and if <lShowOnUp> is
³  .f. (the default) it does not occur (the GET is just skipped)
³ 
³  [lReturn] If set to False (the default) the GET is
³  never actually edited, as the WHEN will always return .f., but
³  it is assigned the value returned by GETDATE(). By setting it to
³  True, the Calendar will pop up, and then the GET will also be
³  put through the normal get editor.
³ 
³  Examples:
³  ---------
³ 
³   proc test
³ 
³   v1 := date()
³   v2 := date()+1
³   v3 := date()+1
³   v4 := date()+1
³ 
³   @10,10 get v1
³   @11,10 get v2 when calendwhen(.f.) // calendar pops up  when the
³                                   // get is entered. No  direct
³                                   // editing.
³   @12,10 get v3 valid calendvalid( {||v3>date()} )
³   @13,10 get v4
³ 
³   read
³ 
³  Notes:
³  -------
³  You might want to look at CALENDVALID() and
³  CALENDKSET() for other options.
³ 
³  Source:
³  -------
³  S_DATVW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION CALENDWHEN(lShowOnUp,lReturn)
local get  := getactive()
local dValue := get:varget()
lReturn   := iif(lReturn#nil,lReturn,.f.)
lShowOnUp := iif(lShowOnUp#nil,lShowOnUp,.f.)
if !(get:exitstate==GE_UP .and. !lShowOnUp)
   dValue := getdate(dValue)
   if lastkey()==K_ENTER
     GET:varput(dValue)
     GET:updatebuffer()
   ENDIF
endif
return lReturn

//-------------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALENDVALID()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CALENDVALID() Uses GETDATE() popup calendar function as a GET
³  VALID clause
³ 
³ 
³  Returns:
³  --------
³  <lValid> => valid condition
³ 
³  Syntax:
³  -------
³  CALENDVALID([bValid])
³ 
³  Description:
³  ------------
³  This sets up the popup GETDATE() calendar for use in
³  a GET VALID clause. (the post validation block). If a value is
³  selected, it is assigned to the get. (if ESCAPE is pressed, it
³  is not) The Calendar function will pop up upon exit from a GET
³  field.
³ 
³  [bValid] If you pass a validation codeblock, it will
³  be checked first. If the GET is already valid, according to the
³  codeblock, the calculator will not be popped up. The codeblock
³  must return a logical value.
³ 
³  Examples:
³  ---------
³ 
³   proc test
³ 
³   v1 := date()
³   v2 := date()
³   v3 := date()
³   v4 := date()
³ 
³   @10,10 get v1
³   @11,10 get v2 when calendwhen(.f.)
³   @12,10 get v3 valid calendvalid( {||v3>date()}  )
³                      // note the validation block
³                      // IF V3 > date(), the calendar
³                      // will not be called
³   @13,10 get v4
³ 
³   read
³ 
³  Notes:
³  -------
³  You might want to look at CALENDWHEN() and
³  CALENDKSET() for other options.
³ 
³  Source:
³  -------
³  S_CALCVW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION CALENDVALID(bValid)
local lReturn := .f.
local get  := getactive()
local dValue := GET:varget()
if bValid==nil .or. !eval(bValid)
   dValue := GETDATE(dValue)
   if lastkey()==K_ENTER
     GET:varput(dValue)
     GET:updatebuffer()
     lReturn := iif(bValid#nil,eval(bValid),.t.)
   endif
else
  lReturn := .t.
endif
return lReturn

