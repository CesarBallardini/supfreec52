/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MSG()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MSG() Displays up to a 9 line message in a window
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  MSG(c1,[c2,c3,c4,c5,c6,c7,c8,c9])
ณ 
ณ  Description:
ณ  ------------
ณ  Displays in a popup box up to 9 lines of a message
ณ  <c1..c9>.
ณ 
ณ  Then waits for a keypress or optionally a time-out.
ณ  First parameter can be a number equaling a time-out value in
ณ  seconds
ณ 
ณ  Examples:
ณ  ---------
ณ   MSG("An error has been detected",;
ณ       "...don't move!")
ณ 
ณ   MSG("A","B","C","D","E","F")
ณ 
ณ   MSG(5,"A","B","C","D","E","F")
ณ 
ณ  Notes:
ณ  -------
ณ  Message is centered on screen in a box
ณ  Once message is displayed, waits for keypress and
ณ  then removes window, restoring screen underneath.
ณ  Or waits for time-out value.
ณ 
ณ  Source:
ณ  -------
ณ  S_MSG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

