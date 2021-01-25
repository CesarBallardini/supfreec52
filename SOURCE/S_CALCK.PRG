
static aAssigns := {}
/*
�����������������������������������������������������������������
� FUNCTION CALCKCLR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CALCKCLR() Clears hot keys set by CALCKSET()
� 
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  CALCKCLR()
� 
�  Description:
�  ------------
�  Clears hot keys set by CALCKSET()
� 
�  Examples:
�  ---------
�   // this will pop up a the calculator when F2 is pressed  while
�   // on the get V2. The value will be assigned to V2.
� 
�   proc test
�   v1 := 123
�   v2 := 456
� 
�   @10,10 get v1
�   @11,10 get v2
� 
�   CALCKSET(K_F2,"TEST","V2",.t.)
� 
�   read
� 
�   CALCKCLR()  // clear it out
� 
�  Source:
�  -------
�  S_CALCK.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION CALCKCLR()
local i
for i = 1 to len(aAssigns)  // clear the SET KEYs
  setkey(aAssigns[i,1])
next
aAssigns := {}
return nil

//------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION CALCKSET()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CALCKSET() Allows use of GETCALC() calculator in GETS
�
�  Returns:
�  --------
�  Nil
� 
�  Syntax:
�  -------
�  CALCKSET(nKey,cProc,cVar,lAssign)
� 
�  Description:
�  ------------
�  Sets up a call to GETCALC() when key <nKey> is
�  pressed while in proc or function <cProc> at variable <cVar>.
� 
�  If <lAssign> is True, the value returned from
�  GETCALC() is assigned to the current get. Use CALCKCLR() when
�  done.
� 
�  Examples:
�  ---------
�   // this will pop up a the calculator when F2 is pressed  while
�   // on the get V2. The value will be assigned to V2.
� 
�   proc test
� 
�   v1 := 123
�   v2 := 456
� 
�   @10,10 get v1
�   @11,10 get v2
� 
�   CALCKSET(K_F2,"TEST","V2",.t.)
� 
�   read
�
�   CALCKCLR()  // clear it out
� 
�  Source:
�  -------
�  S_CALCK.PRG
�
�����������������������������������������������������������������
*/
FUNCTION CALCKSET(nKey,cProc,cVar,lAssign)
lAssign := iif(lAssign#nil,lAssign,.f.)
aadd(aAssigns,{nKey,upper(cProc),upper(cVar),lAssign})
SetKey( nKey, {|p, l, v| CALCKEY(UPPER(p), l, UPPER(v))} )
return nil





//------------------------------------------------------------
STATIC FUNCTION CALCKEY(cProc,garbage,cVar)
local nfound
local aThis
local cValue
local nValue := 0
local nKey := lastkey()
local get  := getactive()
if (nFound := ascan(aAssigns,{|e|e[1]=nKey.and.e[2]==cProc.and.e[3]==cVar}) )> 0
   if aAssigns[nFound,4]
        nValue := get:varget()
   endif
   cValue := GETCALC(nValue)
   if aAssigns[nFound,4] .AND. lastkey()#27 .and. val(cValue)#0
     if messyn("Accept value:"+cValue)
       keyboard cValue
     endif
   endif
endif
return nil

