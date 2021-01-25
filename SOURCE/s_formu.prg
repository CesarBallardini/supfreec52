
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FORMULATE()                          *new*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  FORMULATE() Builds a free-form formula or User Defined Field
ณ
ณ  Returns:
ณ  --------
ณ  <cFormula> => String containing formula
ณ
ณ  Syntax:
ณ  -------
ณ  FORMULATE([cInFormula],[aFields], [aFDesc], [cDisplay],[cTypes] )
ณ
ณ
ณ  Description:
ณ  ------------
ณ  Allows ad hoc creation of formulas (expressions) by mixing freeform
ณ  text, function templates and operators.
ณ
ณ  [cInFormula] Optional character string containing the formula to
ณ               modify
ณ  [aFields]    Optional list of dbf field names
ณ  [aFDesc ]    Optional list of alternate names for dbf field names
ณ  [cDisplay]   Optional text for the prompt. Default is :
ณ               "Create Formula/User Defined field:"
ณ  [cTypes]     Optional string containing allowed return types (in caps)
ณ               Default is "CDNL" (char, date, numeric, logical)
ณ
ณ  Examples:
ณ  ---------
ณ
ณ  1. cExpress := FORMULATE("",nil,nil,"Create logical expression","L")
ณ
ณ  2.(taken from FORMLETR() )
ณ
ณ    cAddExpress := FORMULATE(aEdit[nThisLine],aFieldNames,aFieldDesc,;
ณ       "Modify Label Contents (must result in type CHARACTER):",;
ณ       "C")
ณ
ณ
ณ  Notes:
ณ  -------
ณ
ณ  Source:
ณ  -------
ณ  S_FORMU.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/

FUNCTION FORMULATE(cInFormula,aFields, aFDesc,cDisplay,cTypes)
local cExpress, cFormulaBox, cText, oGet, cWork, cInExpress
local nLastKey, aButtons, nButton, nMouseR, nMouseC
local nScrCol, i, cKey, cCheckType
local aFieldList, aFieldDesc, nCursor

cInExpress := iif(cInFormula#nil,cInFormula,"")
cExpress  := padr(iif(cInFormula#nil,cInFormula,""),200)
cFormulaBox := makebox(4,0,15,79)
cText     := iif(cDisplay#nil,cDisplay,;
             "Create Formula/User Defined field:")
aFieldList:= iif(aFields#nil,aFields,iif(used(),AFIELDSX(),) )
aFieldDesc:= iif(aFields#nil,aFDesc, iif(used(),AFIELDSX(),) )
cTypes    := iif(cTypes#nil,cTypes,"CDNL")
nCursor   := SETCURSOR()
set cursor on

@ 7,3 SAY cText

if used()
  @12,3  say '[F2=FieldList]'
endif
@12,23 say '[F3=Operators]'
@12,43 say '[F4=Formulas ]'
@12,63 say '[F5=Results  ]'
@14,3  say '[ENTER=OK]'
@14,15 say '[ESC=Cancel]'
aButtons := {;
            {12,3,12,16,K_F2 },;
            {12,23,12,36,K_F3},;
            {12,43,12,56,K_F4},;
            {12,63,12,76,K_F5},;
            {14,3,14,12,K_ENTER},;
            {14,15,14,26,K_ESC};
            }

oGet := GetNew(9,3,;
    {|_1|iif(_1#nil,cExpress:=_1,cExpress)},"CEXPRESS","@S74")
oGet:setfocus()
nLastKey := 0
nMouseR  := 0
nMouseC  := 0
nButton  := 0
while .t.

  oGet:assign()
  oGet:display()

  nButton := 0
  nLastKey := rat_event(0,.f.,.f.,@nMouseR, @nMouseC)
  if nLastKEy==K_MOUSELEFT
    nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
  endif
  do case

  case nLastKey==K_MOUSELEFT .and. ;
    nMouseR==9 .and. nMouseC>=3 .and. nMouseC<=77
      nScrCol := col()
      if nScrCol < nMouseC
        for i = 1 to nMouseC-nScrCol
          oGet:right()
          oGet:display()
        end
      elseif nScrCol > nMouseC
        for i = 1 to nScrCol-nMouseC
          oGet:left()
          oGet:display()
        next
      end
  case (nLastKey == K_INS)
      Set( _SET_INSERT, !Set(_SET_INSERT) )

  case (nLastKey == K_CTRL_U)
      oGet:Undo()

  case (nLastKey == K_RIGHT)
      oGet:Right()

  case (nLastKey == K_LEFT)
      oGet:Left()

  case (nLastkey == K_HOME)
      oget:Home()

  case (nLastkey == K_END)
       oget:End()

  case (nLastKey == K_CTRL_RIGHT)
      oGet:WordRight()

  case (nLastKey == K_CTRL_LEFT)
      oGet:WordLeft()

  case (nLastKey == K_BS)
      oGet:BackSpace()

  case (nLastKey == K_DEL)
      oGet:Delete()

  case (nLastKey == K_CTRL_T)
      oGet:DelWordRight()

  case (nLastKey == K_CTRL_Y)
      oGet:DelEnd()

  case (nLastKey == K_CTRL_BS)
      oGet:DelWordLeft()

  case (nLastKey >= 32 .and. nLastKey <= 255)
      cKey := Chr(nLastKey)
      if ( Set(_SET_INSERT) )
          oGet:Insert(cKey)
      else
          oGet:Overstrike(cKey)
      end

  case (nLastKey=K_F2  .or. nButton==K_F2)
       if used()
          cWork := GETFIELDS(aFieldList,aFieldDesc)
          if !empty(cWork)
              oGet:varput(stuff(oGet:varget(),oGet:pos(),0,cWork))
              oGet:varput(padr(trim(oGet:varget()),200)    )
              keyboard repl(chr(K_RIGHT),len(cWork) )
              oGet:updatebuffer()
          endif
       endif
  case nLastKey=K_F3  .or. nButton==K_F3
       cWork := GETOPERA()
       if !empty(cWork)
           oGet:varput(stuff(oGet:varget(),oGet:pos(),0,cWork))
           oGet:varput(padr(trim(oGet:varget()),200)    )
           keyboard repl(chr(K_RIGHT),len(cWork) )
           oGet:updatebuffer()
       endif

  case nLastKey=K_F4  .or. nButton==K_F4
       cWork := GET_TPLATE()
       if !empty(cWork)
           oGet:varput(stuff(oGet:varget(),oGet:pos(),0,cWork))
           oGet:varput(padr(trim(oGet:varget()),200)    )
           keyboard repl(chr(K_RIGHT),len(cWork) )
           oGet:updatebuffer()
       endif

  case (nLastKey=K_F5  .or. nButton==K_F5)
        if empty(cExpress)
           msg("Formula is empty")
        elseif (cCheckType := checktype(alltrim(cExpress)))$cTypes
           if used()
             smalls( &("{||PADR(trans("+alltrim(cExpress)+",''),60)}")  )
           else
             msg( trans(&cExpress,"")  )
           endif
        elseif !("U"$cCheckType)
          amsg({"Formula result is of wrong type.",;
                "Formula result type is:"+cCheckType,;
                "Required result type must be one of:"+cTypes})
        else
           msg("Formula is of unknown type, and cannot be used.")
        endif

  case ( nLastKey == K_ESC .or. nButton==K_ESC)
      cExpress := cInExpress
      exit

  case nLastKey=K_ENTER .or. nButton==K_ENTER
      if !empty(cExpress) .and. (cCheckType := checktype(alltrim(cExpress)))$cTypes
         exit
      elseif empty(cExpress)
         exit
      elseif !("U"$cCheckType)
         amsg({"Formula result is of wrong type.",;
              "Formula result type is:"+cCheckType,;
              "Required result type must be one of:"+cTypes})
         if messyn("Formula result is of wrong type.","Abandon","Edit")
           cExpress := cInExpress
           exit
         endif
      else
         msg("Formula is of unknown type, and cannot be used.")
         if messyn("Formula is of unknown type and cannot be used.","Abandon","Edit")
           cExpress := cInExpress
           exit
         endif
      endif
  endcase
end
setcursor(nCursor)
unbox(cFormulaBox)
return alltrim(cExpress)



//------------------------------------------------------------------
static function get_tplate  // get a formula template
local cForm := ""
local aForm := init_tpl()
local nForm
local cOldcolor := setcolor(sls_popcol() )
keyboard chr(K_DOWN)+chr(K_DOWN)+chr(K_DOWN)
nForm := browse2d(4,0,19,79,aform, ;
            {"Formula","Description","Template"},,"Choose a Formula")
if nForm > 0
  cForm := aForm[nForm,3]
  cForm := strtran(cForm,"c",'""')
  cForm := strtran(cForm,"n",'1')
  cForm := strtran(cForm,"d",'date()')
  cForm := strtran(cForm,"l",'.f.')
endif
setcolor(cOldColor)
return cForm

//------------------------------------------------------------------
static function init_tpl()
local aForm := {}
aadd(aform,{"ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ","",""})
aadd(aform,{"ณCharacter Formulasณ","",""})
aadd(aform,{"ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู","",""})
aadd(aForm,{"LEFT(c,n)","Take first n characters from character field c"," LEFT(c,n)"})
aadd(aForm,{"          ", "e.g. LEFT(LNAME,5)"," LEFT(c,n)"})
aadd(aForm,{"LOWER(c)","Translate character field c to lower case"," LOWER(c)"})
aadd(aForm,{"PADC(c,n)","Center character field c in n spaces"," PADC(c,n)"})
aadd(aForm,{"PADL(c,n)","PAD character field c with n spaces on left"," PADL(c,n)"})
aadd(aForm,{"         ","hint: use PADL(ALLTRIM(c),n) to right-justify","PADL(c,n)"})
aadd(aForm,{"PADR(c,n)","Pad character field c with n spaces on right"," PADR(c,n)"})
aadd(aForm,{"         ","hint: use PADR(ALLTRIM(c),n) to left-justify","PADR(c,n)"})
aadd(aForm,{"PROPER(c)","Capitalize character field c (1st letter caps)"," PROPER(c)"})
aadd(aForm,{"REPLICATE(c,n)","Repeat character(s) c,  n times"," REPLICATE(c,n)"})
aadd(aForm,{"RTRIM(c)","Trim all right spaces from character field c"," RTRIM(c)"})
aadd(aForm,{"SPACE(n)","One or more (n) spaces"," SPACE(n)"})
aadd(aForm,{"STR(n1,n2)","Change number n1 to character, with length of n2   "," STR(n,n)"})
aadd(aForm,{"SUBST(c,n1,n2)","Extract n2 chars starting at n1 from char field c "," SUBST(c,n,n)"})
aadd(aForm,{"UPPER(c)","Translate char field c to uppercase"," UPPER(c)"})
aadd(aForm,{"VAL(c)","Translate character field c into a number"," VAL(c)"})
aadd(aForm,{"EMPTY(c)","Is c empty? "," EMPTY(c)"})
aadd(aform,{"ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ","",""})
aadd(aform,{"ณDate Formulas   ณ","",""})
aadd(aform,{"ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู","",""})
aadd(aForm,{"CDOW(d)","Translate date field d to character name of DAY"," CDOW(d)"})
aadd(aForm,{"CMONTH(d)","Translate date field d to character name of MONTH"," CMONTH(d)"})
aadd(aForm,{"DATE()","Today's date                                   "," DATE()"})
aadd(aForm,{"DAY(d)","Translate date field d to numeric day of month "," DAY(d)"})
aadd(aForm,{"DOW(d)","Translate date field d to numeric day of week "," DOW(d)"})
aadd(aForm,{"DTOC(d)","Translate date field d to char form [MM/DD/YY]"," DTOC(d)"})
aadd(aForm,{"DTOS(d)","Translate date field d to char form [YYYYMMDD]"," DTOS(d)"})
aadd(aForm,{"MONTH(d)","Translate date field d to numeric month  "," MONTH(d)"})
aadd(aForm,{"YEAR(d)","Translate date field d to numeric year "," YEAR(d)"})
aadd(aForm,{"EMPTY(d)","Is d empty? )"," EMPTY(d)"})
aadd(aform,{"ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ","",""})
aadd(aform,{"ณNumeric Formulasณ","",""})
aadd(aform,{"ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู","",""})
aadd(aForm,{"ABS(n)","Absolute value of numeric field n (no - + sign)"," ABS(n)"})
aadd(aForm,{"INT(n)","Integer part of numeric field n (no decimals)"," INT(n)"})
aadd(aForm,{"MAX(n1,n2)","Largest number in a set of numbers n1,n2"," MAX(n,n)"})
aadd(aForm,{"MIN(n2,n2)","Smallest number in a set of numbers n1,n2 "," MIN(n,n)"})
aadd(aForm,{"MOD(n1,n2)","Remainder of number n1 divided by number n2"," MOD(n,n)"})
aadd(aForm,{"ROUND(n1,n2)","Round number n1 to n2 decimals "," ROUND(n,n)"})
aadd(aForm,{"EMPTY(n)","Is n empty? (0) "," EMPTY(n)"})
return aForm



//------------------------------------------------------------------
static FUNCTION getopera
local cReturn := ""
local nReturn
local aOpers := {;
           "Operator         Action                             Result Type",;
           "---------------------------------------------------------------",;
           " *               Multiplication                     (Math)",;
           " +               Add numeric                        (Math)",;
           " -               Subtract numeric                   (Math)",;
           " /               Division of two numbers            (Math)",;
           " %               Modulus of two numbers             (Math)",;
           " +               Concatenate characters             (Character)",;
           " -               Concatenate characters             (Character)",;
           " <>              Not equal                          (Logical)",;
           " <               Less than                          (Logical)",;
           " <=              Less than or equal                 (Logical)",;
           " =               Equal                              (Logical)",;
           " $               Substring (is contained in...)     (Logical)",;
           " .AND.           Logical AND                        (Logical)",;
           " .NOT. !         Logical NOT                        (Logical)",;
           " .OR.            Logical OR                         (Logical)",;
           " >=              Greater than or equal              (Logical)",;
           " >               Greater than                       (Logical)",;
           " ==              Exactly equal                      (Logical)",;
           " ( )             Function or grouping indicator     " }
nReturn := mchoice(aOpers,4,0,19,79,"Operators",.f.)
if nReturn > 2
  cReturn := alltrim(left(aOpers[nReturn],8))
endif
return cReturn


*----------function to popup and keyboard a field name
static function getfields(aFieldNames,aFieldDesc)
local nSelection := mchoice(aFieldDesc,4,20,19,49,"Select Field")
if nSelection > 0
  return  aFieldNames[nSelection]
endif
return ""


*------------returns actual TYPE, including UDF type, and handles errors
*------------in expressions by returning U. Uses temporary error object.
static function checktype(cInExpress)
local cExpress := alltrim(cInExpress)
local cType := TYPE(cExpress)
local xValue
local bError
local bErrorBlock := ERRORBLOCK( {|bError|furecover(bError)}  )
BEGIN SEQUENCE
   * check type here
   if cType=="UI"
        xValue = &cExpress
        cType = valtype(xValue)
   endif
RECOVER USING bError
   cType = "U"
END SEQUENCE
ERRORBLOCK(bErrorBlock)
cType:=iif(cType=="M","C",cType)
return cType


static function furecover(eObj)
BREAK eObj
return nil
