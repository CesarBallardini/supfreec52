/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SADD_REC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SADD_REC() Attempts to append a blank record
³ 
³  Returns:
³  --------
³  <lSuccess> => success
³ 
³  Syntax:
³  -------
³  SADD_REC([nTries],[lAskMore],[cAskMessage])
³ 
³  Description:
³  ------------
³  Attempts to append a blank record. Tries [nTries]
³  times and then allows user to retry or not if [lAskMore] by
³  giving message [cAskMessage] and asking YES/NO.
³ 
³  Examples:
³  ---------
³   IF SADD_REC(5,.T.,"Unable to ADD,Try again?")
³ 
³       IF SREC_LOCK(5,.T.,"Unable to lock, Try again?")
³         REPLACE XXX WITH YYY, ZZZ WITH BBB
³         UNLOCK
³       ENDIF
³   ENDIF
³ 
³  Source:
³  -------
³  S_SADDR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION Sadd_rec(nTries, lAskMore, cAskMessage)
local nOrigTries, lReturn
nTries      := iif(nTries#nil,nTries,5)
lAskMore    := iif(lAskMore#nil,lAskMore,.f. )
cAskMessage := iif(cAskMessage#nil,cAskMessage,"Unable to add. Keep trying?" )
nOrigTries  := nTries
lReturn     := .f.
WHILE nTries > 0
      APPEND BLANK
      if !NETERR()
         lReturn := .t.
         exit
      endif
      nTries--
      if nTries = 0 .and. lAskMore
        if messyn(cAskMessage)
          nTries := nOrigTries
        endif
      else
        inkey(.5)
      endif
ENDDO
RETURN lReturn


