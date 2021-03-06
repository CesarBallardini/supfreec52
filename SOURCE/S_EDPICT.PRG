/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ED_G_PIC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ED_G_PIC() Returns appropriate picture for getting a field
³ 
³  Returns:
³  --------
³  <cPicture> picture clause
³ 
³  Syntax:
³  -------
³  ED_G_PIC(cFieldName)
³ 
³  Description:
³  ------------
³  Returns a picture clause appropriate for editing
³  field where <cFieldName> is the name of the field. Applicable to
³  Character and numeric fields
³ 
³  Examples:
³  ---------
³   @10,10 GET AMOUNT PICT ED_G_PIC("AMOUNT")
³   * would return a picture of "9999.99" depending
³   * on length and decimals
³ 
³  Source:
³  -------
³  S_EDPICT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION ed_g_pic(_bizzaro__)

local cPicture, cString

*- create an appropriate picture
DO CASE
CASE TYPE(_bizzaro__) = "C"
  *- make sure it fits on the screen
  cPicture := "@KS" + LTRIM(STR(MIN(LEN(&_bizzaro__), 78)))
CASE TYPE(_bizzaro__) = "N"
  *- convert to a cString
  cString := STR(&_bizzaro__)
  *- look for a decimal point
  IF "." $ cString
    *- return a picture reflecting a decimal point
    cPicture := REPLICATE("9", AT(".", cString) - 1) + "."
    cPicture := cPicture + REPLICATE("9", LEN(cString) - LEN(cPicture))
  ELSE
    *- return a cString of 9's a the picture
    cPicture := REPLICATE("9", LEN(cString))
  ENDIF
  
OTHERWISE
  *- well I just don't know.
  cPicture  := ""
ENDCASE
RETURN cPicture


