

static aAssigns := {}
//-----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION CALENDKCLR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CALENDKCLR() Clears hot keys set up by CALENDKSET()
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  CALENDKCLR()
� 
�  Description:
�  ------------
�  Clears hot keys set up by CALENDKSET(). Always use
�  this after using CALENDKSET()
� 
�  Examples:
�  ---------
�   // this will pop up a the calendar when F2 is pressed while
�   // on the get V2. The value will be assigned to V2.
� 
�   proc test
�   local v1 := DATE(), v2 := DATE()+1
�   @10,10 get v1
�   @11,10 get v2
� 
�   CALENDKSET(K_F2,"TEST","V2",.t.)
� 
�   read
� 
�   CALENDKCLR()  // clear it out
� 
�  Source:
�  -------
�  S_DATEK.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION CALENDKCLR()
local i
for i = 1 to len(aAssigns)  // clear the SET KEYs
  setkey(aAssigns[i,1])
next
aAssigns := {}
return nil

//------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION CALENDKSET()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CALENDKSET() Allows use of GETDATE() calendar in GETS
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  CALENDKSET(nKey,cProc,cVar,lAssign)
� 
�  Description:
�  ------------
�  Sets up a call to GETDATE() when key <nKey> is
�  pressed while in proc or function <cProc> at variable <cVar>.
� 
�  If <lAssign> is True, the value returned from
�  GETDATE() is assigned to the current get. Use CALENDKCLR() when
�  done.
� 
�  Examples:
�  ---------
� 
�  // this will pop up a the calendar when F2 is pressed while
�  // on the get V2. The value will be assigned to V2.
� 
�  proc test
�  local v1 := DATE(),  v2 := DATE()+1
�  @10,10 get v1
�  @11,10 get v2
�  CALENDKSET(K_F2,"TEST","V2",.t.)
�  read
� 
�  CALENDKCLR()  // clear it out
� 
�  Source:
�  -------
�  S_DATEK.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION CALENDKSET(nKey,cProc,cVar,lAssign)
lAssign := iif(lAssign#nil,lAssign,.f.)
aadd(aAssigns,{nKey,upper(cProc),upper(cVar),lAssign})
SetKey( nKey, {|p, l, v| CALENDKEY(UPPER(p), l, UPPER(v))} )
return nil


//------------------------------------------------------------
STATIC FUNCTION CALENDKEY(cProc,garbage,cVar)
local nfound
local aThis
local dValue := date()
local nKey := lastkey()
local get  := getactive()
if (nFound := ascan(aAssigns,{|e|e[1]=nKey.and.e[2]==cProc.and.e[3]==cVar}) )> 0
   if aAssigns[nFound,4]
      dValue := get:varget()
   endif
   dValue := GETDATE(dValue)
   if aAssigns[nFound,4] .and. lastkey()#27
     if multimsgyn({"Accept value:",dtoc(dValue)})
         get:varput(dValue)
         get:updatebuffer()
     endif
   endif
endif
return nil