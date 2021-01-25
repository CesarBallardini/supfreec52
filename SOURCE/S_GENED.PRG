#include "inkey.ch"
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GENED()                              *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  GENED() Generic dbf editing screen
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  GENED([lModify],[nTop,nBottom],[aFields,aDesc])
ณ 
ณ  Description:
ณ  ------------
ณ  Edit ( [lModify] =.f.) current record (DEFAULT) or
ณ 
ณ  Add  ( [lModify] =.t.) new record.
ณ 
ณ  Window top [nTop] and bottom [nBottom] default to
ณ  centered.
ณ 
ณ  Use optional [aFields] (field names) and [aDesc]
ณ  (field descriptions), or use all fields in dbf.
ณ 
ณ  Examples:
ณ  ---------
ณ   use Customer index Customer
ณ 
ณ   Gened(.f.,2,20)   // edit
ณ 
ณ  Notes:
ณ  -------
ณ  Allows memo editing (multiple memo fields)
ณ  New to 3.5: memo editing is done to a memvar. Changes aren't
ณ  saved unless the whole record is saved. A global [F3=Memo] key
ณ  lets you pick which memo to edit.
ณ 
ณ  Source:
ณ  -------
ณ  S_GENED.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION gened(lAppending,nTop,nBottom,aFieldNames,aFieldDesc)

local cUnderWear,nFirstField,nMaxInBox,nCurrRow
local nCounter,nFieldLen,nPadding,cFieldName,cKeyIntent
local nFieldCount,lSaveIt,cScrollPict,expValue,cDbfAlias
local nIndexOrd,nOldCursor, bOldF10,bOldF3,bOldF9
local cAliasString,nIter, nLastKey
local aValues
local cMemoGet
local getlist := {}
local nThisRecord := recno()

*- no dbf, no function
IF !used()
  msg("Database required")
  RETURN .F.
ENDIF
lAppending := iif(lAppending#nil,lAppending,.f.)

if !lAppending
   IF !SREC_LOCK(5,.T.,"Unable to lock record for EDITING. Keep trying?")
     return .f.
   ENDIF
endif

* save environment, set things up
cUnderWear := savescreen(0,0,24,79)
nOldCursor := setcursor(1)
bOldF10    := setkey(K_F10,{||ctrlw()} )
bOldF3     := setkey(K_F3)

nFieldCount := iif(aFieldNames#nil,len(aFieldNames),fcount())

*- if no params for dimensions, determine approprate dimensions
IF VALTYPE(nTop) <> "N"
  nTop = MAX(1,10-INT(nFieldCount/2) )
ENDIF
IF VALTYPE(nBottom) <> "N"
  nBottom = MIN(nTop+4+nFieldCount,23)
ENDIF
while nBottom-nTop < 10
  nTop := MAX(nTop-1,0)
  nBottom := MIN(nBottom+1,24)
end



*- make two arrays - aFieldNames and field descriptions
IF aFieldNames==nil
  aFieldNames := array(nFieldCount)
  Afields(aFieldNames)
ENDIF
IF aFieldDesc==nil
  aFieldDesc := aclone(aFieldNames)
ENDIF

cDbfAlias       := ALIAS()
cAliasString    := cDbfAlias+"->"
aValues := array(nFieldCount+2)

*- if appending, store empty values, else store dbf values
IF lAppending
  GO BOTT
  SKIP
ENDIF
for nIter = 1 TO nFieldCount
  expValue = aFieldNames[nIter]
  *- fill with value from current dbf
  *- testing for related file with $">"
  IF (">"$expValue) .AND. (!cAliasString$expValue)
    aValues[nIter] = &expValue
  ELSE
    aValues[nIter] = &cDbfAlias->&expValue
  ENDIF
NEXT
if lAppending
  dbgoto( nThisRecord )
endif


*- set up some variables
lSaveIt         := .F.
cMemoGet        := " "
RATexit(.T.)


*- draw the edit window

dispbox(nTop,2,nBottom,78,"ฺฤฟณูฤภณ ")
@nTop+2,3 to nTop+2,77
@nBottom-2,3 to nBottom-2,77
if lAppending
  @ nBottom-1,3 SAY "[][] [PGUP] [PGDN]  [ESCAPE=Exit]  [F10=Save]  [F3=Memo]  [F9=Clone] "
  bOldF9 := setkey(K_F9,{||fillcurr(nFieldCount,aValues,aFieldNames,cAliasString,getlist,cDbfAlias) })
else
  @ nBottom-1,3 SAY "[][] [PGUP] [PGDN]  [ESCAPE=Exit]  [F10=Save]  [F3=Memo] "
endif

*- start at the first field
nFirstField := 1

IF lAppending
  *- appending
  @ nTop+1,4 SAY  "ADDING RECORD"
ELSE
  *- editing
  @ nTop+1,4 SAY  "EDITING RECORD"
ENDIF
SETKEY(K_F3,{||do_mem_ed(aFieldNames,aFieldDesc,aValues)})
DO WHILE .T.

  
  *- clear the whole box each time
  Scroll(nTop+3,3,nBottom-3,77,0)
  
  *- figure out last field in the box
  nMaxInBox  := MIN(nFirstField+((nBottom-3)-(nTop+3)),nFieldCount)
  
  *- current row is 1
  nCurrRow   := nTop+3
  
  *- for each field from the first in the box to the last in the box
  FOR nCounter = nFirstField TO nMaxInBox
    nFieldLen  := LEN(aFieldDesc[nCounter])
    nPadding   := 15-nFieldLen
    cFieldName := aFieldNames[nCounter]
    IF ">"$cFieldName  .AND. (!cAliasString$cFieldName)
      *- account for related aFieldNames
      IF lAppending
        @nCurrRow,3 SAY aFieldDesc[nCounter]+SPACE(nPadding+1)+"<related file>"
      ELSE
        @nCurrRow,3 SAY aFieldDesc[nCounter]+SPACE(nPadding+1)+aValues[nCounter]
      ENDIF
    ELSEIF !ISFIELD(cFieldName)
       @nCurrRow,3 SAY aFieldDesc[nCounter]+SPACE(nPadding+1)
       ??aValues[nCounter]
    ELSEIF TYPE(cFieldName) == "M"
       *- just say the description - no GET
       @nCurrRow,3 SAY aFieldDesc[nCounter]+SPACE(nPadding+1)+'(MEMO FIELD)'
    ELSEIF TYPE(cFieldName) = "C"
      *- character field
      @nCurrRow,3 SAY aFieldDesc[nCounter]+SPACE(nPadding)
      
      *- make a variable to hold a scrolling get picture of the
      *- appropriate length
      cScrollPict = "@S" + LTRIM(STR(76-COL() ))
      @ROW(),COL()+1 GET aValues[nCounter] PICT cScrollPict
    ELSE
      *- otherwise, just get SAY and GET the variable
      @nCurrRow,3 SAY aFieldDesc[nCounter]+SPACE(nPadding) GET aValues[nCounter] PICTURE ed_g_pic(cFieldName)
    ENDIF
    
    *- increment row
    nCurrRow = nCurrRow+1
  NEXT
  
  *- now do the READ
  RAT_READ(Getlist,1,.f.,27,;
      {|r,c|gemice(r,c,lAppending,nBottom,aFieldNames,aFieldDesc,aValues)})
  nLastKey := lastkey()
  
  
  DO CASE
  CASE (nLastKey == K_DOWN .OR. nLastKey == K_ENTER  .OR. nLastKey == K_PGDN)
    *- determine what first field in box should be - wrap around if needed
    IF nMaxInBox+ 1 > nFieldCount
      nFirstField = 1
    ELSE
      nFirstField = MIN(nMaxInBox + 1,nFieldCount)
    ENDIF
  CASE (nLastKey = K_UP  .OR. nLastKey = K_PGUP)
    *- determine what first field in box should be
    IF nFirstField = 1
      nFirstField = 1
    ELSE
      *nFirstField = MAX(nFirstField - 20,1)
      nFirstField = MAX(nFirstField - (nBottom-nTop-5),1)
    ENDIF
  CASE nLastKey==K_ESC
    IF MESSYN("Lose changes?")
      EXIT
    ENDIF
  CASE nLastKey = K_CTRL_END
    IF messyn("Save changes ?")
      IF lAppending
       IF !SADD_REC(5,.T.,"Unable to lock record to save. Keep trying?")
          lSaveIt = .f.
          EXIT
       ENDIF
       * record is locked with successful APPEND BLANK
      ENDIF
      *- replace aFieldNames with memvars
      nIndexOrd = INDEXORD()
      SET ORDER TO 0
      for nIter = 1 TO nFieldCount
        expValue = aFieldNames[nIter]
        REPLACE &expValue WITH aValues[nIter]
      NEXT
      SET ORDER TO (nIndexOrd)
      lSaveIt = .T.
    ENDIF
    EXIT
  ENDCASE
ENDDO
unlock
GOTO RECNO()  && TO flush

*- kill the box, restore the environment and exit
RESTSCREEN(0,0,24,79,cUnderWear)
SETCURSOR(nOldCursor)
SETKEY(K_F10,bOldF10)
SETKEY(K_F3,bOldF3)
if lAppending
  SETKEY(K_F9,bOldF9)
endif

RETURN lSaveIt

//------------------------------------------------------------------------
static proc fillcurr(nFieldCount,aValues,aFieldNames,cAliasString,aGets,cDbfAlias)
local nIter,expValue

for nIter = 1 TO nFieldCount
  expValue = aFieldNames[nIter]
  *- fill with value from current dbf
  *- testing for related file with $">"
  IF ">"$expValue .AND. (!cAliasString$expValue)
    aValues[nIter] = &expValue
  ELSE
    aValues[nIter] = &cDbfAlias->&expValue
  ENDIF
NEXT
for nIter := 1 to len(aGets)
  aGets[nIter]:updatebuffer()
  aGets[nIter]:display()
next
keyboard chr(K_PGDN)+chr(K_PGUP)
return

//------------------------------------------------------------------------

FUNCTION do_mem_ed(aFieldNames,aFieldDesc,aValues)
local i, nChoice
local aMemos := {}
local aMemosAt := {}
for i = 1 to len(aFieldNames)
  if type(aFieldNames[i])=="M"
    aadd(aMemos,aFieldDesc[i])
    aadd(aMemosAt,i)
  endif
next
if len(aMemos) > 1 .and. (nChoice := MCHOICE(aMemos,nil,nil,nil,nil,"Which Memo?") ) > 0
  aValues[aMemosAt[nChoice]] := EDITMEMOV(aValues[aMemosAt[nChoice]],;
   NIL,NIL,NIL,NIL,.t.,nil,aMemos[nChoice])
elseif len(aMemos)==1
  aValues[aMemosAt[1]] := EDITMEMOV(aValues[aMemosAt[1]],;
   NIL,NIL,NIL,NIL,.t.,nil,aMemos[1])
else
  msg("No Memo fields ")
endif
RETURN ''


STATIC FUNCTION gemice(nRow,nCol,lAppending,nBottom,aFieldNames,aFieldDesc,aValues)
local i
if nRow==nBottom-1
  do case
  case nCol >=3 .and. nCol <=5
    keyboard chr(K_UP)
  case nCol >=6 .and. nCol<=8
    keyboard chr(K_DOWN)
  CASE nCol >=10 .and. nCol <=15
    keyboard chr(K_PGUP)
  CASE nCol >=17.and. nCol <=21
    keyboard chr(K_PGDN)
  CASE nCol >=25.and. nCol <=37
    keyboard chr(K_ESC)
  CASE nCol >=40.and. nCol <=49
    keyboard chr(K_CTRL_END)
  CASE nCol >=52.and. nCol <=60
    do_mem_ed(aFieldNames,aFieldDesc,aValues)
  CASE lAppending .and. nCol >=63.and. nCol <=72
    EVAL(SETKEY(K_F9))
  ENDCASE
endIF
RETURN NIL





