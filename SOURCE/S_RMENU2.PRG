
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION RAT_MENU2()                          *changed*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  RAT_MENU2() Mouseable MENU TO emulation
³ 
³  Returns:
³  --------
³  <nSelected> => selected menu option, 0 for none
³ 
³  Syntax:
³  -------
³  RAT_MENU2(aOptions,[nStart],[lImmediate],[bMouse])
³ 
³  Description:
³  ------------
³  You must pass an array of arrays, with each element
³  being an array in the form {nRow,nColumn,cPrompt} which
³  correspond to      [ @nRow,nCol PROMPT cPrompt. ]
³ 
³  [nStart] is an optional starting prompt, with the
³  default being 1
³ 
³  [lImmediate] refers to the action taken when a first
³  letter or a mouse click changes options. The default is to have
³  immediate action - select and return. By passing False, it
³  becomes a 2 step  process, requiring click-click or
³  firstletter-firstletter to select and return.
³ 
³  [bMouse] is an optional codeblock for mouse clicks. If the
³  mouse click does not satisfy RAT_MENU2(), and there is a
³  [bMouse] codeblock, it will be evaluated as follows:
³
³               eval(bMouse,mouserow, mousecol)
³ 
³ 
³  Examples:
³  ---------
³   local aOptions := { ;
³                      {23,2 ,  'Add'},;
³                      {23,9 ,  'Open'},;
³                      {23,17 , 'Delete'},;
³                      {23,27 , 'Change Date'},;
³                      {23,42 , 'Output list'},;
³                      {23,57 , 'Purge '},;
³                      {23,74 , 'Quit'}}
³ 
³   nSelected := RAT_MENU2(aOptions,4,.f.,{|r,c| checkmouse(r,c) })
³ 
³  Source:
³  -------
³  S_RMENU2.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


