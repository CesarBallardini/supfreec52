/*
�����������������������������������������������������������������
� FUNCTION ED_G_PIC()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  ED_G_PIC() Returns appropriate picture for getting a field
� 
�  Returns:
�  --------
�  <cPicture> picture clause
� 
�  Syntax:
�  -------
�  ED_G_PIC(cFieldName)
� 
�  Description:
�  ------------
�  Returns a picture clause appropriate for editing
�  field where <cFieldName> is the name of the field. Applicable to
�  Character and numeric fields
� 
�  Examples:
�  ---------
�   @10,10 GET AMOUNT PICT ED_G_PIC("AMOUNT")
�   * would return a picture of "9999.99" depending
�   * on length and decimals
� 
�  Source:
�  -------
�  S_EDPICT.PRG
� 
����������������������������������������������������������������� 
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

