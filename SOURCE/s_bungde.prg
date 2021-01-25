
static nBungLev := 0
static aBungMen := {}
static aLastOpt := nil


/*
�����������������������������������������������������������������
� FUNCTION BUNGSTART()                          *new*
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BUNGSTART() Starts a BUNGEE() menu array definition sequence
� 
�  Returns:
�  --------
�  NIL
� 
�  Syntax:
�  -------
�  BUNGSTART()
� 
�  Description:
�  ------------
�  BUNGSTART() initializes a BUNGEE() menu definition sequence.
�
�  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
�  BUNGDROP(), BUNGUNDROP() together to create a menu definition
�  array for BUNGEE(). While it is not necessary to use these
�  functions to create the array, it is helpful when you have
�  a complex, multi-level dropdown structure.
� 
�  See BUNGEE for more information.
� 
�  Examples:
�  ---------
� 
�  bungstart()
�
�     bungoption("Files")
�     bungdrop()
�          bungoption("Open" ,{} ,{||!lFileIsOpen} )
�          bungoption("Close",{||nil},{||lFileIsOpen } )
�     bungundrop()
�     bungoption("Edit")
�     bungdrop()
�          bungoption("DBF"  ,{||nil},nil )
�          bungoption("Ascii",{||nil},nil )
�     bungundrop()
�     bungoption("Quit",{||bungeequit()},nil)
�
�  aMenu := bungend()
�  bungee(0,0,79,aMenu)
�     
�  Source:
�  -------
�  S_BUNGDEF.PRG
� 
����������������������������������������������������������������� 
*/
//-----------------------------------------------------------
FUNCTION BUNGSTART
nBungLev := 0
aBungMen := {}
aLastOpt := nil
return nil

/*
�����������������������������������������������������������������
� FUNCTION BUNGOPTION()                            *new*
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BUNGOPTION() Adds option during a BUNGEE() menu definition sequence
� 
�  Returns:
�  --------
�  NIL
� 
�  Syntax:
�  -------
�  BUNGOPTION(cPrompt,expAction,bActive)
� 
�  Description:
�  ------------
�  BUNGOPTION() adds an option during a BUNGEE() menu initialization
�  sequence.
�
�  [cPrompt] is the menu prompt, a character prompt, which is what will be
�            displayed. i.e. "Files", "Edit". Imbed a tilde (~) to determine
�            the trigger character which will be highlighted i.e.
�            "Files","e~xit". The default trigger is the first letter.
�
�            A specialized form of the character prompt is
�            "CROSSBAR". If you include "CROSSBAR" as the text,
�            a crossbar will be drawn joining the left and right sides of the
�            dropdown box.
�
�  [expAction] can be one of 3 things:
�            1. a codeblock. this is simply evaluated
�               when the option is selected
�            2. An array (or nil) if the action is a dropdown box
�               Creates a dropdown box when the prompt is selected.
�               (this option must be then followed by a BUNGDROP()..
�                BUNGUNDROP() sequence to define the dropdown menu. )
�            3. NIL for CROSSBAR types
�
�  [bActive] is the "is this option active?" codeblock
�            This can either be NIL (always active)
�            or is a codeblock which _must_ return type L
�            (logical). This will determine if the prompt
�            is active (available) or not (disabled). If disabled,
�            the prompt is show in the disabled color.
�
�
�  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
�  BUNGDROP(), BUNGUNDROP() together to create a menu definition
�  array for BUNGEE(). While it is not necessary to use these
�  functions to create the array, it is helpful when you have
�  a complex, multi-level dropdown structure.
� 
�  See BUNGEE for more information.
� 
�  Examples:
�  ---------
� 
�  bungstart()
�
�     bungoption("Files")
�     bungdrop()
�          bungoption("Open" ,{} ,{||!lFileIsOpen} )
�          bungoption("Close",{||nil},{||lFileIsOpen } )
�     bungundrop()
�     bungoption("Edit")
�     bungdrop()
�          bungoption("DBF"  ,{||nil},nil )
�          bungoption("Ascii",{||nil},nil )
�     bungundrop()
�     bungoption("Quit",{||bungeequit()},nil)
�
�  aMenu := bungend()
�  bungee(0,0,79,aMenu)
�     
�  Source:
�  -------
�  S_BUNGDEF.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION BUNGEND()                               *new*
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BUNGEND() Ends a BUNGEE() menu array definition sequence
� 
�  Returns:
�  --------
�  <aBungeeMenu> => a BUNGEE() menu array
� 
�  Syntax:
�  -------
�  BUNGEND()
� 
�  Description:
�  ------------
�  BUNGEND() ends a BUNGEE() menu definition sequence, returning
�  a completed BUNGEE() menu array.
�
�  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
�  BUNGDROP(), BUNGUNDROP() together to create a menu definition
�  array for BUNGEE(). While it is not necessary to use these
�  functions to create the array, it is helpful when you have
�  a complex, multi-level dropdown structure.
� 
�  See BUNGEE for more information.
� 
�  Examples:
�  ---------
� 
�  bungstart()
�
�     bungoption("Files")
�     bungdrop()
�          bungoption("Open" ,{} ,{||!lFileIsOpen} )
�          bungoption("Close",{||nil},{||lFileIsOpen } )
�     bungundrop()
�     bungoption("Edit")
�     bungdrop()
�          bungoption("DBF"  ,{||nil},nil )
�          bungoption("Ascii",{||nil},nil )
�     bungundrop()
�     bungoption("Quit",{||bungeequit()},nil)
�
�  aMenu := bungend()
�  bungee(0,0,79,aMenu)
�     
�  Source:
�  -------
�  S_BUNGDEF.PRG
� 
����������������������������������������������������������������� 
*/
//-----------------------------------------------------------
FUNCTION BUNGEND()
local aMenu := ACLONE(aBungMen)
aBungMen := {}
nBungLev := 0
aLastOpt := nil
return aMenu

/*
�����������������������������������������������������������������
� FUNCTION BUNGDROP()                              *new*
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BUNGDROP() Causes dropdown during BUNGEE() menu def sequence
� 
�  Returns:
�  --------
�  NIL
� 
�  Syntax:
�  -------
�  BUNGDROP([nDown],[nOver])
� 
�  Description:
�  ------------
�  BUNGDROP() causes a dropdown to occur during a BUNGEE() menu
�  definition sequence. This is followed by a series of BUNGOPTION()
�  and then BUNGUNDROP() to end the dropdown.
�
�  [nDown] Number of rows down from row of current option (default 1)
�  [nOver] Number of columns over from column of current option
�          (default is 0 for bar options, 1 for dropdown options)
�
�
�  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
�  BUNGDROP(), BUNGUNDROP() together to create a menu definition
�  array for BUNGEE(). While it is not necessary to use these
�  functions to create the array, it is helpful when you have
�  a complex, multi-level dropdown structure.
� 
�  See BUNGEE for more information.
� 
�  Examples:
�  ---------
� 
�  bungstart()
�
�     bungoption("Files")
�     bungdrop()
�          bungoption("Open" ,{} ,{||!lFileIsOpen} )
�          bungoption("Close",{||nil},{||lFileIsOpen } )
�     bungundrop()
�     bungoption("Edit")
�     bungdrop()
�          bungoption("DBF"  ,{||nil},nil )
�          bungoption("Ascii",{||nil},nil )
�     bungundrop()
�     bungoption("Quit",{||bungeequit()},nil)
�
�  aMenu := bungend()
�  bungee(0,0,79,aMenu)
�     
�  Source:
�  -------
�  S_BUNGDEF.PRG
� 
����������������������������������������������������������������� 
*/
//-----------------------------------------------------------
function bungdrop(nDown,nOver)
aLastOpt[4] := nDown
aLastOpt[5] := nOver
nBungLev++
return nil

/*
�����������������������������������������������������������������
� FUNCTION BUNGUNDROP()                            *new*
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  BUNGUNDROP() Ends dropdown during BUNGEE() menu def sequence
� 
�  Returns:
�  --------
�  NIL
� 
�  Syntax:
�  -------
�  BUNGUNDROP()
� 
�  Description:
�  ------------
�  BUNGUNDROP() ends a dropdown during a BUNGEE() menu
�  definition sequence.
�
�  Use BUNGSTART(), BUNGEND(), BUNGOPTION(),
�  BUNGDROP(), BUNGUNDROP() together to create a menu definition
�  array for BUNGEE(). While it is not necessary to use these
�  functions to create the array, it is helpful when you have
�  a complex, multi-level dropdown structure.
� 
�  See BUNGEE for more information.
� 
�  Examples:
�  ---------
� 
�  bungstart()
�
�     bungoption("Files")
�     bungdrop()
�          bungoption("Open" ,{} ,{||!lFileIsOpen} )
�          bungoption("Close",{||nil},{||lFileIsOpen } )
�     bungundrop()
�     bungoption("Edit")
�     bungdrop()
�          bungoption("DBF"  ,{||nil},nil )
�          bungoption("Ascii",{||nil},nil )
�     bungundrop()
�     bungoption("Quit",{||bungeequit()},nil)
�
�  aMenu := bungend()
�  bungee(0,0,79,aMenu)
�     
�     
�  Source:
�  -------
�  S_BUNGDEF.PRG
� 
����������������������������������������������������������������� 
*/
//-----------------------------------------------------------
function bungundrop
nBungLev--
return nil
