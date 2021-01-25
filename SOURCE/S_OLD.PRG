
#include "inkey.ch"

/*
�����������������������������������������������������������������
� FUNCTION OLD()                                *new*
�����������������������������������������������������������������
�
�  Short:
�  ------
�  OLD()  On Line Documentation - TOPIC oriented help system
�
�  Returns:
�  --------
�  NIL
�
�  Syntax:
�  -------
�  OLD()
�
�  Description:
�  ------------
�  This is ON LINE DOCUMENTATION , similiar to NG or Windows help.
�  There are no parameters, but it has a couple of additional
�  exported functions that allow TOPIC selection and DEVELOPMENT
�
�  The documentation is stored in a DBF database, with one
�  record per TOPIC. A TOPIC has a TITLE, stored in the TOPIC field,
�  a variable length TEXT entry (can be as long as needed) stored in the
�  TEXT field, and hotlinks stored in the KEYS field, which link the TOPIC
�  to other topics via a (S)ee also button.
�
�  The options available to the user are:
�
�    (C)ontents   -- go to the CONTENTS screen, a sort of index or
�                    table of contents to the topics in the database
�    (S)ee also   -- select from related topics
�    (O)ther      -- not yet used
�    (B)ack       -- go to previous screen
�
�  The DBF structure is TOPIC C 35
�                       KEYS  M
�                       TEXT  M
�
�
�  Additional Exported Functions:
�
�  OLD_DEV(bDevelopMent)
�      Where bDevelopment is a proc called during development
�      of the doc system. Always pass {||OLD_MOD()} to enable
�      development, and NIL to disable development. When development
�      is active, a prompt called (M)odify appears at the bottom
�      of the screen, allowing CREATION, EDITING, DELETING and
�      LINKING of topics.
�
�      The options avaialable to the developer are:
�
�       Add Topic                 - create a new TOPIC record
�       Edit Topic                - edit the current TOPIC record
�       Delete Topic              - delete the current TOPIC record
�       Modify SEEALSOs           - add/delete See Also references
�       Generate CONTENTS record  - generate the CONTENTS record
�                                   either by tagging selected TOPICS
�                                   or using ALL topics
�
�
�
�  OLD_TOPIC(cTopic)
�      This sets the current TOPIC for OLD(). For instance, on
�      entry into QUERY(), you could call OLD_TOPIC("QUERY BY EXAMPLE").
�      Presuming you had a TOPIC defined called "QUERY BY EXAMPLE",
�      this is what would come up when OLD() was called or activated
�      with a hotkey.
�
�      Call OLD_TOPIC("") to clear the topic. The default topic is
�      the CONTENTS page.
�
�  Examples:
�  ---------
�  For development:
�       OLD_DEV({||OLD_MOD()})
�       OLD()
�  For distribution, simply comment out the OLD_DEV() call.
�
�  For hotkey activation:
�      SETKEY(K_WHATEVER,{||OLD()}  )
�
�
�  When in a particular part of the program:
�       OLD_TOPIC("TOPIC NAME...")
�  to activate a particulat topic.
�
�  Notes:
�  -------
�  There's no reason this couldn't be used alongside of the
�  traditional Clipper context sensitive 'field level' help.
�
�
�  Source:
�  -------
�  S_OLD.PRG
����������������������������������������������������������������
*/
proc old()
local nSelect    := SELECT()
local cInColor   := SETCOLOR(sls_normcol())
local cInScreen  := SAVESCREEN(0,0,MAXROW(),MAXCOL())
local nCursor    := SETCURSOR(0)
local nMouseR    :=0
local nMouseC    :=0
local lDev       := (OLD_DEV()#nil)
local nTbRow     := 1
local cNormCol   := setcolor()
local cTbCont    := takeout(cNormCol,",",5)+","+takeout(cNormCol,",",2)
local cTrigColor := ctrigger(takeout(cNormCol,",",1))
local cTbNorm    := takeout(cNormCol,",",5)+","+takeout(cNormCol,",",5)
local nModify
local nLastKey, aButtons,nButton,cLastKey, nAtRec
local aLines, nRecord, nOldRec
local aHistory   := {}
local oTb := TBROWSENEW(4,2,20,77)

SELECT 0

oTb:addcolumn(tbcolumnnew(nil,{||aLines[nTbRow]}))
oTb:Skipblock     := {|n|aaskip(n,@nTbRow,len(aLines))}
oTb:goTopBlock    := {||nTbRow := 1}
oTb:goBottomBlock := {||nTbRow := len(aLines)}

if DBFCHECK()    //o.l.d. DBF opens OK?
   dispbegin()
   aButtons := ;
        DRAWSOLD(cNormCol,cTbNorm,cTrigColor ,lDev)

   if !empty( OLD_TOPIC() )
     SEEK upper(OLD_TOPIC())
     if !found()
       seek "CONTENTS"
       if !found()
         locate for !empty(field->TOPIC)
       endif
     endif
   else
       seek "CONTENTS"
       if !found()
         locate for !empty(field->TOPIC)
       endif
   endif
   aLines := LOADLINES()

   dispend()
   oTb:colorspec := iif(alltrim(field->TOPIC)=="CONTENTS",cTbCont,cTbNorm)
   nRecord := recno()
   nOldRec := nRecord
   while .t.
        if (nRecord := recno())<>nOldRec
          aadd(aHistory,nOldrec)
        endif
        nOldRec := nRecord
        dispbegin()
        while !oTb:stabilize()
        end
        showline(oTb,cNormCol)
        @ 2,2 SAY padr("Topic: "+alltrim(field->TOPIC),74) color cNormCol
        dispend()
        nLastKey := RAT_EVENT(0,.f.,.f.,@nMouseR,@nMouseC)
        nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
        cLastKey := upper(chr(nLastKey))
        if nButton>0
          cLastKey := upper(chr(nButton))
        endif

        do case
        case cLastKey=="Q" .or. nLastKey==K_ESC
           exit

        case cLastKey=="B"
           if len(aHistory) > 0
             nRecord := ATAIL(aHistory)
             nOldRec := nRecord
             ASIZE(aHistory,len(aHistory)-1)
             go nRecord
             aLines := LOADLINES()
             oTb:colorspec := iif(alltrim(field->TOPIC)=="CONTENTS",cTbCont,cTbNorm)
             nTbRow   := 1
             oTb:rowpos := 1
             oTb:configure()
           else
             tone(300,1)
           endif
        case cLastKey=="M" .and. lDev
           if eval( OLD_DEV() )    // this proc can thus be external
               aLines := LOADLINES()
               oTb:colorspec := iif(alltrim(field->TOPIC)=="CONTENTS",cTbCont,cTbNorm)
               nTbRow   := 1
               oTb:rowpos := 1
               oTb:configure()
           endif

        case cLastKey=="S"
           if SEEALSOS()
                   aLines := LOADLINES()
                   oTb:colorspec := iif(alltrim(field->TOPIC)=="CONTENTS",cTbCont,cTbNorm)
                   nTbRow   := 1
                   oTb:rowpos := 1
                   oTb:configure()
           endif
        case cLastKey=="C"
           nAtRec := recno()
           seek "CONTENTS"
           if found()
                   oTb:colorspec     := cTbCont
                   oTb:colorspec := iif(alltrim(field->TOPIC)=="CONTENTS",cTbCont,cTbNorm)
                   aLines := LOADLINES()
                   nTbRow   := 1
                   oTb:rowpos := 1
                   oTb:configure()
           else
                go (nAtRec)
           endif

        case nLastKey==K_DOWN .or. nButton==K_DOWN
           oTb:down()
           if nButton==K_DOWN
            IFMOUSEHD({||oTb:down(),showline(oTb,cNormCol) },oTb)
           endif

        case nLastKey==K_UP .or. nButton==K_UP
           oTb:up()
           if nButton==K_UP
            IFMOUSEHD({||oTb:up(),showline(oTb,cNormCol) },oTb)
           endif
        case MBRZMOVE(oTb,nMouseR, nMouseC,4,2,20,77) .or. ;
              MBRZCLICK(oTb,nMouseR, nMouseC) .or. nLastkey==K_ENTER
           // you'd only do this if field->topic==CONTENTS
           // then store the line # for a doubleclick

           while !oTb:stabilize()
           end

           IF ALLTRIM(UPPER(field->topic))=="CONTENTS"
              nAtRec := recno()
              if !empty(UPPER(aLines[nTbRow]))
                 seek UPPER(alltrim(aLines[nTbRow]))
                 if found()
                   oTb:colorspec     := cTbNorm
                   aLines := LOADLINES()
                   nTbRow   := 1
                   oTb:rowpos := 1
                   oTb:configure()
                 else
                    go (nAtRec)
                 endif
              endif
           ENDIF
        endcase
   end
   USE
endif
select (nSelect)
setcolor(cInColor)
restscreen(0,0,maxrow(),maxcol(),cInScreen)
setcursor(nCursor)


static proc showline(oTb,cNormCol)
dispbox(4,1,20,1,space(9),cNormCol)
dispbox(4,78,20,78,space(9),cNormCol)
scroll(4,78,20,78,0)
if ALLTRIM(UPPER(field->topic))<>"CONTENTS"
  @3+oTb:rowpos,1 say "" color cNormCol
  @3+oTb:rowpos,78 say "" color cNormCol
endif
return

static function dbfcheck
local lOpened := .f.
local cDocDbf := SLSF_OLD()

IF !FILE(cDocDbf+".DBF")
        dbcreate(cDocDbf,{;
                      {"TOPIC","C",35,0},;
                      {"KEYS","M",10,0},;
                      {"TEXT","M",10,0};
                       })
endif
if SELECT("SLOLDS")>0
   select (SELECT("SLOLDS"))
   lOpened := .t.
elseif snet_use(cDocDbf,"SLOLDS", .f., 5, .f.,"")  // open shared
    IF !FILE(cDocDbf+indexext() )
        INDEX ON upper(field->TOPIC) TO (cDocDbf)
    ENDIF
    SET INDEX TO ( cDocDbf)
    lOpened := .t.
endif
return lOpened



static function drawsold(cBoxColor,cHelpColor,cTrigColor,lDev)
local aButtons
dispbox(1,0,23,79,"�Ŀ����� ",cBoxColor)
@ 3,0 SAY   '�' color cBoxColor
@ 3,79 SAY  '�' color cBoxColor
@ 21,0 SAY  '�' color cBoxColor
@ 21,79 SAY '�' color cBoxColor
@ 3,1 to 3,78   color cBoxColor
@ 21,1 to 21,78 color cBoxColor
@22,2  say '(C)ontents'color cBoxColor
@22,15 say '(S)ee also' color cBoxColor
@22,28 say '(O)ther' color cBoxColor
@22,38 say '(B)ack'
@22,47 say '(Q)uit' color cBoxColor
@22,3  say "C" color cTrigColor
@22,16 say "S" color cTrigColor
@22,29 say "O" color cTrigColor
@22,48 say "Q" color cTrigColor
@22,39 say "B" color cTrigColor
@22,70 say '[]' color cBoxColor
@22,74 say '[]' color cBoxColor
aButtons := { ;
            {22,2,22,11,ASC("C") },;
            {22,15,22,24,ASC("S")},;
            {22,28,22,34,ASC("O")},;
            {22,47,22,52,ASC("Q")},;
            {22,38,22,43,ASC("B")},;
            {22,70,22,72,K_DOWN},;
            {22,74,22,76,K_UP} }
if lDev
  @22,58 say '(M)odify' color cBoxColor
  AADD(aButtons,{22,55,22,65,ASC("M")})
  @22,59 say "M" color cTrigColor
endif
dispbox(5,2,20,77,"         ",cHelpColor)
return aButtons


static function ctrigger(cColor)
local cFg := takeout(cColor,"/",1)
local cBg := takeout(cColor,"/",2)
if cFg<>"W+" .and. cBg<>"W*"
     cFg  := "W+"
else
     if cBg$"N~B~"
         cFg := "W"
     else
         cFg := "N"
     endif
endif

return cFg+"/"+cBg


static function seealsos
local nAtRec := recno()
local aAlsos := {}
local i, nChoice
local lChanged := .f.
if !empty(field->keys)
   for i = 1 to mlcount(field->keys,80)
      aadd(aAlsos,alltrim(memoline(field->keys,80,i)) )
   next
endif
nChoice := MCHOICE(aAlsos)
if nChoice > 0
    SEEK (UPPER(aAlsos[nChoice]))
    if found()
         lChanged := .t.
    else
         go (nAtRec)
    endif
endif
return lChanged


STATIC FUNCTION LOADLINES
local a := {}
local c := fieldget(fieldpos("TEXT"))
local nNextStart := 0
aadd(a,memoline(subst(c,nNextStart+1,100),73,1))
while (nNextStart := nextls(c,nNextStart) ) >= 0
        aadd(a,memoline(subst(c,nNextStart+1,100),73,1))
end
return a


FUNCTION OLD_DEV(bNew)
static bDev := nil
if pcount()>0
        bDev := bNew
endif
return bDev


FUNCTION OLD_TOPIC(cNew)
static cTopic := ""
if cNew#nil
        cTopic := cNew
endif
return cTopic





