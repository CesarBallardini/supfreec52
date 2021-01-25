

#include "box.ch"
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN


#define   MENUSIZE         27
#define   MENUBAR          1
#define   MC_MBOX          2
#define   MC_MSEL          3
#define   MC_MUNS          4
#define   MC_MINA          5
#define   MC_MSELTRIG      6
#define   MC_MUNSTRIG      7
#define   MC_FRAMES        8
#define   MENUCURRTOP      9
#define   MENUDROPPED      10
#define   MENUFIRSTLTR     11
#define   MENUHIDEPATH     12
#define   MENUMOUSEHOTS    13
#define   MENUKEYHOTS      14
#define   MENUEXITREQ      15
#define   MENUTOP          16
#define   MENULEFT         17
#define   MENURIGHT        18
#define   MENUCROSS        19
#define   MENUCHECKEXIT    20
#define   MENUIMMEDIATE    21
#define   MENUNEWTOP       22
#define   MENUHIDELEVEL    23
#define   MENUHIDDEN       24
#define   MENUSHADOWPOS    25
#define   MENUSHADOWATT    26
#define   MENUHANDLEALT    27


#define   BOXSIZE          15
#define   BOXLEVEL         1
#define   BOXTOP           2
#define   BOXLEFT          3
#define   BOXBOTTOM        4
#define   BOXRIGHT         5
#define   BOXPROMPTS       6
#define   BOXFIRST         7
#define   BOXDRAWBLOCK     8
#define   BOXRESTBLOCK     9
#define   BOXUNDER         10

#define   PROMPTSIZE       15
#define   PROMPTLEVEL      1
#define   PROMPTTOP        2
#define   PROMPTLEFT       3
#define   PROMPTBOTTOM     4
#define   PROMPTRIGHT      5
#define   PROMPTTEXT       6
#define   PROMPTTRIGGER    7
#define   PROMPTTRIGPOS    8
#define   PROMPTTYPE       9
#define   PROMPTDISPBLOCK  10
#define   PROMPTACTBLOCK   11
#define   PROMPTEXECBLOCK  12
#define   PROMPTDROPBOX    13

#define   TYPEACTION       1
#define   TYPEDROPDOWN     2
#define   TYPECROSSBAR     3

#define   EVENTMOUSER      K_RBUTTONDOWN
#define   EVENTMOUSEL      K_LBUTTONDOWN

#define   MOUSEHOTTOP        1
#define   MOUSEHOTLEFT       2
#define   MOUSEHOTBOTTOM     3
#define   MOUSEHOTRIGHT      4
#define   MOUSEHOTBLOCK      5

#define   KEYHOTVALUE        1
#define   KEYHOTBLOCK        2

/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION BUNGEE()                             *new*
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³
³  Short:
³  ------
³  BUNGEE() Mouseable, multi-level dropdown menu with triggers
³
³  Returns:
³  --------
³  NIL
³
³  Syntax:
³  -------
³
³  BUNGEE(<nTop>,<nLeft>,<nRight>,<aMenu>,[aColumns],;
³         [aColors],[aHotMice],[aHotKeys],[bExitCheck],;
³         [lImmediate],[lDropped],[nHideLevel],[nShadowPos],;
³         [nShadowAtt],[lHandleAlt] )
³
³  Description:
³  ------------
³  Creates and activates a dropdown menu (bungee style)
³
³  <nTop>          Row of menu bar
³  <nLeft>         Left side of menu bar
³  <nRight>        Right side of menu bar
³  <aMenu>         A menu definition array of arrays
³
³                  You  use the BUNGEE() menu array definition functions:
³                  BUNGSTART(), BUNGEND(), BUNGOPTION(),BUNGDROP(),
³                  BUNGUNDROP() together to create a menu definition array
³                  for BUNGEE( ). This basically defines the menu options,
³                  boxes and actions
³
³  [aColumns]      An array of columns to determine the column
³                  positions for the top bar options. Optional, as
³                  this is automatically determined otherwise.
³
³  [aColors]       An array of seven elements describing 6 colors
³                  and the box drawing frame string
³
³                  BACKGROUND COLOR         1
³                  SELECTED OPTION COLOR    2
³                  UNSELECTED OPTION COLOR  3
³                  INACTIVE OPTION COLOR    4
³                  SELECTED TRIGGER COLOR   5
³                  UNSELECTED TRIGGER COLOR 6
³                  BOX FRAME STRING         7   (as in "ÚÄ¿³ÙÄÀ³ ")
³
³                  Defaults are extracted from the current
³                  values in SETCOLOR(), and adjusted to
³                  account for trigger letters and inactive
³                  colors.
³
³
³  [aHotMice]      An array of hot areas where, should the
³                  mouse click, a codeblock will be evaluated.
³                  The array is an array of arrays, where each
³                  sub-array is in the form:
³                      {nTop,nLeft,nBottom,nRight,bCodeblock}
³                  Where nTop..nRight refer to the screen
³                  coordinates of the hot area.
³                  i.e.
³                  @24,0 say "<Help>"
³                  aHotMice := { {24,0,24,5,{||dohelp}}  }
³
³
³  [aHotKeys]      An array of hotkey values, which, if one of
³                  the keys is pressed, a codeblock will be
³                  evaluated on the spot.
³                  The array is an array of arrays, where each
³                  sub-array is of the form:
³                      {nASCIIValue,bCodeblock}
³
³                  @24,0 say "<Help>"
³                  aHotKeys := { {K_F1,{||dohelp()}  }  }
³
³
³  [bExitBlock]    This is a codeblock which returns a LOGICAL
³                  which is evaluated before a menu exit is
³                  allowed. If it returns .f., a menu exit will
³                  not be allowed.
³                  i.e. {||MESSYN("Really exit?")}
³
³  [lImmediate]    Do mouse clicks or hot keys on options other
³                  than current option cause an immediate action
³                  request? Default = True
³
³  [lDropped]      Should the menu start up in dropped mode (boxes
³                  are already dropped from top bar) Default is
³                  True.
³
³  [nHideLevel]    This indicates the level to which the menu hides
³                  itself when executing an option action, a mouse
³                  hot button or a hot key.
³                  0 - does not hide itself at all
³                  1 - hides everything except the top bar  (default)
³                  2 - hides everything
³
³  [nShadowPos]    Optional shadow position for menu dropdown boxes.
³                  Valid options are:
³                       1. Lower left
³                       3. Lower right
³                       0. None
³                  Upper left and upper right shadow positions are not
³                  allowed. (they can overwrite parts of the menu bar)
³                  Default is SLS_SHADPOS(), unless SLS_SHADPOS() is
³                  upper left or upper right (7,9), in which case it
³                  is set to 0 (none).
³
³                  To force no shadows for the menu, pass 0.
³
³                  Boxes may not always have shadows, if the shadow would
³                  be drawn offscreen.
³
³  [nShadowAtt]   Numeric shadow attribute. Default is SLS_SHADATT(), whose
³                 default is 8. (grey on black)
³
³  [lHandleAlt]   Allow ALT+trigger letter combinations (ALT-A through ALT-Z)
³                 to select menu options
³
³  Examples:
³  ---------
³
³  (Also see S3META2.PRG in the sample files for a good example)
³
³  bungstart()
³  bungoption("Files")
³  bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³  bungundrop()
³  bungoption("Edit")
³  bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³  bungundrop()
³  bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³
³  @24,0 say "[ALT-X=exit]"   // set up Alt-X as a hotkey exit also
³  aHotKeys := { {K_ALT_X,{||bungeequit()}           }
³  aHotMice := {  {24,0,24,11,{||bungeequit()}     }  }
³
³  bungee(0,0,79,aMenu,nil,nil,aHotMice,aHotKeys, { ||messyn("Exit now?") }   )
³
³  Example 2
³  ---------
³
³  bungstart()
³  bungoption("Next",{||dbskip(1)})
³  bungoption("Prev",{||dbskip(-1)})
³  bungoption("Edit",{||doedit()})
³  bungoption("Add ",{||doadd()})
³  bungoption("Delete",{||dodelete()})
³  bungoption("Table",{||editdb(.t.)})
³  bungoption("Search")
³       bungdrop()
³       bungoption("Field Search",{||searchme()} )
³       bungoption("Key Search",{||SPOPSEEK()} )
³       bungoption("Query ",{||query()} )
³       bungundrop()
³  bungoption("Memo")
³       bungdrop()
³       bungoption("View",{||viewmemo()} )
³       bungoption("Edit",{||editmemo()} )
³       bungundrop()
³  bungoption("Hardcopy")
³       bungdrop()
³       bungoption("Record",{||hcrecord()})
³       bungoption("Memo",{||hcmemo()})
³       bungundrop()
³  bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³  bungee(0,0,79,aMenu)
³
³
³
³  Notes:
³  ------
³  Notes: Dropdown boxes will adjust for 'too far right' or 'too far down',
³  but there is no adjustment for 'too many options in the box to fit on
³  screen'
³
³
³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Source:
³  -------
³  S_BUNGEE.PRG, S_BUNGDE.PRG
³
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
*/


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   MAIN MENU HANDLER
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/

FUNCTION BUNGEE(nTop,nLeft,nRight,aInPrompts,aColumns,;
                 aColors,aMouseHots, aKeyHots,bCheckExit,;
                 lImmediate,lDropped,nHideLevel,nShadowpos,;
                 nShadowAtt,lHandleAlt)
local aMenu := MENUDEF(nTop,nLeft,nRight,aInPrompts,aColumns,;
                 aColors,aMouseHots, aKeyHots,bCheckExit,;
                 lImmediate, lDropped,nHideLevel,nShadowPos,;
                 nShadowAtt,lHandleAlt)
logmenu(aMenu)
MHANDLER(aMenu[MENUBAR],aMenu)
logmenu("")
return nil


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   Handle current box/bar
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static FUNCTION MHANDLER(aCurrentBox,aMenu)

  local nCount, nEventCode, cEventCode
  local nNewTopPosit, nNewBoxPosit, nMouseR,nMouseC
  local nMouseHotPress, nKeyHotPress
  local nCursor := SETCURSOR(0)

  local aTopMenuBar        := aMenu[MENUBAR]
  local aCurrentPrompts    := aCurrentBox[BOXPROMPTS]

  // find first active option
  local nCurrentOption      := ASCAN(aCurrentPrompts,;
                             {|a|EVAL(a[PROMPTACTBLOCK])})
  local nNumberofPrompts    := LEN(aCurrentPrompts)
  local lAnyActive          := nCurrentOption > 0
  local lDone               := .f.
  local aTopOptions         := aMenu[MENUBAR,BOXPROMPTS]
  local cTopLtrs            := aMenu[MENUFIRSTLTR]
  local nTopOptions         := LEN(aMenu[MENUBAR,BOXPROMPTS])
  local lActionReq          := .f.
  local lInTopBar           := (aCurrentBox==aTopMenuBar)
  local lDroptoNextLevel    := .f.
  local lImmediate          := aMenu[MENUIMMEDIATE]
  local aAltKeys := ;
          {K_ALT_A,K_ALT_B,K_ALT_C,K_ALT_D,K_ALT_E,;
           K_ALT_F,K_ALT_G,K_ALT_H,K_ALT_I,K_ALT_J,;
           K_ALT_K,K_ALT_L,K_ALT_M,K_ALT_N,K_ALT_O,;
           K_ALT_P,K_ALT_Q,K_ALT_R,K_ALT_S,K_ALT_T,;
           K_ALT_U,K_ALT_V,K_ALT_W,K_ALT_X,K_ALT_Y,K_ALT_Z}
  local nAltFound

  if (aCurrentBox[BOXLEVEL]==0)
    TOP_BAR_POSITION(1,aMenu)
  endif

  PAINTMENUBOX(aCurrentBox)

  AADD(aMenu[MENUHIDEPATH],{aCurrentBox,nCurrentOption})

  While !lDone .and. !aMenu[MENUEXITREQ] .and. !aMenu[MENUNEWTOP]
     lActionReq  := .f.

     if lInTopBar
       nCurrentOption      := TOP_BAR_POSITION(nil,aMenu)
       // reset menu hide path to top bar only
       aMenu[MENUHIDEPATH] := {{aCurrentBox,nCurrentOption}}
     else
       // Set current Menuhidepath option to new box/option
       aMenu[MENUHIDEPATH,len(aMenu[MENUHIDEPATH])] := ;
             {aCurrentBox,nCurrentOption}
     endif


     if nCurrentOption > 0
       //----display current option selected
       EVAL(aCurrentPrompts[nCurrentOption,PROMPTDISPBLOCK],.t.,;
                EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK]) )

     endif


     nMouseR := 0
     nMouseC := 0
     // if in top bar, and menu has dropped, and the current
     // top bar option has a dropbox, and the dropbox has
     // some active prompts
     if lInTopBar .and. aMenu[MENUDROPPED] .and. ;
        !empty(aCurrentPrompts[nCurrentOption,PROMPTDROPBOX]) .and. ;
          ASCAN(aCurrentPrompts[nCurrentOption,PROMPTDROPBOX,BOXPROMPTS],;
                    {|a|EVAL(a[PROMPTACTBLOCK])}) > 0

         //-- call this same proc recursively to handle the
         //-- dropdown box attached to the current prompt/option
         nEventCode := ;
            MHANDLER(aCurrentPrompts[nCurrentOption,PROMPTDROPBOX],aMenu)
         nMouseR := rat_eqmrow()
         nMouseC := rat_eqmcol()

     elseif lDroptoNextLevel
         nEventCode := ;
            MHANDLER(aCurrentPrompts[nCurrentOption,PROMPTDROPBOX],aMenu)
         nMouseR := rat_eqmrow()
         nMouseC := rat_eqmcol()
         lDroptoNextLevel := .f.
         //-- refresh the current box
         MREFBOX(aCurrentBox)

     else
         // otherwise, just sit at the top bar prompt and
         // wait for orders...
         nEventCode := RAT_EVENT(0,.f.,.f.,@nMouseR, @nMouseC)

     endif
     if lInTopBar
       aMenu[MENUNEWTOP]:= .f.
     endif
     if nCurrentOption > 0
       // display current option unselected
       EVAL(aCurrentPrompts[nCurrentOption,PROMPTDISPBLOCK],.f.,;
                EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK]) )
     endif

     if aMenu[MENUHANDLEALT]
         //-- then convert any ALT+key combinations to just the key
         //-- i.e. ALT+A becomes just "A"

         if ( nAltFound := ASCAN(aAltKeys,nEventCode) ) > 0

              if setkey(nEventCode)==nil
                   nEventCode := 64+nAltFound
                   //--  64+1 == 65 == character "A"
              endif
         endif
     endif

     cEventCode := UPPER(CHR(nEventCode))

     DO CASE
     CASE nEventCode == EVENTMOUSEL
        DO CASE
        //-- either top bar or first level of box, and mouse clicked
        //-- on a top bar option (mouseinbox() checks for active status)


        CASE (nNewTopPosit := ;
                    MOUSEINBOX(aMenu[MENUBAR],aTopOptions,nMouseR,nMouseC,.t.) ) > 0

            //-- if its the same top option than current
            if nNewTopPosit==TOP_BAR_POSITION(nil,aMenu)

              //-- if the option is an ACTION (block) option
              if aTopOptions[nNewTopPosit,PROMPTTYPE]==TYPEACTION
                lActionReq := .t.
              elseif !aMenu[MENUDROPPED]
                //-- presume there's a dropdown box
                aMenu[MENUDROPPED] := .t.
              endif

            else
              //-- its a different top ooption, so set it
              TOP_BAR_POSITION(nNewTopPosit,aMenu)

              //-- if we are in the first drop level, we need to
              //-- exit back on level of recursion and let the
              //-- top bar handler realize that it has changed
              //-- top bar options. It will also see that it has
              //-- already dropped, and so will drop the box
              //-- under that option
              *if aCurrentBox[BOXLEVEL]==1
              if aCurrentBox[BOXLEVEL]>0
                *lDone := .t.   // this causes an exit from this level of recursion
                aMenu[MENUNEWTOP]:= .T.
              endif
             if aTopOptions[nNewTopPosit,PROMPTTYPE]==TYPEACTION ;
                        .and. lImmediate
                KEYBOARD chr(K_ENTER)
             endif

            endif
        //-- not in top bar and mouse clicked on a box option
        //-- (mouseinbox() checks for active status)
        CASE !lInTopBar .and. ;
            (nNewBoxPosit := MOUSEINBOX(aCurrentBox,aCurrentPrompts,nMouseR,nMouseC,.f.) ) > 0

            if nCurrentOption==nNewBoxPosit
              //-- if current position, its an action request
              lActionReq := .t.
            else
              //-- otherwise, just change box position
              nCurrentOption := nNewBoxPosit
              if lImmediate
                KEYBOARD chr(K_ENTER)
              endif
            endif

        //-- maybe a programmer supplied hot mouse block?
        CASE (nMouseHotPress := ;
                    ASCAN(aMenu[MENUMOUSEHOTS],;
                    {|e|nMouseR>=e[MOUSEHOTTOP] .and. ;
                    nMouseR <=e[MOUSEHOTBOTTOM] .and. ;
                    nMouseC >=e[MOUSEHOTLEFT] .and. ;
                    nMouseC <= e[MOUSEHOTRIGHT]}) ) > 0

             hide_menu(aMenu)
             SETCURSOR(nCursor)
             eval(aMenu[MENUMOUSEHOTS,nMouseHotPress,MOUSEHOTBLOCK])
             SETCURSOR(0)
             bungeeshow()

             //-- refresh the current box
             MREFBOX(aCurrentBox)

             //-- check for active option
             if !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
                nCurrentOption  := ASCAN(aCurrentPrompts,;
                       {|a|EVAL(a[PROMPTACTBLOCK])})
                if nCurrentOption==0
                  //-- if everything is now inactive, we have to leave
                  lDone := .t.
                endif
             endif
        ENDCASE



     CASE nEventCode == K_LEFT .and. lInTopBar
        nCurrentOption := iif(nCurrentOption==1,;
                          nNumberofPrompts,nCurrentOption-1)
        while !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
           nCurrentOption := iif(nCurrentOption==1,;
                             nNumberofPrompts,nCurrentOption-1)
        end
        TOP_BAR_POSITION( nCurrentOption,aMenu)

     CASE nEventCode == K_LEFT .and. aCurrentBox[BOXLEVEL]==1
        //-- left key, and box level 1, must exit this proc so that
        //-- previous instance of the proc can reset the top bar
        //-- and move to it
        TOP_BAR_POSITION( iif(aMenu[MENUCURRTOP]==1,;
                        nTopOptions,TOP_BAR_POSITION(nil,aMenu)-1) ,aMenu)

        while !EVAL(aTopOptions[TOP_BAR_POSITION(nil,aMenu),PROMPTACTBLOCK])
          TOP_BAR_POSITION( iif(aMenu[MENUCURRTOP]==1,;
                          nTopOptions,TOP_BAR_POSITION(nil,aMenu)-1) ,aMenu)
        end
        lDone := .t.

     CASE nEventCode == K_LEFT .and. aCurrentBox[BOXLEVEL] > 1
        //-- left or right key while in a level 2 or greater box, causes
        //-- and exit back to the parent box
        EXIT

     CASE nEventCode == K_RIGHT .and. lInTopBar
        nCurrentOption := iif(nCurrentOption==nNumberofPrompts,;
                          1,nCurrentOption+1)
        while !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
            nCurrentOption := iif(nCurrentOption==nNumberofPrompts,;
                              1,nCurrentOption+1)
        end
        TOP_BAR_POSITION( nCurrentOption,aMenu)

     CASE nEventCode == K_RIGHT .and. aCurrentBox[BOXLEVEL]==1
        //-- right key, and box level 1, must exit this proc so that
        //-- previous instance of the proc can reset the top bar
        //-- and move to it
        TOP_BAR_POSITION( iif(TOP_BAR_POSITION(nil,aMenu)==nTopOptions,;
                1,TOP_BAR_POSITION(nil,aMenu)+1),aMenu )
        while !EVAL(aTopOptions[TOP_BAR_POSITION(nil,aMenu),PROMPTACTBLOCK])
          TOP_BAR_POSITION( iif(TOP_BAR_POSITION(nil,aMenu)==nTopOptions,;
                  1,TOP_BAR_POSITION(nil,aMenu)+1),aMenu )
        end
        lDone := .t.

     CASE nEventCode == K_RIGHT .and. aCurrentBox[BOXLEVEL] > 1
        //-- left or right key while in a level 2 or greater box, causes
        //-- and exit back to the parent box
        EXIT

     CASE (nEventCode == K_ESC .or. nEventCode == EVENTMOUSER ).and. ;
          aCurrentBox[BOXLEVEL]==0
        //-- escape (or right mouse) while in top bar causes a
        //-- menu exit
        lDone := .t.

     CASE (nEventCode == K_ESC .or. nEventCode == EVENTMOUSER ).and. ;
          aCurrentBox[BOXLEVEL]==1
        //-- escape (or right mouse) while in 1st level box causes
        //-- the menu dropping flag to be set to false, and an
        //-- exit from this level
        aMenu[MENUDROPPED] := .f.
        lDone := .t.

     CASE (nEventCode == K_ESC .or. nEventCode == EVENTMOUSER ).and. ;
          aCurrentBox[BOXLEVEL]>1
        //-- escape (or right mouse) while in > 1st level box causes
        //-- exit from this level
        lDone := .t.

     CASE nEventCode == K_UP .and. aCurrentBox[BOXLEVEL] > 0 .AND. lAnyActive
        nCurrentOption := iif(nCurrentOption==1,;
                               nNumberofPrompts,nCurrentOption-1)
        //-- then check the active blocks to find the first matching,
        //-- moving in reverse
        while !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
           nCurrentOption := iif(nCurrentOption==1,;
                                nNumberofPrompts,nCurrentOption-1)
        end

     CASE nEventCode == K_DOWN .and. aCurrentBox[BOXLEVEL] > 0 .and. lAnyActive
        nCurrentOption := iif(nCurrentOption==nNumberofPrompts,1,nCurrentOption+1)
        //-- then check the active blocks to find the first matching
        //-- moving forward
        while !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
          nCurrentOption := iif(nCurrentOption==nNumberofPrompts,;
                                1,nCurrentOption+1)
        end

     CASE nEventCode == K_ENTER .and. aCurrentBox[BOXLEVEL]==0 .and. ;
              aCurrentPrompts[nCurrentOption,PROMPTTYPE]==TYPEACTION
        //-- enter key or mouse click on top option if it is a
        //-- action type
        lActionReq := .t.

     CASE nEventCode == K_ENTER .and. aCurrentBox[BOXLEVEL]==0 .and. ;
          !aMenu[MENUDROPPED]
        //-- enter key or mouse click on top option if it is a
        //-- dropdown type
        aMenu[MENUDROPPED] := .t.

     CASE nEventCode == K_ENTER .and. aCurrentBox[BOXLEVEL]>0
        lActionReq := .t.

     CASE aCurrentBox[BOXLEVEL] > 0 .and. ;
           (nNewBoxPosit := AT(cEventCode,aCurrentBox[BOXFIRST]))>0
        //-- a check of the key pressed against the current box
        //-- first letters gets a match
        if nCurrentOption==nNewBoxPosit
          //-- if current option, its an action request
          lActionReq := .t.
        else
          //-- otherwise, if it is active, go there
          IF EVAL(aCurrentPrompts[nNewBoxPosit,PROMPTACTBLOCK])
             nCurrentOption := nNewBoxPosit
             if lImmediate
               keyboard chr(K_ENTER)
             endif
          ENDIF
        endif

     CASE (nNewTopPosit := AT(cEventCode,cTopLtrs)  ) > 0
        //-- a check of the key pressed against the top bar
        //-- first letters gets a match, and we are in either
        //-- the top bar or the primary dropdown level
         if nNewTopPosit==TOP_BAR_POSITION(nil,aMenu)
           //-- current position, menu not dropped, cause it to drop
           if !aMenu[MENUDROPPED]
             aMenu[MENUDROPPED] := .t.
           endif
           if aCurrentBox[BOXLEVEL]==0 .and. ;
                    aCurrentPrompts[nCurrentOption,PROMPTTYPE]==TYPEACTION
              lActionReq := .t.
           endif
         elseif EVAL(aTopOptions[nNewTopPosit,PROMPTACTBLOCK])
           //-- different position, change to it
           TOP_BAR_POSITION(nNewTopPosit,aMenu)
           //-- if we are in the 1st level of dropdown, exit
           //-- back to menu bar level to change positions
           if aCurrentBox[BOXLEVEL]>0
             *lDone := .t.
             aMenu[MENUNEWTOP]:= .T.
           endif
           if aTopOptions[nNewTopPosit,PROMPTTYPE]==TYPEACTION
              if lImmediate
                KEYBOARD chr(K_ENTER)
              endif
           endif
         endif

     CASE (nEventCode == K_ESC .or. nEventCode == EVENTMOUSER ) .and. ;
           aCurrentBox[BOXLEVEL]>1
        //-- esc or right mouse when in > level 1 box, just exit back
        //-- to parent box
        lDone := .t.

     CASE (nKeyHotPress := ;
         ASCAN(aMenu[MENUKEYHOTS],{|e|nEventCode==e[KEYHOTVALUE]}) ) > 0
          //-- programmer supplied hotkey, evaluate it

          hide_menu(aMenu)
          SETCURSOR(nCursor)
          eval(aMenu[MENUKEYHOTS,nKeyHotPress,KEYHOTBLOCK])
          SETCURSOR(0)
          bungeeshow()

          //-- refresh the current box
          MREFBOX(aCurrentBox)

          //-- check for active option
          if !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
             nCurrentOption  := ASCAN(aCurrentPrompts,;
                    {|a|EVAL(a[PROMPTACTBLOCK])})
             if nCurrentOption==0
               //-- if everything is now inactive, we have to leave
               lDone := .t.
             endif
          endif

     CASE  setkey(nEventCode) # nil

          hide_menu(aMenu)
          SETCURSOR(nCursor)
          EVAL( setkey(nEventCode), ;
                "BUNGEE", 0, aCurrentPrompts[nCurrentOption,PROMPTTEXT] )
          SETCURSOR(0)
          bungeeshow()

          //-- refresh the current box
          MREFBOX(aCurrentBox)

          //-- check for active option
          if !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
             nCurrentOption  := ASCAN(aCurrentPrompts,;
                    {|a|EVAL(a[PROMPTACTBLOCK])})
             if nCurrentOption==0
               //-- if everything is now inactive, we have to leave
               lDone := .t.
             endif
          endif
     ENDCASE

     //-- now check for an action request
     if lActionReq

        DO CASE
        CASE aCurrentPrompts[nCurrentOption,PROMPTTYPE]==TYPEACTION .and. ;
              VALTYPE(aCurrentPrompts[nCurrentOption,PROMPTEXECBLOCK])=="B"

              hide_menu(aMenu)
              SETCURSOR(nCursor)
              EVAL(aCurrentPrompts[nCurrentOption,PROMPTEXECBLOCK])
              dispbegin()
              SETCURSOR(0)
              bungeeshow()

               //-- refresh the current box
               MREFBOX(aCurrentBox)

               //-- check for active option
               if !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
                  nCurrentOption  := ASCAN(aCurrentPrompts,;
                         {|a|EVAL(a[PROMPTACTBLOCK])})
                  if nCurrentOption==0
                    //-- if everything is now inactive, we have to leave
                    lDone := .t.
                  endif
               endif

              PAINTMENUBOX(aMenu[MENUBAR])
              EVAL(aTopMenuBar[BOXPROMPTS,aMenu[MENUCURRTOP],PROMPTDISPBLOCK],.t.,.t.)
              dispend()

        CASE aCurrentPrompts[nCurrentOption,PROMPTTYPE]==TYPEACTION
             MSG("Programmer has provided nothing to EXECUTE")

        CASE aCurrentPrompts[nCurrentOption,PROMPTTYPE]==TYPEDROPDOWN .and. ;
            !empty(aCurrentPrompts[nCurrentOption,PROMPTDROPBOX]) .and. ;
            ASCAN(aCurrentPrompts[nCurrentOption,PROMPTDROPBOX,BOXPROMPTS],;
                        {|a|EVAL(a[PROMPTACTBLOCK])}) > 0
             lDroptoNextLeve := .t.

        CASE aCurrentPrompts[nCurrentOption,PROMPTTYPE]==TYPEDROPDOWN
             MSG("Submenu currently inactive")
        ENDCASE


        DISPBEGIN()
        MREFBOX(aCurrentBox)
        if !EVAL(aCurrentPrompts[nCurrentOption,PROMPTACTBLOCK])
           nCurrentOption  := ASCAN(aCurrentPrompts,{|a|EVAL(a[PROMPTACTBLOCK])})
           if nCurrentOption==0
             //-- if everything is now inactive, we have to leave
             lDone := .t.
           endif
        endif
        DISPEND()

     endif
     if (lDone .or. aMenu[MENUEXITREQ]) .and. lInTopBar .and. ;
        aMenu[MENUCHECKEXIT]#nil
       if !eval(aMenu[MENUCHECKEXIT])
         aMenu[MENUEXITREQ] := .f.
         lDone := .f.
       endif
     endif
  End

  REMOVEBOX(aCurrentBox)

  ASIZE(aMenu[MENUHIDEPATH],len(aMenu[MENUHIDEPATH])-1)
  SETCURSOR(nCursor)

return 0

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   Log, unlog, return current menu
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function logmenu(aNew)
static aThisMenu := {}
if aNew#nil
 if valtype(aNew)=="A"
   aadd(aThisMenu,aNew)
 else
   aSize(aThisMenu,max(0,len(aThisMenu)-1) )
 endif
endif
return ATAIL(aThisMenu)


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   Draw current box
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function PAINTMENUBOX(aBox)
  local aPrompts := aBox[BOXPROMPTS]
  local aPrompt
  local nCount
  //-- draw the box/bar
  DISPBEGIN()
  EVAL(aBox[BOXDRAWBLOCK])
  for nCount = 1 to len(aPrompts )
    aPrompt := aPrompts[nCount]
    EVAL(aPrompt[PROMPTDISPBLOCK],.f.,EVAL(aPrompt[PROMPTACTBLOCK]) )
  next
  DISPEND()
RETURN nil

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   Refresh current box
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function MREFBOX(aBox)
  local aPrompts := aBox[BOXPROMPTS]
  local aPrompt
  local nCount
  local aSaved := aBox[BOXUNDER]
  dispbegin()
  //-- draw the box/bar
  EVAL(aBox[BOXDRAWBLOCK])
  aBox[BOXUNDER] := aSaved
  for nCount = 1 to len(aPrompts )
    aPrompt := aPrompts[nCount]
    EVAL(aPrompt[PROMPTDISPBLOCK],.f.,EVAL(aPrompt[PROMPTACTBLOCK]) )
  next
  dispend()
RETURN nil




/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   MENU DEFINE
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
FUNCTION MENUDEF(nTop,nLeft,nRight,aInPrompts,aColumns,;
                 aColors,aMouseHots, aKeyHots,bCheckExit, lImmediate,;
                 lDropped,nHideLevel,nShadowPos,nShadowAtt,lHandleAlt)
  local nCount, cPrompt, cTrigger, nAtTrigger
  local aBar        := ARRAY(BOXSIZE)
  local aMenu       := ARRAY(MENUSIZE)
  local aThisPrompt, nColumn, lCross, aWork
  local i, nBarSpace
  local nDown, nOver

  nShadowPos := iif(nShadowPos==nil,SLS_SHADPOS(),nShadowPos)
  nShadowPos := iif(ispart(nShadowPos,1,3,0),nShadowPos,0)
  nShadowAtt := iif(nShadowAtt#nil,nShadowAtt,SLS_SHADATT())
  nBarSpace  := 2
  aColors    := iif(aColors#nil,aColors,array(7))
  ASIZE(aColors,7)
  lHandleAlt := iif(lHandleAlt==nil,.f.,lHandleAlt)

  aColumns    := iif(aColumns#nil,aColumns,ARRAY(LEN(aInPrompts) ) )
  ASIZE(aColumns,len(aInPrompts) )

  if nTop==nil.or.nLeft==nil.or.nRight==nil
   nTop:=0 ; nLeft :=0 ; nRight := MAXCOL()
  endif

  aMenu[MENUCURRTOP]   := 1
  aMenu[MENUHIDDEN]    := .F.
  aMenu[MENUHIDELEVEL]   := iif(nHideLevel#nil, nHideLevel, 1)
  aMenu[MENUDROPPED]   := iif(lDropped#nil, lDropped, .t.)
  aMenu[MENUIMMEDIATE]   := iif(lImmediate#nil, lImmediate, .t.)
  aMenu[MENUFIRSTLTR]  := ""
  aMenu[MENUMOUSEHOTS] := iif(aMouseHots#nil,aMouseHots,{})
  aMenu[MENUKEYHOTS]   := iif(aKeyHots#nil,aKeyHots,{})
  aMenu[MENUNEWTOP]     := .f.
  aMenu[MENUHIDEPATH]  := {}
  aMenu[MENUEXITREQ ]  := .f.
  aMenu[MENUTOP]       := nTop
  aMenu[MENULEFT]      := nLeft
  aMenu[MENURIGHT]     := nRight
  aMenu[MENUSHADOWPOS]     := nShadowPos
  aMenu[MENUSHADOWATT]     := nShadowAtt
  aMenu[MENUHANDLEALT]     := lHandleAlt

  MCOLORSET(aColors,aMenu)

  aMenu[MENUCROSS]     := figurecross(aMenu[MC_FRAMES])
  aMenu[MENUCHECKEXIT] := bCheckExit

  aBar[BOXLEVEL     ] := 0
  aBar[BOXTOP       ] := nTop
  aBar[BOXLEFT      ] := nLeft
  aBar[BOXBOTTOM    ] := nTop
  aBar[BOXRIGHT     ] := nRight
  aBar[BOXPROMPTS   ] := {}
  aBar[BOXFIRST     ] := ""

  nColumn := nLeft

  // determine the top level bar prompts
  for nCount := 1 to len(aInPrompts)
      aWork        := aInPrompts[nCount]
      ASIZE(aWork,5)

      nDown        := iif(aWork[4]#nil,awork[4],1)
      nOver        := iif(aWork[5]#nil,awork[4],0)

      cPrompt      := alltrim(STRTRAN(aWork[1],"~"))
      nAtTrigger   := at("~",aWork[1])
      nAtTrigger   := MAX(1,nAtTrigger)
      cTrigger     := subst(cPrompt,nAtTrigger,1)
      aMenu[MENUFIRSTLTR] += upper(cTrigger)
      aBar[BOXFIRST]      += upper(cTrigger)
      nAtTrigger--
      if aColumns[nCount]#nil
         nColumn := aColumns[nCount]
      elseif nCount > 1
         nColumn := nColumn+nBarSpace+1
      endif
      aThisPrompt                   := ARRAY(PROMPTSIZE)
      aThisPrompt[PROMPTLEVEL]      := 0
      aThisPrompt[PROMPTTOP]        := nTop
      aThisPrompt[PROMPTLEFT]       := nColumn
      aThisPrompt[PROMPTBOTTOM]     := nTop
      aThisPrompt[PROMPTRIGHT]      := nColumn+len(cPrompt)-1
      aThisPrompt[PROMPTTYPE]       := figuretype(aWork)
      aThisPrompt[PROMPTTEXT]       := cPrompt
      aThisPrompt[PROMPTTRIGGER]    := cTrigger
      aThisPrompt[PROMPTTRIGPOS]    := nAtTrigger
      aThisPrompt[PROMPTDISPBLOCK]  := MAKEDB(aThisPrompt,aMenu)

      aThisPrompt[PROMPTACTBLOCK]   := iif(aWork[3]==nil,{||.t.},aWork[3])

      aThisPrompt[PROMPTEXECBLOCK]  := iif(aThisPrompt[PROMPTTYPE]==TYPEACTION,;
                                           aWork[2],nil)


      IF aThisPrompt[PROMPTTYPE]==TYPEDROPDOWN
          aThisPrompt[PROMPTDROPBOX]  := ;
                figurebox(aMenu,aThisPrompt,aWork[2],nDown,nOver)

          aThisPrompt[PROMPTACTBLOCK] := aBlockP(aThisPrompt)
      ENDIF

      AADD(aBar[BOXPROMPTS],aThisPrompt)

      nColumn := nColumn+len(cPrompt)-1
  next

  aBar[BOXDRAWBLOCK ] := {||DRAWBOX(aBar,space(9),aMenu)}
  aBar[BOXRESTBLOCK ] := {|c|REMOVEBOX(aBar)}
  aBar[BOXUNDER     ] := nil

  aMenu[MENUBAR     ] := aBar

return aMenu

static function ablockp(ap)
return {||(ASCAN(ap[PROMPTDROPBOX,BOXPROMPTS],;
 {|a|EVAL(a[PROMPTACTBLOCK])}) > 0 )}


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   DROPDOWN BOX DEFINE
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/

STATIC FUNCTION figurebox(aMenu,aParentPrompt,aBoxPrompts,nDown,nOver)
  local nCount, aBox, lCross, nRows, nCols, aThisPrompt, nColumn
  local aWork,nAtTrigger, cTrigger, cPrompt, nWidth
  local nDownSub, nOverSub

  nDown:= iif(nDown#nil,nDown,1)
  nOver:= iif(nOver#nil,nOver,iif(aParentPrompt[PROMPTLEVEL]==0,0,1))
  nRows:= len(aBoxPrompts)
  nCols:= 1

  for nCount = 1 to len(aBoxPrompts)
    aBoxPrompts[nCount,1] := alltrim(aBoxPrompts[nCount,1])
    IF LEN(aBoxPrompts[nCount,1])+2 > nCols .and. ;
       upper(aBoxPrompts[nCount,1])#"CROSSBAR"
       nCols := LEN(STRTRAN(aBoxPrompts[nCount,1],"~"))+2
    endif
  next

  aBox                   := ARRAY(BOXSIZE)
  aBox[BOXLEVEL     ] := aParentPrompt[PROMPTLEVEL]+1
  aBox[BOXTOP       ] := aParentPrompt[PROMPTTOP]+nDown
  aBox[BOXLEFT      ] := aParentPrompt[PROMPTLEFT]+nOver
  aBox[BOXBOTTOM    ] := aBox[BOXTOP]+nRows+1
  aBox[BOXRIGHT     ] := aBox[BOXLEFT]+nCols+1
  aBox[BOXPROMPTS   ] := {}
  aBox[BOXFIRST     ] := ""

  while aBox[BOXBOTTOM] > MAXROW()
    aBox[BOXBOTTOM]--
    aBox[BOXTOP]--
  end

  while aBox[BOXRIGHT] > MAXCOL()
    aBox[BOXRIGHT]--
    aBox[BOXLEFT]--
  end
  nWidth := aBox[BOXRIGHT]-aBox[BOXLEFT]-3

  nColumn := aBox[BOXLEFT]+2
  for nCount := 1 to len(aBoxPrompts)
      aWork        := aBoxPrompts[nCount]
      aSize(aWork,5)

      nDownSub     := iif(aWork[4]#nil,awork[4],1)
      nOverSub     := iif(aWork[5]#nil,awork[5],1)
      lCross       := upper(aWork[1])=="CROSSBAR"
      if !lCross
         cPrompt      := STRTRAN(aWork[1],"~")
         nAtTrigger   := at("~",aWork[1])
         nAtTrigger   := MAX(1,nAtTrigger)
         cTrigger     := subst(cPrompt,nAtTrigger,1)
         aBox[BOXFIRST]      += upper(cTrigger)
         nAtTrigger--
      else
         cPrompt        := aWork[1]
         nAtTrigger     := 0
         cTrigger            := chr(254)
         aBox[BOXFIRST]      += upper(cTrigger)
      endif

      aThisPrompt                   := ARRAY(PROMPTSIZE)
      aThisPrompt[PROMPTLEVEL]      := aBox[BOXLEVEL]
      aThisPrompt[PROMPTTOP]        := aBox[BOXTOP]+nCount
      aThisPrompt[PROMPTLEFT]       := iif(lCross,aBox[BOXLEFT],nColumn)
      aThisPrompt[PROMPTBOTTOM]     := aThisPrompt[PROMPTTOP]
      aThisPrompt[PROMPTRIGHT]      := iif(lCross,aBox[BOXRIGHT],;
                                       nColumn+len(cPRompt)-1)
      aThisPrompt[PROMPTTYPE]       := figuretype( aWork )
      aThisPrompt[PROMPTTEXT]       := cPrompt
      aThisPrompt[PROMPTTRIGGER]    := cTrigger
      aThisPrompt[PROMPTTRIGPOS]    := nAtTrigger
      if lCross
        aThisPrompt[PROMPTDISPBLOCK]  := MAKECROSS(aThisPrompt[PROMPTTOP],;
                      aThisPrompt[PROMPTLEFT],;
                      aThisPrompt[PROMPTRIGHT],aMenu[MENUCROSS],aMenu)
      else
        aThisPrompt[PROMPTDISPBLOCK]  := MAKEDB(aThisPrompt,aMenu,nWidth)
      endif

      aThisPrompt[PROMPTACTBLOCK]   := iif(aWork[3]==nil,;
                iif(lCross,{||.f.},{||.t.}),aWork[3])

      aThisPrompt[PROMPTEXECBLOCK]  := iif(aThisPrompt[PROMPTTYPE]==TYPEACTION,;
                                           aWork[2],nil)


      IF aThisPrompt[PROMPTTYPE]==TYPEDROPDOWN
          aThisPrompt[PROMPTDROPBOX]  := ;
                figurebox(aMenu,aThisPrompt,aWork[2],nDownSub,nOverSub)
          aThisPrompt[PROMPTACTBLOCK] := aBlockP(aThisPrompt)
      ENDIF

      AADD(aBox[BOXPROMPTS],aThisPrompt)

  next

  aBox[BOXDRAWBLOCK ] := {||DRAWBOX(aBox,aMenu[MC_FRAMES],aMenu)}
  aBox[BOXRESTBLOCK ] := {|c|REMOVEBOX(aBox)}
  aBox[BOXUNDER     ] := nil

  *aParentPrompt[PROMPTDROPBOX] := aBox
return aBox



/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³   DETERMINE PROMPT TYPE
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function figuretype(aPassed)
local nType
if valtype(aPassed[2])=="B"
  nType := TYPEACTION
elseif valtype(aPassed[2])=="A"
  nType := TYPEDROPDOWN
else
  nType := TYPECROSSBAR
endif
return nType



/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³ Save/display box
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/

STATIC FUNCTION DRAWBOX(aBox,cFrame,aMenu)
local lIsBar := (aBox==aMenu[MENUBAR])
cFrame := iif(cFrame#nil,cFrame,aMenu[MC_FRAMES])
dispbegin()
if aBox[BOXUNDER]#nil
 REMOVEBOX(aBox)
endif
if lIsBar
        aBox[BOXUNDER] := SAVESCREEN(aBox[BOXTOP],aBox[BOXLEFT],;
                   aBox[BOXBOTTOM],aBox[BOXRIGHT]+1 )
else
        aBox[BOXUNDER] := SAVESCREEN(aBox[BOXTOP],MAX(aBox[BOXLEFT]-1,0),;
                  MIN(aBox[BOXBOTTOM]+1,MAXROW()),MIN(aBox[BOXRIGHT]+1,MAXCOL()) )
endif
Dispbox(aBox[BOXTOP],aBox[BOXLEFT],;
        aBox[BOXBOTTOM],aBox[BOXRIGHT],cFrame,;
        aMenu[MC_MBOX])
if !lIsbar
   if aMenu[MENUSHADOWPOS] > 0
        SBSHADOW(aBox[BOXTOP],aBox[BOXLEFT],;
                  aBox[BOXBOTTOM],aBox[BOXRIGHT],aMenu[MENUSHADOWPOS],;
                  aMenu[MENUSHADOWATT])
   endif
endif
dispend()
return aBox[BOXUNDER]

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³ Remove Box
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
STATIC FUNCTION REMOVEBOX(aBox)
local lIsBar := (aBox==logmenu()[MENUBAR])
if !EMPTY( aBox[BOXUNDER] )
  dispbegin()
      if lIsBar
        RESTSCREEN(aBox[BOXTOP],aBox[BOXLEFT],;
                   aBox[BOXBOTTOM],aBox[BOXRIGHT],;
                 aBox[BOXUNDER] )
      else
        RESTSCREEN(aBox[BOXTOP],MAX(aBox[BOXLEFT]-1,0),;
                   MIN(aBox[BOXBOTTOM]+1,MAXROW()),MIN(aBox[BOXRIGHT]+1,MAXCOL()),;
                 aBox[BOXUNDER] )
      endif
      aBox[BOXUNDER] := nil
  dispend()
endif
return nil


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Get a color setting
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function RTVCOLOR(aMenu,nPosition)
return aMenu[nPosition]

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Return a prompt display block
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/

STATIC FUNCTION MAKEDB(aPrompt,aMenu,nWidth)
if nWidth==nil
RETURN     {|lSel,lActi|DISPBEGIN(),;
                 DEVPOS(aPRompt[PROMPTTOP],aPrompt[PROMPTLEFT]),;
                 DEVOUT(aPrompt[PROMPTTEXT],;
                    aMenu[iif(lSel,iif(lActi,MC_MSEL,MC_MINA),iif(lActi,MC_MUNS,MC_MINA))]),;
                 DEVPOS(aPrompt[PROMPTTOP],;
                        aPrompt[PROMPTLEFT]+aPRompt[PROMPTTRIGPOS]),;
                 DEVOUT(aPrompt[PROMPTTRIGGER],;
                      aMenu[iif(lSel,iif(lActi,MC_MSELTRIG,MC_MINA),iif(lActi,MC_MUNSTRIG,MC_MINA))]),;
                      DISPEND()  }
else
RETURN     {|lSel,lActi|DISPBEGIN(),;
                 DEVPOS(aPRompt[PROMPTTOP],aPrompt[PROMPTLEFT]),;
                 DEVOUT(PADR(aPrompt[PROMPTTEXT],nWidth),;
                    aMenu[iif(lSel,iif(lActi,MC_MSEL,MC_MINA),iif(lActi,MC_MUNS,MC_MINA))]),;
                 DEVPOS(aPrompt[PROMPTTOP],;
                        aPrompt[PROMPTLEFT]+aPRompt[PROMPTTRIGPOS]),;
                 DEVOUT(aPrompt[PROMPTTRIGGER],;
                      aMenu[iif(lSel,iif(lActi,MC_MSELTRIG,MC_MINA),iif(lActi,MC_MUNSTRIG,MC_MINA))]),;
                      DISPEND()  }
endif
return nil


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Return a CROSSBAR display block
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/

STATIC FUNCTION MAKECROSS(nTop,nLeft,nRight,aCross,aMenu)
memvar _1
RETURN    {||_1:=aMenu[MC_MBOX],;
                DEVPOS(nTop,nLeft),;
                DEVOUT(aCross[1],_1),;
                DEVPOS(nTop,nLeft+1),;
                DEVOUT(REPL(aCross[2],nRight-nLeft-1),_1),;
                DEVPOS(nTop,nRight),;
                DEVOUT(aCross[3],_1 ) }


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  Return current top bar position
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
STATIC FUNCTION TOP_BAR_POSITION(nCurrent,aMenu)
RETURN (  aMenu[MENUCURRTOP]:= IIF(nCurrent#nil,;
          nCurrent,aMenu[MENUCURRTOP])   )


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function MOUSEINBOX(aBox,aPrompts,nMouseR,nMouseC,lTop)
  local nCount

  DO CASE
  CASE lTop
    if nMouseR==aBox[BOXTOP]
        FOR nCount = 1 TO LEN(aPrompts)
           if nMouseC >=(aPrompts[nCount,PROMPTLEFT]).and. ;
              nMouseC <=(aPrompts[nCount,PROMPTRIGHT])
              return nCount
           endif
        NEXT
    endif
  CASE nMouseR>aBox[BOXTOP] .and. nMouseR<aBox[BOXBOTTOM] .and.;
         nMouseC>aBox[BOXLEFT] .and. nMouseC<aBox[BOXRIGHT]
    FOR nCount = 1 TO LEN(aPrompts)
       if (aPrompts[nCount,PROMPTTOP])==nMouseR
            if EVAL(aPrompts[nCount,PROMPTACTBLOCK] )
               return nCount
            endif
       endif
    NEXT
  ENDCASE
RETURN 0



/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³ Create crossbar, given frame characteristics
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
static function figurecross(cFrame)
local aCross := array(3)
aCross[2] := "Ä"
do case
case subst(cFrame,8,1)=="³"
  aCross[1] := "Ã"
case subst(cFrame,8,1)=="º"
  aCross[1] := "Ç"
otherwise
  aCross[1] := ""
endcase
do case
case subst(cFrame,4,1)=="³"
  aCross[3] := "´"
case subst(cFrame,4,1)=="º"
  aCross[3] := "¶"
otherwise
  aCross[3] := ""
endcase
return aCross


static function hide_menu(aMenu)
do case
case aMenu[MENUHIDELEVEL]   ==1
  bungeehide(.f.)
case aMenu[MENUHIDELEVEL]   ==2
  bungeehide(.t.)
endcase
return nil


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³  HIDE MENU
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
FUNCTION BUNGEEHIDE(lHideBar)
  local aScreens := {}
  local nCount, nHideTo
  local aHidden, aMenu
  lHideBar := iif(lHideBar#nil,lHideBar,.t.)
  nHideTo  := iif(lHideBar,1,2)
  aMenu    := LOGMENU()
  IF !aMenu[MENUHIDDEN]
    aHidden := aMenu[MENUHIDEPATH]
    if aMenu#nil
      dispbegin()
      for nCount = LEN(aHidden) to nHideTo step -1
         REMOVEBOX(aHidden[nCount,1])
      next
      dispend()
    endif
  ENDIF
  aMenu[MENUHIDDEN]    := .T.
return nil

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³ Unhide current menu
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
FUNCTION BUNGEESHOW()
  local nCount,  aPrompt
  local aHidden, aMenu
  aMenu   := LOGMENU()
  aHidden := aMenu[MENUHIDEPATH]
  if aMenu#nil
    dispbegin()
    for nCount = 1 to LEN(aHidden)
        aPrompt := aHidden[nCount,1,BOXPROMPTS,aHidden[nCount,2]]
        if aHidden[nCount,1,BOXUNDER]==nil
          PAINTMENUBOX(aHidden[nCount,1])
          EVAL(aPrompt[PROMPTDISPBLOCK],.t.,.t.)
        endif
    next
    dispend()
  endif
  aMenu[MENUHIDDEN]    := .F.
return nil

/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION BUNGEEQUIT()                             *new*
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³
³  Short:
³  ------
³  BUNGEEQUIT( ) is how a Bungee menu is terminated. You would normally
³  call it from one of the menu option codeblocks.
³
³  Returns:
³  --------
³  NIL
³
³  Syntax:
³  -------
³
³  BUNGEEQUIT()
³
³  Description:
³  ------------
³  BUNGEEQUIT( ) is how a Bungee menu is terminated. You would normally
³  call it from one of the menu option codeblocks.
³
³  Examples:
³  ---------
³  bungstart()
³  bungoption("Files")
³  bungdrop()
³          bungoption("Open" ,{} ,{||!lFileIsOpen} )
³          bungoption("Close",{||nil},{||lFileIsOpen } )
³  bungundrop()
³  bungoption("Edit")
³  bungdrop()
³          bungoption("DBF"  ,{||nil},nil )
³          bungoption("Ascii",{||nil},nil )
³  bungundrop()
³  bungoption("Quit",{||bungeequit()},nil)
³
³  aMenu := bungend()
³
³  @24,0 say "ALT-X=exit"   // set up Alt-X as a hotkey exit also
³  aHotKeys := { {K_ALT_X,{||bungeequit()}}  }
³
³  bungee(0,0,79,aMenu,nil,nil,nil,aHotKeys)
³
³
³  Source:
³  -------
³  S_BUNGEE.PRG
³
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
*/
FUNCTION BUNGEEQUIT()
local aMenu := logmenu()
if aMenu#nil
    aMenu[MENUEXITREQ] := .t.
endif
return nil


/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION BUNGEETOP()                             *new*
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³
³  Short:
³  ------
³  Sends the current menu back to the top level box (not all
³  the way to the top bar, but to the bar plus the current box)
³
³
³  Returns:
³  --------
³  NIL
³
³  Syntax:
³  -------
³
³  BUNGEETOP()
³
³  Description:
³  ------------
³  Sends the current menu back to the top level box (not all
³  the way to the top bar, but to the bar plus the current box)
³
³  Examples:
³  ---------
³  bungstart()
³  bungoption("Files")
³  bungdrop()
³     bungoption("Open" ,{} ,{||!lFileIsOpen} )
³     bungdrop()
³       bungoption("DBF" ,{||opendbf(),bungeetop()},nil )  // go back to top
³       bungoption("Ascii",{||opendbf(),bungeetop()},nil )  // after these two
³     bungundrop()
³     bungoption("Close",{||nil},{||lFileIsOpen } )
³  bungundrop()
³  bungoption("Edit")
³          bungoption("Quit",{||bungeequit()},nil)
³  aMenu := bungend()
³
³  bungee(0,0,79,aMenu)
³
³
³  Source:
³  -------
³  S_BUNGEE.PRG
³
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
*/

FUNCTION BUNGEETOP()
local aMenu := logmenu()
if aMenu#nil
    aMenu[MENUNEWTOP] := .t.
endif
return nil


STATIC FUNCTION MCOLORSET(aColors,aMenu)
local c    := setcolor()
local cStd := takeout(c,",",1)
local cUns := takeout(c,",",5)
local cEnh := takeout(c,",",2)
local cWork, cFg, cBg
aMenu[MC_MBOX    ]  := IIF(aColors[1] #nil,aColors[1],cStd)
aMenu[MC_MSEL    ]  := IIF(aColors[2] #nil,aColors[2],cEnh)
aMenu[MC_MUNS    ]  := IIF(aColors[3] #nil,aColors[3],cStd)
aMenu[MC_MINA    ]  := IIF(aColors[4] #nil,aColors[4],"+N/"+takeout(cStd,"/",2) )
aMenu[MC_MSELTRIG]  := IIF(aColors[5] #nil,aColors[5],nil)
if aMenu[MC_MSELTRIG]==nil
   cBg  := takeout(cEnh,"/",2)
   if left(cEnh,2)<>"W+" .and. cBg<>"W*"
     cFg  := "W+"
   else
     if cBg$"N~B~"
         cFg := "GR+"
     else
         cFg := "N"
     endif
   endif
   aMenu[MC_MSELTRIG] := cFg+"/"+cBg
endif
aMenu[MC_MUNSTRIG]  := IIF(aColors[6] #nil,aColors[6],nil)
if aMenu[MC_MUNSTRIG]==nil
   cBg  := takeout(cStd,"/",2)
   if left(cStd,2)<>"W+" .and. !cBg=="W*"
     cFg  := "W+"
   else
     if cBg$"N~B~"
         cFg := "W"
     else
         cFg := "N"
     endif
   endif
   aMenu[MC_MUNSTRIG] := cFg+"/"+cBg
endif
aMenu[MC_FRAMES  ]  := IIF(aColors[7] #nil,aColors[7], B_SINGLE+" ")
RETURN NIL

/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION BUNGREDRAW()                             *new*
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³
³  Short:
³  ------
³  Redraws the current menu, with optional change of colors
³
³  Returns:
³  --------
³  NIL
³
³  Syntax:
³  -------
³  BUNGEETOP([aColors],[nShadowPos,[nShadowAtt])
³
³  Description:
³  ------------
³  Redraws the current menu, with optional change of colors and shadows.
³  The only time you would use this is to change colors and redraw the
³  entire menu. [aColors] is the same as the parameter for BUNGEE() of
³  the same name. You can also just use SETCOLOR() to change colors, and
³  BUNGREDRAW() will parse out the colors it  needs for the menu. What this
³  function does, is 1. Hide the menu 2. Reset the colors  3. Show the menu.
³
³  [nShadowPos]    Optional shadow position for menu dropdown boxes.
³                  Valid options are:
³                       1. Lower left
³                       3. Lower right
³                       0. None
³                  Upper left and upper right shadow positions are not
³                  allowed. (they can overwrite parts of the menu bar)
³                  Default is SLS_SHADPOS(), unless SLS_SHADPOS() is
³                  upper left or upper right (7,9), in which case it
³                  is set to 0 (none).
³
³                  To force no shadows for the menu, pass 0.
³
³                  Boxes may not always have shadows, if the shadow would
³                  be drawn offscreen.
³
³  [nShadowAtt]   Numeric shadow attribute. Default is SLS_SHADATT(), whose
³                 default is 8. (grey on black)
³
³  Examples:
³  ---------
³  bungstart()
³          bungoption("Files")
³          [etc...]
³          bungoption("Colors",{||setcolors(),bungredraw()}  )
³          [etc...]
³    aMenu := bungend()
³
³    bungee(0,0,79,aMenu)
³
³  Source:
³  -------
³  S_BUNGEE.PRG
³
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
*/

function bungredraw(aColors,nShadowPos,nShadowAtt)
local aMenu := logmenu()
aColors    := iif(aColors#nil,aColors,array(7))
if aMenu#nil
    BUNGEEHIDE(.T.)
    MCOLORSET(aColors,aMenu)
    nShadowPos := iif(nShadowPos==nil,SLS_SHADPOS(),nShadowPos)
    nShadowPos := iif(ispart(nShadowPos,1,3,0),nShadowPos,0)
    nShadowAtt := iif(nShadowAtt#nil,nShadowAtt,SLS_SHADATT())
    aMenu[MENUSHADOWPOS]     := nShadowPos
    aMenu[MENUSHADOWATT]     := nShadowAtt
    BUNGEESHOW()
endif
RETURN NIL




