
static nBungLev := 0
static aBungMen := {}
static aLastOpt := nil


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BUNGSTART()                          *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BUNGSTART() Starts a BUNGEE() menu array definition sequence
ณ 
ณ  Returns:
ณ  --------
ณ  NIL
ณ 
ณ  Syntax:
ณ  -------
ณ  BUNGSTART()
ณ 
ณ  Description:
ณ  ------------
ณ  BUNGSTART() initializes a BUNGEE() menu definition sequence.
ณ
ณ  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
ณ  BUNGDROP(), BUNGUNDROP() together to create a menu definition
ณ  array for BUNGEE(). While it is not necessary to use these
ณ  functions to create the array, it is helpful when you have
ณ  a complex, multi-level dropdown structure.
ณ 
ณ  See BUNGEE for more information.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  bungstart()
ณ
ณ     bungoption("Files")
ณ     bungdrop()
ณ          bungoption("Open" ,{} ,{||!lFileIsOpen} )
ณ          bungoption("Close",{||nil},{||lFileIsOpen } )
ณ     bungundrop()
ณ     bungoption("Edit")
ณ     bungdrop()
ณ          bungoption("DBF"  ,{||nil},nil )
ณ          bungoption("Ascii",{||nil},nil )
ณ     bungundrop()
ณ     bungoption("Quit",{||bungeequit()},nil)
ณ
ณ  aMenu := bungend()
ณ  bungee(0,0,79,aMenu)
ณ     
ณ  Source:
ณ  -------
ณ  S_BUNGDEF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
//-----------------------------------------------------------
FUNCTION BUNGSTART
nBungLev := 0
aBungMen := {}
aLastOpt := nil
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BUNGOPTION()                            *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BUNGOPTION() Adds option during a BUNGEE() menu definition sequence
ณ 
ณ  Returns:
ณ  --------
ณ  NIL
ณ 
ณ  Syntax:
ณ  -------
ณ  BUNGOPTION(cPrompt,expAction,bActive)
ณ 
ณ  Description:
ณ  ------------
ณ  BUNGOPTION() adds an option during a BUNGEE() menu initialization
ณ  sequence.
ณ
ณ  [cPrompt] is the menu prompt, a character prompt, which is what will be
ณ            displayed. i.e. "Files", "Edit". Imbed a tilde (~) to determine
ณ            the trigger character which will be highlighted i.e.
ณ            "Files","e~xit". The default trigger is the first letter.
ณ
ณ            A specialized form of the character prompt is
ณ            "CROSSBAR". If you include "CROSSBAR" as the text,
ณ            a crossbar will be drawn joining the left and right sides of the
ณ            dropdown box.
ณ
ณ  [expAction] can be one of 3 things:
ณ            1. a codeblock. this is simply evaluated
ณ               when the option is selected
ณ            2. An array (or nil) if the action is a dropdown box
ณ               Creates a dropdown box when the prompt is selected.
ณ               (this option must be then followed by a BUNGDROP()..
ณ                BUNGUNDROP() sequence to define the dropdown menu. )
ณ            3. NIL for CROSSBAR types
ณ
ณ  [bActive] is the "is this option active?" codeblock
ณ            This can either be NIL (always active)
ณ            or is a codeblock which _must_ return type L
ณ            (logical). This will determine if the prompt
ณ            is active (available) or not (disabled). If disabled,
ณ            the prompt is show in the disabled color.
ณ
ณ
ณ  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
ณ  BUNGDROP(), BUNGUNDROP() together to create a menu definition
ณ  array for BUNGEE(). While it is not necessary to use these
ณ  functions to create the array, it is helpful when you have
ณ  a complex, multi-level dropdown structure.
ณ 
ณ  See BUNGEE for more information.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  bungstart()
ณ
ณ     bungoption("Files")
ณ     bungdrop()
ณ          bungoption("Open" ,{} ,{||!lFileIsOpen} )
ณ          bungoption("Close",{||nil},{||lFileIsOpen } )
ณ     bungundrop()
ณ     bungoption("Edit")
ณ     bungdrop()
ณ          bungoption("DBF"  ,{||nil},nil )
ณ          bungoption("Ascii",{||nil},nil )
ณ     bungundrop()
ณ     bungoption("Quit",{||bungeequit()},nil)
ณ
ณ  aMenu := bungend()
ณ  bungee(0,0,79,aMenu)
ณ     
ณ  Source:
ณ  -------
ณ  S_BUNGDEF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BUNGEND()                               *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BUNGEND() Ends a BUNGEE() menu array definition sequence
ณ 
ณ  Returns:
ณ  --------
ณ  <aBungeeMenu> => a BUNGEE() menu array
ณ 
ณ  Syntax:
ณ  -------
ณ  BUNGEND()
ณ 
ณ  Description:
ณ  ------------
ณ  BUNGEND() ends a BUNGEE() menu definition sequence, returning
ณ  a completed BUNGEE() menu array.
ณ
ณ  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
ณ  BUNGDROP(), BUNGUNDROP() together to create a menu definition
ณ  array for BUNGEE(). While it is not necessary to use these
ณ  functions to create the array, it is helpful when you have
ณ  a complex, multi-level dropdown structure.
ณ 
ณ  See BUNGEE for more information.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  bungstart()
ณ
ณ     bungoption("Files")
ณ     bungdrop()
ณ          bungoption("Open" ,{} ,{||!lFileIsOpen} )
ณ          bungoption("Close",{||nil},{||lFileIsOpen } )
ณ     bungundrop()
ณ     bungoption("Edit")
ณ     bungdrop()
ณ          bungoption("DBF"  ,{||nil},nil )
ณ          bungoption("Ascii",{||nil},nil )
ณ     bungundrop()
ณ     bungoption("Quit",{||bungeequit()},nil)
ณ
ณ  aMenu := bungend()
ณ  bungee(0,0,79,aMenu)
ณ     
ณ  Source:
ณ  -------
ณ  S_BUNGDEF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
//-----------------------------------------------------------
FUNCTION BUNGEND()
local aMenu := ACLONE(aBungMen)
aBungMen := {}
nBungLev := 0
aLastOpt := nil
return aMenu

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BUNGDROP()                              *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BUNGDROP() Causes dropdown during BUNGEE() menu def sequence
ณ 
ณ  Returns:
ณ  --------
ณ  NIL
ณ 
ณ  Syntax:
ณ  -------
ณ  BUNGDROP([nDown],[nOver])
ณ 
ณ  Description:
ณ  ------------
ณ  BUNGDROP() causes a dropdown to occur during a BUNGEE() menu
ณ  definition sequence. This is followed by a series of BUNGOPTION()
ณ  and then BUNGUNDROP() to end the dropdown.
ณ
ณ  [nDown] Number of rows down from row of current option (default 1)
ณ  [nOver] Number of columns over from column of current option
ณ          (default is 0 for bar options, 1 for dropdown options)
ณ
ณ
ณ  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
ณ  BUNGDROP(), BUNGUNDROP() together to create a menu definition
ณ  array for BUNGEE(). While it is not necessary to use these
ณ  functions to create the array, it is helpful when you have
ณ  a complex, multi-level dropdown structure.
ณ 
ณ  See BUNGEE for more information.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  bungstart()
ณ
ณ     bungoption("Files")
ณ     bungdrop()
ณ          bungoption("Open" ,{} ,{||!lFileIsOpen} )
ณ          bungoption("Close",{||nil},{||lFileIsOpen } )
ณ     bungundrop()
ณ     bungoption("Edit")
ณ     bungdrop()
ณ          bungoption("DBF"  ,{||nil},nil )
ณ          bungoption("Ascii",{||nil},nil )
ณ     bungundrop()
ณ     bungoption("Quit",{||bungeequit()},nil)
ณ
ณ  aMenu := bungend()
ณ  bungee(0,0,79,aMenu)
ณ     
ณ  Source:
ณ  -------
ณ  S_BUNGDEF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
//-----------------------------------------------------------
function bungdrop(nDown,nOver)
aLastOpt[4] := nDown
aLastOpt[5] := nOver
nBungLev++
return nil

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION BUNGUNDROP()                            *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  BUNGUNDROP() Ends dropdown during BUNGEE() menu def sequence
ณ 
ณ  Returns:
ณ  --------
ณ  NIL
ณ 
ณ  Syntax:
ณ  -------
ณ  BUNGUNDROP()
ณ 
ณ  Description:
ณ  ------------
ณ  BUNGUNDROP() ends a dropdown during a BUNGEE() menu
ณ  definition sequence.
ณ
ณ  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
ณ  BUNGDROP(), BUNGUNDROP() together to create a menu definition
ณ  array for BUNGEE(). While it is not necessary to use these
ณ  functions to create the array, it is helpful when you have
ณ  a complex, multi-level dropdown structure.
ณ 
ณ  See BUNGEE for more information.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ  bungstart()
ณ
ณ     bungoption("Files")
ณ     bungdrop()
ณ          bungoption("Open" ,{} ,{||!lFileIsOpen} )
ณ          bungoption("Close",{||nil},{||lFileIsOpen } )
ณ     bungundrop()
ณ     bungoption("Edit")
ณ     bungdrop()
ณ          bungoption("DBF"  ,{||nil},nil )
ณ          bungoption("Ascii",{||nil},nil )
ณ     bungundrop()
ณ     bungoption("Quit",{||bungeequit()},nil)
ณ
ณ  aMenu := bungend()
ณ  bungee(0,0,79,aMenu)
ณ     
ณ     
ณ  Source:
ณ  -------
ณ  S_BUNGDEF.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
//-----------------------------------------------------------
function bungundrop
nBungLev--
return nil
