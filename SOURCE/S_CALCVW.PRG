
#include "Inkey.ch"
#include "Getexit.ch"

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALCWHEN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  CALCWHEN() Uses GETCALC() calculator function as a GET WHEN
³  clause
³
³  Returns:
³  --------
³  <lWhen> => when condition
³
³  Syntax:
³  -------
³  CALCWHEN([lShowonUp],[lReturn])
³
³  Description:
³  ------------
³  This sets up the popup GETCALC() calculator for use
³  in a GET WHEN clause. (the pre validation block). If a value is
³  selected, it is assigned to the get. (if ESCAPE is pressed, it
³  is no) The Calculator function will pop up upon entry into a GET
³  field.
³
³  [lShowOnUp] Normally you wouldn't want this WHEN to
³  occur if the user is using the up arrow, and if <lShowOnUp> is
³  .f. (the default) it does not occur (the GET is just skipped)
³
³  [lReturn] If set to False (the default) the GET is
³  never actually edited, as the WHEN will always return .f., but
³  it is assigned the value returned by GETCALC(). By setting it to
³  True, the Calculator will pop up, and then the GET will also be
³  put thorugh the normal get editor.
³
³  Examples:
³  ---------
³ 
³   proc test
³ 
³   v1 := 10
³   v2 := 10
³   v3 := 10
³   v4 := 10
³ 
³   @10,10 get v1
³   @11,10 get v2 when calcwhen(.f.)   // calculator pops up  when
³                                   // get is entered. No  direct
³                                   // editing.
³   @12,10 get v3 valid calcvalid(  {||v3>0}  )
³   @13,10 get v4
³ 
³   read
³ 
³  Notes:
³  -------
³  You might want to look at CALCVALID() and CALCKSET()
³  for other options.
³ 
³  Source:
³  -------
³  S_CALCVW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALCVALID()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  CALCVALID() Uses GETCALC() calculator function as a GET VALID
³  clause
³
³  Returns:
³  --------
³  <lValid> => valid condition
³
³  Syntax:
³  -------
³  CALCVALID([bValid])
³
³  Description:
³  ------------
³  This sets up the popup GETCALC() calculator for use
³  in a GET VALID clause. (the post validation block). If a value
³  is selected, it is assigned to the get. (if ESCAPE is pressed,
³  it is not) The Calculator function will pop up upon exit from a
³  GET field.
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
³   v1 := 10
³   v2 := 10
³   v3 := 10
³   v4 := 10
³ 
³   @10,10 get v1
³   @11,10 get v2 when calcwhen(.f.)
³   @12,10 get v3 valid calcvalid( {||v3>0}  )   // note the valid                                           // block
³                                                 // IF V3 > 0, the calculator
³                                                  // will not be called
³   @13,10 get v4
³ 
³   read
³ 
³  Notes:
³  -------
³  You might want to look at CALCWHEN() and CALCKSET()
³  for other options.
³ 
³  Source:
³  -------
³  S_CALCVW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

