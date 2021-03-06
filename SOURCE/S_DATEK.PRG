

static aAssigns := {}
//-----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALENDKCLR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CALENDKCLR() Clears hot keys set up by CALENDKSET()
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  CALENDKCLR()
³ 
³  Description:
³  ------------
³  Clears hot keys set up by CALENDKSET(). Always use
³  this after using CALENDKSET()
³ 
³  Examples:
³  ---------
³   // this will pop up a the calendar when F2 is pressed while
³   // on the get V2. The value will be assigned to V2.
³ 
³   proc test
³   local v1 := DATE(), v2 := DATE()+1
³   @10,10 get v1
³   @11,10 get v2
³ 
³   CALENDKSET(K_F2,"TEST","V2",.t.)
³ 
³   read
³ 
³   CALENDKCLR()  // clear it out
³ 
³  Source:
³  -------
³  S_DATEK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION CALENDKSET()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  CALENDKSET() Allows use of GETDATE() calendar in GETS
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  CALENDKSET(nKey,cProc,cVar,lAssign)
³ 
³  Description:
³  ------------
³  Sets up a call to GETDATE() when key <nKey> is
³  pressed while in proc or function <cProc> at variable <cVar>.
³ 
³  If <lAssign> is True, the value returned from
³  GETDATE() is assigned to the current get. Use CALENDKCLR() when
³  done.
³ 
³  Examples:
³  ---------
³ 
³  // this will pop up a the calendar when F2 is pressed while
³  // on the get V2. The value will be assigned to V2.
³ 
³  proc test
³  local v1 := DATE(),  v2 := DATE()+1
³  @10,10 get v1
³  @11,10 get v2
³  CALENDKSET(K_F2,"TEST","V2",.t.)
³  read
³ 
³  CALENDKCLR()  // clear it out
³ 
³  Source:
³  -------
³  S_DATEK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
