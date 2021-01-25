
#include "Inkey.ch"
#include "Getexit.ch"

/*
�����������������������������������������������������������������
� FUNCTION CALCWHEN()
�����������������������������������������������������������������
�
�  Short:
�  ------
�  CALCWHEN() Uses GETCALC() calculator function as a GET WHEN
�  clause
�
�  Returns:
�  --------
�  <lWhen> => when condition
�
�  Syntax:
�  -------
�  CALCWHEN([lShowonUp],[lReturn])
�
�  Description:
�  ------------
�  This sets up the popup GETCALC() calculator for use
�  in a GET WHEN clause. (the pre validation block). If a value is
�  selected, it is assigned to the get. (if ESCAPE is pressed, it
�  is no) The Calculator function will pop up upon entry into a GET
�  field.
�
�  [lShowOnUp] Normally you wouldn't want this WHEN to
�  occur if the user is using the up arrow, and if <lShowOnUp> is
�  .f. (the default) it does not occur (the GET is just skipped)
�
�  [lReturn] If set to False (the default) the GET is
�  never actually edited, as the WHEN will always return .f., but
�  it is assigned the value returned by GETCALC(). By setting it to
�  True, the Calculator will pop up, and then the GET will also be
�  put thorugh the normal get editor.
�
�  Examples:
�  ---------
� 
�   proc test
� 
�   v1 := 10
�   v2 := 10
�   v3 := 10
�   v4 := 10
� 
�   @10,10 get v1
�   @11,10 get v2 when calcwhen(.f.)   // calculator pops up  when
�                                   // get is entered. No  direct
�                                   // editing.
�   @12,10 get v3 valid calcvalid(  {||v3>0}  )
�   @13,10 get v4
� 
�   read
� 
�  Notes:
�  -------
�  You might want to look at CALCVALID() and CALCKSET()
�  for other options.
� 
�  Source:
�  -------
�  S_CALCVW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION CALCWHEN(lShowOnUp,lReturn)
local get     := getactive()
local nValue  := get:varget()
lReturn       := iif(lReturn#nil,lReturn,.f.)
lShowOnUp     := iif(lShowOnUp#nil,lShowOnUp,.f.)
if !(get:exitstate==GE_UP .and. !lShowOnUp)
   nValue := getcalc(nValue,.f.)
   if lastkey()#K_ESC .and. nValue # 0
     keyboard alltrim(str(nValue))
     calfeedk(get)
   ENDIF
endif
return lReturn

//-------------------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION CALCVALID()
�����������������������������������������������������������������
�
�  Short:
�  ------
�  CALCVALID() Uses GETCALC() calculator function as a GET VALID
�  clause
�
�  Returns:
�  --------
�  <lValid> => valid condition
�
�  Syntax:
�  -------
�  CALCVALID([bValid])
�
�  Description:
�  ------------
�  This sets up the popup GETCALC() calculator for use
�  in a GET VALID clause. (the post validation block). If a value
�  is selected, it is assigned to the get. (if ESCAPE is pressed,
�  it is not) The Calculator function will pop up upon exit from a
�  GET field.
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
�   v1 := 10
�   v2 := 10
�   v3 := 10
�   v4 := 10
� 
�   @10,10 get v1
�   @11,10 get v2 when calcwhen(.f.)
�   @12,10 get v3 valid calcvalid( {||v3>0}  )   // note the valid                                           // block
�                                                 // IF V3 > 0, the calculator
�                                                  // will not be called
�   @13,10 get v4
� 
�   read
� 
�  Notes:
�  -------
�  You might want to look at CALCWHEN() and CALCKSET()
�  for other options.
� 
�  Source:
�  -------
�  S_CALCVW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION CALCVALID(bValid)
local get  := getactive()
local lReturn := .f.
local nValue := get:varget()
if bValid==nil .or. !eval(bValid)
   nValue := GETCALC(nValue,.F.)
   if lastkey()#K_ESC .and. nValue # 0
     keyboard alltrim(str(nValue))
     calfeedk(get)
     lReturn := iif(bValid#nil,eval(bValid),.t.)
   endif
else
  lReturn := .t.
endif
return lReturn


//---------------------------------------------------------------
static FUNCTION calfeedk(get)
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
