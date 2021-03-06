/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ABORT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ABORT() Pops up dialog box asking: Abort  Don't Abort
³ 
³  Returns:
³  --------
³  <lDoAbort> => True or False
³ 
³  Syntax:
³  -------
³  ABORT([cColor],[nTop,nLeft,nBottom,nRight])
³ 
³  Description:
³  ------------
³  Tests for escape key press at last wait state. If
³  escape key was pressed, pops up a dialog box asking
³      [Abort] [Don't Abort]
³ 
³  Returns True if [Abort], False if [Don't Abort] or
³  False if last key was not 27 (escape key).
³ 
³  Box color is sls_popmenu() or optionally [cColor].
³  Box dimensions are: 9,29,13,51 or optionally
³  [nTop,nLeft,nBottom,nRight]
³ 
³  Examples:
³  ---------
³   INKEY(0)
³   IF ABORT()  // test for lastkey() = 27
³       exit
³   ENDIF
³ 
³  Source:
³  -------
³  S_ABORT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

