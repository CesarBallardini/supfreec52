
proc main
local cInScreen := savescreen(0,0,24,79)
local nSelected := 1
local aOptions := { ;
                 {6,28 ,  'Simple Mouse Test'},;
                 {7,28 ,  'Read with mouse'},;
                 {8,28 ,  'Menu To with mouse'},;
                 {9,28 ,  'Event handler'},;
                 {10,28 , 'Quit'}}

*- set some sets
SET TALK OFF
SET ECHO OFF
SET CONFIRM OFF
SET BELL OFF
SET SAFETY OFF
SET SCOREBOARD OFF
slsf_color("S3COLOR")
initsup(.F.)
rat_reset()
setcolor(sls_normcol())
dispbox(0,0,24,79,"ÚÄ¿³ÙÄÀ³²")
makebox(5,24,12,51)


IF RAT_EXIST()
  while .t.
   nSelected := RAT_MENU2(aOptions,nSelected,.t.)
   do case
   case nSelected == 1
     ratbasic()
   case nSelected == 2
     readrat()
   case nSelected == 3
     RAT_MSG("You're in RAT_MENU2()","right now...")
   case nSelected == 4 // event handler
     event()
   case nSelected == 5 .or. nSelected == 0
     exit
   endcase
  end
else
  msg("Could not find a mouse")
endif
ss_split(0,0,24,79,cInscreen)



//-----------------------------------------------------------------
//--- mouse basics - on/off, location on the screen, button presses
proc ratbasic
local cInscreen := savescreen(0,0,24,79)
local nOldMrow := 0
local nOldMCol := 0
local nMrow    := 0
local nMCol    := 0
local nMLeftpR := 0
local nMLeftpC := 0
local nmRightpR := 0
local nMRightpC := 0
makebox(7,19,17,66,sls_normcol())
@7,20 say "Simple mouse usage..."
@ 9,22 SAY "Mouse row             :"
@ 10,22 SAY "Mouse col             :"
@ 12,22 SAY "Mouse left pressed at :"
@ 13,22 SAY "Mouse right pressed at:"
@ 16,58 say " Quit" color sls_popcol()


rat_on()
nOldMRow := rat_row()+1
nOldMCol := rat_col()+1
while .t.
   nMRow := rat_row()
   nMCol := rat_col()
   if nOldMRow#nMRow .or. nOldMCol#nMCol
     nOldMRow := nMRow
     nOldMCol := nMCol
     rat_off()
     @9,47  say nMRow  pict "999"
     @10,47 say nMCol  pict "999"
     rat_on()
   elseif rat_leftb()
     nMLeftpR := rat_rowl()
     nMLeftpc := rat_coll()
     @12,47 say nMLeftpR  pict "999"
     @12,50 say ","
     @12,51 say nMLeftpC  pict "999"
     if nMLeftpR == 16 .and. nMLeftpC >= 58 .and. nMLeftpC <= 62 // on "Quit"
       exit
     endif
   elseif rat_rightb()
     nMRightpR := rat_rowr()
     nMRightpc := rat_colr()
     @13,47 say nMRightpR  pict "999"
     @13,50 say ","
     @13,51 say nMRightpC  pict "999"
   endif
end
rat_off()
ss_fold(0,0,24,79,cInscreen)

//-----------------------------------------------------------------
//--- mouse READ test
static proc readrat()
 local cBox := makebox(9,9,15,62)
 local v1 := padr("This is a test of the ",50)
 local v2 := padr("Mouse reader in SuperLib",50)
 local v3 := padr("which allows mouse action ",50)
 memvar getlist
 @14,10 say "Use mouse to change gets - right button escapes"
 @10,10 get v1
 @11,10 get v2
 @12,10 get v3
 RAT_READ(getlist,1,.T.,27)
 unbox(cBox)
return


//-----------------------------------------------------------------
//--- EVENT
static proc event()
local cBox := makebox(10,10,15,70)
local nEvent

@11,12 say "Do something..."
@12,12 say "(click the mouse, press a key, etc...)"
@14,12 say "(Press ESCAPE to exit)"
@14,65 say "Quit" color sls_popcol()
while .t.
   nEvent := rat_event(5)
   scroll(11,11,13,69,0)
   do case
   case nEvent == 0
     @11,12 say "Timed out after 5 seconds"
   case nEvent < 400
     @11,12 say "Key press with inkey() value of :"
     ??nEvent
     if nEvent == 27
       exit
     endif
   case nEvent == 400
     @11,12 say "Left mouse button pressed at :"
     ?? trans(rat_eqmrow(),"999"),",", trans(rat_eqmcol(),"999")
     if rat_elbhd(.5)
       ?? " and held down!"
     endif
     if rat_eqmrow() == 14 .and. rat_eqmcol() >= 65 .and. ;
        rat_eqmcol() <= 68 // on "Quit"
       exit
     endif
   case nEvent == 500
     @11,12 say "Right mouse button pressed at :"
     ?? trans(rat_eqmrow(),"999"),",", trans(rat_eqmcol(),"999")
     if rat_erbhd(.5)
       ?? " and held down!"
     endif
   endcase
   @12,12 say "do something else..."

end
unbox(cBox)
return

//--------------MSG() function RATified
FUNCTION rat_msg(cMsg1,cMsg2,cMsg3,cMsg4,cMsg5,cMsg6,cMsg7,cMsg8,cMsg9)
local nMessageLines,nIterator,nTop,nLeft,nBottom
local nRight,cUnderScreen,nOldCursor
LOCAL nTimeout,lIsTimer,nLongest
LOCAL aMessages

*- save cursor status, set cursor off
nOldCursor = setcursor(0)

*- how many paramaters passed (maximum 9)
IF VALTYPE(cMsg1) == "N"
  lIsTimer      := .T.
  nTimeout      := cMsg1
  nMessageLines := MIN(Pcount()-1,8)
  aMessages     := {cMsg2,cMsg3,cMsg4,cMsg5,cMsg6,cMsg7,cMsg8,cMsg9}
ELSE
  lIsTimer      := .F.
  nTimeout      := 0
  nMessageLines := MIN(Pcount(),9)
  aMessages     := {cMsg1,cMsg2,cMsg3,cMsg4,cMsg5,cMsg6,cMsg7,cMsg8,cMsg9}
ENDIF
asize(aMessages,nMessagelines)

*- whats the longest string
nLongest = MAX(bigelem(aMessages)+1,16)

*- figure the window coordinates
nTop            := 8
* if no lIsTimer value, leave blank line before "Press a key...", else no space
nBottom         := IIF(nTimeout=0,nTop+nMessageLines+3,nTop+nMessageLines+1)
nLeft           := INT((79-nLongest)/2 - 1)
nRight          := nLeft+nLongest+2

*- draw a box
cUnderScreen = makebox(nTop,nLeft,nBottom,nRight,sls_popcol())

* display the message
FOR nIterator = 1 TO nMessageLines
  @8+nIterator,nLeft+2 SAY aMessages[nIterator]
NEXT
* now the results of the lIsTimer value
IF nTimeout = 0
  @ nBottom-1,nLeft+2 SAY "Press a key..."
  *- wait
  RAT_EVENT(0)
ELSE
  RAT_EVENT(nTimeout)
ENDIF (nTimeout = 0
*- leave
unbox(cUnderScreen)

*- set cursor on, if that's where it was
SETCURSOR(nOldCursor)
RETURN ''



