
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION POPCOLSEL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  POPCOLSEL() Popup color grid for selecting a single color
ณ 
ณ  Returns:
ณ  --------
ณ  <cColor> => selected color
ณ 
ณ  Syntax:
ณ  -------
ณ  POPCOLSEL([cStartCol])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a grid for selecting a single color (W/N,
ณ  +R/W, etc).
ณ 
ณ  If SETBLINK() is set to .f., high intensity
ณ  background colors are available, otherwise not.
ณ 
ณ  [cStartCol] is an optional starting color, which
ณ  defaults to setcolor().
ณ 
ณ  If ESCAPE is pressed, the starting color is returned.
ณ 
ณ  Examples:
ณ  ---------
ณ   setblink(.f.)
ณ   initsup()
ณ   cNewColor := popcolsel()
ณ 
ณ  Source:
ณ  -------
ณ  S_PCSEL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function popcolsel(cInColor)

  local aFore := {"N","B","G","BG","R","BR","GR","W",;
                    "N+","B+","G+","BG+","R+","BR+","GR+","W+"}
  local aBack := {"N","B","G","BG","R","BR","GR","W",;
                    "N*","B*","G*","BG*","R*","BR*","GR*","W*"}

  local nTop := 0,nLeft:= 0,nBottom,nRight := 19
  local nAtFg,nAtBg,cFg,cBg
  local nLastKey,cBox, nMouseR, nMouseC, aButtons, nButton, lClick
  local lSetBlink,nColorRows
  local cPriorColor := takeout(iif(cInColor#nil,cInColor,setcolor()),",",1)
  local cNewColor   := cPriorColor

  cFg := UPPER(left(alltrim(cPriorColor),at("/",cPriorColor)-1))
  if left(cFg,1)$"+*"
    cFg := subst(cFg,2)+"+"
  endif

  cBg := UPPER(subst(alltrim(cPriorColor),at("/",cPriorColor)+1))
  if left(cBg,1)$"*"
    cBg := subst(cBg,2)+"*"
  endif

  lSetBlink   := setblink()
  nColorRows  := iif(lSetBlink,8,16)
  nBottom     := nColorRows+5
  sbcenter(@nTop,@nLeft,@nBottom,@nRight)

  dispbegin()
  cBox := makebox(nTop,nLeft,nBottom,nRight,"N/W")
  @ nTop,nLeft+1 say " Color Selector "
  @ nBottom-3,nLeft+2 SAY "[] [] [] []"
  @ nBottom-2,nLeft+2 SAY "[ENTER=accept ]"
  @ nBottom-1,nLeft+2 SAY "[ESC=cancel   ]"
  aButtons := {{nBottom-2,nLeft+2,nBottom-2,nLeft+16,K_ENTER},;
               {nBottom-1,nLeft+2,nBottom-1,nLeft+16,K_ESC}}

  FOR nAtBg = 1 TO nColorRows
     FOR nAtFg = 1 TO 16
        @ nTop+nAtBg,nLeft+1+nAtFg SAY "*" color (aFore[nAtFg]+"/"+aBack[nAtBg])
     NEXT
  NEXT
  dispend()

  nAtFg := ascan(aFore,{|el|el==cFg})
  nAtBg := ascan(aBack,{|el|el==cBg})
  do while .t.
      @ nTop+nAtBg,nLeft+1+nAtFg SAY "X" color (aFore[nAtFg]+"/"+aBack[nAtBg])

      nMouseR := 0; nMouseC := 0
      nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
      nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
      lClick  := (nMouseR==nTop+nAtBg .and. nMouseC==nLeft+nAtFg+1)

      @ nTop+nAtBg,nLeft+1+nAtFg SAY "*" color (aFore[nAtFg]+"/"+aBack[nAtBg])
      do case
      case nLastKey = K_UP
        nAtBg := iif(nAtBg=1,nColorRows,nAtBg-1)
      case nLastKey = K_DOWN
        nAtBg := iif(nAtBg=nColorRows,1,nAtBg+1)
      case nLastKey = K_LEFT
        nAtFg := iif(nAtFg=1,16,nAtFg-1)
      case nLastKey = K_RIGHT
        nAtFg := iif(nAtFg=16,1,nAtFg+1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3, nLeft+2, nBottom-3,nLeft+4)
        nAtBg := iif(nAtBg=1,nColorRows,nAtBg-1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3, nLeft+6, nBottom-3, nLeft+8)
        nAtBg := iif(nAtBg=nColorRows,1,nAtBg+1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3, nLeft+10, nBottom-3,nLeft+12)
        nAtFg := iif(nAtFg=16,1,nAtFg+1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3,nLeft+14, nBottom-3,nLeft+16)
        nAtFg := iif(nAtFg=1,16,nAtFg-1)
      case nLastKey = K_ESC  .OR. nButton==K_ESC
        exit
      case nLastKey = K_ENTER .or. nButton==K_ENTER .or. lClick
        cNewColor := padr(left( aFore[nAtFg]+"/"+aBack[nAtBg]+space(7),7),10)
        EXIT
      case nLastKey==K_MOUSELEFT .and.;
             ISMOUSEAT(nMouseR, nMouseC,nTop+1,nLeft+2,;
                       nTop+nColorRows,nLeft+17)
        nAtFg := (nMouseC-nLeft)-1
        nAtBg := (nMouseR-nTop)
      endcase
  enddo
  unbox(cBox)
return cNewColor

