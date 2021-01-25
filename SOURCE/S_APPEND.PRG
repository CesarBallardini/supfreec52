
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

static nFromArea
static nIntoArea
static cIntoAlias,cFromAlias
static bFromQuery
static aTagged
static nFilterType
static aIntoFields,aIntoTypes,aIntoLens,aIntoDecs
static aFromFields,aFromTypes,aFromLens,aFromDecs,aFromDesc
static nFromFields,nIntoFields
static aConversions
static oTb


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION APPENDIT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  APPENDIT() Intelligent APPEND FROM replacement
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  APPENDIT()
ณ 
ณ  Description:
ณ  ------------
ณ  Allows appending records from a database of
ณ  dissimiliar structures, allowing point-and-shoot selection of
ณ  field to field import. Import All/Query matches or Tagged
ณ  records. There are no parameters, but a database is required to
ณ  be open.
ณ 
ณ  Examples:
ณ  ---------
ณ   USE CUSTOMER
ณ   APPENDIT()            // metafunction, menu driven
ณ 
ณ  Notes:
ณ  -------
ณ  This can be painfully slow on a busy network
ณ 
ณ  Source:
ณ  -------
ณ  S_APPEND.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION appendit

local cOldQuery   := sls_query()
local cOldColor   := setcolor(sls_normcol())
local cOldScreen  := savescreen(0,0,24,79)
local nMainSelection := 0
local nIter
local lOpenAlready := .f.

nFromArea   := 0
nIntoArea   := 0
aTagged     := {}

nFilterType := 3
nIntoArea   := SELECT()
cIntoAlias  := ALIAS()
cFromAlias  := ""
aConversions:= {}


IF !USED()
  msg("Need DBF open")

else
  nIntoFields := fcount()
  aIntoFields := array(fcount())
  aIntoTypes  := array(fcount())
  aIntoLens   := array(fcount())
  aIntoDecs   := array(fcount())
  Afields(aIntoFields,aIntoTypes,aIntoLens,aIntoDecs)

  drawmain()
  do while .t.
     Setcolor(sls_popmenu())
     @19,2 SAY "[Import Into:]  "+PADR(cIntoAlias,40)
     @20,2 SAY "[Import From:]  "+PADR(cFromAlias,40)
     @21,2 SAY "[Filter Type:]  "+{"Query Matches   ",;
                                   "Tagged Records  ",;
                                   "None            "}[nFilterType]

     *- do the menu
     nMainSelection := RAT_MENU2({;
                          {2,3, "Select Import File"},;
                          {3,3, "Match Fields"},;
                          {4,3 ,"Do Import"},;
                          {5,3 ,"Quit"},;
                          {7,3 ,"Tag Records to Append"},;
                          {8,3 ,"Build or Modify Query"} } )
     Setcolor(sls_normcol())
     do case
     case nMainSelection==1

       aTagged  := {}
       if nFromarea > 0 .and. !lOpenAlready
          SELE (nFromArea)
          USE
       endif
       SELECT (nIntoArea)
       nFromArea := 0

       lOpenAlready := .f.
       if messyn("Select Import File","Pick from current directory","Type in the file path and name")
          cFromAlias   := popex('*.dbf','[Append From:]')
       elseif lastkey()#27
          cFromAlias   := space(30)
          popread(.t.,"Type in the file name",@cFromAlias,"@K")
          cFromAlias := UPPER(alltrim(cFromAlias))
          cFromAlias += iif(!".DBF"$cFromAlias,".DBF","")
          if !file(cFromAlias)
            msg(cFromAlias,"does not exist")
            cFromAlias := ""
          endif
       endif
       cFromAlias   := LEFT(cFromAlias,AT('.',cFromAlias)-1)

       IF !EMPTY(cFromAlias) .AND. ;
            !(strip_path(cFromAlias,.t.)==cIntoAlias) .and. ;
            (select(upper(strip_path(cFromAlias,.t.)))=0 )
         SELE 0
         IF SNET_USE(cFromAlias,strip_path(cFromAlias,.t.),.f.,5,.t.,"Unable to open "+cFromAlias+". Try again?")
           nFromArea = SELECT()
           nFromFields = Fcount()
           aFromFields := array(nFromFields)
           aFromTypes  := array(nFromFields)
           aFromLens   := array(nFromFields)
           aFromDecs   := array(nFromFields)
           aFromDesc   := array(nFromFields)
           Afields(aFromFields,aFromTypes,aFromLens,aFromDecs)

           FOR nIter = 1 TO nFromFields
             aFromDesc[nIter] = padr(aFromFields[nIter],10)+'   '+;
                                aFromTypes[nIter]+'   '+;
                                TRANS(aFromLens[nIter],"999")+'   '+;
                                TRANS(aFromDecs[nIter],"999")
           NEXT
         ELSE
           msg("Failed to open "+cFromAlias,"exiting APPEND procedure.")
           SELECT (nIntoArea)
           cFromAlias := ""
           nFromArea  := 0
         endif
       ELSEIF ( strip_path(cFromAlias,.t.)==cIntoAlias)
         MSG("Can't import into a DBF from itself...")
         cFromAlias := ""
         nFromArea  := 0
       ELSEIF (select(upper(strip_path(cFromAlias,.t.)))#0 )
         nFromArea  := select(upper(strip_path(cFromAlias,.t.)))
         select (nFromArea)
         nFromFields = Fcount()
         aFromFields := array(nFromFields)
         aFromTypes  := array(nFromFields)
         aFromLens   := array(nFromFields)
         aFromDecs   := array(nFromFields)
         aFromDesc   := array(nFromFields)
         Afields(aFromFields,aFromTypes,aFromLens,aFromDecs)

         FOR nIter = 1 TO nFromFields
           aFromDesc[nIter] = padr(aFromFields[nIter],10)+'   '+;
                              aFromTypes[nIter]+'   '+;
                              TRANS(aFromLens[nIter],"999")+'   '+;
                              TRANS(aFromDecs[nIter],"999")
         NEXT
         lOpenAlready := .t.
       ENDIF
       bFromQuery  := {||.t.}
       SELE (nIntoArea)
       nFilterType := 3
       aConversions:= {}

     case nMainSelection==2  .and. nFromArea > 0  // match fields
         sfim_import()
     case nMainSelection==2
         msg("Select Import File")
     case nMainSelection==3 // do import
        IF nFromArea > 0 .and. len(aConversions) > 0
         IF messyn("Go ahead with import ?")
           sfim_doit()
           SELE (nFromArea)
           USE
           bFromQuery  := {||.t.}
           nFilterType := 3
           SELECT (nIntoArea)
           nFromArea   := 0
           cFromAlias  := ""
           aConversions:= {}
         else
           msg("Select Import File and Match Fields")
         ENDIF
        endif
     case nMainSelection==4 // quit
         exit
     case nMainSelection==5 .and. nFromArea > 0 // tag
           SELECT (nFromArea)
           tagit(aTagged)
           if len(aTagged) > 0
             nFilterType := 2
             bFromQuery = {||(ascan(aTagged,recno())> 0)}
           else
             nFilterType := 3
             bFromQuery  := {||.t.}
           endif
           SELECT (nIntoArea)

     case nMainSelection==6 .and. nFromArea > 0 // query
           SELECT (nFromArea)
           *- build query for other area
           sls_query("")
           QUERY()
           if !empty(sls_query() )
             nFilterType := 1
             bFromQuery := &("{||"+sls_query()+"}" )
           else
              nFilterType := 3
              bFromQuery  := {||.t.}
           endif
           sls_query( cOldQuery)
           SELECT (nIntoArea)
     case ISPART(nMainSelection,5,6)
         msg("Select Import File")
     endcase

  enddo

endif
if nFromarea > 0 .and. !lOpenAlready
   SELE (nFromArea)
   USE
endif
SELECT (nIntoArea)
sls_query(cOldQuery)
setcolor(cOldColor)
RESTSCREEN(0,0,24,79,cOldScreen)

nFromArea  := nil ;nIntoArea  := nil;cIntoAlias := nil;cFromAlias := nil
bFromQuery := nil ;aTagged    := nil;nFilterType:= nil;aIntoFields:= nil
aIntoTypes := nil ;aIntoLens  := nil;aIntoDecs := nil ;aFromFields:= nil
aFromTypes := nil ;aFromLens := nil ;aFromDecs := nil ;aFromDesc := nil
nFromFields := nil ;nIntoFields := nil ; aConversions := nil ; oTb := nil

RETURN ''

//==================================================================

static FUNCTION sfim_import
local lOldExact
local nIter
local nExistMatch
local nElement := 1
local cUnder := savescreen(1,1,23,78)
local cEmpty := repl(chr(177),50)
local expGet,cGetPic
local cWorkType
local nWorklen
local expTemp
local nLastKey, nMouseR, nMouseC, nCurrRow, cLastKey
local aButtons, nButton := 0


SELECT (nIntoArea)
if empty(aConversions)
  aConversions := array( (cIntoAlias)->(fcount())     )
  afill(aConversions,"")
endif

lOldExact = SET(_SET_EXACT,.t.)


FOR nIter = 1 TO nFromFields
  //nExistMatch = Ascan(aFromFields,aIntoFields[nIter])
  nExistMatch = Ascan(aIntoFields,aFromFields[nIter])
  IF nExistMatch > 0
    IF aFromTypes[nIter]==aIntoTypes[nExistMatch] .and.;
       aFromLens[nIter]==aIntoLens[nExistMatch] .and.;
       aFromDecs[nIter]==aIntoDecs[nExistMatch]
          aConversions[nExistMatch] := aFromFields[nIter]
    ENDIF
  ENDIF
NEXT

oTb := tbrowseNew(2,2,19,77)
oTb:headsep := "ฤ"
oTb:colsep := "ณ"
oTb:addcolumn(tbcolumnNew("Target File Fields",;
        {||padr(aIntofields[nElement],15)+iif(empty(aConversions[nElement]),"    "," =>  " )} ))
oTb:getcolumn(1):width := 20
oTb:addcolumn(tbcolumnNew("Append From Import Fields",{||padr(aConversions[nElement],50,chr(177))} ))
oTb:getcolumn(2):width := 50
oTb:skipblock := {|n|app_skip(n,@nElement)}
oTb:gobottomblock := {||nElement := nIntoFields}
oTb:gotopblock := {||nElement := 1}

@ 1,1,23,78 BOX "ฺฤฟณูฤภณ "
@ 1,3 SAY "[Match Fields]"
@ 20,1 SAY 'ร'
@ 20,78 SAY 'ด'
@ 2,3 SAY "Target File Fields         Append From Import File Fields:"
@ 20,2 SAY "ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
@ 21,3 SAY "[][]                       [ENTER=Select Target Field]"
@ 22,3 SAY "[F2=Type In Import Value]    [F3=Complex Import Value  ]    [F10=Done/Exit]"

aButtons := {;
            {21,3 ,21,5,K_UP},;
            {21,6 ,21,8,K_DOWN},;
            {21,32,21,58,K_ENTER},;
            {22,3,22,27,K_F2},;
            {22,32,22,58,K_F3},;
            {22,63,22,77,K_F10};
            }
nMouseR := 0
nMouseC := 0
DO WHILE .T.
  while !oTb:stabilize()
  end
  nCurrRow := ROW()
  nLastKey := RAT_EVENT(0,.F.,.f.,@nMouseR, @nMouseC)
  cLastKey := upper(chr(nLastKey))
  if nLastKey==K_MOUSELEFT
    nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
    if nButton<>0
      cLastKey := upper(chr(nButton))
    endif
  endif

  DO CASE
  CASE nLastKey = K_DOWN .or. nButton==K_DOWN
    oTb:down()
    if nButton==K_DOWN
      IFMOUSEHD({||oTb:down()},oTb)
    endif
  CASE nLastKey = K_PGDN
    oTb:pagedown()
  CASE nLastKey = K_END
    oTb:gobottom()
  CASE nLastKey = K_UP .or. nButton==K_UP
    oTb:up()
    if nButton==K_UP
      IFMOUSEHD({||oTb:up()},oTb)
    endif
  CASE nLastKey = K_PGUP
    oTb:pageup()
  CASE nLastKey = K_HOME
    oTb:gotop()
  CASE isalpha(chr(nLastKey))
    sfim_alpha(nLastKey,@nElement)
    oTb:refreshall()
  CASE nLastKey = K_ENTER .or. nButton==K_ENTER
    sfim_match(aFromDesc,nElement)
    oTb:refreshall()
  CASE nLastKey = K_ESC
    EXIT
  CASE nLastKey = K_F10 .OR. nLastKey= K_CTRL_END .or. nButton==K_F10
    EXIT
  CASE (nLastKey = K_F3 .OR. chr(nLastKey)=="3" .or. nButton==K_F3) .and. ;
        !empty(aConversions[nElement] )    // extended expression
    IF MESSYN("Extend "+aConversions[nElement]+" as a complex expression?")
        select (nFromArea)
        aConversions[nElement] := BUILDEX("Import Value",aConversions[nElement],.t.)
        expTemp     := &( aConversions[nElement] )
        nWorkLen  := varlen(expTemp)
        cWorktype := valtype(expTemp)
        CHECKVAL(nElement,cWorktype,nworkLen)
        select (nIntoArea)
    ENDIF
    oTb:refreshall()
  CASE nLastKey = K_F2  .OR. cLastKey=="2" .or. nButton==K_F2   // type it in
    do case
    case aIntoTypes[nElement] =="C"
      expGet   := space(aIntoLens[nelement])
      cGetPic  := "@S25"
    case aIntoTypes[nElement] =="D"
      expGet   := date()
      cGetPic  := ""
    case aIntoTypes[nElement] =="L"
      expGet   := .f.
      cGetPic  := "Y"
    case aIntoTypes[nElement] =="N"
      expGet   := 0
      cGetPic  := repl("9",aIntoLens[nElement])
      if aIntoDecs[nElement] > 0
        cGetPic  := stuff(cGetPic,aIntoLens[nElement]-aIntoDecs[nElement],1,".")
      endif
    case aIntoTypes[nElement] =="M"
      expGet   := space(100)
      cGetPic  := "@S25"
    endcase
    IF MESSYN("Type in "+aIntoFields[nElement]+" import value?")
      popread(.t.,"Type it in:",@expGet,cGetPic)
      //aConversions[nElement] := "["+trans(expGet,"")+"]"
      IF lastkey()#27
        do case
        case aIntoTypes[nElement] =="C"
          aConversions[nElement] := "["+expGet+"]"
        case aIntoTypes[nElement] =="D"
          aConversions[nElement] := "CTOD("+DTOC(expGet)+")"
        case aIntoTypes[nElement] =="L"
          aConversions[nElement] := IIF(expGet,".t.",".f.")
        case aIntoTypes[nElement] =="N"
          aConversions[nElement] := trans(expGet,cGetPic)
        case aIntoTypes[nElement] =="M"
          aConversions[nElement] := "["+expGet+"]"
        endcase
      endif
    ENDIF
    oTb:refreshall()
  case MBRZMOVE(oTb,nMouseR,nMouseC,4,2,19,77)
  case MBRZCLICK(oTb,nMouseR,nMouseC)
       keyboard chr(K_ENTER)
  ENDCASE
ENDDO
SET(_SET_EXACT,lOldExact)
restscreen(1,1,23,78,cUnder)
return nil

//==================================================================


static FUNCTION sfim_match(aFromDesc,nElement)
local cUnder := makebox(0,40,24,78,Setcolor(),0)
local nChoice := 0
local cWorkType
local nWorklen
local expGet1,expGet2

select (nFromArea)

@ 3,41 TO 3,77
@ 3,40 SAY 'ร'
@ 3,78 SAY 'ด'

@ 20,41 TO 20,77
@ 20,40 SAY 'ร'
@ 20,78 SAY 'ด'
@ 2, 43 SAY "Field       Type   Len    Dec"
@ 1,42 SAY cFromAlias+" Field List"
@ 21,42 SAY "Select field to import into "
@ 22,43 SAY padr(aIntoFields[nElement],10)+'   '+;
                 aIntoTypes[nElement]+'   '+;
                 TRANS(aIntoLens[nElement],"999")+'   '+;
                 TRANS(aIntoDecs[nElement],"999")
att(22,43,22,73,14)
@ 23,42 SAY "Or press ESCAPE for no selection"
nChoice := SACHOICE(4,43,19,77,aFromDesc,nil,nil,nil,20,42,{||KBDESC()})
IF nChoice > 0
  aConversions[nElement] := aFromFields[nChoice]
  cWorktype := aFromTypes[nChoice]
  nWorkLen  := aFromLens[nChoice]
  checkval(nElement,cWorktype,nWorkLen)
  *- comment this out if you don't want to call BUILDEX
ELSE
  aConversions[nElement] = ""
ENDIF
select (nIntoArea)
unbox(cUnder)
RETURN nil

//==================================================================

STATIC FUNCTION CHECKVAL(nelement,cWorktype,nworkLen)
local expGet1,expGet2
do case
case aIntoTypes[nElement]=="C"
  do case
  case cWorktype$"CM"
     IF nWorkLen > aIntoLens[nElement]
       if MESSYN("Length of Source fields exceeds length of Target field",;
                 "Truncate Right","Truncate Left")
          aConversions[nElement]:="LEFT("+aConversions[nElement]+","+;
                 alltrim(str(aIntoLens[nElement]))+")"
       else
          aConversions[nElement]="SUBST("+aConversions[nElement]+",-"+;
                  alltrim(str(aIntoLens[nElement]))+")"
       endif
     ENDIF

  case cWorktype=="D"
     IF aIntoLens[nElement] < 8
       msg(aIntoFields[nElement]+" is less than 8 characters.",;
            "8 characters or more are required")
       aConversions[nElement]=""
     else
       if messyn("Converting a DATE field to a CHARACTER field. Use:",;
                 "MM/DD/YY","YYYYMMDD")
         aConversions[nElement]="DTOC("+aConversions[nElement]+")"
       ELSE
         aConversions[nElement]="DTOS("+aConversions[nElement]+")"
       ENDIF
     endif
  case cWorktype=="L"
      expGet1 := space(aIntoLens[nElement])
      expGet2 := expGet1
      popread(.t.,"Convert Logical TRUE to Character value  :",@expGet1,"",;
                  "Convert Logical FALSE to Character value :",@expGet2,"")
      aConversions[nElement]="IIF("+aConversions[nElement]+;
                  ",["+expGet1+"],["+expGet2+"])"
  case cWorktype=="N"
      if aIntoLens[nElement] < nWorkLen
          IF MESSYN("Length of Source fields exceeds length of Target field",;
                    "Truncate result","Abandon")
             aConversions[nElement]="SUBST(STR("+aConversions[nElement]+"),-"+;
                      alltrim(str(aIntoLens[nElement]))+")"
          else
             aConversions[nElement]=""
          endif
      else
        aConversions[nElement]="STR("+aConversions[nElement]+")"
      endif
  endcase
case aIntoTypes[nElement]=="M"
  do case
  case cWorktype=="D"
      if messyn("Converting a DATE field to a CHARACTER field. Use:",;
                "MM/DD/YY","YYYYMMDD")
        aConversions[nElement]="DTOC("+aConversions[nElement]+")"
      ELSE
        aConversions[nElement]="DTOS("+aConversions[nElement]+")"
      ENDIF
  case cWorktype=="L"
      expGet1 = space(50)
      expGet2 = expGet1
      popread(.t.,"Convert Logical TRUE to Character value  :",@expGet1,;
                  "Convert Logical FALSE to Character value :",@expGet2)
      aConversions[nElement]="IIF("+aConversions[nElement]+;
                  ",["+expGet1+"],["+expGet2+")"
  case cWorktype=="N"
       aConversions[nElement]="STR("+aConversions[nElement]+")"
  endcase
case aIntoTypes[nElement]=="D" .and. (!cWorktype=="D")
  MSG("You are attempting to move a non Date value into a Date",;
      "Field. Select 'Extend as a complex expression' and convert",;
      "To Date first")
   aConversions[nElement]=""
case aIntoTypes[nElement]=="L" .and. (!cWorktype=="L")
  msg("You are attempting to move a non-logical value into",;
      "a Logical field. No-can-do!")
   aConversions[nElement]=""
case aIntoTypes[nElement]=="N"
  do case
  case !cWorktype=="N"
    MSG("You are attempting to move a non Numeric value into a Numeric",;
        "Field. Select 'Extend as a complex expression' and convert",;
        "To Numeric first")
     aConversions[nElement]=""
  case cWorktype=="N"
    aConversions[nElement]="VAL(STR("+aConversions[nElement]+","+;
                         alltrim(str(aIntoLens[nElement]))+","+;
                         alltrim(str(aIntoDecs[nElement]))+"))"
    MSG("Note: If the size of the TARGET field is less than the ",;
        "size of the replacement value, a ZERO value will result.")
  endcase
endcase
return nil


//==================================================================

static FUNCTION sfim_alpha(nKey,nElement)
local cKey        := upper(chr(nKey))
local nTmpElement := IIF(nElement=nIntoFields,1,nElement+1)

DO WHILE !(nTmpElement=nElement)
  IF LEFT(aIntoFields[nTmpElement],1) == cKey
    nElement := nTmpelement
    EXIT
  ENDIF
  nTmpElement = IIF(nTmpElement=nIntoFields,1,nTmpElement+1)
ENDDO
RETURN ''

//==================================================================
static FUNCTION sfim_doit

LOCAL nAppCount
LOCAL cUnder
LOCAL nNtxOrder,nIter

local aReplacewith := {}
local aReplace  := {}
local cStripAlias := strip_path(cFromAlias,.t.)

for nIter = 1 TO nIntoFields
  IF !EMPTY(aConversions[nIter])
    aadd(aReplacewith, &("{||"+aConversions[nIter]+"}" ) )
    aadd(aReplace, FieldWblock(aIntoFields[nIter],nIntoArea) )
  ENDIF
NEXT

nNtxOrder := INDEXORD()
SET ORDER TO 0
nAppCount := 0
cUnder    := makebox(6,20,14,61)

@ 9,20 SAY 'ร'
@ 9,61 SAY 'ด'
@ 7,23 SAY "Appending records"
@ 8,23 SAY "from "+cStripAlias+" into "+cIntoAlias
@ 9,21 SAY "ฤฤฤฤ[ESC to stop process ]ฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
@ 11,23 SAY "0 records appended"
CLEAR TYPEAHEAD
SELECT (nFromArea)
LOCATE FOR eval(bFromQuery)
DO WHILE FOUND()
  //IF inkey() = 27 .or. rat_rightb()
  IF RAT_CHECKESC()
    IF messyn("Stop process ?")
      EXIT
    ENDIF
    CLEAR TYPEAHEAD
  ENDIF
  nAppCount++
  @ 11,23 SAY nAppCount
  ??" records appended"


  SELECT (nIntoArea)
  if SADD_REC(5,.t.,"Network error - Unable to append record. Keep trying?")
     FOR nIter = 1 to len(aReplace)
       eval(aReplace[nIter],(cStripAlias)->(eval(aReplacewith[nIter]))  )
     NEXT
     unlock
  else
     msg("Unable to append record - returning to menu")
     SELECT (nFromArea)
     exit
  endif
  SELECT (nFromArea)
  CONTINUE
ENDDO

unbox(cUnder)
SET ORDER TO nNtxOrder
return nil

//==================================================================
//==================================================================
static function app_skip(n,curr_row)
  local skipcount := 0
  do case
  case n > 0
    do while curr_row+skipcount < fcount()  .and. skipcount < n
      skipcount++
    enddo
  case n < 0
    do while curr_row+skipcount > 1 .and. skipcount > n
      skipcount--
    enddo
  endcase
  curr_row += skipcount
return skipcount

//==================================================================

STATIC PROC DRAWMAIN
Setcolor(sls_normcol())
@ 0,0,24,79 BOX sls_frame()
Setcolor(sls_popmenu())
@1,1,9,25 BOX sls_frame()
@18,1,23,78 BOX sls_frame()
@1,5 SAY '[Append]'
@19,2 SAY "[Import Into:]"
@20,2 SAY "[Import From:]"
@21,2 SAY "[Filter Type:]"
RETURN


