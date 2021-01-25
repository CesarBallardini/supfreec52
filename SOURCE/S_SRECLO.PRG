*------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SREC_LOCK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SREC_LOCK() Attempts to lock a record
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => success
ณ 
ณ  Syntax:
ณ  -------
ณ  SREC_LOCK(nTries,lAskMore,cMoreMessage)
ณ 
ณ  Description:
ณ  ------------
ณ  Attempts to lock current record. Tries <nTries> times
ณ  and then allows user to retry or not based on <lAskMore> by
ณ  giving message <cMoreMessage> and asking YES/NO.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
ณ       REPLACE XXX WITH YYY, ZZZ WITH BBB
ณ       UNLOCK
ณ   ELSE
ณ       LOOP
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_SRECLO.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
* Function            SREC_LOCK()
* Action              -NETWORK-Attempts to lock a record
* Returns             <expL> success
* Category            NETWORK
* Syntax              SREC_LOCK(<expN>,<expL>,<expC>)
* Description         Attempts to lock current record.
*                     Tries <expN> times and then allows user to
*                     retry or not <expL2> by giving message <expC3>
*                     and asking YES/NO.
* Options             .
* Examples            IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
*                        REPLACE XXX WITH YYY, ZZZ WITH BBB
*                         UNLOCK
*                     ELSE
*                        LOOP
*                     ENDIF
*
* Notes               .
* Warnings            .
*--------------------------------------------------------------
*--------------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SREC_LOCK()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SREC_LOCK() Attempts to lock a record
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => success
ณ 
ณ  Syntax:
ณ  -------
ณ  SREC_LOCK(nTries,lAskMore,cMoreMessage)
ณ 
ณ  Description:
ณ  ------------
ณ  Attempts to lock current record. Tries <nTries> times
ณ  and then allows user to retry or not based on <lAskMore> by
ณ  giving message <cMoreMessage> and asking YES/NO.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
ณ       REPLACE XXX WITH YYY, ZZZ WITH BBB
ณ       UNLOCK
ณ   ELSE
ณ       LOOP
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_SRECLO.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION Srec_lock(nTries, lAsk, cMessage)
local nTriesOrig, lReturn
nTriesOrig := nTries
lReturn    := .f.
WHILE nTries > 0
      if RLOCK()
        lReturn := .t.
        exit
      endif
      nTries--
      if nTries = 0 .and. lAsk
        if messyn(cMessage)
          nTries := nTriesOrig
        endif
      else
        inkey(.5)
      endif
ENDDO
RETURN lReturn


