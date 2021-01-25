
memvar getlist

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#ifndef K_SPACE
 #define K_SPACE 32
#endif

#include "box.ch"


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION MODIFY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  MODIFY() Create or modify DBF structures
ณ 
ณ  Returns:
ณ  --------
ณ  <cFile> => name of datafile created/modified
ณ 
ณ  Syntax:
ณ  -------
ณ  MODIFY()
ณ 
ณ  Description:
ณ  ------------
ณ  dBase-like MODI STRU for creating/modifying DBFs.
ณ 
ณ  Examples:
ณ  ---------
ณ   MODIFY()
ณ 
ณ  Warnings:
ณ  ----------
ณ  NOT A NETWORK FUNCTION - DO NOT USE ON A NETWORK
ณ 
ณ  Source:
ณ  -------
ณ  S_MODIFY.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION MODIFY
local cDbfname := ""
local aStruct  := determine(@cDbfName)
local nOldArea := select()
local nOldCursor := setcursor()
local lOldExact  := setexact()

select 0

if aStruct#nil .and. !empty(cDbfName)
  aStruct := makestruct(aStruct)
  if len(aStruct) > 0 .and. !empty(aStruct[1,1]) .and. messyn("Save Changes?")
    putstru(cDbfName,aStruct)
  endif
endif

SELECT (nOldarea)
setexact(lOldexact)
setcursor(nOldcursor)
IF !empty(cDbfName) .and. FILE(cDbfName)
  RETURN cDbfName
ELSE
  RETURN ''
ENDIF
return ''
*-------------------------------------------

static FUNCTION determine(cDbfName)      // cDbfName passed by ref @
local cFromDbf,aStruct
local lUseExist
local nDbfs     := adir("*.dbf")
local aDbfs     := array(nDbfs+1)
local nChoice
Adir("*.dbf",aDbfs)
Ains(aDbfs,1)
aDbfs[1] = "<Create New Datafile>"
nChoice   := mchoice(aDbfs,3,17,15,42,"[DBF to Modify]")
lUseExist := (nChoice > 1)
cDbfName  := iif(nChoice>0,aDbfs[nChoice],"")
IF nChoice > 0
  while aStruct==nil
     IF nChoice == 1         // create new structure
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
       IF messyn("Copy structure from an existing DBF ?")
          if adir("*.DBF") > 0
            cFromDbf = popex("*.DBF",'[Datafile]',.T.)
          ELSE
            msg("No DBFs in this directory")
            EXIT
          ENDIF
       ENDIF
     endif

     IF cFromDbf#nil .AND. !EMPTY(cFromDbf)
       aStruct := getstru(cFromDbf)
     ELSEIF lUseExist
       aStruct := getstru(cDbfName)
     ELSE
       aStruct := {{space(10),"C",10,0}}
     ENDIF
  end
endif
return aStruct

//========================================================
static function getstru(cDbfName)
local aStruct
local cDbtName
USE (cDbfName)
IF !used()
  msg("Unable to open "+cDbfName)
  RETURN nil
else
  aStruct := dbstruct()
ENDIF
USE
return aStruct

//========================================================
static function putstru(cDbfName,aStruct)
local cDbtName
local cTempDbf := getdfp()+"t_e_m_p2.dbf"
local cTempDbt := getdfp()+"t_e_m_p2.dbt"
cDbfName := getdfp()+cDbfName
plswait(.T.,"Writing New Datafile structure...")
if !file(cDbfName)                      // must be a new dbf
  DBCREATE(cDbfName,aStruct)
else                                    // must be an existing dbf
  *- saving an existing structure
  *- erase these two if they exist
  ERASE (cTempDbf)
  ERASE (cTempDbt)

  *- make a DBT filespec, in case there's a DBT
  cDbtName := SUBSTR(cDbfName,1,LEN(cDbfName)-4)+".dbt"

  *- rename dbf, (and .dbt if one exists)
  RENAME (cDbfName) TO (cTempDbf)
  RENAME (cDbtName) TO (cTempDbt)

  DBCREATE(cDbfName,aStruct)

  *- open the new structure
  USE (cDbfName)
  *- append from the renamed dbf
  APPEND FROM (cTempDbf)

  USE
  *- erase temps
  ERASE (cTempDbf)
  ERASE (cTempDbt)
endif
plswait(.f.)
return nil

//----------------------------------------------------------
static function sayinst
local aButtons
local cColor := SLS_POPCOL()
@ 1,1,23,78 BOX "ฺฤฟณูฤภณ "
@ 21,2 to 21,77
@ 3,2 to 3,77
@ 4,45 to 20,45
dispbox(4,2,20,43,space(9),cColor)
@ 1,2 SAY "[Structure Modification]"
@ 2,2 say "#   Name       Type Length Decimals"
@22,2 say "[] [] [] [] [PGUP] [PGDN] [HOME] [END]"
drawcmds(.t.)
dispbox(16,49,20,75,B_SINGLE+" ",cColor)
@ 16,50 SAY "Field Types"  color cColor
@ 17,50 SAY "C=Character    D=Date  " color cColor
@ 18,50 SAY "N=Numeric      L=Logical" color cColor
@ 19,50 SAY "M=Memo" color cColor

aButtons := {;
            {22,2 ,22,4 ,K_UP},;
            {22,6 ,22,8 ,K_DOWN},;
            {22,10,22,12,K_RIGHT},;
            {22,14,22,16,K_LEFT},;
            {22,18,22,23,K_PGUP},;
            {22,25,22,30,K_PGDN},;
            {22,32,22,37,K_HOME},;
            {22,39,22,43,K_END},;
            {5 ,50,5 ,75,K_ESC},;
            {6 ,50,6 ,75,K_F10},;
            {8 ,50,8 ,75,K_ENTER},;
            {9 ,50,9 ,75,K_INS},;
            {10,50,10,75,K_DEL},;
            {11,50,11,75,K_ALT_U},;
            {12,50,12,75,32},;     // space
            {13,50,13,75,K_ALT_A},;
            {14,50,14,75,K_ALT_R} }

return aButtons

static func drawcmds(lCmds)
local cColor := sls_popcol()
DISPBOX(4,49,15,75,B_SINGLE+" ",cColor)
if lCmds
  @4,50 SAY "Commands"  color cColor
  @ 5,50 SAY  "ESC=cancel              " color cColor
  @ 6,50 SAY  "F10=quit/save           " color cColor
  @ 7,50 SAY  "A-Z=find first letter   " color cColor
  @ 8,50 SAY  "ENTER=edit field        " color cColor
  @ 9 ,50 SAY "INSERT=add field        " color cColor
  @ 10,50 SAY "DELETE=delete field     " color cColor
  @ 11,50 SAY "ALT+U=undelete field    " color cColor
 @ 12,50 SAY "SPACE=move field        " color cColor
 @ 13,50 SAY "ALT+A=alphabetize fields" color cColor
 @ 14,50 SAY "ALT+R=reset to original " color cColor
endif
return nil


//======================================================================
static function makestruct(aStruct)
local nElement  := 1
local oTb    := tbrowseNew(4,2,20,33)
local nLastkey,cLastkey, nMouseR, nMouseC, nButton, aButtons
local cInscreen := savescreen(0,0,24,79)
local aMoveSeg,nMoveTo,cMoveBox
local aOldStruc := aclone(aStruct)
local nFound
local aDeleted := {}
local lDoneMods := .f.

dispbox(0,0,24,79,"ฑฑฑฑฑฑฑฑฑ",sls_normcol())

oTb:addcolumn(tbColumnNew(nil,{||trans(nElement,"999")}  ))
oTb:addcolumn(tbColumnNew(nil,{||padr(aStruct[nElement,1],10)}  ))
oTb:addcolumn(tbColumnNew(nil,{||padc(aStruct[nElement,2],4)}  ))
oTb:addcolumn(tbColumnNew(nil,{||trans(aStruct[nElement,3],"999999")}  ))
oTb:addcolumn(tbColumnNew(nil,{||trans(aStruct[nElement,4],"99999")}  ))
*oTb:addcolumn(tbColumnNew("#",{||trans(nElement,"999")}  ))
*oTb:addcolumn(tbColumnNew("Name",{||padr(aStruct[nElement,1],10)}  ))
*oTb:addcolumn(tbColumnNew("Type",{||padc(aStruct[nElement,2],4)}  ))
*oTb:addcolumn(tbColumnNew("Length",{||trans(aStruct[nElement,3],"999999")}  ))
*oTb:addcolumn(tbColumnNew("Dec",{||trans(aStruct[nElement,4],"99999")}  ))
oTb:SKIPBLOCK := {|n|AASKIP(n,@nElement,LEN(aStruct))}
oTb:gobottomblock := {||nElement := len(aStruct)}
oTb:gotopblock    := {||nElement := 1}
*oTb:headsep       := chr(196)

oTb:colorspec := sls_popcol()

aButtons := sayinst()

checkempty(@aStruct)
while !lDoneMods
   nElement := max(1,nElement)
   checkempty(@aStruct)

   while !oTb:stabilize()
   end

   nMouseR := 0; nMouseC := 0
   if !empty(aStruct[1,1])
     nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
     nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
   else
     nLastKey   := K_ENTER
     nButton    := 0
   endif
   cLastKey := upper(chr(nLastkey))
   do case
   CASE nLastKey = K_UP .or. nButton==K_UP         && UP ONE ROW
     oTb:UP()
     if nButton==K_UP
      IFMOUSEHD({||oTb:up()},oTb)
     endif
   CASE nLastKey = K_PGUP  .or. nButton==K_PGUP      && UP ONE PAGE
     oTb:PAGEUP()
   CASE nLastKey = K_LEFT  .or. nButton==K_LEFT      && UP ONE ROW
     oTb:left()
     if nButton==K_LEFT
      IFMOUSEHD({||oTb:left()},oTb)
     endif
   CASE nLastKey = K_RIGHT .or. nButton==K_RIGHT      && UP ONE PAGE
     oTb:right()
     if nButton==K_RIGHT
      IFMOUSEHD({||oTb:right()},oTb)
     endif
   CASE nLastKey = K_HOME  .or. nButton==K_HOME      && HOME
     oTb:GOTOP()
   CASE nLastKey = K_DOWN  .or. nButton==K_DOWN      && DOWN ONE ROW
     oTb:DOWN()
     if nButton==K_DOWN
      IFMOUSEHD({||oTb:down()},oTb)
     endif
   CASE nLastKey = K_PGDN  .or. nButton==K_PGDN      && DOWN ONE PAGE
     oTb:PAGEdOWN()
   CASE nLastKey = K_END   .or. nButton==K_END      && END
     oTb:GOBOTTOM()
   case nLastKey = K_F10   .or. nButton==K_F10
     lDoneMods := .t.
   case (nLastKey = K_ESC .or. nbutton==K_ESC ) .and. messyn("Abandon modifications?")
     lDoneMods := .t.
     asize(aStruct,0)
   case cLastKey$"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        nFound := ASCAN(aStruct,{|e|LEFT(e[1],1)==cLastKey},nElement+1)
        if nFound==0 .and. nElement > 1
          nFound := ASCAN(aStruct,{|e|LEFT(e[1],1)==cLastKey})
        endif
        if nFound > 0
          mf_goto(nFound,nElement,oTb)
        endif
   case nLastkey == K_ENTER .or. nButton==K_ENTER  // edit this field
        mf_edit(aStruct,nElement,aOldStruc)
        if len(aStruct)==0 .or. empty(aStruct[1,1])
          if lastkey()=27 .and. messyn("Abandon modifications?")
            lDoneMods := .t.
          elseif messyn("A Field must be added. Do you wish to quit?")
            lDoneMods := .t.
          endif
        endif
        oTb:refreshcurrent()
   case nLastkey == K_INS  .or. nButton==K_INS     // add field
        ASIZE(aStruct,len(aStruct)+1)
        AINS(aStruct,nElement+1)
        aStruct[nElement+1] := {space(10),"C",10,0}
        oTb:down()
        oTb:refreshall()
        while !oTb:stabilize()
        end
        mf_edit(aStruct,nElement,aOldStruc)
        if empty(aStruct[nElement,1])
          adel(aStruct,nElement)
          ASIZE(aStruct,len(aStruct)-1)
          oTb:up()
        endif
        oTb:refreshall()
   case nLastkey == K_DEL .or. nButton==K_DEL      // delete
        aadd(aDeleted,aStruct[nElement])
        adel(aStruct,nElement)
        ASIZE(aStruct,len(aStruct)-1)
        if nElement > len(aStruct)
          oTb:gotop()
        endif
        oTb:refreshall()
   case nLastkey == K_ALT_R  .or. nButton==K_ALT_R // reset ro original
       aStruct  := aclone(aOldStruc)
       nElement := 1
       oTb:refreshall()
   case nLastkey == K_ALT_U  .or. nButton==K_ALT_U // undelete
        if len(aDeleted) > 0
          ASIZE(aStruct,len(aStruct)+1)
          AINS(aStruct,nElement)
          aStruct[nElement] := atail(aDeleted)
          ASIZE(aDeleted,len(aDeleted)-1)
        endif
        oTb:refreshall()
   case nLastkey == K_ALT_A  .or. nButton==K_ALT_A // alphabetize fields
       aStruct  := ASORT(aStruct,,, { |x, y| x[1] < y[1] })
       nElement := 1
       oTb:configure()
       oTb:refreshall()
   case nLastkey == K_SPACE  .or. nButton==K_SPACE // move single field
    nMoveTo  := nElement
    while .t.
      POPREAD(.T.,"Enter new position of field: "+aStruct[nElement,1],;
                @nMoveto,"999")
      IF lastkey()==K_ESC
        exit
      ELSEIF !(nMoveTo > 0 .AND. nMoveTo <=len(aStruct) )
        msg("Must be greater than 0, less than "+TRANS(len(aStruct),'999') )
      else
        EXIT
      endif
    ENDDO
    if lastkey()<>K_ESC .AND. nMoveto<> nElement
      aMoveSeg := aStruct[nElement]
      Adel(aStruct,nElement)
      AINS(aStruct,nMoveTo)
      aStruct[nMoveTo] := aMoveSeg
      mf_goto(nMoveTo,nElement,oTb)
      nElement := nMoveTo
      oTb:refreshall()
    ENDIF
   case MBRZMOVE(oTb,nMouseR,nMouseC,4,2,22,33)
   case MBRZCLICK(oTb,nMouseR,nMouseC)
      keyboard chr(K_ENTER)
   endcase
end
restscreen(0,0,24,79,cInscreen)
return aStruct


//----------------------------------------------------------



//------------------------------------------------------------
static function mf_edit(aStruct,nElement,aOldStruc)
local cName,cType,nLen,nDec,lSaved
local nRow := row()

drawcmds(.f.)
lSaved := .F.
cName  := aStruct[nElement,1]
cType  := aStruct[nElement,2]
nLen   := aStruct[nElement,3]
nDec   := aStruct[nElement,4]

SET CURSOR ON
IF EMPTY(cName)   && new field
  @nRow,6  get cName PICTURE "@!"
  atail(getlist):postblock := {||fvalid(1,@cName,@cType,@nLen,;
                              @nDec,aStruct,aOldStruc,nElement)}
  @nRow,18 get cType PICTURE "@!"
  atail(getlist):postblock := {||fvalid(2,@cName,@cType,@nLen,;
                              @nDec,aStruct,aOldStruc,nElement)}
  @nRow,25 get nLen picture "999"
  atail(getlist):postblock := {||fvalid(3,@cName,@cType,@nLen,;
                              @nDec,aStruct,aOldStruc,nElement)}
  atail(getlist):preblock := {||!cType$"DLM"}

  @nRow,31 get nDec picture "999"
  atail(getlist):postblock := {||fvalid(4,@cName,@cType,@nLen,;
                              @nDec,aStruct,aOldStruc,nElement)}
  atail(getlist):preblock := {||!cType$"DLMC".and.nLen>2}
  RAT_READ(getlist)
ELSEIF cType $ "LMD"
    msg("This field definition may not be changed")
ELSEIF cType == "C"
    msg("You may change the LENGTH of this field only")
    @nRow,25 get nLen picture "999"
    atail(getlist):postblock := {||fvalid(3,@cName,@cType,@nLen,;
                               @nDec,aStruct,aOldStruc,nElement)}
    RAT_READ(getlist)
ELSE
    msg("You may increase the LENGTH","or decrease the DECIMALS","of this FIELD")
    @nRow,25 get nLen picture "999"
    atail(getlist):postblock := {||fvalid(3,@cName,@cType,@nLen,;
                               @nDec,aStruct,aOldStruc,nElement)}
    @nRow,31 get nDec picture "999"
    atail(getlist):postblock := {||fvalid(4,@cName,@cType,@nLen,;
                               @nDec,aStruct,aOldStruc,nElement)}
    atail(getlist):preblock := {||!cType$"DLMC".and.nLen>2}
    RAT_READ(getlist)
ENDIF

IF !LASTKEY() = K_ESC
  aStruct[nElement,1]:=cName
  aStruct[nElement,2]:=cType
  aStruct[nElement,3]:=nLen
  aStruct[nElement,4]:=nDec
  lSaved = .T.
ENDIF

SET CURSOR OFF
drawcmds(.t.)
RETURN lSaved


//===============================================================
static FUNCTION fvalid(nPosit,cName,cType,nLen,nDec,aStruct,aOldStruc,nElement)
local lReturn := .t.
local nScanFound,nMaxDec
memvar getlist
DO CASE
CASE nPosit = 1
    IF EMPTY(cName)
       msg("Field name is required")
       lReturn := .f.
    ELSEIF !(LEFT(cName,1) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
       msg("Field name must begin with a Character A-Z")
       lReturn := .f.
    ELSEIF !mfcharok(cName)
       lReturn := .f.
    ELSE
       nScanFound := ASCAN(aStruct,{|e|e[1]==cName})
       IF nScanFound<>nElement .and. nScanFound> 0
         msg("Duplicate of existing fieldname")
         lReturn := .f.
       ELSEIF nScanFound == 0
         nScanFound := ASCAN(aOldStruc,{|e|e[1]==cName})
         IF nScanFound > 0
           msg("Duplicate of existing [deleted] fieldname")
           lReturn := .f.
         ENDIF
       ENDIF
    endif

CASE nPosit = 2
    IF !cType $ "CNDLM"
      msg("Invalid field type - use CNDLM")
      lReturn := .F.
    ENDIF

    *- determine len/dec based on type
    DO CASE
    CASE cType = "C"
      nDec := 0
      aeval(getlist,{|g|g:display()} )
    CASE cType = "L"
      nLen := 1
      nDec := 0
      aeval(getlist,{|g|g:display()} )
    CASE cType = "D"
      nLen := 8
      nDec := 0
      aeval(getlist,{|g|g:display()} )
    CASE cType = "M"
      nLen := 10
      nDec := 0
      aeval(getlist,{|g|g:display()} )
    ENDCASE

CASE nPosit = 3
    IF cType == "N"
      IF nLen < aStruct[nElement,3] .and. !empty(aStruct[nElement,1]) // not new
        msg("Cannot decrease size of a numeric field")
        lReturn := .F.
      ELSEIF !nLen > 0
        msg("Field length must be greater than 0")
        lReturn := .F.
      ELSEIF !nLen < 20
        msg("Field length must be less than 20")
        lReturn := .F.
      ENDIF
    ELSEIF cType = "C"
      IF !nLen > 0
        msg("Field length must be greater than 0")
        lReturn := .F.
      ENDIF
    ENDIF
CASE nPosit = 4
    IF cType == "N"
      IF !empty(aStruct[nElement,1]) .and. ;  // this tests if it is a new one
         nDec > aStruct[nelement,4] .and. ASCAN(aOldStruc,{|e|e[1]==cName})>0
           msg("Cannot increase decimals of an existing field")
           lReturn := .F.
      ELSEIF nDec > MAX(nLen-2,0)
        nMaxDec = STR(MAX(nLen-2,0),2)
        msg("Too many decimals for field length","Maximum is "+nMaxDec)
        lReturn := .F.
      ELSEIF nDec > 18
        msg("Decimals must be less than 19")
        lReturn := .F.
      ENDIF
    ENDIF
ENDCASE
RETURN lReturn


//===============================================================
static function mfcharok(cName)
local lReturn  := .t.
local cAllowed := "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"
local nCount   := 1
cName := trim(cName)
FOR nCount = 1 TO LEN(cName)
  IF !SUBSTR(RTRIM(cName),nCount,1) $ cAllowed
    msg("Illegal character in field name :"+SUBSTR(RTRIM(cName),nCount,1),"Must be "+cAllowed )
    lReturn := .f.
    EXIT
  ENDIF
NEXT
return lReturn

//===============================================================
static function mf_goto(nNew,nCurrent,oStruc)
local nIter
local nDiff := ABS(nNew-nCurrent)
if nNew > nCurrent
  for nIter := 1 to nDiff
    oStruc:down()
    while !oStruc:stabilize()
    end
  next
else
  for nIter := 1 to nDiff
    oStruc:up()
    while !oStruc:stabilize()
    end
  next
endif
return nil

//===============================================================
static function checkempty(aStruct)
if len(aStruct)==0
   aStruct := { {space(10),space(1),0,0} }
endif
return aStruct










