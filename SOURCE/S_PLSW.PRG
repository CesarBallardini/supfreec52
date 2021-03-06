/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PLSWAIT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PLSWAIT() Pops up a 'Please Wait' window or removes it
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  PLSWAIT(lOnOff,[cMessage],[nTop,nLeft,nBottom,nRight])
³ 
³  Description:
³  ------------
³  Pops up a window with a 'please wait' message or
³  removes a previous 'please wait' window.
³ 
³  <lOnOff> True means show popup window, False means
³  remove window.
³ 
³  [cMessage] - message. Default is 'Please wait...'
³ 
³  [nTop,nLeft,nBottom,nRight] box coordinates. Defaults
³  are 10,20,12,60.
³ 
³  Examples:
³  ---------
³   PLSWAIT(.T.,"I'm thinking...")
³ 
³   // code here
³ 
³   PLSWAIT(.F.)   // remove plswait message
³ 
³  Source:
³  -------
³  S_PLSW.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION plswait(lBoxOn,cMessage,nTop,nLeft,nBottom,nRight)
local  cInColor,nLenMessage

static nsTop,nsLeft,nsBottom,nsRight,cUnder

IF !VALTYPE(cMessage)=="C"
  cMessage := "Please wait..."
ENDIF

nLenMessage := MIN(LEN(cMessage),76)
cMessage    := LEFT(cMessage,nLenMessage)

IF lBoxOn
  IF nTop#nil.and. nLeft#nil .and. nRight#nil .and. nBottom#nil
    nsTop    := nTop
    nsLeft   := nLeft
    nsBottom := nBottom
    nsRight  := nRight
  ELSE
    nsTop    := 10
    nsBottom := 12
    nsLeft   := INT((79-nLenMessage)/2 - 1)
    nsRight  := nsLeft+nLenMessage+2
  ENDIF
ENDIF
IF lBoxOn
  cInColor  := Setcolor()
  cUnder    :=makebox(nsTop,nsLeft,nsBottom,nsRight,sls_popcol())
  @nsTop+1,nsLeft+1 SAY cMessage color sls_popcol()
  Setcolor(cInColor)
ELSE
  unbox(cUnder)
  cUnder   := nil
  nsTop    := nil
  nsLeft   := nil
  nsBottom := nil
  nsRight  := nil
ENDIF
RETURN ''



