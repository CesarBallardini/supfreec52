/*
�����������������������������������������������������������������
� FUNCTION PLSWAIT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  PLSWAIT() Pops up a 'Please Wait' window or removes it
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  PLSWAIT(lOnOff,[cMessage],[nTop,nLeft,nBottom,nRight])
� 
�  Description:
�  ------------
�  Pops up a window with a 'please wait' message or
�  removes a previous 'please wait' window.
� 
�  <lOnOff> True means show popup window, False means
�  remove window.
� 
�  [cMessage] - message. Default is 'Please wait...'
� 
�  [nTop,nLeft,nBottom,nRight] box coordinates. Defaults
�  are 10,20,12,60.
� 
�  Examples:
�  ---------
�   PLSWAIT(.T.,"I'm thinking...")
� 
�   // code here
� 
�   PLSWAIT(.F.)   // remove plswait message
� 
�  Source:
�  -------
�  S_PLSW.PRG
� 
����������������������������������������������������������������� 
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


