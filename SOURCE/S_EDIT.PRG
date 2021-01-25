#include "inkey.ch"

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION EDITDB()                     *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  EDITDB() Customized database browser with edit/add/search
ณ  capabilities
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  EDITDB([lModify],[aFields,aFieldDesc],[lBypassAsk],[lBypassLeave],;
ณ         [nLock])
ณ 
ณ  Description:
ณ  ------------
ณ  Customized browse interface allowing searching, goto,
ณ  vertical view and (if <lModify> is True) add edit delete.
ณ 
ณ  Also allows limiting of fields viewed.
ณ 
ณ  [lModify] allows add-edit-delete or not.
ณ 
ณ  The two arrays [aFields, aFieldDesc] are of field
ณ  names and field descriptions. Default is all fields, field names
ณ  as descriptions.
ณ 
ณ  [lByPassAsk] allows bypass of the "BROWSE ALL/SELECT
ณ  FIELDS" opening menu choice, and defaults to .f.
ณ 
ณ  [lByPassLeave] allows bypass of "Quit?" dialog. Just quits
ณ
ณ  [nLock] number of columns to lock (default is 0)
ณ 
ณ  Examples:
ณ  ---------
ณ   USE CUSTOMER
ณ 
ณ   aFlds := {"FNAME","LNAME","MI"}
ณ   aDesc := {"First","Last","Middle"}
ณ   editdb(.t.,aFlds,aDesc)
ณ 
ณ  Notes:
ณ  -------
ณ  Allows record deletion, but does not pack. Does not
ณ  'SET DELETED' one way or the other.
ณ 
ณ  Source:
ณ  -------
ณ  S_EDIT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION editdb(lAddEdit,aInFields,aInFdescr,lBypassAsk,lByPassLeave,nLock)

local nDbSize, nIter
local aFields := {}
local aFdescr := {}
local aSelect, cMemBox,cMemo
local nIndexOrder,cInScreen,nOldCursor
local nCounter,nChoice,cOldColor
local oTb, nLkey,cLkey,bOldF10
local cFieldName,cFieldDes, cDeleted
local nrecnoNew,nRecnoOld, cIndexExpr
local bIndexExpr, aView, nLenDesc, nPadding
local nNewCol, aTypes, aLens, cThisType, expGet
local nRow,nCol, cEditScreen,cEditColor
local nFreeze := iif(nLock#nil,nLock,0)
local getlist := {}
local cEdScreen
local nMouseR, nMouseC, aButtons, nButton

local expSeekVar, nLastSeek, lIndexes

* is there a DBF ?
IF !Used()
  RETURN ''
ENDIF

*- save environment ----------------------------------------------
cInscreen  := savescreen(0,0,24,79)
nOldCursor := setcursor(0)

*----- determine index key current----------------------------
cIndexExpr := INDEXKEY(0)
if !empty(cIndexExpr)
  bIndexExpr := &("{||"+cIndexExpr+"}")
endif
lIndexes := !empty(indexkey(1))


*- initialize missing paramaters-------------------------------
lAddEdit     := iif(laddEdit#nil,lAddEdit,.f.)
lByPassAsk   := iif(lByPassAsk#nil,lByPassAsk,.f.)
lByPassLeave := iif(lByPassLeave#nil,lByPassLeave,.f.)
if valtype(aInFields)+valtype(aInFdescr)<>"AA"
  nDbSize   := Fcount()
  aInFields := array(nDbSize)
  aInFdescr := array(nDbSize)
  aFields(aInFields)
  aFields(aInFdescr)
else
  nDbSize := len(aInFdescr)
ENDIF

*--------- determine fields-----------------------------------
selfields(aInFields,aInFdescr,aFields,aFDescr,lByPassAsk)
aTypes := array(len(aFields))
aLens  := array(len(aFields))
fillarr(aFields,aTypes,aLens)


*---------- draw screen----------------------------------------
DISPBEGIN()
cOldColor   := Setcolor(sls_popcol())
@ 0,0 CLEAR TO  24,79
dispbox(0,0,2,79)
dispbox(21,0,24,79)

@ 22,2 SAY    "(Q)uit     (G)oto       (S)earch    (L)ock    (V)ertical View    (F)ields"
IF lIndexes .and. lAddEdit
  @ 23,2  SAY "(E)dit     (A)dd        (D)elete    (R)ecall  (O)rder            (K)eysearch"
ELSEif lAddEdit
   @ 23,2 say "(E)dit     (A)dd        (D)elete    (R)ecall"
ELSEif lIndexes
  @ 23,48  SAY "(O)rder            (K)eysearch"
ENDIF
@1,50 SAY  " (F1 for Navigation keys)"
@0,5  SAY '[Browse Window]'

aButtons := {;
             {22,2,22,7,ASC("Q")},;
             {22,13,22,18,ASC("G")},;
             {22,26,22,33,ASC("S")},;
             {22,38,22,43,ASC("L")},;
             {22,48,22,62,ASC("V")},;
             {22,67,22,74,ASC("F")},;
             {22,67,22,74,ASC("F")},;
             {20,67,20,69,K_UP},;
             {20,70,20,72,K_DOWN},;
             {20,73,20,75,K_RIGHT},;
             {20,76,20,78,K_LEFT},;
             {1,51,1,74,K_F1}  }
if lAddEdit
        AADD(aButtons,{23,2,23,7,ASC("E")})
        AADD(aButtons,{23,13,23,17,ASC("A")})
        AADD(aButtons,{23,26,23,33,ASC("D")})
        AADD(aButtons,{23,38,23,45,ASC("R")})
endif
if lIndexes
        AADD(aButtons,{23,48,23,54,ASC("O")})
        AADD(aButtons,{23,67,23,77,ASC("K")})
endif



SETCOLOR(sls_normcol())
dispbox(3,0,20,79,"ฺฤฟณูฤภณ ")
@20,67 say "[][][][]"
DISPEND()

//-----------create tbrowse --------------------------------
oTb := edbmaketb(aFields,aFdescr,aTypes)
if nFreeze > 0
     oTb:freeze := nFreeze
endif

if recc()==0
  msg("NOTE: No records in this database yet")
endif

while .t.
   dispbegin()
   while !oTb:stabilize()
   end
   nRow     := ROW()
   nCol     := COL()
   nRecnoOld := recno()

   cfieldName  :=  aFields[oTb:colpos]
   cFieldDes   :=  aFdescr[oTb:colpos]
   cDeleted    := IIF(DELETED(),"  [Deleted]","           ")
   @1,5 say '[Record # '+TRANS(RECNO(),'9,999,999,999')+']'+cDeleted ;
                color sls_popcol()
   dispend()

   nLKey := rat_event(0)
   nMouseR := rat_eqmrow()
   nMouseC := rat_eqmcol()
   nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)

   cLkey := upper(chr(nLkey))
   if nButton > 0
     cLkey := upper(chr(nButton))
   endif

   do case
   case nLkey == K_DOWN .or. nButton==K_DOWN
      oTb:down()
      IF nButton==K_DOWN
        IFMOUSEHD({||oTb:down()},oTb)
      ENDIF
   case nLkey == K_PGDN
      oTb:pagedown()
   case nLkey == K_UP .or. nButton==K_UP
      oTb:up()
      IF nButton==K_UP
        IFMOUSEHD({||oTb:up()},oTb)
      ENDIF
   case nLkey == K_PGUP
      oTb:pageup()
   case nLkey == K_CTRL_PGUP
      oTb:gotop()
   case nLkey == K_CTRL_PGDN
      oTb:gobottom()

   case nLkey == K_LEFT .or. nButton==K_LEFT
      oTb:left()
      IF nButton==K_LEFT
        IFMOUSEHD({||oTb:left()},oTb)
      endif
   case nLkey == K_RIGHT .or. nButton==K_RIGHT
      oTb:right()
      IF nButton==K_RIGHT
        IFMOUSEHD({||oTb:right()},oTb)
      endif
   case nLkey == K_CTRL_RIGHT
      oTb:panright()
   case nLkey == K_CTRL_LEFT
      oTb:panleft()

   case nLkey == K_HOME
      oTb:home()
   case nLkey == K_END
      oTb:end()
   case nLkey == K_CTRL_END
      oTb:colpos := oTb:colcount
      oTb:refreshall()
   case nLkey == K_CTRL_HOME
      oTb:colpos := 1
      oTb:refreshall()

   CASE cLkey == "L"
     PopRead(.F.,'Number of columns to Lock: ',@nFreeze,'9')
     oTb:freeze := nFreeze
     oTb:refreshall()
   CASE cLkey=="K" .AND. lIndexes
     SPOPSEEK()
     oTb:rowpos = 1
     oTb:configure()
     oTb:refreshall()
   CASE cLkey=="O" .AND. lIndexes
     SPOPORDER()
     oTb:refreshall()
   CASE cLkey=="Q" .or. nLkey = K_ESC
     if !lByPassLeave
       IF messyn("Quit ")
         EXIT
       ENDIF
     else
       EXIT
     endif
   CASE nLkey = K_F1 .or. nbutton==K_F1
     db_navig()
   CASE cLkey=="G"
     nRecnoNew = recno()
     popread(.f.,"Go to record #   :",@nRecnoNew,"999999")
     IF nRecnoNew > 0 .AND. nRecnoNew <= RECC()
       GO nRecnoNew
       oTb:rowpos = 1
       oTb:configure()
     ENDIF
     oTb:refreshall()
   CASE cLkey=="F"
      selfields(aInFields,aInFdescr,aFields,aFDescr,.f.)
      aTypes := array(len(aFields))
      aLens  := array(len(aFields))
      fillarr(aFields,aTypes,aLens)
      oTb := edbmaketb(aFields,aFdescr,aTypes)
      oTb:configure()
      oTb:refreshall()
   CASE cLkey=="S"
     searchme(aFields,aTypes,aLens,aFdescr)
     oTb:refreshall()
   CASE (cLkey=="D" .OR. cLkey=="R") .AND. lAddEdit
     IF RECC() > 0
      delrec()
      SKIP -1
      SKIP 1
      oTb:refreshall()
     else
       msg("No records added yet - cannot delete")
     endif
   CASE cLkey=="E"  .AND. lAddEdit
     IF RECC() > 0
       cEdScreen := SAVESCREEN(0,0,24,79)
       DISPBOX(0,0,24,79,"ฑฑฑฑฑฑฑฑฑ")
       IF gened(.F.,2,22,aFields,aFdescr)
         oTb:refreshall()
       ENDIF
       RESTSCREEN(0,0,24,79,cEdScreen)
     ELSE
       MSG("No records exist yet. Please add record first, then edit.")
     ENDIF
   CASE cLkey=="V"
     aView := aclone(aFdescr)
     FOR nCounter = 1 TO len(aFields)
       cFieldname := aFields[nCounter]
       cThisType  := aTypes[nCounter]
       nLenDesc   := LEN(aFdescr[nCounter])
       nPadding   := 15-nLenDesc

       *- complete the array element with the current value
       DO CASE
       CASE !isfield(cFieldName)
         aView[nCounter] += SPACE(nPadding)+TRANS(eval(expblock(cFieldName)),"")
       CASE cThisType == "C"
         aView[nCounter] +=SPACE(nPadding)+LTRIM( eval(workblock(cfieldname)) )
       CASE cThisType == "D"
         aView[nCounter] +=SPACE(nPadding)+DTOC( eval(workblock(cfieldname)) )
       CASE cThisType == "N"
         aView[nCounter] +=SPACE(nPadding)+LTRIM(STR( eval(workblock(cfieldname)) ))
       CASE cThisType == "L"
         aView[nCounter] +=SPACE(nPadding)+IIF(eval(workblock(cfieldname)),'True','False')
       ENDCASE

     NEXT
     *- achoice it - view only
     nNewCol = mchoice(aView,5,10,20,75)
     IF nNewCol > 0
       oTb:colpos := nNewCol
       oTb:refreshall()
     ENDIF

   CASE nLKey == 13 .and. recc()==0
      msg("No records exist yet - cannot edit. Add record(s) first.")
   CASE nLkey = 13 .AND.;
       aTypes[oTb:colpos] = "M" .AND. lAddEdit
     if SREC_LOCK(5,.T.,"Network error - Unable to lock record. Keep trying?")
        SET CURSOR ON
        cMemo := Editmemov(fieldget(fieldpos(cfieldname)),4,1,19,78,.T.)
        fieldput(fieldpos(cfieldname),cMemo)
        UNLOCK
        goto recno()
     ENDIF
     UNLOCK
     SET CURSOR OFF
     oTb:refreshall()


   CASE nLkey = 13 .AND.;
       aTypes[oTb:colpos] == "M" .AND. !lAddEdit

       Editmemov(fieldget(fieldpos(cfieldname)),4,1,19,78,.f.)


   CASE cLkey=="A" .AND. lAddEdit      // add
     cEdScreen := SAVESCREEN(0,0,24,79)
     DISPBOX(0,0,24,79,"ฑฑฑฑฑฑฑฑฑ")
     IF gened(.T.,2,22,aFields,aFdescr)
       oTb:refreshall()
     else
       go (nRecnoOld)
     ENDIF
     RESTSCREEN(0,0,24,79,cEdScreen)


   CASE nLkey = 13  .AND. lAddEdit .AND. isfield(cFieldName) .AND. ;
                          isthisarea(cFieldName)     // edit field
     if SREC_LOCK(5,.T.,"Network error - Unable to lock record. Keep trying?")
        SET CURSOR ON

        expGet   := fieldget(fieldpos(cfieldname))
        cEditColor := Setcolor(sls_popcol())
        cEditScreen := savescreen(0,0,24,79)

        v_editd(nRow)

        *- get the temp var
        @ nRow,nCol GET expGet PICTURE ed_g_pic(cfieldName)
        rat_read(getlist,1,.f.,27,{||ctrlw()})

        *- restore things
        Setcolor(cEditColor)
        RESTSCREEN(0,0,24,79,cEditScreen)

        IF lastkey() <> 27 .AND. ratupdated()
            *- changes made, not ESCAPE, replace field with new value
            fieldput(fieldpos(cfieldname),expGet)
            UNLOCK
            goto recno()
        ENDIF
        SET CURSOR OFF
        oTb:refreshall()
     endif
     UNLOCK
   CASE nLkey = 13  .AND. lAddEdit
     msg("That field is not EDITable")
   case MBRZMOVE(oTb,nMouseR,nMouseC,6,1,19,78)
   CASE MBRZCLICK(oTb,nMouseR,nMouseC)
         keyboard chr(K_ENTER)
   endcase

End
* restore environment
setcursor(nOldCursor)
RESTSCREEN(0,0,24,79,cInScreen)
Setcolor(cOldColor)
return ''

//=================================================================
static FUNCTION v_editd(nRow)
IF nRow >=10
  dispbox(5,28,7,62,sls_frame())
  @6,29 SAY "Enter to Save - Escape to Cancel"
ELSE
  dispbox(12,28,14,62,sls_frame())
  @13,29 SAY "Enter to Save - Escape to Cancel"
ENDIF
RETURN ''

//=================================================================
STATIC FUNCTION db_navig
LOCAL cNavBox
cNavBox = makebox(4,4,23,70,sls_popcol())

@5,5 SAY " ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ"
@6,5 SAY " Key                          Effect"
@7,5 SAY " ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ"
@8,5 SAY  " UpArrow                      Move up one row."
@9,5 SAY  " DnArrow                      Move down one row."
@10,5 SAY " LeftArrow                    Move left one column."
@11,5 SAY " RightArrow                   Move right one column."
@12,5 SAY " Ctrl LeftArrow               Pan left one column."
@13,5 SAY " Ctrl RightArrow              Pan right one column."
@14,5 SAY " Home                         Leftmost current screen column."
@15,5 SAY " End                          Rightmost current screen column."
@16,5 SAY " Ctrl-Home                    Leftmost column."
@17,5 SAY " Ctrl-End                     Rightmost column."
@18,5 SAY " PgUp                         Next edit window up."
@19,5 SAY " PgDn                         Next edit window down."
@20,5 SAY " Ctrl-PgUp                    First row of current column."
@21,5 SAY " Ctrl-PgDn                    Last row of current column."
@22,5 SAY " ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ"
rat_event(5)
unbox(cNavBox)
RETURN ''

//=================================================================
static function dskip(n)
  local skipcount := 0
  do case
  case n > 0
    do while !eof().and. skipcount < n
      dbskip(1)
      if !eof()
        skipcount++
      endif
    enddo
  case n < 0
    do while !bof() .and. skipcount > n
      dbskip(-1)
      if !bof()
        skipcount--
      endif
    enddo
  endcase
  if eof()
    dbgobottom()
  elseif bof()
    dbgotop()
  endif
return skipcount


//-------------------------------------------------------------------------
static function selfields(aInFields,aInFdescr,aFields,aFDescr,lBypassAsk)
local aSelect
local i
IF !lByPassAsk .and. ;
     !messyn("Field Selection:","Browse all fields","Select fields") .and. lastkey()#27
  aSelect := tagarray(aInFdescr,"Tag Fields for Browse")
  if len(aSelect) > 0
    asize(aFields,len(aSelect))
    asize(aFdescr,len(aSelect))
    for i = 1 to len(aSelect)
      aFields[i] := aInFields[aSelect[i]]
      aFDescr[i] := aInFdescr[aSelect[i]]
    next
  else
   aSize(aFields,len(aInFields))
   aSize(aFDescr,len(aInFdescr))
   acopy(aInFields,aFields)
   acopy(aInFdescr,aFdescr)
  endif
ELSE
   aSize(aFields,len(aInFields))
   aSize(aFDescr,len(aInFdescr))
   acopy(aInFields,aFields)
   acopy(aInFdescr,aFdescr)
ENDIF
return nil

//------------------------------------------------------------
static function edbmaketb(aFields,aFdescr,aTypes)
local nIter, cFieldName
local oTb := tbrowseNew(4,1,19,78)
for nIter = 1 to len(aFields)
   if aTypes[nIter]=="M"
    cFieldName := aFields[nIter]
    oTb:addColumn(TBColumnNew( aFdescr[nIter],{||"(memo)"}  ) )
   elseif isfield(aFields[nIter])
    oTb:addcolumn(TBColumnNew( aFdescr[nIter],workblock(aFields[nIter])))
   else
    oTb:addcolumn(TBColumnNew( aFdescr[nIter],expblock(aFields[nIter])))
   endif
next
oTb:gobottomblock := {||dbgobottom()}
oTb:gotopblock := {||dbgotop()}
oTb:skipblock := {|n|dskip(n)}
oTb:headsep := "ฤ"
oTb:colsep := "ณ"
//oTb:freeze := nFreeze
return oTb







