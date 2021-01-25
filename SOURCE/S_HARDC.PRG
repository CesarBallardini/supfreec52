//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION HARDCOPY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  HARDCOPY() Prints current record or memo fields to printer
ณ 
ณ  Returns:
ณ  --------
ณ  Nil
ณ 
ณ  Syntax:
ณ  -------
ณ  HARDCOPY([aFields,aFieldDesc,aFieldTypes])
ณ 
ณ  Description:
ณ  ------------
ณ  Prints out contents of the current record, or any
ณ  memo fields in the current record, to printer or file.
ณ 
ณ  [aFields,aFieldDesc,aFieldTypes] are optional arrays
ณ  of field names, field descriptions, and field types. Default is
ณ  field names, field names, and field types in current area.
ณ 
ณ  Examples:
ณ  ---------
ณ   HARDCOPY()
ณ 
ณ  Source:
ณ  -------
ณ  S_HARDC.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION hardcopy(aFields,aFieldDesc,aFieldTypes)
local nRecorMem  := 1
local nTargetDev := 1
LOCAL cOutFile
LOCAL aMemos := {}
LOCAL i,nMemo,cMemo,nLineCount
LOCAL nLpp := 60,nCpp := 79

if aFields==nil .or. aFieldDesc==nil .or. aFieldTypes==nil
  aFields     := afieldsx()
  aFieldDesc  := afieldsx()
  aFieldTypes := aftypesx()
  aMemos      := afieldstype("M")
elseif aMatches( aFieldTypes,{|e|upper(e)=="M"} ) > 0
  aMemos := acopym(aFields,aFieldTypes)
endif


DO WHILE .T.
  IF len(aMemos) > 0
    if ( nRecOrMem  := menu_v("Hardcopy of:","Current record   ",;
                  "Attached Memo field ") )=0
      EXIT
    endif
  ENDIF
  if (nTargetDev := menu_v("Send hardcopy to:","Printer           ","Text File"))=0
    EXIT
  ENDIF
  popread(.t.,"Lines per page:",@nLpp,"99","Characters per line",@nCpp,"999")
  IF nTargetDev = 1
    sls_prn(prnport())  
    IF !p_ready(sls_prn())
      EXIT
    ENDIF
  ELSE
    cOutFile := SPACE(12)
    popread(.F.,"File to send output to ",@cOutFile,"@N")
    IF EMPTY(cOutFile)
      EXIT
    ENDIF
    IF FILE(cOutFile)
      IF !messyn("File "+cOutFile+" exists, and will be overwritten. Continue ?")
        LOOP
      ENDIF
    ENDIF
    SET PRINTER TO (getdfp()+cOutFile)
  ENDIF
  SET PRINT ON
  IF nRecOrMem = 1
    SET CONSOLE OFF
    for i = 1 TO len(aFieldDesc)
      ?padr(aFieldDesc[i],12)
      ??padr(aMacro(aFields[i]),nCpp-12)
      IF (i%nLpp)=0
        EJECT
      ENDIF
    NEXT
    IF (i%nLpp)<>0
      EJECT
    ENDIF
  ELSE
    IF len(aMemos) > 1
      if (nMemo := mchoice(aMemos,8,27,15,54,"Memo field to print"))=0
        RETURN ''
      ENDIF
      cMemo := &( aMemos[nMemo] )
    ELSE
      cMemo := &( aMemos[1] )
    ENDIF
    nLineCount := MLCOUNT(cMemo,nCpp,nil,.t.)
    SET CONSOLE OFF
    IF !EMPTY(cMemo)
      if messyn("About to print: "+alltrim(str(nLineCount))+" lines.",;
                 "Continue","Cancel")
        FOR i = 1 TO nLineCount
          ?MEMOLINE(cMemo,nCpp,i,nil,.t.)
          IF (i%nLpp)=0
            EJECT
          ENDIF ((i%nLpp)=0
        NEXT
        IF (i%nLpp)<>0
          EJECT
        ENDIF ((i%nLpp)<>0
      endif
    ELSE
      msg("This memo field is empty")
    ENDIF
  ENDIF
  SET PRINTER TO (sls_prn())
  SET PRINT OFF
  SET CONSOLE ON
  EXIT
ENDDO
RETURN nil


//------------------------------------------------------
static FUNCTION aCopym(aSource,aTypes)
local i
local aReturn := {}
for i =1 to len(aSource)
 if aTypes[i]=="M"
   aadd(aReturn,aSource[i])
 endif
next
return aReturn


//--------------------------------------------------------------
static function aMacro(expThis)
local expValue := &(expThis)
if valtype(expValue)=="C" .and. (chr(13)$expValue .or. chr(141)$expValue)
  return "(memo)"
else
  return trans(&(expThis),"")
endif
return nil


