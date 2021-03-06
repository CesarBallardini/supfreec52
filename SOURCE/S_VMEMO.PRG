
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#include "memoedit.ch"

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION VIEWMEMOS()                          *changed*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  VIEWMEMOS() Popup viewing (non-edit mode) of memos
³ 
³  Returns:
³  --------
³  Nil
³ 
³  Syntax:
³  -------
³  VIEWMEMOS([nTop,nLeft,nBottom,nRight],[cColor],[cMemoName])
³ 
³  Description:
³  ------------
³  VIEWMEMOS() will determine first off if there are any
³  memo fields to view. If there are not, it will display a message
³  to that effect and exit.
³ 
³  If there is only one memo, it will be immediately
³  viewed.
³ 
³  If there are more than one memo, a picklist of memos
³  will be popped up for selection. The memo selected will be viewed.
³ 
³  [nTop,nLeft,nBottom,nRight] are the dimensions of the
³  popup box.
³ 
³  Default is 2,15,22,65. (Just numbers off the top of
³  my head.)
³ 
³  [cColor] is an optional color string. Default is
³  sls_popcol().
³ 
³  [cMemoName] (new to 3.5) allows you to pass in a memo name and
³  bypass the "Which memo?" screen.
³ 
³  Examples:
³  ---------
³   USE CUSTOMER
³ 
³   if qfldstype("M") > 0  // qfldstyp() is a superlib function
³      VIEWMEMOS()
³   endif
³ 
³  Source:
³  -------
³  S_VMEMO.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
