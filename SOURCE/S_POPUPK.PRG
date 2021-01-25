
static aAssigns := {}


//-----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION POPUPKCLR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  POPUPKCLR() Clears GET hotkey popups set up with POPUPKSET()
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  POPUPKCLR()
ณ 
ณ  Description:
ณ  ------------
ณ  Clears GET hotkey popups set up with POPUPKSET()
ณ 
ณ  See POPUPKSET()
ณ 
ณ  Examples:
ณ  ---------
ณ   POPUPKCLR()
ณ 
ณ  Source:
ณ  -------
ณ  S_POPUPK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION POPUPKCLR()
local i
for i = 1 to len(aAssigns)  // clear the SET KEYs
  setkey(aAssigns[i,1])
next
aAssigns := {}
return nil

//------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION POPUPKSET()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  POPUPKSET() Set a popup for hotkey access from a GET
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  POPUPKSET(nKey,cProc,cVar,bPopup)
ณ 
ณ  Description:
ณ  ------------
ณ  When key <nKey> is pressed while in proc or function
ณ  <cProc> and in get/variable <cVar>, the block <bPopup> will be
ณ  evaluated.
ณ 
ณ  If <bPopup> returns a value, it will be assigned to
ณ  the current get.
ณ 
ณ  Be sure to clear popups with POPUPKCLR() after the
ณ  READ.
ณ 
ณ  Examples:
ณ  ---------
ณ   #include "inkey.ch"
ณ 
ณ   proc test
ณ   b1 := {||msg("Character value"),"Bert"}
ณ   b2 := {||msg("Logical value"),.t.}
ณ   b3 := {||msg("Date value"),date()+100}
ณ   b4 := {||msg("Number value"),123}
ณ 
ณ   v1 := space(10)
ณ   v2 := .f.
ณ   v3 := ctod("  /  /  ")
ณ   v4 := 0
ณ 
ณ   POPUPKSET(K_F1,"TEST","V1",b1)
ณ   POPUPKSET(K_F2,"TEST","V2",b2)
ณ   POPUPKSET(K_F3,"TEST","V3",b3)
ณ   POPUPKSET(K_F4,"TEST","V4",b4)
ณ 
ณ   @14,10 get v1      // if F1 is pressed here, b1 will be evaluated
ณ   @15,10 get v2      // if F2 is pressed here, b2 will be evaluated
ณ   @16,10 get v3      // if F3 is pressed here, b3 will be evaluated
ณ   @17,10 get v4      // if F4 is pressed here, b4 will be evaluated
ณ 
ณ   read
ณ 
ณ   POPUPKCLR()
ณ 
ณ  Source:
ณ  -------
ณ  S_POPUPK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION POPUPKSET(nKey,cProc,cVar,bPopup)
aadd(aAssigns,{nKey,left(upper(cProc),10),upper(cVar),bPopup})
SetKey( nKey, {|p, l, v| POPUPKEY(UPPER(p), l, UPPER(v))} )
return nil


//------------------------------------------------------------
STATIC FUNCTION POPUPKEY(cProc,garbage,cVar)
local nfound
local aThis
local cValue
local expValue
local nKey := lastkey()
local get  := getactive()
if (nFound := ascan(aAssigns,{|e|e[1]==nKey.and.e[2]==cProc.and.e[3]==cVar}) )> 0
   expValue := get:varget()
   expValue := eval(aAssigns[nFound,4],expValue)
   if expValue#nil
    if valtype(expValue)=="N"
     keyboard alltrim(str(expValue))
     popfeedk(get )
    else
     get:varput(expValue)
     get:updatebuffer()
    endif
   endif
endif
return nil


//---------------------------------------------------------------
static FUNCTION popfeedk(get)
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


