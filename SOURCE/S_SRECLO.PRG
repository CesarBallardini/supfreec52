*------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SREC_LOCK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SREC_LOCK() Attempts to lock a record
³ 
³  Returns:
³  --------
³  <lSuccess> => success
³ 
³  Syntax:
³  -------
³  SREC_LOCK(nTries,lAskMore,cMoreMessage)
³ 
³  Description:
³  ------------
³  Attempts to lock current record. Tries <nTries> times
³  and then allows user to retry or not based on <lAskMore> by
³  giving message <cMoreMessage> and asking YES/NO.
³ 
³  Examples:
³  ---------
³   IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
³       REPLACE XXX WITH YYY, ZZZ WITH BBB
³       UNLOCK
³   ELSE
³       LOOP
³   ENDIF
³ 
³  Source:
³  -------
³  S_SRECLO.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SREC_LOCK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SREC_LOCK() Attempts to lock a record
³ 
³  Returns:
³  --------
³  <lSuccess> => success
³ 
³  Syntax:
³  -------
³  SREC_LOCK(nTries,lAskMore,cMoreMessage)
³ 
³  Description:
³  ------------
³  Attempts to lock current record. Tries <nTries> times
³  and then allows user to retry or not based on <lAskMore> by
³  giving message <cMoreMessage> and asking YES/NO.
³ 
³  Examples:
³  ---------
³   IF SREC_LOCK(5,.T.,"Unable to lock record. Try again?")
³       REPLACE XXX WITH YYY, ZZZ WITH BBB
³       UNLOCK
³   ELSE
³       LOOP
³   ENDIF
³ 
³  Source:
³  -------
³  S_SRECLO.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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


