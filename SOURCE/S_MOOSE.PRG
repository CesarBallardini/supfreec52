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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_EVENT()          *changed*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
� 
�  Short:
�  ------
�  RAT_EVENT() Event handler - inkey() with mouse awareness
� 
�  Returns:
�  --------
�  <nEvent> => Event value - either inkey() value or
�  mouse value
� 
�  Syntax:
�  -------
�  RAT_EVENT([nTimeout],[lClearkb])
�
�  Description:
�  ------------
�  Event handler - inkey() with mouse awareness
� 
�  <nTimeout>   is the   # seconds to wait before
�  timeout. Zero (0) means indefinately . If you don't pass
�  anything, default is 0. Slight difference from inkey() there.
� 
�  Returns values are:
� 
�     If keystroke                                   inkey() value
�     If left mouse button has been depressed        K_MOUSELEFT
�     If right mouse button has been depressed       K_RBUTTONDOWN
�     If timeout                                     0
� 
� 
�  [lClearkb]   optional clear keyboard True (default)
�  or False. If a keystroke is gotten, and this is True, clear the
�  keyboard with:
�                     while inkey()#0
�                     end
� 
�  Examples:
�  ---------
�   e := 0
� 
�   while  e#27
�      e := rat_event(30)
�      do case
�      case e == 0
�        ? "Timed out after 30 seconds"
�      case e < K_LBUTTONDOWN
�        ? "Key press with inkey() value of :",e
�      case e == K_LBUTTONDOWN
�        ? "Left mouse button pressed at :"
�        ?? "row-> ",rat_eqmrow(),  "col-> ",rat_eqmcol()
�      case e == K_RBUTTONDOWN
�        ? "Right mouse button pressed at :"
�        ?? "row-> ",rat_eqmrow(),  "col-> ",rat_eqmcol()
�      endcase
�   end
� 
�  Source:
�  -------
�  S_MOOSE.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_ELBHD()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  RAT_ELBHD() Determines if left mouse button is held down
�
�  Returns:
�  --------
�  <lHeldDown> => is LMB held down
� 
�  Syntax:
�  -------
�  RAT_ELBHD([nSeconds])
� 
�  Description:
�  ------------
�  Determines if left mouse button is held down by
�  calling the ASM function RAT_LBHD() for [nSeconds]. Default is .1
�  seconds.
�
�  If the left mouse button is held down during that
�  time frame, True is returned, else False is returned.
� 
�  Note: the ASM function RAT_LBHD() returns a logical
�  value if the left mouse button is depressed RIGHT NOW, but
�  does not take a duration of [nSeconds] into account, which is needed
�  to determine if it is depressed and HELD DOWN.
� 
�  [nSeconds]  is optional seconds to test for. Default
�  is .1 seconds.
�
�  Examples:
�  ---------
�   if rat_elbhd()
� 
�     ?"While you were out:"
� 
�     ?"Left button was depressed and held down at"
� 
�     ??rat_eqmrow(),rat_eqmcol()
�
�   endif
� 
�  Source:
�  -------
�  S_MOOSE.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_ERBHD()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� 
�  Short:
�  ------
�  RAT_ERBHD() Determines if right mouse button is held down
� 
�  Returns:
�  --------
�  <lHeldDown> => is RMB held down
� 
�  Syntax:
�  -------
�  RAT_ERBHD([nSeconds])
� 
�  Description:
�  ------------
�  Determines if right mouse button is held down by
�  calling the ASM function RAT_RBHD() for [nSeconds]. Default for
�  [nSeconds] is .1 seconds. If the right mouse button is held down
�  during that time frame, True is returned, else False is returned.
�
�  [nSeconds]   is optional seconds to test for. Default
�  is .1 seconds.
� 
�  This is different from the .ASM function RAT_RBHD().
�  RAT_ERBHD(<n>) watches the mouse for <n> seconds, and if the
�  mouse remains depressed for the full time, then it is considered
�  to be HELD DOWN.  RAT_RBHD() on the other hand, only checks for
�  the mouse button being depressed RIGHT NOW. RAT_ERBHD() calls
�  RAT_RBHD() repetitively.
�
�  Examples:
�  ---------
�   if rat_erbhd()
� 
�     ?"While you were out:"
� 
�     ?"Right button was depressed and held down at"
� 
�     ??rat_eqmrow(),rat_eqmcol()
�
�   endif
� 
�  Source:
�  -------
�  S_MOOSE.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_EQMROW()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  RAT_EQMROW() Returns mouse row at last press
� 
�  Returns:
�  --------
�  <nRow> => mouse row at last button press (left or
�  right)
�
�  Syntax:
�  -------
�  RAT_EQMROW()
� 
�  Description:
�  ------------
�  Returns mouse row at last press (LEFT OR RIGHT).
�  S_MOOSE.PRG has two static variables, 'mouserow' and 'mousecol'.
�  These are set each time RAT_EVENT() determines that the mouse
�  has been depressed.
� 
�  Examples:
�  ---------
�   e := 0
� 
�   while e#27
�      e := rat_event(30)
�      do case
�      case e == 0
�        ? "Timed out after 30 seconds"
�      case e < K_LBUTTONDOWN
�        ? "Key press with inkey() value of :",e
�      case e == K_LBUTTONDOWN
�        ? "Left mouse button pressed at :"
�        ?? "row-> ",rat_eqmrow()
�        ?? "col-> ",rat_eqmcol()
�      case e == K_RBUTTONDOWN
�        ? "Right mouse button pressed at :"
�        ?? "row-> ",rat_eqmrow()
�        ?? "col-> ",rat_eqmcol()
�      endcase
�   end
�
�  Source:
�  -------
�  S_MOOSE.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様� 
*/
function rat_eqmrow()     && return mouse row at last mouse event
return mouserow
/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_EQMCOL()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  RAT_EQMCOL() Returns mouse column at last press
�
�  Returns:
�  --------
�  <nRow> => mouse column at last button press (left or
�  right)
�
�  Syntax:
�  -------
�  RAT_EQMCOL()
� 
�  Description:
�  ------------
�  Returns mouse column at last press (LEFT OR RIGHT).
�  S_MOOSE.PRG has two static variables, 'mouserow' and 'mousecol'.
�  These are set each time RAT_EVENT() determines that the mouse
�  has been depressed.
� 
�  Examples:
�  ---------
�   e := 0
�
�   while e#27
�      e := rat_event(30)
�      do case
�      case e == 0
�        ? "Timed out after 30 seconds"
�      case e < K_LBUTTONDOWN
�        ? "Key press with inkey() value of :",e
�      case e == K_LBUTTONDOWN
�        ? "Left mouse button pressed at :"
�        ?? "row-> ",rat_eqmrow()
�        ?? "col-> ",rat_eqmcol()
�      case e == K_RBUTTONDOWN
�        ? "Right mouse button pressed at :"
�        ?? "row-> ",rat_eqmrow()
�        ?? "col-> ",rat_eqmcol()
�      endcase
�   end
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
function rat_eqmcol()     && return mouse column at last mouse event
return mousecol
/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_ISMOUSE()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  RAT_ISMOUSE() Determines mouse usage by RAT_EVENT()
�
�  Returns:
�  --------
�  <lIsMouse> => is there a mouse
�
�  Syntax:
�  -------
�  RAT_ISMOUSE([lIsMouse])
�
�  Description:
�  ------------
�  Determines mouse usage by RAT_EVENT(). Default is
�  determined by a call to the ASM function RAT_EXIST(). However,
�  you may want to shut down mouse usage even if a mouse is
�  present. If so, call this function with False, to override.
�
�  [lIsMouse]  S_MOOSE.PRG contains a static variable
�  called 'lIsMouse'. This is determined initially by a call to
�  RAT_EXIST(), but may be overridden by calling RAT_ISMOUSE(.f.).
� 
�  Examples:
�  ---------
�   RAT_ISMOUSE(.f.).
� 
�  Source:
�  -------
�  S_MOOSE.PRG
� 
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
function rat_ismouse(imoose)
lIsMouse := iif(imoose#nil,imoose,iif(lIsMouse#nil,lIsMouse,rat_exist() ) )
return lIsMouse


/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION RAT_LASTEV()          *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  RAT_LASTEV() Returns the last event recorded by RAT_EVENT()
�
�  Returns:
�  --------
�  <nEvent> => last recorded RAT_EVENT() event
�
�  Syntax:
�  -------
�  RAT_LASTEV()
�
�  Description:
�  ------------
�  Every once in a while, some other function will be responsible
�  for doing the RAT_EVENT() call, but your function still wants
�  to know what the last event was. This function can be used to
�  retrieve that value.
�
�  Examples:
�  ---------
�   RAT_LASTEV()
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
function rat_lastev
return nLastEvent


*- various commonly used internal mouse routines


/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION ISMOUSEAT()             *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  ISMOUSEAT() Checks for mouse click within passed coordinates
�
�  Returns:
�  --------
�  <lClicked> => true if mouse click occured within the passed
�                coordinates
�
�  Syntax:
�  -------
�  ISMOUSEAT(nMouseRow, nMouseCol, nTop,nLeft,nBottom,nRight)
�
�  Description:
�  ------------
�  Checks <nMouseRow>, <nMouseCol> against the coordinates
�  <nTop>, <nLeft>,<nBottom>,<nRight> and returns True if the
�  mouse row and col are within the screen coordinates.
�
�  Examples:
�  ---------
�
�  case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft, nBot+2, nLeft+2)
�     oTb:up()
�
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
func ISMOUSEAT(nMouseR, nMouseC, nTop, nLeft, nBottom,nRight)
return (nMouseR>=nTop .and. nMouseR<=nBottom .and. ;
        nMouseC>=nLeft .and. nMouseC<=nRight)


/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION IFMOUSEHD()             *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  IFMOUSEHD() Checks if mouse held down,evals codeblock while it is
�
�  Returns:
�  --------
�  NIL
�
�  Syntax:
�  -------
�  IFMOUSEHD(bBlock, [oTbrowse])
�
�  Description:
�  ------------
�  You'll often want to hold the left mouse button down on a hot object
�  in order to cause an action to repeat rapidly over and over. An
�  example would be on an up or down arrow that caused a tbrowse object
�  to go up or down. Rather than go click-release-click-release-click..etc,
�  you prefer to just hold the mouse down.
�
�  If you detect the mouse has been pressed and you then want to check
�  if its held down and perform an action repetetively while it is,
�  you can use this function.
�
�  <bBlock> is the code block to be evaluated continuously while the mouse
�  is held down. (there is a .01 second delay between iterations).
�
�  [oTbrowse] is an optional Tbrowse object that you wish to be refreshed
�  during the evaluation of the block. (otherwise, you could hold the mouse
�  button down continuously and not se anything happen. You could have
�  your codeblock refresh the Tbrowse, of course. Its just easier this
�  way.
�
�
�  Examples:
�  ---------
�  // this code is taken from SMALLS(), our lookup table popup
�
�  case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft, nBot+2, nLeft+2)
�      oTb:up()
�      IFMOUSEHD({||oTb:up()},oTb)
�  case ISMOUSEAT(nMouseR, nMouseC, nBot+2, nLeft+3, nBot+2, nLeft+5)
�      oTb:down()
�      IFMOUSEHD({||oTb:down()},oTb)
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION MOUSEHOTAT()            *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  MOUSEHOTAT() Checks for mouse click from array of hot coordinates
�
�  Returns:
�  --------
�  <nReturn> => either number of element containing hot coordinates, or,
�               if element (an array) contains > 4 elements, the value in
�               the fifth element.
�
�  Syntax:
�  -------
�  MOUSEHOTAT(nMouseRow, nMouseCol, aHotSpots)
�
�  Description:
�  ------------
�  Checks an array of arrays for hot coordinates against <nMouseRow>
�  and <nMouseCol> to see if the mouse clicked on one of the hot spots.
�  The hot spot array is of the form:
�         {  {nTop,nLeft,nBottom,nRight,[nValue] },...}
�  Where each subarray is an array containing Top, Left, Bottom, Right
�  coordinates for an area of the screen which is mouse hot. If a match
�  is gotten and the subarray is four elements long, the number of the
�  subarray is returned. If the subarray is 5 elements long, the value
�  in the fifth element is returned.
�
�  Examples:
�  ---------
�  #include "INKEY.CH"
�  @10,10 say "<OK>
�  @11,10 say "<Cancel>"
�  aHotAreas  := {  {10,10,10,13}, {11,10,11,18} }
�  nLastKey   := RAT_EVENT(0,.f.,.f.,@nMouseRow, @nMouseCol)
�  nHotMouse  := MOUSEHOTAT(nMouseRow, nMouseCol, aHotAreas)
�  DO CASE
�  CASE nHotMouse==1    // <OK>
�  CASE nHotMouse==2    // <Cancel>
�  ENDCASE
�
�  // OR ALTERNATELY....Here I'll map the hot areas to the same return
�  // values as the hot keys the buttons represent...F10 and ESCAPE
�  // this is useful as you'll often have a button or hot area also
�  // assigned to a hot key.
�
�  @10,10 say "<F10 Save  >
�  @11,10 say "<ESC Cancel>"
�  aHotAreas   := {  {10,10,10,21,K_F10}, {11,10,11,21,K_ESC} }
�  nLastKey    := RAT_EVENT(0,.f.,.f.,@nMouseRow, @nMouseCol)
�  nHotMouse   := MOUSEHOTAT(nMouseRow, nMouseCol, aHotAreas)
�  DO CASE
�  CASE nHotMouse==K_F10 .or. nLastKey==K_F10    // <F10 Save  >
�  CASE nHotMouse==K_ESC .or. nLastKey==K_ESC   // <ESC Cancel>
�  ENDCASE
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION MBRZCLICK()             *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  MBRZCLICK() Checks for mouse click on current Tbrowse row/col
�
�  Returns:
�  --------
�  <lClicked> => if the mouse clicked on the current Tbrowse cursor row and
�                column.
�
�  Syntax:
�  -------
�  MBRZCLICK(oTBrowse, nMouseRow, nMouseCol)
�
�  Description:
�  ------------
�  Determines if the mouse coordinates <nMouseRow> and <nMouseCol>
�  are within the area of the current Tbrowse row and column.
�
�  Examples:
�  ---------
�  from MCHOICE():
�
�   case nLastKey == K_MOUSELEFT
�         do case
�         case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-3, nBottom, nRight-2)
�            oTb:down()
�            IFMOUSEHD({||oTb:down()},oTb)
�         case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
�            keyboard chr(K_ENTER)
�         case MBRZCLICK(oTb,nMouseR, nMouseC)   //<-----here
�            EXIT
�         endcase
�   endcase
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
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
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION MBRZMOVE()              *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  MBRZMOVE() Checks for mouse click at and moves to Tbrowse row/col
�
�  Returns:
�  --------
�  <lClicked> => If the mouse clicked on a new Tbrowse Row/Column.
�
�  Syntax:
�  -------
�  MBRZMOVE(oTBrowse, nMouseRow, nMouseCol,[nTop,nLeft,nBottom,nRight])
�
�  Description:
�  ------------
�  Determines if the mouse coordinates <nMouseRow> and <nMouseCol>
�  are on a new Tbrowse row/column, and causes the Tbrowse cursor to
�  move there.
�
�  [nTop,nLeft,nBottom,nRight] determine the Tbrowse 'live' area - the
�  area exclusive of headers, footers, seperators etc. MBRZMOVE() can
�  determine this on its own, but it is much faster to pass these
�  coordinates if you can.
�
�  Examples:
�  ---------
�  from MCHOICE():
�
�   case nLastKey == K_MOUSELEFT
�     do case
�     case ISMOUSEAT(nMouseR, nMouseC, nBottom,nRight-3, nBottom, nRight-2)
�        oTb:down()
�        IFMOUSEHD({||oTb:down()},oTb)
�     case MBRZMOVE(oTb,nMouseR, nMouseC,nTop+1,nLeft+1,nBottom-1,nRight-1)
�        keyboard chr(K_ENTER)
�     case MBRZMOVE(oTb,nMouseR, nMouseC)
�        EXIT
�     endcase
�   endcase
�
�  Source:
�  -------
�  S_MOOSE.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
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
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  DETERMINE FIRST DATA ROW PHYSICAL
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
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
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  DETERMINE LAST DATA ROW PHYSICAL
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
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
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  Toggle lHandleHot static - do we handle hotkeys or not
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
*/
Function RAT_EHH(lNew)
local lReturn := lHandleHot
if lNew#nil
        lHandleHot := lNew
endif
return lReturn


/*
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  Set PROC,LINE,VARIABLE to pass to SETKEY() blocks
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
*/
PROC RAT_EONKEY(cProc,nLine,cVar)
scProc = cProc
snLine = nLine
scVar  = cVar
RETURN

/*
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  Return VALUE OF STATIC scProc
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
*/
function RAT_EONP
return scProc

/*
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  Return VALUE OF STATIC snLine
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
*/
function RAT_EONL
return snLine

/*
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
�  Return VALUE OF STATIC scVar
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳
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

