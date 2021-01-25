#define D_AMERICAN    "mm/dd/yy"
#define D_ANSI        "yy.mm.dd"
#define D_BRITISH     "dd/mm/yy"
#define D_FRENCH      "dd/mm/yy"
#define D_GERMAN      "dd.mm.yy"
#define D_ITALIAN     "dd-mm-yy"
#define D_JAPANESE    "yy/mm/dd"
#define D_USA         "mm-dd-yy"


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SET_DATE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SET_DATE() Sets and restores date format
ณ 
ณ  Returns:
ณ  --------
ณ  <nFormat> => previous SET DATE format 1-5
ณ 
ณ  Syntax:
ณ  -------
ณ  SET_DATE([nFormatNew])
ณ 
ณ  Description:
ณ  ------------
ณ  Return current SET DATE setting <nFormat> and
ณ  optionally set to new format [nFormatNew]
ณ 
ณ  [nFormatNew] =    1  American
ณ                    2  British/French
ณ                    3  German
ณ                    4  ANSI
ณ                    5  Italian
ณ 
ณ  Examples:
ณ  ---------
ณ   nOldformat := SET_DATE(5)
ณ 
ณ   ** SET TO ITALIAN
ณ 
ณ   * code
ณ 
ณ   * more code
ณ 
ณ   SET_DATE(nOldformat)   // restore to prior setting
ณ 
ณ  Source:
ณ  -------
ณ  S_SETDAT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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


