
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#include "memoedit.ch"

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION VIEWMEMOS()                          *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  VIEWMEMOS() Popup viewing (non-edit mode) of memos
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  VIEWMEMOS([nTop,nLeft,nBottom,nRight],[cColor],[cMemoName])
ณ 
ณ  Description:
ณ  ------------
ณ  VIEWMEMOS() will determine first off if there are any
ณ  memo fields to view. If there are not, it will display a message
ณ  to that effect and exit.
ณ 
ณ  If there is only one memo, it will be immediately
ณ  viewed.
ณ 
ณ  If there are more than one memo, a picklist of memos
ณ  will be popped up for selection. The memo selected will be viewed.
ณ 
ณ  [nTop,nLeft,nBottom,nRight] are the dimensions of the
ณ  popup box.
ณ 
ณ  Default is 2,15,22,65. (Just numbers off the top of
ณ  my head.)
ณ 
ณ  [cColor] is an optional color string. Default is
ณ  sls_popcol().
ณ 
ณ  [cMemoName] (new to 3.5) allows you to pass in a memo name and
ณ  bypass the "Which memo?" screen.
ณ 
ณ  Examples:
ณ  ---------
ณ   USE CUSTOMER
ณ 
ณ   if qfldstype("M") > 0  // qfldstyp() is a superlib function
ณ      VIEWMEMOS()
ณ   endif
ณ 
ณ  Source:
ณ  -------
ณ  S_VMEMO.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function viewmemos(nTop,nLeft,nBottom,nRight,cColor,cMemoName)
local aMemos := aFieldsType("M")
local nChoice,cMemoBox, cMemo
local nMemo := 0
if len(aMemos) > 0
     if cMemoName#nil
       nMemo := ASCAN(aMemos,cMemoName)
     endif
     nChoice = 1
     IF nMemo > 0 .and. nMemo <= len(aMemos)
       nChoice := nMemo
     ELSEIF len(aMemos) > 1
       nChoice := mchoice(aMemos,2,15,3+len(aMemos),26,"Which Memo:")
     ENDIF
     if nChoice > 0
       if !(nTop#nil .and. nLeft#nil .and. nBottom#nil .and. nRight#nil)
         nTop    := 2
         nLeft   := 15
         nBottom := 22
         nRight  := 65
       endif
       if (nRight-nLeft)-1 < 30
         nRight := nLeft+31
         if nRight>maxcol()
             sbCenter(@nTop,@nLeft,@nBottom,@nRight)
         endif
       endif
       cColor := iif(cColor#nil,cColor,sls_popcol())
       cMemoBox := makebox(ntop,nLeft,nBottom,nRight,cColor)
       @ntop,nLeft+1 SAY '[VIEWING MEMO FIELD: '+aMemos[nChoice]+"]"
       @nbottom,nLeft+1 say '[ESCAPE=done]'
       cMemo :=HARDCR(fieldget(fieldpos(aMemos[nChoice])))
       *Memoedit(HARDCR(fieldget(fieldpos(aMemos[nChoice]))),nTop+1,nLeft+1,nbottom-1,nright-1,.F.,'',200)
       mMemoedit(cMemo,nTop+1,nLeft+1,nBottom-1,nRight-1,.f.,;
           {|m,r,c,l,mr,mc,a|vm_mudf(m,r,c,l,mr,mc,a,nbottom,nLeft+1,nLeft+13)},78,;
            nil,nil,nil,nil,nil,nBottom,nRight-16)
       unbox(cMemoBox)
     endif
ELSE
  msg("No memo fields detected","")
endif
return nil


static FUNCTION vm_mudf(nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC,a,nERow,nEscL,nEscR)
local nReturnVal
local nRow := row(), nCol := col()
nReturnVal := ME_DEFAULT
IF !(nMode= ME_INIT)
  if nNextKey== K_MOUSELEFT .and. nMouseR==nERow
     do case
     case nMouseC >=nEscL .and. nMouseC<=nEscR
       KEYBOARD CHR(K_ESC)
     endcase
  endif
ENDIF
devpos(nRow,nCol)
RETURN nReturnval
