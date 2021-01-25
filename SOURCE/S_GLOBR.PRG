
#define REP_TYPEIN      1
#define REP_UPPER       2
#define REP_LOWER       3
#define REP_PROPER      4
#define REP_FORMULA     5
#define REP_CANCEL      6

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GLOBREP()                    *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ  GLOBREP() Performs global selective replace of a field
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  GLOBREP([aFields,aDesc])
ณ 
ณ  Description:
ณ  ------------
ณ  Allows user to point to a field and then enter a
ณ  replacement value for it. Replacement can be executed for all
ณ  records, query matches, or tagged records.
ณ
ณ  [aFields,aDesc] arrays of field names, and field
ณ  descriptions.
ณ
ณ  Examples:
ณ  ---------
ณ   If nChoice == 9   // Global replace
ณ 
ณ     GLOBREP()
ณ 
ณ   endif
ณ 
ณ  Warnings:
ณ  ----------
ณ  These changes are, of course, permanent.
ณ  New to 3.5:
ณ  -Preview (view changes before they happen)
ณ  -'Build Formula' replacement option type. Lets user build a
ณ  formula for replacing the target field.
ณ
ณ  Source:
ณ  -------
ณ  S_GLOBR.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION globrep(aFieldNames,aFieldDesc)

local aFieldTypes,aFieldLens,aFieldDeci
local aTagged       := {}
local nOldCursor    := SETCURSOR(0)
LOCAL cOldcolor     := SETCOLOR()
local nIndexOrder   := INDEXORD()
local cInScreen     := savescreen(0,0,24,79)
local cTargetField  := ""
local NTargetField  := 0
local cOtherField   := ""
local bReplBlock
local nMainMenu,nOtherField
LOCAL nReplaceType,cInfoBox
LOCAL expRepl,cPicture,nQueryType,bQuery
local nReplaced
local bShow1, bShow2, expFormula

IF !used()
  msg("No DBf in use")
  RETURN ''
ENDIF

if aFieldNames==nil .or. aFieldDesc==nil
  aFieldNames  := getfields()
  aFieldDesc   := getfields()
endif

aFieldTypes := array(len(aFieldNames))
aFieldLens  := array(len(aFieldNames))
aFieldDeci  := array(len(aFieldNames))
Fillarr(aFieldNames,aFieldTypes,aFieldLens,aFieldDeci)

Setcolor(sls_normcol())

@0,0,24,79 BOX sls_frame()
Setcolor(sls_popmenu())
@1,1,8 ,35 BOX sls_frame()
@18,1,23,78 BOX sls_frame()
@1,5 SAY '[Global Field Replace/Modify]'

*- do the main loop
DO WHILE .T.
  *- the menu
  Setcolor(sls_popmenu())
  nMainMenu := ;
    RAT_MENU2({ {2,3 ,"Select Field to Replace"},;
                {3,3 ,"Replacement Options"},;
                {4,3 ,"Execute Replacement"},;
                {5,3 ,"Preview Replacement"},;
                {7,3 ,"Quit"}} )

  DO CASE
  CASE nMainMenu = 1
    Scroll(19,2,22,77,0)
    nTargetField := mchoice(aFieldDesc,05,29,16,51,"[Field to Replace]")
    IF nTargetField > 0
      nReplacetype = 0
      IF aFieldTypes[nTargetField] == "M"
        msg("Sorry - can't do replacements on MEMO fields")
        nTargetField := 0
      ELSE
        @20,3 SAY "Replacing/modifying field : "+aFieldNames[nTargetField]
        cTargetField := aFieldNames[nTargetField]
        bReplBlock := nil
      ENDIF
    ENDIF
  CASE nMainMenu = 2 .AND. nTargetField > 0
      nReplacetype := menu_v("Replace field <"+cTargetField+'> with:',;
                      "Type in a value             ",;
                      "Uppercase",;
                      "Lowercase",;
                      "Proper (first letter caps)     ",;
                      "Build Formula                  ",;
                      "Cancel")
      DO CASE
      CASE nReplacetype = REP_TYPEIN
        cPicture := ""
        DO CASE
        CASE aFieldTypes[nTargetField]== "C"
          expRepl  := space(aFieldLens[nTargetField])
          cPicture := "@S20"
        CASE aFieldTypes[nTargetField] == "N"
          expRepl  := 0
          cPicture := repl("9",aFieldLens[nTargetField])
          if aFieldDeci[nTargetField] > 0
            cPicture := stuff(cPicture,;
                        aFieldLens[nTargetField]-aFieldDeci[ntargetField],1,".")
          endif
        CASE aFieldTypes[nTargetField] == "D"
          expRepl  := CTOD('  /  /  ')
        CASE aFieldTypes[nTargetField] == "L"
          expRepl  := .F.
        ENDCASE
        popread(.t.,"Replace with:",@expRepl,cPicture)
        @21,3 SAY "Replacing with            : [VALUE ENTERED BY USER]"
        bReplBlock := {||expRepl}
      CASE nReplacetype < REP_CANCEL .AND. ;
         (aFieldTypes[nTargetField] # "C") .and. nReplaceType<>REP_FORMULA
        msg("Must be type character to convert to Uppercase, Lowercase or Proper")
      CASE nReplacetype = REP_UPPER
        @21,3 SAY "Converting to             : Uppercase format"
        bReplBlock := {||upper(fieldget(nTargetField))}
      CASE nReplacetype = REP_LOWER
        @21,3 SAY "Converting to             : Lowercase format"
        bReplBlock := {||lower(fieldget(nTargetField))}
      CASE nReplacetype = REP_PROPER
        @21,3 SAY "Converting to             : Proper format"
        bReplBlock := {||proper(fieldget(nTargetField))}
      CASE nReplacetype = REP_FORMULA
        expFormula := GRFORMULA(cTargetField,aFieldNames,;
                        aFieldDesc,aFieldNames[nTargetField])
        if !empty(expFormula)
          @21,3 SAY "Replacing with user formula: "+left(expFormula,35)+"..."
          bReplBlock := &("{||"+expFormula+"}")
        endif
      ENDCASE
  CASE nMainMenu = 2 .AND. nTargetField = 0
      msg("Select target field")
  CASE nMainMenu = 3 .AND. nTargetField > 0 .and. bReplBlock#nil
      nQueryType := menu_v("[Record Selection]",;
                           "All Records           ",;
                           "Query Matches      ",;
                           "Tagged Records         ",;
                           "Cancel")
      DO CASE
      CASE nQueryType = 2
        IF !EMPTY(sls_query()) .AND. messyn("Modify current Query ?")
          QUERY(aFieldNames,aFieldNames,aFieldTypes)
        ELSE
          QUERY(aFieldNames,aFieldNames,aFieldTypes)
        ENDIF
        if !empty(sls_query())
          bQuery := sls_bquery()
        endif
        @22,3 SAY "Records being replaced    : RECORDS MATCHING QUERY"
      CASE nQueryType = 3
        tagit(aTagged)
        if len(aTagged) > 0
          bQuery := {||ascan(aTagged,RECNO())>0}
        endif
        @22,3 SAY "Records being replaced    : RECORDS TAGGED BY USER"
      CASE nQueryType = 0 .OR. nQueryType =4
        bQuery := nil
      OTHERWISE
        bQuery := {||.t.}
        @22,3 SAY "Records being replaced    : ALL RECORDS IN DATABASE"
      ENDCASE
      IF bQuery#nil .and. messyn("Execute replacement now ? (Changes will be permanent)")
        IF SFIL_LOCK(5,.T.,"Unable to lock the file for replacement. Keep trying?")
           *- save index order and set order to 0 for a faster replace
           SET ORDER TO 0
           cInfoBox := makebox(5,19,13,55)
           @ 5,21 SAY "[Replacement]"
           @ 7,21 SAY "Total Records"
           @ 9,21 SAY "Number Checked"
           @ 11,21 SAY "Number Replaced"
           @7,41 say trans(recc(),'9999999999')
           GO TOP
           locate for eval(bQuery)
           nReplaced := 0
           while found()
             nReplaced++
             @9,41  say trans(recno(), '9999999999')
             @11,41 say trans(nReplaced, '9999999999')
             fieldput(nTargetField,eval(bReplBlock))
             continue
           end
           *- put the index order back , and annouce completion
           SET ORDER TO nIndexOrder
           unlock
           unbox(cInfoBox)
           msg("Replacement Done!")
           nReplacetype   := 0
        endif
      ENDIF
      Scroll(19,2,22,77,0)
  CASE nMainMenu = 3 .AND. (nTargetField = 0 .or. bReplBlock==nil)
      msg("Select target field and define replacement options")
  CASE nMainMenu = 4  .AND. (nTargetField = 0 .or. bReplBlock==nil)
      msg("Select target field and define replacement options")
  CASE nMainMenu = 4
      bShow1 := &("{||"+;
              "PADR(TRANS("+aFieldNames[nTargetField]+",''),35)"+"}")
      bShow2 := {||padr(trans(eval(bReplBlock),""),35)}
      smalls( {||eval(bShow1)+eval(bShow2)},;
        "Before                             After" )
  CASE nMainMenu = 5 .OR. nMainMenu = 0
    restscreen(0,0,24,79,cInscreen)
    setcolor(cOldColor)
    SETCURSOR(nOldCursor)
    exit
  ENDCASE
ENDDO
RETURN ''
//--------------------------------------------------------
static function getfields
local aFieldarr := array(fcount())
aFields(aFieldarr)
return aFieldArr


STATIC FUNCTION GRFORMULA(cField,aFields,aFDesc,cReplace)
local cExpress := FORMULATE("",aFields,aFDesc,;
         "Create Formula/User Defined field to replace "+cReplace)

if !empty(cExpress)
  cExpress := GCHECKREP(cField,cExpress)
endif
return cExpress

//-----------------------------------------------------------
STATIC FUNCTION GCHECKrep(cField,expReplace)
local expGet1,expGet2
local cWorkType := TYPE(expReplace)
local nWorkLen
local cFieldType:= FIELDTYPEX(cField)
local nFieldLen := FIELDLENX(cField)
local nFieldDec := FIELDDECX(cField)
do case
case cFieldType=="C"
  do case
  case cWorktype$"CM"
     nWorkLen := len(&expReplace)
     IF nWorkLen > nFieldLen
       if MESSYN("Length of Replace formula exceeds length of Target field",;
                 "Truncate Right","Truncate Left")
          expReplace := "LEFT("+expReplace+","+ALLTRIM(STR(nFieldLen))+")"
       else
          expReplace := "RIGHT("+expReplace+","+ALLTRIM(STR(nFieldLen))+")"
       endif
     ELSE
          expReplace := "LEFT("+expReplace+","+ALLTRIM(STR(nFieldLen))+")"
     ENDIF

  case cWorktype=="D"
     IF nFieldLen < 8
       msg(cField+" is less than 8 characters.",;
            "8 characters or more are required")
       expReplace := ""
     else
       if messyn("Converting a DATE field to a CHARACTER field. Use:",;
                 "MM/DD/YY","YYYYMMDD")
         expReplace := "DTOC("+expReplace+")"
       ELSE
         expReplace := "DTOS("+expReplace+")"
       ENDIF
     endif
  case cWorktype=="L"
      expGet1 := space(nFieldLen)
      expGet2 := expGet1
      popread(.t.,"Convert Logical TRUE to Character value  :",@expGet1,"",;
                  "Convert Logical FALSE to Character value :",@expGet2,"")
      expReplace:="IIF("+expReplace+",["+expGet1+"],["+expGet2+"])"
  case cWorktype=="N"
      if nFieldLen < nWorkLen
          IF MESSYN("Length of Replace formula exceeds length of Target field",;
                    "Truncate result","Abandon")
             expReplace:="SUBST(STR("+expReplace+"),-"+;
                      alltrim(str(nFieldLen))+")"
          else
             expReplace=""
          endif
      else
        expReplace="STR("+expReplace+")"
      endif
  endcase
case cFieldType=="M"
  do case
  case cWorktype=="D"
       if messyn("Converting a DATE field to a CHARACTER field. Use:",;
                 "MM/DD/YY","YYYYMMDD")
         expReplace :="DTOC("+expReplace+")"
       ELSE
         expReplace :="DTOS("+expReplace+")"
       ENDIF
  case cWorktype=="L"
      expGet1 := space(50)
      expGet2 := expGet1
      popread(.t.,"Convert Logical TRUE to Character value  :",@expGet1,"",;
                  "Convert Logical FALSE to Character value :",@expGet2,"")
      expReplace:="IIF("+expReplace+",["+expGet1+"],["+expGet2+"])"
  case cWorktype=="N"
       expReplace="STR("+expReplace+")"
  endcase
case cFieldType=="D" .and. (!cWorktype=="D")
  MSG("You are attempting to move a non Date value into a Date",;
      "Field. Can't do that")
      expReplace=""
case cFieldType=="L" .and. (!cWorktype=="L")
  msg("You are attempting to move a non-logical value into",;
      "a Logical field. No-can-do!")
      expReplace=""
case cFieldType=="N"
  do case
  case !cWorktype=="N"
    MSG("You are attempting to move a non Numeric value into a Numeric",;
        "Field. Can't do that")
      expReplace=""
  case cWorktype=="N"
    expReplace:="VAL(STR("+expReplace+","+;
                         alltrim(str(nFieldLen))+","+;
                         alltrim(str(nFieldDec))+"))"
    MSG("Note: If the size of the TARGET field is less than the ",;
        "size of the replacement value, a ZERO value will result.")
  endcase
endcase
return expReplace




