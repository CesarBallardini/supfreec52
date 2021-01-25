
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
//-----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SCONVDELIM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SCONVDELIM() Convert a delimited file to a DBF
ณ 
ณ  Returns:
ณ  --------
ณ  None
ณ 
ณ  Syntax:
ณ  -------
ณ  SCONVDELIM()
ณ 
ณ  Description:
ณ  ------------
ณ  This allows the user to create a DBF file from a
ณ  delimited file.
ณ 
ณ  Several options for defining the delimited file are
ณ  available.
ณ 
ณ  Examples:
ณ  ---------
ณ   use CUSTOMER
ณ 
ณ   SCONVDELIM()
ณ 
ณ  Source:
ณ  -------
ณ  S_CVTDEL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sconvdelim()
local cCharDelim  := ["]  // double quot
local cFieldDelim := [,]  // comma
local i
LOCAL nOldCursor     := setcursor(0)
LOCAL cInScreen      := Savescreen(0,0,24,79)
LOCAL cOldColor      := Setcolor(sls_normcol())
local nMenuChoice
local cInFile        := ""
local aNames       := {}
local aTypes       := {}
local aLens        := {}
local aDeci        := {}

*- draw boxes
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,12,40 BOX sls_frame()
@1,5 SAY '[Convert to DBF from DELIMITED]'
@20,1,23,78 BOX sls_frame()

DO WHILE .T.
  Setcolor(sls_popmenu())
  nMenuChoice := RAT_MENU2({;
        {03,3 ,"Select DELIMITED file  "+padr(cInFile,12)},;
        {04,3 ,"Define DELIMITED file fields "},;
        {05,3 ,"Write DBF file from DELIMITED file"},;
        {08,3 ,"Quit"}},nMenuChoice)

  Setcolor(sls_popcol())

  DO CASE
  CASE nMenuChoice = 0 .or. nMenuChoice = 4
      exit
  CASE nMenuChoice = 1
      cInfile := pickfile()
      aNames       := {}
      aTypes       := {}
      aLens        := {}
      aDeci        := {}
  CASE nMenuChoice = 2  .and. !empty(cInFile) // define ascii file
      popread(.t.,"CHARACTER field delimiter",@cCharDelim,"",;
                  "Field/Field delimiter",@cFieldDelim,"")
      ddelim(cInfile,cCharDelim,cFieldDelim,aNames,aTypes,aLens,aDeci)
  CASE nMenuChoice = 3 .and. len(aNames) =0
      msg("You must define the datafile first")
  CASE nMenuChoice = 3 .and. len(aNames) > 0
      if OK2EXPORT(aNames,aTypes,aLens,aDeci)
        export(cInfile,aNames,aTypes,aLens,aDeci,cCharDelim,cFieldDelim)
      endif
  ENDCASE
END
Restscreen(0,0,24,79,cInScreen)
Setcolor(cOldColor)
setcursor(nOldCursor)
return nil

//-----------------------------------------------------------------
static function pickfile
local cFile := popex("*.*")
return cFile
//-----------------------------------------------------------------
static funct ddelim(cInfile,cCharDelim,cFieldDelim,aNames,aTypes,aLens,aDeci)
local nLastkey,cLastkey, nMouseR, nMouseC, aButtons, nButton
local cThisLine
local i,oTb
local nHandle := fopen(cInFile,64)
local nTop    := 1
local nLeft   := 1
local nBottom := 23
local nRight  := 78
local cInscreen := makebox(nTop,nLeft,nBottom,nRight,sls_popcol())
local nFields   := countfields(nHandle,cFieldDelim)
local nWidth,cType,nPosit,cName,nDeci
asize(aNames,nFields)
asize(aTypes,nFields)
asize(aLens,nFields)
asize(aDeci,nFields)
for i = 1 to nFields
  aNames[i] := iif(aNames[i]==nil,"FIELD"+alltrim(str(i)),aNames[i])
  aTypes[i] := iif(aTypes[i]==nil,"C",aTypes[i])
  aLens[i] := iif(aLens[i]==nil,0,aLens[i])
  aDeci[i] := iif(aDeci[i]==nil,0,aDeci[i])
next


@ 21,2 SAY "ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
@ 22,2 SAY "[ENTER=Edit Field Def]  [S=Scan Widths]  [Q =Quit]  [] [] [] []         "
aButtons := {;
            {22,2,22,23,K_ENTER},;
            {22,26,22,40,ASC("S")},;
            {22,43,22,51,ASC("Q")},;
            {22,54,22,56,K_UP},;
            {22,58,22,60,K_DOWN},;
            {22,62,22,64,K_RIGHT},;
            {22,66,22,68,K_LEFT} }
IF Ferror() <> 0
  msg("Error opening file : "+cInFile)
  unbox(cInScreen)
  RETURN ''
ENDIF

oTb := tbrowsenew(nTop+1,nLeft+1,nBottom-3,nRight-1)
for i = 1 to len(aTypes)
  oTb:addcolumn(tbcolumnnew("Name:"+aNames[i]+";Type:"+atypes[i]+";Len:"+alltrim(str(aLens[i]))+";Deci:"+alltrim(str(aDeci[i])),;
                cvmakeb(i,aTypes,aLens,cFieldDelim,cCharDelim,nHandle) ))
next

oTb:skipblock     := {|n|cvd_tskip(n,nHandle)}
oTb:gotopblock    := {||cvd_ftop(nHandle)}
oTb:gobottomblock := {||cvd_fbot(nHandle)}
oTb:headsep := "ฤ"
oTb:colsep := "ณ"
oTb:colorspec := sls_normcol()

while .T.
  DISPBEGIN()
  @ 22,2 SAY "[ENTER=Edit Field Def]  [S=Scan Widths]  [Q =Quit]  [] [] [] []         " color sls_normcol()
  while !oTb:stabilize()
  end
  DISPEND()
  nMouseR := 0; nMouseC := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)

  cLastkey := upper(chr(nLastkey))
  nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  do case
  case nLastKey == K_UP .or. nButton == K_UP
    oTb:UP()
    if nButton == K_UP
      IFMOUSEHD({||oTb:up()},oTb)
    endif
  case nLastKey == K_DOWN .or. nButton == K_DOWN
    oTb:down()
    if nButton == K_DOWN
      IFMOUSEHD({||oTb:down()},oTb)
    endif
  case nLastKey == K_PGUP
    oTb:PAGEUP()
  case nLastKey == K_PGDN
    oTb:PAGEdown()
  case nLastKey == K_HOME
    oTb:gotop()
  case nLastKey == K_END
    oTb:gobottom()
  case nLastKey == K_LEFT  .or. nButton == K_LEFT
    oTb:left()
    if nButton == K_LEFT
      IFMOUSEHD({||oTb:left()},oTb)
    endif
  case nLastKey == K_RIGHT .or. nButton == K_RIGHT
    oTb:right()
    if nButton == K_RIGHT
      IFMOUSEHD({||oTb:right()},oTb)
    endif
  case nLastkey == K_ENTER .or. nbutton==K_ENTER
    nPosit := oTb:colpos
    cName  := padr(aNames[nPosit],10)
    ctype  := padr(aTypes[nPosit],1)
    nWidth := aLens[nPosit]
    nDeci  := aDeci[nPosit]
    getfdef(@cName,@cType,@nWidth,@nDeci,aNames,nPosit)
    aNames[nPosit]          :=       cName
    aTypes[nPosit]          :=       ctype
    aLens[nPosit]           :=       nWidth
    aDeci[nPosit]           :=       nDeci
    oTb:setcolumn(nPosit,tbcolumnnew("Name:"+aNames[nPosit]+";Type:"+atypes[nPosit]+";Len:"+alltrim(str(aLens[nPosit]))+";Deci:"+alltrim(str(aDeci[nPosit])),;
                  cvmakeb(nPosit,aTypes,aLens,cFieldDelim,cCharDelim,nHandle) ))
    oTb:configure()
    oTb:refreshall()

  case cLastkey=="S"  .or. nButton==ASC("S")
    @ 22,2 SAY PADR("Scanning...ESC to stop...",nRight-nLeft-1)
    scanit(nHandle,aLens,cFieldDelim,aTypes)
    for i = 1 to len(aLens)
      oTb:setcolumn(i,tbcolumnnew("Name:"+aNames[i]+";Type:"+atypes[i]+";Len:"+alltrim(str(aLens[i]))+";Deci:"+alltrim(str(aDeci[i])),;
                  cvmakeb(i,aTypes,aLens,cFieldDelim,cCharDelim,nHandle) ))
    next
  case cLastkey=="Q"  .or. nbutton==ASC("Q") .or. nLastKey==K_ESC
    exit
  case MBRZMOVE(oTb,nMouseR,nMouseC,nTop+6,nLeft+1,nBottom-3,nRight-1)
  case MBRZCLICK(oTb,nMouseR,nMouseC)
     keyboard chr(K_ENTER)

  endcase
end
fclose(nHandle)
unbox(cInscreen)
return nil


//--------------------------------------------------------------------------
static FUNCTION cvd_fbot(nHandle)
FSEEK(nHandle,0,2)
RETURN ''


//--------------------------------------------------------------------------
static FUNCTION cvd_ftop(nHandle)
FSEEK(nHandle,0)
RETURN ''

//--------------------------------------------------------------
static function cvd_tskip(n,nHandle)
local nMoved   := 0
if n > 0
  while nMoved < n
    if fmove2next(nHandle)
      nMoved++
    else
      exit
    endif
  end
elseif n < 0
  while nMoved > n
    if fmove2prev(nHandle)
      nMoved--
    else
      exit
    endif
  end
endif
return nMoved

//--------------------------------------------------------------------------
static function cvmakeb(i,aTypes,aLens,cFieldDel,cCharDel,nHandle)
local bBlock
do case
case aTypes[i]=="C"
*  bBlock := {||cRemove(padr(takeout(sfreadline(nHandle),cFieldDel,i),iif(aLens[i]#0,aLens[i],10)),cCharDel)  }
  bBlock := {||padr(cRemove(takeout(sfreadline(nHandle),cFieldDel,i),cCharDel),iif(aLens[i]#0,aLens[i],10))}
case aTypes[i]=="N"
  bBlock := {||padl(takeout(sfreadline(nHandle),cFieldDel,i),iif(aLens[i]#0,aLens[i],10)) }
case aTypes[i]=="D"
  bBlock := {||stod(takeout(sfreadline(nHandle),cFieldDel,i)) }
case aTypes[i]=="L"
  bBlock := {||iif(takeout(sfreadline(nHandle),cFieldDel,i)=="T",.t.,.f.) }
case aTypes[i]=="?"
  bBlock := {||padr(takeout(sfreadline(nHandle),cFieldDel,i),iif(aLens[i]#0,aLens[i],10)) }
endcase
return bBlock

//--------------------------------------------------------------------------
static function cremove(cStr,cKill)
return strtran(cStr,cKill,'')
//-------------------------------------------------
static function countfields(nHandle,cDelim)
local cLine := sfreadline(nHandle)
local i
local nDelim := 0
for i = 1 to len(cLine)
  if subst(cLine,i,1)==cDelim
    nDelim++
  endif
next
return (nDelim+1)

//-----------------------------------------------------------
static function scanit(nHandle,aLens,cFieldDelim,aTypes)
local nPosit,i,nCount
local cThisLine
nPosit := FSEEK(nHandle,0,1)
cvd_fTop(nHandle)
nCount := 0
//while inkey()#27 .and. !rat_rightb()
while !RAT_CHECKESC()
  if !empty((cThisLine:= sfreadline(nHandle)))
    for i = 1 to len(aLens)
      if aTypes[i]=="C"
        aLens[i] := max(aLens[i],len(takeout(cThisLine,cFieldDelim,i)))
      endif
    next
  else
    exit
  endif
  if !fmove2next(nHandle)
    exit
  endif
  nCount++
  @22,28 say alltrim(str(nCount))
  ??" records checked.."
  ??"("+alltrim(str(fseek(nHandle,0,1)))+")"
end
fseek(nHandle,nPosit)
return nil

//-------------------------------------------------------
static funct getfdef(cName,cType,nLen,nDec,aNames,nPosit)
local inbox := makebox(7,17,16,58)
memvar getlist
@ 8,19  SAY "Field Name"
@ 10,19 SAY "Field Type          (CDNL)"
@ 12,19 SAY "Field Length"
@ 14,19 SAY "Field Decimals"
@8,35  get cName valid nameval(cName,aNames,nPosit) picture "@K !!!!!!!!!!"
@10,35 get cType valid TypeVal(cType,@nLen,@nDec)  PICTURE "!"
@12,35 get nLen  when cType$"CN" valid LenVal(cType,nLen,@nDec)  // dec passed by ref
@14,35 get nDec  when cTYPE=="N" valid DecVal(cType,nLen,@nDec)  // dec passed
SETCURSOR(1)
rat_read(getlist,1,.f.,27,{||ctrlw()})
SETCURSOR(0)
unbox(inbox)
return nil

//-----------------------------------------------------------
static function nameval(cName,aNames,nPosit)
local lReturn := .t.
local nScanFound
memvar getlist
IF EMPTY(cName)
   msg("Field name is required")
   lReturn := .f.
ELSEIF !(LEFT(cName,1) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
   msg("Field name must begin with a Character A-Z")
   lReturn := .f.
ELSEIF !allowedc(cName)
   lReturn := .f.
ELSE
  nScanFound := ASCAN(aNames,{|e|e==cName})
  IF nScanFound<>nPosit .and. nScanFound> 0
    msg("Duplicate of existing fieldname")
    lReturn := .f.
  ENDIF
endif
return lReturn

//-----------------------------------------------------------------
static function TypeVal(cType,nLen,nDec)  // len,dec passed by ref
local lReturn := .t.
memvar getlist
IF !cType $ "CNDLM"
  msg("Invalid field type - use CNDL")
  lReturn := .F.
ENDIF
*- determine len/dec based on type
DO CASE
CASE cType = "C"
  nDec := 0
  aeval(getlist,{|g|g:display()} )
CASE cType = "L"
  nDec := 0
  nLen := 1
  aeval(getlist,{|g|g:display()} )
CASE cType = "D"
  nLen := 8
  nDec := 0
  aeval(getlist,{|g|g:display()} )
ENDCASE
return lReturn

//--------------------------------------------------------
static function LenVal(cType,nLen,nDec)  // dec passed by ref
local lReturn := .t.
memvar getlist
IF cType == "N"
  IF !nLen > 0
    msg("Field length must be greater than 0")
    lReturn := .F.
  ELSEIF !nLen < 20
    msg("Field length must be less than 20")
    lReturn := .F.
  ENDIF
ELSE
   nDec := 0
   if !nLen > 0
    msg("Field length must be greater than 0")
    lReturn := .F.
  ENDIF
ENDIF
aeval(getlist,{|g|g:display()} )
return lReturn

//--------------------------------------------------------
static function DecVal(cType,nLen,nDec)
local lReturn := .t.
local cMaxDec
memvar getlist
IF cType == "N"
  IF nDec > MAX(nLen-2,0)
    cMaxDec = STR(MAX(nLen-2,0),2)
    msg("Too many decimals for field length","Maximum is "+cMaxDec)
    lReturn := .F.
  ELSEIF nDec > 18
    msg("Decimals must be less than 19")
    lReturn := .F.
  ENDIF
ELSE
   nDec := 0
ENDIF
aeval(getlist,{|g|g:display()} )
RETURN lReturn


//===============================================================
static function allowedc(cName)
local lReturn  := .t.
local cAllowed := "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"
local nCount   := 1
cName := trim(cName)
FOR nCount = 1 TO LEN(cName)
  IF !SUBSTR(RTRIM(cName),nCount,1) $ cAllowed
    msg("Illegal character in field name :"+rtrim(cName),"Character :"+SUBSTR(RTRIM(cName),nCount,1),"Must be "+cAllowed )
    lReturn := .f.
    EXIT
  ENDIF
NEXT
return lReturn

//===============================================================
static function OK2EXPORT(aNames,aTypes,aLens,aDeci)
local lReturn := len(aNames)>0
local cName,cType,nLen,nDec
local i
for i = 1 to len(aNames)
  cName := aNames[i]
  cType := aTypes[i]
  nLen  := aLens[i]
  nDec  := aDeci[i]
  do case
  CASE  !nameval(cName,aNames,i)
    lReturn := .t.
    exit
  CASE  !TypeVal(cType,@nLen,@nDec)
    lReturn := .t.
    exit
  CASE  !LenVal(cType,nLen,@nDec)
    lReturn := .t.
    exit
  CASE  !DecVal(cType,nLen,@nDec)
    lReturn := .t.
    exit
  endcase
next
return lReturn

//-----------------------------------------------------------
static function export(cInfile,aNames,aTypes,aLens,aDeci,cCharDel,cFieldDel)
local cDbfName := getdbfname()
local aStruct   := {}
local nOldarea := select()
local nHandle := fopen(cInFile,64)
local nPosit,i,nCount
local cThisLine
local abBlocks := array(len(aNames))
nPosit := FSEEK(nHandle,0,1)
select 0
if !empty(cDbfName)

  for i = 1 to len(aNames)
    aadd(aStruct,{aNames[i],aTypes[i],aLens[i],aDeci[i]})
    do case
    case aTypes[i]=="C"
      abBlocks[i] := {|l,i|cRemove(padr(takeout(l,cFieldDel,i),aLens[i]),cCharDel)  }
    case aTypes[i]=="N"
      abBlocks[i] := {|l,i|makenumb(takeout(l,cFieldDel,i),aLens[i],aDeci[i] ) }
    case aTypes[i]=="D"
      abBlocks[i] := {|l,i|stod(takeout(l,cFieldDel,i)) }
    case aTypes[i]=="L"
      abBlocks[i] := {|l,i|iif(takeout(l,cFieldDel,i)=="T",.t.,.f.) }
    endcase
  next

  DBCREATE(cDbfName,aStruct)
  USE (cDbfName)
  if used()
    cvd_fTop(nHandle)
    nCount := 0
    //while inkey()#27 .and. !rat_rightb()
    WHILE !RAT_CHECKESC()
      if !empty((cThisLine:= sfreadline(nHandle))) .and. !chr(26)$cThisLine
        APPEND BLANK
        for i = 1 to len(aLens)
          fieldput(i,eval(aBBlocks[i],cthisLine,i))
        next
      else
        exit
      endif
      if !fmove2next(nHandle)
        exit
      endif
     nCount++
     @22,4 say alltrim(str(nCount))
     ??" records exported.."
    end
    fseek(nHandle,nPosit)
  endif
  if messyn("View DBf file now?")
    editdb(.t.)
  endif
  USE
endif
select (nOldArea)
fclose(nHandle)
@20,1,23,78 BOX sls_frame()
return nil

//-----------------------------------------------------------
static function getdbfname
local cDbfName  := SPACE(8)
While empty(cDbfName)
  cDbfName  := SPACE(8)
  popread(.F.,"Name of datafile to create (Escape aborts): ",@cDbfName,"@!")
  cDbfName  := Alltrim(cDbfName)
  IF LASTKEY() = K_ESC .OR. EMPTY(cDbfName)
    EXIT
  ENDIF
  cDbfname += ".DBF"
  IF FILE(cDbfName)
    msg("Database "+cDbfName+" already exists - ",;
             "Use another name","Or delete that file first")
    cDbfName := ""
    LOOP
  ENDIF
  exit
end
return cDbfName
//------------------------------------------------------------
static function makenumb(cField,nLen,nDeci )
local nVal  := val(cField)
local cPict := iif(nDeci>0,stuff(repl("9",nLen),nLen-nDeci,1,"."),repl("9",nLen))
return val( trans(nVal,cPict) )





