/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PLSWAIT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PLSWAIT() Pops up a 'Please Wait' window or removes it
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  PLSWAIT(lOnOff,[cMessage],[nTop,nLeft,nBottom,nRight])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a window with a 'please wait' message or
ณ  removes a previous 'please wait' window.
ณ 
ณ  <lOnOff> True means show popup window, False means
ณ  remove window.
ณ 
ณ  [cMessage] - message. Default is 'Please wait...'
ณ 
ณ  [nTop,nLeft,nBottom,nRight] box coordinates. Defaults
ณ  are 10,20,12,60.
ณ 
ณ  Examples:
ณ  ---------
ณ   PLSWAIT(.T.,"I'm thinking...")
ณ 
ณ   // code here
ณ 
ณ   PLSWAIT(.F.)   // remove plswait message
ณ 
ณ  Source:
ณ  -------
ณ  S_PLSW.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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



