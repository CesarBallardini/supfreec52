static nElement   := 1
static nMoveRat   := 0


#include "getexit.ch"

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION VIEWPORT()
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
³ 
³  Short:
³  ------
³  VIEWPORT() Multi-optional data entry engine
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  VIEWPORT([lModify],[aFields,aDesc],[aPict],[aVal],[aLook],;
³            [aOther],[aEdit],[lCarry],[cTitle])
³ 
³  Description:
³  ------------
³  Presents a generic data entry screen with multiple
³  movement, search, view and editing capabilities.
³ 
³  [lModify] Logical - this is (.T.) if you want to give
³  the user Add,Edit,Delete, and (.F.) if not. Defaults to (.T.)
³ 
³  Arrays 1-5 and array 7 must have the same # of
³  elements.
³  (default is # of fields in DBF). You may pass a nil
³  to bypass and activate the default for any of these arrays.
³ 
³  [aFields]    An array of field names. Defaults to all
³  fields in DBF.
³ 
³  [aDesc]   An array of field descriptions. Defaults to
³  field names. You must pass [aFields] if you wish to pass
³  [aDesc]
³ 
³  [aPict]  is an array of PICTURES as Character
³  expressions to correspond with the [aFields] array. Default is
³  pictures as derived by ED_G_PIC(). If you pass this array,
³  each element must contain  at least a "".
³ 
³  [aVal] is an array of VALID clauses and messages
³  to correspond with the [aFields] array. Each is in the form
³ 
³         "{valid clause};{valid message}"
³ 
³  The FIELD is represented as a token "@@"
³  in the valid clause which is replaced with the current edited
³  value at edit time. Note: Field values are loaded into an
³  array when editing, so field names in the valid are not
³  meaningful. Field name FIRST might be aValues[12]. At edit
³  time, the "@@ " will be  replaced with "aValues[12]".
³ 
³         i.e.
³          "!empty(@@);Must not be empty"
³ 
³  If you pass this array, each element must
³  contain at least a "".
³ 
³  [aLook]  is an array of Lookup definitions
³  corresponding to the [aFields] array.
³  These are delimited strings with 1-4
³  component parts matching the first four parameters of SMALLS().
³  Delimiter is a semicolon (;). As an example, to make a lookup
³  definition corresponding to the COMPANY field in the
³  [aFields] array, which will lookup on the field CORPNAME in
³  the database INSTIT, titling the box "Company" and KEYBOARDing
³  the contents of CORPNAME if CR pressed
³ 
³             "CORPNAME;Company;%INSTIT;CORPNAME".
³ 
³  If you realize that these 4 components are
³  parsed and sent as parameters to SMALLS(), you will get the
³  idea.
³ 
³  If you pass this array, each element must
³  contain at least a "".
³ 
³  [aOther]  [1-9 elements] Each of elements 1-9 is a
³  delimited string in the format
³ 
³         "{option};{action}"
³ 
³  where option is a displayed menu option and action
³  is a proc to be executed. i.e.:
³ 
³          "Form Letters;FORMLETR()"
³          "List Myfile;FILEREAD(2,2,22,78,'FMYFILE.TXT')"
³ 
³  Pass 1-9 option/proc combinations. These
³  will be presented as an 'Other' menu.
³ 
³  THESE PROCS MUST BE DECLARED EXTERNAL!!!
³ 
³  [aEdit] an array of logicals matches the FIELDS
³  array and defines which fields may be edited (.t.) and which
³  are display only (.f.)  If you pass this array, each element
³  must be of TYPE Logical.
³ 
³  [lCarry]     Pop up 'Carry Forward' message when adding?
³  True/False. Default is True.
³ 
³  [cTitle]     Optional title. Default is
³               "  VúIúEúW  PúOúRúT  for file: "+TRIM(ALIAS())+' '
³ 
³ 
³ 
³  Examples:
³  ---------
³   local aFlds[fcount()]
³   local aFdes[fcount()]
³   local aFval[fcount()]
³   local aFloo[fcount()]
³   local aFedit[fcount()]
³   afields(aFlds)
³   afields(aFdes)
³   afill(aFval,"")
³   afill(aFloo,"")
³   afill(aFedit,.t.)
³ 
³   // valids for fields 5 and 6
³   aFval[5]:="!empty(@@);Cannot be empty"
³   aFval[6]:="!empty(@@);Cannot be empty"
³ 
³   // lookups for fields 5 and 6
³   aFloo[5] := "First;First Name;%user%;trim(first)"
³   aFloo[6] := "Last;Last Name;%user%;trim(Last)"
³ 
³   // 'other' menu array
³ 
³   aOther := { "Read PRG;FILEREAD(1,1,23,79,'s_viewp.prg')",;
³               "Do Form Letters ;FORMLETR()",;
³               "Frequency Analysis;FREQANAL()" }
³ 
³   VIEWPORT(.t.,aFlds,aFdes,nil,aFval,aFloo,aOther)
³ 
³  Source:
³  -------
³  S_VIEWP.PRG
³ 
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
*/
FUNCTION viewport(lEditAddFlag,aFieldNames,aFieldDesc,aFieldPicts,;
      aFieldValids,aFieldLookups,aOtherMenu,aEditable,lCarryFlag,cTitle)

local aMemos := {}
local aFieldTypes,aFieldLens,aFieldDeci,aValBlocks
local aGetSet,aValues,oTB
local cInScreen := savescreen(0,0,24,79)
local lReadExit  := Ratexit(.T.)
local nOldCursor := setcursor(1)
local bOldF2     := setkey(-1)
local bOldF10    := setkey(-9,{||ctrlw()})
local lOtherMenu := .f.
local aOtherPrompt := {}
local aOtherProc   := {}
local cOldColor    := Setcolor(sls_normcol())
local aIndexKeys   := vp_fillk()
local nMainChoice
local cBrowseBox
local nRecord,nSubChoice,cMemoBox,cOtherBox,lDoCarry
local i, aPrompts, aSubMenu2
local bMouse

nElement        := 1
lEditAddFlag    := iif(lEditAddFlag#nil,lEditAddFlag,.t.)
lCarryFlag      := iif(lCarryFlag#nil,lCarryFlag,.t.)
aFieldNames     := iif(VALTYPE(aFieldNames)#"A",fillfields(),aFieldNames)
aFieldDesc      := iif(VALTYPE(aFieldDesc)#"A",aclone(aFieldNames),aFieldDesc)

aFieldTypes := array(len(aFieldNames))
aFieldLens  := array(len(aFieldNames))
aFieldDeci  := array(len(aFieldNames))
fillarr(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)

if !(VALTYPE(aFieldPicts)=="A" .and. len(aFieldPicts)=len(aFieldNames))
  aFieldPicts := array(len(aFieldNames))
  afill(aFieldPicts,"")
endif
if !(VALTYPE(aFieldValids)=="A" .and. len(aFieldValids)=len(aFieldNames))
  aFieldValids := array(len(aFieldNames))
  afill(aFieldValids,"")
endif
if !(VALTYPE(aFieldLookups)=="A" .and. len(aFieldLookups)=len(aFieldNames))
  aFieldLookups := array(len(aFieldNames))
  afill(aFieldLookups,"")
endif
if !(VALTYPE(aEditable)=="A" .and. len(aEditable)=len(aFieldNames))
  aEditable := array(len(aFieldNames))
  afill(aEditable,.t.)
endif
aValBlocks  := makevalid(aFieldValids)

IF VALTYPE(aOtherMenu)=="A"
  lOtherMenu := .T.
  for i = 1 TO len(aOtherMenu)
    aadd(aOtherPrompt,takeout(aOtherMenu[i],';',1))
    aadd(aOtherProc,takeout(aOtherMenu[i],';',2))
  NEXT
  aadd(aOtherPrompt,"Quit Other Menu")
  aadd(aOtherProc,"")
ENDIF
aGetSet := makegetset(aFieldNames,aEditable)
aValues := array(len(aFieldNames))
fillvalues(aGetset,aValues)
oTB     := vpmaketb(aFieldDesc,aValues,aFieldPicts,aFieldtypes)
aMemos  := figmemos(aFieldNames,aFieldTypes)



@ 0,15,24,79 BOX "ÚÄ¿³ÙÄÀ³ "
if valtype(cTitle)=="C"
  @0,18 SAY cTitle
else
  @0,18 SAY "  VúIúEúW  PúOúRúT  for file: "+TRIM(ALIAS())+' '
endif
IF len(aFieldNames) > 22
  @24,18 SAY "¶ Pgup Pgdn Ç"
  bMouse := {|r,c|iif(r==24.AND. c>=20 .and. c<=23,KBPGUP(),;
                        iif(r==24.AND. c>=25 .and. c<=28,KBPGDN(),nil))}
ENDIF
Setcolor(sls_popcol())
@ 0,0,24,14 BOX "ÉÍ»º¼ÍÈº "
@18,1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄ"
@0,2 SAY " Menu "
* display the menu screen
*----------------------
*- main loop

*- fill in the first set of field pictures
nMainChoice = 1

aPrompts := {}
aadd(aPrompts,{2,2  ,"Next Record"})
aadd(aPrompts,{3,2  ,"Prev Record"})
aadd(aPrompts,{4,2  ,"Search File"})
aadd(aPrompts,{5,2  ,"Key Search"})
aadd(aPrompts,{6,2  ,"TableView"})
aadd(aPrompts,{7,2  ,"Hardcopy"})
aadd(aPrompts,{8,2  ,"Viewmemo"})
aadd(aPrompts,{9,2  ,"Build Query"})
aadd(aPrompts,{10,2 ,"Field Order"})
IF lEditAddFlag
aadd(aPrompts,{11,2 ,"Edit Record"})
aadd(aPrompts,{12,2 ,"Add Record"})
aadd(aPrompts,{13,2 ,"Memo Edit"})
aadd(aPrompts,{14,2 ,"Deleted Flag"})
ENDIF
IF lOtherMenu
  aadd(aPrompts,{15,2 ,"Other Menu"})
ENDIF
aadd(aPrompts,{16,2 ,"Quit"})

if recc()==0
  msg("NOTE: No records in this database yet")
endif
DO WHILE .T.

  DISPBEGIN()
    while !oTb:stabilize()
    end
    SETCURSOR(0)
    SET COLOR TO (sls_popmenu())

    @19,2 SAY "Rec# "
    @20,2 SAY STR(RECNO())
    @21,2 SAY "of # "
    @22,2 SAY STR(RECC())
    @23,2 SAY IIF(DELETED(),"Deleted","       ")
    IF len(aFieldNames) > 22
      @24,18 SAY "¶ Pgup Pgdn Ç" COLOR sls_normcol()
      @18,1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄ"
    ENDIF
  DISPEND()

  *MENU TO nMainChoice
  nMainChoice := RAT_MENU2(aPrompts,nMainChoice,nil,bMouse)
  IF nMainChoice > 2
    SCROLL(2,1,23,13,0)
  ENDIF

  SET COLOR TO (sls_popcol())
  DO CASE
  //---------------------------------------------------------
  CASE lastkey()==K_PGUP
    oTb:rowpos := 1
    nElement := iif(nElement==1,nElement,nElement-1)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE lastkey()==K_PGDN
    if nElement+21 <= len(aFieldNames)
      oTb:rowpos := 1
      nElement := iif(nElement==len(aFieldNames),nElement,nElement+1)
      oTb:refreshall()
    endif
  //---------------------------------------------------------
  CASE nMainChoice = 1       // next
    SKIP
    if eof()
      go bott
    endif
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 2      // previous
    SKIP -1
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 3      // search
    searchme(aFieldNames,aFieldTypes,aFieldLens,aFieldDesc)
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 4     // key search
    getseek(aIndexKeys)
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 5     // tableview
    cBrowseBox = makebox(0,0,24,79,Setcolor(),0)
    tableview(aFieldNames, aFieldDesc)
    unbox(cBrowseBox)
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 6     // hardcopy
    if recc() > 0
      hardcopy(aFieldNames,aFieldDesc,aFieldTypes)
    else
      msg("No records added yet. Cannot print")
    endif
  //---------------------------------------------------------
  CASE nMainChoice = 7         // view memo
    IF len(aMemos) > 0
      nSubchoice = 1
      IF len(aMemos) > 1
        nSubchoice = mchoice(aMemos,2,15,3+len(aMemos),26,"Which Memo:")
        if nSubchoice = 0
          loop
        endif
      ENDIF
      EDITMEMO(aMemos[nSubChoice],1,16,23,78,.f.,200)
    ELSE
      msg("No memo fields detected","")
    ENDIF
  //---------------------------------------------------------
  CASE nMainChoice = 8  // build query
    QUERY(aFieldNames,aFieldDesc,aFieldTypes,"To ViewPort")
  //---------------------------------------------------------
  CASE nMainChoice = 9  // field order
    orderfields(aFieldNames,aFieldDesc,aFieldPicts,;
      aFieldValids,aFieldLookups,aEditable,aFieldTypes,aFieldLens,;
      aFieldDeci,aValues,aGetSet)
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 10 .AND. lEditAddFlag      // edit record
    if  RECC()>0
      SETCURSOR(1)
      if vpedit(aValues,oTb,aValBlocks,aFieldLookups,aFieldPicts,;
              aFieldTypes,aEditable)
         if messyn("Save ?")
            saverecord(aValues,aGetSet,aEditable,aFieldtypes)
         endif
      endif
      SETCURSOR(0)
      UNLOCK
      fillvalues(aGetset,aValues)
      oTb:refreshall()
    else
      msg("No records added yet. Cannot edit.")
    endif
  //---------------------------------------------------------
  CASE nMainChoice = 11 .AND. lEditAddFlag    // add record
    nRecord := recno()
    lDoCarry := .f.
    IF RECC()>0 .and. lCarryFlag
      IF !messyn("Carry contents of current record forward?","No","Yes")
        lDoCarry := .t.
      ENDIF
    ENDIF
    if !lDocarry
      go bottom
      skip
      fillvalues(aGetset,aValues)
    endif
    SETCURSOR(1)
    if vpedit(aValues,oTb,aValBlocks,aFieldLookups,aFieldPicts,;
            aFieldTypes,aEditable)
       if messyn("Save ?")
          addrecord(aValues,aGetSet,aEditable,aFieldtypes)
       else
          go nRecord
       endif
    else
      go nRecord
    endif
    SETCURSOR(0)
    UNLOCK
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  CASE nMainChoice = 12 .AND. lEditAddFlag    // edit memo
    if  RECC()>0
      IF len(aMemos) > 0
        nSubchoice = 1
        IF len(aMemos) > 1
          nSubchoice = mchoice(aMemos,2,15,3+len(aMemos),26,"Which Memo:")
          if nSubchoice = 0
            loop
          endif
        ENDIF
        editmemo(aMemos[nSubchoice],0,15,24,79,.t.)
      ELSE
        msg("No memo fields detected","")
      ENDIF
    else
      msg("No records added yet - cannot edit memos")
    endif
  //---------------------------------------------------------
  CASE nMainChoice = 13 .AND. lEditAddFlag
    if recc() > 0
      if SREC_LOCK(5,.T.,"Network error locking record. Keep trying?")
        IF DELETED()
          RECALL
        ELSE
          DELETE
        ENDIF
        unlock
        goto recno()
      endif
    else
      msg("No records added yet - cannot delete")
    endif
  //---------------------------------------------------------
  CASE (nMainChoice = 10.OR. nMainChoice=14) .AND. (lOtherMenu)
    *- other
    cOtherBox := makebox(8,6,10+len(aOtherPrompt),6+BIGELEM(aOtherPrompt)+2)
    aSubMenu2   := {}
    aadd(aSubMenu2  ,{9,8,aOtherPrompt[1]})
    for i = 2 TO len(aOtherPrompt)
      aadd(aSubMenu2,{8+i,8,aOtherPrompt[i]})
    NEXT
    *MENU TO nSubChoice
    nSubChoice := RAT_MENU2(aSubMenu2)
    unbox(cOtherBox)
    IF nSubChoice > 0 .AND. nSubChoice < len(aOtherPrompt)
      i := &( aOtherProc[nSubChoice] )
    ENDIF
    fillvalues(aGetset,aValues)
    oTb:refreshall()
  //---------------------------------------------------------
  OTHERWISE
    IF MESSYN("Exit Now ?")
      SETCURSOR(nOldCursor)
      SETKEY(-1,bOldF2)
      SETKEY(-9,bOldF10)
      Ratexit(lReadExit)
      Setcolor(cOldColor)
      restscreen(0,0,24,79,cInScreen)
      exit
    endif
  ENDCASE
ENDDO
nElement := nil
return nil


//--------------------------------------------------------------
static function makegetset(aFields,aEditable)
local i
local aGetSet := {}
for i = 1 to len(aFields)
  do case
  case iseditable(aFields[i])
    aadd(aGetSet,workblock(aFields[i]))
  case isfield(aFields[i])
    aadd(aGetSet,workblock(aFields[i]))
    aEditable := .f.
  otherwise
    aadd(aGetSet,expblock(aFields[i]))
    aEditable := .f.
  endcase
next
return aGetSet

//--------------------------------------------------------------
static proc fillvalues(aGetSet,aValues)
local i
for i= 1 to len(aGetSet)
  aValues[i] := eval(aGetSet[i])
next
return

//--------------------------------------------------------------
static function iseditable(f)
return isfield(f) .and. isthisarea(f)

//--------------------------------------------------------------
static function vpmaketb(aDesc,aValues,aPict,aFieldtypes)
local tb      := tbrowsenew(2,16,min(22,len(aDesc)+1),78)
local cColor  := subst(setcolor(),1,at(",",setcolor())-1)
local hColor  := takeout(setcolor(),",",5)

tb:colorspec := cColor+","+cColor+","+hColor
tb:addcolumn(tbcolumnnew(nil,{||padr(aDesc[nElement],15)  }))
tb:addcolumn(tbcolumnnew(nil,;
            {||iif(aFieldTypes[nElement]=="M","(memo)",;
             padr(trans(aValues[nElement],aPict[nElement]),30)) }))
tb:getcolumn(2):colorblock := {||{3,3}}
tb:skipblock := {|n|aaskip(n,@nElement,len(aDesc))}
tb:gotopblock := {||agotop(nElement,tb)}
tb:gobottomblock := {||agobot(nElement,LEN(aDesc),tb)}
return tb

//-----------------------------------------------
static proc agoTop(nElement,oBrz)
local nTemp := nElement
while nTemp > 1
  oBrz:up()
  nTemp--
end
return
//-----------------------------------------------
static proc agoBot(nElement,nLen,oBrz)
local nTemp := nElement
dispbegin()
while nTemp < nLen
  oBrz:down()
  nTemp++
end
while !oBrz:stabilize()
end
dispend()
return

//-----------------------------------------------
static function fillfields
local aFieldNames := array(fcount())
afields(aFieldNames)
return aFieldNames

//------------------------------------------------
static function makevalid(aValids)
local aValBlocks := array(len(aValids))
local i,cValid,cMsg
local cPreMac
for i = 1 to len(aValids)
  if !empty(aValids[i])
    cValid        := takeout(aValids[i],";",1)
    cMsg          := takeout(aValids[i],";",2)
    cPreMac       := ("{|__1|"+strtran(cValid,"@@","__1")+"}")
    aValBlocks[i] := {&(cPreMac),cMsg}
  else
    aValBlocks[i] := nil
  endif
next
return aValBlocks
//-----------------------------------------------
static function figmemos(aFieldNames,aTypes)
local aMemos := {}
local i
for i = 1 to len(aFieldNames)
  if aTypes[i]=="M"
    aadd(aMemos,aFieldNames[i])
  endif
next
return aMemos
//------------------------------------------------
static function vp_fillk
local aKeys := {}
local i := 1
while !empty(indexkey(i))
  aadd(aKeys,indexkey(i))
  i++
end
return aKeys

//------------------------------------------------
static function getseek(aKeys)
local nKey := 0
local expRead
local nOldOrder := indexord()
local nRecord   := recno()
if len(aKeys) > 1
   nKey := mchoice(aKeys,5,15,5+len(aKeys)+2,65,"Select Index Key")
elseif len(aKeys)==1
   nKey := 1
else
   msg("No Index Open")
endif
if nKey > 0
  expRead := eval( &("{||"+aKeys[nKey]+"}") )
  popread(.t.,"Seek value:",@expRead,"@K")
  if lastkey()<>K_ESC .and. !empty(expRead)
     IF VALTYPE(expRead)=="C"
       expRead := trim(expRead)
     endif
     set order to (nKey)
     seek expRead
     if !found()
       msg("Not Found")
       go nRecord
     endif
  endif
endif
set order to (nOldOrder)
return nil

//------------------------------------------------
STATIC FUNCTION orderfields(aFieldNames,aFieldDesc,aFieldPicts,;
      aFieldValids,aFieldLookups,aEditable,aFieldTypes,aFieldLens,;
      aFieldDeci,aValues,aGetSet)

local cSortBox := makebox(2,9,21,65)
local nNewPosition,nOldPosition
local getlist := {}
local aPosits := {}
local i, nRowNow
local bOldF10 := SETKEY(K_F10,{||KBDESC()})
for i = 1 to len(aFieldNames)
  aadd(aPosits,STR(i))
next

@ 2,28 SAY "Â"
@ 18,9 SAY 'Ã'
@ 21,28 SAY "Á"
@ 3,28 SAY "³  Field Viewing Order:"
@ 4,28 SAY "³"
@ 5,28 SAY "³ The fields for this datafile may"
@ 6,28 SAY "³ be viewed in any order.      "
@ 7,28 SAY "³"
@ 8,28 SAY "³ "
@ 9,28 SAY "³ "
@ 10,28 SAY "³"
@ 11,28 SAY "³ Press ENTER to select a field to"
@ 12,28 SAY "³ move. You will be prompted for the"
@ 13,28 SAY "³ position to move it to."
@ 14,28 SAY "³"
@ 15,28 SAY "³"
@ 16,28 SAY "³"
@ 17,28 SAY "³"
@ 18,10 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 19,28 SAY "³"
@ 19,30 SAY "Press F10 when done" color sls_normcol()
@ 20,10 SAY "Total Fields:     ³"
@ 20,23 SAY LTRIM(STR(len(aFieldNames) ))

nRowNow := 1
nNewPosition := 1
nOldPosition := 1
WHILE nOldPosition > 0
  nOldPosition := nNewPosition
  nOldPosition := SACHOICE(4,12,17,27,aFieldDesc,nil,;
                  nNewPosition,nil,18,15,;
                  {|r,c|iif(r==19.and.c>=30.and.c<=48,KBDESC(),nil)})
  IF nOldPosition = 0
    EXIT
  ENDIF
  nNewPosition = MCHOICE(aPosits,4,28,17,48,"New Position")
  IF nNewPosition <= 0
    nNewPosition = 1
  ELSEIF nNewPosition > len(aFieldNames)
    nNewPosition = len(aFieldNames)
  ENDIF

  fieldshift(aFieldNames,nOldPosition,nNewPosition)
  fieldshift(aFieldDesc,nOldPosition,nNewPosition)
  fieldshift(aFieldTypes,nOldPosition,nNewPosition)
  fieldshift(aFieldLens,nOldPosition,nNewPosition)
  fieldshift(aFieldPicts,nOldPosition,nNewPosition)
  fieldshift(aFieldValids,nOldPosition,nNewPosition)
  fieldshift(aFieldLookups,nOldPosition,nNewPosition)
  fieldshift(aEditable,nOldPosition,nNewPosition)
  fieldshift(aValues ,nOldPosition,nNewPosition)
  fieldshift(aGetSet,nOldPosition,nNewPosition)

END
unbox(cSortBox)
SETKEY(K_F10,bOldF10)
RETURN nil
//----------------------------------------------------
STATIC FUNCTION fieldshift(aTarget,nOldPosition,nNewPosition)
local expHoldThis := aTarget[nOldPosition]
adel(aTarget,nOldPosition)
ains(aTarget,nNewPosition)
aTarget[nNewPosition] := expHoldThis
RETURN nil

//--------------------------------------------------------------------
static function vpedit(aValues,oTb,aValBlocks,aLookups,aPicts,aFieldTypes,aEditable)
local aOldValues := aclone(aValues)
local oGet,cPict
local nGetEx := GE_DOWN
local expThis, i
local lSave := .t.
oTb:colpos := 2
//oTb:getcolumn(2):defcolor := {2,2}
oTb:getcolumn(2):colorblock := {||{2,2}}
oTb:refreshall()
if sls_ismouse()
  @24,18 SAY "¶ [F10 save]    [ESC cancel]                  [][] Ç" COLor sls_normcol()
else
  @24,18 SAY "¶ [F10 save]    [ESC cancel]                         Ç" COLor sls_normcol()
endif
while .t.
  while !oTb:stabilize()
  end
  if aEditable[nElement] .and. !aFieldtypes[nElement]=="M"
     cPict := iif(empty(aPicts[nElement]),"@S30",aPicts[nElement])
     expThis := aValues[nElement]
     oGet := getnew(row(),col(),{|n|expThis:=iif(n#nil,n,expThis)},,cPict)
     if !empty(aLookups[nElement])
       @24,50 say "[F2 Lookup]"
     endif
     nGetEx := vpread(oGet,aLookups[nElement],;
          aValBlocks[nElement],{|r,c,cLook|verat(r,c,cLook)})
     aValues[nElement] := expThis
     oTb:refreshcurrent() ; while !oTb:stabilize() ;  end    // 11-23-1992
     if !empty(aLookups[nElement])
       @24,50 say "           "
     endif
  endif
  do case
  case nMoveRat > 0
     for i = 1 to nMoveRat
       oTb:down()
     next
     nMoveRat := 0
  case nMoveRat < 0
     nMoveRat := abs(nMoveRat)
     for i = 1 to nMoveRat
       oTb:up()
     next
     nMoveRat := 0
  case nGetEx = GE_UP .and. nElement == 1
    oTb:gobottom()
  case nGetEx = GE_UP
    oTb:up()
  case nGetEx = GE_DOWN .and. nElement == len(aValues)
    exit
  case nGetEx = GE_DOWN
    oTb:down()
  case nGetEx = GE_ESCAPE
    aValues := aOldValues
    lSave   := .f.
    EXIT
  case nGetEx = GE_WRITE
    EXIT
  endcase
end
//oTb:getcolumn(2):defcolor := {3,3}
oTb:getcolumn(2):colorblock := {||{3,3}}
oTb:gotop()
oTb:refreshall()
@24,18 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" COLor sls_normcol()
RETURN lSave


//-------------------------------------------------------
static function vpread(get,cLookup,aValidBlock,bMouse)
local nLastKey,nExitState, nMr, nMc
get:SetFocus()
get:exitstate := GE_NOEXIT
nMoveRat := 0
while ( get:exitState == GE_NOEXIT )
        if ( get:typeOut )
           get:exitState := GE_ENTER
        end
        while ( get:exitState == GE_NOEXIT )
                nLastKey := rat_event(0,.F.)
                nMr := rat_eqmrow()
                nMc := rat_eqmcol()
                if nLastKey==K_MOUSELEFT
                //new
                  if nMR==get:row .and. nMC>=get:col .and. nMC<= ;
                     get:col+len(trans(get:varget(),get:picture))-1
                     while (get:col-1+get:pos) < nMC .and. !get:typeout
                       get:right()
                       get:display()
                     end
                     while (get:col-1+get:pos) > nMC .and. !get:typeout
                       get:left()
                       get:display()
                     end
                  else
                  //endnew
                     eval(bMouse,nMr,nMc,cLookup)
                  endif
                else
                  vgetakey(nLastKey,get,cLookup)
                endif
        end
        // disallow exit if the VALID condition is not satisfied
        if ( !vpvalid(get,aValidBlock) )
            get:exitState := GE_NOEXIT
            get:display()
        endif
end
nExitState := get:exitstate
get:KillFocus()
return nExitState


static function verat(nMr, nMc, cLook)
if nMr<>row() .and. nMr >= 2 .and. nMr <= 22
  if nMc >= 2 .and. nMc <=78
       if nMr < row()
         nMoveRat := nMr-row()
         keyboard chr(K_UP)
       else
         nMoveRat := nMr-row()
         keyboard chr(K_DOWN)
       endif
  endif
elseif nMr==24
  do case
  case nMc >=20 .and. nMc <=29
    keyboard chr(K_CTRL_END)
  case nMc >=34 .and. nMc <=45
    keyboard chr(27)
  case nMc >= 64 .and. nMc <=66
    keyboard chr(K_UP)
  case nMc > 67 .and. nMc <=69
    KEYBOARD CHR(K_DOWN)
  case nMc >=50 .and. nMc <= 60
    if !empty(cLook)
      vplookup(cLook)
    endif
  ENDCASE
endif
RETURN NIL



#define K_UNDO 21
//-------------------------------------------------------
static proc vgetakey(key,get,cLookup)
local cKey
local bKeyBlock
    do case
    case ( (bKeyBlock := SetKey(key)) <> NIL )
        Eval(bKeyBlock, "VIEWPORT", 0, ReadVar())
    case ispart(key, K_F2 )
        if !empty(cLookup)
          vplookup(cLookup)
        endif
    case ispart(key, K_UP,K_SH_TAB )
        get:exitState := GE_UP
    case ispart(key,K_DOWN,K_TAB,K_ENTER )
        get:exitState := GE_DOWN
    case ( key == K_ESC )
        if ( Set(_SET_ESCAPE) )
          get:undo()
          get:exitState := GE_ESCAPE
        end
    case ISPART(key,K_PGUP,K_PGDN,K_CTRL_W,K_F10,K_CTRL_HOME)
        get:exitState := GE_WRITE
    case (key == K_INS)
        Set( _SET_INSERT, !Set(_SET_INSERT) )
    case (key == K_UNDO)
        get:Undo()
    case (key == K_HOME)
        get:Home()
    case (key == K_END)
        get:End()
    case (key == K_RIGHT)
        get:Right()
    case (key == K_LEFT)
        get:Left()
    case (key == K_CTRL_RIGHT)
        get:WordRight()
    case (key == K_CTRL_LEFT)
        get:WordLeft()
    case (key == K_BS)
        get:BackSpace()
    case (key == K_DEL)
        get:Delete()
    case (key == K_CTRL_T)
        get:DelWordRight()
    case (key == K_CTRL_Y)
        get:DelEnd()
    case (key == K_CTRL_BS)
        get:DelWordLeft()
    otherwise
        if (key >= 32 .and. key <= 255)
           cKey := Chr(key)
           if (get:type == "N" .and. (cKey == "." .or. cKey == ","))
                   get:ToDecPos()
           else
              if ( Set(_SET_INSERT) )
                      get:Insert(cKey)
              else
                      get:Overstrike(cKey)
              endif
              if (get:typeOut .and. !Set(_SET_CONFIRM) )
                 get:exitState := GE_DOWN
              endif
           endif
        end
    endcase
return

*==============================================================
static function vpvalid(get,aValidblock)
local lValid := .t.

if ( get:exitState == GE_ESCAPE )
    return (.t.)                    // NOTE
end
if ( get:BadDate() )
  get:Home()
  return (.f.)                    // NOTE
end
if ( get:changed )
  get:Assign()
end
get:Reset()
if ( aValidBlock <> NIL )
        lValid := Eval(aValidBlock[1], eval(get:block) )
        SetPos( get:row, get:col )
        get:UpdateBuffer()
        if !lValid
          msg(aValidBlock[2])
        endif
end
return (lValid)

static function saverecord(aValues,aGetSet,aEditable,aFieldtypes)
local nOldOrder := INDEXORD()
local i
SET ORDER TO 0
if SREC_LOCK(5,.T.,"Network error locking record. Keep trying?")
  for i = 1 TO len(aValues)
    IF aEditable[i] .AND. (!aFieldTypes[i]=="M")
      eval(aGetSet[i],aValues[i])
    ENDIF
  NEXT
  UNLOCK
ELSE
  msg("Unable to save changes - unable to lock record")
ENDIF
SET ORDER TO (nOldOrder)
return nil

//-----------------------------------------------------------------
static function addrecord(aValues,aGetSet,aEditable,aFieldTypes)
IF SADD_REC(5,.T.,"Network error adding record. Keep trying?")
  saverecord(aValues,aGetset,aEditable,aFieldTypes)
ENDIF
return nil

//-----------------------------------------------------------------
static FUNCTION vplookup(cLookup)
local i
local aLook   := array(4)
local nParams := 0
local cChunk

IF !empty(cLookup)
  for i = 1 TO 4
    cChunk  := takeout(cLookup,';',i)
    IF !EMPTY(cChunk)
       aLook[i] := cChunk
   ENDIF
  NEXT
  smalls(aLook[1] ,aLook[2],aLook[3],aLook[4])
ELSE
  msg("No lookup defined for this field..")
ENDIF
RETURN ''

static function tableview(aFieldNames, aFieldDesc)
Setcolor(sls_normcol())
EDITDB(.f.,aFieldNames,aFieldDesc,.T.,.T.)
Setcolor(sls_popcol())
return nil


static function KBPGDN
keyboard chr(K_PGDN)
RETURN NIL

static function KBPGUP
keyboard chr(K_PGUP)
RETURN NIL

