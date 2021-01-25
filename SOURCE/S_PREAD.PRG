
/*
�����������������������������������������������������������������
� FUNCTION P_READY()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  P_READY() Determines if printer is ready, prompts user
� 
�  Returns:
�  --------
�  <lReady> => True if printer is ready
� 
�  Syntax:
�  -------
�  P_READY([cPort])
� 
�  Description:
�  ------------
�  Checks for printer ready, and prompts user to ready
�  the printer until it is ready, or until user presses escape to
�  abort printing.
� 
�  P_READY() first looks at SLS_PRNC(), and if the
�  value is .f., does no printer check and returns .t.
� 
�  [cPort] - LPT1 LPT2 LPT3
�  Default is LPT1
� 
�  Examples:
�  ---------
�   if P_READY("LPT2")
�     REPORT FORM yayaya TO PRINT
�   ENDIF
� 
�  Notes:
�  -------
�  To stop P_READY() from checking the printer port (as
�  it is imbedded in many SuperLib functions), call SLS_PRNC() with
�  False. This turns printer checking off. (i.e. on a network)
� 
�  Source:
�  -------
�  S_PREAD.PRG
�
�����������������������������������������������������������������
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
�����������������������������������������������������������������
� FUNCTION P_RDYDELAY()
�����������������������������������������������������������������
�
�  Short:
�  ------
�  P_RDYDELAY() Sets/returns p_ready() 'seconds' variable
�
�  Returns:
�  --------
�  <nSeconds> => p_ready() seconds variable
�
�  Syntax:
�  -------
�  P_RDYDELAY([nSeconds])
�
�  Description:
�  ------------
�  P_READY() tries for 5 seconds by default to check the printer
�  for readiness. This function retrieves/sets the variable that
�  controls the # of seconds to try for.
�
�  Examples:
�  ---------
�  P_RDYDELAY(10)
�
�  Source:
�  -------
�  S_PREAD.PRG
�
�����������������������������������������������������������������
*/
FUNCTION P_RDYDELAY(nDelaySec)
static nDelay := 5
nDelay := iif(nDelaySec#nil,nDelaySec,nDelay)
return nDelay


*: EOF: S_PREAD.PRG