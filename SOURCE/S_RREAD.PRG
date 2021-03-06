
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#include "Getexit.ch"

#define K_UNDO          K_CTRL_U


// static array to hold getlists
STATIC aGetSets := {}


// State variables for active READ
//
STATIC slUpdated := .F.
STATIC slKillRead
STATIC slBumpTop
STATIC slBumpBot
STATIC snLastExitState
STATIC snLastPos
STATIC soActiveGet
STATIC scReadProcName
STATIC snReadProcLine


//
// Format of array used to preserve state variables
//
#define GSV_KILLREAD       1
#define GSV_BUMPTOP        2
#define GSV_BUMPBOT        3
#define GSV_LASTEXIT       4
#define GSV_LASTPOS        5
#define GSV_ACTIVEGET      6
#define GSV_READVAR        7
#define GSV_READPROCNAME   8
#define GSV_READPROCLINE   9

#define GSV_COUNT          9



/***
*
*  ReadModal()
*
*  Standard modal READ on an array of GETs
*
*/
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION RAT_READ()                *changed*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  RAT_READ() Mouseable read
³ 
³  Returns:
³  --------
³  Nil
³
³  Syntax:
³  -------
³  RAT_READ(aGetlist,[nStart],[lWrap],[nRmKey],[bLmouse],[aLmKeys])
³ 
³  Description:
³  ------------
³  Set up your gets as normal, with @SAY...GET
³  statements.
³ 
³  The only limitation is that you cannot use a
³  user-defined READER block, as RAT_READ() installs a
³  user-defined reader block for each get.
³ 
³  After setting up your @SAY...GET statements, instead
³  of issuing a READ, issue a RAT_READ(getlist,...).
³ 
³  [nStart] is an optional starting get number, which
³  defaults to 1.
³ 
³  [lWrap] determines if going past top or bottom get
³  exits the read. Default is True. By sending false, going past top
³  will put you at bottom, and going past bottom will put you at top,
³  with only CTRL-W exiting the read.
³ 
³  [nRmKey] is an inkey value that tells RAT_READ() how
³  it should interpret a right mouse button click. Default is ESCAPE.
³
³  [bLmouse] (new in 3.5) is a codeblock that is evaluated when there
³  is a mouse click and it is not meaningful to RAT_READ().
³  It is evaluated as :  eval(bLMouse,mouserow, mousecolumn)
³
³  [aLmKeys] is an array of hot mouse coordinate sub-arrays and their
³  key equivalents. For instance, if you have the following for hot
³  keys: @24,0 say "[F10=save] [ESC=Cancel]", and you wanted these as
³  hot mouse areas, the array would be:
³        {   {24,0,24,9,K_F10},  {24,11,24,22,K_ESC}   }
³  Clicking the mouse within 24,0,24,9 would be interpreted as pressing
³  the F10 key.
³  The structure of each sub-array is {nTop,nLeft,nBottom,nRight,nKeyValue}
³
³
³
³  Examples:
³  ---------
³   v1 := space(10)
³   v2 := space(10)
³   v3 := space(10)
³   @10,10 get v1
³   @11,10 get v2
³   @12,10 get v3
³ 
³   RAT_READ(getlist,2,.T.,27)
³ 
³   // read, starting at get # 2, wrapping, and interpreting the right
³   // mouse button as chr(27) (escape).
³ 
³  Notes:
³  -------
³  This does not replace GETSYS.PRG, but rather parallels it.
³
³  The Clipper GET system, contained in GetSys.Prg and accessed via
³  READ contains several exported functions which obtain /handle
³  information about the current GET and the current READ.
³
³  In order to implement mouse-aware reads, a modification of
³  GetSys.Prg was needed. However....
³
³  I didn't want SuperLib to replace the Clipper Get system
³  willy-nilly, as that would presume that you always wanted
³  to use _only_ the SuperLib version. So I had to rename all
³  of the exported functions in the SuperLib mouseable get
³  system. The names are as follows:
³
³   Clipper Get System    SuperLib GetSystem
³   ------------------    ------------------
³   ReadModal()           Rat_Read()
³   GetReader()           RatReader()
³   GetApplyKey()         RatApplyKey()
³   GetDoSetKey()         RatDoSetKey()
³   GetPostValidate()     RatPostValidate()
³   GetPreValidate()      RatPreValidate()
³   GetActive()           RatActive() ---or--- GetActive()
³   ReadKill()            RatKill()
³   ReadUpdated()         RatSetUpdated()
³   Updated()             RatUpdated()
³
³  So you can call either READ or READMODAL() which accesses the
³  Clipper Get System, or call RAT_READ(), which access the
³  SuperLib mouseable get system, and they will not tromp on
³  one another.
³
³  There still remained one problem, however. Some of the SuperLib
³  functions access the above named exported functions, such as
³  GetActive(), and of course user-defined get readers need to
³  access GetPostValidate(), GetPreValidate(), GetApplyKey() and
³  GetDoSetKey(), and possibly others.
³
³  By calling R_ISRATREAD(), you can determine if the current
³  read is a RAT_READ or not, and call the regular exported
³  read/get functions, or call their equivalent RAT* functions
³  as listed above.
³
³  An exception is GETACTIVE(), which may be called while using
³  either get system, as RAT_READ() calls GETACTIVE() to update
³  the current get, and also saves and restores the active get
³  in case there is a prior READ active.
³
³  This R_ISRATREAD() function returns TRUE/FALSE for 'is the current
³  read a RAT_READ or a READMODAL (normal) read'. Essentially it tells
³  you which GetSystem you are in.
³
³  Thus you can have both RAT_READ() mouse aware reads, and standard
³  READMODAL() Clipper reads in the same system, and tell the
³  difference between the two.
³
³  User defined readers attached to GETS passed to RAT_READ can
³  return a numeric value indicating which get to jump to.
³
³
³  Source:
³  -------
³  S_RREAD.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION Rat_read( aGetList, nPos, lWrap, nRmKey, bLMouse, aLmKeys)
   MEMVAR GETLIST
   LOCAL aGets := iif(aGetList#nil,aGetList,GETLIST)
   LOCAL oGet, nOldCursor := SETCURSOR(1)
   LOCAL aSavGetSysVars
   LOCAL nJump := 0
   LOCAL oOldActive := GETACTIVE()

   nRmKey := iif(nRmKey#nil,nRmKey,K_ESC)
   IF ( EMPTY( aGets ) )

      // S'87 compatibility
      SETPOS( MAXROW() - 1, 0 )
      RETURN (.F.)                  // NOTE

   ENDIF

   R_GETPUSH(aGets)
   RRLASTKEY(0)

   lWrap := iif(lWrap#nil,lWrap,.f.)
   // Preserve state variables
   aSavGetSysVars := ClearGetSysVars()

   // Set these for use in SET KEYs
   scReadProcName := PROCNAME( 1 )
   snReadProcLine := PROCLINE( 1 )

   // Set initial GET to be read
   IF !( VALTYPE( nPos ) == "N" .AND. nPos > 0 )
      nPos := Settle( aGets, 0 , 0, lWrap)
   ENDIF

   WHILE !( nPos == 0 )

      // Get next GET from list and post it as the active GET
      PostActiveGet( oGet := aGets[ nPos ] )
      RRJumpGet(0)

      // Read the GET
      IF ( VALTYPE( oGet:reader ) == "B" )
         nJump := EVAL( oGet:reader, oGet, nRmKey, aLmKeys, bLMouse)
      ELSE
         nJump := RatReader( oGet,nRmKey, aLmKeys, bLMouse )
      ENDIF
      if RRJumpGet()#0
        nJump := RRJumpGet()
        RRJumpGet(0)
      endif

      // Move to next GET based on exit condition
      nPos := Settle( aGets, nPos, nJump, lWrap )

   ENDDO


   // Restore state variables
   RestoreGetSysVars( aSavGetSysVars )

   // S'87 compatibility
   SETPOS( MAXROW() - 1, 0 )

   asize(aGets,0)
   R_GETPOP()
   GETACTIVE(oOldActive)
   SETCURSOR(nOldCursor)
   RRTHISGET("")

RETURN ( slUpdated )



FUNCTION RatReader( oGet,nRmKey, aLmKeys, bLMouse)
local nJump := 0
local nLastKey, nMouseR, nMouseC, nHotAt

   // Read the GET if the WHEN condition is satisfied
   IF ( RatPreValidate( oGet ) )

      // Activate the GET for reading
      oGet:setFocus()

      WHILE ( oGet:exitState == GE_NOEXIT )

         // Check for initial typeout (no editable positions)
         IF ( oGet:typeOut )
            oGet:exitState := GE_ENTER
         ENDIF

         // Apply keystrokes until exit
         WHILE ( oGet:exitState == GE_NOEXIT )
            RRTHISGET(oGet)             // set the current get where it can be reached
            nLastKey := rat_event(0,.f.)
            nMouseR := rat_eqmrow()
            nMouseC := rat_eqmcol()
            if nLastKey==K_MOUSELEFT
                if nMouseR==oGet:row .and. nMouseC>=oGet:col .and. nMouseC<= ;
                   oGet:col+len(trans(oGet:varget(),oGet:picture))-1
                   while (oGet:col-1+oGet:pos) < nMouseC .and. !oGet:typeout
                     oGet:right()
                     oGet:display()
                   end
                   while (oGet:col-1+oGet:pos) > nMouseC .and. !oGet:typeout
                     oGet:left()
                     oGet:display()
                   end
                elseif (nJump := GETJUMP2(nMouseR, nMouseC)) > 0
                   oGet:exitState := GE_ENTER
                elseif aLmKeys#nil .and. ;
                  (nHotAt := MOUSEHOTAT(nMouseR, nMouseC, aLmKeys)) # 0
                   nLastKey := nHotAt
                   RatApplyKey(oGet,nLastKey)
                elseif bLMouse#nil
                   eval(bLMouse,nMouseR,nMouseC)
                   IF ( slKillRead )  // ratkill() called
                      oGet:exitState := GE_ESCAPE
                   ENDIF
                endif
            elseif nLastKey==K_MOUSERIGHT
                nLastKey := nRmKey
                RatApplyKey(oGet,nLastKey)
            else
                RatapplyKey( oGet, nLastKey)
            endif
         ENDDO

         // Disallow exit if the VALID condition is not satisfied
         IF ( !RatPostValidate( oGet ) )
            oGet:exitState := GE_NOEXIT
            nJump := 0
         ENDIF
      ENDDO

      // De-activate the GET
      oGet:killFocus()

   ENDIF

   RETURN nJump



/***
*
*  RatapplyKey()
*
*  Apply a single INKEY() keystroke to a GET
*
*  NOTE: GET must have focus.
*
*/
PROCEDURE RatapplyKey( oGet, nKey )

   LOCAL cKey
   LOCAL bKeyBlock

   RRLASTKEY(nKey)
   // Check for SET KEY first
   IF !( ( bKeyBlock := setkey( nKey ) ) == NIL )
      RatDoSetKey( bKeyBlock, oGet )
      RETURN                           // NOTE
   ENDIF

   DO CASE
   CASE ( nKey == K_UP )
      oGet:exitState := GE_UP

   CASE ( nKey == K_SH_TAB )
      oGet:exitState := GE_UP

   CASE ( nKey == K_DOWN )
      oGet:exitState := GE_DOWN

   CASE ( nKey == K_TAB )
      oGet:exitState := GE_DOWN

   CASE ( nKey == K_ENTER )
      oGet:exitState := GE_ENTER

   CASE ( nKey == K_ESC )
      IF ( SET( _SET_ESCAPE ) )
         
         oGet:undo()
         oGet:exitState := GE_ESCAPE

      ENDIF

   CASE ( nKey == K_PGUP )
      oGet:exitState := GE_WRITE

   CASE ( nKey == K_PGDN )
      oGet:exitState := GE_WRITE

   CASE ( nKey == K_CTRL_HOME )
      oGet:exitState := GE_TOP


#ifdef CTRL_END_SPECIAL

   // Both ^W and ^End go to the last GET
   CASE ( nKey == K_CTRL_END )
      oGet:exitState := GE_BOTTOM

#else

   // Both ^W and ^End terminate the READ (the default)
   CASE ( nKey == K_CTRL_W )
      oGet:exitState := GE_WRITE

#endif


   CASE ( nKey == K_INS )
      SET( _SET_INSERT, !SET( _SET_INSERT ) )

   CASE ( nKey == K_UNDO )
      oGet:undo()

   CASE ( nKey == K_HOME )
      oGet:home()

   CASE ( nKey == K_END )
      oGet:end()

   CASE ( nKey == K_RIGHT )
      oGet:right()

   CASE ( nKey == K_LEFT )
      oGet:left()

   CASE ( nKey == K_CTRL_RIGHT )
      oGet:wordRight()

   CASE ( nKey == K_CTRL_LEFT )
      oGet:wordLeft()

   CASE ( nKey == K_BS )
      oGet:backSpace()

   CASE ( nKey == K_DEL )
      oGet:delete()

   CASE ( nKey == K_CTRL_T )
      oGet:delWordRight()

   CASE ( nKey == K_CTRL_Y )
      oGet:delEnd()

   CASE ( nKey == K_CTRL_BS )
      oGet:delWordLeft()

   OTHERWISE

      IF ( nKey >= 32 .AND. nKey <= 255 )

         cKey := CHR( nKey )

         IF ( oGet:type == "N" .AND. ( cKey == "." .OR. cKey == "," ) )
            oGet:toDecPos()
         ELSE
            
            IF ( SET( _SET_INSERT ) )
               oGet:insert( cKey )
            ELSE
               oGet:overstrike( cKey )
            ENDIF

            IF ( oGet:typeOut )
               IF ( SET( _SET_BELL ) )
                  ?? CHR(7)
               ENDIF

               IF ( !SET( _SET_CONFIRM ) )
                  oGet:exitState := GE_ENTER
               ENDIF
            ENDIF

         ENDIF

      ENDIF

   ENDCASE

   RETURN



/***
*
*  RatPreValidate()
*
*  Test entry condition (WHEN clause) for a GET
*
*/
FUNCTION RatPreValidate( oGet )

   LOCAL lSavUpdated
   LOCAL lWhen := .T.

   IF !( oGet:preBlock == NIL )

      lSavUpdated := slUpdated

      lWhen := EVAL( oGet:preBlock, oGet )

      oGet:display()

      slUpdated := lSavUpdated

   ENDIF

   IF ( slKillRead )
      
      lWhen := .F.
      oGet:exitState := GE_ESCAPE       // Provokes ReadModal() exit

   ELSEIF ( !lWhen )
      
      oGet:exitState := GE_WHEN         // Indicates failure

   ELSE
      
      oGet:exitState := GE_NOEXIT       // Prepares for editing

   END

   RETURN ( lWhen )



/***
*
*  RatPostValidate()
*
*  Test exit condition (VALID clause) for a GET
*
*  NOTE: Bad dates are rejected in such a way as to preserve edit buffer
*
*/
FUNCTION RatPostValidate( oGet )

   LOCAL lSavUpdated
   LOCAL lValid := .T.


   IF ( oGet:exitState == GE_ESCAPE )
      RETURN ( .T. )                   // NOTE
   ENDIF

   IF ( oGet:badDate() )
      oGet:home()
      RETURN ( .F. )                   // NOTE
   ENDIF

   // If editing occurred, assign the new value to the variable
   IF ( oGet:changed )
      oGet:assign()
      slUpdated := .T.
   ENDIF

   // Reform edit buffer, set cursor to home position, redisplay
   oGet:reset()

   // Check VALID condition if specified
   IF !( oGet:postBlock == NIL )

      lSavUpdated := slUpdated

      // S'87 compatibility
      SETPOS( oGet:row, oGet:col + LEN( oGet:buffer ) )

      lValid := EVAL( oGet:postBlock, oGet )

      // Reset S'87 compatibility cursor position
      SETPOS( oGet:row, oGet:col )

      oGet:updateBuffer()

      slUpdated := lSavUpdated

      IF ( slKillRead )
         oGet:exitState := GE_ESCAPE      // Provokes ReadModal() exit
         lValid := .T.

      ENDIF
   ENDIF

   RETURN ( lValid )



/***
*
*  RatDoSetKey()
*
*  Process SET KEY during editing
*
*/
PROCEDURE RatDoSetKey( keyBlock, oGet )

   LOCAL lSavUpdated

   // If editing has occurred, assign variable
   IF ( oGet:changed )
      oGet:assign()
      slUpdated := .T.
   ENDIF

   lSavUpdated := slUpdated

   EVAL( keyBlock, scReadProcName, snReadProcLine, ReadVar() )

   oGet:updateBuffer()

   slUpdated := lSavUpdated

   IF ( slKillRead )
      oGet:exitState := GE_ESCAPE      // provokes ReadModal() exit
   ENDIF

   RETURN





/***
*              READ services
*/



/***
*
*  Settle()
*
*  Returns new position in array of Get objects, based on:
*     - current position
*     - exitState of Get object at current position
*
*  NOTES: return value of 0 indicates termination of READ
*         exitState of old Get is transferred to new Get
*
*/
STATIC FUNCTION Settle( GetList, nPos, nJump, lWrap )    /*gp 09-04-1993*/

   LOCAL nExitState

   IF ( nPos == 0 )
      nExitState := GE_DOWN
   ELSE
      nExitState := GetList[ nPos ]:exitState
   ENDIF

   IF ( nExitState == GE_ESCAPE .or. nExitState == GE_WRITE )
      RETURN ( 0 )               // NOTE
   ENDIF

   IF !( nExitState == GE_WHEN )
      // Reset state info
      snLastPos := nPos
      slBumpTop := .F.
      slBumpBot := .F.
   ELSE
      // Re-use last exitState, do not disturb state info
      nExitState := snLastExitState
   ENDIF

   //
   // Move
   //
   DO CASE
   CASE nJump#nil .and. nJump#0                                          /*gp 09-04-1993*/
      nPos := nJump
   CASE ( nExitState == GE_UP )
      nPos--

   CASE ( nExitState == GE_DOWN )
      nPos++

   CASE ( nExitState == GE_TOP )
      nPos       := 1
      slBumpTop  := .T.
      nExitState := GE_DOWN

   CASE ( nExitState == GE_BOTTOM )
      nPos       := LEN( GetList )
      slBumpBot  := .T.
      nExitState := GE_UP

   CASE ( nExitState == GE_ENTER )
      nPos++

   ENDCASE

   //
   // Bounce
   //
   IF ( nPos == 0 )                       // Bumped top
      IF lWrap                                           /*gp 09-04-1993*/
         nPos       := len(getlist)
      ELSEIF ( !RatExit() .and. !slBumpBot )
         slBumpTop  := .T.
         nPos       := snLastPos
         nExitState := GE_DOWN
      ENDIF

   ELSEIF ( nPos == len( GetList ) + 1 )  // Bumped bottom
      IF lWrap                                           /*gp 09-04-1993*/
         nPos       := 1
      ELSEIF ( !RatExit() .and. !( nExitState == GE_ENTER ) .and. !slBumpTop )
         slBumpBot  := .T.
         nPos       := snLastPos
         nExitState := GE_UP
      ELSE
         nPos := 0
      ENDIF
   ENDIF

   // Record exit state
   snLastExitState := nExitState

   IF !( nPos == 0 )
      GetList[ nPos ]:exitState := nExitState
   ENDIF
   
   RETURN ( nPos )



/***
*
*  PostActiveGet()
*
*  Post active GET for ReadVar(), RatActive()
*
*/
STATIC PROCEDURE PostActiveGet( oGet )

   GetActive( oGet )
   RatActive( oGet )
   ReadVar( GetReadVar( oGet ) )


   RETURN



/***
*
*  ClearGetSysVars()
*
*  Save and clear READ state variables. Return array of saved values
*
*  NOTE: 'Updated' status is cleared but not saved (S'87 compatibility)
*/
STATIC FUNCTION ClearGetSysVars()

   LOCAL aSavSysVars[ GSV_COUNT ]

   // Save current sys vars
   aSavSysVars[ GSV_KILLREAD ]     := slKillRead
   aSavSysVars[ GSV_BUMPTOP ]      := slBumpTop
   aSavSysVars[ GSV_BUMPBOT ]      := slBumpBot
   aSavSysVars[ GSV_LASTEXIT ]     := snLastExitState
   aSavSysVars[ GSV_LASTPOS ]      := snLastPos
   aSavSysVars[ GSV_ACTIVEGET ]    := RatActive( NIL )
   aSavSysVars[ GSV_READVAR ]      := ReadVar( "" )
   aSavSysVars[ GSV_READPROCNAME ] := scReadProcName
   aSavSysVars[ GSV_READPROCLINE ] := snReadProcLine

   // Re-init old ones
   slKillRead      := .F.
   slBumpTop       := .F.
   slBumpBot       := .F.
   snLastExitState := 0
   snLastPos       := 0
   scReadProcName  := ""
   snReadProcLine  := 0
   slUpdated       := .F.

   RETURN ( aSavSysVars )



/***
*
*  RestoreGetSysVars()
*
*  Restore READ state variables from array of saved values
*
*  NOTE: 'Updated' status is not restored (S'87 compatibility)
*
*/
STATIC PROCEDURE RestoreGetSysVars( aSavSysVars )

   slKillRead      := aSavSysVars[ GSV_KILLREAD ]
   slBumpTop       := aSavSysVars[ GSV_BUMPTOP ]
   slBumpBot       := aSavSysVars[ GSV_BUMPBOT ]
   snLastExitState := aSavSysVars[ GSV_LASTEXIT ]
   snLastPos       := aSavSysVars[ GSV_LASTPOS ]

   RatActive( aSavSysVars[ GSV_ACTIVEGET ] )

   ReadVar( aSavSysVars[ GSV_READVAR ] )

   scReadProcName  := aSavSysVars[ GSV_READPROCNAME ]
   snReadProcLine  := aSavSysVars[ GSV_READPROCLINE ]

   RETURN



/***
*
*  GetReadVar()
*
*  Set READVAR() value from a GET
*
*/
STATIC FUNCTION GetReadVar( oGet )

   LOCAL cName := UPPER( oGet:name )
   LOCAL i

   // The following code includes subscripts in the name returned by
   // this FUNCTIONtion, if the get variable is an array element
   //
   // Subscripts are retrieved from the oGet:subscript instance variable
   //
   // NOTE: Incompatible with Summer 87
   //
   IF !( oGet:subscript == NIL )
      FOR i := 1 TO LEN( oGet:subscript )
         cName += "[" + LTRIM( STR( oGet:subscript[i] ) ) + "]"
      NEXT
   END

   RETURN ( cName )

/***
*
*  __KillRatR()
*
*  CLEAR GETS service
*
*/
PROCEDURE __KillRatR()
   slKillRead := .T.
   RETURN



/***
*
*  RatActive()
*
*  Retrieves currently active GET object
*/
FUNCTION RatActive( g )

   LOCAL oldActive := soActiveGet

   IF ( PCOUNT() > 0 )
      soActiveGet := g
   ENDIF

   RETURN ( oldActive )



/***
*
*  RatUpdated()
*
*/
FUNCTION RatUpdated()
   RETURN slUpdated



/***
*
*  RatExit()
*
*/
FUNCTION RatExit( lNew )
   RETURN ( SET( _SET_EXIT, lNew ) )



/***
*
*  RatInsert()
*
*/
FUNCTION RatInsert( lNew )
   RETURN ( SET( _SET_INSERT, lNew ) )




/***
*
*  RatKill()
*
*/
FUNCTION RatKill( lKill )

   LOCAL lSavKill := slKillRead

   IF ( PCOUNT() > 0 )
      slKillRead := lKill
   ENDIF

   RETURN ( lSavKill )



/***
*
*  RatSetUpdate()
*
*/
FUNCTION RatSetUpdate( lUpdated )
   
   LOCAL lSavUpdated := slUpdated
   
   IF ( PCOUNT() > 0 )
      slUpdated := lUpdated
   ENDIF

   RETURN ( lSavUpdated )
      


//----------------------------------------------------------------
FUNCTION  R_GETPUSH(aGets)
aadd(aGetSets,aGets)
return nil

//----------------------------------------------------------------
FUNCTION R_GETPOP()
if len(aGetSets)>0
  ASIZE(aGetSets,len(agetSets)-1)
endif
return ATAIL(aGetSets)


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION GETJUMP2()                   *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  GETJUMP2() Determines if mouse clicked on a get
³
³  Returns:
³  --------
³  <nJumpTo> => Number of get that mouse clicked on
³
³  Syntax:
³  -------
³  GETJUMP2(nMouseRow, nMousecol, [aGetList] )
³
³  Description:
³  ------------
³  This function checks nMouseRow and nMouseCol against the getlist,
³  either passed by you as [aGetList], or by accessing the most recent
³  RAT_READ() get list, and determines if the user clicked on a
³  get. How you then get to that get is up to you. RAT_READ and the
³  specialized get readers in SuperLib make use of this function to
³  jump to non-contiguous gets.
³
³  Examples:
³  ---------
³  IF (nGet := GETJUMP2(nMouseR, nMouseC,getlist) ) > 0
³     ....
³  ENDIF
³
³  Notes:
³  -------
³
³  Source:
³  -------
³  S_RREAD.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION GETJUMP2(nMouseR, nMouseC, getlist)
local nJump := 0
local i
getlist := iif(getlist#nil,getlist,ATAIL(aGetSets) )
if len(aGetSets) > 0
  for i = 1 to len(getlist)
    if nMouseR==getlist[i]:row .and. nMouseC>=getlist[i]:col .and. nMouseC<= ;
        getlist[i]:col+len(trans(getlist[i]:varget(),getlist[i]:picture))-1
          nJump := i
          exit
    endif
  next
endif
return nJump


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION R_ISRATREAD()                 *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  R_ISRATREAD() Determines if RAT_READ() is current get system
³
³  Returns:
³  --------
³  <lIsRatRead> => True if RAT_READ() is current get system
³
³  Syntax:
³  -------
³  R_ISRATREAD()
³
³  Description:
³  ------------
³
³  By calling R_ISRATREAD(), you can determine if the current
³  read is a RAT_READ or not, and call the regular exported
³  read/get functions, or call their equivalent RAT* functions
³  as listed in RAT_READ().
³
³  An exception is GETACTIVE(), which may be called while using
³  either get system, as RAT_READ() calls GETACTIVE() to update
³  the current get, and also saves and restores the active get
³  in case there is a prior READ active.
³
³  This R_ISRATREAD() function returns TRUE/FALSE for 'is the current
³  read a RAT_READ or a READMODAL (normal) read'. Essentially it tells
³  you which GetSystem you are in.
³
³  Thus you can have both RAT_READ() mouse aware reads, and standard
³  READMODAL() Clipper reads in the same system, and tell the
³  difference between the two.
³
³  Examples:
³  ---------
³  IF R_ISRATREAD()
³     ...
³  ENDIF
³
³  Notes:
³  -------
³
³  Source:
³  -------
³  S_RREAD.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
FUNCTION R_ISRATREAD
local lRatRead := .f.
local i := 1
local cProc
while !empty( cProc := PROCNAME(i) )
  if "RAT_READ"$cProc
   lRatRead := .t.
   exit
  elseif "READMODAL"$cProc
   exit
  endif
  i++
end
return lRatRead

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION RRLASTKEY()                 *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  RRLASTKEY()  Retrieve the last key handled by ratapplykey()
³
³  Returns:
³  --------
³  <nLastKey> => last key handled by ratapplykey()
³
³  Syntax:
³  -------
³  RRLASTKEY()
³
³  Description:
³  ------------
³  Returns the last key - including pseudo keys - handled by
³  RatApplyKey().
³
³  The [nRmKey]  and [aLmKeys] parameters of RAT_READ() allow
³  emulation of keypresses. The [nRmKey] determines what key is
³  emulated when the right mouse button is pressed. The [aLmKeys]
³  array contains key emulations to be used for a set of screen
³  hot areas for left mouse button clicks. In both cases, the
³  ascii key code is passed to RatApplyKey() to handle. However,
³  the keys ARE NOT STUFFED INTO THE KEYBOARD, and thus are not
³  retrievable through LASTKEY(). The reason, by the way, that they
³  are not stuffed into the keyboard, is that some keys cannot be
³  stuffed with the KEYBOARD command  ( i.e. ALT-F10 or -39 )
³
³  After a number of requests to be able to tell what key was
³  pressed last when exiting a read, even when it is an interpreted
³  key based on a mouse click, I've added this function. It will return
³  the last key handled by RatApplyKey(), even if the key is based on
³  a mouse click. If the last event is a mouse event that does not
³  translate into a key value, it will return either K_MOUSELEFT for left
³  mouse click, or K_MOUSERIGHT for right mouse click.
³
³
³  Examples:
³  ---------
³  RAT_READ(getlist,...)
³  if RRLASTKEY()==27
³    * escape was pressed or mouse right button was pressed
³
³  endif
³
³  Notes:
³  -------
³
³  Source:
³  -------
³  S_RREAD.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
function RRLASTKEY(nNew)
static nLastKey := 0
if nNew#nil
  nLastKey:=nNew
endif
return nLastKey



static function RRTHISGET(oGetNew)
static oGet := nil
if oGetNew#nil
  oGet := oGetNew
endif
return oGet

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION RRJUMP2()                 *new*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³
³  Short:
³  ------
³  RRJUMP2()  Jump to a new get in a RAT_READ()
³
³  Returns:
³  --------
³  NIL
³
³  Syntax:
³  -------
³  RRJUMP2(nNew)
³
³  Description:
³  ------------
³  While in a RAT_READ(), causes the jump flag to be set to <nNew>, and
³  and the current get's exitstate variable to be set to GE_ENTER. This
³  causes an exit from the current get, and a jump to get <nNew>.
³
³  Examples:
³  ---------
³   // in this example, pressing or clicking F3 causes a jump to
³   // get # 1, while pressing or clicking F4 causes a jump to
³   // get # 5.
³
³   #include "inkey.ch"
³
³   v1 := space(10)
³   v2 := space(10)
³   v3 := space(10)
³   v4 := space(10)
³   v5 := space(10)
³
³   setkey(K_F4,{||rrjump2(5)} )
³   setkey(K_F3,{||rrjump2(1)} )
³
³   @24,0 say "[F3-Go to First Get]  [F4-Go to Last Get]"
³
³   ahot := {{24,0,24,20,K_F3},{24,23,24,41,K_F4} }
³
³   @10,10 get v1
³   @11,10 get v2
³   @12,10 get v3
³   @13,10 get v4
³   @14,10 get v5
³
³   RAT_READ(getlist,1,.T.,27,nil,aHot)
³
³  Notes:
³  -------
³
³  Source:
³  -------
³  S_RREAD.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
function RRJUMP2(nPosit)
if nPosit#nil
  RRJUMPGET(nPosit)
  RRTHISGET():exitstate := GE_ENTER
endif
return nil

static function RRJUMPGET(nNew)
static nJumpTo := 0
if nNew#nil
  nJumpTo:=nNew
endif
return nJumpTo


