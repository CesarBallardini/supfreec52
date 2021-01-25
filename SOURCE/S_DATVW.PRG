#include "Inkey.ch"
#include "Getexit.ch"

//------------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION CALENDWHEN()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CALENDWHEN() Uses GETDATE() function as a GET WHEN clause
� 
� 
�  Returns:
�  --------
�  <lWhen> => when condition
� 
�  Syntax:
�  -------
�  CALENDWHEN([lShowonUp],[lReturn])
� 
�  Description:
�  ------------
�  This sets up the popup GETDATE() function for use in
�  a GET WHEN clause. (the pre validation block). If a date is
�  selected, it is assigned to the get. The Calendar function will
�  pop up upon entry into a GET field.
� 
�  [lShowOnUp] Normally you wouldn't want this WHEN to
�  occur if the user is using the up arrow, and if <lShowOnUp> is
�  .f. (the default) it does not occur (the GET is just skipped)
� 
�  [lReturn] If set to False (the default) the GET is
�  never actually edited, as the WHEN will always return .f., but
�  it is assigned the value returned by GETDATE(). By setting it to
�  True, the Calendar will pop up, and then the GET will also be
�  put through the normal get editor.
� 
�  Examples:
�  ---------
� 
�   proc test
� 
�   v1 := date()
�   v2 := date()+1
�   v3 := date()+1
�   v4 := date()+1
� 
�   @10,10 get v1
�   @11,10 get v2 when calendwhen(.f.) // calendar pops up  when the
�                                   // get is entered. No  direct
�                                   // editing.
�   @12,10 get v3 valid calendvalid( {||v3>date()} )
�   @13,10 get v4
� 
�   read
� 
�  Notes:
�  -------
�  You might want to look at CALENDVALID() and
�  CALENDKSET() for other options.
� 
�  Source:
�  -------
�  S_DATVW.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION CALENDVALID()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CALENDVALID() Uses GETDATE() popup calendar function as a GET
�  VALID clause
� 
� 
�  Returns:
�  --------
�  <lValid> => valid condition
� 
�  Syntax:
�  -------
�  CALENDVALID([bValid])
� 
�  Description:
�  ------------
�  This sets up the popup GETDATE() calendar for use in
�  a GET VALID clause. (the post validation block). If a value is
�  selected, it is assigned to the get. (if ESCAPE is pressed, it
�  is not) The Calendar function will pop up upon exit from a GET
�  field.
� 
�  [bValid] If you pass a validation codeblock, it will
�  be checked first. If the GET is already valid, according to the
�  codeblock, the calculator will not be popped up. The codeblock
�  must return a logical value.
� 
�  Examples:
�  ---------
� 
�   proc test
� 
�   v1 := date()
�   v2 := date()
�   v3 := date()
�   v4 := date()
� 
�   @10,10 get v1
�   @11,10 get v2 when calendwhen(.f.)
�   @12,10 get v3 valid calendvalid( {||v3>date()}  )
�                      // note the validation block
�                      // IF V3 > date(), the calendar
�                      // will not be called
�   @13,10 get v4
� 
�   read
� 
�  Notes:
�  -------
�  You might want to look at CALENDWHEN() and
�  CALENDKSET() for other options.
� 
�  Source:
�  -------
�  S_CALCVW.PRG
� 
����������������������������������������������������������������� 
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
