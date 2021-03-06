/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SUM_AVE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SUM_AVE() Interactive sum or average on a dbf field
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  SUM_AVE([cSumAve])
³ 
³  Description:
³  ------------
³  Does a SUM or AVERAGE on a selected numeric field
³ 
³  [csumAve] = "SUM" or "AVE". Default is "SUM"
³ 
³  Examples:
³  ---------
³   case nChoice = 3  && sum
³ 
³     SUM_AVE("SUM")
³ 
³   case nChoice = 4  && average
³ 
³     SUM_AVE("AVE")
³ 
³  Notes:
³  -------
³  If sls_query() is not empty, an  optional SUM or
³  AVERAGE for QUERY can be done.
³ 
³  Source:
³  -------
³  S_SUMAV.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION sum_ave(cSumOrAve)
LOCAL aStructure := dbstruct()
LOCAL aNumfields := {}
LOCAL aNumPosit  := {},nPosition
LOCAL bQuery
local cFieldName,nSelected,I,cMsg,lSummary,nCursor
local nResult := 0, nCount := 0

cSumOrAve := iif(cSumOrAve==nil,"SUM",cSumOrAve )

*- test for dbf open
IF !used()
  msg("Requires database")
  RETURN ''
ENDIF


*- save cursor status,set cursor off
nCursor  := setcursor(0)
lSummary := (UPPER(cSumOrAve) = "SUM")

*- assign the appropriate message
IF lSummary
  cMsg := "Sum Values in field :"
ELSE
  cMsg := "Average Values in field :"
ENDIF

*- find the aNumfields and copy them to aNumfields[]
plswait(.T.,"Finding numeric fields...")
FOR i = 1 TO Fcount()
  IF aStructure[i,2] == "N"
    aadd(aNumfields,aStructure[i,1])
    aadd(aNumPosit,i)
  ENDIF
NEXT
plswait(.F.)

IF len(aNumFields)==0
  msg("No numeric fields")
  SETCURSOR(nCursor)
  RETURN ''
ENDIF

*- ask for the numeric field to sum/average
nSelected  := mchoice(aNumfields,06,27,16,53,cMsg)

*- if a field was selected
DO WHILE .T.
  IF nSelected > 0
    nPosition  := aNumPosit[nSelected]
    cFieldName := aNumfields[nSelected]
    
    *- ask for OK to do sum/average
    IF messyn(cMsg+cFieldName)

      if messyn("Build or Modify Query?")
        IF !EMPTY(sls_query()) .and. messyn("Query exists. Use current?")
            bQuery := sls_bquery()
        ELSE
            QUERY()
            bQuery := sls_bquery()
        ENDIF
      endif
      
      GO TOP
      IF lSummary
        plswait(.T.,"Summing....")
        DBEval({||nResult+=fieldget(nPosition)},bQuery, {||inkey()#27} )

      ELSE
        plswait(.T.,"Averaging..")
        DBEval({||nCount++,nResult+=fieldget(nPosition)},bQuery,{||inkey()#27})
        nResult := nResult/nCount
      ENDIF
      plswait(.F.)
      
      *- display the nResult
      IF lSummary
        msg("Sum of field "+cFieldName+" = "+STR(nResult)+'  ' )
      ELSE
        msg("Average of field "+cFieldName+" = "+STR(nResult)+'  ' )
      ENDIF
    ENDIF
  ENDIF
  EXIT
ENDDO
SETCURSOR(nCursor)
CLEAR TYPEAHEAD
RETURN nResult

