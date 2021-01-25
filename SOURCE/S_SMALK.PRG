static aAssigns := {}

//-----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SMALLKCLR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SMALLKCLR() Clears get lookup combinations set up with SMALLKSET()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SMALLKCLR()
ณ 
ณ  Description:
ณ  ------------
ณ  Clears the static lookup definitions stored with
ณ  SMALLKSET(). See SMALLKSET().
ณ 
ณ  Examples:
ณ  ---------
ณ   SMALLKSET(K_F2,  ;
ณ         "EDITCUST","mAgent",{||agent},"Agent",5,"AGENT")
ณ 
ณ   SMALLKCLR()
ณ 
ณ  Source:
ณ  -------
ณ  S_SMALK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SMALLKCLR()
local i
for i = 1 to len(aAssigns)  // clear the SET KEYs
  setkey(aAssigns[i,1])
next
aAssigns := {}
return nil

//------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SMALLKSET()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SMALLKSET() Sets up GET-HOTKEY lookup combinations using smalls()
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SMALLKSET(nKey,cProc,cVar,expDisplayString,[cTitle],;
ณ  [expAlias],expReturn,[expStartRange,expEndRange],[bException])
ณ 
ณ  Description:
ณ  ------------
ณ  Sets key <nKey> to popup SMALLS() with parameters
ณ  <expDisplayString> through [bException] when pressed on
ณ  proc/function <cProc> and var/get <cVar>
ณ 
ณ  See SMALLS() for description of parameters
ณ  <expDisplayString> through [bException] This actually sets key
ณ  <nKey> to an internal function called SMALLKEY(), and stores the
ณ  lookup definition in a static array. SMALLKEY() recieves
ณ  proc,line,variable and determines lastkey(), and checks the
ณ  static array for that set. If found, smalls() is called with the
ณ  stored parameters.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   bOldF2 := SETKEY(K_F2)  // save F2 setting
ณ   // set up some var/lookup definitions keyed to F2
ณ 
ณ   SMALLKSET(K_F2,"EDITCUST","mState",  ;
ณ         {||state},"State",5,"STATE")
ณ 
ณ   SMALLKSET(K_F2,"EDITCUST","mZone",  ;
ณ         {||zone},"Zone",5,"ZONE")
ณ 
ณ   SMALLKSET(K_F2,"EDITCUST","mAgent",  ;
ณ         {||agent},"Agent",5,"AGENT")
ณ 
ณ   //...code...
ณ 
ณ   SMALLKCLR()   // be sure to clear out the definitions
ณ 
ณ  Notes:
ณ  -------
ณ  Save and restore the values to any keys used with
ณ  Clipper's  SETKEY(). Use SMALLKCLR() to clear out the SMALLKEY()
ณ  stored definitions.
ณ 
ณ  Source:
ณ  -------
ณ  S_SMALK.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SMALLKSET(nKey,cProc,cVar,expDisplayString,cTitle,;
           expAlias,expReturn,expStartRange,expEndRange,bException)
aadd(aAssigns,{nKey,upper(cProc),upper(cVar),expDisplayString,cTitle,;
               expAlias,expReturn,expStartRange,expEndRange,bException})
SetKey( nKey, {|p, l, v| SMALLKEY(UPPER(p), l, UPPER(v))} )
return nil


//------------------------------------------------------------
static FUNCTION SMALLKEY(cProc,garbage,cVar)
local nfound
local aThis
local nKey := lastkey()
if (nFound := ascan(aAssigns,{|e|e[1]=nKey.and.e[2]==cProc.and.e[3]==cVar}) )> 0
   aThis := aAssigns[nFound]
   SMALLS(aThis[4],aThis[5],aThis[6],aThis[7],aThis[8],aThis[9],aThis[10])
endif
return nil

