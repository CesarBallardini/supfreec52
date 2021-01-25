#include "inkey.ch"

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SGETMANY()                           *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SGETMANY()    Virtual (scrolling)  gets in a popup box
ณ 
ณ  Returns:
ณ  --------
ณ  <lSave> => False if ESC pressed, true otherwise
ณ 
ณ  Syntax:
ณ  -------
ณ  SGETMANY(aGets,aDesc,nTop,nLeft,nBottom,nRight,[cTitle],[cFoot],[nPadding])
ณ 
ณ  Description:
ณ  ------------
ณ  READs a series of GETs in a popup box, with the
ณ  ability to scroll the GETs up/down when there are more GETs than fit in
ณ  the box.
ณ 
ณ  <aGets> is an array of get objects. There are two
ณ  ways to create this:
ณ 
ณ      1.    Use GETNEW() (the Clipper function) to create each
ณ            individual get object. Get row and column do not
ณ            matter - they will be adjusted.
ณ 
ณ            GET postblock and preblock (valid and when)
ณ            may be assigned as normal. As each new GET object is created,
ณ            add it to an array.
ณ 
ณ            Pass this array as <aGets>.
ณ 
ณ      2.    Use the normal @row,col GET... commands, but to a
ณ            location off the screen - otherwise the gets will DISPLAY
ณ            as you are assigning them.
ณ 
ณ            @MAXROW()+1,MAXCOL()+1 GET... works for me.
ณ 
ณ  Using @...GET automatically places new get
ณ  objects in the global array GETLIST. Pass GETLIST as <aGets>.
ณ 
ณ  <aDesc> this is an array of descriptions for each
ณ  get. (the SAY portion). These will be displayed to the left of
ณ  the get.
ณ 
ณ  <nTop,nLeft,nBottom,nRight> are the dimensions of the
ณ  popup box. The Editing area will be the inside dimensions of this
ณ  box. Make sure there's room!
ณ 
ณ  [cTitle] is a string to be used for the title.
ณ  Displayed at <nTop>,<nLeft>+1
ณ 
ณ  [cFoot] is now ignored. This parameter used to be the footer. It
ณ  is now just a placeholder for downward compatibility.
ณ 
ณ  [nPadding] is for the number of spaces of padding
ณ  between the box frame and the editing area. The default is 0,
ณ  which places the editing area at
ณ  nTop+1,nLeft+1,nBottom-1,nRight-1. A [nPadding] of 1 would place
ณ  the editing area at nTop+2,nLeft+2,nBottom-2,nRight-2 etc.
ณ 
ณ  Examples:
ณ  ---------
ณ 
ณ   local i
ณ   local aDesc := {}
ณ   local aGets
ณ   USE CUSTOMER
ณ   aGets := dbf2array()
ณ 
ณ   for i = 1 to len(aGets)
ณ     @maxrow()+1,maxcol()+1 get aGets[i]
ณ     aadd(aDesc,field(i))
ณ   next
ณ 
ณ   SGETMANY(getlist,aDesc,10,10,17,50,;
ณ         "Editing","ESC quits, F10 saves",1)
ณ 
ณ  NOTES:
ณ  -------
ณ  Do not pass a 0 length string as a GET
ณ 
ณ  Source:
ณ  -------
ณ  S_GETMANY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sgetmany(aGets,aDesc,nTop,nLeft,nBottom,nRight,cTitle,cFoot,nPadding)
local cScreen,oTb
local nElement := 1
local nLastKey
local oThisGet,nRow,nCol
local cRightFrame := subst(sls_frame(),4,1)
local lReadExit := ratexit(.t.)
local bF10
local nWidth1,nWidth2
local aBlocks := {}
local lSave   := .t.
local nMouseR, nMouseC,i
nPadding := iif(nPadding#nil,nPadding,0)
cFoot  := "ESC=quit    F10=save"

for i = 1 to len(aGets)
  if aGets[i]:type=="C"
    if len(aGets[i]:varget())==0
      aGets[i]:varput(" ")
    endif
  endif
next

if (nBottom-nTop-1-nPadding) > 0
    bF10 := setkey(K_F10,{||CTRLW()})
    cScreen := makebox(ntop,nLeft,nbottom,nright,sls_popcol())
    cFoot  := iif(cFoot #nil,cFoot ,"")
    cTitle := iif(cTitle#nil,cTitle,"")
    @nTop,nLeft+1    say cTitle
    @nBottom,nLeft+1 say cFoot
    oTb := tbrowseNew(nTop+1+nPadding,nLeft+1+nPadding,nBottom-1-nPadding,nRight-1-nPadding)
    oTb:addcolumn(tbcolumnNew(nil,{||aDesc[nElement]} ))
    oTb:addcolumn(tbcolumnNew(nil,{||trans(aGets[nElement]:varget(),"")} ))
    oTb:SKIPBLOCK :={|n|aaskip(n,@nElement,LEN(aGets))}
    oTb:gobottomblock := {||nElement := len(aGets)}
    oTb:gotopblock  := {||nElement := 1}
    oTb:getcolumn(1):width := (nWidth1 := bigelem(aDesc))
    oTb:getcolumn(2):width := (nWidth2 := (nRight-nLeft-4)-nWidth1-(nPadding*2))
    oTb:colorspec := takeout(setcolor(),",",5)+","+takeout(setcolor(),",",5)
    oTb:configure()
    oTb:freeze := 1
    oTb:colpos := 2
    for i = 1 to len(aGets)
      aGets[i]:picture := makepicture(aGets[i]:picture,nWidth2)
    next
    DO WHILE .T.
       dispbegin()
        oTb:refreshall()
        WHILE !oTb:STABILIZE()
        END
        nRow := row()
        nCol := col()
        devpos(nTop+1,nRight)
        devout(iif(nElement>1,chr(30),cRightFrame),sls_popcol() )
        devpos(nbottom-1,nRight)
        devout(iif(nElement<LEN(aGets),chr(31),cRightFrame ),sls_popcol() )
        setpos(nRow,nCol)
       dispend()
       oThisGet := aGets[nElement]
       oThisGet:row := nRow
       oThisGet:col := nCol
       is_sb(.f.)
       rat_read({oThisGet},1,.f.,27,{|r,c|checkmoose(r,c,oTb,nTop,nLeft,nBottom,nRight)})
       nLastKey := rat_lastev()
       nMouseR := rat_eqmrow()
       nMouseC := rat_eqmcol()


       do case
       CASE nLastKey = K_PGUP        && UP ONE PAGE
         oTb:PAGEUP()
       CASE nLastKey = K_UP
         oTb:UP()
         while nextkey()==K_UP .or. (is_sb() .and. RAT_ELBHD() )
          oTb:UP()
          while !oTb:stabilize()
          end
          INKEY()
         end
       CASE nLastKey = K_DOWN  .or. nLastKey = K_ENTER
         oTb:DOWN()
         if nLastKey<>K_ENTER
          while nextkey()==K_DOWN  .or. (is_sb() .and. RAT_ELBHD() )
           oTb:DOWN()
           while !oTb:stabilize()
           end
           INKEY()
          end
         endif
       CASE nLastKey = K_PGDN        && DOWN ONE PAGE
         oTb:PAGEdOWN()
       case nLastKey = K_F10 .OR. nLastkey = K_CTRL_W
         EXIT
       case nLastKey = K_ESC
         lSave := .f.
         EXIT
       endcase
    ENDDO
    unbox(cScreen)
    setkey(K_F10,bF10)
endif
aSize(aGets,0)
ratexit(lReadExit)
return lSave

//------------------------------------------------------------
static function checkmoose(nMouseR, nMouseC, oTb,nTop,nLeft,nBottom,nRight)
do case
case nMouseR==nTop+1 .and. nMouseC==nRight // up
  keyboard chr(K_UP)
  is_sb(.t.)
case nMouseR==nBottom-1 .and. nMouseC==nRight // down
  keyboard chr(K_DOWN)
  is_sb(.t.)
case nMouseR==nBottom .and. (nMouseC>=nLeft+1 .and. nMousec<=nLeft+8) //esc
  keyboard chr(K_ESC)
case nMouseR==nBottom .and. (nMouseC>=nLeft+13 .and. nMouseC<=nLeft+20) //F10
  keyboard chr(K_CTRL_END)
case nMouseR >= nTop+1 .and. nMouseR<=nBottom-1 .and. ;
    nMouseC>=nLeft+1 .and. nMouseC<=nRight-1
  if nMouseR > row()
     keyboard repl(chr(K_DOWN),nMouseR-row())
  elseif nMouseR < row()
     keyboard repl(chr(K_UP),row()-nMouseR)
  endif
endcase
return nil


//------------------------------------------------------------

static function makepicture(cPicture,nWidth)
local cNewPict
IF empty(cPicture)
  cNewPict := "@S"+alltrim(str(nWidth))
ELSEIF "@"$cPicture
  cNewPict := "@S"+alltrim(str(nWidth))+subst(cPicture,2)
ELSE
  cNewPict := "@S"+alltrim(str(nWidth))+" "+ALLTRIM(cPicture)
ENDIF
return cNewPict


//----------------
static function is_sb(lNew)
static lSb := .f.
if lNew#nil
  lSb := lNew
endif
return lSb

