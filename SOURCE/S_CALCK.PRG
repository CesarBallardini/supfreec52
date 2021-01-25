
static aAssigns := {}
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALCKCLR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CALCKCLR() Clears hot keys set by CALCKSET()
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  CALCKCLR()
ณ 
ณ  Description:
ณ  ------------
ณ  Clears hot keys set by CALCKSET()
ณ 
ณ  Examples:
ณ  ---------
ณ   // this will pop up a the calculator when F2 is pressed  while
ณ   // on the get V2. The value will be assigned to V2.
ณ 
ณ   proc test
ณ   v1 := 123
ณ   v2 := 456
ณ 
ณ   @10,10 get v1
ณ   @11,10 get v2
ณ 
ณ   CALCKSET(K_F2,"TEST","V2",.t.)
ณ 
ณ   read
ณ 
ณ   CALCKCLR()  // clear it out
ณ 
ณ  Source:
ณ  -------
ณ  S_CALCK.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALCKSET()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CALCKSET() Allows use of GETCALC() calculator in GETS
ณ
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  CALCKSET(nKey,cProc,cVar,lAssign)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets up a call to GETCALC() when key <nKey> is
ณ  pressed while in proc or function <cProc> at variable <cVar>.
ณ 
ณ  If <lAssign> is True, the value returned from
ณ  GETCALC() is assigned to the current get. Use CALCKCLR() when
ณ  done.
ณ 
ณ  Examples:
ณ  ---------
ณ   // this will pop up a the calculator when F2 is pressed  while
ณ   // on the get V2. The value will be assigned to V2.
ณ 
ณ   proc test
ณ 
ณ   v1 := 123
ณ   v2 := 456
ณ 
ณ   @10,10 get v1
ณ   @11,10 get v2
ณ 
ณ   CALCKSET(K_F2,"TEST","V2",.t.)
ณ 
ณ   read
ณ
ณ   CALCKCLR()  // clear it out
ณ 
ณ  Source:
ณ  -------
ณ  S_CALCK.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
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


