
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION RAT_MENU2()                          *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  RAT_MENU2() Mouseable MENU TO emulation
ณ 
ณ  Returns:
ณ  --------
ณ  <nSelected> => selected menu option, 0 for none
ณ 
ณ  Syntax:
ณ  -------
ณ  RAT_MENU2(aOptions,[nStart],[lImmediate],[bMouse])
ณ 
ณ  Description:
ณ  ------------
ณ  You must pass an array of arrays, with each element
ณ  being an array in the form {nRow,nColumn,cPrompt} which
ณ  correspond to      [ @nRow,nCol PROMPT cPrompt. ]
ณ 
ณ  [nStart] is an optional starting prompt, with the
ณ  default being 1
ณ 
ณ  [lImmediate] refers to the action taken when a first
ณ  letter or a mouse click changes options. The default is to have
ณ  immediate action - select and return. By passing False, it
ณ  becomes a 2 step  process, requiring click-click or
ณ  firstletter-firstletter to select and return.
ณ 
ณ  [bMouse] is an optional codeblock for mouse clicks. If the
ณ  mouse click does not satisfy RAT_MENU2(), and there is a
ณ  [bMouse] codeblock, it will be evaluated as follows:
ณ
ณ               eval(bMouse,mouserow, mousecol)
ณ 
ณ 
ณ  Examples:
ณ  ---------
ณ   local aOptions := { ;
ณ                      {23,2 ,  'Add'},;
ณ                      {23,9 ,  'Open'},;
ณ                      {23,17 , 'Delete'},;
ณ                      {23,27 , 'Change Date'},;
ณ                      {23,42 , 'Output list'},;
ณ                      {23,57 , 'Purge '},;
ณ                      {23,74 , 'Quit'}}
ณ 
ณ   nSelected := RAT_MENU2(aOptions,4,.f.,{|r,c| checkmouse(r,c) })
ณ 
ณ  Source:
ณ  -------
ณ  S_RMENU2.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION RAT_MENU2(aOptions,nStart,lImmediate,bMouse)
local cNormcolor   := takeout(Setcolor(),",",1)
local cEnhcolor    := takeout(Setcolor(),",",2)
local i,aThisOp
local aDims        := array(len(aOptions))
local nElement     := min(iif(nStart#nil,max(nStart,1),1),len(aOptions))
local nOldSel      := nElement
local nLastKey, nFound, nMrow,nMcol, nMouseFound
local cFirstLet    := ""
local cLastKey, bKeyBlock
local nCursor := setcursor(0)
lImmediate := iif(lImmediate#nil,lImmediate,.t.)
for i = 1 to len(aOptions)
   aThisOp := aOptions[i]
   @aThisOp[1], aThisOp[2] say aThisOp[3] color cNormColor
   aDims[i] := {aThisOp[1],aThisOp[2],aThisOp[1],aThisOp[2]+len(aThisOp[3])-1}
   cFirstLet += upper(left(aThisOp[3],1 ))
next

while .t.
   @aOptions[nOldSel,1],aOptions[nOldSel,2] say aOptions[nOldSel,3] color cNormColor
   nOldSel      := nElement
   @aOptions[nElement,1],aOptions[nElement,2] say aOptions[nElement,3] color cEnhColor
   nLastKey := rat_event(0)
   cLastKey := upper(chr(nLastKey))
   do case
   case nLastKey == K_MOUSELEFT  // left mouse
      nMrow := rat_eqmrow()
      nMcol := rat_eqmcol()
      if (nMouseFound := ascan(aDims,{|d|d[1]==nMrow .and.;
           (d[2] <=nMcol .and. d[4] >=nMcol ) })) > 0
           nElement := nMouseFound
           if lImmediate .or. nElement==nOldSel
             keyboard chr(13)
           endif
      elseif bMouse#nil
         eval(bMouse,nMrow, nMcol)
      endif
   case nLastKey = K_LEFT .or. nLastkey==K_UP
      nElement := IIF(nElement=1,len(aOptions),nElement-1)
   case nLastKey = K_RIGHT .or. nLastKey == K_DOWN
      nElement := IIF(nElement=len(aOptions),1,nElement+1)
   case cLastKey$cFirstLet
      if (nFound := AT(cLastKey,subst(cFirstLet,nElement)) ) > 0
        nElement := nFound+nElement-1
      else
        nElement := at(cLastKey,cFirstLet)
      endif
      if lImmediate .or. nElement==nOldSel
        keyboard chr(13)
      endif
   case nLastKey = K_ENTER .or. nLastkey==K_PGUP .or. nLastkey== K_PGDN
      exit
   case nLastKey = K_ESC .or. nLastKey == K_MOUSERIGHT
      nElement := 0
      exit
    case ( (bKeyBlock := SetKey(nLastKey)) <> NIL )
      Eval(bkeyBlock,"",0,"")
   endcase
end
setcursor(nCursor)
return nElement


