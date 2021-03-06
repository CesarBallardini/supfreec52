static aAssigns := {}

//-----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SMALLKCLR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SMALLKCLR() Clears get lookup combinations set up with SMALLKSET()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SMALLKCLR()
³ 
³  Description:
³  ------------
³  Clears the static lookup definitions stored with
³  SMALLKSET(). See SMALLKSET().
³ 
³  Examples:
³  ---------
³   SMALLKSET(K_F2,  ;
³         "EDITCUST","mAgent",{||agent},"Agent",5,"AGENT")
³ 
³   SMALLKCLR()
³ 
³  Source:
³  -------
³  S_SMALK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SMALLKSET()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SMALLKSET() Sets up GET-HOTKEY lookup combinations using smalls()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SMALLKSET(nKey,cProc,cVar,expDisplayString,[cTitle],;
³  [expAlias],expReturn,[expStartRange,expEndRange],[bException])
³ 
³  Description:
³  ------------
³  Sets key <nKey> to popup SMALLS() with parameters
³  <expDisplayString> through [bException] when pressed on
³  proc/function <cProc> and var/get <cVar>
³ 
³  See SMALLS() for description of parameters
³  <expDisplayString> through [bException] This actually sets key
³  <nKey> to an internal function called SMALLKEY(), and stores the
³  lookup definition in a static array. SMALLKEY() recieves
³  proc,line,variable and determines lastkey(), and checks the
³  static array for that set. If found, smalls() is called with the
³  stored parameters.
³ 
³  Examples:
³  ---------
³ 
³   bOldF2 := SETKEY(K_F2)  // save F2 setting
³   // set up some var/lookup definitions keyed to F2
³ 
³   SMALLKSET(K_F2,"EDITCUST","mState",  ;
³         {||state},"State",5,"STATE")
³ 
³   SMALLKSET(K_F2,"EDITCUST","mZone",  ;
³         {||zone},"Zone",5,"ZONE")
³ 
³   SMALLKSET(K_F2,"EDITCUST","mAgent",  ;
³         {||agent},"Agent",5,"AGENT")
³ 
³   //...code...
³ 
³   SMALLKCLR()   // be sure to clear out the definitions
³ 
³  Notes:
³  -------
³  Save and restore the values to any keys used with
³  Clipper's  SETKEY(). Use SMALLKCLR() to clear out the SMALLKEY()
³  stored definitions.
³ 
³  Source:
³  -------
³  S_SMALK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

