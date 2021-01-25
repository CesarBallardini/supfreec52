/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION FASTFORM()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  FASTFORM() Prints a selected formletter for current record
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  FASTFORM()
ณ 
ณ  Description:
ณ  ------------
ณ  Presents a picklist of formletters to print against
ณ  contents of current record.
ณ 
ณ  Examples:
ณ  ---------
ณ   If nChoice = 4    // form letter
ณ     FASTFORM()
ณ   endif
ณ 
ณ  Notes:
ณ  -------
ณ  Utilizes a form created by FORMLETR() and plugs in
ณ  values from the current record. Interface is a picklist of forms
ณ  available. Depends on the current DBF to match the field values
ณ  in the form.
ณ 
ณ  Source:
ณ  -------
ณ  S_FFORM.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION fastform

LOCAL nOldArea,nPageWidth,cScreen,cTempForm,nLeftMargin,cFormFile
LOCAL getlist := {}

*- default of 79 CPI
nPageWidth  := 79
nLeftMargin := 0
cFormFile  := SLSF_FORM()
cScreen     := savescreen(0,0,24,79)

*- check for file
IF !FILE(cFormFile+".dbf")
  RETURN .F.
ENDIF

*- save old selected area
nOldArea := SELECT()

*- select new area and open FORM
SELE 0
IF !SNET_USE(cFormFile,"__FORMS",.f.,5,.t.,"Unable to open forms file. Try again?")
   SELECT (nOldArea)
   RETURN .F.
ENDIF

*- call SMALLS() to select form from DESCRIPT field
smalls("descript","Select Form - or Press Escape")

*- if not escaped out of
IF !LASTKEY() = 27
  popread(.t.,"Left Margin ->",@nLeftMargin,"99","Page Width",@nPageWidth,"999")

  *- and printer is ready
  IF p_ready(sls_prn())
    cScreen     := savescreen(0,0,24,79)

    SET PRINT ON
    CLEAR
    cTempForm := __FORMS->memo_orig
    
    *- close the database and go back to prior one
    USE
    SELE (nOldArea)
    
    *- print the form
    prntfrml(cTempForm,nPageWidth-nLeftMargin,nLeftMargin)
    EJECT
    SET PRINT OFF
    restscreen(0,0,24,79,cScreen)
  ELSE
    
    *- close the database
    USE
    SELE (nOldArea)
    
  ENDIF
ELSE
  *- close the database
  USE
  SELE (nOldArea)
ENDIF
RETURN ''


