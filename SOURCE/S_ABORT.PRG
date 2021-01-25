/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ABORT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ABORT() Pops up dialog box asking: Abort  Don't Abort
ณ 
ณ  Returns:
ณ  --------
ณ  <lDoAbort> => True or False
ณ 
ณ  Syntax:
ณ  -------
ณ  ABORT([cColor],[nTop,nLeft,nBottom,nRight])
ณ 
ณ  Description:
ณ  ------------
ณ  Tests for escape key press at last wait state. If
ณ  escape key was pressed, pops up a dialog box asking
ณ      [Abort] [Don't Abort]
ณ 
ณ  Returns True if [Abort], False if [Don't Abort] or
ณ  False if last key was not 27 (escape key).
ณ 
ณ  Box color is sls_popmenu() or optionally [cColor].
ณ  Box dimensions are: 9,29,13,51 or optionally
ณ  [nTop,nLeft,nBottom,nRight]
ณ 
ณ  Examples:
ณ  ---------
ณ   INKEY(0)
ณ   IF ABORT()  // test for lastkey() = 27
ณ       exit
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_ABORT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION abort(cBoxColor,nTop,nLeft,nBottom,nRight)
local nSelection,cUnderScreen, aOptions, nFromTop


IF !LASTKEY() = 27
  RETURN .F.
ENDIF

cBoxColor := iif(cBoxColor==nil,sls_popmenu(),cBoxcolor)
IF nTop==nil .or. nLeft==nil .or. nBottom==nil .or. nRight==nil
        nTop:= 9 ; nLeft:= 29 ; nBottom:= 13 ; nRight:= 51
endif
nFromtop := iif(nBottom-nTop>2,2,1)
// save screen
cUnderScreen:=makebox(nTop,nLeft,nBottom,nRight,cBoxColor)

// do a menu while last key is escape
DO WHILE LASTKEY() = 27
  aOptions := { {nTop+nFromTop,nLeft+2 , "Abort" },;
                {nTop+nFromTop,nLeft+2+4+2, "Don't Abort"  } }
  nSelection := RAT_MENU2(aOptions,1,.t.)
ENDDO
unbox(cUnderScreen)

RETURN (nSelection==1)

