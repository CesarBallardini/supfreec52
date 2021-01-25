
#include "Inkey.ch"
#include "Getexit.ch"

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALCWHEN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  CALCWHEN() Uses GETCALC() calculator function as a GET WHEN
ณ  clause
ณ
ณ  Returns:
ณ  --------
ณ  <lWhen> => when condition
ณ
ณ  Syntax:
ณ  -------
ณ  CALCWHEN([lShowonUp],[lReturn])
ณ
ณ  Description:
ณ  ------------
ณ  This sets up the popup GETCALC() calculator for use
ณ  in a GET WHEN clause. (the pre validation block). If a value is
ณ  selected, it is assigned to the get. (if ESCAPE is pressed, it
ณ  is no) The Calculator function will pop up upon entry into a GET
ณ  field.
ณ
ณ  [lShowOnUp] Normally you wouldn't want this WHEN to
ณ  occur if the user is using the up arrow, and if <lShowOnUp> is
ณ  .f. (the default) it does not occur (the GET is just skipped)
ณ
ณ  [lReturn] If set to False (the default) the GET is
ณ  never actually edited, as the WHEN will always return .f., but
ณ  it is assigned the value returned by GETCALC(). By setting it to
ณ  True, the Calculator will pop up, and then the GET will also be
ณ  put thorugh the normal get editor.
ณ
ณ  Examples:
ณ  ---------
ณ 
ณ   proc test
ณ 
ณ   v1 := 10
ณ   v2 := 10
ณ   v3 := 10
ณ   v4 := 10
ณ 
ณ   @10,10 get v1
ณ   @11,10 get v2 when calcwhen(.f.)   // calculator pops up  when
ณ                                   // get is entered. No  direct
ณ                                   // editing.
ณ   @12,10 get v3 valid calcvalid(  {||v3>0}  )
ณ   @13,10 get v4
ณ 
ณ   read
ณ 
ณ  Notes:
ณ  -------
ณ  You might want to look at CALCVALID() and CALCKSET()
ณ  for other options.
ณ 
ณ  Source:
ณ  -------
ณ  S_CALCVW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALCVALID()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  CALCVALID() Uses GETCALC() calculator function as a GET VALID
ณ  clause
ณ
ณ  Returns:
ณ  --------
ณ  <lValid> => valid condition
ณ
ณ  Syntax:
ณ  -------
ณ  CALCVALID([bValid])
ณ
ณ  Description:
ณ  ------------
ณ  This sets up the popup GETCALC() calculator for use
ณ  in a GET VALID clause. (the post validation block). If a value
ณ  is selected, it is assigned to the get. (if ESCAPE is pressed,
ณ  it is not) The Calculator function will pop up upon exit from a
ณ  GET field.
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
ณ   v1 := 10
ณ   v2 := 10
ณ   v3 := 10
ณ   v4 := 10
ณ 
ณ   @10,10 get v1
ณ   @11,10 get v2 when calcwhen(.f.)
ณ   @12,10 get v3 valid calcvalid( {||v3>0}  )   // note the valid                                           // block
ณ                                                 // IF V3 > 0, the calculator
ณ                                                  // will not be called
ณ   @13,10 get v4
ณ 
ณ   read
ณ 
ณ  Notes:
ณ  -------
ณ  You might want to look at CALCWHEN() and CALCKSET()
ณ  for other options.
ณ 
ณ  Source:
ณ  -------
ณ  S_CALCVW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

