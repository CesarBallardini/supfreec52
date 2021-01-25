#define D_AMERICAN    "mm/dd/yy"
#define D_ANSI        "yy.mm.dd"
#define D_BRITISH     "dd/mm/yy"
#define D_FRENCH      "dd/mm/yy"
#define D_GERMAN      "dd.mm.yy"
#define D_ITALIAN     "dd-mm-yy"
#define D_JAPANESE    "yy/mm/dd"
#define D_USA         "mm-dd-yy"


/*
�����������������������������������������������������������������
� FUNCTION SET_DATE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SET_DATE() Sets and restores date format
� 
�  Returns:
�  --------
�  <nFormat> => previous SET DATE format 1-5
� 
�  Syntax:
�  -------
�  SET_DATE([nFormatNew])
� 
�  Description:
�  ------------
�  Return current SET DATE setting <nFormat> and
�  optionally set to new format [nFormatNew]
� 
�  [nFormatNew] =    1  American
�                    2  British/French
�                    3  German
�                    4  ANSI
�                    5  Italian
� 
�  Examples:
�  ---------
�   nOldformat := SET_DATE(5)
� 
�   ** SET TO ITALIAN
� 
�   * code
� 
�   * more code
� 
�   SET_DATE(nOldformat)   // restore to prior setting
� 
�  Source:
�  -------
�  S_SETDAT.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION SET_DATE(nNewFormat)
local nOldFormat,cOldFormat
local lOldCent := SETCENT(.f.)
nOldFormat := 0
cOldFormat :=  lower(SET(_SET_DATEFORMAT))
do case
case cOldFormat == D_AMERICAN
  nOldFormat := 1
case cOldFormat == D_BRITISH
  nOldFormat := 2
case cOldFormat == D_FRENCH
  nOldFormat := 2
case cOldFormat == D_GERMAN
  nOldFormat := 3
case cOldFormat == D_ANSI
  nOldFormat := 4
case cOldFormat == D_ITALIAN     // last, but not least
  nOldFormat := 5
endcase

if nNewFormat#nil
  DO CASE
  CASE nNewFormat = 1
         SET DATE AMERICAN
  CASE nNewFormat = 2
         SET DATE BRITISH
  CASE nNewFormat = 3
         SET DATE GERMAN
  CASE nNewFormat = 4
         SET DATE ANSI
  CASE nNewFormat = 5
         SET DATE ITALIAN
  ENDCASE
endif

SETCENT(lOldCent)
return nOldFormat

