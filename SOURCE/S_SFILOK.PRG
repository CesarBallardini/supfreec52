*------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SFIL_LOCK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SFIL_LOCK() Attempts to lock a file
� 
�  Returns:
�  --------
�  <lSuccess> success
� 
�  Syntax:
�  -------
�  SFIL_LOCK(nTries,lInteract,[cMoreMessage])
� 
�  Description:
�  ------------
�  Attempts to lock entire DBF file. Tries <nTries>
�  times and then allows user to retry or not <lInteract> by giving
�  message [cMoreMessage] and asking YES/NO.
� 
�  Examples:
�  ---------
�   IF SFIL_LOCK(5,.F.)
�       count for "S"$LNAME
�       UNLOCK
�   ELSE
�       LOOP
�   ENDIF
� 
�  Source:
�  -------
�  S_SFILOK.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SFIL_LOCK()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SFIL_LOCK() Attempts to lock a file
� 
�  Returns:
�  --------
�  <lSuccess> success
� 
�  Syntax:
�  -------
�  SFIL_LOCK(nTries,lInteract,[cMoreMessage])
� 
�  Description:
�  ------------
�  Attempts to lock entire DBF file. Tries <nTries>
�  times and then allows user to retry or not <lInteract> by giving
�  message [cMoreMessage] and asking YES/NO.
� 
�  Examples:
�  ---------
�   IF SFIL_LOCK(5,.F.)
�       count for "S"$LNAME
�       UNLOCK
�   ELSE
�       LOOP
�   ENDIF
� 
�  Source:
�  -------
�  S_SFILOK.PRG
� 
����������������������������������������������������������������� 
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
