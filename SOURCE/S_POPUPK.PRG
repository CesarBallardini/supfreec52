
static aAssigns := {}


//-----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPUPKCLR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPUPKCLR() Clears GET hotkey popups set up with POPUPKSET()
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  POPUPKCLR()
³ 
³  Description:
³  ------------
³  Clears GET hotkey popups set up with POPUPKSET()
³ 
³  See POPUPKSET()
³ 
³  Examples:
³  ---------
³   POPUPKCLR()
³ 
³  Source:
³  -------
³  S_POPUPK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPUPKSET()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPUPKSET() Set a popup for hotkey access from a GET
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  POPUPKSET(nKey,cProc,cVar,bPopup)
³ 
³  Description:
³  ------------
³  When key <nKey> is pressed while in proc or function
³  <cProc> and in get/variable <cVar>, the block <bPopup> will be
³  evaluated.
³ 
³  If <bPopup> returns a value, it will be assigned to
³  the current get.
³ 
³  Be sure to clear popups with POPUPKCLR() after the
³  READ.
³ 
³  Examples:
³  ---------
³   #include "inkey.ch"
³ 
³   proc test
³   b1 := {||msg("Character value"),"Bert"}
³   b2 := {||msg("Logical value"),.t.}
³   b3 := {||msg("Date value"),date()+100}
³   b4 := {||msg("Number value"),123}
³ 
³   v1 := space(10)
³   v2 := .f.
³   v3 := ctod("  /  /  ")
³   v4 := 0
³ 
³   POPUPKSET(K_F1,"TEST","V1",b1)
³   POPUPKSET(K_F2,"TEST","V2",b2)
³   POPUPKSET(K_F3,"TEST","V3",b3)
³   POPUPKSET(K_F4,"TEST","V4",b4)
³ 
³   @14,10 get v1      // if F1 is pressed here, b1 will be evaluated
³   @15,10 get v2      // if F2 is pressed here, b2 will be evaluated
³   @16,10 get v3      // if F3 is pressed here, b3 will be evaluated
³   @17,10 get v4      // if F4 is pressed here, b4 will be evaluated
³ 
³   read
³ 
³   POPUPKCLR()
³ 
³  Source:
³  -------
³  S_POPUPK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


