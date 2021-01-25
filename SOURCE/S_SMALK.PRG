static aAssigns := {}

//-----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SMALLKCLR()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SMALLKCLR() Clears get lookup combinations set up with SMALLKSET()
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  SMALLKCLR()
� 
�  Description:
�  ------------
�  Clears the static lookup definitions stored with
�  SMALLKSET(). See SMALLKSET().
� 
�  Examples:
�  ---------
�   SMALLKSET(K_F2,  ;
�         "EDITCUST","mAgent",{||agent},"Agent",5,"AGENT")
� 
�   SMALLKCLR()
� 
�  Source:
�  -------
�  S_SMALK.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SMALLKSET()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SMALLKSET() Sets up GET-HOTKEY lookup combinations using smalls()
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  SMALLKSET(nKey,cProc,cVar,expDisplayString,[cTitle],;
�  [expAlias],expReturn,[expStartRange,expEndRange],[bException])
� 
�  Description:
�  ------------
�  Sets key <nKey> to popup SMALLS() with parameters
�  <expDisplayString> through [bException] when pressed on
�  proc/function <cProc> and var/get <cVar>
� 
�  See SMALLS() for description of parameters
�  <expDisplayString> through [bException] This actually sets key
�  <nKey> to an internal function called SMALLKEY(), and stores the
�  lookup definition in a static array. SMALLKEY() recieves
�  proc,line,variable and determines lastkey(), and checks the
�  static array for that set. If found, smalls() is called with the
�  stored parameters.
� 
�  Examples:
�  ---------
� 
�   bOldF2 := SETKEY(K_F2)  // save F2 setting
�   // set up some var/lookup definitions keyed to F2
� 
�   SMALLKSET(K_F2,"EDITCUST","mState",  ;
�         {||state},"State",5,"STATE")
� 
�   SMALLKSET(K_F2,"EDITCUST","mZone",  ;
�         {||zone},"Zone",5,"ZONE")
� 
�   SMALLKSET(K_F2,"EDITCUST","mAgent",  ;
�         {||agent},"Agent",5,"AGENT")
� 
�   //...code...
� 
�   SMALLKCLR()   // be sure to clear out the definitions
� 
�  Notes:
�  -------
�  Save and restore the values to any keys used with
�  Clipper's  SETKEY(). Use SMALLKCLR() to clear out the SMALLKEY()
�  stored definitions.
� 
�  Source:
�  -------
�  S_SMALK.PRG
� 
����������������������������������������������������������������� 
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
