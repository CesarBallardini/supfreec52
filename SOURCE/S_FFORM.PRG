/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION FASTFORM()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  FASTFORM() Prints a selected formletter for current record
³ 
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  FASTFORM()
³ 
³  Description:
³  ------------
³  Presents a picklist of formletters to print against
³  contents of current record.
³ 
³  Examples:
³  ---------
³   If nChoice = 4    // form letter
³     FASTFORM()
³   endif
³ 
³  Notes:
³  -------
³  Utilizes a form created by FORMLETR() and plugs in
³  values from the current record. Interface is a picklist of forms
³  available. Depends on the current DBF to match the field values
³  in the form.
³ 
³  Source:
³  -------
³  S_FFORM.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


