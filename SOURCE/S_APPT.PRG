
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SAPPOINT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SAPPOINT() Appointments manager - uses popup calendar.
ณ 
ณ  Returns:
ณ  --------
ณ  nil
ณ 
ณ  Syntax:
ณ  -------
ณ  SAPPOINT()
ณ 
ณ  Description:
ณ  ------------
ณ  Presents a menu driven appointment manager, including
ณ  the ability to print the day's appointments.
ณ 
ณ  Examples:
ณ  ---------
ณ   SAPPOINT()
ณ 
ณ  Notes:
ณ  -------
ณ  see SLSF_APPOINT() for setting the default
ณ  APPOINTMENTS dbf to another location/name. Default is "APPOINT".
ณ 
ณ  Source:
ณ  -------
ณ  S_APPT.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function sappoint
local cInBox
local dTarget := date()
local nOldArea:= select()
local nNewArea:= dbselectarea(0)
local oTb
local lProceed := .t.
local cNormcolor,cEnhcolor
local nGridSel     := 1
local nOldSel      := 1
local nLastkey,cLastkey, nMouseR, nMouseC, nButton, nArrow
local aValues      := array(3)
local aOptions := { ;
                   {23,3, 23,7 ,ASC("A"), '[Add]'},;
                   {23,10, 23,15,ASC("E"),'[Edit]'},;
                   {23,18,23,25,ASC("D"), '[Delete]'},;
                   {23,28,23,40,ASC("C"), '[Change Date]'},;
                   {23,43,23,55,ASC("O"), '[Output list]'},;
                   {23,58,23,64,ASC("P"), '[Purge]'},;
                   {23,67,23,72,ASC("Q"), '[Quit]'}}
local aArrows := {;
                 {21,3,21,5,K_UP},;
                 {21,7,21,9,K_DOWN} }


if lProceed := checkfile(slsf_appt())
   cInBox       := makebox(0,0,24,79,sls_popcol())
   cNormcolor   := takeout(Setcolor(),",",1)
   cEnhcolor    := takeout(Setcolor(),",",2)
   @ 1,3 SAY "APPOINTMENT SCHEDULER -  Appointments for "+dtow(dTarget)
   @ 21,3 say "[] []"
   aeval(aOptions,{|e|devpos(e[1],e[2]),devout(e[6],cNormColor)})
   seek(dtos(dTarget))
   dispbox(3,2,19,77)
   oTb := tbrowsenew(4,3,18,76)
   oTb:addcolumn(tbcolumnNew(nil,{||iif(eof(),padr("NONE    ",75),mil2std(__APPT->time)+' '+padr(__APPT->desc,65))} ))
   oTb:skipblock     := {|n|apSkip(n,dTarget)}
   oTb:gobottomblock := {|n|apgoBot(dTarget)}
   oTb:gotopblock    := {|n|apgoTop(dTarget)}
   oTb:colorspec := sls_normcol()
   do while .t.
     dispbegin()
     @aOptions[nOldSel,1],aOptions[nOldSel,2] say aOptions[nOldSel,6] color cNormColor
     nOldSel      := nGridSel
     While !oTb:stabilize()
     end
     @aOptions[nGridSel,1],aOptions[nGridSel,2] say aOptions[nGridSel,6] color cEnhColor
     dispend()
     nMouseR := 0; nMouseC := 0
     nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
     nButton  := MOUSEHOTAT(nMouseR, nMouseC, aOptions)
     nArrow   := MOUSEHOTAT(nMouseR, nMouseC, aArrows)
     cLastKey := upper(chr(nLastkey))

     do case
     case nLastKey = K_UP .or. nArrow==K_UP
         oTb:up()
         if nArrow==K_UP
          IFMOUSEHD({||oTb:up()},oTb)
         endif
     case nLastKey = K_DOWN .or. nArrow==K_DOWN
         oTb:down()
         if nArrow==K_DOWN
          IFMOUSEHD({||oTb:down()},oTb)
         endif
     case nLastKey = K_LEFT .or. nArrow==K_LEFT
        nGridSel := IIF(nGridSel=1,7,nGridSel-1)
     case nLastKey = K_RIGHT .or. nArrow==K_RIGHT
        nGridSel := IIF(nGridSel=7,1,nGridSel+1)
     case cLastKey$"AEDCOPQ"
        nGridSel := AT(upper(chr(nLastKey)),"AEDCOPQ")
        keyboard chr(13)
     case upper(CHR(nButton))$"AEDCOPQ"
        nGridSel := AT(upper(chr(nButton)),"AEDCOPQ")
        keyboard chr(13)
     case nLastKey = K_ENTER
        do case
        case nGridSel = 1   // add
          aValues[1] := dTarget
          aValues[2] := "12:00pm"
          aValues[3] := space(65)
          if ap_edit(aValues)
            if app_add()
              appt_save(aValues)
            endif
          endif
          oTb:refreshall()
        case nGridSel = 2 .and. !eof()  // edit
          aValues[1] := stod(__appt->date)
          aValues[2] := mil2std(__appt->time)
          aValues[3] := __appt->desc
          if ap_edit(aValues)
            appt_save(aValues)
          endif
          oTb:refreshall()
        case nGridSel = 3   // delete
          if messyn("Delete ?")
            blank()
          endif
          oTb:gotop()
          oTb:refreshall()
        case nGridSel = 4   // change date
          dTarget := getdate(dTarget)
          @ 1,2 SAY "APPOINTMENT SCHEDULER -  Appointments for "+dtow(dTarget)
          seek(dtos(dTarget))
          oTb:refreshall()
        case nGridSel = 5   // output list
          print(dTarget)
        case nGridSel = 6   // purge
          clean()
          seek(dtos(dTarget))
          oTb:refreshall()
        case nGridSel = 7   // quit
          exit
        endcase
     case MBRZMOVE(oTb,nMouseR,nMouseC,4,3,18,76)
     case MBRZCLICK(oTb,nMouseR,nMouseC)
        keyboard chr(K_ENTER)
     endcase
   enddo
   unbox(cInBox)
endif
USE
dbselectarea(nOldArea)
return nil

//---------------------------------------------------------------------
static function mil2std(cMilTime)
local cHrs  := left(cMilTime,2)
local cMins := right(cMilTime,2)
local cAmPm := "am"
if val(cHrs)>11
  cAmPm := "pm"
elseif val(chrs)=0
  cHrs  := "12"
  cAmPm := "am"
endif
if val(cHrs)>12
  cHrs  := trans(val(cHrs)-12,"99")
endif
return cHrs+":"+cMins+cAmPm
//---------------------------------------------------------------------
static function std2mil(cStdTime)
local cHrs  := left(cStdTime,2)
local cMins := subst(cStdTime,4,2)
local cAmPm := right(cStdTime,2)
if cAmPm == "pm" .and. val(cHrs) < 12
  cHrs  := trans(val(cHrs)+12,"99")
elseif cAmPm == "am" .and.  cHrs=="12"
  cHrs  := "00"
endif
return cHrs+":"+cMins
//---------------------------------------------------------------------
STATIC FUNCTION checkfile(cApptFile)
local lOk := .t.
field date,time,desc
if !file(cApptFile+".DBF")
   lOk := .f.
   DBCREATE(cApptFile,{ {"DATE","C",8,0},;
                        {"TIME","C",5,0},;
                        {"DESC","C",65,0}})
   if file(cApptFile+".DBF")
      lOk := .t.
   else
      msg("Problem finding/creating Appointments file")
   endif
endif
IF lOk
  lOk := SNET_USE(slsf_appt(),"__APPT",.F.,5,.T.;
                  ,"Unable to open Appointments File. Try again?")
endif
if lOk .and. !file(cApptFile+indexext())
   lOk := .f.
   plswait(.T.,"Building index...")
   *index on DATE+TIME TO (cApptFile)
   index on DATE+TIME TO (cApptFile+indexext())
   plswait(.F.)
   if file(cApptFile+indexext())
      lOk := .t.
   else
       msg("Problem finding/creating index file")
   endif
endif
if lOk
  SET INDEX TO (cApptFile)
  if !indexkey(0)="DATE+TIME"
    lOk := .f.
  endif
ENDIF
return lOk

//---------------------------------------------------------------------
static function apSkip(n,dTarget)
local nMoved     := 0
local nLastGood  := recno()
if n > 0
  while nMoved < n
    dbskip(1)
    if eof() .or. DTOS(dTarget)<>__APPT->date
      dbgoto(nLastGood)
      exit
    else
      nMoved++
      nLastGood := recno()
    endif
  end
elseif n < 0
  while nMoved > n
    dbskip(-1)
    if bof() .or. DTOS(dTarget)<>__APPT->date
      dbgoto(nLastGood)
      exit
    else
      nMoved--
      nLastGood := recno()
    endif
  end
endif
return nMoved

//---------------------------------------------------------------------
static function apgoBot(dTarget)
local nEndRec := recno()
seek DTOS(dTarget)
while DTOS(dTarget)==__APPT->date
  nEndRec := recno()
  dbskip(1)
end
go nEndRec
return nil
//---------------------------------------------------------------------
static function apgoTop(dTarget)
seek DTOS(dTarget)
return nil
//----------------------------------------------------------------
static function ap_edit(aValues)
local lSaved := .f.
local cBox   := makebox(7,1,14,79)
local cAmPm  := right(aValues[2],2)
local cTime  := left(aValues[2],5)
local nHours := val(left(cTime,2))
local nMins  := val(right(cTime,2))
local getlist := {}
local bF10    := SETKEY(K_F10,{||ctrlw()} )
local bF2     := SETKEY(K_F2 ,{||aplookup()} )

@ 7,4 SAY "[Appointment]"
@ 9,9 SAY "Date"
@ 10,9 SAY "Time    :                AmPm"
@ 12,2 SAY "Description"
@14,2 SAY  "[F10 OK]"
@14,12 SAY "[ESCAPE Cancel]"
@14,30 SAY "[F2 Lookup]"

@9,15  say aValues[1]
//@9,15  get aValues[1]
@10,15 get nHours pict "99" valid iif(nHours<13,.t.,(msg("Must be < 13 "),.f.))
@10,18 get nMins  pict "99" valid iif(nMins<60,.t.,(msg("Must be < 60 "),.f.))
@10,40 get cAmpm valid iif(lower(cAmPm)=="am" .or. lower(cAmPm)=="pm",.t.,(msg("Must be [am] or [pm]"),.f.))
@12,15 get aValues[3] PICT "@S62"
aeval(getlist,{|g|g:display()})
rat_read(getlist,1,.f.,27,{|r,c|checkokc(r,c)})

if lastkey()<>27
  if messyn("Save?")
    lSaved := .t.
    cAmPm := lower(cAmPm)
    aValues[1] := dtos(aValues[1])
    aValues[2] := std2mil(padz(trans(nHours,"99")+":"+trans(nMins,"99"))+lower(cAmPm))
  endif
endif
unbox(cBox)
SETKEY(K_F10,bF10 )
SETKEY(K_F2,bF2 )
return lSaved

//----------------------------------------------------------------
static function checkokc(r,c)
if r==14
  if c>=2 .and. c<=9
    keyboard CHR(23)
  elseif c >=12 .and. c <=26
    keyboard CHR(27)
  elseif c >=30 .and. c <=40
    aplookup()
  endif
endif
return nil

//----------------------------------------------------------------
static function aplookup()
local cVar   := upper(GETACTIVE():name)
local cReturn := nil
local nReturn
local bF2 := SETKEY(K_F2,nil)
do case
case cVar=='NHOURS'
   nReturn := MCHOICE({ " 1:00",;
                        " 2:00",;
                        " 3:00",;
                        " 4:00",;
                        " 5:00",;
                        " 6:00",;
                        " 7:00",;
                        " 8:00",;
                        " 9:00",;
                        "10:00",;
                        "11:00",;
                        "12:00" } )
    cReturn := TRANS(nReturn,"99")
    getactive():varput(val(cReturn))
    getactive():updatebuffer()
    getactive():display()
case cVar=='NMINS'
   nReturn := MCHOICE({":00",":15",":30",":45"})
   if nReturn > 0
    cReturn := TRANS((nReturn-1)*15,"99")
    getactive():varput(val(cReturn))
    getactive():updatebuffer()
    getactive():display()
  endif
case cVar=='CAMPM'
   if messyn("AM or PM?","AM","PM")
     cReturn := "am"
   ELSE
     cReturn := "pm"
   endif
    getactive():varput(cReturn)
    getactive():updatebuffer()
    getactive():display()
endcase
SETKEY(K_F2,bF2)
return nil
//----------------------------------------------------------------
static function appt_save(aValues)
IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
   __APPT->date := aValues[1]
   __APPT->time := aValues[2]
   __APPT->desc := aValues[3]
ENDIF
unlock
return nil
//----------------------------------------------------------------
static function blank()
IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
   __APPT->date := ""
   __APPT->time := ""
   __APPT->desc := ""
ENDIF
unlock
return nil
//----------------------------------------------------------------
static function app_add
local lAdded := .f.
seek space(8)
if found()
  lAdded := .t.
elseif SADD_REC(5,.T.,"Unable to ADD,Try again?")
  lAdded := .t.
endif
return lAdded

//----------------------------------------------------------------
static function padz(cStr)
return strtran(cStr," ","0")

//----------------------------------------------------------------
static function clean
local dClean := date()
local i
local cClean
popread(.t.,"Clean out old appointments prior to:",@dClean,"")
if messyn("Are you sure?")
  plswait(.t.,"Cleaning...")
  cClean := dtos(dClean)
  for i = 1 to recc()
    go i
    if __APPT->date < cClean
        blank()
    endif
  next
  plswait(.f.)
endif
return nil

//----------------------------------------------------------------
static function print(dTarget)
local nDevice   := 1
local cDevice   := "LPT1"
local cFileName := "APPOINTS.PRN"
local nLPP      := 60
local nCount    := 0
seek dtos(dTarget)
if found()
   count while dtos(dTarget)==__APPT->date to nCount
   seek dtos(dTarget)
   if messyn("Print "+dtoc(dTarget)+" appointments?")
     if (nDevice := ;
        menu_v("Destination","Printer LPT1",;
           "Printer LPT2","Printer COM1","File","Cancel")) > 0
        if nDevice = 4
          popread(.t.,"File to write to:",@cFilename,"")
          if !empty(cFileName)
            set printer to (cFileName)
            output(dTarget,nCount+10,.f.)
          endif
        elseif nDevice <4
          cDevice := {"LPT1","LPT2","COM1"}[nDevice]
          if p_ready(cDevice,.f.,.f.)
            SET PRINTER TO (cDevice)
            popread(.t.,"Lines per page",@nLpp,"99")
            output(dTarget,nLpp,.t.)
          endif
        endif
     endif
   endif
endif
return nil

static function output(dTarget,nLpp,lIsPrinter)
local nLineCount := 0
set console off
set print on
while dtos(dTarget)==__APPT->date
 if nLineCount == 0
    ?"Appointments for "+dtow(dTarget)
    ?
    ?"Time      Appointment"
    ?repl("-",75)
    ?
    nLineCount := 5
 endif
 ?mil2std(__APPT->time)+space(3)+__APPT->desc
 nLineCount++
 if nLineCount == nLpp .and. lIsPrinter
   eject
   nLineCount := 0
 endif
 dbskip(1)
end
if nLineCount > 0 .and. lIsPrinter
  eject
endif
set print off
set printer to
set console on
msg(3,"Done")
return nil



