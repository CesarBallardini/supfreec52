

#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#DEFINE BUTTON_QUIT        1
#DEFINE BUTTON_EDIT        2
#DEFINE BUTTON_ADD         3
#DEFINE BUTTON_DELETE      4
#DEFINE BUTTON_FILTER      5
#DEFINE BUTTON_MEMO        6
#DEFINE BUTTON_PRINT       7
#DEFINE BUTTON_ORDER       8

/*
ÕìÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
³ FUNCTION TODOLIST()
ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
³ 
³  Short:
³  ------
³  TODOLIST() Simple todo list manager
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  TODOLIST()
³ 
³  Description:
³  ------------
³  Pops up a simple TODO list interface,allowing the
³  user to enter in things 'To do' by Description,Category
³  ,Priority and Date Due. These categories may be sorted, filtered
³  and printed.
³ 
³  Examples:
³  ---------
³   TODOLIST()
³ 
³  Source:
³  -------
³  S_TODO.PRG
³ 
ÔíÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ 
*/
FUNCTION TODOLIST
local   nOldArea,cOldScreen,cOldColor,lAlldone,cFilter,cTempMemo
local   cTodoFile,cTodoNTX1,cTodoNTX2,cTodoNTX3,nOldCursor,bOldF10, bOldF2
local   oTb
local   nLastkey,cLastkey
local   nListOrder
local   cOldQuery  := sls_query()
local   nDispOrder := 1
local   nFilter
local   lAppend,lOktoEdit,lOkToRep
local   mCATEGORY,mITEM,mPRIORITY,mdoby,mdone
local   cHiColor, cMemoBox
local   lDeleted := SET(_SET_DELETED,.t.)
local   nMouseR, nMouseC
local   aButtons, nButton
memvar getlist
field  CATEGORY,ITEM,PRIORITY,DOBY,DONE,LONG_DESC

lAlldone        := .f.
bOldF10         := setkey(-9)
bOldF2          := setkey(-1)
nOldCursor      := setcursor(0)
setkey(-9,{||ctrlw()})
dtow(date())
nOldArea        := select()
select 0
cOldScreen      := savescreen(0,0,24,79)
cOldColor       := setcolor()
cTodoFile       := SLSF_TODO()
cTodoNTX1     := SLSF_TDN1()
cTodoNTX2     := SLSF_TDN2()
cTodoNTX3     := SLSF_TDN3()

if !file(cTodoFile+".DBF")
    BLDDBF(cTodoFile,"CATEGORY,C,10:ITEM,C,60:PRIORITY,C,2:DOBY,D:DONE,L:LONG_DESC,C,231")
endif

IF !SNET_USE(cTodoFile,"__TODO",.f.,5,.F.,"Unable to open TODO file. Keep trying?")
    select (nOldArea)
    setkey(-9,bOldF10)
    setcursor(nOldCursor)
    return ''
ENDIF

IF !file(cTodoNTX1+indexext()) .and. !file(cTodoNTX2+indexext()) .and. !file(cTodoNTX3+indexext())
  index on category+descend(priority) to (cTodoNTX1)
  index on descend(priority) to (cTodoNTX2)
  index on doby to (cTodoNTX3)
endif
set index to (cTodoNTX1), (cTodoNTX2), (cTodoNTX3)
oTb := makevptb()


clear
SETCOLOR(sls_normcol())
cHiColor := takeout(setcolor(),",",5)


@ 0,0,24,79 BOX "ÚÄ¿³ÙÄÀ³ "
@ 1,3 SAY "Todo Manager"
@ 22,0 SAY 'Ã'
@ 22,79 SAY '´'
@ 22,1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 2,2,15,77 BOX "ÚÄ¿³ÙÄÀ³ "
@17,3 SAY 'Memo:'
@ 15,61 SAY "[] [] [] []"

@23,2 say  '[Q]uit'
@23,11 say '[E]dit'
@23,20 say '[A]dd'
@23,28 say '[D]elete'
@23,39 say '[F]ilter'
@23,50 say '[M]emo '
@23,60 say '[P]rint'
@23,70 say '[O]rder'

aButtons := { {23,2,23,7},{23,11,23,16},{23,20,23,23},{23,28,23,35},;
              {23,39,23,46},{23,50,23,55},{23,60,23,66},{23,70,23,76} }

GO TOP
lAllDone := .f.
DO WHILE !lAllDone

   DISPBEGIN()
   @1,57 say PADL("Ordered by: "+{"Category","Priority","Date"}[nDispOrder],20) color sls_normcol()
   while !oTb:stabilize()
   end
   setcolor(cHiColor)
   MEMOEDIT(LONG_DESC,18,3,20,76,.F.,.f.,77)
   setcolor(sls_popcol())
   DISPEND()

   nLastkey := rat_event(0,.f.)
   cLastkey := upper(chr(nLastkey))
   nMouseR := rat_eqmrow()
   nMouseC := rat_eqmcol()
   nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)

   DO CASE
   CASE nLastkey==K_DOWN
      oTb:down()
   CASE nLastkey==K_UP
      oTb:up()
   CASE nLastkey==K_LEFT
      oTb:left()
   CASE nLastkey==K_RIGHT
      oTb:right()
   CASE nLastkey==K_PGDN
      oTb:pagedown()
   CASE nLastkey==K_PGUP
      oTb:pageup()
   CASE nLastkey==K_HOME
      oTb:gotop()
   CASE nLastkey==K_END
      oTb:gobottom()

   CASE cLastkey=="P" .or. nButton==BUTTON_PRINT                        // print
      hidecmds()
      setcolor(sls_normcol())
      nListOrder := menu_v("Order of list: ","Category","Priority","Date","Cancel")
      if nListOrder > 0 .and. nListOrder < 4
        set order to nListOrder
        sls_query("")
        lister()
        sls_query(cOldQuery)
      endif
      set order to nDispOrder
      setcolor(sls_popcol())
      oTb:refreshall()
      saycmds()
   CASE cLastKey$"Q" .or. nLastkey==K_ESC  .or. nButton==BUTTON_QUIT
       lAlldone = .t.
   CASE cLastkey$"O" .or. nButton==BUTTON_ORDER
      hidecmds()
      setcolor(sls_normcol())
      nDispOrder := max(menu_v("Viewing Order: ","Category","Priority","Date"),1)
      setcolor(sls_popcol())
      set order to (nDispOrder)
      oTb:gotop()
      oTb:refreshall()
      saycmds()
   CASE cLastkey$"F".or. nButton==BUTTON_FILTER                             // filter
      hidecmds()
      setcolor(sls_normcol())
      nFilter := menu_v("Set Filter of ","Category to: "+__todo->category,;
                                        "Date  to: "+dtow(__todo->doby),;
                                        "Priority to:"+__todo->priority,;
                                        "No Filter")
      setcolor(sls_popcol())
      do case
      case nFilter = 1
        cFilter = __todo->category
        set filter to CATEGORY = cFilter
      case nFilter = 2
        cFilter = __todo->doby
        set filter to __todo->DOBY = cFilter
      case nFilter = 3
        cFilter = __todo->priority
        set filter to PRIORITY = cFilter
      OTHERWISE
        set filter to
      endcase
      oTb:gotop()
      oTb:refreshall()
      saycmds()
   CASE cLastkey$"D".or. nButton==BUTTON_DELETE
      hidecmds()
      delrec()
      skip 1
      skip -1
      oTb:refreshall()
      saycmds()
   CASE cLastkey$"AE" .or. nLastkey==K_ENTER.or. nButton==BUTTON_EDIT ;
               .or. nButton==BUTTON_ADD
      hidecmds()
      if cLastkey=="A".or. nButton==BUTTON_ADD
         lAppend  := .t.
         mCATEGORY := space(10)
         mITEM     := space(60)
         mPRIORITY := space(2)
         mdoby     := date()
         mdone     := .f.
      else                                      // edit
         lAppend   := .f.
         mCATEGORY := __todo->CATEGORY
         mITEM     := __todo->ITEM
         mPRIORITY := __todo->PRIORITY
         mdoby     := __todo->doby
         mdone     := __todo->done
      endif
      if !lAppend .and. oTb:colpos > 1
          keyboard repl(chr(13),oTb:colpos-1)
      endif
      lOktoEdit := .t.
      if !lAppend
          IF !SREC_LOCK(5,.T.,"Unable to lock record to save. Keep trying?")
             lOktoEdit := .f.
          endif
      endif
      if lOktoEdit
        SET CURSOR ON
        setcolor(sls_normcol())
        @23,1 say "[F2=lookups]  [ESC=cancel]  [F10=done]    higher number = higher priority"
        setkey(-1,{||pops_do()} )
        while !oTb:stabilize()
        end

        @row(),8  get mITEM pict "@S30"
        @row(),39 get mCATEGORY
        @row(),50 get mPRIORITY pict "@K 99"
        @row(),59 get mdoby
        @row(),68 get mdone pict "Y"
        rat_read(getlist,nil,nil,27,{|r,c|readmouse(r,c)})
        setkey(-1,bOldF2)

        set order to 0
        if !nLastKey = 27
          DO WHILE .T.
            if lAppend
               SET(_SET_DELETED,.F.)
               locate for deleted() // attempt to re-use deleted
               SET(_SET_DELETED,.t.)
               if (found() .and. SREC_LOCK(5,.f.)) .or. ;
                 SADD_REC(5,.T.,"Network error adding record. Keep trying?")
                 if found()
                   DBRECALL()
                   replace long_desc with ""
                 endif
               else
                 exit
               endif
            endif
            IF SREC_LOCK(5,.T.,"Unable to lock record to save. Keep trying?")
              replace CATEGORY with mCATEGORY, ITEM with mITEM, ;
                  PRIORITY with trans(val(mPRIORITY),"99"),doby with mdoby, ;
                  done with mdone
              DBRECALL()  // in case we're re-using deleted
            ENDIF
            EXIT
          ENDDO
        endif
        unlock
        goto recno()
        set order to (nDispOrder)
        SET CURSOR OFF
        setcolor(cHiColor)
        MEMOEDIT(LONG_DESC,18,3,20,76,.F.,.f.,77)
        setcolor(sls_popcol())
      endif
      oTb:refreshall()
      saycmds()
   case cLAstkey$"M"    .or. nButton==BUTTON_MEMO                               // memo
      hidecmds()
      IF SREC_LOCK(5,.T.,"Unable to lock record for memo edit. Keep trying?")
          cMemoBox := makebox(14,1,24,78,sls_popcol())
          set cursor on
          @16,2 say "[F10=save]   [ESC=abort]"

          SETCOLOR(takeout(setcolor(),",",5) )

          cTempMemo := MMEMOEDIT(long_desc,18,3,20,75,.t.,;
            {|m,r,c,l,mr,mc|metodoudf(m,r,c,l,mr,mc)},;
              77,nil,nil,nil,nil,nil,16,60)
          REPLACE long_desc WITH cTempMemo
          unbox(cMemoBox)
          set cursor off
          setcolor(sls_normcol())
          setcolor(cHiColor)
          MEMOEDIT(LONG_DESC,18,3,20,76,.F.,.f.,77)
          clear gets
          SETCOLOR(sls_popcol())
          unlock
          goto recno()
          oTb:refreshall()
      endif
      saycmds()
   case nLastKey == K_MOUSELEFT // mouse
     if nMouseR==15
         do case
         case nMouseC>=60  .and. nMouseC<=62   // up
           oTb:UP()
           if rat_elbhd(.2)
             while rat_elbhd(.01)
               oTb:UP()
               while !oTb:stabilize()
               end
             end
           endif

         case nMouseC>=64 .and. nMouseC<=66  // down
           oTb:DOWN()
           if rat_elbhd(.2)
             while rat_elbhd(.01)
               oTb:DOWN()
               while !oTb:stabilize()
               end
             end
           endif
         case nMouseC>=68 .and. nMouseC<=70  // right
           oTb:right()
           if rat_elbhd(.2)
             while rat_elbhd(.01)
               oTb:RIGHT()
               while !oTb:stabilize()
               end
             end
           endif
         case nMouseC>=72 .and. nMouseC<=74  // right
           oTb:left()
           if rat_elbhd(.2)
             while rat_elbhd(.01)
               oTb:left()
               while !oTb:stabilize()
               end
             end
           endif
         endcase
     elseif MBRZCLICK(oTb,nMouseR, nMouseC)
       keyboard chr(K_ENTER)
     else
       MBRZMOVE(oTb,nMouseR,nMouseC,5,3,13,76)
     endif
   ENDCASE
ENDDO
use
SET(_SET_DELETED,lDeleted)
select (nOldArea)
setcolor(cOldColor)
setkey(-9,bOldF10)
setkey(-1,bOldF2)
setcursor(nOldCursor)
restscreen(0,0,24,79,cOldScreen)
RETURN ''


//--------------------------------------------------
static function pops_do
local nThisRecord,cSmallsDisp,cThisVar
if recc()=0
  return ''
endif
cThisVar    := UPPER(readvar())
nThisRecord := recno()
DO CASE
CASE cThisVar == "MDOBY"
        cSmallsDisp ="dtoc(__todo->doby)"
CASE cThisVar == "MDONE"
        cSmallsDisp ="iif(__todo->done,[Y],[N])"
OTHERWISE
        cSmallsDisp := subst(cThisVar,2)
ENDCASE
GO TOP
smalls(cSmallsDisp)
if !LastKey()=27
  cSmallsDisp = &cSmallsDisp
  keyboard cSmallsDisp
endif
if nThisRecord > 0
  go nThisRecord
endif
return ''

//=============================================
static function makevptb
local bTb := tbrowsedb(3,3,13,76)
bTb:headsep := chr(196)
bTb:addcolumn(tbColumnNew("Item",{||left(__todo->item,30)}))
bTb:addcolumn(tbColumnNew("Category",{||__todo->category}))
bTb:addcolumn(tbColumnNew("Priority",{||__todo->priority}))
bTb:addcolumn(tbColumnNew("Do By",{||__todo->doby}))
bTb:addcolumn(tbColumnNew("Done",{||iif(__todo->done,"Yes","No ")} ))
return bTb



static proc saycmds
dispbegin()
@23,01 say  space(78) color sls_normcol()
@ 15,61 SAY "[] [] [] []" color sls_normcol()
@23,2 say  '[Q]uit' color sls_normcol()
@23,11 say '[E]dit' color sls_normcol()
@23,20 say '[A]dd'  color sls_normcol()
@23,28 say '[D]elete'color sls_normcol()
@23,39 say '[F]ilter'color sls_normcol()
@23,50 say '[M]emo ' color sls_normcol()
@23,60 say '[P]rint' color sls_normcol()
@23,70 say '[O]rder' color sls_normcol()
dispend()
return


static proc hidecmds
dispbegin()
@23,01 say  space(78) color sls_normcol()
@15,61 say repl("Ä",15) color sls_normcol()
dispend()
return

#include "memoedit.ch"
static FUNCTION metodoudf(nMode, nLine, nColumn,nNextKey,nMouseR, nMouseC)
local nReturnVal
local nRow := row(), nCol := col()
nReturnVal := ME_DEFAULT
IF !(nMode= ME_INIT)
  if nNextKey== K_MOUSELEFT .and. nMouseR==16
     do case
     case nMouseC >=2 .and. nMouseC<=11
       KEYBOARD CHR(K_CTRL_END)
     case nMouseC >=15 .and. nMouseC<=25
       KEYBOARD CHR(K_ESC)
     endcase
  endif
ENDIF
devpos(nRow,nCol)
RETURN nReturnval

static function readmouse(nMouseR, nMouseC)
IF nMouseR==23
  do case
  case nMouseC>=1  .and. nMouseC<=13
    pops_do()
  case nMouseC>=16 .and. nMouseC<=27
    keyboard chr(K_ESC)
  case nMouseC>=30 .and. nMouseC<=39
    keyboard chr(K_CTRL_END)
  ENDCASE
endif
return 0




