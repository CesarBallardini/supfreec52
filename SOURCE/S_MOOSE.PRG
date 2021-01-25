/*
  NEW 01-25-1994

  Adding HOTKEY handling to RAT_EVENT()
  ------------------------------------

  Files:          S_MOOSE.PRG

  Usage:          Compile S_MOOSE.PRG with your version of Clipper
                          CLIPPER S_MOOSE -n
                  and link it in before SUPER35.LIB  or SUP3552.LIB
                          RTLINK FI whatever,s_moose LIB SUPER35


  Warning: this may be a bit deep in parts (codeblocks, etc...)

  I've added a few new features to RAT_EVENT(), and am uploading it
  here prior to the next release, for testing etc.
  RAT_EVENT() is what handles ALL events in SuperLib 3.5. This includes
  reads, menus, etc. RAT_EVENT() is a part of S_MOOSE.PRG.

  Basically this version adds a toggle that allows RAT_EVENT() to handle
  hotkey ( SET KEY ...) keys itself by evaluating the block that the hotkey
  is attached to.


  New function: RAT_EHH()
  -----------------------
  The default is False - do not handle SETKEY() blocks. You can set it to
  True with RAT_EHH(.T.) or back to False with RAT_EHH(.f.). True tells
  RAT_EVENT() to handle SETKEY() keys.

  i.e.    RAT_EHH(.t.)                          // turn hotkey handling on
          setkey(K_CTRL_C,  {||getcalc()}   )   // set up CTRL-C to
                                                // pop up the calculator
          * calculator will now popup whenever CTRL-C is pressed
          * while SuperLib has control.

  This is really all you need for hotkeys where you don't need some kind
  of 'context sensitivity' such as for a help system.
  (i.e. you don't need to know PROC, LINE and VARIABLE which are the
  parameters passed when you use SET KEY ).

  * VERY IMPORTANT * IF YOU FIND THAT A SUPERLIB KEY SUCH AS F10 OR F2
    HAVE BEEN DISABLED, AND YOU HAVE USED RAT_EHH(.T.), SET IT BACK TO
    FALSE WITH RAT_EHH(.F.) BEFORE CALLING THE FUNCTION. FOR EXAMPLE,
    BEFORE CALLING TODOLIST()...
    lOldHot := RAT_EHH(.f.)  // set it off and save the setting
    TODOLIST()
    RAT_EHH(lOldHot)     // set it back where it was

  New function: RAT_EONKEY()
  --------------------------
  If RAT_EVENT() hotkey processing is enabled, the block attached to
  the hotkey will be evaluated with
          EVAL(block, PROCNAME(1), PROCLINE(1), READVAR() )
  In other words, PROCNAME(1), PROCLINE(1), READVAR() are passed to the
  block as parameters. You can set up a different PROC, LINE and VAR
  to be passed by calling RAT_EONKEY(cProc, cLine, cVar) where cProc, cLine,
  cVar are the PROC, LINE and VARIABLE you wish passed to the hotkey block.
  This will remain in effect until you call RAT_EONKEY() again. Passing
  NIL,NIL,NIL will set it back to the default.


  New function: RAT_EONP() RAT_EONL() RAT_EONV()
  ----------------------------------------------
  If you want to save/restore the PROC, LINE and VARIABLE that have been
  set by RAT_EONKEY(), you can use these three functions.
          cOldProc := RAT_EONP()
          nOldLine := RAT_EONL()
          cOldVar  := RAT_EONV()
          RAT_EONKEY(new settings....)
          ** do something
          RAT_EONKEY(cOldPRoc, nOldLine, cOldVar) // restore



  Notes:
  -------
  When you issue a SET KEY command, it is preprocessed into:

          #command SET KEY <n> TO <proc>                                          ;
                => SetKey( <n>, {|p, l, v| <proc>(p, l, v)} )

  So
          SET KEY 28 to HELP
  Becomes
          SetKey(28,{|p,l,v|HELP(p,l,v)}  )
          // p,l,v = Proc, Line, Variable

  SETKEY(28) will now return a code block.

  When you use the SET KEY command, be sure that the function you
  are setting the key to does not have parameters, because the
  preprocessing above will pass Proc, Line and Variable to it as
  types C, N and C. I tend to like to use the SETKEY() function directly,
  so I know what I'm getting....

*/

#INCLUDE "inkey.ch"
#define MTOP      1
#define MLEFT     2
#define MBOTTOM   3
#define MRIGHT    4
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif

static lIsMouse
static mouserow         := 0
static mousecol         := 0
static nLastEvent       := 0
static scProc, snLine, scVar
static lHandleHot := .f.

*====================================================
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_EVENT()          *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  RAT_EVENT() Event handler - inkey() with mouse awareness
ณ 
ณ  Returns:
ณ  --------
ณ  <nEvent> => Event value - either inkey() value or
ณ  mouse value
ณ 
ณ  Syntax:
ณ  -------
ณ  RAT_EVENT([nTimeout],[lClearkb])
ณ
ณ  Description:
ณ  ------------
ณ  Event handler - inkey() with mouse awareness
ณ 
ณ  <nTimeout>   is the   # seconds to wait before
ณ  timeout. Zero (0) means indefinately . If you don't pass
ณ  anything, default is 0. Slight difference from inkey() there.
ณ 
ณ  Returns values are:
ณ 
ณ     If keystroke                                   inkey() value
ณ     If left mouse button has been depressed        K_MOUSELEFT
ณ     If right mouse button has been depressed       K_RBUTTONDOWN
ณ     If timeout                                     0
ณ 
ณ 
ณ  [lClearkb]   optional clear keyboard True (default)
ณ  or False. If a keystroke is gotten, and this is True, clear the
ณ  keyboard with:
ณ                     while inkey()#0
ณ                     end
ณ 
ณ  Examples:
ณ  ---------
ณ   e := 0
ณ 
ณ   while  e#27
ณ      e := rat_event(30)
ณ      do case
ณ      case e == 0
ณ        ? "Timed out after 30 seconds"
ณ      case e < K_LBUTTONDOWN
ณ        ? "Key press with inkey() value of :",e
ณ      case e == K_LBUTTONDOWN
ณ        ? "Left mouse button pressed at :"
ณ        ?? "row-> ",rat_eqmrow(),  "col-> ",rat_eqmcol()
ณ      case e == K_RBUTTONDOWN
ณ        ? "Right mouse button pressed at :"
ณ        ?? "row-> ",rat_eqmrow(),  "col-> ",rat_eqmcol()
ณ      endcase
ณ   end
ณ 
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function rat_event(timeout,clearkb,lUseNextKey,nMouseR, nMouseC)
  local key,endsec
  local returnval := 0
  local bGetKey
  local cProc, nLine,cVar
  local nOldInkey
  lUseNextKey := iif(lUseNextKey#nil,lUseNextKey,.f.)
  bGetKey     := iif(lUseNextKey,{||nextkey()},{||inkey()})
  if lIsMouse==nil
    lIsMouse    := sls_ismouse()
  endif
  nMouseR  := -1
  nMouseC  := -1
  clearkb  := iif(clearkb==nil,.t.,clearkb)
  timeout  := iif(timeout==nil,5000000,timeout)
  timeout  := iif(timeout==0,5000000,timeout)
  endsec   := seconds()+timeout
  key      := 0
  mouserow := 0
  mousecol := 0

  #ifndef CLIPPER53
  if lIsMouse
    rat_on()
  endif
  #endif
  #ifdef CLIPPER53
    IF lIsMouse
        nOldInkey = set(39,INKEY_LDOWN+INKEY_RDOWN+INKEY_KEYBOARD)
        mSetCursor(.t.)
    endif
  #endif

  do while (returnval==0) .and. (seconds() < endsec)
    if ( key := eval(bGetKey) ) # 0
       if clearkb
          while inkey()#0
          end
       endif
       #ifdef CLIPPER53
         // only trap left and right presses for SuperLib
         if key==K_LDBLCLK
            key = K_LBUTTONDOWN
         ENDIF
         if key==K_RDBLCLK
            key = K_RBUTTONDOWN
         ENDIF
         if key = K_LBUTTONDOWN  .or. key=K_RBUTTONDOWN
             mouserow = mRow()
             mousecol = mCol()
         elseif key > 1000
             if lUseNextKey // clear any othermouse keys if using nextkey
               inkey()
             endif
             key := 0
         endif
       #endif
       returnval := key

    #ifndef CLIPPER53
    elseif lIsMouse
      if rat_leftb()
         mouserow := rat_rowl()
         mousecol := rat_coll()
         returnval := K_LBUTTONDOWN
      elseif rat_rightb()
         mouserow := rat_rowr()
         mousecol := rat_colr()
         returnval := K_RBUTTONDOWN
      endif
    #endif
    endif
    */---handle hotkey here, if setup to do so
    if lHandleHot .and. returnval <> 0 .and. returnval<1000 // not mouse
        if setkey(returnval)#nil .and. PROCNAME(1)#"RATREADER" .and. ;
                PROCNAME(1)#"MHANDLER"
                cProc = iif(scProc#nil,scProc,PROCNAME(1) )
                nLine = iif(snLine#nil,snLine,PROCLINE(1) )
                cVar  = iif(scVar#nil,scVar,READVAR())
                if lIsMouse
                  rat_off()
                endif
                EVAL( setkey(returnval), cProc, nLine,cVar)
                returnval := 0
                keyboard chr(0)
                if lIsMouse
                  rat_on()
                endif
        endif
    endif
  enddo
  #ifndef CLIPPER53
  if lIsMouse
    rat_off()
  endif
  #endif
  #ifdef CLIPPER53
    IF lIsMouse
        nOldInkey = set(39,nOldInkey)
    endif
  #endif
  nLastEvent := returnval
  nMouseR = mouserow
  nMouseC = mousecol
return returnval


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_ELBHD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  RAT_ELBHD() Determines if left mouse button is held down
ณ
ณ  Returns:
ณ  --------
ณ  <lHeldDown> => is LMB held down
ณ 
ณ  Syntax:
ณ  -------
ณ  RAT_ELBHD([nSeconds])
ณ 
ณ  Description:
ณ  ------------
ณ  Determines if left mouse button is held down by
ณ  calling the ASM function RAT_LBHD() for [nSeconds]. Default is .1
ณ  seconds.
ณ
ณ  If the left mouse button is held down during that
ณ  time frame, True is returned, else False is returned.
ณ 
ณ  Note: the ASM function RAT_LBHD() returns a logical
ณ  value if the left mouse button is depressed RIGHT NOW, but
ณ  does not take a duration of [nSeconds] into account, which is needed
ณ  to determine if it is depressed and HELD DOWN.
ณ 
ณ  [nSeconds]  is optional seconds to test for. Default
ณ  is .1 seconds.
ณ
ณ  Examples:
ณ  ---------
ณ   if rat_elbhd()
ณ 
ณ     ?"While you were out:"
ณ 
ณ     ?"Left button was depressed and held down at"
ณ 
ณ     ??rat_eqmrow(),rat_eqmcol()
ณ
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function rat_elbhd(secs)      && is left button held down
local i
local hd := .f.
local start := seconds()
secs := iif(secs#nil,secs,.1)
while seconds()-start <secs .and. (hd := rat_lbhd())
end
return hd
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_ERBHD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ 
ณ  Short:
ณ  ------
ณ  RAT_ERBHD() Determines if right mouse button is held down
ณ 
ณ  Returns:
ณ  --------
ณ  <lHeldDown> => is RMB held down
ณ 
ณ  Syntax:
ณ  -------
ณ  RAT_ERBHD([nSeconds])
ณ 
ณ  Description:
ณ  ------------
ณ  Determines if right mouse button is held down by
ณ  calling the ASM function RAT_RBHD() for [nSeconds]. Default for
ณ  [nSeconds] is .1 seconds. If the right mouse button is held down
ณ  during that time frame, True is returned, else False is returned.
ณ
ณ  [nSeconds]   is optional seconds to test for. Default
ณ  is .1 seconds.
ณ 
ณ  This is different from the .ASM function RAT_RBHD().
ณ  RAT_ERBHD(<n>) watches the mouse for <n> seconds, and if the
ณ  mouse remains depressed for the full time, then it is considered
ณ  to be HELD DOWN.  RAT_RBHD() on the other hand, only checks for
ณ  the mouse button being depressed RIGHT NOW. RAT_ERBHD() calls
ณ  RAT_RBHD() repetitively.
ณ
ณ  Examples:
ณ  ---------
ณ   if rat_erbhd()
ณ 
ณ     ?"While you were out:"
ณ 
ณ     ?"Right button was depressed and held down at"
ณ 
ณ     ??rat_eqmrow(),rat_eqmcol()
ณ
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
function rat_erbhd(secs)       && is right button held down
local i
local hd    := .f.
local start := seconds()
secs := iif(secs#nil,secs,.1)
while seconds()-start <secs .and. (hd := rat_rbhd())
end
return hd
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_EQMROW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  RAT_EQMROW() Returns mouse row at last press
ณ 
ณ  Returns:
ณ  --------
ณ  <nRow> => mouse row at last button press (left or
ณ  right)
ณ
ณ  Syntax:
ณ  -------
ณ  RAT_EQMROW()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns mouse row at last press (LEFT OR RIGHT).
ณ  S_MOOSE.PRG has two static variables, 'mouserow' and 'mousecol'.
ณ  These are set each time RAT_EVENT() determines that the mouse
ณ  has been depressed.
ณ 
ณ  Examples:
ณ  ---------
ณ   e := 0
ณ 
ณ   while e#27
ณ      e := rat_event(30)
ณ      do case
ณ      case e == 0
ณ        ? "Timed out after 30 seconds"
ณ      case e < K_LBUTTONDOWN
ณ        ? "Key press with inkey() value of :",e
ณ      case e == K_LBUTTONDOWN
ณ        ? "Left mouse button pressed at :"
ณ        ?? "row-> ",rat_eqmrow()
ณ        ?? "col-> ",rat_eqmcol()
ณ      case e == K_RBUTTONDOWN
ณ        ? "Right mouse button pressed at :"
ณ        ?? "row-> ",rat_eqmrow()
ณ        ?? "col-> ",rat_eqmcol()
ณ      endcase
ณ   end
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function rat_eqmrow()     && return mouse row at last mouse event
return mouserow
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_EQMCOL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  RAT_EQMCOL() Returns mouse column at last press
ณ
ณ  Returns:
ณ  --------
ณ  <nRow> => mouse column at last button press (left or
ณ  right)
ณ
ณ  Syntax:
ณ  -------
ณ  RAT_EQMCOL()
ณ 
ณ  Description:
ณ  ------------
ณ  Returns mouse column at last press (LEFT OR RIGHT).
ณ  S_MOOSE.PRG has two static variables, 'mouserow' and 'mousecol'.
ณ  These are set each time RAT_EVENT() determines that the mouse
ณ  has been depressed.
ณ 
ณ  Examples:
ณ  ---------
ณ   e := 0
ณ
ณ   while e#27
ณ      e := rat_event(30)
ณ      do case
ณ      case e == 0
ณ        ? "Timed out after 30 seconds"
ณ      case e < K_LBUTTONDOWN
ณ        ? "Key press with inkey() value of :",e
ณ      case e == K_LBUTTONDOWN
ณ        ? "Left mouse button pressed at :"
ณ        ?? "row-> ",rat_eqmrow()
ณ        ?? "col-> ",rat_eqmcol()
ณ      case e == K_RBUTTONDOWN
ณ        ? "Right mouse button pressed at :"
ณ        ?? "row-> ",rat_eqmrow()
ณ        ?? "col-> ",rat_eqmcol()
ณ      endcase
ณ   end
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
function rat_eqmcol()     && return mouse column at last mouse event
return mousecol
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_ISMOUSE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  RAT_ISMOUSE() Determines mouse usage by RAT_EVENT()
ณ
ณ  Returns:
ณ  --------
ณ  <lIsMouse> => is there a mouse
ณ
ณ  Syntax:
ณ  -------
ณ  RAT_ISMOUSE([lIsMouse])
ณ
ณ  Description:
ณ  ------------
ณ  Determines mouse usage by RAT_EVENT(). Default is
ณ  determined by a call to the ASM function RAT_EXIST(). However,
ณ  you may want to shut down mouse usage even if a mouse is
ณ  present. If so, call this function with False, to override.
ณ
ณ  [lIsMouse]  S_MOOSE.PRG contains a static variable
ณ  called 'lIsMouse'. This is determined initially by a call to
ณ  RAT_EXIST(), but may be overridden by calling RAT_ISMOUSE(.f.).
ณ 
ณ  Examples:
ณ  ---------
ณ   RAT_ISMOUSE(.f.).
ณ 
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
function rat_ismouse(imoose)
lIsMouse := iif(imoose#nil,imoose,iif(lIsMouse#nil,lIsMouse,rat_exist() ) )
return lIsMouse


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_LASTEV()          *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  RAT_LASTEV() Returns the last event recorded by RAT_EVENT()
ณ
ณ  Returns:
ณ  --------
ณ  <nEvent> => last recorded RAT_EVENT() event
ณ
ณ  Syntax:
ณ  -------
ณ  RAT_LASTEV()
ณ
ณ  Description:
ณ  ------------
ณ  Every once in a while, some other function will be responsible
ณ  for doing the RAT_EVENT() call, but your function still wants
ณ  to know what the last event was. This function can be used to
ณ  retrieve that value.
ณ
ณ  Examples:
ณ  ---------
ณ   RAT_LASTEV()
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
function rat_lastev
return nLastEvent


*- various commonly used internal mouse routines


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ISMOUSEAT()             *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  ISMOUSEAT() Checks for mouse click within passed coordinates
ณ
ณ  Returns:
ณ  --------
ณ  <lClicked> => true if mouse click occured within the passed
ณ                coordinates
ณ
ณ  Syntax:
ณ  -------
ณ  ISMOUSEAT(nMouseRow, nMouseCol, nTop,nLeft,nBottom,nRight)
ณ
ณ  Description:
ณ  ------------
ณ  Checks <nMouseRow>, <nMouseCol> against the coordinates
ณ  <nTop>, <nLeft>,<nBottom>,<nRight> and returns True if the
ณ  mouse row and col are within the screen coordinates.
ณ
ณ  Examples:
ณ  ---------
ณ
ณ  case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft, nBot+2, nLeft+2)
ณ     oTb:up()
ณ
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
func ISMOUSEAT(nMouseR, nMouseC, nTop, nLeft, nBottom,nRight)
return (nMouseR>=nTop .and. nMouseR<=nBottom .and. ;
        nMouseC>=nLeft .and. nMouseC<=nRight)


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION IFMOUSEHD()             *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  IFMOUSEHD() Checks if mouse held down,evals codeblock while it is
ณ
ณ  Returns:
ณ  --------
ณ  NIL
ณ
ณ  Syntax:
ณ  -------
ณ  IFMOUSEHD(bBlock, [oTbrowse])
ณ
ณ  Description:
ณ  ------------
ณ  You'll often want to hold the left mouse button down on a hot object
ณ  in order to cause an action to repeat rapidly over and over. An
ณ  example would be on an up or down arrow that caused a tbrowse object
ณ  to go up or down. Rather than go click-release-click-release-click..etc,
ณ  you prefer to just hold the mouse down.
ณ
ณ  If you detect the mouse has been pressed and you then want to check
ณ  if its held down and perform an action repetetively while it is,
ณ  you can use this function.
ณ
ณ  <bBlock> is the code block to be evaluated continuously while the mouse
ณ  is held down. (there is a .01 second delay between iterations).
ณ
ณ  [oTbrowse] is an optional Tbrowse object that you wish to be refreshed
ณ  during the evaluation of the block. (otherwise, you could hold the mouse
ณ  button down continuously and not se anything happen. You could have
ณ  your codeblock refresh the Tbrowse, of course. Its just easier this
ณ  way.
ณ
ณ
ณ  Examples:
ณ  ---------
ณ  // this code is taken from SMALLS(), our lookup table popup
ณ
ณ  case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft, nBot+2, nLeft+2)
ณ      oTb:up()
ณ      IFMOUSEHD({||oTb:up()},oTb)
ณ  case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft+3, nBot+2, nLeft+5)
ณ      oTb:down()
ณ      IFMOUSEHD({||oTb:down()},oTb)
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNC IFMOUSEHD(bBlock,oTb)
if rat_elbhd(.2)
  while rat_elbhd(.01)
    EVAL(bBlock)
    if oTb#nil
      while !oTb:stabilize()
      end
    endif
  end
endif
return nil


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MOUSEHOTAT()            *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  MOUSEHOTAT() Checks for mouse click from array of hot coordinates
ณ
ณ  Returns:
ณ  --------
ณ  <nReturn> => either number of element containing hot coordinates, or,
ณ               if element (an array) contains > 4 elements, the value in
ณ               the fifth element.
ณ
ณ  Syntax:
ณ  -------
ณ  MOUSEHOTAT(nMouseRow, nMouseCol, aHotSpots)
ณ
ณ  Description:
ณ  ------------
ณ  Checks an array of arrays for hot coordinates against <nMouseRow>
ณ  and <nMouseCol> to see if the mouse clicked on one of the hot spots.
ณ  The hot spot array is of the form:
ณ         {  {nTop,nLeft,nBottom,nRight,[nValue] },...}
ณ  Where each subarray is an array containing Top, Left, Bottom, Right
ณ  coordinates for an area of the screen which is mouse hot. If a match
ณ  is gotten and the subarray is four elements long, the number of the
ณ  subarray is returned. If the subarray is 5 elements long, the value
ณ  in the fifth element is returned.
ณ
ณ  Examples:
ณ  ---------
ณ  #include "INKEY.CH"
ณ  @10,10 say "<OK>
ณ  @11,10 say "<Cancel>"
ณ  aHotAreas  := {  {10,10,10,13}, {11,10,11,18} }
ณ  nLastKey   := RAT_EVENT(0,.f.,.f.,@nMouseRow, @nMouseCol)
ณ  nHotMouse  := MOUSEHOTAT(nMouseRow, nMouseCol, aHotAreas)
ณ  DO CASE
ณ  CASE nHotMouse==1    // <OK>
ณ  CASE nHotMouse==2    // <Cancel>
ณ  ENDCASE
ณ
ณ  // OR ALTERNATELY....Here I'll map the hot areas to the same return
ณ  // values as the hot keys the buttons represent...F10 and ESCAPE
ณ  // this is useful as you'll often have a button or hot area also
ณ  // assigned to a hot key.
ณ
ณ  @10,10 say "<F10 Save  >
ณ  @11,10 say "<ESC Cancel>"
ณ  aHotAreas   := {  {10,10,10,21,K_F10}, {11,10,11,21,K_ESC} }
ณ  nLastKey    := RAT_EVENT(0,.f.,.f.,@nMouseRow, @nMouseCol)
ณ  nHotMouse   := MOUSEHOTAT(nMouseRow, nMouseCol, aHotAreas)
ณ  DO CASE
ณ  CASE nHotMouse==K_F10 .or. nLastKey==K_F10    // <F10 Save  >
ณ  CASE nHotMouse==K_ESC .or. nLastKey==K_ESC   // <ESC Cancel>
ณ  ENDCASE
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNC MOUSEHOTAT(nMouseR, nMouseC, aButtons)
local nFound := 0
local i, a
for i = 1 to len(aButtons)
   a := aButtons[i]
   if nMouseR>=a[MTOP] .and. nMouseR<=a[MBOTTOM] ;
        .and. nMouseC>=a[MLEFT] .and. nMouseC<=a[MRIGHT]
    nFound := i
    exit
   endif
next
if nFound > 0 .and. len(aButtons[nFound])>4   // if 5th part to array, return that
  nFound := aButtons[nFound,5]
endif
return nFound


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MBRZCLICK()             *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  MBRZCLICK() Checks for mouse click on current Tbrowse row/col
ณ
ณ  Returns:
ณ  --------
ณ  <lClicked> => if the mouse clicked on the current Tbrowse cursor row and
ณ                column.
ณ
ณ  Syntax:
ณ  -------
ณ  MBRZCLICK(oTBrowse, nMouseRow, nMouseCol)
ณ
ณ  Description:
ณ  ------------
ณ  Determines if the mouse coordinates <nMouseRow> and <nMouseCol>
ณ  are within the area of the current Tbrowse row and column.
ณ
ณ  Examples:
ณ  ---------
ณ  from MCHOICE():
ณ
ณ   case nLastKey == K_MOUSELEFT
ณ         do case
ณ         case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-3, nBottom, nRight-2)
ณ            oTb:down()
ณ            IFMOUSEHD({||oTb:down()},oTb)
ณ         case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
ณ            keyboard chr(K_ENTER)
ณ         case MBRZCLICK(oTb,nMouseR, nMouseC)   //<-----here
ณ            EXIT
ณ         endcase
ณ   endcase
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
func MBRZCLICK(oTb,nMouseRow,nMouseCol)
  local nTbCol, nTbColEnd, nTbRow, lThis
  lThis := .f.
  oTb:refreshall()
  while !oTb:stabilize()
  end
  nTbCol    := col()
  nTbColEnd := nTbCol+oTb:colwidth(oTb:colpos)-1
  nTbRow    := row()
  if nMouseCol >= nTbCol .and. nMouseCol <= nTbColEnd .and. ;
     nMouseRow ==nTbRow
     lThis := .t.
  endif
return lThis

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MBRZMOVE()              *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  MBRZMOVE() Checks for mouse click at and moves to Tbrowse row/col
ณ
ณ  Returns:
ณ  --------
ณ  <lClicked> => If the mouse clicked on a new Tbrowse Row/Column.
ณ
ณ  Syntax:
ณ  -------
ณ  MBRZMOVE(oTBrowse, nMouseRow, nMouseCol,[nTop,nLeft,nBottom,nRight])
ณ
ณ  Description:
ณ  ------------
ณ  Determines if the mouse coordinates <nMouseRow> and <nMouseCol>
ณ  are on a new Tbrowse row/column, and causes the Tbrowse cursor to
ณ  move there.
ณ
ณ  [nTop,nLeft,nBottom,nRight] determine the Tbrowse 'live' area - the
ณ  area exclusive of headers, footers, seperators etc. MBRZMOVE() can
ณ  determine this on its own, but it is much faster to pass these
ณ  coordinates if you can.
ณ
ณ  Examples:
ณ  ---------
ณ  from MCHOICE():
ณ
ณ   case nLastKey == K_MOUSELEFT
ณ     do case
ณ     case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-3, nBottom, nRight-2)
ณ        oTb:down()
ณ        IFMOUSEHD({||oTb:down()},oTb)
ณ     case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
ณ        keyboard chr(K_ENTER)
ณ     case MBRZMOVE(oTb,nMouseR, nMouseC)
ณ        EXIT
ณ     endcase
ณ   endcase
ณ
ณ  Source:
ณ  -------
ณ  S_MOOSE.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
*-- this works MUCH faster if nTop..nRight are passed as the
*-- scrollable Tbrowse dimensions (excluding titles, footers)
func MBRZMOVE(oTb,nMouseRow,nMouseCol,nTop,nLeft,nBottom,nRight)
  local nTbCol, nTbColEnd, nTbRow
  local lHandled := .f.
  oTb:refreshall()
  while !oTb:stabilize()
  end

  if nTop==NIL .or. nLeft==NIL .or. nBottom==NIL .or. nRight==NIL
    nTop    := MBRZFDATA(oTb)
    nBottom := MBRZLDATA(oTb)
    nLeft   := oTb:nLeft
    nRight  := oTb:nRight
  endif
  nTbCol    := col()
  nTbColEnd := nTbCol+oTb:colwidth(oTb:colpos)-1
  nTbRow    := row()

  if nMouseRow>=nTop .and. nMouseRow<=nBottom .and. nMouseCol>=nLeft .and. ;
     nMouseCol<=nRight
         if nMouseCol < nTbCol
           lHandled := .t.
           while nMouseCol < nTbCol .and. ;
              oTb:colpos > oTb:leftvisible-oTb:freeze
              oTb:left()
              while !oTb:stabilize()
              end
              nTbCol    := col()
              nTbColEnd := nTbCol+oTb:colwidth(oTb:colpos)-1
           end

         elseif nMouseCol > nTbColend
           lHandled := .t.
           while nMouseCol > nTbCol .and. nMouseCol > nTbColend .and. ;
              oTb:colpos < oTb:rightvisible
              oTb:right()
              while !oTb:stabilize()
              end
              nTbCol    := col()
              nTbColEnd := nTbCol+oTb:colwidth(oTb:colpos)-1
           end
         endif

         if nMouseRow < nTbRow
           lHandled := .t.
           while nTbRow > nMouseRow
             oTb:up()
             nTbRow--
           end
         elseif nMouseRow > nTbRow
           lHandled := .t.
           while nTbRow < nMouseRow
             oTb:down()
             nTbRow++
           end
         endif
  endif
  if lHandled
          while !oTb:stabilize()
          end
  endif
return lHandled



/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  DETERMINE FIRST DATA ROW PHYSICAL
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
static function MBRZFDATA(oTb)
local nFirst := oTb:ntop
local i, lHeadSep, nHeading
local cHead
nHeading := 0
lHeadSep := !empty(oTb:Headsep)
for i = 1 to oTb:colcount()
  IF !empty(oTb:getcolumn(i):Headsep)
    lHeadSep := .t.
  ENDIF
  cHead := oTb:getcolumn(i):Heading
  if cHead#nil
    nHeading := MAX(nHeading,MLCOUNT(STRTRAN(cHead,";",chr(13)+chr(10))))
  endif
next
nFirst += ( nHeading+iif(lHeadsep,1,0) )
return nFirst
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  DETERMINE LAST DATA ROW PHYSICAL
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
static function MBRZLDATA(oTb)
local nLast := oTb:nbottom
local i, lFootSep, nFooting
local cFoot
nFooting := 0
lFootSep := !empty(oTb:footsep)
for i = 1 to oTb:colcount()
  IF !empty(oTb:getcolumn(i):footsep)
    lFootSep := .t.
  ENDIF
  cFoot := oTb:getcolumn(i):footing
  if cFoot#nil
    nFooting := MAX(nFooting,MLCOUNT(STRTRAN(cFoot,";",chr(13)+chr(10))))
  endif
next
nLast -= ( nFooting+iif(lFootsep,1,0) )
return nLast



/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  Toggle lHandleHot static - do we handle hotkeys or not
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
Function RAT_EHH(lNew)
local lReturn := lHandleHot
if lNew#nil
        lHandleHot := lNew
endif
return lReturn


/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  Set PROC,LINE,VARIABLE to pass to SETKEY() blocks
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
PROC RAT_EONKEY(cProc,nLine,cVar)
scProc = cProc
snLine = nLine
scVar  = cVar
RETURN

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  Return VALUE OF STATIC scProc
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
function RAT_EONP
return scProc

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  Return VALUE OF STATIC snLine
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
function RAT_EONL
return snLine

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ณ  Return VALUE OF STATIC scVar
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*/
function RAT_EONV
return scVar


function rat_checkesc
return (inkey()==27 .or. rat_rightb() )

FUNCTION SLS_ISMOUSE(lSet)
if lIsMouse==NIL
  lIsMouse := rat_exist()
endif
if lSet#nil .and. !lSet
 lIsMouse := .f.
endif
return lIsMouse

function rat_lmcode
return K_LBUTTONDOWN

function rat_rmcode
return K_RBUTTONDOWN

