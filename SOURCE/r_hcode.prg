//----------------------------------------------------------------------
#DEFINE M_DBF           1
#DEFINE M_TITLE         2
#DEFINE M_NDXKEY        3
#DEFINE M_MAJKEY        4
#DEFINE M_MINKEY        5
#DEFINE M_MAJTEXT       6
#DEFINE M_MINTEXT       7
#DEFINE M_WIDTH         8
#DEFINE M_LENGTH        9
#DEFINE M_LEFTM        10
#DEFINE M_TOPM         11
#DEFINE M_SPACE        12
#DEFINE M_PAUSE        13
#DEFINE M_NPLINES      14
#DEFINE M_EJB4         15
#DEFINE M_EJAFT        16
#DEFINE M_EJMAJOR      17
#DEFINE M_EJMINOR      18
#DEFINE M_EJGRAND      19
#DEFINE M_UNTOTAL      20
#DEFINE M_MAJCHR       21
#DEFINE M_MINCHR       22
#DEFINE M_NHEAD        23
#DEFINE M_NFOOT        24
#DEFINE M_NTITL        25
#DEFINE M_TSEP         26
#DEFINE M_COLSEP       27
#DEFINE M_CSEPWID      28
#DEFINE M_LINESEP      29
#DEFINE M_NCOLS        30
#DEFINE M_FEET         31
#DEFINE M_HEADS        32
#DEFINE M_STDHEAD      33
#DEFINE M_DETAILS      34
#DEFINE M_QUERY        35
#DEFINE M_FULLSUM      36
#DEFINE M_PRNCODE      37
#DEFINE M_AFTCODE      38

//-------------------------------------------------------------------
EXTERNAL Stuff, Ljust, Rjust, allbut, subplus, startsw, Stod, crunch, strtran
EXTERNAL centr, proper, doyear, womonth, woyear, trueval, dtow
EXTERNAL endswith, dtdiff, daysin, datecalc, begend, nozdiv, stretch, arrange
//-------------------------------------------------------------------
FUNCTION sfrr_hcode

LOCAL cInscreen     := savescreen(0,0,24,79)
local nOldArea      := select()
local cReportDesc   := ""
local cPrgName      := space(50)
local cReportFile   := slsf_report()
local cOldColor,nChoice
local cShowBox

if !file(cReportFile+".DBF")
	MSG("No Report file present")
	return ''
endif
if !SNET_USE(cReportFile,"__REPORTS",.F.,5,.T.,"Network error opening REPORT file. Keep trying?")
   select (nOldArea)
   return ''
endif

*-- draw screen
cOldColor           := setcolor(sls_normcol())
@0,0,24,79 BOX sls_frame()
Setcolor(sls_popcol())
@1,1,09,50 BOX sls_frame()
@1,5 SAY '[Report to PRG Translator]'
@20,1,23,78 BOX sls_frame()
@21,2 say "Using source report   :"
@22,2 say "Writing as (*.PRG)    :"


*-- Main Loop
do while .t.
  @21,27 say cReportDesc
  @22,27 say cPrgName
  
  *- do a menu
  Setcolor(sls_popmenu())
  @02,3 PROMPT "Select Report Definition"
  @03,3 PROMPT "Name of .prg file"
  @04,3 PROMPT "Do translation"
  @05,3 PROMPT "List .prg file"
  @06,3 PROMPT "Quit"
  menu to nChoice
  do case
  case nChoice = 1  && source report
     smalls("[Title->]+__reports->sf_title+[  Using DBF->]+__reports->sf_dbf")
     if Lastkey()=13
       cReportDesc :=__reports->sf_title
     endif
  case nChoice = 2  && prgname
     POPREAD(.F.,"PRG file to translate report to:",@cPrgName,"@S35")
  case nChoice = 3  .and. !empty(cPrgName) .and. !empty(cReportDesc)
     cShowBox := makebox(5,5,20,75)
     TRANSLATE(cPrgName)
     unbox(cShowbox)
  case nChoice = 4  .and. !empty(cPrgName) .and. file(cPrgName)
     fileread(1,1,23,78,cPrgName)
  case nChoice = 5  && quit
     setcolor(cOldColor)
     restscreen(0,0,24,79,cInScreen)
     USE
     select (nOldArea)
     exit
  endcase
enddo
return ''


//----------------------------------------------------------------------
*- this is the actual translation proc

static FUNCTION TRANSLATE(cPrgName)

local nPrgHandle := fcreate(alltrim(cPrgName),0)
local lUseQuery

fwriteline(nPrgHandle,"// assumes DBF/Indexes open")
fwriteline(nPrgHandle,"// link with SUPER.LIB or SUPER5.LIB")
fwriteline(nPrgHandle,"// call with DO "+upper(cPrgName)+"  ")
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the declares ")
writedecl(nPrgHandle)
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the inits")
writeinit(nPrgHandle)
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the header inits")
writehead(nPrgHandle)
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the footer inits")
writefoot(nPrgHandle)
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---- here we write the column inits")
writecolumns(nPrgHandle)
if empty(__reports->sf_query)
   luseQuery := .f.
else
   if messyn("Use stored query? ")
     lUseQuery := .t.
   else
     lUseQuery := .f.
   endif
endif
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---and finally, a call to the print engine...")
fwriteline(nPrgHAndle,;
 "rPrintRep({aValues,aHeader,aFooter,aColumns,aTitles,aWidths,aTotalYN,aPictures},"+logc(lUseQuery)+")" )
fwriteline(nPrgHandle,"")
fwriteline(nPrgHandle,"//---end---")
fclose(nPrgHandle)
msg("Done!")
return ''







//----------------------------------------------------------------------
static function writedecl(nHandle)

fwriteline(nHandle,[#DEFINE M_DBF           1])
fwriteline(nHandle,[#DEFINE M_TITLE         2])
fwriteline(nHandle,[#DEFINE M_NDXKEY        3])
fwriteline(nHandle,[#DEFINE M_MAJKEY        4])
fwriteline(nHandle,[#DEFINE M_MINKEY        5])
fwriteline(nHandle,[#DEFINE M_MAJTEXT       6])
fwriteline(nHandle,[#DEFINE M_MINTEXT       7])
fwriteline(nHandle,[#DEFINE M_WIDTH         8])
fwriteline(nHandle,[#DEFINE M_LENGTH        9])
fwriteline(nHandle,[#DEFINE M_LEFTM        10])
fwriteline(nHandle,[#DEFINE M_TOPM         11])
fwriteline(nHandle,[#DEFINE M_SPACE        12])
fwriteline(nHandle,[#DEFINE M_PAUSE        13])
fwriteline(nHandle,[#DEFINE M_NPLINES      14])
fwriteline(nHandle,[#DEFINE M_EJB4         15])
fwriteline(nHandle,[#DEFINE M_EJAFT        16])
fwriteline(nHandle,[#DEFINE M_EJMAJOR      17])
fwriteline(nHandle,[#DEFINE M_EJMINOR      18])
fwriteline(nHandle,[#DEFINE M_EJGRAND      19])
fwriteline(nHandle,[#DEFINE M_UNTOTAL      20])
fwriteline(nHandle,[#DEFINE M_MAJCHR       21])
fwriteline(nHandle,[#DEFINE M_MINCHR       22])
fwriteline(nHandle,[#DEFINE M_NHEAD        23])
fwriteline(nHandle,[#DEFINE M_NFOOT        24])
fwriteline(nHandle,[#DEFINE M_NTITL        25])
fwriteline(nHandle,[#DEFINE M_TSEP         26])
fwriteline(nHandle,[#DEFINE M_COLSEP       27])
fwriteline(nHandle,[#DEFINE M_CSEPWID      28])
fwriteline(nHandle,[#DEFINE M_LINESEP      29])
fwriteline(nHandle,[#DEFINE M_NCOLS        30])
fwriteline(nHandle,[#DEFINE M_FEET         31])
fwriteline(nHandle,[#DEFINE M_HEADS        32])
fwriteline(nHandle,[#DEFINE M_STDHEAD      33])
fwriteline(nHandle,[#DEFINE M_DETAILS      34])
fwriteline(nHandle,[#DEFINE M_QUERY        35])
fwriteline(nHandle,[#DEFINE M_FULLSUM      36])
fwriteline(nHandle,[#DEFINE M_PRNCODE      37])
fwriteline(nHandle,[#DEFINE M_AFTCODE      38])
fwriteline(nHandle,[])
fwriteline(nHandle,[//-------------------------------------------------------------------])
fwriteline(nHandle,[EXTERNAL Stuff, Ljust, Rjust, allbut, subplus, startsw, Stod, crunch, strtran])
fwriteline(nHandle,[EXTERNAL centr, proper, doyear, womonth, woyear, trueval, dtow])
fwriteline(nHandle,[EXTERNAL endswith, dtdiff, daysin, datecalc, begend, nozdiv, stretch, arrange])
fwriteline(nHandle,[//-------------------------------------------------------------------])
fwriteline(nHandle,[])
fwriteline(nHandle,[local cBuffer,i])
fwriteline(nHandle,"LOCAL aValues[38]")
fwriteline(nHandle,"")
fwriteline(nHandle,"LOCAL aHeader := array("+trans(__reports->sf_nhead,"9")+")" )
fwriteline(nHandle,"LOCAL aFooter := array("+trans(__reports->sf_nfoot,"9")+")")
fwriteline(nHandle,"")
fwriteline(nHandle,"*- column descriptions")
fwriteline(nHandle,"LOCAL aColumns := array("+trans(__reports->sf_ncols,"99")+")")
fwriteline(nHandle,"LOCAL aTitles  := array("+trans(__reports->sf_ncols,"99")+")" )
fwriteline(nHandle,"LOCAL aWidths  := array("+trans(__reports->sf_ncols,"99")+")")
fwriteline(nHandle,"LOCAL aTotalYN := array("+trans(__reports->sf_ncols,"99")+")")
fwriteline(nHandle,"LOCAL aPictures := array("+trans(__reports->sf_ncols,"99")+")")
return nil

//----------------------------------------------------------
static function writeinit(nHandle)
fwriteline(nHandle,[// Here are the report layout and other values-----------------------])
fwriteline(nHandle,[])
fwriteline(nHandle,"aValues[M_TITLE]    := ["+__reports->sf_title+"]")
fwriteline(nHandle,"aValues[M_NDXKEY]   := ["+trim(__reports->sf_ndxkey)+"]")
fwriteline(nHandle,"aValues[M_MAJKEY]   := ["+trim(__reports->sf_majkey)+"]")
fwriteline(nHandle,"aValues[M_MINKEY]   := ["+trim(__reports->sf_minkey)+"]")
fwriteline(nHandle,"aValues[M_WIDTH]    := "+trans(__reports->sf_width,'999'))
fwriteline(nHandle,"aValues[M_LENGTH]   := "+trans(__reports->sf_length,'999'))
fwriteline(nHandle,"aValues[M_LEFTM]    := "+trans(__reports->sf_leftm,'99'))
fwriteline(nHandle,"aValues[M_TOPM]     := "+trans(__reports->sf_topm,'99'))
fwriteline(nHandle,"aValues[M_SPACE]    := "+trans(__reports->sf_space,'9'))
fwriteline(nHandle,"aValues[M_PAUSE]    := "+logc(__reports->sf_pause))
fwriteline(nHandle,"aValues[M_EJB4]     := "+logc(__reports->sf_ejb4))
fwriteline(nHandle,"aValues[M_EJAFT]    := "+logc(__reports->sf_ejaft))
fwriteline(nHandle,"aValues[M_EJMAJOR]  := "+logc(__reports->sf_ejmajor))
fwriteline(nHandle,"aValues[M_EJMINOR]  := "+logc(__reports->sf_ejminor))
fwriteline(nHandle,"aValues[M_EJGRAND]  := "+logc(__reports->sf_ejgrand))
fwriteline(nHandle,"aValues[M_NHEAD]    := "+trans(__reports->sf_nhead,'9'))
fwriteline(nHandle,"aValues[M_NFOOT]    := "+trans(__reports->sf_nfoot,'9'))
fwriteline(nHandle,"aValues[M_NTITL]    := "+trans(__reports->sf_ntitl,'9'))
fwriteline(nHandle,"aValues[M_TSEP]     := ["+__reports->sf_tsep+"]")
fwriteline(nHandle,"aValues[M_COLSEP]   := ["+__reports->sf_colsep+"]")
fwriteline(nHandle,"aValues[M_CSEPWID]  := "+trans(__reports->sf_csepwid,'9'))
fwriteline(nHandle,"aValues[M_LINESEP]  := ["+__reports->sf_linesep+"]")
fwriteline(nHandle,"aValues[M_NCOLS]    := "+trans(__reports->sf_ncols,'99'))
fwriteline(nHandle,"aValues[M_STDHEAD]  := "+logc(__reports->sf_stdhead))
fwriteline(nHandle,"aValues[M_MAJTEXT]  := ["+__reports->sf_majtext+"]")
fwriteline(nHandle,"aValues[M_MINTEXT]  := ["+__reports->sf_mintext+"]")
fwriteline(nHandle,"aValues[M_NPLINES]  := "+trans(__reports->sf_nplines,'9'))
fwriteline(nHandle,"aValues[M_UNTOTAL]  := "+logc(__reports->sf_untotal))
fwriteline(nHandle,"aValues[M_MAJCHR]   := ["+__reports->sf_majchr+"]")
fwriteline(nHandle,"aValues[M_MINCHR]   := ["+__reports->sf_minchr+"]")
fwriteline(nHandle,"aValues[M_FULLSUM]  := ["+__reports->sf_fullsum+"]")
fwriteline(nHandle,"aValues[M_PRNCODE]  := ["+__reports->sf_prncode+"]")
fwriteline(nHandle,"aValues[M_AFTCODE]  := ["+__reports->sf_aftcode+"]")
fwriteline(nHandle,"aValues[M_QUERY]    := ["+__reports->sf_query+"]")
return nil

//---------------------------------------------------------------
static function writehead(nHandle)
local i,cBuffer
cBuffer = __reports->sf_heads
for i = 1 TO __reports->sf_nhead
  fwriteline(nHandle,"aHeader["+alltrim(trans(i,"99"))+"] := ["+ ;
             rUnSquish(Takeout(cBuffer,"þ",i))+"]" )
next
return nil
//---------------------------------------------------------------
static function writefoot(nHandle)
local i,cBuffer
cBuffer = __reports->sf_feet
for i = 1 TO __reports->sf_nfoot
  fwriteline(nHandle,"aFooter["+alltrim(trans(i,"99"))+"] := ["+ ;
             rUnSquish(Takeout(cBuffer,"þ",i))+"]" )
next
return nil
//---------------------------------------------------------------
static function writecolumns(nHandle)
local cBuffer,i
*- column descriptions
for i = 1 TO __reports->sf_ncols
  cBuffer      := TRIM(MEMOLINE(__reports->sf_details,150,i))
  fwriteline(nHandle,"aColumns["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",1)+"]" )
  fwriteline(nHandle,"aTitles["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",2)+"]" )
  fwriteline(nHandle,"aWidths["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",3)+"]" )
  fwriteline(nHandle,"aTotalYN["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",4)+"]" )
  fwriteline(nHandle,"aPictures["+alltrim(trans(i,"99"))+"] := ["+ ;
             Takeout(cBuffer,"þ",5)+"]" )
NEXT
RETURN ''
//---------------------------------------------------------------
static function fwriteline(nHandle,c)
fwrite(nHandle,c+chr(13)+chr(10) )
scroll(6,6,19,74,1)
@19,6 say left(c,68)
return nil
//---------------------------------------------------------------
static function logc(lVal)
return iif(lVal,".t.",".f.")
//------------------------------------------------------------------
STATIC FUNCTION rUnSquish(cInstring)
cInstring = Strtran(cInstring,CHR(01),SPACE(80) )
cInstring = Strtran(cInstring,CHR(02),SPACE(70) )
cInstring = Strtran(cInstring,CHR(03),SPACE(60) )
cInstring = Strtran(cInstring,CHR(04),SPACE(50) )
cInstring = Strtran(cInstring,CHR(05),SPACE(40) )
cInstring = Strtran(cInstring,CHR(06),SPACE(30) )
cInstring = Strtran(cInstring,CHR(07),SPACE(20) )
cInstring = Strtran(cInstring,CHR(08),SPACE(10) )
cInstring = Strtran(cInstring,CHR(09),SPACE(05) )
cInstring = Strtran(cInstring,CHR(10),SPACE(02) )
RETURN cInstring


