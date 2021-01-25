#include "Inkey.ch"
#include "Getexit.ch"

//------------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALENDWHEN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CALENDWHEN() Uses GETDATE() function as a GET WHEN clause
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <lWhen> => when condition
ณ 
ณ  Syntax:
ณ  -------
ณ  CALENDWHEN([lShowonUp],[lReturn])
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the popup GETDATE() function for use in
ณ  a GET WHEN clause. (the pre validation block). If a date is
ณ  selected, it is assigned to the get. The Calendar function will
ณ  pop up upon entry into a GET field.
ณ 
ณ  [lShowOnUp] Normally you wouldn't want this WHEN to
ณ  occur if the user is using the up arrow, and if <lShowOnUp> is
ณ  .f. (the default) it does not occur (the GET is just skipped)
ณ 
ณ  [lReturn] If set to False (the default) the GET is
ณ  never actually edited, as the WHEN will always return .f., but
ณ  it is assigned the value returned by GETDATE(). By setting it to
ณ  True, the Calendar will pop up, and then the GET will also be
ณ  put through the normal get editor.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   proc test
ณ 
ณ   v1 := date()
ณ   v2 := date()+1
ณ   v3 := date()+1
ณ   v4 := date()+1
ณ 
ณ   @10,10 get v1
ณ   @11,10 get v2 when calendwhen(.f.) // calendar pops up  when the
ณ                                   // get is entered. No  direct
ณ                                   // editing.
ณ   @12,10 get v3 valid calendvalid( {||v3>date()} )
ณ   @13,10 get v4
ณ 
ณ   read
ณ 
ณ  Notes:
ณ  -------
ณ  You might want to look at CALENDVALID() and
ณ  CALENDKSET() for other options.
ณ 
ณ  Source:
ณ  -------
ณ  S_DATVW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALENDVALID()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CALENDVALID() Uses GETDATE() popup calendar function as a GET
ณ  VALID clause
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <lValid> => valid condition
ณ 
ณ  Syntax:
ณ  -------
ณ  CALENDVALID([bValid])
ณ 
ณ  Description:
ณ  ------------
ณ  This sets up the popup GETDATE() calendar for use in
ณ  a GET VALID clause. (the post validation block). If a value is
ณ  selected, it is assigned to the get. (if ESCAPE is pressed, it
ณ  is not) The Calendar function will pop up upon exit from a GET
ณ  field.
ณ 
ณ  [bValid] If you pass a validation codeblock, it will
ณ  be checked first. If the GET is already valid, according to the
ณ  codeblock, the calculator will not be popped up. The codeblock
ณ  must return a logical value.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   proc test
ณ 
ณ   v1 := date()
ณ   v2 := date()
ณ   v3 := date()
ณ   v4 := date()
ณ 
ณ   @10,10 get v1
ณ   @11,10 get v2 when calendwhen(.f.)
ณ   @12,10 get v3 valid calendvalid( {||v3>date()}  )
ณ                      // note the validation block
ณ                      // IF V3 > date(), the calendar
ณ                      // will not be called
ณ   @13,10 get v4
ณ 
ณ   read
ณ 
ณ  Notes:
ณ  -------
ณ  You might want to look at CALENDWHEN() and
ณ  CALENDKSET() for other options.
ณ 
ณ  Source:
ณ  -------
ณ  S_CALCVW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

