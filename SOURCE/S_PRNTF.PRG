// new improved 'wrapping' prntfrml()
// 1. Now wraps correctly when values go off right margin
// 2. Outputs logicals as "Yes" or "No"
// 3. Correctly uses decimals or not on numeric fields (if possible to
//    determine)
// 4. Accepts and correctly wraps memo fields to page width.

*/*/ Additional parameter
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PRNTFRML()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PRNTFRML() Prints a formletter created by formletr()
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  PRNTFRML(cForm,[nPageWidth],[nLeftMargin])
³ 
³  Description:
³  ------------
³  Prints the form <cForm> from FORMS.DBF with a
³  pagewidth of [nPageWidth] and a left margin of [nLeftMargin]
³ 
³  <cForm> is normally the contents of the template stored in FORMS.DBF
³  (previous documentation refered to this parameter as the NAME of the
³  form, which is incorrect.
³ 
³  Examples:
³  ---------
³  This is used internally by FORMLETR() and FASTFORM().
³  Refer to its usage there.
³ 
³  SELECT 0
³  USE FORM
³  locate for descript = "MY FORM LETTER" // find letter
³  cForm = form->memo_orig      // load contents
³  USE
³  SELECT MYDBF
³  PRNTFRML(cForm,79)
³ 
³ 
³  Source:
³  -------
³  S_PRNTF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION prntfrml( cTemplate, nPageWidth,nLeftMArgin )

EXTERNAL DTOW
EXTERNAL PROPER

LOCAL nLines, nIter, cCurrentLine, nLeftMark, nRightMark, lEvaluating
local _object_, cFieldType,lBadLine,expFieldVal,cFirstHalf,cLastHalf
local lProperize,cLMSpaces
local cLeftMark := chr(174)
local cRightMark := chr(175)
local cFormLetr := ""

While (nLeftMark := AT(cLeftMark,cTempLate)) > 0
    if (nRightMark:= AT(cRightMark,cTempLate)) > 0
      cFormLetr += getvalue(left(cTempLate,nRightMark),nLeftMark,nRightMark)
      cTempLate := subst(cTempLate,nRightMark+1)
    else
      exit
    endif
end
cFormLetr += cTempLate
*- determine width
IF nPageWidth==nil
  nPageWidth = 80
ENDIF

if nLeftMArgin<>NIL
      cLMSpaces := space(nLeftMArgin)
else
      cLMSpaces := ""
endif

*- determine number of lines
nLines = MLCOUNT(cFormLetr, nPageWidth,nil,.t.)

*- loop for # of lines
FOR nIter = 1 TO nLines
  
  *- get the next line
  cCurrentLine := MEMOLINE(cFormLetr, nPageWidth, nIter,nil,.t.)
  ? cLMSpaces+cCurrentLine
  
NEXT

RETURN ''


//----------------------------------------------------------------
static function getvalue(cChunk,nLeftMark,nRightMark)
local _object_
local lProperize := .f.
local cFieldType,expFieldVal, nFieldDec, nFieldLen, cPicture,cFieldName
local cReturn := ""
_object_ := SUBSTR(cChunk, nLeftMark+1,nRightMark - nLeftMark-1)
_object_:= strtran(_object_,chr(141),"")
_object_:= strtran(_object_,chr(13),"")
_object_:= strtran(_object_,chr(10),"")
cFieldName := _object_
IF LEFT(_object_,1) == CHR(221)
  _object_   := SUBSTR(_object_,2)
  lProperize := .T.
ENDIF

IF !EMPTY(_object_)
 if !(  (cFieldType := type(_object_))=="U" .or. cFieldType=="UE")
     _object_ := &_object_
     cFieldType := VALTYPE(_object_)
     DO CASE
     CASE cFieldType == "C"
       IF lProperize
         expFieldVal := proper(LTRIM(_object_))
       ELSE
         expFieldVal := _object_
       ENDIF
     CASE cFieldType == "D"
       expFieldVal := DTOC(_object_)
     CASE cFieldType == "L"
       expFieldVal := iif(_object_,"Yes","No")
     CASE cFieldType == "N"
       if (nFieldDec := fielddecx(cFieldName)) > 0
          cPicture := repl("9",(nFieldLen := fieldlenx(cFieldName)) )
          cPicture := STUFF(cPicture,nFieldLen-nFieldDec,1,".")
          expFieldVal := LTRIM(TRANS(_object_,cPicture ))
       elseif (nFieldLen := fieldlenx(cFieldName)) > 0
          cPicture := repl("9",(nFieldLen := fieldlenx(cFieldName)) )
          expFieldVal := LTRIM(TRANS(_object_,cPicture ))
       else
         expFieldVal := LTRIM(TRANS(_object_,"999,999,999,999.99"))
       endif
     CASE _object_  == "DTOW(DATE())" .OR. _object_ = "FORMDATE()"
       expFieldVal := DTOW(DATE())
     OTHERWISE
       expFieldVal = ""
     ENDCASE
 else
    expFieldVal = ""
 endif
else
   expFieldVal = ""
endif
cReturn := left(cChunk,nLeftMark-1)+expFieldVal+subst(cChunk,nRightMark+1)
if empty(cReturn)
 cReturn := ""
endif
return cReturn



