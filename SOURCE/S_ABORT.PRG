/*
�����������������������������������������������������������������
� FUNCTION ABORT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ABORT() Pops up dialog box asking: Abort  Don't Abort
� 
�  Returns:
�  --------
�  <lDoAbort> => True or False
� 
�  Syntax:
�  -------
�  ABORT([cColor],[nTop,nLeft,nBottom,nRight])
� 
�  Description:
�  ------------
�  Tests for escape key press at last wait state. If
�  escape key was pressed, pops up a dialog box asking
�      [Abort] [Don't Abort]
� 
�  Returns True if [Abort], False if [Don't Abort] or
�  False if last key was not 27 (escape key).
� 
�  Box color is sls_popmenu() or optionally [cColor].
�  Box dimensions are: 9,29,13,51 or optionally
�  [nTop,nLeft,nBottom,nRight]
� 
�  Examples:
�  ---------
�   INKEY(0)
�   IF ABORT()  // test for lastkey() = 27
�       exit
�   ENDIF
� 
�  Source:
�  -------
�  S_ABORT.PRG
� 
����������������������������������������������������������������� 
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
