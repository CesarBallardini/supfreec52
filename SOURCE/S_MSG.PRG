/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION MSG()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  MSG() Displays up to a 9 line message in a window
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  MSG(c1,[c2,c3,c4,c5,c6,c7,c8,c9])
³ 
³  Description:
³  ------------
³  Displays in a popup box up to 9 lines of a message
³  <c1..c9>.
³ 
³  Then waits for a keypress or optionally a time-out.
³  First parameter can be a number equaling a time-out value in
³  seconds
³ 
³  Examples:
³  ---------
³   MSG("An error has been detected",;
³       "...don't move!")
³ 
³   MSG("A","B","C","D","E","F")
³ 
³   MSG(5,"A","B","C","D","E","F")
³ 
³  Notes:
³  -------
³  Message is centered on screen in a box
³  Once message is displayed, waits for keypress and
³  then removes window, restoring screen underneath.
³  Or waits for time-out value.
³ 
³  Source:
³  -------
³  S_MSG.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION msg(cMsg1,cMsg2,cMsg3,cMsg4,cMsg5,cMsg6,cMsg7,cMsg8,cMsg9)
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
  rat_event(0)
ELSE
  rat_event(nTimeOut)
ENDIF (nTimeout = 0
*- leave
unbox(cUnderScreen)

*- set cursor on, if that's where it was
SETCURSOR(nOldCursor)
RETURN ''

