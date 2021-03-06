
static nBungLev := 0
static aBungMen := {}
static aLastOpt := nil


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BUNGSTART()                          *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BUNGSTART() Starts a BUNGEE() menu array definition sequence
³ 
³  Returns:
³  --------
³  NIL
³ 
³  Syntax:
³  -------
³  BUNGSTART()
³ 
³  Description:
³  ------------
³  BUNGSTART() initializes a BUNGEE() menu definition sequence.
³
³  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
³  BUNGDROP(), BUNGUNDROP() together to create a menu definition
³  array for BUNGEE(). While it is not necessary to use these
³  functions to create the array, it is helpful when you have
³  a complex, multi-level dropdown structure.
³ 
³  See BUNGEE for more information.
³ 
³  Examples:
³  ---------
³ 
³  bungstart()
³
³     bungoption("Files")
³     bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³     bungundrop()
³     bungoption("Edit")
³     bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³     bungundrop()
³     bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³  bungee(0,0,79,aMenu)
³     
³  Source:
³  -------
³  S_BUNGDEF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
//-----------------------------------------------------------
FUNCTION BUNGSTART
nBungLev := 0
aBungMen := {}
aLastOpt := nil
return nil

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BUNGOPTION()                            *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BUNGOPTION() Adds option during a BUNGEE() menu definition sequence
³ 
³  Returns:
³  --------
³  NIL
³ 
³  Syntax:
³  -------
³  BUNGOPTION(cPrompt,expAction,bActive)
³ 
³  Description:
³  ------------
³  BUNGOPTION() adds an option during a BUNGEE() menu initialization
³  sequence.
³
³  [cPrompt] is the menu prompt, a character prompt, which is what will be
³            displayed. i.e. "Files", "Edit". Imbed a tilde (~) to determine
³            the trigger character which will be highlighted i.e.
³            "Files","e~xit". The default trigger is the first letter.
³
³            A specialized form of the character prompt is
³            "CROSSBAR". If you include "CROSSBAR" as the text,
³            a crossbar will be drawn joining the left and right sides of the
³            dropdown box.
³
³  [expAction] can be one of 3 things:
³            1. a codeblock. this is simply evaluated
³               when the option is selected
³            2. An array (or nil) if the action is a dropdown box
³               Creates a dropdown box when the prompt is selected.
³               (this option must be then followed by a BUNGDROP()..
³                BUNGUNDROP() sequence to define the dropdown menu. )
³            3. NIL for CROSSBAR types
³
³  [bActive] is the "is this option active?" codeblock
³            This can either be NIL (always active)
³            or is a codeblock which _must_ return type L
³            (logical). This will determine if the prompt
³            is active (available) or not (disabled). If disabled,
³            the prompt is show in the disabled color.
³
³
³  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
³  BUNGDROP(), BUNGUNDROP() together to create a menu definition
³  array for BUNGEE(). While it is not necessary to use these
³  functions to create the array, it is helpful when you have
³  a complex, multi-level dropdown structure.
³ 
³  See BUNGEE for more information.
³ 
³  Examples:
³  ---------
³ 
³  bungstart()
³
³     bungoption("Files")
³     bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³     bungundrop()
³     bungoption("Edit")
³     bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³     bungundrop()
³     bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³  bungee(0,0,79,aMenu)
³     
³  Source:
³  -------
³  S_BUNGDEF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
//-----------------------------------------------------------
FUNCTION BUNGOPTION(cPrompt,expAction,bActive)
local nLevel := nBungLev
local aNow   := aBungMen
local i
expAction := iif(expAction==nil,{},expAction)
for i = 1 to nLevel
   aNow := ATAIL(aNow)
   aNow := aNow[2]
next
if valtype(aNow)<>"A"
  aNow := {}
endif
aadd(aNow,{cPrompt,expAction,bActive,nil,nil} )
aLastOpt := ATAIL(aNow)
return nil

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BUNGEND()                               *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BUNGEND() Ends a BUNGEE() menu array definition sequence
³ 
³  Returns:
³  --------
³  <aBungeeMenu> => a BUNGEE() menu array
³ 
³  Syntax:
³  -------
³  BUNGEND()
³ 
³  Description:
³  ------------
³  BUNGEND() ends a BUNGEE() menu definition sequence, returning
³  a completed BUNGEE() menu array.
³
³  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
³  BUNGDROP(), BUNGUNDROP() together to create a menu definition
³  array for BUNGEE(). While it is not necessary to use these
³  functions to create the array, it is helpful when you have
³  a complex, multi-level dropdown structure.
³ 
³  See BUNGEE for more information.
³ 
³  Examples:
³  ---------
³ 
³  bungstart()
³
³     bungoption("Files")
³     bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³     bungundrop()
³     bungoption("Edit")
³     bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³     bungundrop()
³     bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³  bungee(0,0,79,aMenu)
³     
³  Source:
³  -------
³  S_BUNGDEF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
//-----------------------------------------------------------
FUNCTION BUNGEND()
local aMenu := ACLONE(aBungMen)
aBungMen := {}
nBungLev := 0
aLastOpt := nil
return aMenu

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BUNGDROP()                              *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BUNGDROP() Causes dropdown during BUNGEE() menu def sequence
³ 
³  Returns:
³  --------
³  NIL
³ 
³  Syntax:
³  -------
³  BUNGDROP([nDown],[nOver])
³ 
³  Description:
³  ------------
³  BUNGDROP() causes a dropdown to occur during a BUNGEE() menu
³  definition sequence. This is followed by a series of BUNGOPTION()
³  and then BUNGUNDROP() to end the dropdown.
³
³  [nDown] Number of rows down from row of current option (default 1)
³  [nOver] Number of columns over from column of current option
³          (default is 0 for bar options, 1 for dropdown options)
³
³
³  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
³  BUNGDROP(), BUNGUNDROP() together to create a menu definition
³  array for BUNGEE(). While it is not necessary to use these
³  functions to create the array, it is helpful when you have
³  a complex, multi-level dropdown structure.
³ 
³  See BUNGEE for more information.
³ 
³  Examples:
³  ---------
³ 
³  bungstart()
³
³     bungoption("Files")
³     bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³     bungundrop()
³     bungoption("Edit")
³     bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³     bungundrop()
³     bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³  bungee(0,0,79,aMenu)
³     
³  Source:
³  -------
³  S_BUNGDEF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
//-----------------------------------------------------------
function bungdrop(nDown,nOver)
aLastOpt[4] := nDown
aLastOpt[5] := nOver
nBungLev++
return nil

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION BUNGUNDROP()                            *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  BUNGUNDROP() Ends dropdown during BUNGEE() menu def sequence
³ 
³  Returns:
³  --------
³  NIL
³ 
³  Syntax:
³  -------
³  BUNGUNDROP()
³ 
³  Description:
³  ------------
³  BUNGUNDROP() ends a dropdown during a BUNGEE() menu
³  definition sequence.
³
³  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
³  BUNGDROP(), BUNGUNDROP() together to create a menu definition
³  array for BUNGEE(). While it is not necessary to use these
³  functions to create the array, it is helpful when you have
³  a complex, multi-level dropdown structure.
³ 
³  See BUNGEE for more information.
³ 
³  Examples:
³  ---------
³ 
³  bungstart()
³
³     bungoption("Files")
³     bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³     bungundrop()
³     bungoption("Edit")
³     bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³     bungundrop()
³     bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³  bungee(0,0,79,aMenu)
³     
³     
³  Source:
³  -------
³  S_BUNGDEF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
//-----------------------------------------------------------
function bungundrop
nBungLev--
return nil
