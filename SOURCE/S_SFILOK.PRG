*------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SFIL_LOCK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SFIL_LOCK() Attempts to lock a file
³ 
³  Returns:
³  --------
³  <lSuccess> success
³ 
³  Syntax:
³  -------
³  SFIL_LOCK(nTries,lInteract,[cMoreMessage])
³ 
³  Description:
³  ------------
³  Attempts to lock entire DBF file. Tries <nTries>
³  times and then allows user to retry or not <lInteract> by giving
³  message [cMoreMessage] and asking YES/NO.
³ 
³  Examples:
³  ---------
³   IF SFIL_LOCK(5,.F.)
³       count for "S"$LNAME
³       UNLOCK
³   ELSE
³       LOOP
³   ENDIF
³ 
³  Source:
³  -------
³  S_SFILOK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
* Function            SFIL_LOCK()
* Action              -NETWORK-Attempts to lock a file
* Returns             <expL> success
* Category            NETWORK
* Syntax              SFIL_LOCK(<expN>,<expL>,<expC>
* Description         Attempts to lock entire DBF file.
*                     Tries <expN> times and then allows user to
*                     retry or not <expL2> by giving message <expC3>
*                     and asking YES/NO.
* Options             .
* Examples            IF SFIL_LOCK(5,.F.)
*                        PACK
*                        UNLOCK
*                     ELSE
*                        LOOP
*                     ENDIF
*
* Notes               .
* Warnings            .
*--------------------------------------------------------------

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SFIL_LOCK()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SFIL_LOCK() Attempts to lock a file
³ 
³  Returns:
³  --------
³  <lSuccess> success
³ 
³  Syntax:
³  -------
³  SFIL_LOCK(nTries,lInteract,[cMoreMessage])
³ 
³  Description:
³  ------------
³  Attempts to lock entire DBF file. Tries <nTries>
³  times and then allows user to retry or not <lInteract> by giving
³  message [cMoreMessage] and asking YES/NO.
³ 
³  Examples:
³  ---------
³   IF SFIL_LOCK(5,.F.)
³       count for "S"$LNAME
³       UNLOCK
³   ELSE
³       LOOP
³   ENDIF
³ 
³  Source:
³  -------
³  S_SFILOK.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION Sfil_lock(nTries, lAskMore, cMessage)
local nOrigTries, lReturn
nOrigTries := nTries
lReturn    := .f.
WHILE nTries > 0
        IF FLOCK()
           lReturn := .t.
           exit
        ENDIF
        nTries--
        if nTries = 0 .and. lAskMore
          if messyn(cMessage)
            nTries := nOrigTries
          endif
        else
          inkey(.5)
        endif
ENDDO
return lReturn

