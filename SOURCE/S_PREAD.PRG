
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION P_READY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  P_READY() Determines if printer is ready, prompts user
ณ 
ณ  Returns:
ณ  --------
ณ  <lReady> => True if printer is ready
ณ 
ณ  Syntax:
ณ  -------
ณ  P_READY([cPort])
ณ 
ณ  Description:
ณ  ------------
ณ  Checks for printer ready, and prompts user to ready
ณ  the printer until it is ready, or until user presses escape to
ณ  abort printing.
ณ 
ณ  P_READY() first looks at SLS_PRNC(), and if the
ณ  value is .f., does no printer check and returns .t.
ณ 
ณ  [cPort] - LPT1 LPT2 LPT3
ณ  Default is LPT1
ณ 
ณ  Examples:
ณ  ---------
ณ   if P_READY("LPT2")
ณ     REPORT FORM yayaya TO PRINT
ณ   ENDIF
ณ 
ณ  Notes:
ณ  -------
ณ  To stop P_READY() from checking the printer port (as
ณ  it is imbedded in many SuperLib functions), call SLS_PRNC() with
ณ  False. This turns printer checking off. (i.e. on a network)
ณ 
ณ  Source:
ณ  -------
ณ  S_PREAD.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION p_ready(cCheckPort,lAllowIgnore,lAllowChange)
local nPort,nAction,lReturn,lDoCheck,nDelaySec,nStartSec
lReturn := .t.
lDoCheck := sls_prnc()
nDelaySec := P_RDYDELAY()  // get delay factor in seconds
lAllowIgnore := iif(lAllowIgnore#nil,lAllowIgnore,.t.)
lAllowChange := iif(lAllowChange#nil,lAllowChange,.t.)
if valtype(cCheckPort)<>"C"
        cCheckPort = "LPT1"
else
        cCheckPort = upper(cCheckPort)
endif
while lDoCheck
   do case
   case cCheckPort == "LPT1"
     nPort := 0
   case cCheckPort == "LPT2"
     nPort := 1
   case cCheckPort == "LPT3"
     nPort := 2
   case "COM"$upper(cCheckPort)
     lReturn := .t.
     lDoCheck := .f.
   otherwise
     lReturn := .f.
     lDoCheck := .f.
   endcase

   * IS THE PRINTER READY
   nStartSec := seconds()
   IF lDoCheck.and. Isprn(nPort)
     lReturn := .t.
     exit
   else
     while (seconds()-nStartSec) < nDelaySec
        if Isprn(nPort)
          lReturn  := .t.
          lDoCheck := .f.
        endif
     end
   ENDIF

   *- loop until printer ready or user presses escape
   WHILE lDoCheck .and. !(Isprn(nPort))
     do case
     case lAllowIgnore .and. lAllowChange
       nAction := menu_v("Printer ("+cCheckPort+") apparently not ready",;
                         "Try again","Abort","Ignore","Change Printer Port")
     case lAllowIgnore
       nAction := menu_v("Printer ("+cCheckPort+") apparently not ready",;
                         "Try again","Abort","Ignore")
     case lAllowChange
       nAction := menu_v("Printer ("+cCheckPort+") apparently not ready",;
                         "Try again","Abort","Change Printer Port")
     case !lAllowChange.and.!lAllowIgnore
       nAction := menu_v("Printer ("+cCheckPort+") apparently not ready",;
                         "Try again","Abort")
     endcase
     IF nAction == 3 .and. lAllowIgnore //Ignore
       lReturn := .t.
       lDoCheck := .f.
     ELSEIF nAction == 0 .OR. nAction == 2  // abort or escape
       lReturn := .f.
       lDoCheck := .f.
     ELSEIF nAction == 4  .or. (nAction == 3 .and. lAllowChange) //change port
       cCheckPort = prnport()
       if left(cCheckPort,3)=="COM" && no way to check, take users
                                      && word for it!
         lReturn := .t.
         lDoCheck := .f.
       else  // have to check the new port
         do case
         case cCheckPort == "LPT1"
           nPort := 0
         case cCheckPort == "LPT2"
           nPort := 1
         case cCheckPort == "LPT3"
           nPort := 2
         endcase
       endif
     ENDI
   ENDDO
   exit
enddo
RETURN lReturn

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION P_RDYDELAY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  Short:
ณ  ------
ณ  P_RDYDELAY() Sets/returns p_ready() 'seconds' variable
ณ
ณ  Returns:
ณ  --------
ณ  <nSeconds> => p_ready() seconds variable
ณ
ณ  Syntax:
ณ  -------
ณ  P_RDYDELAY([nSeconds])
ณ
ณ  Description:
ณ  ------------
ณ  P_READY() tries for 5 seconds by default to check the printer
ณ  for readiness. This function retrieves/sets the variable that
ณ  controls the # of seconds to try for.
ณ
ณ  Examples:
ณ  ---------
ณ  P_RDYDELAY(10)
ณ
ณ  Source:
ณ  -------
ณ  S_PREAD.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION P_RDYDELAY(nDelaySec)
static nDelay := 5
nDelay := iif(nDelaySec#nil,nDelaySec,nDelay)
return nDelay


*: EOF: S_PREAD.PRG
