#include "inkey.ch"

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SGETMANY()                           *changed*
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SGETMANY()    Virtual (scrolling)  gets in a popup box
³ 
³  Returns:
³  --------
³  <lSave> => False if ESC pressed, true otherwise
³ 
³  Syntax:
³  -------
³  SGETMANY(aGets,aDesc,nTop,nLeft,nBottom,nRight,[cTitle],[cFoot],[nPadding])
³ 
³  Description:
³  ------------
³  READs a series of GETs in a popup box, with the
³  ability to scroll the GETs up/down when there are more GETs than fit in
³  the box.
³ 
³  <aGets> is an array of get objects. There are two
³  ways to create this:
³ 
³      1.    Use GETNEW() (the Clipper function) to create each
³            individual get object. Get row and column do not
³            matter - they will be adjusted.
³ 
³            GET postblock and preblock (valid and when)
³            may be assigned as normal. As each new GET object is created,
³            add it to an array.
³ 
³            Pass this array as <aGets>.
³ 
³      2.    Use the normal @row,col GET... commands, but to a
³            location off the screen - otherwise the gets will DISPLAY
³            as you are assigning them.
³ 
³            @MAXROW()+1,MAXCOL()+1 GET... works for me.
³ 
³  Using @...GET automatically places new get
³  objects in the global array GETLIST. Pass GETLIST as <aGets>.
³ 
³  <aDesc> this is an array of descriptions for each
³  get. (the SAY portion). These will be displayed to the left of
³  the get.
³ 
³  <nTop,nLeft,nBottom,nRight> are the dimensions of the
³  popup box. The Editing area will be the inside dimensions of this
³  box. Make sure there's room!
³ 
³  [cTitle] is a string to be used for the title.
³  Displayed at <nTop>,<nLeft>+1
³ 
³  [cFoot] is now ignored. This parameter used to be the footer. It
³  is now just a placeholder for downward compatibility.
³ 
³  [nPadding] is for the number of spaces of padding
³  between the box frame and the editing area. The default is 0,
³  which places the editing area at
³  nTop+1,nLeft+1,nBottom-1,nRight-1. A [nPadding] of 1 would place
³  the editing area at nTop+2,nLeft+2,nBottom-2,nRight-2 etc.
³ 
³  Examples:
³  ---------
³ 
³   local i
³   local aDesc := {}
³   local aGets
³   USE CUSTOMER
³   aGets := dbf2array()
³ 
³   for i = 1 to len(aGets)
³     @maxrow()+1,maxcol()+1 get aGets[i]
³     aadd(aDesc,field(i))
³   next
³ 
³   SGETMANY(getlist,aDesc,10,10,17,50,;
³         "Editing","ESC quits, F10 saves",1)
³ 
³  NOTES:
³  -------
³  Do not pass a 0 length string as a GET
³ 
³  Source:
³  -------
³  S_GETMANY.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

