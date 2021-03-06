#define D_AMERICAN    "mm/dd/yy"
#define D_ANSI        "yy.mm.dd"
#define D_BRITISH     "dd/mm/yy"
#define D_FRENCH      "dd/mm/yy"
#define D_GERMAN      "dd.mm.yy"
#define D_ITALIAN     "dd-mm-yy"
#define D_JAPANESE    "yy/mm/dd"
#define D_USA         "mm-dd-yy"


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SET_DATE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SET_DATE() Sets and restores date format
³ 
³  Returns:
³  --------
³  <nFormat> => previous SET DATE format 1-5
³ 
³  Syntax:
³  -------
³  SET_DATE([nFormatNew])
³ 
³  Description:
³  ------------
³  Return current SET DATE setting <nFormat> and
³  optionally set to new format [nFormatNew]
³ 
³  [nFormatNew] =    1  American
³                    2  British/French
³                    3  German
³                    4  ANSI
³                    5  Italian
³ 
³  Examples:
³  ---------
³   nOldformat := SET_DATE(5)
³ 
³   ** SET TO ITALIAN
³ 
³   * code
³ 
³   * more code
³ 
³   SET_DATE(nOldformat)   // restore to prior setting
³ 
³  Source:
³  -------
³  S_SETDAT.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


