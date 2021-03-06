
#define SEARCH_FIELD   1
#define SEARCH_QUERY   2
#define SEARCH_EOF     3
#define SEARCH_BOF     4
#define SEARCH_DELETED 5
#define SEARCH_MEMO    6
#define SEARCH_ABORT   7

static lCanContinue     := .f.
static bLocateBlock
static cAlias           // new 10-15-1992

/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION SEARCHME()
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  SEARCHME() Search a DBF with user-specified criteria
� 
�  Returns:
�  --------
�  <bSearch> -> The code block used to do the search
� 
�  Syntax:
�  -------
�  SEARCHME([aField,aFieldTypes,aFieldLengths],[aFieldDesc])
� 
�  Description:
�  ------------
�  Searches the current dbf with criteria given
�
�  by the user.
� 
�       for :    Field Contents Match
�                Query match  --->> calls QUERY()
�                End of file
�                Beginning of File
�                Deleted Records
�                Memo contents
� 
�  On subsequent calls, if the previous search resulted
�  in a FOUND(), a box asking "Continue..", "New Search" will pop up.
�  If CONTINUE is selected, a continuation of the last search is
�  done.
� 
�  Three arrays may be passed for FIELDS [aFields],
�  FIELD TYPES [aFieldTypes], and FIELD LENGTHS [aFieldLengths].
� 
�  An additional (optional) array of field descriptions may be passed
� 
�  Default is all fields, field names as descriptions.
� 
�  Searchme() actually returns the code block used to do the
�  search. Normally you would want to ignore this. I use it in
�  TAGIT() - if the code block is not NIL, then I can 'tag all
�  matching' with it.
�
�
�  Examples:
�  ---------
�  SEARCHME()
�
�  Source:
�  -------
�  S_SEARCH.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
FUNCTION searchme(aFieldnames,aFieldtypes,aFieldlens,aFieldSays)

local lContinuing,  nOldRecord
local nSearchType
local nOldCursor,lOldExact

//--------new 10-15-1992 -----------------------
if cAlias==nil            // set up our alias
  searchmrs()
  cAlias := ALIAS()
elseif cAlias#ALIAS()     // check for a DBF switch
  searchmrs()             // reset
  cAlias := ALIAS()
endif
//--------new 10-15-1992 -----------------------

if (aFieldnames==nil .or. aFieldtypes==nil .or. aFieldlens==nil)
  aFieldnames :=array(fcount())
  aFieldtypes :=array(fcount())
  aFieldlens  :=array(fcount())
  Afields(aFieldnames,aFieldtypes,aFieldlens)
endif
if aFieldSays==nil
  aFieldSays := array(fcount() )
  afields(aFieldSays)
endif

lOldExact = setexact()
nOldCursor = iif(set(16)=0,.f.,.t.)
SET CURSOR ON
lContinuing = .F.

*- if a CONTINUE is applicable, find out from the user if it is
*- desirable
IF lCanContinue
  lContinuing = messyn("Continue from last search ?","Continue..","New Search")
ENDIF

nOldRecord = RECNO()
*- if no CONTINUE is wanted, build the LOCATE string
while .t.

   IF lContinuing
     if !trycontinue()       // attempt to do a continue
       go (nOldRecord)
     endif
   ELSE
     bLocateBlock  := nil
     nSearchType = SEARCH_FIELD

     nSearchType = menu_v("[Search for:]","Field Contents Match      ",;
                          "Query match","End of file","Beginning of File",;
                          "Deleted Records","Memo contents","Never Mind")

     IF !( nSearchType = 0 .OR. nSearchType = SEARCH_ABORT )

        IF nSearchType = SEARCH_FIELD
          searchfld(aFieldNames,aFieldTypes,aFieldLens,aFieldSays)
        ELSEIF nSearchType = SEARCH_QUERY
          IF !EMPTY(sls_query())
            IF messyn("Modify Query ?")
              QUERY(aFieldNames,aFieldSays,aFieldTypes)
            endif
            IF !EMPTY(sls_query())
              bLocateBlock := sls_bquery()
            ENDIF
          ELSEIF isloaded("QUERY()")
            IF messyn("No query set .....BUILD ONE NOW?")
              QUERY(aFieldNames,aFieldSays,aFieldTypes)
              IF !EMPTY(sls_query())
                bLocateBlock := sls_bquery()
              ENDIF
            ENDIF
          ENDIF
        ELSEIF nSearchType = SEARCH_EOF
          GO BOTT
          LOCATE for .t. while .t.
          searchmfnd(.t.)     // new 10-15-1992
          lCanContinue = .F.
          exit
        ELSEIF nSearchType = SEARCH_BOF
          GO TOP
          LOCATE for .t. while .t.
          searchmfnd(.t.)     // new 10-15-1992
          lCanContinue = .F.
          exit
        ELSEIF nSearchType = SEARCH_DELETED
          bLocateBlock := {||DELETED()}
        ELSEIF nSearchType = SEARCH_MEMO
          searchmemo(aFieldNames,aFieldTypes,nil,aFieldSays)
        ENDIF

        if valtype(bLocateBlock)=="B"
          plswait(.T.,"Looking....")
          go top
          //locate for eval(bLocateBlock) while (inkey()#27 .and. !rat_rightb() )
          locate for eval(bLocateBlock) while !RAT_CHECKESC()
          plswait(.F.)
          searchmfnd( found() )    // new 10-15-1992
          IF .NOT. FOUND()
            GO nOldRecord
            IF !LASTKEY()=27
              msg("No match found...")
            ELSE
              msg("User aborted search..")
            ENDIF
            lCanContinue = .F.
          ELSE
            *- if we found one, there may be others. Set lCanContinue to .t.
            lCanContinue = .T.
          ENDIF
        endif
     endif
   ENDIF  // continue
   exit
end
SET CURSOR (nOldCursor)
setexact(lOldExact)

RETURN bLocateBlock


//陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
STATIC FUNCTION getmemos(aFieldNames,aFieldTypes,aFieldSays,aMemoNames)
local nIterator
local nMemoCount   := 0
local aMemoFields  := {}
FOR nIterator = 1 TO len(aFieldNames)
  IF aFieldTypes[nIterator] == "M"
    nMemoCount++
    aadd(aMemoFields,aFieldNAmes[nIterator])
    aadd(aMemoNames,aFieldSays[nIterator])
  ENDIF
NEXT
RETURN aMemoFields


//陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
STATIC FUNCTION charops    // character operators
return { "== is exactly equal to",;
         ">  is greater than",;
         "<  is less than",;
         ">= is greater than or equal to",;
         "<= is less than or equal to",;
         "#  is not equal to",;
         "$  contains",;
         "S  starts with",;
         "E  ends with",;
         "?  WILDCARD"  }

//陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
STATIC FUNCTION dnoops    // date/numeric operators
return { "=  is equal to",;
         ">  is greater than",;
         "<  is less than",;
         ">= is greater than or equal to",;
         "<= is less than or equal to",;
         "#  is not equal to"  }

//陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�

STATIC FUNCTION trycontinue
  *- execute the CONTINUE
  SET EXACT OFF
  plswait(.T.,"Looking....")
  CONTINUE
  plswait(.F.)
  searchmfnd( found() )      // 10-15-1992 new
  IF .NOT. FOUND()
    msg("No more matches... ")
    lCanContinue = .F.
  ELSE
    *- if we found something, set lCanContinue to .t. to allow more CONTINUE's
    lCanContinue = .T.
  ENDIF
return found()

//陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
#define MEMO_CONTAINS 1
#define MEMO_ISEMPTY  2
#define MEMO_NOTEMPTY 3

STATIC FUNCTION searchmemo(aFieldNames,aFieldTypes,nFieldSelection,aFieldSays)
local    aOperators  :={"$  contains",;
                        "E  is empty",;
                        "N  is not empty"}
local    aMemoNames  := {}
local    aMemoFields := getmemos(aFieldNames,aFieldtypes,aFieldSays,aMemoNames)
local    cMemoTargetField := ""
local    cMemoName   := ""
local    nMemoSelection
local    nOperatorSelection,cOperatorDescription,cTargetValue


   IF nFieldSelection#nil
     cMemoTargetField := aFieldNames[nFieldSelection]
     cMemoName := aFieldSays[nFieldSelection]
   ELSEIF len(aMemoFields)==0
     msg("No memo fields in this datafile.")
   ELSEIF len(aMemoFields) > 1
     nMemoSelection = mchoice(aMemoNames,2,50,9,77,"Memo field to SEARCH")
     IF nMemoSelection > 0
       cMemoTargetField = aMemoFields[nMemoSelection]
       cMemoName := aMemoNames[nMemoSelection]
     ENDIF
   ELSE
     cMemoTargetField := aMemoFields[1]
     cMemoName := aMemoNames[1]
   ENDIF

   while !empty(cMemoTargetField)
      nOperatorSelection   := mchoice(aOperators,5,20,13,60,;
              "Locate record where memo "+cMemoName+":")
      if nOperatorSelection==0
        exit
      endif
      cOperatorDescription := SUBST(aOperators[nOperatorSelection],4)

      IF nOperatorSelection == MEMO_CONTAINS
          cTargetValue = SPACE(60)
          popread(.T.,padr('Locate for '+cMemoName+;
                  ' contains  : ',70),@cTargetValue,"")
          cTargetValue := Alltrim(cTargetValue)
          IF !EMPTY(cTargetValue)
            bLocateBlock := ;
              {||cTargetValue$xFieldGet(cMemoTargetField)}
          ENDIF
      ELSEIF nOperatorSelection == MEMO_ISEMPTY
        bLocateBlock := {||empty(xFieldGet(cMemoTargetField))}
      ELSEIF nOperatorSelection == MEMO_NOTEMPTY
        bLocateBlock := {||!empty(xFieldGet(cMemoTargetField))}
      ENDIF
      EXIT
   ENDDO
RETURN nil


//陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
#define OCHAR_EXACT 1
#define OCHAR_GT    2
#define OCHAR_LT    3
#define OCHAR_GTE   4
#define OCHAR_LTE   5
#define OCHAR_NOTEQUAL    6
#define OCHAR_CONTAINS    7
#define OCHAR_STARTSWITH  8
#define OCHAR_ENDSWITH    9
#define OCHAR_WILDCARD    10
#define DN_EQ      1
#define DN_GT      2
#define DN_LT      3
#define DN_GTE     4
#define DN_LTE     5
#define DN_NOT     6

static function searchfld(aFieldNames,aFieldTypes,aFieldLens,aFieldSays)
local nFieldSelection,cTargetField,cSearchString
local aOperators,nOperatorSelection,cOperatorDescription
local nLengthOfSearch
local cTargetValue,nTargetValue,dTargetValue,lTargetValue
local cInstruction,cLengthPicture
local cFieldName

  *- call MCHOICE() to do an achoice on the aFieldnames[] array
  nFieldSelection = mchoice(aFieldSays,5,20,20,50,;
              "[  Select Search Field  ] ")

  *- Vern made a selection!
  while nFieldSelection # 0
    cFieldName := aFieldSays[nFieldSelection]
    *- cTargetField contains the name of the selected field to LOCATE on
    cTargetField  := aFieldnames[nFieldSelection]
    cSearchString := aFieldnames[nFieldSelection]

    DO CASE
    CASE aFieldtypes[nFieldSelection] == "C"
        aOperators  := charops()
        nOperatorSelection   := mchoice(aOperators,5,20,16,60,;
           "[ Locate record where "+cFieldName+": ] ")
        if nOperatorSelection==0
         exit
        endif
        cOperatorDescription := SUBST(aOperators[nOperatorSelection],4)
        DO CASE
        CASE nOperatorSelection = OCHAR_WILDCARD
          cInstruction = "WILDCARD match (*=any group of chars, ?=any single char) for "+cFieldName
        OTHERWISE
          cInstruction = padr('Locate for '+cFieldName+' '+cOperatorDescription+'   ',70)
        ENDCASE
        cTargetValue = SPACE(aFieldlens[nFieldSelection])
        cLengthPicture = "@S"+LTRIM(STR(MIN(aFieldlens[nFieldSelection],65)))
        popread(.T.,cInstruction,@cTargetValue,cLengthPicture)
        if lastkey()==27
          exit
        endif
        IF nOperatorSelection > OCHAR_EXACT   // if not exact, trim it
          cTargetValue = Alltrim(cTargetValue)
        ENDIF
        IF nOperatorSelection < OCHAR_CONTAINS  //7
          DO CASE
          CASE nOperatorSelection==OCHAR_EXACT
            bLocateBlock := {||xFieldGet(cTargetField)==cTargetValue}
          CASE nOperatorSelection==OCHAR_GT
            bLocateBlock := {||xFieldGet(cTargetField) > cTargetValue}
          CASE nOperatorSelection==OCHAR_LT
            bLocateBlock := {||xFieldGet(cTargetField) < cTargetValue}
          CASE nOperatorSelection==OCHAR_GTE
            bLocateBlock := {||xFieldGet(cTargetField) >= cTargetValue}
          CASE nOperatorSelection==OCHAR_LTE
            bLocateBlock := {||xFieldGet(cTargetField) <= cTargetValue}
          CASE nOperatorSelection==OCHAR_NOTEQUAL
            bLocateBlock := {||xFieldGet(cTargetField) # cTargetValue}
          ENDCASE
        ELSEIF nOperatorSelection = OCHAR_CONTAINS
          bLocateBlock := {||cTargetValue$xFieldGet(cTargetField)}
        ELSEIF nOperatorSelection = OCHAR_STARTSWITH
          nLengthOfSearch := LEN(cTargetValue)
          bLocateBlock := ;
            {||LEFT(xFieldGet(cTargetField),nLengthOfSearch)==;
            cTargetValue}
        ELSEIF nOperatorSelection = OCHAR_ENDSWITH
          nLengthOfSearch := LEN(cTargetValue)
          bLocateBlock := ;
            {||SUBST(TRIM(xFieldGet(cTargetField)),-nLengthOfSearch);
            ==cTargetValue}
        ELSEIF nOperatorSelection = OCHAR_WILDCARD
          bLocateBlock := ;
            {||_WILDCARD(cTargetValue,xFieldGet(cTargetField))}
        ENDIF
    CASE aFieldtypes[nFieldSelection] == "D"
        aOperators  := dnoops()
        nOperatorSelection   := mchoice(aOperators,5,20,16,60,;
           "[ Locate record where "+cFieldName+": ] ")
        if nOperatorSelection==0
         exit
        endif
        cOperatorDescription := SUBST(aOperators[nOperatorSelection],4)
        dTargetValue = CTOD("  /  /  ")
        popread(.T.,'Locate for '+cFieldName+' '+cOperatorDescription+'  : '+SPACE(1),@dTargetValue,'')
        if lastkey()==27
          exit
        endif
        DO CASE
        CASE nOperatorSelection == DN_EQ
          bLocateBlock := {||xFieldGet(cTargetField)=dTargetValue}
        CASE nOperatorSelection == DN_GT
          bLocateBlock := {||xFieldGet(cTargetField)>dTargetValue}
        CASE nOperatorSelection == DN_LT
          bLocateBlock := {||xFieldGet(cTargetField)<dTargetValue}
        CASE nOperatorSelection == DN_GTE
          bLocateBlock := {||xFieldGet(cTargetField)>=dTargetValue}
        CASE nOperatorSelection == DN_LTE
          bLocateBlock := {||xFieldGet(cTargetField)<=dTargetValue}
        CASE nOperatorSelection == DN_NOT
          bLocateBlock := {||xFieldGet(cTargetField)#dTargetValue}
        ENDCASE
    CASE aFieldtypes[nFieldSelection] == "N"
        aOperators  := dnoops()
        nOperatorSelection   := mchoice(aOperators,5,20,16,60,;
           "[ Locate record where "+cFieldName+": ] ")
        if nOperatorSelection==0
         exit
        endif
        cOperatorDescription := SUBST(aOperators[nOperatorSelection],4)
        nTargetValue = 0
        popread(.T.,'Locate for '+cFieldName+' '+cOperatorDescription+'  : '+SPACE(15),@nTargetValue,ed_g_pic(cTargetField))
        if lastkey()==27
          exit
        endif
        DO CASE
        CASE nOperatorSelection == DN_EQ
          bLocateBlock := {||xFieldGet(cTargetField)=nTargetValue}
        CASE nOperatorSelection == DN_GT
          bLocateBlock := {||xFieldGet(cTargetField)>nTargetValue}
        CASE nOperatorSelection == DN_LT
          bLocateBlock := {||xFieldGet(cTargetField)<nTargetValue}
        CASE nOperatorSelection == DN_GTE
          bLocateBlock := {||xFieldGet(cTargetField)>=nTargetValue}
        CASE nOperatorSelection == DN_LTE
          bLocateBlock := {||xFieldGet(cTargetField)<=nTargetValue}
        CASE nOperatorSelection == DN_NOT
          bLocateBlock := {||xFieldGet(cTargetField)#nTargetValue}
        ENDCASE
    CASE aFieldtypes[nFieldSelection]=="L"
        *- if its a LOGICAL, we just have one operator (=)
        nOperatorSelection   := 1
        cOperatorDescription := "="
        lTargetValue = .F.
        popread(.T.,'Locate for '+cFieldName+' '+cOperatorDescription+'  : '+SPACE(1),@lTargetValue,'')
        if lastkey()==27
          exit
        endif
        if lTargetValue
         bLocateBlock := {||xFieldGet(cTargetField)}
        else
         bLocateBlock := {||!xFieldGet(cTargetField)}
        endif
    CASE aFieldtypes[nFieldSelection]=="M"
      searchmemo(aFieldNames,aFieldTypes,nFieldSelection,aFieldSays)
    ENDCASE
    exit
  enddo //nFieldSelection > 0
RETURN NIL


/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION SEARCHMFND()                      *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  SEARCHMFND() Set/return last found() status from SEARCHME()
�
�  Returns:
�  --------
�  <lFound> -> Last searchme found() status
�
�  Syntax:
�  -------
�  SEARCHMFND([lSet])
�
�  Description:
�  ------------
�  Sets/retrieves the last found() setting for SEARCHME()
�  [lSet] optionally sets the found() flag.
�
�  For instance, to find out what the last result of SEARCHME() was
�  so you can take an action or not based on something being found,
�  use SEARCHMFND() to retrieve the last result.
�
�  Examples:
�  ---------
�  SEARCHMFND(.f.)
�
�  Source:
�  -------
�  S_SEARCH.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
FUNCTION searchmfnd(lSet)   // returns if last operation FOUND() anything
static lFound := .f.
local lReturn := lFound
if lSet#nil
  lFound := lSet
endif
return lReturn



/*
寥様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� FUNCTION SEARCHMRS()                      *new*
突様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�
�  Short:
�  ------
�  SEARCHMRS() Resets all SEARCHME() settings
�
�  Returns:
�  --------
�  NIL
�
�  Syntax:
�  -------
�  SEARCHMRS([)
�
�  Description:
�  ------------
�  Resets all SEARCHME() static variables
�    - sets found() flag to FALSE
�    - sets locate block to nil
�    - sets continue flag to .f.
�    - sets ALIAS to nil
�
�  For instance, if you change datafiles - you need to reset
�  SEARCHME() with SEARMRS()
�
�  Examples:
�  ---------
�  SEARCHMRS()
�
�  Source:
�  -------
�  S_SEARCH.PRG
�
梦様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/
FUNCTION searchmrs()        // resets FOUND() flag to .f.
searchmfnd(.f.)
bLocateBLock := nil         // sets locate block to nil
lCanContinue := .f.         // sets continue flag to .f.
cAlias       := nil         // sets ALIAS to nil
return nil
//-------new 10-15-1992 --------------------


static function xfieldget(cField)
local xValue
if "->"$cField
  xValue := (parsalias(cField))->(fieldget(fieldpos(parsfield(cField) )))
else
  xValue := fieldget(fieldpos(cField))
endif
return xValue

