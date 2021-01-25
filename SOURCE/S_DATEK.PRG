

static aAssigns := {}
//-----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALENDKCLR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CALENDKCLR() Clears hot keys set up by CALENDKSET()
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  CALENDKCLR()
ณ 
ณ  Description:
ณ  ------------
ณ  Clears hot keys set up by CALENDKSET(). Always use
ณ  this after using CALENDKSET()
ณ 
ณ  Examples:
ณ  ---------
ณ   // this will pop up a the calendar when F2 is pressed while
ณ   // on the get V2. The value will be assigned to V2.
ณ 
ณ   proc test
ณ   local v1 := DATE(), v2 := DATE()+1
ณ   @10,10 get v1
ณ   @11,10 get v2
ณ 
ณ   CALENDKSET(K_F2,"TEST","V2",.t.)
ณ 
ณ   read
ณ 
ณ   CALENDKCLR()  // clear it out
ณ 
ณ  Source:
ณ  -------
ณ  S_DATEK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION CALENDKSET()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  CALENDKSET() Allows use of GETDATE() calendar in GETS
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  CALENDKSET(nKey,cProc,cVar,lAssign)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets up a call to GETDATE() when key <nKey> is
ณ  pressed while in proc or function <cProc> at variable <cVar>.
ณ 
ณ  If <lAssign> is True, the value returned from
ณ  GETDATE() is assigned to the current get. Use CALENDKCLR() when
ณ  done.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  // this will pop up a the calendar when F2 is pressed while
ณ  // on the get V2. The value will be assigned to V2.
ณ 
ณ  proc test
ณ  local v1 := DATE(),  v2 := DATE()+1
ณ  @10,10 get v1
ณ  @11,10 get v2
ณ  CALENDKSET(K_F2,"TEST","V2",.t.)
ณ  read
ณ 
ณ  CALENDKCLR()  // clear it out
ณ 
ณ  Source:
ณ  -------
ณ  S_DATEK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
