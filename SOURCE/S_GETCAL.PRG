#include "inkey.ch"
#define CALC_0  1
#define CALC_1  2
#define CALC_2  3
#define CALC_3  4
#define CALC_4  5
#define CALC_5  6
#define CALC_6  7
#define CALC_7  8
#define CALC_8  9
#define CALC_9  10
#define CALC_PLUS  11
#define CALC_C      12
#define CALC_MINUS  13
#define CALC_E      14
#define CALC_STAR   15
#define CALC_DOT    16
#define CALC_EQUAL  17
#define CALC_DIVIDE 18
#define CALC_Q      19
#define CALC_F1     20
#define CALC_F2     21
#define CALC_F3     22
#define CALC_F4     23
#define CALC_PERC   24

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GETCALC()                            *changed*
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  GETCALC() Pops up a quick 'solar' calculator
ณ 
ณ  Returns:
ณ  --------
ณ  <expTotal> => total from calculator as either type
ณ  "N" or "C"
ณ 
ณ  Syntax:
ณ  -------
ณ  GETCALC([nStart],[lReturnChar])
ณ 
ณ  Description:
ณ  ------------
ณ  Pop up 'solar' calculator for simple arithmetic
ณ 
ณ  [nStart]  starting number
ณ 
ณ  [lReturnChar]  return as character string (default
ณ  .t.). False returns as a number.
ณ 
ณ  Examples:
ณ  ---------
ณ   GETCALC(5)
ณ 
ณ  NOTES:
ณ  -------
ณ  See also CALCWHEN(), CALCVALID(), CALCKSET()
ณ 
ณ  Source:
ณ  -------
ณ  S_GETCAL.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION GETCALC( nStartValue, lMakeChar)
local nOldDec           := SET(_SET_DECIMALS,4)
local nLastKey, cLastKey, nMouseR, nMouseC, nButton, aButtons
local nDisplaySize      := 20
local cMemoryBox
local lDecFlag          := .F.
local lMemError         := .F.
local cLastOperator     := "+"
local lErrorFlag        := .F.
local cMemoryValue      := "0"
local nPerc
local cOperand           := "0"
local cDisplay           := "0"
local cTotal             := "0"

local nOldCursor        := setcursor(0)
local cOldColor         := SETCOLOR()
local cCalcBox          := MAKEBOX(3,25,20,55,sls_popmenu())

lMakeChar := iif(lMakeChar#nil,lMakeChar,.t.)
aButtons  := drawcalc()

IF VALTYPE(nStartValue)=="N"
   cTotal   := stripz(ALLTRIM(STR(nStartValue)))
   cDisplay := cTotal
ENDIF

DO WHILE .T.
   @ 5,31 CLEAR TO 5,52
   @ 5,52-LEN(cDisplay) SAY cDisplay

   nLastKey := rat_event(0,.f.)
   cLastKey := upper(chr(nLastkey))
   nMouseR  := rat_eqmrow()
   nMouseC  := rat_eqmcol()
   nButton  := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
   if nButton > 0
     DO CASE
     CASE nButton>0  .AND. nButton<11
       cLastKey := SUBST("0123456789",nButton,1)
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_STAR
       cLastkey := "*"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_PLUS
       cLastkey := "+"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_DIVIDE
       cLastkey := "/"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_MINUS
       cLastkey := "-"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_PERC
       cLastkey := "%"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_C
       cLastKey := "C"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_E
       cLastKey := "E"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_Q
       cLastKey := "Q"
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_DOT
       cLastKey := "."
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_EQUAL
       cLastKey := "="
       nLastKey := ASC(cLastKey)
     CASE nButton == CALC_F1
       nLastKey := K_F1
     CASE nButton == CALC_F2
       nLastKey := K_F2
     CASE nButton == CALC_F3
       nLastKey := K_F3
     CASE nButton == CALC_F4
       nLastKey := K_F4
     ENDCASE
   endif

   IF lErrorFlag .AND. cLastKey#"C"
      LOOP
   ENDIF
   
   DO CASE
   CASE nLastKey = K_F1 && cMemoryValue +
      IF !(lMemError)
         IF cMemoryValue == "0"  && SET IF NOT ALREADY
            cMemoryValue := stripz(IIF(cDisplay <> "0",;
                            ALLTRIM(cDisplay),ALLTRIM(cTotal)))
            IF cMemoryBox==nil
               cMemoryBox = MAKEBOX(3,60,5,78,sls_popmenu())
               @ 3,64 SAY "  MEMORY  "
            ENDIF
            @ 4,61 CLEAR TO 4,77
            @ 4,75-LEN(cMemoryValue) SAY cMemoryValue
         ELSE          && INCREMENT cMemoryValue
            cMemoryValue := stripz(ALLTRIM(STR(VAL(cMemoryValue) + ;
                        IIF(cOperand <> "0",VAL(cOperand),VAL(cTotal)))))
            IF LEN(cTotal) > 12
               lMemError = .T.
               cMemoryValue = "O V E R F L O W"
            ENDIF
            @ 4,61 CLEAR TO 4,77
            @ 4,75-LEN(cMemoryValue) SAY cMemoryValue
         ENDIF
      ELSE
         dotone()
      ENDIF
   CASE nLastKey = K_F2       && cMemoryValue -
      IF !(lMemError)
         IF cMemoryValue = "0"  && SET IF NOT ALREADY
            cMemoryValue = stripz(IIF(cDisplay <> "0","-","")+;
                   IIF(cDisplay <> "0",ALLTRIM(cDisplay),ALLTRIM(cTotal)))
            IF cMemoryBox==nil
               cMemoryBox = MAKEBOX(3,60,5,78,sls_popmenu())
               @ 3,64 SAY "  MEMORY  "
            ENDIF
            @ 4,61 CLEAR TO 4,77
            @ 4,75-LEN(cMemoryValue) SAY cMemoryValue
         ELSE          && DECREMENT cMemoryValue
            cMemoryValue = stripz(ALLTRIM(STR(VAL(cMemoryValue) - ;
                  IIF(cOperand <> "0",VAL(cOperand),VAL(cTotal)))))
            IF LEN(cTotal) > 12
               lMemError = .T.
               cMemoryValue = "O V E R F L O W"
            ENDIF
            @ 4,61 CLEAR TO 4,77
            @ 4,75-LEN(cMemoryValue) SAY cMemoryValue
         ENDIF
      ELSE
         dotone()
      ENDIF
   CASE nLastKey = K_F3      && cMemoryValue CLEAR
      IF cMemoryBox#nil
         IF cMemoryValue <> "0"
            cMemoryValue := "0"
            lMemError    := .F.
            @ 4,61 CLEAR TO 4,77
            @ 4,75-LEN(cMemoryValue) SAY cMemoryValue
         ENDIF
      ELSE
         dotone()
      ENDIF
   CASE nLastKey = K_F4        && cMemoryValue RECALL
      IF cMemoryBox== NIL
         dotone()
      ELSE
         cDisplay := cMemoryValue
         cOperand := cMemoryValue
      ENDIF
   CASE cLastKey = "%"         && PERCENTAGE
      nPerc := (val(cOperand)/100)
      DO CASE
      CASE cLastOperator == "+"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) + (nPerc*val(cTotal)) )))
      CASE cLastOperator == "-"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) - (nPerc*val(cTotal)) )))
      CASE cLastOperator == "*"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) * nPerc )))
      CASE cLastOperator == "/"
         IF VAL(cOperand) = 0
            lErrorFlag := .T.
            cDisplay   := "E R R O R"
            LOOP
         ENDIF
         cTotal = stripz(ALLTRIM(STR(VAL(cTotal) / (nPerc*val(cTotal)) )))
      ENDCASE
      cLastOperator     := "+"
      cOperand          := "0"
      lDecFlag          := .F.
      IF LEN(cTotal) > 12
         lErrorFlag     := .T.
         cDisplay       := "O V E R F L O W"
      ENDIF
      cDisplay = cTotal
      *
   CASE nLastKey = K_ENTER .OR. cLastKey = "="  && EQUALS HIT
      DO CASE
      CASE cLastOperator == "+"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) + VAL(cOperand))))
      CASE cLastOperator == "-"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) - VAL(cOperand))))
      CASE cLastOperator == "*"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) * VAL(cOperand))))
      CASE cLastOperator == "/"
         IF VAL(cOperand) = 0
            lErrorFlag := .T.
            cDisplay   := "E R R O R"
            LOOP
         ENDIF
         cTotal = stripz(ALLTRIM(STR(VAL(cTotal) / VAL(cOperand))))
      ENDCASE
      cLastOperator     := "+"
      cOperand          := "0"
      lDecFlag          := .F.
      IF LEN(cTotal) > 12
         lErrorFlag     := .T.
         cDisplay       := "O V E R F L O W"
      ENDIF
      cDisplay = cTotal
   CASE cLastKey = "C"         // clear
      cTotal    := "0"
      cOperand  := "0"
      cDisplay  := "0"
      lDecFlag  := .F.
      lErrorFlag := .F.
   CASE cLastKey = "E"     //clear entry
      cOperand  := "0"
      lDecFlag  := .F.
      lErrorFlag := .F.
      cDisplay  := cTotal
   CASE nLastKey = K_ESC .OR. cLastKey = "Q"    && ESCAPE KEY - EXIT
      EXIT
   CASE cLastKey$"0123456789"   && NUMERIC KEY
      IF lDecFlag
         cOperand := cOperand + CHR(nLastKey)
      ELSE
         if cOperand == "0"
           cOperand := CHR(nLastKey)
         else
           cOperand += CHR(nLastKey)
         endif
      ENDIF
      cDisplay    := cOperand
      IF LEN(cOperand) > nDisplaySize
         lErrorFlag := .T.
         cDisplay   := "O V E R F L O W"
      ENDIF
   CASE  cLastKey = "."     && DECIMAL HIT
      IF !lDecFlag
         lDecFlag := .T.
         cOperand += "."
      ELSE
         dotone()
      ENDIF
      cDisplay := cOperand
   CASE  cLastKey$"*+/-"

      cOperand = stripz(cOperand)
      @ 5,31 CLEAR TO 5,52
      @ 5,52-LEN(cOperand) SAY cOperand
      
      DO CASE
      CASE cLastOperator = "+"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) + VAL(cOperand))))
      CASE cLastOperator = "-"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) - VAL(cOperand))))
      CASE cLastOperator = "*"
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) * VAL(cOperand))))
      CASE cLastOperator = "/"
         IF VAL(cOperand) = 0
            lErrorFlag := .T.
            cDisplay   := "E R R O R"
            LOOP
         ENDIF
         cTotal := stripz(ALLTRIM(STR(VAL(cTotal) / VAL(cOperand))))
      OTHERWISE
         cTotal := stripz(cOperand)
      ENDCASE
      cLastOperator := CHR(nLastKey)
      cOperand      := "0"
      lDecFlag      := .F.
      cDisplay      := cTotal
      IF LEN(cTotal) > 12
         lErrorFlag = .T.
         cDisplay = "O V E R F L O W"
      ENDIF
   OTHERWISE
         dotone()
   ENDCASE
ENDDO
SET(_SET_DECIMALS,nOldDec)
SETCURSOR(nOldCursor)
UNBOX(cCalcBox)
IF cMemoryBox#nil
   UNBOX(cMemoryBox)
ENDIF
SETCOLOR(cOldColor)
RETURN iif(lMakeChar,cTotal,val(cTotal))


//--------strips trailing zeros (beyond right of decimal point)                                                                && Line 236: After RETURN never executed
static FUNCTION stripz(cOldValue)
if "."$cOldValue
  return strtran(trim(strtran(cOldValue,"0"," "))," ","0")
endif
return cOldValue

//=====================================================
static function drawcalc
local aButtons := {}

@7,27 say "ฐฐฐฐฐฐฐ"
@ 7,35 SAY "Super Solar Calc   "
@  4,27 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
@  5,27 SAY "ณ                         ณ"
@  6,27 SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
@  8,27 SAY "ฺฤฟฺฤฟฺฤฟฺฤฟฺฤฟฺฤฤฤฤฤฤฤฤฤฤฟ"
@  9,27 SAY "ณ7ณณ8ณณ9ณณ+ณณCณณF1 [mem +]ณ"
@ 10,27 SAY "ภฤูภฤูภฤูภฤูภฤูภฤฤฤฤฤฤฤฤฤฤู"
@ 11,27 SAY "ฺฤฟฺฤฟฺฤฟฺฤฟฺฤฟฺฤฤฤฤฤฤฤฤฤฤฟ"
@ 12,27 SAY "ณ4ณณ5ณณ6ณณ-ณณEณณF2 [mem -]ณ"
@ 13,27 SAY "ภฤูภฤูภฤูภฤูภฤูภฤฤฤฤฤฤฤฤฤฤู"
@ 14,27 SAY "ฺฤฟฺฤฟฺฤฟฺฤฟฺฤฟฺฤฤฤฤฤฤฤฤฤฤฟ"
@ 15,27 SAY "ณ1ณณ2ณณ3ณณ*ณณ%ณณF3 [mem C]ณ"
@ 16,27 SAY "ภฤูภฤูภฤูภฤูภฤูภฤฤฤฤฤฤฤฤฤฤู"
@ 17,27 SAY "ฺฤฟฺฤฟฺฤฟฺฤฟฺฤฟฺฤฤฤฤฤฤฤฤฤฤฟ"
@ 18,27 SAY "ณ0ณณ.ณณ=ณณ/ณณQณณF4 [mem R]ณ "
@ 19,27 SAY "ภฤูภฤูภฤูภฤูภฤูภฤฤฤฤฤฤฤฤฤฤู"
aadd(aButtons,{8,27,10,29,CALC_7})
aadd(aButtons,{8,30,10,32,CALC_8})
aadd(aButtons,{8,33,10,35,CALC_9})
aadd(aButtons,{8,36,10,38,CALC_PLUS})
aadd(aButtons,{8,39,10,41,CALC_C})
aadd(aButtons,{8,42,10,53,CALC_F1})

aadd(aButtons,{11,27,13,29,CALC_4})
aadd(aButtons,{11,30,13,32,CALC_5})
aadd(aButtons,{11,33,13,35,CALC_6})
aadd(aButtons,{11,36,13,38,CALC_MINUS})
aadd(aButtons,{11,39,13,41,CALC_E})
aadd(aButtons,{11,42,13,53,CALC_F2})

aadd(aButtons,{14,27,16,29,CALC_1})
aadd(aButtons,{14,30,16,32,CALC_2})
aadd(aButtons,{14,33,16,35,CALC_3})
aadd(aButtons,{14,36,16,38,CALC_STAR })
aadd(aButtons,{14,39,16,41,CALC_PERC})
aadd(aButtons,{14,42,16,53,CALC_F3})

aadd(aButtons,{17,27,19,29,CALC_0})
aadd(aButtons,{17,30,19,32,CALC_DOT})
aadd(aButtons,{17,33,19,35,CALC_EQUAL})
aadd(aButtons,{17,36,19,38,CALC_DIVIDE })
aadd(aButtons,{17,39,19,41,CALC_Q})
aadd(aButtons,{17,42,19,53,CALC_F4})

return aButtons

static proc dotone
tone(300,1)
tone(600,1)
tone(300,1)
return

