
static aAssigns := {}
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALCKCLR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CALCKCLR() Clears hot keys set by CALCKSET()
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  CALCKCLR()
³ 
³  Description:
³  ------------
³  Clears hot keys set by CALCKSET()
³ 
³  Examples:
³  ---------
³   // this will pop up a the calculator when F2 is pressed  while
³   // on the get V2. The value will be assigned to V2.
³ 
³   proc test
³   v1 := 123
³   v2 := 456
³ 
³   @10,10 get v1
³   @11,10 get v2
³ 
³   CALCKSET(K_F2,"TEST","V2",.t.)
³ 
³   read
³ 
³   CALCKCLR()  // clear it out
³ 
³  Source:
³  -------
³  S_CALCK.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALCKSET()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CALCKSET() Allows use of GETCALC() calculator in GETS
³
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  CALCKSET(nKey,cProc,cVar,lAssign)
³ 
³  Description:
³  ------------
³  Sets up a call to GETCALC() when key <nKey> is
³  pressed while in proc or function <cProc> at variable <cVar>.
³ 
³  If <lAssign> is True, the value returned from
³  GETCALC() is assigned to the current get. Use CALCKCLR() when
³  done.
³ 
³  Examples:
³  ---------
³   // this will pop up a the calculator when F2 is pressed  while
³   // on the get V2. The value will be assigned to V2.
³ 
³   proc test
³ 
³   v1 := 123
³   v2 := 456
³ 
³   @10,10 get v1
³   @11,10 get v2
³ 
³   CALCKSET(K_F2,"TEST","V2",.t.)
³ 
³   read
³
³   CALCKCLR()  // clear it out
³ 
³  Source:
³  -------
³  S_CALCK.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
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


