
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#translate standard(<cColor>)   => colorpart(<cColor>,1)
#translate enhanced(<cColor>)   => colorpart(<cColor>,2)
#translate unselected(<cColor>) => colorpart(<cColor>,5)

#define COLOR_NORM_STD        1
#define COLOR_NORM_ENHMENU    2
#define COLOR_NORM_UNS        3
#define COLOR_NORM_ENH        4

#define COLOR_POP_STD         5
#define COLOR_POP_ENHMENU     6
#define COLOR_POP_UNS         7
#define COLOR_POP_ENH         8

#define COLOR_SHADOW_ATT     9

#define COLOR_SHADOW_POS     10
#define COLOR_EXPLODE        11
#define COLOR_BOXFRAME       12

//---------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SETCOLORS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SETCOLORS() Interactive color setting interface
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  SETCOLORS()
ณ
ณ  Description:
ณ  ------------
ณ  This is a development tool for finding nice
ณ  combinations of colors for the global superfunction colors. I would
ณ  not give this to an end user, as it is just TOO MANY CHOICES! I
ณ  normally select 10-15 nice combinations of the colors and give
ณ  the user a selection of those, giving them such names as
ณ  'Hawaiian Blue' or 'Royal Red'. In fact, see COLPIK() for just
ณ  such a function.
ณ 
ณ  If SETBLINK() is set to False (.f.), the high
ณ  intensity colors will be available - if your monitor supports them.
ณ 
ณ  Examples:
ณ  ---------
ณ   SETCOLORS()
ณ 
ณ  Notes:
ณ  -------
ณ  First, a word on the Superfunction color scheme:
ณ 
ณ  This is not the perfect color scheme. It is the one
ณ  on which this library runs. (hey - I hadda pick something) I
ณ  also realize full well that color selection is more art than it
ณ  is technical, and it is difficult to get two people to agree on
ณ  a color scheme.
ณ 
ณ  Several global color settings are used, and they are
ณ  recorded and accessed via the functions:
ณ 
ณ     sls_normcol([cNew])    -  For normal input/output
ณ     sls_normmenu([cNew])   -  For normal 'menu to' operations
ณ     sls_popcol([cNew])     -  For popup box colors
ณ     sls_popmenu([cNew])    -  For popup box menus
ณ     sls_frame([cNew])      -  Frame string
ณ     sls_shadatt([nNew])    -  Shadow color attribute
ณ                              (numeric)
ณ     sls_shadpos([nNew])    -  Shadow position (0,1,3,7,9)
ณ     sls_xplode([lNew])     -  Logical - explode windows?
ณ
ณ     (All of the colors are of the format "f/b,f/b,,,f/b"
ณ      where f=foreground b=background)
ณ 
ณ  SETCOLORS() allows interactive setting of these
ณ  colors. The settings can stored as color sets in COLORS.DBF -
ณ  which is created if needed by SETCOLORS().
ณ 
ณ  If COLORS.DBF is not present, SuperLib will use a
ณ  default set of colors.
ณ 
ณ  See the SATT*() functons, and the SLS_*() functions
ณ  for more info.
ณ 
ณ  See the appendix for more general colors info.
ณ 
ณ  See the upgrade notes for more info on upgrading from
ณ  older SuperLibs, which used a public variable scheme.
ณ 
ณ  Source:
ณ  -------
ณ  S_SETCOL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION setcolors()
local nMenuSelection
local aMenuChoices := array(5)
local aMenuAttr  := {.T.,"W/N,N/W,,,+GR/N","N/W,W/N,,,+GR/N","ฺฤฟณูฤภณ ",0,0,0}
local nOldCursor    := setcursor(0)
local cInScreen     := Savescreen(0,0,24,79)
local cInColor      := Setcolor("W/N,N/W,,,+W/N")
local nOldArea      := SELE()
local aColorset     := getset()
sAttPush()      // push current colors
SELE 0


aMenuChoices[1] := "Box Frame:1.ษอป All Double :2.ีอธ Top Double :3.ึฤท Side Double :4.ฺฤฟ All Single:5.    No Frame"
aMenuChoices[2] := "Shadow Position:1.Lower left:2.Lower right:3.Upper right:4.Upper left:5.None"
aMenuChoices[3] := "Explode:Exploding"
aMenuChoices[4] := "Colors:1.Normal Screen Text:2.Normal Screen Menu:3.Normal Screen Unedited Field:4.Normal Screen Edited Field:5.Popup Screen Text:6.Popup Screen Menu:7.Popup Screen Unedited Field:8.Popup Screen Edited Field:9.Shadow Color"
aMenuChoices[5] := "Quit:Quit:Save Color Set:Restore a Color Set"


*- draw the screen
drawscreen(aColorSet)
nMenuSelection := 1.01
DO WHILE .T.
  nMenuSelection := pulldn(nMenuSelection, aMenuChoices,aMenuAttr)
  
  DO CASE
  CASE nMenuSelection = 1.01
    aColorSet[COLOR_BOXFRAME] := "ษอปบผอศบ "
    paint(1,aColorSet)
  CASE nMenuSelection = 1.02
    aColorSet[COLOR_BOXFRAME] := "ีอธณพอิณ "
    paint(1,aColorSet)
  CASE nMenuSelection = 1.03
    aColorSet[COLOR_BOXFRAME] := "ึฤทบฝฤำบ "
    paint(1,aColorSet)
  CASE nMenuSelection = 1.04
    aColorSet[COLOR_BOXFRAME] := "ฺฤฟณูฤภณ "
    paint(1,aColorSet)
  CASE nMenuSelection = 1.05
    aColorSet[COLOR_BOXFRAME] := "         "
    paint(1,aColorSet)

  CASE nMenuSelection = 2.01
    aColorSet[COLOR_SHADOW_POS] := 1
    paint(9,aColorSet)
  CASE nMenuSelection = 2.02
    aColorSet[COLOR_SHADOW_POS] :=3
    paint(9,aColorSet)
  CASE nMenuSelection = 2.03
    aColorSet[COLOR_SHADOW_POS] :=9
    paint(9,aColorSet)
  CASE nMenuSelection = 2.04
    aColorSet[COLOR_SHADOW_POS] :=7
    paint(9,aColorSet)
  CASE nMenuSelection = 2.05
    aColorSet[COLOR_SHADOW_POS] :=0
    paint(9,aColorSet)

  CASE nMenuSelection = 3.01

    IF aColorSet[COLOR_EXPLODE] .AND. messyn("Turn Explosions OFF?")
      aColorSet[COLOR_EXPLODE] :=.F.
    ELSEIF !aColorSet[COLOR_EXPLODE] .AND. messyn("Turn Explosions ON?")
      aColorSet[COLOR_EXPLODE] :=.T.
    ENDIF

  CASE nMenuSelection = 4.01
    colselect(1,aColorSet)
  CASE nMenuSelection = 4.02
    colselect(2,aColorSet)
  CASE nMenuSelection = 4.03
    colselect(3,aColorSet)
  CASE nMenuSelection = 4.04
    colselect(4,aColorSet)
  CASE nMenuSelection = 4.05
    colselect(5,aColorSet)
  CASE nMenuSelection = 4.06
    colselect(6,aColorSet)
  CASE nMenuSelection = 4.07
    colselect(7,aColorSet)
  CASE nMenuSelection = 4.08
    colselect(8,aColorSet)
  CASE nMenuSelection = 4.09
    colselect(9,aColorSet)

  CASE nMenuSelection = 5.02
    savecolors(aColorSet)
  CASE nMenuSelection = 5.03   // restore a color set
    sAttPick()
    aColorset    := getset()
    paint(1,aColorSet)
  CASE nMenuSelection = 5.01 .or. nMenuSelection = 0
    sAttPop()
    if messyn("Make the current color set ?")
      storecolors(aColorSet)
    endif
    EXIT
  ENDCASE
ENDDO
*- restore the environment
SETCURSOR(nOldCursor)
Setcolor(cInColor)
Restscreen(0,0,24,79,cInScreen)
SELE (nOldArea)
RETURN ''
//-----------------------------------------------------------

//------------------------------------------------------------------------------
static FUNCTION drawscreen(aColorSet)
DISPBOX(0,0,24,79,space(9))
// bxx(6,60,23,79,8,0,0,'',0)
// c_grid(7,62)
paint(1,aColorSet)
RETURN NIL

//------------------------------------------------------------------------------
static FUNCTION paint(nColor,aColorSet)
dispbegin()
DO CASE
CASE nColor = 1
  dispbox(6,1,23,58,aColorSet[COLOR_BOXFRAME],aColorSet[COLOR_NORM_STD])
  dispbox(14,2,22,57,repl(chr(176),9),aColorSet[COLOR_NORM_STD])
  @ 6,8 say "[MAIN SCREEN]" color aColorSet[COLOR_NORM_STD]
  paint(2,aColorSet)
  paint(3,aColorSet)
  paint(4,aColorSet)
  paint(5,aColorSet)
CASE nColor = 2
  @ 08,9 say    "Normal Screen Menu          " color aColorSet[COLOR_NORM_ENHMENU]
CASE nColor = 3
  @10,9 say  "Normal Screen Unedited Field" color aColorSet[COLOR_NORM_UNS]
CASE nColor = 4
  @12,9 say  "Normal Screen Edited Field  " color aColorSet[COLOR_NORM_ENH]
CASE nColor = 5
  dispbox(23,17,23,54,aColorSet[COLOR_BOXFRAME],aColorSet[COLOR_NORM_STD])
  dispbox(14,17,22,54,"ฐฐฐฐฐฐฐฐฐ",aColorSet[COLOR_NORM_STD])
  DO CASE
  CASE aColorSet[COLOR_SHADOW_POS] = 7
    att(14,17,21,52,aColorSet[COLOR_SHADOW_ATT])
  CASE aColorSet[COLOR_SHADOW_POS] = 1
    att(16,17,23,52,aColorSet[COLOR_SHADOW_ATT])
  CASE aColorSet[COLOR_SHADOW_POS] = 3
    att(16,19,23,54,aColorSet[COLOR_SHADOW_ATT])
  CASE aColorSet[COLOR_SHADOW_POS] = 9
    att(14,19,21,54,aColorSet[COLOR_SHADOW_ATT])
  ENDCASE
  dispbox(15,18,22,53,aColorSet[COLOR_BOXFRAME],aColorSet[COLOR_POP_STD])
  @ 15,21 say  "[Popup Box]" color aColorSet[COLOR_POP_STD]
  paint(6,aColorSet)
  paint(7,aColorSet)
  paint(8,aColorSet)
CASE nColor = 6
  @17,22  say "Popup Screen Menu           " color aColorSet[COLOR_POP_ENHMENU]
CASE nColor = 7
  @ 19,22 say "Popup Screen Unedited Field " color aColorSet[COLOR_POP_UNS]
CASE nColor = 8
  @21,22 say "Popup Screen Edited Field   " color aColorSet[COLOR_POP_ENH]
CASE nColor = 9
  paint(5,aColorSet)
ENDCASE
dispend()
return nil

//------------------------------------------------------------
static function colorpart(cIncolor,nPosit)
local cSetcolor   := takeout(cIncolor,",",nPosit)
cSetColor   := iif(empty(cSetColor),"W/N",cSetColor)
RETURN cSetColor

//------------------------------------------------------------
static function getset
local aColorSet := array(12)

aColorSet[COLOR_NORM_STD]     := standard(sls_normcol())
aColorSet[COLOR_NORM_UNS]     := unselected(sls_normcol())
aColorSet[COLOR_NORM_ENH]     := enhanced(sls_normcol())
aColorSet[COLOR_NORM_ENHMENU] := enhanced(sls_normmenu())

aColorSet[COLOR_POP_STD]      := standard(sls_popcol())
aColorSet[COLOR_POP_ENH]      := enhanced(sls_popcol())
aColorSet[COLOR_POP_UNS]      := unselected(sls_popcol())
aColorSet[COLOR_POP_ENHMENU] := enhanced(sls_popmenu())

aColorSet[COLOR_SHADOW_ATT]   := sls_shadatt()
aColorSet[COLOR_SHADOW_POS]   := sls_shadpos()

aColorSet[COLOR_EXPLODE]      := sls_xplode()
aColorSet[COLOR_BOXFRAME]     := sls_frame()

return (aColorSet)

//-----------------------------------------------------------
static FUNCTION storecolors(aColorSet)
sls_normcol(aColorSet[COLOR_NORM_STD]+','+aColorSet[COLOR_NORM_ENH]+',,,'+aColorSet[COLOR_NORM_UNS])
sls_normmenu(aColorSet[COLOR_NORM_STD]+','+aColorSet[COLOR_NORM_ENHMENU]+',,,'+aColorSet[COLOR_NORM_UNS] )
sls_popcol( aColorSet[COLOR_POP_STD]+','+aColorSet[COLOR_POP_ENH]+',,,'+aColorSet[COLOR_POP_UNS] )
sls_popmenu( aColorSet[COLOR_POP_STD]+','+aColorSet[COLOR_POP_ENHMENU]+',,,'+aColorSet[COLOR_POP_UNS])
sls_shadatt( aColorSet[COLOR_SHADOW_ATT] )
sls_shadpos( aColorSet[COLOR_SHADOW_POS] )
sls_xplode( aColorSet[COLOR_EXPLODE] )
sls_frame ( aColorset[COLOR_BOXFRAME] )
return nil
//------------------------------------------------------------
static FUNCTION savecolors(aColorSet)
storecolors(aColorSet)
sAttPickPut()
RETURN ''


static function calign(cColor)
if left(cColor,1)=="+"
  cColor := subst(cColor,2)+"+"
elseif left(cColor,1)=="+"
  cColor := subst(cColor,2)
endif
return nil


static Function colselect(nColor,aColorSet)

  local cInColor := strtran(iif(nColor==9,at2char(aColorSet[nColor]),aColorSet[nColor]),"RB","BR")
  local aFore := {"N","B","G","BG","R","BR","GR","W",;
                    "N+","B+","G+","BG+","R+","BR+","GR+","W+"}
  local aBack := {"N","B","G","BG","R","BR","GR","W",;
                    "N*","B*","G*","BG*","R*","BR*","GR*","W*"}

  local nTop := 1,nLeft:= 60,nBottom,nRight := 79
  local nAtFg,nAtBg,cFg,cBg
  local nLastKey,cBox, nMouseR, nMouseC, aButtons, nButton, lClick
  local lSetBlink,nColorRows
  local cNewColor := alltrim(takeout(iif(cInColor#nil,;
                         cInColor,setcolor()),",",1))

  cFg := UPPER(left(cNewColor,at("/",cNewColor)-1))
  if left(cFg,1)$"+*"
    cFg := subst(cFg,2)+"+"
  endif

  cBg := UPPER(subst(cNewColor,at("/",cNewColor)+1))
  if left(cBg,1)$"*"
    cBg := subst(cBg,2)+"*"
  endif

  lSetBlink   := setblink()
  nColorRows  := iif(lSetBlink,8,16)
  nBottom     := nColorRows+5+1

  dispbegin()
  cBox := makebox(nTop,nLeft,nBottom,nRight,"N/W")
  @ nTop,nLeft+1 say " Color Selector "
  @ nBottom-3,nLeft+2 SAY "[] [] [] []"
  @ nBottom-2,nLeft+2 SAY "[ENTER=accept ]"
  aButtons := {{nBottom-2,nLeft+2,nBottom-2,nLeft+16,K_ENTER}}
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
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3, nLeft+2,nBottom-3, nLeft+4)
         nAtBg := iif(nAtBg=1,nColorRows,nAtBg-1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3, nLeft+6,nBottom-3, nLeft+8)
        nAtBg := iif(nAtBg=nColorRows,1,nAtBg+1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3, nLeft+10,nBottom-3,nLeft+12)
        nAtFg := iif(nAtFg=16,1,nAtFg+1)
      case ISMOUSEAT(nMouseR, nMouseC, nBottom-3,nLeft+14,nBottom-3,nLeft+16)
        nAtFg := iif(nAtFg=1,16,nAtFg-1)
      case nLastKey = K_ESC
        exit
      case nLastKey = K_ENTER .or. nButton==K_ENTER .or. lClick
        EXIT
      case nLastKey==K_MOUSELEFT .and. ;
        ISMOUSEAT(nMouseR, nMouseC,nTop+1,nLeft+2,nTop+nColorRows,nLeft+17)
        nAtFg := (nMouseC-nLeft)-1
        nAtBg := (nMouseR-nTop)
      endcase
      *- assign internal color var these new values
      cNewColor := aFore[nAtFg]+"/"+aBack[nAtBg]
      if nColor==9
        aColorSet[nColor] = ((nAtBg-1)*16)+nAtFg-1
      else
        aColorSet[nColor] = cNewColor
      endif
      *- and re-paint it
      paint(nColor,aColorSet)
  enddo
  unbox(cBox)
return NIL





