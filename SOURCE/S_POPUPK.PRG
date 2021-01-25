
static aAssigns := {}


//-----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION POPUPKCLR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  POPUPKCLR() Clears GET hotkey popups set up with POPUPKSET()
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  POPUPKCLR()
� 
�  Description:
�  ------------
�  Clears GET hotkey popups set up with POPUPKSET()
� 
�  See POPUPKSET()
� 
�  Examples:
�  ---------
�   POPUPKCLR()
� 
�  Source:
�  -------
�  S_POPUPK.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION POPUPKSET()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  POPUPKSET() Set a popup for hotkey access from a GET
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  POPUPKSET(nKey,cProc,cVar,bPopup)
� 
�  Description:
�  ------------
�  When key <nKey> is pressed while in proc or function
�  <cProc> and in get/variable <cVar>, the block <bPopup> will be
�  evaluated.
� 
�  If <bPopup> returns a value, it will be assigned to
�  the current get.
� 
�  Be sure to clear popups with POPUPKCLR() after the
�  READ.
� 
�  Examples:
�  ---------
�   #include "inkey.ch"
� 
�   proc test
�   b1 := {||msg("Character value"),"Bert"}
�   b2 := {||msg("Logical value"),.t.}
�   b3 := {||msg("Date value"),date()+100}
�   b4 := {||msg("Number value"),123}
� 
�   v1 := space(10)
�   v2 := .f.
�   v3 := ctod("  /  /  ")
�   v4 := 0
� 
�   POPUPKSET(K_F1,"TEST","V1",b1)
�   POPUPKSET(K_F2,"TEST","V2",b2)
�   POPUPKSET(K_F3,"TEST","V3",b3)
�   POPUPKSET(K_F4,"TEST","V4",b4)
� 
�   @14,10 get v1      // if F1 is pressed here, b1 will be evaluated
�   @15,10 get v2      // if F2 is pressed here, b2 will be evaluated
�   @16,10 get v3      // if F3 is pressed here, b3 will be evaluated
�   @17,10 get v4      // if F4 is pressed here, b4 will be evaluated
� 
�   read
� 
�   POPUPKCLR()
� 
�  Source:
�  -------
�  S_POPUPK.PRG
� 
����������������������������������������������������������������� 
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

